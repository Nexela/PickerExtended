-------------------------------------------------------------------------------
--[[StickyNotes]]--
-------------------------------------------------------------------------------
if not settings.startup["picker-use-notes"].value then return end

local Data = require("stdlib.data.data")

data:extend{
    {
        type = "custom-input",
        name = "picker-notes",
        key_sequence = "ALT + W",
    },
}

--[[Sticky Note Proxies]]--
local invis_note_item ={
    type = "item",
    name = "invis-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
    icon_size = 32,
    flags = { "hidden" },
    subgroup = "circuit-network",
    place_result="invis-note",
    order = "b[combinators]-c[invis-note]",
    stack_size = 1,
}

local invis_note = {
    type = "constant-combinator",
    name = "invis-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
    icon_size = 32,
    flags = {"player-creation", "placeable-off-grid", "not-repairable", "not-on-map"},
    max_health = 1,
    collision_mask = {"not-colliding-with-itself"},
    item_slot_count = settings.startup["picker-notes-slot-count"].value,
    sprites =
    {
        north = Data.empty_picture(),
        east = Data.empty_picture(),
        south = Data.empty_picture(),
        west = Data.empty_picture(),
    },
    activity_led_sprites =
    {
        north = Data.empty_picture(),
        east = Data.empty_picture(),
        south = Data.empty_picture(),
        west = Data.empty_picture()
    },
    activity_led_light_offsets = {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
    circuit_wire_max_distance = 0,
    circuit_wire_connection_points =
    {
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
        },
    }
}

local sticky_text = Data.duplicate("flying-text", "flying-text", "sticky-text")
sticky_text.icon = "__PickerExtended__/graphics/sticky-note.png"
sticky_text.icon_size = 32
sticky_text.speed = 0
sticky_text.time_to_live = 300

data:extend{invis_note_item, invis_note, sticky_text}
