-------------------------------------------------------------------------------
--[[Picker Crafter]]--
-------------------------------------------------------------------------------
--Return localised name, entity_prototype, and item_prototype
local function get_placeable_item(entity)
    local locname, ep
    if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
        locname = entity.ghost_localised_name
        ep = entity.ghost_prototype
    else
        locname = entity.localised_name
        ep = entity.prototype
    end
    if ep and ep.mineable_properties and ep.mineable_properties.minable and ep.mineable_properties.products
    and ep.mineable_properties.products[1].type == "item" then -- If the entity has mineable products.
        local ip = game.item_prototypes[ep.mineable_properties.products[1].name] -- Retrieve first available item prototype
        if ip and (ip.place_result or ip.place_as_tile_result) then -- If the entity has an item with a placeable prototype,
            return (ip.localised_name or locname), ep, ip
        end
        return locname, ep
    end
end

local function picker_crafter(event)
    local player = game.players[event.player_index]
    if player.selected then
        local _, _, ip = get_placeable_item(player.selected)
        if ip then
            player.begin_crafting{count = 1, recipe = ip.name, silent = false}
        end
    end
end
script.on_event("picker-crafter", picker_crafter)
