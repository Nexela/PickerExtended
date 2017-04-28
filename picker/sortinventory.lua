-------------------------------------------------------------------------------
--[[Sort Inventory]]--
-------------------------------------------------------------------------------
--Original code from the manual inventory sort mod.

local Player = require("stdlib/player")

-------------------------------------------------------------------------------
--[[Helpers]]--
-------------------------------------------------------------------------------
local function get_n(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

local function get_next_unfiltered_slot(inventory, slot)
    if slot > #inventory or slot < 1 then return nil end
    if inventory.get_filter(slot) ~= nil then return get_next_unfiltered_slot(inventory, slot + 1) end
    return slot
end

local function add_unique(tab, value)
    for _, v in pairs(tab) do if v == value then return end end
    table.insert(tab, value)
end

local function get_stacks_with_order(order, stacks)
    local res = {}
    for _, v in pairs(stacks) do if v.stack.valid and v.order == order then table.insert(res, v) end end
    return res
end

local function get_total_ammo(stack) return stack.ammo + (stack.count - 1) * game.item_prototypes[stack.name].magazine_size end
local function get_total_ammo_capacity(name) return game.item_prototypes[name].magazine_size * game.item_prototypes[name].stack_size end

local function get_total_durability(stack) return stack.durability + (stack.count - 1) * game.item_prototypes[stack.name].durability end
local function get_total_durability_prototype(name) return game.item_prototypes[name].durability * game.item_prototypes[name].stack_size end

local function compress_ammo(stack1, stack2)
    local stack1_missing_ammo = get_total_ammo_capacity(stack1.name) - get_total_ammo(stack1)
    local stack2_ammo = get_total_ammo(stack2)

    local stack2_valid = false

    if stack2_ammo == stack1_missing_ammo then
        stack1.add_ammo(stack1_missing_ammo)
        stack2.clear()
    elseif stack2_ammo < stack1_missing_ammo then
        stack1.add_ammo(stack2_ammo)
        stack2.clear()
    elseif stack2_ammo > stack1_missing_ammo then
        stack1.add_ammo(stack1_missing_ammo)
        stack2.drain_ammo(stack1_missing_ammo)

        stack2_valid = true
    end

    return stack2_valid
end

local function compress_usable_stacks(stack1, stack2)
    local stack1_missing_durability = get_total_durability_prototype(stack1.name) - get_total_durability(stack1)
    local stack2_durability = get_total_durability(stack2)
    --local full_durability = game.item_prototypes[stack1.name].durability
    --local t_stack1_missing_durability = full_durability - stack1.durability

    local stack2_valid = false

    if stack2_durability == stack1_missing_durability then
        stack1.add_durability(stack1_missing_durability)
        stack2.clear()
    elseif stack2_durability < stack1_missing_durability then
        stack1.add_durability(stack2_durability)
        stack2.clear()
    elseif stack2_durability > stack1_missing_durability then
        stack1.add_durability(stack1_missing_durability)
        stack2.drain_durability(stack1_missing_durability)
        stack2_valid = true
    end

    return stack2_valid
end

local function iterate_i_slots(i_slots, inventory)
    if i_slots.filters and i_slots.filters[i_slots.current_name] then
        i_slots.current = i_slots.filters[i_slots.current_name][1] -- get the first filtered slot
        table.remove(i_slots.filters[i_slots.current_name], 1) -- remove it from the table

        if get_n(i_slots.filters[i_slots.current_name]) == 0 then -- get the next slot, if there are no other filtered ones (i_slot)
            i_slots.filters[i_slots.current_name] = nil
            i_slots.next = i_slots.i + 1
        else -- get the next slot if there are other filtered ones (the first one)
            i_slots.next = i_slots.filters[i_slots.current_name][1]
        end

        return
    end

    i_slots.i = i_slots.i + 1
    if i_slots.filters then i_slots.i = get_next_unfiltered_slot(inventory, i_slots.i) end

    i_slots.current = i_slots.i
    if i_slots.i then i_slots.next = i_slots.i + 1 else i_slots.next = nil end
    if i_slots.filters and i_slots.next then i_slots.next = get_next_unfiltered_slot(inventory, i_slots.next) end
end
-------------------------------------------------------------------------------
--[[Sorting]]--
-------------------------------------------------------------------------------
-- possible arguments:
-- player_index (mandatory)
-- override_possible (optional), default: false - can the sortlimit be overriden in this process? (true for player manual sort and false for everything else)
-- force_override (optional), default: false - override the sorting limit regardless of other settings. (false for player and true for other entities)
-- inventory (optional), default: nil, but uses the inventory of the player with passed player_index. - determines what to sort, obviously...
-- filtered (optional), default: false - if true, filtered slots are taken into account
--
-- the arguments have to be passed as a table, unless you only pass player_index
local function sort_opened_inventory(data)
    --luacheck: not globals global util

    local player, pdata = Player.get(data.player_index)
    pdata.sort = pdata.sort or {}

    local inventory = data.inventory
    local sort_limit = #inventory
    local filtered = inventory.is_filtered()
    local stacks = {}
    local orders = {}
    local filters

    local proxy = player.surface.create_entity{name = "picker-proxy-chest", position = player.position}
    proxy.operable = false
    proxy.destructible = false
    local proxy_inv = proxy.get_inventory(defines.inventory.chest)

    if filtered then -- figure out which slots have what filters
        filters = {}
        for i = 1, sort_limit do
            local filter = inventory.get_filter(i)
            if filter then
                if filters[filter] then table.insert(filters[filter], i)
                else filters[filter] = {i} end
            end
        end
    end

    ------------ SORTING ------------

    for i = 1, sort_limit do -- put the content into a table
        local stack = inventory[i]
        if stack and stack.valid_for_read then
            local prototype = game.item_prototypes[stack.name]

            -- figure out the full order string of this stack - Why is there no API function for this???
            local order = ""
            if (prototype.group) then order = order .. prototype.group.order .. prototype.group.name end
            if (prototype.subgroup) then order = order .. prototype.subgroup.order .. prototype.subgroup.name end
            if (prototype.order) then order = order .. prototype.order end
            order = order .. prototype.name
            table.insert(stacks, {stack = stack, prototype = prototype, order = order})
            add_unique(orders, order)
        end
    end

    table.sort(orders) -- sort the strings alphabetically

    -- if global.player_settings[player_index].custom_sort_enabled then sort_orders(orders, global.player_settings[player_index].sorting_prefs) end -- WIP custom sorting (waiting for GUI)

    -- arrange the stacks in correct order into the t_chest inventory
    local i_slots = {i = 0, current = 1, next = 2, filters = filters}
    for i = 1, #orders do -- go one order at a time, this also ensures that there's going to be only one item type in each iteration of this loop
        local t_stacks = get_stacks_with_order(orders[i], stacks)
        local damaged_stacks = {} -- because stacks with damage go at the end
        local first = true -- first can't merge with previous stacks, since they're a different type
        i_slots.current_name = t_stacks[1].stack.name
        iterate_i_slots(i_slots, inventory)

        for i_stack = 1, #t_stacks do
            local c_stack = t_stacks[i_stack]

            if not first and proxy_inv[i_slots.current].valid_for_read and proxy_inv[i_slots.current].name == c_stack.stack.name then -- there's a stack available for merge
                local free_space = c_stack.prototype.stack_size - proxy_inv[i_slots.current].count

                local extra_properties = {}
                if c_stack.stack.type == "ammo" then extra_properties.ammo = c_stack.stack.ammo end
                if c_stack.stack.health and c_stack.stack.health ~= 1 then extra_properties.health = c_stack.stack.health end
                if c_stack.stack.durability then extra_properties.durability = c_stack.stack.durability end

                if extra_properties.ammo then -- ammo
                    proxy_inv[i_slots.next].set_stack(c_stack.stack) -- put the stack into the next slot
                    if compress_ammo(proxy_inv[i_slots.current], proxy_inv[i_slots.next]) then
                        iterate_i_slots(i_slots, inventory)
                    end -- merge stacks and only iterate i_slots.i if the next slot still as something in it

                elseif extra_properties.health then -- item is damaged - put at the end and do not stack!
                    table.insert(damaged_stacks, c_stack)

                elseif extra_properties.durability then -- durability (same as ammo)
                    proxy_inv[i_slots.next].set_stack(c_stack.stack)
                    if compress_usable_stacks(proxy_inv[i_slots.current], proxy_inv[i_slots.next]) then iterate_i_slots(i_slots, inventory) end

                else -- everything else
                    if c_stack.stack.count <= free_space then -- fits into the last stack
                        proxy_inv[i_slots.current].count = proxy_inv[i_slots.current].count + c_stack.stack.count

                    elseif c_stack.stack.count > free_space then -- doesn't fit into the last stack - merge and put overflow into the next one
                        proxy_inv[i_slots.current].count = c_stack.prototype.stack_size
                        iterate_i_slots(i_slots, inventory)
                        c_stack.stack.count = c_stack.stack.count - free_space
                        proxy_inv[i_slots.current].set_stack(c_stack.stack)
                    end
                end
            else -- there are no stacks to merge with
                if c_stack.stack.health and c_stack.stack.health ~= 1 then -- damaged - goes to the end
                    table.insert(damaged_stacks, c_stack)

                else -- set it to the next stack
                    proxy_inv[i_slots.current].set_stack(c_stack.stack)
                    first = false
                end
            end
        end

        for i_damaged = 1, #damaged_stacks do -- insert the dmaged stacks (for now these are inserted in the order they were originally - vanilla sorts them by ammount of health left)
            if not first then iterate_i_slots(i_slots, inventory) else first = false end -- prevent overwriting last non-damaged slot if there is one
            proxy_inv[i_slots.current].set_stack(damaged_stacks[i_damaged].stack)
        end
    end

    ------------ END OF SORTING ------------
    -- copy the sorted content back to the original inventory
    for i = 1, sort_limit do
        inventory[i].set_stack(proxy_inv[i])
    end

    proxy.destroy()
end

-------------------------------------------------------------------------------
--[[Event]]--
-------------------------------------------------------------------------------
local sortable_entities = {
    ["container"] = true,
    ["logistic-container"] = true,
    ["car"] = true,
    ["cargo-wagon"] = true,
}
local function sort_inventory(event)
    local player = Player.get(event.player_index)
    if player.opened and sortable_entities[player.opened.type] then
        sort_opened_inventory{
            player_index = event.player_index,
            inventory =
            player.opened.get_inventory(defines.inventory.car_trunk)
            or player.opened.get_inventory(defines.inventory.cargo_wagon)
            or player.opened.get_inventory(defines.inventory.chest),
            --filtered = player.opened.type == "cargo-wagon"
        }
    end
end
script.on_event("picker-manual-inventory-sort", sort_inventory)
-- local function auto_sort_inventory(event)
--     if settings.get_player_settings(event.player_index)["picker-auto-sort-inventory"].value then
--         sort_inventory(event)
--     end
-- end
--Event.register(defines.events.on_selected_entity_changed, auto_sort_inventory)

return sort_inventory
