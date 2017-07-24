-------------------------------------------------------------------------------
--[[Picker Crafter]]--
-------------------------------------------------------------------------------
local lib = require("picker.lib")

local function picker_crafter(event)
    local player = game.players[event.player_index]
    if player.selected then
    		local _, _, ip = lib.get_placeable_item(player.selected)
        if ip and game.recipe_prototypes[ip.name] and player.force.recipes[ip.name].enabled then
            player.begin_crafting{count = 1, recipe = ip.name, silent = false}
        end
    end
end
Event.register("picker-crafter", picker_crafter)
