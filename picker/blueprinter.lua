-------------------------------------------------------------------------------
--[[Picker Blueprinter]]--
-------------------------------------------------------------------------------
local Entity = require("stdlib.entity.entity")
local lib = require("picker.lib")

--Requires empty blueprint in inventory
local function make_simple_blueprint(event)
    local player = game.players[event.player_index]
    if player.controller_type ~= defines.controllers.ghost then
        if player.selected and not (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable")) then
            local entity = player.selected
            if player.clean_cursor() then
                local bp = lib.get_planner(player, "blueprint", "Pipette Blueprint")
                if bp then
                    bp.clear_blueprint()
                    bp.label = "Pipette Blueprint"
                    bp.allow_manual_label_change = false
                    bp.create_blueprint{surface = entity.surface, force = player.force, area = Entity.to_selection_area(entity), always_include_tiles = false}
                    return bp.is_blueprint_setup() and bp
                end
            else
                player.print({"picker.msg-cant-insert-blueprint"})
            end
        elseif not player.selected or (player.selected and (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable"))) then
            if (not player.cursor_stack.valid_for_read or player.cursor_stack.valid_for_read and player.cursor_stack.name ~= "blueprint") then
                --if player.clean_cursor() then
                return player.clean_cursor() and lib.get_planner(player, "blueprint")
                --end
            elseif player.cursor_stack.valid_for_read and player.cursor_stack.name == "blueprint" then
                return player.clean_cursor() and lib.get_planner(player, "deconstruction-planner")
            end
        end
    end
end
script.on_event("picker-make-ghost", make_simple_blueprint)
