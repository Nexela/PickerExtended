-------------------------------------------------------------------------------
--[[Colored Blueprint Books]]--
-------------------------------------------------------------------------------
-- "name": "colored-blueprints-redux",
-- "version": "0.1.1",
-- "title": "Colored Blueprint Books Redux",
-- "author": "Blank",
-- "description": "This mod allows the user to change the color of a blueprint book.",

local colors = require("config").colored_books


local function make_icons(color)
    return {
        {
            icon = "__PickerExtended__/graphics/blueprint-book.png",
        },
        {
            icon = "__PickerExtended__/graphics/blueprint-book-layer.png",
            tint = color
        }
    }
end

--Change the default book to support colors
local default_book = data.raw["blueprint-book"]["blueprint-book"]
default_book.icon = nil
default_book.icons = make_icons({r=0.3, g=0.75, b=1.0, a=1.0})

--Add in the aditional colors
if settings.startup["picker-colored-books"].value then
for name, color in pairs(colors) do
    local book = table.deepcopy(data.raw["blueprint-book"]["blueprint-book"])
    book.name = name.."-book"
    book.icons = make_icons(color)
    book.localised_name = {"item-name.colored-book", {"colors."..name}}
    data:extend{book}
end
end

data:extend{
    {
        type = "custom-input",
        name = "picker-blueprint-colorchange",
        key_sequence = "CONTROL + SHIFT + B",
    }
}
