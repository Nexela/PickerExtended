-------------------------------------------------------------------------------
--[Picker Extended]--
-------------------------------------------------------------------------------
require('__stdlib__/core')

MOD = {}
MOD.name = 'PickerExtended'
MOD.if_name = 'picker'
MOD.DEBUG = require('config').DEBUG

local Event = require('__stdlib__/event/event')
Event.protected_mode = MOD.DEBUG
local Changes = require('__stdlib__/event/changes')
local Player = require('__stdlib__/event/player')
local Force = require('__stdlib__/event/force')

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
    require('__stdlib__/core').create_stdlib_globals()
    require('__stdlib__/scripts/quickstart')
end

--(( Picker Scripts ))--
require('scripts/adjustment-pad').register_events()

require('scripts/playeroptions')
require('scripts/reviver')
require('scripts/tools')
require('scripts/blueprinter')
require('scripts/bpmirror')
require('scripts/bpupdater')
require('scripts/bpsnap')
require('scripts/planners')
require('scripts/zapper')
require('scripts/minimap')
require('scripts/itemcount')
require('scripts/crafter')
require('scripts/renamer')
require('scripts/wiretool')
require('scripts/pipecleaner')
require('scripts/orphans')
require('scripts/beltbrush')
require('scripts/beltreverser')
require('scripts/pastesettings')
require('scripts/flashlight')
require('scripts/helmod')
require('scripts/playerdeath')
--)) Picker Scripts ((--

--(( Remote Interfaces ))--
local interface = require('interface')
remote.add_interface(MOD.if_name, interface) --))

if MOD.DEBUG then
    Event.register(Event.core_events.init, Event.dump_data)
end
