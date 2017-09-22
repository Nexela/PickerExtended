require("prototypes/final-fixes/sortinventory")
require("prototypes/final-fixes/makedisabledeq")

if data.raw["custom-input"] and data.raw["custom-input"]["rename"] then
    data.raw["custom-input"]["rename"].enabled = false
end

if data.raw["custom-input"] and data.raw["custom-input"]["toggle-train-control"] then
    data.raw["custom-input"]["toggle-train-control"].enabled = false
end

local DEBUG = settings.startup["picker-debug"] and settings.startup["picker-debug"].value or false
if DEBUG then
    local developer = require("stdlib.data.developer.developer")
    developer.make_test_entities("PickerExtended")
end
