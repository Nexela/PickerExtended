-------------------------------------------------------------------------------
--[[Item Zapper]]--
-------------------------------------------------------------------------------
local zapper = "picker-item-zapper"
local function cleanup_planners(event)
    local player = game.players[event.player_index]
    local _zappable = function(v, _, name)
        return v == name
    end

    if table.any(settings.get_player_settings(player.index)[zapper].value:split(" "), _zappable, event.entity.stack.name) then
        global.last_dropped = global.last_dropped or {}

        if (global.last_dropped[event.player_index] or 0) + 45 < game.tick then
            global.last_dropped[event.player_index] = game.tick
            event.entity.surface.create_entity{name="drop-planner", position = event.entity.position}
            event.entity.destroy()
        else
            player.cursor_stack.set_stack(event.entity.stack)
            event.entity.destroy()
        end
    end
end
Event.register(defines.events.on_player_dropped_item, cleanup_planners)
