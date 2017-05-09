-------------------------------------------------------------------------------
--[[Helper Functions]]--
-------------------------------------------------------------------------------
local lib = {}
--local mod_gui = require("mod-gui")
local Position = require("stdlib.area.position")
local INVENTORIES = {defines.inventory.player_quickbar, defines.inventory.player_main, defines.inventory.god_quickbar, defines.inventory.god_main}

function lib.get_or_create_main_left_flow(player, flow_name)
    local main_flow = player.gui.left[flow_name.."_main_flow"]
    if not main_flow then
        main_flow = player.gui.left.add{type = "flow", name = flow_name.."_main_flow", direction = "vertical", style = "slot_table_spacing_flow_style"}
    end
    return main_flow
end

-- Gets the name of the item at the given position, or nil if there
-- is no item at that position
function lib.get_item_at_position(inventory, n)
    return inventory[n].valid_for_read and inventory[n].name
end

-- Returns either the item at a position, or the filter
-- at the position if there isn't an item there
function lib.get_item_or_filter_at_position(inventory, n)
    local filter = inventory.get_filter(n)
    return filter or lib.get_item_at_position(inventory, n)
end

function lib.is_beltbrush_bp(stack)
    return stack.valid_for_read and stack.name == "blueprint" and stack.label and stack.label:find("Belt Brush")
end

function lib.stack_name(slot, name, is_bp_setup)
    if slot and slot.valid_for_read then
        local stack
        if slot.name == name then
            stack = slot
        elseif slot.name == name.."-book" then
            local inv = slot.get_inventory(defines.inventory.item_main)
            stack = inv and slot.active_index and inv[slot.active_index]
        end
        if stack and is_bp_setup then
            return stack and stack.name == "blueprint" and stack.is_blueprint_setup() and stack
        else
            return stack
        end
    end
end

--Return localised name, entity_prototype, and item_prototype
function lib.get_placeable_item(entity)
    local locname, ep
    if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
        locname = entity.ghost_localised_name
        ep = entity.ghost_prototype
    else
        locname = entity.localised_name
        ep = entity.prototype
    end
    if ep and ep.mineable_properties and ep.mineable_properties.minable and ep.mineable_properties.products
    and ep.mineable_properties.products[1].type == "item" then -- If the entity has mineable products.
        local ip = game.item_prototypes[ep.mineable_properties.products[1].name] -- Retrieve first available item prototype
        if ip and (ip.place_result or ip.place_as_tile_result) then -- If the entity has an item with a placeable prototype,
            return (ip.localised_name or locname), ep, ip
        end
        return locname, ep
    end
end

function lib.stack_is_ghost(stack, ghost)
    if ghost.name == "entity-ghost" then
        return stack.prototype.place_result and stack.prototype.place_result.name == ghost.ghost_name
    elseif ghost.name == "tile-ghost" then
        return stack.prototype.place_as_tile_result and stack.prototype.place_as_tile_result.result.name == ghost.ghost_name
    end
end

function lib.find_resources(entity)
    if entity.type == "mining-drill" then
        local area = Position.expand_to_area(entity.position, game.entity_prototypes[entity.name].mining_drill_radius)
        local name = entity.mining_target and entity.mining_target.name or nil
        return entity.surface.count_entities_filtered{area=area, type="resource", name=name}
    end
    return 0
end

function lib.damaged(entity)
    return entity.health and entity.prototype.max_health and entity.health < entity.prototype.max_health
end

function lib.get_item_stack(e, name)
    for _, ind in pairs(INVENTORIES) do
        local stack = e.get_inventory(ind) and e.get_inventory(ind).find_item_stack(name)
        if stack then
            return stack
        end
    end
    if e.vehicle and e.vehicle.get_inventory(defines.inventory.car_trunk) then
        local stack = e.vehicle.get_inventory(defines.inventory.car_trunk).find_item_stack(name)
        if stack then
            return stack
        end
    end
end

function lib.satisfy_requests(entity, player, proxy)
    if entity == proxy then
        entity = entity.surface.find_entities_filtered{position = proxy.position , force = player.force, limit = 1}[1]
    end
    local pinv = player.get_inventory(defines.inventory.player_main) or player.get_inventory(defines.inventory.god_main)
    local new_requests = {}
    for name, count in pairs(proxy.item_requests) do
        local removed = player.cheat_mode and count or (entity and entity.can_insert(name) and pinv.remove({name = name, count = count})) or 0
        if removed > 0 then
            entity.insert({name = name, count = removed})
        end
        local balance = count - removed
        new_requests[name] = balance > 0 and balance or nil
    end
    return new_requests
end

function lib.get_planner(player, planner, label)
    local found
    for _, idx in pairs(INVENTORIES) do
        local inventory = player.get_inventory(idx)
        if inventory then
            for i = 1, #inventory do
                local slot = inventory[i]
                if slot.valid_for_read then
                    if slot.name == planner then
                        if planner == "blueprint" then
                            if not slot.is_blueprint_setup() then
                                found = slot
                            elseif (label and slot.is_blueprint_setup() and slot.label and slot.label:find(label)) then
                                if player.cursor_stack.set_stack(slot) then
                                    slot.clear()
                                    return player.cursor_stack
                                end
                            end
                        elseif planner == "deconstruction-planner" then
                            if player.cursor_stack.set_stack(slot) then
                                slot.clear()
                                return player.cursor_stack
                            end
                        end
                    elseif planner == "repair-tool" and slot.type == "repair-tool" then
                        if player.cursor_stack.set_stack(slot) then
                            slot.clear()
                            return player.cursor_stack
                        end
                    end
                end
            end
        end
    end
    if found and player.cursor_stack.set_stack(found) then
        found.clear()
        return player.cursor_stack
    else
        return game.item_prototypes[planner] and player.cursor_stack.set_stack(planner) and player.cursor_stack
    end
end

return lib
