local PlayerData = require("@Loader/Services/Players/PlayerData")
local PlayerService = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(PlayerService.LocalPlayer)

local isFriendsWith = LocalPlayer.IsFriendsWith
local osClock = os.clock

local LocalPlayerManager = {}

function LocalPlayerManager.isFriendsWith(playerData: PlayerData): boolean
    return false
end

return LocalPlayerManager