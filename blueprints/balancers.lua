-------------------------------------------------------------------------------
--[[Export Blueprints]]--
-------------------------------------------------------------------------------
--[[
local inv = game.player.cursor_stack.get_inventory(defines.inventory.item_main)
for i=1, #inv do
    local bp = inv[i]
    if bp.valid and bp.valid_for_read then
        game.write_file("Picker/blueprints/"..bp.label..".lua", "return ")
        game.write_file("Picker/blueprints/"..bp.label..".lua", serpent.block(bp.get_blueprint_entities(), {comment=false, sparse=false, nocode=true}), true)
    end
end
--]]

-------------------------------------------------------------------------------
--[[Build Table]]--
-------------------------------------------------------------------------------
local balancers = {}
local count = 0
for i=1, 32 do
    for j=1, 32 do
        local ok, data = pcall(function() return require("blueprints."..i.."x"..j) end)
        if ok then
            balancers[i.."x"..j] = data
            count = count + 1
        end
    end
end
log("Imported "..count.." Balancers")
log(serpent.block(balancers["1x1"], {comment=false, sparse=false}))
return balancers
