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

Data.create_sound("deltic-start", "__PickerExtended__/sounds/deltic_honk_1.ogg", 1.2)
Data.create_sound("deltic-stop", "__PickerExtended__/sounds/deltic_honk_2.ogg", 1.2)
