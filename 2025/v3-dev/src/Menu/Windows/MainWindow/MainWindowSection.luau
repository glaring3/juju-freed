local MainWindowSubsection = require("@Menu/Windows/MainWindow/MainWindowSubsection")
local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local BuilderService = require("@Menu/Services/Builder/BuilderService")
local Animation = require("@Shared/Utils/Animation")
local Maid = require("@Shared/Utils/Maid")

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable
local taskSpawn = task.spawn
local taskWait = task.wait
local runStyle = Animation.runStyle

local MainWindowSection = {}
MainWindowSection.__index = MainWindowSection

export type MainWindowSection = typeof(setMetatable(
    {} :: {
        _references : {[string] : any},
        _subsections : {[string] : MainWindowSubsection.MainWindowSubsection},
        _subsectionsOrdered : {MainWindowSubsection.MainWindowSubsection},
        _selectedSubsection : MainWindowSubsection.MainWindowSubsection | nil,
        _maid : Maid.Maid,
    },
    MainWindowSection
))

function MainWindowSection.new(mainWindowTab : any, properties : {[string] : any}) : MainWindowSection
    local references = {}

    local self = {
        _references = references,
        _subsections = {},
        _subsectionsOrdered = {},
        _maid = Maid.new()
    }

    references.holderFrame = createInstance("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
    }, nil, "SectionBorder")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.holderFrame)

    references.inside = createInstance("Frame", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(21, 21, 24),
    }, references.holderFrame, "SectionBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.inside)

    references.header = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 31),
    }, references.inside, "SectionHeaderBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.header)

    references.headerDivider = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
    }, references.header, "SectionBorder")

    references.headerImage = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(168, 168, 180),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 11, 0, 11),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = properties.image,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 7, 0.5, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.header, "SectionHeaderImage")

    references.headerDownLine = createInstance("Frame", {
        Size = UDim2.new(0, 1, 0, 5),
        Position = UDim2.new(0, 12, 0, 18),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(168, 168, 180),
    }, references.header, "SectionHeaderLine")

    references.headerBottomLine = createInstance("Frame", {
        Size = UDim2.new(0, 54, 0, 1),
        Position = UDim2.new(0, 13, 0, 22),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(168, 168, 180),
    }, references.header, "SectionHeaderLine")

    references.headerFix = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 3,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 31),
    }, references.header, "SectionHeaderBackground")

    references.subsectionHolder = createInstance("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 21, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -30, 0, 24),
        BorderSizePixel = 0,
    }, references.header)

    createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal,
    }, references.subsectionHolder)

    setMetatable(self, MainWindowSection)

    return self
end

function MainWindowSection.SetSelectedSubsection(self : MainWindowSection, selectedSubsection : MainWindowSubsection.MainWindowSubsection)
    local lastSubsection = self._selectedSubsection

    if lastSubsection then
        lastSubsection.Unselect(lastSubsection)
    end

    selectedSubsection.Select(selectedSubsection)

    self._selectedSubsection = selectedSubsection

    local subsectionButton = selectedSubsection._subsectionButton.holderFrame

    if subsectionButton.AbsoluteSize.X == 0 then
        repeat 
            taskWait()
        until subsectionButton.AbsoluteSize.X > 0
    end

    local references = self._references
    local headerBottomLine = references.headerBottomLine

    local newSize = (subsectionButton.AbsolutePosition.X - headerBottomLine.AbsolutePosition.X) + 4 + subsectionButton.AbsoluteSize.X
    
    runStyle("sectionLine", headerBottomLine, {
        Size = UDim2.new(0, newSize, 0, 1)
    })
end

function MainWindowSection.CreateSubsection(self : MainWindowSection, properties : {[string] : any}) : any
    local newSubsectionButton = BuilderService.createUIObject("SubsectionButton", {
        container = self,
        title = properties.title
    })

    newSubsectionButton.holderFrame.Parent = self._references.subsectionHolder

    local newSubsection = MainWindowSubsection.new({
        subsectionButton = newSubsectionButton
    })

    newSubsection._references.elementHolder.Parent = self._references.inside

    local subsections = self._subsections
    local subsectionsOrdered = self._subsectionsOrdered

    local isFirst = not next(subsections)

    subsections[properties.title] = newSubsection
    subsectionsOrdered[#subsectionsOrdered + 1] = newSubsection

    local clickable = newSubsectionButton._clickable
    local maid = self._maid

    maid.GiveTask(maid, clickable.onRelease:Connect(function()
        if self._selectedSubsection == newSubsection then
            return
        end
        
        self.SetSelectedSubsection(self, newSubsection)
    end))

    if isFirst then
        taskSpawn(self.SetSelectedSubsection, self, newSubsection)
    end

    return newSubsection
end

return MainWindowSection