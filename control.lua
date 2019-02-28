-------------------------------------------------------------------------------
--[Picker Extended]--
-------------------------------------------------------------------------------
require('__stdlib__/stdlib/core')
require('__stdlib__/stdlib/event/event').protected_mode = true
local Changes = require('__stdlib__/stdlib/event/changes')
local Player = require('__stdlib__/stdlib/event/player')
local Force = require('__stdlib__/stdlib/event/force')

Changes.register_events(true)
Player.register_events(true)
Force.register_events(true)

--(( Picker Scripts ))--
require('scripts/playeroptions')
require('scripts/reviver')
require('scripts/zapper')
require('scripts/minimap')
require('scripts/renamer')
require('scripts/pastesettings')
require('scripts/flashlight')
require('scripts/helmod')
require('scripts/groups')

require('scripts/playerdeath')
require('scripts/tools')
require('scripts/wiretools')
require('scripts/oreeraser')

require('scripts/planners')
require('scripts/crafter')
--)) Picker Scripts ((--

--(( Remote Interfaces ))--
local interface = require('__stdlib__/stdlib/scripts/interface')
remote.add_interface('picker', interface)
remote.add_interface(script.mod_name, interface) --))
