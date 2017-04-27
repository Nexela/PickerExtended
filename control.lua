MOD = {}
MOD.name = "PickerExtended"
MOD.if_name = "picker"
MOD.interfaces = {}

require("stdlib.table")
require("stdlib.string")
require("stdlib.color.defines")
require("stdlib.event.event")
require("stdlib.gui.gui")

Event.adjustment_pad = script.generate_event_name()
script.on_event("adjustment-pad-increase", function(event) script.raise_event(Event.adjustment_pad, event) end)
script.on_event("adjustment-pad-decrease", function(event) script.raise_event(Event.adjustment_pad, event) end)

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

-------------------------------------------------------------------------------
--[[Remote Interfaces]]--
-------------------------------------------------------------------------------
MOD.interfaces["write_global"] = function()
    game.write_file("Picker/global.lua", serpent.block(global, {comment=false, nocode=true}), false)
end
MOD.interfaces["get_adjustment_pad_id"] = Event.adjustment_pad
remote.add_interface(MOD.if_name, MOD.interfaces)
