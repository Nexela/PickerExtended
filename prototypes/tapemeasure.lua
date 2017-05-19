-------------------------------------------------------------------------------
--[[Tape Measure]]-- Quick way to get bounding box sizes and distances.
-------------------------------------------------------------------------------
local tape = {
    type = "selection-tool",
    name = "picker-tape-measure",
    icon = "__PickerExtended__/graphics/tape-measure.png",
    icon_size = 64,
    flags = {"goes-to-quickbar", "hidden"},
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
data:extend{tape}
