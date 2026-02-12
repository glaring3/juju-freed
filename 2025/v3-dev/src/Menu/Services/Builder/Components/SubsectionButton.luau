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
local updateLink = ThemeService.updateLink
local runStyle = Animation.runStyle

local SubsectionButton = {}
SubsectionButton.__index = SubsectionButton

setMetatable(SubsectionButton, {__index = HudObjectComponent})

export type SubsectionButton = typeof(setMetatable(
    {} :: {
        _isSelected : boolean,
        _maid : Maid.Maid,
    },
    SubsectionButton
))

function SubsectionButton.new(properties : any) : SubsectionButton
    properties.isHoverable = true
    properties.isClickable = true

    local references = {}

    references.holderFrame = createInstance("TextButton", {
        FontFace = "Menu-Bold",
        Active = false,
        Selectable = false,
        ZIndex = 16,
        TextSize = 11,
        Size = UDim2.new(0, 0, 0, 25),
        TextColor3 = Color3.fromRGB(194, 194, 207),
        Text = properties.title:upper(),
        AutoButtonColor = false,
        TextWrapped = true,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
    }, nil, "SectionHeaderTextUnselected")

    local holderFrame = references.holderFrame :: TextButton
    properties.holderFrame = holderFrame

    local self = HudObjectComponent.new(properties) :: HudObjectComponent.HudObjectComponent & SubsectionButton
    self._references = references
    
    setMetatable(self, SubsectionButton)

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask
    
    local hoverable = self._hoverable :: HudObjectComponent.Hoverable

    giveTask(newMaid, hoverable.onHover:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonHover", references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextHover"),
        })
    end))

    giveTask(newMaid, hoverable.onLeave:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonHover", references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextUnselected"),
        })
    end))

    return self
end

function SubsectionButton:SetSelected(isSelected : boolean)
    if self._isSelected == isSelected then
        return
    end
    
    self._isSelected = isSelected

    local references = self._references
    local style = isSelected and "buttonActivate" or "buttonDeactivate"

    if isSelected then
        runStyle(style, references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextSelected"),
        })
        updateLink(references.holderFrame, "SectionHeaderTextUnselected", "SectionHeaderTextSelected", true)
    else
        runStyle(style, references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextUnselected"),
        })
        updateLink(references.holderFrame, "SectionHeaderTextSelected", "SectionHeaderTextUnselected", true)
    end
end

return SubsectionButton