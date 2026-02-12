local ComponentRegistry = {
    _sharedComponents = {},
    _components = {}
}
local sharedComponents = ComponentRegistry._sharedComponents
local components = ComponentRegistry._components

export type ComponentRegistry = typeof(ComponentRegistry)

components.Window = require("@Menu/Services/Builder/Components/Window")
components.Toggle = require("@Menu/Services/Builder/Components/Toggle")
components.TabButton = require("@Menu/Services/Builder/Components/TabButton")
components.SubsectionButton = require("@Menu/Services/Builder/Components/SubsectionButton")

components.Toggle = require("@Menu/Services/Builder/Components/Toggle")
components.Slider = require("@Menu/Services/Builder/Components/Slider")
components.Dropdown = require("@Menu/Services/Builder/Components/Dropdown")
components.BaseElement = require("@Menu/Services/Builder/Components/Base/BaseElement")

sharedComponents.DropdownFrame = require("@Menu/Services/Builder/Components/Shared/DropdownFrame")
sharedComponents.DropdownOption = require("@Menu/Services/Builder/Components/Shared/DropdownOption")

return ComponentRegistry