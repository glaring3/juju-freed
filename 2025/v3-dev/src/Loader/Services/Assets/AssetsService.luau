local AssetsManager = require("@Loader/Services/Assets/AssetsManager")
local AssetsConfig = require("@Loader/Services/Assets/AssetsConfig")

local downloadFromUrl = AssetsManager.downloadFromUrl
local loadFile = AssetsManager.loadFile

local taskSpawn = task.spawn
local makeFolder = makefolder
local isFolder = isfolder
local isFile = isfile
local type = type

local AssetService = {}

function AssetService.init() : boolean
    local didAssetsFail = false

    local folder = AssetsConfig.folder

    if not isFolder(folder) then
        makeFolder(folder)
    end

    local subfolders = AssetsConfig.subfolders
    local downloadUrl = AssetsConfig.downloadUrl

    local recursiveCreateFiles
    
    recursiveCreateFiles = function(currentPath : string, data : {[string]: any})
        for name, content in next, data do
            if type(content) == "table" then
                local newFolderPath = currentPath .. "/" .. name

                if not isFolder(newFolderPath) then
                    makeFolder(newFolderPath)
                end

                recursiveCreateFiles(newFolderPath, content)
            elseif type(content) == "string" then
                local filePath = currentPath .. "/" .. content

                if not isFile(filePath) then
                    local fileUrl = downloadUrl .. filePath

                    local success = downloadFromUrl(fileUrl, filePath)
                    if not success then
                        didAssetsFail = true
                    else
                        loadFile(filePath)
                    end
                else
                    loadFile(filePath)
                end
            end
        end
    end

    recursiveCreateFiles(folder, subfolders)

    return didAssetsFail
end

return AssetService