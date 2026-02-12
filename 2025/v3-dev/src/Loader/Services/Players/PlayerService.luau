local PlayerData = require("@Loader/Services/Players/PlayerData")
local Signal = require("@Shared/Utils/Signal")

local PlayersService = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(PlayersService.LocalPlayer)

local setMetatable = setmetatable
local taskSpawn = task.spawn

local PlayerService = {
    onPlayerJoined = Signal.new(),
    onPlayerLeft = Signal.new(),
    _playersData = {}
}

local playersData = PlayerService._playersData
                                                    
local function onPlayerAdded(player: Player)
    local playerData = PlayerData.new(player)

    PlayerService.onPlayerJoined:Fire(playerData)

    playersData[player] = playerData
end

function PlayerService.start(): ()
    for index, player in next, PlayersService.GetPlayers(PlayersService) do
        taskSpawn(onPlayerAdded, player)
    end
end

return PlayerService