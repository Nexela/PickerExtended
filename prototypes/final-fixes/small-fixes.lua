------------------------------------------------------------------------------
--[[SMALL FIXES]]--
-------------------------------------------------------------------------------
local settings = settings["startup"]
local player = data.raw["player"]["player"]
local utility_sprites = data.raw["utility-sprites"].default
-------------------------------------------------------------------------------
--[[Fast Replace UG belts]]--
-------------------------------------------------------------------------------
if settings["picker-fast-replace-ug"].value then
    for _, ug in pairs(data.raw["underground-belt"]) do
        ug.fast_replaceable_group = "transport-belt"
    end
end
-------------------------------------------------------------------------------
--[[Renamer Override]]--
-------------------------------------------------------------------------------
--Gotlags renamer is installed unassign hotkey?
--Also set to consuming all so only 1 fires.
if data.raw["custom-input"]["rename"] then
    data.raw["custom-input"]["rename"].key_sequence = ""
    data.raw["custom-input"]["rename"].key_sequence = "all"
end
-------------------------------------------------------------------------------
--[[Fix Bots]]--
-------------------------------------------------------------------------------
--Make construction and logistic robots unminable (no plucking them from the air)
--Also removes them from going to the quickbar.
--Based on Small-Fixes
local types = {"construction-robot", "logistic-robot"}
local bots = {}

--Make them un-minable
for _, bot in pairs(types) do
    for _, entity in pairs(data.raw[bot]) do
        bots[entity.name] = true
        if bot == "construction-robot" and settings["picker-unminable-construction-robots"].value then
            entity.minable = nil
        end
        if bot == "logistic-robot" and settings["picker-unminable-logistic-robots"].value then
            entity.minable = nil
        end
    end
end

--Remove goes-to-quickbar
for _, item in pairs(data.raw["item"]) do
    if item.place_result and bots[item.place_result] then
        local remove
        for idx, flag in pairs(item.flags) do
            if flag == "goes-to-quickbar" then
                remove = idx
                break
            end
        end
        if remove then table.remove(item.flags, remove) end
    end
end

-------------------------------------------------------------------------------
--[[Requester Paste Multiplier]]--
-------------------------------------------------------------------------------
--From small-fixes mod
--change requester paste multiplier for anything at default (10)
local value = settings["picker-requester-paste-multiplier"].value or 10
for _, recipe in pairs(data.raw["recipe"]) do
    if not recipe.requester_paste_multiplier or recipe.requester_paste_multiplier == 10 then
        recipe.requester_paste_multiplier = value
    end
end

-------------------------------------------------------------------------------
--[[Corpse-be-gone]]--
-------------------------------------------------------------------------------
--Adjust coprse time to remove corpses quicker
--only change TTL if TTL is already at default.
--Based off the stumps-be-gone mod
local corpse_time = settings["picker-corpse-time"].value
for _, corpse in pairs(data.raw["corpse"]) do
    if corpse.time_before_removed == 54000 then corpse.time_before_removed = corpse_time end
end
data.raw["character-corpse"]["character-corpse"].time_to_live = settings["picker-player-corpse-time"].value

-------------------------------------------------------------------------------
--[[Starting inventory size]]--
-------------------------------------------------------------------------------
local inv_size = settings["picker-inventory-size"].value
--Modify player inventory size
if player.inventory_size < inv_size then
    player.inventory_size = inv_size
end

-------------------------------------------------------------------------------
--[[Reacher]]--
-------------------------------------------------------------------------------
player.build_distance = settings["picker-reacher-build-distance"].value
player.reach_distance = settings["picker-reacher-reach-distance"].value
player.reach_resource_distance = settings["picker-reacher-reach-resource-distance"].value
player.drop_item_distance = settings["picker-reacher-drop-item-distance"].value
player.loot_pickup_distance = settings["picker-reacher-loot-pickup-distance"].value
player.item_pickup_distance = settings["picker-reacher-item-pickup-distance"].value

-------------------------------------------------------------------------------
--[[Smaller Tree Boxes]]--
-------------------------------------------------------------------------------
if settings["picker-smaller-tree-box"].value then
    for _, stupid_tree in pairs(data.raw["tree"]) do
        if stupid_tree.collision_box then
            stupid_tree.collision_box = {{-0.05, -0.05}, {0.05, 0.05}}
        end
    end
end

-------------------------------------------------------------------------------
--[[Roundup]]--
-------------------------------------------------------------------------------
if settings["picker-roundup"].value then
    if data.raw["tile"]["concrete"] then
        data.raw["tile"]["concrete"].decorative_removal_probability = 1
    end
end

-------------------------------------------------------------------------------
--[[Planner Cleaner]]--
-------------------------------------------------------------------------------
if settings["picker-hide-planners"].value then
    for _, item in pairs(data.raw["selection-tool"]) do
        if data.raw.recipe[item.name] then
            data.raw.recipe[item.name].hidden = true
        end
        item.flags = {"hidden"}
    end
    local rm = data.raw["item"]["resource-monitor"]
    if rm then
        rm.flags = {"hidden"}
        data.raw.recipe[rm.name].hidden = true
    end
end

-------------------------------------------------------------------------------
--[[Smaller no power]]--
-------------------------------------------------------------------------------
--Code and Gfx from "Ion's Tweaks: Less Unplugged", by "author": "KingIonTrueLove"
if settings["picker-small-unplugged-icon"].value then
    utility_sprites.electricity_icon_unplugged.filename = "__PickerExtended__/graphics/electricity-icon-unplugged.png"
end

-------------------------------------------------------------------------------
--[[Smaller gui borders]]--
-------------------------------------------------------------------------------
--Tweak by "Ion's UI Tweaks: Smaller Borders", by "KingIonTrueLove"
if settings["picker-smaller-gui-borders"].value then
    local style = data.raw["gui-style"].default
    style.switch_quickbar_button_style.default_graphical_set.monolith_image.width = 20
    style.switch_quickbar_button_style.default_graphical_set.monolith_image.height = 21
    style.switch_quickbar_button_style.hovered_graphical_set.monolith_image.width = 20
    style.switch_quickbar_button_style.hovered_graphical_set.monolith_image.height = 21
    style.switch_quickbar_button_style.hovered_graphical_set.monolith_image.x = 25
    style.switch_quickbar_button_style.clicked_graphical_set.monolith_image.width = 20
    style.switch_quickbar_button_style.clicked_graphical_set.monolith_image.height = 21
    style.switch_quickbar_button_style.clicked_graphical_set.monolith_image.x = 25

    style.flow_style.horizontal_spacing = 2
    style.flow_style.vertical_spacing = 4

    style.frame_style.top_padding = 2
    style.frame_style.right_padding = 3
    style.frame_style.bottom_padding = 3
    style.frame_style.left_padding = 2

    style.quick_bar_frame_style.top_padding = 2
    style.tool_bar_frame_style.top_padding = 2

    style.scroll_pane_style.horizontal_scroll_bar_spacing = 5
    style.scroll_pane_style.vertical_scroll_bar_spacing = 3
end

-------------------------------------------------------------------------------
--[[Iondicators]]--
-------------------------------------------------------------------------------
--GFX From "Iondicators" by "KingIonTrueLove" https://mods.factorio.com/mods/ion_cannon_1
local ion_line = settings["picker-iondicators-line"].value
local ion_arrow = settings["picker-iondicators-arrow"].value
if ion_line == "green" or ion_line == "yellow" or ion_line == "blue" or ion_line == "purple" then
    utility_sprites.indication_line.filename = "__PickerExtended__/graphics/iondicators/"..ion_line.."-indication-line.png"
end
if ion_arrow == "green" or ion_arrow == "yellow" or ion_arrow == "blue" or ion_arrow == "purple" then
    utility_sprites.indication_arrow.filename = "__PickerExtended__/graphics/iondicators/"..ion_arrow.."-indication-arrow.png"
end

-------------------------------------------------------------------------------
--[[Tile stack sizes]]--
-------------------------------------------------------------------------------
local tile_size = settings["picker-tile-stack"].value
for _, tile in pairs(data.raw.item) do
    local is_tile = tile.place_as_tile
    if is_tile and tile.stack_size < tile_size then
        tile.stack_size = tile_size
    end
end
