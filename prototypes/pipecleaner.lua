local Data = require('__stdlib__/stdlib/data/data')

if settings.startup['picker-tool-pipe-cleaner'].value then
    Data {
        type = 'selection-tool',
        name = 'picker-pipe-cleaner',
        icon = '__PickerExtended__/graphics/pipe-cleaner.png',
        icon_size = 64,
        flags = {'hidden', 'only-in-cursor'},
        subgroup = 'tool',
        order = 'c[selection-tool]-a[pipe-cleaner]',
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
