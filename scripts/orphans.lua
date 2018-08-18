-------------------------------------------------------------------------------
--[[Pipe Orphans]] --
-------------------------------------------------------------------------------
-- Code modified from GotLag's Orphan Finder: https://mods.factorio.com/mods/GotLag/Orphan%20Finder

local Event = require('__stdlib__/event/event')
local Player = require('__stdlib__/event/player')
local Position = require('__stdlib__/area/position')

local types = {
    ['underground-belt'] = 'underground-belt',
    ['pipe-to-ground'] = 'pipe-to-ground',
    ['transport-belt'] = 'underground-belt',
    ['pipe'] = 'pipe-to-ground'
}

local ugs = {
    ['underground-belt'] = 'underground-belt',
    ['pipe-to-ground'] = 'pipe-to-ground'
}

local function _find_mark(entity)
    return entity.surface.find_entities_filtered {
        name = 'picker-orphan-mark',
        area = entity.bounding_box,
        limit = 1
    }[1]
end

local function _destroy_mark(entity)
    local mark = _find_mark(entity)
    if mark then
        mark.destroy()
    end
end

local function find_orphans(event)
    local player, pdata = Player.get(event.player_index)
    local cursor_type = player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.prototype.place_result and types[player.cursor_stack.prototype.place_result.type]
    if (player.selected and types[player.selected.type]) or cursor_type then
        if event.tick > (pdata._next_check or 0) and player.mod_settings['picker-find-orphans'].value then
            local etype = player.selected and types[player.selected.type] or cursor_type
            local ent = player.selected or player
            local filter = {area = Position.expand_to_area(ent.position, 64), type = etype, force = player.force}
            for _, entity in pairs(ent.surface.find_entities_filtered(filter)) do
                local not_con = not entity.neighbours or (entity.neighbours and not entity.neighbours.type and #entity.neighbours[1] < 1)

                if not_con and not _find_mark(entity) then
                    entity.surface.create_entity {name = 'picker-orphan-mark', position = entity.position}
                end
            end
            pdata._next_check = event.tick + (defines.time.second * 5)
        end
    end
end
Event.register({defines.events.on_selected_entity_changed, defines.events.on_player_cursor_stack_changed}, find_orphans)

local function orphan_builder(event)
    if ugs[event.created_entity.type] and event.created_entity.neighbours then
        local _, pdata = Player.get(event.player_index)
        local ents = event.created_entity.neighbours

        if not ents.type then
            for _, inner in pairs(ents) do
                for _, ent in pairs(inner) do
                    _destroy_mark(ent)
                end
            end
        else
            _destroy_mark(ents)
        end
        pdata._next_check = event.tick + (defines.time.second * 2)
    end
end
Event.register(defines.events.on_built_entity, orphan_builder)
