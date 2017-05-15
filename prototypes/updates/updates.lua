if not data.raw["custom-input"] or not data.raw["custom-input"]["toggle-train-control"] then
    data:extend{
        {
            type = "custom-input",
            name = "toggle-train-control",
            key_sequence = "J"
        }
    }
end
