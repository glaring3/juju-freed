local HttpService = cloneref(game:GetService("HttpService"))

local getCustomAsset = getcustomasset
local httpGet = (game :: any).HttpGet
local jsonEncode = HttpService.JSONEncode
local writeFile = writefile
local readFile = readfile
local fontNew = Font.new
local delFile = delfile
local pcall = pcall
local game = game

local normal = Enum.FontStyle.Normal
local bold = Enum.FontWeight.Bold

local AssetsManager = {
    _assetCache = {
        images = {},
        fonts = {}
    }
}
local assetCache = AssetsManager._assetCache

local function getExtension(path : string) : string
    local dotIndex = path:find("%.")

    if dotIndex then
        return path:sub(dotIndex + 1)
    else
        return ""
    end
end

local function getName(path: string) : string
    local slashIndex = path:match("^.*/()") or 0
    local dotIndex = path:find("%.", slashIndex) or (#path + 1)

    return path:sub(slashIndex, dotIndex - 1)
end

function AssetsManager.loadFont(path : string)
    local fileName = getName(path)
    local fontPath = path .. ".font.json"

    writeFile(fontPath, jsonEncode(HttpService, {
        ["name"] = fileName,
        ["faces"] = {
            {
                ["name"] = "Bold",
                ["weight"] = 700,
                ["style"] = "normal",
                ["assetId"] = getCustomAsset(path),
            }
        }
    }))

    local newFont = fontNew(getCustomAsset(fontPath), bold, normal)
    delFile(fontPath)
    
    assetCache.fonts[fileName] = newFont
end

function AssetsManager.loadImage(path : string)
    local imageData = getCustomAsset(path)
    local fileName = getName(path)

    assetCache.images[fileName] = imageData
end

function AssetsManager.downloadFromUrl(url : string, path : string) : boolean
    local success, response = pcall(httpGet, game, url)

    if success and response then
        local writeSuccess = pcall(writeFile, path, response)

        if writeSuccess then
            return true
        else
            return false
        end
    else
        return false
    end
end

function AssetsManager.loadFile(path : string)
    local extension = getExtension(path)

    if extension == "ttf" or extension == "otf" then
        AssetsManager.loadFont(path)
    elseif extension == "png" or extension == "jpg" or extension == "jpeg" then
        AssetsManager.loadImage(path)
    end
end

function AssetsManager.getImage(name : string) : string?
    return assetCache.images[name]
end

function AssetsManager.getFont(name : string) : Font?
    return assetCache.fonts[name]
end

return AssetsManager