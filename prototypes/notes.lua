-------------------------------------------------------------------------------
--[StickyNotes]--
-------------------------------------------------------------------------------
local Data = require('__stdlib__/data/data')
local Item = require('__stdlib__/data/item')
local Entity = require('__stdlib__/data/entity')

local style = data.raw['gui-style'].default

data:extend {
    {
        type = 'font',
        name = 'font_stknt',
        from = 'default',
        border = false,
        size = 15
    },
    {
        type = 'font',
        name = 'font_bold_stknt',
        from = 'default-bold',
        border = false,
        size = 15
    }
}

style.frame_stknt_style = {
    type = 'frame_style',
    parent = 'frame',
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    resize_row_to_width = true,
    resize_to_row_height = false
    -- max_on_row = 1,
}

style.flow_stknt_style = {
    type = 'flow_style',
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 0,
    horizontal_spacing = 2,
    vertical_spacing = 2,
    resize_row_to_width = true,
    resize_to_row_height = false,
    max_on_row = 1,
    graphical_set = {type = 'none'}
}

style.label_stknt_style = {
    type = 'label_style',
    parent = 'label',
    font = 'font_stknt',
    align = 'left',
    default_font_color = {r = 1, g = 1, b = 1},
    hovered_font_color = {r = 1, g = 1, b = 1},
    top_padding = 1,
    right_padding = 1,
    bottom_padding = 0,
    left_padding = 1
}

style.label_bold_stknt_style = {
    type = 'label_style',
    parent = 'label_stknt_style',
    font = 'font_bold_stknt',
    default_font_color = {r = 1, g = 1, b = 0.5},
    hovered_font_color = {r = 1, g = 1, b = 0.5}
}

style.textfield_stknt_style = {
    type = 'textbox_style',
    font = 'font_bold_stknt',
    align = 'left',
    font_color = {},
    default_font_color = {r = 1, g = 1, b = 1},
    hovered_font_color = {r = 1, g = 1, b = 1},
    selection_background_color = {r = 0.66, g = 0.7, b = 0.83},
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 1,
    right_padding = 5,
    minimal_width = 300,
    maximal_width = 600,
    graphical_set = {
        type = 'composition',
        filename = '__core__/graphics/gui.png',
        priority = 'extra-high-no-scale',
        corner_size = {3, 3},
        position = {16, 0}
    }
}

style.textbox_stknt_style = {
    type = 'textbox_style',
    font = 'font_bold_stknt',
    font_color = {},
    default_font_color = {r = 1, g = 1, b = 1},
    hovered_font_color = {r = 1, g = 1, b = 1},
    selection_background_color = {r = 0.66, g = 0.7, b = 0.83},
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 1,
    right_padding = 5,
    minimal_width = 275,
    minimal_height = 75,
    maximal_width = 275,
    graphical_set = {
        type = 'composition',
        filename = '__core__/graphics/gui.png',
        priority = 'extra-high-no-scale',
        corner_size = {3, 3},
        position = {16, 0}
    }
}

style.button_stknt_style = {
    type = 'button_style',
    parent = 'button',
    font = 'font_bold_stknt',
    align = 'center',
    default_font_color = {r = 1, g = 1, b = 1},
    hovered_font_color = {r = 1, g = 1, b = 1},
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    left_click_sound = {
        {
            filename = '__core__/sound/gui-click.ogg',
            volume = 1
        }
    }
}

style.checkbox_stknt_style = {
    type = 'checkbox_style',
    parent = 'checkbox',
    font = 'font_bold_stknt',
    font_color = {r = 1, g = 1, b = 1},
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 2
    -- minimal_height = 32,
    -- maximal_height = 32,
}

if not settings.startup['picker-use-notes'].value then
    return
end

Data {type = 'custom-input', name = 'picker-notes', key_sequence = 'ALT + W'}

Data {
    type = 'sprite',
    name = 'picker-sticky-sprite',
    filename = '__PickerExtended__/graphics/sticky-note.png',
    priority = 'extra-high',
    width = 32,
    height = 32
}

Item {
    type = 'item',
    name = 'invis-note',
    icon = '__PickerExtended__/graphics/sticky-note.png',
    icon_size = 32,
    flags = {'hidden'},
    subgroup = 'circuit-network',
    place_result = 'invis-note',
    order = 'b[combinators]-c[invis-note]',
    stack_size = 1
}

Entity {
    type = 'programmable-speaker',
    name = 'invis-note',
    icon = '__PickerExtended__/graphics/sticky-note.png',
    icon_size = 32,
    flags = {'player-creation', 'placeable-off-grid', 'not-repairable', 'not-on-map'},
    collision_mask = {'not-colliding-with-itself'},
    minable = nil,
    max_health = 150,
    energy_source = {
        type = 'void'
    },
    --render_no_power_icon = false,
    energy_usage_per_tick = '1W',
    sprite = Data.Sprites.empty_picture(),
    audible_distance_modifier = 1, --multiplies the default 40 tiles of audible distance by this number
    maximum_polyphony = 1, --maximum number of samples that can play at the same time
    instruments = {},
    circuit_wire_max_distance = 0
}

Entity('flying-text', 'flying-text'):copy('sticky-text'):set_fields {
    icon = '__PickerExtended__/graphics/sticky-note.png',
    icon_size = 32,
    speed = 0,
    time_to_live = 300
}
