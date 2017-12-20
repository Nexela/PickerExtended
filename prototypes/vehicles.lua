local Data = require("stdlib.data.data")

Data {
    type = "custom-input",
    name = "picker-dude-wheres-my-car",
    key_sequence = "CONTROL + SHIFT + J"
}
Data {
    type = "custom-input",
    name = "picker-toggle-train-control",
    key_sequence = "J"
}
Data {
    type = "custom-input",
    name = "picker-goto-station",
    key_sequence = "J"
}
Data {
    type = "custom-input",
    name = "picker-honk",
    key_sequence = "H"
}

Data.new_sound("deltic-start", "__PickerExtended__/sounds/deltic_honk_1.ogg")
Data.new_sound("deltic-stop", "__PickerExtended__/sounds/deltic_honk_2.ogg")
Data.new_sound("train-long", "__PickerExtended__/sounds/honk_long.ogg")
Data.new_sound("train-2x", "__PickerExtended__/sounds/honk_2x.ogg")
Data.new_sound("car-horn", "__PickerExtended__/sounds/horn_honk.ogg")
