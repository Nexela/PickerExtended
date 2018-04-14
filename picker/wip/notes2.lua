--luacheck: ignore
local Note = {}

local Event = require("stdlib/event/event")
local Player = require("stdlib/event/player")

local text_color_default = {r = 1, g = 1, b = 0}

local function create_or_revive_note(event)
    local ent = event.created_entity

    if ent and ent.valid then
        -- Revive note ghosts immediately
        if ent.name == "entity-ghost" and ent.ghost_name == "invis-note" then
            local revived, rev_ent = ent.revive()
            if revived then
                ent = rev_ent
            end
        end

        if ent.name == "invis-note" then
            ent.destructible = false
            ent.operable = false
            --ent.parameters = {}
            --ent.alert_parameters = {}

            -- Only place an invis-note on a ghost, if that ghost doesn't already have a note
            -- With instant blueprint, the entity revive order is different between different entities.
            -- It is known that oil-refinery > invis-note > chest.
            -- In case the target has not been revived yet, e.g. no instant blueprint, or chest with instant blueprint.

            local note_target =
                ent.surface.find_entities_filtered {
                name = "entity-ghost",
                position = ent.position,
                force = ent.force,
                limit = 1
            }[1]

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
                    if target.prototype.has_flag("player-creation") then
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
        elseif ent.name ~= "entity-ghost" then -- when a normal item is placed figure out what ghosts are destroyed
            if (ent.name == "sticky-note" or ent.name == "sticky-sign") then
                ent.destructible = false
                ent.operable = false
            end

            local x = ent.position.x
            local y = ent.position.y
            local invis_notes = ent.surface.find_entities_filtered {name = "invis-note", area = {{x - 10, y - 10}, {x + 10, y + 10}}}
            for _, invis_note in pairs(invis_notes) do
                local note = get_note(invis_note)
                if not note.target.valid then -- if we deleted a ghost with this placement
                    if math.abs(invis_note.position.x - x) < 0.01 and math.abs(invis_note.position.y - y) < 0.01 then -- if we replaced a correct ghost, reassign
                        update_note_target(note, ent)
                    else -- we destroyed an unrelated ghost
                        destroy_note(note)
                    end
                end
            end
        end
    end
end
Event.register({defines.events.on_built_entity, defines.events.on_robot_built_entity}, on_creation)

function Note.new(entity, data)
    local note = {
        data = data or {
            text = "text " .. table.size(global.notes), -- text
            color = text_color_default, -- color
            show_alert = settings.global["picker-notes-default-autoshow"].value or true,
            show_on_map = settings.global["picker-notes-default-mapmark"].value or false, -- mark on the map
            locked_admin = false, -- only modifiable by admins
            locked_force = true -- only modifiable by the same force
        },
        index = entity.unit_number,
        editer = nil, -- player currently editing
        proxy = nil, -- invis note entity
        sticky = nil, -- text entity
        entity = entity,
        icon_signal_id = {type = "item", name = "invis-note"}
    }
    setmetatable(note, Note.note_mt)

    -- Create proxy

    -- Create sticky

    global.notes[note.index] = note
    return note
end

function Note.get(entity)
    return global.notes[entity.unit_number]
end

function Note:remove_type(type)
    if self[type] and self[type].valid then
        self[type].destory()
    end
    self[type] = nil
    return self
end

function Note:remove_proxy()
    return self:remove_type("proxy")
end

function Note:remove_sticky()
    return self:remove_type("sticky")
end

function Note:remove_mapmark()
    return self:remove_type("mapmark")
end

function Note:delete()
    self:remove_proxy():remove_sticky():remove_mapmark()
    global.notes[self.index] = nil
end

function Note:encode()
    if self.data and self.proxy and self.proxy.valid then
        self.proxy.alert_parameters = {
            show_alert = self.data.show_alert,
            show_on_map = self.data.show_on_maptrue,
            icon_signal_id = self.icon_signal_id,
            alert_message = serpent.dump(self.data)
        }
    end
    return self
end

function Note:decode()
    if self.proxy and self.proxy.valid then
        self.data = load(self.proxy.alert_parameters)
    end
    return self
end

function Note:display_mapmark()
    if self.proxy and self.proxy.valid then
        --if self.data.show_on_map self.mapmark
    end
    return self
end

function Note:show()
    return self
end

function Note:update_position(pos)
    if self.proxy and self.proxy.valid then
        self.proxy.teleport(pos)
    end
    if self.sticky and self.sticky.valid then
        self.sticky.teleport(pos)
    end
    if self.mapmark and self.mapmark.valid then
        self.mapmark.teleport(pos)
    end
end

local function entity_moved(event)
    local entity = event.moved_entity and event.moved_entity.valid and event.moved_entity
    if entity then
        local note = Note(entity)
        if note then
            note:update_position(entity.position)
        end
    end
end
Event.register(Event.dolly_moved, entity_moved)

Note.mt = {
    __call = function(_, ...)
        Note.Get(...)
    end
}

Note.note_mt = {
    __index = Note
}

local function setup_metatables()
    for _, note in pairs(global.notes or {}) do
        setmetatable(note, Note.note_mt)
    end
end
Event.register(Event.core_events.load, setup_metatables)

local function on_init()
    global.notes = {}
end
Event.register(Event.core_events.init, on_init)

setmetatable(Note, Note.mt)
