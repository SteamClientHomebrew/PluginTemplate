local logger     = require("logger")
local millennium = require("millennium")
local json       = require("json")

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
    local icon = millennium.assets.read("resources/favicon.svg")
    if icon == nil then
        logger:error("favicon.svg not found in bundled assets")
        return ""
    end
    return icon
end

---@class PluginStatus
---@field enabled boolean
---@field version string
---@field tags string[]
---@field lastError string|nil

---@ffi
---@return PluginStatus
function getPluginStatus()
    return {
        enabled = true,
        version = "1.0.0",
        tags = { "example", "template" },
        lastError = json.null,
    }
end

---@class PluginPreferences
---@field darkMode boolean
---@field refreshInterval number

---@ffi
---@param prefs PluginPreferences
---@return boolean
function updatePreferences(prefs)
    logger:info(string.format(
        "updatePreferences(darkMode=%s, refreshInterval=%d)",
        tostring(prefs.darkMode), prefs.refreshInterval
    ))
    return true
end

logger:info("Registered RPC Functions")
