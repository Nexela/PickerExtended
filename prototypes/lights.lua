local Prototype = require("stdlib.data.prototype")
-------------------------------------------------------------------------------
--[[Flashlight Toggle]]--
-------------------------------------------------------------------------------
--Code from: "Flashlight On Off", and "HD Flashlight" by: "devilwarriors",
data:extend{
    {
        type = "explosion",
        name = "flashlight-button-press",
        flags = {"not-on-map"},
        animations = {Prototype.empty_animation},
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
