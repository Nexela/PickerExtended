-------------------------------------------------------------------------------
--[Picker Extended]--
-------------------------------------------------------------------------------
require('stdlib/core')

MOD = {}
MOD.name = 'PickerExtended'
MOD.if_name = 'picker'
MOD.interfaces = {}
MOD.config = require('config')
MOD.commands = {}
MOD.DEBUG = settings.startup['picker-debug'] and settings.startup['picker-debug'].value or false

local Event = require('stdlib/event/event')
local Player = require('stdlib/event/player')
local Force = require('stdlib/event/force')

local function on_configuration_changed(event)
    if event.data and event.data.mod_changes and event.data.mod_changes[MOD.name] then
        global._changes = global._changes or {}
        global._changes[event.data.mod_changes[MOD.name].new_version] = event.data.mod_changes[MOD.name].old_version or '0.0.0'
        for _, player in pairs(game.players) do
            local gui = player.gui.center['picker_quick_picker']
            if gui then
                gui.destroy()
            end
        end
    end
end
Event.register(Event.core_events.configuration_changed, on_configuration_changed)

local function on_init()
    global._changes = {}
    global._changes[game.active_mods[MOD.name]] = '0.0.0'
    Player.init()
    Force.init()
end
Event.register(Event.core_events.init, on_init)

Player.register_events()
Force.register_events()

if MOD.DEBUG then
    log(MOD.name .. ' Debug mode enabled')
    require('stdlib/core').create_stdlib_globals()
    require('stdlib/utils/scripts/quickstart')
end

--((Picker Scripts))--
require('picker/adjustment-pad')
require('picker/eqkeys')

require('picker/playeroptions')
require('picker/autodeconstruct')
require('picker/reviver')
require('picker/tools')
require('picker/blueprinter')
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
--))Picker Scripts((--

--((Remote Interfaces))--
MOD.interfaces['write_global'] = function()
    game.write_file('Picker/global.lua', serpent.block(global, {comment = false, nocode = true}), false)
end
MOD.interfaces['console'] = require('stdlib/utils/scripts/console')

remote.add_interface(MOD.if_name, MOD.interfaces) --))
