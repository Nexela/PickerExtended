-------------------------------------------------------------------------------
--[[Picker Dolly]]--
-------------------------------------------------------------------------------
local Position = require("stdlib.area.position")

local input_to_direction = {
    ["dolly-move-north"] = defines.direction.north,
    ["dolly-move-east"] = defines.direction.east,
    ["dolly-move-south"] = defines.direction.south,
    ["dolly-move-west"] = defines.direction.west,
}

local moveable_names = {
    ["constant-combinator"] = 7.5,
    ["arithmetic-combinator"] = 7.5,
    ["decider-combinator"] = 7.5,
    ["rocket-combinator"] = 7.5,
    ["clock-combinator"] = 7.5,
    ["pushbutton"] = 7.5,
}

local oblong_combinators = {
    ["arithmetic-combinator"] = true,
    ["decider-combinator"] = true,
}

local function _get_distance(entity)
    local wire = remote.interfaces["data-raw"] and remote.call("data-raw", "prototype", entity.type, entity.name).maximum_wire_distance
    local circuit = remote.interfaces["data-raw"] and remote.call("data-raw", "prototype", entity.type, entity.name).circuit_wire_max_distance
    return circuit or wire or 7.5
end

local function move_combinator(event)
    local player = game.players[event.player_index]
    local entity = player.selected
    if entity and entity.force == player.force and (remote.interfaces["data-raw"] or moveable_names[entity.name]) and player.can_reach_entity(entity) then
        --Direction to move the source
        local direction = event.direction or input_to_direction[event.input_name]
        --BUG .15.2 teleporting rectangles, make sure to set direction.
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
                    return dist > source_distance or dist > _get_distance(neighbour)
                end
            )
        end

        --teleport the entity out of the way.
        if entity.teleport(Position.translate(entity.position, Position.opposite_direction(direction), 20)) then
            entity.direction = ent_direction
            if entity.surface.can_place_entity{name = entity.name, position = target_pos, direction = ent_direction, force = entity.force} then
                --We can place the entity here, check for wire distance
                if entity.circuit_connected_entities then
                    if entity.type == "electric-pole" and not table.any(entity.neighbours, _cant_reach) then
                        entity.teleport(target_pos)
                        entity.direction = ent_direction
                        entity.last_user = player
                        return
                    elseif entity.type ~= "electric-pole" and not table.any(entity.circuit_connected_entities, _cant_reach) then
                        entity.teleport(target_pos)
                        entity.direction = ent_direction
                        entity.last_user = player
                        return
                    else
                        player.print({"picker-dollies.wires-maxed"})
                        entity.teleport(start_pos)
                        entity.direction = ent_direction
                        return false
                    end
                else --All others
                    entity.teleport(target_pos)
                    entity.direction = ent_direction
                end
            else --Ent can't won't fit, restore position.
                entity.teleport(start_pos)
                entity.direction = ent_direction
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
