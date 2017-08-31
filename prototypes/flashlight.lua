local Data = require("stdlib.data.data")
-------------------------------------------------------------------------------
--[[Flashlight Toggle]]--
-------------------------------------------------------------------------------
--Code from: "Flashlight On Off", and "HD Flashlight" by: "devilwarriors",
data:extend{
    {
        type = "explosion",
        name = "flashlight-button-press",
        flags = {"not-on-map"},
        animations = Data.empty_animations(),
        light = {intensity = 0, size = 0},
        sound =
        {
            {
                filename = "__PickerExtended__/sounds/flashlight_button_press.ogg",
                volume = 1.0
            }
        }
    }
}

data:extend{
    {
        type = "custom-input",
        name = "picker-flashlight-toggle",
        key_sequence = "KEY68"
    }
}
