-------------------------------------------------------------------------------
--[[Death Events]]--
-------------------------------------------------------------------------------
-- Death Notice based on "Death Notice", by "Oniell NZ", "martynmnz@yahoo.co.nz"
local function make_death_marker(event)
    local player = game.players[event.player_index]
    local tag = {
        position = player.position,
        text = "Corpse of "..player.name,
        icon = {type = "item", name = "power-armor-mk2"}
    }
    player.force.add_chart_tag(player.surface, tag)
end
Event.register(defines.events.on_pre_player_died, make_death_marker)
