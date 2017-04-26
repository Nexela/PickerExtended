local INVENTORIES = {defines.inventory.player_quickbar, defines.inventory.player_main, defines.inventory.god_quickbar, defines.inventory.god_main}
local WIRE_DISTANCE = 7.5

require("stdlib.table")
require("stdlib.string")
require("stdlib.event.event")
require("stdlib.gui.gui")
local Entity = require("stdlib.entity.entity")
local Position = require("stdlib.area.position")

-------------------------------------------------------------------------------
--[[Picker]]--
-------------------------------------------------------------------------------
--[[
local function get_item_stack(e, name)
    for _, ind in pairs(INVENTORIES) do
        local stack = e.get_inventory(ind) and e.get_inventory(ind).find_item_stack(name)
        if stack then
            return stack
        end
    end
    if e.vehicle and e.vehicle.get_inventory(defines.inventory.car_trunk) then
        local stack = e.vehicle.get_inventory(defines.inventory.car_trunk).find_item_stack(name)
        if stack then
            return stack
        end
    end
end
--]]
---[[
--Return localised name, entity_prototype, and item_prototype
local function get_placeable_item(entity)
    local locname, ep
    if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
        locname = entity.ghost_localised_name
        ep = entity.ghost_prototype
    else
        locname = entity.localised_name
        ep = entity.prototype
    end
    if ep and ep.mineable_properties and ep.mineable_properties.minable and ep.mineable_properties.products
    and ep.mineable_properties.products[1].type == "item" then -- If the entity has mineable products.
        local ip = game.item_prototypes[ep.mineable_properties.products[1].name] -- Retrieve first available item prototype
        if ip and (ip.place_result or ip.place_as_tile_result) then -- If the entity has an item with a placeable prototype,
            return (ip.localised_name or locname), ep, ip
        end
        return locname, ep
    end
end
--]]

local function stack_equals_ghost(stack, ghost)
    if ghost.name == "entity-ghost" then
        return stack.prototype.place_result and stack.prototype.place_result.name == ghost.ghost_name
    elseif ghost.name == "tile-ghost" then
        return stack.prototype.place_as_tile_result and stack.prototype.place_as_tile_result.result.name == ghost.ghost_name
    end
end

local function picker_revive_selected(event)
    local player = game.players[event.player_index]
    if player.selected and player.controller_type ~= defines.controllers.ghost then
        local ghost = player.selected and (player.selected.name == "entity-ghost" or player.selected.name == "tile-ghost") and player.selected
        local stack = player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack
        if ghost and stack and stack_equals_ghost(stack, ghost) and Position.distance(player.position, ghost.position) <= player.build_distance + 4 then
            local position = ghost.position
            local is_tile = ghost.name == "tile-ghost"
            local revived, entity, requests = ghost.revive(true)
            if revived then
                for collided, count in pairs(revived) do
                    if game.item_prototypes[collided] then
                        local simple_stack = {name = collided, count = count}
                        simple_stack.count = simple_stack.count - player.insert(simple_stack)
                        if simple_stack.count > 0 then
                            player.surface.spill_item_stack(player.position, simple_stack)
                        end
                    end
                end
                if entity then
                    entity.health = (entity.health > 0) and ((stack.health or 1) * entity.prototype.max_health)
                    if requests then
                        local pinv = player.get_inventory(defines.inventory.player_main) or player.get_inventory(defines.inventory.god_main)
                        local new_requests = {}
                        for name, count in pairs(requests.item_requests) do
                            local removed = pinv.remove({name = name, count = count})
                            if removed > 0 then
                                entity.insert({name = name, count = removed})
                            end
                            local balance = count - removed
                            new_requests[name] = balance > 0 and balance or nil
                        end
                        requests.item_requests = new_requests
                    end
                    script.raise_event(defines.events.on_built_entity, {created_entity=entity, player_index=player.index})
                elseif is_tile then
                    script.raise_event(defines.events.on_player_built_tile, {player_index=player.index, positions={position}})
                end
                stack.count = stack.count - 1
            end
        elseif player.selected.name == "item-on-ground" and not player.cursor_stack.valid_for_read then
            if player.cursor_stack.set_stack(player.selected.stack) then
                player.selected.destroy()
            end
        end
    end
end
script.on_event("picker-select", picker_revive_selected)

-------------------------------------------------------------------------------
--[[Picker Crafter]]--
-------------------------------------------------------------------------------
local function picker_crafter(event)
    local player = game.players[event.player_index]
    if player.selected then
        local _, _, ip = get_placeable_item(player.selected)
        if ip then
            player.begin_crafting{count=1,recipe=ip.name,silent=false}
        end
    end
end
script.on_event("picker-crafter", picker_crafter)

-------------------------------------------------------------------------------
--[[Picker Blueprinter]]--
-------------------------------------------------------------------------------
local function get_planner(player, planner, pipette)
    planner = planner or "blueprint"
    for _, idx in pairs(INVENTORIES) do
        local inventory = player.get_inventory(idx)
        if inventory then
            for i = 1, #inventory do
                local slot = inventory[i]
                if slot.valid_for_read and slot.name == planner then
                    if planner == "blueprint" then
                        if (not slot.is_blueprint_setup() or (pipette and slot.is_blueprint_setup() and slot.label == "Pipette Blueprint")) then
                            if player.cursor_stack.set_stack(slot) then
                                slot.clear()
                                return player.cursor_stack
                            end
                        end
                    elseif planner == "deconstruction-planner" then
                        if slot.entity_filter_slots == 0 and player.cursor_stack.set_stack(slot) then
                            slot.clear()
                            return player.cursor_stack
                        end
                    end
                end
            end
        end
    end
    return player.cursor_stack.set_stack(planner) and player.cursor_stack
end

--Requires empty blueprint in inventory
local function make_simple_blueprint(event)
    local player = game.players[event.player_index]
    if player.selected and player.controller_type ~= defines.controllers.ghost then
        local entity = player.selected
        if player.clean_cursor() then
            local bp = get_planner(player, "blueprint", true)
            if bp then
                bp.clear_blueprint()
                bp.label = "Pipette Blueprint"
                bp.allow_manual_label_change = false
                bp.create_blueprint{surface=entity.surface, force=player.force, area=Entity.to_selection_area(entity), always_include_tiles=false}
                -- return blueprint.is_blueprint_setup() and blueprint
            end
        else
            player.print({"picker.msg-cant-insert-blueprint"})
        end
    elseif not player.selected and player.controller_type ~= defines.controllers.ghost then
        if (not player.cursor_stack.valid_for_read or player.cursor_stack.valid_for_read and player.cursor_stack.name ~= "blueprint") then
            --if player.clean_cursor() then
            return player.clean_cursor() and get_planner(player)
            --end
        elseif player.cursor_stack.valid_for_read and player.cursor_stack.name == "blueprint" then
            return player.clean_cursor() and get_planner(player, "deconstruction-planner")
        end
    end
end
script.on_event("picker-make-ghost", make_simple_blueprint)

-------------------------------------------------------------------------------
--[[Item Zapper]]--
-------------------------------------------------------------------------------
local zapper = "picker-item-zapper"
local function cleanup_planners(event)
    local player = game.players[event.player_index]
    local _zappable = function(v, _, name)
        return v == name
    end

    if table.any(settings.get_player_settings(player.index)[zapper].value:split(" "), _zappable, event.entity.stack.name) then
        global.last_dropped = global.last_dropped or {}

        if (global.last_dropped[event.player_index] or 0) + 45 < game.tick then
            global.last_dropped[event.player_index] = game.tick
            event.entity.surface.create_entity{name="drop-planner", position=event.entity.position}
            event.entity.destroy()
        else
            player.cursor_stack.set_stack(event.entity.stack)
            event.entity.destroy()
        end
    end
end
script.on_event(defines.events.on_player_dropped_item, cleanup_planners)

-------------------------------------------------------------------------------
--[[Picker Rename]]--
-------------------------------------------------------------------------------
local function spawn_rename_gui(player)
    local frame = player.gui.center.add{type="frame", name="picker_rename_frame"}
    frame.add{type = "button", name = "picker_rename_x", caption = " X ", style = "picker-rename-button-style"}
    frame.add{type = "textfield", name = "picker_rename_textfield"}
    player.gui.center.picker_rename_frame.picker_rename_textfield.text =
    global.renamer[player.index].backer_name
    frame.add{type = "button", name = "picker_rename_button", caption = "OK", style = "picker-rename-button-style"}
end

Gui.on_click("picker_rename_x",
    function(event)
        game.players[event.player_index].gui.center.picker_rename_frame.destroy()
    end
)
Gui.on_click("picker_rename_button", function(event)
        local player = game.players[event.player_index]
        if global.renamer[event.player_index].valid then
            global.renamer[event.player_index].backer_name =
            player.gui.center.picker_rename_frame.picker_rename_textfield.text
        end
        player.gui.center.picker_rename_frame.destroy()
    end
)

local function picker_rename(event)
    if game.players[event.player_index].gui.center.picker_rename_frame then
        game.players[event.player_index].gui.center.picker_rename_frame.destroy()
    end
    local selection = game.players[event.player_index].selected
    if selection then
        if selection.supports_backer_name() then
            if not global.renamer then global.renamer = {} end
            global.renamer[event.player_index] = selection
            spawn_rename_gui(game.players[event.player_index])
        else
            game.players[event.player_index].print({"picker.selection-not-renamable"})
        end
    end
end
script.on_event("picker-rename", picker_rename)

-------------------------------------------------------------------------------
--[[Picker Item Count]]--
-------------------------------------------------------------------------------
local function get_or_create_itemcount_gui(player)
    local gui = player.gui.center.itemcount
    if not gui then
        gui = player.gui.center.add{type="label", name="itemcount", caption="0", direction = "vertical"}
        gui.style.font = "default-bold"
    end
    local enabled = settings.get_player_settings(player.index)["picker-itemcount"].value
    gui.style.visible = enabled and player.cursor_stack.valid_for_read and #gui.parent.children == 1
    return gui
end

local function get_itemcount_counts(event)
    local player = game.players[event.player_index]
    local stack = player.cursor_stack.valid_for_read and player.cursor_stack
    local gui = get_or_create_itemcount_gui(player)
    if stack then
        local inventory_count = player.get_item_count(stack.name)
        local vehicle_count
        if player.vehicle and player.vehicle.get_inventory(defines.inventory.car_trunk) then
            vehicle_count = player.vehicle.get_inventory(defines.inventory.car_trunk).get_item_count(stack.name)
        end
        gui.caption = inventory_count .. (vehicle_count and (" ("..vehicle_count..")") or "")
    else
        gui.caption = 0
    end
end

local events = {
    defines.events.on_player_cursor_stack_changed,
    defines.events.on_player_driving_changed_state,
    defines.events.on_player_main_inventory_changed,
    defines.events.on_player_ammo_inventory_changed,
    defines.events.on_player_quickbar_inventory_changed,
}
script.on_event(events, get_itemcount_counts)

-------------------------------------------------------------------------------
--[[Copy Chest]]--
-------------------------------------------------------------------------------
local chest_types = {
    ["container"] = true,
    ["logistic-container"] = true
}

local function copy_chest(event)
    local player = game.players[event.player_index]
    local chest = player.selected
    global.copy_chest = global.copy_chest or {}
    global.copy_chest[player.index] = global.copy_chest[player.index] or {}
    if chest and chest_types[chest.type] then
        if player.force == chest.force and player.can_reach_entity(chest) then
            local data = global.copy_chest[player.index]
            if not data.src or not data.src.valid then
                player.print({"picker.copy-src"})
                data.src = chest
                data.tick = game.tick
            elseif data.src.valid then
                game.print({"picker.paste-dest"})
                local src, dest = data.src, chest
                --clone inventory 1 to inventory 2
                local src_inv = src.get_inventory(defines.inventory.chest)
                local dest_inv = dest.get_inventory(defines.inventory.chest)
                if src_inv then
                    for i=1, #src_inv do
                        local stack = src_inv[i]
                        if stack and stack.valid_for_read then
                            stack.count = stack.count - dest_inv.insert({name=stack.name, count=stack.count, health=stack.health})
                        end
                    end
                end
                --Copy requests/bar here if needed?
                global.copy_chest[player.index] = nil
            end
        end
    else
        global.copy_chest[player.index] = nil
    end
end
script.on_event("picker-copy-chest", copy_chest)

-------------------------------------------------------------------------------
--[[Picker Hide Minimap]]--
-------------------------------------------------------------------------------
local function picker_hide_minimap(event)
    local player = game.players[event.player_index]
    if settings.get_player_settings(player.index)["picker-hide-minimap"].value then
        player.game_view_settings.show_minimap = not (player.selected and player.selected.type == "logistic-container")
    end
end
script.on_event(defines.events.on_selected_entity_changed, picker_hide_minimap)

-------------------------------------------------------------------------------
--[[Picker Dolly]]--
-------------------------------------------------------------------------------
local input_to_direction = {
    ["dolly-move-north"] = defines.direction.north,
    ["dolly-move-east"] = defines.direction.east,
    ["dolly-move-south"] = defines.direction.south,
    ["dolly-move-west"] = defines.direction.west,
}

local combinator_names = {
    ["constant-combinator"] = true,
    ["arithmetic-combinator"] = true,
    ["decider-combinator"] = true,
    ["rocket-combinator"] = true,
    ["clock-combinator"] = true,
    ["pushbutton"] = true,
    ["power-switch"] = false,
}
local oblong_combinators = {
    ["arithmetic-combinator"] = true,
    ["decider-combinator"] = true,
}

local function move_combinator(event)
    local player = game.players[event.player_index]
    local entity = player.selected
    if entity and entity.force == player.force and combinator_names[entity.name] and player.can_reach_entity(entity) then
        local direction = event.direction or input_to_direction[event.input_name]
        local distance = event.distance or 1

        local start_pos = event.start_pos or entity.position
        local target_pos = Position.translate(entity.position, direction, distance)
        local source_distance = WIRE_DISTANCE
        local target_distance = WIRE_DISTANCE
        local has_remote

        if remote.interfaces["data-raw"] then
            has_remote = true
            source_distance = remote.call("data-raw", "prototype", entity.type, entity.name).circuit_wire_max_distance
        end

        local _check_pos = function(v, _)
            if v ~= entity then
                target_distance = has_remote and remote.call("data-raw", "prototype", v.type, v.name).circuit_wire_max_distance or target_distance
                local ent_distance = Position.distance(v.position, target_pos)
                return ent_distance > source_distance or ent_distance > target_distance
            end
        end

        --teleport the entity out of the way.
        entity.teleport(Position.translate(entity.position, direction, 10))
        if entity.surface.can_place_entity{name=entity.name,position=target_pos, direction=entity.direction, force=entity.force} then
            --We can place the entity here, check for wire distance
            if not (table.any(entity.circuit_connected_entities.red, _check_pos) or table.any(entity.circuit_connected_entities.green, _check_pos)) then
                entity.teleport(target_pos)
                return true
            else
                player.print({"picker.wires-maxed"})
                entity.teleport(start_pos)
            end
        else
            --Ent can't won't fit, restore position.
            entity.teleport(start_pos)
        end

    end
end
script.on_event({"dolly-move-north", "dolly-move-east", "dolly-move-south", "dolly-move-west"}, move_combinator)

local function try_rotate_combinator(event)
    local player = game.players[event.player_index]
    local entity = player.selected
    if entity and entity.force == player.force and oblong_combinators[entity.name] and player.can_reach_entity(entity) then
        local diags = {
            [defines.direction.north] = defines.direction.northeast,
            [defines.direction.south] = defines.direction.northeast,
            [defines.direction.west] = defines.direction.southwest,
            [defines.direction.east] = defines.direction.southwest,
        }

        event.start_pos = entity.position
        event.start_direction = entity.direction

        event.distance = .5
        entity.direction = entity.direction == 6 and 0 or entity.direction + 2

        event.direction = diags[entity.direction]

        if not move_combinator(event) then
            entity.direction = event.start_direction
        end
    end
end
script.on_event("dolly-rotate-rectangle", try_rotate_combinator)

-------------------------------------------------------------------------------
--[[Settings events]]--
-------------------------------------------------------------------------------
local function update_settings(event)
    local player = game.players[event.player_index]
    --Toggle minimap back on when switching settings just in case
    if event.setting == "picker-hide-minimap" then
        player.game_view_settings.show_minimap = true
    end
    if event.setting == "picker-itemcount" then
        local enabled = settings.get_player_settings(player.index)["picker-itemcount"].value
        local gui = get_or_create_itemcount_gui(player)
        gui.style.visible = enabled and player.cursor_stack.valid_for_read or false
    end
end
script.on_event(defines.events.on_runtime_mod_setting_changed, update_settings)

-------------------------------------------------------------------------------
--[[INIT]]--
-------------------------------------------------------------------------------
