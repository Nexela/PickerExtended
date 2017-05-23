-------------------------------------------------------------------------------
--[[BELT TOOLS]]--
-------------------------------------------------------------------------------
--local Inventory = require("stdlib.entity.inventory")
local Position = require("stdlib.area.position")
--local lib = require("picker.lib")

-------------------------------------------------------------------------------
--[[QUICK UG BELT]]--
-------------------------------------------------------------------------------
--Adapted from "Quick UG Belt", by "Thadorus"
local function quick_ug_belt(event)

    local player = game.players[event.player_index]
    local entity = event.created_entity

    if entity.valid and entity.type == "underground-belt" and entity.neighbours and not (event.revived or event.instant_blueprint) then
        local opts = player.mod_settings["picker-quick-ug-mode"].value
        if opts ~= "off" then

            local nb = entity.neighbours
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

            local cont = true
            if opts == "safe" then
                cont = #belts == distance and not table.any(belts, _not_same_dir)
            elseif opts == "medium" then
                cont = not table.any(belts, _not_same_dir)
            end

            if belts and cont then
                for _, belt in ipairs(belts) do
                    if belt.direction == entity.direction then
                        player.mine_entity(belt)
                    end
                end
            end
        end
    end
end
Event.register(defines.events.on_built_entity, quick_ug_belt)

-------------------------------------------------------------------------------
--[[Quick ug Belt Snapping]]--
-------------------------------------------------------------------------------
-- Snap ug belts when building belts/undergrounds.
