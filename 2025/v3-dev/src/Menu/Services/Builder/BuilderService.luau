local ComponentRegistry = require("@Menu/Services/Builder/ComponentRegistry")
local components = ComponentRegistry._components

local BuilderService = {}
export type BuilderService = typeof(BuilderService)

function BuilderService.init()
    for _, sharedComponent in next, ComponentRegistry._sharedComponents do
        sharedComponent.init()
    end
end

function BuilderService.createUIObject(objectType : string, properties : any) : any
    local objectData = components[objectType]

    if not objectData then
        return
    end

    local newObject = objectData.new(properties)

    return newObject
end

return BuilderService