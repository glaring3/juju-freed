local RunService = cloneref(game.GetService(game, "RunService")) :: RunService

local MainWindowSection = require("@Menu/Windows/MainWindow/MainWindowSection")
local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local renderStepped = RunService.RenderStepped
local renderSteppedWait = renderStepped.Wait

local MainWindowTab = {}
MainWindowTab.__index = MainWindowTab

export type MainWindowTab = typeof(setMetatable(
    {} :: {
        _tabButton : any,
        _isVisible : boolean,
        _references : {[string] : any},
        _sections : {[string] : MainWindowSection.MainWindowSection},
        _sectionsOrdered : {MainWindowSection.MainWindowSection},
    },
    MainWindowTab
))

function MainWindowTab.new(properties : {[string] : any}) : MainWindowTab
    local references = {}

    references.tabFrame = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 9, 0, 51),
        Size = UDim2.new(1, -18, 1, -53),
        ZIndex = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Visible = false
    })

    references.sectionContainer = createInstance("ScrollingFrame", {
        ScrollBarImageColor3 = Color3.fromRGB(120, 120, 140),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Selectable = false,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 21,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, references.tabFrame)

    references.left = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -5, 1, 0),
        ZIndex = 12,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.sectionContainer)

    references.leftLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.left)

    references.right = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0.5, -5, 1, 0),
        ZIndex = 12,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.sectionContainer)

    references.rightLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.right)

    createInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
    }, references.sectionContainer)

    local tabButton = properties.tabButton

    local self = {
        _tabButton = tabButton,
        _isVisible = false,
        _sections = {},
        _sectionsOrdered = {},
        _references = references
    }

    setMetatable(self, MainWindowTab)

    return self
end

function MainWindowTab.Select(self : MainWindowTab)
    if self._isVisible then
        return
    end

    self._isVisible = true
    self._references.tabFrame.Visible = true
    self._tabButton:SetSelected(true)
end

function MainWindowTab.Unselect(self : MainWindowTab)
    if not self._isVisible then
        return
    end

    self._isVisible = false
    self._references.tabFrame.Visible = false
    self._tabButton:SetSelected(false)
end

function MainWindowTab.CreateSection(self : MainWindowTab, properties : {[string] : any}) : MainWindowSection.MainWindowSection
    local newSection = MainWindowSection.new(self, properties)
    local sectionsOrdered = self._sectionsOrdered

    self._sections[properties.title] = newSection
    sectionsOrdered[#sectionsOrdered + 1] = newSection

    return newSection
end

function MainWindowTab.RefreshSectionsLayout(self : MainWindowTab)
    local sectionsOrdered = self._sectionsOrdered
    local rightLayout = self._references.rightLayout
    local leftLayout = self._references.leftLayout

    for i = 1, #sectionsOrdered do
        local section = sectionsOrdered[i]
        local references = section._references

        local holderFrame = references.holderFrame
        holderFrame.Parent = nil
    end

    for i = 1, #sectionsOrdered do
        renderSteppedWait(renderStepped)

        local section = sectionsOrdered[i]
        local references = section._references

        local holderFrame = references.holderFrame

        if leftLayout.AbsoluteContentSize.Y <= rightLayout.AbsoluteContentSize.Y then
            holderFrame.Parent = self._references.left
        else
            holderFrame.Parent = self._references.right
        end
    end
end

return MainWindowTab