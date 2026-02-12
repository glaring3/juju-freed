local HudObjectComponent = require("@Menu/Services/Builder/Classes/HudObjectComponent")
local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local ElementUtils = require("@Menu/Services/Builder/Utils/ElementUtils")
local Animation = require("@Shared/Utils/Animation")
local Maid = require("@Shared/Utils/Maid")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local runStyle = Animation.runStyle

local BaseProperties = {
    selected = {
        textLabel = "ElementTextSelected",
    },
    unselected = {
        textLabel = "ElementTextUnselected",
    },
}

local BaseElement = {}
BaseElement.__index = BaseElement

setMetatable(BaseElement, {__index = HudObjectComponent})

export type BaseElement = typeof(setMetatable(
    {} :: {
        _locked : boolean,
        _value : boolean | number | string | {[string]: any} | nil,
        _prefix : string | nil,
        _suffix : string | nil,
        _minimumValue : number | nil,
        _maximumValue : number | nil,
        _rounding : number | nil,
        _flag : string | nil,
        _selected : boolean,
        _references : {
            [string] : Instance | GuiObject,
            holderFrame : Frame,
            textLabel : TextLabel,
            elementContainer : Frame
        },
        _hoverable : HudObjectComponent.Hoverable,
        _clickable : HudObjectComponent.Clickable,
        AddHoverCallback : (self : BaseElement, callback : () -> (), customHoverable : HudObjectComponent.Hoverable?) -> (),
        AddLeaveCallback : (self : BaseElement, callback : () -> (), customHoverable : HudObjectComponent.Hoverable?) -> (),
        _maid : Maid.Maid,
    },
    BaseElement
))

function BaseElement.new(properties : any) : BaseElement
    properties.isHoverable = true
    
    local references = {}

    references.holderFrame = createInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 15,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    })

    references.textLabel = createInstance("TextLabel", {
        FontFace = "Menu-Semibold",
        TextColor3 = Color3.fromRGB(80, 80, 85),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = properties.title,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 16,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.holderFrame, "ElementTextUnselected")

    references.elementContainer = createInstance("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
    }, references.holderFrame)

    local holderFrame = references.holderFrame :: Frame
    properties.holderFrame = holderFrame

    local self = HudObjectComponent.new(properties) :: HudObjectComponent.HudObjectComponent & BaseElement
    self._references = references :: any
    self._locked = false
    self._flag = properties.flag
    self._selected = false

    setMetatable(self, BaseElement)
    
    if not properties.noTextHoverEffect then
        self.AddHoverCallback(self, function()
            runStyle("buttonHover", references.textLabel, {
                TextColor3 = getThemeColor(self._selected and "ElementTextSelectedHover" or "ElementTextHover"),
            })
        end)

        self.AddLeaveCallback(self, function()
            runStyle("buttonLeave", references.textLabel, {
                TextColor3 = self._selected and getThemeColor("ElementTextSelected") or getThemeColor("ElementTextUnselected"),
            })
        end)
    end

    self.SetText(self, properties.text or "New Element")

    return self
end

function BaseElement:SetValue(value : any)
    if not self.CanModify(self, value) then
        return
    end

    self._value = value
    
    local flag = self._flag

    if flag then
        
    end

    local shouldAnimate = true    
    self.SetValueInternal(self, value, shouldAnimate)
end

function BaseElement:SetSelected(isSelected : boolean, shouldAnimate : boolean)
    if self._selected == isSelected then
        return
    end

    self._selected = isSelected
    self.SetSelectedInternal(self, isSelected, shouldAnimate)

    local references = self._references
    local textLabel = references.textLabel

    local newProperties = isSelected and BaseProperties.selected or BaseProperties.unselected
    local oldProperties = isSelected and BaseProperties.unselected or BaseProperties.selected
    local animationStyle = isSelected and "buttonActivate" or "buttonDeactivate"

    applyProperty(textLabel, {
        newProperties.textLabel, oldProperties.textLabel
    }, animationStyle, shouldAnimate)
end

function BaseElement:SetText(text : string)
    local references = self._references

    references.textLabel.Text = text
end

function BaseElement:CanModify(value : any) : boolean
    if self._locked then
        return false
    end

    return self._value ~= value
end

function BaseElement:AddHoverCallback(callback : () -> (), customHoverable : HudObjectComponent.Hoverable?)
    local hoverable = customHoverable or self._hoverable :: HudObjectComponent.Hoverable
    local newMaid = self._maid

    return newMaid.GiveTask(newMaid, hoverable.onHover:Connect(function()
        if self._locked then
            return
        end

        callback()
    end))
end

function BaseElement:AddLeaveCallback(callback : () -> (), customHoverable : HudObjectComponent.Hoverable?)
    local hoverable = customHoverable or self._hoverable :: HudObjectComponent.Hoverable
    local newMaid = self._maid

    return newMaid.GiveTask(newMaid, hoverable.onLeave:Connect(function()
        if self._locked then
            return
        end
        
        callback()
    end))
end

return BaseElement