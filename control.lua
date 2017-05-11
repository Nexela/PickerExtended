MOD = {}
MOD.name = "PickerExtended"
MOD.if_name = "picker"
MOD.interfaces = {}

require("stdlib.table")
require("stdlib.string")
require("stdlib.defines.colors")
require("stdlib.defines.time")
require("stdlib.event.event")
require("stdlib.event.gui")

-------------------------------------------------------------------------------
--[[INIT]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")
Event.register(Event.core_events.configuration_changed,
    function (event)
        if event.data and event.data.mod_changes and event.data.mod_changes[MOD.name] then
            global._changes = global._changes or {}
            global._changes[event.data.mod_changes[MOD.name].new_version] = event.data.mod_changes[MOD.name].old_version or "0.0.0"
            Player.init()
        end
    end
)

Event.register(Event.core_events.init, function()
        global._changes = {}
        global._changes[game.active_mods[MOD.name]] = "0.0.0"
        Player.init()
    end
)

-------------------------------------------------------------------------------
--[[Picker]]--
-------------------------------------------------------------------------------
require("picker.adjustment-pad")
require("picker.reviver")
require("picker.blueprinter")
require("picker.dollies")
require("picker.minimap")
require("picker.itemcount")
require("picker.crafter")
require("picker.renamer")
require("picker.chestlimit")
require("picker.copychest")
require("picker.sortinventory")
require("picker.zapper")
require("picker.wiretool")
require("picker.pipecleaner")
require("picker.orphans")
require("picker.beltbrush")
require("picker.belttools")
require("picker.pastesettings") --needs on/off user config
require("picker.lights")
require("picker.filterfill")

-------------------------------------------------------------------------------
--[[Remote Interfaces]]--
-------------------------------------------------------------------------------
MOD.interfaces["write_global"] = function()
    game.write_file("Picker/global.lua", serpent.block(global, {comment=false, nocode=true}), false)
end

remote.add_interface(MOD.if_name, MOD.interfaces)
