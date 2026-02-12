local Signal = require("@Shared/Utils/Signal")

local setMetatable = setmetatable

local InternalKeybind = {}
InternalKeybind.__index = InternalKeybind

export type InternalKeybind = typeof(setMetatable(
    {} :: {
        _isUserMade : boolean,
        _keybindName : string,
        _keyCode : Enum.KeyCode,
        _onTriggered : Signal.Signal
    },
    InternalKeybind
))

function InternalKeybind.new(properties : { [string] : any }) : InternalKeybind
    local self = {
        _isUserMade = false,
        _keybindName = properties.name or "Unknown Keybind",
        _keyCode = properties.keyCode or Enum.KeyCode.Unknown,
        _onTriggered = Signal.new()
    }

    setMetatable(self, InternalKeybind)

    return self
end

function InternalKeybind.trigger(self : InternalKeybind)
    self._onTriggered:Fire()
end

return InternalKeybind