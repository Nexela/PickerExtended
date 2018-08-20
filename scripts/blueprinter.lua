-------------------------------------------------------------------------------
--[[Picker Blueprinter]] --
-------------------------------------------------------------------------------
--Mirroring and Upgradeing code from "Foreman", by "Choumiko"

local Event = require('__stdlib__/event/event')
local Gui = require('__stdlib__/event/gui')
local Player = require('__stdlib__/event/player')
local Area = require('__stdlib__/area/area')
local Position = require('__stdlib__/area/position')
local Inventory = require('__stdlib__/entity/inventory')
local Entity = require('__stdlib__/entity/entity')

local lib = require('__PickerExtended__/utils/lib')

-- Creates the BP tools frame
local function get_or_create_blueprint_gui(player)
    local flow = lib.get_or_create_main_left_flow(player, 'picker')

    local bpframe = flow['picker_bp_tools']
    if not bpframe then
        bpframe = flow.add {type = 'frame', name = 'picker_bp_tools', direction = 'horizontal', style = 'picker_frame'}

        local bptable = bpframe.add {type = 'table', name = 'picker_bp_tools_table', column_count = 4, style = 'picker_table'}
        bptable.add {
            type = 'sprite-button',
            name = 'picker_bp_tools_mirror',
            sprite = 'picker-mirror-sprite',
            style = 'picker_buttons',
            tooltip = {'blueprinter.btn-mirror'}
        }
        bptable.add {
            type = 'choose-elem-button',
            name = 'picker_bp_tools_from',
            elem_type = 'entity',
            style = 'picker_buttons',
            tooltip = {'blueprinter.btn-from'}
        }
        bptable.add {type = 'choose-elem-button', name = 'picker_bp_tools_to', elem_type = 'entity', style = 'picker_buttons', tooltip = {'blueprinter.btn-to'}}
        bptable.add {
            type = 'sprite-button',
            name = 'picker_bp_tools_update',
            sprite = 'picker-upgrade-sprite',
            style = 'picker_buttons',
            tooltip = {'blueprinter.btn-upgrade'}
        }
    end
    return bpframe
end

local function show_bp_tools(event)
    local player, pdata = Player.get(event.player_index)
    local bp = Inventory.get_blueprint(player.cursor_stack)
    local frame = get_or_create_blueprint_gui(player)
    if bp and not Inventory.is_named_bp(bp, 'Belt brush') then
        frame.visible = true
        frame['picker_bp_tools_table']['picker_bp_tools_to'].elem_value = nil
        frame['picker_bp_tools_table']['picker_bp_tools_from'].elem_value = nil
    else
        frame.visible = false
    end
    pdata.last_put = nil
end
Event.register(defines.events.on_player_cursor_stack_changed, show_bp_tools)

-- TODO not needed in .17?
-- Blueprint when running out of items
local function blueprint_single_entity(player, pdata, entity, target_name, area)
    if area:size() > 0 then
        local bp = lib.get_planner(player, 'picker-dummy-blueprint', 'Pipette Blueprint')
        if bp then
            bp.clear_blueprint()
            bp.label = 'Pipette Blueprint'
            bp.allow_manual_label_change = false
            -- Build from surface
            bp.create_blueprint {
                surface = entity.surface,
                force = player.force,
                area = area,
                always_include_tiles = false
            }

            -- Remove garbage
            local found = false
            for i, ent in pairs(bp.get_blueprint_entities() or {}) do
                if ent.name == target_name then
                    bp.set_blueprint_entities {ent}
                    found = true
                    break
                end
            end
            pdata.last_put = nil
            if not found then
                return bp.clear() and nil
            end
            if bp.is_blueprint_setup() then
                pdata.new_simple = true
                local frame = get_or_create_blueprint_gui(player)
                frame['picker_bp_tools_table']['picker_bp_tools_from'].elem_value = entity.name
            end
        else
            player.print({'picker.msg-cant-insert-blueprint'})
        end
    end
end

--Creates a blueprint item in your hand of the last thing you built if you run out of items.
local function last_built(event)
    local player, pdata = Player.get(event.player_index)
    if not player.cursor_stack.valid_for_read and player.mod_settings['picker-blueprint-last'].value and pdata.last_put then
        local entity = event.created_entity
        local area = Area(entity.bounding_box)
        blueprint_single_entity(player, pdata, entity, pdata.last_put, area)
    end
end
Event.register(defines.events.on_built_entity, last_built)

local function last_item(event)
    local player, pdata = Player.get(event.player_index)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        local stack = player.cursor_stack
        if stack.count == 1 and stack.prototype.place_result and not stack.prototype.place_result.has_flag('not-blueprintable') and player.get_item_count(stack.name) == 1 then
            pdata.last_put = stack.prototype.place_result.name
        end
    end
end
Event.register(defines.events.on_put_item, last_item)

-- Make Simple Blueprint --Makes a simple blueprint of the selected entity, including recipes/modules
local function make_simple_blueprint(event)
    local player, pdata = Player.get(event.player_index)
    if player.controller_type ~= defines.controllers.ghost and player.mod_settings['picker-simple-blueprint'].value then
        if player.selected and not (player.selected.type == 'resource' or player.selected.has_flag('not-blueprintable')) then
            if not (player.cursor_stack.valid_for_read and global.planners[player.cursor_stack.name]) then
                local entity = player.selected
                if player.clean_cursor() then
                    if entity.force == player.force and Entity.damaged(entity) and lib.get_planner(player, 'repair-tool') then
                        return
                    else
                        local area = Area(entity.bounding_box)
                        blueprint_single_entity(player, pdata, entity, player.selected.name, area)
                    end
                end
            end
        end
    end
end
Event.register('picker-make-ghost', make_simple_blueprint)

-- Update BP Entities
local function update_blueprint(event)
    local player = game.players[event.player_index]
    local stack = Inventory.get_blueprint(player.cursor_stack, true)
    if stack then
        local from = event.element.parent['picker_bp_tools_from'].elem_value
        local to = event.element.parent['picker_bp_tools_to'].elem_value
        if from and to then
            if game.entity_prototypes[from].fast_replaceable_group == game.entity_prototypes[to].fast_replaceable_group then
                local bp_entities = stack.get_blueprint_entities()
                for _, entity in pairs(bp_entities) do
                    if entity.name == from then
                        entity.name = to
                    end
                end

                stack.set_blueprint_entities(bp_entities)
            else
                player.print({'blueprinter.selections-not-fast-replaceable', {'entity-name.' .. from}, {'entity-name.' .. to}})
            end
        else
            player.print({'blueprinter.no-from-or-to'})
        end
    end
end
Gui.on_click('picker_bp_tools_update', update_blueprint)

--Quick Pick Blueprint -- Makes a quick blueprint from the entity selector gui TODO not needed in .17?
local function create_quick_pick_blueprint(event)
    local player = game.players[event.player_index]
    local stack = Inventory.get_blueprint(player.cursor_stack)
    if event.element.elem_value and stack and (not stack.is_blueprint_setup() or Inventory.is_named_bp(stack, 'Pipette Blueprint')) then
        local _valid_entities = function(v)
            if v.place_result then
                return v.place_result.name == event.element.elem_value and not v.place_result.has_flag('not-blueprintable')
            end
        end
        local item = table.find(game.item_prototypes, _valid_entities)
        if item then
            local _, w, h
            if item.place_result.collision_box then
                _, w, h = Area.size(Area.round_to_integer(item.place_result.collision_box))
            end
            local x = w and w % 2 == 0 and -0.5 or 0
            local y = h and h % 2 == 0 and -0.5 or 0
            local entities = {
                {
                    entity_number = 1,
                    name = event.element.elem_value,
                    direction = defines.direction.north,
                    position = Position.translate({x, y}, defines.direction.northeast, item.place_result.building_grid_bit_shift)
                }
            }
            lib.get_planner(player, 'picker-dummy-blueprint', 'Pipette Blueprint')
            local ok =
                pcall(
                function()
                    stack.set_blueprint_entities(entities)
                end
            )
            if ok then
                stack.label = 'Pipette Blueprint'
            end
        end
    end
end
Gui.on_elem_changed('picker_bp_tools_from', create_quick_pick_blueprint)

--(( Blueprint Book tools ))--
local function add_empty_bp_to_book(event)
    local player = game.players[event.player_index]
    local stack = player.cursor_stack
    if stack.valid_for_read and stack.is_blueprint_book then
        local inv = stack.get_inventory(defines.inventory.item_main)
        --insert a dummy print so we have an easy way to find the idx
        if inv and inv.insert('picker-dummy-blueprint') then
            local slot, idx = inv.find_item_stack('picker-dummy-blueprint')
            if slot and idx and slot.set_stack('blueprint') then
                stack.active_index = idx
                -- Cycling blueprints in books raises cursor changed event, lets emulate that.
                script.raise_event(defines.events.on_player_cursor_stack_changed, {player_index = event.player_index})
            end
        end
    end
end
Event.register('picker-add-empty-bp-to-book', add_empty_bp_to_book)

local function _clear_empty_bp(slot)
    if slot.valid_for_read and not slot.is_blueprint_setup() then
        slot.clear()
    end
end
local function clean_empty_bps_in_book(event)
    local player = game.players[event.player_index]
    local stack = player.cursor_stack
    if stack.valid_for_read and stack.is_blueprint_book then
        local inv = stack.get_inventory(defines.inventory.item_main)
        if inv and not inv.is_empty() then
            local change_index = not (inv[stack.active_index].valid_for_read and inv[stack.active_index].is_blueprint_setup())

            Inventory.each_reverse(inv, _clear_empty_bp)

            if change_index then
                local _, idx = inv.find_item_stack('blueprint')
                stack.active_index = idx or 1
                script.raise_event(defines.events.on_player_cursor_stack_changed, {player_index = event.player_index})
            end
        end
    end
end
Event.register('picker-clean-empty-bps-in-book', clean_empty_bps_in_book) --))
