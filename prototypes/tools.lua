-------------------------------------------------------------------------------
--[[Tape Measure]]-- Quick way to get bounding box sizes and distances.
-------------------------------------------------------------------------------
local tape = {
    type = "selection-tool",
    name = "picker-tape-measure",
    icon = "__PickerExtended__/graphics/tape-measure.png",
    icon_size = 64,
    flags = {"hidden"},
    subgroup = "tool",
    order = "c[automated-construction]-a[tape-measure]",
    stack_size = 1,
    stackable = false,
    selection_color = { r = 0, g = 1, b = 0 },
    alt_selection_color = { r = 0, g = 1, b = 0 },
    selection_mode = {"tiles"},
    alt_selection_mode = {"tiles"},
    selection_cursor_box_type = "copy",
    alt_selection_cursor_box_type = "copy",
    always_include_tiles = true
}

-------------------------------------------------------------------------------
--[[Eraser]]--
-------------------------------------------------------------------------------
local eraser = {
    type = "selection-tool",
    name = "picker-ore-eraser",
    icon = "__PickerExtended__/graphics/ore-eraser.png",
    flags = {"hidden"},
    subgroup = "tool",
    order = "c[automated-construction]-b[ore-eraser]",
    stack_size = 1,
    stackable = false,
    selection_color = { r = 0, g = 1, b = 0 },
    alt_selection_color = { r = 0, g = 0, b = 1 },
    selection_mode = {"any-entity"},
    alt_selection_mode = {"any-entity"},
    selection_cursor_box_type = "pair",
    alt_selection_cursor_box_type = "pair"
}

-------------------------------------------------------------------------------
--[[Screen Shot Camera]]--
-------------------------------------------------------------------------------
--Graphics by Factorio forum/mod portal user YuokiTani
local camera = {
    type = "selection-tool",
    name = "picker-camera",
    icon = "__PickerExtended__/graphics/camera.png",
    flags = {"hidden"},
    subgroup = "tool",
    stack_size = 1,
    stackable = false,
    selection_mode = {"tiles"},
    selection_cursor_box_type = "pair",
    selection_color = {r = 0.7, g = 0, b = 0.7},
    alt_selection_mode = {"tiles"},
    alt_selection_color = {r = 0.7, g = 7, b = 0},
    alt_selection_cursor_box_type = "pair"
}

local hotkey = {
    type = "custom-input",
    name = "picker-planner-menu",
    key_sequence = "SHIFT + B",
    consuming = "none"
}

local hotkey2 = {
    type = "custom-input",
    name = "picker-next-planner",
    key_sequence = "CONTROL + Q",
    consuming = "none"
}

local hotkey3 = {
    type = "custom-input",
    name = "picker-inventory-editor",
    key_sequence = "CONTROL + SHIFT + GRAVE",
    consuming = "all"
}

data:extend{tape, eraser, camera, hotkey, hotkey2, hotkey3}
