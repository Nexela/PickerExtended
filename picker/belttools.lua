-------------------------------------------------------------------------------
--[[BELT TOOLS]]--
-------------------------------------------------------------------------------
local Inventory = require("stdlib.entity.inventory")
local Position = require("stdlib.area.position")
local lib = require("picker.lib")

-------------------------------------------------------------------------------
--[[QUICK UG BELT]]--
-------------------------------------------------------------------------------
--Adapted from "Quick UG Belt", by "Thadorus"
local function quick_ug_belt(event)

    local player = game.players[event.player_index]
    local entity = event.created_entity

    if entity.valid and entity.type == "underground-belt" and entity.neighbours[1] and not (event.revived or event.instant_blueprint) then
        local opts = player.mod_settings["picker-quick-ug-mode"].value
        if opts ~= "off" then

            local nb = entity.neighbours[1]
            local belt_type = "transport-belt"
            local belts, distance

            --Get the belts between the undergrounds
            if entity.direction == defines.direction.north or entity.direction == defines.direction.west then
                belts = entity.surface.find_entities_filtered{
                    type = belt_type,
                    area = {{entity.position.x, entity.position.y}, {nb.position.x, nb.position.y}}
                }
                distance = Position.distance(entity.position, nb.position) - 1
            else
                belts = entity.surface.find_entities_filtered{
                    type = belt_type,
                    area = {{nb.position.x, nb.position.y}, {entity.position.x, entity.position.y}}
                }
                distance = Position.distance(entity.position, nb.position) - 1
            end
            local _not_same_dir = function (belt)  return belt.direction ~= entity.direction end



            local safe = (opts == "safe" and #belts == distance and table.any(belts, _not_same_dir)) or (opts == "medium" and table.any(belts, _not_same_dir))
            if belts and not safe then
                local stacks, counts = {}, {}
                for _, belt in ipairs(belts) do
                    if belt.direction == entity.direction then
                        local this_count = 1
                        --Add the belt to the stacks
                        stacks[#stacks + 1] = {name = belt.name, count = 1, health = belt.health / belt.prototype.max_health}
                        counts[belt.name] = (counts[belt.name] or 0) + 1

                        local _get_items = function(v)
                            if v.valid_for_read then
                                stacks[#stacks+1] = {name=v.name, health=v.health, durability=v.durability, count=v.count}
                                counts[v.name] = (counts[v.name] or 0) + v.count
                                this_count = this_count + 1
                                v.clear()
                            end
                        end

                        for i=1, 2 do
                            Inventory.each_reverse(belt.get_transport_line(i), _get_items)
                        end

                        --create fake buffer container for player_mined_entity
                        setmetatable(stacks, {__index = {valid_for_read=true}})

                        script.raise_event(defines.events.on_preplayer_mined_item, {player_index = player.index, entity = entity})
                        script.raise_event(defines.events.on_player_mined_entity, {player_index = player.index, entity = belt, buffer = stacks})
                        belt.surface.create_entity{name = "picker-flying-text", color = defines.colors.red, text = "-"..this_count, position = {belt.position.x-1, belt.position.y-0.5}}
                        belt.destroy()
                    end
                end

                --Create a flying text with combined stack counts.
                local next_pos = Position.increment(Position.offset(player.position, -1.5, -1.5), 0, -0.45)
                table.each(counts,
                    function(v, k)
                        player.surface.create_entity{
                            name="picker-flying-text",
                            position = next_pos(),
                            color = defines.colors.white,
                            text = {"belttools.inserted", game.item_prototypes[k].localised_name, v, player.get_item_count(k) + v}
                        }
                    end
                )
                --Insert our spill the stacks, These stacks could have been modified in on_player_mined_entity
                lib.insert_or_spill_items(player, stacks)
            end
        end
    end
end
Event.register(defines.events.on_built_entity, quick_ug_belt)
