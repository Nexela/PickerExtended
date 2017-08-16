-------------------------------------------------------------------------------
--[[Reviver]]-- Revives the selected entity
-------------------------------------------------------------------------------
local Position = require("stdlib.area.position")
local lib = require("picker.lib")

local function picker_revive_selected(event)
    local player = game.players[event.player_index]
    if player.selected and player.controller_type ~= defines.controllers.ghost then
        local ghost = player.selected and (player.selected.name == "entity-ghost" or player.selected.name == "tile-ghost") and player.selected
        local stack = player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack
        if ghost and stack and lib.stack_is_ghost(stack, ghost) and Position.distance(player.position, ghost.position) <= player.build_distance + 4 then
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
                        requests.item_requests = lib.satisfy_requests(entity, player, requests)
                    end
                    script.raise_event(defines.events.on_built_entity, {created_entity = entity, player_index = player.index})
                elseif is_tile then
                    script.raise_event(defines.events.on_player_built_tile, {player_index = player.index, positions={position}})
                end
                stack.count = stack.count - 1
            end
        elseif player.selected.name == "item-on-ground" and not player.cursor_stack.valid_for_read then
            if player.cursor_stack.set_stack(player.selected.stack) then
                player.selected.destroy()
            end
        elseif player.selected.name == "item-request-proxy" and not player.cursor_stack.valid_for_read then
            player.selected.item_requests = lib.satisfy_requests(player.selected, player, player.selected)
        end
    end
end
Event.register("picker-select", picker_revive_selected)

return picker_revive_selected
