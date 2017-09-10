-------------------------------------------------------------------------------
--[[Additional Paste Settings]]--[[Copy pipe direction]]
-------------------------------------------------------------------------------
--Modified from "Additional Paste Settings", by "Shirkit",
--https://mods.factorio.com/mods/SHiRKiT/additional-paste-settings
--Modified from "Copy Assembler Pipe Direction", by "IronCartographer",
--https://mods.factorio.com/mods/IronCartographer/CopyAssemblerPipeDirection

local Player = require("stdlib.event.player")

--Called before settings are pasted, Allows us to retrieve the existing stored request slots
local function on_pre_entity_settings_pasted(event)
    local _, pdata = Player.get(event.player_index)
    pdata.requests = {}
    if event.source.type == "assembling-machine" and event.destination.type == "logistic-container" and event.destination.request_slot_count > 0 then
        for i = 1, event.destination.request_slot_count do
            pdata.requests[i] = event.destination.get_request_slot(i)
        end
    elseif event.source.type == "logistic-container" and event.destination.type == "logistic-container" and event.destination.request_slot_count > 0 then
        for i = 1, event.destination.request_slot_count do
            event.destination.clear_request_slot(i)
        end
    elseif event.source.type == "inserter" and event.destination.type == "inserter" then
        local ctrl = event.destination.get_or_create_control_behavior()
        ctrl.logistic_condition = nil
        ctrl.circuit_condition = nil
        ctrl.connect_to_logistic_network = false
        ctrl.circuit_mode_of_operation = defines.control_behavior.inserter.circuit_mode_of_operation.none
    end
end

local function paste_assembling_to_container(pdata, event)
    if #pdata.requests > 0 then
        local multiplier = settings.get_player_settings(pdata.index)["picker-player-paste-modifier"].value
        for i = 1, #pdata.requests do
            local found = false
            local source_stack = pdata.requests[i]
            if source_stack then
                for k = 1, event.destination.request_slot_count do
                    local stack = event.destination.get_request_slot(k)
                    if stack and source_stack.name == stack.name then
                        event.destination.set_request_slot({name = stack.name, count = multiplier * (stack.count + source_stack.count)}, k)
                        found = true
                        break
                    end
                end
                if not found then
                    for k = 1, event.destination.request_slot_count do
                        if not event.destination.get_request_slot(k) then
                            event.destination.set_request_slot(source_stack, k)
                            break
                        end
                    end
                end
            end
        end
        pdata.requests = {}
    end
end

local function paste_assembling_to_inserter(pdata, event)
    local multiplier = settings.get_player_settings(pdata.index)["picker-player-paste-modifier"].value
    local ctrl = event.destination.get_or_create_control_behavior()

    local c1 = ctrl.get_circuit_network(defines.wire_type.red)
    local c2 = ctrl.get_circuit_network(defines.wire_type.green)

    if not event.source.recipe then
        if not c1 and not c2 then
            ctrl.logistic_condition = nil
            ctrl.connect_to_logistic_network = false
        else
            ctrl.circuit_condition = nil
            ctrl.circuit_mode_of_operation = defines.control_behavior.inserter.circuit_mode_of_operation.none
        end
    else
        local product = event.source.recipe.products[1].name
        local item = game.item_prototypes[product]

        if item then
            if not c1 and not c2 then
                ctrl.connect_to_logistic_network = true
                ctrl.logistic_condition = {condition={comparator="<", first_signal={type="item", name=product}, constant = multiplier * item.stack_size}}
            else
                ctrl.circuit_mode_of_operation = defines.control_behavior.inserter.circuit_mode_of_operation.enable_disable
                ctrl.circuit_condition = {condition={comparator="<", first_signal={type="item", name=product}, constant = multiplier * item.stack_size}}
            end
        end
    end
end

--Called after the settings are pasted, Allows us to set the correct combined values
local function on_entity_settings_pasted(event)
    local _, pdata = Player.get(event.player_index)

    if event.source.type == "assembling-machine" and event.destination.type == "logistic-container" and event.destination.request_slot_count > 0 then
        paste_assembling_to_container(pdata, event)
    end
    if event.source.type == "assembling-machine" and event.destination.type == "inserter" then
        paste_assembling_to_inserter(pdata, event)
    end
    --Copy assembler pipe direction if entity is square and has fluidboxes
    if event.source and event.source.supports_direction and (event.source.fluidbox and #event.source.fluidbox > 0)
    and(event.source.prototype.collision_box and event.source.prototype.collision_box.x == event.source.prototype.collision_box.y)
    and event.destination.supports_direction and (event.destination.fluidbox and #event.destination.fluidbox > 0)
    and (event.destination.prototype.collision_box and event.destination.prototype.collision_box.x == event.destination.prototype.collision_box.y)
    and event.source.prototype.fast_replaceable_group == "assembling-machine"
    and event.destination.prototype.fast_replaceable_group == "assembling-machine" then
        event.destination.direction = event.source.direction
    end
end

Event.register(defines.events.on_entity_settings_pasted, on_entity_settings_pasted)
Event.register(defines.events.on_pre_entity_settings_pasted, on_pre_entity_settings_pasted)
