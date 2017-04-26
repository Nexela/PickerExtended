data:extend{
    {
        type = "string-setting",
        name = "picker-item-zapper",
        setting_type = "runtime-per-user",
        default_value = "blueprint blueprint-book deconstruction-planner zone-planner unit-remote-control",
        per_user = true
    },
    {
        type = "bool-setting",
        name = "picker-hide-minimap",
        setting_type = "runtime-per-user",
        default_value = true,
        per_user = true
    },
    {
        type = "bool-setting",
        name = "picker-itemcount",
        setting_type = "runtime-per-user",
        default_value = true,
        per_user = true
    },
    {
        type = "bool-setting",
        name = "picker-auto-sort-inventory",
        setting_type = "runtime-per-user",
        default_value = true,
        per_user = true
    },
    {
        type = "double-setting",
        name = "picker-reacher-build-distance",
        setting_type = "startup",
        default_value = 30,
        maximum_value = 10000,
        minimum_value = 1,
        --default factorio 6
    },
    {
        type = "double-setting",
        name = "picker-reacher-reach-distance",
        setting_type = "startup",
        default_value = 30,
        maximum_value = 10000,
        minimum_value = 1,
        --default factorio 6
    },
    {
        type = "double-setting",
        name = "picker-reacher-reach-resource-distance",
        setting_type = "startup",
        default_value = 2.7,
        maximum_value = 10000,
        minimum_value = 1,
        --default factorio 2.7
    },
    {
        type = "double-setting",
        name = "picker-reacher-drop-item-distance",
        setting_type = "startup",
        default_value = 6,
        maximum_value = 10000,
        minimum_value = 1,
        --default factorio 6
    },
    {
        type = "double-setting",
        name = "picker-reacher-item-pickup-distance",
        setting_type = "startup",
        default_value = 1,
        maximum_value = 100,
        minimum_value = 1,
        --default factorio 1
    },
    {
        type = "double-setting",
        name = "picker-reacher-loot-pickup-distance",
        setting_type = "startup",
        default_value = 2,
        maximum_value = 100,
        minimum_value = 1,
        --default factorio 2
    },
}
