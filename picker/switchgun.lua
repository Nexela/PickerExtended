-------------------------------------------------------------------------------
--[[Switch Player Gun while Driving]]--
-------------------------------------------------------------------------------
local function switch_player_gun_while_driving(event)
    local player = game.players[event.player_index]
    if player.character and player.driving then
        local index = player.character.selected_gun_index
        local gun_inv = player.character.get_inventory(defines.inventory.player_guns)
        local start = index
        repeat
            index = index < #gun_inv and (index + 1) or 1
            if gun_inv[index].valid_for_read then
                player.character.selected_gun_index = index
                break
            end
        until index == start
    end
end
Event.register("switch-player-gun-while-driving", switch_player_gun_while_driving)
