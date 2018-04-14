local Data = require('stdlib/data/data')

if settings.startup['picker-cheat-recipes'].value then
    Data('other', 'item-group'):copy('picker-cheats'):set_fields {
        order = 'zzzzzzzzz'
    }
    Data {
        type = 'item-subgroup',
        name = 'picker-cheats',
        group = 'picker-cheats',
        order = 'a'
    }
    Data {
        type = 'item-subgroup',
        name = 'picker-cheats-containers',
        group = 'picker-cheats',
        order = 'b'
    }

end
