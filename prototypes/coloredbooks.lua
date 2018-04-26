-------------------------------------------------------------------------------
--[Colored Blueprint Books]--
-------------------------------------------------------------------------------
-- "name": "colored-blueprints-redux",
-- "version": "0.1.1",
-- "title": "Colored Blueprint Books Redux",
-- "author": "Blank",
-- "description": "This mod allows the user to change the color of a blueprint book.",

local Data = require('stdlib/data/data')
local colors = require('config').colored_books
local use_books = settings.startup['picker-colored-books'].value

local function make_icons(color)
    return {
        {
            icon = '__PickerExtended__/graphics/blueprint-book.png',
            icon_size = 32
        },
        {
            icon = '__PickerExtended__/graphics/blueprint-book-layer.png',
            icon_size = 32,
            tint = color
        }
    }
end

--Change the default book to support colors
local book = Data('blueprint-book', 'blueprint-book'):set('icons', make_icons({r = 0.3, g = 0.75, b = 1.0, a = 1.0})):remove_field('icon')
book.flags = book:Flags() + 'hidden'

--Add in the aditional colors
if use_books then
    for name, color in pairs(colors) do
        book:copy(name .. '-book'):set_fields {
            icons = make_icons(color),
            localised_name = {'item-name.colored-book', {'colors.' .. name}},
            show_in_library = false
        }
    end
end

Data {
    type = 'custom-input',
    name = 'picker-blueprint-colorchange',
    key_sequence = 'CONTROL + SHIFT + B',
    disabled = not use_books
}
