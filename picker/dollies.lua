-------------------------------------------------------------------------------
--[[Picker Dolly]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")
local Area = require("stdlib.area.area")
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

local function blacklist(entity)
    local names = {
        ["entity-ghost"] = true,
        ["tile-ghost"] = true,
        ["item-request-proxy"] = true,
        ["character"] = true
    }
    local types = {
        ["entity-ghost"] = true,
        ["tile-ghost"] = true,
        ["player"] = true,
        ["resource"] = true,
    }
    return names[entity.name] or types[entity.type]
end

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
    local player, pdata = Player.get(event.player_index)
    local entity

    if player.selected and player.selected.force == player.force and not blacklist(player.selected) then
        entity = player.selected
    elseif pdata.dolly and pdata.dolly.valid then
        if event.tick <= pdata.dolly_tick + defines.time.second * 7 then
            entity = pdata.dolly
        else
            pdata.dolly = nil
        end
    end

    if entity then
        if player.can_reach_entity(entity) then
            --Direction to move the source
            local direction = event.direction or input_to_direction[event.input_name]
            --The entities direction
            local ent_direction = entity.direction
            --Distance to move the source, defaults to 1
            local distance = event.distance or 1

            --Where we started from in case we have to return it
            local start_pos = event.start_pos or entity.position
            --Where we want to go too
            local target_pos = Position.translate(entity.position, direction, distance)

            --Wire distance for the source
            local source_distance = _get_distance(entity)

            --returns true if the wires can't reach
            local _cant_reach = function (neighbours)
                return table.any(neighbours,
                    function(neighbour)
                        local dist = Position.distance(neighbour.position, target_pos)
                        return entity ~= neighbour and (dist > source_distance or dist > _get_distance(neighbour))
                    end
                )
            end

            local out_of_the_way = Position.translate(entity.position, Position.opposite_direction(direction), 20)

            local sel_area = Area.to_selection_area(entity)
            local item_area = Area.translate(Area.to_collision_area(entity), direction, distance)
            local update = entity.surface.find_entities_filtered{area = Area.expand(sel_area, 32), force=entity.force}
            local items_on_ground = entity.surface.find_entities_filtered{type = "item-entity", area = item_area}
            local proxy = entity.surface.find_entities_filtered{name = "item-request-proxy", area = sel_area, force = player.force}[1]

            --Update everything after teleporting
            local function teleport_and_update(ent, pos, raise)
                if ent.last_user then ent.last_user = player end
                ent.teleport(pos)
                table.each(items_on_ground,
                    function(item)
                        if item.valid then
                            item.teleport(entity.surface.find_non_colliding_position("item-on-ground", ent.position, 0, .20))
                        end
                    end
                )
                if proxy and proxy.valid then proxy.teleport(ent.position) end
                table.each(update, function(e) e.update_connections() end)
                if raise then
                    script.raise_event(Event.dolly_moved, {player_index = player.index, moved_entity = ent, start_pos = start_pos})
                else
                    player.surface.create_entity{name = "picker-cant-move", position=player.position}
                end
                return raise
            end

            --teleport the entity out of the way.
            if entity.teleport(out_of_the_way) then
                if proxy and proxy.proxy_target == entity then
                    proxy.teleport(entity.position)
                else
                    proxy = false
                end

                table.each(items_on_ground, function(item) item.teleport(out_of_the_way) end)

                pdata.dolly = entity
                pdata.dolly_tick = event.tick
                entity.direction = ent_direction

                if entity.surface.can_place_entity{name = entity.name, position = target_pos, direction = ent_direction, force = entity.force} then
                    --We can place the entity here, check for wire distance
                    if entity.circuit_connected_entities then
                        --Move Poles
                        if entity.type == "electric-pole" and not table.any(entity.neighbours, _cant_reach) then
                            return teleport_and_update(entity, target_pos, true)
                            --Move Wires
                        elseif entity.type ~= "electric-pole" and not table.any(entity.circuit_connected_entities, _cant_reach) then
                            if entity.type == "mining-drill" and lib.find_resources(entity) == 0 then
                                local name = entity.mining_target and entity.mining_target.localised_name or {"picker-dollies.generic-ore-patch"}
                                player.print({"picker-dollies.off-ore-patch", entity.localised_name, name})
                                return teleport_and_update(entity, start_pos, false)
                            else
                                return teleport_and_update(entity, target_pos, true)
                            end
                        else
                            player.print({"picker-dollies.wires-maxed"})
                            return teleport_and_update(entity, start_pos, false)
                        end
                    else --All others
                        return teleport_and_update(entity, target_pos, true)
                    end
                else --Ent can't won't fit, restore position.
                    return teleport_and_update(entity, start_pos, false)
                end
            else --Entity can't be teleported
                player.print({"picker-dollies.cant-be-teleported", entity.localised_name})
            end
        else
            player.surface.create_entity{name = "picker-cant-move", position=player.position}
        end
    end
end
script.on_event({"dolly-move-north", "dolly-move-east", "dolly-move-south", "dolly-move-west"}, move_combinator)

local function try_rotate_combinator(event)
    local player, pdata = Player.get(event.player_index)
    local entity
    if player.selected and player.selected.force == player.force and oblong_combinators[player.selected.name] then
        entity = player.selected
    elseif pdata.dolly and pdata.dolly.valid then
        if event.tick <= pdata.dolly_tick + defines.time.second * 10 then
            entity = pdata.dolly
        else
            pdata.dolly = nil
        end
    end

    if entity then
        if player.can_reach_entity(entity) then
            pdata.dolly = entity
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
end
script.on_event("dolly-rotate-rectangle", try_rotate_combinator)

local function rotate_saved_dolly(event)
    local _, pdata = Player.get(event.player_index)
    local entity
    if pdata.dolly and pdata.dolly.valid then
        if event.tick <= pdata.dolly_tick + defines.time.second * 10 then
            entity = pdata.dolly
        else
            pdata.dolly = nil
        end
    end
    if entity and entity.supports_direction then
        local _, w, h = Area.size(entity.prototype.collision_box)
        if w == h then
            entity.direction = Position.next_direction(entity.direction)
        else
            entity.direction = Position.opposite_direction(entity.direction)
        end
    end
end
script.on_event("dolly-rotate-saved", rotate_saved_dolly)


return move_combinator
