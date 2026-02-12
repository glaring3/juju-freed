if not LPH_OBFUSCATED then
    local env = getfenv()
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_CRASH = function() warn('crash') end
    LPH_OBFUSCATED = false
    LPH_NO_VIRTUALIZE = function(...) return ... end
end

local SecureLoadUnload = require("@Loader/SecureLoadUnload")
local LoggerService = require("@Loader/Services/Logger/LoggerService")
local AssetsService = require("@Loader/Services/Assets/AssetsService")
local Menu = require("@Menu/Main")

local xpcall = xpcall

local Loader = {}

function Loader.init(data)
    local menuConfig = data.menuConfig

    xpcall(function()
        SecureLoadUnload.init()
        
        local didAssetsFail = AssetsService.init()

        if didAssetsFail then
            LoggerService.criticalError("Failed to download critical assets.")
            return
        end

        Menu.init(menuConfig)
    end, function(err)
        if LPH_OBFUSCATED then
            LPH_CRASH()
            return
        end

        warn("Failed to initialize " .. tostring(err))
    end)
end

return Loader