-------------------------------------------------------------------------------
--[Picker Extended]--
-------------------------------------------------------------------------------
require('stdlib/core')

MOD = {}
MOD.name = 'PickerExtended'
MOD.if_name = 'picker'
MOD.DEBUG = settings.startup['picker-debug'] and settings.startup['picker-debug'].value or false

local Event = require('stdlib/event/event')
Event.protected_mode = MOD.DEBUG
local Changes = require('stdlib/event/changes')
local Player = require('stdlib/event/player')
local Force = require('stdlib/event/force')

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
    require('stdlib/core').create_stdlib_globals()
    require('stdlib/utils/scripts/quickstart')
end

--(( Picker Scripts ))--
require('scripts/adjustment-pad')
require('scripts/eqkeys')

require('scripts/playeroptions')
require('scripts/autodeconstruct')
require('scripts/reviver')
require('scripts/tools')
require('scripts/blueprinter')
require('scripts/bpmirror')
require('scripts/bpupdater')
require('scripts/bpsnap')
require('scripts/planners')
require('scripts/zapper')
require('scripts/dollies')
require('scripts/minimap')
require('scripts/itemcount')
require('scripts/crafter')
require('scripts/renamer')
require('scripts/chestlimit')
require('scripts/copychest')
require('scripts/sortinventory')
require('scripts/wiretool')
require('scripts/pipecleaner')
require('scripts/orphans')
require('scripts/beltbrush')
require('scripts/beltreverser')
require('scripts/pastesettings')
require('scripts/flashlight')
require('scripts/filterfill')
require('scripts/vehicles')
require('scripts/helmod')
require('scripts/notes')
require('scripts/coloredbooks')
require('scripts/nakedrails')
--)) Picker Scripts ((--

--(( Remote Interfaces ))--
local interface = require('interface')
remote.add_interface(MOD.if_name, interface) --))

if MOD.DEBUG then
    Event.register(Event.core_events.init, Event.dump_data)
end
