-------------------------------------------------------------------------------
--[[What is it used For]]--
-------------------------------------------------------------------------------
--local lib = require("picker.lib")

--luacheck: ignore

local _find_item = function(v, k, text) return k:lower():find(text) and not v.has_flag("hidden") and v or nil end
local _find_fluid = function(v, k, text) return k:lower():find(text) and v or nil end

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
    return {ingredient=ingredient_in, mined=mined_from, loot=looted_from, product=product_of}
end

local function get_or_create_used_for_flow(player, destroy)
    --luacheck: no unused
    local flow = player.gui.center["used_for_flow"]
    if flow and destroy then
        flow.destroy()
    elseif not flow then
        local held = player.cursor_stack.valid_for_read and player.cursor_stack.name or nil

        --[[Main flow/frame]]
        flow = player.gui.center.add{type="flow", name="used_for_flow", direction="horizontal"}
        flow.style.top_padding = 100
        flow.style.minimal_height = 400
        local frame = flow.add{type = "frame", name = "used_for_flow_frame", direction="vertical"}
        frame.style.resize_row_to_width = true
        frame.style.minimal_width = 430
        frame.style.maximal_width = 430

        --[[Header]]
        local table = frame.add{type = "table", name = "uff_table_header", colspan = 5}
        local label = table.add{type = "label", name = "uff_header_label", caption = "What is it used for:"}
        local search = table.add{type = "textfield", name = "uff_header_search", text = ""}
        local choose = table.add{type = "choose-elem-button", name = "uff_header_item", elem_type = "item", item = held, style = "picker_buttons"}
        local fluid = table.add{type = "sprite-button", name = "uff_header_fluid", sprite="", style = "picker_buttons", tooltip = {"used-for.fluids"}}
        local close = table.add{type = "sprite-button", name = "uff_header_close", sprite="picker-close", style = "picker_buttons", tooltip = {"used-for.close"}}

        --[[Search Table]]
        local search_table = frame.add{type = "table", name = "uff_table_search", colspan = 1}
        local search_frame = search_table.add{type = "frame", name = "uff_table_search_frame", direction = "horizontal"}
        search_frame.style.minimal_width = 410
        -- search_frame.style.maximal_height = 120
        local search_scroll = search_frame.add{type = "scroll-pane", name = "uff_table_search_scroll"}
        search_scroll.style.maximal_width = 390
        search_scroll.style.maximal_height = 110
        local items_table = search_scroll.add{type = "table", name = "uff_table_search_scroll_items", colspan = 10}
        search_table.style.visible = false

        --[[Info Table]]
        local main_table = frame.add{type = "table", name = "uff_table_main", colspan = 4, style = "slot_table_style"}
        main_table.add{type="label", name = "uff_main_ingredient_in", caption={"used-for.ingredient_in"}}
        main_table.add{type="label", name = "uff_main_product_of", caption={"used-for.product_of"}}
        main_table.add{type="label", name = "uff_main_mined_from", caption={"used-for.mined_from"}}
        main_table.add{type="label", name = "uff_main_looted_from", caption={"used-for.looted_from"}}

        main_table.style.visible = choose.elem_value or false
        choose.tooltip = choose.elem_value and game.item_prototypes[choose.elem_value].localised_name or {"used-for.items"}

    end
    return flow
end

local function get_main_frame_from(element, name)
    local parent = element
    repeat
        parent = parent.parent and parent.parent or parent
    until not parent.parent or parent.name == name
    return parent
end


-------------------------------------------------------------------------------
--[[Build items/fluids search]]--
-------------------------------------------------------------------------------
local function select_found_item(event)
    local match = event.match
    local cat = event.element.sprite:match("(.+)/")
    event.element.parent.parent.parent.parent.style.visible = false
    local header = event.element.parent.parent.parent.parent.parent["uff_table_header"]
    if cat == "item" then
        header["uff_header_item"].elem_value = match
        header["uff_header_item"].tooltip = game.item_prototypes[match].localised_name
        header["uff_header_fluid"].sprite = ""
        header["uff_header_fluid"].tooltip = {"used-for.fluids"}
    elseif cat == "fluid" then
        header["uff_header_item"].elem_value = nil
        header["uff_header_item"].tooltip = {"used-for.items"}
        header["uff_header_fluid"].sprite = cat.."/"..match
        header["uff_header_fluid"].tooltip = game.fluid_prototypes[match].localised_name
    end
    --BUILD THE REAL LIST FROM SEARCH!!
end
Gui.on_click("^uff_table_search_scroll_items__(.+)", select_found_item)

local function build_search_table(items_table, items)
    for _, child in pairs(items_table.children) do
        child.destroy()
    end
    for _, data in pairs(items) do
        local type = pcall(function() return data.type end) and "item" or "fluid"
        items_table.add{
            type = "sprite-button",
            name = "uff_table_search_scroll_items__"..data.name,
            sprite = type.."/"..data.name,
            style = "picker_buttons",
            tooltip = data.localised_name
        }
    end
    items_table.parent.parent.parent.style.visible = #items_table.children > 0 or false
    --BUILD IF ONLY 1
end

local function build_fluids(event)
    local items_table = event.element.parent.parent["uff_table_search"]["uff_table_search_frame"]["uff_table_search_scroll"]["uff_table_search_scroll_items"]
    event.element.sprite = ""
    event.element.tooltip = {"used-for.fluids"}
    if event.button == defines.mouse_button_type.right then
        build_search_table(items_table, {})
    else
        build_search_table(items_table, game.fluid_prototypes)
    end
    event.element.parent["uff_header_search"].text = ""
end
Gui.on_click("^uff_header_fluid$", build_fluids)

local function build_items(event)
    local items_table = event.element.parent.parent["uff_table_search"]["uff_table_search_frame"]["uff_table_search_scroll"]["uff_table_search_scroll_items"]
    if event.element.elem_value then
        event.element.tooltip = game.item_prototypes[event.element.elem_value].localised_name
        --BUILD THE REAL LIST!
    else
        event.element.tooltip = {"used-for.items"}
    end
    build_search_table(items_table, {})
    event.element.parent["uff_header_search"].text = ""
end
Gui.on_elem_changed("^uff_header_item$", build_items)

-------------------------------------------------------------------------------
--[[Update search]]--
-------------------------------------------------------------------------------
local function update_search(event)
    --local player = game.players[event.player_index]
    local text = event.element.text
    local items_table = event.element.parent.parent["uff_table_search"]["uff_table_search_frame"]["uff_table_search_scroll"]["uff_table_search_scroll_items"]
    if text == " " or text == "" then
        build_search_table(items_table, {})
    elseif text then
        text = text:lower():gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"):gsub(" ", "%%-")
        local items = table.merge(table.map(game.item_prototypes, _find_item, text), table.map(game.fluid_prototypes, _find_fluid, text))
        build_search_table(items_table, items)
    end
    event.element.parent["uff_header_fluid"].tooltip = {"used-for.fluids"}
    event.element.parent["uff_header_fluid"].sprite = ""
    event.element.parent["uff_header_item"].tooltip = {"used-for.items"}
    event.element.parent["uff_header_item"].elem_value = nil
end
Gui.on_text_changed("uff_header_search", update_search)

-------------------------------------------------------------------------------
--[[Create or close main window]]--
-------------------------------------------------------------------------------
local function what_is_it_used_for(event)
    local player = game.players[event.player_index]
    get_or_create_used_for_flow(player, true)
end
Event.register("picker-used-for", what_is_it_used_for)
Gui.on_click("^uff_header_close$", what_is_it_used_for)
