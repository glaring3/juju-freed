cleardrawcache()

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function(...) return ... end
	LPH_JIT_MAX = function(...) return ... end
	LPH_JIT = function(...) return ... end
end

-----------------------------------
-- * Service & Cache Variables * --
-----------------------------------

local uis = game:GetService("UserInputService")
local tws = game:GetService("TweenService")
	local getValue = tws.GetValue
local hs = game:GetService("HttpService")
local plrs = game:GetService("Players")
local ts = game:GetService("TextService")
local hs = game:GetService("HttpService")
local cg = gethui and gethui() or game:GetService("CoreGui")
local rs = game:GetService("RunService")
local stats = game:GetService("Stats")
local lighting = game:GetService("Lighting")
local tps = game:GetService("TeleportService")
local reps = game:GetService("ReplicatedStorage")
local is = game:GetService("InsertService")

local workspace = workspace
local tostring = tostring
local getconnections = getconnections
local game = game
local tonumber = tonumber

local sky = lighting:FindFirstChildOfClass("Sky")

local clamp = math.clamp
local floor = math.floor
local udim2new = UDim2.new
local vector2new = Vector2.new
local colorfromrgb = Color3.fromRGB
local vector3new = Vector3.new
local cframenew = CFrame.new
local abs = math.abs
local split = string.split
local sub = string.sub
local gsub = string.gsub
local newtweeninfo = TweenInfo.new
	local _wait = task.wait
	local _spawn = task.spawn

local angles = CFrame.Angles
local rad = math.rad
local lower = string.lower
local mathrandom = math.random
	local line_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/line.png")
	local health_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/healthbar.png")
	local ammo_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/ammobar.png")
	local gradient_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/gradientbar.png")
	local pixel_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/white_pixel.png")
	local fonts = {
		1,
		2,
		3,
		3
	}

	if identifyexecutor and identifyexecutor() == "Krampus" then
		fonts = {
			{Drawing.new("Font", "Gatha"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/Gatha.ttf"},
			{Drawing.new("Font", "Sometype"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/Sometype.ttf"},
			{Drawing.new("Font", "Verdana"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/Verdana.ttf"},
			{Drawing.new("Font", "Miracode"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/Miracode.ttf"}
		}

		for name, info in fonts do
			if not info[1]["Loaded"] then
				info[1]["Data"] = game:HttpGet(info[2])
				fonts[name] = info[1]
			else
				fonts[name] = info[1]
			end
		end
	end

local lplr = plrs.LocalPlayer
	local lplr_gui = lplr.PlayerGui
	local mouse = lplr:GetMouse()
	local char = lplr.Character
	local lplr_parts = {}
	local lplr_data = {
		crew = nil,
		gun = nil,
		position_body = nil,
		viewing = nil,
		strafe_angle = 0,
		cframe_body = nil,
		priority = {},
		last_visible_check = os.clock(),
		accessories = {},
		equipped_accessories = {},
		is_typing = false,
		whitelisted = {},
	}

local player_data = {}
local camera = workspace.CurrentCamera
	local wtvp = camera.WorldToViewportPoint
	local raycast = workspace.Raycast

for i,v in getconnections(camera:GetPropertyChangedSignal("CFrame")) do
	v:Disable()
end

--------------------
-- * UI Utility * --
--------------------

local utility = {
	connections = {},
	is_dragging_blocked = false
}

do
	local newInstance = Instance.new
	local keybindBlacklist = {
		Enum.KeyCode.Escape,
		Enum.KeyCode.Tilde,
	}

    utility.lerp = function(initial, new, elapsed)
        return initial + (new - initial) * elapsed
    end
	
	utility.newConnection = function(signal, callback, cache)
		local connection = signal:Connect(callback)

		if cache then
			utility.connections[#utility.connections] = connection
		end

		return connection
	end

	utility.copyTable = function(original)
		local copy = {}
		for _, v in pairs(original) do
			if type(v) == "table" then
				v = utility.copyTable(v)
			end
			copy[_] = v
		end
		return copy
	end

	utility.removeBrackets = function(string)
		return string.lower(string):gsub('[%p%c%s]', '')
	end

	utility.round = LPH_NO_VIRTUALIZE(function(num, decimals)
		local mult = 10^(decimals or 0)
		return floor(num * mult + 0.5) / mult
	end)

	utility.find = LPH_NO_VIRTUALIZE(function(array, find)
		for _, obj in array do
			if find == obj then return  _ end
		end
	end)

	utility.insert = function(array, _)
		array[#array+1] = _
	end

	utility.isValidKey = function(keycode)
		if utility.find(keybindBlacklist, keycode) then
			return false
		end
		return true
	end

	utility.length = function(array)
		local length = 0
		for _, obj in array do length+=1 end
		return length
	end

	utility.remove = function(array, _, z)
		array[z or utility.find(array, _)] = nil
	end

	utility.newDrawing = function(class, properties)
		local object = Drawing.new(class)

		for property, value in properties do
			setrenderproperty(object, property, value)
		end

		return object
	end

	utility.tween = function(...)
		tws:Create(...):Play()
	end

	utility.setDraggable = function(object)
		local dragging = false

		utility.newConnection(object.InputBegan, LPH_JIT_MAX(function(input, gpe)
			if gpe then return end
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not utility.is_dragging_blocked then
				local mouse_location = uis:GetMouseLocation()
				local startPosX = mouse_location.X
				local startPosY = mouse_location.Y
				local objPosX = object.Position.X.Offset
				local objPosY = object.Position.Y.Offset
				dragging = true
				_spawn(function()
					while dragging and not utility.is_dragging_blocked do
						mouse_location = uis:GetMouseLocation()
						object.Position = udim2new(0, objPosX - (startPosX - mouse_location.X), 0, objPosY - (startPosY - mouse_location.Y))
						_wait()
					end
				end)
			end
		end))

		utility.newConnection(object.InputEnded, function(input, gpe)
			if gpe then return end
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
			end
		end)
	end

	utility.isInDrawing = function(object, pos)
		local abs_pos = object.Position
		local abs_size = object.Size
		local x = abs_pos.Y <= pos.Y and pos.Y <= abs_pos.Y + abs_size.Y
		local y = abs_pos.X <= pos.X and pos.X <= abs_pos.X + abs_size.X

		return (x and y)
	end

	utility.isInFrame = function(object, pos)
		local abs_pos = object.AbsolutePosition
		local abs_size = object.AbsoluteSize
		local x = abs_pos.Y <= pos.Y and pos.Y <= abs_pos.Y + abs_size.Y
		local y = abs_pos.X <= pos.X and pos.X <= abs_pos.X + abs_size.X

		return (x and y)
	end

	utility.isInUI = function(gui1, gui2)
		local gui1_topLeft = gui1.AbsolutePosition
		local gui1_bottomRight = gui1_topLeft + gui1.AbsoluteSize

		local gui2_topLeft = gui2.AbsolutePosition
		local gui2_bottomRight = gui2_topLeft + gui2.AbsoluteSize

		return ((gui1_topLeft.x < gui2_bottomRight.x and gui1_bottomRight.x > gui2_topLeft.x) and (gui1_topLeft.y < gui2_bottomRight.y and gui1_bottomRight.y > gui2_topLeft.y))
	end

	utility.newObject = function(class, properties)
		local object = newInstance(class)

		for property, value in properties do
			object[property] = value
		end

		object.Name = properties["Name"] or ""

		return object
	end
end

local aimbot = {
	circle_outline = utility.newDrawing("Circle", {
		Filled = false,
		Radius = 5,
		Thickness = 4,
		ZIndex = 14,
		Color = colorfromrgb(0,0,0),
		NumSides = 33
	}),
	circle = utility.newDrawing("Circle", {
		Filled = false,
		Radius = 5,
		ZIndex = 15,
		Thickness = 2,
		Color = colorfromrgb(255,255,255),
		NumSides = 33
	}),
	assist_circle_outline = utility.newDrawing("Circle", {
		Filled = false,
		Radius = 67,
		Thickness = 4,
		ZIndex = 14,
		Color = colorfromrgb(0,0,0),
		NumSides = 33
	}),
	assist_circle = utility.newDrawing("Circle", {
		Filled = false,
		Radius = 66,
		ZIndex = 15,
		Thickness = 2,
		Color = colorfromrgb(255,255,255),
		NumSides = 33
	}),
	line_outline = utility.newDrawing("Line", {
		Thickness = 4,
		ZIndex = 12,
		Color = colorfromrgb(0,0,0)
	}),
	line = utility.newDrawing("Line", {
		Thickness = 2,
		ZIndex = 13,
		Color = colorfromrgb(255,255,255)
	}),
	target = nil,
	target_screen_position = vector2new(),
	last_refresh = tick(),
	target_velocity = vector3new(0,0,0),
	do_tp = false,
	silent_aim_fov = 67,
	aim_assist_fov = 67
}

------------------------
-- * Signal Library * --
------------------------

local signal = {}
signal.__index = signal

function signal.new()
	return setmetatable({connections = {}}, signal)
end

function signal:Fire(...)
	for _, callback in self.connections do
		_spawn(callback, ...)
	end
end

function signal:Connect(callback)
	local connection = {}
	local connections = self.connections 

	utility.insert(connections, callback)

	function connection:Disconnect()
		utility.remove(connections, callback); connection = nil
	end

	return connection
end

local pixel_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/white_pixel.png")
local shadow = game:HttpGet("https://tr.rbxcdn.com/446dfa2de842ea7bae43c2544f5e12db/420/420/Image/Png")
local sun = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/sun%20(1).png")
local toggle = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/TOGGLE.png")

local font = Drawing.new("Font", "Corbel")
font["Data"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/CORBEL.TTF")


local keybinder = {
    tween_time = os.clock(),
    drawings = {},
    keybinds = {},
    created = false
}

function keybinder:create()
    local background = utility.newDrawing("Image", {
        Rounding = 6,
        Size = vector2new(96,22),
        Data = pixel_image,
        Color = colorfromrgb(0,0,0),
        Position = vector2new(30, workspace.CurrentCamera.ViewportSize.Y/2),
        Transparency = 0.8,
        ZIndex = 12000,
        Visible = false
    })
    local background_shadow = utility.newDrawing("Image", {
        Rounding = 12,
        Size = vector2new(106,28),
        Data = shadow,
        Color = colorfromrgb(176,176,176),
        Position = background.Position - vector2new(5,3),
        Transparency = 0.12,
        ZIndex = 11999,
        Visible = false
    })
    local sun = utility.newDrawing("Image", {
        Position = background.Position + vector2new(3,3),
        Color = colorfromrgb(226,226,226),
        Data = sun,
        Size = vector2new(16,16),
        ZIndex = 12001,
        Visible = false
    })
    local text = utility.newDrawing("Text", {
        Text = "Active Keybinds",
        ZIndex = 12001,
        Color = colorfromrgb(255,255,255),
        Outline = true,
        Font = font,
        Size = 14,
        Visible = false
    })
    background.Size = vector2new(text["TextBounds"]["X"] + 30, 22)
    text["Position"] = background.Position + vector2new(24, 12 - text["TextBounds"]["Y"]/2)

    background_shadow.Size = background.Size + vector2new(10,6)
    background_shadow.Position = background.Position - vector2new(5,3)

    keybinder.drawings = {
        background,
        background_shadow,
        sun,
        text
    }

    keybinder.created = true
end

function keybinder:delete()
    keybinder.tween_time = os.clock() 
    for _, drawing in keybinder.drawings do
        drawing:Destroy()
    end
end

function keybinder:hide()
    if not keybinder.created then
        return end
    
    local old_clock = os.clock()
    local drawings = keybinder.drawings

    keybinder.tween_time = old_clock

    _spawn(LPH_NO_VIRTUALIZE(function()
        while keybinder.tween_time == old_clock and _wait() do
            local time = clamp((os.clock() - old_clock)/0.2, 0, 1)
            
            drawings[1]["Transparency"] = 0.8 + (0-0.8) * time
            drawings[2]["Transparency"] = 0.12 + (0-0.12) * time
            drawings[3]["Transparency"] = 0 + (1-1) * time
            drawings[4]["Transparency"] = 0 + (1-1) * time

            if time >= 1 then
                for i, _ in drawings do
                    _["Visible"] = false
                end
                break
            end
        end
    end))
end

function keybinder:show()
    if not keybinder.created then
        return end
    
    local old_clock = os.clock()
    local drawings = keybinder.drawings

    keybinder.tween_time = old_clock

    for i, _ in drawings do
         _["Transparency"] = 0
         _["Visible"] = true
    end

    _spawn(LPH_NO_VIRTUALIZE(function()
        while keybinder.tween_time == old_clock and _wait() do
            local time = clamp((os.clock() - old_clock)/0.2, 0, 1)
            
            drawings[1]["Transparency"] = 0 + (0.8-0) * time
            drawings[2]["Transparency"] = 0 + (0.12-0) * time
            drawings[3]["Transparency"] = 0 + (1-0) * time
            drawings[4]["Transparency"] = 0 + (1-0) * time

            if time >= 1 then
                break
            end
        end
    end))
end

function keybinder:add(element, name, flag, flag2)
    local keybind = {
        toggle = utility.newDrawing("Image", {
			Size = vector2new(24,24),
			Data = toggle,
			ZIndex = 12001,
			Color = colorfromrgb(255,255,255),
			Visible = true
		}),
		toggle_background = utility.newDrawing("Image", {
			Rounding = 6,
			Size = vector2new(29, 22),
			Data = pixel_image,
			Color = colorfromrgb(0,0,0),
			Transparency = 0.25,
			ZIndex = 12000,
			Visible = true
		}),
		toggle_background_shadow = utility.newDrawing("Image", {
			Rounding = 12,
			Size = vector2new(39,28),
			Data = shadow,
			Color = colorfromrgb(176,176,176),
			Transparency = 0.05,
			ZIndex = 11999,
			Visible = true
		}),
		background = utility.newDrawing("Image", {
			Rounding = 6,
			Size = vector2new(96,22),
			Data = pixel_image,
			Color = colorfromrgb(0,0,0),
			Transparency = 0.25,
			ZIndex = 12000,
			Visible = true
		}),
		background_shadow = utility.newDrawing("Image", {
			Rounding = 12,
			Size = vector2new(106,28),
			Data = shadow,
			Color = colorfromrgb(176,176,176),
			Transparency = 0.05,
			ZIndex = 11999,
			Visible = true
		}),
		text = utility.newDrawing("Text", {
			Text = name,
			ZIndex = 12001,
			Color = colorfromrgb(255,255,255),
			Outline = false,
			Font = font,
			Size = 14,
			Visible = true
		}),
		x = 0,
		y = 0,
        flag = flag,
        flag2 = flag2
    }

	keybind.background.Size = vector2new(keybind.text["TextBounds"]["X"] + 8, 22)

	function keybind:move()
		
	end

    table.insert(keybinder.keybinds, keybind)
end

keybinder:create()
task.wait()
keybinder:show()