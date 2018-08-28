local Data = require('__stdlib__/stdlib/data/data')

if settings.startup['picker-tool-wire-cutter'].value then
    Data {
        type = 'selection-tool',
        name = 'picker-wire-cutter',
        icon = '__PickerExtended__/graphics/cord-cutter.png',
        icon_size = 64,
        flags = {'hidden', 'only-in-cursor'},
        subgroup = 'tool',
        order = 'c[selection-tool]-a[wire-cutter]',
        stack_size = 1,
        stackable = false,
        selection_color = {r = 1, g = 0, b = 0},
        alt_selection_color = {r = 0, g = 1, b = 0},
        selection_mode = {'same-force', 'buildable-type', 'items-to-place'},
        alt_selection_mode = {'same-force', 'buildable-type', 'items-to-place'},
        selection_cursor_box_type = 'copy',
        alt_selection_cursor_box_type = 'copy',
        always_include_tiles = false,
        show_in_library = true
    }
end


--[[
    "blueprint"
    "deconstruct"
    "cancel-deconstruct"
    "items"
    "trees"
    "buildable-type"
    "tiles"
    "items-to-place"
    "any-entity"
    "any-tile"
    "same-force"
    "not-same-force"
    "friend"
    "enemy"
    "upgrade"
    "cancel-upgrade"
    "entity-with-health"
    "entity-with-force"
    "entity-with-owner"
]]
