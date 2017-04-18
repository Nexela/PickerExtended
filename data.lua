-------------------------------------------------------------------------------
--[[Picker]]--
-------------------------------------------------------------------------------
data:extend{
    {
        type = "custom-input",
        name = "picker-select",
        key_sequence = "Q",
        consuming = "all"
    },
    {
        type = "custom-input",
        name = "picker-make-ghost",
        key_sequence = "CONTROL + Q",
        consuming = "all"
    },
    {
        type = "custom-input",
        name = "picker-copy-chest",
        key_sequence = "CONTROL + V",
        consuming = "all"
    },
}

-------------------------------------------------------------------------------
--[[Renamer]]--
-------------------------------------------------------------------------------
if data.raw["custom-input"]["rename"] then -- Gotlags renamer is installed unassign hotkey?
    log("PickerExtended: Renamer installed")
end

data:extend{
    {
        type = "custom-input",
        name = "picker-rename",
        key_sequence = "CONTROL + R",
        consuming = "all"
    },
    {
        type = "font",
        name = "picker-renamer-button",
        from = "default-bold",
        size = 14
    }
}

-------------------------------------------------------------------------------
--[[Combinator Dollies]]--
-------------------------------------------------------------------------------
data:extend{
    {
        type = "custom-input",
        name = "dolly-move-north",
        key_sequence = "SHIFT + W",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-move-west",
        key_sequence = "SHIFT + A",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-move-south",
        key_sequence = "SHIFT + S",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-move-east",
        key_sequence = "SHIFT + D",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-rotate-rectangle",
        key_sequence = "SHIFT + R",
        consuming = "game-only"
    }
}

-------------------------------------------------------------------------------
--[[Styles]]--
-------------------------------------------------------------------------------
data.raw["gui-style"].default["picker-renamer-button-style"] =
{
    type = "button_style",
    parent = "button_style",
    font = "picker-renamer-button",
    align = "center",
    top_padding = 2,
    right_padding = 2,
    bottom_padding = 2,
    left_padding = 2,
    default_font_color = {r = 1, g = 0.707, b = 0.12},
    hovered_font_color = {r = 1, g = 1, b = 1},
    clicked_font_color = {r = 1, g = 0.707, b = 0.12}
}
