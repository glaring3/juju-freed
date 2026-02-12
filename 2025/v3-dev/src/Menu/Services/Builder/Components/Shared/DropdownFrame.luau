local DropdownOption = require("@Menu/Services/Builder/Components/Shared/DropdownOption")
local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local AssetsManager = require("@Loader/Services/Assets/AssetsManager")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local Animation = require("@Shared/Utils/Animation")
local Hoverable = require("@Menu/Services/Builder/Properties/Hoverable")
local Gui = require("@Shared/Utils/Gui")

local createInstance = ThemedInstances.createInstance
local getThemeColor = ThemeService.getThemeColor
local linkInstance = ThemeService.linkInstance
local setMetatable = setmetatable
local getTextSize = Gui.getTextSize
local vector2New = Vector2.new
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local MAX_FRAME_HEIGHT = 80
local FONT = AssetsManager.getFont("Menu-Bold") :: Font

local DropdownFrame = {
    _references = {} :: {
        dropdownFrame : ScrollingFrame,
        UICorner : UICorner,
        UIPadding : UIPadding,
        UIListLayout : UIListLayout,
        UIStroke : UIStroke,
    },
    _currentOptions = {},
    isVisible = false :: boolean
}
local currentOptions = DropdownFrame._currentOptions
local references = DropdownFrame._references

export type DropdownFrame = typeof(DropdownFrame)

function DropdownFrame.addOption(optionName : string, optionImage : string?)
    local newOption = DropdownOption.new(optionName, optionImage)
    
    local Clickable = newOption._clickable
    local Hoverable = newOption._hoverable :: Hoverable.Hoverable

    Hoverable.onHover:Connect(function()
        runStyle("buttonHover", newOption._references.optionLabel, {
            TextColor3 = getThemeColor("DropdownOptionTextHover")
        })
    end)

    Hoverable.onLeave:Connect(function()
        runStyle("buttonLeave", newOption._references.optionLabel, {
            TextColor3 = newOption.isSelected and getThemeColor("DropdownOptionTextUnselected") or getThemeColor("DropdownOptionTextSelected")
        })
    end)
end

function DropdownFrame.removeOption()
    
end

function DropdownFrame.open(bindFrame : GuiObject, options : {{optionName: string, optionImage: string?}})
    if DropdownFrame.isVisible then
        return
    end
    DropdownFrame.isVisible = true

    local longestNameLength = 0
    for _, option in next, options do
        local nameSize = getTextSize(option.optionName, FONT, 14)
        if nameSize.X > longestNameLength then
            longestNameLength = nameSize.X
        end
    end

    local dropdownFrame = references.dropdownFrame
    dropdownFrame.Size = udim2New(0, longestNameLength + 16, 0, references.dropdownFrame.Size.Y.Offset)
    dropdownFrame.Visible = true

    local newPosition = bindFrame.AbsolutePosition + bindFrame.AbsoluteSize + vector2New(0, 2)
    dropdownFrame.Position = udim2New(0, newPosition.X, 0, newPosition.Y)
    
    local dropPosition = bindFrame.AbsolutePosition + bindFrame.AbsoluteSize + vector2New(0, 6)

    runStyle("secondaryDrop", dropdownFrame, {
        Position = udim2New(0, dropPosition.X, 0, dropPosition.Y)
    })
end

function DropdownFrame.close()
    if not DropdownFrame.isVisible then
        return
    end
    DropdownFrame.isVisible = false

    local dropdownFrame = references.dropdownFrame
    dropdownFrame.Visible = false
end

function DropdownFrame.init()
    local dropdownFrame = createInstance("ScrollingFrame", {
        ScrollBarImageColor3 = Color3.fromRGB(129, 129, 150),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 1,
        Selectable = false,
        BackgroundColor3 = Color3.fromRGB(38, 38, 45),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 58, 0, 54),
        Position = UDim2.new(0, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, require("@Menu/Services/Hud/HudService")._screenGui) :: ScrollingFrame
    references.dropdownFrame = dropdownFrame

    linkInstance(references.dropdownFrame, "DropdownOptionScrollBar")
    linkInstance(references.dropdownFrame, "DropdownOptionBackground")

    references.UICorner = createInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
    }, references.dropdownFrame) :: UICorner

    references.UIPadding = createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
    }, references.dropdownFrame) :: UIPadding

    references.UIListLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.dropdownFrame) :: UIListLayout

    references.UIStroke = createInstance("UIStroke", {
        Color = Color3.fromRGB(46, 46, 54),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.dropdownFrame, "DropdownOptionBorder") :: UIStroke

    references.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local absoluteSize = dropdownFrame.AbsoluteSize

        local exceedsHeight = absoluteSize.Y > MAX_FRAME_HEIGHT
        if exceedsHeight then
            dropdownFrame.AutomaticSize = Enum.AutomaticSize.None
            dropdownFrame.Size = UDim2.new(0, absoluteSize.X, 0, MAX_FRAME_HEIGHT)
        else
            dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
        end
    end)
end

return DropdownFrame