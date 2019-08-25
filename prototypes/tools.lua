local Data = require('__stdlib__/stdlib/data/data')

-- Hide base game items because.
Data('blueprint', 'blueprint'):Flags():add('hidden')
Data('deconstruction-planner', 'deconstruction-item'):Flags():add('hidden')
Data('blueprint-book', 'blueprint-book'):Flags():add('hidden')

-- Tape Measure -- Quick way to get bounding box sizes and distances.
if settings.startup['picker-tool-tape-measure'].value then
    local function shortcut_icon(suffix, size)
        return {
            filename = '__PickerExtended__/graphics/shortcut-bar/tape-measure-'..suffix,
            priority = 'extra-high-no-scale',
            size = size,
            scale = 1,
            flags = {'icon'}
        }
    end
    Data {
        type = 'selection-tool',
        name = 'picker-tape-measure',
        icons = {
            {icon='__PickerExtended__/graphics/black.png', icon_size=1, scale=64},
            {icon='__PickerExtended__/graphics/shortcut-bar/tape-measure-x32-white.png', icon_size=32}
        },
        flags = {'hidden', 'only-in-cursor'},
        subgroup = 'tool',
        order = 'c[selection-tool]-a[tape-measure]',
        stack_size = 1,
        stackable = false,
        selection_color = { g = 1 },
        alt_selection_color = { g = 1, b = 1 },
        selection_mode = {'any-tile'},
        alt_selection_mode = {'any-tile'},
        selection_cursor_box_type = 'copy',
        alt_selection_cursor_box_type = 'electricity',
        always_include_tiles = true,
        show_in_library = false
    }
    Data {
        type = 'shortcut',
        name = 'picker-tape-measure',
        order = 'a[alt-mode]-b[copy]',
        -- associated_control_input = 'get-tapeline-tool',
        action = 'create-blueprint-item',
        item_to_create = 'picker-tape-measure',
        icon = shortcut_icon('x32.png', 32),
        small_icon = shortcut_icon('x24.png', 24),
        disabled_icon = shortcut_icon('x32-white.png', 32),
        disabled_small_icon = shortcut_icon('x24-white.png', 24)
    }
end

-- Eraser
if settings.startup['picker-tool-ore-eraser'].value then
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
if settings.startup['picker-tool-camera'].value then
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
        selection_mode = {'any-tile'},
        selection_cursor_box_type = 'pair',
        selection_color = {r = 0.7, g = 0, b = 0.7},
        alt_selection_mode = {'any-tile'},
        alt_selection_color = {r = 0.7, g = 7, b = 0},
        alt_selection_cursor_box_type = 'pair',
        show_in_library = true
    }
end

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

if settings.startup['picker-tool-rewire'].value then
    Data {
        type = 'selection-tool',
        name = 'picker-rewire',
        icon = '__PickerExtended__/graphics/rewire-tool.png',
        icon_size = 32,
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

--[[ selection_mode flags
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
