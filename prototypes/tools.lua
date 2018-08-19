local Data = require('__stdlib__/data/data')

local function get_setting(key)
    return settings.startup[key] and settings.startup[key].value
end

-- Hide base game items because.
Data('blueprint', 'blueprint'):Flags():add('hidden')
Data('deconstruction-planner', 'deconstruction-item'):Flags():add('hidden')
Data('blueprint-book', 'blueprint-book'):Flags():add('hidden')

-- Tape Measure -- Quick way to get bounding box sizes and distances.
if get_setting('picker-tool-tape-measure') then
    Data {
        type = 'selection-tool',
        name = 'picker-tape-measure',
        icon = '__PickerExtended__/graphics/tape-measure.png',
        icon_size = 64,
        flags = {'hidden', 'only-in-cursor'},
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
end

-- Eraser
if get_setting('picker-tool-ore-eraser') then
    Data {
        type = 'selection-tool',
        name = 'picker-ore-eraser',
        icon = '__PickerExtended__/graphics/ore-eraser.png',
        icon_size = 32,
        flags = {'hidden', 'only-in-cursor'},
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
end

-- Screen Shot Camera --Graphics by Factorio forum/mod portal user YuokiTani
if get_setting('picker-tool-camera') then
    Data {
        type = 'selection-tool',
        name = 'picker-camera',
        icon = '__PickerExtended__/graphics/camera.png',
        icon_size = 32,
        flags = {'hidden', 'only-in-cursor'},
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
end

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
