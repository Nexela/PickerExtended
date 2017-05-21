-------------------------------------------------------------------------------
--[[Pipe Orphans]]--
-------------------------------------------------------------------------------
-- Code modified from GotLag's Orphan Finder: https://mods.factorio.com/mods/GotLag/Orphan%20Finder

local Player = require("stdlib/player")
local Position = require("stdlib/area/position")

local types = {
    ["underground-belt"] = "underground-belt",
    ["pipe-to-ground"] = "pipe-to-ground",
    ["transport-belt"] = "underground-belt",
    ["pipe"] = "pipe-to-ground",
}

local ugs = {
    ["underground-belt"] = "underground-belt",
    ["pipe-to-ground"] = "pipe-to-ground",
}

local function _find_mark(entity)
    return entity.surface.find_entities_filtered{name = "picker-orphan-mark", area = Position.expand_to_area(entity.position, .5), limit = 1}[1]
end

local function find_orphans(event)
    local player, pdata = Player.get(event.player_index)
    local cursor_type = player.cursor_stack and player.cursor_stack.valid_for_read and player.cursor_stack.prototype.place_result and types[player.cursor_stack.prototype.place_result.type]
    if (player.selected and types[player.selected.type]) or cursor_type then
        if event.tick > (pdata._next_check or 0) and player.mod_settings["picker-find-orphans"].value then
            local type = player.selected and types[player.selected.type] or cursor_type
            local ent = player.selected or player
            local filter = {area=Position.expand_to_area(ent.position, 64), type = type, force = player.force}
            for _, entity in pairs (ent.surface.find_entities_filtered(filter)) do
                if #entity.neighbours < 1 and not _find_mark(entity) then
                    entity.surface.create_entity{name = "picker-orphan-mark", position = entity.position}
                end
            end
            pdata._next_check = event.tick + (defines.time.second * 5)
        end
    end
end
Event.register({defines.events.on_selected_entity_changed, defines.events.on_player_cursor_stack_changed}, find_orphans)

local function orphan_builder(event)
    local _, pdata = Player.get(event.player_index)
    if ugs[event.created_entity.type] then
        table.each(event.created_entity.neighbours,
            function(nb)
                if #event.created_entity.neighbours > 0 then
                    local mark = _find_mark(nb)
                    if mark then
                        mark.destroy()
                    end
                end
            end
        )
        pdata._next_check = event.tick + (defines.time.second * 2)
    end
end
Event.register(defines.events.on_built_entity, orphan_builder)
