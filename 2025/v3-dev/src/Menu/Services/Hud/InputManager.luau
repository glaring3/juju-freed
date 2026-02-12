local String = require("@Shared/Utils/String")
local Signal = require("@Shared/Utils/Signal")
local Maid = require("@Shared/Utils/Maid")

local ContextActionService = cloneref(game.GetService(game, "ContextActionService")) :: ContextActionService
local UserInputService = cloneref(game.GetService(game, "UserInputService")) :: UserInputService

local inputStateBegin = Enum.UserInputState.Begin
local inputStateEnd = Enum.UserInputState.End
local randomString = String.randomString
local unpack = unpack

local allEnums = {} :: { Enum.KeyCode | Enum.UserInputType }

for index, enum in next, Enum.UserInputType:GetEnumItems() do
    allEnums[#allEnums + 1] = enum
end

for index, enum in next, Enum.KeyCode:GetEnumItems() do
    allEnums[#allEnums + 1] = enum
end

local InputManager = {
    onInputBegan = Signal.new() :: Signal.Signal,
    onInputEnded = Signal.new() :: Signal.Signal,
    onInputChanged = Signal.new() :: Signal.Signal,
    _coreActionKey = "" :: string | nil,
    _isListening = false :: boolean,
    _maid = Maid.new() :: Maid.Maid,
}
local newMaid = InputManager._maid

export type InputManager = typeof(InputManager)

function InputManager.listen()
    if InputManager._isListening then 
        return 
    end

    newMaid:DoCleaning()

    local newActionKey = randomString(8)

    InputManager._isListening = true
    InputManager._coreActionKey = newActionKey

    ContextActionService:BindAction(newActionKey, LPH_JIT_MAX(function(actionName, inputState, inputObject)
        local signal = inputState == inputStateBegin and InputManager.onInputBegan 
            or inputState == inputStateEnd and InputManager.onInputEnded 
            or InputManager.onInputChanged

        signal:Fire(inputObject)
    end), false, unpack(allEnums))
end

function InputManager.stop()
    newMaid:DoCleaning()

    if not InputManager._isListening then 
        return 
    end

    ContextActionService:UnbindAction(InputManager._coreActionKey :: string)
    InputManager._isListening = false
    InputManager._coreActionKey = nil
end

function InputManager.stopListening()
    if not InputManager._isListening then 
        return 
    end

    ContextActionService:UnbindAction(InputManager._coreActionKey :: string)
    InputManager._isListening = false
    InputManager._coreActionKey = nil

    -- This is done for keybinds so they work even when the hud is closed
    local onInputChanged = InputManager.onInputChanged
    local onInputBegan = InputManager.onInputBegan
    local onInputEnded = InputManager.onInputEnded
    
    local giveTask = newMaid.GiveTask

    giveTask(newMaid, UserInputService.InputBegan:Connect(LPH_JIT_MAX(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent then 
            return
        end

        onInputBegan:Fire(inputObject)
    end)))

    giveTask(newMaid, UserInputService.InputChanged:Connect(LPH_JIT_MAX(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent then 
            return
        end

        onInputChanged:Fire(inputObject)
    end)))

    giveTask(newMaid, UserInputService.InputEnded:Connect(LPH_JIT_MAX(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent then 
            return 
        end

        onInputEnded:Fire(inputObject)
    end)))
end

return InputManager