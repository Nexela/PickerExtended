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

        if ip and ip.place_result then -- If the entity has an item with a placeable prototype,
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
          else -- None in inventory
            if DEBUG then locname = ip.name end
						if remote.interfaces.handyhands and remote.interfaces.handyhands.paused and not remote.call("handyhands", "paused", player.index) then
							--player.print("HandyHands not paused")
							if player.get_craftable_count(ip.name) > 0  and player.force.recipes[ip.name].enabled then
								player.begin_crafting{count=1,recipe=ip.name,silent=true}
							end
						else
            	player.print({"msg-no-item-inv", locname})
						end
          end

        else -- No prototype found.
          if DEBUG then player.print("No placeable entity prototype found for item "..player.selected.name..".") end
        end
      else
        if DEBUG then player.print("Not a minable entity with item products") end
      end

    else -- No entity under cursor; maybe the player doesn't know how to use the picker.
      if DEBUG then player.print("Place cursor over an object before activating picker tool.") end
    end
  end)

local function SpawnGUI(player)
  -- if not player.gui.center.renameFrame then
  local frame = player.gui.center.add{type="frame", name="picker_renameFrame"}
  frame.add{type = "button",name = "picker_renamerX",caption = " X ",style = "picker-renamer-button-style"}
  frame.add{type="textfield",name="picker_renameTextfield"}
  player.gui.center.picker_renameFrame.picker_renameTextfield.text =
  global.renamer[player.index].backer_name
  frame.add{type = "button",name = "picker_renamerButton",caption = "OK",style = "picker-renamer-button-style"}
  -- end
end

script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "picker_renamerX" then
      game.players[event.player_index].gui.center.picker_renameFrame.destroy()
    elseif event.element.name == "picker_renamerButton" then
      local player = game.players[event.player_index]
      if global.renamer[event.player_index].valid then
        global.renamer[event.player_index].backer_name =
        player.gui.center.picker_renameFrame.picker_renameTextfield.text
      end
      player.gui.center.picker_renameFrame.destroy()
    end
  end)

script.on_event("picker-rename", function(event)
    if game.players[event.player_index].gui.center.picker_renameFrame then
      game.players[event.player_index].gui.center.picker_renameFrame.destroy()
    end
    local selection = game.players[event.player_index].selected
    if selection then
      if selection.supports_backer_name() then
        if not global.renamer then global.renamer = {} end
        global.renamer[event.player_index] = selection
        SpawnGUI(game.players[event.player_index])
      else
        game.players[event.player_index].print({"selection-not-renamable"})
      end
    end
  end)
