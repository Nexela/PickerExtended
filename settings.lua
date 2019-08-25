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
        type = 'bool-setting',
        name = 'picker-hide-minimap',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'picker-b[minimap]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-allow-multiple-craft',
        setting_type = 'runtime-per-user',
        default_value = false,
        order = 'picker-b[multiplecraft]-a'
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
    },
    {
        name = 'picker-revive-selected-ghosts-entity',
        setting_type = 'runtime-per-user',
        type = 'bool-setting',
        default_value = true
    },
    {
        name = 'picker-revive-selected-ghosts-tile',
        setting_type = 'runtime-per-user',
        type = 'bool-setting',
        default_value = true
    }
}

-------------------------------------------------------------------------------
--[Tape Measure]--
-------------------------------------------------------------------------------

local possible_colors = {
    'white',
    'black',
    'darkgrey',
    'grey',
    'lightgrey',
    'darkred',
    'red',
    'lightred',
    'darkgreen',
    'green',
    'lightgreen',
    'darkblue',
    'blue',
    'lightblue',
    'orange',
    'yellow',
    'pink',
    'purple',
    'brown'
}

data:extend {
    {
        type = 'bool-setting',
        name = 'picker-log-selection-area',
        setting_type = 'runtime-per-user',
        default_value = false,
        order = 'za'
    },
    {
        type = 'bool-setting',
        name = 'picker-draw-tilegrid-on-ground',
        setting_type = 'runtime-per-user',
        default_value = true,
        order = 'zb'
    },
    {
        type = 'double-setting',
        name = 'picker-tilegrid-line-width',
        setting_type = 'runtime-per-user',
        default_value = 2.0,
        order = 'zd'
    },
    {
        type = 'double-setting',
        name = 'picker-tilegrid-clear-delay',
        setting_type = 'runtime-per-user',
        default_value = 5,
        order = 'ze'
    },
    {
        type = 'int-setting',
        name = 'picker-tilegrid-group-divisor',
        setting_type = 'runtime-per-user',
        default_value = 5,
        order = 'zf'
    },
    {
        type = 'int-setting',
        name = 'picker-tilegrid-split-divisor',
        setting_type = 'runtime-per-user',
        default_value = 4,
        order = 'zg'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-background-color',
        setting_type = 'runtime-per-user',
        default_value = 'black',
        allowed_values = possible_colors,
        order = 'zh'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-border-color',
        setting_type = 'runtime-per-user',
        default_value = 'grey',
        allowed_values = possible_colors,
        order = 'zi'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-label-color',
        setting_type = 'runtime-per-user',
        default_value = 'lightgrey',
        allowed_values = possible_colors,
        order = 'zj'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-color-1',
        setting_type = 'runtime-per-user',
        default_value = 'grey',
        allowed_values = possible_colors,
        order = 'zk'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-color-2',
        setting_type = 'runtime-per-user',
        default_value = 'lightgreen',
        allowed_values = possible_colors,
        order = 'zl'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-color-3',
        setting_type = 'runtime-per-user',
        default_value = 'lightred',
        allowed_values = possible_colors,
        order = 'zm'
    },
    {
        type = 'string-setting',
        name = 'picker-tilegrid-color-4',
        setting_type = 'runtime-per-user',
        default_value = 'yellow',
        allowed_values = possible_colors,
        order = 'zn'
    }
}