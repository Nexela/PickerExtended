-------------------------------------------------------------------------------
--[[Adjustment Pad]]--
-------------------------------------------------------------------------------
local Pad = {}
local lib = require("picker.lib")

Event.adjustment_pad = script.generate_event_name()
script.on_event("adjustment-pad-increase", function(event) script.raise_event(Event.adjustment_pad, event) end)
script.on_event("adjustment-pad-decrease", function(event) script.raise_event(Event.adjustment_pad, event) end)

function Pad.remove_gui(player, frame_name, flow_name)
    flow_name = flow_name or "picker"
    local main_flow = lib.get_or_create_main_left_flow(player, flow_name)
    return main_flow[frame_name] and main_flow[frame_name].destroy()
end

function Pad.get_or_create_adjustment_pad(player, name, flow_name) -- return gui
    name = name or "adjustment_pad"
    flow_name = flow_name or "picker"
    local main_flow = lib.get_or_create_main_left_flow(player, flow_name)

    local gui = main_flow[name.."_frame_main"]
    if not gui then
        gui = main_flow.add{type="frame", name=name.."_frame_main", direction="horizontal", style="adjustment_pad_frame_style"}
        gui.add{type="label", name=name.."_label", caption={name.."-gui.label-caption"}, tooltip={name.."-tooltip.label-caption"}, style="adjustment_pad_label_style"}
        gui.add{type="textfield", name = name.."_text_box", text=0, style="adjustment_pad_text_style"}
        --Up/Down buttons
        local table = gui.add{type="table", name = name.."_table", colspan=1, style="adjustment_pad_table_style"}
        table.add{type="button", name=name.."_btn_up", style="adjustment_pad_btn_up"}
        table.add{type="button", name=name.."_btn_dn", style="adjustment_pad_btn_dn"}
        --Reset button
        gui.add{type="button", name=name.."_btn_reset", style="adjustment_pad_btn_reset", tooltip={name.."-tooltip.label-reset"}}
    end
    return main_flow[name.."_frame_main"]
end

MOD.interfaces["get_adjustment_pad_id"] = function() return(Event.adjustment_pad) end
MOD.interfaces["get_or_create_adjustment_pad"] = Pad.get_or_create_adjustment_pad

return Pad
