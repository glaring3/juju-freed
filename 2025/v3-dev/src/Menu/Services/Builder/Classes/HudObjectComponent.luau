local Hoverable = require("@Menu/Services/Builder/Properties/Hoverable")
local Clickable = require("@Menu/Services/Builder/Properties/Clickable")
local Maid = require("@Shared/Utils/Maid")

local setMetatable = setmetatable
local rawSet = rawset

local HudObjectComponent = {}
HudObjectComponent.__index = HudObjectComponent

export type HudObjectComponent = typeof(setMetatable(
    {} :: {
        onShow : () -> (),
        onHide: () -> (),
        _isInteractable : boolean,
        _connections : { [number]: any },
        _references : { [string]: Instance | GuiObject },
        _hoverable : Hoverable.Hoverable | nil,
        _clickable : Clickable.Clickable | nil,
        _maid : Maid.Maid,
    },
    HudObjectComponent
))

export type Clickable = Clickable.Clickable
export type Hoverable = Hoverable.Hoverable

function HudObjectComponent.new(properties : any) : HudObjectComponent
    local self = {
        onShow = properties.onShow :: any,
        onHide = properties.onHide :: any,
        holderFrame = properties.holderFrame :: any,
        _isInteractable = true,
        _connections = {},
        _references = {},
        _maid = Maid.new(),
    }

    if properties.isHoverable then
        local hoverable = Hoverable.new(self.holderFrame)
        self._hoverable = hoverable
    end

    if properties.isClickable then
        local clickable = Clickable.new(self.holderFrame)
        self._clickable = clickable
    end

    setMetatable(self, HudObjectComponent)

    local maid = self._maid

    -- Automatically adds instance references to the maid for cleanup
    setMetatable(self._references, {
        __newindex = function(_references : any, key, value)
            maid.GiveTask(maid, key)
            rawSet(_references, key, value)
        end
    })

    return self
end

function HudObjectComponent.cleanup(self : HudObjectComponent)
    local maid = self._maid
    maid:DoCleaning()
end

return HudObjectComponent