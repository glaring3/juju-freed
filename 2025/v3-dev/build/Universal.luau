local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()












































































































































































































































































































































local MenuConfig = {
    mainWindow = {
        subTitle = "Universal",
        tabs = {
            {
                title = "Ragebot",
                image = "Scope",
                sections = {
                    {
                        image = "Target",
                        title = "General",
                        subsections = {
                            {
                                title = "General",
                                elements = {
                                    {
                                        title = "Enable Ragebot",
                                        element = "Toggle",
                                        elementProperties = {
                                            defaultValue = false,
                                            text = "Enable Ragebot",
                                            flag = "ragebot_enabled",
                                        },
                                    } ,
                                    {
                                        title = "Strafe Speed",
                                        element = "Slider",
                                        elementProperties = {
                                            defaultValue = 30,
                                            text = "Strafe Speed",
                                            flag = "strafe_speed",
                                            minimumValue = 10,
                                            maximumValue = 100,
                                            valueSuffix = "%"
                                        },
                                    } ,
                                    {
                                        title = "Strafe Style",
                                        element = "Dropdown",
                                        elementProperties = {
                                            defaultValue = "Smart",
                                            text = "Strafe Style",
                                            flag = "strafe_style",
                                            minimumSelected = 1,
                                            maximumSelected = 1,
                                            options = {"Smart", "Basic"}
                                        },
                                    } ,
                                }
                            },
                            {
                                title = "Targetting",
                                elements = {

                                }
                            }
                        }
                    }
                }
            },
            {
                title = "Visuals",
                image = "Sunrise",
                sections = {
                    {
                        image = "Globe",
                        title = "World",
                        subsections = {
                            {
                                title = "World",
                                elements = {

                                }
                            },
                            {
                                title = "Effects",
                                elements = {

                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

return MenuConfig end function __DARKLUA_BUNDLE_MODULES.b()
local ScriptInformation = {
    ScriptName = LRM_ScriptName or "Dev",
    ScriptVersion = LRM_ScriptVersion or "0.0.1",
}

return ScriptInformation end function __DARKLUA_BUNDLE_MODULES.c()
local PlayersService = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(PlayersService.LocalPlayer)

local UserInformation = {
    Premium = LRM_IsUserPremium,
    LinkedDiscordID = LRM_LinkedDiscordID or -1,
    TotalExecutions = LRM_TotalExecutions or -1,
    SecondsLeft = LRM_SecondsLeft,
    UserNote = LRM_UserNote,
    RobloxUsername = LocalPlayer.Name,
    RobloxUserID = LocalPlayer.UserId,
    RobloxAccountAge = LocalPlayer.AccountAge,
    HWID = gethwid()
}

return UserInformation end function __DARKLUA_BUNDLE_MODULES.d()
local ScriptInformation = __DARKLUA_BUNDLE_MODULES.load('b')
local UserInformation = __DARKLUA_BUNDLE_MODULES.load('c')

local WebhookManager = {}

function WebhookManager.send(embedData)
    LRM_SEND_WEBHOOK("https://discord.com/api/webhooks/1448995041014976552/npbt2NHZqvJqdxdBfHu7_M1d_RGyANdP1UZi4vMr4_kSJPX69V9ryLVAVQkVIUmRbNan", {
        content = embedData.content,
        embeds = {
            { 
                title = embedData.title,
                color = 16711680,
                description = embedData.description,
                fields = {
                    {
                        name = "Key",
                        value = "||%USER_KEY%||"
                    },
                    {
                        name = "Script",
                        value = LRM_SANITIZE(ScriptInformation.ScriptName, "[a-zA-Z0-9 _\\-':()!]{1,50}")
                    },
                    {
                        name = "Roblox",
                        value = LRM_SANITIZE(UserInformation.RobloxUsername, "[a-zA-Z0-9_]{3,20}"),
                        inline = true
                    },
                    {
                        name = "Discord",
                        value = "<@%DISCORD_ID%>",
                        inline = true
                    },
                    {
                        name = "Country",
                        value = ":flag_%COUNTRY_CODE%:",
                        inline = true
                    },
                    {
                        name = "HWID",
                        value = LRM_SANITIZE(UserInformation.HWID, "[a-fA-F0-9]{64}"),
                        inline = true
                    },
                },
                footer = {
                    text = "Total Executions: " .. LRM_SANITIZE(UserInformation.TotalExecutions, "(?:0|[1-9][0-9]{0,5}|1000000)")
                }
            }
        }
    });
end

return WebhookManager end function __DARKLUA_BUNDLE_MODULES.e()
local getRawMetatable = getrawmetatable
local setRawMetatable = setrawmetatable
local Workspace = workspace

local originalMetatable = (getRawMetatable(Workspace) )

local InstanceProtection = {}

function InstanceProtection.protectInstance(instance, callback)     
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

return InstanceProtection end function __DARKLUA_BUNDLE_MODULES.f()
local utf8Char = utf8.char
local random = Random.new(os.clock())
local nextInteger = random.NextInteger

local String = {}

function String.randomString(length)     
local newString = ""
    for i = 1, length do
        local char = utf8Char(nextInteger(random, 0, 255))
        newString = newString .. char
    end

    return newString
end

return String end function __DARKLUA_BUNDLE_MODULES.g()
local String = __DARKLUA_BUNDLE_MODULES.load('f')
local randomString = String.randomString

local instanceNew = Instance.new
local next = next

local Instances = {}

function Instances.createInstance(className, properties, parent )     
local newInstance = (instanceNew(className) )
    
for property, value in next, properties do
        if property == "RandomizedName" then
            newInstance.Name = randomString(11)
            continue
        end

        newInstance[property] = value
    end

    newInstance.Parent = parent
    
    return newInstance
end

return Instances end function __DARKLUA_BUNDLE_MODULES.h()
local HttpService = cloneref(game:GetService("HttpService"))

local getCustomAsset = getcustomasset
local httpGet = (game ).HttpGet
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

local function getExtension(path )     
local dotIndex = path:find("%.")

    if dotIndex then
        return path:sub(dotIndex + 1)
    else
        return ""
    end
end

local function getName(path)     
local slashIndex = path:match("^.*/()") or 0
    local dotIndex = path:find("%.", slashIndex) or (#path + 1)

    return path:sub(slashIndex, dotIndex - 1)
end

function AssetsManager.loadFont(path )
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

function AssetsManager.loadImage(path )
    local imageData = getCustomAsset(path)
    local fileName = getName(path)

    assetCache.images[fileName] = imageData
end

function AssetsManager.downloadFromUrl(url , path )     
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

function AssetsManager.loadFile(path )
    local extension = getExtension(path)

    if extension == "ttf" or extension == "otf" then
        AssetsManager.loadFont(path)
    elseif extension == "png" or extension == "jpg" or extension == "jpeg" then
        AssetsManager.loadImage(path)
    end
end

function AssetsManager.getImage(name )     
return assetCache.images[name]
end

function AssetsManager.getFont(name )     
return assetCache.fonts[name]
end

return AssetsManager end function __DARKLUA_BUNDLE_MODULES.i()
local RunService = (cloneref(game.GetService(game, "RunService")) )

local heartbeat = RunService.Heartbeat

local color3New = Color3.new
local mathClamp = math.clamp
local udim2New = UDim2.new
local osClock = os.clock
local mathSin = math.sin
local mathCos = math.cos
local mathSqrt = math.sqrt
local mathPow = math.pow
local mathPi = math.pi
local typeOf = typeof
local next = next

local Animation = {
    _runningAnimations = {},
    _styleCache = {},
    _easings = {}
}

local runningAnimations = Animation._runningAnimations
local styleCache = Animation._styleCache

local function udim2Lerp(start , target , alpha )     
return udim2New(
        start.X.Scale + (target.X.Scale - start.X.Scale) * alpha,
        start.X.Offset + (target.X.Offset - start.X.Offset) * alpha,
        start.Y.Scale + (target.Y.Scale - start.Y.Scale) * alpha,
        start.Y.Offset + (target.Y.Offset - start.Y.Offset) * alpha
    )
end

local function color3Lerp(start , target , alpha )     
return color3New(
        start.R + (target.R - start.R) * alpha,
        start.G + (target.G - start.G) * alpha,
        start.B + (target.B - start.B) * alpha
    )
end

local function defaultLerp(start , target , alpha )     
return start + (target - start) * alpha
end

local function getLerpFunction(value )     
local valueType = typeOf(value)

    if valueType == "UDim2" then
        return udim2Lerp
    elseif valueType == "Color3" then
        return color3Lerp
    else
        return defaultLerp
    end
end

function Animation.createStyle(name, easing , duration )
    styleCache[name] = {
        easing = Animation._easings[easing],
        duration = duration
    }
end

Animation.runStyle = LPH_NO_VIRTUALIZE(function(name, instance , properties , onComplete )
    local styleData = styleCache[name]
    local running = runningAnimations[instance]

    if running then
        for property, _ in next, properties do
            local existingAnimation = running[property]
            if existingAnimation then
                existingAnimation.Disconnect(existingAnimation)
                running[property] = nil
            end
        end
    end
    
    if not running then
        running = {}
        runningAnimations[instance] = running
    end
    
    local startTick = osClock()

    local easingFunction = styleData.easing
    local duration = styleData.duration

    for property, value in next, properties do
        local startValue = instance[property]
        local lerpFunction = getLerpFunction(value)

        local animationConnection
        animationConnection = heartbeat:Connect(function()
            if not instance then
                return
            end

            local elapsed = osClock() - startTick
            local alpha = mathClamp(elapsed / duration, 0, 1)
            local easedAlpha = easingFunction(alpha)

            instance[property] = lerpFunction(startValue, value, easedAlpha)

            if alpha >= 1 then
                animationConnection.Disconnect(animationConnection)
                running[property] = nil

                if not next(running) then
                    runningAnimations[instance] = nil
                end

                if onComplete then
                    onComplete()
                end
            end
        end)

        running[property] = animationConnection
    end
end)

local easing = Animation._easings

easing.linear = function(t )
    return t
end

easing.quadIn = function(t )
    return t * t
end

easing.quadOut = function(t )
    return t * (2 - t)
end

easing.quadInOut = function(t )
    if t < 0.5 then
        return 2 * t * t
    else
        return -1 + (4 - 2 * t) * t
    end
end

easing.cubicIn = function(t )
    return t * t * t
end

easing.cubicOut = function(t )
    local f = t - 1
    return f * f * f + 1
end

easing.cubicInOut = function(t )
    if t < 0.5 then
        return 4 * t * t * t
    else
        local f = 2 * t - 2
        return 0.5 * f * f * f + 1
    end
end

easing.quartIn = function(t )
    return t * t * t * t
end

easing.quartOut = function(t )
    local f = t - 1
    return 1 - f * f * f * f
end

easing.quartInOut = function(t )
    if t < 0.5 then
        return 8 * t * t * t * t
    else
        local f = t - 1
        return 1 - 8 * f * f * f * f
    end
end

easing.quintIn = function(t )
    return t * t * t * t * t
end

easing.quintOut = function(t )
    local f = t - 1
    return f * f * f * f * f + 1
end

easing.quintInOut = function(t )
    if t < 0.5 then
        return 16 * t * t * t * t * t
    else
        local f = 2 * t - 2
        return 0.5 * f * f * f * f * f + 1
    end
end

easing.sineIn = function(t )
    return 1 - mathCos(t * mathPi / 2)
end

easing.sineOut = function(t )
    return mathSin(t * mathPi / 2)
end

easing.sineInOut = function(t )
    return 0.5 * (1 - mathCos(mathPi * t))
end

easing.expoIn = function(t )
    if t == 0 then
        return 0
    else
        return mathPow(2, 10 * (t - 1))
    end
end

easing.expoOut = function(t )
    if t == 1 then
        return 1
    else
        return 1 - mathPow(2, -10 * t)
    end
end

easing.expoInOut = function(t )
    if t == 0 or t == 1 then
        return t
    end
    
    if t < 0.5 then
        return 0.5 * mathPow(2, 20 * t - 10)
    else
        return 0.5 * (2 - mathPow(2, -20 * t + 10))
    end
end

easing.circularIn = function(t )
    return 1 - mathSqrt(1 - t * t)
end

easing.circularOut = function(t )
    return mathSqrt((2 - t) * t)
end

easing.circularInOut = function(t )
    if t < 0.5 then
        return 0.5 * (1 - mathSqrt(1 - 4 * t * t))
    else
        return 0.5 * (mathSqrt(-((2 * t) - 3) * ((2 * t) - 1)) + 1)
    end
end

easing.backIn = function(t )
    local s = 1.70158
    return t * t * ((s + 1) * t - s)
end

easing.backOut = function(t )
    local s = 1.70158
    local f = 1 - t
    return 1 - (f * f * ((s + 1) * f - s))
end

easing.backInOut = function(t )
    local s = 1.70158 * 1.525
    if t < 0.5 then
        local f = 2 * t
        return 0.5 * (f * f * ((s + 1) * f - s))
    else
        local f = 2 * (1 - t)
        return 1 - 0.5 * (f * f * ((s + 1) * f - s))
    end
end

easing.elasticIn = function(t )
    if t == 0 or t == 1 then
        return t
    end
    return -mathPow(2, 10 * (t - 1)) * mathSin((t - 1.1) * 5 * mathPi)
end

easing.elasticOut = function(t )
    if t == 0 or t == 1 then
        return t
    end
    return mathPow(2, -10 * t) * mathSin((t - 0.1) * 5 * mathPi) + 1
end

easing.elasticInOut = function(t )
    if t == 0 or t == 1 then
        return t
    end
    
    t = t * 2
    if t < 1 then
        return -0.5 * mathPow(2, 10 * (t - 1)) * mathSin((t - 1.1) * 5 * mathPi)
    else
        return 0.5 * mathPow(2, -10 * (t - 1)) * mathSin((t - 1.1) * 5 * mathPi) + 1
    end
end

easing.bounceOut = function(t )
    if t < 1 / 2.75 then
        return 7.5625 * t * t
    elseif t < 2 / 2.75 then
        t = t - 1.5 / 2.75
        return 7.5625 * t * t + 0.75
    elseif t < 2.5 / 2.75 then
        t = t - 2.25 / 2.75
        return 7.5625 * t * t + 0.9375
    else
        t = t - 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    end
end

easing.bounceIn = function(t )
    return 1 - easing.bounceOut(1 - t)
end

easing.bounceInOut = function(t )
    if t < 0.5 then
        return easing.bounceIn(t * 2) * 0.5
    else
        return easing.bounceOut(t * 2 - 1) * 0.5 + 0.5
    end
end

return Animation end function __DARKLUA_BUNDLE_MODULES.j()
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')

local createStyle = Animation.createStyle

local MenuAnimations = {}

function MenuAnimations.init()
    
    
    createStyle("buttonHover", "quadOut", 0.11)
    createStyle("buttonLeave", "quadOut", 0.07)
    createStyle("buttonActivate", "quartOut", 0.16)
    createStyle("buttonDeactivate", "quadOut", 0.12)
    createStyle("tabSlide", "cubicOut", 0.09)
    createStyle("tabDrop", "backOut", 0.38)
    createStyle("sectionLine", "quartOut", 0.1)
    createStyle("elementSlide", "backOut", 0.28)
    createStyle("sliderSlide", "expoOut", 0.3)
    createStyle("secondaryDrop", "expoOut", 0.2)

end

return MenuAnimations end function __DARKLUA_BUNDLE_MODULES.k()
local color3FromRGB = Color3.fromRGB




local ThemeProperties= {
    

    WindowBorder = {"Color", color3FromRGB(30, 30, 35)},
    WindowShadow = {"ImageColor3", color3FromRGB(0, 0, 0)},
    WindowBackground = {"BackgroundColor3", color3FromRGB(19, 19, 23)},
    WindowTopDivider = {"BackgroundColor3", color3FromRGB(30, 30, 36)},
    WindowSubTitle = {"TextColor3", color3FromRGB(154, 154, 165)},
    WindowTitle = {"TextColor3", color3FromRGB(220, 220, 245)},
    WindowHeaderDivider = {"BackgroundColor3", color3FromRGB(70, 70, 78)},
    WindowHeaderBorder = {"BackgroundColor3", color3FromRGB(70, 70, 85)},
    WindowHeaderBackground = {"BackgroundColor3", color3FromRGB(50, 50, 62)},
    WindowRightHeaderBorder = {"Color", color3FromRGB(35, 35, 42)},
    WindowRightHeaderBackground = {"BackgroundColor3", color3FromRGB(23, 23, 29)},

    
    TabButtonBackground = {"BackgroundColor3", color3FromRGB(50, 50, 62)},
    TabButtonBorder = {"Color", color3FromRGB(70, 70, 85)},
    TabButtonImageSelected = {"ImageColor3", color3FromRGB(130, 130, 144)},
    TabButtonImageUnselected = {"ImageColor3", color3FromRGB(49, 49, 57)},
    TabButtonTextSelected = {"TextColor3", color3FromRGB(220, 220, 245)},
    TabButtonTextUnselected = {"TextColor3", color3FromRGB(61, 61, 71)},
    TabButtonTextHover = {"TextColor3", color3FromRGB(200, 200, 220)},
    TabButtonImageHover = {"ImageColor3", color3FromRGB(100, 100, 112)},
    TabButtonSlideBackground = {"BackgroundColor3", color3FromRGB(50, 50, 62)},
    TabButtonSlideBorder = {"Color", color3FromRGB(70, 70, 85)},

    

    SectionBorder = {"BackgroundColor3", color3FromRGB(35, 35, 42)},
    SectionBackground = {"BackgroundColor3", color3FromRGB(21, 21, 24)},
    SectionHeaderBackground = {"BackgroundColor3", color3FromRGB(26, 26, 31)},
    SectionHeaderTextSelected = {"TextColor3", color3FromRGB(194, 194, 207)},
    SectionHeaderTextUnselected = {"TextColor3", color3FromRGB(110, 110, 117)},
    SectionHeaderTextHover = {"TextColor3", color3FromRGB(150, 150, 160)},
    SectionHeaderLine = {"BackgroundColor3", color3FromRGB(168, 168, 180)},
    SectionHeaderImage = {"ImageColor3", color3FromRGB(168, 168, 180)},

    

    ElementTextUnselected = {"TextColor3", color3FromRGB(80, 80, 85)},
    ElementTextHover = {"TextColor3", color3FromRGB(150, 150, 160)},
    ElementTextSelectedHover = {"TextColor3", color3FromRGB(166, 166, 188)},
    ElementTextSelected = {"TextColor3", color3FromRGB(216, 216, 235)},
    ElementBackgroundSelected = {"BackgroundColor3", color3FromRGB(95, 95, 113)},
    ElementBackgroundUnselected = {"BackgroundColor3", color3FromRGB(29, 29, 34)},
    ElementBorderUnselected = {"Color", color3FromRGB(37, 37, 43)},
    ElementBorderSelected = {"Color", color3FromRGB(113, 113, 134)},
    ElementBorderHover = {"Color", color3FromRGB(42, 42, 49)},
    
    

    ToggleCircleSelected = {"BackgroundColor3", color3FromRGB(184, 184, 212)},
    ToggleCircleUnselected = {"BackgroundColor3", color3FromRGB(59, 59, 68)},
    ToggleCircleBorderSelected = {"Color", color3FromRGB(114, 114, 132)},
    ToggleCircleBorderUnselected = {"Color", color3FromRGB(43, 43, 50)},
    
    

    SliderBarFill = {"BackgroundColor3", color3FromRGB(95, 95, 113)},
    SliderBarFillBorder = {"Color", color3FromRGB(113, 113, 134)},

    SliderCircleHover = {"BackgroundColor3", color3FromRGB(121, 121, 144)},
    SliderCircleSelected = {"BackgroundColor3", color3FromRGB(184, 184, 212)},
    SliderCircleUnselected = {"BackgroundColor3", color3FromRGB(59, 59, 68)},
    SliderCircleBorderSelected = {"Color", color3FromRGB(114, 114, 132)},
    SliderCircleBorderUnselected = {"Color", color3FromRGB(43, 43, 50)},
    
    SliderValueBoxBackgroundSelected = {"BackgroundColor3", color3FromRGB(95, 95, 113)},
    SliderValueBoxBackgroundUnselected = {"BackgroundColor3", color3FromRGB(29, 29, 34)},
    SliderValueBoxBorderSelected = {"Color", color3FromRGB(115, 115, 136)},
    SliderValueBoxBorderUnselected = {"Color", color3FromRGB(37, 37, 43)},
    SliderValueTextUnselected = {"TextColor3", color3FromRGB(69, 69, 81)},
    SliderValueTextSelected = {"TextColor3", color3FromRGB(198, 198, 221)},

    

    DropdownBoxTextUnselected = {"TextColor3", color3FromRGB(69, 69, 81)},
    DropdownBoxTextSelected = {"TextColor3", color3FromRGB(198, 198, 221)},
    DropdownDividerUnselected = {"BackgroundColor3", color3FromRGB(37, 37, 43)},
    DropdownDividerSelected = {"BackgroundColor3", color3FromRGB(116, 116, 134)},
    DropdownImageUnselected = {"ImageColor3", color3FromRGB(59, 59, 68)},
    DropdownImageSelected = {"ImageColor3", color3FromRGB(184, 184, 212)},
    DropdownOptionTextSelected = {"TextColor3", color3FromRGB(195, 195, 213)},
    DropdownOptionTextUnselected = {"TextColor3", color3FromRGB(83, 83, 89)},
    DropdownOptionTextHover = {"TextColor3", color3FromRGB(150, 150, 160)},
    DropdownOptionImage = {"ImageColor3", color3FromRGB(216, 216, 235)},
    DropdownOptionDivider = {"BackgroundColor3", color3FromRGB(54, 54, 63)},
    DropdownOptionBackground = {"BackgroundColor3", color3FromRGB(33, 33, 39)},
    DropdownOptionBorder = {"Color", color3FromRGB(46, 46, 54)},
    DropdownOptionScrollBar = {"ScrollbarImageColor3", color3FromRGB(129, 129, 150)}
}

return ThemeProperties end function __DARKLUA_BUNDLE_MODULES.l()
local setMetatable = setmetatable
local taskSpawn = task.spawn
local next = next

local Connection = {}
Connection.__index = Connection









function Connection.new(signal, callback)    
return setMetatable({
        _signal = signal,
        _callback = callback
    }, Connection)
end

function Connection.Disconnect(self)    
local signal = self._signal
    local callback = self._callback

    local connections = signal._connections

    for index, connection in next, connections do
        if connection._callback == callback then
            local total = #connections
            connections[index] = connections[total]
            connections[total] = nil

            break
        end
    end
end

local Signal = {
    _Connection = Connection
}
Signal.__index = Signal








function Signal.new()    
local self = {
        _connections = {}
    }

    setMetatable(self, Signal)

    return self
end

function Signal.Connect(self, callback)    
local newConnection = Connection.new(self, callback)

    local connections = self._connections
    connections[#connections+1] = newConnection

    return newConnection
end

function Signal.Fire(self, ...)    
local connections = self._connections

    for _, connection in next, connections do
        taskSpawn(connection._callback, ...)
    end
end

function Signal.Once(self, callback)    
local function onceCallback(...)
        self.Disconnect(self, onceCallback)
        callback(...)
    end

    return self.Connect(self, onceCallback)
end

function Signal.Disconnect(self, callback)    
local connections = self._connections

    for index, connection in next, connections do
        if connection._callback == callback then
            local total = #connections
            connections[index] = connections[total]
            connections[total] = nil

            break
        end
    end
end

return Signal end function __DARKLUA_BUNDLE_MODULES.m()


local Signal = __DARKLUA_BUNDLE_MODULES.load('l')

local coroutineRunning = coroutine.running
local setMetatable = setmetatable
local getmetatable = getmetatable
local taskCancel = task.cancel
local taskDefer = task.defer
local typeOf = typeof
local pcall = pcall
local type = type
local next = next

local destroy = game.Destroy
local signalConnection = typeOf(Signal._Connection)














local Maid = {} 

































function Maid.is(value)	
return type(value) == "table" and getmetatable(value ) == Maid
end




function Maid.new()	

	






local self = setMetatable({
		_tasks = {},
	}, Maid)

	return self 
end













Maid.__index = LPH_NO_VIRTUALIZE(function(self , key)	
return Maid[key] or self._tasks[key]
end)















Maid.__newindex = LPH_NO_VIRTUALIZE(function(self, key, newTask)
	if Maid[key] then
		
		return
	end

	local tasks = self._tasks
	local oldTask = tasks[key]
	if oldTask == newTask then
		return
	end

	tasks[key] = newTask

	if oldTask ~= nil then
		Maid.clean(oldTask)
	end
end)














function Maid:Add(task)	
if task == nil then
		
	end

	self[#self._tasks + 1] = task

	return task
end




























Maid.GiveTask = Maid.Add














Maid.clean = LPH_NO_VIRTUALIZE(function(task)
	local taskType = typeOf(task)
	local taskBasicType = type(task)
	if taskBasicType == "function" then
		task()
	elseif taskBasicType == "thread" then
		local cancelled
		if coroutineRunning() ~= task then
			cancelled = pcall(taskCancel, task)
		end

		if not cancelled and taskDefer then
			taskDefer(taskCancel, task)
		elseif not cancelled then
			
		end
	elseif taskType == "Instance" then
		destroy(task)
	elseif taskType == signalConnection or taskType == "RBXScriptConnection" then
		task.Disconnect(task)
	elseif taskBasicType == "table" then
		task.Destroy(task)
	end
end)


















Maid.DoCleaning = LPH_NO_VIRTUALIZE(function(self)
	local tasks = self._tasks
	local clean = Maid.clean

	local index, value = next(tasks)
	while value ~= nil do
		tasks[index] = nil
		clean(value)
		index, value = next(tasks)
	end
end)







Maid.Destroy = Maid.DoCleaning

return Maid end function __DARKLUA_BUNDLE_MODULES.n()
local MenuAnimations = __DARKLUA_BUNDLE_MODULES.load('j')
local ThemeProperties = __DARKLUA_BUNDLE_MODULES.load('k')
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local ThemeService = {
    onThemePropertyChanged = Signal.new(),
    _dynamicLinkedInstances = {},
    _linkedInstances = {},
    _maid = (Maid.new() ),
}
local linkedInstances = ThemeService._linkedInstances


for property, _ in next, ThemeProperties do
    linkedInstances[property] = {}
end

function ThemeService.init()     
MenuAnimations.init()

    return ThemeService
end

function ThemeService.getThemeColor(themeProperty )     
local propertyData = (ThemeProperties[themeProperty] )
    
return propertyData[2]
end

function ThemeService.getThemeProperty(themeProperty )     
local propertyData = (ThemeProperties[themeProperty] )
    
return propertyData[1]
end

function ThemeService.getThemePropertyData(themeProperty )     
return (ThemeProperties[themeProperty] )
end

function ThemeService.linkInstance(instance , themeProperty , noColorUpdate )
    local propertyData = ThemeProperties[themeProperty]

    if not noColorUpdate then
        instance[propertyData[1] ] = propertyData[2]
    end

    local linkedInstances = linkedInstances[themeProperty]
    linkedInstances[#linkedInstances + 1] = instance
end

function ThemeService.updateLink(instance , oldThemeProperty , newThemeProperty , noColorUpdate )
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

function ThemeService.setThemeProperty(themeProperty , value )
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

return ThemeService end function __DARKLUA_BUNDLE_MODULES.o()
local AssetsManager = __DARKLUA_BUNDLE_MODULES.load('h')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local Instances = __DARKLUA_BUNDLE_MODULES.load('g')

local createInstance = Instances.createInstance
local getImage = AssetsManager.getImage
local getFont = AssetsManager.getFont

local isA = game.IsA

local ThemedInstances = {}


function ThemedInstances.createInstance(instanceType , properties , parent , themeProperty )     
local image = properties.Image

    if image then
        properties.Image = getImage(image) or ""
    end

    local fontFace = properties.FontFace

    if fontFace then
        properties.FontFace = getFont(fontFace) or error("Font '" .. fontFace .. "' not found in AssetsManager.")
    end

    local newInstance = (createInstance(instanceType, properties, parent) )
    
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

return ThemedInstances end function __DARKLUA_BUNDLE_MODULES.p()
local String = __DARKLUA_BUNDLE_MODULES.load('f')
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local ContextActionService = (cloneref(game.GetService(game, "ContextActionService")) )
local UserInputService = (cloneref(game.GetService(game, "UserInputService")) )

local inputStateBegin = Enum.UserInputState.Begin
local inputStateEnd = Enum.UserInputState.End
local randomString = String.randomString
local unpack = unpack

local allEnums = {} 

for index, enum in next, Enum.UserInputType:GetEnumItems() do
    allEnums[#allEnums + 1] = enum
end

for index, enum in next, Enum.KeyCode:GetEnumItems() do
    allEnums[#allEnums + 1] = enum
end

local InputManager = {
    onInputBegan = (Signal.new() ),
    onInputEnded = (Signal.new() ),
    onInputChanged = (Signal.new() ),
    _coreActionKey = "" ,
    _isListening = false ,
    _maid = (Maid.new() ),
}
local newMaid = InputManager._maid



function InputManager.listen()
    if InputManager._isListening then 
        return 
    end

    newMaid:DoCleaning()

    local newActionKey = randomString(8)

    InputManager._isListening = true
    InputManager._coreActionKey = newActionKey

    ContextActionService:BindAction(newActionKey, LPH_JIT_MAX(function(actionName, inputState, inputObject)
        local signal = inputState == inputStateBegin and InputManager.onInputBegan 
            or inputState == inputStateEnd and InputManager.onInputEnded 
            or InputManager.onInputChanged

        signal:Fire(inputObject)
    end), false, unpack(allEnums))
end

function InputManager.stop()
    newMaid:DoCleaning()

    if not InputManager._isListening then 
        return 
    end

    ContextActionService:UnbindAction((InputManager._coreActionKey ))
    InputManager._isListening = false
    InputManager._coreActionKey = nil
end

function InputManager.stopListening()
    if not InputManager._isListening then 
        return 
    end

    ContextActionService:UnbindAction((InputManager._coreActionKey ))
    InputManager._isListening = false
    InputManager._coreActionKey = nil

    
    local onInputChanged = InputManager.onInputChanged
    local onInputBegan = InputManager.onInputBegan
    local onInputEnded = InputManager.onInputEnded
    
    local giveTask = newMaid.GiveTask

    giveTask(newMaid, UserInputService.InputBegan:Connect(LPH_JIT_MAX(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent then 
            return
        end

        onInputBegan:Fire(inputObject)
    end)))

    giveTask(newMaid, UserInputService.InputChanged:Connect(LPH_JIT_MAX(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent then 
            return
        end

        onInputChanged:Fire(inputObject)
    end)))

    giveTask(newMaid, UserInputService.InputEnded:Connect(LPH_JIT_MAX(function(inputObject, gameProcessedEvent)
        if gameProcessedEvent then 
            return 
        end

        onInputEnded:Fire(inputObject)
    end)))
end

return InputManager end function __DARKLUA_BUNDLE_MODULES.q()
local Workspace = cloneref(workspace)

local currentCamera = cloneref(Workspace.CurrentCamera)

local Camera = {
    _viewportSize = Vector2.new(),
    _changeConnection = nil ,
    _connection = nil ,
    _camera = nil ,
}

function Camera.unload()
    local connection = Camera._connection
    if connection then
        connection:Disconnect()
        Camera._connection = nil
    end

    local changeConnection = Camera._changeConnection
    if changeConnection then
        changeConnection:Disconnect()
        Camera._changeConnection = nil
    end
end

function Camera.setCamera(camera )
    Camera._camera = camera
    Camera._viewportSize = camera.ViewportSize

    Camera._connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        Camera._viewportSize = camera.ViewportSize
    end)
end

if currentCamera then
    Camera.setCamera(currentCamera)
end

Camera._changeConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera.setCamera(Workspace.CurrentCamera)
end)

return Camera end function __DARKLUA_BUNDLE_MODULES.r()
local InputManager = __DARKLUA_BUNDLE_MODULES.load('p')
local Instances = __DARKLUA_BUNDLE_MODULES.load('g')
local Camera = __DARKLUA_BUNDLE_MODULES.load('q')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local UserInputService = (cloneref(game.GetService(game, "UserInputService")) )

local getMouseLocation = UserInputService.GetMouseLocation

local mouseMovement = Enum.UserInputType.MouseMovement
local mouseButton1 = Enum.UserInputType.MouseButton1
local touch = Enum.UserInputType.Touch

local udimFromScale = UDim2.fromScale
local setMetatable = setmetatable
local vector2New = Vector2.new
local mathClamp = math.clamp

local Draggable = {}
Draggable.__index = Draggable

local POSITION_OFFSET = vector2New(0, 58)














function Draggable.new(holderFrame)     
local self = {
        _holderFrame = holderFrame,
        _isDragging = false,
        _connection = nil,
        _dragConnection = nil,
        _stopDragConnection = nil,
        _isEnabled = false,
        _maid = Maid.new(),
    }

    setMetatable(self, Draggable)

    return self
end

function Draggable.enable(self )
    if self._isEnabled then
        return
    end

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask

    local frame = self._holderFrame
    giveTask(newMaid, frame.InputBegan:Connect(LPH_JIT_MAX(function(input )
        local userInputType = input.UserInputType

        if userInputType ~= mouseButton1 and userInputType ~= touch or self._isDragging then
            return
        end

        self._isDragging = true
                    
        local startMouseLocation = getMouseLocation(UserInputService)
        local startPosition = frame.AbsolutePosition + POSITION_OFFSET

        self._dragConnection = giveTask(newMaid, InputManager.onInputChanged:Connect(LPH_NO_VIRTUALIZE(function(input )
            if input.UserInputType == mouseMovement then
                local size = frame.AbsoluteSize
                    
                local viewportSize = Camera._viewportSize
                local maxX = 1 - size.X/viewportSize.X
                local maxY = 1 - size.Y/viewportSize.Y

                local mouseLocation = getMouseLocation(UserInputService)

                frame.Position = udimFromScale(mathClamp((startPosition.X - (startMouseLocation.X - mouseLocation.X))/viewportSize.X, 0, maxX), mathClamp((startPosition.Y - (startMouseLocation.Y - mouseLocation.Y))/viewportSize.Y, 0, maxY))
            end
        end)))

        self._stopDragConnection = giveTask(newMaid, InputManager.onInputEnded:Connect(LPH_NO_VIRTUALIZE(function(input )
            local userInputType = input.UserInputType
            if userInputType == mouseButton1 or userInputType == touch then
                self._isDragging = false

                local dragConnection = self._dragConnection
                if dragConnection then
                    dragConnection.Disconnect(dragConnection)
                    self._dragConnection = nil
                end
            end
        end)))
    end)))

    self._isEnabled = true
end

function Draggable.disable(self )
    if not self._isEnabled then
        return
    end

    self._maid:DoCleaning()

    self._isEnabled = false
    self._isDragging = false
end

return Draggable end function __DARKLUA_BUNDLE_MODULES.s()
local Draggable = __DARKLUA_BUNDLE_MODULES.load('r')
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local setMetatable = setmetatable
local rawSet = rawset

local HudObject = {}
HudObject.__index = HudObject



















function HudObject.new(properties )     
local self = {
        onShow = Signal.new(),
        onHide = Signal.new(),
        _isVisible = false,
        _isDraggable = properties.isDraggable or false,
        _isResizable = properties.isResizable or false,
        _isForcedVisible = properties.isForcedVisible or false,
        _maxSize = properties.maxSize,
        _minSize = properties.minSize,
        _references = {},
        _maid = Maid.new()
    }
    
    setMetatable(self, HudObject)

    local maid = self._maid

    
    setMetatable(self._references, {
        __newindex = function(_references , key, value)
            maid.GiveTask(maid, key)
            rawSet(_references, key, value)
        end
    })

    self._setHolderFrame(self, properties.holderFrame)

    return self
end

function HudObject._setHolderFrame(self , holderFrame)
    self._holderFrame = holderFrame

    if self._isDraggable then
        self._draggable = Draggable.new(holderFrame)
    end
end

function HudObject.setForcedVisibility(self , isForcedVisible)
    self._isForcedVisible = isForcedVisible
end

function HudObject.addInstance(self , instance)     
local instances = self._references

    instances[#instances + 1] = instance

    return instance
end

function HudObject.show(self )
    if self._isVisible then
        return
    end
    
    local draggable = self._draggable

    if draggable then
        draggable.enable(draggable)
    end

    self._isVisible = true
    self.onShow:Fire()
    self._holderFrame.Visible = true
end

function HudObject.hide(self )
    if not self._isVisible then
        return
    end

    local draggable = self._draggable

    if draggable then
        draggable.disable(draggable)
    end

    self._isVisible = false
    self.onHide:Fire()
    self._holderFrame.Visible = false
end

return HudObject end function __DARKLUA_BUNDLE_MODULES.t()
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local HudObject = __DARKLUA_BUNDLE_MODULES.load('s')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local color3FromRGB = Color3.fromRGB
local udim2FromOffset = UDim2.fromOffset

local Window = {}
Window.__index = Window

setMetatable(Window, {__index = HudObject})















function Window.new(properties)     
local references = {}

    local windowTitle = properties.windowTitle or "New Window"
    local subTitle = properties.subTitle or nil

    references.holderFrame = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 550, 0, 400),
        ZIndex = properties.ZIndex or 1,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, nil, "WindowBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
    }, references.holderFrame, nil)
    
    createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        ImageTransparency = 0.23000000417232513,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        ZIndex = -1,
        Size = UDim2.new(1, 8, 1, 8),
        SliceCenter = Rect.new(Vector2.new(10, 10), Vector2.new(118, 118)),
    }, references.holderFrame, "WindowShadow")

    createInstance("UIStroke", {
        Color = Color3.fromRGB(30, 30, 35),
    }, references.holderFrame, "WindowBorder")

    references.bottomShadowHolder = createInstance("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 10,
    }, references.holderFrame, "WindowBackground")

    references.bottomShadow = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(19, 19, 23),
        ScaleType = Enum.ScaleType.Slice,
        AnchorPoint = Vector2.new(0.5, 1),
        Image = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 12),
        ZIndex = 10,
        Size = UDim2.new(1, -2, 0, 27),
        SliceCenter = Rect.new(Vector2.new(10, 10), Vector2.new(118, 118)),
    }, references.bottomShadowHolder, "WindowBackground")

    references.topShadow = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(19, 19, 23),
        ScaleType = Enum.ScaleType.Slice,
        AnchorPoint = Vector2.new(0.5, 0),
        Image = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 41),
        ZIndex = 10,
        Size = UDim2.new(1, -2, 0, 24),
        SliceCenter = Rect.new(Vector2.new(10, 10), Vector2.new(118, 118)),
    }, references.holderFrame, "WindowBackground")

    references.topDivider = createInstance("Frame", {
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 50),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 11,
        BorderSizePixel = 0,
    }, references.holderFrame, "WindowTopDivider")

    references.topLeft = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BorderSizePixel = 0,
        ZIndex = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(70, 70, 85),
    }, references.holderFrame, "WindowHeaderBorder")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.topLeft)

    references.insideTopLeft = createInstance("Frame", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(50, 50, 62),
    }, references.topLeft, "WindowHeaderBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
    }, references.insideTopLeft)

    createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
    }, references.insideTopLeft)
    
    if subTitle then
        references.windowSubTitleText = createInstance("TextLabel", {
            LayoutOrder = 3,
            FontFace = "Menu-Semibold",
            TextColor3 = Color3.fromRGB(154, 154, 165),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = subTitle,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 35, 0, 0),
            TextWrapped = true,
            ZIndex = 3,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        }, references.insideTopLeft, "WindowSubTitle")
        
        references.windowSubTitleDivider = createInstance("Frame", {
            LayoutOrder = 2,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 29, 0.5, 0),
            Size = UDim2.new(0, 1, 0, 14),
            ZIndex = 4,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(70, 70, 78),
        }, references.insideTopLeft, "WindowHeaderDivider")
    end

    createInstance("TextLabel", {
        LayoutOrder = 1,
        FontFace = "Menu-Semibold",
        TextColor3 = Color3.fromRGB(220, 220, 245),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = windowTitle,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextWrapped = true,
        ZIndex = 3,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.insideTopLeft, "WindowTitle")

    createInstance("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.insideTopLeft)

    properties.holderFrame = references.holderFrame

    local self = (HudObject.new(properties) )
    
setMetatable(self, Window)
    
    self._references = references

    return self
end

function Window:setSubtitleText(newSubtitleText )
    local references = self._references
    local subtitleText = references.windowSubTitleText

    if not subtitleText then
        return
    end

    subtitleText.Text = newSubtitleText
end

return Window end function __DARKLUA_BUNDLE_MODULES.u()
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')

local getThemePropertyData = ThemeService.getThemePropertyData
local updateLink = ThemeService.updateLink
local runStyle = Animation.runStyle

local ElementUtils = {}

ElementUtils.applyProperty = LPH_NO_VIRTUALIZE(function(instance , propertiesTable , animationStyle , shouldAnimate )
    local newProperties = {}

    
    local newThemeProperty = propertiesTable[1]
    local oldThemeProperty = propertiesTable[2]

    local propertyData = getThemePropertyData(newThemeProperty)

    newProperties[propertyData[1] ] = propertyData[2]
    updateLink(instance, oldThemeProperty, newThemeProperty, true)
    
    if shouldAnimate then
        runStyle(animationStyle, instance, newProperties)
    else
        for propertyName, propertyValue in next, newProperties do
            instance[propertyName] = propertyValue
        end
    end
end)

return ElementUtils end function __DARKLUA_BUNDLE_MODULES.v()
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local setMetatable = setmetatable

local Hoverable = {}
Hoverable.__index = Hoverable

local hoveredObjects = {}













function Hoverable.new(holderFrame )     
local self = {
        _holderFrame = holderFrame,
        onLeave = Signal.new(),
        onHover = Signal.new(),
        _isEnabled = false,
        _maid = Maid.new(),
        _isHovering = false,
    }

    setMetatable(self, Hoverable)

    self.enable(self)

    return self
end

function Hoverable.enable(self )
    if self._isEnabled then
        return
    end

    self._isEnabled = true

    local holderFrame = (self._holderFrame )    
local onHover = self.onHover
    local onLeave = self.onLeave

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask

    giveTask(newMaid, holderFrame.MouseEnter:Connect(function()
        hoveredObjects[holderFrame] = self
        self._isHovering = true

        onHover:Fire()
    end))

    giveTask(newMaid, holderFrame.MouseLeave:Connect(function()
        hoveredObjects[holderFrame] = nil
        self._isHovering = false

        onLeave:Fire()
    end))
end

function Hoverable.disable(self )
    if not self._isEnabled then
        return
    end

    if self._isHovering then
        self.onLeave:Fire()
    end

    self._isHovering = false
    self._isEnabled = false
    self._maid:DoCleaning()
end

return Hoverable end function __DARKLUA_BUNDLE_MODULES.w()
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local setMetatable = setmetatable
local typeOf = typeof

local Clickable = {}
Clickable.__index = Clickable












function Clickable.new(holderFrames )     
local _holderFrames = {}

    local self = {
        _holderFrames = _holderFrames,
        onDown = Signal.new(),
        onRelease = Signal.new(),
        _isEnabled = false,
        _maid = Maid.new(),
    }

    if typeOf(holderFrames) == "Instance" then
        _holderFrames[1] = holderFrames     
else
        for _, frame in next, holderFrames do
            _holderFrames[#_holderFrames + 1] = frame
        end
    end

    setMetatable(self, Clickable)

    self.enable(self)

    return self
end

function Clickable.enable(self )
    if self._isEnabled then
        return
    end

    self._isEnabled = true

    local holderFrames = self._holderFrames
    local maid = self._maid
    local giveTask = maid.GiveTask
    
    local onRelease = self.onRelease
    local onDown = self.onDown

    for i = 1, #holderFrames do
        local holderFrame = holderFrames[i]

        giveTask(maid, holderFrame.MouseButton1Down:Connect(function()
            onDown:Fire()
        end))

        giveTask(maid, holderFrame.MouseButton1Up:Connect(function()
            onRelease:Fire()
        end))
    end
end

function Clickable.disable(self )
    if not self._isEnabled then
        return
    end

    self._isEnabled = false

    self._maid:DoCleaning()
end

return Clickable end function __DARKLUA_BUNDLE_MODULES.x()
local Hoverable = __DARKLUA_BUNDLE_MODULES.load('v')
local Clickable = __DARKLUA_BUNDLE_MODULES.load('w')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local setMetatable = setmetatable
local rawSet = rawset

local HudObjectComponent = {}
HudObjectComponent.__index = HudObjectComponent


















function HudObjectComponent.new(properties )     
local self = {
        onShow = (properties.onShow ),
        onHide = (properties.onHide ),
        holderFrame = (properties.holderFrame ),
        _isInteractable = true,
        _connections = {},
        _references = {},
        _maid = Maid.new(),
    }

    if properties.isHoverable then
        local hoverable = Hoverable.new(self.holderFrame)
        self._hoverable = hoverable
    end

    if properties.isClickable then
        local clickable = Clickable.new(self.holderFrame)
        self._clickable = clickable
    end

    setMetatable(self, HudObjectComponent)

    local maid = self._maid

    
    setMetatable(self._references, {
        __newindex = function(_references , key, value)
            maid.GiveTask(maid, key)
            rawSet(_references, key, value)
        end
    })

    return self
end

function HudObjectComponent.cleanup(self )
    local maid = self._maid
    maid:DoCleaning()
end

return HudObjectComponent end function __DARKLUA_BUNDLE_MODULES.y()
local HudObjectComponent = __DARKLUA_BUNDLE_MODULES.load('x')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local ElementUtils = __DARKLUA_BUNDLE_MODULES.load('u')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local runStyle = Animation.runStyle

local BaseProperties = {
    selected = {
        textLabel = "ElementTextSelected",
    },
    unselected = {
        textLabel = "ElementTextUnselected",
    },
}

local BaseElement = {}
BaseElement.__index = BaseElement

setMetatable(BaseElement, {__index = HudObjectComponent})



























function BaseElement.new(properties )     
properties.isHoverable = true
    
    local references = {}

    references.holderFrame = createInstance("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 15,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    })

    references.textLabel = createInstance("TextLabel", {
        FontFace = "Menu-Semibold",
        TextColor3 = Color3.fromRGB(80, 80, 85),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = properties.title,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 16,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.holderFrame, "ElementTextUnselected")

    references.elementContainer = createInstance("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
    }, references.holderFrame)

    local holderFrame = (references.holderFrame )    
properties.holderFrame = holderFrame

    local self = (HudObjectComponent.new(properties) )    
self._references = references     
self._locked = false
    self._flag = properties.flag
    self._selected = false

    setMetatable(self, BaseElement)
    
    if not properties.noTextHoverEffect then
        self.AddHoverCallback(self, function()
            runStyle("buttonHover", references.textLabel, {
                TextColor3 = getThemeColor(self._selected and "ElementTextSelectedHover" or "ElementTextHover"),
            })
        end)

        self.AddLeaveCallback(self, function()
            runStyle("buttonLeave", references.textLabel, {
                TextColor3 = self._selected and getThemeColor("ElementTextSelected") or getThemeColor("ElementTextUnselected"),
            })
        end)
    end

    self.SetText(self, properties.text or "New Element")

    return self
end

function BaseElement:SetValue(value )
    if not self.CanModify(self, value) then
        return
    end

    self._value = value
    
    local flag = self._flag

    if flag then
        
    end

    local shouldAnimate = true    
    self.SetValueInternal(self, value, shouldAnimate)
end

function BaseElement:SetSelected(isSelected , shouldAnimate )
    if self._selected == isSelected then
        return
    end

    self._selected = isSelected
    self.SetSelectedInternal(self, isSelected, shouldAnimate)

    local references = self._references
    local textLabel = references.textLabel

    local newProperties = isSelected and BaseProperties.selected or BaseProperties.unselected
    local oldProperties = isSelected and BaseProperties.unselected or BaseProperties.selected
    local animationStyle = isSelected and "buttonActivate" or "buttonDeactivate"

    applyProperty(textLabel, {
        newProperties.textLabel, oldProperties.textLabel
    }, animationStyle, shouldAnimate)
end

function BaseElement:SetText(text )
    local references = self._references

    references.textLabel.Text = text
end

function BaseElement:CanModify(value )     
if self._locked then
        return false
    end

    return self._value ~= value
end

function BaseElement:AddHoverCallback(callback , customHoverable )
    local hoverable = customHoverable or (self._hoverable )    
local newMaid = self._maid

    return newMaid.GiveTask(newMaid, hoverable.onHover:Connect(function()
        if self._locked then
            return
        end

        callback()
    end))
end

function BaseElement:AddLeaveCallback(callback , customHoverable )
    local hoverable = customHoverable or (self._hoverable )    
local newMaid = self._maid

    return newMaid.GiveTask(newMaid, hoverable.onLeave:Connect(function()
        if self._locked then
            return
        end
        
        callback()
    end))
end

return BaseElement end function __DARKLUA_BUNDLE_MODULES.z()
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local ElementUtils = __DARKLUA_BUNDLE_MODULES.load('u')
local BaseElement = __DARKLUA_BUNDLE_MODULES.load('y')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Clickable = __DARKLUA_BUNDLE_MODULES.load('w')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local updateLink = ThemeService.updateLink
local runStyle = Animation.runStyle
local udim2New = UDim2.new
local type = type

local TOGGLED_CIRCLE_POSITION = udim2New(1, 0, 0.5, 0)
local DEFAULT_CIRCLE_POSITION = udim2New(0, 0, 0.5, 0)

local TOGGLED_CIRCLE_ANCHOR = Vector2.new(1, 0.5)
local DEFAULT_CIRCLE_ANCHOR = Vector2.new(0, 0.5)

local ToggleProperties = {
    selected = {
        toggleCircle = "ToggleCircleSelected",
        toggleCircleBorder = "ToggleCircleBorderSelected",
        toggleFrame = "ElementBackgroundSelected",
        toggleBorder = "ElementBorderSelected"
    },
    unselected = {
        toggleCircle = "ToggleCircleUnselected",
        toggleCircleBorder = "ToggleCircleBorderUnselected",
        toggleFrame = "ElementBackgroundUnselected",
        toggleBorder = "ElementBorderUnselected",
    },
}

local Toggle = {}
Toggle.__index = Toggle

setMetatable(Toggle, {__index = BaseElement})


















function Toggle.new(properties )     
local self = (BaseElement.new(properties) )    
local references = self._references
    
    references.toggleFrame = (createInstance("TextButton", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 40, 1, -2),
        ZIndex = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(29, 29, 34),
        Text = "",
        AutoButtonColor = false,
        Active = false
    }, references.elementContainer, "ElementBackgroundUnselected") )
    
references.toggleTextButtonOverlay = (createInstance("TextButton", {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1,
        Text = "",
        AutoButtonColor = false,
        Active = false
    }, references.textLabel) )
    
createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.toggleFrame)

    references.toggleBorder = (createInstance("UIStroke", {
        Color = Color3.fromRGB(32, 32, 38),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.toggleFrame, "ElementBorderUnselected") )
    
references.toggleCircle = (createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 10, 0, 8),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(59, 59, 68),
    }, references.toggleFrame, "ToggleCircleUnselected") )
    
createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.toggleCircle)

    references.toggleCircleBorder = (createInstance("UIStroke", {
        Color = Color3.fromRGB(43, 43, 50),
    }, references.toggleCircle, "ToggleCircleBorderUnselected") )
    
createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
    }, references.toggleFrame)

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.toggleBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
    end)

    self.AddLeaveCallback(self, function()
        runStyle("buttonLeave", references.toggleBorder, {
            Color = getThemeColor(self._selected and "ElementBorderSelected" or "ElementBorderUnselected"),
        })
    end)
    
    setMetatable(self, Toggle)
    
    local clickable = Clickable.new({references.toggleFrame, references.toggleTextButtonOverlay})
    self._clickable = clickable

    local maid = self._maid
    maid.GiveTask(maid, clickable.onRelease:Connect(function()
        self.SetValue(self, not self._value)
    end))

    return self
end

function Toggle:SetValueInternal(value , shouldAnimate )
    self.SetSelected(self, value, shouldAnimate)
    
    local references = self._references
    local newProperties = value and ToggleProperties.selected or ToggleProperties.unselected
    local oldProperties = value and ToggleProperties.unselected or ToggleProperties.selected
    local animationStyle = value and "buttonActivate" or "buttonDeactivate"

    for referenceName, themeProperty in next, newProperties do
        applyProperty(references[referenceName], {themeProperty, oldProperties[referenceName]}, animationStyle, shouldAnimate)
    end

    local newCirclePosition = value and TOGGLED_CIRCLE_POSITION or DEFAULT_CIRCLE_POSITION
    local newCircleAnchor = value and TOGGLED_CIRCLE_ANCHOR or DEFAULT_CIRCLE_ANCHOR
    local toggleCircle = references.toggleCircle

    if shouldAnimate then
        runStyle(animationStyle, toggleCircle, {
            Position = newCirclePosition,
            AnchorPoint = newCircleAnchor
        })
    else
        toggleCircle.Position = newCirclePosition
        toggleCircle.AnchorPoint = newCircleAnchor
    end
end

function Toggle:SetSelectedInternal(isSelected , shouldAnimate )
    
end

return Toggle end function __DARKLUA_BUNDLE_MODULES.A()
local Instances = __DARKLUA_BUNDLE_MODULES.load('g')

local TextService = (cloneref(game.GetService(game, "TextService")) )

local getTextBoundsAsync = TextService.GetTextBoundsAsync
local vector2New = Vector2.new

local Gui = {
    _textBoundParams = (Instances.createInstance("GetTextBoundsParams", {

    }, nil) )
}
local textBoundParams = Gui._textBoundParams

Gui.getTextSize = LPH_NO_VIRTUALIZE(function(text , font , textSize , width )     
textBoundParams.Font = font
    textBoundParams.Size = textSize
    textBoundParams.Width = width or 1000
    textBoundParams.Text = text

    return getTextBoundsAsync(TextService, textBoundParams)
end)

return Gui end function __DARKLUA_BUNDLE_MODULES.B()
local HudObjectComponent = __DARKLUA_BUNDLE_MODULES.load('x')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')
local Gui = __DARKLUA_BUNDLE_MODULES.load('A')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local updateLink = ThemeService.updateLink
local getTextSize = Gui.getTextSize
local runStyle = Animation.runStyle

local udim2New = UDim2.new

local TabButton = {}
TabButton.__index = TabButton

setMetatable(TabButton, {__index = HudObjectComponent})














function TabButton.new(properties )     
properties.isHoverable = true
    properties.isClickable = true

    local title = properties.title

    local references = {}

    references.holderFrame = (createInstance("TextButton", {
        Active = false,
        Selectable = false,
        ZIndex = 16,
        TextSize = 11,
        Size = UDim2.new(0, 0, 0, 25),
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0,
    }, nil, "SectionHeaderTextUnselected") )
    
references.buttonText = (createInstance("TextLabel", {
	    LayoutOrder = 2,
        FontFace = "Menu-Semibold",
        TextColor3 = Color3.fromRGB(220, 220, 245),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = title,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 22, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 15,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.holderFrame, "TabButtonTextUnselected") )
    
references.buttonImage = (createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(130, 130, 144),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 14, 0, 14),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = properties.image,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0.5, 0),
        ZIndex = 15,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.holderFrame, "TabButtonImageUnselected") )
    
local holderFrame = (references.holderFrame )    
properties.holderFrame = holderFrame

    local self = (HudObjectComponent.new(properties) )    
self._references = references

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask
    self._maid = newMaid

    local newSize = getTextSize(title, references.buttonText.FontFace, 14)

    references.holderFrame.Size = udim2New(0, newSize.X + 26, 0, 25)
    
    setMetatable(self, TabButton)
    
    local hoverable = (self._hoverable )
    
giveTask(newMaid, hoverable.onHover:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonHover", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextHover"),
        })
        runStyle("buttonHover", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageHover"),
        })
    end))

    giveTask(newMaid, hoverable.onLeave:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonLeave", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextUnselected"),
        })
        runStyle("buttonLeave", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageUnselected"),
        })
    end))

    return self
end

function TabButton:SetSelected(isSelected )
    if self._isSelected == isSelected then
        return
    end

    self._isSelected = isSelected

    local references = self._references

    if isSelected then
        runStyle("buttonActivate", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextSelected"),
        })
        runStyle("buttonActivate", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageSelected"),
        })
        updateLink(references.buttonImage, "TabButtonImageUnselected", "TabButtonImageSelected", true)
        updateLink(references.buttonText, "TabButtonTextUnselected", "TabButtonTextSelected", true)
    else
        runStyle("buttonDeactivate", references.buttonImage, {
            ImageColor3 = getThemeColor("TabButtonImageUnselected"),
        })
        runStyle("buttonDeactivate", references.buttonText, {
            TextColor3 = getThemeColor("TabButtonTextUnselected"),
        })
        updateLink(references.buttonImage, "TabButtonImageSelected", "TabButtonImageUnselected", true)
        updateLink(references.buttonText, "TabButtonTextSelected", "TabButtonTextUnselected", true)
    end
end

return TabButton end function __DARKLUA_BUNDLE_MODULES.C()
local HudObjectComponent = __DARKLUA_BUNDLE_MODULES.load('x')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local ElementUtils = __DARKLUA_BUNDLE_MODULES.load('u')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local updateLink = ThemeService.updateLink
local runStyle = Animation.runStyle

local SubsectionButton = {}
SubsectionButton.__index = SubsectionButton

setMetatable(SubsectionButton, {__index = HudObjectComponent})









function SubsectionButton.new(properties )     
properties.isHoverable = true
    properties.isClickable = true

    local references = {}

    references.holderFrame = createInstance("TextButton", {
        FontFace = "Menu-Bold",
        Active = false,
        Selectable = false,
        ZIndex = 16,
        TextSize = 11,
        Size = UDim2.new(0, 0, 0, 25),
        TextColor3 = Color3.fromRGB(194, 194, 207),
        Text = properties.title:upper(),
        AutoButtonColor = false,
        TextWrapped = true,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
    }, nil, "SectionHeaderTextUnselected")

    local holderFrame = (references.holderFrame )    
properties.holderFrame = holderFrame

    local self = (HudObjectComponent.new(properties) )    
self._references = references
    
    setMetatable(self, SubsectionButton)

    local newMaid = self._maid
    local giveTask = newMaid.GiveTask
    
    local hoverable = (self._hoverable )
    
giveTask(newMaid, hoverable.onHover:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonHover", references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextHover"),
        })
    end))

    giveTask(newMaid, hoverable.onLeave:Connect(function()
        if self._isSelected then
            return
        end

        runStyle("buttonHover", references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextUnselected"),
        })
    end))

    return self
end

function SubsectionButton:SetSelected(isSelected )
    if self._isSelected == isSelected then
        return
    end
    
    self._isSelected = isSelected

    local references = self._references
    local style = isSelected and "buttonActivate" or "buttonDeactivate"

    if isSelected then
        runStyle(style, references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextSelected"),
        })
        updateLink(references.holderFrame, "SectionHeaderTextUnselected", "SectionHeaderTextSelected", true)
    else
        runStyle(style, references.holderFrame, {
            TextColor3 = getThemeColor("SectionHeaderTextUnselected"),
        })
        updateLink(references.holderFrame, "SectionHeaderTextSelected", "SectionHeaderTextUnselected", true)
    end
end

return SubsectionButton end function __DARKLUA_BUNDLE_MODULES.D()
local mathFloor = math.floor

local Math = {}

Math.round = function(number , decimals ) 	
local mult = 10^(decimals or 0)
	return mathFloor(number * mult + 0.5) / mult
end

return Math end function __DARKLUA_BUNDLE_MODULES.E()
local UserInputService = (cloneref(game:GetService("UserInputService")) )
local RunService = (cloneref(game:GetService("RunService")) )

local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local ElementUtils = __DARKLUA_BUNDLE_MODULES.load('u')
local BaseElement = __DARKLUA_BUNDLE_MODULES.load('y')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Clickable = __DARKLUA_BUNDLE_MODULES.load('w')
local Hoverable = __DARKLUA_BUNDLE_MODULES.load('v')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')
local Math = __DARKLUA_BUNDLE_MODULES.load('D')

local isMouseButtonPressed = UserInputService.IsMouseButtonPressed
local getLastInputType = UserInputService.GetLastInputType
local getMouseLocation = UserInputService.GetMouseLocation

local renderStepped = RunService.RenderStepped
local renderSteppedWait = renderStepped.Wait
local mouseButton1 = Enum.UserInputType.MouseButton1

local createInstance = ThemedInstances.createInstance
local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local setMetatable = setmetatable
local vector2New = Vector2.new
local mouseWheel = Enum.UserInputType.MouseWheel
local mathClamp = math.clamp
local mathRound = Math.round
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local SliderProperties = {
    selected = {
        sliderCircle = "SliderCircleSelected",
        sliderCircleBorder = "SliderCircleBorderSelected",
        valueBox = "ElementBackgroundSelected",
        valueBoxBorder = "SliderValueBoxBorderSelected",
        valueLabel = "SliderValueTextSelected"
    },
    unselected = {
        sliderCircle = "SliderCircleUnselected",
        sliderCircleBorder = "SliderCircleBorderUnselected",
        valueBox = "ElementBackgroundUnselected",
        valueBoxBorder = "SliderValueBoxBorderUnselected",
        valueLabel = "SliderValueTextUnselected"
    },
}

local VALUE_BOX_START_POSITION = UDim2.new(1, -68, 0.5, 2)
local VALUE_BOX_END_POSITION = UDim2.new(1, -68, 0.5, 0)

local Slider = {}
Slider.__index = Slider

setMetatable(Slider, {__index = BaseElement})































function Slider.new(properties )     
local self = (BaseElement.new(properties) )    
local references = self._references

    references.sliderBar = (createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 60, 0, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(29, 29, 34),
    }, references.elementContainer, "ElementBackgroundUnselected") )
    
references.sliderBarBorder = (createInstance("UIStroke", {
    }, references.sliderBar, "ElementBorderUnselected") )
    
references.sliderFillBar = (createInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(95, 95, 113),
    }, references.sliderBar, "SliderBarFill") )
    
createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.sliderFillBar)

    references.sliderCircle = (createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 8, 0, 8),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(184, 184, 212),
    }, references.sliderFillBar, "SliderCircleUnselected") )
    
createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.sliderCircle)

    references.sliderCircleBorder = (createInstance("UIStroke", {
    }, references.sliderCircle, "SliderCircleBorderUnselected") )
    
references.sliderBarFillBorder = (createInstance("UIStroke", {
    }, references.sliderFillBar, "SliderBarFillBorder") )
    
createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 8),
    }, references.sliderBar)

    createInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, references.sliderBar)

    references.valueBox = (createInstance("TextButton", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -68, 0.5, 0),
        Size = UDim2.new(0, 0, 1, -2),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(95, 95, 113),
        Text = "",
        AutoButtonColor = false,
        Active = false
    }, references.elementContainer, "ElementBackgroundUnselected") )
    
createInstance("UICorner", {
        CornerRadius = UDim.new(0.25, 0),
    }, references.valueBox)

    references.valueBoxBorder = (createInstance("UIStroke", {
        Color = Color3.fromRGB(115, 115, 136),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.valueBox) )
    
createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
    }, references.valueBox)

    references.valueLabel = (createInstance("TextBox", {
        FontFace = "Menu-Bold",
        AnchorPoint = Vector2.new(0.5, 0),
        TextSize = 11,
        Size = UDim2.new(0, 0, 1, -1),
        TextColor3 = Color3.fromRGB(220, 220, 245),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BorderSizePixel = 0,
        Interactable = false
    }, references.valueBox, "SliderValueTextUnselected") )
    
references.sliderButtonOverlay = (createInstance("TextButton", {
        Active = false,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 60, 0, 14),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0.5, 0),
        BorderSizePixel = 0,
        TextSize = 14,
    }, references.elementContainer) )    
    
setMetatable(self, Slider)

    

    local minimumValue = properties.minimumValue or 0
    self._minimumValue = minimumValue
    self._maximumValue = properties.maximumValue or 100
    self._rounding = properties.rounding or 0
    self._valuePrefix = properties.valuePrefix
    self._valueSuffix = properties.valueSuffix
    
    self._dragging = false
    
    

    local clickable = Clickable.new({references.sliderButtonOverlay})
    self._clickable = clickable

    local maid = self._maid
    local giveTask = maid.GiveTask

    giveTask(maid, clickable.onDown:Connect(LPH_JIT_MAX(function()
        local lastMouseLocation = vector2New()
        local sliderBar = references.sliderBar
        
        self._dragging = true

        while isMouseButtonPressed(UserInputService, mouseButton1) do
            local mouseLocation = getMouseLocation(UserInputService)

            if mouseLocation == lastMouseLocation then
                renderSteppedWait(renderStepped)
                continue
            end

            lastMouseLocation = mouseLocation
            local distance = mathClamp((lastMouseLocation.X - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X, 0, 1)

            local minimumValue = self._minimumValue
            local maximumValue = self._maximumValue
            local rounding = self._rounding
            
            local value = mathRound(minimumValue + (maximumValue - minimumValue) * distance, rounding)

            if self._value ~= value then
                self.SetValueInternal(self, value, true)
            end
            renderSteppedWait(renderStepped)
        end

        self._dragging = false

        if self._barHoverable._isHovering then
            return
        end
        
        self._barHoverable.onLeave:Fire()
    end)))

    

    local barHoverable = Hoverable.new(references.sliderButtonOverlay)
    self._barHoverable = barHoverable

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.sliderBarFillBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
        runStyle("buttonHover", references.sliderCircle, {
            BackgroundColor3 = getThemeColor("SliderCircleHover"),
        })
    end, barHoverable)

    self.AddLeaveCallback(self, function()
        if self._dragging then
            return
        end

        runStyle("buttonLeave", references.sliderBarFillBorder, {
            Color = getThemeColor("SliderBarFillBorder"),
        })
        runStyle("buttonHover", references.sliderCircle, {
            BackgroundColor3 = getThemeColor(self._selected and "SliderCircleSelected" or "SliderCircleUnselected"),
        })
    end, barHoverable)
    
    local boxHoverable = Hoverable.new(references.valueBox)
    self._valueBoxHoverable = boxHoverable

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.valueBoxBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
    end, boxHoverable)

    self.AddLeaveCallback(self, function()
        runStyle("buttonHover", references.valueBoxBorder, {
            Color = getThemeColor(self._selected and "SliderValueBoxBorderSelected" or "SliderValueBoxBorderUnselected"),
        })
    end, boxHoverable)

    

    local boxClickable = Clickable.new({(references.valueBox )})
    local valueLabel = (references.valueLabel )
    
giveTask(maid, boxClickable.onRelease:Connect(function()
        valueLabel.Interactable = true
        valueLabel.CaptureFocus(valueLabel)
    end))

    giveTask(maid, valueLabel.FocusLost:Connect(function(enterPressed )
        valueLabel.Interactable = false

        local text = valueLabel.Text
        local newValue = tonumber(text)

        if not enterPressed or newValue == nil or self._value == newValue then
            self.SetValueLabel(self, self._value)
            return
        end

        self.SetValue(self, newValue)
    end))

    

    local scrollConnection = nil     
    
self.AddHoverCallback(self, LPH_JIT_MAX(function()
        if scrollConnection then
            return
        end

        scrollConnection = UserInputService.InputChanged:Connect(function(input )
            if input.UserInputType ~= mouseWheel then
                return
            end

            local delta = input.Position.Z * (self._maximumValue - self._minimumValue) / 100
            local newValue = self._value + delta

            self.SetValue(self, newValue)
        end)
    end), barHoverable)

    self.AddLeaveCallback(self, function()
        if scrollConnection then
            scrollConnection:Disconnect()
            scrollConnection = nil
        end
    end, barHoverable)

    

    self.SetValueInternal(self, properties.defaultValue or minimumValue, false)

    return self
end

function Slider:SetValueInternal(value , shouldAnimate )
    local minimumValue = self._minimumValue
    local maximumValue = self._maximumValue

    self.SetSelected(self, value > minimumValue, shouldAnimate)

    local clampedValue = mathRound(mathClamp(value, minimumValue, maximumValue), self._rounding)
    self._value = clampedValue

    local references = self._references

    local sliderFillBar = references.sliderFillBar
    local newSliderSize = udim2New((clampedValue - minimumValue)/(maximumValue - minimumValue), 0, 1, 0)
    
    if shouldAnimate then
        local valueBox = references.valueBox
        valueBox.Position = VALUE_BOX_START_POSITION

        runStyle("tabDrop", valueBox, {
            Position = VALUE_BOX_END_POSITION
        })
        runStyle("sliderSlide", sliderFillBar, {
            Size = newSliderSize,
        })
    else
        sliderFillBar.Size = newSliderSize
    end

    self.SetValueLabel(self, clampedValue)
end

function Slider:SetValueLabel(value )
    local references = self._references
    local valueLabel = references.valueLabel

    local prefix = self._valuePrefix or ""
    local suffix = self._valueSuffix or ""

    valueLabel.Text = prefix .. tostring(value) .. suffix
end

function Slider:SetSelectedInternal(isSelected , shouldAnimate )
    local references = self._references

    local newProperties = isSelected and SliderProperties.selected or SliderProperties.unselected
    local oldProperties = isSelected and SliderProperties.unselected or SliderProperties.selected

    for referenceName, themeProperty in next, newProperties do
        applyProperty(references[referenceName], {themeProperty, oldProperties[referenceName]}, isSelected and "buttonActivate" or "buttonDeactivate", shouldAnimate)
    end
end

return Slider end function __DARKLUA_BUNDLE_MODULES.F()
local UserInputService = (cloneref(game:GetService("UserInputService")) )
local RunService = (cloneref(game:GetService("RunService")) )

local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local ElementUtils = __DARKLUA_BUNDLE_MODULES.load('u')
local BaseElement = __DARKLUA_BUNDLE_MODULES.load('y')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Clickable = __DARKLUA_BUNDLE_MODULES.load('w')
local Hoverable = __DARKLUA_BUNDLE_MODULES.load('v')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')
local Math = __DARKLUA_BUNDLE_MODULES.load('D')

local isMouseButtonPressed = UserInputService.IsMouseButtonPressed
local getMouseLocation = UserInputService.GetMouseLocation

local renderStepped = RunService.RenderStepped
local renderSteppedWait = renderStepped.Wait
local mouseButton1 = Enum.UserInputType.MouseButton1

local createInstance = ThemedInstances.createInstance
local getThemeColor = ThemeService.getThemeColor
local applyProperty = ElementUtils.applyProperty
local setMetatable = setmetatable
local vector2New = Vector2.new
local mathClamp = math.clamp
local mathRound = Math.round
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local DropdownProperties = {
    selected = {
        dropdownBox = "ElementBackgroundSelected",
        boxBorder = "ElementBorderSelected",
        boxLabel = "DropdownTextSelected",
        boxImage = "DropdownImageSelected",
    },
    unselected = {
        dropdownBox = "ElementBackgroundUnselected",
        boxBorder = "ElementBorderUnselected",
        boxLabel = "DropdownBoxTextUnselected",
        boxImage = "DropdownImageUnselected",
    },
}

local Dropdown = {}
Dropdown.__index = Dropdown

setMetatable(Dropdown, {__index = BaseElement})






















function Dropdown.new(properties )     
local self = (BaseElement.new(properties) )    
local references = self._references

    references.dropdownBox = (createInstance("TextButton", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 1, -2),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(29, 29, 34),
        Text = "",
        Active = false,
        AutoButtonColor = false,
    }, references.elementContainer, "ElementBackgroundUnselected") )
    
createInstance("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.dropdownBox)

    createInstance("UICorner", {
        CornerRadius = UDim.new(0.25, 0),
    }, references.dropdownBox)

    references.boxBorder = (createInstance("UIStroke", {
        Color = Color3.fromRGB(32, 32, 38),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.dropdownBox, "ElementBorderUnselected") )
    
createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
    }, references.dropdownBox)

    references.boxLabel = (createInstance("TextLabel", {
        FontFace = "Menu-Bold",
        TextColor3 = Color3.fromRGB(92, 92, 108),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "None",
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, -1),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextXAlignment = Enum.TextXAlignment.Right,
        BorderSizePixel = 0,
        TextSize = 11,
        LayoutOrder = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.dropdownBox, "DropdownBoxTextUnselected") )
    
references.dropdownDividerHolder = (createInstance("Frame", {
        LayoutOrder = 2,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 4, 1, 2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    }, references.dropdownBox) )
    
references.dropdownDivider = (createInstance("Frame", {
        LayoutOrder = 2,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(0, 2, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(40, 40, 48),
    }, references.dropdownDividerHolder, "DropdownDividerUnselected") )
    
references.boxImage = (createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(92, 92, 121),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 6, 0, 6),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = "Dropdown",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, 0),
        LayoutOrder = 3,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.dropdownBox, "DropdownImageUnselected") )
    
setMetatable(self, Dropdown)

    

    self._minimumSelected = properties.minimumSelected or 0
    self._maximumSelected = properties.maximumSelected or 1
    self._value = {}
    
    

    local maid = self._maid
    local giveTask = maid.GiveTask

    

    local boxHoverable = Hoverable.new(references.dropdownBox)
    self._boxHoverable = boxHoverable

    self.AddHoverCallback(self, function()
        runStyle("buttonHover", references.boxBorder, {
            Color = getThemeColor("ElementBorderHover"),
        })
    end, boxHoverable)

    self.AddLeaveCallback(self, function()
        runStyle("buttonLeave", references.boxBorder, {
            Color = getThemeColor(self._selected and "ElementBorderSelected" or "ElementBorderUnselected"),
        })
    end, boxHoverable)

    

    self.SetValueInternal(self, properties.defaultValue or nil, false)

    return self
end

function Dropdown:SetValueInternal(value , shouldAnimate )
    
end

function Dropdown:SetSelectedInternal(isSelected , shouldAnimate )
    local references = self._references

    local newProperties = isSelected and DropdownProperties.selected or DropdownProperties.unselected
    local oldProperties = isSelected and DropdownProperties.unselected or DropdownProperties.selected

    for referenceName, themeProperty in next, newProperties do
        applyProperty(references[referenceName], {themeProperty, oldProperties[referenceName]}, isSelected and "buttonActivate" or "buttonDeactivate", shouldAnimate)
    end
end

return Dropdown end function __DARKLUA_BUNDLE_MODULES.G()
local HudObjectComponent = __DARKLUA_BUNDLE_MODULES.load('x')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable
local updateLink = ThemeService.updateLink
local destroy = game.Destroy

local DropdownOption = {}
DropdownOption.__index = DropdownOption

setMetatable(DropdownOption, {__index = HudObjectComponent})













function DropdownOption.new(optionName , optionImage )     
local self = (HudObjectComponent.new({
        isClickable = true,
        isHoverable = true
    }) )
    
setMetatable(self, DropdownOption)

    local references = self._references
    references.optionLabel = (createInstance("TextLabel", {
        FontFace = "Menu-Bold",
        TextColor3 = Color3.fromRGB(195, 195, 213),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = optionName,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0.9200000166893005, 0, -0.40243902802467346, 0),
        TextSize = 11,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, nil, "DropdownOptionTextUnselected") )
    
references.optionDivider = (createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 4),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(54, 54, 63),
    }, references.optionLabel, "DropdownOptionDivider") )
    
references.optionCheck = (createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(216, 216, 235),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ResampleMode = Enum.ResamplerMode.Pixelated,
        Size = UDim2.new(0, 8, 0, 8),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = optionImage or "Checkmark",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0.5, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.optionLabel, "DropdownOptionImage") )
    
return self
end

function DropdownOption:Destroy()
    local references = self._references
    for index, instance in next, references do
        destroy(instance)
        references[index] = nil
    end
end

function DropdownOption:SetSelected()
    if self.isSelected then
        return
    end
    self.isSelected = true

    local references = self._references
    updateLink(references.optionLabel, "DropdownOptionTextUnelected", "DropdownOptionTextSelected")
end

function DropdownOption:SetUnselected()
    if not self.isSelected then
        return
    end
    self.isSelected = false

    local references = self._references
    updateLink(references.optionLabel, "DropdownOptionTextSelected", "DropdownOptionTextUnselected")
end

return DropdownOption end function __DARKLUA_BUNDLE_MODULES.H()
local InputManager = __DARKLUA_BUNDLE_MODULES.load('p')
local HudObject = __DARKLUA_BUNDLE_MODULES.load('s')

local HudService = {
    _hudObjects = {} ,
    _frame = nil ,
    _isOpen = false ,
}
local hudObjects = HudService._hudObjects



function HudService.init(properties)
    local screenGui = properties.screenGui
    HudService._screenGui = screenGui
end

function HudService.addHudObject(name, hudObject)
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

return HudService end function __DARKLUA_BUNDLE_MODULES.I()
local DropdownOption = __DARKLUA_BUNDLE_MODULES.load('G')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local AssetsManager = __DARKLUA_BUNDLE_MODULES.load('h')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Hoverable = __DARKLUA_BUNDLE_MODULES.load('v')
local Gui = __DARKLUA_BUNDLE_MODULES.load('A')

local createInstance = ThemedInstances.createInstance
local getThemeColor = ThemeService.getThemeColor
local linkInstance = ThemeService.linkInstance
local setMetatable = setmetatable
local getTextSize = Gui.getTextSize
local vector2New = Vector2.new
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local MAX_FRAME_HEIGHT = 80
local FONT = (AssetsManager.getFont("Menu-Bold") )

local DropdownFrame = {
    _references = {} 





,
    _currentOptions = {},
    isVisible = false 
}
local currentOptions = DropdownFrame._currentOptions
local references = DropdownFrame._references



function DropdownFrame.addOption(optionName , optionImage )
    local newOption = DropdownOption.new(optionName, optionImage)
    
    local Clickable = newOption._clickable
    local Hoverable = (newOption._hoverable )
    
Hoverable.onHover:Connect(function()
        runStyle("buttonHover", newOption._references.optionLabel, {
            TextColor3 = getThemeColor("DropdownOptionTextHover")
        })
    end)

    Hoverable.onLeave:Connect(function()
        runStyle("buttonLeave", newOption._references.optionLabel, {
            TextColor3 = newOption.isSelected and getThemeColor("DropdownOptionTextUnselected") or getThemeColor("DropdownOptionTextSelected")
        })
    end)
end

function DropdownFrame.removeOption()
    
end

function DropdownFrame.open(bindFrame , options )
    if DropdownFrame.isVisible then
        return
    end
    DropdownFrame.isVisible = true

    local longestNameLength = 0
    for _, option in next, options do
        local nameSize = getTextSize(option.optionName, FONT, 14)
        if nameSize.X > longestNameLength then
            longestNameLength = nameSize.X
        end
    end

    local dropdownFrame = references.dropdownFrame
    dropdownFrame.Size = udim2New(0, longestNameLength + 16, 0, references.dropdownFrame.Size.Y.Offset)
    dropdownFrame.Visible = true

    local newPosition = bindFrame.AbsolutePosition + bindFrame.AbsoluteSize + vector2New(0, 2)
    dropdownFrame.Position = udim2New(0, newPosition.X, 0, newPosition.Y)
    
    local dropPosition = bindFrame.AbsolutePosition + bindFrame.AbsoluteSize + vector2New(0, 6)

    runStyle("secondaryDrop", dropdownFrame, {
        Position = udim2New(0, dropPosition.X, 0, dropPosition.Y)
    })
end

function DropdownFrame.close()
    if not DropdownFrame.isVisible then
        return
    end
    DropdownFrame.isVisible = false

    local dropdownFrame = references.dropdownFrame
    dropdownFrame.Visible = false
end

function DropdownFrame.init()
    local dropdownFrame = (createInstance("ScrollingFrame", {
        ScrollBarImageColor3 = Color3.fromRGB(129, 129, 150),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 1,
        Selectable = false,
        BackgroundColor3 = Color3.fromRGB(38, 38, 45),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 58, 0, 54),
        Position = UDim2.new(0, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, __DARKLUA_BUNDLE_MODULES.load('H')._screenGui) )    
references.dropdownFrame = dropdownFrame

    linkInstance(references.dropdownFrame, "DropdownOptionScrollBar")
    linkInstance(references.dropdownFrame, "DropdownOptionBackground")

    references.UICorner = (createInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
    }, references.dropdownFrame) )
    
references.UIPadding = (createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
    }, references.dropdownFrame) )
    
references.UIListLayout = (createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.dropdownFrame) )
    
references.UIStroke = (createInstance("UIStroke", {
        Color = Color3.fromRGB(46, 46, 54),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, references.dropdownFrame, "DropdownOptionBorder") )
    
references.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local absoluteSize = dropdownFrame.AbsoluteSize

        local exceedsHeight = absoluteSize.Y > MAX_FRAME_HEIGHT
        if exceedsHeight then
            dropdownFrame.AutomaticSize = Enum.AutomaticSize.None
            dropdownFrame.Size = UDim2.new(0, absoluteSize.X, 0, MAX_FRAME_HEIGHT)
        else
            dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
        end
    end)
end

return DropdownFrame end function __DARKLUA_BUNDLE_MODULES.J()
local ComponentRegistry = {
    _sharedComponents = {},
    _components = {}
}
local sharedComponents = ComponentRegistry._sharedComponents
local components = ComponentRegistry._components



components.Window = __DARKLUA_BUNDLE_MODULES.load('t')
components.Toggle = __DARKLUA_BUNDLE_MODULES.load('z')
components.TabButton = __DARKLUA_BUNDLE_MODULES.load('B')
components.SubsectionButton = __DARKLUA_BUNDLE_MODULES.load('C')

components.Toggle = __DARKLUA_BUNDLE_MODULES.load('z')
components.Slider = __DARKLUA_BUNDLE_MODULES.load('E')
components.Dropdown = __DARKLUA_BUNDLE_MODULES.load('F')
components.BaseElement = __DARKLUA_BUNDLE_MODULES.load('y')

sharedComponents.DropdownFrame = __DARKLUA_BUNDLE_MODULES.load('I')
sharedComponents.DropdownOption = __DARKLUA_BUNDLE_MODULES.load('G')

return ComponentRegistry end function __DARKLUA_BUNDLE_MODULES.K()
local ComponentRegistry = __DARKLUA_BUNDLE_MODULES.load('J')
local components = ComponentRegistry._components

local BuilderService = {}


function BuilderService.init()
    for _, sharedComponent in next, ComponentRegistry._sharedComponents do
        sharedComponent.init()
    end
end

function BuilderService.createUIObject(objectType , properties )     
local objectData = components[objectType]

    if not objectData then
        return
    end

    local newObject = objectData.new(properties)

    return newObject
end

return BuilderService end function __DARKLUA_BUNDLE_MODULES.L()
local Signal = __DARKLUA_BUNDLE_MODULES.load('l')

local setMetatable = setmetatable

local InternalKeybind = {}
InternalKeybind.__index = InternalKeybind











function InternalKeybind.new(properties )     
local self = {
        _isUserMade = false,
        _keybindName = properties.name or "Unknown Keybind",
        _keyCode = properties.keyCode or Enum.KeyCode.Unknown,
        _onTriggered = Signal.new()
    }

    setMetatable(self, InternalKeybind)

    return self
end

function InternalKeybind.trigger(self )
    self._onTriggered:Fire()
end

return InternalKeybind end function __DARKLUA_BUNDLE_MODULES.M()
local InternalBind = __DARKLUA_BUNDLE_MODULES.load('L')
local InputManager = __DARKLUA_BUNDLE_MODULES.load('p')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local next = next

local KeybindService = {
    _internalBinds = {} ,
    _maid = (Maid.new() ),
}
local internalBinds = KeybindService._internalBinds
local newMaid = KeybindService._maid

local function setInternalBindKeyCode(bind , keyCode )
    local old = bind._keyCode
    bind._keyCode = keyCode

    if old then
        local bindHolder = internalBinds[old]

        if bindHolder then
            bindHolder[bind._keybindName] = nil

            if not next(bindHolder) then
                internalBinds[old] = nil
            end
        end
    end

    local bindHolder = internalBinds[keyCode]
    if not bindHolder then
        bindHolder = {}
        internalBinds[keyCode] = bindHolder
    end

    bindHolder[bind._keybindName] = bind

    bind._keyCode = keyCode
end

function KeybindService.init()
    newMaid.GiveTask(newMaid, InputManager.onInputBegan:Connect(LPH_JIT_MAX(function(input , gameProcessed )
        local keyCode = input.KeyCode
        local inputType = input.UserInputType

        local internalBindsHolder = internalBinds[keyCode] or internalBinds[inputType]
        if internalBindsHolder then
            for name, internalKeyBind in next, internalBindsHolder do
                internalKeyBind.trigger(internalKeyBind)
            end
        end
    end)))
end

function KeybindService.unload()
    newMaid:DoCleaning()
end

function KeybindService.createInternalBind(properties )
    local self = InternalBind.new(properties)
    
    if self._keyCode then
        setInternalBindKeyCode(self, self._keyCode)
    end

    return self
end

return KeybindService end function __DARKLUA_BUNDLE_MODULES.N()
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local BuilderService = __DARKLUA_BUNDLE_MODULES.load('K')

local createInstance = ThemedInstances.createInstance
local createUIObject = BuilderService.createUIObject
local setMetatable = setmetatable

local MainWindowSubsection = {}
MainWindowSubsection.__index = MainWindowSubsection












function MainWindowSubsection.new(properties )     
local references = {}

    local self = {
        _references = references,
        _isSelected = false,
        _elements = {},
        _elementsOrdered = {},
        _subsectionButton = properties.subsectionButton
    }

    references.elementHolder = createInstance("Frame", {
        Position = UDim2.new(0, 9, 0, 36),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -18, 1, -43),
        BorderSizePixel = 0,
        Visible = false
    }, nil)

    createInstance("UIListLayout", {
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.elementHolder)

    createInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
    }, references.elementHolder)
    
    setMetatable(self, MainWindowSubsection)

    return self
end

function MainWindowSubsection.Select(self )
    if self._isSelected then
        return
    end

    self._isSelected = true
    self._references.elementHolder.Visible = true
    self._subsectionButton:SetSelected(true)
end

function MainWindowSubsection.Unselect(self )
    if not self._isSelected then
        return
    end

    self._isSelected = false
    self._references.elementHolder.Visible = false
    self._subsectionButton:SetSelected(false)
end

function MainWindowSubsection.CreateElement(self , properties )     
local elementType = properties.element
    local title = properties.title

    local newElement = createUIObject(elementType, properties.elementProperties)

    newElement.holderFrame.Parent = self._references.elementHolder

    local elementsOrdered = self._elementsOrdered
    local elements = self._elements

    elementsOrdered[#elementsOrdered + 1] = newElement
    elements[title] = newElement
    
    return newElement
end

return MainWindowSubsection end function __DARKLUA_BUNDLE_MODULES.O()
local MainWindowSubsection = __DARKLUA_BUNDLE_MODULES.load('N')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local BuilderService = __DARKLUA_BUNDLE_MODULES.load('K')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable
local taskSpawn = task.spawn
local taskWait = task.wait
local runStyle = Animation.runStyle

local MainWindowSection = {}
MainWindowSection.__index = MainWindowSection












function MainWindowSection.new(mainWindowTab , properties )     
local references = {}

    local self = {
        _references = references,
        _subsections = {},
        _subsectionsOrdered = {},
        _maid = Maid.new()
    }

    references.holderFrame = createInstance("Frame", {
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
    }, nil, "SectionBorder")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.holderFrame)

    references.inside = createInstance("Frame", {
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(21, 21, 24),
    }, references.holderFrame, "SectionBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.inside)

    references.header = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 31),
    }, references.inside, "SectionHeaderBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.header)

    references.headerDivider = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(35, 35, 42),
    }, references.header, "SectionBorder")

    references.headerImage = createInstance("ImageLabel", {
        ImageColor3 = Color3.fromRGB(168, 168, 180),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(0, 11, 0, 11),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = properties.image,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 7, 0.5, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.header, "SectionHeaderImage")

    references.headerDownLine = createInstance("Frame", {
        Size = UDim2.new(0, 1, 0, 5),
        Position = UDim2.new(0, 12, 0, 18),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(168, 168, 180),
    }, references.header, "SectionHeaderLine")

    references.headerBottomLine = createInstance("Frame", {
        Size = UDim2.new(0, 54, 0, 1),
        Position = UDim2.new(0, 13, 0, 22),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 4,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(168, 168, 180),
    }, references.header, "SectionHeaderLine")

    references.headerFix = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 3,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(26, 26, 31),
    }, references.header, "SectionHeaderBackground")

    references.subsectionHolder = createInstance("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 21, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, -30, 0, 24),
        BorderSizePixel = 0,
    }, references.header)

    createInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal,
    }, references.subsectionHolder)

    setMetatable(self, MainWindowSection)

    return self
end

function MainWindowSection.SetSelectedSubsection(self , selectedSubsection )
    local lastSubsection = self._selectedSubsection

    if lastSubsection then
        lastSubsection.Unselect(lastSubsection)
    end

    selectedSubsection.Select(selectedSubsection)

    self._selectedSubsection = selectedSubsection

    local subsectionButton = selectedSubsection._subsectionButton.holderFrame

    if subsectionButton.AbsoluteSize.X == 0 then
        repeat 
            taskWait()
        until subsectionButton.AbsoluteSize.X > 0
    end

    local references = self._references
    local headerBottomLine = references.headerBottomLine

    local newSize = (subsectionButton.AbsolutePosition.X - headerBottomLine.AbsolutePosition.X) + 4 + subsectionButton.AbsoluteSize.X
    
    runStyle("sectionLine", headerBottomLine, {
        Size = UDim2.new(0, newSize, 0, 1)
    })
end

function MainWindowSection.CreateSubsection(self , properties )     
local newSubsectionButton = BuilderService.createUIObject("SubsectionButton", {
        container = self,
        title = properties.title
    })

    newSubsectionButton.holderFrame.Parent = self._references.subsectionHolder

    local newSubsection = MainWindowSubsection.new({
        subsectionButton = newSubsectionButton
    })

    newSubsection._references.elementHolder.Parent = self._references.inside

    local subsections = self._subsections
    local subsectionsOrdered = self._subsectionsOrdered

    local isFirst = not next(subsections)

    subsections[properties.title] = newSubsection
    subsectionsOrdered[#subsectionsOrdered + 1] = newSubsection

    local clickable = newSubsectionButton._clickable
    local maid = self._maid

    maid.GiveTask(maid, clickable.onRelease:Connect(function()
        if self._selectedSubsection == newSubsection then
            return
        end
        
        self.SetSelectedSubsection(self, newSubsection)
    end))

    if isFirst then
        taskSpawn(self.SetSelectedSubsection, self, newSubsection)
    end

    return newSubsection
end

return MainWindowSection end function __DARKLUA_BUNDLE_MODULES.P()
local RunService = (cloneref(game.GetService(game, "RunService")) )

local MainWindowSection = __DARKLUA_BUNDLE_MODULES.load('O')
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')

local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable

local renderStepped = RunService.RenderStepped
local renderSteppedWait = renderStepped.Wait

local MainWindowTab = {}
MainWindowTab.__index = MainWindowTab












function MainWindowTab.new(properties )     
local references = {}

    references.tabFrame = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 9, 0, 51),
        Size = UDim2.new(1, -18, 1, -53),
        ZIndex = 12,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Visible = false
    })

    references.sectionContainer = createInstance("ScrollingFrame", {
        ScrollBarImageColor3 = Color3.fromRGB(120, 120, 140),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 4,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Selectable = false,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 21,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, references.tabFrame)

    references.left = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, -5, 1, 0),
        ZIndex = 12,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.sectionContainer)

    references.leftLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.left)

    references.right = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0.5, -5, 1, 0),
        ZIndex = 12,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, references.sectionContainer)

    references.rightLayout = createInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.right)

    createInstance("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
    }, references.sectionContainer)

    local tabButton = properties.tabButton

    local self = {
        _tabButton = tabButton,
        _isVisible = false,
        _sections = {},
        _sectionsOrdered = {},
        _references = references
    }

    setMetatable(self, MainWindowTab)

    return self
end

function MainWindowTab.Select(self )
    if self._isVisible then
        return
    end

    self._isVisible = true
    self._references.tabFrame.Visible = true
    self._tabButton:SetSelected(true)
end

function MainWindowTab.Unselect(self )
    if not self._isVisible then
        return
    end

    self._isVisible = false
    self._references.tabFrame.Visible = false
    self._tabButton:SetSelected(false)
end

function MainWindowTab.CreateSection(self , properties )     
local newSection = MainWindowSection.new(self, properties)
    local sectionsOrdered = self._sectionsOrdered

    self._sections[properties.title] = newSection
    sectionsOrdered[#sectionsOrdered + 1] = newSection

    return newSection
end

function MainWindowTab.RefreshSectionsLayout(self )
    local sectionsOrdered = self._sectionsOrdered
    local rightLayout = self._references.rightLayout
    local leftLayout = self._references.leftLayout

    for i = 1, #sectionsOrdered do
        local section = sectionsOrdered[i]
        local references = section._references

        local holderFrame = references.holderFrame
        holderFrame.Parent = nil
    end

    for i = 1, #sectionsOrdered do
        renderSteppedWait(renderStepped)

        local section = sectionsOrdered[i]
        local references = section._references

        local holderFrame = references.holderFrame

        if leftLayout.AbsoluteContentSize.Y <= rightLayout.AbsoluteContentSize.Y then
            holderFrame.Parent = self._references.left
        else
            holderFrame.Parent = self._references.right
        end
    end
end

return MainWindowTab end function __DARKLUA_BUNDLE_MODULES.Q()
local ThemedInstances = __DARKLUA_BUNDLE_MODULES.load('o')
local BuilderService = __DARKLUA_BUNDLE_MODULES.load('K')
local MainWindowTab = __DARKLUA_BUNDLE_MODULES.load('P')
local Animation = __DARKLUA_BUNDLE_MODULES.load('i')
local Window = __DARKLUA_BUNDLE_MODULES.load('t')
local Maid = __DARKLUA_BUNDLE_MODULES.load('m')

local udim2FromOffset = UDim2.fromOffset
local createInstance = ThemedInstances.createInstance
local setMetatable = setmetatable
local runStyle = Animation.runStyle
local udim2New = UDim2.new

local MainWindow = {}
MainWindow.__index = MainWindow










setMetatable(MainWindow, {__index = Window})

function MainWindow.init(properties )     
local window = BuilderService.createUIObject("Window", {
        isDraggable = true,
        isForcedVisible = false,
        minSize = udim2FromOffset(550, 400),
        maxSize = udim2FromOffset(1000, 700),
        windowTitle = properties.windowTitle,
        subTitle = properties.subTitle,
        zIndex = 10
    })

    local references = window._references

    references.topRight = createInstance("Frame", {
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BorderSizePixel = 0,
        Position = udim2New(1, -10, 0, 10),
        Size = udim2New(0, 0, 0, 30),
        ZIndex = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(23, 23, 29),
    }, references.holderFrame, "WindowRightHeaderBackground")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, references.topRight)

    references.tabSlider = createInstance("Frame", {
        BorderSizePixel = 0,
        Size = udim2New(1, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 14,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Color3.fromRGB(50, 50, 62),
    }, nil, "TabButtonSlideBackground")

    createInstance("UIStroke", {
        Color = Color3.fromRGB(70, 70, 85),
    }, references.tabSlider, "TabButtonSlideBorder")

    createInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
    }, references.tabSlider)

    references.tabContainer = createInstance("Frame", {
        BackgroundTransparency = 1,
        Position = udim2New(0, 0, 0, 2),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Size = udim2New(0, 0, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        AutomaticSize = Enum.AutomaticSize.X,
    }, references.topRight)

    createInstance("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, references.tabContainer)

    createInstance("UIPadding", {
        PaddingRight = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
    }, references.tabContainer)

    createInstance("UIStroke", {
        Color = Color3.fromRGB(35, 35, 42),
    }, references.topRight, "WindowRightHeaderBorder")

    local tabs = properties.tabs or {}

    setMetatable(window, MainWindow)
    
    local windowTabs = {}
    window._tabs = windowTabs
    window._maid = Maid.new()
    window._selectedTab = nil

    for i = 1, #tabs do
        local tabProperties = tabs[i]

        local newTab = window.CreateTab(window, {
            title = tabProperties.title,
            image = tabProperties.image,
            order = i
        })
        
        windowTabs[tabProperties.title] = newTab
        
        local sections = tabProperties.sections or {}

        for i = 1, #sections do
            local sectionProperties = sections[i]
            local newSection = newTab.CreateSection(newTab, sectionProperties)

            local subsections = sectionProperties.subsections or {}

            for j = 1, #subsections do
                local subSectionProperties = subsections[j]
                local newSubsection = newSection.CreateSubsection(newSection, subSectionProperties)

                local elements = subSectionProperties.elements or {}

                for i = 1, #elements do
                    local newElement = newSubsection.CreateElement(newSubsection, elements[i])
                    
                end
            end
        end

        newTab.RefreshSectionsLayout(newTab)
    end

    return window
end

function MainWindow.CreateTab(self , properties )     
local tabButton = BuilderService.createUIObject("TabButton", {
        container = self._references.tabContainer,
        title = properties.title,
        image = properties.image
    })

    local newTab = (MainWindowTab.new({
        tabButton = tabButton,
        order = properties.order
    }) )
    
newTab._references.tabFrame.Parent = self._references.holderFrame
    tabButton._references.holderFrame.Parent = self._references.tabContainer
    
    local tabs = self._tabs
    local isFirstTab = next(tabs) == nil

    tabs[properties.title] = newTab

    if isFirstTab then
        self.SetSelectedTab(self, properties.title)
    end

    local clickable = tabButton._clickable
    local maid = self._maid

    maid.GiveTask(maid, clickable.onRelease:Connect(function()
        if self._selectedTab == newTab then
            return
        end
        
        self.SetSelectedTab(self, properties.title)
    end))

    return newTab
end

function MainWindow.SetSelectedTab(self , tabName )
    local lastTab = self._selectedTab

    if lastTab then
        lastTab.Unselect(lastTab)
    end

    local tab = self._tabs[tabName]

    if tab then
        tab.Select(tab)
    end

    self._selectedTab = tab

    local tabButton = tab._tabButton
    local tabReferences = tab._references
    local tabHolderFrame = tabButton._references.holderFrame

    local references = self._references
    local tabSlider = references.tabSlider

    if not tabSlider.Parent then
        tabSlider.Parent = tabHolderFrame
        tabSlider.Position = udim2New(0, 0, 0, 0)
        return
    end

    local tabFrame = tabReferences.tabFrame
    tabFrame.Position = UDim2.new(0, 9, 0, 43)

    runStyle("tabDrop", tabFrame, {
        Position = UDim2.new(0, 9, 0, 51)
    })

    local lastAbsolutePosition = tabSlider.AbsolutePosition
    tabSlider.Parent = tabButton._references.holderFrame

    local newPosition = tabHolderFrame.AbsolutePosition
    local offsetX = lastAbsolutePosition.X - newPosition.X

    tabSlider.Position = udim2New(0, offsetX, 0, 0)

    runStyle("tabSlide", tabSlider, {
        Position = udim2New(0, 0, 0, 0)
    }, function()
        tabSlider.Position = udim2New(0, 0, 0, 0)
    end)
end

return MainWindow end function __DARKLUA_BUNDLE_MODULES.R()
local BuilderService = __DARKLUA_BUNDLE_MODULES.load('K')
local KeybindService = __DARKLUA_BUNDLE_MODULES.load('M')
local ThemeService = __DARKLUA_BUNDLE_MODULES.load('n')
local InputManager = __DARKLUA_BUNDLE_MODULES.load('p')
local HudService = __DARKLUA_BUNDLE_MODULES.load('H')
local Instances = __DARKLUA_BUNDLE_MODULES.load('g')

local createInstance = Instances.createInstance
local destroy = workspace.Destroy

local Menu = {
    _screenGui = nil ,
}

function Menu.init(menuConfig)
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

    local mainWindow = (__DARKLUA_BUNDLE_MODULES.load('Q') )
    

    

HudService.addHudObject("MainWindow", mainWindow.init({
        windowTitle = "Juju",
        subTitle = menuConfig.mainWindow.subTitle,
        tabs = menuConfig.mainWindow.tabs
    }))
    
    

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

return Menu end function __DARKLUA_BUNDLE_MODULES.S()
local InstanceProtection = __DARKLUA_BUNDLE_MODULES.load('e')
local Instances = __DARKLUA_BUNDLE_MODULES.load('g')

local Menu = __DARKLUA_BUNDLE_MODULES.load('R')

local cloneFunction = clonefunction
local createInstance = Instances.createInstance
local setRawMetatable = cloneFunction(setrawmetatable)
local isFunctionHooked = cloneFunction(isfunctionhooked)
local identifyExecutor = cloneFunction(identifyexecutor)
local getMetaTable = cloneFunction(getmetatable)
local setMetatable = cloneFunction(setmetatable)
local isCClosure = cloneFunction(iscclosure)
local cloneRef = cloneFunction(cloneref)
local getInfo = cloneFunction(debug.getinfo)
local taskWait = cloneFunction(task.wait)
local getGC = getgc
local type = cloneFunction(type)








local ProtectionFlags= {
    antiHook = {
        thread = true,
        detection = function(flag)
            local executor = identifyExecutor()
            
            local checkedFunctions = {
                getrawmetatable = {
                    getrawmetatable
                },
                setfflag = {
                    setfflag
                },
                getfflag = {
                    getfflag
                },
                sethiddenproperty = {
                    sethiddenproperty
                },
                gethiddenproperty = {
                    gethiddenproperty
                },
                getgc = {
                    getGC
                }
            }

            local c = "=[C]"

            local function checkFunction(func)
                if not isCClosure(func) or getInfo(func).source ~= c then
                    return false
                end

                if isFunctionHooked(func) then
                    return false
                end

                return true
            end

            
            
            local gc = getGC(false)
            local funcCounts = {}

            if executor == "Potassium" then
                funcCounts.setfflag = -1
                funcCounts.getfflag = -1
            end
            
            for index, func in next, gc do
                if type(func) == "function" then
                    local info = getInfo(func)
                    
                    if info.source ~= c then
                        continue
                    end

                    local name = info.name

                    if not name then
                        continue
                    end

                    local check = checkedFunctions[name]
                    
                    if not check then
                        continue
                    end

                    if not funcCounts[name] then
                        funcCounts[name] = 0
                    end

                    funcCounts[name] += 1
                end
            end

            for name, count in next, funcCounts do
                if count > 1 then
                    flag("func c fail " .. name)
                end
            end

            for name, data in next, checkedFunctions do
                if not funcCounts[name] or funcCounts[name] == 0 then
                    flag("func tc fail " .. name)
                end
            end

            local crash = setMetatable({ClassName = "Folder"}, {
                __iter = function()
                    flag("getgc trap")
                end,
                __index = function()
                    flag("getgc trap")
                end,
                __newindex = function()
                    flag("getgc trap")
                end,
                __tostring = function()
                    return "Instance"
                end,
            })

            while true do
                if not crash then
                    flag("getgc trap tamper")
                    break
                end
                for index, data in next, checkedFunctions do
                    if not checkFunction(data[1]) then
                        flag("func fail " .. index)
                    end
                end
                taskWait(0.5)
            end
        end
    },
    antiCopy = {
        thread = true,
        detection = function(flag)
            local getRawMetatable = getrawmetatable

            repeat taskWait() until Menu._screenGui

            local screenGui = Menu._screenGui
            local metaTable = getRawMetatable(screenGui)

            if not metaTable or metaTable ~= getRawMetatable(workspace) then
                flag("no meta table")
                return
            end

            local newMetatable = InstanceProtection.protectInstance(screenGui, flag)

            while true do
                if getRawMetatable(screenGui) ~= newMetatable then
                    flag("meta table tamper")
                    break
                end
                taskWait(0.5)
            end
        end
    },
    antiDex = {
        thread = true,
        detection = LPH_JIT(function(flag)
            local setScriptable = cloneFunction(setscriptable)

            local random = Random.new()
            local nextInteger = random.NextInteger

            local possibleParents = {
                game.GetService(game, "CookiesService"),
                game.GetService(game, "ThirdPartyUserService"),
                game.GetService(game, "Visit")
            }

            for i = 1, 9 do
                local newInstance = createInstance("Motor6D", {
                    RandomizedName = true
                }, i == 9 and cloneRef(gethui()) or cloneRef(possibleParents[nextInteger(random, 1, #possibleParents)]))
                
                setScriptable(newInstance, "Name", false)
                setScriptable(newInstance, "Parent", false)
                setScriptable(newInstance, "ClassName", false)
            end

            for index, parent in next, possibleParents do
                setScriptable(parent, "Name", false)
                setScriptable(parent, "Parent", false)
                setScriptable(parent, "ClassName", false)
            end

            local isExecutorClosure = cloneFunction(isexecutorclosure)
            local getConnections = cloneFunction(getconnections)
            local descendantAdded = game.DescendantAdded

            while true do
                local connections = getConnections(descendantAdded)

                for index, connection in next, connections do
                    local func = connection.Function
                    if func and isExecutorClosure(func) then
                        flag("likely dex")
                        break
                    end
                end

                taskWait(1)
            end
        end)
    },
    antiInfoTamper = {
        thread = true,
        detection = LPH_JIT(function(flag)
            local ScriptInformation = (__DARKLUA_BUNDLE_MODULES.load('b')
)            local UserInformation = (__DARKLUA_BUNDLE_MODULES.load('c')
)
            local newMetatable = {
                __newindex = function(_, _, _)
                    flag("script / user info1")
                end,
                __pairs = function()
                    flag("script / user info2")
                end,
                __iter = function()
                    flag("script / user info3")
                end,
            }

            setRawMetatable(ScriptInformation, newMetatable)
            setRawMetatable(UserInformation, newMetatable)

            while true do
                if getMetaTable(ScriptInformation) ~= newMetatable or getMetaTable(UserInformation) ~= newMetatable then
                    flag("script info tamper")
                    break
                end
                taskWait(1)
            end
        end)
    },
    antiEnvLog = {
        thread = false,
        detection = function(flag)
            local passedCheck = false
            local jobId = game.JobId

            local service = (cloneRef(game:GetService("ChangeHistoryService")) )            
service:SetEnabled(true)

            service.OnRecordingStarted:Connect(function(name , displayName )
                if name == jobId and displayName == jobId:reverse() then
                    passedCheck = true
                else
                    flag("env log fail lol")
                end
            end)

            taskWait()

            service:TryBeginRecording(jobId, jobId:reverse())

            repeat taskWait() until passedCheck == true

            service:SetEnabled(false)
        end
    }
}

return ProtectionFlags end function __DARKLUA_BUNDLE_MODULES.T()
local WebhookManager = __DARKLUA_BUNDLE_MODULES.load('d')
local ProtectionFlags = __DARKLUA_BUNDLE_MODULES.load('S')

local PlayersService = cloneref(game:GetService("Players"))

local getRawMetatable = getrawmetatable
local setRawMetatable = setrawmetatable
local coroutineResume = coroutine.resume
local coroutineCreate = coroutine.create
local coroutineStatus = coroutine.status
local coroutineClose = coroutine.close
local coroutineWrap = coroutine.wrap
local sendWebhook = WebhookManager.send
local taskSpawn = task.spawn
local taskDelay = task.delay
local delFolder = delfolder
local taskWait = task.wait
local osClock = os.clock
local pcall = pcall

local ProtectionService = {
    _detectionFunctions = {}
} 
local detectionFunctions = ProtectionService._detectionFunctions

local detectionCount = 0
local isEnabled = nil 

function ProtectionService.init()
    isEnabled = 1
    if LPH_OBFUSCATED then
        sendWebhook({
            title = "New Execution",
            description = "A new execution was detected.",
            content = "",
        })
    end

    local addDetection = ProtectionService.addDetection
    local flag = ProtectionService.flag
    for _, detectionData in next, ProtectionFlags do
        local isThread = detectionData.thread
        local detection = detectionData.detection

        if not isThread then
            taskSpawn(detection, flag)
        else
            addDetection(detection)
        end
    end

    addDetection(LPH_JIT(function()
        while true do
            for i = 1, detectionCount do
                local thread = detectionFunctions[i]
                if not thread then
                    flag("coroutine fail " .. i)
                    break
                end
            end
            taskWait(1)
        end
    end))

    return ProtectionService
end

function ProtectionService.unload()    
isEnabled = nil
    for i = 1, detectionCount do
        local thread = detectionFunctions[i]
        pcall(coroutineClose, thread)
        detectionFunctions[i] = nil
    end
end

function ProtectionService.flag(flagData)    
if not isEnabled then 
        return 
    end

    if LPH_OBFUSCATED then
        xpcall(function()
            sendWebhook({
                title = "Protection Flagged",
                content = "@everyone",
                description = "A protection flag was triggered: " .. flagData
            })

            pcall(delFolder, "juju")
            
            taskDelay(0.1, function()
                LPH_CRASH()
            end)
        end, function()
            LPH_CRASH()
        end)
    else
        warn("Protection flagged: " .. flagData)
    end
end

function ProtectionService.addDetection(detectionFunction)    
local thread = coroutineCreate(function()
        detectionFunction(ProtectionService.flag)
    end)

    coroutineResume(thread)
    detectionFunctions[#detectionFunctions + 1] = thread
    detectionCount+=1
end

return ProtectionService end function __DARKLUA_BUNDLE_MODULES.U()
local ProtectionService = __DARKLUA_BUNDLE_MODULES.load('T')
local KeybindService = __DARKLUA_BUNDLE_MODULES.load('M')
local Menu = __DARKLUA_BUNDLE_MODULES.load('R')

local String = __DARKLUA_BUNDLE_MODULES.load('f')

local xpcall = xpcall
local getGenv = getgenv
local getReg = getreg

local SecureLoadUnload = {
    _regKey = nil 
}

function SecureLoadUnload.init()
    local genv = getGenv()
    local reg = getReg()
    local key = genv.juju

    if key then
        local unload = reg[key]

        if unload then
            unload()
            reg[key] = nil
        end
    end

    local regKey = (String.randomString(16) )    
SecureLoadUnload._regKey = regKey

    genv.juju = regKey
    reg[regKey] = SecureLoadUnload.unload

    
end

function SecureLoadUnload.unload()
    xpcall(function()
__DARKLUA_BUNDLE_MODULES.load('q')
.unload()
        ProtectionService.unload()
        KeybindService.unload()
        Menu.unload()
    end, function(err)
        if LPH_OBFUSCATED then
            LPH_CRASH()
            return
        end

        warn("Failed to stop " .. tostring(err))
    end)
end

return SecureLoadUnload end function __DARKLUA_BUNDLE_MODULES.V()
local PlayersService = cloneref(game:GetService("Players"))

local localPlayer = cloneref(PlayersService.LocalPlayer)
local kick = localPlayer.Kick

local LoggerService = {}

function LoggerService.criticalError(message)
    local baseMessage = "[Juju]\n\n"
    local errorMessage = baseMessage .. "CRITICAL ERROR:\n" .. message

    if LPH_OBFUSCATED then
        kick(localPlayer, errorMessage)
        return
    end

    warn(errorMessage)
end

return LoggerService end function __DARKLUA_BUNDLE_MODULES.W()
local AssetsConfig = {
    downloadUrl = "https://raw.githubusercontent.com/penguin-3/file-manager/refs/heads/main/",
    folder = "Juju",
    subfolders = {
        Assets = {
            Images = {
                "Sunrise.png",
                "Scope.png",
                "Glow.png",
                "Target.png",
                "Globe.png",
                "Dropdown.png",
            },
            Sounds = {},
            Fonts = {
                "Menu-Semibold.ttf",
                "Menu-Bold.ttf"
            }
        },
        Configs = {},
    },
}

return AssetsConfig end function __DARKLUA_BUNDLE_MODULES.X()
local AssetsManager = __DARKLUA_BUNDLE_MODULES.load('h')
local AssetsConfig = __DARKLUA_BUNDLE_MODULES.load('W')

local downloadFromUrl = AssetsManager.downloadFromUrl
local loadFile = AssetsManager.loadFile

local taskSpawn = task.spawn
local makeFolder = makefolder
local isFolder = isfolder
local isFile = isfile
local type = type

local AssetService = {}

function AssetService.init()     
local didAssetsFail = false

    local folder = AssetsConfig.folder

    if not isFolder(folder) then
        makeFolder(folder)
    end

    local subfolders = AssetsConfig.subfolders
    local downloadUrl = AssetsConfig.downloadUrl

    local recursiveCreateFiles
    
    recursiveCreateFiles = function(currentPath , data )
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

return AssetService end function __DARKLUA_BUNDLE_MODULES.Y()
if not LPH_OBFUSCATED then
    local env = getfenv()
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_CRASH = function() warn('crash') end
    LPH_OBFUSCATED = false
    LPH_NO_VIRTUALIZE = function(...) return ... end
end

local SecureLoadUnload = __DARKLUA_BUNDLE_MODULES.load('U')
local LoggerService = __DARKLUA_BUNDLE_MODULES.load('V')
local AssetsService = __DARKLUA_BUNDLE_MODULES.load('X')
local Menu = __DARKLUA_BUNDLE_MODULES.load('R')

local xpcall = xpcall

local Loader = {}

function Loader.init(data)
    local menuConfig = data.menuConfig

    xpcall(function()
        SecureLoadUnload.init()
        
        local didAssetsFail = AssetsService.init()

        if didAssetsFail then
            LoggerService.criticalError("Failed to download critical assets.")
            return
        end

        Menu.init(menuConfig)
    end, function(err)
        if LPH_OBFUSCATED then
            LPH_CRASH()
            return
        end

        warn("Failed to initialize " .. tostring(err))
    end)
end

return Loader end end
local MenuConfig = __DARKLUA_BUNDLE_MODULES.load('a')

local Loader = __DARKLUA_BUNDLE_MODULES.load('Y')

Loader.init({
    menuConfig = MenuConfig,
})