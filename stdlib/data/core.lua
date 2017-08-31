local Core = require 'stdlib/core'

--Quick to use empty sprite
function Core.empty_picture()
    return {
        filename = "__core__/graphics/empty.png",
        priority = "extra-high",
        width = 1,
        height = 1
    }
end

--Quick to use empty animation
function Core.empty_pictures()
    local empty = Core.empty_picture()
    return {
        filename = empty.filename,
        width = empty.width,
        height = empty.height,
        line_length = 1,
        frame_count = 1,
        shift = { 0, 0},
        animation_speed = 1,
        direction_count=1
    }
end

function Core.empty_animations()
    return {
        Core.empty_pictures()
    }
end

function Core.empty_connection_points(count)
    local points = {}
    for i = 1, count or 1, 1 do
        points[i] = {
            shadow =
            {
                copper = {0, 0},
                green = {0, 0},
                red = {0, 0}
            },
            wire =
            {
                copper = {0, 0},
                green = {0, 0},
                red = {0, 0}
            }
        }
    end
    return points
end
-- render layers
----"tile-transition", "resource", "decorative", "remnants", "floor", "transport-belt-endings", "corpse", "floor-mechanics", "item", "lower-object", "object", "higher-object-above",
----"higher-object-under", "wires", "lower-radius-visualization", "radius-visualization", "entity-info-icon", "explosion", "projectile", "smoke", "air-object", "air-entity-info-con",
----"light-effect", "selection-box", "arrow", "cursor"

-- collision masks
----"ground-tile", "water-tile", "resource-layer", "floor-layer", "item-layer", "object-layer", "player-layer", "ghost-layer", "doodad-layer", "not-colliding-with-itself"

return Core
