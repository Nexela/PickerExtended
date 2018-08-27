local Data = require('__stdlib__/stdlib/data/data')
Data.Util.disable_control('rename')

if require('config').DEBUG then
    log('Making developer debug entities')
    require('__stdlib__/stdlib/data/developer/developer').make_test_entities()
end
