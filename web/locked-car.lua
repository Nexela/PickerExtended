--luacheck: ignore

local function wheres_my_car(event)
    local player, pdata = Player.get(event.player_index)
    if player.selected and player.selected.type == "car" and (player.selected.last_user == player or player.admin) then
        local car = player.selected
        if global.unlocked_cars[car.unit_number] then
            global.unlocked_cars[car.unit_number] = nil
            player.surface.create_entity{name="flying-text", text = {"vehicles.locked-car"}, color = defines.color.red, position = car.position}
        else
            global.unlocked_cars[car.unit_number] = true
            player.surface.create_entity{name="flying-text", text = {"vehicles.unlocked-car"}, color = defines.color.green, position = car.position}
        end
    elseif pdata.last_car and pdata.last_car.valid then
        player.add_custom_alert(pdata.last_car, {type="item", name = pdata.last_car.name}, {"vehicles.dude-wheres-my-car"}, true)
    end
end
script.on_event("picker-dude-wheres-my-car", wheres_my_car)


local function car_thief(event)
    local player, pdata = Player.get(event.player_index)
    if player.vehicle and player.vehicle.type == "car" then
        local car = player.vehicle
        if global.unlocked_cars[car.unit_number] or (car.last_user ~= player and (not player.admin or not settings.global["picker-car-protection"].value)) then
            car.passenger = nil
            player.teleport(player.position)
            local text = {"vehicles.car-thief", car.name, car.last_user.name}
            player.surface.create_entity{name="flying-text", text = text, color = defines.color.yellow, position = player.position}
        else
            pdata.last_car = car
        end
    end
end
Event.register(defines.events.on_player_driving_changed_state, car_thief)

local function lock_car(event)
    local player = game.players[event.player_index]
    local car = player.selected and player.selected.type == "car" and player.selected
    local last_car = event.last_entity and event.last_entity.type == "car" and event.last_entity
    if car or last_car and settings.global["picker-car-protection"].value then
        if car and (player == car.last_user or player.admin) then
            car.minable = true
        elseif last_car and player == last_car.last_user and not global.unlocked_cars[last_car.unit_number] then
            last_car.minable = false
        end
    end
end
Event.register(defines.events.on_selected_entity_changed, lock_car)

data:extend{
    {
    type = "bool-setting",
    name = "picker-car-protection",
    setting_type = "runtime-global",
    default_value = true,
    order = "picker-a[car-protection]-a",
    },
}

--[[
picker-car-protection=Lock cars per user
car-thief=This __1__ is locked by __2__
unlocked-car=Unlocked
locked-car=Locked
picker-car-protection=Vehicles can only be entered or mined by the person who created them unless left unlocked.

--]]
