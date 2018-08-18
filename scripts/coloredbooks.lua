-------------------------------------------------------------------------------
--[Colored Blueprints]--
-------------------------------------------------------------------------------

local Event = require('__stdlib__/event/event')
local colors = require('config').colored_books

local function next_book_color(book_color)
    if book_color == 'blueprint' then
        book_color = nil
    end
    local next_book = next(colors, book_color)
    if next_book == nil then
        return 'blueprint-book'
    else
        return next_book .. '-book'
    end
end

local function change_book_color(event)
    local player = game.players[event.player_index]
    local old_book = player.cursor_stack

    if old_book.valid_for_read and old_book.type == 'blueprint-book' then
        local ent_on_ground =
            player.surface.create_entity {
            name = 'item-on-ground',
            position = player.position,
            stack = {name = next_book_color(old_book.name:match('^(%w+)%-')), count = 1}
        }

        local new_book = ent_on_ground.stack
        local new_book_inv = new_book.get_inventory(defines.inventory.item_main)
        local old_book_inv = old_book.get_inventory(defines.inventory.item_main)

        --If the old book is not empty then transfer the full inventory
        if not old_book_inv.is_empty() then
            for i = 1, #old_book_inv, 1 do
                if old_book_inv[i].valid_for_read then
                    new_book_inv[i].set_stack(old_book_inv[i])
                end
            end
        end

        if old_book.label ~= nil then
            new_book.label = old_book.label
        end
        if old_book.active_index ~= nil then
            new_book.active_index = old_book.active_index
        end

        old_book.set_stack(new_book)
        ent_on_ground.destroy()
    end
end

if settings.startup['picker-colored-books'].value then
    Event.register('picker-blueprint-colorchange', change_book_color)
end
