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
