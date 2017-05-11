-------------------------------------------------------------------------------
--[[Picker Dolly]]--
-------------------------------------------------------------------------------
local Position = require("stdlib.area.position")
local lib = require("picker.lib")

Event.dolly_moved = script.generate_event_name()
MOD.interfaces["dolly_moved_entity_id"] = function() return Event.dolly_moved end
--[[
Event = {player_index = player_index, moved_entity = entity}
--In your mods on_load and on_init
if remote.interfaces["picker"] and remote.interfaces["picker"]["dolly_moved_entity_id"] then
    script.on_event(remote.call("picker", "dolly_moved_entity_id"), function_to_update_positions)
end
--]]

local input_to_direction = {
    ["dolly-move-north"] = defines.direction.north,
    ["dolly-move-east"] = defines.direction.east,
    ["dolly-move-south"] = defines.direction.south,
    ["dolly-move-west"] = defines.direction.west,
}

local oblong_combinators = {
    ["arithmetic-combinator"] = true,
    ["decider-combinator"] = true,
}

local function _get_distance(entity)
    if entity.type == "electric-pole" then
        return entity.prototype.max_wire_distance
    elseif entity.circuit_connected_entities then
        return entity.prototype.max_circuit_wire_distance
    end
end

local function move_combinator(event)
    local player = game.players[event.player_index]
    local entity = player.selected
    if entity and entity.force == player.force and player.can_reach_entity(entity) then
        --Direction to move the source
        local direction = event.direction or input_to_direction[event.input_name]
        local ent_direction = entity.direction
        --Distance to move the source, defaults to 1
        local distance = event.distance or 1

        --Where we started from in case we have to return it
        local start_pos = event.start_pos or entity.position
        --Where we want to go too
        local target_pos = Position.translate(entity.position, direction, distance)

        --Wire distance for the source
        local source_distance = _get_distance(entity)

        local _cant_reach = function (neighbours)
            return table.any(neighbours,
                function(neighbour)
                    local dist = Position.distance(neighbour.position, target_pos)
                    return entity ~= neighbour and (dist > source_distance or dist > _get_distance(neighbour))
                end
            )
        end

        --teleport the entity out of the way.
        if entity.teleport(Position.translate(entity.position, Position.opposite_direction(direction), 20)) then
            entity.direction = ent_direction
            if entity.surface.can_place_entity{name = entity.name, position = target_pos, direction = ent_direction, force = entity.force} then
                --We can place the entity here, check for wire distance
                if entity.circuit_connected_entities then
                    --Move Poles
                    if entity.type == "electric-pole" and not table.any(entity.neighbours, _cant_reach) then
                        entity.teleport(target_pos)
                        entity.last_user = player
                        script.raise_event(Event.dolly_moved, {player_index = player.index, moved_entity = entity})
                        return
                        --Move Wires
                    elseif entity.type ~= "electric-pole" and not table.any(entity.circuit_connected_entities, _cant_reach) then

                        entity.teleport(target_pos)
                        if entity.type == "mining-drill" and lib.find_resources(entity) == 0 then
                            local name = entity.mining_target and entity.mining_target.localised_name or {"picker-dollies.generic-ore-patch"}
                            player.print({"picker-dollies.off-ore-patch", entity.localised_name, name})
                            entity.teleport(start_pos)
                            return
                        else
                            entity.last_user = player
                            script.raise_event(Event.dolly_moved, {player_index = player.index, moved_entity = entity})
                            return true
                        end
                    else
                        player.print({"picker-dollies.wires-maxed"})
                        entity.teleport(start_pos)
                        return false
                    end
                else --All others
                    entity.teleport(target_pos)
                    script.raise_event(Event.dolly_moved, {player_index = player.index, moved_entity = entity})
                    return
                end
            else --Ent can't won't fit, restore position.
                entity.teleport(start_pos)
                return
            end
        else --Entity can't be teleported
            player.print({"picker-dollies.cant-be-teleported", entity.localised_name})
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

return move_combinator
