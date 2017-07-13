-------------------------------------------------------------------------------
--[[MOD CONFIG]]--
-------------------------------------------------------------------------------
local PICKER = {}
PICKER.DEBUG = true

PICKER.colored_books = {
    red = defines.color.red,
    orange = defines.color.orange,
    green = defines.color.green,
    purple = defines.color.purple,
    yellow = defines.color.yellow,
    white = defines.color.white,
    black = defines.color.black,
}

--These settings only affect debug mode, no need to change them
PICKER.quickstart = {
    mod_name = "PickerExtended",
    clear_items = true,
    power_armor = "power-armor-mk2",
    equipment = {
        "creative-mode_super-fusion-reactor-equipment",
        "personal-roboport-mk2-equipment",
        "belt-immunity-equipment"
    },
    starter_tracks = true,
    destroy_everything = true,
    disable_rso_starting = true,
    disable_rso_chunk = true,
    floor_tile = "lab-dark-1",
    floor_tile_alt = "lab-dark-2",
    ore_patches = true,
    make_train = true,
    area_box = {{-250, -250}, {250, 250}},
    chunk_bounds = true,
    center_map_tag = true,
    setup_power = true,
    stacks = {
        "construction-robot",
    },
    quickbar = {
        "picker-tape-measure",
        "creative-mode_item-source",
        "creative-mode_fluid-source",
        "creative-mode_energy-source",
        "creative-mode_super-substation",
        "creative-mode_magic-wand-modifier",
        "creative-mode_super-roboport",
    }
}

return PICKER
