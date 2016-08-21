--DEBUG=true
script.on_event("picker-select", function(event)
	p = game.players[event.player_index]
	if p.selected then
		item, locname = p.selected.name, p.selected.localised_name
		if item == "straight-rail" or item == "curved-rail" then item = "rail" end
		--if item then p.print("Item name is "..item..".") end
		ip = game.item_prototypes[item]
		if ip then  -- If the item has a prototype, then it's something we can pick up.
			if DEBUG then 
				p.print("Item="..item)
				log("Item=" ..item)
			end
			n = math.min(p.get_item_count(item), ip.stack_size)
			if n > 0 then
				-- Player has some of this item in their inventory.
				held_stack = nil
				if p.cursor_stack.valid_for_read then
					-- Player is already holding something, remember what it was:
					held_stack = {name = p.cursor_stack.name, count = p.cursor_stack.count}
					p.cursor_stack.clear()
				end
				-- Put items in the cursor stack:
				p.cursor_stack.set_stack({name = item, count = n})
				-- Remove an equal number from the main inventory:
				p.remove_item({name = item, count = n})
				-- Put whatever was originally being held back into player's inventory:
				if held_stack then
					p.insert(held_stack)
				end
			else
				if locname and type(locname) == "string"  then p.print("No "..locname.." in inventory.") else p.print("No " ..item.." in inventory.") end
			end
		else
			--p.print("No prototype for item "..item..".")
		end
	else
		-- No entity under cursor; maybe the player doesn't know how to use the picker.
		-- p.print("Place cursor over an object before activating picker tool.")
	end
end)
