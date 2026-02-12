repeat task["wait"]() until game:IsLoaded()

if identifyexecutor() == "AWP" then
    cleardrawcache()
end

-- > ( luraph variables )

if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...) return ... end
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_ENCSTR = function(...) return ... end
    LPH_NO_UPVALUES = function(...) return ... end
    LPH_JIT = function(...) return ... end
end

-- > ( bypass )

LPH_JIT_MAX(function()
    if not getgenv().done then
        local reg = getreg()

        local callbacks = {}

        for _, connection in getconnections(game:GetService("ScriptContext")["Error"]) do
            local callback = connection["Function"]
            if callback then
                callbacks[#callbacks + 1] = callback
            end
        end

        for _, connection in getconnections(game:GetService("LogService")["MessageOut"]) do
            local callback = connection["Function"]
            if callback then
                callbacks[#callbacks + 1] = callback
            end
        end

        for _, v in reg do
            if typeof(v) == "function" and islclosure(v) then
                for i = 1, #callbacks do
                    if callbacks[i] == v then
                        reg[_] = function() end
                        break
                    end
                end
            end
        end

        getgenv().done = true
    end
end)()

-- > ( global cheat variables )

local user_input_service = cloneref(game:GetService("UserInputService"))
    local get_mouse_location = user_input_service["GetMouseLocation"]
local players_service = cloneref(game:GetService("Players"))
    local local_player = players_service["LocalPlayer"]
        local mouse = local_player:GetMouse()
local tween_service = cloneref(game:GetService("TweenService"))
    local get_value = tween_service["GetValue"]
local http_service = cloneref(game:GetService("HttpService"))
local workspace = workspace
    local camera = cloneref(workspace["CurrentCamera"])
local hui = cloneref(gethui())

local color3_fromrgb = Color3["fromRGB"]
    local color3_lerp = color3_fromrgb()["Lerp"]
local vector2_new = Vector2["new"]
local udim2_new = UDim2["new"]

local math_random = math["random"]
local clock = os["clock"]
local delay = task["delay"]
local spawn = task["spawn"]
local clamp = math["clamp"]
local floor = math["floor"]
local wait = task["wait"]
local sqrt = math["sqrt"]
local type = type

local shadow_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAQAAABpN6lAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAHdElNRQfiAQkTIxqKm+UhAAACvElEQVR42u2dzY7aMBhFjxPHEzJQBolRq77/27XSwBCSkD/PwinS7LpBVwrfeYLjI4Ozuy6Cw+HIyHBkOMCxTiIQmYnMzEQi0S9Hz/EUePIlxDpJB58YGRiZmJlTgIKCQMkLYYmwTtLhe2509AwM6QbkFJRUbKnYEChWHGCgp6WhpoF0AzI8gYodB/bs2BDI1aYPYqKn5cIZR7oPkyejoGTLgZ+888aOEq82fRAjHRdOlEBkZGTwODwvVOx55zdH9rxSqE0fxMCVMxXQ0dHS4TwZOYENO9448osDW4La9EH01GyAhhOfBHKy9Ar4JcGeA0d2Kw5QAu3yT+fJcB7IyJdn8JUtO36sOAB0vFISKNJz7+9fgelTKBAIlGrThxEI3z743Fpf/P/GAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0nfpsi7enp1VIPI53uPriaVmfT9ORAT8eVmhJWvDZ3oea6TK5OzOkGzIz3Lc4N0K04QM0HZy609IzMRM98nyI9UQHt6ic3/3JaEkzMnsjIjYYzJdA8xejqH8403BjTDRjoqHFAx+lJZnc/qOkYmP3yD9AAkY7PJxpe7hnTT2BiAGZG2ieb3p6ILj75+LqL4O7Dq245/HoDpAjx32cQ8QtpRORenSWX2AAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAAASUVORK5CYII=")
local pixel_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAA8nYBAOgDAADydgEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAACOO8FX0xe8TgAAAAxJREFUGFdj+P//PwAF/gL+pzWBhAAAAABJRU5ErkJggg==")
local exponential = Enum["EasingStyle"]["Exponential"]
local circular = Enum["EasingStyle"]["Circular"]
local quad = Enum["EasingStyle"]["Quad"]

local show_transparency = {Transparency = 1}
local hide_transparency = {Transparency = 0}
local menu_references = {}

local out = Enum["EasingDirection"]["Out"]

local connections = {}
local addon_data = {}
local heartbeat = {}
local flags = {
    ["keybinds_position"] = {15, camera["ViewportSize"]["Y"]/2 - 10},
    ["loaded_addons"] = {},
    ["favorites"] = {}
}

-- > ( global cheat functions )

local create_connection = LPH_NO_VIRTUALIZE(function(signal, callback)
    local connection = signal:Connect(callback)
    connections[#connections + 1] = connection

    return connection
end)

local create_instance = LPH_NO_VIRTUALIZE(function(class, properties)
    local instance = Instance["new"](class)

    for property, value in properties do
        instance[property] = value
    end

    return instance
end)

local round = LPH_NO_VIRTUALIZE(function(num, decimals)
    local mult = 10^(decimals or 0)
    return floor(num * mult + 0.5 - (num < 0 and 1 or 0)) / mult
end)

local remove = LPH_NO_VIRTUALIZE(function(tbl, index)
    local length = #tbl
    for i = index, length - 1 do
        tbl[i] = tbl[i + 1]
    end
    tbl[length] = nil
end)

-- > ( signal library )

local signal = {}

do
    -- > ( connection class)

    local connection = {}

    connection["__index"] = connection

    function connection.new(signal, callback)
        local callbacks = signal["callbacks"]
        callbacks[#callbacks+1] = callback

        return setmetatable({
            callback = callback,
            signal = signal
        }, connection)
    end

    function connection:Disconnect()
        local callbacks = self["signal"]["callbacks"]
        local callback = self["callback"]

        for i = 1, #callbacks do
            if callbacks[i] == callback then
                remove(callbacks, i)

                break
            end
        end
    end

    -- > ( signal class )

    signal["__index"] = signal

    signal.new = LPH_JIT_MAX(function()
        return setmetatable({
            callbacks = {}
        }, signal)
    end)

    function signal:Fire(...)
        local callbacks = self["callbacks"]
        for i = 1, #callbacks do
            spawn(callbacks[i], ...)
        end
    end

    function signal:Connect(callback)
        return connection["new"](self, callback)
    end
end

-- > ( tween library )

local active_tweens = {
    Color = {},
    Color3 = {},
    Size = {},
    tween_position = {},
    Position = {},
    tween_size = {},
    Transparency = {},
    FillTransparency = {},
    OutlineTransparency = {},
    BackgroundTransparency = {},
    ImageTransparency = {},
    FillColor = {},
    OutlineColor = {},
    [11] = {},
    [15] = {}
}

local tween = nil 
do
    local sqrt = math["sqrt"]
 
    tween = LPH_NO_VIRTUALIZE(function(object, properties, easing_style, _, tween_duration)
        local start_time = clock()

        local tween_functions = {}

        for property, value in properties do
            local tweens = active_tweens[property]
            local old_tween = tweens[object]

            if old_tween then
                for i = 1, #heartbeat do
                    if heartbeat[i] == old_tween then
                        remove(heartbeat, i)
                        break
                    end
                end
            end

            local old_value = object[property]

            if property == "Color" or property == "Color3" or property == "FillColor" or property == "OutlineColor" then
                tween_functions[property] = function()
                    local t = ((clock() - start_time)/tween_duration)
                    object[property] = color3_lerp(old_value, value, easing_style == exponential and (t == 1 and 1 or 1 - 2 ^ (-10 * t)) or easing_style == quad and t^2 or sqrt(1 - (t - 1) ^ 2)) or easing_style == "sine" and t < 0.5 and 0.5 * math.sin(clamp(t, 0, 1) * 355/113) or 0.5 + 0.5 * (1 - math.cos((clamp(t, 0, 1) - 0.5) * 355/113))
                end
            elseif property == "tween_position" or property == "tween_size" then
                tween_functions[property] = function()
                    local t = ((clock() - start_time)/tween_duration)
                    local tween_value = easing_style == exponential and (t == 1 and 1 or 1 - 2 ^ (-10 * t)) or easing_style == quad and t^2 or sqrt(1 - (t - 1) ^ 2)

                    local new = (value - old_value)
                    new = udim2_new(new["X"]["Scale"] * tween_value, new["X"]["Offset"] * tween_value, new["Y"]["Scale"] * tween_value, new["Y"]["Offset"] * tween_value)

                    object[property] = old_value + new
                end
            else
                tween_functions[property] = function()
                    local t = ((clock() - start_time)/tween_duration)

                    object[property] = old_value + (value - old_value) * (easing_style == exponential and (t == 1 and 1 or 1 - 2 ^ (-10 * t)) or easing_style == quad and t^2 or sqrt(1 - (t - 1) ^ 2))
                end
            end
        end

        for property, tween in tween_functions do
            heartbeat[#heartbeat+1] = tween
            active_tweens[property][object] = tween
        end

        delay(tween_duration, function()
            for property, tween in tween_functions do
                for i = 1, #heartbeat do
                    if heartbeat[i] == tween then
                        remove(heartbeat, i)

                        object[property] = properties[property]
                        break
                    end
                end
            end
        end)
    end)
end

-- > ( menu )

-- > ( menu )

local menu = {
    on_config_loaded = signal["new"](),
    accent = color3_fromrgb(255, 213, 253),
    colors = {
        ["shadow"] = color3_fromrgb(154, 213, 222),
        ["accent"] = color3_fromrgb(154, 213, 222),
        ["active_text"] = color3_fromrgb(197, 197, 197),
        ["keybind_text"] = color3_fromrgb(197, 197, 197),
        ["border"] = color3_fromrgb(24, 25, 24),
        ["inactive_text"] = color3_fromrgb(75, 72, 72),
        ["highlighted"] = color3_fromrgb(51, 65, 70),
        ["dark_text"] = color3_fromrgb(70, 85, 87),
        ["image"] = color3_fromrgb(89, 89, 89),
        ["section"] = color3_fromrgb(6, 6, 6),
        ["background"] = color3_fromrgb(0, 0, 0),
        ["success"] = color3_fromrgb(154, 213, 222),
        ["error"] = color3_fromrgb(39, 60, 96),
        ["alert"] = color3_fromrgb(30, 51, 61),
        ["logo"] = color3_fromrgb(154, 213, 222),
        ["juju"] = color3_fromrgb(154, 213, 222),
        ["build"] = color3_fromrgb(154, 213, 222),
        ["cursor"] = color3_fromrgb(154, 213, 222),
    },
    settings = {},
    notifications = {},
    groups = {},
    favorites = {},
    autoload = nil,
    initial_base_offset = 75,
    ordered_groups = {},
    theme = ""
}

do
    -- > ( file system )

    do
        local files = {
            ["assets"] = {
                ["api.lua"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/api.lua") end,
                ["sparkle.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/sparkle.ogg") end,
                ["skeet.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/skeet.ogg") end,
                ["neverlose.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/neverlose.ogg") end,
                ["break.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/break.ogg") end,
                ["mc bow.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/mc%20bow.ogg") end,
                ["primordial.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/primordial.ogg") end,
                ["rust.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/rust.ogg") end,
                ["sexy.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/sexy.ogg") end,
                ["jaydes.png"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/jaydes.png") end,
                ["1.png"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/1.png") end,
                ["2.png"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/2.png") end,
                ["logo.png"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/logo.png") end,
                ["saturation.png"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/saturation.png") end,
            },
            ["custom"] = {
                ["textures.json"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/example.textures") end,
                ["character.rbxm"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/character.rbxm") end,
                ["pinksky.rbxm"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/pinksky.rbxm") end,
                ["crunch.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/juju.ogg") end,
                ["scar.ogg"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/scar.ogg") end,
                ["x hit.rbxm"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/x%20hit.rbxm") end,
                ["blossom aura.rbxm"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/blossom%20aura.rbxm") end,
                ["spam.json"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/spam.json") end,
            },
            ["themes"] = {
                ["default.th"] = function() return game:HttpGet("https://github.com/xander-999/juju/raw/refs/heads/main/default.th") end,
            },
            ["addons"] = {},
            ["configs"] = {},
            ["data.dat"] = [[{"notifications":true,"theme":"","favorites":[]}]]
        }

        if not isfolder("juju recode") then
            makefolder("juju recode")
        end

        local recursive_check

        recursive_check = function(path, array)
            for file, data in array do
                local path = path..file
                local data_type = type(data)

                if data_type == "table" then
                    if not isfolder(path) then
                        makefolder(path)
                    end
                    recursive_check(path.."/", data)
                elseif not isfile(path) then
                    writefile(path, type(data) == "function" and data() or data)
                end
            end
        end

        recursive_check("juju recode/", files)
    end

    -- > ( custom drawing )

    local drawing = Drawing
    LPH_NO_VIRTUALIZE(function()
        drawing = _G.FORCE_REAL_DRAWING and Drawing or loadstring(readfile("juju recode/assets/api.lua"))()
    end)()

    getgenv()["fake_drawing"] = drawing

    -- > ( global menu variables )

    local context_action_service = cloneref(game:GetService("ContextActionService"))
        local context_action_click = tostring({}):sub(math_random(8,12))
        local context_action_scroll = tostring({}):sub(math_random(8,12))
        local context_action_typing = tostring({}):sub(math_random(8,12))
        local context_action_typing_core = tostring({}):sub(math_random(8,12))

    local shortened_characters = {
		[Enum.KeyCode.LeftShift] = "lshift",
		[Enum.KeyCode.RightShift] = "rshift",
		[Enum.UserInputType.MouseButton1] = "m1",
		[Enum.UserInputType.MouseButton2] = "m2",
		[Enum.UserInputType.MouseButton3] = "m3",
		[Enum.KeyCode.ButtonX] = "xb",
		[Enum.KeyCode.ButtonY] = "yb",
		[Enum.KeyCode.ButtonA] = "ab",
		[Enum.KeyCode.ButtonB] = "bb",
		[Enum.KeyCode.ButtonR1] = "r1",
		[Enum.KeyCode.ButtonR2] = "r2",
		[Enum.KeyCode.ButtonR1] = "l1",
		[Enum.KeyCode.ButtonR2] = "l2",
		[Enum.KeyCode.DPadLeft] = "dpl",
		[Enum.KeyCode.DPadRight] = "dpr",
		[Enum.KeyCode.DPadUp] = "dpup",
		[Enum.KeyCode.DPadDown] = "dpdn",
		[Enum.KeyCode.Thumbstick1] = "ts1",
		[Enum.KeyCode.Thumbstick2] = "ts2",
		[Enum.KeyCode.Delete] = "delete",
		[Enum.KeyCode.Insert] = "insert",
		[Enum.KeyCode.PageUp] = "pgup",
		[Enum.KeyCode.PageDown] = "pgdw",
		[Enum.KeyCode.LeftControl] = "lctrl",
		[Enum.KeyCode.RightControl] = "rctrl",
		[Enum.KeyCode.RightAlt] = "ralt",
		[Enum.KeyCode.LeftAlt] = "lalt",
		[Enum.KeyCode.CapsLock] = "caps",
		[Enum.KeyCode.ScrollLock] = "slock",
		[Enum.KeyCode.Backspace] = "bspace",
		[Enum.KeyCode.Space] = "space",
        [Enum.KeyCode.Backquote] = "bqte",
        [Enum.KeyCode.BackSlash] = "bsls",
	}

    local on_keybind_created = signal["new"]()
    local on_keybind_deleted = signal["new"]()
    local on_keybind_updated = signal["new"]()
    local on_keybind_change = signal["new"]()
    local transparency_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAABkAAAAMBAMAAABl3At4AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///8rKyoNe1IIAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAABdJREFUGNNjYBBEgmg8ZI4AGo+u+hgEAKy7BSkQOa/KAAAAAElFTkSuQmCC")
    local checkmark_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAEFJREFUKFOFj0EOACEIxMD//3ncTsSDYbUXDFMhpKS4MVbt4Kf+BI/Nj07YIesRPIpm1QoBIf1qQqgVls4QHmdGTFexGgt5dAJMAAAAAElFTkSuQmCC")
    local config_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAFFJREFUKFOdz8ERwCAIBEC0x6QmuzYcORlkhofuB0VEbKKmQoya4tJ0xuzNl6tC64hiNZj6n04eHvlY5YyRz4tCsE3A9FnH7TNILEy5u441kQ8rkEMeEE8J7QAAAABJRU5ErkJggg==")
    local button_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAAMdwEA6AMAAAx3AQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAO7qLRjGzAACAAAAK0lEQVQYVz3KQRIAAAQCwPr/p5WiQ9YAfkDcZiph7HnUucyD3V/RWqbaCjkOewBGmBH+OgAAAABJRU5ErkJggg==")
    local arrow_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAA8nYBAOgDAADydgEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAACOO8FX0xe8TgAAABdJREFUKFNj/A8EDHgAE5QmHwwBKxgYAJzaC/5K6BlzAAAAAElFTkSuQmCC")
    local cog_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAQKAAAECgBJz8A6wAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAB3mgEA6AMAAHeaAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAEyPNqYn0aVIAAAALElEQVQYV2NgBAIGCAmioQhIQACQCZaGYBAJoZGYSApgUhATYAiikJGRkREACr4AMZ+SUSoAAAAASUVORK5CYII=")
    local menu_position = udim2_new(0, camera["ViewportSize"]["X"]/2 - 575/2, 0, camera["ViewportSize"]["Y"]/2 - 450*0.5)

    local half_transparency = {Transparency = 0.5}
    local stop_panel_search = nil
    local do_notifications = true
    local set_active_tab = nil
    local theme_section = nil
    local close_context = nil
    local menu_open = true
    local menu_tick = clock()
    local pop_menu = nil
    local old_text = ""
    local searching = nil
    local hud_frames = {}

    local actives = {
        ["colorpicker"] = nil,
        ["dropdown"] = nil,
        ["settings"] = nil,
        ["binding"] = nil,
        ["keybind"] = nil,
        ["context"] = nil,
        ["panel"] = nil,
        ["tab"] = nil,
        ["colorpicker_saturation"] = 0,
        ["colorpicker_hue"] = 0,
        ["colorpicker_value"] = 0
    }

    -- > ( drawing proxy )

    local drawing_proxy = {}
    local create1 = identifyexecutor() == "AWP" and Drawing["new"] or drawing["new"]

    drawing_proxy.new = identifyexecutor() == "AWP" and LPH_NO_VIRTUALIZE(function(class, properties)
        local object = create1(class)

        local proxy = setmetatable({
            ["position"] = udim2_new(0, 0, 0, 0),
            ["real_position"] = vector2_new(0, 0),
            ["size"] = class == "Text" and 12 or udim2_new(0, 0, 0, 0),
            ["real_size"] = class == "Text" and 12 or vector2_new(0, 0),
            ["object"] = object,
            ["children"] = {},
            ["parent"] = false,
            ["is_rendering"] = false,
            ["skip"] = class == "Circle",
            ["visible"] = false,
            ["destroy"] = function()
                object:Destroy()
            end
        }, drawing_proxy)

        local size = properties["Size"]
        if size and type(size) == "number" then
            properties["Size"] = size+2
        end

        local z_index = properties["ZIndex"]
        properties["ZIndex"] = z_index and z_index+20 or 20

        for property, value in properties do
            proxy[property] = value
        end

        return proxy
    end) or LPH_NO_VIRTUALIZE(function(class, properties)
        local object = create1(class)

        local proxy = setmetatable({
            ["position"] = udim2_new(0, 0, 0, 0),
            ["real_position"] = vector2_new(0, 0),
            ["size"] = class == "Text" and 12 or udim2_new(0, 0, 0, 0),
            ["real_size"] = class == "Text" and 12 or vector2_new(0, 0),
            ["object"] = object,
            ["children"] = {},
            ["parent"] = false,
            ["is_rendering"] = false,
            ["skip"] = class == "Circle",
            ["visible"] = false,
            ["destroy"] = function()
                object:Destroy()
            end
        }, drawing_proxy)

        local z_index = properties["ZIndex"]
        properties["ZIndex"] = z_index and z_index+20 or 20

        for property, value in properties do
            proxy[property] = value
        end

        return proxy
    end)

    getgenv()["_PROXY"] = drawing_proxy
    menu["create_proxy_drawing"] = drawing_proxy["new"]

    do
        local rawget = rawget
        local type = type

        local update_proxy_position
        update_proxy_position = LPH_NO_VIRTUALIZE(function(proxy, position)
            local parent = rawget(proxy, "parent")
            local real_position = parent and parent["real_position"] or vector2_new(position["X"]["Offset"], position["Y"]["Offset"])

            if parent then
                local parent_position = parent["real_position"]
                local real_parent_size = parent["real_size"]

                real_position = vector2_new((parent_position["X"] + real_parent_size["X"] * position["X"]["Scale"]) + position["X"]["Offset"], (parent_position["Y"] + real_parent_size["Y"] * position["Y"]["Scale"]) + position["Y"]["Offset"])
            end

            proxy["object"]["Position"] = real_position
            proxy["real_position"] = real_position

            local children = proxy["children"]
            for i = 1, #children do
                local child = children[i]
                update_proxy_position(child, child["position"])
            end
        end)

        local update_proxy_visibility
        update_proxy_visibility = LPH_NO_VIRTUALIZE(function(proxy, visible)
            local children = proxy["children"]
            local parent = rawget(proxy, "parent")
            local object = proxy["object"]

            if parent and not parent["is_rendering"] then
                proxy["is_rendering"] = false
                object["Visible"] = false
            else
                object["Visible"] = visible
                proxy["is_rendering"] = visible
            end

            for i = 1, #children do
                local child = children[i]
                update_proxy_visibility(child, child["visible"])
            end
        end)

        local update_proxy_size
        update_proxy_size = LPH_NO_VIRTUALIZE(function(proxy, size)
            if type(proxy) ~= "table" or type(proxy["real_size"]) == "number" then -- ??
                return
            end

            local parent = rawget(proxy, "parent")
            local real_size = parent and parent["real_size"] or vector2_new(size["X"]["Offset"], size["Y"]["Offset"])

            if parent then
                local parent_size = parent["real_size"]

                real_size = vector2_new((parent_size["X"] * size["X"]["Scale"]) + size["X"]["Offset"], (parent_size["Y"] * size["Y"]["Scale"]) + size["Y"]["Offset"])
            end

            proxy["object"]["Size"] = real_size
            proxy["real_size"] = real_size

            local children = proxy["children"]
            for i = 1, #children do
                local child = children[i]
                local old = child["real_size"]
                update_proxy_size(child, child["size"])
                
                update_proxy_position(child, child["position"])

            end
        end)

        function drawing_proxy:__newindex(property, value)
            if property == "Position" or property == "tween_position" then
                self["position"] = value
                update_proxy_position(self, value)
            elseif property == "Parent" then
                if value then
                    local children = value["children"]
                    children[#children+1] = self
                end

                self["parent"] = value
                update_proxy_position(self, self["position"])
                update_proxy_visibility(self, self["visible"])

                if type(self["size"]) ~= "number" and not self["skip"] then
                    update_proxy_size(self, self["size"])
                end
            elseif property == "Visible" then
                self["visible"] = value
                update_proxy_visibility(self, value)
            elseif (property == "Size" or property == "tween_size") and type(value) ~= "number" and not self["skip"] then
                self["size"] = value
                update_proxy_size(self, value)
            else
                self["object"][property] = value
            end
        end

        function drawing_proxy:__index(property)
            return property == "tween_size" and self["size"] or property == "tween_position" and self["position"] or property == "Destroy" and self["destroy"] or self["object"][property]
        end
    end

    -- > ( menu creation )

    local cursor = drawing_proxy["new"]("Image", {
        ["Position"] = menu_position,
        ["Size"] = udim2_new(0, 24, 0, 24),
        ["Color"] = menu["colors"]["cursor"],
        ["Rounding"] = 0,
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAACHUExURaWlpdTV1cDBwbq6uv///+Li4q6ursPDw9vc3Nna2sTExLCwsNPT09bW1tXV1bGxsdLT083OzrKyss/Pz7Ozs8jIyLS1tcbHx7W1tcnJybm5ufDw8JKSkpmZmaqrq6ipqaWmpqanp4aGhpqamszMzMLCwuLh4Xx8fL29vfHw8Hl5eY+OjgAAAAqocEsAAAAtdFJOU///////////////////////////////////////////////////////////AKXvC/0AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuNBLfpoMAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuNAADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADX5rshveZftAAAALhJREFUOE/V0scWgjAQhWHUK2JX7L33vP/zmcilJRNd+6+Yme+w4BCoH2kQVKocpDSoAfWQo5sGDQCRVxCg6RMatAxA1ObGKgPoyCIHHlEA6EqiCNDrc1uoBDBwRRlgGHOfZQGMxjyk2QCTKS/MAZjNeUpyARY8JQmgLCSAJY8mCax4+5SD9WYbx+Fufyh/8AwcubBLwYmzkwbmjzr7XmDABbjeOLppcMfjyUlIA/VKHuUM+NofAKXelaSKsWMM5jMAAAAASUVORK5CYII="),
        ["Transparency"] = 0,
        ["ZIndex"] = 1011,
        ["Visible"] = true
    })

    local frame = drawing_proxy["new"]("Image", {
        ["Position"] = menu_position,
        ["Size"] = udim2_new(0, 575, 0, 450),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 1,
        ["Visible"] = false
    })

    local inside = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["section"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 1,
        ["Parent"] = frame,
        ["Visible"] = false
    })

    local logo = drawing_proxy["new"]("Image", {
        ["Color"] = menu["colors"]["accent"],
        ["Data"] = readfile("juju recode/assets/logo.png"),
        ["Position"] = udim2_new(0, 15, 0, 15),
        ["Parent"] = inside,
        ["Size"] = udim2_new(0, 35, 0, 35),
        ["Visible"] = true,
        ["Transparency"] = 1
    })

    local juju_text = drawing_proxy["new"]("Text", {
        ["Font"] = 1,
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Text"] = "juju",
        ["Parent"] = logo,
        ["Position"] = udim2_new(1, 5, 0, 3),
        ["Size"] = 14,
        ["Visible"] = true,
        ["Transparency"] = 1
    })

    local build_text = drawing_proxy["new"]("Text", {
        ["Font"] = 1,
        ["Color"] = menu["colors"]["accent"],
        ["Text"] = (LRM_ScriptName == "da hood" or LRM_ScriptName == "da hood copies") and "live" or "private",
        ["Parent"] = logo,
        ["Position"] = udim2_new(1, 5, 0, 19),
        ["Size"] = 14,
        ["Visible"] = true,
        ["Transparency"] = 1
    })

    local right_side = drawing_proxy["new"]("Square", {
        ["Parent"] = inside,
        ["Position"] = udim2_new(0, 101, 0, 0),
        ["Size"] = udim2_new(1, -101, 1, 0),
        ["Color"] = menu["colors"]["background"],
        ["Visible"] = true,
        ["Filled"] = true,
        ["Transparency"] = 1
    })

    local right_side_cover = drawing_proxy["new"]("Square", {
        ["Parent"] = inside,
        ["Position"] = udim2_new(0, 101, 0, 0),
        ["Size"] = udim2_new(1, -101, 1, 0),
        ["Color"] = menu["colors"]["background"],
        ["Visible"] = true,
        ["Filled"] = true,
        ["ZIndex"] = 999,
        ["Transparency"] = 0
    })

    local right_side_divider = drawing_proxy["new"]("Square", {
        ["Parent"] = inside,
        ["Position"] = udim2_new(0, 100, 0, 0),
        ["Size"] = udim2_new(0, 1, 1, 0),
        ["Color"] = menu["colors"]["background"],
        ["Visible"] = true,
        ["Thickness"] = 1,
        ["Filled"] = true,
        ["Transparency"] = 1
    })

    local search_image = drawing_proxy["new"]("Image", {
        ["Color"] = menu["colors"]["image"],
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAGdJREFUKFONkGEWgCAIg5GTdP9LlqPBA8Pq+yFuOvA5JHFOuDXGhNvAjPVipgtZAFAGtIuvbrSdRA4sJQQBKB/wOM6V9TevAe+cn6su8liwaieSuwuONy4/k0PdZHglsKOEWD+5QyIX+wJP/y1yP3IAAAAASUVORK5CYII="),
        ["Position"] = udim2_new(0, 27, 1, -27),
        ["Parent"] = inside,
        ["Size"] = udim2_new(0, 12, 0, 12),
        ["Transparency"] = 1,
        ["ZIndex"] = 999,
        ["Visible"] = true,
    })

    local themes_image = drawing_proxy["new"]("Image", {
        ["Color"] = menu["colors"]["image"],
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADdYAAA3WAZBveZwAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAiF8BAOgDAACIXwEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAAC1cWHl18YwawAAAH5JREFUKFOFkAsOgCAMQwE5lIfx/qeA4Do7ZCL6ErOWtHwMb7TWinyN1pE4Owxul5uJnAp2ljGFo0B5F1Zhw0p6JVxDfIZegQymtroRTK9wj0bYjl5QtTCGPkqHLGcXpFRQGtYqwhDuDU9YKhYGaQwjAGix0S7W/z0UAO0PIZyip02b2JexIAAAAABJRU5ErkJggg=="),
        ["Position"] = udim2_new(0, 44, 1, -27),
        ["Parent"] = inside,
        ["Size"] = udim2_new(0, 12, 0, 12),
        ["Transparency"] = 1,
        ["Visible"] = true,
    })

    local settings_image = drawing_proxy["new"]("Image", {
        ["Color"] = menu["colors"]["image"],
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAMAAABhq6zVAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAALEwAACxMBAJqcGAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAABJGQEA6AMAAEkZAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAC/Sb/YZ+v7JAAAAMklEQVQYV1WLARIAQAQC9f9Pn65oNAZpFajyUHn0MtJZWkbdt+QxBwtA47X1kzDk9QY8FowASc0mZqAAAAAASUVORK5CYII="),
        ["Position"] = udim2_new(0, 61, 1, -27),
        ["Parent"] = inside,
        ["Size"] = udim2_new(0, 12, 0, 12),
        ["Transparency"] = 1,
        ["Visible"] = true,
    })

    local tab_line = drawing_proxy["new"]("Square", {
        ["Parent"] = inside,
        ["Position"] = udim2_new(0, 0, 0, 0),
        ["Size"] = udim2_new(0, 1, 0, 12),
        ["Filled"] = true,
        ["Transparency"] = 0.5,
        ["Color"] = menu["colors"]["accent"],
        ["Visible"] = true,
    })

    local search_border = drawing_proxy["new"]("Image", {
        ["Parent"] = frame,
        ["Position"] = udim2_new(0, 11, 1, -32),
        ["Size"] = udim2_new(0, 78, 0, 20),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 1,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Visible"] = false,
    })

    local search_inside = drawing_proxy["new"]("Image", {
        ["Parent"] = search_border,
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 1,
        ["Visible"] = true,
    })

    local search_out_border = drawing_proxy["new"]("Image", {
        ["Parent"] = frame,
        ["Position"] = udim2_new(0, 11, 1, -57),
        ["Size"] = udim2_new(0, 78, 0, 20),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 1,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 999,
        ["Visible"] = false,
    })

    local search_out = drawing_proxy["new"]("Image", {
        ["Parent"] = search_out_border,
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 1,
        ["ZIndex"] = 1000,
        ["Visible"] = true,
    })

    local search_text = drawing_proxy["new"]("Text", {
        ["Color"] = menu["colors"]["active_text"],
        ["Text"] = "",
        ["Size"] = 12,
        ["Font"] = 1,
        ["Transparency"] = 1,
        ["Visible"] = true,
        ["Parent"] = search_inside,
        ["Center"] = false,
        ["Position"] = udim2_new(0, 18, 0, 2),
    })

    local drag_frame = drawing_proxy["new"]("Image", {
        ["Position"] = menu_position,
        ["Size"] = udim2_new(0, 575, 0, 450),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 0,
        ["ZIndex"] = 1000,
        ["Visible"] = false
    })

    local drag_inside = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["section"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 1,
        ["Parent"] = drag_frame,
        ["ZIndex"] = 1001,
        ["Visible"] = true
    })

    local drag_logo = drawing_proxy["new"]("Image", {
        ["Color"] = menu["colors"]["accent"],
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAACMAAAAjCAYAAAAe2bNZAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAA3JJREFUWEe92EtIVFEcx/HrIx9ZWvkoTSFLDJPQIBPShRRFSFCQQkVlkPSAViLUImgXgZsWtWpVG1fRQmgRBBEGUUFtWrQoqCjoSQ8qet6+v3PvmTkzXh9zm5kffHTunXHm3P953DMW+L7v5SFlWIu76MVTFOMbPuE3vEL9yEP0wc3BQ+8C9uE5+lCJAnj5qkwpenDDHKWmEa/g56syf6APTE8/PgcP89NNqkoNinBTJ8gwunAHX2G6J9fdpItdDo0PZRceQ1VSI34h0YBcV0YDd0Xw0ORK+Ftd8xMplchlYzRDKrDaHCWj7opMLhujD23ARXMUZARvoIotRAnMtFZy1RhbFS10brToaaFrgbqqFjlvjK3KuDkKoqo8w1Jc1wmiyiSSi8bYqnSYo2Qeohxa/NTQbXiP5CDW1M6yYqyBm9Poxn5z5PsHUI9CJP4225WZripaV3TuMq7hNt7iL5JxW5YFUVWZxJngoX8cer4EU/5+yon/oNW8CnsQFZ1fiVJE/X1WbgfqGs2e+WjFPaRnEx7hA8zeJSpxG6MGaLxpalahCW24BDcDuI/X+IEZPyzTxqgBWj0XoA7aMKka55Ae3ZknoOmrLcTssf01C03BcjRgI4aRnvHwt806zEPU+0WKPOlQ5crQhM04BTdXsQP95iiZI6iGqfxcRZ4MaZrWoBdjcHMMPWhELQbgZj0ip+9MIk9C5dU01Erp5ii6oAZoiqrBzXCjhur5jKoiUSd1Ra0Yhc1ZqEJ10PP2gyqwHW42IOOqSPoJXekqjMBGi5WuXmPHvdoitMDNYahrM66KuAd6A5X3IGy2QANRH5z+Wq22g3DTiYxmkMs90JtoPNj0oRIpd9aQXtsBN7uxCLGqIu5dW19B7be+vdD+4wtS76zBwlcNfU210eZaK61ezyXGi22Mlnc1ptsced4DRL2xXqd7UCfO60SYrXiJua200yUskUqrzY4yBA3ClBKGNIg1W9xo+i9G7O6x3G6yVdA5URXc6KaobjxpjoKM4ha0uY7dPYk4LdPVaRAq7dA013ldsRa49LVnAm2ItaZEcSvzHS+Ch2ZM1EPfbZagHTsxBuUEVCH9n0WDNysx/RxGDdO2QP8z0VcMbQHeQfsVd58yhElowGqPkrW4jVG0V1kGffnSxtnNIWi39gQfMe2OLV487x+AjByM3j95+QAAAABJRU5ErkJggg=="),
        ["Position"] = udim2_new(0.5, -20, 0.5, -20),
        ["Parent"] = drag_inside,
        ["Size"] = udim2_new(0, 40, 0, 40),
        ["Visible"] = true,
        ["ZIndex"] = 1002,
        ["Transparency"] = 1
    })

    -- > ( keybinds )

    local keybind_data = {
        [1] = {
            ["key"] = Enum["KeyCode"]["Delete"],
            ["value"] = true,
            ["original_value"] = false,
            ["set_activated"] = LPH_NO_VIRTUALIZE(function()
                pop_menu()
            end)
        }
    }

    local keybind = {}
    keybind["__index"] = keybind

    function keybind:set_activated(activated)
        local new_value = activated and self["value"] or (not activated and self["original_value"])
        local element = self["element"]
        local type = self["type"]

        if type == 1 then
            element:set_dropdown(new_value, true)
        elseif type == 2 then
            element:set_slider(new_value, true)
        elseif type == 3 then
            element:set_toggle(activated, true)
        elseif type == 4 then
            return element["on_clicked"]:Fire()
        end

        self["activated"] = activated

        on_keybind_change:Fire(self, element, activated)
    end

    -- > ( keybinds list )

    local list_frame = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 15, 0, camera["ViewportSize"]["Y"]/2 - 10),
        ["Size"] = udim2_new(0, 74, 0, 20),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 0,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 10,
        ["Visible"] = false,
    })

    hud_frames["keybinds_position"] = list_frame

    local list_shadow = drawing_proxy["new"]("Image", {
        ["Parent"] = list_frame,
        ["Data"] = shadow_image_data,
        ["Rounding"] = 7,
        ["Color"] = menu["colors"]["shadow"],
        ["Transparency"] = 0,
        ["Size"] = udim2_new(1, 6, 1, 4),
        ["ZIndex"] = 9,
        ["Visible"] = true,
        ["Position"] = udim2_new(0, -3, 0, -2)
    })

    local list_inside = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(0, 72, 0, 18),
        ["Color"] = color3_fromrgb(15, 15, 15),
        ["Transparency"] = 0,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Parent"] = list_frame,
        ["ZIndex"] = 11,
        ["Visible"] = true,
    })

    local list_icon = drawing_proxy["new"]("Image", {
        ["Color"] = menu["colors"]["accent"],
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOwwAADsMBx2+oZAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAABgAAAAAQAAAGAAAAABAAAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAOnV9jjK2mx6AAAAKklEQVQYV2NghANkJhCAKCgGUUAazIUCiBiIAVEAFoLwIQgsCgZwJiMjABBLAEmFjHpsAAAAAElFTkSuQmCC"),
        ["Transparency"] = 0,
        ["Position"] = udim2_new(0, 4, 0, 4),
        ["Parent"] = list_inside,
        ["Size"] = udim2_new(0, 10, 0, 10),
        ["ZIndex"] = 12,
        ["Visible"] = true,
    })

    local list_divider = drawing_proxy["new"]("Square", {
        ["Position"] = udim2_new(0, 20, 0, 4),
        ["Size"] = udim2_new(0, 1, 0, 10),
        ["Color"] = menu["colors"]["accent"],
        ["Transparency"] = 0,
        ["Filled"] = true,
        ["Parent"] = list_inside,
        ["ZIndex"] = 12,
        ["Visible"] = true,
    })

    local list_text = drawing_proxy["new"]("Text", {
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Text"] = "hotkeys",
        ["Size"] = 12,
        ["Font"] = 1,
        ["Transparency"] = 0,
        ["Visible"] = true,
        ["Parent"] = list_inside,
        ["Position"] = udim2_new(0, 26, 0, identifyexecutor() == "AWP" and 2 or 3),
        ["ZIndex"] = 12,
    })

    local list_drawings = {}
    local active_binds = {}

    menu["show_bind"] = function(keybind, just_visual)
        local found = nil

        for i = 1, #active_binds do
            local bind = active_binds[i]
            if bind == keybind then
                found = i
                break
            end
        end

        if not just_visual then
            if not found then
                active_binds[#active_binds+1] = keybind
                found = #active_binds
            end
        end

        local drawings = list_drawings[keybind]
        local frame = drawings["frame"]
        local y = 24 + (found - 1)*21

        frame["Position"] = udim2_new(0, -5, 0, y)
        tween(frame, {Transparency = 0 or 0.2, tween_position = udim2_new(0, 0, 0, y)}, circular, out, 0.15)
        tween(drawings["inside"], {Transparency = 0.7}, circular, out, 0.15)
        tween(drawings["text"], {Transparency = 0.9}, circular, out, 0.15)
        tween(drawings["value"], {Transparency = 0.7}, circular, out, 0.15)
        tween(drawings["shadow"], {Transparency = 0.16}, circular, out, 0.15)
        frame["Visible"] = true
    end

    menu["get_active_binds"] = LPH_NO_VIRTUALIZE(function()
        return active_binds
    end)
    
    local create_hover_connection = nil

    menu["hide_bind"] = function(keybind, just_visual)
        if not just_visual then
            for i = 1, #active_binds do
                if active_binds[i] == keybind then
                    remove(active_binds, i)
                    break
                end
            end

            for i = 1, #active_binds do
                local frame = list_drawings[active_binds[i]]["frame"]
                local old_position = frame["tween_position"]
                local new_position = udim2_new(0, 0, 0, 24 + (i - 1)*21)

                if old_position ~= new_position then
                    tween(frame, {tween_position = new_position}, circular, out, 0.15)
                end
            end
        end

        local drawings = list_drawings[keybind]

        if drawings then
            local frame = drawings["frame"]

            tween(drawings["frame"], {Transparency = 0, tween_position = frame["tween_position"] - udim2_new(0, 5, 0, 0)}, circular, out, 0.15)
            tween(drawings["inside"], hide_transparency, circular, out, 0.15)
            tween(drawings["text"], hide_transparency, circular, out, 0.15)
            tween(drawings["value"], hide_transparency, circular, out, 0.15)
            tween(drawings["shadow"], hide_transparency, circular, out, 0.15)

            delay(0.15, function()
                local found = nil

                if not just_visual then
                    for i = 1, #active_binds do
                        local bind = active_binds[i]
                        if bind == keybind then
                            found = i
                            break
                        end
                    end
                end

                if not found then
                    frame["Visible"] = false
                end
            end)
        end
    end

    function menu:show_keybinds()
        list_frame["Visible"] = true
        tween(list_frame, {Transparency = 0.7}, circular, out, 0.15)
        tween(list_inside, show_transparency, circular, out, 0.15)
        tween(list_shadow, {Transparency = 0.16}, circular, out, 0.15)
        local children = list_inside["children"]
        for i = 1, #children do
            local child = children[i]
            if child["Visible"] then
                tween(child, child == list_text and show_transparency or half_transparency, circular, out, 0.15)
            end
        end

        for i = 1, #active_binds do
            menu["show_bind"](active_binds[i], true)
        end

        menu["keybinds_visible"] = true
    end

    function menu:hide_keybinds()
        list_frame["Visible"] = true
        tween(list_frame, hide_transparency, circular, out, 0.15)
        tween(list_inside, hide_transparency, circular, out, 0.15)
        tween(list_shadow, hide_transparency, circular, out, 0.15)
        local children = list_inside["children"]
        for i = 1, #children do
            local child = children[i]
            if child["Visible"] then
                tween(child, hide_transparency, circular, out, 0.15)
            end
        end

        local old_tick = clock()

        for i = 1, #active_binds do
            local keybind = active_binds[i]
            menu["hide_bind"](keybind, true)
        end

        menu["keybinds_visible"] = old_tick

        delay(0.15, function()
            if old_tick == menu["keybinds_visible"] then
                menu["keybinds_visible"] = false
                list_frame["Visible"] = false
            end
        end)
    end

    function menu:load_theme(theme)
        if theme then
            local path = "juju recode/themes/"..theme..".th"
            if isfile(path) then
                local s, data = pcall(function()
                    return http_service:JSONDecode(readfile(path))
                end)

                if s and data then
                    local elements = theme_section["elements"]
                    for i = 1, #elements do
                        local element = elements[i]
                        local flag = element["color_flag"]
                        if flag then
                            local color = data[flag]

                            if color then
                                element:set_colorpicker(color3_fromrgb(color[1], color[2], color[3]))
                            end
                        end
                    end

                    menu["new_notification"]("loaded theme "..theme, 1)
                    menu["did_action"] = true
                    menu["theme"] = theme
                    menu["saved"] = true
                else
                    menu["new_notification"]("failed to load theme "..theme, 3)
                end
            else
                menu["theme"] = ""
                menu["saved"] = true
            end
        end
    end

    local offset = identifyexecutor() == "AWP" and 1 or 2

    create_connection(on_keybind_created, function(keybind, element)
        local type = keybind["type"]

        if type == 1 then
            local keybind_frame = drawing_proxy["new"]("Image", {
                ["Position"] = udim2_new(0, 0, 0, 25),
                ["Size"] = udim2_new(0, 74, 0, 18),
                ["Color"] = menu["colors"]["border"],
                ["Transparency"] = 0,
                ["Rounding"] = 4,
                ["Parent"] = list_frame,
                ["Data"] = pixel_image_data,
                ["Visible"] = false,
            })

            local keybind_inside = drawing_proxy["new"]("Image", {
                ["Position"] = udim2_new(0, 1, 0, 1),
                ["Size"] = udim2_new(0, 72, 0, 18),
                ["Color"] = menu["colors"]["background"],
                ["Transparency"] = 0,
                ["Rounding"] = 4,
                ["Data"] = pixel_image_data,
                ["Parent"] = keybind_frame,
                ["Visible"] = true,
            })

            local value_image = drawing_proxy["new"]("Image", {
                ["Color"] = menu["colors"]["accent"],
                ["Size"] = udim2_new(0, 10, 0, 10),
                ["Data"] = arrow_image_data,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = keybind_inside,
                ["Position"] = udim2_new(0, 3, 0, 3),
                ["ZIndex"] = 2
            })

            local keybind_text = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["keybind_text"],
                ["Text"] = element["name"],
                ["Size"] = 12,
                ["Font"] = 1,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = keybind_inside,
                ["Position"] = udim2_new(0, 23, 0, offset),
                ["ZIndex"] = 2
            })

            local keybind_shadow = drawing_proxy["new"]("Image", {
                ["Parent"] = keybind_frame,
                ["Data"] = shadow_image_data,
                ["Rounding"] = 7,
                ["Color"] = menu["colors"]["shadow"],
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Position"] = udim2_new(0, 0, 0, 0),
                ["ZIndex"] = 3
            })

            local x_size = keybind_text["TextBounds"]["X"] + 31

            keybind_frame["Size"] = udim2_new(0, x_size, 0, 18)
            keybind_inside["Size"] = udim2_new(0, x_size-2, 0, 16)

            local shadow_size = floor(x_size/11)
            keybind_shadow["Size"] = udim2_new(1, shadow_size - 1, 1, 4)
            keybind_shadow["Position"] = udim2_new(0, -shadow_size/2, 0, -2)

            list_drawings[keybind] = {
                ["frame"] = keybind_frame,
                ["inside"] = keybind_inside,
                ["text"] = keybind_text,
                ["value"] = value_image,
                ["shadow"] = keybind_shadow
            }
        elseif type == 2 then
            local keybind_frame = drawing_proxy["new"]("Image", {
                ["Position"] = udim2_new(0, 0, 0, 25),
                ["Size"] = udim2_new(0, 74, 0, 18),
                ["Color"] = menu["colors"]["border"],
                ["Transparency"] = 0,
                ["Rounding"] = 4,
                ["Parent"] = list_frame,
                ["Data"] = pixel_image_data,
                ["Visible"] = false,
            })

            local keybind_inside = drawing_proxy["new"]("Image", {
                ["Position"] = udim2_new(0, 1, 0, 1),
                ["Size"] = udim2_new(0, 72, 0, 18),
                ["Color"] = menu["colors"]["background"],
                ["Transparency"] = 0,
                ["Rounding"] = 4,
                ["Data"] = pixel_image_data,
                ["Parent"] = keybind_frame,
                ["Visible"] = true,
            })

            local value_text = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["accent"],
                ["Text"] = element["drawings"]["slider_text"]["Text"],
                ["Size"] = 12,
                ["Font"] = 1,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = keybind_inside,
                ["Position"] = udim2_new(0, 3, 0, offset),
            })

            local value = keybind["value"]

            if value == element["slider_min"] then
                value_text["Text"] = element["slider_min_text"] or element["slider_prefix"]..value..element["slider_suffix"]
            else
                value_text["Text"] = (value == element["slider_max"] and element["slider_max_text"]) or element["slider_prefix"]..value..element["slider_suffix"]
            end

            local keybind_text = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["keybind_text"],
                ["Text"] = element["name"],
                ["Size"] = 12,
                ["Font"] = 1,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = keybind_inside,
                ["Position"] = udim2_new(0, 23, 0, offset),
            })

            local keybind_shadow = drawing_proxy["new"]("Image", {
                ["Parent"] = keybind_frame,
                ["Data"] = shadow_image_data,
                ["Rounding"] = 7,
                ["Color"] = menu["colors"]["shadow"],
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Position"] = udim2_new(0, 0, 0, 0),
                ["ZIndex"] = 3
            })


            local text_bounds = value_text["TextBounds"]["X"]
            local x_size = text_bounds + keybind_text["TextBounds"]["X"] + 18

            keybind_text["Position"] = udim2_new(0, text_bounds + 13, 0, 2)
            keybind_frame["Size"] = udim2_new(0, x_size, 0, 18)
            keybind_inside["Size"] = udim2_new(0, x_size-2, 0, 16)

            local shadow_size = floor(x_size/11)
            keybind_shadow["Size"] = udim2_new(1, shadow_size - 1, 1, 4)
            keybind_shadow["Position"] = udim2_new(0, -shadow_size/2, 0, -2)

            list_drawings[keybind] = {
                ["frame"] = keybind_frame,
                ["inside"] = keybind_inside,
                ["text"] = keybind_text,
                ["value"] = value_text,
                ["shadow"] = keybind_shadow
            }
        elseif type == 3 then
            local keybind_frame = drawing_proxy["new"]("Image", {
                ["Position"] = UDim2.new(0, 0, 0, 25),
                ["Size"] = UDim2.new(0, 74, 0, 18),
                ["Color"] = menu["colors"]["border"],
                ["Transparency"] = 0,
                ["Rounding"] = 4,
                ["Parent"] = list_frame,
                ["Data"] = pixel_image_data,
                ["Visible"] = false,
            })

            local keybind_inside = drawing_proxy["new"]("Image", {
                ["Position"] = UDim2.new(0, 1, 0, 1),
                ["Size"] = UDim2.new(0, 72, 0, 18),
                ["Color"] = menu["colors"]["background"],
                ["Transparency"] = 0,
                ["Rounding"] = 4,
                ["Data"] = pixel_image_data,
                ["Parent"] = keybind_frame,
                ["Visible"] = true,
            })

            local keybind_shadow = drawing_proxy["new"]("Image", {
                ["Parent"] = keybind_frame,
                ["Data"] = shadow_image_data,
                ["Rounding"] = 7,
                ["Color"] = menu["colors"]["shadow"],
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Position"] = udim2_new(0, 0, 0, 0),
                ["ZIndex"] = 3
            })

            local value_image = drawing_proxy["new"]("Image", {
                ["Color"] = menu["colors"]["accent"],
                ["Size"] = UDim2.new(0, 10, 0, 10),
                ["Data"] = checkmark_image_data,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = keybind_inside,
                ["Position"] = UDim2.new(0, 3, 0, 3),
                ["ZIndex"] = 2
            })

            local keybind_text = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["keybind_text"],
                ["Text"] = element["name"],
                ["Size"] = 12,
                ["Font"] = 1,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = keybind_inside,
                ["Position"] = UDim2.new(0, 23, 0, offset),
                ["ZIndex"] = 2
            })

            local x_size = keybind_text["TextBounds"]["X"] + 31

            keybind_frame["Size"] = UDim2.new(0, x_size, 0, 18)
            keybind_inside["Size"] = UDim2.new(0, x_size-2, 0, 16)

            local shadow_size = floor(x_size/11)
            keybind_shadow["Size"] = udim2_new(1, shadow_size - 1, 1, 4)
            keybind_shadow["Position"] = udim2_new(0, -shadow_size/2, 0, -2)

            list_drawings[keybind] = {
                ["frame"] = keybind_frame,
                ["inside"] = keybind_inside,
                ["text"] = keybind_text,
                ["value"] = value_image,
                ["shadow"] = keybind_shadow
            }

            if keybind["value"] then
                menu["show_bind"](keybind)
            end
        end
    end)

    create_connection(on_keybind_updated, function(keybind, element)
        local type = keybind["type"]

        if type == 2 then
            local drawings = list_drawings[keybind]
            local value_text = drawings["value"]
            local value = keybind["value"]

            if value == element["slider_min"] then
                value_text["Text"] = element["slider_min_text"] or element["slider_prefix"]..value..element["slider_suffix"]
            else
                value_text["Text"] = (value == element["slider_max"] and element["slider_max_text"]) or element["slider_prefix"]..value..element["slider_suffix"]
            end

            local text_bounds = value_text["TextBounds"]["X"]
            local x_size = text_bounds + drawings["text"]["TextBounds"]["X"] + 18

            drawings["text"]["Position"] = udim2_new(0, text_bounds + 13, 0, 2)
            drawings["frame"]["Size"] = udim2_new(0, x_size, 0, 18)
            drawings["inside"]["Size"] = udim2_new(0, x_size-2, 0, 16)
        end
    end)

    create_connection(on_keybind_change, function(keybind, element, activated)
        if menu["keybinds_visible"] then
            if activated then
                menu["show_bind"](keybind)
            else
                menu["hide_bind"](keybind)
            end
        end
    end)

    create_connection(on_keybind_deleted, function(keybind, element, force)
        if menu["keybinds_visible"] or force then
            menu["hide_bind"](keybind)

            delay(0.15, function()
                local data = list_drawings[keybind]

                if data then
                    for _, drawing in data do
                        drawing:Destroy()
                        data[_] = nil
                    end
                    list_drawings[keybind] = nil
                end
            end)
        else
            local data = list_drawings[keybind]

            if data then
                for _, drawing in data do
                    drawing:Destroy()
                    data[_] = nil
                end
                list_drawings[keybind] = nil
            end
        end
    end)

    -- > ( elements )

    local element = {}
    element["__index"] = element

    local section = {}
    section["__index"] = section

    local item = {}
    item["__index"] = item

    -- > ( inputs )

    local moving = nil

    local right_click_connections = {}
    local scroll_connections = {}
    local hover_connections = {}
    local click_connections = {}
    local hovering_objects = {}
    local active_typing = nil

    local type_line = drawing_proxy["new"]("Square", {
        ["Position"] = udim2_new(0, 0, 0, 0),
        ["Size"] = udim2_new(0, 1, 0, 12),
        ["Filled"] = true,
        ["Transparency"] = 0,
        ["Color"] = menu["colors"]["inactive_text"],
        ["Visible"] = true,
        ["ZIndex"] = 999
    })

    local type_function = LPH_NO_VIRTUALIZE(function()
        local position = active_typing["real_position"]
        type_line["Transparency"] = 0.5 + 0.5 * math["sin"](clock() * math["pi"] * 2.5)
        type_line["Position"] = udim2_new(0, position["X"] + active_typing["TextBounds"]["X"] + 3, 0, position["Y"] + 1)
    end)

    local create_click_connection = function(new_handle, object, callback)
        local handle = click_connections[new_handle]

        if not handle then
            click_connections[new_handle] = {}
            handle = click_connections[new_handle]
        end

        local new_handle = handle[object]
        if not new_handle then
            handle[object] = {
                callback
            }
        else
            new_handle[#new_handle + 1] = callback
        end
    end

    local create_scroll_connection = function(new_handle, object, callback)
        local handle = scroll_connections[new_handle]

        if not handle then
            scroll_connections[new_handle] = {}
            handle = scroll_connections[new_handle]
        end

        local new_handle = handle[object]
        if not new_handle then
            handle[object] = {
                callback
            }
        else
            new_handle[#new_handle + 1] = callback
        end
    end

    local create_right_click_connection = function(new_handle, object, callback)
        local handle = right_click_connections[new_handle]

        if not handle then
            right_click_connections[new_handle] = {}
            handle = right_click_connections[new_handle]
        end

        local new_handle = handle[object]
        if not new_handle then
            handle[object] = {
                callback
            }
        else
            new_handle[#new_handle + 1] = callback
        end
    end

    create_hover_connection = function(new_handle, object, hover_callback, leave_callback)
        local handle = hover_connections[new_handle]

        if not handle then
            hover_connections[new_handle] = {}
            handle = hover_connections[new_handle]
        end

        local new_handle = handle[object]
        if not new_handle then
            handle[object] = {
                {
                    hover_callback,
                    leave_callback
                }
            }
        else
            new_handle[#new_handle + 1] = {
                hover_callback,
                leave_callback
            }
        end
    end

    local open_settings = function(settings)
        local border = settings["border"]
        for _, element in settings["elements"] do
            for _, drawing in element["drawings"] do
                tween(drawing, _ == "slider_fill" and half_transparency or _ == "slider_line" and half_transparency or _ == "checkmark" and (flags[element["toggle_flag"]] and half_transparency or hide_transparency) or _ == "colorpicker_transparency" and {Transparency = -flags[element["transparency_flag"]]+1} or show_transparency, exponential, out, 0.18)
            end
        end

        local position = border["real_position"]
        local x_position = position["X"] + 30
        local screen_size = camera["ViewportSize"]
        local x_size = screen_size["X"]
        local y_size = screen_size["Y"]

        local x_overlap = (x_position + border["real_size"]["X"]) - x_size
        local y_overlap = (position["Y"] + border["real_size"]["Y"]) - y_size

        if x_overlap > 0 then
            x_position-=(x_overlap + 5)
        elseif x_overlap < -x_size then
            x_position+=(-x_overlap + 5)
        else
            x_overlap = 0
        end

        if y_overlap > 0 then
            position-=vector2_new(0, y_overlap + 5)
        elseif y_overlap < -y_size then
            position+=vector2_new(0, y_overlap - 5)
        else
            y_overlap = 0
        end

        tween(settings["inside"], show_transparency, circular, out, 0.15)
        tween(border, {tween_position = udim2_new(1, 5 - x_overlap, 0, -y_overlap), Transparency = 1}, circular, out, 0.15)
        border["Visible"] = true
        actives["settings"] = settings
    end

    local close_settings = function(settings)
        local border = settings["border"]
        for _, element in settings["elements"] do
            for _, drawing in element["drawings"] do
                tween(drawing, hide_transparency, circular, out, 0.15)
            end
        end
        tween(settings["inside"], hide_transparency, circular, out, 0.15)
        tween(border, {tween_position = udim2_new(1, 5, 0, -5), Transparency = 0}, circular, out, 0.15)
        actives["settings"] = nil
        delay(0.15, function()
            if actives["settings"] ~= settings then
                border["Visible"] = false
            end
        end)

        if menu["saved"] then
            menu["saved"] = false
            writefile("juju recode/data.dat", http_service:JSONEncode({
                ["notifications"] = do_notifications,
                ["favorites"] = menu["favorites"],
                ["theme"] = menu["theme"],
                ["hide_on_load"] = menu["hide_on_load"],
                ["autoload"] = menu["autoload"]
            }))
        end
    end

    local stop_typing = function()
        for i = 1, #heartbeat do
            if heartbeat[i] == type_function then
                remove(heartbeat, i)
                break
            end
        end

        if active_typing then
            active_typing["Text"] = old_text
            active_typing = false
            type_line["Visible"] = false
        end

        context_action_service:UnbindAction(context_action_typing)
    end

    local stop_search = function()
        local children = search_out["children"]
        click_connections[search_out] = nil
        hover_connections[search_out] = nil

        for _, child in children do
            children[_] = nil
            child:Destroy()
        end

        search_out_border["Visible"] = false

        searching = nil

        tween(search_image, {tween_position = udim2_new(0, 27, 1, -27), Color = menu["colors"]["image"]}, circular, out, 0.15)
        tween(search_border, {Color = menu["colors"]["border"], ["Transparency"] = 0}, circular, out, 0.15)
        tween(search_inside, hide_transparency, circular, out, 0.15)
        tween(search_text, hide_transparency, circular, out, 0.15)


        delay(0.15, function()
            if not searching then
                search_border["Visible"] = false
            end
        end)
    end

    local start_typing = LPH_JIT_MAX(function(label, limit, callback, numbers, allow_enter, allow_all, only_on_enter) -- > LOL dont ask im too lazy to rewrite this >->
        if active_typing then
            stop_typing()
            return
        end

        type_line["Size"] = udim2_new(0, 1, 0, label["Size"] - 1)
        active_typing = label
        type_line["Visible"] = true
        heartbeat[#heartbeat + 1] = type_function

        local current_input = ""

        old_text = label["Text"]

        local items = Enum["KeyCode"]:GetEnumItems()

        local backspace = Enum["KeyCode"]["Backspace"]
        local enter = Enum["KeyCode"]["Return"]
        local shift = Enum["KeyCode"]["LeftShift"]

        context_action_service:BindAction(context_action_typing, function(_, state, input)
            if state == Enum["UserInputState"]["Begin"] then
                local keycode = input["KeyCode"]
                local is_enter = keycode == enter
                local last_input = current_input

                if is_enter and allow_enter then
                    stop_typing()

                    if searching then
                        stop_search()
                    end

                    if actives["panel"] then
                        stop_panel_search()
                    end

                    callback(current_input, input)

                    return
                elseif keycode == backspace and #current_input > 0 then
                    current_input = current_input:sub(1, #current_input-1)
                elseif user_input_service:IsKeyDown(Enum["KeyCode"]["LeftControl"]) and user_input_service:IsKeyDown(Enum["KeyCode"]["V"]) then
                    local textbox = create_instance("TextBox", {
                        ["Name"] = "\0",
                        ["Parent"] = hui
                    })
                    textbox:CaptureFocus()
                    keypress(0xA2)
                    keypress(0x56)
                    wait()
                    keyrelease(0xA2)
                    keyrelease(0x56)
                    local text = textbox["Text"]
                    if text and #text > 0 then
                        current_input ..= text
                    end
                    textbox["Parent"] = nil
                    textbox:Destroy()
                elseif keycode then
                    if label["TextBounds"]["X"] > limit then
                        return
                    end

                    local letter = user_input_service:GetStringForKeyCode(keycode):lower()
                    local byte = string["byte"](letter)

                    if (allow_all and byte) or ((byte) and (not numbers and (byte == 32 or byte == 44 or byte == 46 or byte >= 97 and byte <= 122) or numbers and (byte == 44 or byte == 46 or byte >= 48 and byte <= 57))) then
                        current_input ..= (user_input_service:IsKeyDown(shift) and string["upper"] or string["lower"])(letter)
                    end

                    callback(current_input)
                end

                label["Text"] = current_input

                if is_enter and only_on_enter or not only_on_enter then
                    local ignore = callback(current_input, input)

                    if ignore then
                        current_input = last_input
                    end
                end
            end
        end, false, unpack(items))

        label["Text"] = ""
    end)

    local do_search = LPH_JIT_MAX(function(text)
        local children = search_out["children"]
        hover_connections[search_out] = nil
        click_connections[search_out] = nil

        for _, child in children do
            children[_] = nil
            child:Destroy()
        end

        search_out_border["Visible"] = false

        if #text < 2 then
            return
        end

        local results = {}

        text = text:lower()

        for name, group in menu["groups"] do
            for name, tab in group["tabs"] do
                for _, section in tab["sections"] do
                    local elements = section["elements"]
                    for i = 1, #elements do
                        local element = elements[i]
                        local test = (element["name"] or "f"):lower():gsub(" ", "")
                        if test:find(text) then
                            results[#results + 1] = {
                                group,
                                tab,
                                section,
                                element
                            }
                        end
                    end
                end
            end
        end

        for element_settings, settings in menu["settings"] do
            local elements = settings["elements"]
            for i = 1, #elements do
                local element = elements[i]
                if (element["name"]:lower()):find(text) then
                    results[#results + 1] = {
                        element_settings,
                        element,
                        settings,
                    }
                end
            end
        end

        local max_textbounds = 0

        if #results > 0 then
            search_out_border["Visible"] = true

            local size = 8 + #results*12

            for i = 1, #results do
                local result = results[i]
                local path = nil
                local tab = nil
                local settings = nil
                local settings_element = nil
                local element = nil
                if #result == 3 then
                    path = result[1]["name"].." > "..result[2]["name"]
                    settings = result[3]
                    settings_element = result[1]
                    element = result[2]
                else
                    tab = result[2]
                    path = result[3]["name"].." > "..result[4]["name"]
                    element = result[4]
                end

                local position = udim2_new(0, 3, 0, 3 + (i-1)*12)
                local text_click = drawing_proxy["new"]("Square", {
                    ["Size"] = udim2_new(1, -6, 0, 12),
                    ["Position"] = position,
                    ["Visible"] = true,
                    ["Filled"] = true,
                    ["Transparency"] = 0,
                    ["Parent"] = search_out
                })
                local text = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["inactive_text"],
                    ["Text"] = path,
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = search_out,
                    ["Position"] = udim2_new(0, 3, 0, 3 + (i-1)*12),
                    ["ZIndex"] = 1001
                })

                local textbounds = text["TextBounds"]
                if textbounds["X"] > max_textbounds then
                    max_textbounds = textbounds["X"]
                end

                create_hover_connection(search_out, text_click, function()
                    tween(text, {["Color"] = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(text, {["Color"] = menu["colors"]["inactive_text"]}, circular, out, 0.17)
                end)

                create_click_connection(search_out, text_click, function()
                    stop_search()
                    stop_typing()
                    if not tab then
                        for name, group in menu["groups"] do
                            for name, potential_tab in group["tabs"] do
                                for _, section in potential_tab["sections"] do
                                    local elements = section["elements"]
                                    for i = 1, #elements do
                                        if elements[i] == settings_element then
                                            tab = potential_tab
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if tab and actives["tab"] ~= tab then
                        set_active_tab(tab)
                    end
                    if settings then
                        if tab then
                            wait(0.075)
                        end
                        open_settings(settings)
                    end
                    local drawings = element["drawings"]
                    local label = drawings["button_text"] or drawings["text"]
                    tween(label, hide_transparency, circular, out, 0.33)
                    delay(0.33, function()
                        if menu_open then
                            tween(label, show_transparency, circular, out, 0.33)
                            delay(0.33, function()
                                if menu_open then
                                    tween(label, hide_transparency, circular, out, 0.33)
                                    delay(0.33, function()
                                        if menu_open then
                                            tween(label, show_transparency, circular, out, 0.33)
                                        end
                                    end)
                                end
                            end)
                        end
                    end)
                end)
            end

            search_out_border["Size"] = udim2_new(0, max_textbounds + 8, 0, size)
            search_out_border["Position"] = udim2_new(0, 11, 1, -42 - size)
            search_out["Size"] = udim2_new(1, -2, 1, -2)

            local children = search_out["children"]
            for i = 1, #children do
                local child = children[i]
                if child["Size"] ~= 12 then
                    child["Size"] = udim2_new(1, -6, 0, 12)
                end
            end
        end
    end)

    local start_search = function()
        tween(search_image, {tween_position = udim2_new(0, 14, 1, -27), Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
        tween(search_border, {["Transparency"] = 1, ["Color"] = menu["colors"]["highlighted"]}, circular, out, 0.15)
        tween(search_inside, show_transparency, circular, out, 0.15)
        tween(search_text, show_transparency, circular, out, 0.15)
        search_border["Visible"] = true

        searching = true

        start_typing(search_text, 51, do_search, false, true, true, false)
    end

    local stop_binding = function(key)
        context_action_service:UnbindCoreAction(context_action_typing_core)
        tween(actives["binding"]["drawings"]["keybind_text"], {["Color"] = menu["colors"]["dark_text"]}, circular, out, 0.17)
        actives["binding"] = nil
    end

    local start_binding = function(element)
        actives["binding"] = element

        local drawings = element["drawings"]
        local keybind_border = drawings["keybind_border"]
        local keybind_inside = drawings["keybind_inside"]
        local keybind_text = drawings["keybind_text"]

        keybind_text["Text"] = "..."

        local size = keybind_text["TextBounds"]["X"] + 8

        keybind_border["Size"] = udim2_new(0, size, 0, 12)
        keybind_border["Position"] = udim2_new(1, -size, 0, 0)
        keybind_inside["Size"] = udim2_new(0, size-2, 0, 10)
        keybind_text["Position"] = udim2_new(0, (size-2)/2, 0, -2)

        local escape = Enum["KeyCode"]["Escape"]
        local tilde = Enum["KeyCode"]["Tilde"]
        local items = Enum["KeyCode"]:GetEnumItems()

        for _, a in Enum["UserInputType"]:GetEnumItems() do
            items[#items + 1] = a
        end

        context_action_service:BindCoreAction(context_action_typing_core, function(_, state, input)
            local key = shortened_characters[input["UserInputType"]] and input["UserInputType"] or input["KeyCode"]

            if state == Enum["UserInputState"]["Begin"] and key ~= Enum["KeyCode"]["Unknown"] then
                if key == escape or key == tilde then
                    key = nil
                end

                element:set_key(key)

                stop_binding()
            end
        end, false, unpack(items))

        tween(keybind_text, {Color = menu["colors"]["accent"]}, circular, out, 0.17)
    end

    local dropdown_border = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 0, 0, 14),
        ["Size"] = udim2_new(0, 0, 0, 15),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 0,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 1003,
        ["Visible"] = false,
    })

    local dropdown_inside = drawing_proxy["new"]("Image", {
        ["Parent"] = dropdown_border,
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 0,
        ["ZIndex"] = 1004,
        ["Visible"] = true,
    })

    local close_dropdown = function()
        local position = dropdown_border["real_position"]
        tween(dropdown_border, {tween_position = udim2_new(0, position["X"], 0, position["Y"] - 5), Transparency = 0}, circular, out, 0.15)
        tween(dropdown_inside, hide_transparency, circular, out, 0.15)
        local connections = click_connections[dropdown_border]

        if connections then
            for object, callback in connections do
                click_connections[object] = nil
            end
            click_connections[dropdown_border] = nil
        end

        local connections = hover_connections[dropdown_border]

        if connections then
            for object, callback in hover_connections[dropdown_border] do
                hover_connections[object] = nil
            end
        end

        local children = dropdown_inside["children"]
        for _, child in children do
            local children = child["children"]
            for i = 1, #children do
                tween(children[i], hide_transparency, circular, out, 0.15)
            end
        end

        local children = dropdown_inside["children"]
        for _, child in children do
            children[_] = nil

            delay(0.14, function()
                child:Destroy()
                local children = child["children"]
                for i = 1, #children do
                    children[i]:Destroy()
                end
            end)
        end

        hover_connections[dropdown_border] = nil
        actives["dropdown"] = nil
    end

    local open_dropdown = function(element)
        actives["dropdown"] = element

        local border = element["drawings"]["dropdown_border"]
        local position = border["real_position"]
        local size = border["real_size"]
        dropdown_border["Position"] = udim2_new(0, position["X"], 0, position["Y"] + 15)
        dropdown_border["Visible"] = true
        tween(dropdown_border, {tween_position = udim2_new(0, position["X"], 0, position["Y"] + 18), Transparency = 1}, circular, out, 0.15)
        tween(dropdown_inside, show_transparency, circular, out, 0.15)

        local options = element["options"]
        dropdown_border["Size"] = udim2_new(0, size["X"], 0, (8 + #options*12))
        dropdown_inside["Size"] = udim2_new(0, size["X"] - 2, 0, (8 + #options*12) - 2)

        local selected_options = flags[element["dropdown_flag"]]

        local multi = element["multi"]

        for i = 1, #options do
            local option = options[i]
            local selected = nil
            if selected_options then
                for i = 1, #selected_options do
                    if selected_options[i] == option then
                        selected = true
                        break
                    end
                end
            end

            local option_click = drawing_proxy["new"]("Square", {
                ["Parent"] = dropdown_inside,
                ["Size"] = udim2_new(1, -6, 0, 12),
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Filled"] = true,
                ["Position"] = udim2_new(0, 3, 0, 3 + (i-1)*12)
            })
            local option_checkmark = drawing_proxy["new"]("Image", {
                ["Parent"] = option_click,
                ["Position"] = udim2_new(1, -8, 0, 2),
                ["Size"] = udim2_new(0, 8, 0, 8),
                ["Data"] = checkmark_image_data,
                ["Transparency"] = 0,
                ["ZIndex"] = 1005,
                ["Color"] = menu["colors"]["highlighted"],
                ["Visible"] = true,
            })
            local option_text = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["inactive_text"],
                ["Text"] = option,
                ["Size"] = 12,
                ["Font"] = 1,
                ["Transparency"] = 0,
                ["Visible"] = true,
                ["Parent"] = option_click,
                ["ZIndex"] = 1005,
                ["Position"] = udim2_new(0, 0, 0, 0),
            })

            tween(option_text, show_transparency, circular, out, 0.15)

            create_hover_connection(dropdown_border, option_click, function()
                if not selected then
                    tween(option_text, {["Color"] = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end
            end, function()
                if not selected then
                    tween(option_text, {Color = menu["colors"]["inactive_text"]}, circular, out, 0.17)
                end
            end)

            create_click_connection(dropdown_border, option_click, function()
                local result = element:update_dropdown_value(option)
                if result then
                    selected = true
                    tween(option_checkmark, show_transparency, circular, out, 0.15)
                    if not multi then
                        close_dropdown(actives["dropdown"])
                    end
                elseif result == false then
                    selected = false
                    tween(option_checkmark, hide_transparency, circular, out, 0.15)
                    if not multi then
                        close_dropdown(actives["dropdown"])
                    end
                end
            end)

            if selected then
                option_text["Color"] = menu["colors"]["highlighted"]
                tween(option_checkmark, show_transparency, circular, out, 0.15)
            end
        end
    end

    local context_border = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 0, 0, 14),
        ["Size"] = udim2_new(0, 100, 0, 15),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 0,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 998,
        ["Visible"] = false,
    })

    local context_inside = drawing_proxy["new"]("Image", {
        ["Parent"] = context_border,
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 0,
        ["ZIndex"] = 999,
        ["Visible"] = true,
    })

    local keybind_border = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 0, 0, 14),
        ["Size"] = udim2_new(0, 170, 0, 20),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 0,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 998,
        ["Visible"] = false,
    })

    local keybind_inside = drawing_proxy["new"]("Image", {
        ["Parent"] = keybind_border,
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 0,
        ["ZIndex"] = 999,
        ["Visible"] = true,
    })

    local keybind_holder = drawing_proxy["new"]("Square", {
        ["Parent"] = keybind_inside,
        ["Position"] = udim2_new(0, 10, 0, 10),
        ["Size"] = udim2_new(1, -20, 1, -20),
        ["Transparency"] = 0,
        ["Filled"] = true,
        ["Visible"] = true,
    })

    local keybind_section = nil
    local copied_transparency = nil
    local copied_color = nil

    local close_keybind = function()
        local position = keybind_border["real_position"]
        tween(keybind_border, {tween_position = udim2_new(0, position["X"], 0, position["Y"] - 5), Transparency = 0}, circular, out, 0.15)
        tween(keybind_inside, hide_transparency, circular, out, 0.15)

        local keybind_elements = keybind_section["elements"]
        for i = #keybind_elements, 1, -1 do
            keybind_elements[i]:remove()
        end

        click_connections[keybind_inside] = nil
        hover_connections[keybind_inside] = nil

        actives["keybind"] = nil

        delay(0.15, function()
            if not actives["keybind"] then
                keybind_border["Visible"] = false
            end
        end)
    end

    local star = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAMAAABhq6zVAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAALGAAACxgBiam1EAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADIGQEA6AMAAMgZAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAACaOS8o1uPhvAAAALklEQVQYV2NgRAIQDgOUgpBIHAYggNE4AEISogfGxuBA2FBlEBrCASsAqWFgBAAZ8wBLe9n4/wAAAABJRU5ErkJggg==")
    local autoload = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAMAAADz0U65AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAN1gAADdYBkG95nAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS40Et+mgwAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAACIXwEA6AMAAIhfAQDoAwAAUGFpbnQuTkVUIDUuMS40AAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAItCLPyg+gOlAAAAJklEQVQYV2NgBAIQAcQMQABiAEkoAyQJZ4BkIQwQBCkA80G6GBkBBlgAKnvLiKoAAAAASUVORK5CYII=")
    local context_buttons = {
        [1] = {
            "create keybind",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAAFE0AABRNAZTKjS8AAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAvQMCAOgDAAC9AwIA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAACZvWRFEAE3KwAAACtJREFUKFNjQAb/oQDKBQMmKI0TEFTAiG4kOiBoAgoAuxAIoFwwoNSRDAwA1K8T+Ha/C0cAAAAASUVORK5CYII="),
            LPH_JIT_MAX(function()
                local new_keybind_data = keybind_data[actives["context"]]
                local do_fire = false

                if not new_keybind_data then
                    new_keybind_data = setmetatable({
                        ["key"] = nil,
                        ["method"] = 1,
                        ["value"] = nil,
                        ["activated"] = false,
                        ["original_value"] = nil,
                        ["type"] = nil,
                        ["element"] = actives["context"]
                    }, keybind)

                    do_fire = true
                end

                keybind_data[actives["context"]] = new_keybind_data

                local position = context_border["real_position"]
                local y_position = position["Y"] + context_border["real_size"]["Y"]
                keybind_border["Position"] = udim2_new(0, position["X"], 0, y_position)
                tween(keybind_border, {tween_position = udim2_new(0, position["X"], 0, y_position + 5), Transparency = 1}, circular, out, 0.15)
                tween(keybind_inside, show_transparency, circular, out, 0.15)
                keybind_border["Visible"] = true

                actives["keybind"] = actives["context"]

                local new_keybind = keybind_section:create_element({
                    ["name"] = "key"
                }, {
                    ["keybind"] = {
                        ["flag"] = tostring({}):sub(math_random(8, 12)),
                    }
                }, true)

                new_keybind:set_key(new_keybind_data["key"])

                local activate_when = keybind_section:create_element({
                    ["name"] = "activate when"
                }, {
                    ["dropdown"] = {
                        ["flag"] = tostring({}):sub(math_random(8, 12)),
                        ["requires_one"] = true,
                        ["options"] = {"toggled", "not held", "held"},
                        ["default"] = {"toggled"}
                    }
                }, true)

                local method = new_keybind_data["method"]

                activate_when:set_dropdown(method == 1 and {"toggled"} or method == 2 and {"not held"} or {"held"})

                create_connection(activate_when["on_dropdown_change"], function(value)
                    local value = value[1]
                    new_keybind_data["method"] = value == "toggled" and 1 or value == "not held" and 2 or 3
                    new_keybind_data:set_activated(value == "not held" and true or false)
                end)

                local active = actives["keybind"]

                if active["options"] then
                    local was_nil = new_keybind_data["type"] == nil
                    new_keybind_data["type"] = 1

                    if was_nil then
                        new_keybind_data["value"] = flags[active["dropdown_flag"]]
                        new_keybind_data["original_value"] = new_keybind_data["value"]
                    end

                    local new_dropdown = keybind_section:create_element({
                        ["name"] = "new value"
                    }, {
                        ["dropdown"] = {
                            ["default"] =  new_keybind_data["value"],
                            ["flag"] = tostring({}):sub(math_random(8, 12)),
                            ["options"] = active["options"],
                            ["requires_one"] = active["requires_one"],
                            ["multi"] = active["multi"]
                        }
                    }, true)

                    create_connection(new_dropdown["on_dropdown_change"], function(value)
                        new_keybind_data["value"] = value

                        if new_keybind_data["activated"] then
                            actives["context"]:set_dropdown(value, true)
                        end
                    end)
                elseif active["slider_flag"] then
                    local was_nil = new_keybind_data["type"] == nil

                    new_keybind_data["type"] = 2

                    if was_nil then
                        new_keybind_data["value"] = flags[active["slider_flag"]]
                        new_keybind_data["original_value"] = new_keybind_data["value"]
                    end

                    local new_slider = keybind_section:create_element({
                        name = "new value"
                    }, {
                        ["slider"] = {
                            ["default"] = new_keybind_data["value"],
                            ["flag"] = tostring({}):sub(math_random(8, 12)),
                            ["min"] = active["slider_min"],
                            ["max"] = active["slider_max"],
                            ["min_text"] = active["slider_min_text"],
                            ["prefix"] = active["slider_prefix"],
                            ["suffix"] = active["slider_suffix"],
                            ["max_text"] = active["slider_max_text"],
                            ["decimals"] = active["slider_decimals"],
                        }
                    }, true)

                    create_connection(new_slider["on_slider_change"], function(value)
                        new_keybind_data["value"] = value
                        on_keybind_updated:Fire(new_keybind_data, actives["context"])

                        if new_keybind_data["activated"] then
                            actives["context"]:set_slider(value, true)
                        end
                    end)
                elseif active["toggle_flag"] then
                    new_keybind_data["type"] = 3

                    new_keybind_data["value"] = flags[active["toggle_flag"]]
                    new_keybind_data["original_value"] = flags[active["toggle_flag"]]
                else
                    activate_when:set_visible(false)
                    new_keybind_data["type"] = 4
                    new_keybind_data["method"] = 1
                end

                create_connection(new_keybind["on_key_change"], function(key)
                    new_keybind_data["key"] = key
                end)

                if do_fire then
                    on_keybind_created:Fire(new_keybind_data, actives["context"])
                end
            end)
        },
        [2] = {
            "delete keybind",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAADHcBAOgDAAAMdwEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADu6i0YxswAAgAAAChJREFUKFNjQAb/oQDKBQNGEIEuCAOMQABl4gYETWCCsnECmitgYAAAtW8QA/NoRH8AAAAASUVORK5CYII="),
            function()
                local data = keybind_data[actives["context"]]

                if data then
                    if data["type"] ~= 4 then
                        data:set_activated(false)
                    end
                    keybind_data[actives["context"]] = nil
                    on_keybind_deleted:Fire(data, actives["context"])
                end

                close_context()
            end
        },
        [3] = {
            "paste color",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAN1gAADdYBkG95nAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAACIXwEA6AMAAIhfAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAALVxYeXXxjBrAAAALklEQVQYV2NgBAMGBgZGCBPEAGIIC04ASRgBkgeqBdPI4ig6wAIQFlgtmMXICAAM5AA7FWCogwAAAABJRU5ErkJggg=="),
            function()
                if copied_color and copied_transparency then
                    actives["context"]:set_colorpicker(copied_color)
                    actives["context"]:set_colorpicker_transparency(copied_transparency)
                end
                close_context()
            end
        },
        [4] = {
            "copy color",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAASRkBAOgDAABJGQEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAAAv0m/2Gfr+yQAAAEFJREFUKFNjZEAC/4EAykQBjCAAZYMBLoUgwAQi8CmAASZiFIEA2ERiAPUVMiK7ET0UkAGKQmwAppkJnykIwMAAAFFQGAl6/FkNAAAAAElFTkSuQmCC"),
            function()
                copied_color = flags[actives["context"]["color_flag"]]
                copied_transparency = flags[actives["context"]["transparency_flag"]]
                close_context()
            end
        },
        [5] = {
            "favorite",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAMAAADz0U65AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAALGAAACxgBiam1EAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADIGQEA6AMAAMgZAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAACaOS8o1uPhvAAAAH0lEQVQYV2NghAIQgwFMwBlwAGWCpMA0MgOkkpGBEQAF1gAlfZ5svQAAAABJRU5ErkJggg=="),
            function()
                local active = actives["context"]
                local favorites = menu["favorites"]
                local flag = active["favorite_flag"]

                if not favorites[flag] then
                    favorites[flag] = true
                    menu["saved"] = true
                    active["favorited"] = true
                    active["parent"]:add_icon(active["drawings"]["text"]["Text"], star)

                    writefile("juju recode/data.dat", http_service:JSONEncode({
                        ["notifications"] = do_notifications,
                        ["favorites"] = menu["favorites"],
                        ["theme"] = menu["theme"],
                        ["autoload"] = menu["autoload"]
                    }))
                end

                close_context()
            end
        },
        [6] = {
            "unfavorite",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAMAAADz0U65AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAALGAAACxgBiam1EAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADIGQEA6AMAAMgZAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAACaOS8o1uPhvAAAAH0lEQVQYV2NghAIQgwFMwBlwAGWCpMA0MgOkkpGBEQAF1gAlfZ5svQAAAABJRU5ErkJggg=="),
            function()
                local active = actives["context"]

                local favorites = menu["favorites"]
                local flag = active["favorite_flag"]
                if favorites[flag] then
                    favorites[flag] = nil
                    active["favorited"] = false
                    active["parent"]:remove_icon(active["drawings"]["text"]["Text"], star)
                    menu["saved"] = true

                    writefile("juju recode/data.dat", http_service:JSONEncode({
                        ["notifications"] = do_notifications,
                        ["favorites"] = menu["favorites"],
                        ["theme"] = menu["theme"],
                        ["autoload"] = menu["autoload"]
                    }))
                end

                close_context()
            end
        },
        [7] = {
            "paste clipboard",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAMAAABhq6zVAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS40Et+mgwAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAAMdwEA6AMAAAx3AQDoAwAAUGFpbnQuTkVUIDUuMS40AAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAANDZYAGx8DPMAAAAHklEQVQYV2NgBAEGKAVhQ3hAAsyCEBBxEKAXh5ERABXWAD2lxbDCAAAAAElFTkSuQmCC"),
            function()
                local textbox = create_instance("TextBox", {
                    ["Parent"] = hui
                })
                textbox:CaptureFocus()
                keypress(0xA2)
                keypress(0x56)
                wait()
                wait()
                keyrelease(0xA2)
                keyrelease(0x56)
                local text = textbox["Text"]
                textbox:Destroy()

                local r, g, b = 255, 255, 255
                local a = 0

                local trimmed_text = (text:match("^%s*(.-)%s*$") or ""):lower():gsub("%s+", "")

                local parsed = false

                local hex_digits = trimmed_text:match("^#?([0-9a-f]+)$")
                if hex_digits then
                    local len = #hex_digits
                    if len == 6 then
                        local r_val = tonumber(hex_digits:sub(1, 2), 16)
                        local g_val = tonumber(hex_digits:sub(3, 4), 16)
                        local b_val = tonumber(hex_digits:sub(5, 6), 16)
                        if r_val and g_val and b_val then
                            r, g, b = r_val, g_val, b_val
                            parsed = true
                        end
                    elseif len == 8 then
                        local r_val = tonumber(hex_digits:sub(1, 2), 16)
                        local g_val = tonumber(hex_digits:sub(3, 4), 16)
                        local b_val = tonumber(hex_digits:sub(5, 6), 16)
                        local a_val = tonumber(hex_digits:sub(7, 8), 16)
                        if r_val and g_val and b_val and a_val then
                            r, g, b = r_val, g_val, b_val
                            a = 1 - (math["min"](math["max"](a_val, 0), 255) / 255)
                            parsed = true
                        end
                    end
                end

                if not parsed then
                    local r_str, g_str, b_str, a_str = trimmed_text:match("^(%d+),(%d+),(%d+),?(%d*)$")
                    if r_str and g_str and b_str then
                        local r_val = tonumber(r_str)
                        local g_val = tonumber(g_str)
                        local b_val = tonumber(b_str)
                        if r_val and g_val and b_val then
                            r, g, b = r_val, g_val, b_val
                            if a_str and #a_str > 0 then
                                local a_val = tonumber(a_str)
                                if a_val then
                                    a = 1 - (math["min"](math["max"](a_val, 0), 255) / 255)
                                end
                            end
                        end
                    end
                end

                if r and g and b then
                    actives["context"]:set_colorpicker(color3_fromrgb(r, g, b))
                    actives["context"]:set_colorpicker_transparency(a or 0)
                    close_context()
                end
            end
        },
        [8] = {
            "autoload config",
            autoload,
            function()
                local active = actives["context"]
                local name = active["name"]

                if menu["autoload"] ~= name then
                    menu["autoload"] = name
                    menu["saved"] = true
                    local parent = active["parent"]
                    local elements = parent["elements"]

                    for _, element in next, elements do
                        parent:remove_icon(element["name"], autoload)                        
                    end

                    active["parent"]:add_icon(active["drawings"]["text"]["Text"], autoload)

                    writefile("juju recode/data.dat", http_service:JSONEncode({
                        ["notifications"] = do_notifications,
                        ["favorites"] = menu["favorites"],
                        ["theme"] = menu["theme"],
                        ["autoload"] = menu["autoload"]
                    }))
                end

                close_context()
            end
        },
        [9] = {
            "stop autoload",
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAMAAADz0U65AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAPhwAAD4cBYAYLnAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS40Et+mgwAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAB+igEA6AMAAH6KAQDoAwAAUGFpbnQuTkVUIDUuMS40AAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAANdbGZi1Ab9fAAAAJElEQVQYV2NgYGAEAiAFZoFJMBtIQbnIDBANVQERBNGMjAwMAAOoABlFkxrMAAAAAElFTkSuQmCC"),
            function()
                local active = actives["context"]
                local active = actives["context"]
                local name = active["name"]

                if menu["autoload"] == name then
                    menu["autoload"] = nil
                    menu["saved"] = true
                    active["parent"]:remove_icon(active["drawings"]["text"]["Text"], autoload)

                    writefile("juju recode/data.dat", http_service:JSONEncode({
                        ["notifications"] = do_notifications,
                        ["favorites"] = menu["favorites"],
                        ["theme"] = menu["theme"],
                        ["autoload"] = menu["autoload"]
                    }))
                end

                close_context()
            end
        }
    }

    for i = 1, #context_buttons do
        local button = context_buttons[i]

        local button_click = drawing_proxy["new"]("Image", {
            ["Parent"] = context_inside,
            ["Size"] = udim2_new(1, 0, 0, 16),
            ["Transparency"] = 0,
            ["Color"] = menu["colors"]["background"],
            ["Visible"] = true,
            ["ZIndex"] = 999,
            ["Data"] = pixel_image_data,
            ["Rounding"] = 4,
        })

        local button_text = drawing_proxy["new"]("Text", {
            ["Color"] = menu["colors"]["inactive_text"],
            ["Text"] = button[1],
            ["Size"] = 12,
            ["Font"] = 1,
            ["Transparency"] = 0,
            ["Visible"] = true,
            ["Parent"] = button_click,
            ["Center"] = false,
            ["Position"] = udim2_new(0, 18, 0, 1),
            ["ZIndex"] = 1000
        })

        local button_icon = drawing_proxy["new"]("Image", {
            ["Data"] = button[2],
            ["Color"] = menu["colors"]["accent"],
            ["Size"] = udim2_new(0, 8, 0, 8),
            ["Transparency"] = 0,
            ["Visible"] = true,
            ["Parent"] = button_click,
            ["Position"] = udim2_new(0, 5, 0, 4),
            ["ZIndex"] = 1000
        })

        create_hover_connection(context_border, button_click, function()
            local h, s, v = menu["colors"]["background"]:ToHSV()

            tween(button_click, {Color = Color3["fromHSV"](h, s, clamp(v * 1.5, 0.1, 1))}, circular, out, 0.15)
        end, function()
            tween(button_click, {Color = menu["colors"]["background"]}, circular, out, 0.15)
        end)

        create_click_connection(context_border, button_click, button[3])

        context_buttons[i] = {
            ["frame"] = button_click,
            ["text"] = button_text,
            ["icon"] = button_icon
        }
    end

    local open_context = function(buttons, element, position)
        local x_position = position["X"] + 15
        local y_position = 0

        context_border["Visible"] = true
        context_border["Position"] = udim2_new(0, x_position, 0, position["Y"] - 5)
        tween(context_border, {Transparency = 1, tween_position = udim2_new(0, x_position, 0, position["Y"])}, circular, out, 0.15)
        tween(context_inside, show_transparency, circular, out, 0.15)

        for i = 1, #context_buttons do
            context_buttons[i]["frame"]["Visible"] = false
        end

        local textbounds = 0

        for i = 1, #buttons do
            local index = buttons[i]
            local button = context_buttons[index]
            local callback = buttons[i]

            if callback then
                local frame = button["frame"]

                frame["Visible"] = true
                tween(frame, show_transparency, circular, out, 0.15)
                tween(button["text"], show_transparency, circular, out, 0.15)
                tween(button["icon"], half_transparency, circular, out, 0.15)
                frame["Position"] = udim2_new(0, 0, 0, y_position)

                if index == 1 then
                    button["text"]["Text"] = keybind_data[element] and "edit keybind" or "create keybind"
                end

                local button_textbounds = button["text"]["TextBounds"]["X"]
                if button_textbounds > textbounds then
                    textbounds = button_textbounds
                end
            end

            y_position = y_position + 16
        end

        context_border["Size"] = udim2_new(0, textbounds + 25, 0, y_position + 2)
        context_inside["Size"] = udim2_new(0, textbounds + 23, 0, y_position)

        for i = 1, #buttons do
            context_buttons[buttons[i]]["frame"]["Size"] = udim2_new(1, 0, 0, 16)
        end

        actives["context"] = element
    end

    close_context = function()
        local position = context_border["real_position"]

        tween(context_border, {Transparency = 0, tween_position = udim2_new(0, position["X"], 0, position["Y"] - 5)}, circular, out, 0.15)
        tween(context_inside, hide_transparency, circular, out, 0.15)

        for i = 1, #context_buttons do
            local button = context_buttons[i]
            local frame = button["frame"]

            if frame["Visible"] then
                tween(frame, hide_transparency, circular, out, 0.15)
                tween(button["text"], hide_transparency, circular, out, 0.15)
                tween(button["icon"], hide_transparency, circular, out, 0.15)
            end
        end

        delay(0.15, function()
            if actives["context"] == nil then
                context_border["Visible"] = false
            end
        end)

        actives["context"] = nil
    end

    local colorpicker_border = drawing_proxy["new"]("Image", {
        ["Position"] = udim2_new(0, 0, 0, 14),
        ["Size"] = udim2_new(0, 185, 0, 221),
        ["Color"] = menu["colors"]["border"],
        ["Transparency"] = 0,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 998,
        ["Visible"] = false,
    })

    local colorpicker_inside = drawing_proxy["new"]("Image", {
        ["Parent"] = colorpicker_border,
        ["Position"] = udim2_new(0, 1, 0, 1),
        ["Size"] = udim2_new(1, -2, 1, -2),
        ["Color"] = menu["colors"]["background"],
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["Transparency"] = 0,
        ["ZIndex"] = 999,
        ["Visible"] = true,
    })

    local colorpicker_saturation_background = drawing_proxy["new"]("Image", {
        ["Parent"] = colorpicker_inside,
        ["Position"] = udim2_new(0, 10, 0, 10),
        ["Size"] = udim2_new(0, 163, 0, 163),
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Transparency"] = 1,
        ["Rounding"] = 4,
        ["Data"] = pixel_image_data,
        ["ZIndex"] = 1000,
        ["Visible"] = true,
    })

    local colorpicker_saturation = drawing_proxy["new"]("Image", {
        ["Parent"] = colorpicker_saturation_background,
        ["Position"] = udim2_new(0, 0, 0, 0),
        ["Size"] = udim2_new(0, 163, 0, 163),
        ["Color"] = color3_fromrgb(255, 0, 0),
        ["Transparency"] = 1,
        ["Rounding"] = 4,
        ["Data"] = readfile("juju recode/assets/saturation.png"),
        ["ZIndex"] = 1001,
        ["Visible"] = true,
    })

    local colorpicker_saturation_dragger = drawing_proxy["new"]("Circle", {
        ["Radius"] = identifyexecutor() == "AWP" and 5 or 6,
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Position"] = udim2_new(0, 159, 0, 4),
        ["Transparency"] = 0,
        ["Thickness"] = identifyexecutor() == "AWP" and 2 or 4,
        ["Parent"] = colorpicker_saturation,
        ["Visible"] = true,
        ["ZIndex"] = 1002
    })

    local colorpicker_transparency = drawing_proxy["new"]("Image", {
        ["Parent"] = colorpicker_inside,
        ["Position"] = udim2_new(0, 10, 0, 183),
        ["Size"] = udim2_new(0, 163, 0, 8),
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Transparency"] = 1,
        ["Rounding"] = 4,
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAKAAAAAICAIAAADx4mP5AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAEVJREFUWEftkTEKACAQw6r/f7TgrTf0EJeSTA10yyr2pUarzmekzuefOp8XdT4jdT69CqIhcDgEDofA4RA4HAKHQ+BopAN55gMK+LqL+AAAAABJRU5ErkJggg=="),
        ["ZIndex"] = 1001,
        ["Visible"] = true,
    })

    local colorpicker_transparency_dragger = drawing_proxy["new"]("Circle", {
        ["Radius"] = identifyexecutor() == "AWP" and 3 or 5,
        ["Color"] = color3_fromrgb(0, 0, 0),
        ["Position"] = udim2_new(0, 4, 0, 4),
        ["Transparency"] = 0,
        ["Thickness"] = identifyexecutor() == "AWP" and 1 or 4,
        ["Filled"] = true,
        ["Parent"] = colorpicker_transparency,
        ["Visible"] = true,
        ["ZIndex"] = 1002
    })

    local colorpicker_transparency_dragger_overlay = drawing_proxy["new"]("Circle", {
        ["Radius"] = identifyexecutor() == "AWP" and 2 or 7,
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Transparency"] = 0,
        ["Radius"] = identifyexecutor() == "AWP" and 2 or 4,
        ["Parent"] = colorpicker_transparency_dragger,
        ["Position"] = udim2_new(0, 0, 0, 0),
        ["Visible"] = true,
        ["ZIndex"] = 1003
    })

    local colorpicker_hue = drawing_proxy["new"]("Image", {
        ["Parent"] = colorpicker_inside,
        ["Position"] = udim2_new(0, 10, 0, 201),
        ["Size"] = udim2_new(0, 163, 0, 8),
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Transparency"] = 1,
        ["Rounding"] = 4,
        ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAKAAAAAICAIAAADx4mP5AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAHJJREFUWEftkW0LgCAMhM9ArP7/b60gSmlGWOILfRz3cIzbhDE54y0wieak5qZ7fjiswIKr5ubHfIOR7U3FI1ra7Wv7Y0q18iTVnenvb6Vt5enTRj/Cy/ZOxVOKGkBUw4CVw4CVw4CVw4CVw4CVw4BVAwRG9lMU6VQQuwAAAABJRU5ErkJggg=="),
        ["ZIndex"] = 1001,
        ["Visible"] = true,
    })

    local colorpicker_hue_dragger = drawing_proxy["new"]("Circle", {
        ["Radius"] = identifyexecutor() == "AWP" and 3 or 5,
        ["Color"] = color3_fromrgb(255, 255, 255),
        ["Position"] = udim2_new(0, 4, 0, 4),
        ["Transparency"] = 0,
        ["Thickness"] = identifyexecutor() == "AWP" and 2 or 4,
        ["Parent"] = colorpicker_hue,
        ["Visible"] = true,
        ["ZIndex"] = 1002
    })

    local set_colorpicker_color = function(color, set)
        colorpicker_saturation["Color"] = Color3.fromHSV(actives["colorpicker_hue"], 1, 1)

        tween(colorpicker_hue_dragger, {tween_position = udim2_new(0, clamp(actives["colorpicker_hue"] * 163, 6, 157), 0, 4)}, circular, out, 0.1)
        tween(colorpicker_saturation_dragger, {tween_position = udim2_new(0, clamp(actives["colorpicker_saturation"] * 163, 6, 157), 0, clamp((1 - actives["colorpicker_value"]) * 163, 6, 157))}, circular, out, 0.1)

        if set then
            actives["colorpicker"]:set_colorpicker(color)
        end
    end

    local set_colorpicker_transparency = function(transparency, set)
        tween(colorpicker_transparency_dragger, {tween_position = udim2_new(0, clamp((1 - transparency) * 163, 6, 157), 0, 4)}, circular, out, 0.1)

        if set then
            actives["colorpicker"]:set_colorpicker_transparency(transparency)
        end
    end

    create_click_connection(colorpicker_border, colorpicker_saturation, function(position)
        local frame_position = colorpicker_saturation["real_position"]
        local frame_position_x = frame_position["X"]
        local frame_position_y = frame_position["Y"]

        actives["colorpicker_saturation"] = clamp((position["X"] - frame_position_x) / 163, 0, 1)
        actives["colorpicker_value"] = clamp((163 - (position["Y"] - frame_position_y)) / 163, 0, 1)

        set_colorpicker_color(Color3.fromHSV(actives["colorpicker_hue"], actives["colorpicker_saturation"], actives["colorpicker_value"]), true)

        moving = create_connection(mouse["Move"], function()
            local position = get_mouse_location(user_input_service)

            actives["colorpicker_saturation"] = clamp((position["X"] - frame_position_x) / 163, 0, 1)
            actives["colorpicker_value"] = clamp((163 - (position["Y"] - frame_position_y)) / 163, 0, 1)

            set_colorpicker_color(Color3.fromHSV(actives["colorpicker_hue"], actives["colorpicker_saturation"], actives["colorpicker_value"]), true)
        end)
    end)

    create_click_connection(colorpicker_border, colorpicker_hue, function(position)
        local frame_position_x = colorpicker_hue["real_position"]["X"]

        actives["colorpicker_hue"] = clamp((position["X"] - frame_position_x) / 163, 0, 1)

        set_colorpicker_color(Color3.fromHSV(actives["colorpicker_hue"], actives["colorpicker_saturation"], actives["colorpicker_value"]), true)

        moving = create_connection(mouse["Move"], function()
            actives["colorpicker_hue"] = clamp((get_mouse_location(user_input_service)["X"] - frame_position_x) / 158, 0, 1)
            set_colorpicker_color(Color3.fromHSV(actives["colorpicker_hue"], actives["colorpicker_saturation"], actives["colorpicker_value"]), true)
        end)
    end)

    create_click_connection(colorpicker_border, colorpicker_transparency, function(position)
        local frame_position_x = colorpicker_transparency["real_position"]["X"]

        set_colorpicker_transparency(clamp(1 - (position["X"] - frame_position_x) / 163, 0, 1), true)

        moving = create_connection(mouse["Move"], function()
            set_colorpicker_transparency(clamp(1 - (get_mouse_location(user_input_service)["X"] - frame_position_x) / 163, 0, 1), true)
        end)
    end)

    local open_colorpicker = function(element)
        local position = element["drawings"]["colorpicker_border"]["real_position"]
        local x_position = position["X"] + 30
        local screen_size = camera["ViewportSize"]
        local x_size = screen_size["X"]
        local y_size = screen_size["Y"]

        local x_overlap = (x_position + colorpicker_inside["real_size"]["X"]) - x_size
        local y_overlap = (position["Y"] + colorpicker_inside["real_size"]["Y"]) - y_size

        if x_overlap > 0 then
            x_position-=(x_overlap + 5)
        elseif x_overlap < -x_size then
            x_position+=(-x_overlap + 5)
        end

        if y_overlap > 0 then
            position-=vector2_new(0, y_overlap + 5)
        elseif y_overlap < -y_size then
            position+=vector2_new(0, y_overlap + 5)
        end


        colorpicker_border["Visible"] = true
        colorpicker_border["Position"] = udim2_new(0, x_position, 0, position["Y"] - 5)

        tween(colorpicker_border, {Transparency = 1, tween_position = udim2_new(0, x_position, 0, position["Y"])}, circular, out, 0.15)
        tween(colorpicker_inside, show_transparency, circular, out, 0.15)
        tween(colorpicker_saturation_background, show_transparency, circular, out, 0.15)
        tween(colorpicker_saturation, show_transparency, circular, out, 0.15)
        tween(colorpicker_transparency, show_transparency, circular, out, 0.15)
        tween(colorpicker_hue, show_transparency, circular, out, 0.15)
        tween(colorpicker_transparency_dragger, show_transparency, circular, out, 0.15)
        tween(colorpicker_transparency_dragger_overlay, show_transparency, circular, out, 0.15)
        tween(colorpicker_hue_dragger, show_transparency, circular, out, 0.15)
        tween(colorpicker_saturation_dragger, show_transparency, circular, out, 0.15)

        local color = flags[element["color_flag"]]

        actives["colorpicker_hue"], actives["colorpicker_saturation"], actives["colorpicker_value"] = color:ToHSV()

        if actives["colorpicker_saturation"] < 0.001 then
            actives["colorpicker_hue"] = 1
        end

        set_colorpicker_color(color)
        set_colorpicker_transparency(flags[element["transparency_flag"]])

        actives["colorpicker"] = element
    end

    local close_colorpicker = function()
        local position = colorpicker_border["real_position"]
        tween(colorpicker_border, {Transparency = 0, tween_position = udim2_new(0, position["X"], 0, position["Y"] - 5)}, circular, out, 0.15)
        tween(colorpicker_inside, hide_transparency, circular, out, 0.15)
        tween(colorpicker_saturation_background, hide_transparency, circular, out, 0.15)
        tween(colorpicker_saturation, hide_transparency, circular, out, 0.15)
        tween(colorpicker_transparency, hide_transparency, circular, out, 0.15)
        tween(colorpicker_hue, hide_transparency, circular, out, 0.15)
        tween(colorpicker_transparency_dragger, hide_transparency, circular, out, 0.15)
        tween(colorpicker_transparency_dragger_overlay, hide_transparency, circular, out, 0.15)
        tween(colorpicker_hue_dragger, hide_transparency, circular, out, 0.15)
        tween(colorpicker_saturation_dragger, hide_transparency, circular, out, 0.15)

        actives["colorpicker"] = nil

        delay(0.15, function()
            if actives["colorpicker"] == nil then
                colorpicker_border["Visible"] = false
            end
        end)
    end

    stop_panel_search = function()
        tween(actives["panel"]["search_border"], {Color = menu["colors"]["border"]}, circular, out, 0.15)
        tween(actives["panel"]["search_image"], {Color = menu["colors"]["border"]}, circular, out, 0.15)
        tween(actives["panel"]["search_text"], {Color = menu["colors"]["inactive_text"]}, circular, out, 0.15)

        local panel = actives["panel"]
        actives["panel"] = nil
        panel:update_position()
    end

    local do_panel_search = function(search_text)
        if not actives["panel"] then
            return
        end

        actives["panel"]["scroll_index"] = 1

        local elements = actives["panel"]["elements"]
        local search_text = search_text:lower()
        local search_index = 0

        for i = 1, #elements do
            local element = elements[i]
            local drawings = element["drawings"]
            local frame = drawings["border"]
            local text = drawings["text"]
            local text2 = element["text2"]
            if search_index < 13 and (text["Text"]:lower():find(search_text) or text2 and text2:lower():find(search_text)) then
                search_index+=1
                frame["Visible"] = true
                frame["Position"] = udim2_new(0, 0, 0, 30 + (search_index - 1) * 30)
            else
                frame["Visible"] = false
            end
        end
    end

    local start_panel_search = function(element)
        actives["panel"] = element

        start_typing(actives["panel"]["search_text"], 150, do_panel_search, false, true, true, false)

        tween(actives["panel"]["search_border"], {Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
        tween(actives["panel"]["search_image"], {Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
        tween(actives["panel"]["search_text"], {Color = menu["colors"]["active_text"]}, circular, out, 0.15)
    end

    local handle_click = LPH_JIT_MAX(function(_, state, input)
        if moving then
            moving:Disconnect()
            moving = nil

            if drag_frame["Visible"] then
                frame["Position"] = menu_position
                frame["Visible"] = true
                tween(drag_frame, hide_transparency, circular, out, 0.12)
                tween(drag_logo, hide_transparency, circular, out, 0.12)
                tween(drag_inside, hide_transparency, circular, out, 0.12)
                delay(0.12, function()
                    if not moving then
                        drag_frame["Visible"] = false
                    end
                end)
            end
        end

        local type = input["UserInputType"]
        if (type ~= Enum["UserInputType"]["MouseButton1"] and type ~= Enum["UserInputType"]["Touch"]) or state ~= Enum["UserInputState"]["Begin"] then
            return
        end

        if active_typing then
            delay(0, function()
                stop_typing(active_typing)

                if searching then
                    stop_search()
                end

                if actives["panel"] then
                    stop_panel_search()
                end
            end)
        end

        local mouse_position = get_mouse_location(user_input_service)
            local mouse_position_x = mouse_position["X"]
            local mouse_position_y = mouse_position["Y"]

        if actives["dropdown"] then
            local border = actives["dropdown"]["drawings"]["dropdown_border"]
                local border_position = border["real_position"] + vector2_new(0, 18)

            if not (mouse_position_x > border_position["X"] and mouse_position_x < border_position["X"] + border["real_size"]["X"]) or not (mouse_position_y > border_position["Y"] and mouse_position_y < border_position["Y"] + dropdown_border["real_size"]["Y"]) then
                close_dropdown(actives["dropdown"])

                return
            end
        elseif actives["colorpicker"] then
            local border_position = colorpicker_border["real_position"]

            if not (mouse_position_x > border_position["X"] and mouse_position_x < border_position["X"] + colorpicker_border["real_size"]["X"]) or not (mouse_position_y > border_position["Y"] and mouse_position_y < border_position["Y"] + colorpicker_border["real_size"]["Y"]) then
                close_colorpicker(actives["colorpicker"])

                return
            end
        elseif actives["keybind"] then
            local border_position = keybind_border["real_position"]

            if not (mouse_position_x > border_position["X"] and mouse_position_x < border_position["X"] + keybind_border["real_size"]["X"]) or not (mouse_position_y > border_position["Y"] and mouse_position_y < border_position["Y"] + keybind_border["real_size"]["Y"]) then
                close_keybind(actives["keybind"])
                close_context(actives["context"])

                return
            end
        elseif actives["context"] then
            local border_position = context_border["real_position"]

            if not (mouse_position_x > border_position["X"] and mouse_position_x < border_position["X"] + context_border["real_size"]["X"]) or not (mouse_position_y > border_position["Y"] and mouse_position_y < border_position["Y"] + context_border["real_size"]["Y"]) then
                close_context(actives["context"])

                return
            end
        elseif actives["settings"] then
            local border = actives["settings"]["border"]
                local border_position = border["real_position"]

            if not (mouse_position_x > border_position["X"] and mouse_position_x < border_position["X"] + border["real_size"]["X"]) or not (mouse_position_y > border_position["Y"] and mouse_position_y <  border_position["Y"] + border["real_size"]["Y"]) then
                close_settings(actives["settings"])

                return
            end
        end

        local connections = searching and click_connections[search_out] or actives["colorpicker"] and click_connections[colorpicker_border] or actives["dropdown"] and click_connections[dropdown_border] or actives["keybind"] and click_connections[keybind_inside] or actives["context"] and click_connections[context_border] or actives["settings"] and click_connections[actives["settings"]["inside"]] or nil

        if connections or (mouse_position_x > menu_position["X"]["Offset"] and mouse_position_x < menu_position["X"]["Offset"] + frame["Size"]["X"]) and (mouse_position_y > menu_position["Y"]["Offset"] and mouse_position_y < menu_position["Y"]["Offset"] + frame["Size"]["Y"]) then
            if not connections then
                for object, connections in click_connections do
                    if not object["is_rendering"] then
                        continue
                    end

                    local object_position = object["real_position"]
                    local object_size = object["real_size"]

                    if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                        for object, data in connections do
                            if not object["is_rendering"] then
                                continue
                            end

                            local object_position = object["real_position"]
                            local object_size = object["real_size"]

                            if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                                for i = 1, #data do
                                    data[i](mouse_position)
                                end

                                return
                            end
                        end
                    end
                end

                local fake_menu_position = frame["real_position"]
                local abs = math["abs"]

                moving = create_connection(mouse["Move"], function()
                    if not drag_frame["Visible"] then
                        drag_frame["Visible"] = true
                        tween(drag_frame, show_transparency, circular, out, 0.05)
                        tween(drag_logo, show_transparency, circular, out, 0.05)
                        tween(drag_inside, show_transparency, circular, out, 0.05)

                        drag_frame["Position"] = menu_position
                        delay(0.02, function()
                            if moving then
                                frame["Visible"] = false
                            end
                        end)
                    end

                    local new_mouse_position = get_mouse_location(user_input_service)
                    local new_position = udim2_new(0, fake_menu_position["X"] - (mouse_position_x - new_mouse_position["X"]), 0, fake_menu_position["Y"] - (mouse_position_y - new_mouse_position["Y"]))

                    if abs(menu_position["X"]["Offset"]-new_position["X"]["Offset"]) > 1.1 or abs(menu_position["Y"]["Offset"]-new_position["Y"]["Offset"]) > 1.1 then
                        drag_frame["Position"] = new_position
                        menu_position = new_position
                    end
                end)
            else
                for object, data in connections do
                    if not object["is_rendering"] then
                        continue
                    end

                    local object_position = object["real_position"]
                    local object_size = object["real_size"]

                    if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                        for i = 1, #data do
                            data[i](mouse_position)
                        end

                        return
                    end
                end
            end
        else
            for flag, frame in hud_frames do
                if frame["is_rendering"] then
                    local hud_position = frame["real_position"]
                    local hud_size = frame["real_size"]

                    if (mouse_position_x > hud_position["X"] and mouse_position_x < hud_position["X"] + hud_size["X"]) and (mouse_position_y > hud_position["Y"] and mouse_position_y < hud_position["Y"] + hud_size["Y"]) then
                        local fake_hud_position = hud_position

                        moving = create_connection(mouse["Move"], function()
                            local new_mouse_position = get_mouse_location(user_input_service)
                            local new_position_x = fake_hud_position["X"] - (mouse_position_x - new_mouse_position["X"])
                            local new_position_y = fake_hud_position["Y"] - (mouse_position_y - new_mouse_position["Y"])
                            local new_position = udim2_new(0, new_position_x, 0, new_position_y)

                            list_frame["Position"] = new_position
                            flags[flag] = {new_position_x, new_position_y}
                        end)

                        break
                    end
                end
            end
        end
    end)

    local handle_scroll = LPH_JIT_MAX(function(_, state, input)
        if state ~= Enum["UserInputState"]["Change"] or input["UserInputType"] ~= Enum["UserInputType"]["MouseWheel"] then
            return
        end

        local mouse_position = get_mouse_location(user_input_service)
            local mouse_position_x = mouse_position["X"]
            local mouse_position_y = mouse_position["Y"]

        local is_up = input["Position"]["Z"] > 0

        if (mouse_position_x > menu_position["X"]["Offset"] and mouse_position_x < menu_position["X"]["Offset"] + frame["Size"]["X"]) and (mouse_position_y > menu_position["Y"]["Offset"] and mouse_position_y < menu_position["Y"]["Offset"] + frame["Size"]["Y"]) then
            for object, connections in scroll_connections do
                if not object["is_rendering"] then
                    continue
                end

                local object_position = object["real_position"]
                local object_size = object["real_size"]

                if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                    for object, data in connections do
                        if not object["is_rendering"] then
                            continue
                        end

                        local object_position = object["real_position"]
                        local object_size = object["real_size"]

                        if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                            for i = 1, #data do
                                data[i](is_up)
                            end

                            return
                        end
                    end
                end
            end
        end
    end)

    local handle_hover = LPH_JIT_MAX(function()
        local mouse_position = get_mouse_location(user_input_service)
            local mouse_position_x = mouse_position["X"]
            local mouse_position_y = mouse_position["Y"]

        cursor["Position"] = udim2_new(0, mouse_position["X"], 0, mouse_position["Y"])
        user_input_service["MouseIconEnabled"] = false

        local connections = searching and hover_connections[search_out] or actives["colorpicker"] and hover_connections[colorpicker_border] or actives["dropdown"] and hover_connections[dropdown_border] or actives["keybind"] and hover_connections[keybind_inside] or actives["context"] and hover_connections[context_border] or actives["settings"] and hover_connections[actives["settings"]["inside"]] or nil

        if connections or (mouse_position_x > menu_position["X"]["Offset"] and mouse_position_x < menu_position["X"]["Offset"] + frame["Size"]["X"]) and (mouse_position_y > menu_position["Y"]["Offset"] and mouse_position_y < menu_position["Y"]["Offset"] + frame["Size"]["Y"]) then
            if not connections then
                for object, connections in hover_connections do
                    if not object["is_rendering"] then
                        continue
                    end

                    local object_position = object["real_position"]
                    local object_size = object["real_size"]

                    if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                        for object, data in connections do
                            if not object["is_rendering"] then
                                continue
                            end

                            local object_position = object["real_position"]
                            local object_size = object["real_size"]

                            if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                                if hovering_objects[object] then
                                    return
                                end

                                for object, data in hovering_objects do
                                    for _, data in data do
                                        data[2]()
                                    end
                                    hovering_objects[object] = nil
                                end

                                hovering_objects[object] = data

                                for _, data in data do
                                    data[1](mouse_position)
                                end

                                return
                            end
                        end
                    end
                end
            else
                for object, data in connections do
                    if not object["is_rendering"] then
                        continue
                    end

                    local object_position = object["real_position"]
                    local object_size = object["real_size"]

                    if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                        if hovering_objects[object] then
                            return
                        end

                        for object, data in hovering_objects do
                            for _, data in data do
                                data[2]()
                            end
                            hovering_objects[object] = nil
                        end

                        hovering_objects[object] = data

                        for _, data in data do
                            data[1](mouse_position)
                        end

                        return
                    end
                end
            end

            for object, data in hovering_objects do
                for _, data in data do
                    data[2]()
                end
                hovering_objects[object] = nil
            end
        else
            for flag, frame in hud_frames do
                if frame["is_rendering"] then
                    local hud_position = frame["real_position"]
                    local hud_size = frame["real_size"]

                    if (mouse_position_x > hud_position["X"] and mouse_position_x < hud_position["X"] + hud_size["X"]) and (mouse_position_y > hud_position["Y"] and mouse_position_y < hud_position["Y"] + hud_size["Y"]) then
                        if hovering_objects[frame] then
                            return
                        end

                        local data = hover_connections[frame][frame]

                        if data then
                            for object, data in hovering_objects do
                                for _, data in data do
                                    data[2]()
                                end
                                hovering_objects[frame] = nil
                            end

                            hovering_objects[frame] = data

                            for _, data in data do
                                data[1](mouse_position)
                            end

                            return
                        end
                    end

                    for object, data in hovering_objects do
                        for _, data in data do
                            data[2]()
                        end
                        hovering_objects[object] = nil
                    end
                end
            end
        end
    end)

    local handle_right_click = LPH_JIT_MAX(function(_, input)
        if actives["dropdown"] then
            return
        end

        local mouse_position = get_mouse_location(user_input_service)
            local mouse_position_x = mouse_position["X"]
            local mouse_position_y = mouse_position["Y"]

        if (mouse_position_x > menu_position["X"]["Offset"] and mouse_position_x < menu_position["X"]["Offset"] + frame["Size"]["X"]*1.5) and (mouse_position_y > menu_position["Y"]["Offset"] and mouse_position_y < menu_position["Y"]["Offset"] + frame["Size"]["Y"]*1.5) then
            for object, connections in right_click_connections do
                if not object["is_rendering"] then
                    continue
                end

                local object_position = object["real_position"]
                local object_size = object["real_size"]

                if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                    for object, data in connections do
                        if not object["is_rendering"] then
                            continue
                        end

                        local object_position = object["real_position"]
                        local object_size = object["real_size"]

                        if (mouse_position_x > object_position["X"] and mouse_position_x < object_position["X"] + object_size["X"]) and (mouse_position_y > object_position["Y"] and mouse_position_y < object_position["Y"] + object_size["Y"]) then
                            for i = 1, #data do
                                data[i](mouse_position)
                            end

                            return
                        end
                    end
                end
            end
        end
    end)

    local hovering = nil

    pop_menu = LPH_JIT_MAX(function(a)
        if moving then
            moving:Disconnect()
            moving = nil
        end

        if drag_frame["Visible"] then
            drag_frame["Visible"] = false
            frame["Visible"] = true
            frame["Position"] = menu_position
        end

        if hovering then
            hovering:Disconnect()
            hovering = nil
        end

        if actives["settings"] then
            close_settings(actives["settings"])
        end

        if searching then
            stop_search()
        end

        if actives["binding"] then
            stop_binding(actives["binding"])
        end

        if actives["dropdown"] then
            close_dropdown(actives["dropdown"])
        end

        if actives["context"] then
            close_context(actives["context"])
        end

        if actives["keybind"] then
            close_keybind(actives["keybind"])
        end

        if actives["panel"] then
            stop_panel_search(actives["panel"])
        end

        if actives["colorpicker"] then
            close_colorpicker(actives["colorpicker"])
        end

        if active_typing then
            stop_typing()
        end

        for object, data in hovering_objects do
            for _, data in data do
                data[2]()
            end
            hovering_objects[object] = nil
        end

        menu_open = not menu_open

        local half_transparency = menu_open and half_transparency or hide_transparency
        local transparency = menu_open and show_transparency or hide_transparency

        tween(cursor, transparency, exponential, out, 0.18)

        local mouse_position = get_mouse_location(user_input_service)
        user_input_service["MouseIconEnabled"] = not menu_open
        cursor["Position"] = udim2_new(0, mouse_position["X"], 0, mouse_position["Y"])
        
        frame["Visible"] = not a
        inside["Visible"] = not a

        tween(frame, transparency, exponential, out, 0.18)
        tween(inside, transparency, exponential, out, 0.18)
        tween(logo, transparency, exponential, out, 0.18)
        tween(juju_text, transparency, exponential, out, 0.18)
        tween(build_text, transparency, exponential, out, 0.18)
        tween(right_side, transparency, exponential, out, 0.18)
        tween(right_side_divider, transparency, exponential, out, 0.18)
        tween(search_image, transparency, exponential, out, 0.18)
        tween(themes_image, transparency, exponential, out, 0.18)

        tween(settings_image, transparency, exponential, out, 0.18)
        tween(tab_line, half_transparency, exponential, out, 0.18)
        tween(search_border, transparency, exponential, out, 0.18)
        tween(search_inside, transparency, exponential, out, 0.18)
        tween(search_text, transparency, exponential, out, 0.18)

        for name, group in menu["groups"] do
            tween(group["text"], half_transparency, exponential, out, 0.18)
            tween(group["line"], half_transparency, exponential, out, 0.18)

            for name, tab in group["tabs"] do
                tween(tab["text"], transparency, exponential, out, 0.18)

                if actives["tab"] == tab then
                    for _, section in tab["sections"] do
                        tween(section["border"], transparency, exponential, out, 0.18)
                        tween(section["line_two"], half_transparency, exponential, out, 0.18)
                        tween(section["inside"], transparency, exponential, out, 0.18)
                        tween(section["label"], half_transparency, exponential, out, 0.18)
                        tween(section["line"], half_transparency, exponential, out, 0.18)

                        local search_border = section["search_border"]

                        if search_border then
                            tween(search_border, transparency, exponential, out, 0.18)
                            tween(section["search_inside"], transparency, exponential, out, 0.18)
                            tween(section["search_text"], transparency, exponential, out, 0.18)
                            tween(section["search_image"], transparency, exponential, out, 0.18)
                        end

                        for _, element in section["elements"] do
                            for _, drawing in element["drawings"] do
                                tween(drawing, _ == "slider_fill" and half_transparency or _ == "slider_line" and half_transparency or _ == "checkmark" and (flags[element["toggle_flag"]] and half_transparency or hide_transparency) or _ == "colorpicker_transparency" and (menu_open and {Transparency = -flags[element["transparency_flag"]]+1} or transparency) or transparency, exponential, out, 0.18)
                            end
                        end
                    end
                end
            end
        end

        context_action_service:BindAction(context_action_click, handle_click, false, Enum["UserInputType"]["MouseButton1"], Enum["UserInputType"]["Touch"])
        context_action_service:BindAction(context_action_scroll, handle_scroll, false, Enum["UserInputType"]["MouseWheel"])

        local old_tick = clock()
        menu_tick = old_tick

        if not menu_open then
            context_action_service:UnbindAction(context_action_click)
            context_action_service:UnbindAction(context_action_scroll)

            delay(0.17, function()
                if old_tick == menu_tick then
                    frame["Visible"] = false
                    inside["Visible"] = false
                end
            end)
        else
            hovering = create_connection(mouse["Move"], handle_hover)
        end
    end)

    create_connection(user_input_service["InputBegan"], LPH_NO_VIRTUALIZE(function(input, gpe)
        local user_input_type = input["UserInputType"]

        if not gpe then
            for element, keybind in keybind_data do
                local key = keybind["key"]
                local is_key = user_input_type == key or input["KeyCode"] == key

                if is_key then
                    local method = keybind["method"]

                    if method == 1 then
                        keybind:set_activated(not keybind["activated"])
                    else
                        keybind:set_activated(method == 3 and true or false)
                    end
                end
            end

            if menu_open and user_input_type == Enum["UserInputType"]["MouseButton2"] then
                handle_right_click(nil, input)
            end
        end
    end))

    create_connection(user_input_service["InputEnded"], LPH_NO_VIRTUALIZE(function(input, gpe)
        if not gpe then
            for _, keybind in keybind_data do
                local key = keybind["key"]
                local is_key = input["UserInputType"] == key or input["KeyCode"] == key

                if is_key then
                    local method = keybind["method"]
                    if method == 2 then
                        keybind:set_activated(true)
                    elseif method == 3 then
                        keybind:set_activated(false)
                    end
                end
            end
        end
    end))

    -- > ( other )

    menu.is_menu_open = LPH_NO_VIRTUALIZE(function()
        return menu_open
    end)

    -- > ( groups )

    set_active_tab = function(tab)
        actives["old_tab"] = actives["tab"]
        local last_group = actives["old_tab"] and actives["old_tab"]["group"]

        tween(right_side_cover, show_transparency, circular, out, 0.15)

        if actives["old_tab"] then
            tween(actives["old_tab"]["frame"], {["tween_position"] = udim2_new(0, 10, 0, 20)}, circular, out, 0.15)
            tween(actives["old_tab"]["text"], {["Color"] = menu["colors"]["inactive_text"], ["tween_position"] = actives["old_tab"]["position"]}, circular, out, 0.15)
        end

        local tab_position = tab["position"]

        if last_group == tab["group"] then
            tween(tab_line, {["tween_position"] = udim2_new(0, tab_position["X"]["Offset"], 0, tab_position["Y"]["Offset"] + 1)}, circular, out, 0.15)
        else
            tab_line["Transparency"] = 0
            tab_line["Position"] = udim2_new(0, tab_position["X"]["Offset"], 0, tab_position["Y"]["Offset"] + 1)
            tween(tab_line, half_transparency, circular, out, 0.2)
        end

        tween(tab["text"], {["Color"] = menu["colors"]["active_text"], ["tween_position"] = udim2_new(0, tab_position["X"]["Offset"] + 5, 0, tab_position["Y"]["Offset"])}, circular, out, 0.15)

        delay(0.14, function()
            if actives["tab"] == tab then
                if actives["old_tab"] then
                    actives["old_tab"]["frame"]["Visible"] = false
                end

                tween(right_side_cover, hide_transparency, circular, out, 0.15)

                local new_frame = tab["frame"]
                new_frame["Visible"] = true
                new_frame["Position"] = udim2_new(0, 10, 0, 20)
                tween(new_frame, {["tween_position"] = udim2_new(0, 10, 0, 10)}, circular, out, 0.15)
            elseif actives["old_tab"] and actives["tab"] ~= actives["old_tab"] then
                actives["old_tab"]["frame"]["Visible"] = false
            end
        end)
        actives["tab"] = tab
    end

    local group_header_height = 30
    local tab_vertical_step = 15

    function menu.update_layout()
        local current_y_offset = menu["initial_base_offset"]
        local ordered_groups = menu["ordered_groups"]
        local num_groups = #ordered_groups
    
        for i = 1, num_groups do
            local group = ordered_groups[i]
            local should_be_visible = group["is_visible"]
            local group_text = group["text"]
            local group_line = group["line"]
            local ordered_tabs = group["ordered_tabs"]
            local num_tabs = #ordered_tabs
    
            group["initial_offset"] = current_y_offset
    
            if group_text then group_text["Visible"] = should_be_visible end
            if group_line then group_line["Visible"] = should_be_visible end
    
            for tab_index = 1, num_tabs do
                local tab = ordered_tabs[tab_index]
                local tab_text = tab["text"]
                local tab_text_frame = tab["text_frame"]
                if tab_text then tab_text["Visible"] = should_be_visible end
                if tab_text_frame then tab_text_frame["Visible"] = should_be_visible end
            end
    
            if should_be_visible then
                if group_text then
                    group_text["Position"] = udim2_new(0, 15, 0, current_y_offset)
                end
                if group_line then
                    group_line["Position"] = udim2_new(0, 15, 0, current_y_offset + 15)
                end
    
                local base_tab_y = current_y_offset + 20
                for tab_index = 1, num_tabs do
                    local tab = ordered_tabs[tab_index]
                    local tab_text = tab["text"]
                    local tab_text_frame = tab["text_frame"]
                    local new_tab_y = base_tab_y + (tab_index-1)*tab_vertical_step
                    local new_tab_position = udim2_new(0, 15, 0, new_tab_y)
                    
                    tab["position"] = new_tab_position
                    if tab_text then
                        tab_text["Position"] = actives["tab"] == tab and udim2_new(0, 20, 0, new_tab_y) or new_tab_position
                    end
                    if tab_text_frame then
                        tab_text_frame["Position"] = new_tab_position
                        if tab_text then
                            tab_text_frame["Size"] = udim2_new(0, 70, 0, tab_text["TextBounds"]["Y"])
                        end
                    end
                end
                current_y_offset = current_y_offset + group["current_height"]
            end
        end

        local size = current_y_offset > 405 and udim2_new(0, 575, 0, 450 + (current_y_offset - 405)) or udim2_new(0, 575, 0, 450)
        drag_frame["Size"] = size
        frame["Size"] = size
    end
    
    local group = {}
    group["__index"] = group
    
    function menu.create_group(name)
        local new_tabs = {}
        local ordered_tabs = {}
        local initial_offset
        local ordered_groups = menu["ordered_groups"]
        local num_groups = #ordered_groups
    
        if num_groups > 0 then
            local previous_group = nil
            for i = num_groups, 1, -1 do
                local g = ordered_groups[i]
                if g["is_visible"] then
                    previous_group = g
                    break
                end
            end
    
            if previous_group then
                initial_offset = previous_group["initial_offset"] + previous_group["current_height"]
            else
                initial_offset = menu["initial_base_offset"]
            end
        else
            initial_offset = menu["initial_base_offset"]
        end
    
        local new_group = setmetatable({
            ["tabs"] = new_tabs,
            ["ordered_tabs"] = ordered_tabs,
            ["initial_offset"] = initial_offset,
            ["current_height"] = group_header_height,
            ["is_visible"] = true,
            ["name"] = name,
            ["text"] = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["accent"],
                ["Transparency"] = 0.5,
                ["Text"] = name,
                ["Parent"] = inside,
                ["Size"] = 14,
                ["Font"] = 1,
                ["Position"] = udim2_new(0, 15, 0, initial_offset),
                ["Visible"] = true,
            }),
            ["line"] = drawing_proxy["new"]("Square", {
                ["Parent"] = inside,
                ["Transparency"] = 0.5,
                ["Position"] = udim2_new(0, 15, 0, initial_offset + 15),
                ["Size"] = udim2_new(0, 70, 0, 1),
                ["Color"] = menu["colors"]["accent"],
                ["Filled"] = true,
                ["Visible"] = true,
            })
        }, group)
    
        menu["groups"][name] = new_group
        ordered_groups[#ordered_groups+1] = new_group
    
        return new_group
    end
    
    function group:create_tab(name)
        local group_initial_offset = self["initial_offset"]
        local ordered_tabs = self["ordered_tabs"]
        local index = #ordered_tabs + 1
        local position = udim2_new(0, 15, 0, group_initial_offset + 20 + (index-1)*tab_vertical_step)
        local is_group_visible = self["is_visible"]
    
        local new_tab = {
            ["text"] = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["inactive_text"],
                ["Text"] = name:sub(1, 12),
                ["Size"] = 12,
                ["Font"] = 1,
                ["Visible"] = is_group_visible,
                ["Parent"] = inside,
                ["Position"] = position
            }),
            ["frame"] = drawing_proxy["new"]("Square", {
                ["Parent"] = right_side,
                ["Position"] = udim2_new(0, 10, 0, 10),
                ["Size"] = udim2_new(1, -20, 1, -20),
                ["Filled"] = true,
                ["Transparency"] = 0,
                ["Visible"] = false
            }),
            ["sections"] = {},
            ["position"] = position,
            ["group"] = self,
            ["name"] = name
        }


        new_tab["destroy"] = function(self)
            if not self or not self["text"] then
                error("attempt to destroy nil tab")
                return
            end
            self["text"]:Destroy()
            self["frame"]:Destroy()
            for _, section in self["sections"] do
                section:destroy()
            end

            self["group"]:remove_tab(name)
        end

        local text = new_tab["text"]
    
        local text_frame = drawing_proxy["new"]("Square", {
            ["Parent"] = inside,
            ["Position"] = position,
            ["Size"] = udim2_new(0, 70, 0, text["TextBounds"]["Y"]),
            ["Filled"] = true,
            ["Transparency"] = 0,
            ["Visible"] = is_group_visible,
        })
        new_tab["text_frame"] = text_frame
    
        self["tabs"][name] = new_tab
        ordered_tabs[#ordered_tabs+1] = new_tab
    
        self["current_height"] = group_header_height + #ordered_tabs * tab_vertical_step
    
        create_click_connection(text_frame, text_frame, function()
            if actives["tab"] ~= new_tab then
                set_active_tab(new_tab)
            end
        end)
        create_hover_connection(text_frame, text_frame, function()
            if actives["tab"] ~= new_tab then
                tween(text, {["Color"] = menu["colors"]["highlighted"]}, circular, out, 0.17)
            end
        end, function()
            if actives["tab"] ~= new_tab then
                tween(text, {["Color"] = menu["colors"]["inactive_text"]}, circular, out, 0.17)
            end
        end)
    
        if actives["tab"] == nil then
            set_active_tab(new_tab)
        end
    
        if is_group_visible then
            menu.update_layout()
        end
    
        return new_tab
    end
    
    function group:remove_tab(name)
        local tab_to_remove = self["tabs"][name]
        if not tab_to_remove then return end
    
        local remove_index = nil
        local ordered_tabs = self["ordered_tabs"]
        local num_tabs = #ordered_tabs
        for i = 1, num_tabs do
            local tab = ordered_tabs[i]
            if tab == tab_to_remove then
                remove_index = i
                break
            end
        end
    
        if not remove_index then return end
    
        local text_obj = tab_to_remove["text"]
        local text_frame_obj = tab_to_remove["text_frame"]
        local frame_obj = tab_to_remove["frame"]
    
        if text_obj then
            text_obj["Visible"] = false
            text_obj["Parent"] = nil
        end
        if text_frame_obj then
            text_frame_obj["Visible"] = false
            text_frame_obj["Parent"] = nil
        end
        if frame_obj then
            frame_obj["Visible"] = false
            frame_obj["Parent"] = nil
        end
    
        if actives["tab"] == tab_to_remove then
            actives["tab"] = nil
        end
    
        self["tabs"][name] = nil
        remove(ordered_tabs, remove_index)
    
        self["current_height"] = group_header_height + #ordered_tabs * tab_vertical_step
    
        if self["is_visible"] then
             menu.update_layout()
        end
    end
    
    function group:hide()
        if not self["is_visible"] then return end
        self["is_visible"] = false
        menu.update_layout()
    end
    
    function group:show()
        if self["is_visible"] then return end
        self["is_visible"] = true
        menu.update_layout()
    end
    
    local section = {}
    section["__index"] = section
    
    function group:create_section(tab_name, name, side, size, y_position)
        local tab = self["tabs"][tab_name]
        if not tab then return nil end
    
        local new_section = setmetatable({
            ["tab"] = tab,
            ["name"] = name,
            ["side"] = side,
            ["size"] = size,
            ["total_y_size"] = 10,
            ["elements"] = {}
        }, section)
    
        local tab_frame = tab["frame"]
        local y_position = y_position or 0
    
        local section_border = drawing_proxy["new"]("Image", {
            ["Parent"] = tab_frame,
            ["Position"] = udim2_new(side == 1 and 0 or 0.5, side == 1 and 0 or 5, y_position, y_position ~= 0 and 10 or 0),
            ["Size"] = udim2_new(0.5, -5, size, y_position ~= 0 and - 10 or 0),
            ["Color"] = menu["colors"]["border"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 2,
            ["Visible"] = true,
        })
        local section_inside = drawing_proxy["new"]("Image", {
            ["Parent"] = section_border,
            ["Position"] = udim2_new(0, 1, 0, 0),
            ["Size"] = udim2_new(1, -2, 1, -1),
            ["Color"] = menu["colors"]["section"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 3,
            ["Visible"] = true,
        })
        local section_line = drawing_proxy["new"]("Square", {
            ["Parent"] = section_inside,
            ["Size"] = udim2_new(0, 9, 0, 1),
            ["Position"] = udim2_new(0, 1, 0, 0),
            ["Color"] = menu["colors"]["accent"],
            ["Transparency"] = 0.5,
            ["Filled"] = true,
            ["ZIndex"] = 4,
            ["Visible"] = true,
        })
        local section_label = drawing_proxy["new"]("Text", {
            ["Color"] = menu["colors"]["accent"],
            ["Transparency"] = 0.5,
            ["Text"] = name,
            ["Parent"] = section_inside,
            ["Position"] = udim2_new(0, 15, 0, -8),
            ["Size"] = 12,
            ["Font"] = 1,
            ["ZIndex"] = 4,
            ["Visible"] = true,
        })
        local text_bounds = section_label["TextBounds"]["X"]+20
        local section_line_two = drawing_proxy["new"]("Square", {
            ["Parent"] = section_inside,
            ["Position"] = udim2_new(0, text_bounds, 0, 0),
            ["Size"] = udim2_new(1, -(text_bounds+1), 0, 1),
            ["Color"] = menu["colors"]["accent"],
            ["Filled"] = true,
            ["Transparency"] = 0.5,
            ["ZIndex"] = 4,
            ["Visible"] = true,
        })
        local element_holder = drawing_proxy["new"]("Square", {
            ["Parent"] = section_inside,
            ["Position"] = udim2_new(0, 10, 0, 10),
            ["Size"] = udim2_new(1, -20, 1, -20),
            ["Transparency"] = 0,
            ["Filled"] = true,
            ["Visible"] = true,
        })
    
        new_section["border"] = section_border
        new_section["line_two"] = section_line_two
        new_section["inside"] = section_inside
        new_section["label"] = section_label
        new_section["line"] = section_line
        new_section["holder"] = element_holder
    
        tab["sections"][name] = new_section
    
        return new_section
    end
    
    local panel_section = {}
    panel_section["__index"] = panel_section
    
    function group:create_panel_section(tab_name, name, side, favorites, configs)
        local tab = self["tabs"][tab_name]
        if not tab then return nil end
    
        local new_section = setmetatable({
            ["tab"] = tab,
            ["name"] = name,
            ["total_y_size"] = 30,
            ["scroll_index"] = 1,
            ["elements"] = {},
            ["selected"] = nil,
            ["on_selection_change"] = signal["new"](),
            ["favorites"] = favorites,
            ["configs"] = configs
        }, panel_section)
    
        local tab_frame = tab["frame"]
    
        local section_border = drawing_proxy["new"]("Image", {
            ["Parent"] = tab_frame,
            ["Position"] = udim2_new(side == 1 and 0 or 0.5, side == 1 and 0 or 5, 0, 0),
            ["Size"] = udim2_new(0.5, -5, 1, 0),
            ["Color"] = menu["colors"]["border"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["Visible"] = true,
        })
        local section_inside = drawing_proxy["new"]("Image", {
            ["Parent"] = section_border,
            ["Position"] = udim2_new(0, 1, 0, 0),
            ["Size"] = udim2_new(1, -2, 1, -1),
            ["Color"] = menu["colors"]["section"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["Visible"] = true,
        })
        local section_line = drawing_proxy["new"]("Square", {
            ["Parent"] = section_inside,
            ["Size"] = udim2_new(0, 9, 0, 1),
            ["Position"] = udim2_new(0, 1, 0, 0),
            ["Color"] = menu["colors"]["accent"],
            ["Transparency"] = 0.5,
            ["Filled"] = true,
            ["Visible"] = true,
        })
        local section_label = drawing_proxy["new"]("Text", {
            ["Color"] = menu["colors"]["accent"],
            ["Transparency"] = 0.5,
            ["Text"] = name,
            ["Parent"] = section_inside,
            ["Position"] = udim2_new(0, 15, 0, -8),
            ["Size"] = 12,
            ["Font"] = 1,
            ["Visible"] = true,
        })
        local text_bounds = section_label["TextBounds"]["X"]+20
        local section_line_two = drawing_proxy["new"]("Square", {
            ["Parent"] = section_inside,
            ["Position"] = udim2_new(0, text_bounds, 0, 0),
            ["Size"] = udim2_new(1, -(text_bounds+1), 0, 1),
            ["Color"] = menu["colors"]["accent"],
            ["Filled"] = true,
            ["Transparency"] = 0.5,
            ["Visible"] = true,
        })
        local element_holder = drawing_proxy["new"]("Square", {
            ["Parent"] = section_inside,
            ["Position"] = udim2_new(0, 10, 0, 10),
            ["Size"] = udim2_new(1, -20, 1, -20),
            ["Transparency"] = 0,
            ["Filled"] = true,
            ["Visible"] = true,
        })
        local search_border = drawing_proxy["new"]("Image", {
            ["Parent"] = element_holder,
            ["Position"] = udim2_new(0, 0, 0, 0),
            ["Size"] = udim2_new(1, 0, 0, 20),
            ["Color"] = menu["colors"]["border"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = zindex,
            ["Visible"] = true,
        })
        local search_inside = drawing_proxy["new"]("Image", {
            ["Parent"] = search_border,
            ["Position"] = udim2_new(0, 1, 0, 1),
            ["Size"] = udim2_new(1, -2, 1, -2),
            ["Color"] = menu["colors"]["background"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = zindex,
            ["Visible"] = true,
        })
        local search_text = drawing_proxy["new"]("Text", {
            ["Color"] = menu["colors"]["inactive_text"],
            ["Text"] = "search",
            ["Size"] = 12,
            ["Font"] = 1,
            ["Transparency"] = 1,
            ["Visible"] = true,
            ["Parent"] = search_inside,
            ["Position"] = udim2_new(0, 22, 0, 3),
        })
        local search_image = drawing_proxy["new"]("Image", {
            ["Color"] = menu["colors"]["inactive_text"],
            ["Data"] = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAGdJREFUKFONkGEWgCAIg5GTdP9LlqPBA8Pq+yFuOvA5JHFOuDXGhNvAjPVipgtZAFAGtIuvbrSdRA4sJQQBKB/wOM6V9TevAe+cn6su8liwaieSuwuONy4/k0PdZHglsKOEWD+5QyIX+wJP/y1yP3IAAAAASUVORK5CYII="),
            ["Position"] = udim2_new(0, 4, 0, 4),
            ["Parent"] = search_inside,
            ["Size"] = udim2_new(0, 12, 0, 12),
            ["Transparency"] = 1,
            ["Visible"] = true,
        })
    
        new_section["border"] = section_border
        new_section["line_two"] = section_line_two
        new_section["inside"] = section_inside
        new_section["label"] = section_label
        new_section["line"] = section_line
        new_section["holder"] = element_holder
        new_section["search_image"] = search_image
        new_section["search_border"] = search_border
        new_section["search_inside"] = search_inside
        new_section["search_text"] = search_text
        new_section["search_image"] = search_image
    
        tab["sections"][name] = new_section
    
        create_hover_connection(element_holder, search_border, function()
            if not actives["panel"] then
                tween(search_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
            end
        end, function()
            if not actives["panel"] then
                tween(search_border, {Color = menu["colors"]["border"]}, circular, out, 0.15)
            end
        end)
    
        create_click_connection(element_holder, search_border, function()
            start_panel_search(new_section)
        end)
    
        create_scroll_connection(section_border, section_border, function(is_up)
            local old_scroll_index = new_section["scroll_index"]
            new_section["scroll_index"] = clamp(old_scroll_index + (is_up and -1 or 1), 1, 1 + clamp(#new_section["elements"] - 13, 0, 1000))
            new_section:update_position()
        end)
    
        return new_section
    end

    -- > ( panel sections )

    function panel_section:add_item(info)
        local new_item = setmetatable({
            ["drawings"] = {},
            ["color"] = color,
            ["name"] = info["text"],
            ["parent"] = self["name"],
            ["icons"] = {}
        }, item)

        local border = drawing_proxy["new"]("Image", {
            ["Parent"] = self["holder"],
            ["Position"] = udim2_new(0, 0, 0, self["total_y_size"]),
            ["Size"] = udim2_new(1, 0, 0, 20),
            ["Color"] = menu["colors"]["border"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["Visible"] = false,
        })
        local inside = drawing_proxy["new"]("Image", {
            ["Parent"] = border,
            ["Position"] = udim2_new(0, 1, 0, 1),
            ["Size"] = udim2_new(1, -2, 1, -2),
            ["Color"] = menu["colors"]["background"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 2,
            ["Visible"] = true,
        })
        local text = drawing_proxy["new"]("Text", {
            ["Color"] = menu["colors"]["inactive_text"],
            ["Text"] = info["text"],
            ["Size"] = 12,
            ["Font"] = 1,
            ["Transparency"] = 1,
            ["Visible"] = true,
            ["Parent"] = inside,
            ["ZIndex"] = 3,
            ["Position"] = udim2_new(0, 5, 0, 3),
        })


        new_item["drawings"]["border"] = border
        new_item["drawings"]["inside"] = inside
        new_item["drawings"]["text"] = text

        self["total_y_size"]+=30
        self["elements"][#self["elements"]+1] = new_item

        local icons = info["icons"]
        for i = 1, #icons do
            local icon = icons[i]
            local name = "icon_"..tostring(clock())

            new_item["drawings"][name] = drawing_proxy["new"]("Image", {
                ["Parent"] = inside,
                ["Position"] = udim2_new(0, 4 + (#icons - i)*15, 0, 4),
                ["Size"] = udim2_new(0, 10, 0, 10),
                ["Color"] = menu["colors"]["accent"],
                ["Visible"] = true,
                ["Transparency"] = 1,
                ["ZIndex"] = 4,
                ["Data"] = icon
            })

            new_item["icons"][i] = {icon, name}
        end

        self["scroll_index"] = clamp(self["scroll_index"], 1, 1 + clamp(#self["elements"] - 13, 0, 1000))

        local x = 4 + #(icons)*15
        text["Position"] = udim2_new(0, x, 0, 3)
        local text2_text = info["text2"]
        if text2_text then
            local text2 = drawing_proxy["new"]("Text", {
                ["Color"] = menu["colors"]["dark_text"],
                ["Text"] = text2_text,
                ["Size"] = 12,
                ["Font"] = 1,
                ["Transparency"] = 1,
                ["Visible"] = true,
                ["Parent"] = inside,
                ["ZIndex"] = 4,
                ["Position"] = udim2_new(0, x + text["TextBounds"]["X"] + 3, 0, 3),
            })

            local size = text2["Position"]["X"] + text2["TextBounds"]["X"] + 9
            local border_size = border["Position"]["X"] + border["Size"]["X"]
            if size > border_size then
                local overlap = 2 + math["ceil"]((size-border_size)/6)
                text2["Text"] = text2["Text"]:sub(1, -overlap)..".."
            end
            new_item["drawings"]["text2"] = text2
            new_item["text2"] = text2_text
        end

        self:update_position()

        create_hover_connection(self["holder"], border, function()
            if self["selected"] ~= new_item then
                tween(border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
            end
        end, function()
            if self["selected"] ~= new_item then
                tween(border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
            end
        end)

        if self["favorites"] then
            local flag = info["text"]..self["name"]
            new_item["favorite_flag"] = flag
            new_item["parent"] = self
            local favorited = menu["favorites"][flag]
            if favorited then
                new_item["favorited"] = true
                self:add_icon(info["text"], star)
            end
            create_right_click_connection(self["holder"], border, function(position)
                open_context({menu["favorites"][flag] and 6 or 5}, new_item, position)
            end)
        elseif self["configs"] then
            new_item["parent"] = self
            create_right_click_connection(self["holder"], border, function(position)
                open_context({menu["autoload"] == new_item["name"] and 9 or 8}, new_item, position)
            end)
        end

        create_click_connection(self["holder"], border, function()
            if not self["locked"] then
                local selected = self["selected"]
                if selected ~= new_item then
                    tween(border, {["Color"] = menu["colors"]["highlighted"]}, circular, out, 0.17)
                    self["selected"] = new_item
                    self["on_selection_change"]:Fire(text["Text"])

                    local elements = self["elements"]
                    local index = nil
                    for i = 1, #elements do
                        if elements[i] == new_item then
                            index = i
                        end
                    end

                    local elements = self["elements"]
                    local old_item = elements[1]
                    elements[1] = new_item
                    elements[index or #elements+1] = old_item

                    if selected then
                        tween(selected["drawings"]["border"], {Color = menu["colors"]["border"]}, circular, out, 0.17)
                    end

                    self["scroll_index"] = 1
                    self:update_position()
                else
                    tween(border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                    self["selected"] = nil
                    self["on_selection_change"]:Fire(nil)
                end
            end
        end)

        return new_item
    end

    function panel_section:remove_item(text, delay, skip)
        local elements = self["elements"]
        local holder = self["holder"]
        local object = nil

        for i = 1, #elements do
            local element = elements[i]

            if element and element["drawings"]["text"]["Text"] == text then
                object = element
                if not delay then
                    remove(elements, i)
                end
                break
            end
        end

        if not object then
            return
        end

        local drawings = object["drawings"]
        local frame = drawings["border"]

        local connections = click_connections[holder]

        if connections then
            connections[frame] = nil
        end

        local connections = hover_connections[holder]

        if connections then
            connections[frame] = nil
        end

        local connections = right_click_connections[holder]

        if connections then
            connections[frame] = nil
        end

        for _, drawing in drawings do
            drawing:Destroy()
            drawings[_] = nil
        end

        self["scroll_index"] = clamp(self["scroll_index"], 1, 1 + clamp(#self["elements"] - 13, 0, 1000))

        if not delay then
            self:update_position()
        end

        if self["selected"] == object then
            self["selected"] = nil
            if not skip then
                self["on_selection_change"]:Fire(nil)
            end
        end
    end

    function panel_section:edit_item_color(text, color)
        local elements = self["elements"]
        local object = nil

        for i = 1, #elements do
            local element = elements[i]["drawings"]["text"]

            if element["Text"] == text then
                object = element
                break
            end
        end

        if not object then
            return
        end

        object["Color"] = color
    end

    function panel_section:remove_icon(text, icon)
        local elements = self["elements"]
        local object = nil

        for i = 1, #elements do
            local element = elements[i]
            local label = elements[i]["drawings"]["text"]

            if label["Text"] == text then
                object = element
                break
            end
        end

        if not object then
            return
        end

        local drawings = object["drawings"]
        local icons = object["icons"]

        local has_icon = false

        for i = 1, #icons do
            local icon_data = icons[i]
            if icon_data[1] == icon then
                has_icon = true                
                break
            end
        end

        if not has_icon then
            return
        end

        for i = 1, #icons do
            local icon_data = icons[i]
            if icon_data[1] == icon then
                local name = icon_data[2]
                remove(icons, i)
                drawings[name]:Destroy() 
                drawings[name] = nil
                break
            else
                drawings[icon_data[2]]["tween_position"]-=udim2_new(0, 15, 0, 0)
            end
        end

        drawings["text"]["tween_position"] = udim2_new(0, 5 + (15) * (#icons), 0, 3)

        self:update_position()
    end

    function panel_section:add_icon(text, icon)
        local elements = self["elements"]
        local object = nil

        for i = 1, #elements do
            local element = elements[i]
            local label = elements[i]["drawings"]["text"]

            if label["Text"] == text then
                object = element
                break
            end
        end

        if not object then
            return
        end

        local drawings = object["drawings"]
        local icons = object["icons"]

        for i = 1, #icons do
            drawings[icons[i][2]]["tween_position"]+=udim2_new(0, 15, 0, 0)
        end

        local name = "icon_"..clock()

        drawings[name] = drawing_proxy["new"]("Image", {
            ["Parent"] = drawings["inside"],
            ["Position"] = udim2_new(0, 4, 0, 4),
            ["Size"] = udim2_new(0, 10, 0, 10),
            ["Color"] = menu["colors"]["accent"],
            ["Visible"] = true,
            ["Transparency"] = 1,
            ["ZIndex"] = 4,
            ["Data"] = icon
        })

        icons[#icons+1] = {icon, name}

        drawings["text"]["tween_position"] = udim2_new(0, 5 + (15) * (#icons), 0, 3)

        self:update_position()
    end

    function panel_section:update_position()
        if actives["panel"] then
            return
        end

        local scroll_index = self["scroll_index"]
        local elements = self["elements"]
        local fake_elements = {}

        for i = 1, #elements do
            local element = elements[i]
            if element["favorited"] then
                local frame = elements[i]["drawings"]["border"]
                frame["Visible"] = true
                frame["Position"] = udim2_new(0, 0, 0, 30 + (i - scroll_index) * 30)
                fake_elements[#fake_elements+1] = element
            end
        end

        for i = 1, #elements do
            local element = elements[i]
            if not element["favorited"] then
                fake_elements[#fake_elements+1] = element
            end
        end

        for i = 1, #fake_elements do
            local frame = fake_elements[i]["drawings"]["border"]
            if i >= scroll_index and i < scroll_index + 13 then
                frame["Visible"] = true
                frame["Position"] = udim2_new(0, 0, 0, 30 + (i - scroll_index) * 30)
            else
                frame["Visible"] = false
            end
        end
    end

    -- > ( elements )

    function element.new(info, elements)
        local position = info["position"]
        local parent = info["parent"]

        local frame = drawing_proxy["new"]("Square", {
            ["Parent"] = parent,
            ["Position"] = position,
            ["Size"] = udim2_new(1, -20, 0, 12),
            ["Transparency"] = 0,
            ["Visible"] = true,
        })

        local zindex = parent["ZIndex"] + 1

        local new_element = setmetatable({
            ["drawings"] = {
                ["text"] = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["inactive_text"],
                    ["Text"] = info["text"],
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, -1),
                    ["ZIndex"] = zindex
                })
            },
            ["frame"] = frame,
            ["visible"] = true,
            ["section"] = info["section"],
            ["name"] = info["text"],
            ["old_visible"] = true
        }, element)

        local text = new_element["drawings"]["text"]
        local total_y_size = 17

        for element, properties in elements do
            if element == "toggle" then
                text["tween_position"]+=udim2_new(0, 17, 0, 0)

                local toggle_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, 0),
                    ["Size"] = udim2_new(0, 12, 0, 12),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 1,
                    ["Visible"] = true,
                })
                local toggle_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = toggle_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local toggle_click = drawing_proxy["new"]("Square", {
                    ["Parent"] = frame,
                    ["Size"] = udim2_new(0, 17 + new_element["drawings"]["text"]["TextBounds"]["X"], 1, 0),
                    ["Transparency"] = 0,
                    ["Visible"] = true,
                    ["ZIndex"] = zindex + 3,
                    ["Position"] = udim2_new(0, 0, 0, 0),
                })
                local checkmark = drawing_proxy["new"]("Image", {
                    ["Parent"] = toggle_inside,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Data"] = checkmark_image_data,
                    ["Transparency"] = 0,
                    ["ZIndex"] = zindex + 3,
                    ["Color"] = menu["colors"]["accent"],
                    ["Visible"] = true,
                })

                new_element["drawings"]["toggle_border"] = toggle_border
                new_element["drawings"]["toggle_inside"] = toggle_inside
                new_element["drawings"]["checkmark"] = checkmark

                create_hover_connection(parent, toggle_click, function()
                    tween(toggle_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(toggle_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                end)

                new_element["on_toggle_change"] = signal["new"]()
                new_element["toggle_flag"] = properties["flag"]

                if properties["default"] then
                    new_element:set_toggle(true)
                else
                    flags[properties["flag"]] = false
                end

                create_click_connection(parent, toggle_click, function()
                    new_element:set_toggle(not flags[properties["flag"]])
                end)

                if not info["fake"] then
                    create_right_click_connection(parent, toggle_click, function(position)
                        open_context(keybind_data[new_element] and {2,1} or {1}, new_element, position)
                    end)
                end
            elseif element == "slider" then
                total_y_size+=14

                local slider_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, 14),
                    ["Size"] = udim2_new(1, 0, 0, 12),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 1,
                    ["Visible"] = true,
                })
                local slider_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = slider_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Transparency"] = 1,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local slider_fill = drawing_proxy["new"]("Image", {
                    ["Parent"] = slider_inside,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(0, 0, 1, -2),
                    ["Color"] = menu["colors"]["accent"],
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Transparency"] = 0.5,
                    ["ZIndex"] = zindex + 3,
                    ["Visible"] = true,
                })
                local slider_line = drawing_proxy["new"]("Square", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, text["TextBounds"]["X"] + (elements["toggle"] and 20 or 3), 0, 2),
                    ["Size"] = udim2_new(0, 1, 0, 8),
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Visible"] = true,
                    ["Filled"] = true,
                    ["Transparency"] = 0.5,
                    ["ZIndex"] = zindex + 4,
                })
                local slider_text = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Text"] = "",
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = frame,
                    ["ZIndex"] = zindex + 5,
                    ["Position"] = udim2_new(0, text["TextBounds"]["X"] + (elements["toggle"] and 24 or 7), 0, -1),
                })
                local slider_click = drawing_proxy["new"]("Square", {
                    ["Parent"] = slider_line,
                    ["Position"] = udim2_new(0, 0, 0, -1),
                    ["Size"] = udim2_new(0, 50, 0, 10),
                    ["Transparency"] = 0,
                    ["Filled"] = true,
                    ["ZIndex"] = zindex + 5,
                    ["Visible"] = true,
                })

                new_element["drawings"]["slider_border"] = slider_border
                new_element["drawings"]["slider_inside"] = slider_inside
                new_element["drawings"]["slider_fill"] = slider_fill
                new_element["drawings"]["slider_line"] = slider_line
                new_element["drawings"]["slider_text"] = slider_text

                new_element["on_slider_change"] = signal["new"]()
                new_element["slider_max"] = properties["max"]
                new_element["slider_min"] = properties["min"]
                new_element["slider_min_text"] = properties["min_text"]
                new_element["slider_max_text"] = properties["max_text"]
                new_element["slider_suffix"] = properties["suffix"] or ""
                new_element["slider_decimals"] = properties["decimals"] or 0

                new_element["slider_prefix"] = properties["prefix"] or ""
                new_element["slider_flag"] = properties["flag"]

                create_hover_connection(parent, slider_border, function()
                    tween(slider_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(slider_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                end)

                create_click_connection(parent, slider_click, function()
                    start_typing(slider_text, 100, function(value)
                        if tonumber(value) then
                            new_element:set_slider(value)
                        end
                    end, true, true)
                end)

                create_click_connection(parent, slider_border, function(mouse_position)
                    local min, max, decimals = properties["min"], properties["max"], properties["decimals"]
                    moving = create_connection(mouse["Move"], function()
                        new_element:set_slider(round(min + (max - min) * (get_mouse_location(user_input_service)["X"] - slider_inside["real_position"]["X"])/slider_inside["real_size"]["X"], decimals))
                    end)
                    new_element:set_slider(round(min + (max - min) * (mouse_position["X"] - slider_inside["real_position"]["X"])/slider_inside["real_size"]["X"], decimals))
                end)

                if not info["fake"] then
                    create_right_click_connection(parent, slider_border, function(position)
                        open_context(keybind_data[new_element] and {2,1} or {1}, new_element, position)
                    end)
                end

                new_element:set_slider(properties["default"] or properties["min"])
            elseif element == "textbox" then
                total_y_size+=18

                local textbox_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, 14),
                    ["Size"] = udim2_new(1, 0, 0, 16),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Visible"] = true,
                    ["ZIndex"] = zindex + 1,
                })
                local textbox_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = textbox_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Transparency"] = 1,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local textbox_text = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Text"] = "...",
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = textbox_inside,
                    ["Center"] = false,
                    ["ZIndex"] = zindex + 3,
                    ["Position"] = udim2_new(0, 2, 0, 0),
                })
                new_element["drawings"]["textbox_border"] = textbox_border
                new_element["drawings"]["textbox_inside"] = textbox_inside
                new_element["drawings"]["textbox_text"] = textbox_text

                new_element["on_textbox_change"] = signal["new"]()
                new_element["textbox_flag"] = properties["flag"]

                create_hover_connection(parent, textbox_border, function()
                    tween(textbox_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(textbox_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                end)

                create_click_connection(parent, textbox_border, function()
                    start_typing(textbox_text, textbox_border["real_size"]["X"] - 15, function(value)
                        new_element:set_textbox(tostring(value))
                    end, false, true, true, true)
                end)

                new_element:set_textbox(properties["default"] or nil)
            elseif element == "dropdown" then
                total_y_size+=18

                local dropdown_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, 14),
                    ["Size"] = udim2_new(1, 0, 0, 16),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Visible"] = true,
                    ["ZIndex"] = zindex + 1,
                })
                local dropdown_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = dropdown_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Transparency"] = 1,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local dropdown_text = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Text"] = "none",
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = dropdown_inside,
                    ["Center"] = false,
                    ["ZIndex"] = zindex + 3,
                    ["Position"] = udim2_new(0, 3, 0, 0),
                })
                local dropdown_arrow = drawing_proxy["new"]("Image", {
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Data"] = arrow_image_data,
                    ["Size"] = udim2_new(0, 8, 0, 8),
                    ["Position"] = udim2_new(1, -11, 0.5, -4),
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["ZIndex"] = zindex + 3,
                    ["Parent"] = dropdown_inside,
                })

                new_element["drawings"]["dropdown_border"] = dropdown_border
                new_element["drawings"]["dropdown_inside"] = dropdown_inside
                new_element["drawings"]["dropdown_arrow"] = dropdown_arrow
                new_element["drawings"]["dropdown_text"] = dropdown_text
                new_element["on_dropdown_change"] = signal["new"]()
                new_element["dropdown_flag"] = properties["flag"]
                new_element["multi"] = properties["multi"]
                new_element["requires_one"] = properties["requires_one"]

                new_element["options"] = properties["options"]

                create_hover_connection(parent, dropdown_border, function()
                    tween(dropdown_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                    tween(dropdown_arrow, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(dropdown_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                    tween(dropdown_arrow, {Color = menu["colors"]["dark_text"]}, circular, out, 0.17)
                end)

                local extensions = properties["use_custom_extensions"]
                if extensions then
                    local original_options = properties["options"]
                    local new_options = {}

                    for i = 1, #original_options do
                        new_options[#new_options + 1] = original_options[i]
                    end

                    for _, file in listfiles("juju recode/custom") do
                        local extension = file:match("%.([^%.]+)$")

                        if extension then
                            for i = 1, #extensions do
                                if extensions[i] == extension then
                                    local file_name = file:match("([^/\\]+)$")
                                    local found = false
                                    for i = 1, #original_options do
                                        if original_options[i] == file_name then
                                            found = true 
                                            break
                                        end
                                    end
                                    if not found then
                                        new_options[#new_options + 1] = file_name
                                    end
                                    break
                                end
                            end
                        end
                    end

                    new_element["options"] = new_options

                    create_click_connection(parent, dropdown_border, function()
                        local original_options = properties["options"]
                        local new_options = {}
    
                        for i = 1, #original_options do
                            new_options[#new_options + 1] = original_options[i]
                        end
    
                        for _, file in listfiles("juju recode/custom") do
                            local extension = file:match("%.([^%.]+)$")
    
                            if extension then
                                for i = 1, #extensions do
                                    if extensions[i] == extension then
                                        local file_name = file:match("([^/\\]+)$")
                                        local found = false
                                        for i = 1, #original_options do
                                            if original_options[i] == file_name then
                                                found = true 
                                                break
                                            end
                                        end
                                        if not found then
                                            new_options[#new_options + 1] = file_name
                                        end
                                        break
                                    end
                                end
                            end
                        end
    
                        new_element["options"] = new_options

                        open_dropdown(new_element)
                    end)
                else
                    create_click_connection(parent, dropdown_border, function()
                        open_dropdown(new_element)
                    end)
                end

                if not info["fake"] then
                    create_right_click_connection(parent, dropdown_border, function(position)
                        open_context(keybind_data[new_element] and {2,1} or {1}, new_element, position)
                    end)
                end

                local default = properties["default"]
                new_element["dropdown_default"] = default
                new_element["requires_one"] = properties["requires_one"]

                if default then
                    new_element:set_dropdown(default)
                end
            elseif element == "keybind" then
                local keybind_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(1, -40, 0, 0),
                    ["Size"] = udim2_new(0, 40, 0, 12),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 1,
                    ["Visible"] = true,
                })
                local keybind_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = keybind_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local keybind_text = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Text"] = "none",
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = keybind_inside,
                    ["Center"] = true,
                    ["ZIndex"] = zindex + 3,
                    ["Position"] = udim2_new(0.5, 0, 0, -1),
                })

                local size = keybind_text["TextBounds"]["X"] + 8

                keybind_border["Size"] = udim2_new(0, size, 0, 12)
                keybind_border["Position"] = udim2_new(1, -size, 0, 0)
                keybind_inside["Size"] = udim2_new(0, size-2, 0, 10)

                new_element["drawings"]["keybind_border"] = keybind_border
                new_element["drawings"]["keybind_inside"] = keybind_inside
                new_element["drawings"]["keybind_text"] = keybind_text
                new_element["on_key_change"] = signal["new"]()
                new_element["on_key_press"] = signal["new"]()

                create_hover_connection(parent, frame, function()
                    tween(keybind_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(keybind_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                end)

                create_click_connection(parent, frame, function()
                    start_binding(new_element)
                end)

                if properties["flag"] then
                    new_element["keybind_flag"] = properties["flag"]

                    local data = math_random(9000000,90000000)
                    keybind_data[data] = {
                        ["key"] = properties["default"],
                        ["value"] = true,
                        ["original_value"] = false,
                        ["set_activated"] = function()
                            new_element["on_key_press"]:Fire()
                        end
                    }
                    create_connection(new_element["on_key_change"], function(key)
                        keybind_data[data]["key"] = key
                        flags[properties["flag"]] = key
                    end)
                end
            elseif element == "colorpicker" then
                local transparency = properties["default_transparency"] or 0
                local color = properties["default_color"] or color3_fromrgb(255, 0, 0)

                local colorpicker_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(1, -25, 0, 0),
                    ["Size"] = udim2_new(0, 25, 0, 12),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 1,
                    ["Visible"] = true,
                })
                local colorpicker_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = colorpicker_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local colorpicker_transparency = drawing_proxy["new"]("Image", {
                    ["Parent"] = colorpicker_inside,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = color3_fromrgb(255, 255, 255),
                    ["Transparency"] = -transparency+1,
                    ["Rounding"] = 4,
                    ["Data"] = transparency_image_data,
                    ["ZIndex"] = zindex + 3,
                    ["Visible"] = true,
                })
                local colorpicker_fill = drawing_proxy["new"]("Image", {
                    ["Parent"] = colorpicker_transparency,
                    ["Position"] = udim2_new(0, 0, 0, 0),
                    ["Size"] = udim2_new(1, 0, 1, 0),
                    ["Color"] = color,
                    ["Transparency"] = 1,
                    ["Rounding"] = 2,
                    ["Data"] = pixel_image_data,
                    ["ZIndex"] = zindex + 3,
                    ["Visible"] = true,
                })

                new_element["drawings"]["colorpicker_transparency"] = colorpicker_transparency
                new_element["drawings"]["colorpicker_border"] = colorpicker_border
                new_element["drawings"]["colorpicker_inside"] = colorpicker_inside
                new_element["drawings"]["colorpicker_fill"] = colorpicker_fill

                new_element["transparency_flag"] = properties["transparency_flag"]
                new_element["color_flag"] = properties["color_flag"]
                new_element["on_transparency_change"] = signal["new"]()
                new_element["on_color_change"] = signal["new"]()

                create_hover_connection(parent, colorpicker_border, function()
                    tween(colorpicker_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(colorpicker_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                end)

                create_click_connection(parent, colorpicker_border, function()
                    open_colorpicker(new_element)
                end)

                create_right_click_connection(parent, colorpicker_border, function(position)
                    open_context({7,3,4}, new_element, position)
                end)

                new_element:set_colorpicker(properties["default_color"] or color3_fromrgb(255, 0, 0))
                new_element:set_colorpicker_transparency(properties["default_transparency"] or 0)
            elseif element == "info" then
                new_element["drawings"]["info_text"] = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["inactive_text"],
                    ["Text"] = "",
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, -1),
                    ["ZIndex"] = zindex + 1
                })
            elseif element == "button" then
                total_y_size+=4
                local button_border = drawing_proxy["new"]("Image", {
                    ["Parent"] = frame,
                    ["Position"] = udim2_new(0, 0, 0, 0),
                    ["Size"] = udim2_new(1, 0, 0, 16),
                    ["Color"] = menu["colors"]["border"],
                    ["Transparency"] = 1,
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Visible"] = true,
                    ["ZIndex"] = zindex + 1,
                })
                local button_inside = drawing_proxy["new"]("Image", {
                    ["Parent"] = button_border,
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Color"] = menu["colors"]["background"],
                    ["Rounding"] = 4,
                    ["Data"] = pixel_image_data,
                    ["Transparency"] = 1,
                    ["ZIndex"] = zindex + 2,
                    ["Visible"] = true,
                })
                local button_icon = drawing_proxy["new"]("Image", {
                    ["Parent"] = button_border,
                    ["Position"] = udim2_new(1, -14, 0, 3),
                    ["Size"] = udim2_new(0, 10, 0, 10),
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Rounding"] = 4,
                    ["Data"] = button_image_data,
                    ["Transparency"] = 1,
                    ["ZIndex"] = zindex + 3,
                    ["Visible"] = true,
                })
                local button_text = drawing_proxy["new"]("Text", {
                    ["Color"] = menu["colors"]["dark_text"],
                    ["Text"] = info["text"],
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["Transparency"] = 1,
                    ["Visible"] = true,
                    ["Parent"] = button_inside,
                    ["Center"] = false,
                    ["ZIndex"] = zindex + 3,
                    ["Position"] = udim2_new(0, 3, 0, 0),
                })

                local cooldown = clock()

                new_element["on_clicked"] = signal["new"]()

                local drawings = new_element["drawings"]
                drawings["button_border"] = button_border
                drawings["button_inside"] = button_inside
                drawings["button_text"] = button_text
                drawings["button_icon"] = button_icon
                drawings["text"]["Text"] = ""

                create_hover_connection(parent, button_border, function()
                    tween(button_border, {Color = menu["colors"]["highlighted"]}, circular, out, 0.17)
                end, function()
                    tween(button_border, {Color = menu["colors"]["border"]}, circular, out, 0.17)
                end)

                if properties["confirmation"] then
                    local in_confirmation = false

                    create_click_connection(parent, button_border, function()
                        if clock() - cooldown > 0.15 and not actives["typing"] then
                            cooldown = clock()
                            if in_confirmation then
                                new_element["on_clicked"]:Fire()
                                tween(button_inside, {Color = color3_fromrgb(40, 40, 40)}, circular, out, 0.075)
                                delay(0.075, function()
                                    tween(button_inside, {Color = menu["colors"]["background"]}, circular, out, 0.075)
                                end)
                                tween(button_text, {["Color"] = menu["colors"]["dark_text"]}, circular, out, 0.075)
                                tween(button_text, {["tween_position"] = udim2_new(0, 3, 0, 0)}, circular, out, 0.075)
                                in_confirmation = false
                            else
                                tween(button_text, {Color = menu["colors"]["accent"]}, circular, out, 0.075)
                                local old = cooldown
                                in_confirmation = cooldown
                                for i = 1, 3 do
                                    if in_confirmation ~= old then
                                        break
                                    end
                                    button_text["Text"] = "are you sure? ("..(4-i).."s left)"
                                    tween(button_text, {["tween_position"] = udim2_new(0, 3, 0, -1)}, circular, out, 0.075)
                                    wait(0.075)
                                    if in_confirmation ~= old then
                                        break
                                    end
                                    tween(button_text, {["tween_position"] = udim2_new(0, 3, 0, 0)}, circular, out, 0.075)
                                    wait(0.925)
                                end
                                button_text["Text"] = info["text"]
                                tween(button_text, {["Color"] = menu["colors"]["dark_text"]}, circular, out, 0.075)
                                tween(button_text, {["tween_position"] = udim2_new(0, 3, 0, 0)}, circular, out, 0.075)
                                in_confirmation = false
                            end
                        end
                    end)
                else
                    create_click_connection(parent, button_border, function()
                        if clock() - cooldown > 0.15 then
                            cooldown = clock()
                            new_element["on_clicked"]:Fire()
                            tween(button_inside, {Color = color3_fromrgb(40, 40, 40)}, circular, out, 0.075)
                            delay(0.075, function()
                                tween(button_inside, {Color = menu["colors"]["background"]}, circular, out, 0.075)
                            end)
                        end
                    end)

                    if not info["fake"] then
                        create_right_click_connection(parent, button_border, function(position)
                            open_context(keybind_data[new_element] and {2,1} or {1}, new_element, position)
                        end)
                    end
                end
            end
        end

        local tip = info["tip"]

        if tip then
            create_hover_connection(parent, button_border, function()
                show_tooltip(new_element, tip)
            end, function()
                hide_tooltip(new_element, tip)
            end)
        end

        new_element["total_y_size"] = total_y_size

        frame["Size"] = udim2_new(1, -20, 0, total_y_size)

        return new_element, total_y_size
    end

    function element:set_info(property, value)
        local text = self["drawings"]["info_text"]
        text[property] = value

        if property == "Text" then
            text["Position"] = udim2_new(1, -text["TextBounds"]["X"], 0, -1)
        end
    end

    function element:set_options(options)
        self:set_dropdown()
        self["options"] = options
    end

    function element:set_toggle(value, just_keybind)
        local keybind = keybind_data[self]
        if keybind then
            if not just_keybind then
                local is_on_not_held = keybind["method"] == 2
                keybind["value"] = value
                keybind["activated"] = is_on_not_held or value
                spawn(on_keybind_change["Fire"], on_keybind_change, keybind, self, is_on_not_held or value)

                if is_on_not_held then
                    return
                end
            end
        end

        local drawings = self["drawings"]
        tween(drawings["text"], {Color = value and menu["colors"]["active_text"] or menu["colors"]["inactive_text"]}, exponential, out, 0.2)
        tween(drawings["checkmark"], {Transparency = value and 0.5 or 0}, exponential, out, 0.2)

        flags[self["toggle_flag"]] = value
        self["on_toggle_change"]:Fire(value)
    end

    function element:set_slider(value, just_keybind)
        local drawings = self["drawings"]
        local max = self["slider_max"]
        local min = self["slider_min"]
        value = clamp(value, min, max)

        tween(drawings["slider_fill"], {tween_size = udim2_new((value - min) / (max - min), value == max and -2 or 0, 1, -2)}, exponential, out, 0.2)

        local text = drawings["slider_text"]
        if value == min then
            tween(drawings["slider_line"], {Color = menu["colors"]["dark_text"]}, circular, out, 0.2)
            text["Text"] = self["slider_min_text"] or self["slider_prefix"]..value..self["slider_suffix"]
        else
            tween(drawings["slider_line"], {Color = menu["colors"]["accent"]}, circular, out, 0.2)
            text["Text"] = (value == max and self["slider_max_text"]) or self["slider_prefix"]..value..self["slider_suffix"]
        end

        local keybind = keybind_data[self]

        if keybind then
            if not just_keybind then
                keybind["original_value"] = value
            end
        end

        flags[self["slider_flag"]] = value
        self["on_slider_change"]:Fire(value)
    end

    function element:set_textbox(value)
        flags[self["textbox_flag"]] = value
        self["drawings"]["textbox_text"]["Text"] = value == nil and "..." or value == "" and "..." or value
        self["on_textbox_change"]:Fire(value)
    end

    function element:set_colorpicker(value)
        flags[self["color_flag"]] = value
        self["drawings"]["colorpicker_fill"]["Color"] = value

        self["on_color_change"]:Fire(value)
    end

    function element:set_colorpicker_transparency(value)
        flags[self["transparency_flag"]] = value
        self["drawings"]["colorpicker_fill"]["Transparency"] = -value+1

        self["on_transparency_change"]:Fire(value)
    end

    function element:set_dropdown(value, just_keybind, no_fire)
        local drawings = self["drawings"]
        local dropdown_text = drawings["dropdown_text"]
        local max_textbounds = drawings["dropdown_inside"]["real_size"]["X"]

        local text = ""
        local last_text = ""

        value = type(value) == "table" and value or {value}

        local options = self["options"]

        for i = 1, #value do
            local option = value[i]
            local found = false
            for i = 1, #options do
                if options[i] == option then
                    found = true
                    break
                end
            end
            if not found then
                for i = 1, #value do
                    if value[i] == option then
                        remove(value, i)
                        break
                    end
                end
            end
        end

        if value and #value ~= 0 then
            for i = 1, #value do
                local option = value[i]
                text = i == 1 and option or text .. ", " .. option
                dropdown_text["Text"] = text

                if dropdown_text["TextBounds"]["X"] + 8 > max_textbounds then
                    dropdown_text["Text"] = last_text.."..."
                    break
                end

                last_text = text
            end
        else
            dropdown_text["Text"] = "none"
        end

        local keybind = keybind_data[self]

        if keybind then
            if not just_keybind then
                keybind["original_value"] = value
            end
        end

        flags[self["dropdown_flag"]] = value

        if not no_fire then
            self["on_dropdown_change"]:Fire(value)
        end
    end

    function element:update_dropdown_value(option)
        local value = flags[self["dropdown_flag"]]
        local multi = self["multi"]
        local requires_one = self["requires_one"]

        if multi then
            local count = value and #value or 0
            for i = 1, count do
                if value[i] == option then
                    if requires_one and count == 1 then
                        return nil
                    end

                    remove(value, i)

                    self:set_dropdown(value)

                    return false
                end
            end

            if value then
                value[#value+1] = option
            else
                value = {option}
                flags[self["dropdown_flag"]] = value
            end

            self:set_dropdown(value)

            return true
        else
            if value and option == value[1] then
                if requires_one then
                    return nil
                end

                self:set_dropdown(nil)

                return false
            else
                self:set_dropdown({option})

                return true
            end
        end
    end

    function element:set_key(value)
        local drawings = self["drawings"]
        local keybind_border = drawings["keybind_border"]
        local keybind_inside = drawings["keybind_inside"]
        local keybind_text = drawings["keybind_text"]

        keybind_text["Text"] = value and (shortened_characters[value] and shortened_characters[value] or value["Name"]:lower()) or "none"

        local size = keybind_text["TextBounds"]["X"] + 8

        keybind_border["Size"] = udim2_new(0, size, 0, 12)
        keybind_border["Position"] = udim2_new(1, -size, 0, 0)
        keybind_inside["Size"] = udim2_new(0, size-2, 0, 10)
        keybind_text["Position"] = udim2_new(0, (size-2)/2, 0, -2)

        local flag = self["keybind_flag"]

        if flag then
            flags[flag] = value
        end

        self["on_key_change"]:Fire(value)
    end

    local settings = {}
    settings["__index"] = settings

    function settings:create_element(a,b,c)
        return self["sections"][a["section"] or 1]:create_element(a,b,c)
    end

    function element:create_settings(count)
        local frame = self["frame"]
        local cog_icon = drawing_proxy["new"]("Image", {
            ["Data"] = cog_image_data,
            ["Visible"] = true,
            ["Transparency"] = 1,
            ["Color"] = menu["colors"]["inactive_text"],
            ["Size"] = udim2_new(0, 10, 0, 10),
            ["Position"] = udim2_new(1, -10, 0, 1),
            ["ZIndex"] = frame["ZIndex"] + 4,
            ["Parent"] = frame
        })

        self["drawings"]["cog_icon"] = cog_icon

        create_hover_connection(frame, cog_icon, function()
            tween(cog_icon, {["Color"] = menu["colors"]["highlighted"]}, circular, out, 0.17)
        end, function()
            tween(cog_icon, {Color = menu["colors"]["inactive_text"]}, circular, out, 0.17)
        end)

        local section_border = drawing_proxy["new"]("Image", {
            ["Parent"] = cog_icon,
            ["Position"] = udim2_new(1, 5, 0, -5),
            ["Size"] = udim2_new(0, 170, 0, 10),
            ["Color"] = menu["colors"]["border"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 500,
            ["Visible"] = false,
        })
        local section_inside = drawing_proxy["new"]("Image", {
            ["Parent"] = section_border,
            ["Position"] = udim2_new(0, 1, 0, 1),
            ["Size"] = udim2_new(1, -2, 1, -2),
            ["Color"] = menu["colors"]["section"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 501,
            ["Visible"] = true,
        })

        local new_settings = setmetatable({
            ["sections"] = {},
            ["elements"] = {},
            ["border"] = section_border,
            ["inside"] = section_inside
        }, settings)

        for i = 1, type(count) == "number" and count or 1 do
            local new_section = setmetatable({
                ["tab"] = self["section"]["tab"],
                ["total_y_size"] = 10,
                ["frame"] = self["frame"],
                ["elements"] = new_settings["elements"]
            }, section)

            local element_holder = drawing_proxy["new"]("Square", {
                ["Parent"] = section_inside,
                ["Position"] = udim2_new(0, 10 + i * 180, 0, 10),
                ["Size"] = udim2_new(1, -20, 1, -20),
                ["Transparency"] = 0,
                ["Filled"] = true,
                ["ZIndex"] = 502,
                ["Visible"] = true,
            })

            new_section["border"] = section_border
            new_section["inside"] = section_inside
            new_section["holder"] = element_holder

            new_settings["sections"][i] = new_section
        end

        create_click_connection(self["frame"], cog_icon, function()
            if actives["settings"] == new_settings then
                close_settings(new_settings)
            else
                open_settings(new_settings)
            end
        end)

        menu["settings"][self] = new_settings

        return new_settings
    end

    function element:remove()
        local parent = self["parent"]
        local object = self["frame"]

        local connections = click_connections[parent]

        if connections then
            connections[object] = nil
        end

        local connections = hover_connections[parent]

        if connections then
            connections[object] = nil
        end

        local connections = right_click_connections[parent]

        if connections then
            connections[object] = nil
        end

        local drawings = self["drawings"]

        for _, drawing in drawings do
            drawing:Destroy()
            drawings[_] = nil
        end

        local section = self["section"]
        local elements = section["elements"]

        for i = 1, #elements do
            if elements[i] == self then
                remove(elements, i)
                break
            end
        end

        section:recalculate_size()
    end

    function element:set_visible(visible, old)
        if not old then
            self["old_visible"] = visible
        end
        self["visible"] = visible
        self["frame"]["Visible"] = visible
        self["section"]:recalculate_size()
    end

    function section:create_element(info, elements, fake)
        local position = self["total_y_size"]
        local new_element, total_y_size = element["new"]({
            ["text"] = info["name"],
            ["parent"] = self["inside"],
            ["position"] = udim2_new(0, 10, 0, position),
            ["fake"] = fake,
            ["old_visible"] = true,
            ["section"] = self
        }, elements)

        self["total_y_size"]+=total_y_size

        self["elements"][#self["elements"]+1] = new_element

        if not self["side"] then
            self["border"]["Size"] = udim2_new(0, 170, 0, self["total_y_size"] + 7)
            self["inside"]["Size"] = udim2_new(1, -2, 1, -2)
        end

        return new_element
    end

    function section:recalculate_size()
        local elements = self["elements"]
        local total_size = 10

        for i = 1, #elements do
            local element = elements[i]
            if element["visible"] then
                element["frame"]["Position"] = udim2_new(0, 10, 0, total_size)
                total_size+=element["total_y_size"]
            end
        end

        if not self["side"] then
            self["border"]["Size"] = udim2_new(0, 170, 0, total_size + 7)
            self["inside"]["Size"] = udim2_new(1, -2, 1, -2)
        end

        self["total_y_size"] = total_size
    end

    function section:destroy()
        if not self["border"] then 
            return 
        end
        for _, element in self["elements"] do
            element:remove()
        end
        for _, drawing in self do
            local type = typeof(drawing)
            if (type == "Drawing" or type == "Table") and rawget(drawing, "Destroy") then
                drawing["Destroy"](drawing)
                self[_] = nil
            end
        end
    end

    -- > ( notifications )

    local notification_types = {
        [1] = {
            color3_fromrgb(174, 255, 0),
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAFFJREFUOE/NzEsOgCAMRdGy/0UrlxSDtY90RDwD/hc7rvlccnW+rIdrhFL4ieBrKYvGzDAv40cqQlOXuwjpoyhGeA5UnEV4HcZYRSli+PY3zG4fbDP68uskQAAAAABJRU5ErkJggg==")
        },
        [2] = {
            color3_fromrgb(255, 225, 0),
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADdYAAA3WAZBveZwAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAiF8BAOgDAACIXwEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAAC1cWHl18YwawAAAGdJREFUOE+dkUsOgDAIRMWd9z+sSxUyNAKZ/t5mSmBKoQfjAQgLAg1kg3zg2Dihy5Sb2PNyV9pRCxWEhWBk3ZSca8aeyfnXbC/HjDPdHK+14VeMim2tY7qgNzRAjf4VNM8SIzZnFHkB8alA8IwiGIYAAAAASUVORK5CYII=")
        },
        [3] = {
            color3_fromrgb(255, 60, 63),
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAPgAAAD4ABMkKt4wAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADMiQEA6AMAAMyJAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAAd06aoHBh5lAAAAPElEQVQYV22LQQ4AMAjC8P+fHqg4l4yDthERQHRIUGzONd9rGTLk9SRcb38tc7mFkRpy5VTtKY1zltERByNGAFUDKq+CAAAAAElFTkSuQmCC")
        },
        [4] = {
            color3_fromrgb(255, 60, 63),
            base64_decode("iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOwgAADsIBFShKgAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADydgEA6AMAAPJ2AQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAI47wVfTF7xOAAAAP0lEQVQYV22NSQoAIBDDnP9/WpNW8GBwaZyCa2TdO+choQJRgouM2vN2UFLx1V0eNQUkk9rnI4IQ21OuUj7MbDBmAHXXCP83AAAAAElFTkSuQmCC")
        }
    }

    do
        local update_notifications = LPH_NO_VIRTUALIZE(function()
            local notifications = menu["notifications"]
            local size = camera["ViewportSize"]["Y"]*0.88
            if #notifications > 6 then
                notifications[1]:dismiss()
            end
            for i = 1, #notifications do
                local notification = notifications[i]
                local inside = notification["inside"]
                local position = inside["Position"]
                local new_position = udim2_new(0, position["X"], 0, size - (i*29))
                if position ~= new_position then
                    tween(inside, {tween_position = new_position}, exponential, out, 0.14)
                end
            end
        end)

        local colors = menu["colors"]

        local notification = {}
        notification["__index"] = notification
        
        menu["new_notification"] = function(text, type, time, data)
            if do_notifications then
                local color = typeof(time) == "Color3" and time or (type == 1 and colors["success"]) or (type == 2 and colors["alert"]) or (type == 3 and colors["error"]) or colors["accent"]
                local inside = drawing_proxy["new"]("Image", {
                    ["Data"] = pixel_image_data,
                    ["Rounding"] = 7,
                    ["Size"] = udim2_new(1, -2, 1, -2),
                    ["Position"] = udim2_new(0, 1, 0, 1),
                    ["Color"] = colors["background"],
                    ["Transparency"] = 0,
                    ["ZIndex"] = 1101,
                    ["Visible"] = true,
                })
                local image = drawing_proxy["new"]("Image", {
                    ["Parent"] = inside,
                    ["Position"] = udim2_new(0, 5, 0, 5),
                    ["Size"] = udim2_new(0, 12, 0, 12),
                    ["Color"] = color,
                    ["Transparency"] = 0,
                    ["Data"] = data or notification_types[type][2],
                    ["Rounding"] = 4,
                    ["ZIndex"] = 1102,
                    ["Visible"] = true,
                })
                local text = drawing_proxy["new"]("Text", {
                    ["Parent"] = inside,
                    ["Position"] = udim2_new(0, 26, 0, 5),
                    ["Color"] = colors["active_text"],
                    ["Text"] = text,
                    ["Size"] = 12,
                    ["Font"] = 1,
                    ["ZIndex"] = 1102,
                    ["Transparency"] = 0,
                    ["Visible"] = true,
                })
                local shadow = drawing_proxy["new"]("Image", {
                    ["Parent"] = inside,
                    ["Data"] = shadow_image_data,
                    ["Rounding"] = 8,
                    ["Color"] = color,
                    ["Transparency"] = 0,
                    ["ZIndex"] = 1100,
                    ["Visible"] = true,
                    ["Position"] = udim2_new(0, 0, 0, 0),
                })

                local x_size = 32 + text["TextBounds"]["X"]
                local size = udim2_new(0, x_size, 0, 24)

                inside["Size"] = size

                local shadow_size = floor(x_size/13)
                shadow["Size"] = size + udim2_new(0, shadow_size, 0, 6)
                shadow["Position"] = udim2_new(0, -shadow_size/2, 0, -3)

                local new_notification = setmetatable({
                    ["inside"] = inside,
                    ["image"] = image,
                    ["text"] = text,
                    ["shadow"] = shadow,
                    ["start"] = clock(),
                    ["active"] = true
                }, notification)

                delay(clamp(time and typeof(time) == "number" and time or 2, 0.5, 7), function()
                    if new_notification["active"] then
                        new_notification:dismiss()
                    end
                end)

                local notifications = menu["notifications"]
                local viewport_size = camera["ViewportSize"]

                inside["Position"] = udim2_new(0, (viewport_size["X"]*0.5) - (x_size*0.5), 0, viewport_size["Y"]*0.88 - (#notifications*29 - 5))

                tween(inside, {Transparency = 0.89}, circular, out, 0.12)
                tween(image, show_transparency, circular, out, 0.12)
                tween(text, show_transparency, circular, out, 0.12)
                tween(shadow, {Transparency = 0.16}, circular, out, 0.12)

                notifications[#notifications+1] = new_notification

                spawn(update_notifications)
            end
        end

        function notification:dismiss()
            local inside = self["inside"]
            local image = self["image"]
            local text = self["text"]
            local shadow = self["shadow"]
            tween(inside, hide_transparency, circular, out, 0.12)
            tween(image, hide_transparency, circular, out, 0.12)
            tween(text, hide_transparency, circular, out, 0.12)
            tween(shadow, hide_transparency, circular, out, 0.12)
            self["active"] = false

            local notifications = menu["notifications"]
            for i = 1, #notifications do
                if notifications[i] == self then
                    remove(notifications, i)
                    break
                end
            end

            delay(0.12, function()
                inside:Destroy()
                image:Destroy()
                text:Destroy()
                shadow:Destroy()
                spawn(update_notifications)
            end)
        end
    end

    -- > ( finalization )

    do
        -- >> ( menu finalization )

        keybind_section = setmetatable({
            ["name"] = name,
            ["side"] = side,
            ["size"] = size,
            ["total_y_size"] = 10,
            ["holder"] = keybind_holder,
            ["border"] = keybind_border,
            ["inside"] = keybind_inside,
            ["elements"] = {}
        }, section)

        create_hover_connection(list_frame, list_frame, function()
            tween(list_frame, {Color = menu["colors"]["highlighted"], Transparency = 1}, circular, out, 0.15)
        end, function()
            tween(list_frame, {Color = menu["colors"]["border"], Transparency = 0.2}, circular, out, 0.15)
        end)

        menu.set_accent_color = LPH_JIT_MAX(function(color)
            menu["colors"]["accent"] = color

            tab_line["Color"] = color
            drag_logo["Color"] = color
            for name, group in menu["groups"] do
                group["text"]["Color"] = color
                group["line"]["Color"] = color

                for name, tab in group["tabs"] do
                    for _, section in tab["sections"] do
                        section["line_two"]["Color"] = color
                        section["line"]["Color"] = color
                        section["label"]["Color"] = color

                        for _, element in section["elements"] do
                            local drawings = element["drawings"]
                            local checkmark = drawings["checkmark"]
                            local slider_fill = drawings["slider_fill"]
                            local slider_text = drawings["slider_text"]

                            local icons = element["icons"]

                            if icons then
                                for i = 1, #icons do
                                    local icon = icons[i]
                                    drawings[icon[2]]["Color"] = color
                                end
                            end

                            if slider_fill then
                                slider_fill["Color"] = color

                                if flags[element["slider_flag"]] > element["slider_min"] then
                                    drawings["slider_line"]["Color"] = color
                                end
                            end

                            if checkmark then
                                checkmark["Color"] = color
                            end
                        end
                    end
                end
            end

            for _, settings in menu["settings"] do
                for _, element in settings["elements"] do
                    local drawings = element["drawings"]
                    local checkmark = drawings["checkmark"]
                    local slider_fill = drawings["slider_fill"]

                    if slider_fill then
                        slider_fill["Color"] = color

                        if flags[element["slider_flag"]] > element["slider_min"] then
                            drawings["slider_line"]["Color"] = color
                        end
                    end

                    if checkmark then
                        checkmark["Color"] = color
                    end
                end
            end

            for i = 1, #context_buttons do
                context_buttons[i]["icon"]["Color"] = color
            end

            list_divider["Color"] = color
            list_icon["Color"] = color

            for _, drawing in list_drawings do
                drawing["value"]["Color"] = color
            end
        end)

        -- >> ( config system )

        local function to_base64(input)
            local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local encoded = ""
            local padding = 0

            while #input % 3 ~= 0 do
                input = input .. "\0"
                padding = padding + 1
            end

            for i = 1, #input, 3 do
                local a, b, c = string["byte"](input, i, i + 2)
                local n = a * 2^16 + (b or 0) * 2^8 + (c or 0)
                encoded = encoded .. string["sub"](charset, math.floor(n / 2^18) % 64 + 1, math.floor(n / 2^18) % 64 + 1)
                encoded = encoded .. string["sub"](charset, math.floor(n / 2^12) % 64 + 1, math.floor(n / 2^12) % 64 + 1)
                encoded = encoded .. string["sub"](charset, math.floor(n / 2^6) % 64 + 1, math.floor(n / 2^6) % 64 + 1)
                encoded = encoded .. string["sub"](charset, n % 64 + 1, n % 64 + 1)
            end

            return string["sub"](encoded, 1, #encoded - padding) .. string["rep"]("=", padding)
        end

        local function from_base64(input)
            local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local decoded = ""
            input = string["gsub"](input, "=", "")

            for i = 1, #input, 4 do
                local a, b, c, d = string["find"](charset, string["sub"](input, i, i)) - 1,
                                   string["find"](charset, string["sub"](input, i + 1, i + 1)) - 1,
                                   string["find"](charset, string["sub"](input, i + 2, i + 2)) - 1 or 0,
                                   string["find"](charset, string["sub"](input, i + 3, i + 3)) - 1 or 0
                local n = a * 2^18 + b * 2^12 + c * 2^6 + d
                decoded = decoded .. string["char"](math.floor(n / 2^16) % 256)
                decoded = decoded .. string["char"](math.floor(n / 2^8) % 256)
                decoded = decoded .. string["char"](n % 256)
            end

            return string["gsub"](decoded, "%z", "")
        end

        local function xor_crypt(input, key)
            local output = {}
            for i = 1, #input do
                local key_byte = string["byte"](key, (i - 1) % #key + 1)
                local xored = bit32["bxor"](string["byte"](input, i), key_byte)
                table.insert(output, string["char"](xored))
            end
            return table.concat(output)
        end

        local function shuffle_key(key)
            local shuffled = {}
            for i = 1, #key do
                table.insert(shuffled, string["sub"](key, i, i))
            end
            for i = #shuffled, 2, -1 do
                local j = math_random(i)
                shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
            end
            return table.concat(shuffled)
        end

        local function encrypt(input, key)
            local salt = tostring(math_random(1000, 9999))
            input = salt .. input .. string["reverse"](salt)
            local shuffled_key = shuffle_key(key)
            local xored = xor_crypt(input, shuffled_key)
            return to_base64(xored)
        end

        local function decrypt(input, key)
            local decoded = from_base64(input)
            local shuffled_key = shuffle_key(key)
            local xored = xor_crypt(decoded, shuffled_key)
            local salt_length = 4

            return string["sub"](xored, salt_length + 1, -salt_length - 1)
        end

        menu.get_config_list = function()
            local list = {}

            local files = listfiles("juju recode/configs/")
            for _, file in files do
                if string["match"](file, "%.(.*)") == "cfg" then
                    list[#list+1] = string["sub"](file, 21, #file-4)
                end
            end

            return list
        end

        menu.get_addon_list = function()
            local list = {}

            local files = listfiles("juju recode/addons/")
            for _, file in files do
                if string["match"](file, "%.(.*)") == "luau" then
                    list[#list+1] = string["sub"](file, 20, #file-5)
                end
            end

            return list
        end

        menu.get_skins_list = function()
            local list = {}

            local files = listfiles("juju recode/custom/")
            for _, file in files do
                if string["match"](file, "%.(.*)") == "skin" then
                    list[#list+1] = string["sub"](file, 20, #file-5)
                end
            end

            return list
        end

        menu.get_theme_list = function()
            local list = {}

            local files = listfiles("juju recode/themes/")
            for _, file in files do
                if string["match"](file, "%.(.*)") == "th" then
                    list[#list+1] = string["sub"](file, 20, #file-3)
                end
            end

            return list
        end

        menu.save_config = LPH_JIT(function(name)
            if string["find"](name, "%/") or string["find"](name, "%.") then
                return
            end

            local keybinds = {}

            local config = {
                ["keybinds"] = keybinds,
                ["author"] = flags["author"] or LRM_LinkedDiscordID or "Unknown",
                ["date"] = os["date"]("%x")
            }

            for flag, data in flags do
                local data = data
                local type_of = typeof(data)
                if type_of == "Color3" then
                    data = {floor(data["R"]*255), floor(data["G"]*255), floor(data["B"]*255)}
                elseif type_of == "EnumItem" then
                    data = data["Name"]
                end

                if flag:sub(1,1) == "!" then
                    continue
                end

                config[flag] = data
            end

            for element, data in keybind_data do
                if type(element) == "table" then
                    local type = data["type"]
                    local flag = data["element"][type == 1 and "dropdown_flag" or type == 2 and "slider_flag" or type == 3 and "toggle_flag" or type == 4 and "name"]
                    local original_value = data["original_value"]

                    keybinds[#keybinds + 1] = {
                        ["flag"] = flag,
                        ["og_value"] = original_value,
                        ["value"] = data["value"],
                        ["method"] = data["method"],
                        ["key"] = data["key"]["Name"],
                        ["type"] = type
                    }

                    config[flag] = original_value
                end
            end

            writefile("juju recode/configs/"..name..".cfg", encrypt(http_service:JSONEncode(config), "^^^^^^^^^^^^^^^^^^^^"))
        end)

        menu["get_config_data"] = LPH_JIT(function(data)
            local success, decrypted = pcall(decrypt, data, "^^^^^^^^^^^^^^^^^^^^")

            if decrypted then
                local success, json = pcall(function()
                    return http_service:JSONDecode(decrypted)
                end)

                if success then
                    return json
                end
            end
        end)

        menu["load_config"] = LPH_JIT_MAX(function(name)
            if string["find"](name, "%/") or string["find"](name, "%.") then
                return
            end

            local path = "juju recode/configs/"..name..".cfg"

            if isfile(path) then
                local new_flags = menu["get_config_data"](readfile(path))

                if new_flags then
                    local loaded_addons = new_flags["loaded_addons"]

                    if loaded_addons then
                        for _, addon in addon_data do
                            for i = 1, #loaded_addons do
                                if addon == loaded_addons[i] then
                                    continue
                                end
                                menu["unload_addon"](loaded_addons[i])
                            end
                        end

                        for _, addon in loaded_addons do
                            if not addon_data[addon] then
                                menu["load_addon"](addon)
                            end
                        end
                    else
                        for _, addon in addon_data do
                            menu["unload_addon"](addon)
                        end
                    end

                    for element, keybind in keybind_data do
                        if element ~= 1 then
                            on_keybind_deleted:Fire(keybind, element, true)
                        end
                    end

                    local colors = menu["colors"]
                    for color, old in colors do
                        local value = new_flags[color.."_color"]

                        if value then
                            colors[color] = color3_fromrgb(value[1], value[2], value[3])
                        end
                    end

                    local keybinds = new_flags["keybinds"]

                    if keybinds then
                        for _, data in keybind_data do
                            if type(_) == "table" then
                                keybind_data[_] = nil
                            end
                        end

                        for _, new_keybind in keybinds do
                            local flag = new_keybind["flag"]
                            local type = new_keybind["type"]
                            local flag_name = type == 1 and "dropdown_flag" or type == 2 and "slider_flag" or type == 3 and "toggle_flag" or type == 4 and "name"
                            local new_keybind_data = nil

                            local key = new_keybind["key"]

                            local s = pcall(function()
                                key = Enum["UserInputType"][key]
                            end)
                            if not s then
                                s = pcall(function()
                                    key = Enum["KeyCode"][key]
                                end)
                            end

                            if s then
                                for _, group in menu["groups"] do
                                    for name, tab in group["tabs"] do
                                        for _, section in tab["sections"] do
                                            local elements = section["elements"]
                                            for i = 1, #elements do
                                                local element = elements[i]
                                                if element[flag_name] == flag then
                                                    local method = new_keybind["method"]

                                                    new_keybind_data = setmetatable({
                                                        ["method"] = type == 2 and 1 or method,
                                                        ["original_value"] = new_keybind["og_value"],
                                                        ["value"] = (type == 4 and "") or (type == 3 and new_flags[element[flag_name]]) or (type ~= 3 and new_keybind["value"]),
                                                        ["type"] = type,
                                                        ["activated"] = method == 2,
                                                        ["element"] = element,
                                                        ["key"] = key
                                                    }, keybind)

                                                    break
                                                end
                                            end
                                        end
                                    end
                                end

                                for _, settings in menu["settings"] do
                                    local elements = settings["elements"]
                                    for i = 1, #elements do
                                        local element = elements[i]
                                        if element[flag_name] == flag then
                                            local method = new_keybind["method"]
                                            new_keybind_data = setmetatable({
                                                ["method"] = type == 2 and 1 or method,
                                                ["original_value"] = new_keybind["og_value"],
                                                ["value"] = (type == 4 and "") or (type == 3 and new_flags[element[flag_name]]) or (type ~= 3 and new_keybind["value"]),
                                                ["type"] = type,
                                                ["activated"] = method == 2,
                                                ["element"] = element,
                                                ["key"] = key
                                            }, keybind)
                                            break
                                        end
                                    end
                                end

                                if new_keybind_data then
                                    local element = new_keybind_data["element"]
                                    keybind_data[element] = new_keybind_data

                                    on_keybind_created:Fire(new_keybind_data, element)
                                end
                            end
                        end
                    end

                    for name, group in menu["groups"] do
                        for name, tab in group["tabs"] do
                            for _, section in tab["sections"] do
                                local elements = section["elements"]
                                for i = 1, #elements do
                                    local element = elements[i]
                                    local slider_flag = element["slider_flag"]
                                    local toggle_flag = element["toggle_flag"]
                                    local dropdown_flag = element["dropdown_flag"]
                                    local textbox_flag = element["textbox_flag"]
                                    local colorpicker_flag = element["color_flag"]
                                    local keybind_flag = element["keybind_flag"]

                                    if slider_flag then
                                        local value = flags[slider_flag]
                                        local new_value = new_flags[slider_flag]

                                        if new_value ~= nil and value ~= new_value then
                                            element:set_slider(new_value)
                                        end
                                    end

                                    if toggle_flag then
                                        local value = flags[toggle_flag]
                                        local new_value = new_flags[toggle_flag]

                                        if new_value ~= nil and value ~= new_value then
                                            element:set_toggle(new_value)
                                        end
                                    end

                                    if dropdown_flag then
                                        local value = flags[dropdown_flag]
                                        local new_value = new_flags[dropdown_flag]

                                        if value ~= new_value then
                                            if new_value then
                                                local options = element["options"]

                                                for _, value in new_value do
                                                    local found = false
                                                    for i = 1, #options do
                                                        if options[i] == value then
                                                            found = true
                                                            break
                                                        end
                                                    end
                                                    if not found then
                                                        remove(new_value, _)
                                                    end
                                                end
                                            end

                                            element:set_dropdown((new_value and #new_value > 0 and new_value) or (element["requires_one"] and element["dropdown_default"]))
                                        end
                                    end

                                    if textbox_flag then
                                        local value = flags[textbox_flag]
                                        local new_value = new_flags[textbox_flag]

                                        if new_value ~= nil and value ~= new_value then
                                            element:set_textbox(new_value)
                                        end
                                    end

                                    if colorpicker_flag then
                                        local color_value = flags[colorpicker_flag]
                                        local new_color_value = new_flags[colorpicker_flag]
                                        new_color_value = new_color_value and color3_fromrgb(new_color_value[1], new_color_value[2], new_color_value[3]) or nil
                                        local transparency_flag = element["transparency_flag"]
                                        local transparency_value = flags[transparency_flag]
                                        local new_transparency_value = new_flags[transparency_flag]

                                        if new_color_value ~= nil and color_value ~= new_color_value then
                                            element:set_colorpicker(new_color_value)
                                        end

                                        if new_transparency_value ~= nil and transparency_value ~= new_transparency_value then
                                            element:set_colorpicker_transparency(new_transparency_value)
                                        end
                                    end

                                    if keybind_flag then
                                        local value = flags[keybind_flag]
                                        local new_value = new_flags[keybind_flag]

                                        if new_value ~= nil and value ~= new_value then
                                            local s, err = pcall(function()
                                                new_value = Enum["UserInputType"][new_value]
                                            end)
                                            if not s then
                                                new_value = Enum["KeyCode"][new_value]
                                            end
                                            element:set_key(new_value)
                                        end
                                    end
                                end
                            end
                        end
                    end

                    for element_settings, settings in menu["settings"] do
                        local elements = settings["elements"]
                        for i = 1, #elements do
                            local element = elements[i]
                            local slider_flag = element["slider_flag"]
                            local toggle_flag = element["toggle_flag"]
                            local dropdown_flag = element["dropdown_flag"]
                            local textbox_flag = element["textbox_flag"]
                            local colorpicker_flag = element["color_flag"]
                            local keybind_flag = element["keybind_flag"]

                            if slider_flag then
                                local value = flags[slider_flag]
                                local new_value = new_flags[slider_flag]

                                if new_value ~= nil and value ~= new_value then
                                    element:set_slider(new_value)
                                end
                            end

                            if toggle_flag then
                                local value = flags[toggle_flag]
                                local new_value = new_flags[toggle_flag]

                                if new_value ~= nil and value ~= new_value then
                                    element:set_toggle(new_value)
                                end
                            end

                            if dropdown_flag then
                                local value = flags[dropdown_flag]
                                local new_value = new_flags[dropdown_flag]

                                if value ~= new_value then
                                    if new_value then
                                        local options = element["options"]

                                        for _, value in new_value do
                                            local found = false
                                            for i = 1, #options do
                                                if options[i] == value then
                                                    found = true
                                                    break
                                                end
                                            end
                                            if not found then
                                                remove(new_value, _)
                                            end
                                        end
                                    end

                                    element:set_dropdown((new_value and #new_value > 0 and new_value) or (element["requires_one"] and element["dropdown_default"]))
                                end
                            end

                            if textbox_flag then
                                local value = flags[textbox_flag]
                                local new_value = new_flags[textbox_flag]

                                if new_value ~= nil and value ~= new_value then
                                    element:set_textbox(new_value)
                                end
                            end

                            if colorpicker_flag then
                                local color_value = flags[colorpicker_flag]
                                local new_color_value = new_flags[colorpicker_flag]

                                new_color_value = new_color_value and color3_fromrgb(new_color_value[1], new_color_value[2], new_color_value[3]) or nil
                                local transparency_flag = element["transparency_flag"]
                                local transparency_value = flags[transparency_flag]
                                local new_transparency_value = new_flags[transparency_flag]

                                if new_color_value ~= nil and color_value ~= new_color_value then
                                    element:set_colorpicker(new_color_value)
                                end

                                if new_transparency_value ~= nil and transparency_value ~= new_transparency_value then
                                    element:set_colorpicker_transparency(new_transparency_value)
                                end
                            end

                            if keybind_flag then
                                local value = flags[keybind_flag]
                                local new_value = new_flags[keybind_flag]

                                if new_value ~= nil and value ~= new_value then
                                    local s, err = pcall(function()
                                        new_value = Enum["UserInputType"][new_value]
                                    end)
                                    if not s then
                                        new_value = Enum["KeyCode"][new_value]
                                    end
                                    element:set_key(new_value)
                                end
                            end
                        end
                    end

                    local keybinds_position = new_flags["keybinds_position"]

                    if keybinds_position then
                        list_frame["Position"] = udim2_new(0, keybinds_position[1], 0, keybinds_position[2])
                    end

                    local skins = new_flags["skins"]

                    if skins and type(skins) == "table" then
                        flags["skins"] = skins
                    end

                    menu["on_config_loaded"]:Fire()
                end
            end
        end)

        do
            menu["unload_addon"] = function(name)
                local data = addon_data[name]

                if data then
                    local thread = data[1]
                    local on_unload = data[4]
                    if on_unload then
                        on_unload()
                    end
                    if data[2]["destroy"] then
                    
                        data[2]["destroy"](data[2])
                        local addons_group = menu["groups"]["addons"]

                        local count = #addons_group["ordered_tabs"]
                        local is_visible = addons_group["is_visible"]
                        if count == 0 and is_visible then
                            addons_group["hide"](addons_group)
                        elseif count > 0 and not is_visible then
                            addons_group["show"](addons_group)
                        end
                    end
                    for _, connection in data[3] do
                        connection:Disconnect()
                    end
                    local loaded_addons = flags["loaded_addons"]
                    local found = nil
                    for i = 1, #loaded_addons do
                        if loaded_addons[i] == name then
                            found = i
                            break
                        end
                    end
                    if found then
                        remove(loaded_addons, found)
                    end

                    coroutine["close"](thread)
                    addon_data[name] = nil
                end
            end

            menu["load_addon"] = function(name)
                local path = "juju recode/addons/"..name..".luau"

                if not isfile(path) then
                    return "file does not exist"
                end

                local data = readfile(path)

                local s, err = pcall(function()
                    data = loadstring(data)
                end)

                if not s then
                    return "juju: addon "..name.." experienced an error while loading: "..err
                end

                if addon_data[name] then
                    menu["unload_addon"](name)
                end

                getfenv(data).__IDENTIFIER = name

                local thread = coroutine["create"](data)

                addon_data[name] = {
                    thread,
                    {},
                    {},
                    function()

                    end,
                    name
                }
                local loaded_addons = flags["loaded_addons"]
                loaded_addons[#loaded_addons+1] = name

                local s, err = coroutine["resume"](thread)

                if not s then
                    spawn(menu["unload_addon"], name)
                    error("juju: addon "..name.." experienced an error while loading: "..err)
                end
            end
        end

        -- >> ( fake settings )

        local settings_section = setmetatable({
            ["total_y_size"] = 10,
            ["elements"] = {}
        }, section)

        settings_section["border"] = drawing_proxy["new"]("Image", {
            ["Parent"] = settings_image,
            ["Position"] = udim2_new(1, 5, 0, -5),
            ["Size"] = udim2_new(0, 170, 0, 10),
            ["Color"] = menu["colors"]["border"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 500,
            ["Visible"] = false,
        })
        settings_section["inside"] = drawing_proxy["new"]("Image", {
            ["Parent"] = settings_section["border"],
            ["Position"] = udim2_new(0, 1, 0, 1),
            ["Size"] = udim2_new(1, -2, 1, -2),
            ["Color"] = menu["colors"]["background"],
            ["Transparency"] = 1,
            ["Rounding"] = 4,
            ["Data"] = pixel_image_data,
            ["ZIndex"] = 501,
            ["Visible"] = true,
        })
        settings_section["holder"] = drawing_proxy["new"]("Square", {
            ["Parent"] = settings_section["inside"],
            ["Position"] = udim2_new(0, 10, 0, 10),
            ["Size"] = udim2_new(1, -20, 1, -20),
            ["Transparency"] = 0,
            ["Filled"] = true,
            ["ZIndex"] = 502,
            ["Visible"] = true,
        })

        menu["settings"][{["name"] = "settings"}] = settings_section

        -- >> ( settings )

        do
            local menu_keybind = settings_section:create_element({
                ["name"] = "toggle bind",
            }, {
                ["keybind"] = {
                    ["flag"] = "menu_key"
                }
            })

            menu_keybind:set_key(Enum["KeyCode"]["Insert"])
            create_connection(menu_keybind["on_key_change"], function(key)
                keybind_data[1]["key"] = key
            end)

            create_connection(settings_section:create_element({
                ["name"] = "keybinds list",
            }, {
                ["toggle"] = {
                    ["default"] = false,
                    ["flag"] = "keybind_list"
                }
            })["on_toggle_change"], function(bool)
                if bool then
                    menu:show_keybinds()
                else
                    menu:hide_keybinds()
                end
            end)

            menu_references["notifications"] = settings_section:create_element({
                ["name"] = "notifications",
            }, {
                ["toggle"] = {
                    ["default"] = do_notifications,
                    ["flag"] = "!notifications"
                }
            })

            menu_references["hide_on_load"] = settings_section:create_element({
                ["name"] = "hide on load",
            }, {
                ["toggle"] = {
                    ["default"] = false,
                    ["flag"] = "!hide_on_load"
                }
            })

            create_connection(menu_references["notifications"]["on_toggle_change"], function(bool)
                do_notifications = bool
                menu["saved"] = true
            end)
            
            create_connection(menu_references["hide_on_load"]["on_toggle_change"], function(bool)
                menu["hide_on_load"] = bool
                menu["saved"] = true
            end)

            settings_section:create_element({
                ["name"] = "custom kick screen",
            }, {
                ["toggle"] = {
                    ["default"] = false,
                    ["flag"] = "custom_kick_screen"
                },
                ["textbox"] = {
                    ["flag"] = "custom_kick_screen_background",
                    ["default"] = "2.png"
                },
                ["colorpicker"] = {
                    ["color_flag"] = "custom_kick_screen_color",
                    ["transparency_flag"] = "custom_kick_screen_color_transparency",
                    ["default_color"] = menu["colors"]["accent"],
                    ["default_transparency"] = 0
                }
            })

            create_connection(settings_section:create_element({
                ["name"] = "unload juju",
            }, {
                ["button"] = {
                    ["confirmation"] = true
                },
            })["on_clicked"], function()
                getgenv()["_JUJU"]()

                if identifyexecutor() == "AWP" then
                    cleardrawcache()
                end
            end)
        end

       -- >> ( fake theme )

        do
            theme_section = setmetatable({
                ["total_y_size"] = 10,
                ["elements"] = {}
            }, section)

            theme_section["border"] = drawing_proxy["new"]("Image", {
                ["Parent"] = themes_image,
                ["Position"] = udim2_new(1, 5, 0, -5),
                ["Size"] = udim2_new(0, 170, 0, 10),
                ["Color"] = menu["colors"]["border"],
                ["Transparency"] = 1,
                ["Rounding"] = 4,
                ["Data"] = pixel_image_data,
                ["ZIndex"] = 500,
                ["Visible"] = false,
            })
            theme_section["inside"] = drawing_proxy["new"]("Image", {
                ["Parent"] = theme_section["border"],
                ["Position"] = udim2_new(0, 1, 0, 1),
                ["Size"] = udim2_new(1, -2, 1, -2),
                ["Color"] =  menu["colors"]["background"],
                ["Transparency"] = 1,
                ["Rounding"] = 4,
                ["Data"] = pixel_image_data,
                ["ZIndex"] = 501,
                ["Visible"] = true,
            })
            theme_section["holder"] = drawing_proxy["new"]("Square", {
                ["Parent"] = theme_section["inside"],
                ["Position"] = udim2_new(0, 10, 0, 10),
                ["Size"] = udim2_new(1, -20, 1, -20),
                ["Transparency"] = 0,
                ["Filled"] = true,
                ["ZIndex"] = 502,
                ["Visible"] = true,
            })

            menu["settings"][{["name"] = "theming"}] = theme_section

            -- >> ( settings )

            create_connection(theme_section:create_element({
                ["name"] = "juju color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["juju"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!juju_transparency",
                    ["color_flag"] = "!juju_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["juju"] = color
                juju_text["Color"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "logo color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["logo"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!logo_transparency",
                    ["color_flag"] = "!logo_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["logo"] = color
                logo["Color"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "error color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["error"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "e!rror_transparency",
                    ["color_flag"] = "!error_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["error"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "build color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["build"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!build_transparency",
                    ["color_flag"] = "!build_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["build"] = color
                build_text["Color"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "image color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["image"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!image_transparency",
                    ["color_flag"] = "!image_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["image"] = color
                themes_image["Color"] = color
                settings_image["Color"] = color
                search_image["Color"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "border color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["border"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!border_transparency",
                    ["color_flag"] = "!border_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["border"] = color
                context_border["Color"] = color
                dropdown_border["Color"] = color
                list_frame["Color"] = color
                search_out_border["Color"] = color
                for _, drawings in list_drawings do
                    drawings["inside"]["Color"] = color
                end

                for _, settings in menu["settings"] do
                    settings["border"]["Color"] = color
                end

                for name, group in menu["groups"] do
                    for name, tab in group["tabs"] do
                        for _, section in tab["sections"] do
                            local search_border = section["search_border"]
                            if search_border then
                                search_border["Color"] = color
                            end
                            section["border"]["Color"] = color
                            for _, element in section["elements"] do
                                local drawings = element["drawings"]
                                local toggle_border = drawings["toggle_border"]
                                local dropdown_border = drawings["dropdown_border"]
                                local slider_border = drawings["slider_border"]
                                local colorpicker_border = drawings["colorpicker_border"]
                                local keybind_border = drawings["keybind_border"]
                                local button_border = drawings["button_border"]
                                local textbox_border = drawings["textbox_border"]
                                local border = drawings["border"]

                                if toggle_border then
                                    toggle_border["Color"] = color
                                end

                                if dropdown_border then
                                    dropdown_border["Color"] = color
                                end

                                if slider_border then
                                    slider_border["Color"] = color
                                end

                                if colorpicker_border then
                                    colorpicker_border["Color"] = color
                                end

                                if keybind_border then
                                    keybind_border["Color"] = color
                                end

                                if button_border then
                                    button_border["Color"] = color
                                end

                                if border and section["selected"] ~= element then
                                    border["Color"] = color
                                end

                                if textbox_border then
                                    textbox_border["Color"] = color
                                end
                            end
                        end
                    end
                end

                for _, settings in menu["settings"] do
                    for _, element in settings["elements"] do
                        local drawings = element["drawings"]
                        local toggle_border = drawings["toggle_border"]
                        local dropdown_border = drawings["dropdown_border"]
                        local slider_border = drawings["slider_border"]
                        local colorpicker_border = drawings["colorpicker_border"]
                        local keybind_border = drawings["keybind_border"]
                        local button_border = drawings["button_border"]
                        local textbox_border = drawings["textbox_border"]

                        if toggle_border then
                            toggle_border["Color"] = color
                        end

                        if dropdown_border then
                            dropdown_border["Color"] = color
                        end

                        if slider_border then
                            slider_border["Color"] = color
                        end

                        if colorpicker_border then
                            colorpicker_border["Color"] = color
                        end

                        if keybind_border then
                            keybind_border["Color"] = color
                        end

                        if button_border then
                            button_border["Color"] = color
                        end

                        if textbox_border then
                            textbox_border["Color"] = color
                        end
                    end
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "alert color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["alert"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!alert_transparency",
                    ["color_flag"] = "!alert_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["alert"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "cursor color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["cursor"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!cursor_transparency",
                    ["color_flag"] = "!cursor_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["cursor"] = color
                cursor["Color"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "accent color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["accent"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!accent_transparency",
                    ["color_flag"] = "!accent_color"
                }
            })["on_color_change"], function(color)
                menu.set_accent_color(color)
            end)

            create_connection(theme_section:create_element({
                ["name"] = "shadow color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["shadow"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!shadow_transparency",
                    ["color_flag"] = "!shadow_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["shadow"] = color

                list_shadow["Color"] = color

                for _, drawing in list_drawings do
                    drawing["shadow"]["Color"] = color
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "success color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["success"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!success_transparency",
                    ["color_flag"] = "!success_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["success"] = color
            end)

            create_connection(theme_section:create_element({
                ["name"] = "dark text color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["dark_text"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!dark_text_transparency",
                    ["color_flag"] = "!dark_text_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["dark_text"] = color

                for name, group in menu["groups"] do
                    for name, tab in group["tabs"] do
                        for _, section in tab["sections"] do
                            for _, element in section["elements"] do
                                local drawings = element["drawings"]
                                local text = drawings["dropdown_text"]
                                local dropdown_arrow = drawings["dropdown_arrow"]
                                local button_text = drawings["button_text"]
                                local button_icon = drawings["button_icon"]
                                local textbox_text = drawings["textbox_text"]
                                local keybind_text = drawings["keybind_text"]
                                local slider_text = drawings["slider_text"]

                                local text2 = drawings["text2"]

                                if text then
                                    text["Color"] = color
                                end

                                if text2 then
                                    text2["Color"] = color
                                end

                                if button_text then
                                    button_text["Color"] = color
                                end

                                if textbox_text then
                                    textbox_text["Color"] = color
                                end

                                if button_icon then
                                    button_icon["Color"] = color
                                end

                                if keybind_text then
                                    keybind_text["Color"] = color
                                end

                                if dropdown_arrow then
                                    dropdown_arrow["Color"] = color
                                end

                                if slider_text then
                                    slider_text["Color"] = color
                                end
                            end
                        end
                    end
                end

                for _, settings in menu["settings"] do
                    for _, element in settings["elements"] do
                        local drawings = element["drawings"]
                        local text = drawings["dropdown_text"]
                        local dropdown_arrow = drawings["dropdown_arrow"]
                        local slider_text = drawings["slider_text"]
                        local text2 = drawings["text2"]
                        local button_text = drawings["button_text"]
                        local button_icon = drawings["button_icon"]
                        local textbox_text = drawings["textbox_text"]
                        local keybind_text = drawings["keybind_text"]

                        if text then
                            text["Color"] = color
                        end

                        if textbox_text then
                            textbox_text["Color"] = color
                        end

                        if dropdown_arrow then
                            dropdown_arrow["Color"] = color
                        end

                        if keybind_text then
                            keybind_text["Color"] = color
                        end

                        if text2 then
                            text2["Color"] = color
                        end

                        if button_text then
                            button_text["Color"] = color
                        end

                        if button_icon then
                            button_icon["Color"] = color
                        end

                        if slider_text then
                            slider_text["Color"] = color
                        end
                    end
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "section color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["section"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!section_transparency",
                    ["color_flag"] = "!section_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["section"] = color
                inside["Color"] = color

                for name, group in menu["groups"] do
                    for name, tab in group["tabs"] do
                        for _, section in tab["sections"] do
                            section["inside"]["Color"] = color
                        end
                    end
                end

                for _, settings in menu["settings"] do
                    settings["inside"]["Color"] = color
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "active text color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["active_text"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!active_text_transparency",
                    ["color_flag"] = "!active_text_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["active_text"] = color
                search_text["Color"] = color
                list_text["Color"] = color
                actives["tab"]["text"]["Color"] = color

                for name, group in menu["groups"] do
                    for name, tab in group["tabs"] do
                        if actives["tab"] == tab then
                            tab["text"]["Color"] = color
                        end
                        for _, section in tab["sections"] do
                            for _, element in section["elements"] do
                                local toggle_flag = element["toggle_flag"]

                                if toggle_flag then
                                    if flags[toggle_flag] then
                                        element["drawings"]["text"]["Color"] = color
                                    end
                                end
                            end
                        end
                    end
                end

                for _, settings in menu["settings"] do
                    for _, element in settings["elements"] do
                        local toggle_flag = element["toggle_flag"]

                        if toggle_flag then
                            if flags[toggle_flag] then
                                element["drawings"]["text"]["Color"] = color
                            end
                        end
                    end
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "inactive text color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["inactive_text"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!inactive_text_transparency",
                    ["color_flag"] = "!inactive_text_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["inactive_text"] = color
                type_line["Color"] = color

                for name, group in menu["groups"] do
                    for name, tab in group["tabs"] do
                        if actives["tab"] ~= tab then
                            tab["text"]["Color"] = color
                        end
                        for _, section in tab["sections"] do
                            local search_image = section["search_image"]

                            if search_image then
                                search_image["Color"] = color
                            end
                            for _, element in section["elements"] do
                                local drawings = element["drawings"]
                                local cog_icon = drawings["cog_icon"]

                                local toggle_flag = element["toggle_flag"]

                                if not toggle_flag or not flags[toggle_flag] then
                                    element["drawings"]["text"]["Color"] = color
                                end

                                if cog_icon then
                                    cog_icon["Color"] = color
                                end
                            end
                        end
                    end
                end

                for _, settings in menu["settings"] do
                    for _, element in settings["elements"] do
                        local drawings = element["drawings"]
                        local dropdown_arrow = drawings["dropdown_arrow"]

                        if dropdown_arrow then
                            dropdown_arrow["Color"] = color
                        end

                        local toggle_flag = element["toggle_flag"]

                        if not toggle_flag or not flags[toggle_flag] then
                            element["drawings"]["text"]["Color"] = color
                        end
                    end
                end

                for i = 1, #context_buttons do
                    context_buttons[i]["text"]["Color"] = color
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "keybind text color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["keybind_text"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!keybind_text_transparency",
                    ["color_flag"] = "!keybind_text_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["keybind_text"] = color
                for _, drawings in list_drawings do
                    drawings["text"]["Color"] = color
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "background color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["background"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!background_transparency",
                    ["color_flag"] = "!background_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["background"] = color
                context_inside["Color"] = color
                right_side["Color"] = color
                right_side_cover["Color"] = color
                right_side_divider["Color"] = color
                search_inside["Color"] = color
                search_out["Color"] = color
                keybind_inside["Color"] = color
                search_inside["Color"] = color
                colorpicker_inside["Color"] = color
                right_side["Color"] = color
                right_side_cover["Color"] = color
                right_side_divider["Color"] = color
                search_inside["Color"] = color
                search_out["Color"] = color
                dropdown_inside["Color"] = color
                context_inside["Color"] = color
                keybind_inside["Color"] = color
                search_inside["Color"] = color
                list_inside["Color"] = color
                search_out["Color"] = color
                drag_frame["Color"] = color

                for _, drawings in list_drawings do
                    drawings["inside"]["Color"] = color
                end

                for _, button in context_buttons do
                    button["frame"]["Color"] = color
                end

                for name, group in menu["groups"] do
                    for name, tab in group["tabs"] do
                        for _, section in tab["sections"] do
                            local search_inside = section["search_inside"]
                            if search_inside then
                                search_inside["Color"] = color
                            end
                            for _, element in section["elements"] do
                                local drawings = element["drawings"]
                                local toggle_inside = drawings["toggle_inside"]
                                local dropdown_inside = drawings["dropdown_inside"]
                                local slider_inside = drawings["slider_inside"]
                                local colorpicker_inside = drawings["colorpicker_inside"]
                                local keybind_inside = drawings["keybind_inside"]
                                local button_inside = drawings["button_inside"]
                                local textbox_inside = drawings["textbox_inside"]
                                local inside = drawings["inside"]

                                if toggle_inside then
                                    toggle_inside["Color"] = color
                                end

                                if dropdown_inside then
                                    dropdown_inside["Color"] = color
                                end

                                if slider_inside then
                                    slider_inside["Color"] = color
                                end

                                if colorpicker_inside then
                                    colorpicker_inside["Color"] = color
                                end

                                if keybind_inside then
                                    keybind_inside["Color"] = color
                                end

                                if button_inside then
                                    button_inside["Color"] = color
                                end

                                if textbox_inside then
                                    textbox_inside["Color"] = color
                                end

                                if inside then
                                    inside["Color"] = color
                                end
                            end
                        end
                    end
                end

                for _, settings in menu["settings"] do
                    for _, element in settings["elements"] do
                        local drawings = element["drawings"]
                        local toggle_inside = drawings["toggle_inside"]
                        local dropdown_inside = drawings["dropdown_inside"]
                        local slider_inside = drawings["slider_inside"]
                        local colorpicker_inside = drawings["colorpicker_inside"]
                        local keybind_inside = drawings["keybind_inside"]
                        local button_inside = drawings["button_inside"]
                        local textbox_inside = drawings["textbox_inside"]
                        local inside = drawings["inside"]

                        if toggle_inside then
                            toggle_inside["Color"] = color
                        end

                        if dropdown_inside then
                            dropdown_inside["Color"] = color
                        end

                        if slider_inside then
                            slider_inside["Color"] = color
                        end

                        if colorpicker_inside then
                            colorpicker_inside["Color"] = color
                        end

                        if keybind_inside then
                            keybind_inside["Color"] = color
                        end

                        if button_inside then
                            button_inside["Color"] = color
                        end

                        if textbox_inside then
                            textbox_inside["Color"] = color
                        end

                        if inside then
                            inside["Color"] = color
                        end
                    end
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "active border color",
            }, {
                ["colorpicker"] = {
                    ["default_color"] = menu["colors"]["highlighted"],
                    ["default_transparency"] = 0,
                    ["transparency_flag"] = "!active_border_transparency",
                    ["color_flag"] = "!active_border_color"
                }
            })["on_color_change"], function(color)
                menu["colors"]["highlighted"] = color
            end)

            theme_section:create_element({
                ["name"] = "themes",
                ["section"] = 2
            }, {
                ["dropdown"] = {
                    ["options"] = menu["get_theme_list"](),
                    ["flag"] = "!themes",
                    ["default"] = menu["theme"] and {menu["theme"]} or nil
                }
            })

            create_connection(theme_section:create_element({
                ["name"] = "refresh themes",
                ["section"] = 2
            }, {
                ["button"] = {
                    ["fake"] = true
                }
            })["on_clicked"], function()
                local elements = theme_section["elements"]

                for i = 1, #elements do
                    local element = elements[i]
                    if element["dropdown_flag"] then
                        element:set_options(menu["get_theme_list"]())
                        break
                    end
                end
            end)

            create_connection(theme_section:create_element({
                ["name"] = "load theme",
                ["section"] = 2
            }, {
                ["button"] = {
                    ["fake"] = true
                }
            })["on_clicked"], function()
                menu:load_theme(flags["!themes"][1])
            end)

            theme_section:create_element({
                ["name"] = "name",
                ["section"] = 2
            }, {
                ["textbox"] = {
                    ["flag"] = "!name"
                }
            })

            create_connection(theme_section:create_element({
                ["name"] = "save theme",
                ["section"] = 2
            }, {
                ["button"] = {}
            })["on_clicked"], function()
                local file = "juju recode/themes/"..flags["!name"]..".th"
                local data = {}

                local elements = theme_section["elements"]

                for i = 1, #elements do
                    local element = elements[i]
                    local flag = element["color_flag"]
                    if flag then
                        local color = flags[flag]
                        data[flag] = {floor(color["R"] * 255), floor(color["G"] * 255), floor(color["B"] * 255)}
                    end
                end

                writefile(file, http_service:JSONEncode(data))

                menu["new_notification"]("successfully saved theme "..flags["!name"], 1)

                local elements = theme_section["elements"]

                for i = 1, #elements do
                    local element = elements[i]
                    if element["dropdown_flag"] then
                        element:set_options(menu["get_theme_list"]())
                        break
                    end
                end
            end)

            create_click_connection(frame, themes_image, function()
                if actives["settings"] == theme_section then
                    close_settings(theme_section)
                else
                    open_settings(theme_section)
                end
            end)

            create_hover_connection(frame, themes_image, function()
                tween(themes_image, {Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
            end, function()
                tween(themes_image, {Color = menu["colors"]["image"]}, circular, out, 0.15)
            end)
        end

        -- >> ( buttons )

        create_click_connection(frame, settings_image, function()
            if actives["settings"] == theme_section then
                close_settings(settings_section)
            else
                open_settings(settings_section)
            end
        end)

        create_hover_connection(frame, settings_image, function()
            tween(settings_image, {Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
        end, function()
            tween(settings_image, {Color = menu["colors"]["image"]}, circular, out, 0.15)
        end)

        create_hover_connection(frame, search_image, function()
            if not searching then
                tween(search_image, {Color = menu["colors"]["highlighted"]}, circular, out, 0.15)
            end
        end, function()
            if not searching then
                tween(search_image, {Color = menu["colors"]["image"]}, circular, out, 0.15)
            end
        end)

        create_click_connection(frame, search_image, start_search)

        -- >> ( group creation )

        do
            local main = menu.create_group("main")
                main:create_tab("ragebot")
                main:create_tab("legitbot")

            local visuals = menu.create_group("visuals")
                visuals:create_tab("players")
                visuals:create_tab("general")
                visuals:create_tab("skins")

           local misc = menu.create_group("misc.")
                misc:create_tab("players")
                misc:create_tab("configs")
                misc:create_tab("addons")
                misc:create_tab("shop")
                misc:create_tab("main")
            menu.create_group("addons")
            menu["groups"]["addons"]:hide()
        end

        menu_references["addon_list"] = menu["groups"]["misc."]:create_panel_section("addons", "addon list", 1, 1, 0)
        menu_references["addon_panel"] = menu["groups"]["misc."]:create_section("addons", "addon panel", 2, 1, 0)

        menu_references["load_addon"] = menu_references["addon_panel"]:create_element({
            ["name"] = "load addon"
        }, {
            ["button"] = {
                ["fake"] = true
            }
        })

        menu_references["unload_addon"] = menu_references["addon_panel"]:create_element({
            ["name"] = "unload addon"
        }, {
            ["button"] = {
                ["fake"] = true
            }
        })

        menu_references["refresh_addon_list"] = menu_references["addon_panel"]:create_element({
            ["name"] = "refresh addon list"
        }, {
            ["button"] = {
                ["fake"] = true
            }
        })

        -- >> ( configs )

        local config_list = menu["groups"]["misc."]:create_panel_section("configs", "config list", 1, false, true)
        local config_info = menu["groups"]["misc."]:create_section("configs", "config info", 2, 0.3, 0)
        local config_editor = menu["groups"]["misc."]:create_section("configs", "config editor", 2, 0.7, 0.3)

        menu_references["config_list"] = config_list

        local config_author = config_info:create_element({
            ["name"] = "creator: "
        }, {
            ["info"] = {}
        })

        local config_last_updated = config_info:create_element({
            ["name"] = "last updated: "
        }, {
            ["info"] = {}
        })

        local config_name = config_editor:create_element({
            ["name"] = "config name"
        }, {
            ["textbox"] = {
                ["flag"] = "!config_name"
            }
        })

        local create_config = config_editor:create_element({
            ["name"] = "create config"
        }, {
            ["button"] = {
                ["fake"] = true
            }
        })

        local delete_config = config_editor:create_element({
            ["name"] = "delete config"
        }, {
            ["button"] = {
                ["confirmation"] = true,
                ["fake"] = true
            }
        })

        local update_config = config_editor:create_element({
            ["name"] = "update config"
        }, {
            ["button"] = {
                ["confirmation"] = true,
                ["fake"] = true
            }
        })

        local load_config = config_editor:create_element({
            ["name"] = "load config"
        }, {
            ["button"] = {
                ["confirmation"] = true,
                ["fake"] = true
            }
        })

        local refresh_config_list = config_editor:create_element({
            ["name"] = "refresh config list"
        }, {
            ["button"] = {
                ["fake"] = true
            }
        })

        create_connection(config_list["on_selection_change"], function(config)
            local config = config or "AbbbbAzbbbbA12z"
            local path = "juju recode/configs/"..config..".cfg"
            local data = nil
            if isfile(path) then
                data = menu["get_config_data"](readfile(path))
            end
            if not data then
                config_name:set_visible(true)
                create_config:set_visible(true)
                load_config:set_visible(false)
                update_config:set_visible(false)
                delete_config:set_visible(false)
                config_author:set_visible(false)

                config_last_updated:set_visible(false)
                refresh_config_list:set_visible(true)
            else
                config_name:set_visible(false)
                create_config:set_visible(false)
                load_config:set_visible(true)
                update_config:set_visible(true)
                delete_config:set_visible(true)
                refresh_config_list:set_visible(false)
                config_last_updated:set_visible(true)
                config_last_updated:set_info("Text", data["date"])

                local author = data["author"]
                local username = nil

                if author and tonumber(author) then
                    local s, data = pcall(function()
                        local body = request({
                            ["Url"] = "https://discord-lookup-api-pied.vercel.app/v1/user/"..author,
                            ["Method"] = "GET",
                            ["Headers"] = {
                                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                                ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
                                ["Accept-Language"] = "en-US,en;q=0.9",
                                ["Connection"] = "keep-alive",
                                ["Referer"] = "https://www.google.com/",
                                ["DNT"] = "1",
                                ["Upgrade-Insecure-Requests"] = "1"
                            }
                        })

                        if body and body["StatusCode"] == 200 then
                            return http_service:JSONDecode(body["Body"])
                        end
                    end)
                    username = (s and data) and "@"..data["username"] or "failed to fetch"
                    config_author:set_visible(true)
                    config_author:set_info("Text", username)
                else
                    config_author:set_visible(false)
                    config_author:set_info("Text", "")
                end
            end
        end)

        create_connection(create_config["on_clicked"], function()
            local selected_config = flags["!config_name"]

            if selected_config and tostring(selected_config) and #selected_config > 0 then
                menu["save_config"](selected_config)

                config_list:add_item({
                    ["text"] = selected_config,
                    ["icons"] = {
                        config_image_data
                    }
                })

                menu["new_notification"](
                    "successfully created config "..selected_config,
                    1
                )
            end
        end)

        create_connection(refresh_config_list["on_clicked"], function()
            local elements = config_list["elements"]
            for _, element in elements do
                config_list:remove_item(element["name"], true)
                elements[_] = nil
            end

            local configs = menu["get_config_list"]()
            local current_autoload = menu["autoload"]

            for i = 1, #configs do
                local config = configs[i]
                config_list:add_item({
                    ["text"] = config,
                    ["icons"] = current_autoload == config and {
                        autoload,
                        config_image_data
                    } or {
                        config_image_data
                    }
                })
            end
        end)

        create_connection(delete_config["on_clicked"], function()
            local selected_config = config_list["selected"]["name"]

            if selected_config and tostring(selected_config) and #selected_config > 0 then
                config_list:remove_item(selected_config)
                delfile("juju recode/configs/"..selected_config..".cfg")
                menu["new_notification"](
                    "successfully deleted config "..selected_config,
                    1
                )
            end
        end)

        create_connection(update_config["on_clicked"], function()
            local selected_config = config_list["selected"]["name"]

            if selected_config and tostring(selected_config) and #selected_config > 0 then
                menu["save_config"](selected_config)
                menu["new_notification"](
                    "successfully updated config "..selected_config,
                    1
                )
            end
        end)

        create_connection(load_config["on_clicked"], function()
            local selected_config = config_list["selected"]["name"]

            if selected_config and tostring(selected_config) and #selected_config > 0 then
                menu["load_config"](selected_config)
                menu["new_notification"](
                    "successfully loaded config "..selected_config,
                    1
                )
            end
        end)

        for _, config in menu.get_config_list() do
            config_list:add_item({
                ["text"] = config,
                ["icons"] = menu["autoload"] == config and {
                    autoload,
                    config_image_data
                } or {
                    config_image_data
                }
            })
        end

        config_author:set_visible(false)
        update_config:set_visible(false)
        config_last_updated:set_visible(false)
        delete_config:set_visible(false)
        load_config:set_visible(false)
    end

    -- > ( loading / unloading )

    do
        local unload = getgenv()["_JUJU"]

        if unload then
            unload()
        end

        local env = getgenv()
        local old_drawing = env["fake_drawing"]

        local metatables = {}

        local real = getrawmetatable
        env["_OG"] = real
        env["getrawmetatable"] = newcclosure(function(instance)
            local mt = real(instance)
            metatables[instance] = mt

            return mt
        end)

        getrawmetatable = env["getrawmetatable"]

        env["_JUJU"] = function()
            env["_JUJU"] = nil

            for _, group in menu["groups"] do
                for _, tab in group["tabs"] do
                    for _, section in tab["sections"] do
                        local elements = section["elements"]
                        for i = 1, #elements do
                            local element = elements[i]

                            if element["toggle_flag"] then
                                element:set_toggle(false)
                            end
                        end
                    end
                end
            end

            for _, settings in menu["settings"] do
                local elements = settings["elements"]
                for i = 1, #elements do
                    local element = elements[i]

                    if element["toggle_flag"] then
                        element:set_toggle(false)
                    end
                end
            end

            for i = 1, #connections do
                connections[i]:Disconnect()
            end

            context_action_service:UnbindAction(context_action_click)
            context_action_service:UnbindAction(context_action_typing)
            context_action_service:UnbindCoreAction(context_action_typing_core)
            context_action_service:UnbindAction(context_action_scroll)

            env["getrawmetatable"] = real

            for instance, mt in metatables do
                setrawmetatable(instance, mt)
            end

            old_drawing["_UNLOAD"]()
        end

        -- >> ( data )

        local s, data = pcall(function()
            return http_service:JSONDecode(readfile("juju recode/data.dat"))
        end)

        if s and data then
            local notifications = data["notifications"]
            local autoload_config = data["autoload"]
            local favorites = data["favorites"]
            local theme = data["theme"]
            local hide_on_load = data["hide_on_load"]

            menu["hide_on_load"] = hide_on_load

            pop_menu(true)

            if not hide_on_load then
                pop_menu()
            end

            menu["theme"] = theme or ""
            menu["favorites"] = favorites or {}
            menu["autoload"] = autoload_config or nil
            do_notifications = notifications or notifications == nil or false
            menu_references["notifications"]:set_toggle(do_notifications)
            menu_references["hide_on_load"]:set_toggle(hide_on_load)

            if theme then
                menu:load_theme(theme)
            end
            
            if autoload_config then
                menu_references["config_list"]:add_icon(autoload_config, autoload)
            end
        else
            writefile("juju recode/data.dat", http_service:JSONEncode({
                ["notifications"] = do_notifications,
                ["favorites"] = {},
                ["hide_on_load"] = false,
                ["theme"] = "",
            }))
        end
    end
end

-- > ( cheat signals )

local signals = {
    ["on_local_character_description_changed"] = signal["new"](),
    ["on_player_character_added"] = signal["new"](),
    ["on_player_health_changed"] = signal["new"](),
    ["on_player_status_changed"] = signal["new"](),
    ["on_player_armor_changed"] = signal["new"](),
    ["on_player_tool_equipped"] = signal["new"](),
    ["on_player_bullet_fired"] = signal["new"](),
    ["on_local_bullet_confirmed"] = signal["new"](),
    ["on_legitbot_target_changed"] = signal["new"](),
    ["on_ragebot_target_changed"] = signal["new"](),
    ["on_local_armor_changed"] = signal["new"](),
    ["on_local_health_changed"] = signal["new"](),
    ["on_local_tool_equipped"] = signal["new"](),
    ["on_local_bullet_failed"] = signal["new"](),
    ["on_local_bullet_fired"] = signal["new"](),
    ["on_local_reload"] = signal["new"](),
    ["on_player_added"] = signal["new"](),
    ["on_player_died"] = signal["new"](),
    ["on_local_character_loaded"] = signal["new"](),
    ["on_local_character_added"] = signal["new"](),
    ["on_bounty_placed"] = signal["new"](),
    ["on_shot_at"] = signal["new"](),
    ["on_player_character_added_quick"] = signal["new"](),
    ["on_rpg_fired"] = signal["new"](),
    ["on_player_role_changed"] = signal["new"](),
    ["on_local_ammo_changed"] = signal["new"](),
    ["on_stomp"] = signal["new"](),
    ["on_vehicle_sat_in"] = signal["new"](),
}

-- > ( cheat variables )

local r6_part = "Torso"

local body_parts = {
    "Head",
    "Left Arm",
    "Right Arm",
    "Torso",
    "Left Leg",
    "Right Leg"
}

local workspace = game:GetService("Workspace")
local camera = workspace["CurrentCamera"]
local teleport_service = cloneref(game:GetService("TeleportService"))
local run_service = cloneref(game:GetService("RunService"))
local core_gui = cloneref(game:GetService("CoreGui"))

local find_first_child_of_class = workspace["FindFirstChildOfClass"]
local world_to_viewport_point = camera["WorldToViewportPoint"]
local find_first_child = workspace["FindFirstChild"]
local wait_for_child = workspace["WaitForChild"]
local get_children = workspace["GetChildren"]
local render_stepped = run_service["RenderStepped"]
local render_stepped_wait = render_stepped["Wait"]
local vector3_new = Vector3["new"]
local cframe_new = CFrame["new"]
local cframe_zero = CFrame["new"]()
local vector3_zero = Vector3["zero"]
local cframe_angles = CFrame["Angles"]
local params = RaycastParams["new"]()
local raycast = workspace["Raycast"]

params["FilterType"] = Enum["RaycastFilterType"]["Exclude"]
params["FilterDescendantsInstances"] = {}

local abs = math["abs"]
local pi = math["pi"]

local legitbot_target = nil

local real_drawing = getgenv()["Drawing"]
local fake_drawing = getgenv()["fake_drawing"]

local destroy = game["Destroy"]
local clone = workspace["Clone"]

local player_data = {}
local anti_aim = {}

-- > ( cheat functions )

local create_real_drawing = LPH_NO_VIRTUALIZE(function(class, properties)
    local object = real_drawing["new"](class)

    for property, value in properties do
        object[property] = value
    end

    return object
end)

local create_fake_drawing = LPH_NO_VIRTUALIZE(function(class, properties)
    local object = fake_drawing["new"](class)

    for property, value in properties do
        object[property] = value
    end

    return object
end)

local new_notification = menu["new_notification"]
local set_legitbot_target = nil

-- > ( client stuff )

local local_server_position = cframe_zero
local local_client_position = cframe_zero
local local_character = local_player["Character"]
local local_reloading = false
local local_parts = {}
local local_item = nil
local local_ping = 50
local local_gun = nil
local local_fps = 200
local local_ammo = 0

do
    local function apply_hrp_fix(hrp)
        local old = getrawmetatable(hrp)
        local old_index = old["__index"]

        local new = {
            ["__index"] = newcclosure(LPH_NO_VIRTUALIZE(function(self, index)
                if not checkcaller() and self and index == "CFrame" and (#anti_aim ~= 0 or purchasing) then
                    return local_client_position
                end
                return old_index(self, index)
            end))
        }

        for _, v in old do
            if not new[_] then
                new[_] = v
            end
        end

        setrawmetatable(hrp, new)
    end

    local on_child_added = LPH_JIT_MAX(function(child)
        local_parts[child["Name"]] = child
    end)

    local on_child_removed = LPH_NO_VIRTUALIZE(function(child)
        local_parts[child["Name"]] = nil
    end)

    local on_character_added = LPH_NO_VIRTUALIZE(function(character)
        local_gun = nil
        local_item = nil

        local hrp = wait_for_child(character, "HumanoidRootPart", 9e9)

        if not hrp then
            return
        end

        apply_hrp_fix(hrp)

        local_parts = {
            ["HumanoidRootPart"] = hrp
        }

        local humanoid = wait_for_child(character, "Humanoid", 9e9)

        wait_for_child(character, "Head", 5)

        local children = get_children(character)
        for i = 1, #children do
            local child = children[i]
            local_parts[child["Name"]] = child

            if child["ClassName"] == "Tool" then
                on_child_added(child)
            end
        end

        create_connection(character["ChildAdded"], on_child_added)
        create_connection(character["ChildRemoved"], on_child_removed)

        local_character = character

        signals["on_local_character_added"]:Fire(1)

        local_reloading = false

        signals["on_local_character_loaded"]:Fire(true)
    end)

    if local_character then
        spawn(on_character_added, local_character)
    end

    create_connection(local_player["CharacterAdded"], on_character_added)
end

-- > ( movement )

do
    menu_references["movement_section"] = menu["groups"]["misc."]:create_section("main", "movement", 1, 0.6, 0)

    -- >> ( removals )

    menu_references["remove_jump_cooldown"] = menu_references["movement_section"]:create_element({["name"] = "remove jump cooldown"}, {["toggle"] = {["flag"] = "remove_jump_cooldown"}})
    menu_references["remove_slowdowns"] = menu_references["movement_section"]:create_element({["name"] = "remove slowdowns"}, {["toggle"] = {["flag"] = "remove_slowdowns"}})
    
    -- >> ( jump power )

    menu_references["jump_power"] = menu_references["movement_section"]:create_element({["name"] = "jump power"}, {["toggle"] = {["flag"] = "jump_power"}})
    menu_references["jump_power_settings"] = menu_references["jump_power"]:create_settings()
    menu_references["jump_power_value"] = menu_references["jump_power_settings"]:create_element({["name"] = "power"}, {["slider"] = {["flag"] = "jump_power_value", ["min"] = 0, ["max"] = 1000, ["default"] = 50}})

    -- >> ( noclip )

    menu_references["noclip"] = menu_references["movement_section"]:create_element({["name"] = "noclip"}, {["toggle"] = {["flag"] = "noclip"}})

    local noclip_renderstepped_connection = nil

    local do_noclip = LPH_NO_VIRTUALIZE(function()
        for _, part in local_parts do
            local name = part["ClassName"]
            if name == "MeshPart" or name == "Part" then
                part["CanCollide"] = false
            end
        end
    end)

    create_connection(menu_references["noclip"]["on_toggle_change"], function(value)
        if noclip_renderstepped_connection then
            noclip_renderstepped_connection:Disconnect()
            noclip_renderstepped_connection = nil
        end

        if value then
            noclip_renderstepped_connection = create_connection(run_service["Stepped"], do_noclip)
        end
    end)

   -- >> ( speed )

    local is_key_down = user_input_service["IsKeyDown"]

    local w = Enum["KeyCode"]["W"]
    local s = Enum["KeyCode"]["S"]
    local space = Enum["KeyCode"]["Space"]
    local a = Enum["KeyCode"]["A"]
    local d = Enum["KeyCode"]["D"]

    local multiplier = 560
    local style = "normal"
    local running = Enum["HumanoidStateType"]["Running"]
    local jumping = Enum["HumanoidStateType"]["Jumping"]

    local do_speed = LPH_JIT_MAX(function(dt, hrp)
        if not hrp then
            return
        end

        local humanoid = local_parts["Humanoid"]

        if not humanoid then
            return
        end

		local move_direction = humanoid["MoveDirection"]

        if style == "normal" then
            hrp["CFrame"]+=((vector3_new(move_direction["X"],0,move_direction["Z"])*dt)*multiplier)
        elseif style == "bhop" then
            hrp["CFrame"]+=((vector3_new(move_direction["X"],0,move_direction["Z"])*dt)*multiplier)
            if humanoid:GetState() == running and (is_key_down(user_input_service, w) or is_key_down(user_input_service, s) or is_key_down(user_input_service, a) or is_key_down(user_input_service, d)) then
                humanoid:ChangeState(jumping)
            end
        elseif style == "minecraft" then
            hrp["CFrame"]+=((vector3_new(move_direction["X"],0,move_direction["Z"])*dt)*multiplier)
            if humanoid:GetState() == running and (is_key_down(user_input_service, w) or is_key_down(user_input_service, s) or is_key_down(user_input_service, a) or is_key_down(user_input_service, d)) then
                humanoid:ChangeState(jumping)
                hrp["Velocity"]*=vector3_new(1,1.5,1)
                wait(humanoid["JumpPower"]/500)
                hrp["Velocity"]*=vector3_new(1,-1.1,1)
            end
        end
    end)

    menu_references["speed"] = menu_references["movement_section"]:create_element({["name"] = "speed"}, {["toggle"] = {["flag"] = "speed"}})
        menu_references["speed_settings"] = menu_references["speed"]:create_settings()
        menu_references["speed_value"] = menu_references["speed_settings"]:create_element({["name"] = "speed value"}, {["slider"] = {["default"] = 35, ["min"] = 0, ["max"] = 100, ["suffix"] = "%", ["flag"] = "speed_value", ["prefix"] = ""}})
        menu_references["speed_style"] = menu_references["speed_settings"]:create_element({["name"] = "style"}, {["dropdown"] = {["default"] = {"normal"}, ["options"] = {"minecraft", "slippery", "normal", "bhop"}, ["flag"] = "speed_style", ["requires_one"] = true}})

    create_connection(menu_references["speed"]["on_toggle_change"], function(value)
        slippery_velocity = vector3_zero
        for i = 1, #heartbeat do
            if heartbeat[i] == do_speed then
                remove(heartbeat, i)
                break
            end
        end

        if value then
            heartbeat[#heartbeat+1] = do_speed
        end
    end)

    create_connection(menu_references["speed_value"]["on_slider_change"], function(value)
        multiplier = value*16
    end)

    create_connection(menu_references["speed_style"]["on_dropdown_change"], function(value)
        style = value[1]
    end)

    -- >> ( flight )

    local float_velocity = vector3_new(0, pi - 2, 0)

    local multiplier = 1750

    local do_flight = LPH_NO_VIRTUALIZE(function(dt, hrp)
        if not hrp then
            return
        end

        local humanoid = local_parts["Humanoid"]

        if not humanoid then
            return
        end

		local move_direction = humanoid["MoveDirection"]
        hrp["Velocity"] = float_velocity
        hrp["CFrame"]+=((vector3_new(move_direction["X"], is_key_down(user_input_service, space) and 1 or ((is_key_down(user_input_service, s) and -camera["CFrame"]["lookVector"]["Y"]) or (is_key_down(user_input_service, w) and camera["CFrame"]["lookVector"]["Y"]) or 0) * clamp(move_direction["Magnitude"], 0, 1), move_direction["Z"])*dt)*multiplier)
    end)

    menu_references["flight"] = menu_references["movement_section"]:create_element({["name"] = "flight"}, {["toggle"] = {["flag"] = "flight"}})
    menu_references["flight_settings"] = menu_references["flight"]:create_settings()
    menu_references["flight_speed"] = menu_references["flight_settings"]:create_element({["name"] = "flight speed"}, {["slider"] = {["default"] = 35, ["min"] = 1, ["max"] = 100, ["suffix"] = "%", ["flag"] = "flight_value", ["prefix"] = ""}})

    create_connection(menu_references["flight"]["on_toggle_change"], function(value)
        for i = 1, #heartbeat do
            if heartbeat[i] == do_flight then
                remove(heartbeat, i)
                break
            end
        end

        if value then
            heartbeat[#heartbeat+1] = do_flight
        end
    end)

    create_connection(menu_references["flight_speed"]["on_slider_change"], function(value)
        multiplier = value*50
    end)

    menu_references["other_section"] = menu["groups"]["misc."]:create_section("main", "other", 1, 0.4, 0.6)

    -- >> ( trash talk )
    
    do
        local event = find_first_child(cloneref(game:GetService("ReplicatedStorage")), "DefaultChatSystemChatEvents")
        
        if event then
            --event = find_first_child(event, "SayMessageRequest")
        end

        if event then
            menu_references["trash_talk"] = menu_references["other_section"]:create_element({["name"] = "trash talk"}, {["toggle"] = {["flag"] = "trash_talk"}})
            menu_references["trash_talk_settings"] = menu_references["trash_talk"]:create_settings()
            menu_references["trash_talk_list"] = menu_references["trash_talk_settings"]:create_element({["name"] = "message list"}, {["dropdown"] = {["flag"] = "trash_talk_list", ["options"] = {}, ["use_custom_extensions"] = {"json", "txt"}, ["default"] = {"spam.json"}, ["requires_one"] = true}})

            local trash_talk_list = {}
            local last_chat = clock()

            local do_trashtalk_spam = LPH_JIT_MAX(function()
                if (workspace["GetServerTimeNow"](workspace)*1.1) % 2.35 < 0.1 and (clock() - last_chat > 0.15) then
                    last_chat = clock()
                    local count = #trash_talk_list
                    if count > 0 then
                        event["FireServer"](event, count == 1 and trash_talk_list[1] or trash_talk_list[math_random(1, count)], "All")
                    end
                end
            end)

            create_connection(menu_references["trash_talk"]["on_toggle_change"], function(bool)
                local path = "juju recode/custom/"..flags["trash_talk_list"][1]
                if isfile(path) then 
                    local s, err = pcall(function()
                        trash_talk_list = http_service:JSONDecode(readfile(path))
                    end)

                    if err then
                        new_notification(
                            "failed to load trash talk list due to invalid json",
                            3
                        )
                    end 
                end

                for i = 1, #heartbeat do 
                    if heartbeat[i] == do_trashtalk_spam then
                        remove(heartbeat, i)
                        break
                    end
                end

                if bool then
                    heartbeat[#heartbeat + 1] = do_trashtalk_spam
                end
            end)

            create_connection(menu_references["trash_talk_list"]["on_dropdown_change"], function(value)
                local path = "juju recode/custom/"..flags["trash_talk_list"][1]
                if isfile(path) then 
                    local s, err = pcall(function()
                        trash_talk_list = http_service:JSONDecode(readfile(path))
                    end)

                    if err then
                        new_notification(
                            "failed to load trash talk list due to invalid json",
                            3
                        )
                    end 
                end
            end)
        end
    end
end

-- > ( misc )

do
    menu_references["utility_section"] = menu["groups"]["misc."]:create_section("main", "utility", 2, 0.6, 0)

    -- >> ( force reset )

    create_connection(menu_references["utility_section"]:create_element({["name"] = "force reset"}, {["button"] = {}})["on_clicked"], function()
        local humanoid = local_parts["Humanoid"]

        if humanoid then
            humanoid["Health"] = 0
        end
    end)

    -- >> ( tools )

    menu_references["server_section"] = menu["groups"]["misc."]:create_section("main", "server", 2, 0.4, 0.6)
    create_connection(menu_references["server_section"]:create_element({["name"] = "copy join script"}, {["button"] = {}})["on_clicked"], function()
        setclipboard("cloneref(game:GetService(\"TeleportService\")):TeleportToPlaceInstance("..game["PlaceId"]..", \""..game["JobId"].."\")")
        new_notification("copied join script to clipboard", 1)
    end)

    create_connection(menu_references["server_section"]:create_element({["name"] = "rejoin server"}, {["button"] = {}})["on_clicked"], function()
        local_player:Kick("R..")

        teleport_service:TeleportToPlaceInstance(game["PlaceId"], game["JobId"])
    end)

    create_connection(menu_references["server_section"]:create_element({["name"] = "hop servers"}, {["button"] = {}})["on_clicked"], function()
        local servers = http_service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game["PlaceId"].."/servers/Public?sortOrder=Asc&limit=100"))["data"]
        local cursor = servers["nextPageCursor"]

        if cursor and cursor ~= "null" and cursor ~= "" then
            servers = http_service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game["PlaceId"].."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor))["data"]
        end

        local lowest_ping = 9e9
        local most_players = 0
        local best_server
        local max_players = tonumber(servers[1]["maxPlayers"])
        local half = max_players / 2
        for i = 1, #servers do
            local server = servers[i]
            local players = tonumber(server["playing"])
            local ping = tonumber(server["ping"])
            if players ~= max_players and players > half and ping < lowest_ping then
                lowest_ping = ping
                most_players = players
                best_server = server["id"]
            end
        end

        if best_server then
            local_player:Kick("H..")
            teleport_service:TeleportToPlaceInstance(game["PlaceId"], best_server)
        else
            new_notification("failed to find server", 3)
        end
    end)
end

-- > ( player data )

do
    local saved_statuses = {}

    create_connection(signals["on_player_status_changed"], function(data, status)
        saved_statuses[data[2]["Name"]] = status
    end)

    local players = menu["groups"]["misc."]:create_panel_section("players", "players", 1)
    local player_editor = menu["groups"]["misc."]:create_section("players", "player editor", 2, 0.4, 0)

    local player_status = player_editor:create_element({["name"] = "status"}, {["dropdown"] = {["flag"] = "0", ["options"] = {"whitelisted", "normal"}, ["default"] = {"normal"}, ["requires_one"] = true}})

    -- >> ( player editor )

    local selected_player = nil

    create_connection(players["on_selection_change"], function(player)
        selected_player = player and find_first_child(players_service, player) or nil

        if selected_player then
            local data = player_data[selected_player]
            local status = data[1]
            local information = data[17]

            player_status:set_dropdown({status == 1 and "normal" or status == 2 and "whitelisted"}, false, true)
        end
    end)

    create_connection(player_status["on_dropdown_change"], function(value)
        if selected_player then
            local data = player_data[selected_player]
            local value = value[1]
            local status = value == "normal" and 1 or value == "whitelisted" and 2 or 3

            if data[1] ~= status then
                data[1] = status
                signals["on_player_status_changed"]:Fire(data, status)

                new_notification(
                    "set "..selected_player["Name"].."'s status to "..(status == 1 and "normal" or status == 2 and "whitelisted"),
                    1
                )
            end
        end
    end)

    create_connection(player_editor:create_element({["name"] = "copy profile link"}, {["button"] = {}})["on_clicked"], function()
        if selected_player then
            setclipboard("https://www.roblox.com/users/"..selected_player["UserId"].."/profile#!/juju")
            new_notification(
                "copied "..selected_player["Name"].."'s profile link to your clipboard",
                1
            )
        end
    end)

    -- >> ( player interactions )

    local player_interactions = menu["groups"]["misc."]:create_section("players", "player interactions", 2, 0.6, 0.4)
        menu_references["auto_set_statuses"] = player_interactions:create_element({["name"] = "auto set statuses"}, {["toggle"] = {["flag"] = "auto_set_statuses"}})
        menu_references["auto_set_statuses_settings"] = menu_references["auto_set_statuses"]:create_settings()
        menu_references["set_whitelisted_if"] = menu_references["auto_set_statuses_settings"]:create_element({["name"] = "set whitelisted if"}, {["dropdown"] = {["flag"] = "set_whitelisted_if", ["options"] = {"is a friend"}, ["default"] = {"is a friend"}, ["multi"] = true}})
        menu_references["set_target_if"] = menu_references["auto_set_statuses_settings"]:create_element({["name"] = "set target if"}, {["dropdown"] = {["flag"] = "set_target_if", ["options"] = {"friends with an target"}, ["default"] = {"friends with an target"}, ["multi"] = true}})
        menu_references["auto_set_statuses_notifications"] = menu_references["auto_set_statuses_settings"]:create_element({["name"] = "notifications"}, {["toggle"] = {["flag"] = "auto_set_statuses_notifications"}})

    local do_whitelisted_is_friend = true
    local do_target_is_mutual_friend = true

    local auto_set_statuses_connection = nil
    local auto_set_status = LPH_JIT_MAX(function(data)
        local old_status = data[1]
        local new_status = nil
        local da_player = data[2]
        local crew = nil

        if data[17] then
            crew = find_first_child(data[17], "Crew")

            if crew then
                local value = crew["Value"]

                if value and #value ~= 0 then
                    crew = value
                end
            end
        end

        if do_whitelisted_is_friend then
            local _, s = pcall(da_player["IsFriendsWith"], da_player, local_player["UserId"])
            if _ and s then
                new_status = 2
            end
        elseif do_target_is_mutual_friend then
            for player, data in player_data do
                if player ~= da_player and data[1] == 3 and data[17] then
                    local s, friends = pcall(function()
                        return da_player:IsFriendsWith(player["UserId"])
                    end)

                    if s and friends then
                        new_status = 3
                        break
                    end
                end
            end
        end

        if new_status and old_status ~= new_status then
            if flags["auto_set_statuses_notifications"] then
                new_notification(
                    "auto set "..da_player["Name"].."'s status to "..(new_status == 2 and "whitelisted" or "target"),
                    1
                )
            end
            data[1] = new_status
            signals["on_player_status_changed"]:Fire(data, new_status)
        end
    end)

    create_connection(menu_references["auto_set_statuses"]["on_toggle_change"], function(value)
        if auto_set_statuses_connection then
            auto_set_statuses_connection:Disconnect()
            auto_set_statuses_connection = nil
        end

        if value then
            for player, data in player_data do
                spawn(auto_set_status, data)
            end

            auto_set_statuses_connection = create_connection(signals["on_player_added"], auto_set_status)
        end
    end)

    create_connection(menu_references["set_whitelisted_if"]["on_dropdown_change"], function(value)
        do_whitelisted_is_friend = false

        for i = 1, #value do
            local value = value[i]
            if value == "is a friend" then
                do_whitelisted_is_friend = true
            end
        end
    end)

    create_connection(menu_references["set_target_if"]["on_dropdown_change"], function(value)
        if value[1] then
            do_target_is_mutual_friend = false

            for i = 1, #value do
                local value = value[i]
                if value == "friends with an target" then
                    do_target_is_mutual_friend = true
                end
            end
        end
    end)

    -- >> ( player data creation )

    local blank_player_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAAMdwEA6AMAAAx3AQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAO7qLRjGzAACAAAAI0lEQVQYV2NgZGRkAAIQBWGB2DiZSGphAEUBhAVkY2MyMAIACxYALVlZOREAAAAASUVORK5CYII=")

    local on_character_added = LPH_JIT_MAX(function(character)
        local humanoid = wait_for_child(character, "Humanoid", 5)
        local head = wait_for_child(character, "Head", 5)

        if not humanoid then
            return
        end

        local player = find_first_child(players_service, character["Name"])
        local data = player_data[player]

        if not data then
            return
        end

        local data_parts = data[4]

        for part, _ in data_parts do
            data_parts[part] = nil
        end

        local children = get_children(character)

        for i = 1, #children do
            local child = children[i]
            data_parts[child["Name"]] = child

            if child["ClassName"] == "Tool" then
                data[13] = child
                signals["on_player_tool_equipped"]:Fire(data, child)
            end
        end

        create_connection(character["ChildAdded"], function(child)
            data_parts[child["Name"]] = child

            if child["ClassName"] == "Tool" then
                data[13] = child
                signals["on_player_tool_equipped"]:Fire(data, child)
            end
        end)

        create_connection(character["ChildRemoved"], function(child)
            data_parts[child["Name"]] = nil

            if child["ClassName"] == "Tool" then
                data[13] = nil
                signals["on_player_tool_equipped"]:Fire(data, nil)
            end
        end)

        local old_health = floor(humanoid["Health"])

        create_connection(humanoid:GetPropertyChangedSignal("Health"), function()
            local health = floor(humanoid["Health"])
            local difference = health - old_health
            data[9] = health

            signals["on_player_health_changed"]:Fire(data, health, difference)
            old_health = health

            if difference < 0 and local_shot then
                local signal = signals["on_local_bullet_confirmed"]
                spawn(signal["Fire"], signal, player, head, tostring(floor(difference)))
            end
        end)

        create_connection(humanoid:GetPropertyChangedSignal("MaxHealth"), function()
            data[10] = floor(humanoid["MaxHealth"])
        end)

        data[3] = character
        data[9] = old_health
        data[10] = floor(humanoid["MaxHealth"])
        data[11] = old_health

        local old_armor = 0

        local function do_death()
            if data[3] == character and not data[7] then
                signals["on_player_died"]:Fire(data)
                signals["on_player_health_changed"]:Fire(data, 0, old_health - 0)
                signals["on_player_tool_equipped"]:Fire(data, nil)
                signals["on_player_armor_changed"]:Fire(data, 0, old_armor - 0)
            end
        end

        if humanoid then
            create_connection(humanoid:GetPropertyChangedSignal("Parent"), function()
                if humanoid["Parent"] == nil then
                    do_death()
                end
            end)
        end
        create_connection(humanoid["Died"], do_death)

        data[7] = false
        data[14] = 0
        data[15] = 0
        data[18] = false
        data[13] = nil

        signals["on_player_character_added"]:Fire(data, character)
        signals["on_player_tool_equipped"]:Fire(data, nil)
        signals["on_player_health_changed"]:Fire(data, old_health, -old_health)
    end)

    local register_player = LPH_JIT_MAX(function(player)
        local status = saved_statuses[player["Name"]]
        local new_data = {
            [1] = status or 1, -- >> status
            [2] = player, -- >> player
            [3] = player["Character"], -- >> character
            [4] = { -- >> parts
                ["Head"] = nil,
                ["Torso"] = nil,
                ["Left Arm"] = nil,
                ["Right Arm"] = nil,
                ["Left Leg"] = nil,
                ["Right Leg"] = nil
            },
            [5] = { -- >> drawings
                [1] = nil,
                [2] = nil,
                [3] = nil,
                [4] = nil,
                [5] = nil,
                [6] = nil,
                [7] = nil,
                [8] = nil,
                [9] = nil,
                [10] = nil,
                [11] = nil,
                [12] = nil,
                [13] = nil
            },
            [6] = false, -- >> rendering
            [7] = false, -- >> dead
            [8] = nil, -- >> highlight
            [9] = 100, -- >> health
            [10] = 100, -- >> max health
            [11] = 100, -- >> fake health
            [12] = {}, -- >> chams
            [13] = nil, -- >> tool
        }

        players:add_item({
            ["text"] = player["Name"],
            ["icons"] = {blank_player_image_data},
            ["text2"] = player["DisplayName"]
        })

        player_data[player] = new_data

        if player["Character"] then
            spawn(on_character_added, player["Character"])
        end

        create_connection(player["CharacterAdded"], on_character_added)
        signals["on_player_added"]:Fire(new_data)

        if status then
            signals["on_player_status_changed"]:Fire(new_data, status)
        end
    end)

    local remove_player = LPH_JIT_MAX(function(player)
        if player == local_player then
            return
        end

        players:remove_item(player["Name"])

        local data = player_data[player]
        local drawings = data[5]
        data[3] = nil

        for _, drawing in drawings do
            drawing:Destroy()
            drawings[_] = nil
        end

        local highlight = data[8]

        if highlight then
            destroy(highlight)
        end

        local chams = data[12]

        if chams then
            for i = 1, #chams do
                destroy(chams[i])
                chams[i] = nil
            end
            data[12] = nil
        end

        if legitbot_target and legitbot_target[1] == data then
            set_legitbot_target(nil, "legitbot target "..player["Name"].." has left")
        end

        player_data[player] = nil
    end)

    local all_players = players_service:GetPlayers()
    for i = 1, #all_players do
        local player = all_players[i]
        if player ~= local_player then
            spawn(register_player, player)
        end
    end

    create_connection(players_service["PlayerAdded"], register_player)
    create_connection(players_service["PlayerRemoving"], remove_player)
end

-- > ( world visuals )

do
    local lighting = game:GetService("Lighting")
    local sky = find_first_child_of_class(lighting, "Sky") or create_instance("Sky", {["Parent"] = lighting, ["Name"] = "\0"})

    local original = {
        ["ClockTime"] = lighting["ClockTime"],
        ["Technology"] = lighting["Technology"],
        ["TimeOfDay"] = lighting["TimeOfDay"],
        ["Ambient"] = lighting["Ambient"],
        ["OutdoorAmbient"] = lighting["OutdoorAmbient"],
    }
    local spoofing = {
        ["ClockTime"] = nil,
        ["TimeOfDay"] = nil,
        ["Technology"] = nil,
        ["Ambient"] = false,
        ["OutdoorAmbient"] = false,
    }

    do -- > ( spoof properties)
        local metatable = getrawmetatable(lighting)
            local old_new_index = metatable["__newindex"]
            local old_index = metatable["__index"]

        local fake_metatable = {
            ["__newindex"] = newcclosure(LPH_NO_VIRTUALIZE(function(self, property, value)
                if self then
                    if not checkcaller() and spoofing[property] then
                        original[property] = value
                        return
                    end
                end
                return old_new_index(self, property, value)
            end)),
            ["__index"] = newcclosure(LPH_NO_VIRTUALIZE(function(self, property)
                if self then
                    if not checkcaller() then
                        return spoofing[property] and original[property] or old_index(self, property)
                    end
                end
                return old_index(self, property)
            end))
        }

        for _, metamethod in metatable do
            if not fake_metatable[_] then
                fake_metatable[_] = metamethod
            end
        end

        setrawmetatable(lighting, fake_metatable)
    end

    menu_references["lighting_section"] = menu["groups"]["visuals"]:create_section("general", "world", 1, 0.6, 0)

    -- >> ( background noise )

    do
        local sounds = {
            ["windy winter"] = "rbxassetid://6046340391",
            ["light rain"] = "rbxassetid://18862087062",
            ["thunderstorm"] = "rbxassetid://4305545740",
            ["night"] = "rbxassetid://179507208",
            ["day"] = "rbxassetid://6189453706"
        }
        local sound = nil

        menu_references["background_noise"] = menu_references["lighting_section"]:create_element({["name"] = "background noise"}, {["toggle"] = {["flag"] = "background_noise"}})
            menu_references["background_noise_settings"] = menu_references["background_noise"]:create_settings()
            menu_references["background_noise_sound"] = menu_references["background_noise_settings"]:create_element({["name"] = "sound"}, {["dropdown"] = {["flag"] = "background_noise_sound", ["requires_one"] = true, ["options"] = {"windy winter", "thunderstorm", "light rain", "night", "day"}, ["use_custom_extensions"] = {"mp3", "ogg", "wav"}, ["default"] = {"night"}}})
            menu_references["background_noise_volume"] = menu_references["background_noise_settings"]:create_element({["name"] = "volume"}, {["slider"] = {["flag"] = "background_noise_volume", ["min"] = 0, ["max"] = 100, ["default"] = 25, ["suffix"] = "%"}})
        
        create_connection(menu_references["background_noise"]["on_toggle_change"], function(value)
            if sound then
                destroy(sound)
                sound = nil
            end

            if value then
                sound = create_instance("Sound", {
                    ["SoundId"] = sounds[flags["background_noise_sound"][1]],
                    ["Volume"] = flags["background_noise_volume"]/65,
                    ["Looped"] = true,
                    ["Name"] = "\0",
                    ["Parent"] = hui
                })

                sound["Play"](sound)
            end
        end)

        create_connection(menu_references["background_noise_volume"]["on_slider_change"], function(value)
            if sound then
                sound["Volume"] = value/65
            end
        end)

        create_connection(menu_references["background_noise_sound"]["on_dropdown_change"], function(value)
            local value = value[1]

            local new_sound = sounds[value]

            if not new_sound then
                local path = "juju recode/custom/"..value

                if isfile(path) then
                    local s, data = pcall(getcustomasset, path)

                    if not s then
                        new_notification(
                            "failed to load background noise "..value,
                            3
                        )
                    else
                        new_sound = data
                    end

                    sounds[value] = new_sound
                end
            end

            if sound then
                sound["SoundId"] = new_sound
                sound["Stop"](sound)
                sound["Play"](sound)
            end
        end)
    end

    -- > ( lighting mode )

    menu_references["lighting_mode"] = menu_references["lighting_section"]:create_element({["name"] = "lighting mode"}, {["toggle"] = {["flag"] = "lighting_mode"}, ["dropdown"] = {["flag"] = "lighting_mode_value", ["options"] = {"compatibility", "shadowmap", "unified", "future", "legacy", "voxel"}, ["default"] = {lighting["Technology"]["Name"]:lower()}, ["requires_one"] = true}})

    create_connection(menu_references["lighting_mode"]["on_toggle_change"], function(value)
        if value then
            local value = flags["lighting_mode_value"][1]

            spoofing["Technology"] = true
            lighting["Technology"] = Enum["Technology"][value == "shadowmap" and "ShadowMap" or value:gsub("^.", string["upper"])]
        else
            spoofing["Technology"] = nil
            lighting["Technology"] = original["Technology"]
        end
    end)

    create_connection(menu_references["lighting_mode"]["on_dropdown_change"], function(value)
        if flags["lighting_mode"] then
            local value = value[1]
            lighting["Technology"] = Enum["Technology"][value == "shadowmap" and "ShadowMap" or value:gsub("^.", string["upper"])]
        end
    end)

    menu_references["world_time"] = menu_references["lighting_section"]:create_element({["name"] = "world time"}, {["toggle"] = {["flag"] = "world_time"}, ["slider"] = {["flag"] = "world_time_value", ["min"] = 0, ["max"] = 24, ["decimals"] = 1, ["suffix"] = "", ["prefix"] = "hour ", ["default"] = 4.5}})

    create_connection(menu_references["world_time"]["on_toggle_change"], function(value)
        if value then
            local time = flags["world_time_value"]
            spoofing["ClockTime"] = true
            spoofing["TimeOfDay"] = true
            lighting["ClockTime"] = time
        else
            spoofing["ClockTime"] = nil
            spoofing["TimeOfDay"] = nil
            lighting["ClockTime"] = original["ClockTime"]
        end
    end)

    create_connection(menu_references["world_time"]["on_slider_change"], function(value)
        if flags["world_time"] then
            lighting["ClockTime"] = value
        end
    end)

    -- >> ( atmosphere )

    menu_references["atmosphere"] = menu_references["lighting_section"]:create_element({["name"] = "atmosphere"}, {["toggle"] = {["flag"] = "atmosphere"}})
        menu_references["atmosphere_settings"] = menu_references["atmosphere"]:create_settings()
        menu_references["atmosphere_color"] = menu_references["atmosphere_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "atmosphere_color", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0, ["transparency_flag"] = "atmosphere_transparency"}})
        menu_references["atmosphere_decay"] = menu_references["atmosphere_settings"]:create_element({["name"] = "decay"}, {["colorpicker"] = {["color_flag"] = "decay_color", ["default_color"] = color3_fromrgb(120, 120, 120), ["default_transparency"] = 0, ["transparency_flag"] = "decay_transparency"}})
        menu_references["atmosphere_haze"] = menu_references["atmosphere_settings"]:create_element({["name"] = "haze"}, {["slider"] = {["flag"] = "haze", ["min"] = 0, ["max"] = 10, ["decimals"] = 3, ["suffix"] = "", ["prefix"] = "", ["default"] = 1}})
        menu_references["atmosphere_glare"] = menu_references["atmosphere_settings"]:create_element({["name"] = "glare"}, {["slider"] = {["flag"] = "glare", ["min"] = 0, ["max"] = 10, ["decimals"] = 3, ["suffix"] = "", ["prefix"] = "", ["default"] = 10}})
        menu_references["atmosphere_offset"] = menu_references["atmosphere_settings"]:create_element({["name"] = "offset"}, {["slider"] = {["flag"] = "offset", ["min"] = 0, ["max"] = 1, ["decimals"] = 3, ["suffix"] = "", ["prefix"] = "", ["default"] = 0}})
        menu_references["atmosphere_density"] = menu_references["atmosphere_settings"]:create_element({["name"] = "density"}, {["slider"] = {["flag"] = "density", ["min"] = 0, ["max"] = 1, ["decimals"] = 3, ["suffix"] = "", ["prefix"] = "", ["default"] = 0.35}})

    local atmosphere = nil

    create_connection(menu_references["atmosphere"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
        if atmosphere then
            destroy(atmosphere)
            atmosphere = nil
        end

        if value then
            atmosphere = create_instance("Atmosphere", {
                ["Color"] = flags["atmosphere_color"],
                ["Density"] = flags["density"],
                ["Glare"] = flags["glare"],
                ["Haze"] = flags["haze"],
                ["Offset"] = flags["offset"],
                ["Decay"] = flags["decay_color"],
                ["Parent"] = lighting
            })
        end
    end))

    create_connection(menu_references["atmosphere_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(value)
        if atmosphere then
            atmosphere["Color"] = value
        end
    end))

    create_connection(menu_references["atmosphere_decay"]["on_color_change"], function(value)
        if atmosphere then
            atmosphere["Decay"] = value
        end
    end)

    create_connection(menu_references["atmosphere_haze"]["on_slider_change"], LPH_NO_VIRTUALIZE(function(value)
        if atmosphere then
            atmosphere["Haze"] = value
        end
    end))

    create_connection(menu_references["atmosphere_glare"]["on_slider_change"], LPH_NO_VIRTUALIZE(function(value)
        if atmosphere then
            atmosphere["Glare"] = value
        end
    end))

    create_connection(menu_references["atmosphere_offset"]["on_slider_change"], LPH_NO_VIRTUALIZE(function(value)
        if atmosphere then
            atmosphere["Offset"] = value
        end
    end))

    create_connection(menu_references["atmosphere_density"]["on_slider_change"], function(value)
        if atmosphere then
            atmosphere["Density"] = value
        end
    end)

    -- >> ( saturation )

    local color_correction = find_first_child_of_class(lighting, "ColorCorrectionEffect") or create_instance("ColorCorrectionEffect", {["Parent"] = lighting, ["Name"] = "\0"})

    menu_references["saturation"] = menu_references["lighting_section"]:create_element({["name"] = "saturation"}, {["toggle"] = {["flag"] = "saturation"}, ["slider"] = {["min"] = -1, ["max"] = 1, ["decimals"] = 2, ["default"] = round(color_correction["Saturation"], 2), ["flag"] = "saturation_value"}})

    create_connection(menu_references["saturation"]["on_toggle_change"], function(value)
        if color_correction then
            color_correction["Saturation"] = value and flags["saturation_value"] or 0.1
        end
    end)

    create_connection(menu_references["saturation"]["on_slider_change"], function(value)
        if color_correction and flags["saturation"] then
            color_correction["Saturation"] = value
        end
    end)

    -- >> ( contrast )

    menu_references["contrast"] = menu_references["lighting_section"]:create_element({["name"] = "contrast"}, {["toggle"] = {["flag"] = "contrast"}, ["slider"] = {["min"] = -1, ["max"] = 1, ["decimals"] = 2, ["default"] = round(color_correction["Contrast"], 2), ["flag"] = "contrast_value"}})

    create_connection(menu_references["contrast"]["on_toggle_change"], function(value)
        if color_correction then
            color_correction["Contrast"] = value and flags["contrast_value"] or 0.05
        end
    end)

    create_connection(menu_references["contrast"]["on_slider_change"], function(value)
        if color_correction and flags["contrast"] then
            color_correction["Contrast"] = value
        end
    end)

    -- >> ( textures )

    local textures_connection = nil
    local material_service = cloneref(game:GetService("MaterialService"))

    local texture_packs = {
        ["minecraft"] = {
            ["Slate"] = "http://www.roblox.com/asset/?id=8676746437",
            ["Grass"] = "http://www.roblox.com/asset/?id=9267183930",
            ["Sand"] = "http://www.roblox.com/asset/?id=12624140843",
            ["Wood"] = "http://www.roblox.com/asset/?id=3258599312",
            ["Brick"] = "http://www.roblox.com/asset/?id=10777285622",
            ["Concrete"] = "http://www.roblox.com/asset/?id=15622710576",
            ["CorrodedMetal"] = "rbxassetid://78612695839404",
            ["Metal"] = "http://www.roblox.com/asset/?id=121650613091353",
            ["WoodPlanks"] = "http://www.roblox.com/asset/?id=8676581022"
        },
    }
    
    local restores = {}
    local textures = texture_packs["minecraft"]
    local variants = {}

    menu_references["textures"] = menu_references["lighting_section"]:create_element({["name"] = "textures"}, {["toggle"] = {["flag"] = "textures"}})
        menu_references["textures_settings"] = menu_references["textures"]:create_settings()
        menu_references["textures_pack"] = menu_references["textures_settings"]:create_element({["name"] = "pack"}, {["dropdown"] = {["flag"] = "textures_pack", ["options"] = {"minecraft"}, ["default"] = {"minecraft"}, ["use_custom_extensions"] = {"json", "txt", "ink", "textures"}, ["requires_one"] = true}})

    local apply_texture = LPH_NO_VIRTUALIZE(function(descendant)
        local class_name = descendant["ClassName"]
        local white = color3_fromrgb(254, 253, 255)

        if class_name == "MeshPart" or class_name == "Part" then
            local texture = textures[descendant["Material"]["Name"]]

            if (texture or descendant["Color"] == white) and descendant["Transparency"] < 0.8 then
                if not restores[descendant] then
                    restores[descendant] = descendant["Color"]

                    descendant["Color"] = white
                end
            end
        end
    end)

    local gf = game_data["map_folder"] or workspace

    local apply_textures = LPH_NO_VIRTUALIZE(function()
        for i = 1, #variants do
            destroy(variants[i])
            variants[i] = nil
        end

        for name, id in textures do
            if name ~= "Glass" then
                local material = create_instance("MaterialVariant", {
                    ["MetalnessMap"] = id,
                    ["NormalMap"] = id,
                    ["BaseMaterial"] = Enum["Material"][name],
                    ["Name"] = name,
                    ["StudsPerTile"] = 5,
                    ["RoughnessMap"] = id,
                    ["Parent"] = material_service,
                    ["ColorMap"] = id,
                })
                variants[#variants+1] = material
            end
        end

        local descendants = gf:GetDescendants()

        for i = 1, #descendants do
            apply_texture(descendants[i])
        end
    end)

    local get_textures = LPH_JIT_MAX(function(value)
        local path = "juju recode/custom/"..value

        if isfile(path) then
            local s, data = pcall(function()
                return http_service:JSONDecode(readfile(path))
            end)

            if s and data then
                local texture_pack = {}

                for property, value in data do
                    texture_pack[property] = value
                end

                texture_packs[value] = texture_pack

                textures = texture_pack
                if textures_connection then
                    apply_textures()
                end
            else
                new_notification(
                    "failed to load file "..value,
                    3
                )
            end
        end
    end)

    create_connection(menu_references["textures"]["on_toggle_change"], LPH_JIT_MAX(function(value)
        if textures_connection then
            textures_connection:Disconnect()
            textures_connection = nil
        end

        if value then
            textures_connection = create_connection((game_data["map_folder"] or workspace)["DescendantAdded"], apply_texture)
            apply_textures()
        else
            for i = 1, #variants do
                destroy(variants[i])
                variants[i] = nil
            end
            for part, data in restores do
                part["Color"] = data
                restores[part] = nil
            end
        end
    end))

    create_connection(menu_references["textures_pack"]["on_dropdown_change"], LPH_NO_VIRTUALIZE(function(value)
        local value = value[1]
        textures = texture_packs[value]

        if not textures then
            get_textures(value)
            textures = texture_packs[value]
        end

        textures = texture_packs[value]
    end))

    -- >> ( ambient )

    menu_references["ambient"] = menu_references["lighting_section"]:create_element({["name"] = "ambient"}, {["toggle"] = {["flag"] = "ambient"}})
        menu_references["ambient_settings"] = menu_references["ambient"]:create_settings()
        menu_references["ambient_outdoor_color"] = menu_references["ambient_settings"]:create_element({["name"] = "outdoor color"}, {["colorpicker"] = {["color_flag"] = "outdoor_color", ["default_color"] = lighting["OutdoorAmbient"], ["default_transparency"] = 0, ["transparency_flag"] = "outdoor_transparency"}})
        menu_references["ambient_color"] = menu_references["ambient_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "ambient_color", ["default_color"] = lighting["Ambient"], ["default_transparency"] = 0, ["transparency_flag"] = "ambient_transparency"}})

    create_connection(menu_references["ambient"]["on_toggle_change"], function(value)
        if value then
            spoofing["Ambient"] = true
            lighting["Ambient"] = flags["ambient_color"]
            spoofing["OutdoorAmbient"] = true
            lighting["OutdoorAmbient"] = flags["outdoor_color"]
        else
            spoofing["Ambient"] = false
            spoofing["OutdoorAmbient"] = false
            lighting["Ambient"] = original["Ambient"]
            lighting["OutdoorAmbient"] = original["OutdoorAmbient"]
        end
    end)

    create_connection(menu_references["ambient_color"]["on_color_change"], function(color)
        if flags["ambient"] then
            lighting["Ambient"] = color
        end
    end)

    create_connection(menu_references["ambient_outdoor_color"]["on_color_change"], function(color)
        if flags["ambient"] then
            lighting["OutdoorAmbient"] = color
        end
    end)

        -- >> ( weather )

        menu_references["weather"] = menu_references["lighting_section"]:create_element({["name"] = "weather"}, {["toggle"] = {["flag"] = "weather"}})
        menu_references["weather_settings"] = menu_references["weather"]:create_settings()
        menu_references["weather_type"] = menu_references["weather_settings"]:create_element({["name"] = "type"}, {["dropdown"] = {["flag"] = "weather_type", ["options"] = {"light rain", "rain", "snow"}, ["default"] = {"rain"}, ["requires_one"] = true}})
        menu_references["weather_color"] = menu_references["weather_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "weather_color", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0, ["transparency_flag"] = "weather_transparency"}})
        menu_references["weather_rate"] = menu_references["weather_settings"]:create_element({["name"] = "rate"}, {["slider"] = {["flag"] = "weather_rate", ["min"] = 1, ["max"] = 100, ["default"] = 100, ["suffix"] = "%"}})

    local weather_part = nil
    local weather_particle = nil

    local weather_types = {
        ["rain"] = {
            ["Speed"] = NumberRange.new(60, 60),
            ["LockedToPart"] = true,
            ["Rate"] = 600,
            ["Texture"] = "rbxassetid://1822883048",
            ["EmissionDirection"] = Enum.NormalId.Bottom,
            ["Transparency"] = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.25, 0.7842668294906616),
            NumberSequenceKeypoint.new(0.75, 0.7842668294906616),
            NumberSequenceKeypoint.new(1, 1)
            },
            ["Lifetime"] = NumberRange.new(0.800000011920929, 0.800000011920929),
            ["LightEmission"] = 0.05000000074505806,
            ["LightInfluence"] = 0.8999999761581421,
            ["Orientation"] = Enum.ParticleOrientation.FacingCameraWorldUp,
            ["Size"] = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 10),
            NumberSequenceKeypoint.new(1, 10)
            }
        },
        ["snow"] = {
            ["Transparency"] = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.7374999523162842),
                NumberSequenceKeypoint.new(0.973, 0.768750011920929),
                NumberSequenceKeypoint.new(1, 1)
            },
            ["Texture"] = "http://www.roblox.com/asset/?id=99851851",
            ["SpreadAngle"] = Vector2.new(50, 50),
            ["Speed"] = NumberRange.new(30, 30),
            ["LightEmission"] = 0.5,
            ["Rate"] = 1000,
            ["EmissionDirection"] = Enum.NormalId.Bottom,
            ["Size"] = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.33096909523010254),
                NumberSequenceKeypoint.new(0.551, 0.40189146995544434),
                NumberSequenceKeypoint.new(1, 0.33096909523010254)
            }
        },
        ["light rain"] = {
            ["LockedToPart"] = true,
            ["Rate"] = 500,
                ["Squash"] = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 3),
                NumberSequenceKeypoint.new(1, 3)
            },
                ["LightInfluence"] = 0.30000001192092896,
                ["Transparency"] = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.435, 0),
                NumberSequenceKeypoint.new(1, 1)
            },
            ["Texture"] = "rbxasset://textures/particles/sparkles_main.dds",
            ["Speed"] = NumberRange.new(30, 50),
            ["Lifetime"] = NumberRange.new(9, 9),
            ["LightEmission"] = 0.5,
            ["Brightness"] = 2,
            ["EmissionDirection"] = Enum.NormalId.Bottom,
            ["Orientation"] = Enum.ParticleOrientation.FacingCameraWorldUp,
            ["Size"] = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.20000000298023224),
                NumberSequenceKeypoint.new(1, 0.20000000298023224)
            }
        }
    }

    local offset = vector3_new(0, 20, 0)

    local do_weather = LPH_NO_VIRTUALIZE(function(dt, hrp)
        weather_part["CFrame"] = cframe_new(camera["CFrame"]["p"]) + offset
    end)

    local ignored = ignored[1] or workspace

    create_connection(menu_references["weather"]["on_toggle_change"], function(value)
        if weather_part then
            destroy(weather_part)
            weather_part = nil
            weather_particle = nil
        end

        for i = 1, #heartbeat do
            if heartbeat[i] == do_weather then
                remove(heartbeat, i)
                break
            end
        end

        if value then
            weather_part = create_instance("Part", {
                ["Size"] = vector3_new(40, 40, 85),
                ["CanCollide"] = false,
                ["Massless"] = true,
                ["CastShadow"] = false,
                ["Transparency"] = 1,
                ["Anchored"] = true,
                ["Name"] = "\0",
                ["Parent"] = ignored
            })

            local data = weather_types[flags["weather_type"][1]]
            local color = ColorSequence.new(flags["weather_color"])
            weather_particle = create_instance("ParticleEmitter", data)
            weather_particle["Color"] = color
            weather_particle["Parent"] = weather_part

            heartbeat[#heartbeat+1] = do_weather
        end
    end)

    create_connection(menu_references["weather_type"]["on_dropdown_change"], function(value)
        if weather_particle then
            destroy(weather_particle)
            weather_particle = nil

            weather_particle = create_instance("ParticleEmitter", weather_types[value[1]])
            weather_particle["Color"] = ColorSequence.new(flags["weather_color"])
            weather_particle["Parent"] = weather_part
        end
    end)

    create_connection(menu_references["weather_color"]["on_color_change"], function(color)
        if weather_particle then
            local color = ColorSequence.new(color)
            weather_particle["Color"] = color
        end
    end)

    create_connection(menu_references["weather_rate"]["on_slider_change"], function(value)
        local rate = 1000 * (value/100)

        if weather_particle then
            weather_particle["Rate"] = rate
        end

        for weather, data in weather_types do
            weather_types[weather]["Rate"] = rate
        end
    end)

    -- >> ( skybox )

    local skyboxes = {
        ["default"] = {
            ["SkyboxBk"] = sky["SkyboxBk"],
            ["SkyboxDn"] = sky["SkyboxDn"],
            ["SkyboxFt"] = sky["SkyboxFt"],
            ["SkyboxLf"] = sky["SkyboxLf"],
            ["SkyboxRt"] = sky["SkyboxRt"],
            ["SkyboxUp"] = sky["SkyboxUp"],
            ["SunTextureId"] = sky["SunTextureId"],
            ["MoonTextureId"] = sky["MoonTextureId"]
        },
        ["stormy"] = {
            ["SkyboxUp"] = "http://www.roblox.com/asset/?id=18703232671",
            ["SkyboxBk"] = "http://www.roblox.com/asset/?id=18703245834",
            ["SkyboxLf"] = "http://www.roblox.com/asset/?id=18703237556",
            ["SkyboxDn"] = "http://www.roblox.com/asset/?id=18703243349",
            ["SkyboxFt"] = "http://www.roblox.com/asset/?id=18703240532",
            ["SkyboxRt"] = "http://www.roblox.com/asset/?id=18703235430",
            ["SunTextureId"] = sky["SunTextureId"],
            ["MoonTextureId"] = sky["MoonTextureId"]
        },
        ["blue space"] = {
            ["SkyboxLf"] = "rbxassetid://15536114370",
            ["SkyboxUp"] = "rbxassetid://15536117282",
            ["SkyboxRt"] = "rbxassetid://15536118762",
            ["SkyboxFt"] = "rbxassetid://15536116141",
            ["SkyboxDn"] = "rbxassetid://15536112543",
            ["SkyboxBk"] = "rbxassetid://15536110634",
            ["SunTextureId"] = sky["SunTextureId"],
            ["MoonTextureId"] = sky["MoonTextureId"]
        },
        ["pink"] = {
            ["SkyboxUp"] = "rbxassetid://12216108877",
            ["SkyboxLf"] = "rbxassetid://12216110170",
            ["SkyboxRt"] = "rbxassetid://12216110471",
            ["SkyboxFt"] = "rbxassetid://12216109489",
            ["SkyboxBk"] = "rbxassetid://12216109205",
            ["SkyboxDn"] = "rbxassetid://12216109875",
            ["SunTextureId"] = sky["SunTextureId"],
            ["MoonTextureId"] = sky["MoonTextureId"]
        },
        ["black storm"] = {
            ["SkyboxLf"] = "rbxassetid://15502507918",
            ["SkyboxUp"] = "rbxassetid://15502511911",
            ["SkyboxRt"] = "rbxassetid://15502509398",
            ["SkyboxFt"] = "rbxassetid://15502510289",
            ["SkyboxDn"] = "rbxassetid://15502508460",
            ["SkyboxBk"] = "rbxassetid://15502511288",
            ["SunTextureId"] = sky["SunTextureId"],
            ["MoonTextureId"] = sky["MoonTextureId"]
        },
        ["realistic"] = {
            ["SkyboxUp"] = "rbxassetid://653719321",
            ["SkyboxDn"] = "rbxassetid://653718790",
            ["SkyboxLf"] = "rbxassetid://653719190",
            ["SkyboxFt"] = "rbxassetid://653719067",
            ["SkyboxRt"] = "rbxassetid://653718931",
            ["SkyboxBk"] = "rbxassetid://653719502",
            ["SunTextureId"] = sky["SunTextureId"],
            ["MoonTextureId"] = sky["MoonTextureId"]
        }
    }

    menu_references["skybox"] = menu_references["lighting_section"]:create_element({["name"] = "skybox"}, {["toggle"] = {["flag"] = "skybox"}})
        menu_references["skybox_settings"] = menu_references["skybox"]:create_settings()
        menu_references["skybox_value"] = menu_references["skybox_settings"]:create_element({["name"] = "sky"}, {["dropdown"] = {["flag"] = "skybox_value", ["requires_one"] = true, ["options"] = {"black storm", "blue space", "realistic", "stormy", "pink"}, ["use_custom_extensions"] = {"rbxm"}, ["default"] = {"black storm"}}})

    local apply_skybox = LPH_NO_VIRTUALIZE(function(skybox)
        local ids = skyboxes[skybox]

        sky["SkyboxBk"] = ids["SkyboxBk"]
        sky["SkyboxDn"] = ids["SkyboxDn"]
        sky["SkyboxFt"] = ids["SkyboxFt"]
        sky["SkyboxLf"] = ids["SkyboxLf"]
        sky["SkyboxRt"] = ids["SkyboxRt"]
        sky["SkyboxUp"] = ids["SkyboxUp"]
        sky["SunTextureId"] = ids["SunTextureId"]
        sky["MoonTextureId"] = ids["MoonTextureId"]
    end)

    create_connection(menu_references["skybox"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
        apply_skybox(value and flags["skybox_value"][1] or "default")
    end))

    create_connection(menu_references["skybox_value"]["on_dropdown_change"], LPH_JIT_MAX(function(value)
        local value = value[1]

        if not skyboxes[value] then
            local new_skybox = game:GetObjects(getcustomasset("juju recode/custom/"..value))[1]
            skyboxes[value] = new_skybox
        end

        if flags["skybox"] then
            apply_skybox(value)
        end
    end))

    -- >> ( tint )

    menu_references["tint"] = menu_references["lighting_section"]:create_element({["name"] = "tint"}, {["toggle"] = {["flag"] = "tint"}, ["colorpicker"] = {["color_flag"] = "tint_color", ["default_color"] = color_correction["TintColor"], ["transparency_flag"] = "tint_transparency", ["default_transparency"] = 0}})

    create_connection(menu_references["tint"]["on_toggle_change"], function(value)
        if color_correction then
            color_correction["TintColor"] = value and flags["tint_color"] or color3_fromrgb(255,255,255)
        end
    end)

    create_connection(menu_references["tint"]["on_color_change"], function(value)
        if flags["tint"] and color_correction then
            color_correction["TintColor"] = value
        end
    end)
end

-- >> ( game )

do
    local numbersequencekeypointnew = NumberSequenceKeypoint["new"]
    local numbersequencenew = NumberSequence["new"]

    menu_references["hud_section"] = menu["groups"]["visuals"]:create_section("general", "hud", 1, 0.4, 0.6)
        menu_references["server_position_indicator"] = menu_references["hud_section"]:create_element({["name"] = "server position indicator"}, {["toggle"] = {["flag"] = "server_position_indicator"}})
        menu_references["server_position_indicator_settings"] = menu_references["server_position_indicator"]:create_settings()
        menu_references["smooth_server_position_indicator"] = menu_references["server_position_indicator_settings"]:create_element({["name"] = "smooth"}, {["toggle"] = {["flag"] = "smooth_server_position_indicator"}})

        menu_references["server_position_indicator_icon_color"] = menu_references["server_position_indicator_settings"]:create_element({["name"] = "icon color"}, {["colorpicker"] = {["color_flag"] = "server_position_indicator_icon_color", ["default_color"] = color3_fromrgb(193, 247, 255), ["default_transparency"] = 0.89, ["transparency_flag"] = "server_position_indicator_icon_transparency"}})
        menu_references["server_position_indicator_glow_color"] = menu_references["server_position_indicator_settings"]:create_element({["name"] = "glow color"}, {["colorpicker"] = {["color_flag"] = "server_position_indicator_glow_color", ["default_color"] = color3_fromrgb(193, 247, 255), ["default_transparency"] = 0.9, ["transparency_flag"] = "server_position_indicator_glow_transparency"}})
        menu_references["server_position_indicator_background_color"] = menu_references["server_position_indicator_settings"]:create_element({["name"] = "background color"}, {["colorpicker"] = {["color_flag"] = "server_position_indicator_background_color", ["default_color"] = color3_fromrgb(15, 15, 15), ["default_transparency"] = 0.89, ["transparency_flag"] = "server_position_indicator_background_transparency"}})
        menu_references["aspect_ratio"] = menu_references["hud_section"]:create_element({["name"] = "aspect ratio"}, {["toggle"] = {["flag"] = "aspect_ratio"}, ["slider"] = {["flag"] = "aspect_ratio_value", ["min"] = 0.1, ["max"] = 1.2, ["default"] = 1, ["decimals"] = 2, ["suffix"] = "x"}})

    -- >> ( aspect ratio )

    local multiplier = cframe_new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    local last_tween_value = 0

    local tween_function = nil

    local do_aspect_ratio = LPH_NO_VIRTUALIZE(function(dt)
        render_stepped_wait(render_stepped)
        camera["CFrame"]*=multiplier
    end)

    local tween_ratio = LPH_JIT_MAX(function(new_value, force)
        if tween_function then
            for i = 1, #heartbeat do
                if heartbeat[i] == tween_function then
                    remove(heartbeat, i)
                    break
                end
            end
        end

        local elapsed_time = 0
        local old_last_tween_value = last_tween_value

        local new_tween_function = function(dt)
            elapsed_time+=dt
            last_tween_value = old_last_tween_value + (new_value - old_last_tween_value) * get_value(tween_service, elapsed_time/0.16, circular, out)
            multiplier = cframe_new(0, 0, 0, 1, 0, 0, 0, last_tween_value, 0, 0, 0, 1)
            if force then
                render_stepped_wait(render_stepped)
                camera["CFrame"]*=multiplier
            end
        end

        tween_function = new_tween_function

        multiplier = cframe_new(0, 0, 0, 1, 0, 0, 0, last_tween_value, 0, 0, 0, 1)

        heartbeat[#heartbeat+1] = tween_function

        delay(0.16, function()
            for i = 1, #heartbeat do
                if heartbeat[i] == new_tween_function then
                    remove(heartbeat, i)
                    multiplier = cframe_new(0, 0, 0, 1, 0, 0, 0, new_value, 0, 0, 0, 1)
                    break
                end
            end
        end)
    end)

    create_connection(menu_references["aspect_ratio"]["on_toggle_change"], function(value)
        for i = 1, #heartbeat do
            if heartbeat[i] == do_aspect_ratio then
                remove(heartbeat, i)
                break
            end
        end

        if value then
            last_tween_value = 1
            multiplier = cframe_new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            tween_ratio(flags["aspect_ratio_value"])
            heartbeat[#heartbeat+1] = do_aspect_ratio
        else
            tween_ratio(1, true)
        end
    end)

    create_connection(menu_references["aspect_ratio"]["on_slider_change"], function(value)
        tween_ratio(value)
    end)

    -- >> ( server position indicator )

    local visible = false
    local circle = nil
    local image = nil
    local glow = nil
    local shadow_transparency = {["Transparency"] = 0.09}
    local circle_transparency = {["Transparency"] = 0.8}
    local image_transparency = {["Transparency"] = 0.8}
    local offset = vector3_new(0, 0.5, 0)
    local data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAB0AAAAdCAMAAABhTZc9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAPUExURQAAAP///wwMDP39/QAAAJn0DigAAAAFdFJOU/////8A+7YOUwAAAAlwSFlzAABLlgAAS5YBPIKNxAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAD7fwcA6AMAAPt/BwDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAFgdiCkiK10LAAAAZ0lEQVQ4T+XT0QqAMAgF0Gv5/9/cdJrXPYweopeEoe5MGKOgHMDSR/aAiPSNyBaGnT9S4Oi3pnqOtuEqE5kfaiHxG8pYTJoHrMzdzFu1h0qt57oLH58a/YhFfUU/4s967tT/Iv4mVS+LEAmXjonxPAAAAABJRU5ErkJggg==")
    local last_pos = nil
    local do_smooth_server_position_indicator = nil

    local do_server_position_indicator = LPH_JIT_MAX(function(dt)
        if local_client_position ~= local_server_position then
            local local_server_position = local_server_position["p"]
            
            local pos, on_screen = world_to_viewport_point(camera, local_server_position)

            if do_smooth_server_position_indicator then
                if not last_pos then
                    last_pos = pos
                end
                pos = last_pos + (pos - last_pos) * dt*4^2
            end

            last_pos = pos
            if not on_screen and visible then
                tween(glow, hide_transparency, circular, out, 0)
                tween(image, hide_transparency, circular, out, 0)
                tween(circle, hide_transparency, circular, out, 0)
                visible = false
                return
            elseif not visible and on_screen then
                spawn(function()
                    tween(glow, shadow_transparency, circular, out, 0.07)
                    tween(image, image_transparency, circular, out, 0.07)
                    tween(circle, circle_transparency, circular, out, 0.07)
                end)
                visible = true
            elseif not visible and not on_screen then
                visible = false
                return
            end

            local pos2, _ = world_to_viewport_point(camera, local_server_position + offset)

            local size = clamp((pos["Y"]-pos2["Y"])*10, 35, 45)

            local pos = vector2_new(pos["X"], pos["Y"])
            circle["Size"] = vector2_new(size, size)
            circle["Position"] = pos - vector2_new(size/2, size/2)

            local image_size = vector2_new(size*0.6, size*0.6)
            image["Position"] = pos - image_size/2
            image["Size"] = image_size

            local glow_size = vector2_new(size*1.08, size*1.08)
            glow["Position"] = pos - glow_size/2
            glow["Size"] = glow_size
        elseif visible then
            visible = false
            tween(glow, hide_transparency, circular, out, 0.09)
            tween(image, hide_transparency, circular, out, 0.09)
            tween(circle, hide_transparency, circular, out, 0.09)
        end
    end)

    local create_drawing = identifyexecutor() == "Wave" and create_fake_drawing or create_real_drawing

    create_connection(menu_references["smooth_server_position_indicator"]["on_toggle_change"], function(value)
        last_pos = nil
        do_smooth_server_position_indicator = value
    end)

    create_connection(menu_references["server_position_indicator"]["on_toggle_change"], function(value)
        last_pos = nil
        for i = 1, #heartbeat do
            if heartbeat[i] == do_server_position_indicator then
                remove(heartbeat, i)
                break
            end
        end

        visible = false

        if circle then
            circle:Destroy()
            circle = nil
        end

        if image then
            image:Destroy()
            image = nil
        end

        if glow then
            glow:Destroy()
            glow = nil
        end

        visible = false

        if value then
            circle = create_drawing("Image", {
                ["Color"] = flags["server_position_indicator_background_color"],
                ["Transparency"] = 0,
                ["ZIndex"] = 1,
                ["Visible"] = true,
                ["Data"] = pixel_image_data,
                ["Rounding"] = 30,
                ["Position"] = vector2_new(0, 0),
                ["Size"] = vector2_new(65, 65),
            })

            image = create_drawing("Image", {
                ["Color"] = flags["server_position_indicator_icon_color"],
                ["Transparency"] = 0,
                ["ZIndex"] = 2,
                ["Visible"] = true,
                ["Data"] = data,
                ["Position"] = vector2_new(0, 0),
                ["Size"] = vector2_new(29, 29),
            })

            glow = create_drawing("Image", {
                ["Color"] = flags["server_position_indicator_glow_color"],
                ["Transparency"] = 0,
                ["ZIndex"] = 3,
                ["Visible"] = true,
                ["Data"] = shadow_image_data,
                ["Rounding"] = 36,
                ["Position"] = vector2_new(0, 0),
                ["Size"] = vector2_new(73, 73)
            })

            heartbeat[#heartbeat+1] = do_server_position_indicator
        end
    end)

    create_connection(menu_references["server_position_indicator_glow_color"]["on_color_change"], function(value)
        if glow then
            glow["Color"] = value
        end
    end)

    create_connection(menu_references["server_position_indicator_glow_color"]["on_transparency_change"], function(value)
        if glow and visible then
            glow["Transparency"] = -value+1
            shadow_transparency["Transparency"] = {["Transparency"] = -value+1}
        end
    end)

    create_connection(menu_references["server_position_indicator_icon_color"]["on_color_change"], function(value)
        if image then
            image["Color"] = value
        end
    end)

    create_connection(menu_references["server_position_indicator_icon_color"]["on_transparency_change"], function(value)
        if image and visible then
            image["Transparency"] = -value+1
            image_transparency["Transparency"] = {["Transparency"] = -value+1}
        end
    end)

    create_connection(menu_references["server_position_indicator_background_color"]["on_color_change"], function(value)
        if circle then
            circle["Color"] = value
        end
    end)

    create_connection(menu_references["server_position_indicator_background_color"]["on_transparency_change"], function(value)
        if circle and visible then
            circle["Transparency"] = -value+1
            circle_transparency["Transparency"] = {["Transparency"] = -value+1}
        end
    end)

    menu_references["game_section"] = menu["groups"]["visuals"]:create_section("general", "game", 2, 0.65, 0)
    menu_references["shot_notifications"] = menu_references["game_section"]:create_element({["name"] = "shot notifications"}, {["toggle"] = {["flag"] = "shot_notifications"}})
        menu_references["shot_notifications_settings"] = menu_references["shot_notifications"]:create_settings()
        menu_references["shot_notifications_notify_when"] = menu_references["shot_notifications_settings"]:create_element({["name"] = "notify when"}, {["dropdown"] = {["options"] = {"shot hit"}, ["requires_one"] = false, ["multi"] = true, ["flag"] = "shot_notifications_notify_when", ["default"] = {"shot hit"}}})
        menu_references["shot_notifications_failed_color"] = menu_references["shot_notifications_settings"]:create_element({["name"] = "failed color"}, {["colorpicker"] = {["color_flag"] = "shot_notifications_failed_color", ["transparency_flag"] = "failed_transparency", ["default_color"] = color3_fromrgb(255, 134, 134), ["default_transparency"] = 0}})
        menu_references["shot_notifications_hit_color"] = menu_references["shot_notifications_settings"]:create_element({["name"] = "hit color"}, {["colorpicker"] = {["color_flag"] = "shot_notifications_hit_color", ["transparency_flag"] = "hit_transparency", ["default_color"] = color3_fromrgb(0, 215, 0), ["default_transparency"] = 0}})
    menu_references["damage_number"] = menu_references["game_section"]:create_element({["name"] = "damage number"}, {["toggle"] = {["flag"] = "damage_number"}})
        menu_references["damage_number_settings"] = menu_references["damage_number"]:create_settings()
        menu_references["damage_number_font"] = menu_references["damage_number_settings"]:create_element({["name"] = "font"}, {["dropdown"] = {["flag"] = "damage_number_font", ["default"] = {"2"}, ["options"] = {"0", "1", "2", "3"}, ["requires_one"] = true}})
        menu_references["damage_number_lifetime"] = menu_references["damage_number_settings"]:create_element({["name"] = "lifetime"}, {["slider"] = {["flag"] = "damage_number_lifetime", ["min"] = 0.7, ["max"] = 2, ["default"] = 0.7, ["decimals"] = 1, ["suffix"] = "s", ["prefix"] = ""}})
        menu_references["damage_number_color"] = menu_references["damage_number_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "damage_number_color", ["transparency_flag"] = "damage_number_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["damage_number_lethal_color"] = menu_references["damage_number_settings"]:create_element({["name"] = "lethal color"}, {["colorpicker"] = {["color_flag"] = "damage_number_lethal_color", ["transparency_flag"] = "damage_number_lethal_transparency", ["default_color"] = color3_fromrgb(255, 55, 55), ["default_transparency"] = 0}})
        menu_references["damage_number_outline_color"] = menu_references["damage_number_settings"]:create_element({["name"] = "outline color"}, {["colorpicker"] = {["color_flag"] = "damage_number_outline_color", ["transparency_flag"] = "damage_number_outline_transparency", ["default_color"] = color3_fromrgb(35, 35, 35), ["default_transparency"] = 0}})
    menu_references["d3_hit_marker"] = menu_references["game_section"]:create_element({["name"] = "3d hit marker"}, {["toggle"] = {["flag"] = "d3_hit_marker"}})
        menu_references["d3_hit_marker_settings"] = menu_references["d3_hit_marker"]:create_settings()
        menu_references["d3_hit_marker_lifetime"] = menu_references["d3_hit_marker_settings"]:create_element({["name"] = "lifetime"}, {["slider"] = {["flag"] = "d3_hit_marker_lifetime", ["min"] = 0.1, ["max"] = 2, ["default"] = 0.7, ["decimals"] = 1, ["suffix"] = "s", ["prefix"] = ""}})
        menu_references["d3_hit_marker_thickness"] = menu_references["d3_hit_marker_settings"]:create_element({["name"] = "thickness"}, {["slider"] = {["flag"] = "d3_hit_marker_thickness", ["min"] = 0, ["max"] = 4, ["default"] = 2, ["decimals"] = 0, ["suffix"] = "px", ["prefix"] = ""}})
        menu_references["d3_hit_marker_color"] = menu_references["d3_hit_marker_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "d3_hit_marker_color", ["transparency_flag"] = "d3_hit_marker_transparency", ["default_color"] = color3_fromrgb(133, 220, 255), ["default_transparency"] = 0}})
        menu_references["d3_hit_marker_lethal_color"] = menu_references["d3_hit_marker_settings"]:create_element({["name"] = "lethal color"}, {["colorpicker"] = {["color_flag"] = "d3_hit_marker_lethal_color", ["transparency_flag"] = "d3_hit_marker_transparency", ["default_color"] = color3_fromrgb(255, 0, 0), ["default_transparency"] = 0}})
        menu_references["d3_hit_marker_outline_color"] = menu_references["d3_hit_marker_settings"]:create_element({["name"] = "outline color"}, {["colorpicker"] = {["color_flag"] = "d3_hit_marker_outline_color", ["transparency_flag"] = "d3_hit_marker_outline_transparency", ["default_color"] = color3_fromrgb(35, 35, 35), ["default_transparency"] = 0}})
    menu_references["d2_hit_marker"] = menu_references["game_section"]:create_element({["name"] = "2d hit marker"}, {["toggle"] = {["flag"] = "d2_hit_marker"}})
        menu_references["d2_hit_marker_settings"] = menu_references["d2_hit_marker"]:create_settings()
        menu_references["d2_hit_marker_lifetime"] = menu_references["d2_hit_marker_settings"]:create_element({["name"] = "lifetime"}, {["slider"] = {["flag"] = "d2_hit_marker_lifetime", ["min"] = 0.1, ["max"] = 2, ["default"] = 0.7, ["decimals"] = 1, ["suffix"] = "s", ["prefix"] = ""}})
        menu_references["d2_hit_marker_thickness"] = menu_references["d2_hit_marker_settings"]:create_element({["name"] = "thickness"}, {["slider"] = {["flag"] = "d2_hit_marker_thickness", ["min"] = 0, ["max"] = 4, ["default"] = 2, ["decimals"] = 0, ["suffix"] = "px", ["prefix"] = ""}})
        menu_references["d2_hit_marker_color"] = menu_references["d2_hit_marker_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "d2_hit_marker_color", ["transparency_flag"] = "d2_hit_marker_transparency", ["default_color"] = color3_fromrgb(133, 220, 255), ["default_transparency"] = 0}})
        menu_references["d2_hit_marker_lethal_color"] = menu_references["d2_hit_marker_settings"]:create_element({["name"] = "lethal color"}, {["colorpicker"] = {["color_flag"] = "d2_hit_marker_lethal_color", ["transparency_flag"] = "d2_hit_marker_transparency", ["default_color"] = color3_fromrgb(255, 0, 0), ["default_transparency"] = 0}})
        menu_references["d2_hit_marker_outline_color"] = menu_references["d2_hit_marker_settings"]:create_element({["name"] = "outline color"}, {["colorpicker"] = {["color_flag"] = "d2_hit_marker_outline_color", ["transparency_flag"] = "d2_hit_marker_outline_transparency", ["default_color"] = color3_fromrgb(35, 35, 35), ["default_transparency"] = 0}})
    menu_references["hit_skeleton"] = menu_references["game_section"]:create_element({["name"] = "hit skeleton"}, {["toggle"] = {["flag"] = "hit_skeleton"}})
        menu_references["hit_skeleton_settings"] = menu_references["hit_skeleton"]:create_settings()
        menu_references["hit_skeleton_animation"] = menu_references["hit_skeleton_settings"]:create_element({["name"] = "animation"}, {["dropdown"] = {["flag"] = "hit_skeleton_animation", ["default"] = {"fade"}, ["options"] = {"fade", "none"}, ["requires_one"] = true}})
        menu_references["hit_skeleton_lifetime"] = menu_references["hit_skeleton_settings"]:create_element({["name"] = "lifetime"}, {["slider"] = {["flag"] = "hit_skeleton_lifetime", ["min"] = 0.1, ["max"] = 1.5, ["default"] = 0.8, ["decimals"] = 1, ["suffix"] = "s", ["prefix"] = ""}})
        menu_references["hit_skeleton_thickness"] = menu_references["hit_skeleton_settings"]:create_element({["name"] = "thickness"}, {["slider"] = {["flag"] = "hit_skeleton_thickness", ["min"] = 0.1, ["max"] = 5, ["default"] = 3, ["decimals"] = 1}})
        menu_references["hit_skeleton_color"] = menu_references["hit_skeleton_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "hit_skeleton_color", ["transparency_flag"] = "hit_skeleton_transparency", ["default_color"] = color3_fromrgb(142, 242, 255), ["default_transparency"] = 0.8}})
    menu_references["hit_particle"] = menu_references["game_section"]:create_element({["name"] = "hit particle"}, {["toggle"] = {["flag"] = "hit_particle"}})
        menu_references["hit_particle_settings"] = menu_references["hit_particle"]:create_settings()
        menu_references["hit_particle_behind_walls"] = menu_references["hit_particle_settings"]:create_element({["name"] = "behind walls"}, {["toggle"] = {["flag"] = "hit_particle_behind_walls"}})
        menu_references["hit_particle_lethal_color"] = menu_references["hit_particle_settings"]:create_element({["name"] = "lethal color"}, {["colorpicker"] = {["color_flag"] = "hit_particle_lethal_color", ["transparency_flag"] = "hit_particle_lethal_transparency", ["default_color"] = color3_fromrgb(133, 220, 255), ["default_transparency"] = 0.2}})
        menu_references["hit_particle_color"] = menu_references["hit_particle_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "hit_particle_color", ["transparency_flag"] = "hit_particle_transparency", ["default_color"] = color3_fromrgb(133, 220, 255), ["default_transparency"] = 0.2}})
        menu_references["hit_particle_particle"] = menu_references["hit_particle_settings"]:create_element({["name"] = "particle"}, {["dropdown"] = {["flag"] = "hit_particle_particle", ["default"] = {"sparks"}, ["options"] = {"bubble", "sparks", "orbs", "air"}, ["use_custom_extensions"] = {"rbxm", "rbmx"}}})
    menu_references["hit_overlay"] = menu_references["game_section"]:create_element({["name"] = "hit overlay"}, {["toggle"] = {["flag"] = "hit_overlay"}})
        menu_references["hit_overlay_settings"] = menu_references["hit_overlay"]:create_settings()
        menu_references["hit_overlay_lifetime"] = menu_references["hit_overlay_settings"]:create_element({["name"] = "lifetime"}, {["slider"] = {["flag"] = "hit_overlay_lifetime", ["min"] = 0.1, ["max"] = 0.8, ["default"] = 0.7, ["decimals"] = 1, ["suffix"] = "s", ["prefix"] = ""}})
        menu_references["hit_overlay_color"] = menu_references["hit_overlay_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "hit_overlay_color", ["transparency_flag"] = "hit_overlay_transparency", ["default_color"] = color3_fromrgb(133, 220, 255), ["default_transparency"] = 0.2}})
        menu_references["hit_overlay_lethal_color"] = menu_references["hit_overlay_settings"]:create_element({["name"] = "lethal color"}, {["colorpicker"] = {["color_flag"] = "hit_overlay_lethal_color", ["transparency_flag"] = "hit_overlay_lethal_transparency", ["default_color"] = color3_fromrgb(255, 55, 55), ["default_transparency"] = 0.2}})
    menu_references["hit_sound"] = menu_references["game_section"]:create_element({["name"] = "hit sound"}, {["toggle"] = {["flag"] = "hit_sound"}})
        menu_references["hit_sound_settings"] = menu_references["hit_sound"]:create_settings()
        menu_references["hit_sound_value"] = menu_references["hit_sound_settings"]:create_element({["name"] = "sound"}, {["dropdown"] = {["flag"] = "hit_sound_value", ["default"] = {"mc bow"}, ["options"] = {"primordial", "neverlose", "sparkle", "mc bow", "skeet", "break", "rust"}, ["requires_one"] = true, ["use_custom_extensions"] = {"mp3", "ogg", "wav"}}})
        menu_references["hit_sound_volume"] = menu_references["hit_sound_settings"]:create_element({["name"] = "volume"}, {["slider"] = {["flag"] = "hit_sound_volume", ["min"] = 0.1, ["max"] = 5, ["default"] = 1, ["decimals"] = 1}})

    -- >> ( shot notifications )

    local show_notifications_on_local_bullet_confirmed = nil

    local do_hit_notification = true

    local send_hit_notification = function(player, part, damage)
        if player and part then
            new_notification(
                "hit "..player["Name"].." for "..damage.." health "..(message or ""),
                1,
                flags["shot_notifications_hit_color"]
            )
        end
    end

    create_connection(menu_references["shot_notifications"]["on_toggle_change"], function(value)
        if show_notifications_on_local_bullet_confirmed then
            show_notifications_on_local_bullet_confirmed:Disconnect()
            show_notifications_on_local_bullet_confirmed = nil
        end

        if value then
            if do_hit_notification then
                show_notifications_on_local_bullet_confirmed = create_connection(signals["on_local_bullet_confirmed"], send_hit_notification)
            end
        end
    end)

    create_connection(menu_references["shot_notifications_notify_when"]["on_dropdown_change"], function(value)
        do_hit_notification = false

        for i = 1, #value do
            if value[i] == "shot hit" then
                do_hit_notification = true
            end
        end

        if flags["shot_notifications"] then

            if show_notifications_on_local_bullet_confirmed then
                show_notifications_on_local_bullet_confirmed:Disconnect()
                show_notifications_on_local_bullet_confirmed = nil
            end

            if do_hit_notification then
                show_notifications_on_local_bullet_confirmed = create_connection(signals["on_local_bullet_confirmed"], send_hit_notification)
            end
        end
    end)

    -- >> ( hit skeleton )

    local hit_skeleton_on_player_hit = nil

    local hit_skeleton_fade = true
    local hit_skeleton_lifetime = 0.8
    local hit_skeleton_thickness = 3
    local hit_skeleton_transparency = 1
    local hit_skeleton_color = color3_fromrgb(142, 242, 255)

    local hit_skeleton_create_line = function()
        return create_real_drawing("Line", {
            Color = hit_skeleton_color,
            Thickness = hit_skeleton_thickness,
            Transparency = hit_skeleton_transparency,
            Visible = false
        })
    end

    local do_hit_skeleton = LPH_NO_VIRTUALIZE(function(player)
        local data = player_data[player]
        local character = data[3]

        if not character then
            return
        end
        local parts = data[4]

        local head_to_neck = hit_skeleton_create_line()
        local neck_to_left_shoulder = hit_skeleton_create_line()
        local neck_to_right_shoulder = hit_skeleton_create_line()
        local left_shoulder_to_upper_arm = hit_skeleton_create_line()
        local right_shoulder_to_upper_arm = hit_skeleton_create_line()
        local left_upper_arm_to_lower_arm = hit_skeleton_create_line()
        local right_upper_arm_to_lower_arm = hit_skeleton_create_line()
        local left_lower_arm_to_hand = hit_skeleton_create_line()
        local right_lower_arm_to_hand = hit_skeleton_create_line()
        local neck_to_lower_torso = hit_skeleton_create_line()
        local lower_torso_to_left_upper_leg = hit_skeleton_create_line()
        local lower_torso_to_right_upper_leg = hit_skeleton_create_line()
        local left_upper_leg_to_lower_leg = hit_skeleton_create_line()
        local right_upper_leg_to_lower_leg = hit_skeleton_create_line()
        local left_lower_leg_to_foot = hit_skeleton_create_line()
        local right_lower_leg_to_foot = hit_skeleton_create_line()

        local head_cframe = nil
        local left_upper_arm_cframe = nil
        local right_upper_arm_cframe = nil
        local left_lower_arm_cframe = nil
        local right_lower_arm_cframe = nil
        local left_hand_cframe = nil
        local right_hand_cframe = nil
        local lower_torso_cframe = nil
        local left_upper_leg_cframe = nil
        local right_upper_leg_cframe = nil
        local left_lower_leg_cframe = nil
        local right_lower_leg_cframe = nil
        local left_foot_cframe = nil
        local right_foot_cframe = nil

        local head = parts.Head
        local left_upper_arm = parts.LeftUpperArm
        local right_upper_arm = parts.RightUpperArm
        local left_lower_arm = parts.LeftLowerArm
        local right_lower_arm = parts.RightLowerArm
        local left_hand = parts.LeftHand
        local right_hand = parts.RightHand
        local lower_torso = parts.LowerTorso
        local left_upper_leg = parts.LeftUpperLeg
        local right_upper_leg = parts.RightUpperLeg
        local left_lower_leg = parts.LeftLowerLeg
        local right_lower_leg = parts.RightLowerLeg
        local left_foot = parts.LeftFoot
        local right_foot = parts.RightFoot

        if head then head_cframe = head.CFrame end
        if left_upper_arm then left_upper_arm_cframe = left_upper_arm.CFrame end
        if right_upper_arm then right_upper_arm_cframe = right_upper_arm.CFrame end
        if left_lower_arm then left_lower_arm_cframe = left_lower_arm.CFrame end
        if right_lower_arm then right_lower_arm_cframe = right_lower_arm.CFrame end
        if left_hand then left_hand_cframe = left_hand.CFrame end
        if right_hand then right_hand_cframe = right_hand.CFrame end
        if lower_torso then lower_torso_cframe = lower_torso.CFrame end
        if left_upper_leg then left_upper_leg_cframe = left_upper_leg.CFrame end
        if right_upper_leg then right_upper_leg_cframe = right_upper_leg.CFrame end
        if left_lower_leg then left_lower_leg_cframe = left_lower_leg.CFrame end
        if right_lower_leg then right_lower_leg_cframe = right_lower_leg.CFrame end
        if left_foot then left_foot_cframe = left_foot.CFrame end
        if right_foot then right_foot_cframe = right_foot.CFrame end

        local draw = function()
            head_to_neck.Visible = false
            local neck_position = nil
            if head_cframe then
                local head_position, head_visible = world_to_viewport_point(camera, head_cframe.Position)

                local neck_3d = (head_cframe - head_cframe.YVector / 1.3).Position;
                local _neck_position, neck_visible = world_to_viewport_point(camera, neck_3d);

                if head_visible and neck_visible then
                    head_to_neck.Visible = true
                    head_to_neck.From = vector2_new(head_position.X, head_position.Y)
                    neck_position = _neck_position
                    neck_position = vector2_new(neck_position.X, neck_position.Y)
                    head_to_neck.To = neck_position
                end
            end

            neck_to_left_shoulder.Visible = false
            local left_shoulder_position = nil
            if neck_position and left_upper_arm_cframe then
                local _left_shoulder_position, left_shoulder_visible = world_to_viewport_point(camera, left_upper_arm_cframe.Position + left_upper_arm_cframe.YVector / 2)

                if left_shoulder_visible then
                    neck_to_left_shoulder.Visible = true
                    neck_to_left_shoulder.From = neck_position
                    left_shoulder_position = _left_shoulder_position
                    left_shoulder_position = vector2_new(left_shoulder_position.X, left_shoulder_position.Y)
                    neck_to_left_shoulder.To = left_shoulder_position
                end
            end

            neck_to_right_shoulder.Visible = false
            local right_shoulder_position = nil
            if neck_position and right_upper_arm_cframe then
                local _right_shoulder_position, right_shoulder_visible = world_to_viewport_point(camera, right_upper_arm_cframe.Position + right_upper_arm_cframe.YVector / 2)

                if right_shoulder_visible then
                    neck_to_right_shoulder.Visible = true
                    neck_to_right_shoulder.From = neck_position
                    right_shoulder_position = _right_shoulder_position
                    right_shoulder_position = vector2_new(right_shoulder_position.X, right_shoulder_position.Y)
                    neck_to_right_shoulder.To = right_shoulder_position
                end
            end

            left_shoulder_to_upper_arm.Visible = false
            local left_upper_arm_position = nil
            if left_shoulder_position and left_upper_arm_cframe then
                local _left_upper_arm_position, left_upper_arm_visible = world_to_viewport_point(camera, left_upper_arm_cframe.Position - left_upper_arm_cframe.UpVector / 2 - left_upper_arm_cframe.XVector / 3)

                if left_upper_arm_visible then
                    left_shoulder_to_upper_arm.Visible = true
                    left_shoulder_to_upper_arm.From = left_shoulder_position
                    left_upper_arm_position = _left_upper_arm_position
                    left_upper_arm_position = vector2_new(left_upper_arm_position.X, left_upper_arm_position.Y)
                    left_shoulder_to_upper_arm.To = left_upper_arm_position
                end
            end

            right_shoulder_to_upper_arm.Visible = false
            local right_upper_arm_position = nil
            if right_shoulder_position and right_upper_arm_cframe then
                local _right_upper_arm_position, right_upper_arm_visible = world_to_viewport_point(camera, right_upper_arm_cframe.Position - right_upper_arm_cframe.UpVector / 2 + right_upper_arm_cframe.XVector / 3)

                if right_upper_arm_visible then
                    right_shoulder_to_upper_arm.Visible = true
                    right_shoulder_to_upper_arm.From = right_shoulder_position
                    right_upper_arm_position = _right_upper_arm_position
                    right_upper_arm_position = vector2_new(right_upper_arm_position.X, right_upper_arm_position.Y)
                    right_shoulder_to_upper_arm.To = right_upper_arm_position
                end
            end

            left_upper_arm_to_lower_arm.Visible = false
            local left_lower_arm_position = nil
            if left_upper_arm_position and left_lower_arm_cframe then
                local _left_lower_arm_position, left_lower_arm_visible = world_to_viewport_point(camera, left_lower_arm_cframe.Position - left_lower_arm_cframe.UpVector / 2 - left_lower_arm_cframe.XVector / 4)

                if left_lower_arm_visible then
                    left_upper_arm_to_lower_arm.Visible = true
                    left_upper_arm_to_lower_arm.From = left_upper_arm_position
                    left_lower_arm_position = _left_lower_arm_position
                    left_lower_arm_position = vector2_new(left_lower_arm_position.X, left_lower_arm_position.Y)
                    left_upper_arm_to_lower_arm.To = left_lower_arm_position
                end
            end

            right_upper_arm_to_lower_arm.Visible = false
            local right_lower_arm_position = nil
            if right_upper_arm_position and right_lower_arm_cframe then
                local _right_lower_arm_position, right_lower_arm_visible = world_to_viewport_point(camera, right_lower_arm_cframe.Position - right_lower_arm_cframe.UpVector / 2 + right_lower_arm_cframe.XVector / 4)

                if right_lower_arm_visible then
                    right_upper_arm_to_lower_arm.Visible = true
                    right_upper_arm_to_lower_arm.From = right_upper_arm_position
                    right_lower_arm_position = _right_lower_arm_position
                    right_lower_arm_position = vector2_new(right_lower_arm_position.X, right_lower_arm_position.Y)
                    right_upper_arm_to_lower_arm.To = right_lower_arm_position
                end
            end

            left_lower_arm_to_hand.Visible = false
            local left_hand_position = nil
            if left_lower_arm_position and left_hand_cframe then
                local _left_hand_position, left_hand_visible = world_to_viewport_point(camera, left_hand_cframe.Position)

                if left_hand_visible then
                    left_lower_arm_to_hand.Visible = true
                    left_lower_arm_to_hand.From = left_lower_arm_position
                    left_hand_position = _left_hand_position
                    left_hand_position = vector2_new(left_hand_position.X, left_hand_position.Y)
                    left_lower_arm_to_hand.To = left_hand_position
                end
            end

            right_lower_arm_to_hand.Visible = false
            local right_hand_position = nil
            if right_lower_arm_position and right_hand_cframe then
                local _right_hand_position, right_hand_visible = world_to_viewport_point(camera, right_hand_cframe.Position)

                if right_hand_visible then
                    right_lower_arm_to_hand.Visible = true
                    right_lower_arm_to_hand.From = right_lower_arm_position
                    right_hand_position = _right_hand_position
                    right_hand_position = vector2_new(right_hand_position.X, right_hand_position.Y)
                    right_lower_arm_to_hand.To = right_hand_position
                end
            end

            neck_to_lower_torso.Visible = false
            local lower_torso_position = nil
            if neck_position and lower_torso_cframe then
                local _lower_torso_position, lower_torso_visible = world_to_viewport_point(camera, lower_torso_cframe.Position)

                if lower_torso_visible then
                    neck_to_lower_torso.Visible = true
                    neck_to_lower_torso.From = neck_position
                    lower_torso_position = _lower_torso_position
                    lower_torso_position = vector2_new(lower_torso_position.X, lower_torso_position.Y)
                    neck_to_lower_torso.To = lower_torso_position
                end
            end

            lower_torso_to_left_upper_leg.Visible = false
            local left_upper_leg_position = nil
            if lower_torso_position and left_upper_leg_cframe then
                local _left_upper_leg_position, left_upper_leg_visible = world_to_viewport_point(camera, left_upper_leg_cframe.Position + left_upper_leg_cframe.UpVector / 2)

                if left_upper_leg_visible then
                    lower_torso_to_left_upper_leg.Visible = true
                    lower_torso_to_left_upper_leg.From = lower_torso_position
                    left_upper_leg_position = _left_upper_leg_position
                    left_upper_leg_position = vector2_new(left_upper_leg_position.X, left_upper_leg_position.Y)
                    lower_torso_to_left_upper_leg.To = left_upper_leg_position
                end
            end

            lower_torso_to_right_upper_leg.Visible = false
            local right_upper_leg_position = nil
            if lower_torso_position and right_upper_leg_cframe then
                local _right_upper_leg_position, right_upper_leg_visible = world_to_viewport_point(camera, right_upper_leg_cframe.Position + right_upper_leg_cframe.UpVector / 2)

                if right_upper_leg_visible then
                    lower_torso_to_right_upper_leg.Visible = true
                    lower_torso_to_right_upper_leg.From = lower_torso_position
                    right_upper_leg_position = _right_upper_leg_position
                    right_upper_leg_position = vector2_new(right_upper_leg_position.X, right_upper_leg_position.Y)
                    lower_torso_to_right_upper_leg.To = right_upper_leg_position
                end
            end

            left_upper_leg_to_lower_leg.Visible = false
            local left_lower_leg_position = nil
            if left_upper_leg_position and left_lower_leg_cframe then
                local _left_lower_leg_position, left_lower_leg_visible = world_to_viewport_point(camera, left_lower_leg_cframe.Position + left_lower_leg_cframe.UpVector / 2)

                if left_lower_leg_visible then
                    left_upper_leg_to_lower_leg.Visible = true
                    left_upper_leg_to_lower_leg.From = left_upper_leg_position
                    left_lower_leg_position = _left_lower_leg_position
                    left_lower_leg_position = vector2_new(left_lower_leg_position.X, left_lower_leg_position.Y)
                    left_upper_leg_to_lower_leg.To = left_lower_leg_position
                end
            end

            right_upper_leg_to_lower_leg.Visible = false
            local right_lower_leg_position = nil
            if right_upper_leg_position and right_lower_leg_cframe then
                local _right_lower_leg_position, right_lower_leg_visible = world_to_viewport_point(camera, right_lower_leg_cframe.Position + right_lower_leg_cframe.UpVector / 2)

                if right_lower_leg_visible then
                    right_upper_leg_to_lower_leg.Visible = true
                    right_upper_leg_to_lower_leg.From = right_upper_leg_position
                    right_lower_leg_position = _right_lower_leg_position
                    right_lower_leg_position = vector2_new(right_lower_leg_position.X, right_lower_leg_position.Y)
                    right_upper_leg_to_lower_leg.To = right_lower_leg_position
                end
            end

            left_lower_leg_to_foot.Visible = false
            local left_foot_position = nil
            if left_lower_leg_position and left_foot_cframe then
                local _left_foot_position, left_foot_visible = world_to_viewport_point(camera, left_foot_cframe.Position)

                if left_foot_visible then
                    left_lower_leg_to_foot.Visible = true
                    left_lower_leg_to_foot.From = left_lower_leg_position
                    left_foot_position = _left_foot_position
                    left_foot_position = vector2_new(left_foot_position.X, left_foot_position.Y)
                    left_lower_leg_to_foot.To = left_foot_position
                end
            end

            right_lower_leg_to_foot.Visible = false
            local right_foot_position = nil
            if right_lower_leg_position and right_foot_cframe then
                local _right_foot_position, right_foot_visible = world_to_viewport_point(camera, right_foot_cframe.Position)

                if right_foot_visible then
                    right_lower_leg_to_foot.Visible = true
                    right_lower_leg_to_foot.From = right_lower_leg_position
                    right_foot_position = _right_foot_position
                    right_foot_position = vector2_new(right_foot_position.X, right_foot_position.Y)
                    right_lower_leg_to_foot.To = right_foot_position
                end
            end
        end

        heartbeat[#heartbeat+1] = draw

        wait(hit_skeleton_lifetime)

        if hit_skeleton_fade then
            tween(head_to_neck, hide_transparency, quad, out, 0.2)
            tween(neck_to_left_shoulder, hide_transparency, quad, out, 0.2)
            tween(neck_to_right_shoulder, hide_transparency, quad, out, 0.2)
            tween(left_shoulder_to_upper_arm, hide_transparency, quad, out, 0.2)
            tween(right_shoulder_to_upper_arm, hide_transparency, quad, out, 0.2)
            tween(left_upper_arm_to_lower_arm, hide_transparency, quad, out, 0.2)
            tween(right_upper_arm_to_lower_arm, hide_transparency, quad, out, 0.2)
            tween(left_lower_arm_to_hand, hide_transparency, quad, out, 0.2)
            tween(right_lower_arm_to_hand, hide_transparency, quad, out, 0.2)
            tween(neck_to_lower_torso, hide_transparency, quad, out, 0.2)
            tween(lower_torso_to_left_upper_leg, hide_transparency, quad, out, 0.2)
            tween(lower_torso_to_right_upper_leg, hide_transparency, quad, out, 0.2)
            tween(left_upper_leg_to_lower_leg, hide_transparency, quad, out, 0.2)
            tween(right_upper_leg_to_lower_leg, hide_transparency, quad, out, 0.2)
            tween(left_lower_leg_to_foot, hide_transparency, quad, out, 0.2)
            tween(right_lower_leg_to_foot, hide_transparency, quad, out, 0.2)

            wait(0.2)
        end

        for i = 1, #heartbeat do
            if heartbeat[i] == draw then
                remove(heartbeat, i)
                break
            end
        end

        if head_to_neck then
            head_to_neck:Destroy()
            neck_to_left_shoulder:Destroy()
            neck_to_right_shoulder:Destroy()
            left_shoulder_to_upper_arm:Destroy()
            right_shoulder_to_upper_arm:Destroy()
            left_upper_arm_to_lower_arm:Destroy()
            right_upper_arm_to_lower_arm:Destroy()
            left_lower_arm_to_hand:Destroy()
            right_lower_arm_to_hand:Destroy()
            neck_to_lower_torso:Destroy()
            lower_torso_to_left_upper_leg:Destroy()
            lower_torso_to_right_upper_leg:Destroy()
            left_upper_leg_to_lower_leg:Destroy()
            right_upper_leg_to_lower_leg:Destroy()
            left_lower_leg_to_foot:Destroy()
            right_lower_leg_to_foot:Destroy()
        end
    end)

    create_connection(menu_references["hit_skeleton"]["on_toggle_change"], function(value)
        if hit_skeleton_on_player_hit then
            hit_skeleton_on_player_hit:Disconnect()
            hit_skeleton_on_player_hit = nil
        end

        if value then
            hit_skeleton_on_player_hit = create_connection(signals["on_local_bullet_confirmed"], do_hit_skeleton)
        end
    end)

    create_connection(menu_references["hit_skeleton_animation"]["on_dropdown_change"], function(value)
        hit_skeleton_fade = value[1] == "fade"
    end)

    create_connection(menu_references["hit_skeleton_lifetime"]["on_slider_change"], function(value)
        hit_skeleton_lifetime = value
    end)
    
    create_connection(menu_references["hit_skeleton_thickness"]["on_slider_change"], function(value)
        hit_skeleton_thickness = value
    end)

    create_connection(menu_references["hit_skeleton_color"]["on_color_change"], function(value)
        hit_skeleton_color = value
    end)

    create_connection(menu_references["hit_skeleton_color"]["on_transparency_change"], function(value)
        hit_skeleton_transparency = 1 - value
    end)

    -- >> ( hit sound )

    local hit_sound_connection = nil
    local sound_service = cloneref(game:GetService("SoundService"))

    local hit_sounds = {
        ["primordial"] = readfile("juju recode/assets/primordial.ogg"),
        ["neverlose"] = readfile("juju recode/assets/neverlose.ogg"),
        ["sparkle"] = readfile("juju recode/assets/sparkle.ogg"),
        ["mc bow"] = readfile("juju recode/assets/mc bow.ogg"),
        ["break"] = readfile("juju recode/assets/break.ogg"),
        ["skeet"] = readfile("juju recode/assets/skeet.ogg"),
        ["rust"] = readfile("juju recode/assets/rust.ogg"),
    }

    for _, data in hit_sounds do
        local path = tostring({}):sub(math_random(8, 12))..".ogg"
        writefile(path, data)
        hit_sounds[_] = getcustomasset(path)
        delfile(path)
    end

    local hit_sound_data = hit_sounds["juju"]

    local do_hit_sound = function()
        delay(0, destroy, create_instance("Sound", {
            ["SoundId"] = hit_sound_data,
            ["Volume"] = flags["hit_sound_volume"],
            ["PlayOnRemove"] = true,
            ["Name"] = "\0",
            ["Parent"] = sound_service
        }))
    end

    create_connection(menu_references["hit_sound"]["on_toggle_change"], function(value)
        if hit_sound_connection then
            hit_sound_connection:Disconnect()
            hit_sound_connection = nil
        end

        if value then
            hit_sound_connection = create_connection(signals["on_local_bullet_confirmed"], do_hit_sound)
        end
    end)

    create_connection(menu_references["hit_sound_value"]["on_dropdown_change"], function(value)
        local new_value = value[1]
        hit_sound_data = hit_sounds[new_value]

        if new_value and not hit_sound_data then
            local path = tostring({}):sub(math_random(8, 12))..".ogg"
            writefile(path, readfile("juju recode/custom/"..new_value))
            local asset = getcustomasset(path)
            hit_sounds[new_value] = asset
            delfile(path)

            hit_sound_data = asset
        end
    end)

    -- >> ( hit particle )

    do
        local hit_particle_part = create_instance("Part", {
            ["Name"] = "\0",
            ["Anchored"] = true,
            ["CanCollide"] = false,
            ["Massless"] = true,
            ["CastShadow"] = false,
            ["Size"] = vector3_new(0.01, 0.01, 0.01)
        })

        local hit_particles = {
            ["sparks"] = {
                {
                    create_instance("ParticleEmitter", {
                        ["Acceleration"] = vector3_new(0,-50,0);
                        ["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0.999969,0.999985)),ColorSequenceKeypoint.new(0.25,Color3.new(0.333333,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,1,0.498039))};
                        ["Lifetime"] = NumberRange.new(0.5,1);
                        ["LightEmission"] = 1;
                        ["Enabled"] = false;
                        ["Orientation"] = Enum.ParticleOrientation.VelocityParallel;
                        ["Rate"] = 0;
                        ["Size"] = NumberSequence.new{NumberSequenceKeypoint.new(0,0.6,0),NumberSequenceKeypoint.new(0.5,0.6,0),NumberSequenceKeypoint.new(1,0,0)};
                        ["Speed"] = NumberRange.new(15,15);
                        ["SpreadAngle"] = vector2_new(50,-50);
                        ["Texture"] = [[http://www.roblox.com/asset/?id=18540695516]];
                        ["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,1,0)};
                        ["Name"] = "\0";
                        ["Parent"] = hit_particle_part
                    }),
                    30
                }
            },
            ["bubble"] = {
                {
                    create_instance("ParticleEmitter", {
                        ["FlipbookMode"] = Enum.ParticleFlipbookMode.OneShot,
                        ["Color"] = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 255))
                        },
                        ["LockedToPart"] = true,
                        ["Rate"] = 1.5,
                        ["Rotation"] = NumberRange.new(-5, 5),
                        ["Transparency"] = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.464, 0.768750011920929),
                            NumberSequenceKeypoint.new(1, 1)
                        },
                        ["Texture"] = "rbxassetid://17086075673",
                        ["Lifetime"] = NumberRange.new(0.450000001192092896, 0.450000001192092896),
                        ["LightEmission"] = 1,
                        ["Brightness"] = 5,
                        ["Speed"] = NumberRange.new(0, 0),
                        ["Size"] = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0.10000000149011612),
                            NumberSequenceKeypoint.new(1, 6)
                        },
                        ["Enabled"] = false,
                        ["Parent"] = hit_particle_part
                    }),
                    1
                }
            },
            ["orbs"] = {
                {
                    create_instance("ParticleEmitter", {
                        ["FlipbookMode"] = Enum.ParticleFlipbookMode.OneShot,
                        ["RotSpeed"] = NumberRange.new(-10, 10),
                        ["FlipbookFramerate"] = NumberRange.new(40, 40),
                        ["Drag"] = 1,
                        ["Rate"] = 1,
                        ["Texture"] = "rbxassetid://15011464541",
                        ["Rotation"] = NumberRange.new(-1000, 1000),
                        ["Transparency"] = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1)
                        },
                        ["SpreadAngle"] = Vector2.new(-1000, 1000),
                        ["Lifetime"] = NumberRange.new(0.44999998807907104, 0.44999998807907104),
                        ["LightEmission"] = 1,
                        ["Brightness"] = 10,
                        ["FlipbookLayout"] = Enum.ParticleFlipbookLayout.Grid8x8,
                        ["Size"] = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 5.5),
                            NumberSequenceKeypoint.new(1, 5.5)
                        },
                        ["Enabled"] = false,
                        ["Parent"] = hit_particle_part
                    }),
                    3
                }
            },
            ["air"] = {
                {
                    create_instance("ParticleEmitter", {
                        ["FlipbookMode"] = Enum.ParticleFlipbookMode.PingPong,
                        ["VelocityInheritance"] = 0.15000000596046448,
                        ["Texture"] = "rbxassetid://10536350143",
                        ["FlipbookFramerate"] = NumberRange.new(30, 30),
                        ["Drag"] = 4.5,
                        ["Rate"] = 1,
                        ["Speed"] = NumberRange.new(0, 0),
                        ["LightInfluence"] = 1,
                        ["Acceleration"] = vector3_new(1, 0, 1),
                        ["LockedToPart"] = true,
                        ["Lifetime"] = NumberRange.new(1, 1),
                        ["LightEmission"] = 1,
                        ["Brightness"] = 10,
                        ["FlipbookLayout"] = Enum.ParticleFlipbookLayout.Grid8x8,
                        ["Size"] = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 3),
                            NumberSequenceKeypoint.new(1, 3)
                        },
                        ["Parent"] = hit_particle_part,
                        ["Enabled"] = false
                    }),
                    1
                }
            }
        }

        local hit_particle_connection = nil
        local hit_particle = hit_particles["sparks"]

        local do_hit_particle = LPH_NO_VIRTUALIZE(function(player, part)
            local color = ColorSequence["new"](player_data[player][18] and flags["hit_particle_lethal_color"] or flags["hit_particle_color"])
            local z_offset = flags["hit_particle_behind_walls"] and 1 or 0
            hit_particle_part["CFrame"] = part["CFrame"]
            for _, particle in hit_particle do
                local instance = particle[1]
                instance["Color"] = color
                instance["ZOffset"] = z_offset
                instance:Emit(particle[2])
            end
        end)

        create_connection(menu_references["hit_particle"]["on_toggle_change"], function(value)
            hit_particle_part["Parent"] = value and ignored[1] or hui

            if hit_particle_connection then
                hit_particle_connection:Disconnect()
                hit_particle_connection = nil
            end

            if value then
                hit_particle_connection = create_connection(signals["on_local_bullet_confirmed"], do_hit_particle)
            end
        end)

        create_connection(menu_references["hit_particle_particle"]["on_dropdown_change"], function(value)
            local value = value[1]
            hit_particle = hit_particles[value]

            if not hit_particle then
                local new_particle = game:GetObjects(getcustomasset("juju recode/custom/"..value))[1]
                local children = get_children(new_particle)
                local new_hit_particle = {}
                for i = 1, #children do
                    local child = children[i]
                    if child["ClassName"] == "ParticleEmitter" then
                        new_hit_particle[#new_hit_particle+1] = {
                            child,
                            child["Rate"]
                        }

                        child["Enabled"] = false
                        child["Parent"] = hit_particle_part
                    end
                end

                hit_particles[value] = new_hit_particle
                hit_particle = new_hit_particle
            end
        end)
    end

    -- >> ( hit overlay )

    local hit_overlay_connection = nil
    local data = readfile("juju recode/assets/1.png")

    local hit_image = nil
    local last_hit = clock()
    local do_hit_overlay = function(player)
        local new_last_hit = clock()
        last_hit = new_last_hit

        local is_lethal = player_data[player][18]
        hit_image["Color"] = is_lethal and flags["hit_overlay_lethal_color"] or flags["hit_overlay_color"]
        hit_image["Size"] = camera["ViewportSize"]

        local lifetime = flags["hit_overlay_lifetime"]
        tween(hit_image, {Transparency = is_lethal and -flags["hit_overlay_lethal_transparency"]+1 or -flags["hit_overlay_transparency"]+1}, quad, out, (lifetime/5.25))
        wait(lifetime/5.15)

        if new_last_hit ~= last_hit then
            return
        end

        tween(hit_image, hide_transparency, quad, out, (lifetime/5.25))
    end

    create_connection(menu_references["hit_overlay"]["on_toggle_change"], function(value)
        if hit_overlay_connection then
            hit_overlay_connection:Disconnect()
            hit_overlay_connection = nil
        end

        if hit_image then
            hit_image:Destroy()
            hit_image = nil
        end

        if value then
            hit_image = create_real_drawing("Image", {
                ["Color"] = flags["hit_overlay_color"],
                ["Transparency"] = 0,
                ["Size"] = camera["ViewportSize"],
                ["ZIndex"] = 5500,
                ["Visible"] = true,
                ["Data"] = data
            })

            hit_overlay_connection = create_connection(signals["on_local_bullet_confirmed"], do_hit_overlay)
        end
    end)

    -- >> ( damage number )

    do
        local damage_number_connection = nil
        local damage_number_outline_color = color3_fromrgb(35, 35, 35)
        local damage_number_font = 2
        local show_offset = vector3_new(0,1.5,0)
        local create_drawing = (identifyexecutor() == "Swift" or identifyexecutor() == "Potassium") and create_fake_drawing or create_real_drawing

        local do_damage_number = LPH_JIT_MAX(function(player, part, damage)
            local transparency = -flags["damage_number_transparency"]+1
            local color = player_data[player][18] and flags["damage_number_lethal_color"] or flags["damage_number_color"]
            local number = create_drawing("Text", {
                ["Text"] = damage,
                ["Size"] = 14,
                ["Color"] = color,
                ["OutlineColor"] = damage_number_outline_color,
                ["Transparency"] = 0,
                ["ZIndex"] = 5500,
                ["Outline"] = true,
                ["Font"] = damage_number_font,
                ["Visible"] = true
            })

            local part_position = (damage and part) and part["Position"] or last_shot and last_shot["p"]
            local new_position = part_position
            local elapsed_time = 0

            local lifetime = flags["damage_number_lifetime"]
            local half = lifetime/1.6
            local new_half = lifetime/2

            local new_function = function(dt)
                elapsed_time+=dt

                local position, on_screen = world_to_viewport_point(camera, new_position)

                if on_screen then
                    if elapsed_time > lifetime then
                        local part_position = part_position + show_offset
                        local value = get_value(tween_service, (elapsed_time - lifetime) / new_half, exponential, out)
                        number["Transparency"] = transparency + (0 - transparency) * value
                        local new = -(show_offset*value)
                        new_position = part_position + ((part_position+new) - part_position) * value
                    elseif elapsed_time < half then
                        local value = get_value(tween_service, elapsed_time / half, exponential, out)
                        number["Transparency"] = 0 + (transparency - 0) * value
                        new_position = part_position + (show_offset*value)
                    end

                    number["Position"] = vector2_new(position["X"] + 13, position["Y"])
                else
                    number["Visible"] = false
                end
            end

            heartbeat[#heartbeat+1] = new_function

            delay(lifetime + new_half, function()
                for i = 1, #heartbeat do
                    if heartbeat[i] == new_function then
                        remove(heartbeat, i)
                        break
                    end
                end

                number:Destroy()
            end)
        end)

        create_connection(menu_references["damage_number"]["on_toggle_change"], function(value)
            if damage_number_connection then
                damage_number_connection:Disconnect()
                damage_number_connection = nil
            end

            if value then
                damage_number_connection = create_connection(signals["on_local_bullet_confirmed"], do_damage_number)
            end
        end)

        create_connection(menu_references["damage_number_outline_color"]["on_color_change"], function(value)
            damage_number_outline_color = value
        end)

        create_connection(menu_references["damage_number_font"]["on_dropdown_change"], function(value)
            damage_number_font = tonumber(value[1])
        end)
    end

    -- >> ( 3d hit marker )

    local d3_hit_marker_connection = nil
    local d3_hit_marker_color = color3_fromrgb(255, 255, 255)
    local d3_hit_marker_outline_color = color3_fromrgb(35, 35, 35)

    local do_d3_hit_marker = LPH_NO_VIRTUALIZE(function(player, part, damage)
        local lines = {}
        local outlines = {}
        local thickness = flags["d3_hit_marker_thickness"]
        local color = player_data[player][18] and flags["d3_hit_marker_lethal_color"] or d3_hit_marker_color

        for i = 1, 4 do
            lines[i] = create_real_drawing("Line", {
                ["Thickness"] = thickness,
                ["Color"] = color,
                ["Transparency"] = 1,
                ["ZIndex"] = 100,
                ["Visible"] = true
            })
            outlines[i] = create_real_drawing("Line", {
                ["Thickness"] = thickness + 2,
                ["Color"] = d3_hit_marker_outline_color,
                ["Transparency"] = 1,
                ["ZIndex"] = 99,
                ["Visible"] = true
            })
        end

        local lifetime = flags["d3_hit_marker_lifetime"]
        local position = (damage and part) and part["Position"] or last_shot and last_shot["p"]
        local elapsed_time = 0

        local new_function = function(dt)
            elapsed_time+=dt

            local position, on_screen = world_to_viewport_point(camera, position)

            if on_screen then
                local position_x = position["X"]
                local position_y = position["Y"]

                for i = 1, 4 do
                    lines[i]["Visible"] = true
                    outlines[i]["Visible"] = true
                end

                if elapsed_time > lifetime then
                    local elapsed_time = elapsed_time - lifetime
                    local transparency = 1 + (0 - 1) * get_value(tween_service, elapsed_time / 0.3, quad, out)

                    for i = 1, 4 do
                        lines[i]["Transparency"] = transparency
                        outlines[i]["Transparency"] = transparency
                    end
                end

                local from1 = vector2_new(position_x - 10, position_y - 10)
                local to1 = vector2_new(position_x - 5, position_y - 5)
                lines[1]["From"], lines[1]["To"] = from1, to1
                outlines[1]["From"], outlines[1]["To"] = from1, to1

                local from2 = vector2_new(position_x + 10, position_y - 10)
                local to2 = vector2_new(position_x + 5, position_y - 5)
                lines[2]["From"], lines[2]["To"] = from2, to2
                outlines[2]["From"], outlines[2]["To"] = from2, to2

                local from3 = vector2_new(position_x - 10, position_y + 10)
                local to3 = vector2_new(position_x - 5, position_y + 5)
                lines[3]["From"], lines[3]["To"] = from3, to3
                outlines[3]["From"], outlines[3]["To"] = from3, to3

                local from4 = vector2_new(position_x + 10, position_y + 10)
                local to4 = vector2_new(position_x + 5, position_y + 5)
                lines[4]["From"], lines[4]["To"] = from4, to4
                outlines[4]["From"], outlines[4]["To"] = from4, to4
            else
                for i = 1, 4 do
                    lines[i]["Visible"] = false
                    outlines[i]["Visible"] = false
                end
            end
        end

        heartbeat[#heartbeat+1] = new_function

        delay(lifetime + 0.3, function()
            for i = 1, #heartbeat do
                if heartbeat[i] == new_function then
                    remove(heartbeat, i)
                    break
                end
            end

            for i = 1, 4 do
                lines[i]:Destroy()
                lines[i] = nil
                outlines[i]:Destroy()
                outlines[i] = nil
            end
        end)
    end)

    create_connection(menu_references["d3_hit_marker"]["on_toggle_change"], function(value)
        if d3_hit_marker_connection then
            d3_hit_marker_connection:Disconnect()
            d3_hit_marker_connection = nil
        end

        if value then
            d3_hit_marker_connection = create_connection(signals["on_local_bullet_confirmed"], do_d3_hit_marker)
        end
    end)

    create_connection(menu_references["d3_hit_marker_color"]["on_color_change"], function(value)
        d3_hit_marker_color = value
    end)

    create_connection(menu_references["d3_hit_marker_outline_color"]["on_color_change"], function(value)
        d3_hit_marker_outline_color = value
    end)

    -- >> ( 2d hit marker )

    do
        local d2_hit_marker_connection = nil
        local d2_hit_marker_color = color3_fromrgb(255, 255, 255)
        local d2_hit_marker_outline_color = color3_fromrgb(35, 35, 35)

        local do_d2_hit_marker = LPH_NO_VIRTUALIZE(function(player)
            local lines = {}
            local outlines = {}
            local thickness = flags["d2_hit_marker_thickness"]
            local color = player_data[player][18] and flags["d2_hit_marker_lethal_color"] or d2_hit_marker_color

            for i = 1, 4 do
                lines[i] = create_real_drawing("Line", {
                    ["Thickness"] = thickness,
                    ["Color"] = color,
                    ["Transparency"] = 1,
                    ["ZIndex"] = 100,
                    ["Visible"] = true
                })
                outlines[i] = create_real_drawing("Line", {
                    ["Thickness"] = thickness + 2,
                    ["Color"] = d2_hit_marker_outline_color,
                    ["Transparency"] = 1,
                    ["ZIndex"] = 99,
                    ["Visible"] = true
                })
            end

            local lifetime = flags["d2_hit_marker_lifetime"]
            local elapsed_time = 0

            local new_function = function(dt)
                elapsed_time+=dt

                local position = camera["ViewportSize"]/2
                local position_x = position["X"]
                local position_y = position["Y"]

                for i = 1, 4 do
                    lines[i]["Visible"] = true
                    outlines[i]["Visible"] = true
                end

                if elapsed_time > lifetime then
                    local elapsed_time = elapsed_time - lifetime
                    local transparency = 1 + (0 - 1) * get_value(tween_service, elapsed_time / 0.2, quad, out)

                    for i = 1, 4 do
                        lines[i]["Transparency"] = transparency
                        outlines[i]["Transparency"] = transparency
                    end
                end

                local from1 = vector2_new(position_x - 10, position_y - 10)
                local to1 = vector2_new(position_x - 5, position_y - 5)
                lines[1]["From"], lines[1]["To"] = from1, to1
                outlines[1]["From"], outlines[1]["To"] = from1, to1

                local from2 = vector2_new(position_x + 10, position_y - 10)
                local to2 = vector2_new(position_x + 5, position_y - 5)
                lines[2]["From"], lines[2]["To"] = from2, to2
                outlines[2]["From"], outlines[2]["To"] = from2, to2

                local from3 = vector2_new(position_x - 10, position_y + 10)
                local to3 = vector2_new(position_x - 5, position_y + 5)
                lines[3]["From"], lines[3]["To"] = from3, to3
                outlines[3]["From"], outlines[3]["To"] = from3, to3

                local from4 = vector2_new(position_x + 10, position_y + 10)
                local to4 = vector2_new(position_x + 5, position_y + 5)
                lines[4]["From"], lines[4]["To"] = from4, to4
                outlines[4]["From"], outlines[4]["To"] = from4, to4
            end

            heartbeat[#heartbeat+1] = new_function

            delay(lifetime + 0.2, function()
                for i = 1, #heartbeat do
                    if heartbeat[i] == new_function then
                        remove(heartbeat, i)
                        break
                    end
                end

                for i = 1, 4 do
                    lines[i]:Destroy()
                    lines[i] = nil
                    outlines[i]:Destroy()
                    outlines[i] = nil
                end
            end)
        end)

        create_connection(menu_references["d2_hit_marker"]["on_toggle_change"], function(value)
            if d2_hit_marker_connection then
                d2_hit_marker_connection:Disconnect()
                d2_hit_marker_connection = nil
            end

            if value then
                d2_hit_marker_connection = create_connection(signals["on_local_bullet_confirmed"], do_d2_hit_marker)
            end
        end)

        create_connection(menu_references["d2_hit_marker_color"]["on_color_change"], function(value)
            d2_hit_marker_color = value
        end)

        create_connection(menu_references["d2_hit_marker_outline_color"]["on_color_change"], function(value)
            d2_hit_marker_outline_color = value
        end)
    end

    -- >> ( hit chams )

    do
        menu_references["hit_chams"] = menu_references["game_section"]:create_element({["name"] = "hit chams"}, {["toggle"] = {["flag"] = "hit_chams"}})
            menu_references["hit_chams_settings"] = menu_references["hit_chams"]:create_settings()
            menu_references["hit_chams_only_last_hit"] = menu_references["hit_chams_settings"]:create_element({["name"] = "only last hit"}, {["toggle"] = {["flag"] = "only_last_hit"}})
            menu_references["hit_chams_animation"] = menu_references["hit_chams_settings"]:create_element({["name"] = "animation"}, {["dropdown"] = {["flag"] = "hit_chams_animation", ["default"] = {"new fade"}, ["options"] = {"new fade", "fade", "none"}, ["requires_one"] = true}})
            menu_references["hit_chams_type"] = menu_references["hit_chams_settings"]:create_element({["name"] = "type"}, {["dropdown"] = {["flag"] = "hit_chams_type", ["default"] = {"neon"}, ["options"] = {"forcefield", "outline", "neon"}, ["requires_one"] = true}})
            menu_references["hit_chams_lifetime"] = menu_references["hit_chams_settings"]:create_element({["name"] = "lifetime"}, {["slider"] = {["flag"] = "hit_chams_lifetime", ["min"] = 0.1, ["max"] = 1.5, ["default"] = 0.8, ["decimals"] = 1, ["suffix"] = "s", ["prefix"] = ""}})
            menu_references["hit_chams_color"] = menu_references["hit_chams_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "hit_chams_color", ["transparency_flag"] = "hit_chams_transparency", ["default_color"] = color3_fromrgb(142, 242, 255), ["default_transparency"] = 0.8}})

        local hit_chams_on_player_hit = nil

        local hit_chams_transparency = 0.5
        local hit_chams_material = Enum["Material"]["Neon"]
        local hit_chams_lifetime = 1
        local hit_chams_color = color3_fromrgb(142, 242, 255)
        local hit_chams_part = create_instance("SelectionBox", {
            ["LineThickness"] = 0.01,
            ["Color3"] = hit_chams_color,
            ["Transparency"] = hit_chams_transparency,
            ["Name"] = "\0",
            ["Adornee"] = nil
        })
        local only_last_hit = nil
        local last_model = nil

        local destroy_hit_chams_none = function(model)
            destroy(model)
        end

        local destroy_hit_chams_fade = LPH_NO_VIRTUALIZE(function(model)
            local children = get_children(model)
            local elapsed_time = 0

            local tween_function = function(dt)
                if model then
                    elapsed_time+=dt
                    local transparency = hit_chams_transparency + (1 - hit_chams_transparency) * get_value(tween_service, elapsed_time / 0.25, quad, out)
                    for i = 1, #children do
                        local child = children[i]
                        local child_transparency = child["Transparency"]
                        if child_transparency ~= transparency and child_transparency ~= 1 then
                            child["Transparency"] = transparency
                        end
                    end
                end
            end

            heartbeat[#heartbeat+1] = tween_function
            delay(0.25, function()
                for i = 1, #heartbeat do
                    if heartbeat[i] == tween_function then
                        remove(heartbeat, i)
                        break
                    end
                end
                destroy(model)
            end)
        end)

        local size = vector3_new(1, 1, 1)

        local destroy_hit_chams_new_fade = LPH_NO_VIRTUALIZE(function(model)
            local children = get_children(model)
            local elapsed_time = 0

            local head = nil
            local old_sizes = {}
            for i = 1, #children do
                local child = children[i]
                if child["ClassName"] == "MeshPart" then
                    old_sizes[child] = child["Size"]
                end
                if child["Name"] == "Head" then
                    head = child
                end
            end

            if not head then
                return
            end

            local tween_function = function(dt)
                if model then
                    elapsed_time+=dt
                    local transparency = hit_chams_transparency + (1 - hit_chams_transparency) * get_value(tween_service, elapsed_time / 0.15, quad, out)
                    for i = 1, #children do
                        local child = children[i]
                        local child_transparency = child["Transparency"]
                        if child_transparency ~= 1 then
                            child["Transparency"] = transparency

                            local old_size = old_sizes[child]

                            if old_size then
                                child["Size"] = old_size + size*transparency
                            end
                        end
                    end
                end
            end

            heartbeat[#heartbeat+1] = tween_function
            delay(0.25, function()
                for i = 1, #heartbeat do
                    if heartbeat[i] == tween_function then
                        remove(heartbeat, i)
                        break
                    end
                end
                destroy(model)
            end)
        end)

        local destroy_hit_chams = destroy_hit_chams_new_fade
        local ignored = ignored[1]

        local do_hit_chams = LPH_NO_VIRTUALIZE(function(player)
            if last_model and only_last_hit then
                destroy(last_model)
            end

            last_model = nil

            local character = player_data[player][3]

            if character then
                character["Archivable"] = true
                local new_model = clone(character)
                character["Archivable"] = false
                new_model["Name"] = "\0"
                local children = get_children(new_model)

                for i = 1, #children do
                    local part = children[i]
                    local class_name = part["ClassName"]
                    if class_name == "MeshPart" then
                        part["Material"] = hit_chams_material
                        part["Color"] = hit_chams_color
                        part["Transparency"] = hit_chams_transparency
                        part["TextureID"] = ""
                        part["CanCollide"] = false
                        part["Anchored"] = true

                        if part["Name"] == "Head" then
                            local face = find_first_child_of_class(part, "Decal")

                            if face then
                                destroy(face)
                            end
                        end
                    elseif class_name == "Accessory" then
                        local hat = find_first_child_of_class(part, "MeshPart")

                        if hat then
                            hat["Material"] = hit_chams_material
                            hat["Color"] = hit_chams_color
                            hat["Transparency"] = hit_chams_transparency
                            hat["TextureID"] = ""
                            hat["CanCollide"] = false
                            hat["Anchored"] = true
                            hat["Parent"] = new_model
                            destroy(part)
                        end
                    else
                        destroy(part)
                    end
                end

                last_model = new_model
                new_model["Parent"] = ignored

                delay(hit_chams_lifetime, destroy_hit_chams, new_model)
            end
        end)

        local do_hit_chams_outline = LPH_NO_VIRTUALIZE(function(player)
            if last_model and only_last_hit then
                destroy(last_model)
            end

            last_model = nil

            local character = player_data[player][3]

            if character then
                character["Archivable"] = true
                local new_model = clone(character)
                character["Archivable"] = false
                new_model["Name"] = "\0"
                local children = get_children(new_model)

                for i = 1, #children do
                    local part = children[i]
                    local is_head = part["Name"] == "Head"
                    if is_head or part["ClassName"] == "MeshPart" then
                        local part_name = part["Name"]
                        part["Transparency"] = 1
                        part["CanCollide"] = false
                        part["Anchored"] = true
                        local outline = clone(hit_chams_part)
                        outline["Name"] = part_name
                        part["Name"] = "\0"
                        outline["Parent"] = new_model
                        outline["Adornee"] = part

                        if is_head then
                            local face = find_first_child(part, "face")

                            if face then
                                destroy(face)
                            end
                        end
                    else
                        destroy(part)
                    end
                end

                last_model = new_model
                new_model["Parent"] = ignored

                delay(hit_chams_lifetime, destroy_hit_chams, new_model)
            end
        end)

        create_connection(menu_references["hit_chams"]["on_toggle_change"], function(value)
            if hit_chams_on_player_hit then
                hit_chams_on_player_hit:Disconnect()
                hit_chams_on_player_hit = nil
            end

            if value then
                hit_chams_on_player_hit = create_connection(signals["on_local_bullet_confirmed"], flags["hit_chams_type"] == "outline" and do_hit_chams_outline or do_hit_chams)
            end
        end)

        create_connection(menu_references["hit_chams_only_last_hit"]["on_toggle_change"], function(value)
            only_last_hit = value
        end)

        create_connection(menu_references["hit_chams_color"]["on_color_change"], function(value)
            hit_chams_color = value
            hit_chams_part["Color3"] = value
        end)

        create_connection(menu_references["hit_chams_color"]["on_transparency_change"], function(value)
            hit_chams_transparency = value
            hit_chams_part["Transparency"] = value
        end)

        create_connection(menu_references["hit_chams_type"]["on_dropdown_change"], function(value)
            local value = value[1]
            hit_chams_material = value == "neon" and Enum["Material"]["Neon"] or value == "forcefield" and Enum["Material"]["ForceField"] or Enum["Material"]["ForceField"]

            if hit_chams_on_player_hit then
                hit_chams_on_player_hit:Disconnect()
                hit_chams_on_player_hit = nil
            end

            if flags["hit_chams"] then
                hit_chams_on_player_hit = create_connection(signals["on_local_bullet_confirmed"], value == "outline" and do_hit_chams_outline or do_hit_chams)
            end
        end)

        create_connection(menu_references["hit_chams_lifetime"]["on_slider_change"], function(value)
            hit_chams_lifetime = value
        end)

        create_connection(menu_references["hit_chams_animation"]["on_dropdown_change"], function(value)
            local value = value[1]
            destroy_hit_chams = value == "new fade" and destroy_hit_chams_new_fade or value == "fade" and destroy_hit_chams_fade or destroy_hit_chams_none
        end)
    end

    -- >> ( other visuals )

    menu_references["visuals_other_section"] = menu["groups"]["visuals"]:create_section("general", "other", 2, 0.35, 0.65)

    -- >> ( disable rendering )

    do
        menu_references["disable_rendering"] = menu_references["visuals_other_section"]:create_element({["name"] = "disable rendering"}, {["toggle"] = {["flag"] = "disable_rendering"}})

        create_connection(menu_references["disable_rendering"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            run_service["Set3dRenderingEnabled"](run_service, not value)
        end))
    end

    -- >> ( motion blur )

    do
        local lighting = game:GetService("Lighting")

        menu_references["motion_blur"] = menu_references["visuals_other_section"]:create_element({["name"] = "motion blur"}, {["toggle"] = {["flag"] = "motion_blur"}})
            menu_references["motion_blur_settings"] = menu_references["motion_blur"]:create_settings()
            menu_references["motion_blur_intensity"] = menu_references["motion_blur_settings"]:create_element({["name"] = "intensity"}, {["slider"] = {["min"] = 0, ["max"] = 100, ["flag"] = "motion_blur_intensity", ["suffix"] = "%", ["decimals"] = 1, ["default"] = 25}})

        local blur = nil
        local blur_intensity = 2750
        local last_look_vector = nil
        local smoothed_blur_size = 0

        local do_motion_blur = LPH_JIT_MAX(function(dt)
            render_stepped_wait(render_stepped)
            if not last_look_vector then
                last_look_vector = camera["CFrame"]["lookVector"]
                return
            end

            local look_vector = camera["CFrame"]["lookVector"]
            local new_blur_size = (look_vector - last_look_vector)["magnitude"] * blur_intensity * dt

            smoothed_blur_size = (smoothed_blur_size + (new_blur_size - smoothed_blur_size)) * dt*30^2
        
            blur["Size"] = smoothed_blur_size
            last_look_vector = look_vector
        end)

        create_connection(menu_references["motion_blur"]["on_toggle_change"], function(value)
            for i = 1, #heartbeat do
                if heartbeat[i] == do_motion_blur then
                    remove(heartbeat, i)
                    break
                end
            end

            if blur then
                destroy(blur)
                blur = nil
            end

            last_look_vector = nil

            if value then
                blur = create_instance("BlurEffect", {
                    ["Parent"] = lighting,
                    ["Size"] = 0
                })

                heartbeat[#heartbeat+1] = do_motion_blur
            end
        end)

        create_connection(menu_references["motion_blur_intensity"]["on_slider_change"], function(value)
            blur_intensity = value*110
        end)
    end
end

-- >> ( player visuals )

do
    menu_references["esp_section"] = menu["groups"]["visuals"]:create_section("players", "player esp", 1, 0.6, 0)
    menu_references["esp"] = menu_references["esp_section"]:create_element({["name"] = "enabled"}, {["toggle"] = {["flag"] = "esp"}})
        menu_references["esp_settings"] = menu_references["esp"]:create_settings()
        menu_references["render_statuses"] = menu_references["esp_settings"]:create_element({["name"] = "render statuses"}, {["dropdown"] = {["flag"] = "render_statuses", ["options"] = {"whitelisted", "normal", "target"}, ["default"] = {"whitelisted", "normal", "target"}, ["multi"] = true, ["requires_one"] = true}})

    menu_references["box"] = menu_references["esp_section"]:create_element({["name"] = "box"}, {["toggle"] = {["flag"] = "box"}})
        menu_references["box_settings"] = menu_references["box"]:create_settings()
        menu_references["box_outline"] = menu_references["box_settings"]:create_element({["name"] = "outline"}, {["colorpicker"] = {["color_flag"] = "box_outline_color", ["transparency_flag"] = "box_outline_transparency", ["default_color"] = color3_fromrgb(30, 30, 30), ["default_transparency"] = 0}})
        menu_references["box_color"] = menu_references["box_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "box_color", ["transparency_flag"] = "box_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["target_box_color"] = menu_references["box_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_box_color", ["transparency_flag"] = "target_box_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["whitelisted_box_color"] = menu_references["box_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_box_color", ["transparency_flag"] = "whitelisted_box_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})

    menu_references["name"] = menu_references["esp_section"]:create_element({["name"] = "name"}, {["toggle"] = {["flag"] = "name"}})
        menu_references["name_settings"] = menu_references["name"]:create_settings()
        menu_references["name_use_display"] = menu_references["name_settings"]:create_element({["name"] = "use display name"}, {["toggle"] = {["flag"] = "name_use_display"}})
        menu_references["name_color"] = menu_references["name_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "name_color", ["transparency_flag"] = "name_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["target_name_color"] = menu_references["name_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_name_color", ["transparency_flag"] = "target_name_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["whitelisted_name_color"] = menu_references["name_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_name_color", ["transparency_flag"] = "whitelisted_name_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})

    menu_references["image"] = menu_references["esp_section"]:create_element({["name"] = "image"}, {["toggle"] = {["flag"] = "image"}})
        menu_references["image_settings"] = menu_references["image"]:create_settings()
        menu_references["image_value"] = menu_references["image_settings"]:create_element({["name"] = "image"}, {["dropdown"] = {["options"] = {"gradient fill", "fill"}, ["requires_one"] = true, ["flag"] = "image_value", ["default"] = {"gradient fill"}}})
        menu_references["image_color"] = menu_references["image_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "image_color", ["transparency_flag"] = "image_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0.85}})
        menu_references["target_image_color"] = menu_references["image_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_image_color", ["transparency_flag"] = "target_image_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0.85}})
        menu_references["whitelisted_image_color"] = menu_references["image_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_image_color", ["transparency_flag"] = "whitelisted_image_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0.85}})

    menu_references["chams"] = menu_references["esp_section"]:create_element({["name"] = "chams"}, {["toggle"] = {["flag"] = "chams"}})
        menu_references["chams_settings"] = menu_references["chams"]:create_settings()
        menu_references["chams_behind_walls"] = menu_references["chams_settings"]:create_element({["name"] = "behind walls"}, {["toggle"] = {["flag"] = "chams_behind_walls", ["default"] = true}})
        menu_references["chams_color"] = menu_references["chams_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "chams_color", ["transparency_flag"] = "chams_transparency", ["default_color"] = color3_fromrgb(249, 217, 255), ["default_transparency"] = 0.5}})
        menu_references["target_chams_color"] = menu_references["chams_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_chams_color", ["transparency_flag"] = "target_chams_transparency", ["default_color"] = color3_fromrgb(249, 217, 255), ["default_transparency"] = 0.5}})
        menu_references["whitelisted_chams_color"] = menu_references["chams_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_chams_color", ["transparency_flag"] = "whitelisted_chams_transparency", ["default_color"] = color3_fromrgb(249, 217, 255), ["default_transparency"] = 0.5}})

    menu_references["material"] = menu_references["esp_section"]:create_element({["name"] = "material"}, {["toggle"] = {["flag"] = "material"}})
        menu_references["material_settings"] = menu_references["material"]:create_settings()
        menu_references["material_value"] = menu_references["material_settings"]:create_element({["name"] = "material"}, {["dropdown"] = {["options"] = {"neon", "forcefield"}, ["requires_one"] = true, ["flag"] = "material_value", ["default"] = {"neon"}}})
        menu_references["material_color"] = menu_references["material_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "material_color", ["transparency_flag"] = "material_transparency", ["default_color"] = color3_fromrgb(249, 217, 255), ["default_transparency"] = 0.2}})
        menu_references["target_material_color"] = menu_references["material_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_material_color", ["transparency_flag"] = "target_material_transparency", ["default_color"] = color3_fromrgb(249, 217, 255), ["default_transparency"] = 0.2}})
        menu_references["whitelisted_material_color"] = menu_references["material_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_material_color", ["transparency_flag"] = "whitelisted_material_transparency", ["default_color"] = color3_fromrgb(249, 217, 255), ["default_transparency"] = 0.2}})
        
    menu_references["item_text"] = menu_references["esp_section"]:create_element({["name"] = "tool text"}, {["toggle"] = {["flag"] = "item_text"}})
        menu_references["item_text_settings"] = menu_references["item_text"]:create_settings()
        menu_references["item_text_casing"] = menu_references["item_text_settings"]:create_element({["name"] = "casing"}, {["dropdown"] = {["options"] = {"uppercase", "lowercase"}, ["requires_one"] = true, ["flag"] = "item_text_casing", ["default"] = {"lowercase"}}})
        menu_references["item_text_color"] = menu_references["item_text_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "item_text_color", ["transparency_flag"] = "item_text_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["target_item_text_color"] = menu_references["item_text_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_item_text_color", ["transparency_flag"] = "target_item_text_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["whitelisted_item_text_color"] = menu_references["item_text_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_item_text_color", ["transparency_flag"] = "whitelisted_item_text_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        
    menu_references["item_icon"] = menu_references["esp_section"]:create_element({["name"] = "tool icon"}, {["toggle"] = {["flag"] = "item_icon"}})
        menu_references["item_icon_settings"] = menu_references["item_icon"]:create_settings()
        menu_references["item_icon_color"] = menu_references["item_icon_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "item_icon_color", ["transparency_flag"] = "item_icon_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["target_item_icon_color"] = menu_references["item_icon_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_item_icon_color", ["transparency_flag"] = "target_item_icon_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["whitelisted_item_icon_color"] = menu_references["item_icon_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_item_icon_color", ["transparency_flag"] = "whitelisted_item_icon_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})

    menu_references["highlight"] = menu_references["esp_section"]:create_element({["name"] = "highlight"}, {["toggle"] = {["flag"] = "highlight"}})
        menu_references["highlight_settings"] = menu_references["highlight"]:create_settings()
        menu_references["highlight_behind_walls"] = menu_references["highlight_settings"]:create_element({["name"] = "behind walls"}, {["toggle"] = {["flag"] = "highlight_behind_walls", ["default"] = true}})
        menu_references["highlight_color"] = menu_references["highlight_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "highlight_color", ["transparency_flag"] = "highlight_transparency", ["default_color"] = color3_fromrgb(0, 0, 0), ["default_transparency"] = 0.9}})
        menu_references["target_highlight_color"] = menu_references["highlight_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_highlight_color", ["transparency_flag"] = "target_highlight_transparency", ["default_color"] = color3_fromrgb(0, 0, 0), ["default_transparency"] = 0.9}})
        menu_references["whitelisted_highlight_color"] = menu_references["highlight_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_highlight_color", ["transparency_flag"] = "whitelisted_highlight_transparency", ["default_color"] = color3_fromrgb(0, 0, 0), ["default_transparency"] = 0.9}})
        menu_references["highlight_outline_color"] = menu_references["highlight_settings"]:create_element({["name"] = "outline color"}, {["colorpicker"] = {["color_flag"] = "highlight_outline_color", ["transparency_flag"] = "highlight_outline_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0.2}})
        menu_references["target_highlight_outline_color"] = menu_references["highlight_settings"]:create_element({["name"] = "target outline color"}, {["colorpicker"] = {["color_flag"] = "target_highlight_outline_color", ["transparency_flag"] = "target_highlight_outline_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0.2}})
        menu_references["whitelisted_highlight_outline_color"] = menu_references["highlight_settings"]:create_element({["name"] = "whitelisted outline color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_highlight_outline_color", ["transparency_flag"] = "whitelisted_highlight_outline_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0.2}})

    menu_references["health_bar"] = menu_references["esp_section"]:create_element({["name"] = "health bar"}, {["toggle"] = {["flag"] = "health_bar"}})
        menu_references["health_bar_settings"] = menu_references["health_bar"]:create_settings()
        menu_references["health_bar_gradient"] = menu_references["health_bar_settings"]:create_element({["name"] = "gradient"}, {["toggle"] = {["flag"] = "health_bar_gradient"}, ["colorpicker"] = {["color_flag"] = "health_bar_gradient_color", ["transparency_flag"] = "health_bar_gradient_transparency", ["default_color"] = color3_fromrgb(105, 205, 255), ["default_transparency"] = 0}})
        menu_references["target_health_bar_gradient"] = menu_references["health_bar_settings"]:create_element({["name"] = "target gradient"}, {["colorpicker"] = {["color_flag"] = "target_health_bar_gradient_color", ["transparency_flag"] = "target_health_bar_gradient_transparency", ["default_color"] = color3_fromrgb(105, 205, 255), ["default_transparency"] = 0}})
        menu_references["whitelisted_health_bar_gradient"] = menu_references["health_bar_settings"]:create_element({["name"] = "whitelisted gradient"}, {["colorpicker"] = {["color_flag"] = "whitelisted_health_bar_gradient_color", ["transparency_flag"] = "whitelisted_health_bar_gradient_transparency", ["default_color"] = color3_fromrgb(105, 205, 255), ["default_transparency"] = 0}})
        menu_references["health_bar_outline"] = menu_references["health_bar_settings"]:create_element({["name"] = "outline"}, {["colorpicker"] = {["color_flag"] = "health_bar_outline_color", ["transparency_flag"] = "health_bar_outline_transparency", ["default_color"] = color3_fromrgb(30, 30, 30), ["default_transparency"] = 0}})
        menu_references["health_bar_color"] = menu_references["health_bar_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "health_bar_color", ["transparency_flag"] = "health_bar_transparency", ["default_color"] = color3_fromrgb(0, 255, 0), ["default_transparency"] = 0}})
        menu_references["target_health_bar_color"] = menu_references["health_bar_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_health_bar_color", ["transparency_flag"] = "target_health_bar_transparency", ["default_color"] = color3_fromrgb(0, 255, 0), ["default_transparency"] = 0}})
        menu_references["whitelisted_health_bar_color"] = menu_references["health_bar_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_health_bar_color", ["transparency_flag"] = "whitelisted_health_bar_transparency", ["default_color"] = color3_fromrgb(0, 255, 0), ["default_transparency"] = 0}})
        menu_references["target_health_bar_gradient"]:set_visible(false)
        menu_references["whitelisted_health_bar_gradient"]:set_visible(false)

    menu_references["health_text"] = menu_references["esp_section"]:create_element({["name"] = "health text"}, {["toggle"] = {["flag"] = "health_text"}})
        menu_references["health_text_settings"] = menu_references["health_text"]:create_settings()
        menu_references["health_text_hide_if_full"] = menu_references["health_text_settings"]:create_element({["name"] = "hide if full"}, {["toggle"] = {["flag"] = "health_text_hide_if_full"}})
        menu_references["health_text_color"] = menu_references["health_text_settings"]:create_element({["name"] = "color"}, {["colorpicker"] = {["color_flag"] = "health_text_color", ["transparency_flag"] = "health_text_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["target_health_text_color"] = menu_references["health_text_settings"]:create_element({["name"] = "target color"}, {["colorpicker"] = {["color_flag"] = "target_health_text_color", ["transparency_flag"] = "target_health_text_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})
        menu_references["whitelisted_health_text_color"] = menu_references["health_text_settings"]:create_element({["name"] = "whitelisted color"}, {["colorpicker"] = {["color_flag"] = "whitelisted_health_text_color", ["transparency_flag"] = "whitelisted_health_text_transparency", ["default_color"] = color3_fromrgb(255, 255, 255), ["default_transparency"] = 0}})

    menu_references["fonts"] = menu_references["esp_section"]:create_element({["name"] = "fonts"}, {}):create_settings()
        menu_references["main_font"] = menu_references["fonts"]:create_element({["name"] = "main font"}, {["dropdown"] = {["options"] = {"0", "1", "2", "3"}, ["requires_one"] = true, ["flag"] = "main_font", ["default"] = identifyexecutor() == "Wave" and {"1"} or {"2"}}})
        menu_references["small_font"] = menu_references["fonts"]:create_element({["name"] = "small font"}, {["dropdown"] = {["options"] = {"0", "1", "2", "3"}, ["requires_one"] = true, ["flag"] = "small_font", ["default"] = identifyexecutor() == "Wave" and {"1"} or {"2"}}})

    -- >> ( esp variables )

    local offset = vector3_new(0,0.5,0)
    local bar_offset = vector2_new(0, 1)
    local zero_size = vector2_new()
    local chams_offset = vector3_new(0.01, 0.01, 0.01)

    local do_box = false

    local do_name = false
        local use_display_name = false

    local do_health_bar = false
        local health_bar_offset = vector2_new(6, 1)
        local do_health_bar_gradient = false

    local do_chams = false
    local chams_z_index = 1
    local do_image = false
    local do_highlight = false
    local highlight_depth_mode = Enum["HighlightDepthMode"]["AlwaysOnTop"]

    local do_item_text = false
        local item_text_function = string["lower"]
    local do_item_icon = false

    local do_health_text = false
        local normal_health_text_offset = vector2_new(8, 1)
        local health_text_offset = vector2_new(8, 1)
        local hide_health_text_if_full = false

    local do_material = false
        local material_value = Enum["Material"]["Neon"]
    local material_attribute = tostring({}):sub(math_random(8,12))

    local main_font = identifyexecutor() == "Wave" and 1 or 2
    local main_size = identifyexecutor() == "Wave" and 13 or 13
    local small_font = identifyexecutor() == "Wave" and 1 or 2
    local small_size = identifyexecutor() == "Wave" and 13 or 11

    local transparencies = {
        [1] = {
            [1] = 1,
            [2] = 1,
            [3] = 1,
            [4] = 1,
            [5] = 1,
            [6] = 1,
            [7] = 1,
            [8] = 1,
            [9] = 1,
            [10] = 1,
            [11] = 1,
            [12] = 1,
            [13] = 1,
            [14] = 0.11
        }
    }

    local colors = {
        [1] = {
            [1] = color3_fromrgb(255,255,255),
            [2] = color3_fromrgb(30,30,30),
            [3] = color3_fromrgb(255,255,255),
            [4] = color3_fromrgb(0, 255, 0),
            [5] = color3_fromrgb(30, 30, 30),
            [6] = color3_fromrgb(105, 205, 255),
            [7] = color3_fromrgb(255,255,255),
            [8] = color3_fromrgb(255,255,255),
            [9] = color3_fromrgb(255,255,255),
            [10] = color3_fromrgb(0,155,255),
            [11] = color3_fromrgb(35,35,35),
            [12] = color3_fromrgb(255,255,255),
            [13] = color3_fromrgb(255,255,255),
            [14] = color3_fromrgb(255,0,0),
        }
    }

    local alt_information = {
        [1] = {
            [1] = color3_fromrgb(0, 0, 0),
            [2] = 0.9,
            [3] = color3_fromrgb(255, 255, 255),
            [4] = 0.2,
            [5] = color3_fromrgb(249, 217, 255),
            [6] = 0.5,
            [7] = color3_fromrgb(249, 217, 255),
            [8] = 0.2
        }
    }

    local render_statuses = {
        [1] = 1,
        [2] = 1,
        [3] = 1
    }

    do
        local old_alt_information = alt_information[1]
        local old_transparencies = transparencies[1]
        local old_colors = colors[1]

        for i = 2, 3 do
            local new_alt_information = {}

            local new_transparencies = {}
            local new_colors = {}
            for i = 1, #old_transparencies do
                new_transparencies[i] = old_transparencies[i]
                new_colors[i] = old_colors[i]
            end
            for i = 1, #old_alt_information do
                new_alt_information[i] = old_alt_information[i]
            end
            alt_information[i] = new_alt_information
            transparencies[i] = new_transparencies
            colors[i] = new_colors
        end
    end

    -- >> ( esp core )

    local do_esp = LPH_NO_VIRTUALIZE(function()
        for player, data in player_data do
            local parts = data[4]
            local upper_torso = parts[r6_part]

            if not upper_torso or not data[3] or not render_statuses[data[1]] then
                continue
            end

            local position = upper_torso["Position"]
            local screen_pos, on_screen = world_to_viewport_point(camera, position + offset)

            if on_screen then
                local drawings = data[5]

                if not data[6] then
                    for _, drawing in drawings do
                        drawing["Visible"] = true
                    end
                    data[6] = true
                end

                local offset_pos = world_to_viewport_point(camera, position - offset)

                local difference = offset_pos["Y"]-screen_pos["Y"]
                local y_size = difference * 6
                local x_size = difference * 4

                local size = vector2_new(x_size, y_size)
                local position = vector2_new(offset_pos["X"] - x_size/2, offset_pos["Y"] - y_size/2)

                if do_box then
                    local box = drawings[1]
                    local outline = drawings[2]

                    box["Size"] = size
                    box["Position"] = position
                    outline["Size"] = size
                    outline["Position"] = position
                end

                if do_image then
                    local image = drawings[13]
                    image["Size"] = size
                    image["Position"] = position
                end

                if do_name then
                    drawings[3]["Position"] = position + vector2_new(x_size/2, -15)
                end

                if do_health_bar then
                    local y_size = y_size + 2
                    local outline = drawings[5]
                    outline["Position"] = position - health_bar_offset
                    outline["Size"] = vector2_new(4, y_size)

                    local health_size = (data[11]/data[10]) * (y_size-2)
                    local bar_position = position + vector2_new(-5, y_size - health_size - 2)
                    local bar_size = vector2_new(2, health_size)

                    local bar = drawings[4]
                    bar["Position"] = bar_position
                    bar["Size"] = bar_size

                    if do_health_bar_gradient then
                        local gradient = drawings[6]
                        gradient["Position"] = bar_position - bar_offset
                        gradient["Size"] = bar_size + bar_offset
                    end
                end

                if do_health_text then
                    local health_text = drawings[7]
                    drawings[7]["Position"] = position - health_text_offset - vector2_new(health_text["TextBounds"]["X"], 0)
                end

                if do_item_text then
                    if data[13] then
                        drawings[8]["Position"] = position + vector2_new(x_size/2, y_size + 2)
                    end
                end

                if do_item_icon then
                    if data[13] then
                        drawings[9]["Position"] = position + vector2_new((x_size-24)/2, y_size + (do_item_text and small_size or 0) + 2)
                    end
                end
            elseif data[6] then
                local drawings = data[5]
                for _, drawing in drawings do
                    drawing["Visible"] = false
                end
                data[6] = false
            end
        end
    end)

    local tween_esp = LPH_NO_VIRTUALIZE(function(data, showing)
        local status = data[1]

        local drawings = data[5]
        local transparencies = transparencies[status]

        local highlight = data[8]
        local highlight_transparencies = alt_information[status]
        local highlight_fill_transparency = highlight_transparencies[2]
        local highlight_outline_transparency = highlight_transparencies[4]

        local chams = data[12]
        local chams_transparency = highlight_transparencies[6]

        if not data[6] then
            for name, drawing in drawings do
                drawing["Transparency"] = showing and transparencies[name] or 0
            end
            if highlight then
                highlight["FillTransparency"] = showing and highlight_transparencies[2] or 1
                highlight["OutlineTransparency"] = showing and highlight_transparencies[4] or 1
            end
            if chams then
                for i = 1, #chams do
                    chams[i]["Transparency"] = showing and highlight_transparencies[6] or 1
                end
            end
            return
        end

        local old_transparencies = {}

        for name, drawing in drawings do
            old_transparencies[name] = drawing["Transparency"]
        end

        local elapsed_time = 0

        local heartbeat_function = function(dt)
            elapsed_time+=dt
            local value = get_value(tween_service, elapsed_time / 0.75, quad, out)

            for name, drawing in drawings do
                local old_transparency = old_transparencies[name]
                if old_transparency then
                    drawing["Transparency"] = old_transparency + ((showing and transparencies[name] or 0) - old_transparency) * value
                end
            end

            if highlight then
                highlight["FillTransparency"] = highlight_fill_transparency + ((showing and highlight_transparencies[2] or 1) - highlight_fill_transparency) * value
                highlight["OutlineTransparency"] = highlight_outline_transparency + ((showing and highlight_transparencies[4] or 1) - highlight_outline_transparency) * value
            end

            if chams then
                local transparency = chams_transparency + ((showing and highlight_transparencies[6] or 1) - chams_transparency) * value
                for i = 1, #chams do
                    chams[i]["Transparency"] = transparency
                end
            end
        end

        heartbeat[#heartbeat+1] = heartbeat_function

        delay(0.75, function()
            local index = nil
            for i = 1, #heartbeat do
                if heartbeat[i] == heartbeat_function then
                    index = i
                    break
                end
            end
            if index then
                remove(heartbeat, index)
            end
            for name, drawing in drawings do
                drawing["Transparency"] = showing and transparencies[name] or 0
            end
            if highlight then
                highlight["FillTransparency"] = showing and highlight_transparencies[2] or 1
                highlight["OutlineTransparency"] = showing and highlight_transparencies[4] or 1
            end
            if chams then
                for i = 1, #chams do
                    chams[i]["Transparency"] = showing and highlight_transparencies[6] or 1
                end
            end
        end)
    end)

    local update_esp = LPH_NO_VIRTUALIZE(function(data, status)
        local colors = colors[status]
        local transparencies = transparencies[status]
        local alt_information = alt_information[status]

        local drawings = data[5]
        local set_visibility = not render_statuses[status]
        data[6] = false

        for i = 1, #colors do
            local drawing = drawings[i]
            if drawing then
                drawing["Color"] = colors[i]
                drawing["Transparency"] = transparencies[i]

                if set_visibility then 
                    drawing["Visible"] = false
                end 
            end
        end

        local chams = data[12]
        if chams then
            local color = alt_information[5]
            local transparency = alt_information[6]
            for i = 1, #chams do
                chams[i]["Color3"] = color
                chams[i]["Transparency"] = transparency
            end
        end

        local highlight = data[8]
        if highlight then
            highlight["FillColor"] = alt_information[1]
            highlight["FillTransparency"] = alt_information[2]
            highlight["OutlineColor"] = alt_information[3]
            highlight["OutlineTransparency"] = alt_information[4]
        end
    end)

    local last_target = nil
    local update_esp_with_tween = nil; update_esp_with_tween = LPH_NO_VIRTUALIZE(function(data, revert_status, bypass)
        local status = revert_status or 3
        if last_target then
            local old_last_target = last_target
            last_target = nil
            update_esp_with_tween(old_last_target, old_last_target[1])
        end

        if data then
            if not revert_status then
                last_target = data
            end

            local old_status = data[1]

            if old_status ~= 3 then
                local colors = colors[status]
                local transparencies = transparencies[status]
                local alt_information = alt_information[status]

                local chams = data[12]
                local drawings = data[5]
                local highlight = data[8]
                local set_visibility = not render_statuses[status]
                data[6] = false

                if data[7] then
                    for i = 1, #colors do
                        local drawing = drawings[i]
                        if drawing then
                            drawing["Color"] = colors[i]

                            if set_visibility then 
                                drawing["Visible"] = false
                            end
                        end
                    end

                    if chams then
                        local color = alt_information[5]
                        local transparency = alt_information[6]
                        for i = 1, #chams do
                            chams[i]["Color3"] = color
                            chams[i]["Transparency"] = transparency
                        end
                    end

                    if highlight then
                        highlight["FillColor"] = alt_information[1]
                        highlight["OutlineColor"] = alt_information[3]

                        return
                    end
                end

                for i = 1, #colors do
                    local drawing = drawings[i]
                    if drawing then
                        tween(drawing, {Color = colors[i], Transparency = transparencies[i]}, exponential, out, 0.17)
                    end
                end

                if chams then
                    local color = alt_information[5]
                    local transparency = alt_information[6]
                    for i = 1, #chams do
                        tween(chams[i], {Color3 = color, Transparency = transparency}, exponential, out, 0.17)
                    end
                end

                if highlight then
                    tween(highlight, {FillColor = alt_information[1], FillTransparency = alt_information[2], OutlineColor = alt_information[3], OutlineTransparency = alt_information[4]}, exponential, out, 0.17)
                end
            end
        end
    end)

    local create_box = LPH_NO_VIRTUALIZE(function(data)
        local rendering = data[6]
        local drawings = data[5]
        local status = data[1]

        local colors = colors[status]
        local transparencies = transparencies[status]

        drawings[1] = create_real_drawing("Square", {
            Color = colors[1],
            Thickness = 1,
            Filled = false,
            Transparency = transparencies[1],
            ZIndex = 3,
            Visible = rendering
        })
        drawings[2] = create_real_drawing("Square", {
            Color = colors[2],
            Thickness = 3,
            Filled = false,
            ZIndex = 2,
            Transparency = transparencies[2],
            Visible = rendering
        })
    end)

    local create_name = LPH_NO_VIRTUALIZE(function(data)
        local status = data[1]
        local player = data[2]

        data[5][3] = create_real_drawing("Text", {
            Color = colors[status][3],
            Center = true,
            Outline = true,
            Transparency = transparencies[status][3],
            Size = main_size,
            Font = main_font,
            Text = use_display_name and player["DisplayName"] or player["Name"],
            Visible = data[6]
        })
    end)

    local bar_half_gradient_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAACACAYAAADK+QP0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACUSURBVChTbVHRFQMhDFLjEA7T/ecqoXBRe3woJIjm2dZanwH0XLABIyLEDLJdls+ypYznmCxkB2Q22GUMa+wmAUPcLr1gy+JbA9gZfWQV5RoujWhnCrtjzDnVsLkWvpRRnPeyUNZslLooxSMvVvIKUCggn3HdoQFL5v4LBd7yCDUqwGcrhVCe8efzw6+U3WKcX9H7F7u/BOHzO9gQAAAAAElFTkSuQmCC")

    local create_health_bar = LPH_NO_VIRTUALIZE(function(data)
        local rendering = data[6]
        local drawings = data[5]
        local status = data[1]

        data[11] = data[9]

        local colors = colors[status]
        local transparencies = transparencies[status]

        drawings[4] = create_real_drawing("Square", {
            Color = colors[4],
            Thickness = 1,
            Filled = true,
            Transparency = transparencies[4],
            ZIndex = 3,
            Visible = rendering
        })
        drawings[5] = create_real_drawing("Square", {
            Color = colors[5],
            Thickness = 3,
            Filled = true,
            ZIndex = 2,
            Transparency = transparencies[5],
            Visible = rendering
        })

        if do_health_bar_gradient then
            drawings[6] = create_real_drawing("Image", {
                Color = colors[6],
                Transparency = transparencies[6],
                ZIndex = 4,
                Data = bar_half_gradient_data,
                Visible = rendering
            })
        end
    end)

    local update_health_bar = LPH_NO_VIRTUALIZE(function(data, new_health, difference)
        if abs(difference) <= 1 then
            data[11] = new_health
            return
        end
        tween(data, {[11] = new_health}, "sine", out, 0.15)
    end)

    local create_chams = LPH_NO_VIRTUALIZE(function(data)
        local parts = data[4]

        local alt_information = alt_information[data[1]]
        local color = alt_information[5]
        local transparency = alt_information[6]

        local chams = {}
        local culling_mode = Enum["AdornCullingMode"]["Automatic"]

        for i = 1, #body_parts do
            local part = body_parts[i]
            local character_part = parts[part]
            chams[#chams+1] = create_instance("BoxHandleAdornment", {
                ["Visible"] = true,
                ["Adornee"] = character_part,
                ["Transparency"] = transparency,
                ["AdornCullingMode"] = culling_mode,
                ["Archivable"] = true,
                ["Color3"] = color,
                ["ZIndex"] = chams_z_index,
                ["AlwaysOnTop"] = true,
                ["Size"] = character_part and character_part["Size"] + chams_offset or chams_offset,
                ["Parent"] = core_gui
            })
        end

        data[12] = chams
    end)

    local update_chams = LPH_NO_VIRTUALIZE(function(data)
        local chams = data[12]
        local parts = data[4]
        for i = 1, #body_parts do
            local cham = chams[i]
            local local_part = parts[body_parts[i]]
            cham["Adornee"] = local_part
            cham["Size"] = local_part and local_part["Size"] + chams_offset or chams_offset
        end
    end)

    local update_highlight = LPH_NO_VIRTUALIZE(function(data)
        local highlight = data[8]
        highlight["Adornee"] = nil
        highlight["Parent"] = nil
        highlight["Adornee"] = data[3]
        highlight["Parent"] = hui
    end)

    local create_highlight = LPH_NO_VIRTUALIZE(function(data)
        local alt_information = alt_information[data[1]]
        local character = data[3]

        data[8] = create_instance("Highlight", {
            FillColor = alt_information[1],
            FillTransparency = alt_information[2],
            OutlineColor = alt_information[3],
            OutlineTransparency = alt_information[4],
            DepthMode = highlight_depth_mode,
            Enabled = true,
            Adornee = character,
            Parent = hui
        })
    end)

    local update_health_text = LPH_NO_VIRTUALIZE(function(data, health)
        data[5][7]["Text"] = (hide_health_text_if_full and health >= data[10] or false) and "" or tostring(health)
    end)

    local create_health_text = LPH_NO_VIRTUALIZE(function(data)
        local status = data[1]
        local health = data[9]

        data[5][7] = create_real_drawing("Text", {
            Color = colors[status][7],
            Center = false,
            Outline = true,
            Transparency = transparencies[status][7],
            Size = small_size,
            Font = small_font,
            Text = (hide_health_text_if_full and health >= data[10] or false) and "" or tostring(health),
            Visible = data[6]
        })
    end)

    local item_icon_data = {}

    local create_item_text = LPH_NO_VIRTUALIZE(function(data)
        local status = data[1]
        local tool = data[13]

        data[5][8] = create_real_drawing("Text", {
            Color = colors[status][8],
            Center = true,
            Outline = true,
            Transparency = transparencies[status][8],
            Size = small_size,
            Font = small_font,
            Text = tool and item_text_function(tool["Name"]:gsub("[^%w]", "")) or "",
            Visible = data[6]
        })
    end)

    local update_item_text = LPH_NO_VIRTUALIZE(function(data, tool)
        if data[2] and data[5][8] then
            data[5][8]["Text"] = tool and item_text_function(tool["Name"]:gsub("[^%w]", "")) or ""
        end
    end)

    local create_item_icon = (identifyexecutor() == "Swift" or identifyexecutor() == "Potassium") and LPH_NO_VIRTUALIZE(function(data)
        if data[2] then
            local status = data[1]
            local tool = data[13]

            local image = tool and item_icon_data[tool["Name"]] or ""
            data[5][9] = create_fake_drawing("Image", {
                Color = colors[status][9],
                Transparency = transparencies[status][9],
                Data = image,
                Size = vector2_new(24,12),
                Visible = data[6]
            })
        end
    end) or LPH_NO_VIRTUALIZE(function(data)
        if data[2] then
            local status = data[1]
            local tool = data[13]

            local image = tool and item_icon_data[tool["Name"]] or ""
            data[5][9] = create_real_drawing("Image", {
                Color = colors[status][9],
                Transparency = transparencies[status][9],
                Data = image,
                Size = vector2_new(24,12),
                Visible = data[6]
            })
        end
    end)

    local update_item_icon = LPH_NO_VIRTUALIZE(function(data, tool)
        if data[2] and data[5][9] then
            data[5][9]["Data"] = tool and item_icon_data[tool["Name"]] or ""
        end
    end)

    local image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAABkCAYAAABHLFpgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABTSURBVChTdU/LDsAwCGJu1/3/59rUC5HAhaA8bNHdfwF4LrwbagN3wgakwMVc4ttCTLhxmKjOIma5S5VfiC0TE180R8aRIAJvuJfGGHcsoHoZ6gCUSgTCpTUDpwAAAABJRU5ErkJggg==")

    local create_image = LPH_NO_VIRTUALIZE(function(data)
        local status = data[1]

        data[5][13] = create_real_drawing("Image", {
            Color = colors[status][13],
            Transparency = transparencies[status][13],
            Data = image_data or "",
            ZIndex = 4,
            Visible = data[6]
        })
    end)

    local plastic = Enum["Material"]["Plastic"]
    local forcefield = Enum["Material"]["ForceField"]

    local remove_material = LPH_NO_VIRTUALIZE(function(data, character, parts, description)
        local character = character or data[3]

        if character then
            local parts = parts or data[4]
            local head = parts["Head"]
            local humanoid = parts["Humanoid"]

        end
    end)

    local apply_material = LPH_NO_VIRTUALIZE(function(data, character, material)
        local character = data[3]
        local material = material or material_value

        if character then
            local player = data[2]

        end
    end)

    local create_esp = LPH_NO_VIRTUALIZE(function(data)
        data[6] = false
        if do_box then
            create_box(data)
        end
        if do_name then
            create_name(data)
        end
        if do_chams then
            create_chams(data)
        end
        if do_highlight then
            create_highlight(data)
        end
        if do_health_bar then
            create_health_bar(data)
        end
        if do_health_text then
            create_health_text(data)
        end
        if do_item_text then
            create_item_text(data)
        end
        if do_item_icon then
            create_item_icon(data)
        end
        if do_image then
            create_image(data)
        end
        if do_material then
            local character = data[3]

            if character then
                spawn(apply_material, data)
            end
        end
    end)

    local create_esp_with_tween = LPH_NO_VIRTUALIZE(function(data)
        create_esp(data)
        tween_esp(data, true)
    end)

    -- >> ( show arms in first person)

    do
        menu_references["local_character_section"] = menu["groups"]["visuals"]:create_section("players", "local character", 2, 1, 0)
    end


    -- >> ( esp connections )

    do
        local health_text_player_health_changed_connection = nil
        local health_bar_player_health_changed_connection = nil
        local armor_bar_player_armor_changed_connection = nil

        local item_text_player_tool_equipped_connection = nil
        local item_icon_player_tool_equipped_connection = nil
        local highlight_character_added_connection = nil
        local material_on_player_character_added = nil
        local player_legitbot_target_connection = nil

        local chams_character_added_connection = nil
        local player_status_changed_connection = nil
        local character_added_connection = nil
        local player_added_connection = nil
        local player_died_connection = nil

        create_connection(menu_references["render_statuses"]["on_dropdown_change"], function(value)
            render_statuses[1] = nil
            render_statuses[2] = nil
            render_statuses[3] = nil

            for i = 1, #value do
                local value = value[i]
                if value == "whitelisted" then
                    render_statuses[2] = 1
                elseif value == "normal" then
                    render_statuses[1] = 1
                elseif value == "target" then
                    render_statuses[3] = 1
                end
            end

            if player_added_connection then
                for player, data in player_data do
                    local status = data[4]
                    local visible = render_statuses[status]

                    for _, drawing in data[5] do
                        drawing["Visible"] = visible and data[6] or false
                    end

                    data[6] = not visible and false or visible and data[6]
                end
            end
        end)

        create_connection(menu_references["esp"]["on_toggle_change"], LPH_JIT_MAX(function(value)
            for i = 1, #heartbeat do
                if heartbeat[i] == do_esp then
                    remove(heartbeat, i)
                    break
                end
            end

            for player, data in player_data do
                local drawings = data[5]
                for _, drawing in drawings do
                    drawing:Destroy()
                    drawings[_] = nil
                end

                local highlight = data[8]
                if highlight then
                    destroy(highlight)
                    data[8] = nil
                end

                local chams = data[12]
                if chams then
                    for i = 1, #chams do
                        destroy(chams[i])
                        chams[i] = nil
                    end
                    data[12] = nil
                end

                if do_material and data[3] then
                    remove_material(data)
                end
            end

            if character_added_connection then
                character_added_connection:Disconnect()
                character_added_connection = nil
            end

            if player_added_connection then
                player_added_connection:Disconnect()
                player_added_connection = nil
            end

            if player_died_connection then
                player_died_connection:Disconnect()
                player_died_connection = nil
            end

            if health_bar_player_health_changed_connection then
                health_bar_player_health_changed_connection:Disconnect()
                health_bar_player_health_changed_connection = nil
            end

            if health_text_player_health_changed_connection then
                health_text_player_health_changed_connection:Disconnect()
                health_text_player_health_changed_connection = nil
            end

            if chams_character_added_connection then
                chams_character_added_connection:Disconnect()
                chams_character_added_connection = nil
            end

            if highlight_character_added_connection then
                highlight_character_added_connection:Disconnect()
                highlight_character_added_connection = nil
            end

            if item_text_player_tool_equipped_connection then
                item_text_player_tool_equipped_connection:Disconnect()
                item_text_player_tool_equipped_connection = nil
            end

            if item_icon_player_tool_equipped_connection then
                item_icon_player_tool_equipped_connection:Disconnect()
                item_icon_player_tool_equipped_connection = nil
            end

            if player_legitbot_target_connection then
                player_legitbot_target_connection:Disconnect()
                player_legitbot_target_connection = nil
            end

            if player_status_changed_connection then
                player_status_changed_connection:Disconnect()
                player_status_changed_connection = nil
            end

            if material_on_player_character_added then
                material_on_player_character_added:Disconnect()
                material_on_player_character_added = nil
            end

            if value then
                for player, data in player_data do
                    create_esp(data)
                end

                heartbeat[#heartbeat+1] = do_esp

                player_died_connection = create_connection(signals["on_player_died"], tween_esp)
                player_added_connection = create_connection(signals["on_player_added"], create_esp_with_tween)
                character_added_connection = create_connection(signals["on_player_character_added"], tween_esp)
                player_status_changed_connection = create_connection(signals["on_player_status_changed"], update_esp)
                player_legitbot_target_connection = create_connection(signals["on_legitbot_target_changed"], update_esp_with_tween)

                if do_health_bar then
                    health_bar_player_health_changed_connection = create_connection(signals["on_player_health_changed"], update_health_bar)
                end

                if do_chams then
                    chams_character_added_connection = create_connection(signals["on_player_character_added"], update_chams)
                end

                if do_highlight then
                    highlight_character_added_connection = create_connection(signals["on_player_character_added"], update_highlight)
                end

                if do_item_text then
                    item_text_player_tool_equipped_connection = create_connection(signals["on_player_tool_equipped"], update_item_text)
                end

                if do_item_icon then
                    item_icon_player_tool_equipped_connection = create_connection(signals["on_player_tool_equipped"], create_item_icon)
                end

                if do_material then
                    material_on_player_character_added = create_connection(signals["on_player_character_added"], apply_material)
                end

                if do_health_text then
                    health_text_player_health_changed_connection = create_connection(signals["on_player_health_changed"], update_health_text)
                end
            end
        end))

        create_connection(menu_references["main_font"]["on_dropdown_change"], LPH_NO_VIRTUALIZE(function(value)
            main_font = tonumber(value[1])

            if value and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]
                    local name = drawings[3]

                    if name then
                        name["Font"] = main_font
                    end
                end
            end
        end))

        create_connection(menu_references["small_font"]["on_dropdown_change"], LPH_NO_VIRTUALIZE(function(value)
            small_font = tonumber(value[1])

            if value and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]
                    local health_text = drawings[7]

                    if health_text then
                        health_text["Font"] = small_font
                    end

                    local item_text = drawings[8]

                    if item_text then
                        item_text["Font"] = small_font
                    end
                end
            end
        end))

        create_connection(menu_references["box"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_box = value

            for player, data in player_data do
                local drawings = data[5]
                local box = drawings[1]
                local box_outline = drawings[2]

                if box then
                    box:Destroy()
                    drawings[1] = nil
                end

                if box_outline then
                    box_outline:Destroy()
                    drawings[2] = nil
                end
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_box(data)
                end
            end
        end))

        create_connection(menu_references["name"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_name = value

            for player, data in player_data do
                local drawings = data[5]
                local name = drawings[3]

                if name then
                    name:Destroy()
                    drawings[3] = nil
                end
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_name(data)
                end
            end
        end))

        create_connection(menu_references["name_use_display"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            use_display_name = value
            if do_name and flags["esp"] then
                for player, data in player_data do
                    local name = data[5][3]

                    if name then
                        name["Text"] = value and player["DisplayName"] or player["Name"]
                    end
                end
            end
        end))

        create_connection(menu_references["box_outline"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[1][2] = color
            colors[2][2] = color
            colors[3][2] = color

            if do_box and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]
                    local box_outline = drawings[2]

                    if box_outline then
                        box_outline["Color"] = color
                    end
                end
            end
        end))

        create_connection(menu_references["box_outline"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1

            transparencies[1][2] = transparency
            transparencies[2][2] = transparency
            transparencies[3][2] = transparency

            if do_box and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]
                    local box_outline = drawings[2]

                    if box_outline then
                        box_outline["Transparency"] = transparency
                    end
                end
            end
        end))

        create_connection(menu_references["health_bar_outline"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[1][5] = color
            colors[2][5] = color
            colors[3][5] = color

            if do_health_bar and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]
                    local health_bar_outline = drawings[5]

                    if health_bar_outline then
                        health_bar_outline["Color"] = color
                    end
                end
            end
        end))

        create_connection(menu_references["health_bar_outline"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[1][5] = transparency
            transparencies[2][5] = transparency
            transparencies[3][5] = transparency

            if do_health_bar and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]
                    local health_bar_outline = drawings[5]

                    if health_bar_outline then
                        health_bar_outline["Transparency"] = transparency
                    end
                end
            end
        end))

        create_connection(menu_references["health_bar_gradient"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_health_bar_gradient = value

            menu_references["target_health_bar_gradient"]:set_visible(value)
            menu_references["whitelisted_health_bar_gradient"]:set_visible(value)

            if do_health_bar and flags["esp"] then
                for player, data in player_data do
                    local drawings = data[5]

                    local health_bar = drawings[4]
                    if health_bar then
                        health_bar:Destroy()
                        drawings[4] = nil
                    end

                    local health_bar_outline = drawings[5]
                    if health_bar_outline then
                        health_bar_outline:Destroy()
                        drawings[5] = nil
                    end

                    local health_bar_gradient = drawings[6]
                    if health_bar_gradient then
                        health_bar_gradient:Destroy()
                        drawings[6] = nil
                    end

                    create_health_bar(data)
                end
            end
        end))

        create_connection(menu_references["health_bar"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_health_bar = value
            armor_bar_offset = value and vector2_new(11, 1) or vector2_new(6, 1)
            health_text_offset = value and (do_armor_bar and vector2_new(15, 1) or vector2_new(8, 1)) or vector2_new(2, 1)

            if health_bar_player_health_changed_connection then
                health_bar_player_health_changed_connection:Disconnect()
                health_bar_player_health_changed_connection = nil
            end

            for player, data in player_data do
                local drawings = data[5]

                local health_bar = drawings[4]
                if health_bar then
                    health_bar:Destroy()
                    drawings[4] = nil
                end

                local health_bar_outline = drawings[5]
                if health_bar_outline then
                    health_bar_outline:Destroy()
                    drawings[5] = nil
                end

                local health_bar_gradient = drawings[6]
                if health_bar_gradient then
                    health_bar_gradient:Destroy()
                    drawings[6] = nil
                end
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_health_bar(data)
                end

                health_bar_player_health_changed_connection = create_connection(signals["on_player_health_changed"], update_health_bar)
            end
        end))

        create_connection(menu_references["chams"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_chams = value

            if chams_character_added_connection then
                chams_character_added_connection:Disconnect()
                chams_character_added_connection = nil
            end

            for player, data in player_data do
                local chams = data[12]

                if chams then
                    for i = 1, #chams do
                        destroy(chams[i])
                        chams[i] = nil
                    end
                    data[12] = nil
                end
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_chams(data)
                end

                chams_character_added_connection = create_connection(signals["on_player_character_added"], update_chams)
            end
        end))

        create_connection(menu_references["chams_behind_walls"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            chams_z_index = value and 1 or -1

            if flags["esp"] then
                for player, data in player_data do
                    local chams = data[12]
                    for i = 1, #chams do
                        chams[i]["ZIndex"] = chams_z_index
                    end
                end
            end
        end))

        create_connection(menu_references["highlight_behind_walls"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            highlight_depth_mode = value and Enum["HighlightDepthMode"]["AlwaysOnTop"] or Enum["HighlightDepthMode"]["Occluded"]

            if flags["esp"] then
                for player, data in player_data do
                    local highlight = data[8]
                    if highlight then
                        highlight["DepthMode"] = highlight_depth_mode
                    end
                end
            end
        end))

        create_connection(menu_references["highlight"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_highlight = value

            if highlight_character_added_connection then
                highlight_character_added_connection:Disconnect()
                highlight_character_added_connection = nil
            end

            for player, data in player_data do
                local highlight = data[8]

                if highlight then
                    destroy(highlight)
                    data[8] = nil
                end
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_highlight(data)
                end

                highlight_character_added_connection = create_connection(signals["on_player_character_added"], update_highlight)
            end
        end))

        create_connection(menu_references["health_text"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_health_text = value

            for player, data in player_data do
                local drawings = data[5]
                local health_text = drawings[7]

                if health_text then
                    health_text:Destroy()
                    drawings[7] = nil
                end
            end

            if health_text_player_health_changed_connection then
                health_text_player_health_changed_connection:Disconnect()
                health_text_player_health_changed_connection = nil
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_health_text(data)
                end

                health_text_player_health_changed_connection = create_connection(signals["on_player_health_changed"], update_health_text)
            end
        end))

        create_connection(menu_references["health_text_hide_if_full"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            hide_health_text_if_full = value

            if flags["esp"] and do_health_text then
                for player, data in player_data do
                    update_health_text(data, data[9])
                end
            end
        end))

        create_connection(menu_references["item_text"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_item_text = value

            for player, data in player_data do
                local drawings = data[5]
                local item_text = drawings[8]

                if item_text then
                    item_text:Destroy()
                    drawings[8] = nil
                end
            end

            if item_text_player_tool_equipped_connection then
                item_text_player_tool_equipped_connection:Disconnect()
                item_text_player_tool_equipped_connection = nil
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_item_text(data)
                end

                item_text_player_tool_equipped_connection = create_connection(signals["on_player_tool_equipped"], update_item_text)
            end
        end))

        create_connection(menu_references["item_text_casing"]["on_dropdown_change"], LPH_NO_VIRTUALIZE(function(value)
            item_text_function = value[1] == "uppercase" and string["upper"] or string["lower"]
        end))

        create_connection(menu_references["item_icon"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_item_icon = value

            for player, data in player_data do
                local drawings = data[5]
                local item_icon = drawings[9]

                if item_icon then
                    item_icon:Destroy()
                    drawings[9] = nil
                end
            end

            if item_icon_player_tool_equipped_connection then
                item_icon_player_tool_equipped_connection:Disconnect()
                item_icon_player_tool_equipped_connection = nil
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_item_icon(data)
                end

                item_icon_player_tool_equipped_connection = create_connection(signals["on_player_tool_equipped"], update_item_icon)
            end
        end))

        create_connection(menu_references["image"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_image = value

            for player, data in player_data do
                local drawings = data[5]
                local image = drawings[13]

                if image then
                    image:Destroy()
                    drawings[13] = nil
                end
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    create_image(data)
                end
            end
        end))

        create_connection(menu_references["image_value"]["on_dropdown_change"], LPH_JIT_MAX(function(value)
            local selected = value[1]

            image_data = selected == "gradient fill" and "iVBORw0KGgoAAAANSUhEUgAAAAEAAABkCAYAAABHLFpgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABTSURBVChTdU/LDsAwCGJu1/3/59rUC5HAhaA8bNHdfwF4LrwbagN3wgakwMVc4ttCTLhxmKjOIma5S5VfiC0TE180R8aRIAJvuJfGGHcsoHoZ6gCUSgTCpTUDpwAAAABJRU5ErkJggg==" or selected == "fill" and "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/j//z8ABf4C/qc1gYQAAAAASUVORK5CYII=" or ""

            if image_data == "" then
                local path = "juju recode/custom/"..selected

                if isfile(path) then
                    image_data = readfile(path)
                end
            else
                image_data = base64_decode(image_data)
            end

            if do_image then
                for player, data in player_data do
                    data[5][13]["Data"] = image_data
                end
            end
        end))

        create_connection(menu_references["material_value"]["on_dropdown_change"], function(value)
            material_value = value[1] == "neon" and Enum["Material"]["Neon"] or Enum["Material"]["ForceField"]
        end)

        create_connection(menu_references["material"]["on_toggle_change"], LPH_NO_VIRTUALIZE(function(value)
            do_material = value

            if material_on_player_character_added then
                material_on_player_character_added:Disconnect()
                material_on_player_character_added = nil
            end

            if value and flags["esp"] then
                for player, data in player_data do
                    if data[3] then
                        spawn(apply_material, data)
                    end
                end

                material_on_player_character_added = create_connection(signals["on_player_character_added"], apply_material)
            elseif flags["esp"] then
                for player, data in player_data do
                    if data[3] then
                        remove_material(data)
                    end
                end
            end
        end))
    end

    -- >> ( color / transparency updaters )

    local statuses = {
        [1] = "",
        [2] = "whitelisted_",
        [3] = "target_"
    }

    for status, name in statuses do
        local colors = colors[status]
        local transparencies = transparencies[status]
        local alt_information = alt_information[status]

        create_connection(menu_references[name.."box_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[1] = color
            if do_box then
                for player, data in player_data do
                    if data[1] == status then
                        local box = data[5][1]

                        if box then
                            box["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."box_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[1] = transparency

            if do_box then
                for player, data in player_data do
                    if data[1] == status then
                        local box = data[5][1]

                        if box then
                            box["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."name_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[3] = color
            if do_name then
                for player, data in player_data do
                    if data[1] == status then
                        local name = data[5][3]

                        if name then
                            name["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."name_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[3] = transparency

            if do_name then
                for player, data in player_data do
                    if data[1] == status then
                        local name = data[5][3]

                        if name then
                            name["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."health_bar_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[4] = color
            if do_health_bar then
                for player, data in player_data do
                    if data[1] == status then
                        local health_bar = data[5][4]

                        if health_bar then
                            health_bar["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."health_bar_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[4] = transparency

            if do_health_bar then
                for player, data in player_data do
                    if data[1] == status then
                        local health_bar = data[5][4]

                        if health_bar then
                            health_bar["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."health_bar_gradient"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[6] = color
            if do_health_bar and do_health_bar_gradient then
                for player, data in player_data do
                    if data[1] == status then
                        local health_bar_gradient = data[5][6]

                        if health_bar_gradient then
                            health_bar_gradient["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."health_bar_gradient"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[6] = transparency

            if do_health_bar and do_health_bar_gradient then
                for player, data in player_data do
                    if data[1] == status then
                        local health_bar_gradient = data[5][6]

                        if health_bar_gradient then
                            health_bar_gradient["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."chams_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            alt_information[5] = color
            if do_chams then
                for player, data in player_data do
                    if data[1] == status then
                        local chams = data[12]

                        if chams then
                            for i = 1, #chams do
                                chams[i]["Color3"] = color
                            end
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."chams_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            alt_information[6] = transparency

            if do_chams then
                for player, data in player_data do
                    if data[1] == status then
                        local chams = data[12]

                        if chams then
                            for i = 1, #chams do
                                chams[i]["Transparency"] = transparency
                            end
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."highlight_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            alt_information[1] = color
            if do_highlight then
                for player, data in player_data do
                    if data[1] == status then
                        local highlight = data[8]

                        if highlight then
                            highlight["FillColor"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."highlight_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            alt_information[2] = transparency

            if do_highlight then
                for player, data in player_data do
                    if data[1] == status then
                        local highlight = data[8]

                        if highlight then
                            highlight["FillTransparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."highlight_outline_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            alt_information[3] = color
            if do_highlight then
                for player, data in player_data do
                    if data[1] == status then
                        local highlight = data[8]

                        if highlight then
                            highlight["OutlineColor"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."highlight_outline_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            alt_information[4] = transparency

            if do_highlight then
                for player, data in player_data do
                    if data[1] == status then
                        local highlight = data[8]

                        if highlight then
                            highlight["OutlineTransparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."health_text_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[7] = color
            if do_health_text then
                for player, data in player_data do
                    if data[1] == status then
                        local health_text = data[5][7]

                        if health_text then
                            health_text["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."health_text_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[7] = transparency

            if do_health_text then
                for player, data in player_data do
                    if data[1] == status then
                        local health_text = data[5][7]

                        if health_text then
                            health_text["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."item_text_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[8] = color
            if do_item_text then
                for player, data in player_data do
                    if data[1] == status then
                        local item_text = data[5][8]

                        if item_text then
                            item_text["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."item_text_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[8] = transparency

            if do_item_text then
                for player, data in player_data do
                    if data[1] == status then
                        local item_text = data[5][8]

                        if item_text then
                            item_text["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."item_icon_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[9] = color
            if do_item_icon then
                for player, data in player_data do
                    if data[1] == status then
                        local item_icon = data[5][9]

                        if item_icon then
                            item_icon["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."item_icon_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[9] = transparency

            if do_item_icon then
                for player, data in player_data do
                    if data[1] == status then
                        local item_icon = data[5][9]

                        if item_icon then
                            item_icon["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."image_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            colors[13] = color
            if do_image then
                for player, data in player_data do
                    if data[1] == status then
                        local image = data[5][13]

                        if image then
                            image["Color"] = color
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."image_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            local transparency = -transparency+1
            transparencies[13] = transparency

            if do_image then
                for player, data in player_data do
                    if data[1] == status then
                        local image = data[5][13]

                        if image then
                            image["Transparency"] = transparency
                        end
                    end
                end
            end
        end))

        create_connection(menu_references[name.."material_color"]["on_color_change"], LPH_NO_VIRTUALIZE(function(color)
            alt_information[7] = color

            if do_material then
                for player, data in player_data do
                    if data[1] == status and data[3] then
                        spawn(apply_material, data)
                    end
                end
            end
        end))

        create_connection(menu_references[name.."material_color"]["on_transparency_change"], LPH_NO_VIRTUALIZE(function(transparency)
            alt_information[8] = clamp(transparency, 0, 0.999999)

            if do_material then
                for player, data in player_data do
                    if data[1] == status and data[3] then
                        spawn(apply_material, data)
                    end
                end
            end
        end))
    end

    -- >> ( other )

    menu_references["other_section"] = menu["groups"]["visuals"]:create_section("players", "other", 1, 0.4, 0.6)
end

-- > ( legitbot )

local set_aim_assist_position = nil
local set_silent_aim_position = nil
local get_silent_aim_position = nil

do
    -- >> ( mouse hook )

    local silent_aim_position = nil
    local silent_aim_redirect_chance = 0
    local custom_silent_aim_position = nil

    do
        local old = getrawmetatable(mouse)
        local old_index = old["__index"]

        local new = {
            ["__index"] = newcclosure(LPH_JIT_MAX(function(self, index)
                local position = ragebot_aim_position or silent_aim_position
                if not checkcaller() and self and (index == "Hit" or index == "hit") and position then
                    if ((position == silent_aim_position and flags["silent_aim"]) and (math_random(1,100) > silent_aim_redirect_chance or flags["anti_aim_viewer"])) or ragebot_aim_position then
                        return cframe_new(position)
                    end
                end
                return old_index(self, index)
            end))
        }

        for _, v in old do
            if not new[_] then
                new[_] = v
            end
        end

        setrawmetatable(mouse, new)
    end

    set_silent_aim_position = LPH_NO_VIRTUALIZE(function(position)
        local type = typeof(position)

        if type ~= "Vector3" then
            error("juju: set_silent_aim_position expected Vector3 got"..type)
            return
        end

        custom_silent_aim_position = position
        spawn(function()
            if custom_silent_aim_position == position then
                custom_silent_aim_position = nil
            end
        end)
    end)

    get_silent_aim_position = LPH_NO_VIRTUALIZE(function()
        return custom_silent_aim_position or silent_aim_position
    end)

    -- >> ( ui )

    menu_references["legitbot_settings_section"] = menu["groups"]["main"]:create_section("legitbot", "settings", 1, 0.54)
        menu_references["legitbot_target_selection_settings"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "settings"}, {})
        menu_references["legitbot_target_selection_settings"] = menu_references["legitbot_target_selection_settings"]:create_settings()
        menu_references["legitbot_target_selection_target_switch_cooldown"] = menu_references["legitbot_target_selection_settings"]:create_element({["name"] = "target swap cooldown"}, {["slider"] = {["flag"] = "legitbot_target_selection_target_switch_cooldown", ["min"] = 0, ["max"] = 2, ["suffix"] = "s", ["min_text"] = "none", ["default"] = 0, ["decimals"] = 2}})
        menu_references["legitbot_target_selection_max_target_distance"] = menu_references["legitbot_target_selection_settings"]:create_element({["name"] = "target distance"}, {["slider"] = {["flag"] = "legitbot_target_selection_max_target_distance", ["min"] = 0, ["max"] = 2500, ["suffix"] = " studs", ["default"] = 0, ["min_text"] = "gun range", ["max_text"] = "infinite"}})
        menu_references["legitbot_target_selection_notification"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "notification"}, {["toggle"] = {["flag"] = "legitbot_target_selection_notification", ["default"] = false}})
        menu_references["legitbot_target_selection_automatic"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "automatic"}, {["toggle"] = {["flag"] = "legitbot_target_selection_automatic", ["default"] = false}})
        menu_references["legitbot_target_selection_target_bind"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "target bind"}, {["keybind"] = {["flag"] = "legitbot_target_selection_target_bind", ["default"] = Enum["KeyCode"]["E"]}})
        menu_references["legitbot_target_selection_untarget_when"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "untarget when"}, {["dropdown"] = {["flag"] = "legitbot_target_selection_untarget_when", ["default"] = {"not visible"}, ["options"] = {"better target", "not visible", "off screen"}, ["multi"] = true}})
        menu_references["legitbot_target_statuses"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "target statuses"}, {["dropdown"] = {["flag"] = "legitbot_target_statuses", ["options"] = {"whitelisted", "normal", "target"}, ["default"] = {"normal", "target"}, ["multi"] = true, ["requires_one"] = true}})
        menu_references["legitbot_target_selection_ignore_if"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "ignore if"}, {["dropdown"] = {["flag"] = "ignore_if", ["options"] = {"invulnerable", "not visible"}, ["default"] = {"invulnerable", "not visible"}, ["multi"] = true}})
        menu_references["legitbot_field_of_view"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "field of view"}, {["slider"] = {["flag"] = "legitbot_field_of_view", ["min"] = 0, ["max"] = 180, ["default"] = 180, ["suffix"] = "°", ["max_text"] = "full"}})

        if do_prediction then
            menu_references["legitbot_prediction"] = menu_references["legitbot_settings_section"]:create_element({["name"] = "prediction"}, {["slider"] = {["flag"] = "legitbot_prediction", ["min"] = 0, ["max"] = 0.5, ["default"] = 0, ["min_text"] = "auto", ["max_text"] = "disabled", ["suffix"] = "x", ["decimals"] = 2}})
            menu_references["legitbot_prediction_settings"] = menu_references["legitbot_prediction"]:create_settings()
            menu_references["legitbot_resolver_rate"] = menu_references["legitbot_prediction_settings"]:create_element({["name"] = "resolver rate"}, {["slider"] = {["flag"] = "legitbot_resolver_rate", ["min"] = 0, ["suffix"] = "s", ["max"] = 0.1, ["default"] = 0.0205, ["min_text"] = do_prediction and "disabled" or nil, ["decimals"] = 4}})
            menu_references["legitbot_jump_prediction"] = menu_references["legitbot_prediction_settings"]:create_element({["name"] = "jump prediction"}, {["toggle"] = {["flag"] = "legitbot_jump_prediction"}})
        end

    menu_references["aim_assist_section"] = menu["groups"]["main"]:create_section("legitbot", "assistance", 1, 0.45, 0.55)
        menu_references["aim_assist"] = menu_references["aim_assist_section"]:create_element({["name"] = "aim assist"}, {["toggle"] = {["flag"] = "aim_assist"}})
        menu_references["aim_assist_settings"] = menu_references["aim_assist"]:create_settings()
        menu_references["aim_assist_method"] = menu_references["aim_assist_settings"]:create_element({["name"] = "method"}, {["dropdown"] = {["flag"] = "aim_assist_method", ["options"] = {"camera", "mouse"}, ["default"] = {"mouse"}, ["requires_one"] = true}})
        menu_references["aim_assist_max_distance"] = menu_references["aim_assist_settings"]:create_element({["name"] = "max distance"}, {["slider"] = {["flag"] = "aim_assist_max_distance", ["min"] = 0, ["max"] = 2500, ["default"] = 0, ["suffix"] = " studs", ["min_text"] = "gun range", ["max_text"] = "infinite"}})

        menu_references["aim_assist_smoothing"] = menu_references["aim_assist_section"]:create_element({["name"] = "smoothing"}, {["toggle"] = {["flag"] = "aim_assist_smoothing"}})
        menu_references["aim_assist_smoothing_settings"] = menu_references["aim_assist_smoothing"]:create_settings()
        menu_references["aim_assist_smoothing_type"] = menu_references["aim_assist_smoothing_settings"]:create_element({["name"] = "type"}, {["dropdown"] = {["flag"] = "aim_assist_smoothing_type", ["options"] = {"exponential", "constant", "random", "quart", "quad", "back", "sine"}, ["default"] = {"random"}, ["multi"] = false, ["requires_one"] = true}})
        menu_references["aim_assist_horizontal_smoothing_amount"] = menu_references["aim_assist_smoothing_settings"]:create_element({["name"] = "horizontal"}, {["slider"] = {["flag"] = "aim_assist_horizontal_smoothing_amount", ["min"] = 0, ["max"] = 100, ["default"] = 45, ["suffix"] = "%"}})
        menu_references["aim_assist_vertical_smoothing_amount"] = menu_references["aim_assist_smoothing_settings"]:create_element({["name"] = "vertical"}, {["slider"] = {["flag"] = "aim_assist_vertical_smoothing_amount", ["min"] = 0, ["max"] = 100, ["default"] = 45, ["suffix"] = "%"}})
        menu_references["aim_assist_dont_aim_if"] = menu_references["aim_assist_section"]:create_element({["name"] = "dont aim if"}, {["dropdown"] = {["flag"] = "aim_assist_dont_aim_if", ["options"] = {"no gun equipped", "reloading"}, ["default"] = {"no gun equipped", "reloading"}, ["multi"] = true}})
        menu_references["aim_assist_hitbox"] = menu_references["aim_assist_section"]:create_element({["name"] = "hitbox"}, {["dropdown"] = {["flag"] = "aim_assist_hitbox", ["options"] = {"random", "closest", "head", "root"}, ["default"] = {"head"}, ["multi"] = false, ["requires_one"] = true}})
        menu_references["aim_assist_multipoint"] = menu_references["aim_assist_section"]:create_element({["name"] = "multipoint"}, {["slider"] = {["flag"] = "aim_assist_multipoint", ["min"] = 0, ["max"] = 100, ["default"] = 90, ["suffix"] = "%"}})
        menu_references["aim_assist_field_of_view"] = menu_references["aim_assist_section"]:create_element({["name"] = "field of view"}, {["slider"] = {["flag"] = "aim_assist_field_of_view", ["min"] = 0, ["max"] = 180, ["default"] = 30, ["suffix"] = "°", ["decimals"] = 1}})

        menu_references["aim_assist_field_of_view_settings"] = menu_references["aim_assist_field_of_view"]:create_settings()
        menu_references["aim_assist_dead_zone"] = menu_references["aim_assist_field_of_view_settings"]:create_element({["name"] = "dead zone"}, {["slider"] = {["flag"] = "aim_assist_dead_zone", ["min"] = 0, ["max"] = 90, ["default"] = 0, ["suffix"] = "%", ["min_text"] = "disabled"}})
        menu_references["aim_assist_field_of_view_show_fov"] = menu_references["aim_assist_field_of_view_settings"]:create_element({["name"] = "show fov"}, {["toggle"] = {["flag"] = "aim_assist_field_of_view_show_fov"}, ["colorpicker"] = {["color_flag"] = "aim_assist_field_of_view_color", ["default_color"] = color3_fromrgb(181, 255, 246), ["default_transparency"] = 0.8, ["transparency_flag"] = "aim_assist_field_of_view_transparency"}})
        menu_references["aim_assist_field_of_view_dead_zone"] = menu_references["aim_assist_field_of_view_settings"]:create_element({["name"] = "dead zone"}, {["colorpicker"] = {["color_flag"] = "aim_assist_field_of_view_dead_zone_color", ["default_color"] = color3_fromrgb(155, 0, 0), ["default_transparency"] = 0.8, ["transparency_flag"] = "aim_assist_field_of_view_dead_zone_transparency"}})
        menu_references["aim_assist_field_of_view_outline"] = menu_references["aim_assist_field_of_view_settings"]:create_element({["name"] = "outline"}, {["colorpicker"] = {["color_flag"] = "aim_assist_field_of_view_outline_color", ["default_color"] = color3_fromrgb(181, 255, 246), ["default_transparency"] = 0.4, ["transparency_flag"] = "aim_assist_field_of_view_outline_transparency"}})

    menu_references["silent_aim_section"] = menu["groups"]["main"]:create_section("legitbot", "redirection", 2, 0.45, 0.0)
        menu_references["silent_aim"] = menu_references["silent_aim_section"]:create_element({["name"] = "silent aim"}, {["toggle"] = {["flag"] = "silent_aim"}})
        menu_references["silent_aim_settings"] = menu_references["silent_aim"]:create_settings()

        if do_prediction then
            menu_references["anti_aim_viewer"] = menu_references["silent_aim_settings"]:create_element({["name"] = "anti aim viewer"}, {["toggle"] = {["flag"] = "anti_aim_viewer"}})
        end
        menu_references["silent_aim_no_tool_check"] = menu_references["silent_aim_settings"]:create_element({["name"] = "no tool check"}, {["toggle"] = {["flag"] = "silent_aim_no_tool_check"}})

        menu_references["silent_aim_max_distance"] = menu_references["silent_aim_settings"]:create_element({["name"] = "max distance"}, {["slider"] = {["flag"] = "silent_aim_max_distance", ["min"] = 0, ["max"] = 2500, ["default"] = 0, ["suffix"] = " studs", ["min_text"] = "gun range", ["max_text"] = "infinite"}})
        menu_references["silent_aim_hitbox"] = menu_references["silent_aim_section"]:create_element({["name"] = "hitbox"}, {["dropdown"] = {["flag"] = "silent_aim_hitbox", ["options"] = {"random", "closest", "head", "root"}, ["default"] = {"head"}, ["multi"] = false, ["requires_one"] = true}})
        menu_references["silent_aim_multipoint"] = menu_references["silent_aim_section"]:create_element({["name"] = "multipoint"}, {["slider"] = {["flag"] = "silent_aim_multipoint", ["min"] = 0, ["max"] = 100, ["default"] = 90, ["suffix"] = "%"}})
        menu_references["silent_aim_field_of_view"] = menu_references["silent_aim_section"]:create_element({["name"] = "field of view"}, {["slider"] = {["flag"] = "silent_aim_field_of_view", ["min"] = 0, ["max"] = 180, ["default"] = 30, ["suffix"] = "°", ["decimals"] = 1}})
        menu_references["silent_aim_redirect_chance"] = menu_references["silent_aim_section"]:create_element({["name"] = "redirect chance"}, {["slider"] = {["flag"] = "silent_aim_redirect_chance", ["min"] = 1, ["max"] = 100, ["default"] = 100, ["suffix"] = "%"}})
        menu_references["silent_aim_field_of_view_settings"] = menu_references["silent_aim_field_of_view"]:create_settings()
        menu_references["silent_aim_field_of_view_show_fov"] = menu_references["silent_aim_field_of_view_settings"]:create_element({["name"] = "show fov"}, {["toggle"] = {["flag"] = "silent_aim_field_of_view_show_fov"}, ["colorpicker"] = {["color_flag"] = "silent_aim_field_of_view_color", ["default_color"] = color3_fromrgb(181, 255, 246), ["default_transparency"] = 0.8, ["transparency_flag"] = "silent_aim_field_of_view_transparency"}})
        menu_references["silent_aim_field_of_view_outline"] = menu_references["silent_aim_field_of_view_settings"]:create_element({["name"] = "outline"}, {["colorpicker"] = {["color_flag"] = "silent_aim_field_of_view_outline_color", ["default_color"] = color3_fromrgb(181, 255, 246), ["default_transparency"] = 0.4, ["transparency_flag"] = "silent_aim_field_of_view_outline_transparency"}})
        menu_references["silent_aim_max_curve"] = menu_references["silent_aim_section"]:create_element({["name"] = "max curve"}, {["slider"] = {["flag"] = "silent_aim_max_curve", ["min"] = 1, ["max"] = 100, ["default"] = 100, ["suffix"] = "%"}})
        menu_references["silent_aim_max_curve_settings"] = menu_references["silent_aim_max_curve"]:create_settings()
        menu_references["silent_aim_dont_curve_vertically"] = menu_references["silent_aim_max_curve_settings"]:create_element({["name"] = "dont curve vertically"}, {["toggle"] = {["flag"] = "silent_aim_dont_curve_vertically"}})
    menu_references["triggerbot_section"] = menu["groups"]["main"]:create_section("legitbot", "trigger", 2, 0.55, 0.45)
        menu_references["triggerbot"] = menu_references["triggerbot_section"]:create_element({["name"] = "triggerbot"}, {["toggle"] = {["flag"] = "triggerbot"}})
        menu_references["triggerbot_settings"] = menu_references["triggerbot"]:create_settings()
        menu_references["triggerbot_no_tool_check"] = menu_references["triggerbot_settings"]:create_element({["name"] = "no tool check"}, {["toggle"] = {["flag"] = "triggerbot_no_tool_check"}})
        menu_references["triggerbot_max_distance"] = menu_references["triggerbot_settings"]:create_element({["name"] = "max distance"}, {["slider"] = {["flag"] = "triggerbot_max_distance", ["min"] = 0, ["max"] = 2500, ["default"] = 0, ["suffix"] = " studs", ["min_text"] = "gun range", ["max_text"] = "infinite"}})
        menu_references["triggerbot_hitboxes"] = menu_references["triggerbot_section"]:create_element({["name"] = do_prediction and "hitbox" or "hitboxes"}, {["dropdown"] = {["flag"] = "triggerbot_hitboxes", ["options"] = do_prediction and {"closest", "head", "torso"} or {"head", "torso", "arms", "legs"}, ["default"] = do_prediction and {"closest"} or {"head", "torso", "arms", "legs"}, ["multi"] = not do_prediction, ["requires_one"] = true}})
        menu_references["triggerbot_refresh_rate"] = menu_references["triggerbot_section"]:create_element({["name"] = "refresh rate"}, {["slider"] = {["flag"] = "triggerbot_refresh_rate", ["min"] = 0, ["max"] = 0.1, ["default"] = 0, ["decimals"] = 2, ["suffix"] = "s", ["min_text"] = "instant"}})
        menu_references["triggerbot_hover_time"] = menu_references["triggerbot_section"]:create_element({["name"] = "hover time"}, {["slider"] = {["flag"] = "triggerbot_hover_time", ["min"] = 0, ["max"] = 0.3, ["default"] = 0, ["decimals"] = 2, ["suffix"] = "s", ["min_text"] = "instant"}})
        menu_references["triggerbot_cooldown"] = menu_references["triggerbot_section"]:create_element({["name"] = "cooldown"}, {["slider"] = {["flag"] = "triggerbot_cooldown", ["min"] = 0, ["max"] = 1, ["default"] = 0, ["decimals"] = 2, ["suffix"] = "s", ["min_text"] = "none"}})
        if do_prediction then
            menu_references["triggerbot_radius"] = menu_references["triggerbot_section"]:create_element({["name"] = "radius"}, {["slider"] = {["flag"] = "triggerbot_radius", ["min"] = 1, ["max"] = 200, ["default"] = 30, ["decimals"] = 1, ["suffix"] = "%"}})
            menu_references["triggerbot_radius_settings"] = menu_references["triggerbot_radius"]:create_settings()
            menu_references["triggerbot_show_radius"] = menu_references["triggerbot_radius_settings"]:create_element({["name"] = "show radius"}, {["toggle"] = {["flag"] = "triggerbot_show_radius"}, ["colorpicker"] = {["color_flag"] = "triggerbot_show_radius_color", ["default_color"] = color3_fromrgb(181, 255, 246), ["default_transparency"] = 0.8, ["transparency_flag"] = "triggerbot_show_radius_transparency"}})
            menu_references["triggerbot_show_radius_outline"] = menu_references["triggerbot_radius_settings"]:create_element({["name"] = "outline color"}, {["colorpicker"] = {["color_flag"] = "triggerbot_show_radius_outline_color", ["default_color"] = color3_fromrgb(181, 255, 246), ["default_transparency"] = 0.3, ["transparency_flag"] = "triggerbot_show_radius_outline_transparency"}})
        end
        menu_references["triggerbot_delay"] = menu_references["triggerbot_section"]:create_element({["name"] = "delay"}, {["slider"] = {["flag"] = "triggerbot_delay", ["min"] = 0, ["max"] = 0.75, ["default"] = 0, ["decimals"] = 2, ["suffix"] = "s", ["min_text"] = "instant"}})

    -- >> ( legitbot master )

    local gravity = workspace["Gravity"]

    local legitbot_ignore_if_invulnerable = true
    local legitbot_ignore_if_not_visible = true
    local legitbot_untarget_when_better_target = false
    local legitbot_untarget_when_off_screen = false

    local legitbot_max_distance = 0
    local legitbot_untarget_when_not_visible = true
    local target_switch_cooldown = 0
    local legitbot_automatic = false
    local legitbot_dont_aim = false
    local do_notification = false

    local target_target = true
    local target_normal = true
    local target_whitelisted = false
    local last_target_dt = clock()
    local last_switch = clock()

    local legitbot_prediction = 0
    local legitbot_resolver_rate = 0.0265

    local legitbot_jump_prediction = true
    local legitbot_last_velocity_update = clock()

    local legitbot_target_velocity = vector3_new()
    local legitbot_last_position = nil
    local legitbot_target_prediction = vector3_new()

    local target_changed_signal = signals["on_legitbot_target_changed"]

    set_legitbot_target = LPH_NO_VIRTUALIZE(function(target, automatic)
        if legitbot_target == target then
            return
        end

        if not automatic or (target == nil or clock() - last_switch > target_switch_cooldown) then
            last_switch = clock()

            if do_notification then
                new_notification("set legitbot target to "..(target and target[1][2]["Name"] or "nobody"), 1)
            end

            legitbot_last_velocity_update = clock()
            legitbot_last_position = nil
            legitbot_target = target
            legitbot_target_prediction = vector3_zero
            target_changed_signal:Fire(target and target[1] or nil)
        end
    end)

    local legitbot_field_of_view = false

    local get_legitbot_target = nil; get_legitbot_target = LPH_NO_VIRTUALIZE(function(dt, getting, bypass)
        local camera_pos = camera["CFrame"]["p"]
        local mouse_pos = get_mouse_location(user_input_service)

        if not bypass then
            legitbot_dont_aim = false

            if legitbot_target then
                local data = legitbot_target[1]

                if data then
                    local parts = data[4]
                    local hrp = parts["HumanoidRootPart"]
                    local hrp_position = hrp["Position"]

                    if legitbot_untarget_when_not_visible then
                        local distance = hrp_position-camera_pos
                        local instances = {data[3], local_character}
                        for i = 1, #ignored do
                            instances[#instances + 1] = ignored[i]
                        end

                        params["FilterDescendantsInstances"] = instances

                        if raycast(workspace, camera_pos, distance.unit * distance.Magnitude, params) then
                            set_legitbot_target(legitbot_automatic and get_legitbot_target(dt, true, true) or nil)
                            return
                        end
                    end

                    if legitbot_untarget_when_better_target then
                        local target = get_legitbot_target(dt, hrp, true)
                        if target and target[1] ~= data then
                            set_legitbot_target(legitbot_automatic and get_legitbot_target(dt, true, true) or nil, true)
                            return
                        end
                    end

                    if legitbot_max_distance == 2500 or (hrp_position-local_client_position["p"])["Magnitude"] < (legitbot_max_distance == 0 and (local_gun or 250) or legitbot_max_distance) then
                        local position, on_screen = world_to_viewport_point(camera, hrp_position)

                        if legitbot_untarget_when_off_screen and not on_screen then
                            set_legitbot_target(legitbot_automatic and get_legitbot_target(dt, true, true) or nil)
                            return
                        end

                        if legitbot_ignore_if_invulnerable and ((parts["FORCEFIELD"] or parts["ForceField"]) or parts["GRABBING_CONSTRAINT"]) then
                            legitbot_dont_aim = true
                            return
                        end

                        if legitbot_ignore_if_not_visible then
                            local distance = hrp_position-camera_pos
                            local instances = {data[3], local_character}
                            for i = 1, #ignored do
                                instances[#instances + 1] = ignored[i]
                            end

                            params["FilterDescendantsInstances"] = instances

                            if raycast(workspace, camera_pos, distance.unit * distance.Magnitude, params) then
                                legitbot_dont_aim = true
                                return
                            end
                        end

                        legitbot_target = {data, hrp, (vector2_new(position["X"], position["Y"]) - mouse_pos)["Magnitude"]}
                        legitbot_dont_aim = false

                        if do_prediction then
                            if not legitbot_last_position then
                                legitbot_last_position = hrp_position
                                legitbot_target_velocity = vector3_zero
                            elseif clock() - legitbot_last_velocity_update > legitbot_resolver_rate then
                                legitbot_last_velocity_update = clock()
                                legitbot_target_velocity = (hrp_position - legitbot_last_position) / legitbot_resolver_rate
                                legitbot_last_position = hrp_position
                            end

                            legitbot_target_prediction = legitbot_target_velocity * (legitbot_prediction == 0 and local_ping/1000 or legitbot_prediction == 0.5 and 0)

                            if legitbot_jump_prediction then
                                local y_velocity = legitbot_target_velocity["Y"]

                                if abs(y_velocity) < 80 then
                                    local ping = local_ping/1000
                                    legitbot_target_prediction = vector3_new(legitbot_target_prediction["X"], (y_velocity * ping) - (0.5 * gravity * (ping ^ 2)), legitbot_target_prediction["Z"])
                                end
                            end
                        end

                        return legitbot_target
                    end
                end
            end

            if not legitbot_automatic then
                return
            end
        end

        last_target_dt = dt
        local targets = {}

        local local_client_position = local_client_position["p"]
        local mouse_position = get_mouse_location(user_input_service)
        
        local field_of_view = legitbot_field_of_view and (camera["ViewportSize"]["Magnitude"]/(pi/2))*legitbot_field_of_view or false
        for player, data in player_data do
            if not data[7] and not data[18] then
                local status = data[1]

                if status == 3 and target_target or status == 2 and target_whitelisted or status == 1 and target_normal then
                    local parts = data[4]
                    local hrp = parts["HumanoidRootPart"]

                    if hrp then
                        local hrp_position = hrp["Position"]
                        local position, on_screen = world_to_viewport_point(camera, hrp_position)

                        if legitbot_max_distance == 2500 or on_screen and (hrp_position-local_client_position)["Magnitude"] < (legitbot_max_distance == 0 and (local_gun or 250) or legitbot_max_distance) then
                            if legitbot_ignore_if_invulnerable and ((parts["FORCEFIELD"] or parts["ForceField"])) then
                                continue
                            end
                            local distance = (vector2_new(position["X"], position["Y"]) - mouse_pos)["Magnitude"]

                            if field_of_view and distance > field_of_view then
                                continue
                            end
                            if legitbot_ignore_if_not_visible then
                                local distance = hrp_position-camera_pos

                                local instances = {data[3], local_character}
                                for i = 1, #ignored do
                                    instances[#instances + 1] = ignored[i]
                                end

                                params["FilterDescendantsInstances"] = instances
                                if raycast(workspace, camera_pos, distance.unit * distance.Magnitude, params) then
                                    continue
                                end
                            end

                            targets[#targets+1] = {data, hrp, (vector2_new(position["X"], position["Y"]) - mouse_pos)["Magnitude"]}
                        end
                    end
                end
            end
        end

        local closest = math["huge"]
        local best = nil
        for i = 1, #targets do
            local target = targets[i]
            local distance = target[3]
            if distance < closest then
                closest = distance
                best = target
            end
        end

        if getting then
            return best
        end

        set_legitbot_target(best, true)

        return best
    end)

    local get_closest_part = LPH_NO_VIRTUALIZE(function(data)
        local mouse_pos = get_mouse_location(user_input_service)

        local parts = data[4]
        local closest = math["huge"]
        local closest_part = nil

        for i = 1, #body_parts do
            local part = body_parts[i]
            local body_part = parts[part]
            if body_part then
                local pos, on_screen = world_to_viewport_point(camera, body_part["Position"])
                if on_screen then
                    local distance = (mouse_pos - vector2_new(pos["X"], pos["Y"])).Magnitude
                    if distance < closest then
                        closest = distance
                        closest_part = part
                    end
                end
            end
        end

        return closest_part or ""
    end)

    create_connection(menu_references["legitbot_target_selection_automatic"]["on_toggle_change"], function(value)
        legitbot_dont_aim = false
        legitbot_automatic = value
        menu_references["legitbot_target_selection_target_bind"]:set_visible(not value)
    end)

    create_connection(menu_references["legitbot_target_selection_automatic"]["on_toggle_change"], function(value)
        legitbot_dont_aim = false
        legitbot_automatic = value
        menu_references["legitbot_target_selection_target_bind"]:set_visible(not value)
    end)

    if do_prediction then
        create_connection(menu_references["legitbot_prediction"]["on_slider_change"], function(value)
            legitbot_prediction = value
        end)

        create_connection(menu_references["legitbot_resolver_rate"]["on_slider_change"], function(value)
            legitbot_resolver_rate = value
        end)
    end

    create_connection(menu_references["legitbot_target_selection_target_bind"]["on_key_press"], function(value)
        if not legitbot_automatic and (flags["aim_assist"] or flags["triggerbot"] or flags["silent_aim"]) then
            if legitbot_target then
                set_legitbot_target(nil)
            else
                set_legitbot_target(get_legitbot_target(clock(), true, true))
            end
        end
    end)

    create_connection(menu_references["legitbot_target_selection_ignore_if"]["on_dropdown_change"], function(value)
        legitbot_ignore_if_invulnerable = false
        legitbot_ignore_if_not_visible = false

        for i = 1, #value do
            local value = value[i]
            if value == "invulnerable" then
                legitbot_ignore_if_invulnerable = true
            elseif value == "not visible" then
                legitbot_ignore_if_not_visible = true
            end
        end
    end)

    create_connection(menu_references["legitbot_target_selection_target_switch_cooldown"]["on_slider_change"], function(value)
        target_switch_cooldown = value
    end)

    create_connection(menu_references["legitbot_target_selection_max_target_distance"]["on_slider_change"], function(value)
        legitbot_max_distance = value
    end)

    create_connection(menu_references["legitbot_target_selection_untarget_when"]["on_dropdown_change"], function(value)
        legitbot_untarget_when_better_target = false
        legitbot_untarget_when_not_visible = false
        legitbot_untarget_when_off_screen = false

        for i = 1, #value do
            local value = value[i]
            if value == "not visible" then
                legitbot_untarget_when_not_visible = true
            elseif value == "better target" then
                legitbot_untarget_when_better_target = true
            elseif value == "off screen" then
                legitbot_untarget_when_off_screen = true
            end
        end
    end)

    create_connection(menu_references["legitbot_target_selection_notification"]["on_toggle_change"], function(value)
        do_notification = value
    end)

    create_connection(menu_references["legitbot_field_of_view"]["on_slider_change"], function(value)
        legitbot_field_of_view = value ~= 180 and value/180 or false
    end)

    -- >> ( aim assist )

    local fov_circle = nil
    local fov_circle_outline = nil
    local fov_circle_dead_zone = nil

    local aim_assist_field_of_view = (camera["ViewportSize"]["Magnitude"]/(pi/2))*(flags["aim_assist_field_of_view"]/180)
    local aim_assist_dead_zone = 0
    local aim_assist_vertical_smoothing = 6
    local aim_assist_horizontal_smoothing = 6
    local aim_assist_multipoint = 0.15
    local aim_assist_hitbox = "Head"
    local aim_assist_smoothing_type = "random"
    local aim_assist_dont_aim_if_no_gun_equipped = true
    local aim_assist_dont_aim_if_reloading = true
    local aim_assist_max_distance = 0
    local aim_assist_method = "mouse"
    local custom_aim_assist_position = nil

    local do_aim_assist = LPH_JIT_MAX(function(dt, local_hrp)
        local mouse_position = get_mouse_location(user_input_service)

        if fov_circle then
            local old_position = fov_circle["Position"]
            local new_position = old_position + (mouse_position - old_position) * dt*4^2

            fov_circle["Position"] = new_position
            fov_circle_outline["Position"] = new_position
            fov_circle_dead_zone["Position"] = new_position
        end

        if dt ~= last_target_dt and flags["aim_assist"] then
            get_legitbot_target(dt)
        end

        if legitbot_target and local_hrp then
            local distance = legitbot_target[3]
            if distance < aim_assist_field_of_view and distance >= aim_assist_dead_zone and not legitbot_dont_aim then
                local data = legitbot_target[1]
                local part = data[4][aim_assist_hitbox == "closest" and get_closest_part(data) or aim_assist_hitbox]

                if part and not data[18] and not data[7] and (not aim_assist_dont_aim_if_no_gun_equipped or local_gun ~= nil) and (not aim_assist_dont_aim_if_reloading or not local_reloading) then
                    local part_position = custom_aim_assist_position or part["Position"]

                    if aim_assist_max_distance == 2500 or (local_hrp["Position"]-part_position)["Magnitude"] <= (aim_assist_max_distance == 0 and (local_gun or 250) or aim_assist_max_distance) then
                        if aim_assist_multipoint ~= 0 and not custom_aim_assist_position then
                            local part_cframe = part["CFrame"]
                            local cf = part_cframe:PointToObjectSpace(mouse["Hit"]["p"])
                            local size = part["Size"]*aim_assist_multipoint

                            part_cframe*=vector3_new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
                            part_position = vector3_new(part_cframe.X, part_cframe.Y, part_cframe.Z)
                        end

                        part_position+=legitbot_target_prediction

                        local pos, _ = world_to_viewport_point(camera, part_position)
                        local move_position = vector2_new(pos["X"] - mouse_position["X"], pos["Y"] - mouse_position["Y"])

                        if move_position["magnitude"] > 1 then 
                            local aim_assist_horizontal_multiplier = nil
                            local aim_assist_vertical_multiplier = nil

                            if aim_assist_horizontal_smoothing == 0 then
                                aim_assist_horizontal_multiplier = 0.9999
                            elseif aim_assist_smoothing_type == "random" then
                                aim_assist_horizontal_multiplier=((dt*100)/(math_random(floor(aim_assist_horizontal_smoothing*450), floor(aim_assist_horizontal_smoothing*1100))/1000))
                            elseif aim_assist_smoothing_type == "constant" then
                                aim_assist_horizontal_multiplier=((dt*100)/aim_assist_horizontal_smoothing)
                            else
                                aim_assist_horizontal_multiplier=((dt*100)/(aim_assist_horizontal_smoothing*get_value(tween_service, move_position["Magnitude"]/aim_assist_field_of_view, aim_assist_smoothing_type, out)))
                            end

                            if aim_assist_vertical_smoothing == 0 then
                                aim_assist_vertical_multiplier = 0.9999
                            elseif aim_assist_smoothing_type == "random" then
                                aim_assist_vertical_multiplier=((dt*100)/(math_random(floor(aim_assist_vertical_smoothing*450), floor(aim_assist_vertical_smoothing*1100))/1000))
                            elseif aim_assist_smoothing_type == "constant" then
                                aim_assist_vertical_multiplier=((dt*100)/aim_assist_vertical_smoothing)
                            else
                                aim_assist_vertical_multiplier=((dt*100)/(aim_assist_vertical_smoothing*get_value(tween_service, move_position["Magnitude"]/aim_assist_field_of_view, aim_assist_smoothing_type, out)))
                            end

                            if aim_assist_method == "mouse" then
                                mousemoverel(move_position["X"]*aim_assist_horizontal_multiplier, move_position["Y"]*aim_assist_vertical_multiplier)
                            elseif camera then
                                render_stepped_wait(render_stepped)
                                local old = camera["CFrame"]
                                camera["CFrame"] = old:Lerp(cframe_new(old["p"], vector3_new(part_position["X"], old["Y"], part_position["Z"])), clamp(aim_assist_horizontal_multiplier/9, 0, 1)):Lerp(cframe_new(old["p"], part_position), clamp(aim_assist_vertical_multiplier/9, 0, 1))
                            end
                        end
                    end
                end
            end
        end

        custom_aim_assist_position = nil
    end)

    local update_aim_assist_field_of_view = function()
        aim_assist_field_of_view = (camera["ViewportSize"]["Magnitude"]/(pi/2))*(flags["aim_assist_field_of_view"]/180)
        aim_assist_dead_zone = aim_assist_field_of_view*(flags["aim_assist_dead_zone"]/100)

        if fov_circle_outline then
            fov_circle_outline["Radius"] = aim_assist_field_of_view
        end

        if fov_circle_dead_zone then
            fov_circle_dead_zone["Radius"] = aim_assist_dead_zone
        end

        if fov_circle then
            fov_circle["Radius"] = aim_assist_field_of_view
        end
    end

    local aim_assist_camera_connection = nil

    create_connection(menu_references["aim_assist"]["on_toggle_change"], function(value)
        last_target_dt = nil

        if not value and not flags["triggerbot"] and not flags["silent_aim"] then
            delay(0.01, function()
                set_legitbot_target(nil)
                last_target_dt = nil
                silent_aim_position = nil
            end)
        end

        if not value then
            delay(0.15, function()
                for i = 1, #heartbeat do
                    if heartbeat[i] == do_aim_assist then
                        remove(heartbeat, i)
                        break
                    end
                end
            end)
        else
            for i = 1, #heartbeat do
                if heartbeat[i] == do_aim_assist then
                    remove(heartbeat, i)
                    break
                end
            end
        end

        if aim_assist_camera_connection then
            aim_assist_camera_connection:Disconnect()
            aim_assist_camera_connection = nil
        end

        if value then
            spawn(function()
                if fov_circle then
                    tween(fov_circle, {["Transparency"] = -flags["aim_assist_field_of_view_transparency"]+1}, circular, out, 0.15)
                    tween(fov_circle_outline, {['Transparency'] = -flags["aim_assist_field_of_view_outline_transparency"]+1}, circular, out, 0.15)
                    tween(fov_circle_dead_zone, {['Transparency'] = -flags["aim_assist_field_of_view_dead_zone_transparency"]+1}, circular, out, 0.15)
                end
            end)
            heartbeat[#heartbeat+1] = do_aim_assist
            aim_assist_camera_connection = create_connection(camera:GetPropertyChangedSignal("ViewportSize"), update_aim_assist_field_of_view)
        else
            spawn(function()
                if fov_circle then
                    tween(fov_circle, hide_transparency, circular, out, 0.15)
                    tween(fov_circle_outline, hide_transparency, circular, out, 0.15)
                    tween(fov_circle_dead_zone, hide_transparency, circular, out, 0.15)
                end
            end)
        end
    end)

    create_connection(menu_references["aim_assist_hitbox"]["on_dropdown_change"], function(value)
        local value = value[1]
        aim_assist_hitbox = value == "head" and "Head" or value == "root" and "HumanoidRootPart" or "closest"
    end)

    create_connection(menu_references["aim_assist_method"]["on_dropdown_change"], function(value)
        aim_assist_method = value[1]
    end)

    create_connection(menu_references["aim_assist_max_distance"]["on_slider_change"], function(value)
        aim_assist_max_distance = value
    end)

    create_connection(menu_references["aim_assist_field_of_view_show_fov"]["on_toggle_change"], function(value)
        if fov_circle then
            fov_circle:Destroy()
            fov_circle = nil
        end

        if fov_circle_outline then
            fov_circle_outline:Destroy()
            fov_circle_outline = nil
        end

        if fov_circle_dead_zone then
            fov_circle_dead_zone:Destroy()
            fov_circle_dead_zone= nil
        end

        if value then
            fov_circle = create_real_drawing("Circle", {
                ["Radius"] = aim_assist_field_of_view,
                ["Color"] = flags["aim_assist_field_of_view_color"],
                ["Filled"] = true,
                ["Transparency"] = 0,
                ["Thickness"] = 1,
                ["Visible"] = true
            })
            fov_circle_outline = create_real_drawing("Circle", {
                ["Radius"] = aim_assist_field_of_view,
                ["Color"] = flags["aim_assist_field_of_view_outline_color"],
                ["Filled"] = false,
                ["Transparency"] = 0,
                ["Thickness"] = 2,
                ["Visible"] = true
            })
            fov_circle_dead_zone = create_real_drawing("Circle", {
                ["Radius"] = aim_assist_dead_zone,
                ["Color"] = flags["aim_assist_field_of_view_dead_zone_color"],
                ["Filled"] = false,
                ["Transparency"] = 0,
                ["Thickness"] = 2,
                ["Visible"] = true
            })
            if flags["aim_assist"] then
                spawn(tween, fov_circle, {["Transparency"] = -flags["aim_assist_field_of_view_transparency"]+1}, circular, out, 0.15)
                spawn(tween, fov_circle_outline, {['Transparency'] = -flags["aim_assist_field_of_view_outline_transparency"]+1}, circular, out, 0.15)
                spawn(tween, fov_circle_dead_zone, {['Transparency'] = -flags["aim_assist_field_of_view_dead_zone_transparency"]+1}, circular, out, 0.15)
            end
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view_show_fov"]["on_color_change"], function(value)
        if fov_circle then
            fov_circle["Color"] = value
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view_show_fov"]["on_transparency_change"], function(value)
        local transparency = 1-value
        if fov_circle and flags["aim_assist"] then
            tween(fov_circle, {["Transparency"] = transparency}, circular, out, 0)
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view_outline"]["on_color_change"], function(value)
        if fov_circle_outline then
            fov_circle_outline["Color"] = value
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view_outline"]["on_transparency_change"], function(value)
        local transparency = 1-value

        if fov_circle_outline and flags["aim_assist"] then
            tween(fov_circle_outline, {['Transparency'] = transparency}, circular, out, 0.15)
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view_dead_zone"]["on_color_change"], function(value)
        if fov_circle_dead_zone then
            fov_circle_dead_zone["Color"] = value
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view_dead_zone"]["on_transparency_change"], function(value)
        local transparency = 1-value
        if fov_circle_dead_zone and flags["aim_assist"] then
            tween(fov_circle_dead_zone, {['Transparency'] = transparency}, circular, out, 0.15)
        end
    end)

    create_connection(menu_references["aim_assist_field_of_view"]["on_slider_change"], update_aim_assist_field_of_view)
    create_connection(menu_references["aim_assist_dead_zone"]["on_slider_change"], update_aim_assist_field_of_view)

    create_connection(menu_references["aim_assist_smoothing"]["on_toggle_change"], function(value)
        aim_assist_vertical_smoothing = value and flags["aim_assist_vertical_smoothing_amount"]/5 or 0
        aim_assist_horizontal_smoothing = value and flags["aim_assist_horizontal_smoothing_amount"]/5 or 0
    end)

    create_connection(menu_references["aim_assist_multipoint"]["on_slider_change"], function(value)
        aim_assist_multipoint = value/200
    end)

    create_connection(menu_references["aim_assist_vertical_smoothing_amount"]["on_slider_change"], function(value)
        if flags["aim_assist_smoothing"] then
            aim_assist_vertical_smoothing = value/5
        end
    end)

    create_connection(menu_references["aim_assist_horizontal_smoothing_amount"]["on_slider_change"], function(value)
        if flags["aim_assist_smoothing"] then
            aim_assist_horizontal_smoothing = value/5
        end
    end)

    create_connection(menu_references["aim_assist_smoothing_type"]["on_dropdown_change"], function(value)
        local value = value[1]
        aim_assist_smoothing_type = value == "exponential" and Enum["EasingStyle"]["Exponential"] or value == "circular" and Enum["EasingStyle"]["Circular"] or value == "quad" and Enum["EasingStyle"]["Quad"] or value == "sine" and Enum["EasingStyle"]["Sine"] or value == "quart" and Enum["EasingStyle"]["Quart"] or value == "back" and Enum["EasingStyle"]["Back"] or value
    end)

    create_connection(menu_references["aim_assist_dont_aim_if"]["on_dropdown_change"], function(value)
        aim_assist_dont_aim_if_no_gun_equipped = false
        aim_assist_dont_aim_if_reloading = false

        for i = 1, #value do
            local value = value[i]
            if value == "no gun equipped" then
                aim_assist_dont_aim_if_no_gun_equipped = true
            elseif value == "reloading" then
                aim_assist_dont_aim_if_reloading = true
            end
        end
    end)

    set_aim_assist_position = LPH_NO_VIRTUALIZE(function(position)
        local type = typeof(position)

        if type ~= "Vector3" then
            error("juju: set_aim_assist_position arg #1 expected Vector3 got "..type)
            return
        end

        custom_aim_assist_position = position
        spawn(function()
            if custom_aim_assist_position == position then
                custom_aim_assist_position = nil
            end
        end)
    end)

    -- >> ( silent aim )

    local viewport_point_to_ray = camera["ViewportPointToRay"]

    local fov_circle = nil
    local fov_circle_outline = nil

    local silent_aim_max_distance = 0
    local silent_aim_field_of_view = (camera["ViewportSize"]["Magnitude"]/(pi/2))*(flags["silent_aim_field_of_view"]/180)
    local silent_aim_multipoint = 0.15
    local silent_aim_hitbox = "Head"
    local silent_aim_no_tool_check = false
    local silent_aim_max_curve = nil
    local silent_aim_dont_curve_vertically = false

    local do_silent_aim = LPH_JIT_MAX(function(dt, hrp)
        local mouse_position = get_mouse_location(user_input_service)

        if fov_circle then
            local old_position = fov_circle["Position"]
            local new_position = old_position + (mouse_position - old_position) * dt*4^2

            fov_circle["Position"] = new_position
            fov_circle_outline["Position"] = new_position
        end
        
        if dt ~= last_target_dt and flags["silent_aim"] then
            get_legitbot_target(dt)
        end

        if legitbot_target and legitbot_target[3] < silent_aim_field_of_view and not legitbot_dont_aim then
            local data = legitbot_target[1]
            local part = data[4][silent_aim_hitbox == "closest" and get_closest_part(data) or silent_aim_hitbox]

            if part and not data[18] and not data[7] then
                local part_position = custom_silent_aim_position or part["Position"]

                if (silent_aim_no_tool_check or local_gun) and (silent_aim_max_distance == 2500 or (hrp["Position"]-part_position)["Magnitude"] <= (silent_aim_max_distance == 0 and (local_gun or 250) or silent_aim_max_distance)) then
                    local part_cframe = part["CFrame"]

                    if silent_aim_multipoint ~= 0 and not custom_silent_aim_position then
                        local cf = part_cframe["PointToObjectSpace"](part_cframe, mouse["Hit"]["p"])
                        local size = part["Size"]*silent_aim_multipoint

                        part_cframe*=vector3_new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
                        part_position = vector3_new(part_cframe.X, part_cframe.Y, part_cframe.Z)
                    end
                
                    silent_aim_position = part_position + legitbot_target_prediction
                    custom_silent_aim_position = nil

                    if silent_aim_max_curve or silent_aim_dont_curve_vertically then
                        local pos = world_to_viewport_point(camera, silent_aim_position)
                        local world_position = mouse_position+((vector2_new(pos.X, pos.Y)-mouse_position)*(silent_aim_max_curve or 1))
                        local ray = viewport_point_to_ray(camera, world_position.X, silent_aim_dont_curve_vertically and mouse_position["Y"] or world_position["Y"])
                        silent_aim_position = ray["Origin"] + ray["Direction"] * (ray["Origin"]-part_position)["magnitude"]
                    end

                    return
                end
            end
        end

        silent_aim_position = nil
        custom_silent_aim_position = nil
    end)

    create_connection(menu_references["silent_aim"]["on_toggle_change"], function(value)
        last_target_dt = nil
        silent_aim_position = nil

        if not value and not flags["triggerbot"] and not flags["aim_assist"] then
            delay(0.01, function()
                set_legitbot_target(nil)
                last_target_dt = nil
                silent_aim_position = nil
            end)
        end

        if not value then
            delay(0.15, function()
                for i = 1, #heartbeat do
                    if heartbeat[i] == do_silent_aim then
                        remove(heartbeat, i)
                        break
                    end
                end
            end)
        else
            for i = 1, #heartbeat do
                if heartbeat[i] == do_silent_aim then
                    remove(heartbeat, i)
                    break
                end
            end
        end

        if value then
            if fov_circle then
                tween(fov_circle, {["Transparency"] = -flags["silent_aim_field_of_view_transparency"]+1}, circular, out, 0.15)
                tween(fov_circle_outline, {['Transparency'] = -flags["silent_aim_field_of_view_outline_transparency"]+1}, circular, out, 0.15)
            end
            heartbeat[#heartbeat+1] = do_silent_aim
        else
            if fov_circle then
                tween(fov_circle, hide_transparency, circular, out, 0.15)
                tween(fov_circle_outline, hide_transparency, circular, out, 0.15)
            end
        end
    end)

    create_connection(menu_references["silent_aim_max_curve"]["on_slider_change"], function(value)
        silent_aim_max_curve = value ~= 100 and value/100 or nil
    end)

    create_connection(menu_references["silent_aim_dont_curve_vertically"]["on_toggle_change"], function(value)
        silent_aim_dont_curve_vertically = value
    end)

    create_connection(menu_references["silent_aim_hitbox"]["on_dropdown_change"], function(value)
        local value = value[1]
        silent_aim_hitbox = value == "head" and "Head" or value == "root" and "HumanoidRootPart" or "closest"
    end)

    create_connection(menu_references["silent_aim_field_of_view_show_fov"]["on_toggle_change"], function(value)
        if fov_circle then
            fov_circle:Destroy()
            fov_circle = nil
        end

        if fov_circle_outline then
            fov_circle_outline:Destroy()
            fov_circle_outline = nil
        end

        if value then
            fov_circle = create_real_drawing("Circle", {
                ["Radius"] = silent_aim_field_of_view,
                ["Color"] = flags["silent_aim_field_of_view_color"],
                ["Filled"] = true,
                ["Transparency"] = 0,
                ["Thickness"] = 1,
                ["Visible"] = true
            })
            fov_circle_outline = create_real_drawing("Circle", {
                ["Radius"] = silent_aim_field_of_view,
                ["Color"] = flags["silent_aim_field_of_view_outline_color"],
                ["Filled"] = false,
                ["Transparency"] = 0,
                ["Thickness"] = 2,
                ["Visible"] = true
            })
            if flags["silent_aim"] then
                tween(fov_circle, {["Transparency"] = -flags["silent_aim_field_of_view_transparency"]+1}, circular, out, 0.15)
                tween(fov_circle_outline, {['Transparency'] = -flags["silent_aim_field_of_view_outline_transparency"]+1}, circular, out, 0.15)
            end
        end
    end)

    create_connection(menu_references["silent_aim_field_of_view_show_fov"]["on_color_change"], function(value)
        if fov_circle then
            fov_circle["Color"] = value
        end
    end)

    create_connection(menu_references["silent_aim_field_of_view_show_fov"]["on_transparency_change"], function(value)
        if fov_circle and flags["silent_aim"] then
            tween(fov_circle, {["Transparency"] = 1-value}, circular, out, 0)
        end
    end)

    create_connection(menu_references["silent_aim_field_of_view_outline"]["on_color_change"], function(value)
        if fov_circle_outline then
            fov_circle_outline["Color"] = value
        end
    end)

    create_connection(menu_references["silent_aim_field_of_view_outline"]["on_transparency_change"], function(value)
        if fov_circle_outline and flags["silent_aim"] then
            tween(fov_circle_outline, {["Transparency"] = 1-value}, circular, out, 0)
        end
    end)

    create_connection(menu_references["silent_aim_field_of_view"]["on_slider_change"], function(value)
        silent_aim_field_of_view = (camera["ViewportSize"]["Magnitude"]/(pi/2))*(value/180)

        if fov_circle_outline then
            fov_circle_outline["Radius"] = silent_aim_field_of_view
        end

        if fov_circle then
            fov_circle["Radius"] = silent_aim_field_of_view
        end
    end)

    create_connection(menu_references["silent_aim_multipoint"]["on_slider_change"], function(value)
        silent_aim_multipoint = value/200
    end)

    create_connection(menu_references["silent_aim_no_tool_check"]["on_toggle_change"], function(value)
        silent_aim_no_tool_check = value
    end)

    create_connection(menu_references["silent_aim_redirect_chance"]["on_slider_change"], function(value)
        silent_aim_redirect_chance = 100 - value
    end)

    create_connection(menu_references["silent_aim_max_distance"]["on_slider_change"], function(value)
        silent_aim_max_distance = value
    end)

    if game_data["prediction"] then
        local anti_aim_viewer_connection1 = nil
        local anti_aim_viewer_connection2 = nil
        local aav_event = game_data["aav_event"]

        local do_anti_aim_viewer = LPH_JIT_MAX(function(tool)
            if anti_aim_viewer_connection2 then
                anti_aim_viewer_connection2:Disconnect()
                anti_aim_viewer_connection2 = nil
            end

            if tool then
                anti_aim_viewer_connection2 = create_connection(tool["Activated"], function()
                    if silent_aim_position and math_random(1,100) > silent_aim_redirect_chance then
                        aav_event(silent_aim_position)
                    end
                end)
            end
        end)

        create_connection(menu_references["anti_aim_viewer"]["on_toggle_change"], function(value)
            if anti_aim_viewer_connection1 then
                anti_aim_viewer_connection1:Disconnect()
                anti_aim_viewer_connection1 = nil
            end

            if anti_aim_viewer_connection2 then
                anti_aim_viewer_connection2:Disconnect()
                anti_aim_viewer_connection2 = nil
            end

            if value then
                anti_aim_viewer_connection1 = create_connection(signals["on_local_tool_equipped"], do_anti_aim_viewer)

                if local_gun then
                    do_anti_aim_viewer(local_tool)
                end
            end
        end)
    end

    -- >> ( triggerbot )

    do
        local triggerbot_do_head = true
        local triggerbot_do_torso = true
        local triggerbot_do_arms = false
        local triggerbot_do_legs = false
        local triggerbot_cooldown = 0
        local triggerbot_hover_time = 0
        local triggerbot_delay = 0
        local last_triggerbot_part = nil
        local triggerbot_max_distance = 0
        local triggerbot_hitbox = "closest"
        local triggerbot_radius = (camera["ViewportSize"]["Magnitude"]/(1000*pi)) * 3

        local triggerbot_hover_tick = clock()
        local triggerbot_tick = clock()
        local triggerbot_circle = nil
        local triggerbot_circle_outline = nil

        local triggerbot_no_tool_check = false

        local offset = vector3_new(0,1,0)

        local do_triggerbot = do_prediction and LPH_JIT_MAX(function(dt, hrp)
            local mouse_position = get_mouse_location(user_input_service)

            if dt ~= last_target_dt then
                get_legitbot_target(dt)
            end

            if legitbot_target and not legitbot_dont_aim and (triggerbot_no_tool_check or local_gun) then
                local data = legitbot_target[1]
                local parts = data[4]
                local target_hrp = parts["HumanoidRootPart"]
                if not data[7] and not data[18] and not parts["ForceField"] and not parts["FORCEFIELD"] and target_hrp then
                    local max = (triggerbot_max_distance == 0 and (local_gun or 250) or triggerbot_max_distance)
                    if triggerbot_max_distance == 2500 or (hrp["Position"]-target_hrp["Position"])["Magnitude"] <= max then
                        local part = data[4][triggerbot_hitbox == "closest" and get_closest_part(data) or triggerbot_hitbox]

                        if part then
                            local ignore = {local_character, ignored, camera, data[3]}
                            for i = 1, #ignored do
                                ignore[#ignore + 1] = ignored[i]
                            end
        
                            params["FilterDescendantsInstances"] = ignore
        
                            local target_position = part["Position"] + legitbot_target_prediction
                            local pos, on_screen = world_to_viewport_point(camera, target_position)
        
                            if on_screen then
                                pos = vector2_new(pos["X"], pos["Y"])
        
                                local pos2, on_screen2 = world_to_viewport_point(camera, target_position - offset)
            
                                local radius = abs((pos-vector2_new(pos2["X"], pos2["Y"]))["Magnitude"])*triggerbot_radius
            
                                if triggerbot_circle then
                                    triggerbot_circle["Radius"] = radius
                                    triggerbot_circle["Position"] = pos
                                    triggerbot_circle_outline["Radius"] = radius
                                    triggerbot_circle_outline["Position"] = pos
                                    triggerbot_circle_outline["Visible"] = true
                                    triggerbot_circle["Visible"] = true
                                end
            
                                local origin = local_client_position["p"]
                                local difference = (target_position - origin)
                                local result = raycast(workspace, origin, difference["Unit"] * (difference["Magnitude"]), params)
            
                                if not result then
                                    local tick = clock()
            
                                    if (tick-triggerbot_tick > triggerbot_cooldown or triggerbot_cooldown == 0) and (mouse_position-pos)["Magnitude"] <= radius then
                                        triggerbot_tick = tick
            
                                        if last_triggerbot_part ~= instance then
                                            triggerbot_hover_tick = tick
                                        end
            
                                        if tick - triggerbot_hover_tick > triggerbot_hover_time or triggerbot_hover_time == 0 then
                                            if triggerbot_delay > 0 then
                                                delay(triggerbot_delay, function()
                                                    mouse1press()
                                                    wait()
                                                    mouse1release()
                                                end)
                                            else
                                                mouse1press()
                                                wait()
                                                mouse1release()
                                            end
                                        end
                                    end
            
                                    return
                                end
                            end
                        end
                    end
                end
            end

            last_triggerbot_part = nil
            if triggerbot_circle then
                triggerbot_circle["Visible"] = false
                triggerbot_circle_outline["Visible"] = false
            end
        end) or LPH_JIT_MAX(function(dt, hrp)
            local mouse_position = get_mouse_location(user_input_service)

            if dt ~= last_target_dt then
                get_legitbot_target(dt)
            end

            if legitbot_target and not legitbot_dont_aim and (triggerbot_no_tool_check or local_gun) then
                local ray = viewport_point_to_ray(camera, mouse_position["X"], mouse_position["Y"])
                local data = legitbot_target[1]
                local parts = data[4]
                local target_hrp = parts["HumanoidRootPart"]
                if not data[7] and not data[18] and not parts["ForceField"] and not parts["FORCEFIELD"] and target_hrp then
                    local max = (triggerbot_max_distance == 0 and (local_gun or 250) or triggerbot_max_distance)
                    if triggerbot_max_distance == 2500 or (hrp["Position"]-target_hrp["Position"])["Magnitude"] <= max then
                        local ignore = {local_character, ignored, camera, data[13]}
                        for i = 1, #ignored do
                            ignore[#ignore + 1] = ignored[i]
                        end

                        for name, part in parts do
                            if part["ClassName"] == "Accessory" then
                                ignore[#ignore+1] = part
                            elseif part:IsA("BasePart") and part["Transparency"] == 1 then
                                ignore[#ignore+1] = part
                            end
                        end

                        params["FilterDescendantsInstances"] = ignore

                        local result = raycast(workspace, ray["Origin"], ray["Direction"] * (max), params)

                        if result then
                            local instance = result["Instance"]

                            if instance then
                                local name = instance["Name"]

                                if parts[name] == instance then
                                    local do_triggerbot = false

                                    if triggerbot_do_head and name == "Head" then
                                        do_triggerbot = instance
                                    elseif triggerbot_do_torso and (name == "UpperTorso" or name == "LowerTorso" or name == "HumanoidRootPart" or name == "Torso") then
                                        do_triggerbot = instance
                                    elseif triggerbot_do_arms and (name == "LeftUpperArm" or name == "RightUpperArm" or name == "LeftLowerArm" or name == "RightLowerArm" or name == "LeftHand" or name == "RightHand" or name == "Left Arm" or name == "Right Arm") then
                                        do_triggerbot = instance
                                    elseif triggerbot_do_legs and (name == "LeftUpperLeg" or name == "RightUpperLeg" or name == "LeftLowerLeg" or name == "RightLowerLeg" or name == "LeftFoot" or name == "RightFoot" or name == "Right Leg" or name == "Left Leg") then
                                        do_triggerbot = instance
                                    end

                                    if do_triggerbot then
                                        local tick = clock()

                                        if tick-triggerbot_tick > triggerbot_cooldown or triggerbot_cooldown == 0 then
                                            triggerbot_tick = tick

                                            if last_triggerbot_part ~= instance then
                                                triggerbot_hover_tick = tick
                                            end

                                            if tick - triggerbot_hover_tick > triggerbot_hover_time or triggerbot_hover_time == 0 then
                                                if triggerbot_delay > 0 then
                                                    delay(triggerbot_delay, function()
                                                        mouse1press()
                                                        wait()
                                                        mouse1release()
                                                    end)
                                                else
                                                    mouse1press()
                                                    wait()
                                                    mouse1release()
                                                end
                                            end
                                        end
                                    end

                                    last_triggerbot_part = instance

                                    return
                                end
                            end
                        end
                    end
                end
            end

            last_triggerbot_part = nil
        end)

        create_connection(menu_references["triggerbot"]["on_toggle_change"], function(value)
            last_target_dt = nil

            if not value and not flags["silent_aim"] and not flags["aim_assist"] then
                delay(0.01, function()
                    set_legitbot_target(nil)
                    last_target_dt = nil
                    silent_aim_position = nil
                end)
            end

            for i = 1, #heartbeat do
                if heartbeat[i] == do_triggerbot then
                    remove(heartbeat, i)
                    break
                end
            end

            if value then
                heartbeat[#heartbeat+1] = do_triggerbot
            end
        end)

        create_connection(menu_references["triggerbot_hitboxes"]["on_dropdown_change"], do_prediction and function(value)
            local value = value[1]
            triggerbot_hitbox = value == "head" and "Head" or value == "torso" and "UpperTorso" or value
        end or function(value)
            triggerbot_do_legs = false
            triggerbot_do_torso = false
            triggerbot_do_arms = false
            triggerbot_do_head = false

            for i = 1, #value do
                local value = value[i]

                if value == "head" then
                    triggerbot_do_head = true
                elseif value == "torso" then
                    triggerbot_do_torso = true
                elseif value == "arms" then
                    triggerbot_do_arms = true
                elseif value == "legs" then
                    triggerbot_do_legs = true
                end
            end
        end)

        create_connection(menu_references["triggerbot_cooldown"]["on_slider_change"], function(value)
            triggerbot_cooldown = value
        end)

        create_connection(menu_references["triggerbot_max_distance"]["on_slider_change"], function(value)
            triggerbot_max_distance = value
        end)

        create_connection(menu_references["triggerbot_delay"]["on_slider_change"], function(value)
            triggerbot_delay = value
        end)

        create_connection(menu_references["triggerbot_hover_time"]["on_slider_change"], function(value)
            triggerbot_hover_time = value
        end)

        create_connection(menu_references["triggerbot_no_tool_check"]["on_toggle_change"], function(value)
            triggerbot_no_tool_check = value
        end)

        if do_prediction then
            local create_drawing = identifyexecutor() == "Wave" and create_fake_drawing or create_real_drawing
            create_connection(menu_references["triggerbot_radius"]["on_slider_change"], function(value)
                triggerbot_radius = (camera["ViewportSize"]["Magnitude"]/(1000*pi)) * value/10
            end)

            create_connection(menu_references["triggerbot_show_radius"]["on_toggle_change"], function(value)
                if triggerbot_circle then
                    triggerbot_circle:Destroy()
                    triggerbot_circle = nil
                end

                if triggerbot_circle_outline then
                    triggerbot_circle_outline:Destroy()
                    triggerbot_circle_outline = nil
                end

                if value then
                    triggerbot_circle = create_drawing("Circle", {
                        ["Visible"] = false,
                        ["Color"] = flags["triggerbot_show_radius_color"],
                        ["Transparency"] = 1-flags["triggerbot_show_radius_transparency"],
                        ["Thickness"] = 1,
                        ["Filled"] = true
                    })

                    triggerbot_circle_outline = create_drawing("Circle", {
                        ["Visible"] = false,
                        ["Color"] = flags["triggerbot_show_radius_outline_color"],
                        ["Transparency"] = 1-flags["triggerbot_show_radius_outline_transparency"],
                        ["Thickness"] = 1,
                        ["Filled"] = false
                    })
                end
            end)

            create_connection(menu_references["triggerbot_show_radius"]["on_color_change"], function(color)
                if triggerbot_circle then
                    triggerbot_circle["Color"] = color
                end
            end)

            create_connection(menu_references["triggerbot_show_radius"]["on_transparency_change"], function(transparency)
                if triggerbot_circle then
                    triggerbot_circle["Transparency"] = 1-transparency
                end
            end)

            create_connection(menu_references["triggerbot_show_radius_outline"]["on_color_change"], function(color)
                if triggerbot_circle_outline then
                    triggerbot_circle_outline["Color"] = color
                end
            end)

            create_connection(menu_references["triggerbot_show_radius_outline"]["on_transparency_change"], function(transparency)
                if triggerbot_circle_outline then
                    triggerbot_circle_outline["Transparency"] = 1-transparency
                end
            end)
        end
    end
end

-- > ( finalization )

do
    local data_ping = game:GetService("Stats")["Network"]["ServerStatsItem"]["Data Ping"]
    local last_ping_check = clock()
    local ping_data = {}

    local update_server_position = LPH_NO_VIRTUALIZE(function(hrp)
        local_server_position = hrp["CFrame"]
    end)

    local last_fps = clock()

    create_connection(game:GetService("RunService")["Heartbeat"], LPH_NO_VIRTUALIZE(function(dt)
        if in_void then
            in_void = nil
        else
            in_void = false
        end

        local_fps = 1/(clock() - last_fps)
        last_fps = clock()

        if clock()-last_ping_check > 2 then
            last_ping_check = clock()

            if #ping_data >= 10 then
                remove(ping_data, 1)
            end

            local new_ping = data_ping:GetValue()
            ping_data[#ping_data+1] = new_ping

            local total = 0
            for _, ping in ping_data do
                total+=ping
            end
            local_ping = floor(total/#ping_data)
        end

        local hrp = local_parts["HumanoidRootPart"]

        for i = 1, #heartbeat do
            spawn(heartbeat[i], dt, hrp)
        end

        if hrp then
            local_client_position = hrp["CFrame"]
        end

        for i = 1, #anti_aim do
            local func = anti_aim[i]
            if func then
                spawn(func, dt, hrp)
            end
        end

        if hrp then
            spawn(update_server_position, hrp)
        end
    end))
end

-- > ( addons )

do
    local running_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAMAAABhq6zVAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAAMdwEA6AMAAAx3AQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAO7qLRjGzAACAAAALElEQVQYV2NgRALoHAYGmAiEA+XCOGAenAPiYucgKwOxoRwwE8xBACQOIyMAHuoAZdtKAY0AAAAASUVORK5CYII=")
    local lua_image_data = base64_decode("iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAMAAAAolt3jAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOwgAADsIBFShKgAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADydgEA6AMAAPJ2AQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAI47wVfTF7xOAAAAOklEQVQYV3WMQQoAMAjD6v8/PVLrwMHKZhMPqlY+qgamvwYF8uDUXUNW86OMVktq1r4OBYnVkE6WVh04mgCJI6LjgQAAAABJRU5ErkJggg==")
    local addon_list = menu_references["addon_list"]

    for _, addon in menu["get_addon_list"]() do
        addon_list:add_item({
            ["text"] = addon,
            ["icons"] = {
                lua_image_data
            }
        })
    end

    -- >> ( addons )

    local addon_panel = menu_references["addon_panel"]
    local load_addon = menu_references["load_addon"]

    if load_addon then
        local unload_addon = menu_references["unload_addon"]
        local refresh_addon_list = menu_references["refresh_addon_list"]

        create_connection(addon_list["on_selection_change"], function(addon)
            local addon = addon or ""
            local path = "juju recode/addons/"..addon..".luau"

            if addon ~= "" and isfile(path) then
                if addon_data[addon] then
                    load_addon:set_visible(false)
                    unload_addon:set_visible(true)
                else
                    load_addon:set_visible(true)
                    unload_addon:set_visible(false)
                end
                refresh_addon_list:set_visible(false)
            else
                refresh_addon_list:set_visible(true)
                unload_addon:set_visible(false)
                load_addon:set_visible(false)
            end
        end)

        local do_refresh = function()
            local elements = addon_list["elements"]
            for _, element in elements do
                addon_list:remove_item(element["name"], true)
                elements[_] = nil
            end

            local addons = menu["get_addon_list"]()
            for i = 1, #addons do
                addon_list:add_item({
                    ["text"] = addons[i],
                    ["icons"] = addon_data[addons[i]] and {running_image_data, lua_image_data} or {
                        lua_image_data
                    }
                })
            end
        end

        create_connection(refresh_addon_list["on_clicked"], do_refresh)
        create_connection(menu["on_config_loaded"], do_refresh)

        create_connection(unload_addon["on_clicked"], function()
            local selected_addon = addon_list["selected"]
            local selected = selected_addon and selected_addon["name"]
            if selected_addon and addon_data[selected] then
                menu["unload_addon"](selected)
                new_notification("successfully unloaded addon "..selected, 1)
                addon_list:remove_icon(selected, running_image_data)
                load_addon:set_visible(true)
                unload_addon:set_visible(false)
            end
        end)

        create_connection(load_addon["on_clicked"], function()
            local selected_addon = addon_list["selected"]
            local selected = selected_addon and selected_addon["name"]

            if selected_addon and not addon_data[selected] then
                local did_error = menu["load_addon"](selected)
                if did_error then
                    new_notification("failed to load addon "..selected.." ("..did_error..")", 3)
                    error(did_error)
                    return
                end
                new_notification("successfully loaded addon "..selected, 1)
                unload_addon:set_visible(true)
                addon_list:add_icon(selected, running_image_data)
                load_addon:set_visible(false)
            end
        end)

        unload_addon:set_visible(false)
        load_addon:set_visible(false)
    end

    local typeof = typeof
    local g = menu["get_active_binds"]

    getgenv()["juju"] = {
        create_connection = function(signal, callback)
            local type = typeof(signal)

            if type ~= "RBXScriptSignal" and type ~= "table" then
                error("juju: create_connection arg #1 expected RBXScriptSignal or table got "..type)
                return
            end

            local type = typeof(callback)

            if type ~= "function" then
                error("juju: create_connection arg #2 expected function got "..type)
                return
            end

            local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER

            if identifier then
                local data = addon_data[identifier]

                if data then
                    local data = addon_data[identifier]
                    local connections = data[3]

                    local connection = signal:Connect(callback)

                    connections[#connections+1] = connection

                    return connection
                end
            end
        end,
        find_element = LPH_JIT_MAX(function(parent, name)
            local type = typeof(name)

            if type ~= "string" then
                error("juju: find_element arg #1 expected string got "..type)
                return
            end

            local type = typeof(parent)

            if type ~= "string" then
                error("juju: find_element arg #2 expected string got "..type)
                return
            end

            local name = name:lower()

            if name:find("config") or name:find("unload") then
                error("juju: find_element arg #2 expected string got <?>")
                return
            end

            local parent = parent:lower()

            for _, group in menu["groups"] do
                for _, tab in group["tabs"] do
                    for _, section in tab["sections"] do
                        if section["name"]:lower() == parent then
                            local elements = section["elements"]
                            for i = 1, #elements do
                                local element = elements[i]
                                if (element["name"]):lower() == name then
                                    return element
                                end
                            end
                        end
                    end
                end
            end

            for element_settings, settings in menu["settings"] do
                if element_settings["name"]:lower() == parent then
                    local elements = settings["elements"]
                    for i = 1, #elements do
                        local element = elements[i]
                        if (element["name"]:lower()) == name then
                            return element
                        end
                    end
                end
            end

            error("juju: find_element failed to find element "..name)
        end),
        create_section = function(name, side, size, offset)
            local type = typeof(name)

            if type ~= "string" then
                error("juju: create_section arg #1 expected string got "..type)
                return
            end

            local type = typeof(side)

            if type ~= "number" then
                error("juju: create_section arg #2 expected number got "..type)
                return
            elseif side ~= 1 and side ~= 2 then
                error("juju: create_section arg #2 expected number 1 or 2 got "..side)
                return
            end

            local type = typeof(size)

            if type ~= "number" then
                error("juju: create_section arg #3 expected number got "..type)
                return
            elseif size < 0 or size > 1 then
                error("juju: create_section arg #3 expected number between 0 and 1 got "..size)
                return
            end

            local type = typeof(offset)

            if type ~= "number" then
                error("juju: create_section arg #4 expected number got "..type)
                return
            elseif offset < 0 or offset > 0.9 then
                error("juju: create_section arg #4 expected number between 0 and 0.9 got "..offset)
                return
            end

            local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER

            if identifier then
                local data = addon_data[identifier]

                if data then
                    local tab = data[2]

                    if tab and tab["destroy"] then
                        return menu["groups"]["addons"]:create_section(data[5], name, side, size, offset)
                    end
                end
            end
        end,
        create_element = function(section, info, elements)
            local type = typeof(section)

            if type ~= "string" then
                if not elements and type == "table" then
                    local new_info = section
                    local new_elements = info

                    if typeof(new_info) == "table" and typeof(new_elements) == "table" then
                        local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER

                        local data = addon_data[identifier]

                        if data then
                            local tab = data[2]
        
                            if not tab or not tab["destroy"] then
                                juju["create_tab"]()
                                data[6] = juju["create_section"]("update yo addon twin", 1, 1, 0)
                            end

                            return data[6]:create_element(new_info, new_elements)
                        end
                    end
                end
                error("juju: create_element arg #1 expected string got "..type)
                return
            end

            local type = typeof(info)

            if type ~= "table" then
                error("juju: create_element arg #2 expected table got "..type)
                return
            end

            local type = typeof(elements)

            if type ~= "table" then
                error("juju: create_element arg #3 expected table got "..type)
                return
            end

            local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER
            
            if identifier then
                local data = addon_data[identifier]

                if data then
                    local tab = data[2]

                    if not tab or not tab["destroy"] then
                        error("juju: create_element failed due to missing tab")
                        return 
                    end

                    local section = tab["sections"][section]

                    if not section or not section["destroy"] then
                        error("juju: create_element failed due to missing section \'"..section.."\''")
                        return 
                    end

                    return section:create_element(info, elements)
                end
            end
        end,
        get_signal = LPH_JIT_MAX(function(signal)
            local type = typeof(signal)

            if type ~= "string" then
                error("juju: get_signal arg #1 expected string got "..type)
                return
            end

            if signal == "on_ragebot_target_changed" or signal == "on_legitbot_target_changed" or signal == "on_target_changed" then
                local fake = {
                    ["Connect"] = function(self, callback)
                        return signals[signal]:Connect(function(player, ...)
                            return callback(player and player[2])
                        end)
                    end
                }

                return fake
            end

            return signals[signal]
        end),
        get_signals = LPH_NO_VIRTUALIZE(function()
            local all = {}
            for signal, _ in signals do
                all[#all+1] = signal
            end
            return all
        end),
        set_flag = LPH_JIT_MAX(function(flag, value)
            if flag == nil or flag == "author" or flag == "date" or flag == "loaded_addons" then
                error("juju: set_flag arg #1 expected string got <?>")
                return
            end

            local type = type(flag)

            if type ~= "string" then
                error("juju: set_flag arg #1 expected string got "..type)
                return
            end

            flags[flag] = value
        end),
        get_flag = LPH_NO_VIRTUALIZE(function(flag)
            if flag == "author" or flag == "date" or flag == "loaded_addons" or flag == nil then
                return nil
            end 

            return flags[flag]
        end),
        get_flags = LPH_NO_VIRTUALIZE(function()
            local all = {}
            for flag, _ in flags do
                if flag == "author" or flag == "date" or flag == "loaded_addons" then
                    continue
                end 
                all[#all+1] = flag
            end
            return all
        end),
        load_config = newcclosure(function(string)
            local type = type(string)

            if type ~= "string" then
                error("juju: load_config arg #1 expected string got "..type)
                return
            end

            if isfile("juju recode/configs/"..string..".cfg") then
                menu["load_config"](string)
            else
                error("juju: load_config expected string got "..type)
            end
        end),
        set_tab_text = function(text)
            local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER

            if identifier then
                local data = addon_data[identifier]

                if data then
                    local tab = data[2]

                    if tab and tab["text"] then
                        local type = type(text)

                        if type ~= "string" then
                            error("juju: set_tab_text arg #1 expected string got "..type)
                            return
                        end

                        tab["text"]["Text"] = text
                    end
                end
            end
        end,
        on_unload = function(func)
            local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER

            if identifier then
                local data = addon_data[identifier] 
                
                if data then
                    data[4] = func
                end
            end
        end,
        create_tab = function(func)
            local identifier = getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER

            if identifier then
                local data = addon_data[identifier]

                if data and not data[2]["destroy"] then
                    local addons = menu["groups"]["addons"]
                    if not addons["is_visible"] then
                        addons:show()
                    end

                    data[2] = addons:create_tab(addon_data[getfenv(0).__IDENTIFIER or getfenv(1).__IDENTIFIER or getfenv(2).__IDENTIFIER or getfenv(3).__IDENTIFIER][5], func)
                end
            end
        end,
        is_in_void = LPH_NO_VIRTUALIZE(function()
            return in_void
        end),
        is_auto_stomping = LPH_NO_VIRTUALIZE(function()
            return stomping
        end),
        get_ping = LPH_NO_VIRTUALIZE(function()
            return local_ping
        end),
        purchase_item = LPH_JIT_MAX(function(item, ammo)
            purchase_item(item, ammo)
        end),
        is_purchasing = LPH_NO_VIRTUALIZE(function()
            return purchasing
        end),
        get_server_cframe = LPH_NO_VIRTUALIZE(function()
            return local_server_position
        end),
        get_client_cframe = LPH_NO_VIRTUALIZE(function()
            return local_client_position
        end),
        get_ragebot_target = LPH_NO_VIRTUALIZE(function()
            return ragebot_target and ragebot_target[2] or nil
        end),
        set_ragebot_target = LPH_JIT_MAX(function(player, message)
            local type = typeof(player)

            if player ~= nil and ((type ~= "Instance") or (player and player["ClassName"] ~= "Player" or player == local_player)) then
                error("juju: set_ragebot_target arg #1 expected Player got "..type)
                return
            end

            local type = typeof(message)

            if type ~= "string" and message ~= nil then
                error("juju: set_ragebot_target arg #2 expected string or nil got "..type)
                return
            end

            if flags["ragebot"] then
                set_ragebot_target(player and player_data[player] or nil, "ragebot target set to "..(player and player["Name"] or "nobody"))

                return true
            end
        end),
        get_player_status = function(player)
            local type = typeof(player)

            if type ~= "Instance" or player["ClassName"] ~= "Player" or player == local_player then
                error("juju: get_player_status arg #1 expected Player got "..type)
                return
            end

            local data = player_data[player]

            if data then
                return data[1]
            end
        end,
        set_player_status = LPH_JIT_MAX(function(player, status)
            local type = typeof(player)

            if type ~= "Instance" or player["ClassName"] ~= "Player" or player == local_player then
                error("juju: set_player_status arg #1 expected Player got "..type)
                return
            end

            local type = typeof(status)

            if type ~= "number" then
                error("juju: set_player_status arg #1 expected number 1-3 got "..type)
                return
            end

            local data = player_data[player]

            if data then
                local old_status = data[1]

                if old_status ~= status then
                    data[1] = status
                    signals["on_player_status_changed"]:Fire(data, status)
                end
            end

            return true
        end),
        set_server_cframe = LPH_JIT_MAX(function(cf)
            local type = typeof(cf)

            if type ~= "CFrame" then
                error("juju: set_server_cframe arg #1 expected CFrame got "..type)
                return
            end

            local hrp = local_parts["HumanoidRootPart"]

            if not hrp then
                return
            end

            local new_function = function(dt, hrp)
                if not hrp then
                    return
                end

                local old = hrp["CFrame"]
                hrp["CFrame"] = cf
                render_stepped_wait(render_stepped)
                hrp["CFrame"] = old
            end

            anti_aim[#anti_aim+1] = new_function

            run_service["Heartbeat"]:Wait()

            for i = 1, #anti_aim do
                if anti_aim[i] == new_function then
                    remove(anti_aim, i)
                    break
                end
            end
        end),
        is_player_invulnerable = LPH_JIT_MAX(function(player)
            local type = typeof(player)

            if type ~= "Instance" or player["ClassName"] ~= "Player" then
                error("juju: is_player_invulnerable arg #1 expected Instance (Player) got "..type)
                return
            end

            local data = player_data[player]

            if data then
                local parts = data[4]
                return parts["GRABBING_CONSTRAINT"] or parts["ForceField"] or parts["FORCEFIELD"] or false
            end
        end),
        is_player_dead = LPH_JIT_MAX(function(player)
            local type = typeof(player)

            if type ~= "Instance" or player["ClassName"] ~= "Player" then
                error("juju: is_player_dead arg #1 expected Instance (Player) got "..type)
                return
            end

            local data = player_data[player]

            return data and data[7] or nil
        end),
        get_ragebot_aim_position = LPH_NO_VIRTUALIZE(function()
            return ragebot_aim_position
        end),
        set_ragebot_aim_position = LPH_NO_VIRTUALIZE(function(position)
            local type = typeof(position)

            if type == "Vector3" then
                custom_ragebot_aim_position = position
            end
        end),
        set_aim_assist_position = set_aim_assist_position,
        get_silent_aim_position = get_silent_aim_position,
        set_silent_aim_position = set_silent_aim_position,
        get_active_keybinds = LPH_NO_VIRTUALIZE(function()
            local b = g()
            local r = {}
            for i = 1, #b do
                local z = b[i]
                r[z["element"]["name"]] = z["value"]
            end
            return r
        end),
        reload_gun = LPH_NO_VIRTUALIZE(function()
            if not local_reloading and local_gun then
                event:FireServer("Reload", local_gun)
                return true
            end
        end),
        set_legitbot_target = LPH_JIT_MAX(function(player, message)
            local type = typeof(player)

            if player ~= nil and ((type ~= "Instance") or (player and player["ClassName"] ~= "Player" or player == local_player)) then
                error("juju: set_legitbot_target arg #1 expected Player got "..type)
                return
            end

            local type = typeof(message)

            if type ~= "string" and message ~= nil then
                error("juju: set_legitbot_target arg #2 expected string or nil got "..type)
                return
            end


            if flags["aim_assist"] or flags["triggerbot"] or flags["silent_aim"] then
                if player then
                    local data = player_data[player]

                    if data then
                        local hrp = data[4]["HumanoidRootPart"]
                        local distance = 1000

                        if hrp then
                            local position, on_screen = world_to_viewport_point(camera, hrp["Position"])
                            if on_screen then
                                local mouse_pos = get_mouse_location(user_input_service)
                                distance = (vector2_new(position["X"], position["Y"]) - mouse_pos)["Magnitude"]
                            end
                        end

                        set_legitbot_target({data, hrp, distance}, "legitbot target set to "..player["Name"])
                    else
                        set_legitbot_target(nil, "legitbot target set to nobody")
                    end
                else
                    set_legitbot_target(nil, "legitbot target set to nobody")
                end
                return true
            end
        end),
        get_legitbot_target = LPH_NO_VIRTUALIZE(function()
            return legitbot_target and legitbot_target[1][2] or nil
        end),
        is_defensive_active = is_defensive_active,
        is_in_vehicle = LPH_NO_VIRTUALIZE(function()
            return vehicle ~= nil
        end),
        create_notification = LPH_JIT_MAX(function(text, type, time)
            local type2 = typeof(text)

            if type2 ~= "string" then
                error("juju: create_notification arg #1 expected string got "..type2)
                return
            end

            local type2 = typeof(type)

            if type2 ~= "number" then
                error("juju: create_notification arg #2 expected number got "..type2)
                return
            end

            local type2 = typeof(time)

            if type2 ~= "number" and time ~= nil then
                error("juju: create_notification arg #3 expected number got "..type2)
                return
            end

            new_notification(text, type, time)
        end)
    }
end

-- > ( finish loading )

do
    local username = "?"
    local avatar = nil

    local LRM_LinkedDiscordID = LRM_LinkedDiscordID or "320421345324433418"
    if LRM_LinkedDiscordID then
        local s, data = pcall(function()
            local body = request({
                ["Url"] = "https://discord-lookup-api-pied.vercel.app/v1/user/"..LRM_LinkedDiscordID,
                ["Method"] = "GET",
                ["Headers"] = {
                    ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                    ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
                    ["Accept-Language"] = "en-US,en;q=0.9",
                    ["Connection"] = "keep-alive",
                    ["Referer"] = "https://www.google.com/",
                    ["DNT"] = "1",
                    ["Upgrade-Insecure-Requests"] = "1"
                }
            })

            if body and body["StatusCode"] == 200 then
                local username = http_service:JSONDecode(body["Body"])

                if username then
                    return username
                end
            end
        end)

        username = (s and data) and "@"..data["username"] or "?"

        if username ~= "?" then
            s, avatar = pcall(function()
                return game:HttpGet(data["avatar"]["link"])
            end)
        end
    end

    new_notification(
        "welcome back to juju, "..username,
        5,
        color3_fromrgb(255, 255, 255),
        avatar or base64_decode("iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAADHcBAOgDAAAMdwEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADu6i0YxswAAgAAAGBJREFUOE+tkdEOgCAIRdH//+eCO3BG16TWeUEYB5zK7xyKHynNI9g1G01BRJZYDOjqjPpN3G2lG2cpGqIWOWUW89nwFHSPIG95DRNLwypNl6sapcmMqjiemAmPX/ANkROaKkTiEnqHHQAAAABJRU5ErkJggg==")
    )

    local overlay = core_gui["RobloxPromptGui"]["promptOverlay"]

    create_connection(overlay["ChildAdded"], LPH_JIT_MAX(function(error) -- >> genuinely if this ever gets leaked.. DONT ask
        if error["Name"] == "ErrorPrompt" then
            if flags["custom_kick_screen"] then
                if not _G.did then
                    spawn(function()
                        local gui_service = cloneref(game:GetService("GuiService"))
                        while wait(0.15) do
                            gui_service:ClearError()
                        end
                    end)
                    wait()
                    _G.did = true
                    local background = flags["custom_kick_screen_background"]
                    local create_fake_drawing = getgenv()["_PROXY"]["new"]
                    local color = flags["custom_kick_screen_color"]
                    local path = "juju recode/"..(background == "2.png" and "assets/2.png" or "custom/"..background)
                    local data = isfile(path) and readfile(path) or readfile("juju recode/assets/2.png")
                    local message_label = error["MessageArea"]["ErrorFrame"]["ErrorMessage"]
                    local message = error["MessageArea"]["ErrorFrame"]["ErrorMessage"]
                    error["Visible"] = false
                    local blur = find_first_child_of_class(cloneref(game:GetService("Lighting")), "BlurEffect")
                    if blur then
                        destroy(blur)
                    end
                    message = message["Text"] == "Label" and "" or message["Text"]
                    local is_rejoining = message:find("Moderation message: R..")
                    local is_hopping = message:find("Moderation message: H..")

                    create_connection(message_label:GetPropertyChangedSignal("Text"), function()
                        message = message_label["Text"]
                    end)

                    local background = create_fake_drawing("Image", {
                        ["Color"] = color3_fromrgb(255, 255, 255),
                        ["Size"] = udim2_new(0, camera["ViewportSize"]["X"], 0, camera["ViewportSize"]["Y"]),
                        ["Position"] = udim2_new(0, 0, 0, 0),
                        ["Transparency"] = 0,
                        ["Visible"] = true,
                        ["Data"] = data,
                        ["ZIndex"] = 10000,
                    })
                    local shadow = create_fake_drawing("Image", {
                        ["Color"] = color3_fromrgb(0, 0, 0),
                        ["Size"] = udim2_new(1, 560, 1, 560),
                        ["Position"] = udim2_new(0, -280, 0, -280),
                        ["Transparency"] = 0,
                        ["Visible"] = true,
                        ["Data"] = shadow_image_data,
                        ["Parent"] = background,
                        ["ZIndex"] = 10001,
                    })
                    local logo = create_fake_drawing("Image", {
                        ["Color"] = color3_fromrgb(255, 255, 255),
                        ["Size"] = udim2_new(0, 100, 0, 100),
                        ["Position"] = udim2_new(0.5, -50, 0.45, -50),
                        ["Data"] = readfile("juju recode/assets/logo.png"),
                        ["Transparency"] = 0,
                        ["Parent"] = background,
                        ["Visible"] = true,
                        ["ZIndex"] = 10002,
                    })
                    local text = create_fake_drawing("Text", {
                        ["Color"] = color3_fromrgb(255, 255, 255),
                        ["Size"] = 24,
                        ["Position"] = udim2_new(1, 0, 0.45, 0),
                        ["Text"] = is_rejoining and "now rejoining..." or is_hopping and "now hopping..." or "you've been disconnected",
                        ["Transparency"] = 0,
                        ["Parent"] = logo,
                        ["ZIndex"] = 10003,
                        ["Visible"] = true
                    })

                    create_connection(camera:GetPropertyChangedSignal("ViewportSize"), function()
                        background["Size"] = udim2_new(0, camera["ViewportSize"]["X"], 0, camera["ViewportSize"]["Y"])
                    end)
                    error["Visible"] = false
                    local blur = find_first_child_of_class(cloneref(game:GetService("Lighting")), "BlurEffect")
                    if blur then
                        destroy(blur)
                    end

                    local linear = Enum["EasingStyle"]["Linear"]

                    tween(background, show_transparency, linear, out, 0.4)
                    tween(shadow, {["Transparency"] = 0.89}, circular, out, 0.4)
                    wait(0.8)
                    tween(logo, {["tween_position"] = udim2_new(0.5, -50, 0.5, -50), ["Transparency"] = 0.4}, circular, out, 0.4)
                    wait(0.5)
                    tween(logo, {["tween_position"] = udim2_new(0.5, -210, 0.5, -50)}, circular, out, 0.4)
                    tween(text, {["tween_position"] = udim2_new(1, 0, 0.5, 0), ["Transparency"] = 0.4}, circular, out, 0.8)
                    wait(0.9)
                    tween(text, {["tween_position"] = udim2_new(1, 0, 0.2, 0)}, circular, out, 0.4)

                    if not is_rejoining and not is_hopping then
                        local reason_text = create_fake_drawing("Text", {
                            ["Color"] = color3_fromrgb(150, 150, 150),
                            ["Size"] = 16,
                            ["Position"] = udim2_new(0.5, 0, 0.5, 50),
                            ["Text"] = "\""..message.."\"",
                            ["Transparency"] = 0,
                            ["Parent"] = background,
                            ["ZIndex"] = 10003,
                            ["Center"] = true,
                            ["Visible"] = true
                        })
                        local rejoin_frame = create_fake_drawing("Image", {
                            ["Color"] = color,
                            ["Size"] = udim2_new(1, 0, 0, 25),
                            ["Position"] = udim2_new(1, 0, 0.48, 0),
                            ["Data"] = pixel_image_data,
                            ["Rounding"] = 10,
                            ["Transparency"] = 0,
                            ["Parent"] = logo,
                            ["Visible"] = true,
                            ["ZIndex"] = 10002,
                        })
                        local rejoin_text = create_fake_drawing("Text", {
                            ["Color"] = color3_fromrgb(255, 255, 255),
                            ["Size"] = 16,
                            ["Position"] = udim2_new(0.5, 0, 0.15, 0),
                            ["Text"] = "rejoin",
                            ["Transparency"] = 0,
                            ["Parent"] = rejoin_frame,
                            ["ZIndex"] = 10003,
                            ["Center"] = true,
                            ["Visible"] = true
                        })
                        local hop_frame = create_fake_drawing("Image", {
                            ["Color"] = color,
                            ["Size"] = udim2_new(1, 0, 0, 25),
                            ["Position"] = udim2_new(2, 10, 0.48, 0),
                            ["Data"] = pixel_image_data,
                            ["Rounding"] = 10,
                            ["Transparency"] = 0,
                            ["Parent"] = logo,
                            ["Visible"] = true,
                            ["ZIndex"] = 10002,
                        })
                        local hop_text = create_fake_drawing("Text", {
                            ["Color"] = color3_fromrgb(255, 255, 255),
                            ["Size"] = 16,
                            ["Position"] = udim2_new(0.5, 0, 0.15, 0),
                            ["Text"] = "hop",
                            ["Transparency"] = 0,
                            ["Parent"] = hop_frame,
                            ["ZIndex"] = 10003,
                            ["Center"] = true,
                            ["Visible"] = true
                        })

                        tween(rejoin_frame, {["Transparency"] = 0.5}, circular, out, 0.4)
                        tween(hop_frame, {["Transparency"] = 0.5}, circular, out, 0.4)
                        tween(rejoin_text, {["Transparency"] = 0.5}, circular, out, 0.4)
                        tween(hop_text, {["Transparency"] = 0.5}, circular, out, 0.4)
                        tween(reason_text, {["Transparency"] = 0.5}, circular, out, 0.4)
                        create_connection(camera:GetPropertyChangedSignal("ViewportSize"), function()
                            background["Size"] = udim2_new(0, camera["ViewportSize"]["X"], 0, camera["ViewportSize"]["Y"])
                        end)

                        local last_tweened = nil
                        create_connection(mouse["Move"], function()
                            local pos = get_mouse_location(user_input_service)
                            local rejoin_pos = rejoin_frame["Position"]
                            local hop_pos = hop_frame["Position"]
                            local size = hop_frame["real_size"]["X"]

                            if (pos["X"] >= rejoin_pos["X"] and pos["X"] <= rejoin_pos["X"] + size) and (pos["Y"] >= rejoin_pos["Y"] and pos["Y"] <= rejoin_pos["Y"] + 25) then
                                if not last_tweened then
                                    tween(rejoin_frame, {["Transparency"] = 0.75}, circular, out, 0.2)
                                end
                                last_tweened = rejoin_frame
                                return
                            elseif (pos["X"] >= hop_pos["X"] and pos["X"] <= hop_pos["X"] + size) and (pos["Y"] >= hop_pos["Y"] and pos["Y"] <= hop_pos["Y"] + 25) then
                                if not last_tweened then
                                    tween(hop_frame, {["Transparency"] = 0.75}, circular, out, 0.2)
                                end
                                last_tweened = hop_frame
                                return
                            end

                            if last_tweened then
                                tween(last_tweened, {["Transparency"] = 0.5}, circular, out, 0.2)
                                last_tweened = nil
                                return
                            end
                        end)

                        local connection = nil
                        connection = create_connection(user_input_service["InputBegan"], function(input, gpe)
                            if input["UserInputType"] == Enum["UserInputType"]["MouseButton1"] then
                                if last_tweened == rejoin_frame then
                                    connection:Disconnect()

                                    teleport_service:Teleport(game["PlaceId"])
                                    text["Text"] = "rejoining server..."
                                    tween(last_tweened, {["Transparency"] = 0.8}, circular, out, 0.2)
                                elseif last_tweened == hop_frame then
                                    connection:Disconnect()
                                    tween(last_tweened, {["Transparency"] = 0.8}, circular, out, 0.2)

                                    text["Text"] = "finding server..."
                                    local servers = http_service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game["PlaceId"].."/servers/Public?sortOrder=Asc&limit=100"))["data"]
                                    local lowest_ping = 9e9
                                    local most_players = 0
                                    local best_server
                                    local max_players = tonumber(servers[1]["maxPlayers"])
                                    for i = 1, #servers do
                                        local server = servers[i]
                                        local players = tonumber(server["playing"])
                                        local ping = tonumber(server["ping"])
                                        if players ~= max_players and players > most_players and ping < lowest_ping then
                                            lowest_ping = ping
                                            most_players = players
                                            best_server = server["id"]
                                        end
                                    end

                                    if best_server then
                                        text["Text"] = "joining server..."

                                        teleport_service:TeleportToPlaceInstance(game["PlaceId"], best_server)
                                    else
                                        text["Text"] = "failed to find server"
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end
    end))

    local autoload = menu["autoload"]
    if autoload and isfile("juju recode/configs/"..autoload..".cfg") then
        spawn(menu["load_config"], autoload)
        menu["new_notification"]("autoloaded config "..autoload, 1)
    end
end
