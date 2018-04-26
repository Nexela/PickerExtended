local Data = require('stdlib/data/data')

-- Hide base game items because.
Data('blueprint', 'blueprint'):Flags():add('hidden')
Data('deconstruction-planner', 'deconstruction-item'):Flags():add('hidden')

-- Tape Measure -- Quick way to get bounding box sizes and distances.
Data {
    type = 'selection-tool',
    name = 'picker-tape-measure',
    icon = '__PickerExtended__/graphics/tape-measure.png',
    icon_size = 64,
    flags = {'hidden'},
    subgroup = 'tool',
    order = 'c[selection-tool]-a[tape-measure]',
    stack_size = 1,
    stackable = false,
    selection_color = {r = 0, g = 1, b = 0},
    alt_selection_color = {r = 0, g = 1, b = 0},
    selection_mode = {'tiles'},
    alt_selection_mode = {'tiles'},
    selection_cursor_box_type = 'copy',
    alt_selection_cursor_box_type = 'copy',
    always_include_tiles = true,
    show_in_library = true
}

-- Eraser
Data {
    type = 'selection-tool',
    name = 'picker-ore-eraser',
    icon = '__PickerExtended__/graphics/ore-eraser.png',
    icon_size = 32,
    flags = {'hidden'},
    subgroup = 'tool',
    order = 'c[selection-tool]-b[ore-eraser]',
    stack_size = 1,
    stackable = false,
    selection_color = {r = 0, g = 1, b = 0},
    alt_selection_color = {r = 0, g = 0, b = 1},
    selection_mode = {'any-entity'},
    alt_selection_mode = {'any-entity'},
    selection_cursor_box_type = 'pair',
    alt_selection_cursor_box_type = 'pair',
    show_in_library = true
}

-- Screen Shot Camera --Graphics by Factorio forum/mod portal user YuokiTani
Data {
    type = 'selection-tool',
    name = 'picker-camera',
    icon = '__PickerExtended__/graphics/camera.png',
    icon_size = 32,
    flags = {'hidden'},
    subgroup = 'tool',
    order = 'd[selection-tool]-b[camera]',
    stack_size = 1,
    stackable = false,
    selection_mode = {'tiles'},
    selection_cursor_box_type = 'pair',
    selection_color = {r = 0.7, g = 0, b = 0.7},
    alt_selection_mode = {'tiles'},
    alt_selection_color = {r = 0.7, g = 7, b = 0},
    alt_selection_cursor_box_type = 'pair',
    show_in_library = true
}

Data {
    type = 'selection-tool',
    name = 'picker-ping-tool',
    icon = '__PickerExtended__/graphics/pingtool.png',
    icon_size = 32,
    flags = {'hidden'},
    stackable = false,
    stack_size = 1,
    subgroup = 'tool',
    order = 'c[selection-tool]-e[ping-tool]',
    selection_color = {r = 0, g = 1, b = 0},
    alt_selection_color = {r = 0, g = 1, b = 0},
    selection_mode = {'tiles'},
    alt_selection_mode = {'tiles'},
    selection_cursor_box_type = 'copy',
    alt_selection_cursor_box_type = 'copy',
    always_include_tiles = true,
    show_in_library = true
}

Data {
    type = 'smoke-with-trigger',
    name = 'picker-map-ping-explosion',
    icon = '__PickerExtended__/graphics/pingtool.png',
    icon_size = 32,
    flags = {'not-on-map', 'placeable-off-grid'},
    show_when_smoke_off = true,
    animation = {
        layers = {
            {
                width = 256,
                height = 256,
                flags = {'compressed'},
                priority = 'low',
                frame_count = 128,
                shift = {0, 0},
                animation_speed = 1,
                stripes = {
                    {
                        filename = '__PickerExtended__/graphics/pingsplosion1.png',
                        width_in_frames = 8,
                        height_in_frames = 8
                    },
                    {
                        filename = '__PickerExtended__/graphics/pingsplosion2.png',
                        width_in_frames = 8,
                        height_in_frames = 8
                    }
                }
            }
        }
    },
    slow_down_factor = 0,
    affected_by_wind = false,
    cyclic = true,
    duration = defines.time.second * 10,
    fade_away_duration = (defines.time.second * 10) / 4,
    spread_duration = 10
}

Data {
    type = 'sound',
    name = 'picker-map-ping-1',
    filename = '__PickerExtended__/sounds/ping1.ogg'
}
Data {
    type = 'sound',
    name = 'picker-map-ping-2',
    filename = '__PickerExtended__/sounds/ping2.ogg'
}
Data {
    type = 'sound',
    name = 'picker-map-ping-3',
    filename = '__PickerExtended__/sounds/ping3.ogg'
}


Data {
    type = 'custom-input',
    name = 'picker-planner-menu',
    key_sequence = 'SHIFT + B',
    consuming = 'none'
}

Data {
    type = 'custom-input',
    name = 'picker-next-planner',
    key_sequence = 'CONTROL + Q',
    consuming = 'none'
}

Data {
    type = 'custom-input',
    name = 'picker-inventory-editor',
    key_sequence = 'CONTROL + SHIFT + GRAVE',
    consuming = 'all'
}
