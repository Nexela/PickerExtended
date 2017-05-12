-------------------------------------------------------------------------------
--[[Picker Blueprinter]]--
-------------------------------------------------------------------------------
--Mirroring and Upgradeing code from "Foreman", by "Choumiko"

local Position = require("stdlib.area.position")
local Area = require("stdlib.area.area")
local Entity = require("stdlib.entity.entity")
local lib = require("picker.lib")
Event.mirror = script.generate_event_name()

-------------------------------------------------------------------------------
--[[BP Tools]]--
-------------------------------------------------------------------------------
local function get_or_create_blueprint_gui(player)
    local flow = lib.get_or_create_main_left_flow(player, "picker")
    local bpframe = flow["picker_bp_tools"]
    if not bpframe then
        bpframe = flow.add{type = "frame", name = "picker_bp_tools", direction="horizontal", style="filterfill_frame"}
        bpframe.add{type = "button", name = "picker_bp_tools_mirror", style = "picker_blueprinter_btn_mirror", tooltip = {"blueprinter.btn-mirror"}}
        bpframe.add{type = "choose-elem-button", name = "picker_bp_tools_from", elem_type="entity", style = "picker_blueprinter_btn_elem", tooltip = {"blueprinter.btn-from"}}
        bpframe.add{type = "choose-elem-button", name = "picker_bp_tools_to", elem_type="entity", style = "picker_blueprinter_btn_elem", tooltip = {"blueprinter.btn-to"}}
        bpframe.add{type = "button", name = "picker_bp_tools_update", caption = "OK", style = "picker_blueprinter_btn_upgrade", tooltip = {"blueprinter.btn-upgrade"}}
    end
    return bpframe
end

local function show_bp_tools(event)
    local player = game.players[event.player_index]
    local bp = lib.stack_name(player.cursor_stack, "blueprint", true)
    local frame = get_or_create_blueprint_gui(player) --.style.visible = bp and true or false
    if bp and not lib.is_beltbrush_bp(bp) then
        frame.style.visible = true
    else
        frame.destroy()
    end
end
Event.register(defines.events.on_player_cursor_stack_changed, show_bp_tools)

-------------------------------------------------------------------------------
--[[Open held item inventory]]--
-------------------------------------------------------------------------------
local function open_held_item_inventory(event)
    local player = game.players[event.player_index]
    if player.cursor_stack.valid_for_read then
        player.opened = player.cursor_stack
    end
end
script.on_event("picker-inventory-editor", open_held_item_inventory)

-------------------------------------------------------------------------------
--[[Make Simple Blueprint]]--
-------------------------------------------------------------------------------
local function make_simple_blueprint(event)
    local player = game.players[event.player_index]
    if player.controller_type ~= defines.controllers.ghost then
        if player.selected and not (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable")) then
            local entity = player.selected
            if player.clean_cursor() then
                if entity.force == player.force and lib.damaged(entity) and lib.get_planner(player, "repair-tool") then
                    return
                else
                    local area = Entity.to_collision_area(entity)
                    if Area.size(area) > 0 then
                        local bp = lib.get_planner(player, "blueprint", "Pipette Blueprint")
                        if bp then
                            bp.clear_blueprint()
                            bp.label = "Pipette Blueprint"
                            bp.allow_manual_label_change = false
                            bp.create_blueprint{surface = entity.surface, force = player.force, area = area, always_include_tiles = false}
                            return bp.is_blueprint_setup() and bp
                        end
                    end

                end
            else
                player.print({"picker.msg-cant-insert-blueprint"})
            end
        elseif not player.selected or (player.selected and (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable"))) then
            lib.get_next_planner(player)
        end
    end
end
script.on_event("picker-make-ghost", make_simple_blueprint)

-------------------------------------------------------------------------------
--[[Update BP Entities]]--
-------------------------------------------------------------------------------
local function update_blueprint(event)
    local player = game.players[event.player_index]
    local stack = lib.stack_name(player.cursor_stack, "blueprint", true)
    if stack then
        local from = event.element.parent["picker_bp_tools_from"].elem_value
        local to = event.element.parent["picker_bp_tools_to"].elem_value
        if from and to then
            if game.entity_prototypes[from].fast_replaceable_group == game.entity_prototypes[to].fast_replaceable_group then
                local bp_entities = stack.get_blueprint_entities()
                for _, entity in pairs(bp_entities) do
                    if entity.name == from then
                        entity.name = to
                    end
                end

                stack.set_blueprint_entities(bp_entities)
            else
                player.print({"blueprinter.selections-not-fast-replaceable", {"entity-name."..from}, {"entity-name."..to}})
            end
        else
            player.print({"blueprinter.no-from-or-to"})
        end
    end
end
Gui.on_click("picker_bp_tools_update", update_blueprint)

-------------------------------------------------------------------------------
--[[Mirroring]]--
-------------------------------------------------------------------------------
local function get_mirrored_blueprint(blueprint)
    local curves, others, stops, signals, tanks = 9, 0, 4, 4, 2

    local smartTrains = remote.interfaces.st and remote.interfaces.st.getProxyPositions
    local smartStops = {["smart-train-stop-proxy"] = {}, ["smart-train-stop-proxy-cargo"] = {}}
    local smartSignal = {}
    local smartCargo = {}
    local proxyKeys = function(trainStop)
        local proxies = remote.call("st", "getProxyPositions", trainStop)
        local signal = proxies.signalProxy.x .. ":" .. proxies.signalProxy.y
        local cargo = proxies.cargo.x .. ":" .. proxies.cargo.y
        return {signal = signal, cargo = cargo}
    end
    local entities = blueprint.get_blueprint_entities()
    local tiles = blueprint.get_blueprint_tiles()
    if entities then
        for i, ent in pairs(entities) do
            local entType = game.entity_prototypes[ent.name] and game.entity_prototypes[ent.name].type
            ent.direction = ent.direction or 0
            if entType == "curved-rail" then
                ent.direction = (curves - ent.direction) % 8
            elseif entType == "rail-signal" or entType == "rail-chain-signal" then
                ent.direction = (signals - ent.direction) % 8
            elseif entType == "train-stop" then
                if ent.name == "smart-train-stop" and smartTrains then
                    local proxies = proxyKeys(ent)
                    smartStops["smart-train-stop-proxy"][proxies.signal] = {old = {direction = ent.direction, position = Position.copy(ent.position)}}
                    smartStops["smart-train-stop-proxy-cargo"][proxies.cargo] = {old = {direction = ent.direction, position = Position.copy(ent.position)}}
                    ent.direction = (stops - ent.direction) % 8
                    smartStops["smart-train-stop-proxy"][proxies.signal].new = ent
                    smartStops["smart-train-stop-proxy-cargo"][proxies.cargo].new = ent
                else
                    ent.direction = (stops - ent.direction) % 8
                end
            elseif entType == "storage-tank" then
                ent.direction = (tanks + ent.direction) % 8
            elseif entType == "lamp" and ent.name == "smart-train-stop-proxy" then
                ent.direction = 0
                table.insert(smartSignal, {entity = {name=ent.name, position = Position.copy(ent.position)}, i = i})
            elseif entType == "constant-combinator" and ent.name == "smart-train-stop-proxy-cargo" then
                ent.direction = 0
                table.insert(smartCargo, {entity = {name=ent.name, position = Position.copy(ent.position)}, i = i})
            else
                ent.direction = (others - ent.direction) % 8
            end

            ent.position.x = -1 * ent.position.x

            if ent.drop_position then
                ent.drop_position.x = -1 * ent.drop_position.x
            end
            if ent.pickup_position then
                ent.pickup_position.x = -1 * ent.pickup_position.x
            end
        end
    end
    for _, data in pairs(smartSignal) do
        local proxy = data.entity
        local stop = smartStops[proxy.name][proxy.position.x .. ":" .. proxy.position.y]
        if stop then
            local newPositions = remote.call("st", "getProxyPositions", stop.new)
            entities[data.i].position = newPositions.signalProxy
        end
    end
    for _, data in pairs(smartCargo) do
        local proxy = data.entity
        local stop = smartStops[proxy.name][proxy.position.x .. ":" .. proxy.position.y]
        if stop then
            local newPositions = remote.call("st", "getProxyPositions", stop.new)
            entities[data.i].position = newPositions.cargo
        end
    end
    if tiles then
        for _, tile in pairs(tiles) do
            tile.position.x = -1 * tile.position.x
        end
    end
    return {entities = entities, tiles = tiles}
end

local function mirror_blueprint (event)
    local player = game.players[event.player_index]
    local blueprint = lib.stack_name(player.cursor_stack, "blueprint", true)
    if blueprint then
        local mirrored = get_mirrored_blueprint(blueprint)
        blueprint.set_blueprint_entities(mirrored.entities)
        blueprint.set_blueprint_tiles(mirrored.tiles)
        if blueprint.label and not event.corner then
            if blueprint.label:find("Belt Brush Corner Left") then
                blueprint.label = "Belt Brush Corner Right "..blueprint.label:match("%d+")
            elseif blueprint.label:find("Belt Brush Corner Right") then
                blueprint.label = "Belt Brush Corner Left "..blueprint.label:match("%d+")
            end
        end
    end
end
Gui.on_click("picker_bp_tools_mirror", mirror_blueprint)
script.on_event("picker-mirror-blueprint", mirror_blueprint)
Event.register(Event.mirror, mirror_blueprint)

-------------------------------------------------------------------------------
--[[Quick Pick Blueprint]]--
-------------------------------------------------------------------------------
local function create_or_destroy_quick_picker(event)
    local player = game.players[event.player_index]
    local gui = player.gui.center["picker_quick_picker"]
    if gui then
        gui.destroy()
    else
        gui = player.gui.center.add{type="frame", name="picker_quick_picker", direction="vertical", style = "filterfill_frame"}
        gui.add{type="label", name = "picker_quick_picker_label", caption = "Quick BP"}
        local btn = gui.add{type="choose-elem-button", name = "picker_quick_picker_item", elem_type="item", style = "picker_blueprinter_btn_elem"}
        btn.style.minimal_height = 32
        btn.style.minimal_height = 32
    end
end
script.on_event("picker-quick-picker", create_or_destroy_quick_picker)

local function create_quick_pick_blueprint(event)
    local player = game.players[event.player_index]
    if event.element.elem_value then
        if player.cheat_mode then
            if player.clean_cursor() then
                player.cursor_stack.set_stack({name = event.element.elem_value, count = 1})
            end
        else
            if game.item_prototypes[event.element.elem_value].place_result then
                local stack = player.clean_cursor() and lib.get_planner(player, "blueprint")
                local entities = {
                    {
                        entity_number = 1,
                        name = game.item_prototypes[event.element.elem_value].place_result.name,
                        direction = defines.direction.north,
                        position = {0.5, 0.5}
                    }
                }
                stack.set_blueprint_entities(entities)
            end

        end
    end
    create_or_destroy_quick_picker(event)
end
Gui.on_elem_changed("picker_quick_picker_item", create_quick_pick_blueprint)
