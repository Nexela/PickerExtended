local Data = require('__stdlib__/stdlib/data/data')

data:extend {
    {
        type = 'custom-input',
        name = 'picker-select',
        key_sequence = 'Q',
        linked_game_control = 'smart-pipette'
    },
    {
        type = 'custom-input',
        name = 'picker-crafter',
        key_sequence = 'ALT + Q'
    },
    {
        type = 'custom-input',
        name = 'picker-make-ghost',
        key_sequence = 'CONTROL + Q'
    },
    {
        type = 'custom-input',
        name = 'picker-wire-cutter',
        key_sequence = 'CONTROL + DELETE'
    },
    {
        type = 'custom-input',
        name = 'picker-wire-picker',
        key_sequence = 'SHIFT + Q'
    },
    {
        type = 'custom-input',
        name = 'picker-used-for',
        key_sequence = 'CONTROL + SHIFT + ENTER'
    },
    {
        type = 'custom-input',
        name = 'picker-flashlight-toggle',
        key_sequence = 'SEMICOLON'
    }
}

Data {
    type = 'flying-text',
    name = 'picker-flying-text',
    flags = {'placeable-off-grid', 'not-on-map'},
    time_to_live = 150,
    speed = 0.05
}

Data {
    name = 'picker-buffer-corpse-instant',
    type = 'character-corpse',
    picture = Data.Sprites.empty_pictures(),
    selection_priority = 0,
    time_to_live = 1
}
Data {
    name = 'picker-buffer-corpse-inf',
    type = 'character-corpse',
    picture = Data.Sprites.empty_pictures(),
    selection_priority = 0,
    time_to_live = 2147483647
}
