require("prototypes/final-fixes/sortinventory")
require("prototypes/final-fixes/makedisabledeq")

-------------------------------------------------------------------------------
--[[Renamer Override]]--
-------------------------------------------------------------------------------
--Gotlags renamer is installed unassign hotkey?
--Also set to consuming all so only 1 fires.
if data.raw["custom-input"]["rename"] then
    data.raw["custom-input"]["rename"].key_sequence = ""
    data.raw["custom-input"]["rename"].key_sequence = "all"
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
