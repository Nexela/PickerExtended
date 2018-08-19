local Data = require('__stdlib__/data/data')

Data.Util.disable_control('rename')
Data.Util.disable_control('ReverseEntireBelt')


local DEBUG = settings.startup['picker-debug'] and settings.startup['picker-debug'].value or false
if DEBUG then
    local developer = require('__stdlib__/data/developer/developer')
    developer.make_test_entities('PickerExtended')
end
