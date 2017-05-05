-------------------------------------------------------------------------------
--[[Belt Brush]]--
-------------------------------------------------------------------------------
local Player = require("stdlib/player")
local Pad = require("picker.adjustment-pad")
local lib = require("picker.lib")

local match_to_item = {
    ["transport-belt"] = true
}

local function is_beltbrush_bp(stack)
    return stack.valid_for_read and stack.name == "blueprint" and stack.label and stack.label:find("Belt Brush")
end

local function get_match(stack)
    return stack.valid_for_read and stack.prototype.place_result and match_to_item[stack.prototype.place_result.type or "nil"]
end

local function build_beltbrush(stack, name, lanes)

    if name then
        local entities = {}
        for i = 1, lanes do
            entities[#entities+1] = {
                entity_number = i,
                name = name,
                position = {0+i-1,0},
                direction = defines.direction.north,
            }
        end
        stack.set_blueprint_entities(entities)
    end
end

local function create_or_destroy_bp(player, lanes)
    local stack = player.cursor_stack
    local name
    if get_match(stack) then
        name = stack.prototype.place_result.name
    elseif stack.is_blueprint_setup() then
        local ent = table.find(stack.get_blueprint_entities(), function(v) return game.entity_prototypes[v.name].type == "transport-belt" end)
        name = ent and ent.name
    end
    if name then
        if lanes > 1 then
            if is_beltbrush_bp(stack) then
                log("log")
                --player.cursor_stack.clear_blueprint()
            elseif player.clean_cursor() then
                stack = lib.get_planner(player, "blueprint", "Belt Brush")
                stack.clear_blueprint()
            end
            stack.label = "Belt Brush "..lanes
            stack.allow_manual_label_change = false
            build_beltbrush(stack, name, lanes)
            -- elseif is_beltbrush_bp(stack) then
            -- if stack.is_blueprint_setup() then
            -- --local new_stack = player.find_item_stack(name)
            -- -- if new_stack and stack.set_stack(new_stack) then
            -- -- new_stack.clear()
            -- -- end
            -- stack.clear()
            -- else
            -- stack.clear()
            -- --stack.set_stack()
            -- end
        end
    end
end

local function increase_decrease_reprogrammer(event, change)
    local player = Player.get(event.player_index)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        local stack = player.cursor_stack
        if get_match(stack) or is_beltbrush_bp(stack) then
            local text_field = Pad.get_or_create_adjustment_pad(player, "beltbrush")["beltbrush_text_box"]
            local lanes = tonumber(text_field.text)
            if event.element and event.element.name == "beltbrush_text_box" and not type(event.element.text) == "number" then
                return
            elseif event.element and event.element.name == "beltbrush_text_box" then
                lanes = tonumber(text_field.text)
            else
                lanes = math.min(math.max(1, lanes + (change or 0)),32)
            end
            text_field.text = lanes
            create_or_destroy_bp(player, lanes)
        end
    else
        Pad.remove_gui(player, "beltbrush_frame_main")
    end
end

local function adjust_pad(event)
    local player = Player.get(event.player_index)
    if player.gui.left["beltbrush_frame_main"] then
        if get_match(player.cursor_stack) or is_beltbrush_bp(player.cursor_stack) then
            if event.input_name == "adjustment-pad-increase" then
                increase_decrease_reprogrammer(event, 1)
            elseif event.input_name == "adjustment-pad-decrease" then
                increase_decrease_reprogrammer(event, -1)
            end
        end
    end
end
Event.register(Event.adjustment_pad, adjust_pad)

Gui.on_text_changed("beltbrush_text_box", function (event) increase_decrease_reprogrammer(event, 0) end)
Gui.on_click("beltbrush_btn_up", function (event) increase_decrease_reprogrammer(event, 1) end)
Gui.on_click("beltbrush_btn_dn", function (event) increase_decrease_reprogrammer(event, -1) end)
Gui.on_click("beltbrush_btn_reset", function(event) increase_decrease_reprogrammer(event, -99999999999) end)

Event.register(defines.events.on_player_cursor_stack_changed, increase_decrease_reprogrammer)
