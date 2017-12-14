-------------------------------------------------------------------------------
--[[Combinator Dollies]] --
-------------------------------------------------------------------------------
data:extend {
    {
        type = "custom-input",
        name = "dolly-move-north",
        key_sequence = "UP"
    },
    {
        type = "custom-input",
        name = "dolly-move-west",
        key_sequence = "LEFT"
    },
    {
        type = "custom-input",
        name = "dolly-move-south",
        key_sequence = "DOWN"
    },
    {
        type = "custom-input",
        name = "dolly-move-east",
        key_sequence = "RIGHT"
    },
    {
        type = "custom-input",
        name = "dolly-rotate-rectangle",
        key_sequence = "PAD DELETE",
    },
    {
        type = "custom-input",
        name = "dolly-rotate-saved",
        key_sequence = "PAD 0",
        linked_game_control = "rotate"
    },
    {
        type = "custom-input",
        name = "dolly-rotate-saved-reverse",
        key_sequence = "SHIFT + PAD 0",
        linked_game_control = "reverse-rotate"
    },
    {
        type = "custom-input",
        name = "dolly-rotate-ghost",
        key_sequence = "R",
        linked_game_control = "rotate"
    },
    {
        type = "custom-input",
        name = "dolly-rotate-ghost-reverse",
        key_sequence = "SHIFT + R",
        linked_game_control = "reverse-rotate"
    }
}
