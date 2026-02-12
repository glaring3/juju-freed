local setMetatable = setmetatable
local osClock = os.clock

local PlayerData = {}
PlayerData.__index = PlayerData

export type PlayerData = typeof(setMetatable(
    {} :: {
        playerInstance: Player,
        joinTime: number,
        isFriend: boolean?,
    },
    PlayerData
))

function PlayerData.new(player: Player): PlayerData
    local self = {
        playerInstance = player,
        joinTime = osClock(),
        isFriend = nil,
    }

    return setMetatable(self, PlayerData)
end

return PlayerData