local getRawMetatable = getrawmetatable
local setRawMetatable = setrawmetatable
local Workspace = workspace

local originalMetatable = getRawMetatable(Workspace) :: {[any]: any}

local InstanceProtection = {}

function InstanceProtection.protectInstance(instance: Instance?, callback: (flagData: string) -> ()) : any?
    if not instance then
        return nil
    end

    local newMetatable = {
        __iter = function()
            callback("instance iter")
        end,
        __tostring = function()
            callback("instance tostring")
            return ""
        end
    }
    
    for index, func in next, originalMetatable do
        if not newMetatable[index] then
            newMetatable[index] = func
        end
    end

    setRawMetatable(instance, newMetatable)

    return newMetatable
end

return InstanceProtection