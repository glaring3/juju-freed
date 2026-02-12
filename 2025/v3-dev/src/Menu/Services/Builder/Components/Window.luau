local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local HudObject = require("@Menu/Services/Builder/Classes/HudObject")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local color3FromRGB = Color3.fromRGB
local udim2FromOffset = UDim2.fromOffset

local Window = {}
Window.__index = Window

setMetatable(Window, {__index = HudObject})

export type Window = typeof(setMetatable(
    {} :: {
        _references : {
            holderFrame : Frame,
            topDivider : Frame,
            topLeft : Frame,
            insideTopLeft : Frame,
            windowSubTitleText : TextLabel?,
            windowSubTitleDivider : Frame?,
        }
    },
    Window
))

function Window.new(properties) : Window
    local references = {}

    local windowTitle = properties.windowTitle or "New Window"
    local subTitle = properties.subTitle or nil

    references.holderFrame = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 550, 0, 400),
        ZIndex = properties.ZIndex or 1,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, nil, "WindowBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
    }, references.holderFrame, nil)
    
    createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        ImageTransparency = 0.23000000417232513,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        ZIndex = -1,
        Size = UDim2.new(1, 8, 1, 8),
        SliceCenter = Rect.new(Vector2.new(10, 10), Vector2.new(118, 118)),
    }, references.holderFrame, "WindowShadow")

    createInstance("UIStroke", {
        Color = Color3.fromRGB(30, 30, 35),
    }, references.holderFrame, "WindowBorder")

    references.bottomShadowHolder = createInstance("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 10,
    }, references.holderFrame, "WindowBackground")

    references.bottomShadow = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(19, 19, 23),
        ScaleType = Enum.ScaleType.Slice,
        AnchorPoint = Vector2.new(0.5, 1),
        Image = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 12),
        ZIndex = 10,
        Size = UDim2.new(1, -2, 0, 27),
        SliceCenter = Rect.new(Vector2.new(10, 10), Vector2.new(118, 118)),
    }, references.bottomShadowHolder, "WindowBackground")

    references.topShadow = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(19, 19, 23),
        ScaleType = Enum.ScaleType.Slice,
        AnchorPoint = Vector2.new(0.5, 0),
        Image = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 41),
        ZIndex = 10,
        Size = UDim2.new(1, -2, 0, 24),
        SliceCenter = Rect.new(Vector2.new(10, 10), Vector2.new(118, 118)),
    }, references.holderFrame, "WindowBackground")

    references.topDivider = createInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 11,
        BorderSizePixel = 0,
    }, references.holderFrame, "WindowTopDivider")

    references.topLeft = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(70, 70, 85),
    }, references.holderFrame, "WindowHeaderBorder")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.topLeft)

    references.insideTopLeft = createInstance("Frame", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(50, 50, 62),
    }, references.topLeft, "WindowHeaderBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
    }, references.insideTopLeft)

    createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
    }, references.insideTopLeft)
    
    if subTitle then
        references.windowSubTitleText = createInstance("TextLabel", {
            LayoutOrder = 3,
            FontFace = "Menu-Semibold",
            TextColor3 = Color3.fromRGB(154, 154, 165),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = subTitle,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 35, 0, 0),
            TextWrapped = true,
            ZIndex = 3,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        }, references.insideTopLeft, "WindowSubTitle")
        
        references.windowSubTitleDivider = createInstance("Frame", {
            LayoutOrder = 2,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 29, 0.5, 0),
            Size = UDim2.new(0, 1, 0, 14),
            ZIndex = 4,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(70, 70, 78),
        }, references.insideTopLeft, "WindowHeaderDivider")
    end

    createInstance("TextLabel", {
        LayoutOrder = 1,
        FontFace = "Menu-Semibold",
        TextColor3 = Color3.fromRGB(220, 220, 245),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = windowTitle,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextWrapped = true,
        ZIndex = 3,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.insideTopLeft, "WindowTitle")

    createInstance("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.insideTopLeft)

    properties.holderFrame = references.holderFrame

    local self = HudObject.new(properties) :: any

    setMetatable(self, Window)
    
    self._references = references

    return self
end

function Window:setSubtitleText(newSubtitleText : string)
    local references = self._references
    local subtitleText = references.windowSubTitleText

    if not subtitleText then
        return
    end

    subtitleText.Text = newSubtitleText
end

return Window