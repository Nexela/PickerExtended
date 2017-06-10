-------------------------------------------------------------------------------
--[[DATA.LUA]]--
-------------------------------------------------------------------------------
local PICKER = require("config")

-------------------------------------------------------------------------------
--[[Table Mutates]]--
-------------------------------------------------------------------------------
require("stdlib.table")
require("stdlib.string")
require("stdlib.defines.color")
require("stdlib.defines.time")

-------------------------------------------------------------------------------
--[[Picker]]--
-------------------------------------------------------------------------------
require("prototypes.adjustment-pad")
require("prototypes.styles")
require("prototypes.sprites")

require("prototypes.picker")
require("prototypes.tools")
require("prototypes.renamer")
require("prototypes.dollies")
require("prototypes.zapper")
require("prototypes.sortinventory")
require("prototypes.orphans")
require("prototypes.lights")
require("prototypes.notes")

if PICKER.DEBUG then
    local developer = require("stdlib.prototype.prototypes.developer")
    developer.make_chunk_markers("PickerExtended")
end
