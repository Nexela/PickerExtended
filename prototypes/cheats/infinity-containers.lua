local path = '__PickerExtended__/graphics/cheats/'

--local Data = require('stdlib/data/data')
local Entity = require('stdlib/data/entity')
local Recipe = require('stdlib/data/recipe')
local Item = require('stdlib/data/item')

--------------------------------------------------------------------------------
--[Infinity-Chests]--
--------------------------------------------------------------------------------
local entity = Entity('infinity-chest', 'infinity-container'):copy('picker-infinity-chest')
entity:copy('picker-infinity-storage-chest'):set_fields {
        logistic_mode = 'storage',
        logistic_slots_count = 1,
        icon = path .. 'infinity-storage-chest.png'
    }.picture.filename = path .. 'infinity-storage-chest.png'
entity:copy('picker-infinity-requester-chest'):set_fields {
        logistic_mode = 'requester',
        icon = path .. 'infinity-requester-chest.png'
    }.picture.filename = path .. 'infinity-requester-chest.png'
entity:copy('picker-infinity-passive-chest'):set_fields {
        logistic_mode = 'passive-provider',
        icon = path .. 'infinity-passive-chest.png'
    }.picture.filename = path .. 'infinity-passive-chest.png'
entity:copy('picker-infinity-active-chest'):set_fields {
        logistic_mode = 'active-provider',
        icon = path .. 'infinity-active-chest.png'
    }.picture.filename = path .. 'infinity-active-chest.png'
entity:copy('picker-infinity-buffer-chest'):set_fields {
        logistic_mode = 'buffer',
        logistic_slots_count = 12,
        icon = path .. 'infinity-buffer-chest.png'
    }.picture.filename = path .. 'infinity-buffer-chest.png'

local item = Item('infinity-chest', 'item'):copy('picker-infinity-chest'):set_fields{stack_size = 100}
item:copy('picker-infinity-active-chest'):set_fields {icon = path .. 'infinity-active-chest.png'}
item:copy('picker-infinity-passive-chest'):set_fields {icon = path .. 'infinity-passive-chest.png'}
item:copy('picker-infinity-storage-chest'):set_fields {icon = path .. 'infinity-storage-chest.png'}
item:copy('picker-infinity-requester-chest'):set_fields {icon = path .. 'infinity-requester-chest.png'}
item:copy('picker-infinity-buffer-chest'):set_fields {icon = path .. 'infinity-buffer-chest.png'}

if settings.startup['picker-cheat-recipes'].value then
    local chest =
        Recipe {
        type = 'recipe',
        name = 'picker-infinity-chest',
        ingredients = {},
        result = 'picker-infinity-chest',
        subgroup = 'picker-cheats-containers',
        order = 'a',
        enabled = true,
        hidden = false
    }
    chest:copy('picker-infinity-active-chest'):set_fields {order = 'b'}
    chest:copy('picker-infinity-passive-chest'):set_fields {order = 'c'}
    chest:copy('picker-infinity-storage-chest'):set_fields {order = 'd'}
    chest:copy('picker-infinity-buffer-chest'):set_fields {order = 'e'}
    chest:copy('picker-infinity-requester-chest'):set_fields {order = 'f'}

end
