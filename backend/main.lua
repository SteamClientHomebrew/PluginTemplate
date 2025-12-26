local logger = require("logger")
local millennium = require("millennium")

function test_frontend_message_callback(message, status, count)
    logger:info("test_frontend_message_callback called")
    logger:info("Received args: " .. table.concat({message, tostring(status), tostring(count)}, ", "))

    return "Response from backend"
end

local function on_load()
    logger:info("Comparing millennium version: " .. millennium.cmp_version(millennium.version(), "2.29.3"))

    logger:info("Example plugin loaded with Millennium version " .. millennium.version())
    millennium.ready()
end

-- Called when your plugin is unloaded. This happens when the plugin is disabled or Steam is shutting down.
-- NOTE: If Steam crashes or is force closed by task manager, this function may not be called -- so don't rely on it for critical cleanup.
local function on_unload()
    logger:info("Plugin unloaded")
end

-- Called when the Steam UI has fully loaded.
local function on_frontend_loaded()
    logger:info("Frontend loaded")
    local result = millennium.call_frontend_method("classname.method", { 18, "USA", false })
    logger:info(result)
end

return {
    on_frontend_loaded = on_frontend_loaded,
    on_load = on_load,
    on_unload = on_unload,

    -- patches let you directly override content from steam's js files as if they served with it.
    -- effectively, this means you can trampoline, hook, block, or entirely change the functionality of steam's js files.
    -- If you check the network tab on the chrome inspector, you'll see this file has directly served with this patch inside of it,
    -- Millennium did all the hard lifting :)
    patches = {
        {
            -- this find segment dictates the content you are able to edit. it essentially casts a net over a portion of the file content
            -- and tells Millennium you'll be editing it. This helps with optimization, and preventing Millennium from selecting content you didn't me to select.
            -- This search query is incredibly fast. To keep it that way, some advanced regex selectors will not work.
            -- Make sure your regex is "hyperscan" compatible.
            find = [["#Menu_Account"\)\s*:\s*\w+\.createElement\("div",\s*\{[^}]*className:\s*\w+\(\)\.SteamButton[^}]*\},\s*\w+\.createElement\(\w+\.SteamLogo]],

            -- Tell Millennium to only target files starting with "chunk" as this is the file we are concerned with.
            -- This helps Millennium optimize your selector, and prevent accidentally patching files you didn't mean to.
            file = [[chunk~[0-9a-f]+\.js]],

            -- All transforms are handled with PCRE2, not hyperscan like the "find" query.
            -- These names aren't particularly important, but note their feature sets aren't the exact same.
            transforms = {
                {
                    -- Let Millennium know we want to replace this content
                    match = [[createElement\(\w+\.SteamLogo]],
                    -- #{{self}} is a macro that denotes your plugins frontend instance.
                    -- hookedSettingsIcon() will be called on your frontend now.
                    -- Make sure to "Millennium.exposeObj({ hookedSettingsIcon });" first, otherwise the function will be private by default.
                    replace = [[createElement(#{{self}}?.hookedSettingsIcon?.().SteamButton]], -- ALWAYS null safe you calls. The frontend may not be ready when this code runs.
                }
                -- this is a list, you can add more elements
            }
        }
        -- this is a list, you can add more elements
    }
}
