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
        name = 'picker-copy-chest',
        key_sequence = 'CONTROL + V'
    },
    {
        type = 'custom-input',
        name = 'picker-pipe-cleaner',
        key_sequence = 'CONTROL + DELETE'
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
        name = 'picker-beltbrush-corners',
        key_sequence = 'CONTROL + SHIFT + R'
    },
    {
        type = 'custom-input',
        name = 'picker-beltbrush-balancers',
        key_sequence = 'CONTROL + SHIFT + B'
    },
    {
        type = 'custom-input',
        name = 'picker-mirror-blueprint',
        key_sequence = 'ALT + R'
    },
    {
        type = 'custom-input',
        name = 'picker-used-for',
        key_sequence = 'CONTROL + SHIFT + ENTER'
    },
    {
        type = 'custom-input',
        name = 'picker-reverse-belts',
        key_sequence = 'ALT + R'
    },
    {
        type = 'custom-input',
        name = 'picker-manual-inventory-sort',
        key_sequence = 'SHIFT + E'
    },
    {
        type = 'custom-input',
        name = 'picker-flashlight-toggle',
        key_sequence = 'KEY68'
    }
}

local text = {
    type = 'flying-text',
    name = 'picker-flying-text',
    flags = {'placeable-off-grid', 'not-on-map'},
    time_to_live = 150,
    speed = 0.05
}
data:extend {text}
