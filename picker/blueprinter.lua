-------------------------------------------------------------------------------
--[[Picker Blueprinter]]--
-------------------------------------------------------------------------------
--Mirroring and Upgradeing code from "Foreman", by "Choumiko"

local Position = require("stdlib.area.position")
local Entity = require("stdlib.entity.entity")
local lib = require("picker.lib")
local mod_gui = require("mod-gui")

--Requires empty blueprint in inventory
local function make_simple_blueprint(event)
    local player = game.players[event.player_index]
    if player.controller_type ~= defines.controllers.ghost then
        if player.selected and not (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable")) then
            local entity = player.selected
            if player.clean_cursor() then
                if entity.force == player.force and lib.damaged(entity) and lib.get_planner(player, "repair-tool") then
                    return
                else
                    local bp = lib.get_planner(player, "blueprint", "Pipette Blueprint")
                    if bp then
                        bp.clear_blueprint()
                        bp.label = "Pipette Blueprint"
                        bp.allow_manual_label_change = false
                        bp.create_blueprint{surface = entity.surface, force = player.force, area = Entity.to_selection_area(entity), always_include_tiles = false}
                        return bp.is_blueprint_setup() and bp
                    end
                end
            else
                player.print({"picker.msg-cant-insert-blueprint"})
            end
        elseif not player.selected or (player.selected and (player.selected.type == "resource" or player.selected.has_flag("not-blueprintable"))) then
            if (not player.cursor_stack.valid_for_read or player.cursor_stack.valid_for_read and player.cursor_stack.name ~= "blueprint") then
                return player.clean_cursor() and lib.get_planner(player, "blueprint")
            elseif player.cursor_stack.valid_for_read and player.cursor_stack.name == "blueprint" then
                return player.clean_cursor() and lib.get_planner(player, "deconstruction-planner")
            end
        end
    end
end
script.on_event("picker-make-ghost", make_simple_blueprint)

local function get_or_create_blueprint_gui(player)
    local frame = mod_gui.get_frame_flow(player)
    local bpframe = frame["picker_bp_tools"]
    if not bpframe then
        bpframe = frame.add{type = "frame", name = "picker_bp_tools", direction="horizontal"}
        bpframe.style.bottom_padding = 0
        bpframe.add{type = "button", name = "picker_bp_tools_mirror", style = "picker_blueprinter_btn_mirror", tooltip = {"blueprinter.btn-mirror"}}
        bpframe.add{type = "choose-elem-button", name = "picker_bp_tools_from", elem_type="entity", style = "picker_blueprinter_btn_elem", tooltip = {"blueprinter.btn-from"}}
        bpframe.add{type = "choose-elem-button", name = "picker_bp_tools_to", elem_type="entity", style = "picker_blueprinter_btn_elem", tooltip = {"blueprinter.btn-to"}}
        bpframe.add{type = "button", name = "picker_bp_tools_update", caption = "OK", style = "picker_blueprinter_btn_upgrade", tooltip = {"blueprinter.btn-upgrade"}}
    end
    return bpframe
end

local function show_bp_tools(event)
    local player = game.players[event.player_index]
    get_or_create_blueprint_gui(player).style.visible = lib.cursor_stack_name(player, "blueprint") and player.cursor_stack.is_blueprint_setup() or false
end
Event.register(defines.events.on_player_cursor_stack_changed, show_bp_tools)

local function update_blueprint(event)
    local player = game.players[event.player_index]
    if lib.cursor_stack_name(player, "blueprint") and player.cursor_stack.is_blueprint_setup() then
        local from = event.element.parent["picker_bp_tools_from"].elem_value
        local to = event.element.parent["picker_bp_tools_to"].elem_value
        if from and to then
            if game.entity_prototypes[from].fast_replaceable_group == game.entity_prototypes[to].fast_replaceable_group then
                local bp_entities = player.cursor_stack.get_blueprint_entities()
                for _, entity in pairs(bp_entities) do
                    if entity.name == from then
                        entity.name = to
                    end
                end

                player.cursor_stack.set_blueprint_entities(bp_entities)
            else
                player.print({"blueprinter.selections-not-fast-replaceable", {"entity-name."..from}, {"entity-name."..to}})
            end
        else
            player.print({"blueprinter.no-from-or-to"})
        end
    end
end
Gui.on_click("picker_bp_tools_update", update_blueprint)


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
    local blueprint = lib.cursor_stack_name(player, "blueprint")
    if blueprint and blueprint.is_blueprint_setup() then
        local mirrored = get_mirrored_blueprint(blueprint)
        blueprint.set_blueprint_entities(mirrored.entities)
        blueprint.set_blueprint_tiles(mirrored.tiles)
    else
        player.print("Click this button with a blueprint or book with an active blueprint to mirror it")
    end
end
Gui.on_click("picker_bp_tools_mirror", mirror_blueprint)
