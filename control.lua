-------------------------------------------------------------------------------
--[Picker Extended]--
-------------------------------------------------------------------------------
require('stdlib/core')

MOD = {}
MOD.name = 'PickerExtended'
MOD.if_name = 'picker'
MOD.DEBUG = settings.startup['picker-debug'] and settings.startup['picker-debug'].value or false

local Event = require('stdlib/event/event')
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
require('picker/adjustment-pad')
require('picker/eqkeys')

require('picker/playeroptions')
require('picker/autodeconstruct')
require('picker/reviver')
require('picker/tools')
require('picker/blueprinter')
require('picker/bpmirror')
require('picker/bpsnap')
require('picker/planners')
require('picker/zapper')
require('picker/dollies')
require('picker/minimap')
require('picker/itemcount')
require('picker/crafter')
require('picker/renamer')
require('picker/chestlimit')
require('picker/copychest')
require('picker/sortinventory')
require('picker/wiretool')
require('picker/pipecleaner')
require('picker/orphans')
require('picker/beltbrush')
require('picker/beltreverser')
require("picker/pastesettings")
require('picker/flashlight')
require('picker/filterfill')
require('picker/vehicles')
require('picker/helmod')
require('picker/notes')
require('picker/coloredbooks')
require('picker/switchgun')
--)) Picker Scripts ((--

--(( Remote Interfaces ))--
local interface = require('interface')
remote.add_interface(MOD.if_name, interface) --))
