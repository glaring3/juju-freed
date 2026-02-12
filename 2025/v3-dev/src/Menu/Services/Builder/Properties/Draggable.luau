local InputManager = require("@Menu/Services/Hud/InputManager")
local Instances = require("@Shared/Utils/Instances")
local Camera = require("@Shared/Utils/Camera")
local Maid = require("@Shared/Utils/Maid")

local UserInputService = cloneref(game.GetService(game, "UserInputService")) :: UserInputService

local getMouseLocation = UserInputService.GetMouseLocation

local mouseMovement = Enum.UserInputType.MouseMovement
local mouseButton1 = Enum.UserInputType.MouseButton1
local touch = Enum.UserInputType.Touch

local udimFromScale = UDim2.fromScale
local setMetatable = setmetatable
local vector2New = Vector2.new
local mathClamp = math.clamp

local Draggable = {}
Draggable.__index = Draggable

local POSITION_OFFSET = vector2New(0, 58)

export type Draggable = typeof(setMetatable(
    {} :: {
        _holderFrame : any,
        _isDragging : boolean,
        _connection: any,
        _dragConnection: any,
        _stopDragConnection: any,
        _isEnabled : boolean,
        _maid : Maid.Maid,
    },
    Draggable
))

function Draggable.new(holderFrame) : Draggable
    local self = {
        _holderFrame = holderFrame,
        _isDragging = false,
        _connection = nil,
        _dragConnection = nil,
        _stopDragConnection = nil,
        _isEnabled = false,
        _maid = Maid.new(),
    }

    setMetatable(self, Draggable)

    return self
end

function Draggable.enable(self : Draggable)
    if self._isEnabled then
        return
    end

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask

    local frame = self._holderFrame
    giveTask(newMaid, frame.InputBegan:Connect(LPH_JIT_MAX(function(input : InputObject)
        local userInputType = input.UserInputType

        if userInputType ~= mouseButton1 and userInputType ~= touch or self._isDragging then
            return
        end

        self._isDragging = true
                    
        local startMouseLocation = getMouseLocation(UserInputService)
        local startPosition = frame.AbsolutePosition + POSITION_OFFSET

        self._dragConnection = giveTask(newMaid, InputManager.onInputChanged:Connect(LPH_NO_VIRTUALIZE(function(input : any)
            if input.UserInputType == mouseMovement then
                local size = frame.AbsoluteSize
                    
                local viewportSize = Camera._viewportSize
                local maxX = 1 - size.X/viewportSize.X
                local maxY = 1 - size.Y/viewportSize.Y

                local mouseLocation = getMouseLocation(UserInputService)

                frame.Position = udimFromScale(mathClamp((startPosition.X - (startMouseLocation.X - mouseLocation.X))/viewportSize.X, 0, maxX), mathClamp((startPosition.Y - (startMouseLocation.Y - mouseLocation.Y))/viewportSize.Y, 0, maxY))
            end
        end)))

        self._stopDragConnection = giveTask(newMaid, InputManager.onInputEnded:Connect(LPH_NO_VIRTUALIZE(function(input : any)
            local userInputType = input.UserInputType
            if userInputType == mouseButton1 or userInputType == touch then
                self._isDragging = false

                local dragConnection = self._dragConnection
                if dragConnection then
                    dragConnection.Disconnect(dragConnection)
                    self._dragConnection = nil
                end
            end
        end)))
    end)))

    self._isEnabled = true
end

function Draggable.disable(self : Draggable)
    if not self._isEnabled then
        return
    end

    self._maid:DoCleaning()

    self._isEnabled = false
    self._isDragging = false
end

return Draggable