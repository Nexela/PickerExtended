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
    type = "constant-combinator",
    name = "invis-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
    icon_size = 32,
    flags = {"player-creation", "placeable-off-grid", "not-repairable", "not-on-map"},
    max_health = 1,
    collision_mask = {"not-colliding-with-itself"},
    item_slot_count = settings.startup["picker-notes-slot-count"].value,
    sprites = {
        north = Data.empty_picture(),
        east = Data.empty_picture(),
        south = Data.empty_picture(),
        west = Data.empty_picture()
    },
    activity_led_sprites = {
        north = Data.empty_picture(),
        east = Data.empty_picture(),
        south = Data.empty_picture(),
        west = Data.empty_picture()
    },
    activity_led_light_offsets = {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
    circuit_wire_max_distance = 0,
    circuit_wire_connection_points = {
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        },
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        },
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        },
        {
            shadow = {red = {0, 0}, green = {0, 0}},
            wire = {red = {0, 0}, green = {0, 0}}
        }
    }
}

local function text_settings(text)
    text.icon = "__PickerExtended__/graphics/sticky-note.png"
    text.icon_size = 32
    text.speed = 0
    text.time_to_live = 300
end
Entity("flying-text", "flying-text"):copy("sticky-text"):excute(text_settings)
