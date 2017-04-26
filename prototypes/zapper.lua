-------------------------------------------------------------------------------
--[[Sounds]]--
-------------------------------------------------------------------------------
local sound_drop = table.deepcopy(data.raw["explosion"]["explosion"])
sound_drop.name = "drop-planner"
for _, animation in pairs(sound_drop.animations) do
    animation.scale = .5
end
for _, variation in pairs(sound_drop.sound.variations) do
    variation.filename = "__base__/sound/fight/laser-1.ogg"
    variation.volume = .5
end
data:extend{sound_drop}
