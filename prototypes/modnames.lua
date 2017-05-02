if settings.startup["picker-hide-mod-names"].value then
    data:extend{
        {
            type = "font",
            name = "null-font",
            from = "default-bold",
            size = 0
        }
    }

    data.raw["gui-style"]["default"].mod_list_label_style =
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
