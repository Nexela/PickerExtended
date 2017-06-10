-------------------------------------------------------------------------------
--[[StickyNotes]]--
-------------------------------------------------------------------------------
local Prototype = require("stdlib.prototype.prototype")

data:extend{
    {
        type = "custom-input",
        name = "picker-notes",
        key_sequence = "ALT + W",
        consuming = "script-only"
    },
}

local tech = {
    type = "technology",
    name = "sticky-notes",
    icon = "__PickerExtended__/graphics/sticky-notes.png",
    icon_size = 128,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "sticky-note",
        },
        {
            type = "unlock-recipe",
            recipe = "sticky-sign",
        },
    },
    unit = {
        count = 20,
        ingredients = {
            {"science-pack-1", 1},
        },
        time = 10
    },
    order = "k-c",
}
data:extend({tech})

--------------------------------------------------------------------------------------
--[[Sticky Note]]--
local sticky_note_recipe = {
    type = "recipe",
    name = "sticky-note",
    enabled = false,
    energy_required = 0.5,
    ingredients =
    {
        {"wood", 3}
    },
    result = "sticky-note",
    result_count = 1,
}

local sticky_note_item = {
    type = "item",
    name = "sticky-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
    flags = {"goes-to-quickbar"},
    subgroup = "terrain",
    order = "y",
    place_result = "sticky-note",
    stack_size = 100
}

local sticky_note = Prototype.duplicate( "container", "wooden-chest", "sticky-note", true)
sticky_note.icon = "__PickerExtended__/graphics/sticky-note.png"
sticky_note.picture =
{
    filename = "__PickerExtended__/graphics/sticky-note.png",
    priority = "extra-high",
    width = 32,
    height = 32,
    shift = {0,0},
}
--sticky_note.collision_mask = "floor-layer"
sticky_note.collision_box = {{-0.1, -0.1}, {0.1, 0.1}}
sticky_note.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
sticky_note.inventory_size = 0

data:extend({sticky_note_recipe, sticky_note_item, sticky_note})

--------------------------------------------------------------------------------------
--[[Sticky Sign]]--
local sticky_sign_recipe = {
    type = "recipe",
    name = "sticky-sign",
    enabled = false,
    energy_required = 1,
    ingredients =
    {
        {"iron-plate", 3}
    },
    result = "sticky-sign",
    result_count = 1,
}

local sticky_sign_item = {
    type = "item",
    name = "sticky-sign",
    icon = "__PickerExtended__/graphics/sign-icon.png",
    flags = {"goes-to-quickbar"},
    subgroup = "terrain",
    order = "y",
    place_result = "sticky-sign",
    stack_size = 100
}

local sticky_sign = Prototype.duplicate( "container", "wooden-chest", "sticky-sign", true )
sticky_sign.icon = "__PickerExtended__/graphics/sign-icon.png"
sticky_sign.picture =
{
    filename = "__PickerExtended__/graphics/sign.png",
    priority = "extra-high",
    width = 64,
    height = 64,
    shift = {0.5,-0.5},
}
sticky_sign.collision_box = {{-0.1, -0.1}, {0.1, 0.1}}
sticky_sign.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
-- sticky_sign.collision_mask = "floor-layer"
sticky_sign.inventory_size = 0

data:extend({sticky_sign_recipe, sticky_sign_item, sticky_sign})

--------------------------------------------------------------------------------------
--[[Sticky Note Proxies]]--
local invis_note_item ={
    type = "item",
    name = "invis-note",
    icon = "__PickerExtended__/graphics/sticky-note.png",
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
    flags = {"player-creation", "placeable-off-grid", "not-repairable", "not-on-map"},
    max_health = 1,
    collision_mask = {"not-colliding-with-itself"},
    item_slot_count = settings.startup["picker-notes-slot-count"].value,
    sprites =
    {
        north = Prototype.empty_sprite(),
        east = Prototype.empty_sprite(),
        south = Prototype.empty_sprite(),
        west = Prototype.empty_sprite(),
    },
    activity_led_sprites =
    {
        north = Prototype.empty_sprite(),
        east = Prototype.empty_sprite(),
        south = Prototype.empty_sprite(),
        west = Prototype.empty_sprite()
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

local sticky_text = Prototype.duplicate("flying-text", "flying-text", "sticky-text")
sticky_text.icon = "__PickerExtended__/graphics/sign-icon.png"
sticky_text.speed = 0
sticky_text.time_to_live = 300

data:extend{invis_note_item, invis_note, sticky_text}
