local logger     = require("logger")
local millennium = require("millennium")

---@ffi
--- Add three numbers together, returning the sum
---@param a number
---@param b number
---@param c number
---@return number
function add(a, b, c)
    logger:info(string.format("add(%d, %d, %d)", a, b, c))
    return a + b + c
end

---@ffi
---@return string
function getSteamBrewIconResource()
    logger:info("Getting SteamClientHomebrew icon...")
    return millennium.assets.read("resources/favicon.svg")
end

logger:info("Registered RPC Functions")
