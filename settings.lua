require('settings/tools')
require('settings/playeroptions')

data:extend {
    {
        type = 'bool-setting',
        name = 'picker-transfer-settings-death',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-transfer-settings'
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
        name = 'picker-use-groups',
        setting_type = 'runtime-per-user',
        type = 'bool-setting',
        default_value = true
    },
    {
        name = 'picker-use-subgroups',
        setting_type = 'runtime-per-user',
        type = 'bool-setting',
        default_value = true
    }
}
