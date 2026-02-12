local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local BuilderService = require("@Menu/Services/Builder/BuilderService")
local MainWindowTab = require("@Menu/Windows/MainWindow/MainWindowTab")
local Animation = require("@Shared/Utils/Animation")
local Window = require("@Menu/Services/Builder/Components/Window")
local Maid = require("@Shared/Utils/Maid")

local udim2FromOffset = UDim2.fromOffset
local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local MainWindow = {}
MainWindow.__index = MainWindow

export type MainWindow = typeof(setMetatable(
    {} :: {
        _tabs: { [string] : MainWindowTab.MainWindowTab },
        _selectedTab: MainWindowTab.MainWindowTab | nil,
        _maid : Maid.Maid,
    },
    MainWindow
))

setMetatable(MainWindow, {__index = Window})

function MainWindow.init(properties : {[string] : any}) : any
    local window = BuilderService.createUIObject("Window", {
        isDraggable = true,
        isForcedVisible = false,
        minSize = udim2FromOffset(550, 400),
        maxSize = udim2FromOffset(1000, 700),
        windowTitle = properties.windowTitle,
        subTitle = properties.subTitle,
        zIndex = 10
    })

    local references = window._references

    references.topRight = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BorderSizePixel = 0,
        Position = udim2New(1, -10, 0, 10),
        Size = udim2New(0, 0, 0, 30),
        ZIndex = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(23, 23, 29),
    }, references.holderFrame, "WindowRightHeaderBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.topRight)

    references.tabSlider = createInstance("Frame", {
        BorderSizePixel = 0,
        Size = udim2New(1, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 14,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(50, 50, 62),
    }, nil, "TabButtonSlideBackground")

    createInstance("UIStroke", {
        Color = Color3.fromRGB(70, 70, 85),
    }, references.tabSlider, "TabButtonSlideBorder")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
    }, references.tabSlider)

    references.tabContainer = createInstance("Frame", {
        BackgroundTransparency = 1,
        Position = udim2New(0, 0, 0, 2),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = udim2New(0, 0, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.X,
    }, references.topRight)

    createInstance("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.tabContainer)

    createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
    }, references.tabContainer)

    createInstance("UIStroke", {
        Color = Color3.fromRGB(35, 35, 42),
    }, references.topRight, "WindowRightHeaderBorder")

    local tabs = properties.tabs or {}

    setMetatable(window, MainWindow)
    
    local windowTabs = {}
    window._tabs = windowTabs
    window._maid = Maid.new()
    window._selectedTab = nil

    for i = 1, #tabs do
        local tabProperties = tabs[i]

        local newTab = window.CreateTab(window, {
            title = tabProperties.title,
            image = tabProperties.image,
            order = i
        })
        
        windowTabs[tabProperties.title] = newTab
        
        local sections = tabProperties.sections or {}

        for i = 1, #sections do
            local sectionProperties = sections[i]
            local newSection = newTab.CreateSection(newTab, sectionProperties)

            local subsections = sectionProperties.subsections or {}

            for j = 1, #subsections do
                local subSectionProperties = subsections[j]
                local newSubsection = newSection.CreateSubsection(newSection, subSectionProperties)

                local elements = subSectionProperties.elements or {}

                for i = 1, #elements do
                    local newElement = newSubsection.CreateElement(newSubsection, elements[i])
                    
                end
            end
        end

        newTab.RefreshSectionsLayout(newTab)
    end

    return window
end

function MainWindow.CreateTab(self : any, properties : {[string] : any}) : any
    local tabButton = BuilderService.createUIObject("TabButton", {
        container = self._references.tabContainer,
        title = properties.title,
        image = properties.image
    })

    local newTab = MainWindowTab.new({
        tabButton = tabButton,
        order = properties.order
    }) :: MainWindowTab.MainWindowTab

    newTab._references.tabFrame.Parent = self._references.holderFrame
    tabButton._references.holderFrame.Parent = self._references.tabContainer
    
    local tabs = self._tabs
    local isFirstTab = next(tabs) == nil

    tabs[properties.title] = newTab

    if isFirstTab then
        self.SetSelectedTab(self, properties.title)
    end

    local clickable = tabButton._clickable
    local maid = self._maid

    maid.GiveTask(maid, clickable.onRelease:Connect(function()
        if self._selectedTab == newTab then
            return
        end
        
        self.SetSelectedTab(self, properties.title)
    end))

    return newTab
end

function MainWindow.SetSelectedTab(self : any, tabName : string)
    local lastTab = self._selectedTab

    if lastTab then
        lastTab.Unselect(lastTab)
    end

    local tab = self._tabs[tabName]

    if tab then
        tab.Select(tab)
    end

    self._selectedTab = tab

    local tabButton = tab._tabButton
    local tabReferences = tab._references
    local tabHolderFrame = tabButton._references.holderFrame

    local references = self._references
    local tabSlider = references.tabSlider

    if not tabSlider.Parent then
        tabSlider.Parent = tabHolderFrame
        tabSlider.Position = udim2New(0, 0, 0, 0)
        return
    end

    local tabFrame = tabReferences.tabFrame
    tabFrame.Position = UDim2.new(0, 9, 0, 43)

    runStyle("tabDrop", tabFrame, {
        Position = UDim2.new(0, 9, 0, 51)
    })

    local lastAbsolutePosition = tabSlider.AbsolutePosition
    tabSlider.Parent = tabButton._references.holderFrame

    local newPosition = tabHolderFrame.AbsolutePosition
    local offsetX = lastAbsolutePosition.X - newPosition.X

    tabSlider.Position = udim2New(0, offsetX, 0, 0)

    runStyle("tabSlide", tabSlider, {
        Position = udim2New(0, 0, 0, 0)
    }, function()
        tabSlider.Position = udim2New(0, 0, 0, 0)
    end)
end

return MainWindow