-------------------------------------------------------------------------------
--[[StickyNotes]] --
-------------------------------------------------------------------------------
if not settings.startup["picker-use-notes"].value then
    return
end

local Data = require("stdlib.data.data")
local Item = require("stdlib.data.item")
local Entity = require("stdlib.data.entity")

Data {
    type = "custom-input",
    name = "picker-notes",
    key_sequence = "ALT + W"
}

Data {
    type = "sprite",
    name = "picker-sticky-sprite",
    filename = "__PickerExtended__/graphics/sticky-note.png",
    priority = "extra-high",
    width = 32,
    height = 32
}

Item {
    type = "item",
    name = "invis-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
    icon_size = 32,
    flags = {"hidden"},
    subgroup = "circuit-network",
    place_result = "invis-note",
    order = "b[combinators]-c[invis-note]",
    stack_size = 1
}

Entity {
    type = "programmable-speaker",
    name = "invis-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
    icon_size = 32,
    flags = {"player-creation", "placeable-off-grid", "not-repairable", "not-on-map"},
    collision_mask = {"not-colliding-with-itself"},
    minable = nil,
    max_health = 150,
    energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        render_no_network_icon = false,
        render_no_power_icon = false
    },
    render_no_power_icon = false,
    energy_usage_per_tick = "0W",
    sprite = Data.empty_picture(),
    audible_distance_modifier = 1, --multiplies the default 40 tiles of audible distance by this number
    maximum_polyphony = 1, --maximum number of samples that can play at the same time
    instruments = {
        {
            name = "alarms",
            notes = {
                {name = "alarm-1", sound = {filename = "__base__/sound/programmable-speaker/alarm-1.ogg"}},
                {name = "alarm-2", sound = {filename = "__base__/sound/programmable-speaker/alarm-2.ogg"}},
                {name = "buzzer-1", sound = {filename = "__base__/sound/programmable-speaker/buzzer-1.ogg"}},
                {name = "buzzer-2", sound = {filename = "__base__/sound/programmable-speaker/buzzer-2.ogg"}},
                {name = "buzzer-3", sound = {filename = "__base__/sound/programmable-speaker/buzzer-3.ogg"}},
                {name = "ring", sound = {filename = "__base__/sound/programmable-speaker/ring.ogg", preload = false}},
                {name = "siren", sound = {filename = "__base__/sound/programmable-speaker/siren.ogg", preload = false}}
            }
        }
    },
    circuit_wire_max_distance = 0
}

-- Entity {
--     type = "constant-combinator",
--     name = "invis-note",
--     icon = "__PickerExtended__/graphics/sticky-note.png",
--     icon_size = 32,
--     flags = {"player-creation", "placeable-off-grid", "not-repairable", "not-on-map"},
--     max_health = 1,
--     collision_mask = {"not-colliding-with-itself"},
--     item_slot_count = settings.startup["picker-notes-slot-count"].value,
--     sprites = {
--         north = Data.empty_picture(),
--         east = Data.empty_picture(),
--         south = Data.empty_picture(),
--         west = Data.empty_picture()
--     },
--     activity_led_sprites = {
--         north = Data.empty_picture(),
--         east = Data.empty_picture(),
--         south = Data.empty_picture(),
--         west = Data.empty_picture()
--     },
--     activity_led_light_offsets = {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
--     circuit_wire_max_distance = 0,
--     circuit_wire_connection_points = {
--         {
--             shadow = {red = {0, 0}, green = {0, 0}},
--             wire = {red = {0, 0}, green = {0, 0}}
--         },
--         {
--             shadow = {red = {0, 0}, green = {0, 0}},
--             wire = {red = {0, 0}, green = {0, 0}}
--         },
--         {
--             shadow = {red = {0, 0}, green = {0, 0}},
--             wire = {red = {0, 0}, green = {0, 0}}
--         },
--         {
--             shadow = {red = {0, 0}, green = {0, 0}},
--             wire = {red = {0, 0}, green = {0, 0}}
--         }
--     }
-- }

Entity("flying-text", "flying-text"):copy("sticky-text"):set_fields {
    icon = "__PickerExtended__/graphics/sticky-note.png",
    icon_size = 32,
    speed = 0,
    time_to_live = 300
}
