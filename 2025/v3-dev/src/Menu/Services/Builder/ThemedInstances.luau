local AssetsManager = require("@Loader/Services/Assets/AssetsManager")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local Instances = require("@Shared/Utils/Instances")

local createInstance = Instances.createInstance
local getImage = AssetsManager.getImage
local getFont = AssetsManager.getFont

local isA = game.IsA

local ThemedInstances = {}
export type ThemedInstances = typeof(ThemedInstances)

function ThemedInstances.createInstance(instanceType : string, properties : {[string]: any}, parent : any, themeProperty : any) : Instance
    local image = properties.Image

    if image then
        properties.Image = getImage(image) or ""
    end

    local fontFace = properties.FontFace

    if fontFace then
        properties.FontFace = getFont(fontFace) or error("Font '" .. fontFace .. "' not found in AssetsManager.")
    end

    local newInstance = createInstance(instanceType, properties, parent) :: any

    if parent and isA(newInstance, "GuiObject") then
        local zIndex = properties.ZIndex
        newInstance.ZIndex = zIndex and parent.ZIndex + zIndex or parent.ZIndex
    end

    if not themeProperty then
        return newInstance
    end

    ThemeService.linkInstance(newInstance, themeProperty)

    return newInstance
end

return ThemedInstances