-------------------------------------------------------------------------------
--[[FAST FILTER FILL]]--
-------------------------------------------------------------------------------
--Code modified from: "Fast Filter Fill" by: "Keryja, SeaRyanC"

local lib = require("picker.lib")
local INVENTORY_COLUMNS = 10

-------------------------------------------------------------------------------
--[[BUTTONS]]--
-------------------------------------------------------------------------------
--[flow][frame][[table[#btns]][table[#btns]]]
local function get_or_create_filterfill_gui(player, destroy)
    local flow = lib.get_or_create_main_left_flow(player, "picker")

    local filter_frame = flow["filterfill_frame"]
    if destroy then
        return filter_frame and filter_frame.destroy()
    elseif not filter_frame then
        filter_frame = flow.add{type = "frame", name = "filterfill_frame", direction="horizontal", style = "picker_frame"}

        local requests = filter_frame.add{type = "table", name = "filterfill_requests", colspan = 6, style = "picker_table"}
        requests.add{type = "sprite-button", name = "filterfill_requests_btn_bp", sprite = "picker-request-bp", tooltip = {"filterfill.btn-bp"}, style = "picker_buttons"}
        requests.add{type = "sprite-button", name = "filterfill_requests_btn_2x", sprite = "picker-request-2x", tooltip = {"filterfill.btn-2x"}, style = "picker_buttons"}
        requests.add{type = "sprite-button", name = "filterfill_requests_btn_5x", sprite = "picker-request-5x", tooltip = {"filterfill.btn-5x"}, style = "picker_buttons"}
        requests.add{type = "sprite-button", name = "filterfill_requests_btn_10x", sprite = "picker-request-10x", tooltip = {"filterfill.btn-10x"}, style = "picker_buttons"}
        requests.add{type = "sprite-button", name = "filterfill_requests_btn_max", sprite = "picker-request-max", tooltip = {"filterfill.btn-max"}, style = "picker_buttons"}
        requests.add{type = "sprite-button", name = "filterfill_requests_btn_0x", sprite = "picker-request-clear", tooltip = {"filterfill.btn-clear"}, style = "picker_buttons"}

        local filters = filter_frame.add{type = "table", name = "filterfill_filters", colspan = 5, style = "picker_table"}
        filters.add{type = "sprite-button", name = "filterfill_filters_btn_all", sprite = "picker-filters-all", tooltip = {"filterfill.btn-all"}, style = "picker_buttons"}
        filters.add{type = "sprite-button", name = "filterfill_filters_btn_down", sprite = "picker-filters-down", tooltip = {"filterfill.btn-down"}, style = "picker_buttons"}
        filters.add{type = "sprite-button", name = "filterfill_filters_btn_right", sprite = "picker-filters-right", tooltip = {"filterfill.btn-right"}, style = "picker_buttons"}
        filters.add{type = "sprite-button", name = "filterfill_filters_btn_set_all", sprite = "picker-filters-set-all", tooltip = {"filterfill.btn-set-all"}, style = "picker_buttons"}
        filters.add{type = "sprite-button", name = "filterfill_filters_btn_clear_all", sprite = "picker-filters-clear-all", tooltip = {"filterfill.btn-clear-all"}, style = "picker_buttons"}
    end
    return filter_frame
end

-------------------------------------------------------------------------------
--[[FILTERS]]--
-------------------------------------------------------------------------------
-- Filtering: Filter all cells of the opened container with the
-- contents of the player's cursor stack, or the first item in the container,
-- or the first filter in the container
local function filterfill_all(event)
    local player = game.players[event.player_index]
    if player.opened then
        -- Get the contents of the player's cursor stack, or the first cell
        local inventory = player.opened.get_output_inventory()
        local desired = (player.cursor_stack.valid_for_read and player.cursor_stack.name) or lib.get_item_or_filter_at_position(inventory, 1)
        for i = 1, #inventory do
            local current = not event.shift and lib.get_item_or_filter_at_position(inventory, i)
            inventory.set_filter(i, current or desired or nil)
        end
    end
end
Gui.on_click("filterfill_filters_btn_all", filterfill_all)

-- Filtering: Copies the filter settings of each cell to the cell(s) below it
local function filterfill_down(event)
    local player = game.players[event.player_index]
    if player.opened then
        local inventory = player.opened.get_output_inventory()
        local size = #inventory
        local rows = math.ceil(size / INVENTORY_COLUMNS)
        for c = 1, INVENTORY_COLUMNS do
            local desired = lib.get_item_or_filter_at_position(inventory, c)
            for r = 1, rows do
                local i = c + (r - 1) * INVENTORY_COLUMNS
                if i <= size then
                    desired = lib.get_item_or_filter_at_position(inventory, i) or desired
                    inventory.set_filter(i, desired or nil)
                end
            end
        end
    end
end
Gui.on_click("filterfill_filters_btn_down", filterfill_down)

-- Filtering: Copies the filter settings of each cell to the cell(s) to the right of it
local function filterfill_right(event)
    local player = game.players[event.player_index]
    if player.opened then
        local inventory = player.opened.get_output_inventory()
        local size = #inventory
        local rows = math.ceil(size / INVENTORY_COLUMNS)
        --local desired
        for r = 1, rows do
            local desired = lib.get_item_or_filter_at_position(inventory, 1 + (r - 1) * INVENTORY_COLUMNS)
            for c = 1, INVENTORY_COLUMNS do
                local i = c + (r - 1) * INVENTORY_COLUMNS
                if i <= size then
                    desired = lib.get_item_or_filter_at_position(inventory, i) or desired
                    inventory.set_filter(i, desired or nil)
                end
            end
        end
    end
end
Gui.on_click("filterfill_filters_btn_right", filterfill_right)

-- Filtering: Set the filters of the opened container to the contents of each cell
local function filterfill_set_all(event)
    local player = game.players[event.player_index]
    if player.opened then
        local inventory = player.opened.get_output_inventory()
        for i = 1, #inventory do
            local desired = lib.get_item_at_position(inventory, i)
            inventory.set_filter(i, desired or nil)
        end
    end
end
Gui.on_click("filterfill_filters_btn_set_all", filterfill_set_all)

-- Filtering: Clear all filters in the opened container
local function filterfill_clear_all(event)
    local player = game.players[event.player_index]
    if player.opened then
        local inventory = player.opened.get_output_inventory()
        for i = 1, #inventory do
            inventory.set_filter(i, nil)
        end
    end
end
Gui.on_click("filterfill_filters_btn_clear_all", filterfill_clear_all)

-------------------------------------------------------------------------------
--[[REQUESTS]]--
-------------------------------------------------------------------------------
local function requests_fill(event)
    local player = game.players[event.player_index]
    local totalStackRequests = 0
    if player.opened then
        -- Add up how many total stacks we need here
        for i = 1, player.opened.request_slot_count do
            local item = player.opened.get_request_slot(i)
            if item then
                totalStackRequests = totalStackRequests + item.count / game.item_prototypes[item.name].stack_size
            end
        end
        -- Go back and re-set each thing according to its rounded-up stack size
        for i = 1, player.opened.request_slot_count do
            local item = player.opened.get_request_slot(i)
            if item then
                local stacksToRequest = math.ceil(item.count / game.item_prototypes[item.name].stack_size)
                local numberToRequest = stacksToRequest * game.item_prototypes[item.name].stack_size
                player.opened.set_request_slot({ name = item.name, count = numberToRequest }, i)
            end
        end
    end
    event.element.parent.parent.destroy()
    player.opened = nil
end
Gui.on_click("filterfill_requests_btn_max", requests_fill)

local function multiply_filter(event)
    local player = game.players[event.player_index]
    if player.opened then
        local factor = tonumber(event.element.name:match("%d+"))
        for i = 1, player.opened.request_slot_count do
            local existing = player.opened.get_request_slot(i)
            if existing and factor > 0 then
                player.opened.set_request_slot({ name = existing.name, count = math.floor(existing.count * factor) }, i)
            else
                player.opened.clear_request_slot(i)
            end
        end
    end
    event.element.parent.parent.destroy()
    player.opened = nil
end
Gui.on_click("filterfill_requests_btn_%d+x", multiply_filter)

local function blueprint_requests(event)
    --chest "should be non-nil" at this point
    local player = game.players[event.player_index]
    local chest = player.opened
    local chest_inv = chest and chest.get_output_inventory()
    local blueprint = lib.stack_name(player.cursor_stack, "blueprint", true) or (chest_inv and lib.stack_name(chest_inv[1], "blueprint", true))
    if chest then
        if blueprint then
            for i = 1, chest.request_slot_count do
                chest.clear_request_slot(i)
            end
            local i = 1
            table.each(blueprint.cost_to_build,
                function(v,k)
                    if i < chest.request_slot_count then
                        chest.set_request_slot({name = k, count = v}, i)
                        i = i + 1
                    else
                        return true
                    end
                end
            )

            event.element.parent.parent.destroy()
            player.opened = nil
        else
            player.print({"filterfill.no-blueprint"})
        end
    else
        event.element.parent.parent.destroy()
    end
end
Gui.on_click("filterfill_requests_btn_bp", blueprint_requests)

-------------------------------------------------------------------------------
--[[Check inventory]]--
-------------------------------------------------------------------------------
local function check_for_filterable_inventory(event)
    local player = game.players[event.player_index]
    local frame = get_or_create_filterfill_gui(player)
    if player.opened and not frame.style.visible then
        frame["filterfill_requests"].style.visible = player.opened.prototype.logistic_mode == "requester"
        frame["filterfill_filters"].style.visible = player.opened.get_output_inventory() and player.opened.get_output_inventory().supports_filters()
        frame.style.visible = frame["filterfill_filters"].style.visible or frame["filterfill_requests"].style.visible
    elseif not player.opened then
        frame.destroy()
    end
end
Event.register(defines.events.on_selected_entity_changed, check_for_filterable_inventory)
