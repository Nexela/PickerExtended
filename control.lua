MOD = {}
MOD.name = "PickerExtended"
MOD.if_name = "picker"
MOD.interfaces = {}

require("stdlib.table")
require("stdlib.string")
require("stdlib.color.defines")
require("stdlib.event.event")
require("stdlib.gui.gui")

local Player = require("stdlib.player")

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

Event.register(defines.events.on_player_created, function()MOD.interfaces.write_global() end)

-------------------------------------------------------------------------------
--[[INIT]]--
-------------------------------------------------------------------------------
Event.register(Event.core_events.configuration_changed,
    function (event)
        if event and event.mod_changes and event.mod_changes[MOD.name] then
            Player.init()
            MOD.interfaces.write_global()
        end
    end
)

Event.register(Event.core_events.init, function()
        Player.init()
        MOD.interfaces.write_global()
    end
)

-------------------------------------------------------------------------------
--[[Remote Interfaces]]--
-------------------------------------------------------------------------------
MOD.interfaces["write_global"] = function()
    game.write_file("Picker/global.lua", serpent.block(global, {comment=false, nocode=true}), false)
end
remote.add_interface(MOD.if_name, MOD.interfaces)
