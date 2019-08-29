-------------------------------------------------------------------------------
--[Tape Measure]--
-------------------------------------------------------------------------------
local Area = require('__stdlib__/stdlib/area/area')
local Color = require('__stdlib__/stdlib/utils/color')
local Event = require('__stdlib__/stdlib/event/event')

local function measure_area(event)
    if event.item ~= 'picker-tape-measure' then return end
    local player = game.players[event.player_index]
    local surface_index = player.surface.index
    local is_alt_selection = event.name == defines.events.on_player_alt_selected_area
    -- retrieve mod settings
    local player_mod_settings = player.mod_settings
    local mod_settings = {}
	mod_settings.draw_tilegrid_on_ground = player_mod_settings['picker-draw-tilegrid-on-ground'].value
    mod_settings.tilegrid_line_width = player_mod_settings['picker-tilegrid-line-width'].value
    mod_settings.tilegrid_clear_delay = player_mod_settings['picker-tilegrid-clear-delay'].value * 60
    mod_settings.tilegrid_group_divisor = player_mod_settings['picker-tilegrid-group-divisor'].value
	mod_settings.tilegrid_split_divisor = player_mod_settings['picker-tilegrid-split-divisor'].value
	mod_settings.tilegrid_background_color = Color.set(defines.color[player_mod_settings['picker-tilegrid-background-color'].value], 0.6)
	mod_settings.tilegrid_border_color = Color.set(defines.color[player_mod_settings['picker-tilegrid-border-color'].value])
	mod_settings.tilegrid_label_color = Color.set(defines.color[player_mod_settings['picker-tilegrid-label-color'].value], 0.8)
	mod_settings.tilegrid_div_color = {}
	mod_settings.tilegrid_div_color[1] = Color.set(defines.color[player_mod_settings['picker-tilegrid-color-1'].value])
	mod_settings.tilegrid_div_color[2] = Color.set(defines.color[player_mod_settings['picker-tilegrid-color-2'].value])
	mod_settings.tilegrid_div_color[3] = Color.set(defines.color[player_mod_settings['picker-tilegrid-color-3'].value])
	mod_settings.tilegrid_div_color[4] = Color.set(defines.color[player_mod_settings['picker-tilegrid-color-4'].value])
	mod_settings.label_primary_size = 2
	mod_settings.label_secondary_size = 1
	mod_settings.label_primary_offset = 1.1
	mod_settings.label_secondary_offset = 0.6
    -- generate area
    local area = Area(event.area):normalize():ceil():corners()
    area.size,area.width,area.height = area:size()
	area.midpoints = Area.center(area)
	-- calculate tilegrid divisors
	local tilegrid_divisors = {}
	if is_alt_selection then
		tilegrid_divisors[1] = {x = 1, y = 1 }
		tilegrid_divisors[2] = {x = (area.width > 1 and (area.width / mod_settings.tilegrid_split_divisor) or area.width), y = (area.height > 1 and (area.height / mod_settings.tilegrid_split_divisor) or area.height)}
		tilegrid_divisors[3] = {x = (area.width > 1 and (area.midpoints.x - area.left_top.x) or area.width), y = (area.height > 1 and (area.midpoints.y - area.left_top.y) or area.height)}
	else
		for i=1,4 do
			table.insert(tilegrid_divisors, { x = mod_settings.tilegrid_group_divisor ^ (i - 1), y = mod_settings.tilegrid_group_divisor ^ (i - 1) })
		end
	end
	-- log dimensions to chat, if desired
	if player_mod_settings['picker-log-selection-area'].value == true then player.print('Dimensions: ' .. area.width .. 'x' .. area.height) end

    -- --------------------------------------------------
    -- DRAW TILEGRID
    
    -- locals to improve performance!
    local draw_rectangle = rendering.draw_rectangle
    local draw_line = rendering.draw_line
    local draw_text = rendering.draw_text

    -- background
    draw_rectangle {
        color = mod_settings.tilegrid_background_color,
        filled = true,
        left_top = {area.left_top.x,area.left_top.y},
        right_bottom = {area.right_bottom.x,area.right_bottom.y},
        surface = surface_index,
        time_to_live = mod_settings.tilegrid_clear_delay,
        draw_on_ground = mod_settings.draw_tilegrid_on_ground,
        players = { player }
	}
	
	-- grids
	for k,t in pairs(tilegrid_divisors) do
		for i=t.x,area.width,t.x do
			draw_line {
				color = mod_settings.tilegrid_div_color[k],
				width = mod_settings.tilegrid_line_width,
				from = {(area.left_top.x + i),area.left_top.y},
				to = {(area.left_bottom.x + i),area.left_bottom.y},
				surface = surface_index,
				time_to_live = mod_settings.tilegrid_clear_delay,
				draw_on_ground = mod_settings.draw_tilegrid_on_ground,
				players = { player }
			}
		end

		for i=t.y,area.height,t.y do
			draw_line {
				color = mod_settings.tilegrid_div_color[k],
				width = mod_settings.tilegrid_line_width,
				from = {area.left_top.x,(area.left_top.y + i)},
				to = {area.right_top.x,(area.left_top.y + i)},
				surface = surface_index,
				time_to_live = mod_settings.tilegrid_clear_delay,
				draw_on_ground = mod_settings.draw_tilegrid_on_ground,
				players = { player }
			}
		end
	end

    -- border
    draw_rectangle {
        color = mod_settings.tilegrid_border_color,
        width = mod_settings.tilegrid_line_width,
        filled = false,
        left_top = {area.left_top.x,area.left_top.y},
        right_bottom = {area.right_bottom.x,area.right_bottom.y},
        surface = surface_index,
        time_to_live = mod_settings.tilegrid_clear_delay,
        draw_on_ground = mod_settings.draw_tilegrid_on_ground,
        players = { player }
	}

	-- labels
	if area.height > 1 then
        draw_text {
            text = area.height,
            surface = surface_index,
            target = {(area.left_top.x - 1.1), area.midpoints.y},
            color = mod_settings.tilegrid_label_color,
            alignment = 'center',
            scale = 2,
            orientation = 0.75,
            time_to_live = mod_settings.tilegrid_clear_delay,
            players = { player }
        }
	end
	
    if area.width > 1 then
        draw_text {
            text = area.width,
            surface = surface_index,
            target = {area.midpoints.x, (area.left_top.y - 1.1)},
            color = mod_settings.tilegrid_label_color,
            alignment = 'center',
            scale = 2,
            time_to_live = mod_settings.tilegrid_clear_delay,
            players = { player }
        }
	end
end
Event.register({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, measure_area)

-------------------------------------------------------------------------------
--[Screenshot Camera]--
-------------------------------------------------------------------------------
--Code modified from "Screenshot camera", by "aaargha",
--[[
Take a screenshot and save it to a file.
Parameters
Table with the following fields:
player :: string or LuaPlayer or uint (optional)
by_player :: string or LuaPlayer or uint (optional): If defined, the screenshot will only be taken for this player.
position :: Position (optional)
resolution :: Position (optional): Maximum allowed resolution is 16384x16384 (resp. 8196x8196 when anti_alias is true), but maximum recommended resolution is 4096x4096 (resp. 2048x2048).
zoom :: double (optional)
path :: string (optional): Path to save the screenshot in
show_gui :: boolean (optional): Include game GUI in the screenshot?
show_entity_info :: boolean (optional): Include entity info (alt-mode)?
anti_alias :: boolean (optional): Render in double resolution and scale down (including GUI)?
--]]
local function paparazzi(event)
    if event.item == 'picker-camera' then
        local player = game.players[event.player_index]
        local opt = player.mod_settings
        local _zoom = opt['picker-camera-zoom'].value
        local _aa = opt['picker-camera-aa'].value
        local _gui = opt['picker-camera-gui'].value
        local _alt_info = event.name == defines.events.on_player_alt_selected_area
        local _path = 'Screenshots/' .. (_alt_info and 'Alt/' or '') .. event.tick .. '.png'

        local pix_per_tile = 32 * _zoom
        local max_dist = (_aa and 256 / _zoom) or 512 / _zoom

        local area = Area(event.area):ceil()
        local diffx = area.right_bottom.x - area.left_top.x
        local diffy = area.right_bottom.y - area.left_top.y

        local res = {x = diffx * pix_per_tile, y = diffy * pix_per_tile}
        local pos = {x = area.left_top.x + diffx / 2, y = area.left_top.y + diffy / 2}

        if res.x >= 1 and res.y >= 1 then
            --use another mod to handle larger screenshots if available
            if remote.interfaces['LargerScreenshots'] and remote.interfaces['LargerScreenshots']['screenshot'] then
                remote.call(
                    'LargerScreenshots',
                    'screenshot',
                    {
                        player = player,
                        by_player = player,
                        position = pos,
                        size = {x = diffx, y = diffy},
                        zoom = _zoom,
                        path_prefix = 'Picker',
                        show_gui = _gui,
                        show_entity_info = _alt_info,
                        anti_alias = _aa
                    }
                )
            else
                if diffx <= max_dist then
                    if diffy <= max_dist then
                        player.print('Taking screenshot of selected area')
                        game.take_screenshot {
                            player = player,
                            by_player = player,
                            position = pos,
                            resolution = res,
                            zoom = _zoom,
                            path = _path,
                            show_gui = _gui,
                            show_entity_info = _alt_info,
                            anti_alias = _aa
                        }
                    else
                        player.print('Area too tall, max is ' .. max_dist .. ' tiles')
                    end
                else
                    player.print('Area too wide, max is ' .. max_dist .. ' tiles')
                end
            end
        end
    end
end
Event.register({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, paparazzi)
