-------------------------------------------------------------------------------
--[[Train Helpers]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.event.player")
local lib = require("picker.lib")

local ts = {
    wait_station = defines.train_state.wait_station,
    no_path = defines.train_state.no_path,
    no_schedule = defines.train_state.no_schedule,
    manual = defines.train_state.manual_control,
}

local available_ts = {
    [defines.train_state.no_schedule] = true,
    [defines.train_state.no_path] = true,
}

local function available_train(train)
    return available_ts[train.state] or (train.state == ts.wait_station and #train.schedule.records == 1)
end

local function on_player_driving_changed_state(event)
    local player = game.players[event.player_index]
    if player.vehicle and player.vehicle.train and player.mod_settings["picker-auto-manual-train"].value then
        local train = player.vehicle.train
        --Set train to manual
        if #train.get_passengers == 1 and available_train(train) then
            player.vehicle.train.manual_mode = true
            player.vehicle.surface.create_entity{name="flying-text", text = {"vehicles.manual-mode"}, position=player.vehicle.position, color=defines.color.green}
        end
    end
end
Event.register(defines.events.on_player_driving_changed_state, on_player_driving_changed_state)

Event.register("picker-toggle-train-control",
    function(event)
        local player = game.players[event.player_index]
        if player.vehicle and player.vehicle.train then
            player.vehicle.train.manual_mode = not player.vehicle.train.manual_mode
            local text = player.vehicle.train.manual_mode and {"vehicles.manual-mode"} or {"vehicles.automatic-mode"}
            player.vehicle.surface.create_entity{name="flying-text", text = text, position=player.vehicle.position, color=defines.color.green}
        end
    end
)

-------------------------------------------------------------------------------
--[[Car Helpers]]--
-------------------------------------------------------------------------------
local function wheres_my_car(event)
    local player, pdata = Player.get(event.player_index)
    if not event.input and player.vehicle and player.vehicle.type == "car" then
        pdata.last_car = player.vehicle
    elseif player.selected and player.selected.type == "car" then
        pdata.last_car = player.selected
    elseif event.input_name and pdata.last_car and pdata.last_car.valid then
        player.add_custom_alert(pdata.last_car, {type="item", name = pdata.last_car.name}, {"vehicles.dude-wheres-my-car"}, true)
    end
end
Event.register({"picker-dude-wheres-my-car", defines.events.on_player_driving_changed_state}, wheres_my_car)
