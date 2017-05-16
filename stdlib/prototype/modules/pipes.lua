
local empty_sprite = require 'stdlib.prototype.modules.core'['empty_sprite']
local Pipes = {}

--Define pipe connection pipe pictures, not all entities use these. This function needs some work though.
function Pipes.pipe_pictures(pictures, shift_north, shift_south, shift_west, shift_east)
    if pictures == "turret" then
        shift_north = shift_north or {0, 0}
        shift_south = shift_south or {0, 0}
        shift_west = shift_west or {0, 0}
        shift_east = shift_east or {0, 0}

        return {
            north =
            {
                filename = "__base__/graphics/entity/pipe/pipe-straight-vertical.png",
                priority = "extra-high",
                width = 44,
                height = 42,
                shift = shift_north
            },
            south =
            {
                filename = "__base__/graphics/entity/pipe/pipe-straight-vertical.png",
                priority = "extra-high",
                width = 44,
                height = 42,
                shift = shift_south
            },
            west =
            {
                filename = "__base__/graphics/entity/pipe/pipe-straight-horizontal.png",
                priority = "extra-high",
                width = 32,
                height = 42,
                shift = shift_west
            },
            east =
            {
                filename = "__base__/graphics/entity/pipe/pipe-straight-horizontal.png",
                priority = "extra-high",
                width = 32,
                height = 42,
                shift = shift_east
            },
        }
    else
        shift_north = shift_north or {0, 0}
        shift_south = shift_south or {0, 0}
        shift_west = shift_west or {0, 0}
        shift_east = shift_east or {0, 0}
        return
        {
            north =
            {
                filename = "__base__/graphics/entity/assembling-machine-2/pipe-north.png",
                priority = "extra-high",
                width = 40,
                height = 45,
                shift = shift_north
            },
            south =
            {
                filename = "__base__/graphics/entity/assembling-machine-2/pipe-south.png",
                priority = "extra-high",
                width = 40,
                height = 45,
                shift = shift_south
            },
            west =
            {
                filename = "__base__/graphics/entity/assembling-machine-2/pipe-west.png",
                priority = "extra-high",
                width = 40,
                height = 45,
                shift = shift_west
            },
            east =
            {
                filename = "__base__/graphics/entity/assembling-machine-2/pipe-east.png",
                priority = "extra-high",
                width = 40,
                height = 45,
                shift = shift_east
            },
        }
    end
end

--return pipe covers for true directions.
function Pipes.pipe_covers(n, s, e, w)
    if (n == nil and s == nil and e == nil and w == nil) then
        n, s, e, w = true, true, true, true
    end
    if n == true then n = {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
            priority = "extra-high",
            width = 44,
            height = 32
        }
    else
        n = empty_sprite
    end
    if e == true then
        e = {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
            priority = "extra-high",
            width = 32,
            height = 32
        }
    else
        e = empty_sprite
    end
    if s == true then
        s =
        {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
            priority = "extra-high",
            width = 46,
            height = 52
        }
    else
        s = empty_sprite
    end
    if w == true then
        w =
        {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
            priority = "extra-high",
            width = 32,
            height = 32
        }
    else
        w = empty_sprite
    end

    return {north = n, south = s, east = e, west = w}
end

return Pipes
