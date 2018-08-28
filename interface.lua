local interface = {}
local Event = require('__stdlib__/stdlib/event/event')

interface['write_global'] = function()
    game.write_file(script.mod_name .. '/global.lua', serpent.block(global, {comment = false, nocode = true}), false)
    Event.dump_data()
end

interface['dump_all'] = function()
    for inter in pairs(remote.interfaces) do
        if remote.interfaces[inter]['write_global'] then
            remote.call(inter, 'write_global')
        end
    end
end

return interface
