local HudObjectComponent = require("@Menu/Services/Builder/Classes/HudObjectComponent")
local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local Animation = require("@Shared/Utils/Animation")
local Signal = require("@Shared/Utils/Signal")
local Maid = require("@Shared/Utils/Maid")
local Gui = require("@Shared/Utils/Gui")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local updateLink = ThemeService.updateLink
local getTextSize = Gui.getTextSize
local runStyle = Animation.runStyle

local udim2New = UDim2.new

local TabButton = {}
TabButton.__index = TabButton

setMetatable(TabButton, {__index = HudObjectComponent})

export type TabButton = typeof(setMetatable(
    {} :: {
        _isSelected : boolean,
        _references : {
            holderFrame : TextButton,
            buttonText : TextLabel,
            buttonImage : ImageLabel,
        },
        _maid : Maid.Maid,
    },
    TabButton
))

function TabButton.new(properties : any) : TabButton
    properties.isHoverable = true
    properties.isClickable = true

    local title = properties.title

    local references = {}

    references.holderFrame = createInstance("TextButton", {
        Active = false,
        Selectable = false,
        ZIndex = 16,
        TextSize = 11,
        Size = UDim2.new(0, 0, 0, 25),
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0,
    }, nil, "SectionHeaderTextUnselected") :: TextButton

    references.buttonText = createInstance("TextLabel", {
	    LayoutOrder = 2,
        FontFace = "Menu-Semibold",
        TextColor3 = Color3.fromRGB(220, 220, 245),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = title,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 22, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 15,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.holderFrame, "TabButtonTextUnselected") :: TextLabel

    references.buttonImage = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(130, 130, 144),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = properties.image,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0.5, 0),
        ZIndex = 15,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.holderFrame, "TabButtonImageUnselected") :: ImageLabel

    local holderFrame = references.holderFrame :: TextButton
    properties.holderFrame = holderFrame

    local self = HudObjectComponent.new(properties) :: HudObjectComponent.HudObjectComponent & TabButton
    self._references = references

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask
    self._maid = newMaid

    local newSize = getTextSize(title, references.buttonText.FontFace, 14)

    references.holderFrame.Size = udim2New(0, newSize.X + 26, 0, 25)
    
    setMetatable(self, TabButton)
    
    local hoverable = self._hoverable :: HudObjectComponent.Hoverable

    giveTask(newMaid, hoverable.onHover:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonHover", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextHover"),
        })
        runStyle("buttonHover", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageHover"),
        })
    end))

    giveTask(newMaid, hoverable.onLeave:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonLeave", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextUnselected"),
        })
        runStyle("buttonLeave", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageUnselected"),
        })
    end))

    return self
end

function TabButton:SetSelected(isSelected : boolean)
    if self._isSelected == isSelected then
        return
    end

    self._isSelected = isSelected

    local references = self._references

    if isSelected then
        runStyle("buttonActivate", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextSelected"),
        })
        runStyle("buttonActivate", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageSelected"),
        })
        updateLink(references.buttonImage, "TabButtonImageUnselected", "TabButtonImageSelected", true)
        updateLink(references.buttonText, "TabButtonTextUnselected", "TabButtonTextSelected", true)
    else
        runStyle("buttonDeactivate", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageUnselected"),
        })
        runStyle("buttonDeactivate", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextUnselected"),
        })
        updateLink(references.buttonImage, "TabButtonImageSelected", "TabButtonImageUnselected", true)
        updateLink(references.buttonText, "TabButtonTextSelected", "TabButtonTextUnselected", true)
    end
end

return TabButton