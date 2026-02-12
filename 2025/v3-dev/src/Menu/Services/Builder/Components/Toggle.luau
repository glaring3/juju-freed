local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local ElementUtils = require("@Menu/Services/Builder/Utils/ElementUtils")
local BaseElement = require("@Menu/Services/Builder/Components/Base/BaseElement")
local Animation = require("@Shared/Utils/Animation")
local Clickable = require("@Menu/Services/Builder/Properties/Clickable")
local Maid = require("@Shared/Utils/Maid")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local updateLink = ThemeService.updateLink
local runStyle = Animation.runStyle
local udim2New = UDim2.new
local type = type

local TOGGLED_CIRCLE_POSITION = udim2New(1, 0, 0.5, 0)
local DEFAULT_CIRCLE_POSITION = udim2New(0, 0, 0.5, 0)

local TOGGLED_CIRCLE_ANCHOR = Vector2.new(1, 0.5)
local DEFAULT_CIRCLE_ANCHOR = Vector2.new(0, 0.5)

local ToggleProperties = {
    selected = {
        toggleCircle = "ToggleCircleSelected",
        toggleCircleBorder = "ToggleCircleBorderSelected",
        toggleFrame = "ElementBackgroundSelected",
        toggleBorder = "ElementBorderSelected"
    },
    unselected = {
        toggleCircle = "ToggleCircleUnselected",
        toggleCircleBorder = "ToggleCircleBorderUnselected",
        toggleFrame = "ElementBackgroundUnselected",
        toggleBorder = "ElementBorderUnselected",
    },
}

local Toggle = {}
Toggle.__index = Toggle

setMetatable(Toggle, {__index = BaseElement})

export type Toggle = typeof(setMetatable(
    {} :: {
        _value : boolean,
        _references : {
            [string] : Instance | GuiObject,
            toggleFrame : TextButton,
            toggleTextButtonOverlay : TextButton,
            toggleBorder : UIStroke,
            toggleCircle : Frame,
            toggleCircleBorder : UIStroke,
        },
        _maid : Maid.Maid,
        _clickable : Clickable.Clickable,
    },
    Toggle
))

function Toggle.new(properties : any) : Toggle
    local self = BaseElement.new(properties) :: BaseElement.BaseElement & Toggle
    local references = self._references
    
    references.toggleFrame = createInstance("TextButton", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 40, 1, -2),
        ZIndex = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(29, 29, 34),
        Text = "",
        AutoButtonColor = false,
        Active = false
    }, references.elementContainer, "ElementBackgroundUnselected") :: TextButton

    references.toggleTextButtonOverlay = createInstance("TextButton", {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1,
        Text = "",
        AutoButtonColor = false,
        Active = false
    }, references.textLabel) :: TextButton

    createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.toggleFrame)

    references.toggleBorder = createInstance("UIStroke", {
        Color = Color3.fromRGB(32, 32, 38),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.toggleFrame, "ElementBorderUnselected") :: UIStroke

    references.toggleCircle = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 10, 0, 8),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(59, 59, 68),
    }, references.toggleFrame, "ToggleCircleUnselected") :: Frame

    createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.toggleCircle)

    references.toggleCircleBorder = createInstance("UIStroke", {
        Color = Color3.fromRGB(43, 43, 50),
    }, references.toggleCircle, "ToggleCircleBorderUnselected") :: UIStroke

    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
    }, references.toggleFrame)

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.toggleBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
    end)

    self.AddLeaveCallback(self, function()
        runStyle("buttonLeave", references.toggleBorder, {
            Color = getThemeColor(self._selected and "ElementBorderSelected" or "ElementBorderUnselected"),
        })
    end)
    
    setMetatable(self, Toggle)
    
    local clickable = Clickable.new({references.toggleFrame, references.toggleTextButtonOverlay})
    self._clickable = clickable

    local maid = self._maid
    maid.GiveTask(maid, clickable.onRelease:Connect(function()
        self.SetValue(self, not self._value)
    end))

    return self
end

function Toggle:SetValueInternal(value : boolean, shouldAnimate : boolean)
    self.SetSelected(self, value, shouldAnimate)
    
    local references = self._references
    local newProperties = value and ToggleProperties.selected or ToggleProperties.unselected
    local oldProperties = value and ToggleProperties.unselected or ToggleProperties.selected
    local animationStyle = value and "buttonActivate" or "buttonDeactivate"

    for referenceName, themeProperty in next, newProperties do
        applyProperty(references[referenceName], {themeProperty, oldProperties[referenceName]}, animationStyle, shouldAnimate)
    end

    local newCirclePosition = value and TOGGLED_CIRCLE_POSITION or DEFAULT_CIRCLE_POSITION
    local newCircleAnchor = value and TOGGLED_CIRCLE_ANCHOR or DEFAULT_CIRCLE_ANCHOR
    local toggleCircle = references.toggleCircle

    if shouldAnimate then
        runStyle(animationStyle, toggleCircle, {
            Position = newCirclePosition,
            AnchorPoint = newCircleAnchor
        })
    else
        toggleCircle.Position = newCirclePosition
        toggleCircle.AnchorPoint = newCircleAnchor
    end
end

function Toggle:SetSelectedInternal(isSelected : boolean, shouldAnimate : boolean)
    -- No additional visual changes needed for selected state in Toggle
end

return Toggle