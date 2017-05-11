-------------------------------------------------------------------------------
--[[Blueprinter styles]]--
-------------------------------------------------------------------------------
local function graphical_set(name)
    return {
        type = "monolith",
        monolith_image = {
            filename = "__PickerExtended__/graphics/"..name..".png",
            priority = "extra-high",
            width = 32,
            height = 32,
            x = 0,
            y = 0,
        }
    }
end

local style = data.raw["gui-style"].default

style.picker_blueprinter_buttons = {
    type="button_style",
    parent="button_style",
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

style.picker_blueprinter_btn_mirror = {
    type="button_style",
    parent="picker_blueprinter_buttons",
    default_graphical_set = graphical_set("mirror"),
    hovered_graphical_set = graphical_set("mirror"),
    clicked_graphical_set = graphical_set("mirror"),
}

style.picker_blueprinter_btn_elem = {
    type="button_style",
    parent="picker_blueprinter_buttons",
}

style.picker_blueprinter_btn_upgrade = {
    type="button_style",
    parent="picker_blueprinter_buttons",
    default_graphical_set = graphical_set("upgrade"),
    hovered_graphical_set = graphical_set("upgrade"),
    clicked_graphical_set = graphical_set("upgrade"),
}
