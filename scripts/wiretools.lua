-------------------------------------------------------------------------------
--[WIRE TOOLS]--
-------------------------------------------------------------------------------
local Event = require('__stdlib__/stdlib/event/event')
local lib = require('__PickerExtended__/utils/lib')

--Cut wires code modified from "WireStripper", by "justarandomgeek"
--https://mods.factorio.com/mods/justarandomgeek/wirestripper

local function update_wires(player, entities, network)
    local found = false
    for _, entity in pairs(entities) do
        if not network then
            if entity.type == 'electric-pole' then
                found = true
                pcall(
                    function()
                        entity.disconnect_neighbour()
                    end
                )
            end
        else
            found = true
            pcall(
                function()
                    entity.disconnect_neighbour(defines.wire_type.green)
                    entity.disconnect_neighbour(defines.wire_type.red)
                end
            )
        end
        if entity.last_user then
            entity.last_user = player
        end
    end
    return found
end

local function cut_wires(event)
    if event.item == 'picker-wire-cutter' and #event.entities > 0 then
        local player = game.players[event.player_index]
        if player.admin or not settings.global['picker-wire-cutter-admin'].value then
            if event.name == defines.events.on_player_selected_area then
                if update_wires(player, event.entities) then
                    player.print({'wiretool.copper-removed'})
                end
            elseif event.name == defines.events.on_player_alt_selected_area then
                update_wires(player, event.entities, 'network')
                player.print({'wiretool.network-removed'})
            end
        else
            player.print({'wiretool.must-be-admin'})
        end
    end
end
Event.register({defines.events.on_player_alt_selected_area, defines.events.on_player_selected_area}, cut_wires)

local wire_types = {
    'red-wire',
    'green-wire',
    'copper-cable'
}

local function pick_wires(event)
    local player = game.players[event.player_index]
    local stack = player.cursor_stack
    if not stack.valid_for_read then
        for _, wire_name in ipairs(wire_types) do
            local wire = lib.get_item_stack(player, wire_name)
            if wire then
                return player.clean_cursor() and stack.swap_stack(wire)
            end
        end
        player.print({'wiretool.no-wires-found'})
    elseif stack.valid_for_read then
        local index
        local _find = function(v, k)
            if v == stack.name then
                index = k
                return true
            end
        end

        if table.any(wire_types, _find) then
            local start = index
            repeat
                index = index < #wire_types and index + 1 or 1
                local wire = lib.get_item_stack(player, wire_types[index])
                if wire then
                    return player.clean_cursor() and stack.swap_stack(wire)
                end
            until index == start
            player.print({'wiretool.no-wires-found'})
            player.clean_cursor()
        end
    end
end
Event.register('picker-wire-picker', pick_wires)
