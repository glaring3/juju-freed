local ProtectionService = require("@Loader/Services/Protection/ProtectionService")
local KeybindService = require("@Menu/Services/Keybinds/KeybindService")
local Menu = require("@Menu/Main")

local String = require("@Shared/Utils/String")

local xpcall = xpcall
local getGenv = getgenv
local getReg = getreg

local SecureLoadUnload = {
    _regKey = nil :: any
}

function SecureLoadUnload.init()
    local genv = getGenv()
    local reg = getReg()
    local key = genv.juju

    if key then
        local unload = reg[key]

        if unload then
            unload()
            reg[key] = nil
        end
    end

    local regKey = String.randomString(16) :: any
    SecureLoadUnload._regKey = regKey

    genv.juju = regKey
    reg[regKey] = SecureLoadUnload.unload

    --ProtectionService.init()
end

function SecureLoadUnload.unload()
    xpcall(function()
        -- TO-DO: find a way to make unloading less manual
        require("@Shared/Utils/Camera").unload()
        ProtectionService.unload()
        KeybindService.unload()
        Menu.unload()
    end, function(err)
        if LPH_OBFUSCATED then
            LPH_CRASH()
            return
        end

        warn("Failed to stop " .. tostring(err))
    end)
end

return SecureLoadUnload