-------------------------------------------------------------------------------
--[Reviver] -- Revives the selected entity
-------------------------------------------------------------------------------

local Event = require('__stdlib__/stdlib/event/event')
local Area = require('__stdlib__/stdlib/area/area')
local Player = require('__stdlib__/stdlib/event/player')
local lib = require('__PickerAtheneum__/utils/lib')

--as of 08/30 this is mostly incorporated into base.
--Modules are still not revived,
--items on ground are not picked up
--tile proxys are not selected  Should be added to pippette to put in hand

local function revive_it(event)
    local placed = event.created_entity
    if not lib.ghosts[placed.name] and Area(placed.selection_box):size() > 0 then
        local player = Player.get(event.player_index)
        lib.satisfy_requests(player, placed)
    end
end
Event.register(defines.events.on_built_entity, revive_it)

local function picker_revive_selected(event)
    local player = game.players[event.player_index]
    if player.selected and player.controller_type ~= defines.controllers.ghost then
        if player.selected.name == 'item-on-ground' then
            return player.mine_entity(player.selected)
        elseif player.selected.name == 'item-request-proxy' and not player.cursor_stack.valid_for_read then
            lib.satisfy_requests(player, player.selected)
        end
    end
end
Event.register('picker-select', picker_revive_selected)

return picker_revive_selected
