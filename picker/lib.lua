-------------------------------------------------------------------------------
--[[Helper Functions]]--
-------------------------------------------------------------------------------
local lib = {}
local INVENTORIES = {defines.inventory.player_quickbar, defines.inventory.player_main, defines.inventory.god_quickbar, defines.inventory.god_main}

function lib.get_item_stack(e, name)
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

function lib.get_planner(player, planner, label)
    local found
    for _, idx in pairs(INVENTORIES) do
        local inventory = player.get_inventory(idx)
        if inventory then
            for i = 1, #inventory do
                local slot = inventory[i]
                if slot.valid_for_read and slot.name == planner then
                    if planner == "blueprint" then
                        if not slot.is_blueprint_setup() then
                            found = slot
                        elseif (label and slot.is_blueprint_setup() and slot.label and slot.label:find(label)) then
                            if player.cursor_stack.set_stack(slot) then
                                slot.clear()
                                return player.cursor_stack
                            end
                        end
                    elseif planner == "deconstruction-planner" then
                        if player.cursor_stack.set_stack(slot) then
                            slot.clear()
                            return player.cursor_stack
                        end
                    end
                end
            end
        end
    end
    if found and player.cursor_stack.set_stack(found) then
        found.clear()
        return player.cursor_stack
    else
        return player.cursor_stack.set_stack(planner) and player.cursor_stack
    end
end

return lib
