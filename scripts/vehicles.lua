--[[
    vehicles.lua
    Adds honking for trains and vehicles
    Adds vehicle snapping for cars and tanks
    Adds goto selected station hotkey when inside a train
    Adds toggle train mode hotkey
    Adds automatic train mode toggling
]]
local Event = require('stdlib/event/event')
local Player = require('stdlib/event/player')

--[[
	"name": "DelticHonk",
	"title": "Deltic Honk",
	"author": "Michael Cowgill (ChurchOrganist)",
	"contact": "jmcowgill@gmail.com",
	"description": [[
        blatant hack of Gotlag's original Honk mod which changes the sounds to Deltic horns.
        Trains honk when stopping. And starting. And on command.
    ]]
--]

local function attract_enemies(entity, range)
    if settings.global['picker-train-honk-attract'].value then
        for _, enemy in pairs(entity.surface.find_enemy_units(entity.position, range)) do
            enemy.set_command({type = defines.command.attack, target = entity, distraction = defines.distraction.by_damage})
        end
    end
end

local HONK_COOLDOWN = 120

local honk_states = {
    [defines.train_state.on_the_path] = true,
    [defines.train_state.arrive_station] = true,
    [defines.train_state.arrive_signal] = true
}

local ts = {
    wait_station = defines.train_state.wait_station,
    no_path = defines.train_state.no_path,
    no_schedule = defines.train_state.no_schedule,
    manual = defines.train_state.manual_control
}

local available_ts = {
    [defines.train_state.no_schedule] = true,
    [defines.train_state.no_path] = true
}

-- Is the train available for automatic to manual control.
local function available_train(train)
    return available_ts[train.state] or (train.state == ts.wait_station and #train.schedule.records == 1)
end

-- When entering a train if it is in automatic and waiting at a station, or has no schedule or path
-- then set to manual mode.
local function on_player_driving_changed_state(event)
    local player = game.players[event.player_index]
    if player.vehicle and player.vehicle.train and player.mod_settings['picker-auto-manual-train'].value then
        local train = player.vehicle.train
        --Set train to manual
        if #train.passengers == 1 and available_train(train) then
            player.vehicle.train.manual_mode = true
            player.vehicle.surface.create_entity {
                name = 'flying-text',
                text = {'vehicles.manual-mode'},
                position = player.vehicle.position,
                color = defines.color.green
            }
        end
    end
end
Event.register(defines.events.on_player_driving_changed_state, on_player_driving_changed_state)

-- Hotkey for toggling a train between automatic and manual.
local function toggle_train_control(event)
    local player = game.players[event.player_index]
    if player.vehicle and player.vehicle.train and not (player.selected and player.selected.type == 'train-stop') then
        player.vehicle.train.manual_mode = not player.vehicle.train.manual_mode
        local text = player.vehicle.train.manual_mode and {'vehicles.manual-mode'} or {'vehicles.automatic-mode'}
        player.vehicle.surface.create_entity {
            name = 'flying-text',
            text = text,
            position = player.vehicle.position,
            color = defines.color.green
        }
    end
end
Event.register('picker-toggle-train-control', toggle_train_control)

-- Force the train to go to the next station.
local function goto_next_station(event)
    local player = game.players[event.player_index]
    local train = player.vehicle and player.vehicle.train
    if train and not (player.selected and player.selected.type == 'train-stop') then
        local schedule = train.schedule
        local stops = #schedule.records
        if stops > 0 then
            if schedule.current < stops then
                schedule.current = schedule.current + 1
            else
                schedule.current = 1
            end
            train.schedule = schedule
            train.manual_mode = false
            player.vehicle.surface.create_entity {
                name = 'flying-text',
                text = 'Next station',
                position = player.vehicle.position,
                color = defines.color.green
            }
        end
    end
end
Event.register('picker-goto-next-station', goto_next_station)

-- Hotkey while selecting a station will tell the train to go to that station if
-- the train has 1 or fewer stations.
local function goto_station(event)
    local player = game.players[event.player_index]
    if player.selected and player.selected.type == 'train-stop' then
        local train = player.vehicle and player.vehicle.train
        local stop = player.selected
        if train and (train.schedule and #train.schedule.records or 0) <= 1 then
            train.schedule = {
                current = 1,
                records = {
                    [1] = {time_to_wait = 999, station = stop.backer_name}
                }
            }
            train.manual_mode = false
        end
    end
end
Event.register('picker-goto-station', goto_station)

-- Create a custom alert to help find the last car you were in.
local function wheres_my_car(event)
    local player, pdata = Player.get(event.player_index)
    if not event.input and player.vehicle and player.vehicle.type == 'car' then
        pdata.last_car = player.vehicle
    elseif player.selected and player.selected.type == 'car' then
        pdata.last_car = player.selected
    elseif event.input_name and pdata.last_car and pdata.last_car.valid then
        if not pdata.car_finder_beam then
            pdata.car_finder_beam = player.surface.create_entity({
                name = 'picker-pointer-beam',
                position = player.position,
                source = player.character,
                --TODO 0.17 source_position = {entity_position.x, entity_position.y - 0.1},
                target = pdata.last_car,
                duration = 2000000000
            })
        else
            pdata.car_finder_beam.destroy()
            pdata.car_finder_beam = nil
        end
        player.add_custom_alert(pdata.last_car, {type = 'item', name = pdata.last_car.name}, {'vehicles.dude-wheres-my-car'}, true)
    end
end
Event.register({'picker-dude-wheres-my-car', defines.events.on_player_driving_changed_state}, wheres_my_car)

-- Trains honk when in automatic mode when starting or stopping.
local function attempt_honk(event)
    if honk_states[event.train.state] and settings.global['picker-train-honk'].value then
        local honk = settings.global['picker-train-honk-type'].value .. (event.name == defines.train_state.on_the_path and '-start' or '-stop')
        local entity
        if (global.recently_honked[event.train.id] or event.tick) <= event.tick then
            if event.train.speed >= 0 and #event.train.locomotives.front_movers > 0 then
                entity = event.train.locomotives.front_movers[1]
            elseif event.train.speed <= 0 and #event.train.locomotives.back_movers > 0 then
                entity = event.train.locomotives.back_movers[#event.train.locomotives.back_movers]
            end
            global.recently_honked[event.train.id] = event.tick + HONK_COOLDOWN
            if entity then
                entity.surface.play_sound {
                    path = honk,
                    position = entity.position,
                    volume = 1
                }
                attract_enemies(entity, 75)
            end
        end
    end
end
Event.register(defines.events.on_train_changed_state, attempt_honk)

-- Hotkey for manually honking a vehicle train.
local function manual_honk(event)
    local player = game.players[event.player_index]
    local vehicle = player.vehicle
    if vehicle then
        if vehicle.type == 'locomotive' then
            local sound = settings.global['picker-train-honk-type'].value
            if vehicle.train.manual_mode then
                local train = vehicle.train
                if train.speed == 0 then
                    vehicle.surface.play_sound {
                        path = sound .. '-start',
                        position = vehicle.position,
                        volume = 1
                    }
                else
                    vehicle.surface.play_sound {
                        path = sound .. '-stop',
                        position = vehicle.position,
                        volume = 1
                    }
                end
                attract_enemies(vehicle, 75)
            end
        else
            if vehicle.name:find('tank') then
                vehicle.surface.play_sound {
                    path = 'train-stop',
                    position = vehicle.position,
                    volume = 1
                }
            else
                vehicle.surface.play_sound {
                    path = 'car-horn',
                    position = vehicle.position,
                    volume = 1
                }
            end
            attract_enemies(vehicle, 50)
        end
    end
end
Event.register('picker-honk', manual_honk)

--[[
  "name": "VehicleSnap",
  "author": "Zaflis",
  "homepage": "https://forums.factorio.com/viewtopic.php?f=92&t=25501",
  "description": "Snaps movement angle when driving cars or tanks.",
--]]
-- snap amount is the amount of different angles car can drive on,
-- (360 / vehiclesnap_amount) is the difference between 2 axis
-- car will slowly turn towards such angle axis
local SNAP_AMOUNT = 16

local function snap_vehicle(event)
    local player, pdata = Player.get(event.player_index)
    if player and player.vehicle and player.vehicle.type == 'car' and not player.vehicle.train and player.vehicle.speed > 0.1 then
        local o = player.vehicle.orientation
        local last_o = pdata._last_orientation
        if last_o and pdata.snap ~= false and math.abs(o - last_o) < 0.001 then
            local snap_o = math.floor(o * SNAP_AMOUNT + 0.5) / SNAP_AMOUNT
            -- Interpolate with 80% current and 20% target orientation
            o = (o * 4.0 + snap_o) * 0.2
            player.vehicle.orientation = o
        end
        pdata._last_orientation = o
    end
end
Event.register(defines.events.on_player_changed_position, snap_vehicle)

local function toggle_snap(command)
    local player, pdata = Player.get(command.player_index)
    pdata.snap = not pdata.snap
    player.print({'', tostring(pdata.snap)})
end
commands.add_command('snap', 'snapdriving', toggle_snap)

-- INIT -----------------------------------------------------------------------
local function init_and_config()
    global.recently_honked = global.recently_honked or {}
    Player.add_data_all({snap = true})
end
Event.register(Event.core_events.init_and_config, init_and_config)
