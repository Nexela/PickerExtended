require("prototypes/final-fixes/sortinventory")
require("prototypes/final-fixes/makedisabledeq")

-------------------------------------------------------------------------------
--[[Renamer Override]]--
-------------------------------------------------------------------------------
--Gotlags renamer is installed unassign hotkey?
if data.raw["custom-input"]["rename"] then
    data.raw["custom-input"]["rename"].key_sequence = ""
end

if not data.raw["custom-input"] or not data.raw["custom-input"]["toggle-train-control"] then
    data:extend{
        {
            type = "custom-input",
            name = "toggle-train-control",
            key_sequence = "J"
        }
    }
end

local DEBUG = settings.startup["picker-debug"] and settings.startup["picker-debug"].value or false
if DEBUG then
    local developer = require("stdlib.data.developer.developer")
    developer.make_chunk_markers("PickerExtended")
end
