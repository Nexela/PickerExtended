-------------------------------------------------------------------------------
--[Item Zapper]--
-------------------------------------------------------------------------------
local Event = require('stdlib/event/event')
local Player = require('stdlib/event/player')
local Position = require('stdlib/area/position')

local evt = defines.events

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
    local inventory
    local is_trash = event.name == evt.on_player_trash_inventory_changed

    if event.name == evt.on_player_main_inventory_changed then
        inventory = player.get_main_inventory()
    elseif event.name == evt.on_player_quickbar_inventory_changed then
        inventory = player.get_quickbar()
    elseif is_trash then
        inventory = player.get_inventory(defines.inventory.player_trash)
    else
        return
    end

    for planner in pairs(global.planners or {}) do
        local bp = game.item_prototypes[planner] and inventory.find_item_stack(planner)
        if bp then
            local setting = settings['picker-no-' .. bp.name .. '-inv'] and settings['picker-no-' .. bp.name .. '-inv'].value or settings['picker-no-other-planner-inv'].value
            if event.name == evt.on_player_trash_inventory_changed or (setting ~= 'none' and not (setting == 'main' and inventory.is_quickbar())) then
               return bp.clear()
            end
        end
    end
end
local events = {evt.on_player_main_inventory_changed, evt.on_player_quickbar_inventory_changed, evt.on_player_trash_inventory_changed}
Event.register(events, cleanup_blueprints)
