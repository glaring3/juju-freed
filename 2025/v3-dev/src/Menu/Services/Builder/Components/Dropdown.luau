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
local getMouseLocation = UserInputService.GetMouseLocation

local renderStepped = RunService.RenderStepped
local renderSteppedWait = renderStepped.Wait
local mouseButton1 = Enum.UserInputType.MouseButton1

local createInstance = ThemedInstances.createInstance
local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local setMetatable = setmetatable
local vector2New = Vector2.new
local mathClamp = math.clamp
local mathRound = Math.round
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local DropdownProperties = {
    selected = {
        dropdownBox = "ElementBackgroundSelected",
        boxBorder = "ElementBorderSelected",
        boxLabel = "DropdownTextSelected",
        boxImage = "DropdownImageSelected",
    },
    unselected = {
        dropdownBox = "ElementBackgroundUnselected",
        boxBorder = "ElementBorderUnselected",
        boxLabel = "DropdownBoxTextUnselected",
        boxImage = "DropdownImageUnselected",
    },
}

local Dropdown = {}
Dropdown.__index = Dropdown

setMetatable(Dropdown, {__index = BaseElement})

export type Dropdown = typeof(setMetatable(
    {} :: {
        _value : {
            [any] : any
        },
        _references : {
            [string] : Instance | GuiObject,
            dropdownBox : TextButton,
            boxBorder : UIStroke,
            boxLabel : TextLabel,
            boxImage : ImageLabel
        },
        _maid : Maid.Maid,
        _maximumSelected : number,
        _minimumSelected : number,
        _defaultValue : {[any] : any}?,
        _boxHoverable : any
    },
    Dropdown
))

function Dropdown.new(properties : any) : Dropdown
    local self = BaseElement.new(properties) :: BaseElement.BaseElement & Dropdown
    local references = self._references

    references.dropdownBox = createInstance("TextButton", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 1, -2),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(29, 29, 34),
        Text = "",
        Active = false,
        AutoButtonColor = false,
    }, references.elementContainer, "ElementBackgroundUnselected") :: TextButton

    createInstance("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.dropdownBox)

    createInstance("UICorner", {
        CornerRadius = UDim.new(0.25, 0),
    }, references.dropdownBox)

    references.boxBorder = createInstance("UIStroke", {
        Color = Color3.fromRGB(32, 32, 38),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.dropdownBox, "ElementBorderUnselected") :: UIStroke

    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
    }, references.dropdownBox)

    references.boxLabel = createInstance("TextLabel", {
        FontFace = "Menu-Bold",
        TextColor3 = Color3.fromRGB(92, 92, 108),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "None",
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, -1),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextXAlignment = Enum.TextXAlignment.Right,
        BorderSizePixel = 0,
        TextSize = 11,
        LayoutOrder = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.dropdownBox, "DropdownBoxTextUnselected") :: TextLabel

    references.dropdownDividerHolder = createInstance("Frame", {
        LayoutOrder = 2,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 4, 1, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    }, references.dropdownBox) :: Frame

    references.dropdownDivider = createInstance("Frame", {
        LayoutOrder = 2,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(0, 2, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    }, references.dropdownDividerHolder, "DropdownDividerUnselected") :: Frame

    references.boxImage = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(92, 92, 121),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 6, 0, 6),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = "Dropdown",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, 0),
        LayoutOrder = 3,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.dropdownBox, "DropdownImageUnselected") :: ImageLabel

    setMetatable(self, Dropdown)

    -- Initialize properties

    self._minimumSelected = properties.minimumSelected or 0
    self._maximumSelected = properties.maximumSelected or 1
    self._value = {}
    
    -- Initialize Clickable

    local maid = self._maid
    local giveTask = maid.GiveTask

    -- Hovering

    local boxHoverable = Hoverable.new(references.dropdownBox)
    self._boxHoverable = boxHoverable

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.boxBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
    end, boxHoverable)

    self.AddLeaveCallback(self, function()
        runStyle("buttonLeave", references.boxBorder, {
            Color = getThemeColor(self._selected and "ElementBorderSelected" or "ElementBorderUnselected"),
        })
    end, boxHoverable)

    -- Set default value

    self.SetValueInternal(self, properties.defaultValue or nil, false)

    return self
end

function Dropdown:SetValueInternal(value : number, shouldAnimate : boolean)
    
end

function Dropdown:SetSelectedInternal(isSelected : boolean, shouldAnimate : boolean)
    local references = self._references

    local newProperties = isSelected and DropdownProperties.selected or DropdownProperties.unselected
    local oldProperties = isSelected and DropdownProperties.unselected or DropdownProperties.selected

    for referenceName, themeProperty in next, newProperties do
        applyProperty(references[referenceName], {themeProperty, oldProperties[referenceName]}, isSelected and "buttonActivate" or "buttonDeactivate", shouldAnimate)
    end
end

return Dropdown