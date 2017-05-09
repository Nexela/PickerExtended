local function graphical_set(name, s, x, y)
    return {
        type = "monolith",
        monolith_image = {
            filename = "__PickerExtended__/graphics/"..name..".png",
            priority = "extra-high",
            width = s,
            height = s,
            x = x,
            y = y or 0,
        }
    }
end

local style = data.raw["gui-style"].default


-------------------------------------------------------------------------------
--[[Frames]]--
-------------------------------------------------------------------------------
style.filterfill_frame = {
    type = "frame_style",
    parent = "frame_style",
    top_padding = 0,
    bottom_padding = 0,
    right_padding = 0,
    left_padding = 0,
}
style.filterfill_requests = {
    type = "frame_style",
    parent = "filterfill_frame"
}
style.filterfill_filters = {
    type = "frame_style",
    parent = "filterfill_frame"
}

-------------------------------------------------------------------------------
--[[Buttons]]--
-------------------------------------------------------------------------------
style.filterfill_buttons = {
    type = "button_style",
    parent = "button_style",
    maximal_height = 33,
    minimal_height = 33,
    maximal_width = 33,
    minimal_width = 33,
    left_click_sound = {
        {
            filename = "__core__/sound/gui-click.ogg",
            volume = 1
        }
    }
}

-------------------------------------------------------------------------------
--[[Requests]]--
-------------------------------------------------------------------------------
style.filterfill_requests_btn_bp = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 320),
    hovered_graphical_set = graphical_set("filterfill", 64, 320),
    clicked_graphical_set = graphical_set("filterfill", 64, 320),
}
style.filterfill_requests_btn_2x = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 384),
    hovered_graphical_set = graphical_set("filterfill", 64, 384),
    clicked_graphical_set = graphical_set("filterfill", 64, 384),
}
style.filterfill_requests_btn_5x = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 448),
    hovered_graphical_set = graphical_set("filterfill", 64, 448),
    clicked_graphical_set = graphical_set("filterfill", 64, 448),
}
style.filterfill_requests_btn_10x = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 512),
    hovered_graphical_set = graphical_set("filterfill", 64, 512),
    clicked_graphical_set = graphical_set("filterfill", 64, 512),
}
style.filterfill_requests_btn_max = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 576),
    hovered_graphical_set = graphical_set("filterfill", 64, 576),
    clicked_graphical_set = graphical_set("filterfill", 64, 576),
}
style.filterfill_requests_btn_clear = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 256),
    hovered_graphical_set = graphical_set("filterfill", 64, 256),
    clicked_graphical_set = graphical_set("filterfill", 64, 256),
}
-------------------------------------------------------------------------------
--[[Filters]]--
-------------------------------------------------------------------------------
style.filterfill_filters_btn_all = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 0),
    hovered_graphical_set = graphical_set("filterfill", 64, 0),
    clicked_graphical_set = graphical_set("filterfill", 64, 0),
}
style.filterfill_filters_btn_down = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 64),
    hovered_graphical_set = graphical_set("filterfill", 64, 64),
    clicked_graphical_set = graphical_set("filterfill", 64, 64),
}
style.filterfill_filters_btn_right = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 128),
    hovered_graphical_set = graphical_set("filterfill", 64, 128),
    clicked_graphical_set = graphical_set("filterfill", 64, 128),
}
style.filterfill_filters_btn_set_all = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 192),
    hovered_graphical_set = graphical_set("filterfill", 64, 192),
    clicked_graphical_set = graphical_set("filterfill", 64, 192),
}
style.filterfill_filters_btn_clear_all = {
    type = "button_style",
    parent = "filterfill_buttons",
    default_graphical_set = graphical_set("filterfill", 64, 256),
    hovered_graphical_set = graphical_set("filterfill", 64, 256),
    clicked_graphical_set = graphical_set("filterfill", 64, 256),
}
