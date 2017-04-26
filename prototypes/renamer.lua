-------------------------------------------------------------------------------
--[[Renamer]]--
-------------------------------------------------------------------------------
--Gotlags renamer is installed unassign hotkey?
if not data.raw["custom-input"]["rename"] then
    data:extend{
        {
            type = "custom-input",
            name = "picker-rename",
            key_sequence = "CONTROL + R",
            consuming = "all"
        },
        {
            type = "font",
            name = "picker-rename-button",
            from = "default-bold",
            size = 14
        }
    }
end

-------------------------------------------------------------------------------
--[[Styles]]--
-------------------------------------------------------------------------------
data.raw["gui-style"].default["picker-rename-button-style"] =
{
    type = "button_style",
    parent = "button_style",
    font = "picker-rename-button",
    align = "center",
    top_padding = 2,
    right_padding = 2,
    bottom_padding = 2,
    left_padding = 2,
    default_font_color = {r = 1, g = 0.707, b = 0.12},
    hovered_font_color = {r = 1, g = 1, b = 1},
    clicked_font_color = {r = 1, g = 0.707, b = 0.12}
}
