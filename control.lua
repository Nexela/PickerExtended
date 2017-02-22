local DEBUG = false

script.on_event("picker-select",
    function(event)
        local player = game.players[event.player_index]
        if player.connected and player.selected and player.controller_type ~= defines.controllers.ghost then
            local entity = player.selected
            local creative = player.cheat_mode
            local ip, locname, ep

            if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
                locname = entity.ghost_localised_name
                ep = entity.ghost_prototype
            else
                locname = entity.localised_name -- use entity name as locname in case we can't find an item.
                ep = entity.prototype
            end

            if ep and ep.mineable_properties and ep.mineable_properties.minable and ep.mineable_properties.products
            and ep.mineable_properties.products[1].type == "item" then -- If the entity has mineable products.

                ip = game.item_prototypes[ep.mineable_properties.products[1].name] -- Retrieve first available item prototype

                if ip and (ip.place_result or ip.place_as_tile_result) then -- If the entity has an item with a placeable prototype,
                    locname=ip.localised_name or locname
                    local n = math.min(player.get_item_count(ip.name), ip.stack_size)

                    if n > 0 then --Player has some of this item in their inventory.
                        --Save the current stack (if not using combined Q button)
                        local held_stack
                        if player.cursor_stack.valid_for_read then
                            --Player is already holding something, remember what it was:
                            held_stack = {name = player.cursor_stack.name, count = player.cursor_stack.count, health = player.cursor_stack.health}
                            player.cursor_stack.clear()
                        end
                        --If it is a ghost just revive it.
                        --local max_distance = 12 + player.character_build_distance_bonus + player.force.character_build_distance_bonus
                        if entity.name == "entity-ghost" or entity.name == "tile-ghost" and player.can_reach_entity(entity) then
                            local type, position = entity.name, entity.position
                            local revived, new_entity = entity.revive()
                            if revived and type == "entity-ghost" then
                                game.raise_event(defines.events.on_built_entity, {created_entity=new_entity, player_index=player.index})
                                player.remove_item({name = ip.name, count = 1})
                            end
                            if revived and type == "tile-ghost" then
                                game.raise_event(defines.events.on_player_built_tile, {player_index=player.index, positions={position}})
                                player.remove_item({name = ip.name, count = 1})
                            end
                        else
                            -- Put items in the cursor stack:
                            player.cursor_stack.set_stack({name = ip.name, count = n})
                            -- Remove an equal number from the main inventory:
                            player.remove_item({name = ip.name, count = n})
                            -- Put whatever was originally being held back into player's inventory:
                            if held_stack then
                                player.insert(held_stack)
                            end
                        end
                    elseif creative then -- player has cheat_mode enabled just give him 1 if he doesn't have any!
                        if entity.name == "entity-ghost" or entity.name == "tile-ghost" then
                            local type, position = entity.name, entity.position
                            local revived, new_entity = entity.revive()
                            if revived and type == "entity-ghost" then
                                game.raise_event(defines.events.on_robot_built_entity, {created_entity=new_entity, robot=player})
                            end
                            if revived and type == "tile-ghost" then
                                game.raise_event(defines.events.on_player_built_tile, {robot=player, positions={position}})
                            end
                        else
                            player.cursor_stack.clear()
                            player.cursor_stack.set_stack({name = ip.name, count = 1})
                        end
                    else -- None in inventory
                        if DEBUG then locname = ip.name end
                        if player.force.recipes[ip.name] and remote.interfaces.handyhands and not remote.call("handyhands", "paused", player.index) then
                            if player.get_craftable_count(ip.name) > 0 and player.force.recipes[ip.name].enabled then
                                player.begin_crafting{count=1,recipe=ip.name,silent=true}
                            end
                        else
                            player.print({"msg-no-item-inv", locname})
                        end
                    end
                else -- No prototype found.
                    if DEBUG then player.print("No placeable item prototype found for item "..ep.name..".") end
                end
            else
                if DEBUG then player.print("Not a minable entity with item products") end
            end

        else -- No entity under cursor; maybe the player doesn't know how to use the picker.
            if DEBUG then player.print("Place cursor over an object before activating picker tool.") end
        end
    end
)

local function SpawnGUI(player)
    local frame = player.gui.center.add{type="frame", name="picker_renameFrame"}
    frame.add{type = "button",name = "picker_renamerX",caption = " X ",style = "picker-renamer-button-style"}
    frame.add{type="textfield",name="picker_renameTextfield"}
    player.gui.center.picker_renameFrame.picker_renameTextfield.text =
    global.renamer[player.index].backer_name
    frame.add{type = "button",name = "picker_renamerButton",caption = "OK",style = "picker-renamer-button-style"}
end

script.on_event(defines.events.on_gui_click,
    function(event)
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
    end
)

script.on_event("picker-rename",
    function(event)
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
    end
)
