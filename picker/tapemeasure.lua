-------------------------------------------------------------------------------
--[[Tape Measure]]--
-------------------------------------------------------------------------------
local Area = require("stdlib.area.area")
local Position = require("stdlib.area.position")

local function measure_area(event)
    if event.item == "picker-tape-measure" then
        local player = game.players[event.player_index]
        local area
        if event.name == defines.events.on_player_selected_area then
            area = Area.round_to_integer(event.area)
        else
            area = Area.tile_center_points(event.area)
        end
        local size, width, height = Area.size(area)
        player.print(Area.tostring(area) .. " Center = "..Position.tostring(Area.center(area)))
        player.print("Size = "..size.." Width = "..width.." Height = "..height)
    end
end
Event.register({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, measure_area)
