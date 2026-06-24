local logger     = require("logger")
local millennium = require("millennium")
local utils      = require("utils")

---@ffi
--- Add three numbers together, returning the sum
---@param a number
---@param b number
---@param c number
---@return number
function add(a, b, c)
	logger:info(string.format("add(%d, %d, %d) called!", a, b, c))
	return a + b + c
end

local function on_load()
	logger:info("Loaded with Millennium version " .. millennium.version())
	millennium.ready()
end

-- Called when your plugin is unloaded. This happens when the plugin is disabled or Steam is shutting down.
-- NOTE: If Steam crashes or is force closed by task manager, this function may not be called -- so don't rely on it for critical cleanup.
local function on_unload()
	logger:info("Plugin unloaded")
end

-- Called when the Steam UI has fully loaded.
local function on_frontend_loaded()
	local start = utils.time_micro()
	logger:info("Frontend load notification received!")
	-- once the frontend is loaded, we can make calls with it.
	local result = millennium.call_frontend_method("subtract", { 200, 100 })
	if result == nil then
		logger:error("Failed to call Version.parse")
		return
	end
	local end_time = (utils.time_micro() - start) / 1000
	logger:info(string.format("Result %s in %.2fms", result.difference, end_time))
end

local function get_patches()
	return {
		{
			find =
			[["#Menu_Account"\):\(0,\w+\.jsxs\)\("div",\{className:\w+\(\)\.SteamButton,children:\[\(0,\w+\.jsx\)\(\w+\.SteamLogo]],
			file = [[chunk~[0-9a-f]+\.js]],
			transforms = {
				{
					match = [[\(0,(\w+\.jsx)\)\(\w+\.SteamLogo]],
					replace = [[(0,\1)(#{{self}}?.hookedSettingsIcon?.SteamButton||(()=>null)]],
				}
			}
		}
	}
end

return {
	on_frontend_loaded = on_frontend_loaded,
	on_load = on_load,
	on_unload = on_unload,
	patches = get_patches()
}
