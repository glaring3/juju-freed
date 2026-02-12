local Draggable = require("@Menu/Services/Builder/Properties/Draggable")
local Signal = require("@Shared/Utils/Signal")
local Maid = require("@Shared/Utils/Maid")

local setMetatable = setmetatable
local rawSet = rawset

local HudObject = {}
HudObject.__index = HudObject

export type HudObject = typeof(setMetatable(
    {} :: {
        onShow : Signal.Signal,
        onHide: Signal.Signal,
        _maxSize : UDim2 | nil,
        _minSize : UDim2 | nil,
        _isForcedVisible : boolean,
        _isVisible : boolean,
        _isDraggable : boolean,
        _isResizable : boolean,
        _references : { [number]: Instance },
        _draggable : Draggable.Draggable | nil,
        _holderFrame : any,

    },
    HudObject
))

function HudObject.new(properties : any) : HudObject
    local self = {
        onShow = Signal.new(),
        onHide = Signal.new(),
        _isVisible = false,
        _isDraggable = properties.isDraggable or false,
        _isResizable = properties.isResizable or false,
        _isForcedVisible = properties.isForcedVisible or false,
        _maxSize = properties.maxSize,
        _minSize = properties.minSize,
        _references = {},
        _maid = Maid.new()
    }
    
    setMetatable(self, HudObject)

    local maid = self._maid

    -- Automatically adds instance references to the maid for cleanup
    setMetatable(self._references, {
        __newindex = function(_references : any, key, value)
            maid.GiveTask(maid, key)
            rawSet(_references, key, value)
        end
    })

    self._setHolderFrame(self, properties.holderFrame)

    return self
end

function HudObject._setHolderFrame(self : HudObject, holderFrame: any)
    self._holderFrame = holderFrame

    if self._isDraggable then
        self._draggable = Draggable.new(holderFrame)
    end
end

function HudObject.setForcedVisibility(self : HudObject, isForcedVisible: boolean)
    self._isForcedVisible = isForcedVisible
end

function HudObject.addInstance(self : HudObject, instance: Instance) : Instance
    local instances = self._references

    instances[#instances + 1] = instance

    return instance
end

function HudObject.show(self : HudObject)
    if self._isVisible then
        return
    end
    
    local draggable = self._draggable

    if draggable then
        draggable.enable(draggable)
    end

    self._isVisible = true
    self.onShow:Fire()
    self._holderFrame.Visible = true
end

function HudObject.hide(self : HudObject)
    if not self._isVisible then
        return
    end

    local draggable = self._draggable

    if draggable then
        draggable.disable(draggable)
    end

    self._isVisible = false
    self.onHide:Fire()
    self._holderFrame.Visible = false
end

return HudObject