local Signal = require("@Shared/Utils/Signal")
local Maid = require("@Shared/Utils/Maid")

local setMetatable = setmetatable
local typeOf = typeof

local Clickable = {}
Clickable.__index = Clickable

export type Clickable = typeof(setMetatable(
    {} :: {
        _holderFrames : {[number] : TextButton | ImageButton},
        _isEnabled : boolean,
        onDown : Signal.Signal,
        onRelease : Signal.Signal,
        _maid : Maid.Maid
    },
    Clickable
))

function Clickable.new(holderFrames : Instance | {[number] : TextButton | ImageButton}) : Clickable
    local _holderFrames = {}

    local self = {
        _holderFrames = _holderFrames,
        onDown = Signal.new(),
        onRelease = Signal.new(),
        _isEnabled = false,
        _maid = Maid.new(),
    }

    if typeOf(holderFrames) == "Instance" then
        _holderFrames[1] = holderFrames :: TextButton | ImageButton
    else
        for _, frame in next, holderFrames :: any do
            _holderFrames[#_holderFrames + 1] = frame
        end
    end

    setMetatable(self, Clickable)

    self.enable(self)

    return self
end

function Clickable.enable(self : Clickable)
    if self._isEnabled then
        return
    end

    self._isEnabled = true

    local holderFrames = self._holderFrames
    local maid = self._maid
    local giveTask = maid.GiveTask
    
    local onRelease = self.onRelease
    local onDown = self.onDown

    for i = 1, #holderFrames do
        local holderFrame = holderFrames[i]

        giveTask(maid, holderFrame.MouseButton1Down:Connect(function()
            onDown:Fire()
        end))

        giveTask(maid, holderFrame.MouseButton1Up:Connect(function()
            onRelease:Fire()
        end))
    end
end

function Clickable.disable(self : Clickable)
    if not self._isEnabled then
        return
    end

    self._isEnabled = false

    self._maid:DoCleaning()
end

return Clickable