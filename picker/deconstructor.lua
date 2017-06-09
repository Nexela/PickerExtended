-------------------------------------------------------------------------------
--[[Deconstruction Planner Tools]]--
-------------------------------------------------------------------------------
local Player = require("stdlib.event.player")
local lib = require("picker.lib")

local function get_or_create_deconstructor_gui(player)
    local flow = lib.get_or_create_main_left_flow(player, "picker")
    local bpframe = flow["picker_decon_tools"]
    if not bpframe then
        bpframe = flow.add{type = "frame", name = "picker_decon_tools", direction="horizontal", style="filterfill_frame"}
        bpframe.style.minimal_height = 33
        --bpframe.style.maximal_height = 33
        bpframe.style.minimal_width = 33
        bpframe.style.top_padding = 0
        bpframe.style.right_padding = 0
        bpframe.style.left_padding = 0
        bpframe.style.bottom_padding = 0
        bpframe.style.title_right_padding = 0
        bpframe.style.title_left_padding = 0
        for i = 1, 5 do
            local btn = bpframe.add{type = "sprite-button", name = "picker_decon_tools_"..i, sprite = "item/deconstruction-planner"}
            btn.style.minimal_height = 32
            btn.style.maximal_height = 32
            btn.style.minimal_width = 32
            btn.style.maximal_width = 32
            btn.style.top_padding = 0
            btn.style.right_padding = 0
            btn.style.left_padding = 0
            btn.style.bottom_padding = 0
        end
    end
    return bpframe
end

local function deconstruction_planner(event)
    local player, pdata = Player.get(event.player_index)--luacheck: ignore pdata
    local stack = player.cursor_stack
    local frame = get_or_create_deconstructor_gui(player)
    if stack.valid_for_read and stack.name == "deconstruction-planner" then
        frame.style.visible = true
    else
        frame.destroy()
    end
end
Event.register(defines.events.on_player_cursor_stack_changed, deconstruction_planner)
