if settings.startup["picker-brighter-lights-player"].value then
    for _, player in pairs(data.raw["player"]) do
        player.light =
        {
            {
                intensity = 0.9,
                size = 150,
            }
        }
    end
end

if settings.startup["picker-brighter-lights-vehicles"].value then
    for _, vehicle in pairs(data.raw["car"]) do
        vehicle.light =
        {
            {
                intensity = 0.9,
                size = 150
            }
        }
    end

    for _, loco in pairs(data.raw["locomotive"]) do
        --Front light is the headlight going forward
        --Back light is the red light at the back
        --stand_by_light is the blue light at the front.
        loco.front_light =
        {
            {
                intensity = 0.9,
                size = 150,
            },
            {
                intensity = 0.9,
                size = 150,
            }
        }
        loco.stand_by_light =
        {
            {
                color = {b=1},
                shift = {-0.6, -3.5},
                size = 2,
                intensity = 0.5
            },
            {
                intensity = 0.9,
                size = 150,
            }
        }
    end
end
