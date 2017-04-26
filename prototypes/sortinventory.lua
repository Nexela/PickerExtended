local Proto = require("stdlib.data.protohelpers")
local input_inventory_sort = {
    type = "custom-input",
    name = "picker-manual-inventory-sort",
    key_sequence = "SHIFT + E",
    consuming = "none"
}

local container = {
    type = "container",
    name = "picker-proxy-chest",
    icon = "__base__/graphics/icons/wooden-chest.png",
    flags = {},
    selectable_in_game = false,
    collision_mask = {},
    max_health = 10000,
    inventory_size = 0,
    picture = Proto.empty_animation,
    circuit_wire_max_distance = 0
}

data:extend{input_inventory_sort, container}
