-------------------------------------------------------------------------------
--[[Pipe Cleaner]] --
-------------------------------------------------------------------------------
--Loosley based on pipe manager by KeyboardHack
local Event = require('__stdlib__/stdlib/event/event')
local table = require('__stdlib__/stdlib/utils/table')

--Start at a drain and clear fluidboxes out that match. find drain connections not cleaned and repeat
local function call_a_plumber(event)
    if event.item == 'picker-pipe-cleaner' then
        local plumber = game.players[event.player_index]
        --TODO alt_selected_area
        if event.name == defines.events.on_player_selected_area then
            local clog
            local rootered = {}
            local toilets = {}
            local amount = 0
            -- Find the first fluidbox with a liquid
            for _, toilet in pairs(event.entities) do
                clog = toilet.fluidbox and #toilet.fluidbox > 0 and toilet.fluidbox[1] and toilet.fluidbox[1].name
                if clog then
                    toilets[toilet.unit_number] = toilet.fluidbox
                    break
                end
            end
            if clog then
                repeat
                    local index, drain = next(toilets)
                    if index then
                        rootered[index] = drain
                        for i = 1, #drain do
                            if drain[i] and drain[i].name and drain[i].name == clog then
                                amount = amount + drain[i].amount
                                drain[i] = nil
                                table.each(
                                    drain.get_connections(i),
                                    function(v)
                                        if not rootered[v.owner.unit_number] then
                                            toilets[v.owner.unit_number] = v
                                        end
                                    end
                                )
                            end
                        end
                        toilets[index] = nil
                        if drain.owner.last_user then
                            drain.owner.last_user = plumber
                        end
                    end
                until not index
                plumber.print({'pipecleaner.cleaning-clogs', amount, game.fluid_prototypes[clog].localised_name})
            else
                plumber.print({'pipecleaner.no-clogs-found'})
            end
        end
    end
end
Event.register({defines.events.on_player_selected_area, defines.events.on_player_alt_selected_area}, call_a_plumber)
