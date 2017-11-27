local Note = {}
local Player = require("stdlib.event.player")

function Note.new(entity)
    local text_color_default = {r = 1, g = 1, b = 0}

    local note = {
        text = "text " .. global.n_note + 1, -- text
        color = text_color_default, -- color
        count = nil, -- number of the note
        autoshow = settings.global["picker-notes-default-autoshow"].value,
        locked_force = true, -- only modifiable by the same force
        locked_admin = false, -- only modifiable by admins
        editer = nil, -- player currently editing
        mapmark = nil, -- mark on the map
        proxy = nil, -- invis note entity
        sticky = nil, -- text entity
        entity = entity,
        index = entity.unit_number -- needed in case target becomes invalid
    }
    setmetatable(note, Note.note_mt)

    global.notes = global.notes or {}
    global.notes[note.index] = note
    return global.notes[note.index]
end

function Note.get(entity)
    global.notes = global.notes or {}
    local note = global.notes[entity.unit_number]
    if note then
        return note
    else
        return Note.new(entity)
    end
end

function Note:remove_type(type)
    if self[type] and self[type].valid and self[type].destory() then
        self[type] = nil
    end
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

function Note.encode(note)
    return note
end

function Note.decode(note)
    return note
end

function Note.display_mapmark(note)
    return note
end

function Note.show(note)
    return note
end

Note.mt = {
    __index = Note,
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
