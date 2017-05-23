-------------------------------------------------------------------------------
--[[Planners]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")
--local Area = require("stdlib.area.area")
--local Entity = require("stdlib.entity.entity")
local lib = require("picker.lib")

-------------------------------------------------------------------------------
--[[Open held item inventory]]--
-------------------------------------------------------------------------------
local function open_held_item_inventory(event)
    local player = game.players[event.player_index]
    if player.cursor_stack.valid_for_read then
        player.opened = player.cursor_stack
    end
end
script.on_event("picker-inventory-editor", open_held_item_inventory)

local function cycle_planners(event)
    local player, pdata = Player.get(event.player_index)
    if player.controller_type ~= defines.controllers.ghost then
        if not pdata.new_simple or not player.cursor_stack.valid_for_read then
            pdata.last_planner = lib.get_next_planner(player, pdata.last_planner) and player.cursor_stack.name
        end
        pdata.new_simple = false
    end
    --end
end
script.on_event("picker-next-planner", cycle_planners)
