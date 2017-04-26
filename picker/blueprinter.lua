-------------------------------------------------------------------------------
--[[Picker Blueprinter]]--
-------------------------------------------------------------------------------
local Entity = require("stdlib.entity.entity")
local INVENTORIES = {defines.inventory.player_quickbar, defines.inventory.player_main, defines.inventory.god_quickbar, defines.inventory.god_main}

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
                bp.create_blueprint{surface = entity.surface, force = player.force, area = Entity.to_selection_area(entity), always_include_tiles = false}
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
