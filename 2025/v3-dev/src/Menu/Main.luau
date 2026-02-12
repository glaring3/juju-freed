local BuilderService = require("@Menu/Services/Builder/BuilderService")
local KeybindService = require("@Menu/Services/Keybinds/KeybindService")
local ThemeService = require("@Menu/Services/Theme/ThemeService")
local InputManager = require("@Menu/Services/Hud/InputManager")
local HudService = require("@Menu/Services/Hud/HudService")
local Instances = require("@Shared/Utils/Instances")

local createInstance = Instances.createInstance
local destroy = workspace.Destroy

local Menu = {
    _screenGui = nil :: Instance?,
}

function Menu.init(menuConfig: any)
    ThemeService.init()
    
    local newScreenGui = createInstance("ScreenGui", {
        RandomizedName = true,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ScreenInsets = Enum.ScreenInsets.None
    }, cloneref(gethui()))

    Menu._screenGui = newScreenGui
    HudService.init({
        screenGui = newScreenGui
    })

    local mainWindow = require("@Menu/Windows/MainWindow/MainWindow") :: any

    --[[local playersWindow = require("@Menu/Windows/PlayersWindow/PlayersWindow") :: any
    playersWindow.init()--]]

    HudService.addHudObject("MainWindow", mainWindow.init({
        windowTitle = "Juju",
        subTitle = menuConfig.mainWindow.subTitle,
        tabs = menuConfig.mainWindow.tabs
    }))
    
    --HudService.addHudObject("PlayersWindow", playersWindow)

    local toggleMenuKeybind = KeybindService.createInternalBind({
        name = "ToggleMenu",
        keyCode = Enum.KeyCode.LeftAlt,
    })

    toggleMenuKeybind._onTriggered:Connect(function()
        if HudService._isOpen then
            HudService.closeHud()
        else
            HudService.openHud()
        end
    end)

    -- Initialize BuilderService

    BuilderService.init()
    KeybindService.init()
    HudService.openHud()
end

function Menu.unload()
    local screenGui = Menu._screenGui

    if screenGui then
        destroy(screenGui)
        Menu._screenGui = nil
    end

    HudService.unload()
end

return Menu