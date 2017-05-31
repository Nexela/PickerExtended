-------------------------------------------------------------------------------
--[[Item Zapper]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")

local function zapper(event)
    local player, pdata = Player.get(event.player_index)
    local name = event.entity.stack.name
    local _zappable = function(v)
        return v == name
    end
    local all, list = player.mod_settings["picker-item-zapper-all"].value, player.mod_settings["picker-item-zapper"].value


    if all or (list and table.any(list:split(" "), _zappable)) then
        if (pdata.last_dropped or 0) + 45 < game.tick then
            pdata.last_dropped = game.tick
            event.entity.surface.create_entity{name="drop-planner", position = event.entity.position}
            event.entity.destroy()
        else
            player.cursor_stack.set_stack(event.entity.stack)
            event.entity.destroy()
        end
    end
end
Event.register(defines.events.on_player_dropped_item, zapper)

local inv_map = {
    [defines.events.on_player_main_inventory_changed] = defines.inventory.player_main,
    [defines.events.on_player_quickbar_inventory_changed] = defines.inventory.player_quickbar
}
local inv_map_god = {
    [defines.events.on_player_main_inventory_changed] = defines.inventory.god_main,
    [defines.events.on_player_quickbar_inventory_changed] = defines.inventory.god_quickbar
}

local function cleanup_blueprints(event)
    local player = game.players[event.player_index]
    local index = (player.character and inv_map[event.name]) or inv_map_god[event.name]
    local inventory = player.get_inventory(index)
    for planner in pairs(global.planners) do
        local bp = game.item_prototypes[planner] and inventory.find_item_stack(planner)
        if bp then
            local settings = player.mod_settings
            local setting = settings["picker-no-"..bp.name.."-inv"] and settings["picker-no-"..bp.name.."-inv"].value or settings["picker-no-other-planner-inv"].value
            if setting ~= "none" and not (setting == "main" and index == defines.inventory.player_quickbar) then
                bp.clear()
            end
        end
    end
end
Event.register(defines.events.on_player_main_inventory_changed, cleanup_blueprints)
Event.register(defines.events.on_player_quickbar_inventory_changed, cleanup_blueprints)
