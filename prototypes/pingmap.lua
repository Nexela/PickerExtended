-------------------------------------------------------------------------------
--[[Map Ping]]--
-------------------------------------------------------------------------------
local Data = require("stdlib/data/data")

local item = {
    type = "selection-tool",
    name = "picker-ping-tool",
    icon = "__PickerExtended__/graphics/pingtool.png",
    flags = {},
    stackable = false,
    stack_size = 1,
    subgroup = "tool",
    order = "c[automated-construction]-p[ping]",
    selection_color = { r = 0, g = 1, b = 0 },
    alt_selection_color = { r = 0, g = 1, b = 0 },
    selection_mode = {"tiles"},
    alt_selection_mode = {"tiles"},
    selection_cursor_box_type = "copy",
    alt_selection_cursor_box_type = "copy",
    always_include_tiles = true,
    show_in_library = true
}

local entity = {
    type = "smoke-with-trigger",
    name = "picker-map-ping-explosion",
    icon = "__PickerExtended__/graphics/pingtool.png",
    flags = {"not-on-map", "placeable-off-grid"},
    show_when_smoke_off = true,
    animation =
    {
        layers =
        {
            {
                width = 256,
                height = 256,
                flags = { "compressed" },
                priority = "low",
                frame_count = 128,
                shift = {0, 0},
                animation_speed = 1,
                stripes =
                {
                    {
                        filename = "__PickerExtended__/graphics/pingsplosion1.png",
                        width_in_frames = 8,
                        height_in_frames = 8,
                    },
                    {
                        filename = "__PickerExtended__/graphics/pingsplosion2.png",
                        width_in_frames = 8,
                        height_in_frames = 8,
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
    --duration = settings.startup["map-ping-duration-ticks"].value,
    --fade_away_duration = settings.startup["map-ping-duration-ticks"].value / 4,
    spread_duration = 10,
}

Data.create_sound("ping-sound-1", "__PickerExtended__/sounds/ping1.ogg", .75)
Data.create_sound("ping-sound-2", "__PickerExtended__/sounds/ping2.ogg", .75)
Data.create_sound("ping-sound-3", "__PickerExtended__/sounds/ping3.ogg", .75)

data:extend{item, entity}
