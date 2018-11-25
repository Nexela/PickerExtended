-------------------------------------------------------------------------------
--[StickyNotes]--
-------------------------------------------------------------------------------
local Event = require('stdlib/event/event')
local Gui = require('stdlib/event/gui')
local Player = require('stdlib/event/player')

if not settings.startup['picker-use-notes'].value then
    return
end

local text_color_default = {r = 1, g = 1, b = 0}
local color_array = {}
for _, v in pairs(defines.color) do
    table.insert(color_array, v)
end

local color_picker_interface = 'color-picker'
local open_color_picker_button_name = 'open_color_picker_stknt'
local color_picker_name = 'color_picker_stknt'

--------------------------------------------------------------------------------
--[Gui Layout]--
--------------------------------------------------------------------------------
local function menu_note(player, pdata, open_or_close)
    if open_or_close == nil then
        open_or_close = (player.gui.center.flow_stknt == nil)
    end

    if player.gui.center.flow_stknt then
        player.gui.center.flow_stknt.destroy()
    end

    --! Remove after .16 support
    if player.gui.left.flow_stknt then
        player.gui.left.flow_stknt.destroy()
    end

    if open_or_close then
        local flow, frame, color_button
        local note = pdata.note_sel

        if note then
            flow =
                player.gui.center.add {
                type = 'flow',
                name = 'flow_stknt',
                style = 'achievements_vertical_flow',
                direction = 'vertical'
            }
            frame =
                flow.add {
                type = 'frame',
                name = 'frm_stknt',
                caption = {'notes-gui.title', (player.selected and player.selected.unit_number) or note.n},
                style = 'frame_stknt_style',
                direction = 'vertical'
            }

            local table_main =
                frame.add {
                type = 'table',
                name = 'tab_stknt_main',
                column_count = 1,
                style = 'picker_table'
            }
            local txt_box =
                table_main.add {
                type = 'text-box',
                name = 'txt_stknt',
                text = note.text,
                style = 'textbox_stknt_style',
                word_wrap = true
            }

            if not settings.global['picker-notes-use-color-picker'].value then
                local table_colors =
                    table_main.add {
                    type = 'table',
                    name = 'tab_stknt_colors',
                    style = 'picker_table',
                    column_count = 10
                }
                for name, color in pairs(defines.color) do
                    color_button =
                        table_colors.add {
                        type = 'button',
                        name = 'but_stknt_col_' .. name,
                        caption = '@',
                        style = 'button_stknt_style'
                    }
                    color_button.style.font_color = color
                end
            end

            local table_checks =
                table_main.add {
                type = 'table',
                name = 'tab_stknt_check',
                column_count = 2,
                style = 'picker_table'
            }
            table_checks.add {
                type = 'checkbox',
                name = 'chk_stknt_autoshow',
                caption = {'notes-gui.autoshow'},
                state = note.autoshow or false,
                tooltip = {'notes-gui-tt.autoshow'},
                style = 'checkbox_stknt_style'
            }
            table_checks.add {
                type = 'checkbox',
                name = 'chk_stknt_mapmark',
                caption = {'notes-gui.mapmark'},
                state = note.mapmark ~= nil,
                tooltip = {'notes-gui-tt.mapmark'},
                style = 'checkbox_stknt_style'
            }
            table_checks.add {
                type = 'checkbox',
                name = 'chk_stknt_locked_force',
                caption = {'notes-gui.locked-force'},
                state = note.locked_force or false,
                tooltip = {'notes-gui-tt.locked-force'},
                style = 'checkbox_stknt_style'
            }
            table_checks.add {
                    type = 'checkbox',
                    name = 'chk_stknt_locked_admin',
                    caption = {'notes-gui.locked-admin'},
                    state = note.locked_admin or false,
                    tooltip = {'notes-gui-tt.locked-admin'},
                    style = 'checkbox_stknt_style'
                }.enabled = player.admin

            local table_but =
                table_main.add {
                type = 'table',
                name = 'tab_stknt_but',
                column_count = 6,
                style = 'picker_table'
            }
            table_but.add {
                type = 'button',
                name = 'but_stknt_delete',
                caption = {'notes-gui.delete'},
                tooltip = {'notes-gui-tt.delete'},
                style = 'button_stknt_style'
            }
            table_but.add {
                type = 'button',
                name = 'but_stknt_close',
                caption = {'notes-gui.close'},
                tooltip = {'notes-gui-tt.close'},
                style = 'button_stknt_style'
            }
            -- Use Color Picker mod if enabled.
            if settings.global['picker-notes-use-color-picker'].value and remote.interfaces[color_picker_interface] then
                table_but.add {
                    type = 'button',
                    name = open_color_picker_button_name,
                    caption = {'gui-train.color'},
                    style = 'button_stknt_style'
                }
            end
            txt_box.focus()
            player.opened = flow
        end
    end
end

--------------------------------------------------------------------------------
--[Codes]--
--------------------------------------------------------------------------------
local function display_mapmark(note, on_or_off)
    if note then
        if note.mapmark and note.mapmark.valid then
            note.mapmark.destroy()
        end
        note.mapmark = nil

        if on_or_off and note.invis_note and note.invis_note.valid then
            local tag = {
                icon = {type = 'item', name = 'invis-note'},
                position = note.invis_note.position,
                text = note.text,
                last_user = note.last_user,
                target = note.invis_note
            }
            note.mapmark = note.invis_note.force.add_chart_tag(note.invis_note.surface, tag)
        end
    end
end

local function create_invis_note(entity)
    local surf = entity.surface
    local invis_note =
        surf.create_entity(
        {
            name = 'invis-note',
            position = entity.position,
            direction = entity.direction,
            force = entity.force
        }
    )
    invis_note.destructible = false
    invis_note.operable = false
    return invis_note
end

local function encode_note(note)
    local invis_note = note.invis_note

    if invis_note then
        invis_note.alert_parameters = {
            show_alert = true,
            show_on_map = true,
            icon_signal_id = {type = 'item', name = 'invis-note'},
            alert_message = note.text
        }
    end
end

local function decode_note(invis_note, target)
    local note = {}
    note.invis_note = invis_note
    note.target = target
    note.target_unit_number = target.unit_number -- needed in case target becomes invalid
    note.text = invis_note.alert_parameters.alert_message
    return note
end

local function show_note(note)
    if note then
        if note.fly and note.fly.valid then
            note.fly.active = note.autoshow or false
            return
        end

        if note.invis_note and note.invis_note.valid then
            local pos = note.invis_note.position
            local surf = note.invis_note.surface
            local x = pos.x - 1
            local y = pos.y

            local fly =
                surf.create_entity {
                name = 'sticky-text',
                text = note.text,
                color = note.color,
                position = {x = x, y = y}
            }
            if fly then
                note.fly = fly
                note.fly.active = note.autoshow or false
            end
        end
    end
end

local function hide_note(note)
    if note then
        if note.fly and note.fly.valid then
            note.fly.destroy()
        end
        note.fly = nil
    end
end

local function destroy_note(note)
    for _, player in pairs(game.connected_players) do
        local pdata = global.players[player.index]

        if pdata.note_sel == note then
            menu_note(player, pdata, false)
            pdata.note_sel = nil
        end
    end

    hide_note(note)

    if note.mapmark and note.mapmark.valid then
        note.mapmark.destroy()
    end
    note.mapmark = nil


    if note.invis_note and note.invis_note.valid then
        global.notes_by_invis[note.invis_note.unit_number] = nil
        global.notes_by_target[note.target_unit_number] = nil
        note.invis_note.destroy()
    end
end

-- lookup the note of an invis-note or a target entity
local function get_note(ent)
    if ent.name == 'invis-note' then
        return global.notes_by_invis[ent.unit_number]
    end
    return global.notes_by_target[ent.unit_number]
end

local function on_selected_entity_changed(event)
    local player = game.players[event.player_index]
    if player.selected then
        return show_note(get_note(player.selected))
    end
end
Event.register(defines.events.on_selected_entity_changed, on_selected_entity_changed)

local function register_note(note)
    global.n_note = global.n_note + 1
    note.n = global.n_note
    global.notes_by_target[note.target.unit_number] = note
    global.notes_by_invis[note.invis_note.unit_number] = note
end

local function update_note_target(note, new_target)
    if note.target then
        global.notes_by_target[note.target_unit_number] = nil
    end
    note.target = new_target
    note.target_unit_number = new_target.unit_number
    global.notes_by_target[new_target.unit_number] = note
end

local function add_note(entity)
    local note = {
        text = 'text ' .. global.n_note + 1, -- text
        color = text_color_default, -- color
        n = nil, -- number of the note
        fly = nil, -- text entity
        autoshow = settings.global['picker-notes-default-autoshow'].value, -- if true, then note autoshows/hides
        mapmark = nil, -- mark on the map
        locked_force = true, -- only modifiable by the same force
        locked_admin = false, -- only modifiable by admins
        editer = nil, -- player currently editing
        is_sign = (entity.name == 'sticky-note' or entity.name == 'sticky-sign'), -- is connected to a real note/sign object
        invis_note = create_invis_note(entity),
        target = entity,
        target_unit_number = entity.unit_number -- needed in case target becomes invalid
    }

    note.text = #settings.global['picker-notes-default-message'].value > 1 and settings.global['picker-notes-default-message'].value or note.text
    show_note(note)
    register_note(note)
    display_mapmark(note, settings.global['picker-notes-default-mapmark'].value)
    encode_note(note)

    return (note)
end

local function entity_moved(event)
    local ent = event.moved_entity and event.moved_entity.valid and event.moved_entity
    if ent then
        local note = get_note(ent)
        if note then
            note.invis_note.teleport(ent.position)
            if note.fly then
                hide_note(note)
                show_note(note)
            end
        end
    end
end
Event.register(Event.generate_event_name('dolly_moved'), entity_moved)

local function on_creation(event)
    local ent = event.created_entity

    if not ent.valid then
        return
    end

    -- Revive note ghosts immediately
    if ent.name == 'entity-ghost' and ent.ghost_name == 'invis-note' then
        local revived, rev_ent = ent.revive()
        if revived then
            ent = rev_ent
        end
    end

    if ent.name == 'invis-note' then
        ent.destructible = false
        ent.operable = false

        -- Only place an invis-note on a ghost, if that ghost doesn't already have a note
        -- With instant blueprint, the entity revive order is different between different entities.
        -- It is known that oil-refinery > invis-note > chest.
        -- In case the target has not been revived yet, e.g. no instant blueprint, or chest with instant blueprint.
        local note_target
        local note_targets =
            ent.surface.find_entities_filtered {
            name = 'entity-ghost',
            position = ent.position,
            force = ent.force,
            limit = 1
        }

        if #note_targets > 0 then
            local target = note_targets[1]
            if target.valid and get_note(target) == nil then
                note_target = target
            end
        end
        -- In case the target has already been revived, e.g. oil-refinery with instant blueprint.
        if not note_target then
            note_targets = ent.surface.find_entities_filtered {position = ent.position, force = ent.force}
            for _, target in pairs(note_targets) do
                if target.prototype.has_flag('player-creation') then
                    if target.valid and get_note(target) == nil then
                        note_target = target
                    end
                    break
                end
            end
        end

        if note_target then
            local note = decode_note(ent, note_target)
            if note then
                note.invis_note.teleport(note.target.position) -- align the note to avoid adding up error
                register_note(note)
                show_note(note)
                display_mapmark(note, note.mapmark)
            else
                -- we could keep around the invis-note in case they install a newer version that makes it readable
                -- but then we'd have to keep track of the invis-notes on the map, instead of just decoding on creation
                ent.destroy()
            end
        else
            ent.destroy()
        end
    elseif ent.name ~= 'entity-ghost' then -- when a normal item is placed figure out what ghosts are destroyed
        if (ent.name == 'sticky-note' or ent.name == 'sticky-sign') then
            ent.destructible = false
            ent.operable = false
        end

        local x = ent.position.x
        local y = ent.position.y
        local invis_notes = ent.surface.find_entities_filtered {name = 'invis-note', area = {{x - 10, y - 10}, {x + 10, y + 10}}}
        for _, invis_note in pairs(invis_notes) do
            local note = get_note(invis_note)
            if note and not note.target.valid then -- if we deleted a ghost with this placement
                if math.abs(invis_note.position.x - x) < 0.01 and math.abs(invis_note.position.y - y) < 0.01 then -- if we replaced a correct ghost, reassign
                    update_note_target(note, ent)
                else -- we destroyed an unrelated ghost
                    destroy_note(note)
                end
            end
        end
    end
end
Event.register({defines.events.on_built_entity, defines.events.on_robot_built_entity}, on_creation)

local function on_destruction(event)
    local ent = event.entity
    local note = get_note(ent)
    if note then
        destroy_note(note)
    end
end
Event.register({defines.events.on_entity_died, defines.events.on_robot_pre_mined, defines.events.on_pre_player_mined_item}, on_destruction)

local function on_marked_for_deconstruction(event)
    local ent = event.entity
    if ent.name == 'invis-note' then
        local note = get_note(ent)
        if not note.target.valid or note.target.name == 'entity-ghost' then
            destroy_note(note)
        else -- if target is still valid, just cancel deconstruction
            local force = (event.player_index and game.players[event.player_index].force) or (ent.last_user and ent.last_user.force) or ent.force
            ent.cancel_deconstruction(force)
        end
    end
end
Event.register(defines.events.on_marked_for_deconstruction, on_marked_for_deconstruction)

--------------------------------------------------------------------------------
--[Gui]--
--------------------------------------------------------------------------------
Gui.on_text_changed(
    '^txt_stknt$',
    function(event)
        local _, pdata = Player.get(event.player_index)
        local note = pdata.note_sel

        if note then
            note.text = event.element.text
            encode_note(note)

            hide_note(note)
            show_note(note)
            if note.mapmark then
                display_mapmark(note, true)
            end
        end
    end
)

local function close_note(event)
    if event.element and (event.element.name == 'flow_stknt' or event.element.name == 'but_stknt_close') then
        local player, pdata = Player.get(event.player_index)
        local note = pdata.note_sel
        if note then
            if #player.gui.center.flow_stknt.frm_stknt.tab_stknt_main.txt_stknt.text == 0 then
                destroy_note(note)
            end
            note.editer = nil
        end
        menu_note(player, pdata, false)
        pdata.note_sel = nil
    end
end
Gui.on_click('but_stknt_close', close_note)
Event.register(defines.events.on_gui_closed, close_note)

Gui.on_click(
    'but_stknt_delete',
    function(event)
        local player, pdata = Player.get(event.player_index)
        local note = pdata.note_sel

        if note then
            destroy_note(note)
            menu_note(player, pdata, false)
            pdata.note_sel = nil
        end
    end
)

Gui.on_click(
    'but_stknt_col_(.*)',
    function(event)
        local _, pdata = Player.get(event.player_index)

        local note = pdata.note_sel
        local color = defines.color[event.match]

        if color and note then
            note.color = color
            encode_note(note)
            hide_note(note)
            show_note(note)
        end
    end
)

Gui.on_checked_state_changed(
    'chk_stknt_autoshow',
    function(event)
        local _, pdata = Player.get(event.player_index)
        local note = pdata.note_sel
        if note then
            note.autoshow = event.element.state
            encode_note(note)
            if note.autoshow then
                hide_note(note)
            else
                show_note(note)
            end
        end
    end
)

Gui.on_checked_state_changed(
    'chk_stknt_mapmark',
    function(event)
        local _, pdata = Player.get(event.player_index)
        local note = pdata.note_sel
        if note then
            if event.element.state then
                display_mapmark(note, true)
            else
                display_mapmark(note, false)
            end
        end
        encode_note(note)
    end
)

Gui.on_checked_state_changed(
    'chk_stknt_locked_force',
    function(event)
        local _, pdata = Player.get(event.player_index)
        local note = pdata.note_sel
        note.locked_force = event.element.state
        encode_note(note)
    end
)

Gui.on_checked_state_changed(
    'chk_stknt_locked_admin',
    function(event)
        local player, pdata = Player.get(event.player_index)
        if player.admin then
            local note = pdata.note_sel
            note.locked_admin = event.element.state
            encode_note(note)
            if note.is_sign then
                if note.locked_admin then
                    note.target.minable = false
                else
                    note.target.minable = true
                end
            end
        end
    end
)

Gui.on_click(
    open_color_picker_button_name,
    function(event)
        local player, pdata = Player.get(event.player_index)
        -- open color picker.
        local flow = player.gui.center.flow_stknt
        if flow then
            if flow[color_picker_name] then
                flow[color_picker_name].destroy()
            else
                remote.call(
                    color_picker_interface,
                    'add_instance',
                    {
                        parent = flow,
                        container_name = color_picker_name,
                        color = pdata.note_sel and pdata.note_sel.color,
                        show_ok_button = true
                    }
                )
            end
        end
    end
)

--------------------------------------------------------------------------------
--[Hotkeys]--
--------------------------------------------------------------------------------
local ignore_types = {
    ['car'] = true,
    ['tank'] = true,
    ['player'] = true,
    ['unit'] = true,
    ['unit-spawner'] = true,
    ['straight-rail'] = true,
    ['curved-rail'] = true,
    ['locomotive'] = true,
    ['cargo-wagon'] = true,
    ['fluid-wagon'] = true,
    ['logistic-robot'] = true,
    ['construction-robot'] = true,
    ['combat-robot'] = true
}

local function on_hotkey_write(event)
    local player, pdata = Player.get(event.player_index)
    local selected = player.selected
    local note

    if selected then
        note = get_note(selected)

        if note == nil and player.force == selected.force then
            -- add a new note
            local type = selected.type

            -- do not add a text on movable objects or rails.
            if not ignore_types[type] then
                note = add_note(selected)
            end
        end
    end

    local previous = pdata.note_sel

    if previous ~= note then
        -- hide the previous menu
        if previous then
            previous.editer = nil
            menu_note(player, pdata, false)
            pdata.note_sel = nil
        end

        -- show the new menu
        if note and (note.editer == nil or not note.editer.connected) and (note.invis_note.valid and note.invis_note.force == player.force or not note.locked_force) and (player.admin or not note.locked_admin) then
            pdata.note_sel = note
            note.editer = player
            menu_note(player, pdata, true)
        end
    end
end
Event.register('picker-notes', on_hotkey_write)

--------------------------------------------------------------------------------
--[Core Events]--
--------------------------------------------------------------------------------
local function register_conditionals()
    if remote.interfaces[color_picker_interface] then
        -- color picker events.
        Event.register(
            remote.call(color_picker_interface, 'on_color_updated'),
            function(event)
                if event.container.name == color_picker_name then
                    local _, pdata = Player.get(event.player_index)
                    local note = pdata.note_sel
                    local color = event.color

                    if color and note then
                        note.color = color
                        hide_note(note)
                        show_note(note)
                    end
                end
            end
        )

        Event.register(
            remote.call(color_picker_interface, 'on_ok_button_clicked'),
            function(event)
                if event.container.name == color_picker_name then
                    event.container.destroy()
                end
            end
        )
    end
end

local function on_load()
    register_conditionals()
end
Event.register(Event.core_events.load, on_load)

local function on_init()
    global.notes_by_invis = {}
    global.notes_by_target = {}
    global.n_note = 0
    register_conditionals()
end
Event.register(Event.core_events.init, on_init)

--------------------------------------------------------------------------------
--[Interface]--
--------------------------------------------------------------------------------
local note_interface = {}

function note_interface.delete_all()
    table.each(global.notes_by_invis, destroy_note)
    table.each(global.notes_by_target, destroy_note)
end

function note_interface.count(silent)
    local invis = table.count_keys(global.notes_by_invis)
    local target = table.count_keys(global.notes_by_target)
    if not silent then
        game.print('Notes by invis-notes: ' .. invis .. ' Notes by targets: ' .. target)
    end
    return invis, target
end

-- destroy any remaining notes without targets or invis-notes
-- also, make sure notes are aligned with their targets
function note_interface.clean()
    local destroy_count = 0
    local align_count = 0

    local function fix_note(note)
        if not note.invis_note.valid or not note.target.valid then
            destroy_note(note)
            destroy_count = destroy_count + 1
        elseif note.invis_note.position.x ~= note.target.position.x or note.invis_note.position.y ~= note.target.position.y then
            note.invis_note.teleport(note.target.position)
            hide_note(note)
            show_note(note)
            align_count = align_count + 1
        end
    end

    table.each(global.notes_by_invis, fix_note)
    table.each(global.notes_by_target, fix_note)

    game.print('Cleaned out ' .. destroy_count .. ' notes')
    game.print('Aligned ' .. align_count .. ' notes')
end

function note_interface.add_note(entity, parameters)
    add_note(entity)
    note_interface.modify_note(entity, parameters)
end

function note_interface.remove_note(entity)
    local note = get_note(entity)
    if note then
        destroy_note(note)
    end
end

local isset = function(val)
    return val and true or val == false
end

local writable_fields = {
    --[fieldname]=function(value,note), functions should perform check of the passed values and transformations as needed
    text = function(note, t)
        note.text = t and tostring(t)
    end, -- text
    color = function(note, color_name)
        note.color = defines.color[color_name] or note.color
    end, -- color
    autoshow = function(note, boolean)
        note.autoshow = boolean
    end, -- if true, then note autoshows/hides
    mapmark = function(note, boolean)
        display_mapmark(note, boolean)
    end, -- mark on the map
    locked_force = function(note, boolean)
        note.locked_force = boolean
    end, -- only modifiable by the same force
    locked_admin = function(note, boolean)
        if note.is_sign then
            if boolean then
                note.target.minable = false
            else
                note.target.minable = true
            end
        end
    end -- only modifiable by admins
}

function note_interface.modify_note(entity, par)
    local note = get_note(entity)
    if not note then
        return
    end
    for k, v in pairs(writable_fields) do
        if isset(par[k]) then
            v(note, par[k])
        end
    end

    encode_note(note)
    hide_note(note)
    show_note(note)
    if note.mapmark then
        display_mapmark(note, true)
    end
end

--(( Add to picker and StickyNotes interface ))--
local interface = require('interface')
for name, func in pairs(note_interface) do
    interface[name] = func
end

if not remote.interfaces['StickyNotes'] then
    remote.add_interface('StickyNotes', note_interface)
end --))
