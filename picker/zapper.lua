-------------------------------------------------------------------------------
--[Item Zapper]--
-------------------------------------------------------------------------------
local Event = require('stdlib/event/event')
local Player = require('stdlib/event/player')
local Position = require('stdlib/area/position')

local function zapper(event)
    local player, pdata = Player.get(event.player_index)
    local name = (player.cursor_stack.valid_for_read and player.cursor_stack.name)

    if name then
        local all = player.mod_settings['picker-item-zapper-all'].value

        if all or global.planners[name] then
            if (pdata.last_dropped or 0) + 30 < game.tick then
                pdata.last_dropped = game.tick
                if player.cursor_stack.valid_for_read then
                    player.cursor_stack.clear()
                    player.surface.create_entity {
                        name = 'drop-planner',
                        position = Position(player.position):translate(math.random(0, 7), 1)
                    }
                end
            end
        end
    end
end
Event.register('picker-zapper', zapper)

local function cleanup_blueprints(event)
    local player = game.players[event.player_index]

    local settings = player.mod_settings
    local quickbar = false
    local inventory

    if event.name == defines.events.on_player_main_inventory_changed then
        inventory = player.get_main_inventory()
    else
        inventory = player.get_quickbar()
        quickbar = true
    end

    for planner in pairs(global.planners or {}) do
        local bp = game.item_prototypes[planner] and inventory.find_item_stack(planner)
        if bp then
            local setting = settings['picker-no-' .. bp.name .. '-inv'] and settings['picker-no-' .. bp.name .. '-inv'].value or settings['picker-no-other-planner-inv'].value
            if setting ~= 'none' and not (setting == 'main' and quickbar) then
                bp.clear()
            end
        end
    end
end
Event.register({defines.events.on_player_main_inventory_changed, defines.events.on_player_quickbar_inventory_changed}, cleanup_blueprints)
