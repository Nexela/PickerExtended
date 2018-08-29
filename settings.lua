require('settings/tools')
data:extend {
    --(( Selection Tools ))--
    {
        type = 'bool-setting',
        name = 'picker-tool-tape-measure',
        setting_type = 'startup',
        default_value = true,
        order = 'tool-tape-measure'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-ore-eraser',
        setting_type = 'startup',
        default_value = true,
        order = 'tool-ore-eraser'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-wire-cutter',
        setting_type = 'startup',
        default_value = true,
        order = 'tool-wire-cutter'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-pipe-cleaner',
        setting_type = 'startup',
        default_value = true,
        order = 'tool-pipe-cleaner'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-camera',
        setting_type = 'startup',
        default_value = true,
        order = 'tool-camera'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-bp-updater',
        setting_type = 'startup',
        default_value = true,
        order = 'tool-bp-updater'
    },--))
    {
        type = 'bool-setting',
        name = 'picker-bp-snap',
        setting_type = 'startup',
        default_value = true,
        order = 'picker[startup]-edge-snap'
    },
    {
        type = 'bool-setting',
        name = 'picker-transfer-settings-death',
        setting_type = 'startup',
        default_value = true,
        order = 'picker[startup]-transfer-settings'
    }
}

data:extend{
    {
        type = 'bool-setting',
        name = 'picker-wire-cutter-admin',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'picker[admin]'
    },
    {
        type = 'bool-setting',
        name = 'picker-pipe-cleaner-admin',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'picker[admin]'
    }
}

data:extend {
    {
        type = 'bool-setting',
        name = 'picker-simple-blueprint',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-a[blueprint]-a'
    },
    {
        type = 'string-setting',
        name = 'picker-no-blueprint-inv',
        setting_type = 'runtime-per-user',
        default_value = 'none',
        allowed_values = {'none', 'main', 'all'},
        order = 'picker-z[zapper]-a'
    },
    {
        type = 'string-setting',
        name = 'picker-no-deconstruction-planner-inv',
        setting_type = 'runtime-per-user',
        default_value = 'none',
        allowed_values = {'none', 'main', 'all'},
        order = 'picker-z[zapper]-b'
    },
    {
        type = 'string-setting',
        name = 'picker-no-other-planner-inv',
        setting_type = 'runtime-per-user',
        default_value = 'none',
        allowed_values = {'none', 'main', 'all'},
        order = 'picker-z[zapper]-c'
    },
    {
        type = 'bool-setting',
        name = 'picker-item-zapper-all',
        setting_type = 'runtime-per-user',
        default_value = false,
        order = 'picker-z[zapper]-y'
    },
    {
        type = 'bool-setting',
        name = 'picker-hide-minimap',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-b[minimap]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-itemcount',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-b[itemcount]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-search-light',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-b[lights]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-alt-mode-default',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-d[alt-mode]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-camera-gui',
        setting_type = 'runtime-per-user',
        default_value = false,
        order = 'picker-f[screenshot]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-camera-aa',
        setting_type = 'runtime-per-user',
        default_value = false,
        order = 'picker-f[screenshot]-b'
    },
    {
        type = 'double-setting',
        name = 'picker-camera-zoom',
        setting_type = 'runtime-per-user',
        default_value = 1,
        minimum_value = 0,
        order = 'picker-f[screenshot]-c'
    },
    {
        type = 'bool-setting',
        name = 'picker-remember-planner',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-g[planner]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-blueprint-last',
        setting_type = 'runtime-per-user',
        default_value = false,
        order = 'picker-g[last-put]-a'
    },
    {
        type = 'string-setting',
        name = 'picker-bp-updater-version-increment',
        setting_type = 'runtime-per-user',
        order = 'picker-f[1]',
        default_value = 'auto',
        allowed_values = {'off', 'auto', 'on'}
    },
    {
        type = 'string-setting',
        name = 'picker-bp-updater-alt-version-increment',
        setting_type = 'runtime-per-user',
        order = 'picker-f[2]',
        default_value = 'on',
        allowed_values = {'off', 'auto', 'on'}
    },
    {
        type = "bool-setting",
        name = "picker-bp-snap-cardinal-center",
        setting_type = "runtime-per-user",
        order = 'picker-f[3]',
        default_value = true,
    },
    {
        type = "bool-setting",
        name = "picker-bp-snap-horizontal-invert",
        setting_type = "runtime-per-user",
        order = 'picker-f[4]',
        default_value = false,
    },
    {
        type = "bool-setting",
        name = "picker-bp-snap-vertical-invert",
        setting_type = "runtime-per-user",
        order = 'picker-f[5]',
        default_value = false,
    }
}
