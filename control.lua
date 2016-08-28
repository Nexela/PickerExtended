local DEBUG = false
script.on_event("picker-select", function(event)
	local player = game.players[event.player_index]
	local creative = player.cheat_mode
	if player.selected then
		
		
		local ip
		local locname = player.selected.localised_name -- use entity name as locname in case we can't find an item.
        local ep = player.selected.prototype
       
        
        if ep and ep.mineable_properties and ep.mineable_properties.minable and ep.mineable_properties.products
        and ep.mineable_properties.products[1].type == "item" then -- If the entity has mineable products.
        	
        	ip = game.item_prototypes[ep.mineable_properties.products[1].name] -- Retrieve first available item prototype
			
			
			if ip and ip.place_result then  -- If the entity has an item with a placeable prototype,
				locname=ip.localised_name or locname
				local n = math.min(player.get_item_count(ip.name), ip.stack_size)
				
				if n > 0 then -- Player has some of this item in their inventory.
					local held_stack = nil
					if player.cursor_stack.valid_for_read then
						-- Player is already holding something, remember what it was:
						held_stack = {name = player.cursor_stack.name, count = player.cursor_stack.count}
						player.cursor_stack.clear()
					end
					-- Put items in the cursor stack:
					player.cursor_stack.set_stack({name = ip.name, count = n})
					-- Remove an equal number from the main inventory:
					player.remove_item({name = ip.name, count = n})
					-- Put whatever was originally being held back into player's inventory:
					if held_stack then
						player.insert(held_stack)
					end
				elseif creative then -- player has cheat_mode enabled just give him 1 if he doesn't have any!
					player.cursor_stack.clear()
					player.cursor_stack.set_stack({name = ip.name, count = 1})
				else  -- None in inventory
					if DEBUG then locname = ip.name end
	                player.print({"msg-no-item-inv", locname})
				end
			
			else -- No prototype found.
				if DEBUG then player.print("No placeable entity prototype found for item "..player.selected.name..".") end
			end
		else
			if DEBUG then player.print("Not a minable entity with item products") end
		end
	
	else -- No entity under cursor; maybe the player doesn't know how to use the picker.
		--if DEBUG then player.print("Place cursor over an object before activating picker tool.") end
	end
end)
