local Player = require("stdlib.player")
-------------------------------------------------------------------------------
--[[Lights]]--
-------------------------------------------------------------------------------
--Code modified from Searching-flashlights, by RK84
local atan2 , pi , floor = math.atan2, math.pi, math.floor

local function orient_players( event )
    local player = game.players[event.player_index]
    if player.selected and player.character and not player.vehicle and not player.walking_state.walking then
        if settings.get_player_settings(player)["picker-search-light"].value then
            --Code optimization by GotLag
            local dx = player.position.x - player.selected.position.x
            local dy = player.selected.position.y - player.position.y
            local orientation = (atan2(dx, dy) / pi + 1) / 2
            player.character.direction = floor(orientation * 8 + 0.5) % 8
        end
    end
end
Event.register(defines.events.on_selected_entity_changed, orient_players )

-------------------------------------------------------------------------------
--[[Flashlight on/off]]--
-------------------------------------------------------------------------------
--Code from: "Flashlight On Off", by: "devilwarriors",
local function toggle_flashlight(event)
    local player, pdata = Player.get(event.player_index)

    if player.character then
        if pdata.flashlight_off then
            pdata.flashlight_off = nil
            player.character.enable_flashlight()
            player.surface.create_entity({name = "flashlight-button-press", position = player.position})
        else
            pdata.flashlight_off = true
            player.character.disable_flashlight()
            player.surface.create_entity({name = "flashlight-button-press", position = player.position})
        end
    end
end
script.on_event("picker-flashlight-toggle", toggle_flashlight)
