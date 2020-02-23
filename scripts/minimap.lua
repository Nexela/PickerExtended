-------------------------------------------------------------------------------
--[Picker Hide Minimap]--
-------------------------------------------------------------------------------
-- TODO add hotkeys to enable/disable map and other elements

local Event = require('__stdlib__/stdlib/event/event')
local Player = require('__stdlib__/stdlib/event/player')
local table = require('__stdlib__/stdlib/utils/table')

local hide_types = table.array_to_dictionary {'logistic-container', 'electric-pole', 'roboport', 'container'}

local function picker_hide_minimap(event)
    local player, pdata = Player.get(event.player_index)
    if pdata.minimap_disabled then
        return
    end
    if not player.opened and player.selected and hide_types[player.selected.type] and player.game_view_settings.show_minimap then
        if player.mod_settings['picker-hide-minimap'].value then
            player.game_view_settings.show_minimap = false
        end
    elseif not player.game_view_settings.show_minimap and not (player.selected and hide_types[player.selected.type]) then
        if player.mod_settings['picker-hide-minimap'].value then
            player.game_view_settings.show_minimap = true
        end
    end
end
Event.register(defines.events.on_selected_entity_changed, picker_hide_minimap)

local function toggle_minimap(event)
    local player, pdata = Player.get(event.player_index)
    if pdata.minimap_disabled then
        player.game_view_settings.show_minimap = true
        pdata.minimap_disabled = false
    else
        player.game_view_settings.show_minimap = false
        pdata.minimap_disabled = true
    end
end
Event.register('picker-toggle-minimap', toggle_minimap)

local function update_minimap_settings(event)
    --Toggle minimap back on when switching settings just in case
    if event.setting == 'picker-hide-minimap' then
        game.players[event.player_index].game_view_settings.show_minimap = true
    end
end
Event.register(defines.events.on_runtime_mod_setting_changed, update_minimap_settings)

return picker_hide_minimap
