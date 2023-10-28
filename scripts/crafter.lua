-------------------------------------------------------------------------------
--[Picker Crafter]-- Craft selected entity on hotkey press
-------------------------------------------------------------------------------
local Event = require('__stdlib__/stdlib/event/event')
local lib = require('__PickerAtheneum__/utils/lib')

local function santas_little_helper(player, name)
    local allow_multiple = player.mod_settings['picker-allow-multiple-craft'].value
    local to_front = player.mod_settings['picker-queue-to-front'].value
    if game.recipe_prototypes[name] and player.force.recipes[name].enabled and (allow_multiple or player.get_item_count(name) == 0) then
        if to_front then global.queue_to_front = true end
        player.begin_crafting { count = 1, recipe = name, silent = false }
    end
end

local function picker_crafter(event)
    local player = game.players[event.player_index]
    local selected, stack = player.selected, player.cursor_stack
    if selected and stack then
        if not stack.valid_for_read then
            local _, _, ip = lib.get_placeable_item(selected)
            if ip then
                santas_little_helper(player, ip.name)
            end
        end
    elseif player.cursor_ghost then
        santas_little_helper(player, player.cursor_ghost.name)
    end
end
Event.register('picker-crafter', picker_crafter)

local function picker_push_craft_to_front(event)
    if global.queue_busy or not global.queue_to_front then return nil end

    global.queue_busy = true

    local player = game.players[event.player_index]
    local old_inventory_bonus = player.character_inventory_slots_bonus
    player.character_inventory_slots_bonus = old_inventory_bonus + 1000

    local saved_queue = {}
    while player.crafting_queue do
        local queue_item = player.crafting_queue[#player.crafting_queue]
        if #player.crafting_queue == 1 and queue_item.recipe == event.recipe.name then
            break
        else
            table.insert(saved_queue, queue_item)
            player.cancel_crafting{index=queue_item.index, count=queue_item.count}
        end
    end

    -- cover case when last item in queue is same recipe we are adding in front
    if saved_queue[1].recipe == event.recipe.name and saved_queue[1].count - event.queued_count > 0 then
        saved_queue[1].count = saved_queue[1].count - event.queued_count
    elseif saved_queue[1].recipe == event.recipe.name then
        table.remove(saved_queue, 1)
    end
    
    player.begin_crafting{count=event.queued_count, recipe=event.recipe, silent=true}
    while #saved_queue > 0 do
        queue_entry = table.remove(saved_queue, #saved_queue)
        player.begin_crafting{count=queue_entry.count, recipe=queue_entry.recipe, silent=true}
    end

    player.character_inventory_slots_bonus = old_inventory_bonus
    global.queue_to_front = false
    global.queue_busy = false
end
Event.register(defines.events.on_pre_player_crafted_item, picker_push_craft_to_front)
