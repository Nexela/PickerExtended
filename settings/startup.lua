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
