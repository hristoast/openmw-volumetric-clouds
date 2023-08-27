local core = require('openmw.core')
local storage = require('openmw.storage')
local postprocessing = require('openmw.postprocessing')
local clouds = postprocessing.load("clouds")
local I = require('openmw.interfaces')
local MOD_NAME = "ZesterersVolumetricClouds"
local playerSettings = storage.playerSection("SettingsPlayer" .. MOD_NAME)

--https://openmw.readthedocs.io/en/latest/reference/postprocessing/lua.html#controlling-uniforms
local current

I.Settings.registerPage {
    key = MOD_NAME,
    l10n = MOD_NAME,
    name = "Zesterer's Volumetric Clouds",
    description = "Lua-ified version with cloud density that lowers at night time."
}
I.Settings.registerGroup {
    key = "SettingsPlayer" .. MOD_NAME,
    l10n = MOD_NAME,
    name = "Zesterer's Volumetric Clouds",
    page = MOD_NAME,
    description = "Density settings",
    permanentStorage = false,
    settings = {
        {
            key = "dayTimeDensity",
            name = "Daytime Density",
            default = 0.0,
            renderer = "number",
            min = -10.0,
            max = 10.0
        },
        {
            key = "nightTimeDensity",
            name = "Night Density",
            default = -6.0,
            renderer = "number",
            min = -10.0,
            max = 10.0
        },
        {
            key = "debugMessages",
            name = "Show Debug Messages In Console",
            default = false,
            renderer = "checkbox"
        }
    }
}

return {
    engineHandlers = {
        onUpdate = function()
            local hour = (core.getGameTime() / 60 / 60 - 24) % 24
            if hour > 0 and hour < 5 then
                if current ~= playerSettings:get("nightTimeDensity") then
                    clouds:setFloat("cloud_density", playerSettings:get("nightTimeDensity"))
                    current = playerSettings:get("nightTimeDensity")
                    if playerSettings:get("debugMessages") then
                        print(string.format("Setting night density to: %f", current))
                    end
                end
            elseif hour > 5 then
                if current ~= playerSettings:get("dayTimeDensity") then
                    clouds:setFloat("cloud_density", playerSettings:get("dayTimeDensity"))
                    current = playerSettings:get("dayTimeDensity")
                    if playerSettings:get("debugMessages") then
                        print(string.format("Setting day density to: %f", current))
                    end
                end
            end
        end
    }
}
