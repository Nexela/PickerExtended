-------------------------------------------------------------------------------
--[[What is it used For]]--
-------------------------------------------------------------------------------
local lib = require("picker.lib")

local function find_technology(recipe, player, show_all)
    for _,tech in pairs(player.force.technologies) do
        if not tech.researched then
            for _, effect in pairs(tech.effects) do
                if effect.type == "unlock-recipe" then
                    if effect.recipe == recipe then
                        if tech.enabled then
                            return tech.localised_name
                        else
                            if show_all then
                                return {"disabled_tech", tech.localised_name}
                            end
                        end
                    end
                end
            end
        end
    end
    if show_all then
        return {"not_found"}
    end
end

local function item_details(item, force)
    local ingredient_in, mined_from, looted_from, product_of = {}, {}, {}, {}
    for _, recipe in pairs(force.recipes) do
        for _, ingredient in pairs(recipe.ingredients) do
            if ingredient.name == item then
                table.insert(ingredient_in, recipe)
                break
            end
        end
        for _, product in pairs(recipe.products) do
            if product.name == item then
                table.insert(product_of, recipe)
                break
            end
        end
    end

    for _, entity in pairs(game.entity_prototypes) do
        if entity.loot then
            for _,loot in pairs(entity.loot) do
                if loot.item == item then
                    table.insert(looted_from, entity)
                    break
                end
            end
        end
        if (entity.type == "resource" or entity.type == "tree") and entity.mineable_properties and entity.mineable_properties.products then
            for _, product in pairs(entity.mineable_properties.products) do
                if product.name == item then
                    table.insert(mined_from, entity)
                    break
                end
            end
        end
    end
    return ingredient_in, mined_from, looted_from, product_of
end

local function get_or_create_used_for_flow(player)
    local flow = player.gui.center["used_for_flow"]
    if flow then
        flow.destroy()
    else
        local held = player.cursor_stack.valid_for_read and player.cursor_stack.name or nil

        flow = player.gui.center.add{type="flow", name="used_for_flow", direction="horizontal"}
        local frame = flow.add{type = "frame", name = "used_for_flow_frame", direction="vertical"}

        ---Header row
        local table = frame.add{type = "table", name = "used_for_flow_frame_table_header", colspan = 5}
        table.add{type = "label", name = "used_for_header_label", caption = "What is it used for:"}
        local search = table.add{type = "textfield", name = "used_for_header_search", text = ""}
        local choose = table.add{type = "choose-elem-button", name = "used_for_header_item", elem_type = "item", item = held}
        local fluid = table.add{type = "sprite-button", name = "used_for_header_fluid", sprite="fluid/water"}
        fluid.style.minimal_width = 34
        fluid.style.minimal_height = 34

        ---Main table
        local main_table = frame.add{type = "table", name = "used_for_flow_frame_table_main", colspan = 4, style = "slot_table_style"}
        main_table.add{type="label", name = "used_for_main_ingredient_in", caption={"used-for.ingredient_in"}}
        main_table.add{type="label", name = "used_for_main_product_of", caption={"used-for.product_of"}}
        main_table.add{type="label", name = "used_for_main_mined_from", caption={"used-for.mined_from"}}
        main_table.add{type="label", name = "used_for_main_looted_from", caption={"used-for.looted_from"}}

        main_table.style.visible = choose.elem_value or false

    end
    return flow
end

local function update_search(event)
    local player = game.players[event.player_index]
    local text = #event.element.text > 2 and event.element.text
    if text then
        text = text:lower():gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"):gsub(" ", "%%-")
        local items = table.filter(game.item_prototypes, function(_, k) return k:lower():find(text) end)
        local fluids = table.filter(game.fluid_prototypes, function (_, k) return k:lower():find(text) end)
    end
end
Gui.on_text_changed("used_for_header_search", update_search)

local function what_is_it_used_for(event)
    local player = game.players[event.player_index]
    get_or_create_used_for_flow(player)
end
script.on_event("picker-used-for", what_is_it_used_for)
