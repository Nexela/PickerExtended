--luacheck: ignore
--Patch loader speeds to saturate a belt.
--based on Loader Speed Patch by Optera, These values should overwrite
if patch_loader_speed then
  for _, loader in pairs(data.raw["loader"]) do
    if loader.name == "loader" then
      loader.speed = 0.04 -- default 0.03125
    elseif loader.name == "fast-loader" then
      loader.speed = 0.80 -- default 0.0625
    elseif loader.name == "express-loader" then
      loader.speed = 0.12 -- default 0.09375
    elseif loader.name == "faster-loader" then
      loader.speed = 0.16 -- default 0.125
    elseif loader.name == "extremely-fast-loader" then
      loader.speed = 0.20 -- default 0.15625
    end
  end
  log("#4 Updating Loader Speeds")
end


--Adjust tree collision size
--based on tree-collision Mod
if smaller_tree_collision then
  log("#3 Updating Tree Collision")
  for _,tree in pairs(data.raw["tree"]) do
    tree.collision_box = {{-0.05, -0.05}, {0.05, 0.05}}
  end
end

if use_Nexela_Settings and data.raw.item["solid-alginic-acid"] then
	data.raw.item["solid-alginic-acid"].fuel_value = "12MJ"
end
