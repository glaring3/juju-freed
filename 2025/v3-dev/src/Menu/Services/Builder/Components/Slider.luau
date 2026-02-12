local UserInputService = cloneref(game:GetService("UserInputService")) :: UserInputService
local RunService = cloneref(game:GetService("RunService")) :: RunService

local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local ElementUtils = require("@Menu/Services/Builder/Utils/ElementUtils")
local BaseElement = require("@Menu/Services/Builder/Components/Base/BaseElement")
local Animation = require("@Shared/Utils/Animation")
local Clickable = require("@Menu/Services/Builder/Properties/Clickable")
local Hoverable = require("@Menu/Services/Builder/Properties/Hoverable")
local Maid = require("@Shared/Utils/Maid")
local Math = require("@Shared/Utils/Math")

local isMouseButtonPressed = UserInputService.IsMouseButtonPressed
local getLastInputType = UserInputService.GetLastInputType
local getMouseLocation = UserInputService.GetMouseLocation

local renderStepped = RunService.RenderStepped
local renderSteppedWait = renderStepped.Wait
local mouseButton1 = Enum.UserInputType.MouseButton1

local createInstance = ThemedInstances.createInstance
local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local setMetatable = setmetatable
local vector2New = Vector2.new
local mouseWheel = Enum.UserInputType.MouseWheel
local mathClamp = math.clamp
local mathRound = Math.round
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local SliderProperties = {
    selected = {
        sliderCircle = "SliderCircleSelected",
        sliderCircleBorder = "SliderCircleBorderSelected",
        valueBox = "ElementBackgroundSelected",
        valueBoxBorder = "SliderValueBoxBorderSelected",
        valueLabel = "SliderValueTextSelected"
    },
    unselected = {
        sliderCircle = "SliderCircleUnselected",
        sliderCircleBorder = "SliderCircleBorderUnselected",
        valueBox = "ElementBackgroundUnselected",
        valueBoxBorder = "SliderValueBoxBorderUnselected",
        valueLabel = "SliderValueTextUnselected"
    },
}

local VALUE_BOX_START_POSITION = UDim2.new(1, -68, 0.5, 2)
local VALUE_BOX_END_POSITION = UDim2.new(1, -68, 0.5, 0)

local Slider = {}
Slider.__index = Slider

setMetatable(Slider, {__index = BaseElement})

export type Slider = typeof(setMetatable(
    {} :: {
        _value : number,
        _references : {
            [string] : Instance | GuiObject,
            sliderBar : Frame,
            sliderBarBorder : UIStroke,
            sliderFillBar : Frame,
            sliderBarFillBorder : UIStroke,
            sliderCircle : Frame,
            sliderCircleBorder : UIStroke,
            valueBox : TextButton,
            valueBoxBorder : UIStroke,
            valueLabel : TextBox,
            sliderButtonOverlay : TextButton
        },
        _maid : Maid.Maid,
        _clickable : Clickable.Clickable,
        _minimumValue : number,
        _maximumValue : number,
        _rounding : number,
        _valuePrefix : string | nil,
        _valueSuffix : string | nil,
        _barHoverable : Hoverable.Hoverable,
        _dragging : boolean,
        _valueBoxHoverable : Hoverable.Hoverable,
    },
    Slider
))

function Slider.new(properties : any) : Slider
    local self = BaseElement.new(properties) :: BaseElement.BaseElement & Slider
    local references = self._references

    references.sliderBar = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 60, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(29, 29, 34),
    }, references.elementContainer, "ElementBackgroundUnselected") :: Frame

    references.sliderBarBorder = createInstance("UIStroke", {
    }, references.sliderBar, "ElementBorderUnselected") :: UIStroke

    references.sliderFillBar = createInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(95, 95, 113),
    }, references.sliderBar, "SliderBarFill") :: Frame

    createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.sliderFillBar)

    references.sliderCircle = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 8, 0, 8),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(184, 184, 212),
    }, references.sliderFillBar, "SliderCircleUnselected") :: Frame

    createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.sliderCircle)

    references.sliderCircleBorder = createInstance("UIStroke", {
    }, references.sliderCircle, "SliderCircleBorderUnselected") :: UIStroke

    references.sliderBarFillBorder = createInstance("UIStroke", {
    }, references.sliderFillBar, "SliderBarFillBorder") :: UIStroke

    createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 8),
    }, references.sliderBar)

    createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.sliderBar)

    references.valueBox = createInstance("TextButton", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -68, 0.5, 0),
        Size = UDim2.new(0, 0, 1, -2),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(95, 95, 113),
        Text = "",
        AutoButtonColor = false,
        Active = false
    }, references.elementContainer, "ElementBackgroundUnselected") :: TextButton

    createInstance("UICorner", {
        CornerRadius = UDim.new(0.25, 0),
    }, references.valueBox)

    references.valueBoxBorder = createInstance("UIStroke", {
        Color = Color3.fromRGB(115, 115, 136),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.valueBox) :: UIStroke

    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
    }, references.valueBox)

    references.valueLabel = createInstance("TextBox", {
        FontFace = "Menu-Bold",
        AnchorPoint = Vector2.new(0.5, 0),
        TextSize = 11,
        Size = UDim2.new(0, 0, 1, -1),
        TextColor3 = Color3.fromRGB(220, 220, 245),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        Interactable = false
    }, references.valueBox, "SliderValueTextUnselected") :: TextBox

    references.sliderButtonOverlay = createInstance("TextButton", {
        Active = false,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 60, 0, 14),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0.5, 0),
        BorderSizePixel = 0,
        TextSize = 14,
    }, references.elementContainer) :: TextButton
    
    setMetatable(self, Slider)

    -- Initialize properties

    local minimumValue = properties.minimumValue or 0
    self._minimumValue = minimumValue
    self._maximumValue = properties.maximumValue or 100
    self._rounding = properties.rounding or 0
    self._valuePrefix = properties.valuePrefix
    self._valueSuffix = properties.valueSuffix
    
    self._dragging = false
    
    -- Initialize Clickable

    local clickable = Clickable.new({references.sliderButtonOverlay})
    self._clickable = clickable

    local maid = self._maid
    local giveTask = maid.GiveTask

    giveTask(maid, clickable.onDown:Connect(LPH_JIT_MAX(function()
        local lastMouseLocation = vector2New()
        local sliderBar = references.sliderBar
        
        self._dragging = true

        while isMouseButtonPressed(UserInputService, mouseButton1) do
            local mouseLocation = getMouseLocation(UserInputService)

            if mouseLocation == lastMouseLocation then
                renderSteppedWait(renderStepped)
                continue
            end

            lastMouseLocation = mouseLocation
            local distance = mathClamp((lastMouseLocation.X - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X, 0, 1)

            local minimumValue = self._minimumValue
            local maximumValue = self._maximumValue
            local rounding = self._rounding
            
            local value = mathRound(minimumValue + (maximumValue - minimumValue) * distance, rounding)

            if self._value ~= value then
                self.SetValueInternal(self, value, true)
            end
            renderSteppedWait(renderStepped)
        end

        self._dragging = false

        if self._barHoverable._isHovering then
            return
        end
        
        self._barHoverable.onLeave:Fire()
    end)))

    -- Hovering

    local barHoverable = Hoverable.new(references.sliderButtonOverlay)
    self._barHoverable = barHoverable

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.sliderBarFillBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
        runStyle("buttonHover", references.sliderCircle, {
            BackgroundColor3 = getThemeColor("SliderCircleHover"),
        })
    end, barHoverable)

    self.AddLeaveCallback(self, function()
        if self._dragging then
            return
        end

        runStyle("buttonLeave", references.sliderBarFillBorder, {
            Color = getThemeColor("SliderBarFillBorder"),
        })
        runStyle("buttonHover", references.sliderCircle, {
            BackgroundColor3 = getThemeColor(self._selected and "SliderCircleSelected" or "SliderCircleUnselected"),
        })
    end, barHoverable)
    
    local boxHoverable = Hoverable.new(references.valueBox)
    self._valueBoxHoverable = boxHoverable

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.valueBoxBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
    end, boxHoverable)

    self.AddLeaveCallback(self, function()
        runStyle("buttonHover", references.valueBoxBorder, {
            Color = getThemeColor(self._selected and "SliderValueBoxBorderSelected" or "SliderValueBoxBorderUnselected"),
        })
    end, boxHoverable)

    -- Value box

    local boxClickable = Clickable.new({references.valueBox :: TextButton})
    local valueLabel = references.valueLabel :: TextBox

    giveTask(maid, boxClickable.onRelease:Connect(function()
        valueLabel.Interactable = true
        valueLabel.CaptureFocus(valueLabel)
    end))

    giveTask(maid, valueLabel.FocusLost:Connect(function(enterPressed : boolean)
        valueLabel.Interactable = false

        local text = valueLabel.Text
        local newValue = tonumber(text)

        if not enterPressed or newValue == nil or self._value == newValue then
            self.SetValueLabel(self, self._value)
            return
        end

        self.SetValue(self, newValue)
    end))

    -- Scrolling

    local scrollConnection = nil :: RBXScriptConnection?
    
    self.AddHoverCallback(self, LPH_JIT_MAX(function()
        if scrollConnection then
            return
        end

        scrollConnection = UserInputService.InputChanged:Connect(function(input : InputObject)
            if input.UserInputType ~= mouseWheel then
                return
            end

            local delta = input.Position.Z * (self._maximumValue - self._minimumValue) / 100
            local newValue = self._value + delta

            self.SetValue(self, newValue)
        end)
    end), barHoverable)

    self.AddLeaveCallback(self, function()
        if scrollConnection then
            scrollConnection:Disconnect()
            scrollConnection = nil
        end
    end, barHoverable)

    -- Set default value

    self.SetValueInternal(self, properties.defaultValue or minimumValue, false)

    return self
end

function Slider:SetValueInternal(value : number, shouldAnimate : boolean)
    local minimumValue = self._minimumValue
    local maximumValue = self._maximumValue

    self.SetSelected(self, value > minimumValue, shouldAnimate)

    local clampedValue = mathRound(mathClamp(value, minimumValue, maximumValue), self._rounding)
    self._value = clampedValue

    local references = self._references

    local sliderFillBar = references.sliderFillBar
    local newSliderSize = udim2New((clampedValue - minimumValue)/(maximumValue - minimumValue), 0, 1, 0)
    
    if shouldAnimate then
        local valueBox = references.valueBox
        valueBox.Position = VALUE_BOX_START_POSITION

        runStyle("tabDrop", valueBox, {
            Position = VALUE_BOX_END_POSITION
        })
        runStyle("sliderSlide", sliderFillBar, {
            Size = newSliderSize,
        })
    else
        sliderFillBar.Size = newSliderSize
    end

    self.SetValueLabel(self, clampedValue)
end

function Slider:SetValueLabel(value : number)
    local references = self._references
    local valueLabel = references.valueLabel

    local prefix = self._valuePrefix or ""
    local suffix = self._valueSuffix or ""

    valueLabel.Text = prefix .. tostring(value) .. suffix
end

function Slider:SetSelectedInternal(isSelected : boolean, shouldAnimate : boolean)
    local references = self._references

    local newProperties = isSelected and SliderProperties.selected or SliderProperties.unselected
    local oldProperties = isSelected and SliderProperties.unselected or SliderProperties.selected

    for referenceName, themeProperty in next, newProperties do
        applyProperty(references[referenceName], {themeProperty, oldProperties[referenceName]}, isSelected and "buttonActivate" or "buttonDeactivate", shouldAnimate)
    end
end

return Slider