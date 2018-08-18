-------------------------------------------------------------------------------
--[MOD CONFIG]--
-------------------------------------------------------------------------------
local PICKER = {}

--Create the Debug option and default to true if this is not a build release
PICKER.DEBUG = true

PICKER.colored_books = {
    -- red = defines.color.red,
    red = {r = 1, b = 1, g = 1, a = 1}
    -- orange = defines.color.orange,
    -- green = defines.color.green,
    -- purple = defines.color.purple,
    -- yellow = defines.color.yellow,
    -- white = defines.color.white,
    -- black = defines.color.black
}

return PICKER
