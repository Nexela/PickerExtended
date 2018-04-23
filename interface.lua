local interface = {}

interface['write_global'] = function()
    game.write_file(script.mod_name .. '/global.lua', serpent.block(global, {comment = false, nocode = true}), false)
end

interface['console'] = require('stdlib/utils/scripts/console')

return interface
