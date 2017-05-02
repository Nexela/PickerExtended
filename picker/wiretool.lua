-------------------------------------------------------------------------------
--[[WIRE TOOLS]]--
-------------------------------------------------------------------------------
local Player = require("stdlib/player")
local lib = require("picker.lib")

--Cut wires code modified from "WireStripper", by "justarandomgeek"
--https://mods.factorio.com/mods/justarandomgeek/wirestripper
local function cut_wires(event)
    local player = Player.get(event.player_index)
    if player.selected and player.selected.circuit_connected_entities then
        pcall(function() player.selected.disconnect_neighbour() end)
        pcall(function() player.selected.disconnect_neighbour(defines.wire_type.red) end)
        pcall(function() player.selected.disconnect_neighbour(defines.wire_type.green) end)
        player.print({"wiretool.all-wires-removed"})
    end
end
script.on_event("picker-wire-cutter", cut_wires)

local wire_types = {
    "red-wire",
    "green-wire",
    "copper-cable",
}

local function pick_wires(event)
    local player = Player.get(event.player_index)
    local stack = player.cursor_stack
    if not stack.valid_for_read then
        for _, wire_name in ipairs (wire_types) do
            local wire = lib.get_item_stack(player, wire_name)
            if wire then
                stack.set_stack(wire)
                wire.clear()
                return
            end
        end
        player.print({"wiretool.no-wires-found"})
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
                    return player.clean_cursor() and stack.set_stack(wire) and wire.clear()
                end
            until index == start
            player.print({"wiretool.no-wires-found"})
            player.clean_cursor()
        end
    end
end
script.on_event("picker-wire-picker", pick_wires)
