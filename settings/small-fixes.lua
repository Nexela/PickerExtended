data:extend{
    {
        type = "bool-setting",
        name = "picker-unminable-construction-robots",
        setting_type = "startup",
        default_value = true,
        --default factorio false
    },
    {
        type = "bool-setting",
        name = "picker-unminable-logistic-robots",
        setting_type = "startup",
        default_value = true,
        --default factorio false
    },
    {
        type = "int-setting",
        name = "picker-requester-paste-multiplier",
        setting_type = "startup",
        default_value = 2,
        maximum_value = 100,
        minimum_value = 1,
        --default factorio 2
    },
    {
        type = "int-setting",
        name = "picker-corpse-time",
        setting_type = "startup",
        default_value = 60 * 60,
        minimum_value = 1,
        maximum_value = 60 * 60 * 60,
        --default factorio 54000, 15 minutes
    },
    {
        type = "int-setting",
        name = "picker-inventory-size",
        setting_type = "startup",
        default_value = 60,
        minimum_value = 1,
        maxium_value = 600,
        --default factorio 60
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
