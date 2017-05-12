-------------------------------------------------------------------------------
--[[Picker Hide Minimap]]--
-------------------------------------------------------------------------------
local function picker_hide_minimap(event)
    local player = game.players[event.player_index]
    if player.mod_settings["picker-hide-minimap"].value then
        if not player.opened and player.selected and player.selected.type == "logistic-container" and player.game_view_settings.show_minimap then
            player.game_view_settings.show_minimap = false
        elseif not player.game_view_settings.show_minimap and not (player.selected and player.selected.type == "logistic-container") then
            player.game_view_settings.show_minimap = true
        end
    end
end
Event.register(defines.events.on_selected_entity_changed, picker_hide_minimap)

local function update_minimap_settings(event)
    local player = game.players[event.player_index]
    --Toggle minimap back on when switching settings just in case
    if event.setting == "picker-hide-minimap" then
        player.game_view_settings.show_minimap = true
    end
end
Event.register(defines.events.on_runtime_mod_setting_changed, update_minimap_settings)

return picker_hide_minimap
