local ThemedInstances = require("@Menu/Services/Builder/ThemedInstances")
local BuilderService = require("@Menu/Services/Builder/BuilderService")

local createInstance = ThemedInstances.createInstance
local createUIObject = BuilderService.createUIObject
local setMetatable = setmetatable

local MainWindowSubsection = {}
MainWindowSubsection.__index = MainWindowSubsection

export type MainWindowSubsection = typeof(setMetatable(
    {} :: {
        _references : {[string] : any},
        _isSelected : boolean,
        _elements : {[string] : any},
        _elementsOrdered : {any},
        _subsectionButton : any,
    }, 
    MainWindowSubsection
))

function MainWindowSubsection.new(properties : {[string] : any}) : MainWindowSubsection
    local references = {}

    local self = {
        _references = references,
        _isSelected = false,
        _elements = {},
        _elementsOrdered = {},
        _subsectionButton = properties.subsectionButton
    }

    references.elementHolder = createInstance("Frame", {
        Position = UDim2.new(0, 9, 0, 36),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -18, 1, -43),
        BorderSizePixel = 0,
        Visible = false
    }, nil)

    createInstance("UIListLayout", {
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.elementHolder)

    createInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
    }, references.elementHolder)
    
    setMetatable(self, MainWindowSubsection)

    return self
end

function MainWindowSubsection.Select(self : MainWindowSubsection)
    if self._isSelected then
        return
    end

    self._isSelected = true
    self._references.elementHolder.Visible = true
    self._subsectionButton:SetSelected(true)
end

function MainWindowSubsection.Unselect(self : MainWindowSubsection)
    if not self._isSelected then
        return
    end

    self._isSelected = false
    self._references.elementHolder.Visible = false
    self._subsectionButton:SetSelected(false)
end

function MainWindowSubsection.CreateElement(self : MainWindowSubsection, properties : {element : string, title : string, elementProperties : {[string] : any}}) : any
    local elementType = properties.element
    local title = properties.title

    local newElement = createUIObject(elementType, properties.elementProperties)

    newElement.holderFrame.Parent = self._references.elementHolder

    local elementsOrdered = self._elementsOrdered
    local elements = self._elements

    elementsOrdered[#elementsOrdered + 1] = newElement
    elements[title] = newElement
    
    return newElement
end

return MainWindowSubsection