local InternalBind = require("@Menu/Services/Keybinds/InternalKeybind")
local InputManager = require("@Menu/Services/Hud/InputManager")
local Maid = require("@Shared/Utils/Maid")

local next = next

local KeybindService = {
    _internalBinds = {} :: { [any] : { [string] : InternalBind.InternalKeybind } },
    _maid = Maid.new() :: Maid.Maid,
}
local internalBinds = KeybindService._internalBinds
local newMaid = KeybindService._maid

local function setInternalBindKeyCode(bind : InternalBind.InternalKeybind, keyCode : any)
    local old = bind._keyCode
    bind._keyCode = keyCode

    if old then
        local bindHolder = internalBinds[old]

        if bindHolder then
            bindHolder[bind._keybindName] = nil

            if not next(bindHolder) then
                internalBinds[old] = nil
            end
        end
    end

    local bindHolder = internalBinds[keyCode]
    if not bindHolder then
        bindHolder = {}
        internalBinds[keyCode] = bindHolder
    end

    bindHolder[bind._keybindName] = bind

    bind._keyCode = keyCode
end

function KeybindService.init()
    newMaid.GiveTask(newMaid, InputManager.onInputBegan:Connect(LPH_JIT_MAX(function(input : any, gameProcessed : any)
        local keyCode = input.KeyCode
        local inputType = input.UserInputType

        local internalBindsHolder = internalBinds[keyCode] or internalBinds[inputType]
        if internalBindsHolder then
            for name, internalKeyBind in next, internalBindsHolder do
                internalKeyBind.trigger(internalKeyBind)
            end
        end
    end)))
end

function KeybindService.unload()
    newMaid:DoCleaning()
end

function KeybindService.createInternalBind(properties : { [string] : any })
    local self = InternalBind.new(properties)
    
    if self._keyCode then
        setInternalBindKeyCode(self, self._keyCode)
    end

    return self
end

return KeybindService