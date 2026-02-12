local MenuAnimations = require("@Menu/Services/Theme/MenuAnimations")
local ThemeProperties = require("@Menu/Services/Theme/ThemeProperties")
local Signal = require("@Shared/Utils/Signal")
local Maid = require("@Shared/Utils/Maid")

local ThemeService = {
    onThemePropertyChanged = Signal.new(),
    _dynamicLinkedInstances = {},
    _linkedInstances = {},
    _maid = Maid.new() :: Maid.Maid,
}
local linkedInstances = ThemeService._linkedInstances
--local newMaid = ThemeService._maid

for property, _ in next, ThemeProperties do
    linkedInstances[property] = {}
end

function ThemeService.init() : typeof(ThemeService)
    MenuAnimations.init()

    return ThemeService
end

function ThemeService.getThemeColor(themeProperty : string) : Color3
    local propertyData = ThemeProperties[themeProperty] :: any

    return propertyData[2]
end

function ThemeService.getThemeProperty(themeProperty : string) : string
    local propertyData = ThemeProperties[themeProperty] :: any

    return propertyData[1]
end

function ThemeService.getThemePropertyData(themeProperty : string) : {propertyName : string, propertyColor : Color3}
    return ThemeProperties[themeProperty] :: any
end

function ThemeService.linkInstance(instance : any, themeProperty : string | any, noColorUpdate : boolean | nil)
    local propertyData = ThemeProperties[themeProperty]

    if not noColorUpdate then
        instance[propertyData[1]] = propertyData[2]
    end

    local linkedInstances = linkedInstances[themeProperty]
    linkedInstances[#linkedInstances + 1] = instance
end

function ThemeService.updateLink(instance : any, oldThemeProperty : string | any, newThemeProperty : string | any, noColorUpdate : boolean | nil)
    local linkedInstances = linkedInstances[oldThemeProperty]
    local total = #linkedInstances

    for i = 1, total do
        if linkedInstances[i] == instance then
            linkedInstances[total] = linkedInstances[i]
            linkedInstances[total] = nil
            break
        end
    end
    
    ThemeService.linkInstance(instance, newThemeProperty, noColorUpdate)
end

function ThemeService.setThemeProperty(themeProperty : string, value : Color3)
    local linkedInstances = linkedInstances[themeProperty]
    local propertyData = ThemeProperties[themeProperty]
    local property = propertyData[2]
    for index, instance in next, linkedInstances do
        if not instance then
            linkedInstances[index] = nil
            continue
        end

        instance[property] = value
    end

    ThemeService.onThemePropertyChanged:Fire(themeProperty, value)
end

return ThemeService