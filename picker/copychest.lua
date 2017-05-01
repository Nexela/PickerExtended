-------------------------------------------------------------------------------
--[[Copy Chest]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.player")
local chest_types = {
    ["container"] = true,
    ["logistic-container"] = true
}

local function copy_chest(event)
    local player, pdata = Player.get(event.player_index)
    local chest = player.selected
    pdata.copy_chest = pdata.copy_chest or {}
    if chest and chest_types[chest.type] then
        if player.force == chest.force and player.can_reach_entity(chest) then
            --local data = global.copy_chest[player.index]
            if not pdata.copy_chest.src or not pdata.copy_chest.src.valid then
                player.print({"picker.copy-src"})
                pdata.copy_chest.src = chest
                pdata.copy_chest.tick = game.tick
            elseif pdata.copy_chest.src.valid then
                player.print({"picker.paste-dest"})
                local src, dest = pdata.copy_chest.src, chest
                --clone inventory 1 to inventory 2
                local src_inv = src.get_inventory(defines.inventory.chest)
                local dest_inv = dest.get_inventory(defines.inventory.chest)
                if src_inv then
                    for i = 1, #src_inv do
                        local stack = src_inv[i]
                        if stack and stack.valid_for_read then
                            local new_stack = {name = stack.name, count = stack.count, health = stack.health, durability = stack.durability}
                            new_stack.ammo = stack.prototype.magazine_size and stack.ammo
                            stack.count = stack.count - dest_inv.insert(new_stack)
                        end
                    end
                end
                --Copy requests/bar here if needed?
                pdata.copy_chest = nil
            end
        end
    else
        pdata.copy_chest = nil
    end
end
script.on_event("picker-copy-chest", copy_chest)
