-------------------------------------------------------------------------------
--[[Helper Functions]]--
-------------------------------------------------------------------------------
local lib = {}
local INVENTORIES = {defines.inventory.player_quickbar, defines.inventory.player_main, defines.inventory.god_quickbar, defines.inventory.god_main}

function lib.cursor_stack_name(player, name)
    return player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.name == name and player.cursor_stack
end

function lib.stack_is_ghost(stack, ghost)
    if ghost.name == "entity-ghost" then
        return stack.prototype.place_result and stack.prototype.place_result.name == ghost.ghost_name
    elseif ghost.name == "tile-ghost" then
        return stack.prototype.place_as_tile_result and stack.prototype.place_as_tile_result.result.name == ghost.ghost_name
    end
end

function lib.damaged(entity)
    return entity.health and entity.prototype.max_health and entity.health < entity.prototype.max_health
end

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

function lib.satisfy_requests(entity, player, proxy)
    if entity == proxy then
        entity = entity.surface.find_entities_filtered{position = proxy.position , force = player.force, limit = 1}[1]
    end
    local pinv = player.get_inventory(defines.inventory.player_main) or player.get_inventory(defines.inventory.god_main)
    local new_requests = {}
    for name, count in pairs(proxy.item_requests) do
        local removed = player.cheat_mode and count or (entity and entity.can_insert(name) and pinv.remove({name = name, count = count})) or 0
        if removed > 0 then
            entity.insert({name = name, count = removed})
        end
        local balance = count - removed
        new_requests[name] = balance > 0 and balance or nil
    end
    return new_requests
end

function lib.get_planner(player, planner, label)
    local found
    for _, idx in pairs(INVENTORIES) do
        local inventory = player.get_inventory(idx)
        if inventory then
            for i = 1, #inventory do
                local slot = inventory[i]
                if slot.valid_for_read then
                    if slot.name == planner then
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
                    elseif planner == "repair-tool" and slot.type == "repair-tool" then
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
        return game.item_prototypes[planner] and player.cursor_stack.set_stack(planner) and player.cursor_stack
    end
end

return lib
