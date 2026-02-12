local ThemeService = require("@Menu/Services/Theme/ThemeService")
local Animation = require("@Shared/Utils/Animation")

local getThemePropertyData = ThemeService.getThemePropertyData
local updateLink = ThemeService.updateLink
local runStyle = Animation.runStyle

local ElementUtils = {}

ElementUtils.applyProperty = LPH_NO_VIRTUALIZE(function(instance : any, propertiesTable : {any}, animationStyle : string, shouldAnimate : boolean)
    local newProperties = {}

    -- Replace any theme property names with their actual values and update links
    local newThemeProperty = propertiesTable[1]
    local oldThemeProperty = propertiesTable[2]

    local propertyData = getThemePropertyData(newThemeProperty)

    newProperties[propertyData[1]] = propertyData[2]
    updateLink(instance, oldThemeProperty, newThemeProperty, true)
    
    if shouldAnimate then
        runStyle(animationStyle, instance, newProperties)
    else
        for propertyName, propertyValue in next, newProperties do
            instance[propertyName] = propertyValue
        end
    end
end)

return ElementUtils