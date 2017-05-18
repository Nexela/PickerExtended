-------------------------------------------------------------------------------
--[[Planners]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")
--local Position = require("stdlib.area.position")
local Area = require("stdlib.area.area")
local Entity = require("stdlib.entity.entity")
local lib = require("picker.lib")

-------------------------------------------------------------------------------
--[[Open held item inventory]]--
-------------------------------------------------------------------------------
local function open_held_item_inventory(event)
    local player = game.players[event.player_index]
    if player.cursor_stack.valid_for_read then
        player.opened = player.cursor_stack
    end
end
script.on_event("picker-inventory-editor", open_held_item_inventory)

-------------------------------------------------------------------------------
--[[Make Simple Blueprint]]--
-------------------------------------------------------------------------------
local function make_simple_blueprint(event)
    local player, pdata = Player.get(event.player_index)
    if player.controller_type ~= defines.controllers.ghost then
        if player.selected and not (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable")) then
            if not (player.cursor_stack.valid_for_read and lib.planners[player.cursor_stack.name]) then
                local entity = player.selected
                if player.clean_cursor() then
                    if entity.force == player.force and lib.damaged(entity) and lib.get_planner(player, "repair-tool") then
                        return
                    else
                        local area = Entity.to_collision_area(entity)
                        if Area.size(area) > 0 then
                            local bp = lib.get_planner(player, "blueprint", "Pipette Blueprint")
                            if bp then
                                bp.clear_blueprint()
                                bp.label = "Pipette Blueprint"
                                bp.allow_manual_label_change = false
                                bp.create_blueprint{
                                    surface = entity.surface,
                                    force = player.force,
                                    area = area,
                                    always_include_tiles = false
                                }
                                pdata.new_simple = true
                                return bp.is_blueprint_setup() and bp
                            end
                        end
                    end
                else
                    player.print({"picker.msg-cant-insert-blueprint"})
                end
            end
        end
    end
end
script.on_event("picker-make-ghost", make_simple_blueprint)

local function cycle_planners(event)
    local player, pdata = Player.get(event.player_index)
    if player.controller_type ~= defines.controllers.ghost then
        if not pdata.new_simple or not player.cursor_stack.valid_for_read then
            pdata.last_planner = lib.get_next_planner(player, pdata.last_planner) and player.cursor_stack.name
        end
        pdata.new_simple = false
    end
    --end
end
script.on_event("picker-next-planner", cycle_planners)

-------------------------------------------------------------------------------
--[[Quick Pick Blueprint]]--
-------------------------------------------------------------------------------
local function create_or_destroy_quick_picker(event)
    local player = game.players[event.player_index]
    local gui = player.gui.center["picker_quick_picker"]
    if gui then
        gui.destroy()
    else
        gui = player.gui.center.add{type="frame", name="picker_quick_picker", direction="vertical", style = "filterfill_frame"}
        gui.add{type="label", name = "picker_quick_picker_label", caption = "Quick BP"}
        local btn = gui.add{type="choose-elem-button", name = "picker_quick_picker_item", elem_type="item", style = "picker_blueprinter_btn_elem"}
        btn.style.minimal_height = 32
        btn.style.minimal_height = 32
    end
end
script.on_event("picker-quick-picker", create_or_destroy_quick_picker)

local function create_quick_pick_blueprint(event)
    local player = game.players[event.player_index]
    if event.element.elem_value then
        if player.cheat_mode then
            if player.clean_cursor() then
                player.cursor_stack.set_stack({name = event.element.elem_value, count = 1})
            end
        else
            if game.item_prototypes[event.element.elem_value].place_result then
                local stack = player.clean_cursor() and lib.get_planner(player, "blueprint")
                local entities = {
                    {
                        entity_number = 1,
                        name = game.item_prototypes[event.element.elem_value].place_result.name,
                        direction = defines.direction.north,
                        position = {0.5, 0.5}
                    }
                }
                stack.set_blueprint_entities(entities)
            end

        end
    end
    create_or_destroy_quick_picker(event)
end
Gui.on_elem_changed("picker_quick_picker_item", create_quick_pick_blueprint)
