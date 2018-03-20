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
        name = 'picker-auto-sort-inventory',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-b[sortinventory]-a'
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
        name = 'picker-find-orphans',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-b[find-orphans]-a'
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
        name = 'picker-auto-manual-train',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-e[automatic-trains]-a'
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
    }
}
