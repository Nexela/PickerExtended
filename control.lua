local DEBUG = false
local Entity = require("stdlib.entity.entity")
local INVENTORIES = {defines.inventory.player_quickbar, defines.inventory.player_main, defines.inventory.god_quickbar, defines.inventory.god_main}

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

local function get_and_setup_blueprint(player, entity)
    for _, ind in pairs(INVENTORIES) do
        local blueprint = player.get_inventory(ind) and player.get_inventory(ind).find_item_stack("blueprint")
        if blueprint and (not blueprint.is_blueprint_setup() or (blueprint.is_blueprint_setup() and blueprint.label == "Picker-blueprint")) then
            blueprint.set_stack({name="blueprint", count = 1})
            blueprint.label = "Picker-blueprint"
            blueprint.create_blueprint{surface=entity.surface, force=player.force, area=Entity.to_selection_area(entity), always_include_tiles=false}
            return blueprint.is_blueprint_setup() and blueprint
        end
    end
end

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

--Requires empty blueprint in inventory
local function make_simple_blueprint(event)
    local player = game.players[event.player_index]
    if player.selected and player.controller_type ~= defines.controllers.ghost then
        local entity = player.selected
        --local locname, ep, ip = get_placeable_item(entity)
        local blueprint = get_and_setup_blueprint(player, entity)
        if blueprint then
            --Clean the cursor_stack (if not using combined Q button)
            player.clean_cursor()
            --If cursor stack is empty, and we were able to transfer the stack. clear the stack from inventory.
            if not player.cursor_stack.valid_for_read and player.cursor_stack.set_stack(blueprint) then
                blueprint.clear()
            else
                if DEBUG then player.print("Can't clean cursor") end
            end
        else
            player.print({"msg-no-blueprint-inv"})
        end --blueprint
    end --player.selected
end
script.on_event("picker-make-ghost", make_simple_blueprint)

local function picker_select(event)
    local player = game.players[event.player_index]
    if player.selected and player.controller_type ~= defines.controllers.ghost then
        local entity = player.selected
        local creative = player.cheat_mode
        local locname, ep, ip = get_placeable_item(entity)
        if ep then
            if ip then
                local stack = get_item_stack(player, ip.name)
                if stack or creative then --Player has some of this item in their inventory.
                    --If it is a ghost just revive it
                    if entity.name == "entity-ghost" or entity.name == "tile-ghost" and player.can_reach_entity(entity) then
                        local type, position = entity.name, entity.position
                        local revived, new_entity = entity.revive()
                        if revived then
                            if not creative then
                                if new_entity then
                                    new_entity.health = (new_entity.health > 0) and ((stack.health or 1) * new_entity.prototype.max_health)
                                end
                                stack.count = stack.count - 1
                            end
                            if type == "entity-ghost" then
                                game.raise_event(defines.events.on_built_entity, {created_entity=new_entity, player_index=player.index})
                            elseif type == "tile-ghost" then
                                game.raise_event(defines.events.on_player_built_tile, {player_index=player.index, positions={position}})
                            end
                        end
                    else
                        --Clean the cursor_stack (if not using combined Q button)
                        player.clean_cursor()
                        --If cursor stack is empty, and we were able to transfer or create the stack. clear the stack from inventory.
                        if not player.cursor_stack.valid_for_read then
                            if player.cursor_stack.set_stack(stack or ((creative and {name=ip.name, count = 1}) or nil)) and stack then
                                stack.clear()
                            end
                        else
                            if DEBUG then player.print("Can't clean cursor") end
                        end
                    end
                else -- None in inventory
                    if player.force.recipes[ip.name] and remote.interfaces.handyhands and not remote.call("handyhands", "paused", player.index) then
                        if player.get_craftable_count(ip.name) > 0 and player.force.recipes[ip.name].enabled then
                            player.begin_crafting{count=1, recipe=ip.name, silent=true}
                        end
                    else
                        player.print({"msg-no-item-inv", locname})
                    end
                end
            else -- No prototype found.
                if DEBUG then player.print("No placeable item prototype found for item "..ep.name..".") end
            end
        else
            if DEBUG then player.print("Not a minable entity with item products") end
        end
    else -- No entity under cursor; maybe the player doesn't know how to use the picker.
        if DEBUG then player.print("Place cursor over an object before activating picker tool.") end
    end
end
script.on_event("picker-select", picker_select)

local function SpawnGUI(player)
    local frame = player.gui.center.add{type="frame", name="picker_renameFrame"}
    frame.add{type = "button",name = "picker_renamerX",caption = " X ",style = "picker-renamer-button-style"}
    frame.add{type="textfield",name="picker_renameTextfield"}
    player.gui.center.picker_renameFrame.picker_renameTextfield.text =
    global.renamer[player.index].backer_name
    frame.add{type = "button",name = "picker_renamerButton",caption = "OK",style = "picker-renamer-button-style"}
end

local function on_gui_click(event)
    if event.element.name == "picker_renamerX" then
        game.players[event.player_index].gui.center.picker_renameFrame.destroy()
    elseif event.element.name == "picker_renamerButton" then
        local player = game.players[event.player_index]
        if global.renamer[event.player_index].valid then
            global.renamer[event.player_index].backer_name =
            player.gui.center.picker_renameFrame.picker_renameTextfield.text
        end
        player.gui.center.picker_renameFrame.destroy()
    end
end
script.on_event(defines.events.on_gui_click, on_gui_click)

local function picker_rename(event)
    if game.players[event.player_index].gui.center.picker_renameFrame then
        game.players[event.player_index].gui.center.picker_renameFrame.destroy()
    end
    local selection = game.players[event.player_index].selected
    if selection then
        if selection.supports_backer_name() then
            if not global.renamer then global.renamer = {} end
            global.renamer[event.player_index] = selection
            SpawnGUI(game.players[event.player_index])
        else
            game.players[event.player_index].print({"selection-not-renamable"})
        end
    end
end
script.on_event("picker-rename", picker_rename)

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
