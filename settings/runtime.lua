data:extend {
    {
        type = 'string-setting',
        name = 'picker-notes-default-message',
        setting_type = 'runtime-global',
        default_value = '',
        allow_blank = true,
        order = 'picker-notes-aa'
    },
    {
        type = 'bool-setting',
        name = 'picker-notes-default-autoshow',
        setting_type = 'runtime-global',
        default_value = false,
        order = 'picker-notes-bb'
    },
    {
        type = 'bool-setting',
        name = 'picker-notes-default-mapmark',
        setting_type = 'runtime-global',
        default_value = false,
        order = 'picker-notes-cb'
    },
    {
        type = 'bool-setting',
        name = 'picker-notes-use-color-picker',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'picker-notes-db'
    },
    {
        type = 'bool-setting',
        name = 'picker-autodeconstruct',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'picker-autodeconstruct-a'
    },
    {
        type = 'bool-setting',
        name = 'picker-autodeconstruct-target',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'picker-autodeconstruct-b'
    },
    {
        type = 'bool-setting',
        name = 'picker-train-honk',
        setting_type = 'runtime-global',
        default_value = true,
        order = 'picker-honk-a'
    },
    {
        type = 'string-setting',
        name = 'picker-train-honk-type',
        setting_type = 'runtime-global',
        default_value = 'deltic',
        allowed_values = {'deltic', 'train'},
        order = 'picker-honk-ab'
    },
}
