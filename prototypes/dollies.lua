-------------------------------------------------------------------------------
--[[Combinator Dollies]]--
-------------------------------------------------------------------------------
local Prototype = require("stdlib.prototype.prototype")
data:extend{
    {
        type = "custom-input",
        name = "dolly-move-north",
        key_sequence = "UP",
    },
    {
        type = "custom-input",
        name = "dolly-move-west",
        key_sequence = "LEFT",
    },
    {
        type = "custom-input",
        name = "dolly-move-south",
        key_sequence = "DOWN",
    },
    {
        type = "custom-input",
        name = "dolly-move-east",
        key_sequence = "RIGHT",
    },
    {
        type = "custom-input",
        name = "dolly-rotate-saved",
        key_sequence = "PAD 0",
    },
    {
        type = "custom-input",
        name = "dolly-rotate-rectangle",
        key_sequence = "PAD DELETE",
    }
}

local sound = {
    type = "explosion",
    name = "picker-cant-move",
    animations = {Prototype.empty_animation()},
    sound = {
        filename = "__core__/sound/cannot-build.ogg",
        volume = .75
    },
}
data:extend{sound}
