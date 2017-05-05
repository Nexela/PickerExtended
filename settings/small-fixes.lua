data:extend{
    {
        type = "bool-setting",
        name = "picker-unminable-construction-robots",
        setting_type = "startup",
        default_value = true,
        order = "picker-a[bots]-a"
        --default factorio false
    },
    {
        type = "bool-setting",
        name = "picker-unminable-logistic-robots",
        setting_type = "startup",
        default_value = true,
        order = "picker-a[bots]-b"
        --default factorio false
    },
    {
        type = "int-setting",
        name = "picker-requester-paste-multiplier",
        setting_type = "startup",
        default_value = 10,
        maximum_value = 100,
        minimum_value = 1,
        order = "picker-c[requester-paste]-a"
        --default factorio 2
    },
    {
        type = "int-setting",
        name = "picker-corpse-time",
        setting_type = "startup",
        default_value = 60 * 60,
        minimum_value = 0,
        maximum_value = 60 * 60 * 60 * 60,
        order = "picker-m[corpse-time]-a"
        --default factorio 54000, 15 minutes
    },
    {
        type = "int-setting",
        name = "picker-player-corpse-time",
        setting_type = "startup",
        default_value = 60 * 60 * 15,
        minimum_value = 0,
        maximum_value = 60 * 60 * 60 * 60,
        order = "picker-m[corpse-time]-b"
        --default factorio 54000, 15 minutes
    },
    {
        type = "int-setting",
        name = "picker-inventory-size",
        setting_type = "startup",
        default_value = 60,
        minimum_value = 1,
        maxium_value = 600,
        order = "picker-b[inv-size]-a"
        --default factorio 60
    },
    {
        type = "double-setting",
        name = "picker-reacher-reach-distance",
        setting_type = "startup",
        default_value = 30,
        maximum_value = 10000,
        minimum_value = 1,
        order = "picker-d[reacher]-a"
        --default factorio 6
    },
    {
        type = "double-setting",
        name = "picker-reacher-build-distance",
        setting_type = "startup",
        default_value = 30,
        maximum_value = 10000,
        minimum_value = 1,
        order = "picker-d[reacher]-b"
        --default factorio 6
    },
    {
        type = "double-setting",
        name = "picker-reacher-reach-resource-distance",
        setting_type = "startup",
        default_value = 2.7,
        maximum_value = 10000,
        minimum_value = 1,
        order = "picker-d[reacher]-c"
        --default factorio 2.7
    },
    {
        type = "double-setting",
        name = "picker-reacher-drop-item-distance",
        setting_type = "startup",
        default_value = 6,
        maximum_value = 10000,
        minimum_value = 1,
        order = "picker-d[reacher]-d"
        --default factorio 6
    },
    {
        type = "double-setting",
        name = "picker-reacher-item-pickup-distance",
        setting_type = "startup",
        default_value = 1,
        maximum_value = 100,
        minimum_value = 1,
        order = "picker-d[reacher]-e"
        --default factorio 1
    },
    {
        type = "double-setting",
        name = "picker-reacher-loot-pickup-distance",
        setting_type = "startup",
        default_value = 2,
        maximum_value = 100,
        minimum_value = 1,
        order = "picker-d[reacher]-f"
        --default factorio 2
    },
    {
        type = "bool-setting",
        name = "picker-hide-mod-names",
        setting_type = "startup",
        default_value = false,
        order = "picker-e[hide-mod-names]-b"
    },
}
