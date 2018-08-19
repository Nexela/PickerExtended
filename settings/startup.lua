local config = require('config')

data:extend {
    {
        type = 'bool-setting',
        name = 'picker-use-notes',
        setting_type = 'startup',
        default_value = true,
        order = 'picker[startup][notes]-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-colored-books',
        setting_type = 'startup',
        default_value = true,
        order = 'picker[startup][colored-blueprints]'
    },
    {
        type = 'bool-setting',
        name = 'picker-naked-rails',
        setting_type = 'startup',
        default_value = true,
        order = 'picker[startup][naked-rails]'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-tape-measure',
        setting_type = 'startup',
        default_value = true,
        order = 'a[startup]-tool-tape-measure'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-ore-eraser',
        setting_type = 'startup',
        default_value = true,
        order = 'a[startup]-tool-ore-eraser'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-camera',
        setting_type = 'startup',
        default_value = true,
        order = 'a[startup]-tool-camera'
    },
    {
        type = 'bool-setting',
        name = 'picker-tool-bp-updater',
        setting_type = 'startup',
        default_value = true,
        order = 'a[startup]-tool-bp-updater'
    },
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

if config.DEBUG then
    data:extend {
        {
            type = 'bool-setting',
            name = 'picker-debug',
            setting_type = 'startup',
            default_value = true,
            order = 'a[startup]'
        }
    }
end
