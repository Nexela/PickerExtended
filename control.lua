-------------------------------------------------------------------------------
--[Picker Extended]--
-------------------------------------------------------------------------------
require('__stdlib__/stdlib/core')

MOD = {}
MOD.name = 'PickerExtended'
MOD.if_name = 'picker'
MOD.DEBUG = require('config').DEBUG

local Event = require('__stdlib__/stdlib/event/event')
Event.protected_mode = MOD.DEBUG
local Changes = require('__stdlib__/stdlib/event/changes')
local Player = require('__stdlib__/stdlib/event/player')
local Force = require('__stdlib__/stdlib/event/force')

local function on_init()
    Player.init()
    Force.init()
end
Event.register(Event.core_events.init, on_init)

Changes.register_events()
Player.register_events()
Force.register_events()

if MOD.DEBUG then
    log(MOD.name .. ' Debug mode enabled')
    require('__stdlib__/stdlib/core').create_stdlib_globals()
    require('__stdlib__/stdlib/scripts/quickstart')
end

--(( Picker Scripts ))--
require('scripts/playeroptions')
require('scripts/tools')
require('scripts/reviver')
require('scripts/zapper')
require('scripts/minimap')
require('scripts/itemcount')
require('scripts/renamer')
require('scripts/pastesettings')
require('scripts/flashlight')
require('scripts/helmod')
require('scripts/playerdeath')
require('scripts/wiretools')
require('scripts/pipecleaner')

require('scripts/blueprinter')
require('scripts/bpmirror')
require('scripts/bpupdater')
require('scripts/bpsnap')
require('scripts/planners')
require('scripts/crafter')
--)) Picker Scripts ((--

--(( Remote Interfaces ))--
local interface = require('__stdlib__/stdlib/scripts/interface')
remote.add_interface(MOD.if_name, interface)
remote.add_interface(script.mod_name, interface) --))
