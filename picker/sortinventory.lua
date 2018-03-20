local Event = require('stdlib/event/event')

local function sort_inventory(event)
    local player = game.players[event.player_index]
    if player.opened and player.opened_gui_type == defines.gui_type.entity then
        local inventory = player.opened.get_inventory(defines.inventory.car_trunk) or player.opened.get_inventory(defines.inventory.cargo_wagon) or player.opened.get_inventory(defines.inventory.chest)
        if inventory and (event.input_name == 'picker-manual-inventory-sort' or player.mod_settings['picker-auto-sort-inventory'].value) then
            inventory.sort_and_merge()
        end
    end
end
Event.register({'picker-manual-inventory-sort', defines.events.on_gui_opened}, sort_inventory)

return sort_inventory
