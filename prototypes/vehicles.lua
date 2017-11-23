local Data = require("stdlib.data.data")

data:extend {
    {
        type = "custom-input",
        name = "picker-dude-wheres-my-car",
        key_sequence = "CONTROL + SHIFT + J"
    },
    {
        type = "custom-input",
        name = "picker-toggle-train-control",
        key_sequence = "J"
    },
    {
        type = "custom-input",
        name = "picker-goto-station",
        key_sequence = "J"
    },
    {
        type = "custom-input",
        name = "picker-honk",
        key_sequence = "H"
    }
}

Data.create_sound("deltic-start", "__PickerExtended__/sounds/deltic_honk_1.ogg")
Data.create_sound("deltic-stop", "__PickerExtended__/sounds/deltic_honk_2.ogg")
Data.create_sound("train-long", "__PickerExtended__/sounds/honk_long.ogg")
Data.create_sound("train-2x", "__PickerExtended__/sounds/honk_2x.ogg")
Data.create_sound("car-horn", "__PickerExtended__/sounds/horn_honk.ogg")
