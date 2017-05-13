-------------------------------------------------------------------------------
--[[Proxy Chest]]--
-------------------------------------------------------------------------------
--Set the proxy chest size to the size of the largest inventory
local size = 0

local data_to_check = {
    "container",
    "logistic-container",
    "car",
    "cargo-wagon",
}

for _, type in pairs(data_to_check) do
    for _, entity in pairs(data.raw[type]) do
        size = entity.inventory_size > size and entity.inventory_size or size
    end
end
data.raw["container"]["picker-proxy-chest"].inventory_size = size
