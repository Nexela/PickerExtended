require("stdlib.table")
require("stdlib.string")

-- 'consuming'
-- available options:
-- none: default if not defined
-- all: if this is the first input to get this key sequence then no other inputs listening for this sequence are fired
-- script-only: if this is the first *custom* input to get this key sequence then no other *custom* inputs listening for this sequence are fired.
----Normal game inputs will still be fired even if they match this sequence.
-- game-only: The opposite of script-only: blocks game inputs using the same key sequence but lets other custom inputs using the same key sequence fire.
-------------------------------------------------------------------------------
--[[Picker]]--
-------------------------------------------------------------------------------
data:extend{
    {
        type = "custom-input",
        name = "picker-select",
        key_sequence = "Q",
        --consuming = "all"
    },
    {
        type = "custom-input",
        name = "picker-crafter",
        key_sequence = "ALT + Q",
        --consuming = "all"
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
if data.raw["custom-input"]["rename"] then
    -- Gotlags renamer is installed unassign hotkey?
    error("PickerExtended: Renamer installed")
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
        name = "picker-rename-button",
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
        key_sequence = "UP",
        --consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-move-west",
        key_sequence = "LEFT",
        --consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-move-south",
        key_sequence = "DOWN",
        --consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-move-east",
        key_sequence = "RIGHT",
        --consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "dolly-rotate-rectangle",
        key_sequence = "CONTROL + ALT + R",
        --consuming = "game-only"
    }
}

-------------------------------------------------------------------------------
--[[Sounds]]--
-------------------------------------------------------------------------------
local sound_drop = table.deepcopy(data.raw["explosion"]["explosion"])
sound_drop.name = "drop-planner"
for _, animation in pairs(sound_drop.animations) do
    animation.scale = .5
end
for _, variation in pairs(sound_drop.sound.variations) do
    variation.filename = "__base__/sound/fight/laser-1.ogg"
    variation.volume = .5
end
data:extend{sound_drop}

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
