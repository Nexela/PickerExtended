--------------------------------------------------------------------------------
--[[autodeconstruct]] --
--------------------------------------------------------------------------------
--"title": "Auto Deconstruct",
--"author": "mindmix",
--"description": "This mod marks drills that have no more resources to mine for deconstruction."

local Event = require('stdlib/event/event')
local Area = require('stdlib/area/area')
local Position = require('stdlib/area/position')
local lib = require('scripts/lib')

local function find_targeters(entity)
    local targeters = {}
    local filter = {force = entity.force, area = Area(entity.selection_box):expand(10)}
    for _, ent in pairs(entity.surface.find_entities_filtered(filter)) do
        if ent.drop_target == entity and not ent.to_be_deconstructed then
            targeters[#targeters + 1] = ent
        end
    end
    return targeters
end

local _find = function(v)
    return (v.amount > 0 or v.prototype.infinite_resource)
end

local function has_resources(drill)
    local filter = {area = Position(drill.position):expand_to_area(drill.prototype.mining_drill_radius), type = 'resource'}
    return table.find(drill.surface.find_entities_filtered(filter), _find)
end

local targets = table.array_to_dictionary({'container', 'logistic-container'})

local function check_for_deconstruction(drill)
    if not drill.to_be_deconstructed(drill.force) and lib.can_decon(drill) and not has_resources(drill) and not lib.has_fluidbox(drill) and not lib.is_circuit_connected(drill) then
        if drill.order_deconstruction(drill.force) then
            if settings.global['picker-autodeconstruct-target'].value then
                local target = drill.drop_target
                if target and targets[target.type] and not lib.is_circuit_connected(target) and lib.can_decon(target) and target.force == drill.force then
                    local targeters = find_targeters(target)
                    if #targeters <= 0 then
                        target.order_deconstruction(drill.force)
                    end
                end
            end
        end
    end
end

local function autodeconstruct(event)
    if settings.global['picker-autodeconstruct'].value then
        local resource = event.entity
        local filter = {type = 'mining-drill', area = Area(resource.selection_box):expand(10)}
        for _, drill in pairs(resource.surface.find_entities_filtered(filter)) do
            check_for_deconstruction(drill)
        end
    end
end
Event.register(defines.events.on_resource_depleted, autodeconstruct)

local function init()
    for _, surface in pairs(game.surfaces) do
        for _, drill in pairs(surface.find_entities_filtered {type = 'mining-drill'}) do
            check_for_deconstruction(drill)
        end
    end
end
Event.register(Event.core_events.init, init)
