-- 'consuming'
-- available options:
-- none: default if not defined
-- all: if this is the first input to get this key sequence then no other inputs listening for this sequence are fired
-- script-only: if this is the first *custom* input to get this key sequence then no other *custom* inputs listening for this sequence are fired.
----Normal game inputs will still be fired even if they match this sequence.
-- game-only: The opposite of script-only: blocks game inputs using the same key sequence but lets other custom inputs using the same key sequence fire.
data:extend{
    {
        type = "custom-input",
        name = "picker-select",
        key_sequence = "Q",
    },
    {
        type = "custom-input",
        name = "picker-crafter",
        key_sequence = "ALT + Q",
    },
    {
        type = "custom-input",
        name = "picker-make-ghost",
        key_sequence = "CONTROL + Q",
    },
    {
        type = "custom-input",
        name = "picker-copy-chest",
        key_sequence = "CONTROL + V",
    },
    {
        type = "custom-input",
        name = "picker-pipe-cleaner",
        key_sequence = "CONTROL + DELETE",
    },
    {
        type = "custom-input",
        name = "picker-wire-cutter",
        key_sequence = "CONTROL + DELETE",
    },
    {
        type = "custom-input",
        name = "picker-wire-picker",
        key_sequence = "SHIFT + Q",
    },
    {
        type = "custom-input",
        name = "picker-beltbrush-corners",
        key_sequence = "CONTROL + SHIFT + R",
    },
    {
        type = "custom-input",
        name = "picker-beltbrush-balancers",
        key_sequence = "CONTROL + SHIFT + B",
    },
    {
        type = "custom-input",
        name = "picker-mirror-blueprint",
        key_sequence = "ALT + R",
    },
    {
        type = "custom-input",
        name = "picker-used-for",
        key_sequence = "CONTROL + SHIFT + ENTER",
    },
    {
        type = "custom-input",
        name = "picker-dude-wheres-my-car",
        key_sequence = "CONTROL + SHIFT + J",
    },
}

local text ={
    type = "flying-text",
    name = "picker-flying-text",
    flags = {"placeable-off-grid", "not-on-map"},
    time_to_live = 60,
    speed = 0.05
}
data:extend{text}
