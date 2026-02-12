local HudObjectComponent = require("@Menu/Services/Builder/Classes/HudObjectComponent")
local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local ThemeService = require("@Menu/Services/Theme/ThemeService")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable
local updateLink = ThemeService.updateLink
local destroy = game.Destroy

local DropdownOption = {}
DropdownOption.__index = DropdownOption

setMetatable(DropdownOption, {__index = HudObjectComponent})

export type DropdownOption = typeof(setMetatable(
    {} :: {
        _references: {
            optionLabel: TextLabel,
            optionDivider: Frame,
            optionCheck: ImageLabel
        },
        isSelected: boolean
    },
    DropdownOption
))

function DropdownOption.new(optionName : string, optionImage : string?) : DropdownOption & HudObjectComponent.HudObjectComponent
    local self = HudObjectComponent.new({
        isClickable = true,
        isHoverable = true
    }) :: DropdownOption & HudObjectComponent.HudObjectComponent

    setMetatable(self, DropdownOption)

    local references = self._references
    references.optionLabel = createInstance("TextLabel", {
        FontFace = "Menu-Bold",
        TextColor3 = Color3.fromRGB(195, 195, 213),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = optionName,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0.9200000166893005, 0, -0.40243902802467346, 0),
        TextSize = 11,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, nil, "DropdownOptionTextUnselected") :: TextLabel

    references.optionDivider = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 4),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(54, 54, 63),
    }, references.optionLabel, "DropdownOptionDivider") :: Frame

    references.optionCheck = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(216, 216, 235),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ResampleMode = Enum.ResamplerMode.Pixelated,
        Size = UDim2.new(0, 8, 0, 8),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = optionImage or "Checkmark",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0.5, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.optionLabel, "DropdownOptionImage") :: ImageLabel

    return self
end

function DropdownOption:Destroy()
    local references = self._references
    for index, instance in next, references do
        destroy(instance)
        references[index] = nil
    end
end

function DropdownOption:SetSelected()
    if self.isSelected then
        return
    end
    self.isSelected = true

    local references = self._references
    updateLink(references.optionLabel, "DropdownOptionTextUnelected", "DropdownOptionTextSelected")
end

function DropdownOption:SetUnselected()
    if not self.isSelected then
        return
    end
    self.isSelected = false

    local references = self._references
    updateLink(references.optionLabel, "DropdownOptionTextSelected", "DropdownOptionTextUnselected")
end

return DropdownOption