local Signal = require("@Shared/Utils/Signal")
local Maid = require("@Shared/Utils/Maid")

local setMetatable = setmetatable

local Hoverable = {}
Hoverable.__index = Hoverable

local hoveredObjects = {}

export type Hoverable = typeof(setMetatable(
    {} :: {
        _holderFrame : Instance?,
        _isEnabled : boolean,
        onHover : Signal.Signal,
        onLeave : Signal.Signal,
        _maid : Maid.Maid,
        _isHovering : boolean,
    },
    Hoverable
))

function Hoverable.new(holderFrame : GuiObject) : Hoverable
    local self = {
        _holderFrame = holderFrame,
        onLeave = Signal.new(),
        onHover = Signal.new(),
        _isEnabled = false,
        _maid = Maid.new(),
        _isHovering = false,
    }

    setMetatable(self, Hoverable)

    self.enable(self)

    return self
end

function Hoverable.enable(self : Hoverable)
    if self._isEnabled then
        return
    end

    self._isEnabled = true

    local holderFrame = self._holderFrame :: any
    local onHover = self.onHover
    local onLeave = self.onLeave

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask

    giveTask(newMaid, holderFrame.MouseEnter:Connect(function()
        hoveredObjects[holderFrame] = self
        self._isHovering = true

        onHover:Fire()
    end))

    giveTask(newMaid, holderFrame.MouseLeave:Connect(function()
        hoveredObjects[holderFrame] = nil
        self._isHovering = false

        onLeave:Fire()
    end))
end

function Hoverable.disable(self : Hoverable)
    if not self._isEnabled then
        return
    end

    if self._isHovering then
        self.onLeave:Fire()
    end

    self._isHovering = false
    self._isEnabled = false
    self._maid:DoCleaning()
end

return Hoverable