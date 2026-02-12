local InputManager = require("@Menu/Services/Hud/InputManager")
local HudObject = require("@Menu/Services/Builder/Classes/HudObject")

local HudService = {
    _hudObjects = {} :: { [string]: HudObject.HudObject },
    _frame = nil :: any,
    _isOpen = false :: boolean,
}
local hudObjects = HudService._hudObjects

export type HudService = typeof(HudService)

function HudService.init(properties: { [string]: any })
    local screenGui = properties.screenGui
    HudService._screenGui = screenGui
end

function HudService.addHudObject(name: string, hudObject: HudObject.HudObject)
    hudObjects[name] = hudObject

    local holderFrame = hudObject._holderFrame
    holderFrame.Parent = HudService._screenGui
end

function HudService.unload()
    InputManager.stopListening()
end

function HudService.openHud()
    if HudService._isOpen then 
        return 
    end

    for name, hudObject in next, hudObjects do
        hudObject.show(hudObject)
    end

    HudService._isOpen = true
    InputManager.listen()
end

function HudService.closeHud()
    if not HudService._isOpen then 
        return 
    end

    for name, hudObject in next, hudObjects do
        hudObject.hide(hudObject)
    end

    HudService._isOpen = false
    InputManager.stopListening()
end

return HudService