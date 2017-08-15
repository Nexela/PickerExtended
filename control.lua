-------------------------------------------------------------------------------
--[[Picker Extended]]--
-------------------------------------------------------------------------------

require("stdlib.table")
require("stdlib.string")
require("stdlib.defines.color")
require("stdlib.defines.time")

MOD = {}
MOD.name = "PickerExtended"
MOD.if_name = "picker"
MOD.interfaces = {}
MOD.config = require("config")
MOD.commands = {}

require("stdlib.event.event")
require("stdlib.event.player")
require("stdlib.event.force")
require("stdlib.event.gui")

-------------------------------------------------------------------------------
--[[INIT]]--
-------------------------------------------------------------------------------
Event.register(Event.core_events.configuration_changed,
    function (event)
        if event.data and event.data.mod_changes and event.data.mod_changes[MOD.name] then
            global._changes = global._changes or {}
            global._changes[event.data.mod_changes[MOD.name].new_version] = event.data.mod_changes[MOD.name].old_version or "0.0.0"
            for _, player in pairs(game.players) do
                local gui = player.gui.center["picker_quick_picker"]
                if gui then gui.destroy() end
            end
        end
    end
)

Event.register(Event.core_events.init, function()
        global._changes = {}
        global._changes[game.active_mods[MOD.name]] = "0.0.0"
    end
)

local function set_join_options(event)
    local player = game.players[event.player_index]
    if player.mod_settings["picker-alt-mode-default"].value then
        player.game_view_settings.show_entity_info = true
    end
end
Event.register(defines.events.on_player_joined_game, set_join_options)

if MOD.config.DEBUG then
    log(MOD.name .. " Debug mode enabled")
    require("stdlib/debug/quickstart")
end

-------------------------------------------------------------------------------
--[[Picker]]--
-------------------------------------------------------------------------------
require("picker.adjustment-pad")
require("picker.eqkeys") --Equipment hotkeys and gui from nanobots

require("picker.reviver")
require("picker.tools")
require("picker.blueprinter")
require("picker.planners")
--require("picker.death") -- Create a death map tag?
--require("picker.deconstructor") -- Deconstruction Planner Builder?
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
require("picker.flashlight")
require("picker.filterfill")
require("picker.vehicles")
require("picker.helmod")
--require("picker.usedfor") --Built in what is it used for.
--require("picker.pingmap")
require("picker.notes")
require("picker.coloredbooks")
require("picker.switchgun")

-------------------------------------------------------------------------------
--[[Remote Interfaces]]--
-------------------------------------------------------------------------------
MOD.interfaces["write_global"] = function()
    game.write_file("Picker/global.lua", serpent.block(global, {comment=false, nocode=true}), false)
end
MOD.interfaces["console"] = require("stdlib.utils.console")

remote.add_interface(MOD.if_name, MOD.interfaces)
--commands.add_command("picker", "Picker Command", function(event) game.print(serpent.block(event, {comment=false})) end)
