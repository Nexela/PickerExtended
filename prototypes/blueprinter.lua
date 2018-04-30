local Data = require('stdlib/data/data')

local snap = settings.startup['picker-bp-snap'].value or false

local function get_setting(key)
    return settings.startup[key] and settings.startup[key].value
end

Data {
    type = 'custom-input',
    name = 'picker-mirror-blueprint',
    key_sequence = 'ALT + R'
}

Data {
    type = 'custom-input',
    name = 'picker-bp-snap-n',
    key_sequence = 'PAD 8',
    enabled = snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-e',
    key_sequence = 'PAD 6',
    enabled =  snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-s',
    key_sequence = 'PAD 2',
    enabled =  snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-w',
    key_sequence = 'PAD 4',
    enabled =  snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-nw',
    key_sequence = 'PAD 7',
    enabled =  snap
}

Data {
    type = 'custom-input',
    name = 'picker-bp-snap-ne',
    key_sequence = 'PAD 9',
    enabled =  snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-sw',
    key_sequence = 'PAD 1',
    enabled = snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-se',
    key_sequence = 'PAD 3',
    enabled = snap
}
Data {
    type = 'custom-input',
    name = 'picker-bp-snap-center',
    key_sequence = 'PAD 5',
    enabled = snap
}

Data('blueprint', 'blueprint'):copy('picker-dummy-blueprint'):set_fields {
    draw_label_for_cursor_render = false,
    show_in_library = false,
    flags = {'hidden'},
    order = 'c[automated-construction]-a[blueprint]-no-picker'
}
Data {
    type = 'custom-input',
    name = 'picker-add-empty-bp-to-book',
    key_sequence = 'PAD +',
    linked_game_control = 'larger-terrain-building-area'
}
Data {
    type = 'custom-input',
    name = 'picker-clean-empty-bps-in-book',
    key_sequence = 'PAD +',
    linked_game_control = 'smaller-terrain-building-area'
}
