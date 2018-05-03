-------------------------------------------------------------------------------
--[Chest Limiter]--
-------------------------------------------------------------------------------
local Event = require('stdlib/event/event')
local Gui = require('stdlib/event/gui')
local Player = require('stdlib/event/player')
local Pad = require('scripts/adjustment-pad')

local match_to_item = {
    ['container'] = true,
    ['logistic-container'] = true,
    ['cargo-wagon'] = true
}

local function get_match(stack)
    if stack.valid_for_read and stack.prototype.place_result and match_to_item[stack.prototype.place_result.type or 'nil'] then
        return true
    end
end

local function increase_decrease_reprogrammer(event, change)
    local player, pdata = Player.get(event.player_index)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        local stack = player.cursor_stack
        if get_match(stack) then
            pdata.chests = pdata.chests or {}
            local bar = pdata.chests[stack.name] or 0
            --.15 we can get the #slots from prototype
            local text_field = Pad.get_or_create_adjustment_pad(player, 'chestlimit')['chestlimit_text_box']
            --text_field.text = pdata[stack.name] or 0
            if event.element and event.element.name == 'chestlimit_text_box' and not type(event.element.text) == 'number' then
                return
            elseif event.element and event.element.name == 'chestlimit_text_box' then
                bar = tonumber(text_field.text)
            else
                bar = math.max(0, bar + (change or 0))
            end
            pdata.chests[stack.name] = (bar or 0 > 0 and bar) or nil
            text_field.text = bar or 0
        else
            Pad.remove_gui(player, 'chestlimit_frame_main')
        end
    else
        Pad.remove_gui(player, 'chestlimit_frame_main')
    end
end

local function adjust_limit_pad(event)
    local player = Player.get(event.player_index)
    if get_match(player.cursor_stack) and Pad.get_or_create_adjustment_pad(player, 'chestlimit') then
        if event.input_name == 'adjustment-pad-increase' then
            increase_decrease_reprogrammer(event, 1)
        elseif event.input_name == 'adjustment-pad-decrease' then
            increase_decrease_reprogrammer(event, -1)
        end
    end
end
Event.register(Event.generate_event_name('adjustment_pad'), adjust_limit_pad)

Gui.on_text_changed(
    'chestlimit_text_box',
    function(event)
        increase_decrease_reprogrammer(event, 0)
    end
)
Gui.on_click(
    'chestlimit_btn_up',
    function(event)
        increase_decrease_reprogrammer(event, 1)
    end
)
Gui.on_click(
    'chestlimit_btn_dn',
    function(event)
        increase_decrease_reprogrammer(event, -1)
    end
)
Gui.on_click(
    'chestlimit_btn_reset',
    function(event)
        increase_decrease_reprogrammer(event, -99999999999)
    end
)

local function on_chest_built(event)
    if match_to_item[event.created_entity.type] then
        local _, pdata = Player.get(event.player_index)
        pdata.chests = pdata.chests or {}
        local entity = event.created_entity
        local bar = pdata.chests[entity.name]
        local inventory = entity.get_inventory(defines.inventory.chest)
        if inventory and inventory.hasbar() and bar and bar > 0 then
            inventory.setbar(bar + 1)
        end
    end
end
Event.register(defines.events.on_built_entity, on_chest_built)

Event.register(defines.events.on_player_cursor_stack_changed, increase_decrease_reprogrammer)
