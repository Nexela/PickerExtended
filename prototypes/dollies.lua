-------------------------------------------------------------------------------
--[Combinator Dollies]--
-------------------------------------------------------------------------------

local Data = require('stdlib/data/data')

data:extend {
    {
        type = 'custom-input',
        name = 'dolly-move-north',
        key_sequence = 'UP'
    },
    {
        type = 'custom-input',
        name = 'dolly-move-west',
        key_sequence = 'LEFT'
    },
    {
        type = 'custom-input',
        name = 'dolly-move-south',
        key_sequence = 'DOWN'
    },
    {
        type = 'custom-input',
        name = 'dolly-move-east',
        key_sequence = 'RIGHT'
    },
    {
        type = 'custom-input',
        name = 'dolly-mass-move-north',
        key_sequence = 'SHIFT + UP'
    },
    {
        type = 'custom-input',
        name = 'dolly-mass-move-west',
        key_sequence = 'SHIFT + LEFT'
    },
    {
        type = 'custom-input',
        name = 'dolly-mass-move-south',
        key_sequence = 'SHIFT + DOWN'
    },
    {
        type = 'custom-input',
        name = 'dolly-mass-move-east',
        key_sequence = 'SHIFT + RIGHT'
    },
    {
        type = 'custom-input',
        name = 'dolly-rotate-rectangle',
        key_sequence = 'PAD DELETE'
    },
    {
        type = 'custom-input',
        name = 'dolly-rotate-saved',
        key_sequence = 'PAD 0',
        linked_game_control = 'rotate'
    },
    {
        type = 'custom-input',
        name = 'dolly-rotate-saved-reverse',
        key_sequence = 'SHIFT + PAD 0',
        linked_game_control = 'reverse-rotate'
    },
    {
        type = 'custom-input',
        name = 'dolly-rotate-ghost',
        key_sequence = 'R',
        linked_game_control = 'rotate'
    },
    {
        type = 'custom-input',
        name = 'dolly-rotate-ghost-reverse',
        key_sequence = 'SHIFT + R',
        linked_game_control = 'reverse-rotate'
    }
}

Data {
    type = 'selection-tool',
    name = 'picker-dolly',
    localised_name = 'Picker Dolly Tool',
    localised_description = 'Mass Move stuff',
    icon = '__PickerExtended__/graphics/dolly.png',
    icon_size = 64,
    flags = {},
    subgroup = 'tool',
    order = 'c[automated-construction]-b[dolly]',
    stack_size = 1,
    stackable = false,
    selection_color = {r = 0, g = 1, b = 0},
    alt_selection_color = {r = 0, g = 0, b = 1},
    selection_mode = {'matches-force', 'buildable-type'},
    alt_selection_mode = {'matches-force', 'buildable-type'},
    selection_cursor_box_type = 'entity',
    alt_selection_cursor_box_type = 'entity',
    always_include_tiles = false,
    show_in_library = true
}
