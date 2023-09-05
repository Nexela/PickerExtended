-------------------------------------------------------------------------------
--[Picker Crafter]-- Craft selected entity on hotkey press
-------------------------------------------------------------------------------
local Event = require('__stdlib__/stdlib/event/event')
local lib = require('__PickerAtheneum__/utils/lib')

local function santas_little_helper(player, name)
    local crafted = false
    local allow_multiple = player.mod_settings['picker-allow-multiple-craft'].value
    for _, unlocked_recipe in pairs(player.force.recipes) do
        for _, product in pairs(unlocked_recipe.products) do
            if product.name == name then
                local recipe_name = unlocked_recipe.name
                if game.recipe_prototypes[recipe_name] and player.force.recipes[recipe_name].enabled and (allow_multiple or player.get_item_count(name) == 0) and crafted == false then
                    player.begin_crafting { count = 1, recipe = recipe_name, silent = false }
                    crafted = true
                end
            end
        end
    end
end

local function picker_crafter(event)
    local player = game.players[event.player_index]
    local selected, stack = player.selected, player.cursor_stack
    if selected and stack then
        if not stack.valid_for_read then
            local _, _, ip = lib.get_placeable_item(selected)
            if ip then
                santas_little_helper(player, ip.name)
            end
        end
    elseif player.cursor_ghost then
        santas_little_helper(player, player.cursor_ghost.name)
    end
end
Event.register('picker-crafter', picker_crafter)
