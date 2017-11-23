-------------------------------------------------------------------------------
--[[Item Zapper]] --
-------------------------------------------------------------------------------
local Player = require("stdlib.event.player")
local Position = require("stdlib.area.position")

local function zapper(event)
    local player, pdata = Player.get(event.player_index)
    local name = (player.cursor_stack.valid_for_read and player.cursor_stack.name)

    if name then
        local all = player.mod_settings["picker-item-zapper-all"].value

        if all or global.planners[name] then
            if (pdata.last_dropped or 0) + 30 < game.tick then
                pdata.last_dropped = game.tick
                if player.cursor_stack.valid_for_read then
                    player.cursor_stack.clear()
                    player.surface.create_entity {
                        name = "drop-planner",
                        position = Position(player.position):translate(math.random(0, 7), 1)
                    }
                end
            end
        end
    end
end
Event.register("picker-zapper", zapper)

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
            local setting =
                settings["picker-no-" .. bp.name .. "-inv"] and settings["picker-no-" .. bp.name .. "-inv"].value or
                settings["picker-no-other-planner-inv"].value
            if setting ~= "none" and not (setting == "main" and index == defines.inventory.player_quickbar) then
                bp.clear()
            end
        end
    end
end
Event.register({defines.events.on_player_main_inventory_changed, defines.events.on_player_quickbar_inventory_changed}, cleanup_blueprints)
