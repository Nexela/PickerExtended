local Event = require('__stdlib__/event/event')

local function set_join_options(event)
    local player = game.players[event.player_index]
    if player.mod_settings['picker-alt-mode-default'].value then
        player.game_view_settings.show_entity_info = true
    end
end
Event.register(defines.events.on_player_joined_game, set_join_options)
