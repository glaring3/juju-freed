local PlayersService = cloneref(game:GetService("Players"))

local localPlayer = cloneref(PlayersService.LocalPlayer)
local kick = localPlayer.Kick

local LoggerService = {}

function LoggerService.criticalError(message)
    local baseMessage = "[Juju]\n\n"
    local errorMessage = baseMessage .. "CRITICAL ERROR:\n" .. message

    if LPH_OBFUSCATED then
        kick(localPlayer, errorMessage)
        return
    end

    warn(errorMessage)
end

return LoggerService