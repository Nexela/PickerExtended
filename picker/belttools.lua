-------------------------------------------------------------------------------
--[[BELT TOOLS]]--
-------------------------------------------------------------------------------
local Inventory = require("stdlib.entity.inventory")
local lib = require("picker.lib")

-------------------------------------------------------------------------------
--[[QUICK UG BELT]]--
-------------------------------------------------------------------------------
--Adapted from "Quick UG Belt", by "Thadorus"

local function increment(position)
    local x = position.x -.5
    local y = position.y - 1
    return function()
        y = y + .25
        return {x, y}
    end
end

local function quick_ug_belt(event)

    local player = game.players[event.player_index]
    local entity = event.created_entity

    if entity.valid and entity.type == "underground-belt" and entity.neighbours[1] and not (event.revived or event.instant_blueprint) then
        local opts = settings.get_player_settings(player)
        if opts["picker-quick-ug-mode"].value ~= "off" then
            local nb = entity.neighbours[1]
            local belt_type = "transport-belt"
            local belts

            --Get the belts between the undergrounds
            if entity.direction == defines.direction.north or entity.direction == defines.direction.west then
                belts = entity.surface.find_entities_filtered{
                    type = belt_type,
                    area = {{entity.position.x, entity.position.y}, {nb.position.x, nb.position.y}}
                }
            else
                belts = entity.surface.find_entities_filtered{
                    type = belt_type,
                    area = {{nb.position.x, nb.position.y}, {entity.position.x, entity.position.y}}
                }
            end
            if belts and not (opts["picker-quick-ug-mode"].value == "safe" and table.any(belts, function(b) return b.direction ~= entity.direction end)) then
                local stacks = {}
                for _, belt in ipairs(belts) do
                    if belt.direction == entity.direction then
                        local position = {belt.position.x-1, belt.position.y-0.5}
                        local belt_item = {name = belt.name, count = 1, health = belt.health / belt.prototype.max_health}

                        local _get_items = function(v)
                            if v.valid_for_read then
                                stacks[#stacks+1] = {name=v.name, health=v.health, durability=v.durability, count=v.count}
                                v.clear()
                            end
                        end

                        for i=1, 2 do
                            Inventory.each_reverse(belt.get_transport_line(i), _get_items)
                        end

                        stacks[#stacks + 1] = belt_item

                        setmetatable(stacks, {__index = {valid_for_read=true}})
                        script.raise_event(defines.events.on_preplayer_mined_item, {player_index = player.index, entity = entity})
                        script.raise_event(defines.events.on_player_mined_entity, {player_index = player.index, entity = belt, buffer = stacks})
                        belt.surface.create_entity{name = "flying-text", color = defines.colors.red, text = "-"..#stacks, position = position}
                        belt.destroy()
                    end
                end
                local counts = {}
                local next_y = increment(player.position)
                table.each(stacks,
                    function(v)
                        counts[v.name] = (counts[v.name] or 0) + v.count
                    end
                )
                table.each(counts,
                    function(v, k)
                        player.surface.create_entity{
                            name="flying-text",
                            position = next_y(),
                            color = defines.colors.green,
                            text = {"belttools.inserted", game.item_prototypes[k].localised_name, v}
                        }
                    end
                )
                lib.insert_or_spill_items(player, stacks)
            end
        end
    end
end
Event.register(defines.events.on_built_entity, quick_ug_belt)
