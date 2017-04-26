-------------------------------------------------------------------------------
--[[Picker Dolly]]--
-------------------------------------------------------------------------------
local Position = require("stdlib.area.position")

local WIRE_DISTANCE = 7.5

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
        if entity.surface.can_place_entity{name = entity.name, position = target_pos, direction = entity.direction, force = entity.force} then
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

return move_combinator
