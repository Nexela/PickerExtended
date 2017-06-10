-------------------------------------------------------------------------------
--[[STYLES and BUTTON SPRITES]]--
-------------------------------------------------------------------------------
local style = data.raw["gui-style"].default

-------------------------------------------------------------------------------
--[[Frames]]--
-------------------------------------------------------------------------------
style.picker_frame = {
    type = "frame_style",
    parent = "frame_style",
    top_padding = 0,
    bottom_padding = 0,
    right_padding = 0,
    left_padding = 0,
}

-------------------------------------------------------------------------------
--[[Tables]]--
-------------------------------------------------------------------------------
style.picker_table = {
    type = "table_style",
    parent = "table_style",
    top_padding = 0,
    bottom_padding = 0,
    right_padding = 0,
    left_padding = 0,
    cell_spacing = 0,
    horizontal_spacing = 0,
    vertical_spacing = 0,
}
-------------------------------------------------------------------------------
--[[32x32 Button Styles]]--
-------------------------------------------------------------------------------
style.picker_buttons = {
    type="button_style",
    parent="button_style",
    maximal_height = 33,
    minimal_height = 33,
    maximal_width = 33,
    minimal_width = 33,
    top_padding = 0,
    bottom_padding = 0,
    right_padding = 0,
    left_padding = 0,
    left_click_sound = {
        {
            filename = "__core__/sound/gui-click.ogg",
            volume = 1
        }
    },
    right_click_sound = {
        {
            filename = "__core__/sound/gui-click.ogg",
            volume = 1
        }
    }
}
style.picker_buttons_med = {
    type="button_style",
    parent="picker_buttons",
    maximal_height = 48,
    minimal_height = 48,
    maximal_width = 48,
    minimal_width = 48,
}
style.picker_buttons_big = {
    type="button_style",
    parent="picker_buttons",
    maximal_height = 64,
    minimal_height = 64,
    maximal_width = 64,
    minimal_width = 64,
}

style.picker_buttons_med_off = {
    type = "button_style",
    parent = "picker_buttons_med",
    default_graphical_set = {
        corner_size = {
            3,
            3
        },
        filename = "__core__/graphics/gui.png",
        load_in_minimal_mode = true,
        position = {
            16,
            16
        },
        priority = "extra-high-no-scale",
        type = "composition"
    }
}

-------------------------------------------------------------------------------
--[[Filterfill Tables]]--
-------------------------------------------------------------------------------

style.filterfill_requests = {
    type = "table_style",
    parent = "picker_table"
}
style.filterfill_filters = {
    type = "table_style",
    parent = "picker_table"
}

-------------------------------------------------------------------------------
--[[MOD Names]]--
-------------------------------------------------------------------------------
if settings.startup["picker-hide-mod-names"].value then
    data:extend{
        {
            type = "font",
            name = "null-font",
            from = "default-bold",
            size = 0
        }
    }

    style.mod_list_label_style =
    {
        type = "label_style",
        parent = "label_style",
        font = "null-font",
        font_color={r=1.0, g=0.0, b=1.0},
        minimal_width = 0,
        maximal_width = 1,
        minimal_height = 0,
        maximal_height = 1,
        width = 0,
        height = 0
    }
end

-------------------------------------------------------------------------------
--[[What is it used for]]--
-------------------------------------------------------------------------------
style.small_spacing_scroll_pane_style =
{
    type = "scroll_pane_style",
    parent = "scroll_pane_style",
    top_padding = 2,
    left_padding = 0,
    right_padding = 0,
    flow_style = {"slot_table_spacing_flow_style"}
}
style.row_table_style =
{
    type = "table_style",
    cell_padding = 5,
    horizontal_spacing=0,
    vertical_spacing=0,
    odd_row_graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {8, 0}
    },
    even_row_graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {8, 0}
    }
}

-------------------------------------------------------------------------------
--[[Sticky Notes]]--
-------------------------------------------------------------------------------
data:extend{
    {
        type = "font",
        name = "font_stknt",
        from = "default",
        border = false,
        size = 15
    },
    {
        type = "font",
        name = "font_bold_stknt",
        from = "default-bold",
        border = false,
        size = 15
    },
}

style.frame_stknt_style =
{
    type="frame_style",
    parent="frame_style",
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    resize_row_to_width = true,
    resize_to_row_height = false,
    -- max_on_row = 1,
}

style.flow_stknt_style =
{
    type = "flow_style",

    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 0,

    horizontal_spacing = 2,
    vertical_spacing = 2,
    resize_row_to_width = true,
    resize_to_row_height = false,
    max_on_row = 1,

    graphical_set = { type = "none" },
}

style.label_stknt_style =
{
    type="label_style",
    parent="label_style",
    font="font_stknt",
    align = "left",
    default_font_color={r=1, g=1, b=1},
    hovered_font_color={r=1, g=1, b=1},
    top_padding = 1,
    right_padding = 1,
    bottom_padding = 0,
    left_padding = 1,
}

style.label_bold_stknt_style =
{
    type="label_style",
    parent="label_stknt_style",
    font="font_bold_stknt",
    default_font_color={r=1, g=1, b=0.5},
    hovered_font_color={r=1, g=1, b=0.5},
}

style.textfield_stknt_style =
{
    type = "textfield_style",
    font="font_bold_stknt",
    align = "left",
    font_color = {},
    default_font_color={r=1, g=1, b=1},
    hovered_font_color={r=1, g=1, b=1},
    selection_background_color= {r=0.66, g=0.7, b=0.83},
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 1,
    right_padding = 5,
    minimal_width = 300,
    maximal_width = 600,
    graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {16, 0}
    },
}

style.button_stknt_style =
{
    type="button_style",
    parent="button_style",
    font="font_bold_stknt",
    align = "center",
    default_font_color={r=1, g=1, b=1},
    hovered_font_color={r=1, g=1, b=1},
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    left_click_sound =
    {
        {
            filename = "__core__/sound/gui-click.ogg",
            volume = 1
        }
    },
}

style.checkbox_stknt_style =
{
    type = "checkbox_style",
    parent="checkbox_style",
    font = "font_bold_stknt",
    font_color = {r=1, g=1, b=1},
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 2,
    -- minimal_height = 32,
    -- maximal_height = 32,
}
