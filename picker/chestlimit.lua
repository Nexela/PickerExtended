-------------------------------------------------------------------------------
--[[Chest Limiter]]--
-------------------------------------------------------------------------------
local Player = require("stdlib/player")

local match_to_item = {
    ["container"] = true,
    ["logistic-container"] = true,
    ["cargo-wagon"] = true,
}

local function remove_gui(player, frame_name)
    return player.gui.left[frame_name] and player.gui.left[frame_name].destroy()
end

local function get_or_create_chest_limiter_gui(player) -- return gui
    local gui = player.gui.left["chestlimit_frame_main"]
    if not gui then
        gui = player.gui.left.add{type="frame", name="chestlimit_frame_main", direction="horizontal", style="chestlimit_frame_style"}
        gui.add{type="label", name="chestlimit_label", caption={"chestlimit-gui.label-caption"}, tooltip={"chestlimit-tooltip.label-caption"}, style="chestlimit_label_style"}
        gui.add{type="textfield", name = "chestlimit_text_box", text=0, style="chestlimit_text_style"}
        --Up/Down buttons
        local table = gui.add{type="table", name = "chestlimit_table", colspan=1, style="chestlimit_table_style"}
        table.add{type="button", name="chestlimit_btn_up", style="chestlimit_btn_up"}
        table.add{type="button", name="chestlimit_btn_dn", style="chestlimit_btn_dn"}
        --Reset button
        gui.add{type="button", name="chestlimit_btn_reset", style="chestlimit_btn_reset", tooltip={"chestlimit-tooltip.label-reset"}}
    end
    return player.gui.left["chestlimit_frame_main"]
end

local function increase_decrease_reprogrammer(event, change)
    local player, pdata = Player.get(event.player_index)
    if player.cursor_stack.valid_for_read then
        local stack = player.cursor_stack
        local match = (stack.prototype.place_result and stack.prototype.place_result.type) or "not_found"
        if match_to_item[match] then
            pdata.chests = pdata.chests or {}
            local bar = pdata.chests[stack.name] or 0
            --.15 we can get the #slots from prototype
            local text_field = get_or_create_chest_limiter_gui(player)["chestlimit_text_box"]
            --text_field.text = pdata[stack.name] or 0
            if event.element and event.element.name == "chestlimit_text_box" and not type(event.element.text) == "number" then
                return
            elseif event.element and event.element.name == "chestlimit_text_box" then
                bar = tonumber(text_field.text)
            else
                bar = math.max(0, bar + (change or 0))
            end
            pdata.chests[stack.name] = (bar > 0 and bar) or nil
            text_field.text = bar
        end
    else
        remove_gui(player, "chestlimit_frame_main")
    end
end

Gui.on_text_changed("chestlimit_text_box", function (event) increase_decrease_reprogrammer(event, 0) end)
Gui.on_click("chestlimit_btn_up", function (event) increase_decrease_reprogrammer(event, 1) end)
Gui.on_click("chestlimit_btn_dn", function (event) increase_decrease_reprogrammer(event, -1) end)
Gui.on_click("chestlimit_btn_reset", function(event) increase_decrease_reprogrammer(event, -99999999999) end)

local function on_chest_built(event)
    if match_to_item[event.created_entity.type] then
        local _, pdata = Player.get(event.player_index)
        pdata.chests = pdata.chests or {}
        local entity = event.created_entity
        local bar = pdata.chests[entity.name]
        local inventory = entity.get_inventory(defines.inventory.chest)
        if inventory and inventory.hasbar() and bar and bar > 0 then
            inventory.setbar(bar)
        end
    end
end
Event.register(defines.events.on_built_entity, on_chest_built)

Event.register(defines.events.on_player_cursor_stack_changed, increase_decrease_reprogrammer)
