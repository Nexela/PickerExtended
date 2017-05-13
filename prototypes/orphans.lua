local marker = {
    type = "corpse",
    name = "picker-orphan-mark",
    collision_mask = {},
    selection_box = {{-1.5, -1.5}, {.5, .5}},
    minable = {mining_time = 0},
    flags = {"not-repairable", "not-on-map", "not-blueprintable", "not-deconstructable"},
    time_before_removed = 60 * 10,
    final_render_layer = "lower-object",
    splash_speed = .5,
    splash = {
        {
            filename = "__PickerExtended__/graphics/fading_circle.png",
            line_length = 7,
            width = 64,
            height = 64,
            frame_count = 14,
            shift = {-0.5, -0.4},
        }
    }
}

data:extend{marker}
