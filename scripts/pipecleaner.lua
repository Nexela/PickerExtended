-------------------------------------------------------------------------------
--[[Pipe Cleaner]] --
-------------------------------------------------------------------------------
--Loosley based on pipe manager by KeyboardHack

local Event = require('__stdlib__/event/event')
local Player = require('__stdlib__/event/player')

--Start at a drain and clear fluidboxes out that match. find drain connections not cleaned and repeat
local function call_a_plumber(event)
    local plumber = Player.get(event.player_index)
    if plumber.admin and plumber.selected and plumber.selected.fluidbox then
        local rootered = {}
        local toilets = {}
        toilets[plumber.selected.unit_number] = plumber.selected.fluidbox

        local clog = #plumber.selected.fluidbox > 0 and plumber.selected.fluidbox[1] and plumber.selected.fluidbox[1].name
        if clog then
            plumber.print({'pipecleaner.cleaning-clogs', game.fluid_prototypes[clog].localised_name})

            repeat
                local index, drain = next(toilets)
                if index then
                    rootered[index] = drain
                    for i = 1, #drain do
                        if drain[i] and drain[i].name and drain[i].name == clog then
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
        elseif #plumber.selected.fluidbox > 0 then
            plumber.print({'pipecleaner.no-clogs-found'})
        end
    end
end
Event.register('picker-pipe-cleaner', call_a_plumber)
