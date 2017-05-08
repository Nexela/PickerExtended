-------------------------------------------------------------------------------
--[[Belt Brush]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")
local Position = require("stdlib.area.position")
local Pad = require("picker.adjustment-pad")
local lib = require("picker.lib")

local balancers = require("blueprints.balancers")

local match_to_item = {
    ["transport-belt"] = true,
    ["underground-belt"] = true
}

local function is_beltbrush_bp(stack)
    return stack.valid_for_read and stack.name == "blueprint" and stack.label and stack.label:find("Belt Brush")
end

local function get_match(stack)
    return stack.valid_for_read and stack.prototype.place_result and match_to_item[stack.prototype.place_result.type or "nil"]
end

local function revive_belts(event)
    local player = Player.get(event.player_index)
    if event.created_entity.name == "entity-ghost" and match_to_item[event.created_entity.ghost_type] and is_beltbrush_bp(player.cursor_stack) then
        local ghost = event.created_entity
        local name = ghost.ghost_name
        if Position.distance(player.position, ghost.position) <= player.build_distance + 1 then
            if player.get_item_count(name) > 0 then
                local _, revived = ghost.revive()
                if revived then
                    player.remove_item({name=name, count=1})
                    script.raise_event(defines.events.on_built_entity, {created_entity = revived, player_index = player.index, revived = true})
                end
            end
        end
    end
end
Event.register(defines.events.on_built_entity, revive_belts)

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
        table.each(entities, function(ent) ent.position = Position.translate(ent.position, defines.direction.west, math.floor(lanes/2)) end)
        stack.set_blueprint_entities(entities)
    end
end

local function create_or_destroy_bp(player, lanes)
    local stack = player.cursor_stack
    local name
    if get_match(stack) then
        name = stack.prototype.place_result.name
    elseif stack.is_blueprint_setup() then
        local ent = table.find(stack.get_blueprint_entities(), function(v) return match_to_item[game.entity_prototypes[v.name].type] end)
        name = ent and ent.name
    end

    if name then
        if lanes > 1 then
            if not is_beltbrush_bp(stack) and player.clean_cursor() then

                --elseif player.clean_cursor() then
                stack = lib.get_planner(player, "blueprint", "Belt Brush")
                stack.clear_blueprint()
            end
            if lib.cursor_stack_name(player, "blueprint") then
                stack.label = "Belt Brush "..lanes
                stack.allow_manual_label_change = false
                build_beltbrush(stack, name, lanes)
            end
        elseif is_beltbrush_bp(stack) and lanes == 1 then
            for _, inv in pairs({defines.inventory.player_main, defines.inventory.player_quickbar}) do
                local item = player.get_inventory(inv).find_item_stack(name)
                if item then
                    stack.clear()
                    stack.set_stack(item)
                    item.clear()
                else
                    stack.clear()
                end
            end
        end
    end
end

local function beltbrush_corners(event)
    local player = Player.get(event.player_index)
    if is_beltbrush_bp(player.cursor_stack) then
        local stack = player.cursor_stack
        local bp = stack.get_blueprint_entities()
        local belt = table.find(bp, function(v) return match_to_item[game.entity_prototypes[v.name].type] end)
        belt = belt and belt.name
        if belt and game.entity_prototypes[belt].type == "transport-belt" then
            local stored = tonumber(Pad.get_or_create_adjustment_pad(player, "beltbrush")["beltbrush_text_box"].text)
            local lanes = #bp
            if lanes == stored then
                local new_ents = {}
                local next_id = 1

                local dir = bp[1].direction or 0

                local function next_dir()
                    return dir == 0 and 6 or dir - 2
                end

                local function get_dir(x, y)
                    if y - lanes + x <= 1 then
                        return next_dir()
                    else
                        return dir
                    end
                end

                for x = 1, lanes do
                    for y = 1, lanes do
                        next_id = next_id + 1
                        new_ents[#new_ents + 1] = {
                            entity_number = next_id,
                            name = belt,
                            position = {x = x, y = y},
                            direction = get_dir(x, y)
                        }
                    end
                end
                table.each(new_ents, function(ent) ent.position = Position.translate(ent.position, defines.direction.northwest, math.floor(lanes/2)) end)
                stack.set_blueprint_entities(new_ents)
                stack.label = "Belt Brush Corners "..lanes
            end
        end
    end
end
script.on_event("picker-beltbrush-corners", beltbrush_corners)

local function beltbrush_balancers(event)
    local player = Player.get(event.player_index)
    if is_beltbrush_bp(player.cursor_stack) then
        local stack = player.cursor_stack
        local bp = stack.get_blueprint_entities()
        local belt = table.find(bp, function(v) return match_to_item[game.entity_prototypes[v.name].type] end)
        belt = belt and belt.name
        if belt and game.entity_prototypes[belt].type == "transport-belt" then
            local lanes = tonumber(Pad.get_or_create_adjustment_pad(player, "beltbrush")["beltbrush_text_box"].text)
            local kind = belt:gsub("transport%-belt", "")
            local current = stack.label:gsub("Belt Brush Balancers %d+x", "")
            local width = (tonumber(current) and tonumber(current) - 1) or 32

            local ents

            repeat
                ents = table.deepcopy(balancers[lanes.."x"..width])
                width = (not ents and width - 1) or width
            until ents or width <= 0

            if ents then
                table.each(ents, function(v) v.name = kind..v.name end)
                stack.set_blueprint_entities(ents)
                stack.label = "Belt Brush Balancers "..lanes.."x"..width
            end
        end
    end
end
script.on_event("picker-beltbrush-balancers", beltbrush_balancers)

print(tonumber("test"))
-------------------------------------------------------------------------------
--[[Adjustment Pad]]--
-------------------------------------------------------------------------------
local function increase_decrease_reprogrammer(event, change)
    local player = Player.get(event.player_index)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        local stack = player.cursor_stack
        if get_match(stack) or is_beltbrush_bp(stack) then
            local text_field = Pad.get_or_create_adjustment_pad(player, "beltbrush")["beltbrush_text_box"]
            local lanes = tonumber(text_field.text)
            if event.element and event.element.name == "beltbrush_text_box" and not tonumber(event.element.text) then
                game.print("should be returning")
                return
            elseif event.element and event.element.name == "beltbrush_text_box" then
                lanes = (tonumber(text_field.text) or 1) <= 32 and (tonumber(text_field.text) or 1) or 32
            else
                lanes = lanes and math.min(math.max(1, lanes + (change or 0)),32) or 1
            end
            text_field.text = lanes or 1
            create_or_destroy_bp(player, lanes or 1)
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
