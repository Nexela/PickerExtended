local marker = {
    type = "corpse",
    name = "picker-orphan-mark",
    collision_mask = {},
    selection_box = {{-1.5, -1.5}, {.5, .5}},
    minable = {mining_time = 0},
    flags = {"not-repairable", "not-on-map"},
    time_before_removed = 60 * 10,
    final_render_layer = "lower-object",
    --dying_speed = 1,
    -- animation = {
    -- filename = "__core__/graphics/arrows/gui-arrow-circle.png",
    -- line_length = 1,
    -- width = 50,
    -- height = 50,
    -- frame_count = 1,
    -- direction_count = 1,
    -- shift = {-0.5, -0.4},
    -- scale = 1.5,
    -- priority = "high",
    -- animation_speed = 1
    -- }
    -- animation = {
    --     filename = "__PickerExtended__/graphics/fading_circle.png",
    --     line_length = 7,
    --     width = 64,
    --     height = 64,
    --     frame_count = 14,
    --     direction_count = 1,
    --     priority = "extra-high",
    --     animation_speed = .05,
    -- },
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
