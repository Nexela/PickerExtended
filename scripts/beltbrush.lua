-------------------------------------------------------------------------------
--[Belt Brush]-- TODO .16 can use item_stack.import/export
-------------------------------------------------------------------------------
local Event = require('stdlib/event/event')
local Gui = require('stdlib/event/gui')
local Player = require('stdlib/event/player')
local Position = require('stdlib/area/position')
local Area = require('stdlib/area/area')
local Pad = require('scripts/adjustment-pad')
local lib = require('scripts/lib')

local balancers = require('blueprints/balancers')

--These items can be used to make brush widths
local match_to_brush = {
    ['transport-belt'] = true,
    ['underground-belt'] = true,
    ['loader'] = true,
    ['pipe-to-ground'] = true
}

--These items will be automatically revived in belt brush BPs
local match_to_revive = {
    ['transport-belt'] = true,
    ['underground-belt'] = true,
    ['splitter'] = true,
    ['loader'] = true,
    ['pipe-to-ground'] = true
}

local function get_match(stack)
    return stack.valid_for_read and stack.prototype.place_result and match_to_brush[stack.prototype.place_result.type or 'nil']
end

--Revive belts in build range when using belt brush blueprints
local function revive_belts(event)
    local player = Player.get(event.player_index)
    if event.created_entity.name == 'entity-ghost' and match_to_revive[event.created_entity.ghost_type] and lib.is_named_bp(player.cursor_stack, 'Belt Brush') then
        local ghost = event.created_entity
        local name = ghost.ghost_name
        if Position.distance(player.position, ghost.position) <= player.build_distance + 1 then
            if player.get_item_count(name) > 0 then
                local _, revived = ghost.revive()
                if revived then
                    player.remove_item({name = name, count = 1})
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
            entities[#entities + 1] = {
                entity_number = i,
                name = name,
                position = {0 + i - 1, 0},
                direction = defines.direction.north
            }
        end
        -- Shift all entities in the blueprint to try and keep it centered on the cursor
        table.each(
            entities,
            function(ent)
                ent.position = Position.translate(ent.position, defines.direction.west, math.ceil(lanes / 2) - 1)
            end
        )
        stack.set_blueprint_entities(entities)
        stack.label = 'Belt Brush ' .. lanes
        stack.allow_manual_label_change = false
    end
end

local function create_or_destroy_bp(player, lanes)
    local stack = player.cursor_stack
    local name
    if get_match(stack) then
        name = stack.prototype.place_result.name
    elseif stack.is_blueprint_setup() then
        local ent =
            table.find(
            stack.get_blueprint_entities(),
            function(v)
                return match_to_brush[game.entity_prototypes[v.name].type]
            end
        )
        name = ent and ent.name
    end

    if name then
        if lanes > 1 then
            if not lib.is_named_bp(stack, 'Belt Brush') and player.clean_cursor() then
                --elseif player.clean_cursor() then
                stack = lib.get_planner(player, 'blueprint', 'Belt Brush')
                stack.clear_blueprint()
            end
            if lib.get_blueprint(player.cursor_stack, false) then
                build_beltbrush(stack, name, lanes)
            end
        elseif lib.is_named_bp(stack, 'Belt Brush') and lanes == 1 then
            for _, inv in pairs({defines.inventory.player_main, defines.inventory.player_quickbar}) do
                local item = player.get_inventory(inv).find_item_stack(name)
                if item then
                    --TODO swapstack?
                    --stack.clear()
                    stack.set_stack(item)
                    item.clear()
                    break
                else
                    stack.clear()
                end
            end
        end
    end
end

-------------------------------------------------------------------------------
--[Automatic Corners]--
-------------------------------------------------------------------------------
local function build_corner_brush(stack, belt, lanes)
    if lanes >= 1 and lanes <= 32 then
        local new_ents = {}
        local next_id = 1

        local dir = belt.direction or 0

        local function next_dir()
            return dir == 0 and 6 or dir - 2
        end

        local function get_dir(x, y)
            if y + .5 - lanes + x + .5 <= 1 then
                return next_dir()
            else
                return dir
            end
        end

        for x = .5, lanes, 1 do
            for y = .5, lanes, 1 do
                next_id = next_id + 1
                new_ents[#new_ents + 1] = {
                    entity_number = next_id,
                    name = belt.name,
                    position = {x = x, y = y},
                    direction = get_dir(x, y)
                }
            end
        end
        table.each(
            new_ents,
            function(ent)
                ent.position = Position.translate(ent.position, defines.direction.northwest, math.ceil(lanes / 2))
            end
        )
        stack.set_blueprint_entities(new_ents)
        stack.label = 'Belt Brush Corner Left ' .. lanes
    end
end

local function build_ug_brush(stack, ug, lanes)
    if lanes >= 1 and lanes <= 32 then
        local name = ug.name
        local direction = ug.direction
        local type = ug.type

        local opposite_type = {
            ['input'] = 'output',
            ['output'] = 'input'
        }

        local distance = tonumber(stack.label:match('Belt Brush Underground %d+x(%d+)'))
        local max = game.entity_prototypes[ug.name].max_underground_distance
        max = distance or max
        if max > 0 then
            local new_ents = {}
            local next_id = 0
            local get_next_id = function()
                next_id = next_id + 1
                return next_id
            end

            for x = 0.5, lanes, 1 do
                new_ents[#new_ents + 1] = {
                    entity_number = get_next_id(),
                    name = name,
                    direction = direction,
                    type = type,
                    position = {x, -0.5}
                }
                new_ents[#new_ents + 1] = {
                    entity_number = get_next_id(),
                    name = name,
                    direction = direction,
                    type = opposite_type[type],
                    position = {x, -(0.5 + max)}
                }
            end
            table.each(
                new_ents,
                function(ent)
                    ent.position = Position.translate(ent.position, defines.direction.west, math.ceil(lanes / 2))
                end
            )
            table.each(
                new_ents,
                function(ent)
                    ent.position = Position.translate(ent.position, defines.direction.south, math.ceil(max / 2))
                end
            )
            stack.set_blueprint_entities(new_ents)
            stack.label = 'Belt Brush Underground ' .. lanes .. 'x' .. (max - 1)
        else
            build_beltbrush(stack, ug.name, lanes)
        end
    end
end

local function build_ptg_brush(stack, ptg, lanes)
    if lanes >= 1 and lanes <= 32 then
        local name = ptg.name
        local direction = ptg.direction
        local new_ents = {}
        local max = game.entity_prototypes[name].max_underground_distance
        local next_id = 0
        local get_next_id = function()
            next_id = next_id + 1
            return next_id
        end

        for x = 0.5, lanes, 1 do
            new_ents[#new_ents + 1] = {
                entity_number = get_next_id(),
                name = name,
                direction = direction,
                position = {x, 0.5}
            }
            new_ents[#new_ents + 1] = {
                entity_number = get_next_id(),
                name = name,
                direction = Position.opposite_direction(direction),
                position = {x, (0.5 + max)}
            }
        end

        table.each(
            new_ents,
            function(ent)
                ent.position = Position.translate(ent.position, defines.direction.west, math.ceil(lanes / 2))
            end
        )
        table.each(
            new_ents,
            function(ent)
                ent.position = Position.translate(ent.position, defines.direction.north, math.ceil(max / 2))
            end
        )
        stack.set_blueprint_entities(new_ents)
        stack.label = 'Belt Brush Pipe to Ground ' .. lanes
    end
end

-- Build corners based on brushed width on key press
-- pressing a second time will mirror the corner
-- pressing a third time will revert to brush width
local function beltbrush_corners(event)
    local player = Player.get(event.player_index)
    if lib.is_named_bp(player.cursor_stack, 'Belt Brush') then
        local stack = player.cursor_stack
        local stored = tonumber(Pad.get_or_create_adjustment_pad(player, 'beltbrush')['beltbrush_text_box'].text)
        local bp_ents = stack.get_blueprint_entities()
        local belt =
            table.find(
            bp_ents,
            function(v)
                return game.entity_prototypes[v.name].type == 'transport-belt'
            end
        )
        local ug =
            table.find(
            bp_ents,
            function(v)
                return game.entity_prototypes[v.name].type == 'underground-belt'
            end
        )
        local ptg =
            table.find(
            bp_ents,
            function(v)
                return game.entity_prototypes[v.name].type == 'pipe-to-ground'
            end
        )

        if not (stack.label:find('Corner') or stack.label:find('Underground') or stack.label:find('Pipe to Ground')) then
            if belt and belt.name then
                build_corner_brush(stack, belt, stored)
            elseif ug and ug.name then
                build_ug_brush(stack, ug, stored)
            elseif ptg and ptg.name then
                build_ptg_brush(stack, ptg, stored)
            end
        elseif stack.label:find('Belt Brush Corner Left') then
            Event.dispatch({name = Event.generate_event_name('mirror_blueprint'), player_index = player.index, corner = true})
            stack.label = 'Belt Brush Corner Right ' .. stack.label:match('%d+')
        elseif stack.label:find('Belt Brush Corner Right') then
            build_beltbrush(stack, belt.name, tonumber(stack.label:match('%d+')))
        elseif stack.label:find('Belt Brush Underground') then
            build_ug_brush(stack, ug, tonumber(stack.label:match('%d+')))
        elseif stack.label:find('Belt Brush Pipe to Ground') then
            build_beltbrush(stack, ptg.name, tonumber(stack.label:match('%d+')))
        end
    end
end
Event.register('picker-beltbrush-corners', beltbrush_corners)

-------------------------------------------------------------------------------
--[Automatic Balancers]--
-------------------------------------------------------------------------------
local function build_cascading_underground(stack, ug, lanes)
    if lanes >= 1 and lanes <= 32 then
        local next_id = 0
        local get_next_id = function()
            next_id = next_id + 1
            return next_id
        end
        local casc = {}

        local distance = tonumber(stack.label:match('Belt Brush Cascade %d+x(%d+)'))
        local max = game.entity_prototypes[ug.name].max_underground_distance
        max = distance or max

        if max > 0 then
            local skip = lanes + .5
            for y = .5, (lanes * max) + max, max + 1 do
                for x = .5, lanes + 0.5, 1 do
                    if x < skip then
                        casc[#casc + 1] = {
                            entity_number = get_next_id(),
                            name = ug.name,
                            direction = 4,
                            type = 'input',
                            position = {x, y}
                        }

                        casc[#casc + 1] = {
                            entity_number = get_next_id(),
                            name = ug.name,
                            direction = 4,
                            type = 'output',
                            position = {x, y + max}
                        }
                    end
                end
                skip = skip - 1
            end
            table.each(
                casc,
                function(ent)
                    ent.position = Position.translate(ent.position, defines.direction.west, math.ceil(lanes / 2))
                end
            )
            table.each(
                casc,
                function(ent)
                    ent.position = Position.translate(ent.position, defines.direction.north, math.ceil(max / 2))
                end
            )
            stack.set_blueprint_entities(casc)
            stack.label = 'Belt Brush Cascade ' .. lanes .. 'x' .. (max - 1)
        else
            build_beltbrush(stack, ug.name, lanes)
        end
    end
end

-- Build balaners based on brush width on key press.
-- Subsequent key presses will cycle through the availble balancers
local function beltbrush_balancers(event)
    local player = Player.get(event.player_index)
    if lib.is_named_bp(player.cursor_stack, 'Belt Brush') then
        local stack = player.cursor_stack
        local lanes = tonumber(Pad.get_or_create_adjustment_pad(player, 'beltbrush')['beltbrush_text_box'].text)
        local bp = stack.get_blueprint_entities()
        local belt =
            table.find(
            bp,
            function(v)
                return game.entity_prototypes[v.name].type == 'transport-belt'
            end
        )
        local ug =
            table.find(
            bp,
            function(v)
                return game.entity_prototypes[v.name].type == 'underground-belt'
            end
        )
        belt = belt and belt.name
        if belt then
            local kind = belt:gsub('transport%-belt', '')
            local current = stack.label:gsub('Belt Brush Balancers %d+x', '')

            --set the width to 1 less then existing or existing if not a balancer already
            local width = (tonumber(current) and tonumber(current) - 1) or lanes

            if lanes then
                local ents

                local i = 0
                repeat
                    ents = table.deepcopy(balancers[lanes .. 'x' .. width])
                    width = (not ents and ((width <= 1 and 32) or (width - 1))) or width
                    i = i + 1
                until ents or width == lanes or i == 100

                if ents and not (width == lanes and stack.label:find('Belt Brush Balancers')) then
                    table.each(
                        ents,
                        function(v)
                            v.name = kind .. v.name
                        end
                    )
                    stack.set_blueprint_entities(ents)
                    stack.label = 'Belt Brush Balancers ' .. lanes .. 'x' .. width
                elseif stack.label:find('Belt Brush Balancers') then
                    build_beltbrush(stack, belt, lanes)
                end
            end
        elseif ug and ug.name then
            build_cascading_underground(stack, ug, lanes)
        end
    end
end
Event.register('picker-beltbrush-balancers', beltbrush_balancers)

-------------------------------------------------------------------------------
--[Allow Upgrades]--
-------------------------------------------------------------------------------
-- When a blueprint is placed check to see if it is a beltbrush bp and if it is destroy matched ghosts underneath.
local function placed_blueprint(event)
    local player, pdata = Player.get(event.player_index)
    local stack = lib.get_blueprint(player.cursor_stack, true)
    if stack and lib.is_named_bp(stack, 'Belt Brush') and (pdata.last_ghost_check or 0) <= event.tick - 2 then --and not stack.label:find("Belt Brush %d+") then
        local corners = {lx = 0, ly = 0, rx = 0, ry = 0}
        --Create a bounding box from the blueprint entities.
        table.each(
            stack.get_blueprint_entities(),
            function(v)
                if v.position.x > 0 and v.position.x > corners.rx then
                    corners.rx = v.position.x + .5
                elseif v.position.x <= 0 and v.position.x < corners.lx then
                    corners.lx = v.position.x - .5
                end
                if v.position.y > 0 and v.position.y > corners.ry then
                    corners.ry = v.position.y + .5
                elseif v.position.y <= 0 and v.position.y < corners.ly then
                    corners.ly = v.position.y - .5
                end
            end
        )

        --For all ghosts in the bounding box destroy them if they match revivables.
        local position = {math.floor(event.position.x) + .5, math.floor(event.position.y) + .5}
        table.each(
            player.surface.find_entities_filtered {
                name = 'entity-ghost',
                area = Area.offset({{corners.lx, corners.ly}, {corners.rx, corners.ry}}, position)
            },
            function(v)
                if match_to_revive[v.ghost_type] then
                    v.destroy()
                end
            end
        )
        pdata.last_ghost_check = event.tick
    end
end
Event.register(defines.events.on_put_item, placed_blueprint)

-------------------------------------------------------------------------------
--[Adjustment Pad]--
-------------------------------------------------------------------------------
local function increase_decrease_reprogrammer(event, change)
    local player = Player.get(event.player_index)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        local stack = player.cursor_stack
        if get_match(stack) or lib.is_named_bp(stack, 'Belt Brush') then
            local text_field = Pad.get_or_create_adjustment_pad(player, 'beltbrush')['beltbrush_text_box']
            local lanes = lib.is_named_bp(stack, 'Belt Brush') and stack.label:match('%d+') or tonumber(text_field.text)
            if event.element and event.element.name == 'beltbrush_text_box' and not tonumber(event.element.text) then
                return
            elseif event.element and event.element.name == 'beltbrush_text_box' then
                lanes = (tonumber(text_field.text) or 1) <= 32 and (tonumber(text_field.text) or 1) or 32
            else
                lanes = lanes and math.min(math.max(1, lanes + (change or 0)), 32) or 1
            end
            text_field.text = lanes or 1
            if not (lib.is_named_bp(stack, 'Belt Brush') and not change) then
                create_or_destroy_bp(player, lanes or 1)
            end
        else
            Pad.remove_gui(player, 'beltbrush_frame_main')
        end
    else
        Pad.remove_gui(player, 'beltbrush_frame_main')
    end
end

local function adjust_pad(event)
    local player = Player.get(event.player_index)
    if lib.get_or_create_main_left_flow(player, 'picker')['beltbrush_frame_main'] then
        if get_match(player.cursor_stack) or lib.is_named_bp(player.cursor_stack, 'Belt Brush') then
            if event.input_name == 'adjustment-pad-increase' then
                increase_decrease_reprogrammer(event, 1)
            elseif event.input_name == 'adjustment-pad-decrease' then
                increase_decrease_reprogrammer(event, -1)
            end
        end
    end
end
Event.register(Event.adjustment_pad, adjust_pad)

Gui.on_text_changed(
    'beltbrush_text_box',
    function(event)
        increase_decrease_reprogrammer(event, 0)
    end
)
Gui.on_click(
    'beltbrush_btn_up',
    function(event)
        increase_decrease_reprogrammer(event, 1)
    end
)
Gui.on_click(
    'beltbrush_btn_dn',
    function(event)
        increase_decrease_reprogrammer(event, -1)
    end
)
Gui.on_click(
    'beltbrush_btn_reset',
    function(event)
        increase_decrease_reprogrammer(event, -99999999999)
    end
)
Event.register(defines.events.on_player_cursor_stack_changed, increase_decrease_reprogrammer)
