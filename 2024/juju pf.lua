if getfflag("DebugRunParallelLuaOnMainThread") ~= "true" and getfflag("DebugRunParallelLuaOnMainThread") ~= true then
	setfflag("DebugRunParallelLuaOnMainThread", "true")
	game:GetService("Players").LocalPlayer:Kick("juju.lol - fflag not active, re-execute when you rejoin (rejoining in 3 secs)")
	task.wait(3)
	game:GetService("TeleportService"):Teleport(game.PlaceId)
	return
end

for _, a in getconnections(game.DescendantAdded) do
	if debug.getinfo(a.Function, "s").source == "=" then
		a:Disconnect()
	end
end

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function(...) return ... end
	LPH_JIT_MAX = function(...) return ... end
	LPH_JIT = function(...) return ... end
	LPH_NO_UPVALUES = function(...) return ... end
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
local cg = game:GetService("CoreGui")
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
local _wait = task.wait
local _spawn = task.spawn
local ignored_folder = workspace.Ignore
local ignored_folder2 = workspace.Terrain
local ignored_folder3 = workspace.Players
local weapon_database = reps.Content.ProductionContent.WeaponDatabase
local controller = {}

local sky = lighting:FindFirstChildOfClass("Sky")

if not sky then
	sky = Instance.new("Sky", lighting)
end

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

local angles = CFrame.Angles
local rad = math.rad
local lower = string.lower
local mathrandom = math.random
	local line_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/line.png")
	local health_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/healthbar.png")
	local ammo_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/ammobar.png")
	local pixel_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/white_pixel.png")
	local gradient_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/gradientbar.png")
	local grenade_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/nade_icon.png")
	local gradient_circle = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/gradient_circle.png")
	local fonts = {
		1,
		2,
		3,
		3
	}

	if identifyexecutor and identifyexecutor() == "Krampus" then
		fonts = {
			{Drawing.new("Font", "Corbel"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/CORBEL.TTF"},
			{Drawing.new("Font", "CorbelBold"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/CORBELB.TTF"},
			{Drawing.new("Font", "Lucon"), "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/LUCON.TTF"},
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
		gun = nil,
		strafe_angle = 0,
		priority = {},
		last_update = os.clock(),
		whitelisted = {},
		hit_chance = 0,
		reduce_horizontal = 0,
		reduce_vertical = 0,
		accuracy = 100,
		deadzone = 0,
		aiming = false
	}

local player_data = {}
local camera = workspace.CurrentCamera
	local wtvp = camera.WorldToViewportPoint
	local raycast = workspace.Raycast

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

	utility.round = function(num, decimals)
		local mult = 10^(decimals or 0)
		return floor(num * mult + 0.5) / mult
	end

	utility.find = function(array, find)
		for _, obj in array do
			if find == obj then return  _ end
		end
	end

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
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not utility.is_dragging_blocked then
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
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
		Radius = 66,
		Thickness = 4,
		ZIndex = 14,
		Color = colorfromrgb(0,0,0),
		NumSides = 33
	}),
	circle = utility.newDrawing("Circle", {
		Filled = false,
		Radius = 66,
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
	do_tp = false,
	silent_aim_fov = 67,
	do_hit = false,
	last_random_update = os.clock(),
	silent_accuracy = vector3new(),
	aim_assist_fov = 67
}

local bounding_box_object = utility.newObject("SelectionBox", {
	LineThickness = 0.01,
	SurfaceColor3 = colorfromrgb(255,255,255),
	SurfaceTransparency = 1,
	Color3 = colorfromrgb(255,255,255),
	Parent = gethui and gethui()
})

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

------------------------------------
-- * Register Folders and Files * --
------------------------------------

local config_location = "juju"

if not isfolder("juju") then
	makefolder("juju")
end

if not isfolder("juju/configs") then
	makefolder("juju/configs")
end

if not isfolder("juju/skins") then
	makefolder("juju/skins")
end

if not isfolder("juju/scripts") then
	makefolder("juju/scripts")
end

if not isfile("juju/data.juju") then
	writefile("juju/data.juju", hs:JSONEncode({menu_size = {658, 558}}))
end

------------
-- * UI * --
------------

local menu = {
	on_closing = signal.new(),
	on_opening = signal.new(),
	on_load = signal.new(),
	toggle = "INSERT",
	busy = false,
	is_open = true,
	flags = {},
	active_keybind = nil,
	active_colorpicker = nil,
	accent_color = colorfromrgb(153, 196, 39),
	on_accent_change = signal.new(),
	blocked = false,
	keybinds = {}
}

local window = {}
window.__index = window
local tab = {}
tab.__index = tab
local section = {}
section.__index = section
local element = {}
element.__index = element

local flags = menu.flags
local isIn = utility.isInUI
local isInFrame = utility.isInFrame
local newObject = utility.newObject
local find = utility.find
local insert = utility.insert
local remove = utility.remove
local round = utility.round
local tween = utility.tween
local length = utility.length

-----------------
-- * Configs * --
-----------------

utility.saveConfig = LPH_NO_VIRTUALIZE(function(name)
	local new_flags = utility.copyTable(flags)
	for flag, info in new_flags do
		if typeof(info) == "Color3" then
			new_flags[flag] = {utility.round(info.R*255, 0), utility.round(info.G*255, 0), utility.round(info.B*255, 0)}
		elseif typeof(info) == "table" and info["key"] then
			new_flags[flag]["key"] = info["key"].Name
		end
	end
	writefile(config_location.."/configs/"..name..".cfg", hs:JSONEncode(new_flags))
end)

utility.loadConfig = LPH_NO_VIRTUALIZE(function(name)
	local config = isfile(config_location.."/configs/"..name..".cfg")

	if not config then
		return end

	config = readfile(config_location.."/configs/"..name..".cfg")

	local config = hs:JSONDecode(config)
	if config then
		for flag, info in config do
			if typeof(info) == "table" then
				if typeof(info[1]) == "number" then
					config[flag] = colorfromrgb(info[1], info[2], info[3])
				elseif info["key"] then
					config[flag]["key"] = info["key"]:find("Mouse") and Enum.UserInputType[info["key"]] or Enum.KeyCode[info["key"]]
				end
			end
			menu.flags[flag] = config[flag]
		end
	end

	return config
end)

utility.getConfigList = LPH_NO_VIRTUALIZE(function()
	local list = {}
	for _, config in listfiles(config_location.."/configs/") do
		utility.insert(list, string.sub(config, #(config_location.."/configs/")+1, #config-4))
	end
	return list
end)

utility.getScriptList = LPH_NO_VIRTUALIZE(function()
	local list = {}
	for _, config in listfiles(config_location.."/scripts/") do
		utility.insert(list, string.sub(config, #(config_location.."/scripts/")+1, #config-4))
	end
	return list
end)


local _screenGui = nil

do
	local shortened_characters = {
		[Enum.KeyCode.LeftShift] = "LSHF",
		[Enum.KeyCode.RightShift] = "RSHF",
		[Enum.UserInputType.MouseButton1] = "M1",
		[Enum.UserInputType.MouseButton2] = "M2",
		[Enum.UserInputType.MouseButton3] = "M3",
		[Enum.KeyCode.ButtonX] = "XB",
		[Enum.KeyCode.ButtonY] = "YB",
		[Enum.KeyCode.ButtonA] = "AB",
		[Enum.KeyCode.ButtonB] = "BB",
		[Enum.KeyCode.ButtonR1] = "R1",
		[Enum.KeyCode.ButtonR2] = "R2",
		[Enum.KeyCode.ButtonR1] = "L1",
		[Enum.KeyCode.ButtonR2] = "L2",
		[Enum.KeyCode.DPadLeft] = "DPL",
		[Enum.KeyCode.DPadRight] = "DPR",
		[Enum.KeyCode.DPadUp] = "DPUP",
		[Enum.KeyCode.DPadDown] = "DPDN",
		[Enum.KeyCode.Thumbstick1] = "TS1",
		[Enum.KeyCode.Thumbstick2] = "TS2",
		[Enum.KeyCode.Delete] = "DEL",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.PageUp] = "PGUP",
		[Enum.KeyCode.PageDown] = "PGDW",
		[Enum.KeyCode.LeftControl] = "LCTR",
		[Enum.KeyCode.RightControl] = "RCTR",
		[Enum.KeyCode.RightAlt] = "RALT",
		[Enum.KeyCode.LeftAlt] = "LALT",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.ScrollLock] = "SLCK",
		[Enum.KeyCode.Backspace] = "BSPC",
		[Enum.KeyCode.Space] = "SPC",
	}

	_screenGui = newObject("ScreenGui", {
		ResetOnSpawn = false;
		Parent = gethui and gethui() or cg
	})

	local KeybindOpen = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(12, 12, 12);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, 0);
		Size = udim2new(0, 100, 0, 0);
		AutomaticSize = Enum.AutomaticSize.Y;
		ZIndex = 25;
		Visible = false;
		Parent = _screenGui	
	})
	local KeybindOpenInside2 = newObject("Frame", {
		Parent = KeybindOpen;
		BackgroundColor3 = colorfromrgb(35, 35, 35);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		AutomaticSize = Enum.AutomaticSize.Y;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 0, 0);
		ZIndex = 25
	})
	local UIListLayout = newObject("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = KeybindOpenInside2
	})
	local AlwaysOn = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 17);
		ZIndex = 25;
		Font = Enum.Font.SourceSans;
		Text = "    Always on";
		TextColor3 = colorfromrgb(205, 205, 205);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = KeybindOpenInside2
	})
	local OnHotkeyLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 17);
		ZIndex = 25;
		Font = Enum.Font.SourceSans;
		Text = "    On hotkey";
		TextColor3 = colorfromrgb(205, 205, 205);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = KeybindOpenInside2
	})
	local ToggleLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 17);
		ZIndex = 25;
		Font = Enum.Font.SourceSans;
		Text = "    Toggle";
		TextColor3 = colorfromrgb(205, 205, 205);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = KeybindOpenInside2
	})

	local counter = 0

	for _, object in KeybindOpenInside2:GetChildren() do
		if object:IsA("TextLabel") then
			counter+=1
			local count = counter

			object.Name = count

			utility.newConnection(object.MouseEnter, function()
				object.BackgroundTransparency = 0
				if flags[menu.active_keybind.flag]["method"] == count then return end
				object.Font = Enum.Font.SourceSansBold
			end)

			utility.newConnection(object.MouseLeave, function()
				object.BackgroundTransparency = 1
				if flags[menu.active_keybind.flag]["method"] == count then return end
				object.Font = Enum.Font.SourceSans
			end)

			utility.newConnection(object.InputBegan, function(input, gpe)
				if gpe then return end
				if flags[menu.active_keybind.flag]["method"] == count then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					menu.active_keybind:setMethod(count)
				end
			end)
		end
	end

	local ColorpickerOpen = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(12, 12, 12);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 180, 0, 175);
		ZIndex = 25;
		Visible = false;
		Parent = _screenGui
	})
	local Inside2 = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(40, 40, 40);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 25;
		Parent = ColorpickerOpen
	})
	local Inside3 = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(23, 23, 23);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 25;
		Parent = Inside2
	})
	local SaturationImage = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(170, 0, 0);
		BorderColor3 = colorfromrgb(13, 13, 13);
		Position = udim2new(0, 3, 0, 3);
		Size = udim2new(0, 150, 0, 150);
		ZIndex = 25;
		Image = "rbxassetid://13966897785";
		Parent = Inside3
	})
	local SaturationMover = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Size = udim2new(0, 4, 0, 4);
		ZIndex = 25;
		Image = "http://www.roblox.com/asset/?id=14138315296";
		Parent = SaturationImage
	})
	local HueFrame = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BorderColor3 = colorfromrgb(13, 13, 13);
		Position = udim2new(1, -20, 0, 3);
		Size = udim2new(0, 17, 0, 150);
		ZIndex = 25;
		Parent = Inside3
	})
	local UIGradient = newObject("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(170, 0, 0)), ColorSequenceKeypoint.new(0.15, colorfromrgb(255, 255, 0)), ColorSequenceKeypoint.new(0.30, colorfromrgb(0, 255, 0)), ColorSequenceKeypoint.new(0.45, colorfromrgb(0, 255, 255)), ColorSequenceKeypoint.new(0.60, colorfromrgb(0, 0, 255)), ColorSequenceKeypoint.new(0.75, colorfromrgb(175, 0, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(170, 0, 0))};
		Rotation = 90;
		Parent = HueFrame
	})
	local HueMover = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 0.6;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 4);
		ZIndex = 25;
		Image = "http://www.roblox.com/asset/?id=14138375431";
		Parent = HueFrame
	})
	local TransparencyFrame = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(226, 226, 226);
		BorderColor3 = colorfromrgb(13, 13, 13);
		Position = udim2new(0, 3, 1, -15);
		Size = udim2new(0, 150, 0, 12);
		ZIndex = 25;
		Parent = Inside3
	})
	local UIGradient2 = newObject("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(155, 155, 155)), ColorSequenceKeypoint.new(1.00, colorfromrgb(155, 155, 155))};
		Rotation = 90;
		Parent = TransparencyFrame
	})
	local TransparencyMover = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -3, 0, 0);
		Size = udim2new(0, 3, 1, 0);
		ZIndex = 25;
		Image = "http://www.roblox.com/asset/?id=14138391128";
		Parent = TransparencyFrame
	})

	local hue, saturation, value = 0, 0, 255

	local color = colorfromrgb(255,255,255)
	local transparency = 0

	local dragging_sat, dragging_hue, dragging_trans = false, false, false

	local function update_sv(val, sat, nocallback)
		saturation = sat
		value = val 
		color = Color3.fromHSV(hue/360, saturation/255, value/255)
		SaturationMover.Position = udim2new(clamp(sat/255, 0, 0.98), 0, 1 - clamp(val/255, 0.02, 1), 0)
		TransparencyFrame.BackgroundColor3 = color
		menu.active_colorpicker:setColor(color, transparency, true)
		menu.active_colorpicker.onColorChange:Fire(color, transparency)
	end

	local function update_hue(hue2)
		SaturationImage.BackgroundColor3 = Color3.fromHSV(hue2/360, 1, 1)
		HueMover.Position = udim2new(0, 0, clamp(hue2/360, 0, 0.99), 0)
		color = Color3.fromHSV(hue2/360, saturation/255, value/255)
		hue = hue2
		TransparencyFrame.BackgroundColor3 = color
		menu.active_colorpicker:setColor(color, transparency, true)
		menu.active_colorpicker.onColorChange:Fire(color, transparency)
	end

	local function update_transparency(o, nocallback)
		TransparencyMover.Position = udim2new(clamp(1 - o, 0, 0.98), 0, 0, 0)
		transparency = o
		local color2 = 155 * (1-(transparency*0.5))
		UIGradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(color2, color2, color2)), ColorSequenceKeypoint.new(1.00, colorfromrgb(color2, color2, color2))};
		menu.active_colorpicker:setColor(color, transparency, true)
		menu.active_colorpicker.onColorChange:Fire(color, transparency)
	end

	local mouse_connection = nil

	utility.newConnection(SaturationImage.InputBegan, function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
			local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
			local sat = 255 * xdistance
			local val = 255 * ydistance
			update_sv(val, sat)
			dragging_sat = true
			mouse_connection = utility.newConnection(mouse.Move, function()
				local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
				local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
				local sat = 255 * xdistance
				local val = 255 * ydistance
				update_sv(val, sat)
			end, true)
		end
	end)

	utility.newConnection(SaturationImage.InputEnded, function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging_sat then
			dragging_sat = false
			mouse_connection:Disconnect()
		end
	end)

	utility.newConnection(HueFrame.InputBegan, function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
			local hue = 360 * xdistance
			update_hue(hue)
			dragging_hue = true
			mouse_connection = utility.newConnection(mouse.Move, function()
				local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
				local hue = 360 * xdistance
				update_hue(hue)
			end, true)
		end
	end)

	utility.newConnection(HueFrame.InputEnded, function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging_hue then
			dragging_hue = false
			mouse_connection:Disconnect()
		end
	end)

	utility.newConnection(TransparencyFrame.InputBegan, function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
			update_transparency(1 - 1 * xdistance)
			dragging_trans = true
			mouse_connection = utility.newConnection(mouse.Move, function()
				local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
				update_transparency(1 - 1 * xdistance)
			end, true)
		end
	end)

	utility.newConnection(TransparencyFrame.InputEnded, function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging_trans then
			dragging_trans = false
			mouse_connection:Disconnect()
		end
	end)

	function menu:set_accent_color(color)
		menu.accent_color = color
		menu.on_accent_change:Fire(color)
	end

	function menu:init(tabs, selected_tab)
		local Border = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(60, 60, 60);
			BorderColor3 = colorfromrgb(12, 12, 12);
			Position = udim2new(0, 500, 0, 300);
			Size = udim2new(0, 658, 0, 558);
			Parent = _screenGui
		})
		local Border2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(40, 40, 40);
			Position = udim2new(0, 2, 0, 2);
			Size = udim2new(1, -4, 1, -4);
			Parent = Border;
		})
		local Background = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(60, 60, 60);
			Position = udim2new(0, 3, 0, 3);
			Size = udim2new(1, -6, 1, -6);
			Image = "rbxassetid://15453092054";
			ScaleType = Enum.ScaleType.Tile;
			TileSize = udim2new(0, 4, 0, 548);
			Parent = Border2
		})
		local TabHolder = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, 14);
			Size = udim2new(0, 73, 0, 0);
			Parent = Background
		})
		local TabLayout = newObject("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Parent = TabHolder
		})
		local TopGap = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0, 73, 0, 14);
			Parent = Background
		})
		local TopSideFix = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 73, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = TopGap
		})
		local TopSideFix2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, 0, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = TopSideFix
		})
		local BottomGap = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 1, -22);
			Size = udim2new(0, 73, 0, 22);
			Parent = Background
		})
		local BottomSideFix = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 73, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = BottomGap
		})
		local BottomSideFix2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, 0, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = BottomSideFix
		})
		local TopBar_2 = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(12, 12, 12);
			Position = udim2new(0, 1, 0, 1);
			BackgroundTransparency = 1;
			Size = udim2new(1, -2, 0, 2);
			ZIndex = 2;
			Image = "rbxassetid://15453122383";
			Parent = Background
		})
		local BlackBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(6, 6, 6);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 1, 0);
			Size = udim2new(1, 0, 0, 1);
			ZIndex = 2;
			Parent = TopBar_2
		})
		local Dragger = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -6, 1, -6);
			Size = udim2new(0, 6, 0, 6);
			BackgroundTransparency = 1;
			Visible = true;
			Parent = Border
		})

		local isDragging = false

		utility.newConnection(Dragger.InputBegan, function(input, gpe)
			if gpe then return end
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not menu.busy then
				local startPosition = uis:GetMouseLocation()
				local oldSize = Border.Size
				isDragging = true
				utility.is_dragging_blocked = true
				_spawn(function()
					while isDragging do
						local change = uis:GetMouseLocation()-(Border.AbsolutePosition + Border.AbsoluteSize + vector2new(0,36))
						Border.Size = udim2new(0, clamp(oldSize.X.Offset + change.X, 658, 5000), 0, clamp(oldSize.Y.Offset + change.Y, 558, 5000))
						oldSize = Border.Size
						startPosition = (Border.AbsolutePosition + Border.AbsoluteSize)
						BottomGap.Size = udim2new(0, 73, 0, 22 + Border.Size.Y.Offset-558)
						BottomGap.Position = udim2new(0, 0, 1, -BottomGap.Size.Y.Offset)
						_wait()
					end
				end)
			end
		end)	

		utility.newConnection(Dragger.InputEnded, function(input, gpe)
			if gpe then return end
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				if isDragging then isDragging = false; utility.is_dragging_blocked = false end
			end
		end)

		utility.setDraggable(Border)

		local new_window = {
			tab_holder = TabHolder,
			active_tab = nil,
			background = Background,
			tabs = {}
		}

		utility.newConnection(Border:GetPropertyChangedSignal("BackgroundTransparency"), function()
			if not menu.blocked then
				_screenGui.Enabled = Border.BackgroundTransparency ~= 1
				menu.is_open = _screenGui.Enabled
			end
		end)

		utility.newConnection(menu.on_closing, function()
			tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Border2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Background, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(TabHolder, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopGap, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopSideFix, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopSideFix2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomGap, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomSideFix, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomSideFix2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopBar_2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(BlackBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Border2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Background, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(TabHolder, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopGap, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopSideFix, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopSideFix2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomGap, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomSideFix, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomSideFix2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopBar_2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(BlackBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
		end, true)

		utility.newConnection(Background:GetPropertyChangedSignal("ImageTransparency"), function()
			Background.BackgroundTransparency = Background.ImageTransparency == 0 and 0 or 1
		end)

		setmetatable(new_window, window)

		local window_tabs = new_window.tabs
		local is_first_tab = true

		for int = 1, 8 do
			new_window:_registerTab(int, tabs[int], int == selected_tab)
		end

		return new_window
	end

	function window:_registerTab(int, info, is_first_tab)
		local new_tab = {
			sections = {},
			is_open = false
		}

		local Button = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0, 73, 0, 64);
			Parent = self.tab_holder
		})
		local BottomBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 1, 1);
			Size = udim2new(1, 0, 0, 1);
			Visible = false;
			ZIndex = 2;
			Parent = Button
		})
		local BottomBar2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, -1);
			Size = udim2new(1, 2, 1, 0);
			ZIndex = 2;
			Parent = BottomBar
		})
		local Icon = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, 0, 1, 0);
			Image = info.icon;
			ImageColor3 = colorfromrgb(109, 109, 109);
			Parent = Button
		})
		local TopBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, -2);
			Size = udim2new(1, 0, 0, 1);
			Visible = false;
			ZIndex = 2;
			Parent = Button
		})
		local TopBar2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, 1);
			Size = udim2new(1, 2, 1, 0);
			ZIndex = 2;
			Parent = TopBar
		})
		local SideBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 73, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = Button
		})
		local SideBar2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, 0, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = SideBar    
		})

		local _Tab = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 96, 0, 23);
			Size = udim2new(1, -115, 1, -43);
			Visible = false;
			Parent = self.background
		})

		utility.newConnection(menu.on_closing, function()
			tween(Button, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomBar2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(SideBar2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(SideBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopBar2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Icon, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			tween(Button, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = self.active_tab == int and 1 or 0})
			tween(BottomBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomBar2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(SideBar2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(SideBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopBar2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopBar, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Icon, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
		end, true)

		utility.newConnection(Button.InputBegan, function(input, gpe)
			if gpe then return end
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 then
				if self.active_tab == int then return end
				self:_setActiveTab(int)
			end
		end)

		utility.newConnection(Button.MouseEnter, function()
			if self.active_tab == int then return end
			Icon.ImageColor3 = colorfromrgb(204, 204, 204)
		end)

		utility.newConnection(Button.MouseLeave, function()
			if self.active_tab == int then return end
			Icon.ImageColor3 = colorfromrgb(109, 109, 109)
		end)

		new_tab.button = Button
		new_tab.icon = Icon
		new_tab.bottom_bar = BottomBar
		new_tab.top_bar = TopBar
		new_tab.side_bar = SideBar
		new_tab.frame = _Tab

		setmetatable(new_tab, tab)

		self.tabs[int] = new_tab

		if is_first_tab then self:_setActiveTab(int) end

		return new_tab
	end

	function window:_setActiveTab(int)
		self.active_tab = int

		local tabs = self.tabs
		for _int = 1, 8 do
			local tab = tabs[_int]
			if not tab then continue end -- // no better way to do it!! frick
			local is_active_tab = int == _int
			tab.icon.ImageColor3 = is_active_tab and colorfromrgb(255,255,255) or colorfromrgb(109,109,109)
			tab.bottom_bar.Visible = is_active_tab
			tab.top_bar.Visible = is_active_tab
			tab.side_bar.Visible = not is_active_tab
			tab.button.BackgroundTransparency = is_active_tab and 1 or 0
			tab.frame.Visible = is_active_tab
		end
	end

	function window:getTab(int)
		return self.tabs[int]
	end

	function tab:newSection(info)
		local Section = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0.5, -9, info.scale, -9);
			Position = udim2new(info.x, 0, info.y, 0);
			BackgroundTransparency = 1;
			Parent = self.frame
		})
		local Inside = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, 0, 1, -1);
			Parent = Section
		})
		local Inside2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 1, 0, 0);
			Size = udim2new(1, -2, 1, -1);
			Parent = Inside
		})
		local Inside3 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(23, 23, 23);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 1, 0, 0);
			Size = udim2new(1, -2, 1, -1);
			Parent = Inside2
		})
		local SectionLabel = newObject("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 12, 0, -2);
			Font = Enum.Font.SourceSansBold;
			Text = info.name;
			TextColor3 = colorfromrgb(198, 198, 198);
			TextSize = 13.000;
			TextXAlignment = Enum.TextXAlignment.Left;
			ZIndex = 4;
			Parent = Inside3
		})
		local TopLine = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0, 9, 0, 1);
			Parent = Inside3
		})
		local TopLine2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, -2, 0, -1);
			Size = udim2new(1, 2, 0, 1);
			Parent = TopLine
		})
		local ArrowUp = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -16, 0, 5);
			Size = udim2new(0, 5, 0, 4);
			Image = "rbxassetid://15540851994";
			ImageTransparency = 1;
			ZIndex = 3;
			Visible = false;
			Parent = Inside3
		})
		local ArrowDown = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -16, 1, -9);
			Size = udim2new(0, 5, 0, 4);
			Visible = false;
			ZIndex = 3;
			Image = "rbxassetid://15540867448";
			ImageTransparency = 1;
			Parent = Inside3
		})
		local BottomShadow = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 1, 1, -20);
			Size = udim2new(1, -2, 0, 20);
			Image = "rbxassetid://15541064478";
			ImageColor3 = colorfromrgb(23, 23, 23);
			ZIndex = 2;
			Parent = Inside3
		})
		local TopShadow = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Rotation = 180.000;
			Position = udim2new(0, 1, 0, 2);
			Size = udim2new(1, -2, 0, 20);
			Image = "rbxassetid://15541064478";
			ImageColor3 = colorfromrgb(23, 23, 23);
			ZIndex = 2;
			Parent = Inside3
		})
		local ScrollBackground = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -6, 0, 0);
			Size = udim2new(0, 6, 1, 0);
			Visible = false;
			ZIndex = 2;
			Parent = Inside3
		})
		local Scroller = newObject("ScrollingFrame", {
			Active = false;
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, 2);
			Selectable = false;
			ScrollingEnabled = false;
			Size = udim2new(1, 0, 1, -2);
			ZIndex = 3;
			BottomImage = "rbxassetid://15540816491";
			CanvasPosition = vector2new(0, 0);
			CanvasSize = udim2new(0, 0, 1, 0);
			MidImage = "rbxassetid://15540816491";
			ScrollBarImageTransparency = 1;
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
			ScrollBarImageColor3 = colorfromrgb(65, 65, 65);
			ScrollBarThickness = 5;
			TopImage = "rbxassetid://15540816491";
			ClipsDescendants = true;
			Parent = Inside3
		})
		local ElementHolder = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 18, 0, 18);
			Size = udim2new(1, -36, 0, 0);
			AutomaticSize = Enum.AutomaticSize.Y;
			Parent = Scroller
		})
		local UIListLayout = newObject("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 10);
			Parent = ElementHolder
		})

		local size = ts:GetTextSize(info.name, 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).x

		local _TopLine = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, -(size + 16), 0, 1);
			Position = udim2new(0, size + 16, 0, 0);
			Parent = Inside3
		})
		local _TopLine2 = newObject("Frame", {	
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, -1);
			Size = udim2new(1, 2, 0, 1);
			Parent = _TopLine
		})
		local _Frame = newObject("Frame", {
			Parent = nil;
			Size = udim2new(1,0,0,4);
			Visible = true;
			BackgroundTransparency = 1
		})
		local DragImage = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			ImageColor3 = colorfromrgb(40, 40, 40);
			BorderSizePixel = 0;
			Position = udim2new(1, -5, 1, -5);
			Size = udim2new(0, 5, 0, 5);
			Image = "rbxassetid://15528648404";
			ZIndex = 99;
			Parent = Inside3
		})

		utility.newConnection(menu.on_closing, function()
			if not self.frame.Visible then return end
			tween(_TopLine2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(_TopLine, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(ScrollBackground, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Scroller, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 1})
			tween(TopShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(BottomShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(ArrowUp, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(ArrowDown, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(TopLine2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopLine, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Inside3, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(SectionLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
			tween(DragImage, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			if not self.frame.Visible then return end
			tween(_TopLine2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(_TopLine, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Scroller, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = Scroller.ScrollingEnabled and 0 or 1})
			tween(TopShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(BottomShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
				tween(ArrowUp, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			else
				tween(ArrowDown, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			end
			tween(TopLine2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopLine, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Inside3, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(SectionLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
			tween(DragImage, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
		end, true)

		local function updateSize()
			local wholeSectionSize = Section.AbsoluteSize - vector2new(0, 40)
			if ElementHolder.AbsoluteSize.Y > wholeSectionSize.Y then
				Scroller.CanvasSize = udim2new(0, 0, 1, 0)
				Scroller.ScrollingEnabled = true
				Scroller.ScrollBarImageTransparency = 0
				ScrollBackground.Visible = true
				ArrowUp.Visible = true
				ArrowDown.Visible = true
				BottomShadow.Visible = true; TopShadow.Visible = true
				_Frame.Parent = ElementHolder
			else
				_Frame.Parent = nil
				Scroller.ScrollingEnabled = false
				Scroller.ScrollBarImageTransparency = 1
				ScrollBackground.Visible = false
				ArrowUp.Visible = false
				ArrowDown.Visible = false
				BottomShadow.Visible = false; TopShadow.Visible = false
			end 
		end

		utility.newConnection(ArrowUp.InputBegan, function(input, gpe)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				Scroller.CanvasPosition.Y = UDim.new(0,0)
			end
		end)

		utility.newConnection(ArrowDown.InputBegan, function(input, gpe)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				Scroller.CanvasPosition = Udim.new(0,Scroller.AbsoluteCanvasSize.Y)
			end
		end)

		utility.newConnection(_TopLine:GetPropertyChangedSignal("AbsoluteSize"), function()
			_TopLine.Visible = _TopLine.AbsoluteSize.X > 0 and true or false
		end)

		utility.newConnection(Scroller:GetPropertyChangedSignal("CanvasPosition"), function()
			if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
				ArrowUp.ImageTransparency = 0
				ArrowDown.ImageTransparency = 1
			else
				ArrowUp.ImageTransparency = 1
				ArrowDown.ImageTransparency = 0
			end
		end)

		local new_section = {
			tab_frame = self.frame;
			element_holder = ElementHolder;
			elements = {};
			frame = Section
		}

		setmetatable(new_section, section)

		utility.newConnection(Section:GetPropertyChangedSignal("Size"), updateSize)

		utility.newConnection(ElementHolder:GetPropertyChangedSignal("AbsoluteSize"), updateSize)

		if info.is_changeable then
			local Frame = self.frame

			local isMoving = false
			local isDragging = false
			local oldSize = nil

			utility.newConnection(DragImage.InputBegan, function(input, gpe)
				if gpe then return end
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not menu.busy then
					local mouseLocation = uis:GetMouseLocation()
					if not isDragging then
						isDragging = true
						Inside2.BackgroundColor3 = menu.accent_color
						_TopLine.BackgroundColor3 = menu.accent_color
						TopLine.BackgroundColor3 = menu.accent_color
						DragImage.ImageColor3 = menu.accent_color
						utility.is_dragging_blocked = true
						_spawn(function()
							while isDragging do
								local minimumXDistance = Frame.AbsoluteSize.X/20
								local minimumYDistance = Frame.AbsoluteSize.Y/20
								local _mouseLocation = uis:GetMouseLocation()
								local difference = (Section.AbsolutePosition + Section.AbsoluteSize)
								local xDifference = _mouseLocation.X - difference.X
								local yDifference = _mouseLocation.Y - 36 - difference.Y
								if math.abs(xDifference) > minimumXDistance or math.abs(yDifference) > minimumYDistance then
									local xAdd = math.round(xDifference/minimumXDistance)
									local yAdd = math.round(yDifference/minimumYDistance)
									oldSize = Section.Size
									Section.Size = udim2new(clamp(Section.Size.X.Scale + xAdd * 0.05, 0.1, 1), Section.Size.X.Offset, clamp(Section.Size.Y.Scale + yAdd * 0.05, 0.05, 1), Section.Size.Y.Offset)
									if not isInFrame(self.frame, Section.AbsolutePosition + Section.AbsoluteSize) then Section.Size = oldSize end
								end
								_wait()
							end
						end)
					end
				end
			end)

			utility.newConnection(Section.InputBegan, function(input, gpe)
				if gpe then return end
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not menu.busy then
					local absolutePosition = SectionLabel.AbsolutePosition
					local mouseLocation = uis:GetMouseLocation()
					if mouseLocation.Y - absolutePosition.Y < 52 then
						isMoving = true
						utility.is_dragging_blocked = true
						SectionLabel.TextColor3 = menu.accent_color

						_spawn(function()
							while isMoving do
								local minimumXDistance = Frame.AbsoluteSize.X/20
								local minimumYDistance = Frame.AbsoluteSize.Y/20
								local _mouseLocation = uis:GetMouseLocation()
								local xDifference = _mouseLocation.X - mouseLocation.X
								local yDifference = _mouseLocation.Y - mouseLocation.Y
								local oldPosition = Section.Position
								if math.abs(xDifference) > minimumXDistance or math.abs(yDifference) > minimumYDistance then
									local xAdd = math.round(xDifference/minimumXDistance)
									local yAdd = math.round(yDifference/minimumYDistance)
									absolutePosition = SectionLabel.AbsolutePosition
									mouseLocation = uis:GetMouseLocation()
									Section.Position = udim2new(clamp(Section.Position.X.Scale + xAdd * 0.05, 0, 1), Section.Position.X.Offset, clamp(Section.Position.Y.Scale + yAdd * 0.05, 0, 1), Section.Position.Y.Offset)
									for _, section in self.sections do
										if section.frame == Section then continue end
										if isIn(section.frame, Section) then
											local oldSize = section.frame.Size
											local _oldPosition = section.frame.Position
											section.frame.Position = oldPosition
											section.frame.Size = Section.Size
											Section.Size = oldSize
											Section.Position = _oldPosition
											continue
										end
									end
									if not isInFrame(self.frame, Section.AbsolutePosition + Section.AbsoluteSize) then Section.Position = oldPosition end
								end
								_wait()
							end
						end)
					end
				end
			end)

			utility.newConnection(DragImage.InputEnded, function(input, gpe)
				if gpe then return end
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					if isDragging then isDragging = false; utility.is_dragging_blocked = false; Inside2.BackgroundColor3 = colorfromrgb(40,40,40); TopLine.BackgroundColor3 = colorfromrgb(40,40,40); _TopLine.BackgroundColor3 = colorfromrgb(40, 40, 40); DragImage.ImageColor3 = colorfromrgb(40, 40, 40) end
				end
			end)

			utility.newConnection(Section.InputEnded, function(input, gpe)
				if gpe then return end
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					if isMoving then isMoving = false; utility.is_dragging_blocked = false; SectionLabel.TextColor3 = colorfromrgb(198, 198, 198) end
				end
			end)
		end

		self.sections[info.name] = new_section

		return new_section
	end

	function section:newElement(info)
		local Frame = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, 0, 0, 8);
			Parent = self.element_holder	
		})
		local Label = newObject("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 20, 0, -1);
			Size = udim2new(0.5, 0, 0, 8);
			Font = Enum.Font.SourceSans;
			Text = info.name;
			TextColor3 = info.highlighted == true and colorfromrgb(182, 182, 101) or colorfromrgb(205, 205, 205);
			TextSize = 13.000;
			TextXAlignment = Enum.TextXAlignment.Left;
			Parent = Frame
		})

		local new_element = {
			frame = Frame
		}

		local tab_frame = self.tab_frame

		setmetatable(new_element, element)

		function new_element:Destroy()
			Frame:Destroy()
			new_element = nil
		end

		for _element, _info in info.types do
			if lower(_element) == "toggle" then
				local Box = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 8, 0, 8);
					Parent = Frame
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(77, 77, 77);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = Box
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(218, 218, 218))};
					Rotation = 90;
					Parent = Inside
				})

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(Box, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Label, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Box, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Label, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
				end, true)

				local h,s,v = menu.accent_color:ToHSV()

				new_element.onToggleChange = signal.new()

				new_element.toggled = false

				flags[_info.flag] = false

				utility.newConnection(menu.on_accent_change, function(color)
					h,s,v = color:ToHSV()
					if new_element.toggled then
						Inside.BackgroundColor3 = color
					end
				end)

				local function onHover()
					Inside.BackgroundColor3 = new_element.toggled == true and Color3.fromHSV(h,s,v*1.1) or colorfromrgb(85,85,85)
				end

				local function onLeave()
					Inside.BackgroundColor3 = new_element.toggled == true and menu.accent_color or colorfromrgb(77,77,77)
				end

				local function onClick(input, gpe)
					if gpe then return end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not menu.busy then
						new_element:setToggle(not new_element.toggled)
					end
				end

				local last_bool = _info.default

				function new_element:setToggle(bool, dont)
					if last_bool ~= bool or dont then
						new_element.onToggleChange:Fire(bool)
					end
					last_bool = bool
					Inside.BackgroundColor3 = bool and menu.accent_color or colorfromrgb(77,77,77)
					new_element.toggled = bool
					flags[_info.flag] = bool
				end

				new_element:setToggle(_info.default or false)

				utility.newConnection(Label.InputEnded, onClick)
				utility.newConnection(Box.InputEnded, onClick)
				utility.newConnection(Box.MouseEnter, onHover)
				utility.newConnection(Label.MouseEnter, onHover)
				utility.newConnection(Box.MouseLeave, onLeave)
				utility.newConnection(Label.MouseLeave, onLeave)

				if not _info.no_load then
					utility.newConnection(menu.on_load, function()
						new_element:setToggle(flags[_info.flag])
					end, true)
				end
			elseif lower(_element) == "dropdown" then
				Frame.Size = udim2new(1,0,0,31)
				local Border = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 11);
					Size = udim2new(0.72, 0, 0, 20);
					Parent = Frame
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					MaxSize = vector2new(200, 9e9);
					Parent = Border
				})
				local _Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = Border
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(31, 31, 31)), ColorSequenceKeypoint.new(1.00, colorfromrgb(36, 36, 36))};
					Rotation = 90;
					Parent = _Inside
				})
				local DropdownLabel = newObject("TextLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 6, 0, 0);
					Size = udim2new(1, -24, 1, 0);
					Font = Enum.Font.SourceSans;
					Text = "-";
					TextColor3 = colorfromrgb(152, 152, 152);
					TextSize = 13.000;
					TextWrapped = true;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = _Inside
				})
				local Arrow = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -11, 0, 6);
					Size = udim2new(0, 5, 0, 4);
					Image = "rbxassetid://15556784588";
					ImageColor3 = colorfromrgb(151, 151, 151);
					Parent = _Inside
				})
				local DropdownOpen = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 11);
					Size = udim2new(0, 156, 0, 20);
					AutomaticSize = Enum.AutomaticSize.Y;
					Visible = false;
					ZIndex = 10;
					Parent = _screenGui
				})
				local OpenInside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(35, 35, 35);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					ZIndex = 10;
					Parent = DropdownOpen
				})
				local UIListLayout = newObject("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Parent = OpenInside
				})

				local isOpen = false

				local function onHover()
					if isOpen then return end
					Arrow.ImageColor3 = colorfromrgb(156, 156, 156)
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(41, 41, 41)), ColorSequenceKeypoint.new(1.00, colorfromrgb(46, 46, 46))};
				end

				local function onLeave()
					if isOpen then return end
					Arrow.ImageColor3 = colorfromrgb(151, 151, 151)
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(31, 31, 31)), ColorSequenceKeypoint.new(1.00, colorfromrgb(36, 36, 36))};
				end

				local clickOutConnection = nil

				new_element.onDropdownChange = signal.new()
				function new_element:setDropdownVisiblity(bool)
					Frame.Size = bool and udim2new(1,0,0,31) or udim2new(1,0,0,8)
					Border.Visible = bool
				end

				local function closeDropdown(isOnBorder)
					clickOutConnection:Disconnect()
					DropdownOpen.Visible = false

					task.delay(0, function()
						isOpen = false
						menu.busy = false
						utility.is_dragging_blocked = false	
					end)
	
					if isOnBorder then onHover() else onLeave() end
				end

				local function openDropdown()
					local newPosition = Border.AbsolutePosition
					DropdownOpen.Size = udim2new(0, Border.AbsoluteSize.X, 0, 20)
					DropdownOpen.Position = udim2new(0, newPosition.X, 0, newPosition.Y + 2 + Border.AbsoluteSize.Y)
					DropdownOpen.Visible = true

					clickOutConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
						if gpe then return end
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							local pos = input.Position
							if not isInFrame(Border, pos) and not isInFrame(DropdownOpen, pos) then closeDropdown() end
						end
					end), true)

					isOpen = true; menu.busy = true; utility.is_dragging_blocked = true
				end

				function new_element:setSelected(options)
					local string = ""
					for _, label in OpenInside:GetChildren() do
						if label.ClassName ~= "TextLabel" then 
							continue end
						local option = label.Name
						if find(options, option) then
							string = #string == 0 and option or string..", "..option
							label.Font = Enum.Font.SourceSansBold
							label.TextColor3 = menu.accent_color
						else
							label.Font = Enum.Font.SourceSans
							label.TextColor3 = colorfromrgb(208, 208, 208)
						end
					end
					DropdownLabel.Text = string == "" and "-" or string
					new_element.onDropdownChange:Fire(options)
					flags[_info.flag] = options
				end

				utility.newConnection(menu.on_accent_change, function(color)
					for _, label in OpenInside:GetChildren() do
						if label.ClassName ~= "TextLabel" then 
							continue end
						local option = label.Name
						if find(flags[_info.flag], option) then
							label.TextColor3 = menu.accent_color
						end
					end
				end)

				flags[_info.flag] = {}

				do
					for _, option in _info.options do
						local DropdownOption = newObject("TextLabel", {
							BackgroundColor3 = colorfromrgb(25, 25, 25);
							BackgroundTransparency = 1.000;
							BorderColor3 = colorfromrgb(0, 0, 0);
							BorderSizePixel = 0;
							Size = udim2new(1, 0, 0, 20);
							ZIndex = 11;
							Font = Enum.Font.SourceSans;
							Text = "   "..option;
							TextColor3 = colorfromrgb(208, 208, 208);
							TextSize = 13.000;
							TextXAlignment = Enum.TextXAlignment.Left;
							Parent = OpenInside
						}); DropdownOption.Name = option

						if _info.multi then
							utility.newConnection(DropdownOption.MouseEnter, function()
								DropdownOption.BackgroundTransparency = 0
							end)

							utility.newConnection(DropdownOption.MouseLeave, function()
								DropdownOption.BackgroundTransparency = 1
							end)

							utility.newConnection(DropdownOption.InputBegan, function(input, gpe)
								if gpe then return end
								if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
									if not find(flags[_info.flag], option) then 
										insert(flags[_info.flag], option)
									else
										if _info.no_none and length(flags[_info.flag]) == 1 then return end
										remove(flags[_info.flag], option)
									end
									new_element:setSelected(flags[_info.flag])
								end
							end)
						else
							utility.newConnection(DropdownOption.MouseEnter, function()
								DropdownOption.BackgroundTransparency = 0
								if flags[_info.flag][1] == option then return end
								DropdownOption.Font = Enum.Font.SourceSansBold
							end)

							utility.newConnection(DropdownOption.MouseLeave, function()
								DropdownOption.BackgroundTransparency = 1
								if flags[_info.flag][1] == option then return end
								DropdownOption.Font = Enum.Font.SourceSans
							end)

							utility.newConnection(DropdownOption.InputBegan, function(input, gpe)
								if gpe then return end
								if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
									if _info.no_none and find(flags[_info.flag], option) then return end
									flags[_info.flag] = find(flags[_info.flag], option) and nil or {option}
									new_element:setSelected(flags[_info.flag])
									closeDropdown()
								end
							end)
						end
					end
				end

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(Label, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(_Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(DropdownLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Arrow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
					if isOpen then closeDropdown() end
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Label, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(_Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(DropdownLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Arrow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
				end, true)

				utility.newConnection(Border.MouseEnter, onHover)
				utility.newConnection(Border.MouseLeave, onLeave)

				utility.newConnection(Border.InputEnded, function(input, gpe)
					if gpe then return end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						if not menu.busy then
							openDropdown()
						elseif isOpen then
							closeDropdown(true)
						end
					end
				end)

				new_element:setSelected(_info.default ~= nil and _info.default or {})

				if not _info.no_load then
					utility.newConnection(menu.on_load, function()
						new_element:setSelected(flags[_info.flag])
					end, true)
				end
			elseif lower(_element) == "slider" then
				Frame.Size = udim2new(1,0,0,20)
				local Border = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 13);
					Size = udim2new(0.72, 0, 0, 7);
					Parent = Frame
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					MaxSize = vector2new(200, 9e9);
					Parent = Border
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = Border
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(51, 51, 51)), ColorSequenceKeypoint.new(1.00, colorfromrgb(71, 71, 71))};
					Rotation = 90;
					Parent = Inside
				})
				local Fill = newObject("Frame", {
					BackgroundColor3 = menu.accent_color;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 0, 1, 0);
					Parent = Inside
				})
				local UIGradient_2 = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(249, 249, 249)), ColorSequenceKeypoint.new(1.00, colorfromrgb(201, 201, 201))};
					Rotation = 90;
					Parent = Fill
				})
				local ValueLabel = newObject("TextBox", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -1, 0, 5);
					Font = Enum.Font.SourceSansBold;
					Text = _info.prefix.._info.min.._info.suffix;
					TextColor3 = colorfromrgb(205, 205, 205);
					TextSize = 13.000;
					ClearTextOnFocus = true;
					TextStrokeTransparency = 0.000;
					Parent = Fill
				})
				local Down = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, -7, 0, 2);
					Size = udim2new(0, 3, 0, 3);
					Image = "rbxassetid://15582036409";
					Visible = _info.changers and true or false;
					Parent = Border	
				})
				local Up = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, 4, 0, 2);
					Size = udim2new(0, 3, 0, 3);
					Image = "rbxassetid://15582024931";
					Visible = _info.changers and true or false;
					Parent = Border
				})
				
				utility.newConnection(ValueLabel.FocusLost, function()
					local value = tonumber(ValueLabel.Text) or _info.min
					new_element:setValue(value)
				end, true)

				utility.newConnection(menu.on_accent_change, function(color)
					Fill.BackgroundColor3 = color
				end)

				flags[_info.flag] = _info.min

				new_element.onSliderChange = signal.new()

				local mouseConnection = nil
				local dragging = false

				function new_element:changeSliderVisiblity(bool)
					Frame.Size = bool and udim2new(1,0,0,20) or udim2new(1,0,0,8)
					Border.Visible = bool
				end

				function new_element:setValue(value)
					local value = clamp(value, _info.min, _info.max)
					Fill.Size = udim2new((value - _info.min)/(_info.max-_info.min), 0, 1, 0)
					ValueLabel.Text = _info.prefix..value.._info.suffix
					ValueLabel.Size = udim2new(0, ts:GetTextSize(tostring(value), 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).X, 0, 13)
					ValueLabel.Position = udim2new(1, -ts:GetTextSize(tostring(value), 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).X/2, 0, 0)
					if _info.min == value and _info.min_text then
						ValueLabel.Text = _info.min_text
					end
					flags[_info.flag] = value
					if _info.changers then
						Down.Visible = value > _info.min
						Up.Visible = value < _info.max
					end 
					new_element.onSliderChange:Fire(value)		
				end

				if _info.changers then
					utility.newConnection(Down.InputBegan, function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							new_element:setValue(round(flags[_info.flag]-_info.changers, _info.decimal))
						end
					end)

					utility.newConnection(Up.InputBegan, function(input)
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							new_element:setValue(flags[_info.flag]+_info.changers, _info.decimal)
						end
					end)
				end

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(Label, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Fill, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(ValueLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Down, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
					tween(Up, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
					if dragging then
						utility.is_dragging_blocked = false 
						dragging = false
					end
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Label, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Fill, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(ValueLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Down, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
					tween(Up, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
				end, true)

				utility.newConnection(Inside.InputBegan, function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not menu.busy then
						utility.is_dragging_blocked = true 
						local distance = clamp((input.Position.X - Inside.AbsolutePosition.X)/Inside.AbsoluteSize.X, 0, 1)
						local value = round(_info.min + (_info.max - _info.min) * distance, _info.decimal and _info.decimal or 0)
						new_element:setValue(value)

						mouseConnection = utility.newConnection(mouse.Move, function()
							if dragging then
								local distance = clamp((mouse.X - Inside.AbsolutePosition.X)/Inside.AbsoluteSize.X, 0, 1)
								local value = round(_info.min + (_info.max-_info.min) * distance, _info.decimal and _info.decimal or 0)
								new_element:setValue(value)
							else
								mouseConnection:Disconnect()
							end
						end, true)

						dragging = true
					end
				end)

				utility.newConnection(Inside.InputEnded, function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragging then
						utility.is_dragging_blocked = false 
						dragging = false
					end
				end)

				utility.newConnection(Inside.MouseEnter, function()
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(61, 61, 61)), ColorSequenceKeypoint.new(1.00, colorfromrgb(76, 76, 76))}
				end)

				utility.newConnection(Inside.MouseLeave, function()
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(51, 51, 51)), ColorSequenceKeypoint.new(1.00, colorfromrgb(71, 71, 71))}
				end)

				new_element:setValue(_info.default or _info.min)

				utility.newConnection(menu.on_load, function()
					new_element:setValue(flags[_info.flag])
				end, true)
			elseif lower(_element) == "colorpicker" then
				local ColorBox = newObject("Frame", {
					AnchorPoint = vector2new(1, 0);
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, 0, 0, 0);
					Size = udim2new(0, 17, 0, 8);
					Parent = Frame
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = ColorBox
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(218, 218, 218))};
					Rotation = 90;
					Parent = Inside
				})

				local isOpen = false

				new_element.onColorChange = signal.new()

				flags[_info.flag] = _info.default
				flags[_info.transparency_flag] = _info.default_transparency

				new_element.flag = _info.flag
				new_element.transparency_flag = _info.transparency_flag

				function new_element:setColorpickerVisibility(bool)
					ColorBox.Visible = bool
				end

				local clickOutConnection = nil

				local function closeColorpicker()
					clickOutConnection:Disconnect()
					ColorpickerOpen.Visible = false

					menu.active_colorpicker = nil

					task.delay(0, function()
						isOpen = false
						menu.busy = false
						utility.is_dragging_blocked = false	
					end)
				end

				local function openColorpicker()
					local newPosition = ColorBox.AbsolutePosition
					ColorpickerOpen.Position = udim2new(0, newPosition.X, 0, newPosition.Y + 2 + ColorBox.AbsoluteSize.Y)
					ColorpickerOpen.Visible = true

					menu.active_colorpicker = new_element

					new_element:setColor(flags[_info.flag], flags[_info.transparency_flag])

					clickOutConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
						if gpe then return end
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							local pos = input.Position
							if not isInFrame(ColorBox, pos) and not isInFrame(ColorpickerOpen, pos) then closeColorpicker() end
						end
					end), true)

					isOpen = true; menu.busy = true; utility.is_dragging_blocked = true
				end

				utility.newConnection(ColorBox.InputEnded, function(input, gpe)
					if gpe then return end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						if not menu.busy then
							openColorpicker()
						elseif isOpen then
							closeColorpicker(true)
						end
					end
				end)

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					if isOpen then
						closeColorpicker()
					end
					tween(ColorBox, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(ColorBox, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
				end, true)

				function new_element:setColor(color, transparency, no_move)
					if menu.active_colorpicker ~= new_element or no_move then
						flags[_info.flag] = color
						flags[_info.transparency_flag] = transparency
						Inside.BackgroundColor3 = color
						new_element.onColorChange:Fire(color, transparency)
						return
					end
					local h,s,v = color:ToHSV()
					update_sv(v*255, s*255, true)
					update_hue(h*360)
					update_transparency(transparency)
				end

				new_element:setColor(_info.default or colorfromrgb(255,255,255), _info.default_transparency or 0)

				utility.newConnection(menu.on_load, function()
					new_element:setColor(flags[_info.flag], flags[_info.transparency_flag])
				end, true)
			elseif lower(_element) == "button" then
				Frame.Size = udim2new(1,0,0,25)
				Label.Visible = false
				local Border = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 0);
					Size = udim2new(0.72, 0, 0, 25);
					Parent = Frame
				})
				local Inside2 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(36, 36, 36);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = Border
				})
				local Inside3 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = Inside2
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(31, 31, 31)), ColorSequenceKeypoint.new(1.00, colorfromrgb(36, 36, 36))};
					Rotation = 90;
					Parent = Inside3
				})
				local ButtonLabel = newObject("TextLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 1, 0);
					Font = Enum.Font.SourceSans;
					Text = _info.text;
					TextColor3 = colorfromrgb(212, 212, 212);
					TextSize = 13.000;
					TextWrapped = true;
					Parent = Inside3
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					Parent = Border;
					MaxSize = vector2new(200, 9e9)
				})

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside3, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(ButtonLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Border, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside3, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(ButtonLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
				end, true)

				local function onHover()
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(36, 36, 36)), ColorSequenceKeypoint.new(1.00, colorfromrgb(41, 41, 41))};
				end

				local function onLeave()
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(31, 31, 31)), ColorSequenceKeypoint.new(1.00, colorfromrgb(36, 36, 36))};
				end

				utility.newConnection(Border.InputBegan, function(input, gpe)
					if gpe then return end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(26, 26, 26)), ColorSequenceKeypoint.new(1.00, colorfromrgb(31, 31, 31))};
					end
				end)

				utility.newConnection(Border.InputEnded, function(input, gpe)
					if gpe then return end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						if isInFrame(Border, input.Position) then
							_info.callback()
							onHover()
						else
							UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(26, 26, 26)), ColorSequenceKeypoint.new(1.00, colorfromrgb(31, 31, 31))};
						end
					end
				end)

				utility.newConnection(Border.MouseEnter, onHover)
				utility.newConnection(Border.MouseLeave, onLeave)
			elseif lower(_element) == "keybind" then
				local KeybindLabel = newObject("TextLabel", {
					AnchorPoint = vector2new(1, 0);
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.X;
					Position = udim2new(1, 0, 0, 0);
					Size = udim2new(0, 0, 0, 7);
					FontFace = Font.fromId(12187371840);
					Text = "[-]";
					TextColor3 = colorfromrgb(117, 117, 117);
					TextSize = 9.000;
					TextStrokeTransparency = 0.000;
					TextWrapped = true;
					Parent = Frame
				})

				new_element.onActiveChange = signal.new()

				local isOpen = false
				local clickOutConnection = nil
				local keyListenConnection = nil
				local counter = 0

				new_element.flag = _info.flag

				flags[_info.flag] = {
					method = 1,
					key = nil,
					active = false
				}

				function new_element:setActive(active)
					flags[_info.flag]["active"] = active
					new_element.onActiveChange:Fire(active)
				end

				function new_element:setMethod(method, just_visual)
					flags[_info.flag]["method"] = method
					new_element:setActive(method == 1)
					if menu.active_keybind ~= new_element then
						return end

					for _, object in KeybindOpenInside2:GetChildren() do
						if object:IsA("TextLabel") then
							object.Font = Enum.Font.SourceSans
							object.TextColor3 = colorfromrgb(205,205,205)
						end
					end
					local object = KeybindOpenInside2:FindFirstChild(method)
					object.Font = Enum.Font.SourceSansBold
					object.TextColor3 = menu.accent_color
					if method == 1 and not just_visual then
						new_element:setActive(true)
					end
				end

				function new_element:setKey(keycode, new)
					local old_keycode = flags[_info.flag]["key"]
					if old_keycode and old_keycode ~= "" then
						local keybind = menu.keybinds[old_keycode]
						if keybind then
							if #keybind == 1 then
								for _, v in keybind do
									if v[2] == _info.flag then
										menu.keybinds[old_keycode] = nil
										break
									end
								end
							else
								for _, v in keybind do
									if v[2] == _info.flag then
										utility.remove(menu.keybinds[old_keycode], _, _)
										break
									end
								end
							end
						end
					end
					if keycode == nil or keycode == "" then
						KeybindLabel.Text = "[-]"
						flags[_info.flag]["key"] = nil
						flags[_info.flag]["active"] = flags[_info.flag]["method"] == 1
						return
					end
					if menu.keybinds[keycode] then
						utility.insert(menu.keybinds[keycode], {new_element, _info.flag})
					elseif keycode then
						menu.keybinds[keycode] = {{new_element, _info.flag}}
					end
					flags[_info.flag]["key"] = keycode
					local shortened = shortened_characters[keycode] and shortened_characters[keycode] or keycode.Name
					KeybindLabel.Text = "["..string.upper(shortened).."]"
				end

				new_element:setMethod(_info.method and _info.method or 1)
				new_element:setKey(_info.key and _info.key or nil)

				local function onHover()
					if menu.busy then return end
					KeybindLabel.TextColor3 = colorfromrgb(176,176,176)
				end

				local function onLeave()
					if menu.busy then return end
					KeybindLabel.TextColor3 = colorfromrgb(117,117,117)
				end

				local function stopKeybind()
					KeybindLabel.TextColor3 = colorfromrgb(117, 117, 117)
					keyListenConnection:Disconnect()
					menu.busy = false; utility.is_dragging_blocked = false
				end

				local function startKeybind()
					menu.busy = true; utility.is_dragging_blocked = true
					_wait()
					KeybindLabel.TextColor3 = colorfromrgb(200,0,0)
					keyListenConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
						if gpe then 
							new_element:setKey(nil)
							stopKeybind()
							return 
						end
						local key = shortened_characters[input.UserInputType] and input.UserInputType or input.KeyCode
						local is_valid_key = utility.isValidKey(key)
						if is_valid_key then
							new_element:setKey(key)
						else
							new_element:setKey(nil)
						end
						stopKeybind()
					end), true)
				end

				if not _info.method_locked then
					local function closeKeybind(isOnBorder)
						clickOutConnection:Disconnect()
						KeybindOpen.Visible = false

						isOpen = false
						menu.busy = false
						utility.is_dragging_blocked = false
						menu.active_keybind = nil

						if isOnBorder then onHover() else onLeave() end
					end

					local function openKeybind()
						local newPosition = KeybindLabel.AbsolutePosition
						KeybindOpen.Position = udim2new(0, newPosition.X - 102, 0, newPosition.Y)
						KeybindOpen.Visible = true

						menu.active_keybind = new_element

						new_element:setMethod(flags[_info.flag]["method"], true)

						clickOutConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
							if gpe then return end
							if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
								local pos = input.Position
								if not isInFrame(KeybindLabel, pos) and not isInFrame(KeybindOpen, pos) then closeKeybind() end
							end
						end), true)

						isOpen = true; menu.busy = true; utility.is_dragging_blocked = true
					end

					utility.newConnection(KeybindLabel.InputEnded, function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.MouseButton2 then
							if not menu.busy then
								openKeybind()
							elseif isOpen then
								closeKeybind(true)
							end
						end
					end)
				end

				utility.newConnection(KeybindLabel.InputBegan, function(input, gpe)
					if gpe then return end
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
						if not menu.busy then
							startKeybind()
						end
					end
				end)

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(KeybindLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1, TextStrokeTransparency = 1})
					if isOpen then closeKeybind() end
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(KeybindLabel, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0, TextStrokeTransparency = 0})
				end, true)

				utility.newConnection(KeybindLabel.MouseEnter, onHover)
				utility.newConnection(KeybindLabel.MouseLeave, onLeave)

				utility.newConnection(menu.on_load, function()
					new_element:setKey(flags[_info.flag]["key"], true)
					new_element:setMethod(flags[_info.flag]["method"])
				end, true)
			elseif lower(_element) == "multibox" then
				Frame.Size = udim2new(1, 0, 0, _info.max*20)
				Label.Visible = false
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 1);
					Size = udim2new(0.72, 0, 1, 0);
					ZIndex = 2;
					Parent = Frame
				})
				local Inside2 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(40, 40, 40);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					ZIndex = 2;
					Parent = Inside
				})
				local Scroller = newObject("ScrollingFrame", {
					Active = true;
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					AutomaticCanvasSize = Enum.AutomaticSize.Y;
					Size = udim2new(1, 0, 1, 0);
					BottomImage = "rbxassetid://15540816491";
					ScrollBarImageColor3 = colorfromrgb(65, 65, 65);
					CanvasSize = udim2new(0, 0, 1, 0);
					MidImage = "rbxassetid://15540816491";
					ScrollBarThickness = 5;
					ScrollingEnabled = false;
					TopImage = "rbxassetid://15540816491";
					ZIndex = 4;
					Parent = Inside2
				})
				local OptionHolder = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					ZIndex = 2;
					Parent = Scroller
				})
				local UIListLayout = newObject("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Padding = UDim.new(0, 0);
					Parent = OptionHolder
				})
				local ArrowDown = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -16, 1, -9);
					Size = udim2new(0, 5, 0, 4);
					Visible = false;
					Image = "rbxassetid://15540867448";
					ZIndex = 5;
					Parent = Inside2	
				})
				local ArrowUp = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -16, 0, 5);
					Size = udim2new(0, 5, 0, 4);
					Visible = false;
					Image = "rbxassetid://15547663604";
					ZIndex = 5;
					Parent = Inside2
				})
				local BottomShadow = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 0, 1, -21);
					Size = udim2new(1, 0, 0, 20);
					Image = "rbxassetid://15541064478";
					ImageColor3 = colorfromrgb(35, 35, 35);
					ZIndex = 2;
					Parent = Inside2
				})
				local TopShadow = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Rotation = 180.000;
					Size = udim2new(1, 0, 0, 20);
					Image = "rbxassetid://15541064478";
					ImageColor3 = colorfromrgb(35, 35, 35);
					ZIndex = 2;
					Parent = Inside2
				})
				local ScrollBackground = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(40, 40, 40);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -6, 0, 0);
					Size = udim2new(0, 6, 1, 0);
					Visible = false;
					ZIndex = 3;
					Parent = Inside2
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					Parent = Inside;
					MaxSize = vector2new(200, 9e9)
				})

				if _info.search then
					local Search = newObject("Frame", {
						BackgroundColor3 = colorfromrgb(12, 12, 12);
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 19, 0, 0);
						Size = udim2new(0.72, 0, 0, 20);
						Parent = Frame
					})
					local SearchInside = newObject("Frame", {
						BackgroundColor3 = colorfromrgb(50, 50, 50);
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 1, 0, 1);
						Size = udim2new(1, -2, 1, -2);
						Parent = Search
					})
					local SearchInside2 = newObject("Frame", {
						BackgroundColor3 = colorfromrgb(24, 24, 24);
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 1, 0, 1);
						Size = udim2new(1, -2, 1, -2);
						Parent = SearchInside
					})
					local TextBox = newObject("TextBox", {
						BackgroundColor3 = colorfromrgb(255, 255, 255);
						BackgroundTransparency = 1.000;
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 5, 0, 0);
						Size = udim2new(1, -5, 1, 0);
						ZIndex = 2;
						Font = Enum.Font.SourceSansBold;
						Text = "_";
						TextColor3 = colorfromrgb(208, 208, 208);
						TextSize = 13.000;
						TextXAlignment = Enum.TextXAlignment.Left;
						ClearTextOnFocus = false;
						Parent = SearchInside2
					})
					local UISizeConstraint = newObject("UISizeConstraint", {
						Parent = Search;
						MaxSize = vector2new(200, 9e9)
					})

					utility.newConnection(TextBox.FocusLost, function()
						TextBox.TextColor3 = colorfromrgb(208, 208, 208);
						if TextBox.Text == "" then
							TextBox.Text = "_" 
						end
					end)

					utility.newConnection(TextBox.Focused, function()
						if menu.busy then
							TextBox:ReleaseFocus()
							return
						end

						if TextBox.Text == "_" then
							TextBox.Text = "" 
						end
						TextBox.TextColor3 = menu.accent_color;
					end)

					utility.newConnection(TextBox:GetPropertyChangedSignal("Text"), function()
						local text = lower(TextBox.Text)

						if text == "_" then
							return end

						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								if text == "" or lower(object.Name):find(text) then
									object.Visible = true
								else
									object.Visible = false
								end
							end
						end
					end)

					Frame.Size = udim2new(1,0,0,(20*_info.max) + 20)
					Inside.Size = udim2new(0.72, 0, 1, -20)
					Inside.Position = udim2new(0, 19, 0, 19)

					utility.newConnection(menu.on_closing, function()
						if not tab_frame.Visible then return end
						tween(Search, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(SearchInside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(SearchInside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(TextBox, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
						tween(ScrollBackground, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(BottomShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(TopShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowDown, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowUp, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Scroller, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 1})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
							end
						end
					end, true)

					utility.newConnection(menu.on_opening, function()
						if not tab_frame.Visible then return end
						tween(Search, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(SearchInside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(SearchInside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(TextBox, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
						tween(ScrollBackground, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(BottomShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(TopShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
							tween(ArrowUp, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						else
							tween(ArrowDown, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						end
						tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Scroller, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 0})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
							end
						end
					end, true)
				else
					utility.newConnection(menu.on_closing, function()
						if not tab_frame.Visible then return end
						tween(ScrollBackground, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(BottomShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(TopShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowDown, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowUp, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Scroller, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 1})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
							end
						end
					end, true)

					utility.newConnection(menu.on_opening, function()
						if not tab_frame.Visible then return end
						tween(ScrollBackground, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(BottomShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(TopShadow, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(ArrowDown, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(ArrowUp, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Scroller, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 0})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
							end
						end
					end, true)
				end

				local function updateSize()
					if OptionHolder.AbsoluteSize.Y > Inside.AbsoluteSize.Y then
						Scroller.CanvasSize = udim2new(0, 0, 1, 0)
						Scroller.ScrollingEnabled = true
						Scroller.ScrollBarImageTransparency = 0
						ScrollBackground.Visible = true
						ArrowUp.Visible = true
						ArrowDown.Visible = true
						BottomShadow.Visible = true; TopShadow.Visible = true
					else
						Scroller.ScrollingEnabled = false
						Scroller.ScrollBarImageTransparency = 1
						ScrollBackground.Visible = false
						ArrowUp.Visible = false
						ArrowDown.Visible = false
						BottomShadow.Visible = false; TopShadow.Visible = false
					end 
				end

				utility.newConnection(Scroller:GetPropertyChangedSignal("CanvasPosition"), function()
					if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
						ArrowUp.ImageTransparency = 0
						ArrowDown.ImageTransparency = 1
					else
						ArrowUp.ImageTransparency = 1
						ArrowDown.ImageTransparency = 0
					end
				end)

				utility.newConnection(OptionHolder:GetPropertyChangedSignal("AbsoluteSize"), updateSize)
				utility.newConnection(Scroller:GetPropertyChangedSignal("CanvasSize"), updateSize)

				updateSize()

				utility.newConnection(ArrowUp.InputBegan, function()
					Scroller.CanvasPosition.Y = UDim.new(0,0)
				end)
		
				utility.newConnection(ArrowDown.InputBegan, function()
					Scroller.CanvasPosition = UDim.new(0,Scroller.AbsoluteCanvasSize.Y)
				end)

				new_element.selected_option = nil
				new_element.onSelectionChange = signal.new()

				function new_element:removeAllOptions()
					for _, option in OptionHolder:GetChildren() do
						if option.ClassName == "TextLabel" then
							option:Destroy()
						end
					end
					new_element:setSelected(nil, true)
				end

				function new_element:setSelected(text, no)
					text = text or ""
					if new_element.selected_option == text then
						return end

					local old_option = new_element.selected_option and OptionHolder:FindFirstChild(new_element.selected_option) or nil

					if old_option and old_option.ClassName == "TextLabel" then
						old_option.Font = Enum.Font.SourceSans
						old_option.TextColor3 = colorfromrgb(208, 208, 208)
					end

					local option = OptionHolder:FindFirstChild(text)

					if not option or option.ClassName ~= "TextLabel" then
						new_element.selected_option = nil
						new_element.onSelectionChange:Fire(nil)
						return
					end

					new_element.selected_option = text

					if not no then
						new_element.onSelectionChange:Fire(text)
					end

					option.Font = Enum.Font.SourceSansBold
					option.TextColor3 = menu.accent_color
				end

				function new_element:removeOption(text)
					local option = OptionHolder:FindFirstChild(text)
					if option then
						option:Destroy()
					end
					if new_element.selected_option == text then
						new_element:setSelected(nil)
					end
				end

				function new_element:addOption(text)
					local MultiOption = newObject("TextLabel", {
						BackgroundColor3 = colorfromrgb(25, 25, 25);
						BackgroundTransparency = 1.000;
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Size = udim2new(1, 0, 0, 20);
						ZIndex = 25;
						Font = Enum.Font.SourceSans;
						Text = "     "..text;
						TextColor3 = colorfromrgb(208, 208, 208);
						TextSize = 13.000;
						TextXAlignment = Enum.TextXAlignment.Left;
						Parent = OptionHolder
					}); MultiOption.Name = text

					utility.newConnection(MultiOption.MouseEnter, function()
						MultiOption.BackgroundTransparency = 0
						if new_element.selected_option == text then return end
						MultiOption.Font = Enum.Font.SourceSansBold
					end)

					utility.newConnection(MultiOption.MouseLeave, function()
						MultiOption.BackgroundTransparency = 1
						if new_element.selected_option == text then return end
						MultiOption.Font = Enum.Font.SourceSans
					end)

					utility.newConnection(MultiOption.InputBegan, function(input, gpe)
						if gpe or menu.busy then return end
						if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
							new_element:setSelected(text)
						end
					end)
				end
			elseif lower(_element) == "textbox" then
				Frame.Size = udim2new(1, 0, 0, 20)
				local Textbox = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 20);
					Parent = Frame
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 0);
					Size = udim2new(0.72, 0, 0, 20);
					Parent = Textbox
				})
				local Inside2 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(50, 50, 50);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);	
					Size = udim2new(1, -2, 1, -2);
					Parent = Inside
				})
				local Inside3 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(24, 24, 24);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					Parent = Inside2
				})
				local TextBox = newObject("TextBox", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 5, 0, 0);
					Size = udim2new(1, -5, 1, 0);
					ZIndex = 2;
					Font = Enum.Font.SourceSansBold;
					Text = "_";
					TextColor3 = colorfromrgb(208, 208, 208);
					TextSize = 13.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					ClearTextOnFocus = false;
					Parent = Inside3
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					MaxSize = vector2new(200, 9e9);
					Parent = Inside
				})

				Label.Visible = false

				function new_element:setText(text)
					text = text or ""
					if TextBox.Text ~= text then
						TextBox.Text = text
					end

					flags[_info.flag] = text
				end

				utility.newConnection(TextBox.FocusLost, function()
					TextBox.TextColor3 = colorfromrgb(208, 208, 208);
					if TextBox.Text == "" then
						TextBox.Text = "_" 
					end
				end)

				utility.newConnection(TextBox.Focused, function()
					if menu.busy then
						TextBox:ReleaseFocus()
						return
					end

					if TextBox.Text == "_" then
						TextBox.Text = "" 
					end
					TextBox.TextColor3 = menu.accent_color;
				end)

				utility.newConnection(TextBox:GetPropertyChangedSignal("Text"), function()
					local text = lower(TextBox.Text)

					if text == "_" then
						new_element:setText(nil)
						return end

					new_element:setText(TextBox.Text)
				end)

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside3, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(TextBox, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Inside, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside2, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside3, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(TextBox, newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
				end, true)

				if not _info.no_load then
					utility.newConnection(menu.on_load, function()
						new_element:setText(flags[_info.flag])
					end, true)
				end
			end
		end

		self.elements[info.name] = new_element

		return new_element
	end

	function element:setVisible(bool)
		self.frame.Visible = bool
	end

	utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
		if gpe then 
			return 
		end
		local keycode = shortened_characters[input.UserInputType] and input.UserInputType or input.KeyCode
		if keycode then
			if string.upper(input.KeyCode.Name) == menu.toggle then
				if menu.is_open then menu.on_closing:Fire() else menu.on_opening:Fire() end
				return
			end
			local keybinds = menu.keybinds[keycode]
			if keybinds then
				for _, info in keybinds do
					local flag = info[2]
					if flags[flag]["method"] == 2 then
						info[1]:setActive(true)
					elseif flags[flag]["method"] == 3 then
						info[1]:setActive(not menu.flags[flag]["active"])
					end
				end
			end
		end
	end), true)

	utility.newConnection(uis.InputEnded, LPH_NO_VIRTUALIZE(function(input, gpe)
		if gpe then return end
		local keycode = shortened_characters[input.UserInputType] and input.UserInputType or input.KeyCode
		if keycode then
			local keybinds = menu.keybinds[keycode]
			if keybinds then
				for _, info in keybinds do
					local flag = info[2]
					if flags[flag]["method"] == 2 then
						info[1]:setActive(false)
					end
				end
			end
		end
	end), true)
end

------------------------
-- * Game functions * --
------------------------

local pf_client = {}

local getEntry = nil

local function getCharacter(entry)
	local character = entry["_thirdPersonObject"]
	
	if not character then
		return end

	return character["_characterHash"]
end

local function getWeapon(entry)
	local data = entry["_thirdPersonObject"]
	
	if not data then
		return end

	return data["_weaponname"]
end

local getController = nil
local lplrHitPlayer = signal.new()

local dot = Vector3.zero.Dot

local getTrajectory = LPH_NO_VIRTUALIZE(function(o, a, t, s, e)
	local f = -a
	local ld = t - o
	local a = dot(f, f)
	local b = 4 * dot(ld, ld)
	local k = (4 * (dot(f, ld) + s * s)) / (2 * a)
	local v = (k * k - b / a) ^ 0.5
	local t, t0 = k - v, k + v

	t = t < 0 and t0 or t; t = t ^ 0.5
	return f * t / 2 + (e or Vector3.zero) + ld / t, t
end)

local grenadeThrown = signal.new()
local latest_grenade = nil
local network_send = nil

local characterTable = nil
local old_vel = nil
local get_time = nil
local get_character_object = nil

local gun_types = {
	["Default"] = {}
}

local gun_specifics = {}
local gun_modules = {}

LPH_NO_VIRTUALIZE(function()
	for _, v in weapon_database:GetDescendants() do
		if v.ClassName == "ModuleScript" then
			local module = nil
			pcall(function()
				module = require(v)
			end)
			if module and not gun_types[module["type"]] then
				gun_modules[v.Name] = module
				local type = string.gsub(string.lower(module["type"]), "^%l", string.upper)
				type = string.sub(type, 1, 1)..string.lower(string.sub(type, 2, #type)).."s"
				gun_types[type] = {}
				gun_specifics[v.Name] = type
			end 
		end
	end
end)()

local getGunType = LPH_JIT_MAX(function(name)
	return gun_specifics[name] or "Default"
end)

for _, v in getgc(true) do
    if typeof(v) == "table" then
		if rawget(v, "getTime")then
            get_time = rawget(v, "getTime")
		end
		if rawget(v, "getCharacterObject")then
            get_character_object = rawget(v, "getCharacterObject")
		end
        if rawget(v, "getEntry") and rawget(v, "operateOnAllEntries") then
            pf_client = v
            getEntry = rawget(v, "getEntry")
        elseif rawget(v, "walkSway") and rawget(v, "boltStop") then
            local old_walk_sway = rawget(v, "walkSway")
            rawset(v, "walkSway", LPH_NO_VIRTUALIZE(function(...)
				local return_value = flags["no_gun_sway"] and cframenew() or old_walk_sway(...)
				if flags["viewmodel_changer"] then
					return_value*=cframenew(flags["viewmodel_x"], flags["viewmodel_y"], flags["viewmodel_z"]) * angles(0,0,rad(flags["viewmodel_roll"]))
				end
                return return_value
            end))
            local old_gun_sway = rawget(v, "gunSway")
            rawset(v, "gunSway", LPH_NO_VIRTUALIZE(function(...)
                return flags["no_gun_sway"] and cframenew() or old_gun_sway(...)
            end))
			local old_firerate = rawget(v, "getFirerate")
            rawset(v, "getFirerate", LPH_NO_VIRTUALIZE(function(...)
				if flags["firerate_modifier"] then
					return old_firerate(...) * flags["modifier"]
				end
                return old_firerate(...)
            end))
			local old_getweaponstat = rawget(v, "getWeaponStat")
			local alr_printed = {}
			rawset(v, "getWeaponStat", LPH_NO_VIRTUALIZE(function(weapon, stat, ...)
				if (stat == "pullout" or stat == "unequiptime" or stat == "equiptime") and flags["instant_equip"] then
					return 0
				end
				return old_getweaponstat(weapon, stat, ...)
			end))
        elseif rawget(v, "meleeSway") then
            local old_melee_sway = rawget(v, "meleeSway")
            rawset(v, "meleeSway", LPH_NO_VIRTUALIZE(function(...)
				local return_value = flags["no_gun_sway"] and cframenew() or old_melee_sway(...)
				if flags["viewmodel_changer"] then
					return_value*=cframenew(flags["viewmodel_x"], flags["viewmodel_y"], flags["viewmodel_z"]) * angles(0,0,rad(flags["viewmodel_roll"]))
				end
                return return_value
            end))
            local old_melee_walk_sway = rawget(v, "walkSway")
            rawset(v, "walkSway", LPH_NO_VIRTUALIZE(function(...)
                return flags["no_melee_sway"] and cframenew() or old_melee_walk_sway(...)
            end))
			local old_getweaponstat = rawget(v, "getWeaponStat")
			rawset(v, "getWeaponStat", LPH_NO_VIRTUALIZE(function(weapon, stat, ...)
				if (stat == "pullout" or stat == "unequiptime" or stat == "equiptime") and flags["instant_equip"] then
					return 0
				end
				return old_getweaponstat(weapon, stat, ...)
			end))
        elseif rawget(v, "shake") then
            local old_recoil = rawget(v, "applyImpulse")
            rawset(v, "applyImpulse", LPH_NO_VIRTUALIZE(function(_, amount)
				local horizontal = ((100-lplr_data["reduce_horizontal"])/100)
				local vertical = ((100-lplr_data["reduce_vertical"])/100)
                return old_recoil(_, amount*vector3new(vertical, horizontal, horizontal))
            end))
        elseif rawget(v, "getController") then
            getController = rawget(v, "getController")
		elseif rawget(v, "new") and rawget(v, "stepRender") then
			local old = rawget(v, "new")
			rawset(v, "new", LPH_NO_VIRTUALIZE(function(data)
				if flags["silent_aim"] and aimbot.target_position then
					if lplr_data["hit_chance"] < 100 and not aimbot.do_hit then
						return old(data)
					end

					data.velocity = getTrajectory(data.position, vector3new(0, -196.2, 0), aimbot.target_position + aimbot.silent_accuracy, data.velocity.magnitude, player_data[aimbot.target]["entry"]["_velspring"]["t"])

					old_vel = data.velocity
				end
				return old(data)
			end))
		elseif rawget(v, "getHealth") and rawget(v, "parkour") then
			characterTable = v
		elseif rawget(v, "send") then
            local old = rawget(v, "send")
			
			rawset(v, "send", LPH_JIT_MAX(function(...)
				local args = {...}
				local data = args[2]

				if data == "newbullets" and flags["silent_aim"] and aimbot.target_position then
					if lplr_data["hit_chance"] < 100 and not aimbot.do_hit then
						return old(...)
					end

					local sending = args[4]
					local bullets = sending["bullets"]
					local trajectory = getTrajectory(sending["firepos"], vector3new(0, -196.2, 0), aimbot.target_position + aimbot.silent_accuracy, lplr_data["active_weapon"]:getWeaponStat("bulletspeed"), player_data[aimbot.target]["entry"]["_velspring"]["t"])

					for i = 1, #bullets do
						bullets[i][1] = trajectory.Unit
					end

					return old(unpack(args))
				elseif data == "aim" then
					lplr_data["aiming"] = args[3]
				elseif data == "bullethit" then
					local player = args[4]
					local part = lower(tostring(args[6]))

					lplrHitPlayer:Fire(player, part)
				elseif data == "equip" then
					task.delay(0, function()
						local controller = getController()

						if controller then
							lplr_data["active_weapon"] = controller:getActiveWeapon()
							local gunType = getGunType(lplr_data["active_weapon"]["_weaponName"])
							if gunType ~= "Default" and not flags[gunType.."_override_general"] then
								gunType = "Default"
							end
							if lplr_data["gun"] ~= gunType then
								lplr_data["gun"] = gunType
								lplr_data["reduce_horizontal"] = flags[gunType.."_reduce_horizontal"]
								lplr_data["reduce_vertical"] = flags[gunType.."_reduce_vertical"]
								lplr_data["hit_chance"] = flags[gunType.."_hit_chance"]
								lplr_data["accuracy"] = flags[gunType.."_accuracy"]
								aimbot["silent_aim_fov"] = flags[gunType.."_silent_field_of_view"]*3.33
								aimbot.circle.Radius = aimbot["silent_aim_fov"]
								aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
								aimbot["aim_assist_fov"] = flags[gunType.."_aim_assist_field_of_view"]*3.33
								aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
								aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
								aimbot["deadzone"] = flags[gunType.."_deadzone"]/100
							end
						end
					end)
				end
				return old(...)
			end))

			network_send = LPH_NO_VIRTUALIZE(function(...)
				old(v, ...)
			end)
        end
	elseif typeof(v) == "function" and debug.getinfo(v, "s").source and debug.getinfo(v, "s").source:find("ThrowableConnector") and #debug.getconstants(v) == 35 then
		old_grenade = nil; old_grenade = hookfunction(v, LPH_NO_UPVALUES(function(...)
			local args = {...}

			task.delay(0.001, function()
				local cook_time = args[5]
				local thrower = args[1]
				local tick = tostring(os.clock())
				local end_pos = vector3new()

				for _, arg in args do
					if typeof(arg) == "table" and #arg > 0 then
						end_pos = arg[#arg].p
						break
					end
				end

				if thrower.Team == lplr.Team and thrower ~= lplr then
					return 
				end

				task.wait()

				grenadeThrown:Fire(thrower, latest_grenade, cook_time, args[2], end_pos)
			end)
			
			return old_grenade(...)
		end))
    end
end

setthreadidentity(8)

------------------------
-- * Game Functions * --
------------------------

local menu_references = {}

local notifications = 0
local notification_removed = signal.new()

local newNotification = LPH_NO_VIRTUALIZE(function(text, style)
	if style == "Default" then
		local drawings = {
			utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(180,30);
				Color = colorfromrgb(12,12,12);
				Transparency = 0;
				ZIndex = 1;
				Filled = true
			}),
			utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(178,28);
				Color = colorfromrgb(20,20,20);
				Transparency = 0;
				ZIndex = 2;
				Filled = true
			}),
			utility.newDrawing("Image", {
				Data = line_image;
				Color = colorfromrgb(255,255,255);
				Transparency = 0;
				ZIndex = 3;
				Size = vector2new(0,3)
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(255,255,255);
				Transparency = 0;
				Size = 18;
				Text = text;
				Outline = true;
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
		}

		local x_size = drawings[4]["TextBounds"]["X"]+20
		local y = camera.ViewportSize.Y - (flags["notification_y_offset"] + notifications*35)
		local x = camera.ViewportSize.X/2 - (x_size)/2
		for i = 1, 4 do
			local drawing = drawings[i]
			if i ~= 4 then
				local _y = drawing["Size"]["Y"]
				drawing.Position = vector2new(i == 1 and x or x + 2, i == 1 and y or y + 2)
				drawing.Size = vector2new(i == 1 and x_size or x_size-4, i == 1 and _y or _y-2)
			else
				drawing.Position = vector2new(x + 10, y + 9)
			end
		end

		notifications+=1

		local notification = notifications

		local connection = nil
		local tween_connection = nil
		local old_value = 0
		local value = 1
		local elapsed_time = 0
		local new_value = 0
		
		connection = utility.newConnection(notification_removed, function(int)
			if notification > int then
				notification-=1
				local y = camera.ViewportSize.Y - (flags["notification_y_offset"] + (notification-1)*35)
				for i = 1, 4 do
					local drawing = drawings[i]
					if i ~= 4 then
						local _y = drawing["Size"]["Y"]
						drawing.Position = vector2new(i == 1 and x or x + 2, i == 1 and y or y + 2)
					else
						drawing.Position = vector2new(x + 10, y + 9)
					end
				end
			end
		end, true)

		tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.22 then
				local tween_value = getValue(tws, (elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				new_value = old_value + (value-old_value)*tween_value
				for _, drawing in drawings do
					drawing.Transparency = new_value
					drawing.Visible = true
					if drawing == drawings[3] then
						drawing.Size = vector2new((x_size-4)*tween_value, 3)
					end
				end
			else
				for _, drawing in drawings do
					drawing.Transparency = new_value
				end
				tween_connection:Disconnect()
			end
		end, true)

		_wait(1.5)

		local old_value = 1
		local value = 0
		local elapsed_time = 0
		local new_value = 0

		tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.22 then
				local tween_value = getValue(tws, (elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				new_value = old_value + (value-old_value)*tween_value
				for _, drawing in drawings do
					drawing.Transparency = new_value
					drawing.Visible = true
					if drawing == drawings[3] then
						drawing.Size = vector2new(x_size + (4-x_size)*tween_value, 3)
					end
				end
			else
				for _, drawing in drawings do
					drawing.Transparency = new_value
				end
			end
		end)

		task.delay(0.22, function()
			for _, drawing in drawings do
				drawing:Destroy()
			end
			tween_connection:Disconnect()
			connection:Disconnect()
			notifications-=1
			notification_removed:Fire(notification)
		end)
	elseif style == "Minimalistic" then
		local drawing =	utility.newDrawing("Text", {
			Center = true;
			Color = colorfromrgb(226,226,226);
			Transparency = 0;
			Size = 18;
			Text = text;
			Outline = true;
			ZIndex = 4;
			Font = fonts[tonumber(flags["notification_font"][1])]
		})
	
		local y = camera.ViewportSize.Y - (flags["notification_y_offset"] + notifications*19)
		local x = camera.ViewportSize.X/2
	
		notifications+=1

		drawing.Position = vector2new(x, y)
	
		local notification = notifications
	
		local connection = nil
		local tween_connection = nil
		local old_value = 0
		local value = 1
		local elapsed_time = 0
		local new_value = 0
		
		connection = utility.newConnection(notification_removed, function(int)
			if notification > int then
				notification-=1
				drawing.Position = vector2new(x, camera.ViewportSize.Y - (flags["notification_y_offset"] + (notification-1)*19))
			end
		end, true)
	
		tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.22 then
				local tween_value = getValue(tws, (elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				new_value = old_value + (value-old_value)*tween_value
				drawing.Transparency = new_value
				drawing.Visible = true
			else
				drawing.Transparency = new_value
				tween_connection:Disconnect()
			end
		end, true)
	
		_wait(1.5)
	
		local old_value = 1
		local value = 0
		local elapsed_time = 0
		local new_value = 0
	
		tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.22 then
				local tween_value = getValue(tws, (elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				new_value = old_value + (value-old_value)*tween_value
				drawing.Transparency = new_value
				drawing.Visible = true
			else
				drawing.Transparency = new_value
			end
		end)
	
		task.delay(0.22, function()
			drawing:Destroy()
			tween_connection:Disconnect()
			connection:Disconnect()
			notifications-=1
			notification_removed:Fire(notification)
		end)
	elseif style == "Eclipse" then
		local args = text:split(" ")

		local drawings = #args == 5 and {
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Text = "[";
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = flags["notification_color"];
				Transparency = 0;
				Size = 16;
				Text = "juju";
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Outline = true;
				Text = "]";
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Outline = true;
				Size = 16;
				Text = "Hit";
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = flags["notification_color"];
				Transparency = 0;
				Size = 16;
				Text = args[2];
				Outline = true;
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Outline = true;
				Text = "in";
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = flags["notification_color"];
				Transparency = 0;
				Size = 16;
				Text = args[4];
				Outline = true;
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			})
		} or (#args == 4 and {
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Outline = true;
				Text = "[";
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = flags["notification_color"];
				Transparency = 0;
				Size = 16;
				Text = "juju";
				Outline = true;
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Text = "]";
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Text = "Locked onto player";
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = flags["notification_color"];
				Transparency = 0;
				Size = 16;
				Text = args[4];
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			})
		}) or (#args == 1 and {
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Text = "[";
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = flags["notification_color"];
				Transparency = 0;
				Size = 16;
				Outline = true;
				Text = "juju";
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Outline = true;
				Text = "]";
				ZIndex = 4;
				Font = fonts[tonumber(flags["notification_font"][1])]
			}),
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(226,226,226);
				Transparency = 0;
				Size = 16;
				Text = "Unlocked";
				ZIndex = 4;
				Outline = true;
				Font = fonts[tonumber(flags["notification_font"][1])]
			})
		})

		local y = camera.ViewportSize.Y - (flags["notification_y_offset"] + notifications*16)
		local x = camera.ViewportSize.X/2

		notifications+=1

		local full_size = 0

		for i = 1, #drawings do
			local drawing = drawings[i]
			full_size+=drawing.TextBounds.X
		end

		local total_size = 0

		for i = 1, #drawings do
			local drawing = drawings[i]
			local size = drawing.TextBounds.X + ((i < 3 and 0) or 4)
			drawing.Position = vector2new(x-full_size/2 + total_size, y)
			total_size+=size
		end
	
		local notification = notifications
	
		local connection = nil
		local tween_connection = nil
		local old_value = 0
		local value = 1
		local elapsed_time = 0
		local new_value = 0
		
		connection = utility.newConnection(notification_removed, function(int)
			if notification > int then
				notification-=1
				y = camera.ViewportSize.Y - (flags["notification_y_offset"] + (notification-1)*16)
				local total_size = 0

				for i = 1, #drawings do
					local drawing = drawings[i]
					local size = drawing.TextBounds.X + ((i < 3 and 0) or 4)
					drawing.Position = vector2new(x-full_size/2 + total_size, y)
					total_size+=size
				end
			end
		end, true)
	
		tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.22 then
				local tween_value = getValue(tws, (elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				new_value = old_value + (value-old_value)*tween_value
				for i = 1, #drawings do
					local drawing = drawings[i]
					drawing.Transparency = new_value
					drawing.Visible = true
				end
			else
				for i = 1, #drawings do
					local drawing = drawings[i]
					drawing.Transparency = new_value
				end
				tween_connection:Disconnect()
			end
		end, true)
	
		_wait(1.5)
	
		local old_value = 1
		local value = 0
		local elapsed_time = 0
		local new_value = 0
	
		tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.22 then
				local tween_value = getValue(tws, (elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
				new_value = old_value + (value-old_value)*tween_value
				for i = 1, #drawings do
					local drawing = drawings[i]
					drawing.Transparency = new_value
					drawing.Visible = true
				end
			else
				for i = 1, #drawings do
					local drawing = drawings[i]
					drawing.Transparency = new_value
				end
			end
		end)
	
		task.delay(0.22, function()
			for i = 1, #drawings do
				drawings[i]:Destroy()
			end
			tween_connection:Disconnect()
			connection:Disconnect()
			notifications-=1
			notification_removed:Fire(notification)
		end)
	end
end)

local keybinder = {
	drawings = {
		utility.newDrawing("Square", {
			Position = vector2new(500,500);
			Size = vector2new(180,25);
			Transparency = 0.2;
			Color = colorfromrgb(13,13,13);
			Filled = true
		}),
		utility.newDrawing("Image", {
			Data = line_image;
			Color = colorfromrgb(255, 255, 255);
			Size = vector2new(180,3)
		}),
		utility.newDrawing("Text", {
			Center = true;
			Color = colorfromrgb(255,255,255);
			Size = 16;
			Text = "keybinds";
			Font = 2
		}),
	},
	active = {},
	all = {},
	tween_connection = nil
}

function keybinder:add(element, name, flag, flag2)
	local keybind = {
		drawings = {
			utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(255,255,255);
				Size = 14;
				Text = name;
				Transparency = 0;
				Outline = true;
				Font = 2
			}),
			utility.newDrawing("Text", {
				Center = true;
				Color = colorfromrgb(255,255,255);
				Size = 14;
				Text = "["..((flags[flag]["method"] == 1) and "always" or (flags[flag]["method"] == 2 and "held") or (flags[flag]["method"] == 3 and "toggle")).."]";
				Transparency = 0;
				Outline = true;
				Font = 2
			}),
		},
		active = flags[flag]["active"],
		tween_connection = nil,
		flag = flag,
		flag2 = flag2
	}

	keybind.show = LPH_NO_VIRTUALIZE(function()
		if not flags["keybinds_list"] or not flags[flag2] then
			return end

		if keybind.tween_connection then
			keybind.tween_connection:Disconnect()
		end

		local old_value = keybind.drawings[1].Transparency
		local value = 1
		local elapsed_time = 0
		local new_value = 0
		keybind.tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.1 then
				new_value = old_value + ((value-old_value)*getValue(tws, (elapsed_time / 0.1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				for _, drawing in keybind.drawings do
					drawing.Transparency = new_value
					drawing.Visible = true
				end
			else
				for _, drawing in keybind.drawings do
					drawing.Transparency = new_value
					drawing.Visible = true
				end
				keybind.tween_connection:Disconnect()
			end
		end)
	end)

	keybind.hide = LPH_NO_VIRTUALIZE(function()
		if keybind.tween_connection then
			keybind.tween_connection:Disconnect()
		end
		local old_value = keybind.drawings[1].Transparency
		local value = 0
		local elapsed_time = 0
		local new_value = 0
		keybind.tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			if elapsed_time < 0.1 then
				new_value = old_value + ((value-old_value)*getValue(tws, (elapsed_time / 0.1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				for _, drawing in keybind.drawings do
					drawing.Transparency = new_value
				end
			else
				for _, drawing in keybind.drawings do
					drawing.Transparency = new_value
					drawing.Visible = false
				end
				keybind.tween_connection:Disconnect()
			end
		end, true)
	end)

	function keybind:move(position)
		keybind.drawings[1].Position = keybinder.drawings[1].Position + vector2new(0, 12 + 16*position)
		keybind.drawings[2].Position = keybind.drawings[1].Position + vector2new(180 - keybind.drawings[2].TextBounds.X/2, 0)
	end

	insert(keybinder.all, keybind)

	if keybind.active then
		keybind.show()
	end

	utility.newConnection(element.onActiveChange, function(active)
		_wait()
		local do_show = flags["keybinds_list"] and flags[flag2]
		keybind.active = active

		if do_show then
			if active then
				keybind.show()
			else
				keybind.hide()
			end

			keybinder:refresh()
		end

		keybind.drawings[2]["Text"] = "["..((flags[flag]["method"] == 1 and "always") or (flags[flag]["method"] == 2 and "held") or (flags[flag]["method"] == 3 and "toggle")).."]"
	end, true)

	utility.newConnection(element.onToggleChange, function(bool)
		_wait()
		local do_show = flags["keybinds_list"]

		if do_show then
			if flags[flag]["active"] and bool then
				keybind.show()
			else
				keybind.hide()
			end
			keybinder:refresh()
		end

		keybind.drawings[2]["Text"] = "["..((flags[flag]["method"] == 1 and "always") or (flags[flag]["method"] == 2 and "held") or (flags[flag]["method"] == 3 and "toggle")).."]"
	end, true)
end

function keybinder:move(position)
	local count = 0
	for i = 1, 3 do
		local drawing = keybinder.drawings[i]
		if i ~= 3 then
			drawing.Position = position
		else
			drawing.Position = position + vector2new(90, 6)
		end
	end
	for _, keybind in keybinder.all do
		if keybind.active and flags[keybind.flag2] then
			count+=1
			keybind:move(count)
		end
	end
	flags["keybind_position"] = {"A", position.X, position.Y}
end

keybinder.close = LPH_NO_VIRTUALIZE(function()
	if keybinder.tween_connection then
		keybinder.tween_connection:Disconnect()
	end
	local old_value = keybinder.drawings[1].Transparency
	local value = 0
	local elapsed_time = 0
	local new_value = 0
	for _, keybind in keybinder.all do
		if keybind.drawings[1]["Transparency"] ~= 0 then
			keybind.hide()
		end
	end
	keybinder.tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
		if elapsed_time < 0.15 then
			new_value = old_value + ((value-old_value)*getValue(tws, (elapsed_time / 0.15), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			for _, drawing in keybinder.drawings do
				drawing["Transparency"] = new_value
			end
		else
			for _, drawing in keybinder.drawings do
				drawing["Transparency"] = new_value
				drawing["Visible"] = false
			end
			keybinder.tween_connection:Disconnect()
		end
	end, true)
end)

function keybinder:refresh()
	local count = 0
	for _, keybind in keybinder.all do
		if keybind.active and flags[keybind.flag2] then
			count+=1
			keybind.show()
			keybind:move(count)
		else
			keybind.hide()
		end
	end
	if count == 0 then
		keybinder.close()
	else
		keybinder.open()
	end
end

keybinder.open = LPH_NO_VIRTUALIZE(function()
	if keybinder.tween_connection then
		keybinder.tween_connection:Disconnect()
	end
	local old_value = keybinder.drawings[1].Transparency
	local new_value = 1
	local value = 1
	local elapsed_time = 0
	local count = 0
	for _, keybind in keybinder.all do
		if keybind.active and flags[keybind.flag2] then
			count+=1
			keybind.show()
			keybind:move(count)
		end
	end
	keybinder.tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
		if elapsed_time < 0.15 then
			new_value = old_value + ((value-old_value)*getValue(tws, (elapsed_time / 0.15), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			for _, drawing in keybinder.drawings do
				drawing.Transparency = new_value
				drawing.Visible = true
			end
		else
			for _, drawing in keybinder.drawings do
				drawing.Transparency = new_value
				drawing.Visible = true
			end
			keybinder.tween_connection:Disconnect()
		end
	end, true)
end)

keybinder:move(camera.ViewportSize/2)
flags["keybind_position"] = {"A", (camera.ViewportSize/2).X, (camera.ViewportSize/2).Y}


local spoof_properties = {
	["FogColor"] = lighting.FogColor,
	["ExposureCompensation"] = lighting.ExposureCompensation,
	["FogEnd"] = lighting.FogEnd,
	["FogStart"] = lighting.FogStart,
	["GlobalShadows"] = lighting.GlobalShadows,
	["ClockTime"] = floor(lighting.ClockTime),
	["Brightness"] = lighting.Brightness,
	["Ambient"] = lighting.Ambient,
	["CFrame"] = cframenew()
}

local aimbotTargetChange = signal.new()

local part_list = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
local character_parts = {}

local getClosestHitbox = LPH_NO_VIRTUALIZE(function(mouse_pos, character_parts)
	local closest = math.huge
	local closest_part = character_parts["Torso"]

	for i = 1, #part_list do
		local part_name = part_list[i]
		local part = character_parts[part_name]
		if not part then continue end
		local pos, on_screen = wtvp(camera, part.Position)
		if on_screen then
			local distance = (mouse_pos - vector2new(pos.X, pos.Y)).magnitude
			if distance < closest then
				closest = distance
				closest_part = part
			end
		end
	end

	return closest_part
end)

----------------------
-- * Player Setup * --
----------------------

local getAimbotCandidate = LPH_NO_VIRTUALIZE(function(mouse_position)
	local closest = 9e9
	local candidate = nil
	local position = nil
	local camera_pos = camera.CFrame.p
	local max_target_distance = flags["max_target_distance"]
	local checks = flags["target_checks"]
	local fov = aimbot["silent_aim_fov"] > aimbot["aim_assist_fov"] and aimbot["silent_aim_fov"] or aimbot["aim_assist_fov"]
	for player, info in player_data do
        local entry = info["entry"]
		local character = getCharacter(info["entry"])

		if not character or info["whitelisted"] or not entry["_alive"] or (player.Team == lplr.Team) then
			continue end

		local torso = character.Torso

		if not torso then
			continue end

		local pos, on_screen = wtvp(camera, torso.Position)

		if not on_screen then
			continue end

		local pos = vector2new(pos.X, pos.Y)
		local distance = (mouse_position - pos).magnitude

		if distance > fov then
			continue end

		local obj_distance = (camera_pos-torso.Position).magnitude

		if obj_distance > max_target_distance then
			continue end

		local stop = false
	
		for _, check in checks do
            if check == "Behind wall" then
				local raycast_params = RaycastParams.new()
				raycast_params.IgnoreWater = true;
				raycast_params.FilterDescendantsInstances = {torso.Parent, camera, ignored_folder, ignored_folder2, ignored_folder3}
				raycast_params.FilterType = Enum.RaycastFilterType.Exclude
				
				if raycast(workspace, camera_pos, (torso.Position-camera_pos).unit * obj_distance, raycast_params) then
					stop = true
					break
				end
			end
		end

		if stop then
			continue end

		if info["aimbot_priority"] then
			return player, pos
		end

		if distance < closest then
			closest = distance
			candidate = player
			position = pos
		end
	end
	return candidate, position
end)

local createESPObjects = LPH_NO_VIRTUALIZE(function(player)
	local highlight = newObject("Highlight", {
		Adornee = nil;
		DepthMode = flags["through_walls"] and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded;
		Enabled = false;
		FillColor = flags["highlight_color"];
		FillTransparency = flags["highlight_transparency"];
		OutlineColor = flags["outline_color"];
		OutlineTransparency = flags["outline_transparency"];
		Parent = gethui and gethui() or cg
	})

	local chams = {
		hidden = {},
		visible = {}
	}

	for _, part in part_list do
		local size = part == "Torso" and vector3new(2,2,1) or part == "Head" and vector3new(1,1,1) or vector3new(1,2,1)
		local hidden_box = newObject("BoxHandleAdornment", {
			Size = size + vector3new(0.01,0.01,0.01),
			ZIndex = 1,
			Color3 = flags["chams_color"],
			Transparency = flags["chams_transparency"],
			AlwaysOnTop = true,
			Parent = cg
		})
		local visible_box = newObject("BoxHandleAdornment", {
			Size = size + vector3new(0.2,0.2,0.2),
			ZIndex = 1,
			Color3 = flags["visible_chams_color"],
			Transparency = flags["visible_chams_transparency"],
			Parent = cg
		})
		chams["hidden"][part] = hidden_box
		chams["visible"][part] = visible_box
	end

	return {
		utility.newDrawing("Square", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["box_transparency"]+1,
		}),
		utility.newDrawing("Square", {
			Thickness = 1,
			ZIndex = 2,
			Filled = flags["box_fill"],
			Color = flags["box_color"],
			Transparency = -flags["box_transparency"]+1,
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			Size = flags["name_size"],
			ZIndex = 2,
			Color = flags["name_color"],
			Transparency = -flags["name_transparency"]+1,
			Text = flags["name_display"] and player.DisplayName or player.Name,
			Font = tonumber(flags["esp_font"][1])
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["health_transparency"]+1,
			Color = colorfromrgb(0,0,0)
		}),
		utility.newDrawing("Image", {
			Color = flags["health_color"],
			Transparency = -flags["health_transparency"]+1,
			Data = flags["gradient_bars"] and health_image or pixel_image,
			ZIndex = 2,
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			Size = flags["weapon_size"],
			ZIndex = 2,
			Text = "",
			Font = tonumber(flags["esp_font"][1]),
			Color = flags["weapon_color"],
			Transparency = -flags["weapon_transparency"]+1
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 3,
			Size = 14,
			Color = flags["number_color"],
			Font = tonumber(flags["esp_font"][1]),
			Transparency = -flags["number_transparency"]+1
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"]
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"]
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"]
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"]
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"]
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 0,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = colorfromrgb(0,0,0)
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 0,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = colorfromrgb(0,0,0)
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 0,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = colorfromrgb(0,0,0)
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 0,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = colorfromrgb(0,0,0)
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 0,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = colorfromrgb(0,0,0)
		}),
	}, highlight, chams
end)

local playerAdded = LPH_NO_VIRTUALIZE(function(player)	
	player_data[player] = {
		character = nil,
		health = 0,
		gun = false,
		not_on_screen = true,
		highlight = nil,
		drawings = {},
		forcefield = false,
		whitelisted = lplr_data["whitelisted"][player.Name] and true or false,
		aimbot_priority = lplr_data["priority"][player.Name] and true or false,
		entry = nil,
		chams = {
			hidden = {},
			visible = {},
		},
		last_position = {
			nil,
			nil,
			nil,
			nil,
			nil,
			nil,
			os.clock()
		},
		tweens = {}
	}

	if flags["esp"] then
		local drawings, highlight, chams = createESPObjects(player)
		player_data[player]["drawings"] = drawings
		player_data[player]["highlight"] = highlight
		player_data[player]["chams"] = chams
	end

	menu_references["players_box"]:addOption(player.Name)

	repeat _wait() until getEntry(player) or player == nil

	if player == nil then
		return end

	player_data[player]["entry"] = getEntry(player)
end)

local playerRemoving = LPH_NO_VIRTUALIZE(function(player)
	local data = player_data[player]

	if not data then
		return 
	end

	if lplr_data["viewing"] == player then
		camera.CameraSubject = char
		lplr_data["viewing"] = nil
	end

	local drawings = data["drawings"]
	if drawings then
		for _, drawing in drawings do
			drawing:Destroy()
		end
	end

	local highlight = data["highlight"]
	if highlight then
		highlight:Destroy()
	end

	menu_references["players_box"]:removeOption(player.Name)

	player_data[player] = nil
end)

utility.newConnection(plrs.PlayerAdded, playerAdded, true)
utility.newConnection(plrs.PlayerRemoving, playerRemoving, true)

------------------
-- * UI Setup * --
------------------

local window = menu:init(
	{
		[1] = {
			icon = "rbxassetid://15453302474"
		},
		[2] = {
			icon = "rbxassetid://15453313321"
		},
		[3] = {
			icon = "rbxassetid://15453335745"
		},
		[4] = {
			icon = "rbxassetid://15453344494"
		},
		[5] = {
			icon = "rbxassetid://15453349637"
		},
		[6] = {
			icon = "rbxassetid://15453354931"
		},
		[7] = {
			icon = "rbxassetid://15453359751"
		},
		[8] = {
			icon = "rbxassetid://15453364412"
		}
	},
	3
)

local old_list = utility.getConfigList()
local old_script_list = utility.getScriptList()
local config_list = nil

local rage = window:getTab(1)
	local exploits_section = rage:newSection({name = "Exploits", is_changeable = false, scale = 1})
		menu_references["infinite_wallbang"] = exploits_section:newElement({name = "Infinite wallbang", types = {toggle = {flag = "infinite_wallbang"}}})
	local combat_section = rage:newSection({name = "Combat", is_changeable = false, x = 0.5, scale = 1})
		menu_references["knifebot"] = combat_section:newElement({name = "Knifebot", types = {toggle = {flag = "knifebot"}, keybind = {flag = "knifebot_keybind"}}}); keybinder:add(menu_references["knifebot"], "Knifebot", "knifebot_keybind", "knifebot")
		menu_references["knifebot_headshot"] = combat_section:newElement({name = "Headshot", types = {toggle = {flag = "knifebot_headshot"}}})
		menu_references["stab_distance"] = combat_section:newElement({name = "Stab distance", types = {slider = {flag = "stab_distance", min = 1, max = 12, suffix = "", prefix = ""}}})
local legit = window:getTab(3)
	local aimbot_section = legit:newSection({name = "Aimbot settings", is_changeable = false, scale = 0.7})
		menu_references["aimbot_toggle"] = aimbot_section:newElement({name = "Enabled", types = {toggle = {flag = "aimbot"}, keybind = {flag = "aimbot_keybind", method = 1}}}); keybinder:add(menu_references["aimbot_toggle"], "Aimbot", "aimbot_keybind", "aimbot")
		menu_references["auto_select_target"] = aimbot_section:newElement({name = "Auto select target", types = {toggle = {flag = "auto_select_target"}}})
		menu_references["lock_bind"] = aimbot_section:newElement({name = "Lock bind", types = {keybind = {flag = "lock_bind", method = 3, method_locked = true}}})
		menu_references["multipoint"]  = aimbot_section:newElement({name = "Multipoint", types = {toggle = {flag = "multipoint"}, slider = {flag = "multipoint_value", min = 1, max = 100, suffix = "%", prefix = ""}}})
		menu_references["silent_aim"] = aimbot_section:newElement({name = "Silent aim", types = {toggle = {flag = "silent_aim"}}})
		menu_references["silent_aim_disable_when"] = aimbot_section:newElement({name = "Disable when", types = {dropdown = {flag = "silent_aim_disable_when", multi = true, options = {"Not aiming down sights", "Out of fov", "Behind wall", "Off screen"}}}})
		menu_references["aim_assist"] = aimbot_section:newElement({name = "Aim assist", types = {toggle = {flag = "aim_assist"}, keybind = {flag = "aim_assist_keybind"}}}); keybinder:add(menu_references["aim_assist"], "Aim assist", "aim_assist_keybind", "aim_assist")
		menu_references["aim_assist_disable_when"] = aimbot_section:newElement({name = "Disable when", types = {dropdown = {flag = "aim_assist_disable_when", multi = true, options = {"Not aiming down sights", "Out of fov", "Off screen", "Behind wall"}}}})
		aimbot_section:newElement({name = "Max target distance", types = {slider = {flag = "max_target_distance", min = 50, default = 150, max = 2500, suffix = "", prefix = "", changers = 1}}})
		aimbot_section:newElement({name = "Target checks", types = {dropdown = {flag = "target_checks", multi = true, options = {"Behind wall"}}}})
	local gun_settings = legit:newSection({name = "Gun settings", is_changeable = false, x = 0.5, scale = 1})
		menu_references["selected_gun"] = gun_settings:newElement({name = "Selected gun", types = {dropdown = {flag = "selected_gun", no_none = true, default = {"Default"}, options = {"Default", "Revolvers", "Assaults", "Shotguns", "Carbines", "Snipers", "Pistols", "Dmrs"}}}})
		local function updateGunTab(tab)
			tab = tab[1]
			for gun, _ in gun_types do
				for setting, element in _["settings"] do
					element:setVisible(gun == tab)
				end
			end
		end
		for gun, _ in gun_types do
			if gun ~= "Default" then
				_["settings"] = {
					gun_settings:newElement({name = "Override general config", types = {toggle = {flag = gun.."_override_general"}}}),
					gun_settings:newElement({name = "Silent aim field of view", types = {slider = {flag = gun.."_silent_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Silent aim hit chance", types = {slider = {flag = gun.."_hit_chance", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}}),
					gun_settings:newElement({name = "Silent aim accuracy", types = {slider = {flag = gun.."_accuracy", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}}),
					gun_settings:newElement({name = "Aim assist field of view", types = {slider = {flag = gun.."_aim_assist_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Aim assist deadzone", types = {slider = {flag = gun.."_deadzone", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal smoothness", types = {slider = {flag = gun.."_aim_assist_horizontal_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical smoothness", types = {slider = {flag = gun.."_aim_assist_vertical_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal shake", types = {slider = {flag = gun.."_aim_assist_horizontal_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical shake", types = {slider = {flag = gun.."_aim_assist_vertical_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist smoothing direction", types = {dropdown = {flag = gun.."_smoothing_direction", no_none = true, default = {"Out"}, options = {"InOut", "Out", "In"}}}}),
					gun_settings:newElement({name = "Aim assist smoothing style", types = {dropdown = {flag = gun.."_smoothing_style", no_none = true, default = {"Linear"}, options = {"Linear", "Circular", "Sine", "Quad", "Quint", "Bounce", "Exponential", "Back", "Cubic", "Elastic"}}}}),
					gun_settings:newElement({name = "Hitbox", types = {dropdown = {flag = gun.."_hitbox", no_none = true, default = {"Head"}, options = {"Head", "Torso", "Arms", "Legs", "Closest"}}}}),
					gun_settings:newElement({name = "Horizontal recoil reduction", types = {slider = {flag = gun.."_reduce_horizontal", min = 0, max = 100, decimal = 1, prefix = "", suffix = "%"}}}),
					gun_settings:newElement({name = "Vertical recoil reduction", types = {slider = {flag = gun.."_reduce_vertical", min = 0, max = 100, decimal = 1, prefix = "", suffix = "%"}}})
				}
				for _, element in _["settings"] do
					if element.onSliderChange then
						utility.newConnection(element.onSliderChange, function()
							if lplr_data["gun"] == gun then
								lplr_data["reduce_horizontal"] = flags[gun.."_reduce_horizontal"]
								lplr_data["reduce_vertical"] = flags[gun.."_reduce_vertical"]
								lplr_data["hit_chance"] = flags[gun.."_hit_chance"]
								lplr_data["accuracy"] = flags[gun.."_accuracy"]
								aimbot["silent_aim_fov"] = flags[gun.."_silent_field_of_view"]*3.33
								aimbot.circle.Radius = aimbot["silent_aim_fov"]
								aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
								aimbot["aim_assist_fov"] = flags[gun.."_aim_assist_field_of_view"]*3.33
								aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
								aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
							end
						end, true)
					end
				end
			else
				_["settings"] = {
					gun_settings:newElement({name = "Silent aim field of view", types = {slider = {flag = gun.."_silent_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Silent aim hit chance", types = {slider = {flag = gun.."_hit_chance", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}}),
					gun_settings:newElement({name = "Silent aim accuracy", types = {slider = {flag = gun.."_accuracy", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}}),
					gun_settings:newElement({name = "Aim assist field of view", types = {slider = {flag = gun.."_aim_assist_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Aim assist deadzone", types = {slider = {flag = gun.."_deadzone", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal smoothness", types = {slider = {flag = gun.."_aim_assist_horizontal_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical smoothness", types = {slider = {flag = gun.."_aim_assist_vertical_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal shake", types = {slider = {flag = gun.."_aim_assist_horizontal_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical shake", types = {slider = {flag = gun.."_aim_assist_vertical_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist smoothing direction", types = {dropdown = {flag = gun.."_smoothing_direction", no_none = true, default = {"Out"}, options = {"InOut", "Out", "In"}}}}),
					gun_settings:newElement({name = "Aim assist smoothing style", types = {dropdown = {flag = gun.."_smoothing_style", no_none = true, default = {"Linear"}, options = {"Linear", "Circular", "Sine", "Quad", "Quint", "Bounce", "Exponential", "Back", "Cubic", "Elastic"}}}}),
					gun_settings:newElement({name = "Hitbox", types = {dropdown = {flag = gun.."_hitbox", no_none = true, default = {"Head"}, options = {"Head", "Torso", "Arms", "Legs", "Closest"}}}}),
					gun_settings:newElement({name = "Horizontal recoil reduction", types = {slider = {flag = gun.."_reduce_horizontal", min = 0, max = 100, decimal = 1, prefix = "", suffix = "%"}}}),
					gun_settings:newElement({name = "Vertical recoil reduction", types = {slider = {flag = gun.."_reduce_vertical", min = 0, max = 100, decimal = 1, prefix = "", suffix = "%"}}})
				}
				for _, element in _["settings"] do
					if element.onSliderChange then
						utility.newConnection(element.onSliderChange, function()
							if lplr_data["gun"] == gun then
								lplr_data["reduce_horizontal"] = flags[gun.."_reduce_horizontal"]
								lplr_data["reduce_vertical"] = flags[gun.."_reduce_vertical"]
								lplr_data["hit_chance"] = flags[gun.."_hit_chance"]
								lplr_data["accuracy"] = flags[gun.."_accuracy"]
								aimbot["silent_aim_fov"] = flags[gun.."_silent_field_of_view"]*3.33
								aimbot.circle.Radius = aimbot["silent_aim_fov"]
								aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
								aimbot["aim_assist_fov"] = flags[gun.."_aim_assist_field_of_view"]*3.33
								aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
								aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
							end
						end, true)
					end
				end
			end
		end
		updateGunTab({"Default"})
		utility.newConnection(menu_references["selected_gun"].onDropdownChange, updateGunTab, true)
	local aimbot_visualization = legit:newSection({name = "Aimbot visualization", is_changeable = false, scale = 0.3, x = 0, y = 0.7})
		menu_references["show_aim_assist_fov"] = aimbot_visualization:newElement({name = "Show aim assist fov", types = {toggle = {default = true, flag = "aim_assist_fov"}, colorpicker = {flag = "aim_assist_fov_color", transparency_flag = "aim_assist_fov_transparency"}}})
		menu_references["aim_assist_fov_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {default = false, flag = "aim_assist_fov_filled"}}})
		menu_references["show_fov"] = aimbot_visualization:newElement({name = "Show silent aim fov", types = {toggle = {default = true, flag = "show_fov"}, colorpicker = {flag = "fov_color", transparency_flag = "fov_transparency"}}})
		menu_references["show_fov_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {default = false, flag = "show_fov_filled"}}})
		menu_references["gradient_overlay"] = aimbot_visualization:newElement({name = "Gradient overlay", types = {toggle = {flag = "gradient_overlay"}, colorpicker = {flag = "gradient_overlay_color", transparency_flag = "gradient_overlay_transparency"}}})
		menu_references["gradient_glow"] = aimbot_visualization:newElement({name = "Glow", types = {toggle = {flag = "gradient_glow"}}})
		menu_references["bounding_box"] = aimbot_visualization:newElement({name = "Bounding box", types = {toggle = {flag = "bounding_box"}, colorpicker = {flag = "bounding_box_color", transparency_flag = "bounding_box_transparency"}}})
		menu_references["bounding_box_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {flag = "bounding_box_filled"}}})
local visuals = window:getTab(4)
	local player_esp_section = visuals:newSection({name = "Player ESP", is_changeable = true, scale = 0.6})
		menu_references["esp_toggle"] = player_esp_section:newElement({name = "Enabled", types = {toggle = {flag = "esp"}}})
		menu_references["box_toggle"] = player_esp_section:newElement({name = "Box", types = {toggle = {flag = "box"}, colorpicker = {flag = "box_color", transparency_flag = "box_transparency"}}})
		menu_references["fill_toggle"] = player_esp_section:newElement({name = "Filled", types = {toggle = {flag = "box_fill"}}})
		menu_references["name_toggle"] = player_esp_section:newElement({name = "Name", types = {toggle = {flag = "name"}, colorpicker = {flag = "name_color", transparency_flag = "name_transparency"}}})
		menu_references["name_display"] = player_esp_section:newElement({name = "Use display name", types = {toggle = {flag = "name_display"}}})
		menu_references["name_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "name_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["weapon_toggle"] = player_esp_section:newElement({name = "Weapon",types = {toggle = {flag = "weapon"}, colorpicker = {flag = "weapon_color", transparency_flag = "weapon_transparency"}}})
		menu_references["weapon_surrounding"] = player_esp_section:newElement({name = "Surrounding", types = {dropdown = {flag = "surrounding", no_none = true, default = {"Brackets"}, options = {"Brackets", "Arrows", "None"}}}})
		menu_references["weapon_casing"] = player_esp_section:newElement({name = "Casing", types = {dropdown = {flag = "weapon_casing", no_none = true, default = {"Lowercase"}, options = {"Lowercase", "Uppercase", "Normal"}}}})
		menu_references["weapon_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "weapon_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["highlight_toggle"] = player_esp_section:newElement({name = "Highlight", types = {toggle = {flag = "highlight"}, colorpicker = {flag = "highlight_color", default_transparency = 0.6, default = colorfromrgb(93, 169, 240), transparency_flag = "highlight_transparency"}}})
		menu_references["through_walls"] = player_esp_section:newElement({name = "Through walls", types = {toggle = {flag = "through_walls", default = true}}})
		menu_references["highlight_outline"] = player_esp_section:newElement({name = "Outline", types = {colorpicker = {flag = "outline_color", default = colorfromrgb(255, 105, 247), transparency_flag = "outline_transparency"}}})
		menu_references["skeleton_toggle"] = player_esp_section:newElement({name = "Skeleton", types = {toggle = {flag = "skeleton"}, colorpicker = {flag = "skeleton_color", default = colorfromrgb(255, 255, 255), transparency_flag = "skeleton_transparency"}}})
		menu_references["health_toggle"] = player_esp_section:newElement({name = "Health bar", types = {toggle = {flag = "health"}, colorpicker = {flag = "health_color", default = colorfromrgb(105, 255, 117), transparency_flag = "health_transparency"}}})
		menu_references["health_number"] = player_esp_section:newElement({name = "Number", types = {toggle = {flag = "health_number"}, colorpicker = {flag = "number_color", transparency_flag = "number_transparency"}}})
		menu_references["chams_toggle"] = player_esp_section:newElement({name = "Chams", types = {toggle = {flag = "chams"}, colorpicker = {flag = "chams_color", default_transparency = 0.6, default = colorfromrgb(0,255,0), transparency_flag = "chams_transparency"}}})
		menu_references["visible_chams_toggle"] = player_esp_section:newElement({name = "Visible chams", types = {toggle = {flag = "visible_chams"}, colorpicker = {flag = "visible_chams_color", default_transparency = 0.4, default = colorfromrgb(255,0,0), transparency_flag = "visible_chams_transparency"}}})
		menu_references["gradient_bars"] = player_esp_section:newElement({name = "Gradient bars", types = {toggle = {default = true, flag = "gradient_bars"}}})
		menu_references["esp_font"] = player_esp_section:newElement({name = "Text font", types = {dropdown = {flag = "esp_font", no_none = true, default = {"2"}, options = {"1", "2", "3", "4"}}}})
	local world_section = visuals:newSection({name = "World", is_changeable = true, x = 0.5, scale = 0.3})
		menu_references["world_brightness"] = world_section:newElement({name = "World brightness", types = {toggle = {flag = "world_brightness"}, slider = {flag = "world_brightness", prefix = "", suffix = "", min = 0, max = 5, decimal = 1, default = spoof_properties["Brightness"]}}})
		menu_references["remove_shadows"] = world_section:newElement({name = "Remove shadows", types = {toggle = {flag = "remove_shadows"}}})
		menu_references["world_exposure"] = world_section:newElement({name = "World exposure", types = {toggle = {flag = "world_exposure"}, slider = {flag = "world_exposure_value", prefix = "", suffix = "", min = -2, decimal = 1, max = 3, default = spoof_properties["ExposureCompensation"]}}})
		menu_references["world_ambient"] = world_section:newElement({name = "World ambient", types = {toggle = {flag = "world_ambient"}, colorpicker = {flag = "world_ambient_color", default = spoof_properties["Ambient"], transparency_flag = "world_ambient_transparency"}}})
		menu_references["world_skybox"] = world_section:newElement({name = "World skybox", types = {toggle = {flag = "world_skybox"}, dropdown = {flag = "world_skybox_skybox", no_none = true, default = {"Crimson Night"}, options = {"Crimson Night", "Abyssal Blues", "Orange Sunset", "Blue Galaxy", "Stormy Night", "Spongebob", "Sunrise", "Snowy", "Retro"}}}})
		menu_references["world_time"] = world_section:newElement({name = "World time", types = {toggle = {flag = "world_time"}, slider = {flag = "world_time_value", prefix = "", suffix = "", min = 0, max = 24, decimal = 1, default = spoof_properties["ClockTime"]}}})
		menu_references["fog_changer"] = world_section:newElement({name = "World fog", types = {toggle = {flag = "fog_changer"}, colorpicker = {flag = "fog_color", transparency_flag = "fog_transparency", default = spoof_properties["FogColor"]}}})
		menu_references["fog_start"] = world_section:newElement({name = "Fog start", types = {slider = {flag = "fog_start", prefix = "", suffix = "", min = 1, max = 5000, default = spoof_properties["FogStart"]}}})
		menu_references["fog_end"] = world_section:newElement({name = "Fog end", types = {slider = {flag = "fog_end", prefix = "", suffix = "", min = 1, max = 5000, default = spoof_properties["FogEnd"]}}})
	local hud_section = visuals:newSection({name = "Hud", is_changeable = true, x = 0.5, y = 0.3, scale = 0.3})
		menu_references["drawing_crosshair"] = hud_section:newElement({name = "Drawing crosshair", types = {toggle = {flag = "drawing_crosshair"}, colorpicker = {flag = "drawing_crosshair_color", transparency_flag = "drawing_crosshair_transparency"}}})
		menu_references["crosshair_smoothness"] = hud_section:newElement({name = "Smoothness", types = {slider = {flag = "crosshair_smoothness", suffix = "%", prefix = "", min = 0, max = 100}}})
		menu_references["drawing_crosshair_spin"] = hud_section:newElement({name = "Spin", types = {toggle = {flag = "drawing_crosshair_spin"}, slider = {flag = "drawing_crosshair_speed", suffix = "%", prefix = "", min = 1, max = 100}}})
		menu_references["drawing_crosshair_location"] = hud_section:newElement({name = "Location", types = {dropdown = {flag = "drawing_crosshair_location", options = {"Mouse", "Center", "Target"}, no_none = true, default = {"Mouse"}}}})
		menu_references["drawing_crosshair_length"] = hud_section:newElement({name = "Length", types = {slider = {flag = "drawing_crosshair_length", suffix = "px", prefix = "", min = 5, max = 100}}})
		menu_references["drawing_crosshair_gap"] = hud_section:newElement({name = "Gap", types = {slider = {flag = "drawing_crosshair_gap", suffix = "px", prefix = "", min = 5, max = 100}}})
		menu_references["notifications_"] = hud_section:newElement({name = "Notifications", types = {toggle = {flag = "notifications"}, colorpicker = {default = colorfromrgb(255,255,255), transparency_flag = "notification_transparency",  default_transparency = 0, flag = "notification_color"}, dropdown = {multi = true, options = {"Target changes", "Hits"}, flag = "notifications_selected"}}})
		menu_references["notification_style"] = hud_section:newElement({name = "Style", types = {dropdown = {options = {"Default", "Minimalistic", "Eclipse"}, no_none = true, default = {"Default"}, flag = "notification_style"}}})
		menu_references["notification_font"] = hud_section:newElement({name = "Font", types = {dropdown = {options = {"1", "2", "3", "4"}, no_none = true, flag = "notification_font", default = {"2"}}}})
		menu_references["notification_y_offset"] = hud_section:newElement({name = "Y offset", types = {slider = {prefix = "", suffix = "px", min = 0, max = 1080, default = 200, flag = "notification_y_offset"}}})
		menu_references["keybinds_list"] = hud_section:newElement({name = "Keybinds list", types = {toggle = {flag = "keybinds_list"}, colorpicker = {flag = "keybinds_list_color", transparency_flag = "keybinds_list_transparency"}}})
		menu_references["keybinds_style"] = hud_section:newElement({name = "Style", types = {dropdown = {options = {"Default", "Gradient", "Color"}, no_none = true, default = {"Default"}, flag = "keybinds_style"}}})
		menu_references["keybinds_font"] = hud_section:newElement({name = "Font", types = {dropdown = {options = {"1", "2", "3", "4"}, no_none = true, flag = "keybinds_font", default = {"2"}}}})
		menu_references["watermark"] = hud_section:newElement({name = "Center watermark", types = {toggle = {flag = "watermark"}, colorpicker = {flag = "watermark_color", default = colorfromrgb(153, 196, 39), transparency_flag = "watermark_transparency"}}})
		menu_references["watermark_font"] = hud_section:newElement({name = "Font", types = {dropdown = {options = {"1", "2", "3", "4"}, no_none = true, flag = "watermark_font", default = {"2"}}}})
		menu_references["watermark_size"] = hud_section:newElement({name = "Size", types = {slider = {flag = "watermark_size", min = 12, default = 14, max = 30, suffix = "", prefix = ""}}})
		menu_references["watermark_x_offset"] = hud_section:newElement({name = "X offset", types = {slider = {flag = "watermark_x_offset", min = -500, default = 0, max = 500, suffix = "px", prefix = ""}}})
		menu_references["watermark_y_offset"] = hud_section:newElement({name = "Y offset", types = {slider = {flag = "watermark_y_offset", min = -500, default = 0, max = 500, suffix = "px", prefix = ""}}})
		menu_references["watermark_location"] = hud_section:newElement({name = "Location", types = {dropdown = {flag = "watermark_location", options = {"Center", "Target", "Mouse"}, no_none = true, default = {"Center"}}}})
	local world_esp = visuals:newSection({name = "World ESP", is_changeable = true, y = 0.6, scale = 0.4})
		menu_references["grenade_warnings_esp"] = world_esp:newElement({name = "Grenade warnings", types = {toggle = {flag = "grenade_warnings"}}})
		menu_references["ragdoll_changer"] = world_esp:newElement({name = "Ragdoll changer", types = {toggle = {flag = "ragdoll_changer"}, colorpicker = {default = colorfromrgb(255,255,255), transparency_flag = "ragdoll_transparency", default_transparency = 0, flag = "ragdoll_color"}}})
		menu_references["ragdoll_material"] = world_esp:newElement({name = "Material", types = {dropdown = {flag = "ragdoll_material", options = {"ForceField", "Glass", "Neon"}, no_none = true, default = {"ForceField"}}}})
		menu_references["dropped_weapon_esp"] = world_esp:newElement({name = "Dropped weapons", types = {toggle = {flag = "dropped_weapon"}, colorpicker = {default = colorfromrgb(255,255,255), transparency_flag = "dropped_weapon_transparency",  default_transparency = 0, flag = "dropped_weapon_color"}}})
		menu_references["dropped_weapon_max_distance"] = world_esp:newElement({name = "Max distance", types = {slider = {flag = "dropped_weapon_max_distance", min = 10, max = 500, default = 150, decimal = 0, prefix = "", suffix = " studs"}}})
		menu_references["dropped_weapon_surrounding"] = world_esp:newElement({name = "Surrounding", types = {dropdown = {flag = "dropped_weapon_surrounding", no_none = true, default = {"Brackets"}, options = {"Brackets", "Arrows", "None"}}}})
		menu_references["dropped_weapon_casing"] = world_esp:newElement({name = "Casing", types = {dropdown = {flag = "dropped_weapon_casing", no_none = true, default = {"Lowercase"}, options = {"Lowercase", "Uppercase", "Normal"}}}})
		menu_references["dropped_weapon_font"] = world_esp:newElement({name = "Text font", types = {dropdown = {options = {"1", "2", "3", "4"}, no_none = true, flag = "dropped_weapon_font", default = {"2"}}}})
		menu_references["dropped_weapon_size"] = world_esp:newElement({name = "Size", types = {slider = {flag = "dropped_weapon_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
	local other_section = visuals:newSection({name = "Other", is_changeable = true, x = 0.5, y = 0.6, scale = 0.4})
		menu_references["viewmodel_changer"] = other_section:newElement({name = "Viewmodel changer", types = {toggle = {flag = "viewmodel_changer"}}})
		menu_references["x_position"] = other_section:newElement({name = "X position", types = {slider = {flag = "viewmodel_x", min = -5, default = 0, decimal = 1, max = 5, suffix = "", prefix = ""}}})
		menu_references["y_position"] = other_section:newElement({name = "Y position", types = {slider = {flag = "viewmodel_y", min = -5, default = 0, decimal = 1, max = 5, suffix = "", prefix = ""}}})
		menu_references["z_position"] = other_section:newElement({name = "Z position", types = {slider = {flag = "viewmodel_z", min = -5, default = 0, decimal = 1, max = 5, suffix = "", prefix = ""}}})
		menu_references["roll"] = other_section:newElement({name = "Roll", types = {slider = {flag = "viewmodel_roll", min = 0, max = 360, suffix = "°", prefix = ""}}})
		menu_references["weapon_highlight"] = other_section:newElement({name = "Weapon highlight", types = {toggle = {flag = "weapon_highlight"}, colorpicker = {flag = "weapon_highlight_color", transparency_flag = "weapon_highlight_transparency"}}})
		menu_references["weapon_outline"] = other_section:newElement({name = "Weapon outline", types = {colorpicker = {flag = "weapon_outline_color", transparency_flag = "weapon_outline_transparency"}}})
		menu_references["weapon_material"] = other_section:newElement({name = "Weapon material", types = {toggle = {flag = "weapon_material"}, colorpicker = {flag = "weapon_material_color", transparency_flag = "weapon_material_transparency"}}})
		menu_references["weapon_material_dropdown"] = other_section:newElement({name = "Material", types = {dropdown = {options = {"ForceField", "Glass", "Neon"}, no_none = true, default = {"ForceField"}, flag = "weapon_material_dropdown"}}})
		menu_references["arms_highlight"] = other_section:newElement({name = "Arms highlight", types = {toggle = {flag = "arms_highlight"}, colorpicker = {flag = "arms_highlight_color", transparency_flag = "arms_highlight_transparency"}}})
		menu_references["arms_outline"] = other_section:newElement({name = "Arms outline", types = {colorpicker = {flag = "arms_outline_color", transparency_flag = "arms_outline_transparency"}}})
		menu_references["arms_material"] = other_section:newElement({name = "Arms material", types = {toggle = {flag = "arms_material"}, colorpicker = {flag = "arms_material_color", transparency_flag = "arms_material_transparency"}}})
		menu_references["arms_material_dropdown"] = other_section:newElement({name = "Material", types = {dropdown = {options = {"ForceField", "Glass", "Neon"}, no_none = true, default = {"ForceField"}, flag = "arms_material_dropdown"}}})
		menu_references["hit_effect"] = other_section:newElement({name = "Hit effect", types = {toggle = {flag = "hit_effect"}, colorpicker = {flag = "hit_effect_color", transparency_flag = "hit_effect_transparency"}, dropdown = {options = {"Lightning", "Explosion", "Sludge", "Bubble", "Sparks", "Void"}, flag = "hit_effect_effect", default = {"Bubble"}, no_none = true}}})
		menu_references["hit_chams"] = other_section:newElement({name = "Hit chams", types = {toggle = {flag = "hit_chams"}, dropdown = {options = {"ForceField", "Neon"}, flag = "hit_chams_material", default = {"ForceField"}, no_none = true}, colorpicker = {flag = "hit_chams_color", default = colorfromrgb(255,0,0), transparency_flag = "hit_chams_transparency"}}})
		menu_references["hit_chams_lifetime"] = other_section:newElement({name = "Chams lifetime", types = {slider = {flag = "hit_chams_lifetime", min = 0.1, max = 1.5, prefix = "", suffix = "s", decimal = 1}}})
		menu_references["hit_chams_fade"] = other_section:newElement({name = "Fade", types = {toggle = {flag = "hit_chams_fade"}}})
		menu_references["hitmarker"] = other_section:newElement({name = "Hitmarker", types = {toggle = {flag = "hitmarker"}, colorpicker = {flag = "hitmarker_color", transparency_flag = "hitmarker_tranparency"}, dropdown = {options = {"2D", "3D"}, flag = "hitmarker_style", default = {"2D"}, no_none = true}}})
		menu_references["hitmarker_size"] = other_section:newElement({name = "Size", types = {slider = {flag = "hitmarker_size", min = 5, max = 30, suffix = "", decimal = 1, default = 10, prefix = ""}}})
		menu_references["hitmarker_gap"] = other_section:newElement({name = "Gap", types = {slider = {flag = "hitmarker_gap", min = 5, max = 30, suffix = "", decimal = 1, default = 10, prefix = ""}}})
		menu_references["hitsound"] = other_section:newElement({name = "Hitsound", types = {toggle = {flag = "hitsound"}, dropdown = {options = {"Minecraft", "Gamesense", "Neverlose", "Bameware", "Bubble", "RIFK7", "Rust", "Cod", "Custom"}, flag = "hitsound_sound", default = {"Gamesense"}, no_none = true}}})
		menu_references["custom_id"] = other_section:newElement({name = "Custom ID", types = {textbox = {flag = "custom_id"}}})
		menu_references["hitsound_volume"] = other_section:newElement({name = "Volume", types = {slider = {flag = "volume", min = 0.1, max = 5, suffix = "", decimal = 1, default = 1, prefix = ""}}})
local misc = window:getTab(5)
    local movement_section = misc:newSection({name = "Movement", is_changeable = true, scale = 0.5})
        menu_references["cframe_speed"] = movement_section:newElement({name = "CFrame speed", types = {toggle = {flag = "cframe_speed"}, keybind = {flag = "cframe_speed_keybind"}}}); keybinder:add(menu_references["cframe_speed"], "CFrame speed", "cframe_speed_keybind", "cframe_speed")
        menu_references["cframe_speed_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_speed_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
        menu_references["cframe_fly"] = movement_section:newElement({name = "CFrame fly", types = {toggle = {flag = "cframe_fly"}, keybind = {flag = "cframe_fly_keybind"}}}); keybinder:add(menu_references["cframe_fly"], "CFrame fly", "cframe_fly_keybind", "cframe_fly")
		menu_references["cframe_fly_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_fly_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		menu_references["auto_jump"] = movement_section:newElement({name = "Auto jump", types = {toggle = {flag = "auto_jump"}, keybind = {flag = "auto_jump_keybind"}}}); keybinder:add(menu_references["auto_jump"], "Auto jump", "auto_jump_keybind", "auto_jump")
	local game_section = misc:newSection({name = "Game modifiers", is_changeable = true, y = 0.5, scale = 0.5})
		game_section:newElement({name = "Instant equip", types = {toggle = {flag = "instant_equip"}}})
		game_section:newElement({name = "No melee sway", types = {toggle = {flag = "no_melee_sway"}}})
		game_section:newElement({name = "No gun sway", types = {toggle = {flag = "no_gun_sway"}}})
		menu_references["firerate_modifier"] = game_section:newElement({name = "Firerate modifier", types = {toggle = {flag = "firerate_modifier"}}})
		menu_references["modifier"] = game_section:newElement({name = "Modifier", types = {slider = {flag = "modifier", suffix = "x", decimal = 2, prefix = "", min = 1, max = 10}}})
local players_tab = window:getTab(7)
	local players_section = players_tab:newSection({name = "Players", is_changeable = true, x = 0, scale = 1})
		menu_references["players_box"] = players_section:newElement({name = "_", types = {multibox = {max = 12, search = true}}})
		menu_references["aimbot_priority"] = players_section:newElement({name = "Priority", types = {toggle = {no_load = true, flag = "aimbot_priority"}}})
		menu_references["whitelisted"] = players_section:newElement({name = "Whitelisted", types = {toggle = {no_load = true, flag = "whitelisted"}}})
local configuration = window:getTab(8)
		local config_section = configuration:newSection({name = "Configs", is_changeable = false, scale = 0.8})
			config_list = config_section:newElement({name = "Config list", types = {multibox = {max = 8, search = true}}})
			config_section:newElement({name = "Update config", types = {button = {text = "Update config", 
				callback = function()
					local option = config_list.selected_option
					if option then
						utility.saveConfig(option)
						for _, config in old_list do
							config_list:removeOption(config)
						end
						old_list = utility.getConfigList()
						for _, config in old_list do
							config_list:addOption(config)
						end
					end
				end
			}}})
			config_section:newElement({name = "Load config", types = {button = {text = "Load config",
			callback = function()
				if config_list.selected_option then
					utility.loadConfig(config_list.selected_option)
					menu.on_load:Fire()
					if flags["keybind_position"] then
						keybinder:move(vector2new(flags["keybind_position"][2], flags["keybind_position"][3]))
					end
				end
			end
		}}})
			config_section:newElement({name = "Config name", types = {textbox = {no_load = true, flag = "config_name"}}})
			config_section:newElement({name = "Create config", types = {button = {text = "Create config", 
				callback = function()
					if #flags["config_name"] > 0 then
						utility.saveConfig(flags["config_name"])
						for _, config in old_list do
							config_list:removeOption(config)
						end
						old_list = utility.getConfigList()
						for _, config in old_list do
							config_list:addOption(config)
						end
					end
				end
			}}})
			config_section:newElement({name = "Refresh list", types = {button = {text = "Refresh list",
				callback = function()
					for _, config in old_list do
						config_list:removeOption(config)
					end
					old_list = utility.getConfigList()
					for _, config in old_list do
						config_list:addOption(config)
					end
				end
			}}})
		local menu_section = configuration:newSection({name = "Menu", is_changeable = false, y = 0.8, scale = 0.2})
			utility.newConnection(menu_section:newElement({name = "Menu toggle key", types = {keybind = {flag = "menu_key", key = Enum.KeyCode.Insert, method = 2, method_locked = true}}}).onActiveChange, function()
				if flags["menu_key"]["key"] ~= nil then
					menu["toggle"] = string.upper(flags["menu_key"]["key"]["Name"])
				end
			end)
			utility.newConnection(menu_section:newElement({name = "Menu color", types = {colorpicker = {flag = "menu_accent", transparency_flag = "", default = menu.accent_color}}}).onColorChange, function(color)
				menu:set_accent_color(color)
			end)
			local unload_cheat = menu_section:newElement({name = "Unload cheat", types = {button = {text = "Unload cheat",
				callback = function()
					for player, info in player_data do
						local highlight = info["highlight"]
						if highlight then
							highlight:Destroy()
						end
						local drawings = info["drawings"]
						if drawings then
							for _, drawing in drawings do
								drawing:Destroy()
							end
						end
					end
					for flag, value in pairs(flags) do
						if typeof(value) == "boolean" then
							flags[flag] = false
						end
					end
					menu.on_load:Fire()
					for _, connection in utility.connections do
						connection:Disconnect()
					end
					_screenGui:Destroy()
					for _, drawing in keybinder.drawings do
						drawing:Destroy()
					end
					for lua, _ in script_environment do
						task.cancel(script_environment[lua])
						script_environment[lua] = nil
						script_unloaded:Fire(lua)
					end
					getgenv().juju = nil
				end
			}}})
			local disable_all = menu_section:newElement({name = "Disable all", types = {button = {text = "Disable all",
				callback = function()
					for flag, value in pairs(flags) do
						if typeof(value) == "boolean" then
							flags[flag] = false
						end
					end
					menu.on_load:Fire()
				end
			}}})
		local lua_section = configuration:newSection({name = "LUA", is_changeable = false, x = 0.5, scale = 1})
			local script_environment = {}
			local script_unloaded = signal.new()
			getgenv().juju = {
				aimbot_target_changed = aimbotTargetChange,
				script_unloaded = script_unloaded,
				menu_references = menu_references,
				flags = flags,
				section = lua_section,
				hit_player = lplrHitPlayer,
				set_aimbot_target = LPH_NO_VIRTUALIZE(function(target)
					if target == nil then
						aimbot["target"] = nil
						aimbotTargetChange:Fire(nil)
						return
					end
	
					if typeof(target) ~= "Instance" then
						return error("juju.lol\n	tried to set target as class \""..typeof(target).."\" (expected Player)") end
	
					if target.ClassName ~= "Player" then
						return error("juju.lol\n	tried to set target as object \""..typeof(target).."\" (expected Player)") end
	
					aimbot["target"] = target
					aimbotTargetChange:Fire(nil)
				end),
				get_aimbot_target = LPH_NO_VIRTUALIZE(function()
					return aimbot["target"]
				end)
			}
			local script_list = lua_section:newElement({name = "Script list", types = {multibox = {max = 2, search = true}}})
			lua_section:newElement({name = "Load script", types = {button = {text = "Load script",
				callback = function()
					if script_list.selected_option and not script_environment[script_list.selected_option] then
						local data = nil
						pcall(function()
							data = readfile(config_location.."/scripts/"..script_list.selected_option..".lua")
						end)
	
						if not data then
							error("juju.lol\n	failed to read script \""..script_list.selected_option.."\"")
							return
						end
	
						local new_script_list = utility.getScriptList()
						for name, lua in script_environment do
							if not find(new_script_list, name..".lua") then
								task.cancel(lua)
								script_environment[name] = nil
							end	
						end
	
						task.wait()
	
						local s, err = pcall(function()
							script_environment[script_list.selected_option] = task.spawn(loadstring(data))
						end)
						
						if not s then
							error(err)
						end
					end
				end
			}}})
			lua_section:newElement({name = "Unload script", types = {button = {text = "Unload script",
				callback = function()
					if script_list.selected_option and script_environment[script_list.selected_option]  then
						local lua = script_list.selected_option 
	
						if not lua then
							error("juju.lol\n	failed to unload script \""..script_list.selected_option.."\"")
							return 
						end
	
						task.cancel(script_environment[lua])
						script_environment[lua] = nil
						script_unloaded:Fire(lua)
					end
				end
			}}})
			lua_section:newElement({name = "Refresh list", types = {button = {text = "Refresh list",
				callback = function()
					for _, lua in old_script_list do
						script_list:removeOption(lua)
					end
					old_script_list = utility.getScriptList()
					for _, lua in old_script_list do
						script_list:addOption(lua)
					end
				end
			}}})
			for _, lua in old_script_list do
				script_list:addOption(lua)
			end
local move_connection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if flags["keybinds_list"] and utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
			_spawn(function()
				while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					_wait()
					keybinder:move(uis:GetMouseLocation())
				end
			end)
		end
	end
end), true)

utility.newConnection(menu.on_opening, function()
	if move_connection then
		move_connection:Disconnect()
	end
	move_connection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if flags["keybinds_list"] and utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
				_spawn(function()
					while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						_wait()
						keybinder:move(uis:GetMouseLocation())
					end
				end)
			end
		end
	end), true)
end, true)

utility.newConnection(menu.on_closing, function()
	if move_connection then
		move_connection:Disconnect()
	end
end, true)

-----------------
-- * UI Init * --
-----------------

for _, config in old_list do
	config_list:addOption(config)
end

--------------------------
-- * Feature Updaters * --
--------------------------

local part_connection = nil

utility.newConnection(ignored_folder.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
    if object.Name == "RefPlayer" then
		if part_connection then
			part_connection:Disconnect()
		end
		character_parts = {}
        lplr_data["character_model"] = object
		for _, child in object:GetChildren() do
			character_parts[child.Name] = child
		end
		part_connection = utility.newConnection(object.ChildAdded, function(part)
			character_parts[part.Name] = part
		end, true)
    end
end), true)
lplr_data["character_model"] = ignored_folder:FindFirstChild("RefPlayer")

if lplr_data["character_model"] then
	for _, child in object:GetChildren() do
		character_parts[child.Name] = child
	end
	part_connection = utility.newConnection(object.ChildAdded, function(part)
		character_parts[part.Name] = part
	end, true)
end

do
    local camera_added_connection = nil
    local camera_added_connection2 = nil

	local applyMaterial = LPH_NO_VIRTUALIZE(function(part, color, material)
		for _, descendant in part:GetDescendants() do
			local class = descendant.ClassName
			if class == "SpecialMesh" then
				descendant.TextureId = ""
			elseif class == "MeshPart" then
				descendant.TextureID = ""
				descendant.Color = color
				descendant.Material = material
			elseif class == "UnionOperation" then
				descendant.UsePartColor = true
				descendant.Color = color
				descendant.Material = material
			elseif class == "Part" then
				descendant.Color = color
				descendant.Material = material
			elseif class == "Texture" then
				descendant:Destroy()
			end
		end
	end)
	utility.newConnection(menu_references["weapon_material"].onToggleChange, function(bool)
		if camera_added_connection2 then
			camera_added_connection2:Disconnect()
		end
		if bool then
			camera_added_connection2 = utility.newConnection(camera.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
				if object.ClassName == "Model" then
					if object.Name ~= "Left Arm" and object.Name ~= "Left Arm" then
						applyMaterial(object, flags["weapon_material_color"], Enum.Material[flags["weapon_material_dropdown"][1]])
					end
				end
			end), true)
			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" then
					if object.Name ~= "Left Arm" and object.Name ~= "Left Arm" then
						applyMaterial(object, flags["weapon_material_color"], Enum.Material[flags["weapon_material_dropdown"][1]])
					end
				end
			end
		end
		menu_references["weapon_material_dropdown"]:setVisible(bool)
	end, true)
	menu_references["weapon_material_dropdown"]:setVisible(false)

	utility.newConnection(menu_references["arms_material"].onToggleChange, function(bool)
		if camera_added_connection then
			camera_added_connection:Disconnect()
		end
		if bool then
			camera_added_connection = utility.newConnection(camera.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
				if object.ClassName == "Model" then
					if object.Name == "Left Arm" then
						applyMaterial(object, flags["arms_material_color"], Enum.Material[flags["arms_material_dropdown"][1]])
					elseif object.Name == "Right Arm" then
						applyMaterial(object, flags["arms_material_color"], Enum.Material[flags["arms_material_dropdown"][1]])
					end
				end
			end), true)
			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" then
					if object.Name == "Left Arm" then
						applyMaterial(object, flags["arms_material_color"], Enum.Material[flags["arms_material_dropdown"][1]])
					elseif object.Name == "Right Arm" then
						applyMaterial(object, flags["arms_material_color"], Enum.Material[flags["arms_material_dropdown"][1]])
					end
				end
			end
		end
		menu_references["arms_material_dropdown"]:setVisible(bool)
	end, true)
	menu_references["arms_material_dropdown"]:setVisible(false)

	utility.newConnection(menu_references["weapon_material"].onColorChange, function(color)
		if flags["weapon_material"] then
			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" then
					if object.Name ~= "Left Arm" and object.Name ~= "Left Arm" then
						applyMaterial(object, color, Enum.Material[flags["weapon_material_dropdown"][1]])
					end
				end
			end
		end
	end, true)

	utility.newConnection(menu_references["weapon_material_dropdown"].onDropdownChange, function(color)
		if flags["weapon_material"] then
			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" then
					if object.Name ~= "Left Arm" and object.Name ~= "Left Arm" then
						applyMaterial(object, color, Enum.Material[flags["weapon_material_dropdown"][1]])
					end
				end
			end
		end
	end, true)

	utility.newConnection(menu_references["arms_material"].onColorChange, function(color)
		if flags["arms_material"] then
			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" then
					if object.Name == "Left Arm" then
						applyMaterial(object, color, Enum.Material[flags["arms_material_dropdown"][1]])
					elseif object.Name == "Right Arm" then
						applyMaterial(object, color, Enum.Material[flags["arms_material_dropdown"][1]])
					end
				end
			end
		end
	end, true)

	utility.newConnection(menu_references["arms_material_dropdown"].onDropdownChange, function()
		if flags["arms_material"] then
			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" then
					if object.Name == "Left Arm" then
						applyMaterial(object, flags["arms_material_color"], Enum.Material[flags["arms_material_dropdown"][1]])
					elseif object.Name == "Right Arm" then
						applyMaterial(object, flags["arms_material_color"], Enum.Material[flags["arms_material_dropdown"][1]])
					end
				end
			end
		end
	end, true)
end

utility.newConnection(menu_references["infinite_wallbang"].onToggleChange, LPH_JIT(function(bool)
	workspace.Map.Parent = bool and ignored_folder or workspace
end), true)

local applyRagdoll = LPH_NO_VIRTUALIZE(function(ragdoll)
	task.wait()
	local material = Enum.Material[flags["ragdoll_material"][1]]
	local transparency = flags["ragdoll_transparency"]
	local color = flags["ragdoll_color"]

	for _, descendant in ragdoll:GetDescendants() do
		local class = descendant.ClassName
		if class == "SpecialMesh" or class == "Texture" then
			descendant:Destroy()
		elseif class == "MeshPart" then
			descendant.TextureID = ""
			descendant.Transparency = transparency
			descendant.Color = color
			descendant.Material = material
		elseif class == "Part" then
			descendant.Transparency = transparency
			descendant.Color = color
			descendant.Material = material
		end
	end
end)

local ragdollConnection = nil

utility.newConnection(menu_references["ragdoll_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	menu_references["ragdoll_material"]:setVisible(bool)
	if ragdollConnection then
		ragdollConnection:Disconnect()
	end
	if not bool then
		for _, ragdoll in ignored_folder.DeadBody:GetChildren() do
			ragdoll:Destroy()
		end
	else
		for _, ragdoll in ignored_folder.DeadBody:GetChildren() do
			applyRagdoll(ragdoll)
		end
		ragdollConnection = utility.newConnection(ignored_folder.DeadBody.ChildAdded, applyRagdoll, true)
	end
end), true)
menu_references["ragdoll_material"]:setVisible(false)

utility.newConnection(menu_references["ragdoll_changer"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not flags["ragdoll_changer"] then
		return end

	for _, ragdoll in ignored_folder.DeadBody:GetChildren() do
		applyRagdoll(ragdoll)
	end
end), true)

utility.newConnection(menu_references["ragdoll_material"].onDropdownChange, LPH_NO_VIRTUALIZE(function()
	if not flags["ragdoll_changer"] then
		return end

	for _, ragdoll in ignored_folder.DeadBody:GetChildren() do
		applyRagdoll(ragdoll)
	end
end), true)

utility.newConnection(menu_references["viewmodel_changer"].onToggleChange, function(bool)
	menu_references["x_position"]:setVisible(bool)
	menu_references["y_position"]:setVisible(bool)
	menu_references["z_position"]:setVisible(bool)
	menu_references["roll"]:setVisible(bool)
end, true)
menu_references["x_position"]:setVisible(false)
menu_references["y_position"]:setVisible(false)
menu_references["z_position"]:setVisible(false)
menu_references["roll"]:setVisible(false)

local gradient_glow = newObject("MeshPart", {
	MeshId = [[rbxassetid://7382231813]];
	CollisionFidelity = Enum.CollisionFidelity.Default;
	CFrame = cframenew(-101.011864,2.9840486,51.3301125,1,0,0,0,1,0,0,0,1);
	Color = Color3.new(1,0.34902,0.34902);
	Material = Enum.Material.Neon;
	Size = vector3new(4.525260925292969,5.96809720993042,4.525260925292969);
	Transparency = 1;
	Parent = cg;
	Anchored = true;
	CanCollide = false
})

do
	local a1 = newObject("Attachment", {
		Parent = gradient_glow;
		CFrame = CFrame.new(0,0,-2,1,0,0,0,1,0,0,0,1)
	})
	local a2 = newObject("Attachment", {
		Parent = gradient_glow;
		CFrame = CFrame.new(0,0,2,1,0,0,0,1,0,0,0,1)
	})
	local b1 = newObject("Beam", {
		Attachment0 = a1;
		Attachment1 = a2;
		CurveSize0 = 2.67;
		CurveSize1 = -2.67;
		LightInfluence = 1;
		Texture = [[rbxassetid://17120910128]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.8,0),NumberSequenceKeypoint.new(1,0.8,0)};
		Width0 = 0;
		Segments = 100;
		Width1 = 0;
		Parent = gradient_glow
	})
	local b2 = newObject("Beam", {
		Attachment0 = a1;
		Attachment1 = a2;
		CurveSize0 = -2.67;
		CurveSize1 = 2.67;
		LightInfluence = 1;
		Texture = [[rbxassetid://17120910128]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.4,0),NumberSequenceKeypoint.new(1,1,0)};
		Width0 = 0;
		Segments = 100;
		Width1 = 0;
		Parent = gradient_glow
	})

	utility.newConnection(gradient_glow:GetPropertyChangedSignal("Size"), LPH_NO_VIRTUALIZE(function()
		local size = gradient_glow.Size.Y+0.2
		b1.Width0 = size
		b1.Width1 = size
		b2.Width0 = size
		b2.Width1 = size
		if gradient_glow.Size.Y < 0.01 then
			gradient_glow.Parent = cg
		else
			gradient_glow.Parent = ignored_folder
		end
	end), true)
end

newObject("PointLight", {
	Range = 0;
	Brightness = 15;
	Color = Color3.new(1,0,0);
	Name = "Light";
	Parent = gradient_glow
})

utility.newConnection(menu_references["gradient_overlay"].onToggleChange, function(bool)
	menu_references["gradient_glow"]:setVisible(bool)
	gradient_glow.Parent = (bool and aimbot.target) and ignored_folder or cg
end, true)
menu_references["gradient_glow"]:setVisible(false)

utility.newConnection(menu_references["gradient_overlay"].onColorChange, function(color, transparency)
	for _, v in gradient_glow:GetChildren() do
		if v.ClassName == "Beam" then
			v.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,transparency,0),NumberSequenceKeypoint.new(1,transparency,0)};
			v.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)}
		elseif v.ClassName == "PointLight" then
			v.Color = color
		end
	end
end, true)

utility.newConnection(menu_references["gradient_glow"].onToggleChange, function(bool)
	gradient_glow.Light.Range = bool and 2 or 0
end, true)

utility.newConnection(menu_references["firerate_modifier"].onToggleChange, function(bool)
	menu_references["modifier"]:setVisible(bool)
end, true)
menu_references["modifier"]:setVisible(false)

local last_target = nil

do
	local camera_added_connection = nil

	local left_highlight = newObject("Highlight", {
		FillColor = flags["arms_highlight_color"],
		FillTransparency = flags["arms_highlight_color"],
		OutlineColor = flags["arms_outline_color"],
		OutlineTransparency = flags["arms_outline_transparency"],
		Adornee = nil,
		Parent = cg,
	})

	local right_highlight = newObject("Highlight", {
		FillColor = flags["arms_highlight_color"],
		FillTransparency = flags["arms_highlight_color"],
		OutlineColor = flags["arms_outline_color"],
		OutlineTransparency = flags["arms_outline_transparency"],
		Adornee = nil,
		Parent = cg
	})

	utility.newConnection(menu_references["arms_highlight"].onToggleChange, function(bool)
		menu_references['arms_outline']:setVisible(bool)
		if camera_added_connection then
			camera_added_connection:Disconnect()
		end
		left_highlight["Adornee"] = nil
		right_highlight["Adornee"] = nil

		if bool then
			local left_arm = camera:FindFirstChild("Left Arm")
			local right_arm = camera:FindFirstChild("Right Arm")

			if left_arm then
				left_highlight["Adornee"] = left_arm
			end

			if right_arm then
				right_highlight["Adornee"] = right_arm
			end

			camera_added_connection = utility.newConnection(camera.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
				if object.ClassName == "Model" then
					if object.Name == "Left Arm" then
						left_highlight["Adornee"] = object
					elseif object.Name == "Right Arm" then
						right_highlight["Adornee"] = object
					end
				end
			end), true)
		end
	end, true)
	menu_references['arms_outline']:setVisible(false)

	utility.newConnection(menu_references["arms_highlight"].onColorChange, function(color, transparency)
		left_highlight["FillColor"] = color
		right_highlight["FillColor"] = color
		left_highlight["FillTransparency"] = transparency
		right_highlight["FillTransparency"] = transparency
	end, true)

	utility.newConnection(menu_references["arms_outline"].onColorChange, function(color, transparency)
		left_highlight["OutlineColor"] = color
		right_highlight["OutlineColor"] = color
		left_highlight["OutlineTransparency"] = transparency
		right_highlight["OutlineTransparency"] = transparency
	end, true)
end

do
	local camera_added_connection = nil

	local weapon_highlight = newObject("Highlight", {
		FillColor = flags["weapon_highlight_color"],
		FillTransparency = flags["weapon_highlight_color"],
		OutlineColor = flags["weapon_outline_color"],
		OutlineTransparency = flags["weapon_outline_transparency"],
		Adornee = nil,
		Parent = cg,
	})

	utility.newConnection(menu_references["weapon_highlight"].onToggleChange, function(bool)
		menu_references['weapon_outline']:setVisible(bool)
		if camera_added_connection then
			camera_added_connection:Disconnect()
		end
		weapon_highlight["Adornee"] = nil

		if bool then
			local weapon = nil

			for _, object in camera:GetChildren() do
				if object.ClassName == "Model" and object.Name ~= "Left Arm" and object.Name ~= "Right Arm" then
					weapon_highlight["Adornee"] = object
				end
			end

			camera_added_connection = utility.newConnection(camera.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
				if object.ClassName == "Model" then
					if object.Name ~= "Left Arm" and object.Name ~= "Right Arm" then
						weapon_highlight["Adornee"] = object
					end
				end
			end), true)
		end
	end, true)
	menu_references['weapon_outline']:setVisible(false)

	utility.newConnection(menu_references["weapon_highlight"].onColorChange, function(color, transparency)
		weapon_highlight["FillColor"] = color
		weapon_highlight["FillTransparency"] = transparency
	end, true)

	utility.newConnection(menu_references["weapon_outline"].onColorChange, function(color, transparency)
		weapon_highlight["OutlineColor"] = color
		weapon_highlight["OutlineTransparency"] = transparency
	end, true)
end

utility.newConnection(aimbotTargetChange, LPH_JIT_MAX(function(target)
	local old_last_target = last_target
	last_target = target
	if flags["notifications"] and find(flags["notifications_selected"], "Target changes") and target ~= old_last_target then
		_spawn(newNotification, target and "locked onto player "..target.Name or "unlocked", flags["notification_style"][1])
	end

	gradient_glow.Parent = (flags["gradient_overlay"] and target) and ignored_folder or cg
	if flags["gradient_overlay"] then
		if target then
			tween(gradient_glow, newtweeninfo(0.15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 6, 1)})
		else
			tween(gradient_glow, newtweeninfo(0.08, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 0, 1)})
		end
	end

	local data = player_data[player]

	if not data then
		return end

	local entry = data["entry"]

	if not entry then
		return end

	local character = getCharacter(entry)

	if not character then
		return end

	bounding_box_object.Adornee = target and character.Torso.Parent or nil
	if not flags["bounding_box"] then
		bounding_box_object.Adornee = nil
	end
end), true)

utility.newConnection(menu_references["show_aim_assist_fov"].onToggleChange, function(bool)
	aimbot.assist_circle.Visible = flags["aimbot"] and bool or false
	aimbot.assist_circle_outline.Visible = aimbot.assist_circle.Visible
	menu_references["aim_assist_fov_filled"]:setVisible(bool)
end, true)

utility.newConnection(menu_references["aim_assist_fov_filled"].onToggleChange, function(bool)
	aimbot.assist_circle.Filled = bool
end, true)

utility.newConnection(menu_references["show_aim_assist_fov"].onColorChange, function(color, transparency)
	aimbot.assist_circle.Color = color
	aimbot.assist_circle.Transparency = -transparency+1
	aimbot.assist_circle_outline.Transparency = aimbot.assist_circle.Transparency
end, true)

utility.newConnection(menu_references["show_fov"].onToggleChange, function(bool)
	aimbot.circle.Visible = flags["aimbot"] and bool or false
	aimbot.circle_outline.Visible = aimbot.circle.Visible
	menu_references["show_fov_filled"]:setVisible(bool)
end, true)

utility.newConnection(menu_references["show_fov_filled"].onToggleChange, function(bool)
	aimbot.circle.Filled = bool
end, true)

utility.newConnection(menu_references["show_fov"].onColorChange, function(color, transparency)
	aimbot.circle.Color = color
	aimbot.circle.Transparency = -transparency+1
	aimbot.circle_outline.Transparency = aimbot.circle.Transparency
end, true)


utility.newConnection(menu_references["hitmarker"].onToggleChange, function(bool)
	menu_references["hitmarker_size"]:setVisible(bool)
	menu_references["hitmarker_gap"]:setVisible(bool)
end, true)
menu_references["hitmarker_size"]:setVisible(false)
menu_references["hitmarker_gap"]:setVisible(false)

utility.newConnection(menu_references["hitsound"].onDropdownChange, function(selected)
	menu_references["custom_id"]:setVisible(flags["hitsound"] and selected[1] == "Custom" or false)
end, true)

utility.newConnection(menu_references["hitsound"].onToggleChange, function(bool)
	menu_references["hitsound_volume"]:setVisible(bool)
	menu_references["custom_id"]:setVisible(bool and flags["hitsound_sound"][1] == "Custom" or false)
end, true)
menu_references["hitsound_volume"]:setVisible(false)
menu_references["custom_id"]:setVisible(false)

utility.newConnection(menu_references["multipoint"].onToggleChange, function(bool)
	menu_references["multipoint"]:changeSliderVisiblity(bool)
end, true)
menu_references["multipoint"]:changeSliderVisiblity(false)

utility.newConnection(menu_references["keybinds_list"].onColorChange, function(color)
	if flags["keybinds_style"][1] ~= "Default" then
		keybinder.drawings[2].Color = color
	end
end, true)

utility.newConnection(menu_references["keybinds_style"].onDropdownChange, function(selected)
	if selected[1] == "Default" then
		keybinder.drawings[2].Data = line_image
		keybinder.drawings[2].Color = colorfromrgb(255,255,255)
	elseif selected[1] == "Color" then
		keybinder.drawings[2].Data = pixel_image
		keybinder.drawings[2].Color = flags["keybinds_list_color"]
	elseif selected[1] == "Gradient" then
		keybinder.drawings[2].Data = gradient_image
		keybinder.drawings[2].Color = flags["keybinds_list_color"]
	end
end, true)

utility.newConnection(menu_references["keybinds_font"].onDropdownChange, function(selected)
	local font = fonts[tonumber(selected[1])]
	keybinder.drawings[3]["Font"] = font
	for _, info in keybinder.all do
		for _, drawing in info.drawings do
			drawing["Font"] = font
		end
	end
end, true)

utility.newConnection(menu_references["keybinds_list"].onToggleChange, function(bool)
	menu_references["keybinds_font"]:setVisible(bool)
	menu_references["keybinds_style"]:setVisible(bool)
	if bool then
		keybinder.open()
	else
		keybinder.close()
	end
end, true)
menu_references["keybinds_font"]:setVisible(false)
menu_references["keybinds_style"]:setVisible(false)

utility.newConnection(menu_references["chams_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local chams = info["chams"]
		if chams then
			for _, box in chams["hidden"] do
				box["Color3"] = color
				box["Transparency"] = transparency 
			end
		end
	end
end, true)

utility.newConnection(menu_references["visible_chams_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local chams = info["chams"]
		if chams then
			for _, box in chams["visible"] do
				box["Color3"] = color
				box["Transparency"] = transparency 
			end
		end
	end
end, true)


utility.newConnection(menu_references["highlight_outline"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.OutlineColor = color
			highlight.OutlineTransparency = transparency
		end
	end
end, true)

utility.newConnection(menu_references["through_walls"].onToggleChange, function(bool)
	local mode = bool and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.DepthMode = mode
		end
	end
end, true)

utility.newConnection(menu_references["highlight_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.FillColor = color
			highlight.FillTransparency = transparency
		end
	end
end, true)

utility.newConnection(menu_references["gradient_bars"].onToggleChange, function(bool)
	local image = bool and health_image or pixel_image
	for player, info in player_data do
		local drawings = info["drawings"]
		if drawings then
			local health_bar = drawings[5]

			if health_bar then
				health_bar["Data"] = image
			end
		end
	end
end)

utility.newConnection(menu_references["box_toggle"].onToggleChange, function(bool)
	menu_references["fill_toggle"]:setVisible(bool)
end, true)
menu_references["fill_toggle"]:setVisible(false)

utility.newConnection(menu_references["box_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local box = drawings[2]
			local outline = drawings[1]

			if box and outline then
				box["Color"] = color
				box["Transparency"] = -transparency+1
				outline["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["name_size"].onSliderChange, function(value)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local name = drawings[3]

			if name then
				name["Size"] = value
			end
		end
	end
end, true)

utility.newConnection(menu_references["name_display"].onToggleChange, function(bool)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local name = drawings[3]

			if name then
				name["Text"] = bool and player.DisplayName or player.Name
			end
		end
	end
end, true)

utility.newConnection(menu_references["esp_font"].onDropdownChange, function(selected)
	local font = tonumber(selected[1])
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local name = drawings[3]
			local weapon = drawings[6]
			local health = drawings[7]

			if name then
				name["Font"] = font
			end

			if weapon then
				weapon["Font"] = font
			end

			if health then
				health["Font"] = font
			end
		end
	end
end, true)

utility.newConnection(menu_references["name_toggle"].onToggleChange, function(bool)
	menu_references["name_size"]:setVisible(bool)
	menu_references["name_display"]:setVisible(bool)
end, true)
menu_references["name_size"]:setVisible(false)
menu_references["name_display"]:setVisible(false)

utility.newConnection(menu_references["weapon_size"].onSliderChange, function(value)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local weapon = drawings[6]

			if weapon then
				weapon["Size"] = value
			end
		end
	end
end, true)

utility.newConnection(menu_references["weapon_toggle"].onToggleChange, function(bool)
	menu_references["weapon_size"]:setVisible(bool)
	menu_references["weapon_surrounding"]:setVisible(bool)
	menu_references["weapon_casing"]:setVisible(bool)
end, true)
menu_references["weapon_size"]:setVisible(false)
menu_references["weapon_surrounding"]:setVisible(false)
menu_references["weapon_casing"]:setVisible(false)

utility.newConnection(menu_references["weapon_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local weapon = drawings[6]

			if weapon then
				weapon["Color"] = color
				weapon["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["health_number"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local health_number = drawings[7]

			if health_number then
				health_number["Color"] = color
				health_number["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["health_toggle"].onToggleChange, function(bool)
	menu_references["health_number"]:setVisible(bool)
end, true)
menu_references["health_number"]:setVisible(false)

utility.newConnection(menu_references["health_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local health = drawings[5]

			if health then
				health["Color"] = color
				health["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["name_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local name = drawings[3]

			if name then
				name["Color"] = color
				name["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["fill_toggle"].onToggleChange, function(bool)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local box = drawings[2]

			if box then
				box["Filled"] = bool
			end
		end
	end
end, true)

---------------------------
-- * Metamethod Hooks * --
---------------------------

local skip_indexes = {
	["ExposureCompensation"] = "world_exposure",
	["FogStart"] = "fog_changer",
	["FogEnd"] = "fog_changer",
	["FogColor"] = "fog_changer",
	["GlobalShadows"] = "remove_shadows",
	["ClockTime"] = "world_time",
	["Brightness"] = "world_brightness",
	["Ambient"] = "world_ambient",
}

local old_new_index = nil

old_new_index = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, index, value)
	if not checkcaller() and self and index and value then
		if spoof_properties[index] then
			spoof_properties[index] = value
			local hi = skip_indexes[index]
			if flags[hi] then
				return
			end
		end
	end
	return old_new_index(self, index, value)
end))

local old_index = nil

old_index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, index)
	if not checkcaller() then
		if spoof_properties[index]then
			local hi = skip_indexes[index]
			if flags[hi] then
				return spoof_properties[index]
			end
		end
	end
	return old_index(self, index)
end))

-----------------------------
-- * Cheat Core Features * --
-----------------------------

local offsets = {
	vector2new(1,1),
	vector2new(-1,1),
	vector2new(1,-1),
	vector2new(-1,-1)
}	

local renderHitmarker = LPH_NO_VIRTUALIZE(function(is_2d, player)
	local data = player_data[player]

	if not data then
		return end

	local entry = data["entry"]

	if not entry then
		return end

	local character = getCharacter(entry)

	if not character then
		return end

	local hitmarker = {}
	
	for i = 1, 4 do
		hitmarker[i] = {
			outline = utility.newDrawing("Line", {
				Thickness = 3,
				ZIndex = 1,
				Color = colorfromrgb(0,0,0)
			}),
			line = utility.newDrawing("Line", {
				Thickness = 1,
				ZIndex = 2,
				Color = colorfromrgb(255,255,255)
			})
		}
	end

	local time_elapsed = 0
	local render_connection = nil
	local gap = flags["hitmarker_gap"]
	local size = flags["hitmarker_size"]
	local color = flags["hitmarker_color"]
	
	if is_2d then
		render_connection = utility.newConnection(rs.Heartbeat, function(dt)
			time_elapsed+=dt
			local mouse_pos = uis:GetMouseLocation()
			local tween_value = getValue(tws, (time_elapsed / .6), Enum.EasingStyle.Sine, Enum.EasingDirection.In)

			for i = 1, 4 do
				local lines = hitmarker[i]
				local outline = lines.outline
				local line = lines.line
				local offset = offsets[i]
				local offset_pos = offset * gap

				line.Visible = true
				outline.Visible = true
				line.From = mouse_pos + offset_pos
				line.To = line.From + offset * size
				line.Color = color
				line.Transparency = 1-tween_value
				outline.Transparency = 1-tween_value
				outline.From = line.From
				outline.To = line.To
			end
		end)
	else
		local position = character.Torso.Position
		render_connection = utility.newConnection(rs.Heartbeat, function(dt)
			time_elapsed+=dt
			local position_on_screen, on_screen = wtvp(camera, position)
			if on_screen then
				local mouse_pos = vector2new(position_on_screen.X, position_on_screen.Y)
				local tween_value = getValue(tws, (time_elapsed / .6), Enum.EasingStyle.Sine, Enum.EasingDirection.In)

				for i = 1, 4 do
					local lines = hitmarker[i]
					local outline = lines.outline
					local line = lines.line
					local offset = offsets[i]
					local offset_pos = offset * gap

					line.Visible = true
					outline.Visible = true
					line.From = mouse_pos + offset_pos
					line.To = line.From + offset * size
					line.Color = color
					line.Transparency = 1-tween_value
					outline.Transparency = 1-tween_value
					outline.From = line.From
					outline.To = line.To
				end
			else
				for i = 1, 4 do
					local lines = hitmarker[i]
					local outline = lines.outline
					local line = lines.line

					line:Destroy()
					outline:Destroy()
				end
				render_connection:Disconnect()
			end
		end)
	end

	_wait(0.6)

	for _, info in hitmarker do
		for _, drawing in info do
			drawing:Destroy()
		end
	end

	render_connection:Disconnect()
end)

local renderHitCham = LPH_NO_VIRTUALIZE(function(player)
	local data = player_data[player]

	if not data then
		return end

	local entry = data["entry"]

	if not entry then
		return end

	local character = getCharacter(entry)

	if not character then
		return end
		
	local character_cloned = newObject("Model", {
		Parent = workspace.Ignore,
		Name = "test"
	})

	for _, part_ in part_list do
		local part = character[part_]:Clone()
		part.Parent = character_cloned
		part.Name = part_
	end

	local all_parts = character_cloned:GetChildren()
	local material = Enum.Material[flags["hit_chams_material"][1]]
	local color = flags["hit_chams_color"]
	local transparency = flags["hit_chams_transparency"]
	local lifetime = flags["hit_chams_lifetime"]

	for i = 1, #all_parts do
		local part = all_parts[i]
		local class_name = part.ClassName
		part.Color = color
		part.Material = material
		part.Transparency = transparency
		part.CanCollide = false
		part.Anchored = true
		part:FindFirstChildOfClass("SpecialMesh"):Destroy()
		if part.Name == "Torso" then
			for _, child in part:GetChildren() do
				if child.ClassName == "Texture" then
					child:Destroy()
				end
			end
		elseif part.Name == "Head" then
			local decal = part:FindFirstChildOfClass("Decal")
			if decal then decal:Destroy() end
		end
	end

	if flags["hit_chams_fade"] then
		for i = 1, #all_parts do
			tween(all_parts[i], newtweeninfo(lifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Transparency = 1})
		end
	end

	task.delay(lifetime, function()
		character_cloned:Destroy()
	end)

	character_cloned.Parent = workspace.Ignore
end)

local particle_part = newObject("Part", {
	Size = vector3new(1,1,1),
	Transparency = 1,
	CanCollide = false,
	Anchored = true,
	Parent = workspace.Ignore
})

newObject("ParticleEmitter", {
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.784314,0.411765,1)),ColorSequenceKeypoint.new(1,Color3.new(0.784314,0.411765,1))};
	Lifetime = NumberRange.new(0.5,0.5);
	LightEmission = 1;
	LockedToPart = true;
	Orientation = Enum.ParticleOrientation.VelocityPerpendicular;
	Rate = 0;
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
	Speed = NumberRange.new(1.5,1.5);
	Texture = [[rbxassetid://1084991215]];
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.602372,0,0),NumberSequenceKeypoint.new(1,1,0)};
	ZOffset = 1;
	Name = "bubble1";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.784314,0.411765,1)),ColorSequenceKeypoint.new(1,Color3.new(0.784314,0.411765,1))};
	Lifetime = NumberRange.new(0.5,0.5);
	LightEmission = 1;
	LockedToPart = true;
	Rate = 0;
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
	Speed = NumberRange.new(0,0);
	Texture = [[rbxassetid://1084991215]];
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.601581,0,0),NumberSequenceKeypoint.new(1,1,0)};
	ZOffset = 1;
	Name = "bubble2";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))};
	Lifetime = NumberRange.new(0.2,0.5);
	LockedToPart = true;
	Orientation = Enum.ParticleOrientation.VelocityParallel;
	Rate = 0;
	Rotation = NumberRange.new(-90,90);
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,8.5,1.5)};
	Speed = NumberRange.new(0.1,0.1);
	SpreadAngle = vector2new(180,180);
	Texture = [[http://www.roblox.com/asset/?id=6820680001]];
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.200791,0,0),NumberSequenceKeypoint.new(0.699605,0,0),NumberSequenceKeypoint.new(1,1,0)};
	ZOffset = 1.5;
	Name = "bubble3";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Acceleration = vector3new(0,-50,0);
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0.999969,0.999985)),ColorSequenceKeypoint.new(0.25,Color3.new(0.333333,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,1,0.498039))};
	Lifetime = NumberRange.new(0.5,1);
	LightEmission = 1;
	Orientation = Enum.ParticleOrientation.VelocityParallel;
	Rate = 0;
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.6,0),NumberSequenceKeypoint.new(0.5,0.6,0),NumberSequenceKeypoint.new(1,0,0)};
	Speed = NumberRange.new(15,15);
	SpreadAngle = vector2new(50,-50);
	Texture = [[http://www.roblox.com/asset/?id=7587238412]];
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,1,0)};
	Name = "sparks";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Brightness = 5;
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0.34902,1)),ColorSequenceKeypoint.new(1,Color3.new(0,0.34902,1))};
	Enabled = false;
	FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4;
	FlipbookMode = Enum.ParticleFlipbookMode.OneShot;
	Lifetime = NumberRange.new(0.75,0.75);
	LightEmission = 3;
	LockedToPart = true;
	Rate = 30;
	Rotation = NumberRange.new(-360,360);
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,2,0),NumberSequenceKeypoint.new(1,2,0)};
	Speed = NumberRange.new(0,0);
	SpreadAngle = Vector2.new(-360,360);
	Texture = "rbxassetid://11492870634";
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.859268,0,0),NumberSequenceKeypoint.new(1,1,0)};
	ZOffset = 3;
	Name = "lightning";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0.584314,0,1))};
	Enabled = false;
	Lifetime = NumberRange.new(1,1);
	LightEmission = 0.5;
	Rate = 400;
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.375,0),NumberSequenceKeypoint.new(1,0,0)};
	Speed = NumberRange.new(0,0);
	Texture = "rbxassetid://348120961";
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)};
	ZOffset = 1;
	Name = "plasma";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0.584314,0,1))};
	Enabled = false;
	Lifetime = NumberRange.new(1,1);
	LightEmission = 1;
	Rate = 100;
	Rotation = NumberRange.new(37,999);
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,2.625,0),NumberSequenceKeypoint.new(1,0,0)};
	Speed = NumberRange.new(0,0);
	Texture = "rbxassetid://1084976679";
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.499426,0,0),NumberSequenceKeypoint.new(1,1,0)};
	Name = "plasma2";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8;
	FlipbookMode = Enum.ParticleFlipbookMode.OneShot;
	Lifetime = NumberRange.new(1,1);
	LightInfluence = 1;
	LockedToPart = true;
	Rate = 1;
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,5,0),NumberSequenceKeypoint.new(1,5,0)};
	Speed = NumberRange.new(1,1);
	Texture = "rbxassetid://9135699136";
	Enabled = false;
	Name = "explosion";
	Parent = particle_part
})

newObject("ParticleEmitter", {
	Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))};
	Enabled = false;
	Lifetime = NumberRange.new(0.2,0.5);
	LockedToPart = true;
	Orientation = Enum.ParticleOrientation.VelocityParallel;
	Rate = 120;
	Rotation = NumberRange.new(-90,90);
	Size = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,5.34161,1.5)};
	Speed = NumberRange.new(0.1,0.1);
	SpreadAngle = Vector2.new(180,180);
	Texture = "http://www.roblox.com/asset/?id=6820680001";
	Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.200791,0,0),NumberSequenceKeypoint.new(0.699605,0,0),NumberSequenceKeypoint.new(1,1,0)};
	ZOffset = 1.5;
	Name = "sludge";
	Parent = particle_part
})

local hit_effects = {
	["Bubble"] = {
		{
			"bubble1",
			"bubble2",
			"bubble3"
		},
		1,
		false
	},
	["Sparks"] = {
		{
			"sparks"
		},
		30,
		false
	},
	["Lightning"] = {
		{
			"lightning"
		},
		3,
		false
	},
	["Void"] = {
		{
			"plasma",
			"plasma2"
		},
		2,
		false
	},
	["Explosion"] = {
		{
			"explosion",
		},
		1,
		false
	},
	["Sludge"] = {
		{
			"sludge",
		},
		25,
		false
	},
}

local renderHitEffect = LPH_NO_VIRTUALIZE(function(player)
	local data = player_data[player]

	if not data then
		return end

	local entry = data["entry"]

	if not entry then
		return end

	local character = getCharacter(entry)

	if not character then
		return end

	local hit_effect = hit_effects[flags["hit_effect_effect"][1]]

	local hrp = character.Torso
	particle_part.CFrame = hrp.CFrame
	for _, particle in hit_effect[1] do
		local particle = particle_part[particle]
		particle.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, flags["hit_effect_color"]), ColorSequenceKeypoint.new(1.00, flags["hit_effect_color"])}
		particle:Emit(hit_effect[2])
	end
end)

local hitsounds = {RIFK7 = "rbxassetid://9102080552", Bubble = "rbxassetid://9102092728", Minecraft = "rbxassetid://5869422451", Cod = "rbxassetid://160432334", Bameware = "rbxassetid://6565367558", Neverlose = "rbxassetid://6565370984", Gamesense = "rbxassetid://4817809188", Rust = "rbxassetid://6565371338"}

utility.newConnection(lplrHitPlayer, LPH_JIT(function(player, part)
	if flags["hitmarker"] then
		local is_2d = flags["hitmarker_style"][1] == "2D"
		_spawn(renderHitmarker, is_2d, player)
	end
	if flags["notifications"] and find(flags["notifications_selected"], "Hits") then
		_spawn(newNotification, "hit "..player.Name.." in "..part.." ", flags["notification_style"][1])
	end
	if flags["hitsound"] then
		local hitsound = flags["hitsound_sound"][1]
		newObject("Sound", {
			Volume = flags["hitsound_volume"];
			PlayOnRemove = true;
			SoundId = hitsound == "Custom" and (isfile(flags["custom_id"]) and getcustomasset(flags["custom_id"], false) or flags["custom_id"]) or hitsounds[flags["hitsound_sound"][1]];
			Parent = lplr.PlayerGui
		}):Destroy()
	end
	if flags["hit_chams"] then
		_spawn(renderHitCham, player)
	end
	if flags["hit_effect"] then
		_spawn(renderHitEffect, player)
	end
end), true)

local heartbeat_callbacks = {}
local anti_callbacks = {}

local autoJump = LPH_NO_VIRTUALIZE(function(dt)
	local model = lplr_data["character_model"]

	if not flags["auto_jump_keybind"]["active"] or not model then
		return end 

	local hum = character_parts["Humanoid"]

	if not hum then
		return end

	if hum:GetState() ~= Enum.HumanoidStateType.Jumping and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

utility.newConnection(menu_references["auto_jump"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, autoJump) then
		remove(heartbeat_callbacks, autoJump)
	end
	if bool then
		insert(heartbeat_callbacks, autoJump)
	end 
end, true)

local knifebot = LPH_JIT_MAX(function(dt)
	if flags["knifebot_keybind"]["active"] then
		local char = get_character_object()
		local hrp_pos = char and char["_rootPart"].Position or vector3new()
		local closest = 9e9
		local victim = nil
		local pos = nil
		for player, info in player_data do
			local entry = info["entry"]

			if not entry or player.Team == lplr.Team then
				continue 
			end

			local character = getCharacter(entry)

			if (not character or not entry["_alive"]) then
				continue 
			end

			local hrp = character and character.Torso or nil

			if not hrp then
				continue end

			local dist = (hrp.Position-hrp_pos).magnitude
			if dist <= flags["stab_distance"] then
				if dist <= closest then 
					closest = dist
					pos = hrp.Position
					victim = player
				end
			end
		end
		if victim then
			network_send("stab")
			network_send("knifehit", victim, flags["knifebot_headshot"] and "Head" or "Torso", pos, get_time())
		end
	end
end)

utility.newConnection(menu_references["knifebot"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, knifebot) then
		remove(heartbeat_callbacks, knifebot)
	end
	if bool then
		insert(heartbeat_callbacks, knifebot)
	end
	menu_references["stab_distance"]:setVisible(bool)
	menu_references["knifebot_headshot"]:setVisible(bool)
end, true)
menu_references["stab_distance"]:setVisible(false)
menu_references["knifebot_headshot"]:setVisible(false)

local cframeSpeed = LPH_JIT(function(dt)
	if not flags["cframe_speed_keybind"]["active"] then
		return end 

	local char = lplr_data["character_model"]

	if not char then
		return end

    local hrp = character_parts["HumanoidRootPart"]
	local hum = character_parts["Humanoid"]

    if not hrp or not hum then
        return end
		
	hrp.CFrame+=((hum.MoveDirection*dt)*(flags["cframe_speed_speed"]*0.5))
end)

local cframeFly = LPH_JIT(function(dt)
	if not flags["cframe_fly_keybind"]["active"] then
		return end 

	local char = lplr_data["character_model"]

	if not char then
		return end

	local hum = character_parts["Humanoid"]
    local hrp = character_parts["HumanoidRootPart"]

    if not hrp or not hum then
        return end

	local speed = flags["cframe_fly_speed"]

	hrp.Velocity = vector3new(hrp.Velocity.X, 1.8, hrp.Velocity.Z)
	
	hrp.CFrame+=(((hum.MoveDirection*dt)*(speed*0.5))*vector3new(1,0,1)) + vector3new(0,(uis:IsKeyDown(Enum.KeyCode.Space) and 1+((speed*0.1)*dt)) or (uis:IsKeyDown(Enum.KeyCode.LeftShift) and -1-((speed*0.1)*dt)) or 0,0)
end)

utility.newConnection(menu_references["cframe_fly"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, cframeFly) then
		remove(heartbeat_callbacks, cframeFly)
	end
	if bool then
		insert(heartbeat_callbacks, cframeFly)
	end	
	menu_references["cframe_fly_speed"]:setVisible(bool)
end, true)
menu_references["cframe_fly_speed"]:setVisible(false)

utility.newConnection(menu_references["cframe_speed"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, cframeSpeed) then
		remove(heartbeat_callbacks, cframeSpeed)
	end
	if bool then
		insert(heartbeat_callbacks, cframeSpeed)
	end
	menu_references["cframe_speed_speed"]:setVisible(bool)
end, true)
menu_references["cframe_speed_speed"]:setVisible(false)

do
	local crosshair = {}
	local spin_angle = 0
	local angles = {0.0, 1.57, 3.14, 4.71}

	local doCrosshair = LPH_JIT_MAX(function(dt)
		local length = flags["drawing_crosshair_length"] * 5
		local gap = flags["drawing_crosshair_gap"]
		spin_angle = flags["drawing_crosshair_spin"] and spin_angle + rad((flags["drawing_crosshair_speed"] * 5) * dt) or 0;
		local angle = spin_angle
		local location = flags["drawing_crosshair_location"][1] == "Mouse" and uis:GetMouseLocation() or flags["drawing_crosshair_location"][1] == "Center" and camera.ViewportSize/2 or nil
		if location == nil then
			if aimbot.target then
				local hrp = getCharacter(player_data[aimbot.target]["entry"])["Torso"]

				if hrp then
					local pos, on_screen = wtvp(camera, hrp.Position)
					if on_screen then
						location = vector2new(pos.X, pos.Y)
					else
						location = uis:GetMouseLocation()
					end
				else
					location = uis:GetMouseLocation()
				end
			else
				location = uis:GetMouseLocation()
			end
		end
		for i = 1, 4 do 
			local line = crosshair[i][1]
			local outline = crosshair[i][2]
			local pos = vector2new(math.cos(spin_angle + angles[i]), (math.sin(spin_angle + angles[i])))
			line.From = location + pos * gap 
			line.To = line.From + pos * length
			outline.From = location + pos * (gap - 1)
			outline.To = outline.From + pos * (length + 1)
			line.Visible = true 
			outline.Visible = true 
		end 
	end)

	utility.newConnection(menu_references["drawing_crosshair_spin"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		menu_references["drawing_crosshair_spin"]:changeSliderVisiblity(bool)
	end), true)

	utility.newConnection(menu_references["drawing_crosshair"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		if crosshair[1] then
			for i = 1, 4 do
				crosshair[i][1]:Destroy()
				crosshair[i][2]:Destroy()
			end
		end
		if find(heartbeat_callbacks, doCrosshair) then
			remove(heartbeat_callbacks, doCrosshair)
		end
		if bool then
			for i = 1, 4 do
				crosshair[i] = {
					utility.newDrawing("Line", {
						ZIndex = 10000,
						Visible = true,
						Thickness = 1,
						Color = flags["drawing_crosshair_color"],
						Transparency = -flags["drawing_crosshair_transparency"]+1,
					}),
					utility.newDrawing("Line", {
						Visible = true,
						ZIndex = 9999,
						Thickness = 3,
						Color = colorfromrgb(0,0,0),
						Transparency = -flags["drawing_crosshair_transparency"]+1,
					})
				}
			end
			insert(heartbeat_callbacks, doCrosshair)
		end
		menu_references["drawing_crosshair_gap"]:setVisible(bool)
		menu_references["drawing_crosshair_length"]:setVisible(bool)
		menu_references["drawing_crosshair_location"]:setVisible(bool)
		menu_references["drawing_crosshair_spin"]:setVisible(bool)
		menu_references["drawing_crosshair_spin"]:changeSliderVisiblity(bool and flags["drawing_crosshair_spin"] or false)
	end), true)
	menu_references["drawing_crosshair_spin"]:setVisible(false)
	menu_references["drawing_crosshair_spin"]:changeSliderVisiblity(false)
	menu_references["drawing_crosshair_gap"]:setVisible(false)
	menu_references["drawing_crosshair_length"]:setVisible(false)
	menu_references["drawing_crosshair_location"]:setVisible(false)
	menu_references["drawing_crosshair_spin"]:setVisible(false)

	utility.newConnection(menu_references["drawing_crosshair"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
		if #crosshair > 0 then
			for i = 1, #crosshair do
				crosshair[i][1]["Color"] = color
				crosshair[i][1]["Transparency"] = -transparency+1
				crosshair[i][2]["Transparency"] = -transparency+1
			end
		end
	end), true)
end

do
	local grenade_esp_objects = {}
	local grenade_connection2 = nil
	local doGrenadeESP = LPH_NO_VIRTUALIZE(function(dt)
		for _, indicator in grenade_esp_objects do
			local image = indicator[1]
			local image2 = indicator[2]
			local distance = indicator[3]
			local damage = indicator[13]
			local end_position = indicator[6]

			if indicator[4]-os.clock() <= 0 then
				image:Destroy()
				image2:Destroy()
				distance:Destroy()
				damage:Destroy()

				grenade_esp_objects[_] = nil
				continue
			end

			image["Visible"] = false
			image2["Visible"] = false
			distance["Visible"] = false
			damage["Visible"] = false

			local last_visible_check = indicator[7]
			if os.clock()-last_visible_check > .175 then
				local raycast_params = RaycastParams.new()
				raycast_params.IgnoreWater = true;
				raycast_params.FilterDescendantsInstances = {camera, ignored_folder, ignored_folder2, ignored_folder3}
				raycast_params.FilterType = Enum.RaycastFilterType.Exclude

				local cam_pos = camera.CFrame.p
				indicator[8] = true

				if raycast(workspace, cam_pos, (end_position - cam_pos).unit * (end_position - cam_pos).magnitude, raycast_params) then
					indicator[8] = false
					continue 
				end
			end

			local time_left = tostring(round(clamp(indicator[4]-os.clock(), 0, 9e9), 1))

			distance["Text"] = time_left.."s"

			if indicator[8] then
				local screen_pos, on_screen = wtvp(camera, end_position)
				screen_pos = vector2new(screen_pos.X, screen_pos.Y)

				local dist = (camera.CFrame.p-end_position).magnitude

				local _damage = dist > indicator[12] and 0 or (dist < indicator[11] and indicator[9] or (indicator[10] - indicator[9]) / (indicator[12] - indicator[11]) * (dist - indicator[11]) + indicator[9])

				damage["Text"] = _damage <= 0 and "safe" or _damage >= 98 and "lethal" or "-"..round(_damage, 0).." hp"

				if on_screen then
					local size = floor(((screen_pos.Y - wtvp(camera, end_position + vector3new(0, 2.8, 0)).Y)/2)*1.65)
					image["Visible"] = true
					image["Position"] = screen_pos - vector2new(size/2, size/2)
					image["Size"] = vector2new(size, size)
					image2["Visible"] = true
					image2["Size"] = vector2new(size/1.2, size/1.2)
					image2["Position"] = screen_pos - vector2new(size/1.2, size/1.2)/2
					distance["Visible"] = true
					distance["Size"] = size/3
					distance["Position"] = screen_pos - vector2new(distance["TextBounds"]["X"]/2, -distance["TextBounds"]["Y"]/2)
					damage["Visible"] = true
					damage["Size"] = size/3
					damage["Position"] = screen_pos - vector2new(damage["TextBounds"]["X"]/2, size/2 + damage["TextBounds"]["Y"]/2)
				elseif dist-16 < indicator[11] or dist-16 < indicator[12] then
					local size = 75
					local x_add = screen_pos.X < size+8 and size+8 or screen_pos.X > camera.ViewportSize.X and camera.ViewportSize.X - size+8 or screen_pos.X
					local y_add = screen_pos.Y < size+8 and size+8 or screen_pos.Y > camera.ViewportSize.Y and camera.ViewportSize.Y - size+8 or x_add == screen_pos.X and camera.ViewportSize.Y - size+8 or screen_pos.Y

					screen_pos = vector2new(x_add, y_add)
					image["Visible"] = true
					image["Position"] = screen_pos - vector2new(size/2, size/2)
					image["Size"] = vector2new(size, size)
					image2["Visible"] = true
					image2["Size"] = vector2new(size/1.2, size/1.2)
					image2["Position"] = screen_pos - vector2new(size/1.2, size/1.2)/2
					distance["Visible"] = true
					distance["Size"] = size/3
					distance["Position"] = screen_pos - vector2new(distance["TextBounds"]["X"]/2, -distance["TextBounds"]["Y"]/2)
					damage["Visible"] = true
					damage["Size"] = size/3
					damage["Position"] = screen_pos - vector2new(damage["TextBounds"]["X"]/2, size/2 + damage["TextBounds"]["Y"]/2)
				end
			end
		end
	end)

	utility.newConnection(menu_references["grenade_warnings_esp"].onToggleChange, function(bool)
		if grenade_connection2 then
			grenade_connection2:Disconnect()
		end
		if find(heartbeat_callbacks, doGrenadeESP) then
			remove(heartbeat_callbacks, doGrenadeESP)
		end
		if bool then
			insert(heartbeat_callbacks, doGrenadeESP)
			grenade_connection2 = utility.newConnection(grenadeThrown, LPH_NO_VIRTUALIZE(function(player, object, cook_time, type, end_position)
				local indicator = {
					utility.newDrawing("Image", {
						Data = gradient_circle,
						Color = colorfromrgb(255,0,0),
						ZIndex = 2
					}),
					utility.newDrawing("Image", {
						Data = grenade_image,
						Color = colorfromrgb(255,255,255),
						ZIndex = 2
					}),
					utility.newDrawing("Text", {
						Outline = true,
						ZIndex = 2,
						Text = round(cook_time, 1).."s",
						Color = colorfromrgb(255,255,255),
						Font = fonts[tonumber(flags["esp_font"][1])]
					}),
					os.clock()+cook_time,
					cook_time,
					end_position,
					os.clock()-1,
					false,
					0,
					0,
					0,
					0,
					utility.newDrawing("Text", {
						Outline = true,
						ZIndex = 2,
						Text = "safe",
						Color = colorfromrgb(255,255,255),
						Font = fonts[tonumber(flags["esp_font"][1])]
					}),
				}

				local module = gun_modules[type]

				if module then
					indicator[9] = module["damage0"]
					indicator[10] = module["damage1"]
					indicator[11] = module["range0"]
					indicator[12] = module["range1"]
				end

				insert(grenade_esp_objects, indicator)
			end), true)
		end
	end, true)
end

local doWatermark = nil
do
	local elapsed_time = 0
	local new_value = 0
	local old_value = 0
	local cooldown = true
	local cycle = false

	local watermark = {
		utility.newDrawing("Text", {
			Text = "juju",
			Color = colorfromrgb(153, 196, 39),
			Size = 14,
			Font = 2,
			Outline = true,
			Transparency = 0,
			ZIndex = 999
		}),
		utility.newDrawing("Text", {
			Text = ".lol",
			Color = colorfromrgb(226,226,226),
			Size = 14,
			Font = 2,
			Outline = true,
			Transparency = 1,
			ZIndex = 999
		}),
	}

	doWatermark = LPH_NO_VIRTUALIZE(function(dt)
		local total_size = (watermark[1]["TextBounds"]["X"] + watermark[2]["TextBounds"]["X"])/2
		local pos = nil
		
		if flags["watermark_location"][1] == "Center" then
			pos = camera.ViewportSize/2
		elseif flags["watermark_location"][1] == "Mouse" then
			pos = uis:GetMouseLocation()
		elseif flags["watermark_location"][1] == "Target" then
			local target = aimbot.target
			if target then
				local hrp = getCharacter(player_data[target]["entry"])["Torso"]

				if hrp then
					local _pos, on_screen = wtvp(camera, hrp.Position)
					if on_screen then
						pos = vector2new(_pos.X, _pos.Y)
					else
						pos = camera.ViewportSize/2
					end
				else
					pos = camera.ViewportSize/2
				end
			else
				pos = camera.ViewportSize/2 
			end
		end
 		
		pos+=vector2new(flags["watermark_x_offset"], flags["watermark_y_offset"]) - vector2new(total_size, 0)

		watermark[1]["Position"] = pos
		watermark[2]["Position"] = pos + vector2new(watermark[1]["TextBounds"]["X"],0)

		elapsed_time+=dt
		
		if elapsed_time < 0.5 then
			local tween_value = getValue(tws, (elapsed_time / 0.5), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local new_value = old_value + (new_value-old_value)*tween_value
			watermark[1].Transparency = new_value
		elseif cooldown then
			cooldown = false
			watermark[1].Transparency = cycle and 0 or 1
			cycle = not cycle
			new_value = cycle and 0 or 1
			old_value = cycle and 1 or 0
			task.delay(0.2, function()
				elapsed_time = 0
				cooldown = true
			end)
		end
	end)

	utility.newConnection(menu_references["watermark_size"].onSliderChange, function(value)
		for _, drawing in watermark do
			drawing["Size"] = value
		end
	end, true)
	
	utility.newConnection(menu_references["watermark_font"].onDropdownChange, function(selected)
		local font = fonts[tonumber(selected[1])]
		for _, drawing in watermark do
			drawing["Font"] = font
		end
	end, true)
	
	utility.newConnection(menu_references["watermark"].onColorChange, function(color)
		watermark[1]["Color"] = color
	end, true)
	
	utility.newConnection(menu_references["watermark"].onToggleChange, function(bool)
		for _, drawing in watermark do
			drawing["Visible"] = false
		end
		if find(heartbeat_callbacks, doWatermark) then
			remove(heartbeat_callbacks, doWatermark)
		end
		if bool then
			for _, drawing in watermark do
				drawing["Visible"] = true
			end
			insert(heartbeat_callbacks, doWatermark)
		end
		menu_references["watermark_x_offset"]:setVisible(bool)
		menu_references["watermark_y_offset"]:setVisible(bool)
		menu_references["watermark_size"]:setVisible(bool)
		menu_references["watermark_font"]:setVisible(bool)
		menu_references["watermark_location"]:setVisible(bool)
	end, true)
	menu_references["watermark_x_offset"]:setVisible(false)
	menu_references["watermark_y_offset"]:setVisible(false)
	menu_references["watermark_size"]:setVisible(false)
	menu_references["watermark_font"]:setVisible(false)
	menu_references["watermark_location"]:setVisible(false)
end

do
	local weapon_esp_objects = {}

	local doWeaponESP = LPH_NO_VIRTUALIZE(function(dt)
		local pos = camera.CFrame.p
		for object, drawing in weapon_esp_objects do
			if (pos-object.Position).magnitude > flags["dropped_weapon_max_distance"] then
				drawing["Visible"] = false
				continue end

			local pos, on_screen = wtvp(camera, object.Position)

			if not on_screen then
				drawing["Visible"] = false
				continue end

			drawing["Visible"] = true
			drawing["Position"] = vector2new(pos.X, pos.Y)
		end
	end)

	local weapon_connection = nil

	utility.newConnection(menu_references["dropped_weapon_esp"].onColorChange, LPH_JIT_MAX(function(color, transparency)
		for _, drawing in weapon_esp_objects do
			drawing["Color"] = color
			drawing["Transparency"] = transparency
		end
	end), true)

	utility.newConnection(menu_references["dropped_weapon_font"].onDropdownChange, LPH_JIT_MAX(function(font)
		local font = fonts[tonumber(font[1])]
		for _, drawing in weapon_esp_objects do
			drawing["Font"] = font
		end
	end), true)

	utility.newConnection(menu_references["dropped_weapon_size"].onSliderChange, LPH_JIT_MAX(function(value)
		for _, drawing in weapon_esp_objects do
			drawing["Size"] = value
		end
	end), true)

	utility.newConnection(menu_references["dropped_weapon_esp"].onToggleChange, LPH_JIT_MAX(function(bool)
		menu_references["dropped_weapon_font"]:setVisible(bool)
		menu_references["dropped_weapon_size"]:setVisible(bool)
		menu_references["dropped_weapon_max_distance"]:setVisible(bool)
		menu_references["dropped_weapon_surrounding"]:setVisible(bool)
		menu_references["dropped_weapon_casing"]:setVisible(bool)

		if find(heartbeat_callbacks, doWeaponESP) then
			remove(heartbeat_callbacks, doWeaponESP)
			for object, drawing in weapon_esp_objects do
				drawing:Destroy()
			end
		end
		if weapon_connection then
			weapon_connection:Disconnect()
		end
		if bool then
			weapon_connection = utility.newConnection(workspace.Ignore.GunDrop.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
				if object.Name ~= "Dropped" then
					return end

				task.wait()
				local node = object:WaitForChild("Slot1", 1)
				local display_name = object:WaitForChild("DisplayName", 1)
				if node and display_name then
					local name = object.DisplayName.Value
					local casing = flags["dropped_weapon_casing"][1]
					if casing == "Lowercase" then
						name = lower(name)
					elseif casing == "Uppercase" then
						name = string.upper(name)
					end
					local surrounding = flags["dropped_weapon_surrounding"][1]
					if surrounding == "Brackets" then
						name = "["..name.."]"
					elseif surrounding == "Arrows" then
						name = ">"..name.."<"
					end
					weapon_esp_objects[node] = utility.newDrawing("Text", {
						Visible = false,
						Size = flags["dropped_weapon_size"],
						Font = fonts[tonumber(flags["dropped_weapon_font"][1])],
						Color = flags["dropped_weapon_color"],
						Text = name,
						Outline = true,
						Transparency = -flags["dropped_weapon_transparency"]+1
					})

					utility.newConnection(object.AncestryChanged, function()
						if weapon_esp_objects[node] then
							weapon_esp_objects[node]:Destroy()
							weapon_esp_objects[node] = nil
						end
					end, true)
				end
			end), true)
			for _, object in workspace.Ignore.GunDrop:GetChildren() do
				if object.Name ~= "Dropped" then
					continue end

				local node = object:WaitForChild("Slot1", 1)
				local display_name = object:WaitForChild("DisplayName", 1)
				if node and display_name then
					local name = object.DisplayName.Value
					local casing = flags["dropped_weapon_casing"][1]
					if casing == "Lowercase" then
						name = lower(name)
					elseif casing == "Uppercase" then
						name = string.upper(name)
					end
					local surrounding = flags["dropped_weapon_surrounding"][1]
					if surrounding == "Brackets" then
						name = "["..name.."]"
					elseif surrounding == "Arrows" then
						name = ">"..name.."<"
					end
					weapon_esp_objects[node] = utility.newDrawing("Text", {
						Visible = false,
						Size = flags["dropped_weapon_size"],
						Font = fonts[tonumber(flags["dropped_weapon_font"][1])],
						Color = flags["dropped_weapon_color"],
						Text = name,
						Outline = true,
						Transparency = -flags["dropped_weapon_transparency"]+1
					})

					utility.newConnection(object.AncestryChanged, function()
						if weapon_esp_objects[node] then
							weapon_esp_objects[node]:Destroy()
							weapon_esp_objects[node] = nil
						end
					end, true)
				end
			end
			insert(heartbeat_callbacks, doWeaponESP)
		end
	end), true)
	menu_references["dropped_weapon_font"]:setVisible(false)
	menu_references["dropped_weapon_size"]:setVisible(false)
	menu_references["dropped_weapon_max_distance"]:setVisible(false)
	menu_references["dropped_weapon_surrounding"]:setVisible(false)
	menu_references["dropped_weapon_casing"]:setVisible(false)
end

local doAimbot = LPH_NO_VIRTUALIZE(function(dt)
	if os.clock() - aimbot.last_random_update > 0.1 then
		aimbot.last_random_update = os.clock()
		aimbot.do_hit = not (lplr_data["hit_chance"] <= mathrandom(1, 100))
		aimbot.silent_accuracy = (vector3new(mathrandom(-155,155),mathrandom(-155,155),mathrandom(-155,155))/100) * ((100-lplr_data["accuracy"])/100)
	end

	local mouse_position = uis:GetMouseLocation()
		aimbot.circle.Position = mouse_position
		aimbot.circle_outline.Position = mouse_position
		aimbot.assist_circle.Position = mouse_position
		aimbot.assist_circle_outline.Position = mouse_position
	local target = not flags["auto_select_target"] and aimbot.target or nil
	local aimbot_position = nil
	local max_target_distance = flags["max_target_distance"]

	if (target or flags["auto_select_target"]) and flags["aimbot_keybind"]["active"] then
		target = flags["auto_select_target"] and getAimbotCandidate(mouse_position) or target
		local gun = lplr_data["gun"]
		if not stop and target then
			local gun = gun == nil and "Default" or (not flags[gun.."_override_general"] and "Default") or gun
			local data = player_data[target]
			local character = getCharacter(data["entry"])
			local part = flags[gun.."_hitbox"][1]

			part = part == "Closest" and getClosestHitbox(mouse_position, character) or character[part]

			if not part then
				aimbot.target_position = nil
				line.Visible = false
				line_outline.Visible = false
				return 
			end

			local hrp = character["Torso"]
			local hrp_pos = camera.CFrame.Position 

			if flags["gradient_overlay"] then
				if data["knocked"] then
					if lplr_data["gradient_visible"] then
						tween(gradient_glow, newtweeninfo(0.08, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 0, 1)})
						lplr_data["gradient_visible"] = false
					end
				elseif not lplr_data["gradient_visible"] then
					tween(gradient_glow, newtweeninfo(0.15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 6, 1)})
					lplr_data["gradient_visible"] = true
				elseif not data["knocked"] then
					gradient_glow.CFrame = CFrame.new(hrp.CFrame.p)
				end
			end

			local part_position = part.Position
			if flags["multipoint"] then
				local cf = part.CFrame:PointToObjectSpace(mouse.Hit.p)
				local size = part.Size*(flags["multipoint_value"]/200)

				part_position = part.CFrame * vector3new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
			end

			local did_check_on_screen = nil
			local did_check_visible = nil

			if flags["silent_aim"] then
				local stop = false
				for _, check in flags["silent_aim_disable_when"] do
					if check == "Out of fov" then
						local pos = wtvp(camera, part_position)
						pos = vector2new(pos.X, pos.Y)
						if (pos-mouse_position).magnitude > aimbot["silent_aim_fov"] then
							stop = true
							break
						end
					elseif check == "Off screen" then
						local _, on_screen = wtvp(camera, part_position)
						if not on_screen then
							did_check_on_screen = false
							stop = true
							break
						end
					elseif check == "Behind wall" then
						local raycast_params = RaycastParams.new()
						raycast_params.IgnoreWater = true
						raycast_params.FilterDescendantsInstances = {hrp.Parent, camera, ignored_folder, ignored_folder2, ignored_folder3}
						raycast_params.FilterType = Enum.RaycastFilterType.Exclude

						if raycast(workspace, hrp_pos, (part_position - hrp_pos).unit * (part_position - hrp_pos).magnitude, raycast_params) then
							did_check_on_screen = false
							stop = true
							break
						end
					elseif check == "Not aiming down sights" and not lplr_data["aiming"] then
						stop = true
						break
					end
				end

				if not stop then
					aimbot_position = part_position
				end
			end

			if flags["aim_assist"] and flags["aim_assist_keybind"]["active"] then
				local stop = false

				for _, check in flags["aim_assist_disable_when"] do
					if check == "Out of fov" then
						local pos = wtvp(camera, part_position)
						pos = vector2new(pos.X, pos.Y)
						if (pos-mouse_position).magnitude > aimbot["aim_assist_fov"] then
							stop = true
							break
						end
					elseif check == "Off screen" then
						if did_check_on_screen == nil then
							local _, on_screen = wtvp(camera, part_position)
							if not on_screen then
								stop = true
								break
							end
						elseif not did_check_on_screen then
							stop = true
							break
						end
					elseif check == "Behind wall" then
						if did_check_visible == nil then
							local raycast_params = RaycastParams.new()
							raycast_params.IgnoreWater = true
							raycast_params.FilterDescendantsInstances = {hrp.Parent, camera, ignored_folder, ignored_folder2, ignored_folder3}
							raycast_params.FilterType = Enum.RaycastFilterType.Exclude

							if raycast(workspace, hrp_pos, (part_position - hrp_pos).unit * (part_position - hrp_pos).magnitude, raycast_params) then
								stop = true
								break
							end
						elseif not did_check_visible then
							stop = true
							break
						end
					elseif check == "Not aiming down sights" and not lplr_data["aiming"] then
						stop = true
						break
					end
				end

				if not stop then
					local velocity = vector3new()

					local horizontal = flags[gun.."_aim_assist_horizontal_shake"]
					local vertical = flags[gun.."_aim_assist_horizontal_shake"]
					if horizontal > 0 then
						velocity+=vector3new(mathrandom(1, horizontal+1)/(mathrandom(2) == 1 and -50 or 50),1,mathrandom(1, horizontal+1)/(mathrandom(2) == 1 and -50 or 50))
					end
					if vertical > 0 then
						velocity+=vector3new(1,mathrandom(1, vertical+1)/(mathrandom(2) == 1 and -50 or 50),1)
					end

					local position = part_position+velocity
					
					local pos = wtvp(camera, position)
					local new_pos = vector2new(pos.X, pos.Y)
					local distance = new_pos-mouse_position

					if aimbot.do_tp then
						mousemoverel(distance.X, distance.Y)
						aimbot.do_tp = false
					elseif math.abs(distance.magnitude) > aimbot["aim_assist_fov"]*aimbot["deadzone"] then
						local ease_style = Enum.EasingStyle[flags[gun.."_smoothing_style"][1]]
						local direction = Enum.EasingDirection[flags[gun.."_smoothing_direction"][1]]
						mousemoverel(distance.X * getValue(tws, ((100.01-flags[gun.."_aim_assist_horizontal_smoothness"])/100), ease_style, direction), distance.Y * getValue(tws, (100.01-flags[gun.."_aim_assist_vertical_smoothness"])/100, ease_style, direction))	
					end
				end
			end
		end
	end
	if target ~= aimbot.target then
		aimbotTargetChange:Fire(target)
		aimbot.target = target
	end
	aimbot.target_position = aimbot_position
end)

utility.newConnection(menu_references["aimbot_toggle"].onToggleChange, function(bool)
	local aimbot_circle = aimbot.circle
	aimbot.target = nil
	aimbotTargetChange:Fire(nil)
	aimbot_circle.Visible = (bool and flags["show_fov"] or false)
	aimbot.circle_outline.Visible = aimbot_circle.Visible
	aimbot.assist_circle.Visible = (bool and flags["aim_assist_fov"] or false)
	aimbot.assist_circle_outline.Visible = aimbot.assist_circle.Visible
	if find(heartbeat_callbacks, doAimbot) then
		remove(heartbeat_callbacks, doAimbot)
	end
	if bool then
		insert(heartbeat_callbacks, doAimbot)
	end
end, true)

local renderESP = nil

do	
	local do_box = flags["box"]
	local do_name = flags["name"]
	local do_health = flags["health"]
	local do_health_number = flags["health_number"]
	local do_ammo = flags["ammo"]
	local do_weapon = flags["weapon"]
	local do_ammo_number = flags["ammo_number"]
	local do_skeleton = flags["skeleton_toggle"]
	local do_highlight = flags["highlight_toggle"]
	local do_chams = flags["chams_toggle"]

	local below = vector3new(0, -3.65, 0)
	local above = vector3new(0, 2.9, 0)

	renderESP = LPH_NO_VIRTUALIZE(function(dt)
		for player, info in player_data do
			local drawings = info["drawings"]
			local entry = info["entry"]

			if not entry or player.Team == lplr.Team then
				if not info["not_on_screen"] then
					info["not_on_screen"] = true
					for _, drawing in drawings do
						drawing.Visible = false
					end
					if do_chams then
						local chams = info["chams"]
						for _, part in part_list do
							chams["hidden"][part]["Adornee"] = nil
							chams["visible"][part]["Adornee"] = nil
						end
					end
					if info["highlight"] then
						info["highlight"]["Adornee"] = nil
					end
				end
				continue 
			end

			local character = getCharacter(entry)

			if entry["_alive"] then
				info["last_position"][7] = os.clock()
			end

			if (not character or not entry["_alive"]) and (os.clock()-info["last_position"][7]) > 0.5 then
				info["not_on_screen"] = true

				for _, drawing in drawings do
					drawing.Visible = false
				end
				if info["highlight"] then
					info["highlight"]["Adornee"] = nil
				end
				if do_chams then
					local chams = info["chams"]
					for _, part in part_list do
						chams["hidden"][part]["Adornee"] = nil
						chams["visible"][part]["Adornee"] = nil
					end
				end
				continue 
			end

			local hrp = character and character.Torso or nil

			if hrp then
				local hrp_pos = hrp.Position

				info["last_position"][1] = hrp_pos
				info["last_position"][7] = os.clock()

				local bottom, bottom_visible = wtvp(camera, hrp_pos + below) 
				local top, top_visible = nil, nil

				if not bottom_visible then
					top, top_visible = wtvp(camera, hrp_pos + above)
				end

				if bottom_visible or top_visible then
					if top == nil then 
						top = wtvp(camera, hrp_pos + above)
					end

					info["not_on_screen"] = false

					local size = (bottom.Y - top.Y)
					local box_size = vector2new(size * 0.7, size * 0.95)
					local box_pos = vector2new(bottom.X - size * 0.35, bottom.Y - size * 0.95)
					local box_size_y = box_size.Y
					local box_size_x = box_size.X
					local box_pos_x = box_pos.X
					local box_pos_y = box_pos.Y

					if do_highlight then
						info["highlight"].Adornee = hrp.Parent
					end

					if do_chams then
						local chams = info["chams"]
						for _, part in part_list do
							local hidden = chams["hidden"][part]
							local visible = chams["visible"][part]
							hidden["Adornee"] = character[part]
							visible["Adornee"] = character[part]
							hidden["Transparency"] = flags["chams_transparency"]
							visible["Transparency"] = flags["visible_chams_transparency"]
						end
					end

					if do_box then
						local outline = drawings[1]
						local box = drawings[2]

						box["Size"] = box_size
						box["Position"] = box_pos
						outline["Size"] = box_size
						outline["Position"] = box_pos
						outline["Visible"] = true
						box["Visible"] = true

						box["Transparency"] = -flags["box_transparency"]+1
						outline["Transparency"] = -flags["box_transparency"]+1
					end

					if do_name then
						local name = drawings[3]

						name["Position"] = vector2new(box_size_x / 2 + box_pos_x, box_pos_y - name.TextBounds.Y - 2)
						name["Visible"] = true
						name["Transparency"] = -flags["name_transparency"]+1
					end

					if do_health then
						local health, max_health = entry._healthstate.health0, entry._healthstate.maxhealth
						local bar = drawings[5]
						local outline = drawings[4]
						health = health == 0 and 100 or health
						health = round(health, 0)
						local ratio = health / max_health

						bar.Position = vector2new(box_pos_x - 5, box_pos_y + box_size_y)
						bar.Size = vector2new(1, -ratio * box_size_y)
						outline.From = vector2new(bar.Position.X, box_pos_y + box_size_y + 1)
						outline.To = vector2new(bar.Position.X, bar.Position.Y - box_size_y - 1)
						outline.Visible = true
						bar.Visible = true
						bar["Transparency"] = -flags["health_transparency"]+1
						outline["Transparency"] = -flags["health_transparency"]+1

						if do_health_number then
							local text = drawings[7]

							text.Visible = ratio < 0.99 and true or false

							if text.Visible then
								text.Text = tostring(floor(health))
								text.Position = bar.Position - vector2new(text.TextBounds.X/2 + 2, 6 - bar.Size.Y)
							end

							text["Transparency"] = -flags["number_transparency"]+1
						end
					end

					if do_weapon then
						local text = getWeapon(entry)
						local tool = drawings[6]

						tool.Visible = text and true or false

						if text then
							local casing = flags["dropped_weapon_casing"][1]
							if casing == "Lowercase" then
								text = lower(text)
							elseif casing == "Uppercase" then
								text = string.upper(text)
							end
							local surrounding = flags["dropped_weapon_surrounding"][1]
							if surrounding == "Brackets" then
								text = "["..text.."]"
							elseif surrounding == "Arrows" then
								text = ">"..text.."<"
							end

							tool.Text = text
							tool["Transparency"] = -flags["weapon_transparency"]+1
							tool.Position = vector2new(box_size_x / 2 + box_pos_x, box_pos_y + box_size_y)
						end
					end

					if do_skeleton and info["last_position"][2] then
						local torso_pos = wtvp(camera, hrp_pos)

						local left_arm_pos = wtvp(camera, character["Left Arm"].Position)
						local right_arm_pos = wtvp(camera, character["Right Arm"].Position)
						local left_leg_pos = wtvp(camera, character["Left Leg"].Position)
						local right_leg_pos = wtvp(camera, character["Right Leg"].Position)
						local head_pos = wtvp(camera, character["Head"].Position)

						info["last_position"][2] = character["Left Arm"].Position
						info["last_position"][3] = character["Right Arm"].Position
						info["last_position"][4] = character["Left Leg"].Position
						info["last_position"][5] = character["Right Leg"].Position
						info["last_position"][6] = character["Head"].Position

						torso_pos = vector2new(torso_pos.X, torso_pos.Y)

						for i = 8, 17 do
							local drawing = drawings[i]

							drawing["Visible"] = true
							drawing["From"] = torso_pos
							drawing["Transparency"] = -flags["skeleton_transparency"]+1
						end

						left_arm_pos = vector2new(left_arm_pos.X, left_arm_pos.Y)
						right_arm_pos = vector2new(right_arm_pos.X, right_arm_pos.Y)
						left_leg_pos = vector2new(left_leg_pos.X, left_leg_pos.Y)
						right_leg_pos = vector2new(right_leg_pos.X, right_leg_pos.Y)
						head_pos = vector2new(head_pos.X, head_pos.Y)

						drawings[8].To = left_arm_pos
						drawings[9].To = right_arm_pos
						drawings[10].To = left_leg_pos
						drawings[11].To = right_leg_pos
						drawings[12].To = head_pos
						drawings[13].To = left_arm_pos
						drawings[14].To = right_arm_pos
						drawings[15].To = left_leg_pos
						drawings[16].To = right_leg_pos
						drawings[17].To = head_pos
					end
				elseif not info["not_on_screen"] then
					for _, drawing in drawings do
						drawing.Visible = false
					end		
				end
			elseif info["last_position"][1] then
				local hrp_pos = info["last_position"][1]

				local bottom, bottom_visible = wtvp(camera, hrp_pos + below) 
				local top, top_visible = nil, nil

				if not bottom_visible then
					top, top_visible = wtvp(camera, hrp_pos + above)
				end

				if bottom_visible or top_visible then
					if top == nil then 
						top = wtvp(camera, hrp_pos + above)
					end

					info["not_on_screen"] = false

					local sold = (os.clock()-info["last_position"][7])/0.5 * dt * 5

					local size = (bottom.Y - top.Y)
					local box_size = vector2new(size * 0.7, size * 0.95)
					local box_pos = vector2new(bottom.X - size * 0.35, bottom.Y - size * 0.95)
					local box_size_y = box_size.Y
					local box_size_x = box_size.X
					local box_pos_x = box_pos.X
					local box_pos_y = box_pos.Y

					if do_chams then
						local chams = info["chams"]
						for _, part in part_list do
							local hidden = chams["hidden"][part]
							local visible = chams["visible"][part]
							hidden["Transparency"]+=sold
							visible["Transparency"]+=sold
						end
					end

					if do_box then
						local outline = drawings[1]
						local box = drawings[2]

						box["Size"] = box_size
						box["Position"] = box_pos
						outline["Size"] = box_size
						outline["Position"] = box_pos
						outline["Visible"] = true
						box["Visible"] = true
						outline["Transparency"]-=sold
						box["Transparency"]-=sold
					end

					if do_name then
						local name = drawings[3]

						name["Position"] = vector2new(box_size_x / 2 + box_pos_x, box_pos_y - name.TextBounds.Y - 2)
						name["Visible"] = true

						name["Transparency"] = name["Transparency"] - sold
					end

					if do_health then
						local health, max_health = entry._healthstate.health0, entry._healthstate.maxhealth
						local bar = drawings[5]
						local outline = drawings[4]
						local ratio = 0 / max_health

						bar.Position = vector2new(box_pos_x - 5, box_pos_y + box_size_y)
						bar.Size = vector2new(1, -ratio * box_size_y)
						outline.From = vector2new(bar.Position.X, box_pos_y + box_size_y + 1)
						outline.To = vector2new(bar.Position.X, bar.Position.Y - box_size_y - 1)
						outline.Visible = true
						bar.Visible = true

						bar["Transparency"] = bar["Transparency"] - sold
						outline["Transparency"] = outline["Transparency"] - sold

						if do_health_number then
							local text = drawings[7]

							text.Visible = ratio < 0.99 and true or false

							if text.Visible then
								text.Text = "0"
								text.Position = bar.Position - vector2new(text.TextBounds.X/2 + 2, 6 - bar.Size.Y)
							end

							text["Transparency"] = text["Transparency"] - sold
						end
					end

					if do_weapon then
						local text = getWeapon(entry)
						local tool = drawings[6]

						tool.Visible = text and true or false

						if text then
							local casing = flags["dropped_weapon_casing"][1]
							if casing == "Lowercase" then
								text = lower(text)
							elseif casing == "Uppercase" then
								text = string.upper(text)
							end
							local surrounding = flags["dropped_weapon_surrounding"][1]
							if surrounding == "Brackets" then
								text = "["..text.."]"
							elseif surrounding == "Arrows" then
								text = ">"..text.."<"
							end

							tool.Text = text
							tool.Position = vector2new(box_size_x / 2 + box_pos_x, box_pos_y + box_size_y)

							text["Transparency"] = text["Transparency"] - sold
						end
					end

					if do_skeleton and info["last_position"][2] then
						local torso_pos = wtvp(camera, hrp_pos)

						local left_arm_pos = wtvp(camera, info["last_position"][2])
						local right_arm_pos = wtvp(camera, info["last_position"][3])
						local left_leg_pos = wtvp(camera, info["last_position"][4])
						local right_leg_pos = wtvp(camera, info["last_position"][5])
						local head_pos = wtvp(camera, info["last_position"][6])

						torso_pos = vector2new(torso_pos.X, torso_pos.Y)

						for i = 8, 17 do
							local drawing = drawings[i]

							drawing["Visible"] = true
							drawing["From"] = torso_pos
							drawing["Transparency"] = drawing["Transparency"] - sold
						end

						left_arm_pos = vector2new(left_arm_pos.X, left_arm_pos.Y)
						right_arm_pos = vector2new(right_arm_pos.X, right_arm_pos.Y)
						left_leg_pos = vector2new(left_leg_pos.X, left_leg_pos.Y)
						right_leg_pos = vector2new(right_leg_pos.X, right_leg_pos.Y)
						head_pos = vector2new(head_pos.X, head_pos.Y)

						drawings[8].To = left_arm_pos
						drawings[9].To = right_arm_pos
						drawings[10].To = left_leg_pos
						drawings[11].To = right_leg_pos
						drawings[12].To = head_pos
						drawings[13].To = left_arm_pos
						drawings[14].To = right_arm_pos
						drawings[15].To = left_leg_pos
						drawings[16].To = right_leg_pos
						drawings[17].To = head_pos
					end
				elseif not info["not_on_screen"] then
					for _, drawing in drawings do
						drawing.Visible = false
					end		
				end
			elseif not info["not_on_screen"] then
				for _, drawing in drawings do
					drawing.Visible = false
				end	
			end
		end
	end)

	utility.newConnection(menu_references["chams_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_chams = bool
		menu_references["visible_chams_toggle"]:setVisible(bool)
		for player, info in player_data do
			local chams = info["chams"]
			if chams then
				for _, box in chams["hidden"] do
					box["Adornee"] = nil
				end
				for _, box in chams["visible"] do
					box["Adornee"] = nil
				end
			end
		end
	end), true)
	menu_references["visible_chams_toggle"]:setVisible(false)
	utility.newConnection(menu_references["box_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_box = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[1]["Visible"] = false
					drawings[2]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["name_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_name = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[3]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["health_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_health = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[4]["Visible"] = false
					drawings[5]["Visible"] = false
					drawings[7]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["health_number"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_health_number = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[7]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["weapon_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_weapon = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[6]["Visible"] = false
				end
			end
		end
	end), true)
	
	utility.newConnection(menu_references["highlight_toggle"].onToggleChange, function(bool)
		do_highlight = bool
		menu_references["highlight_outline"]:setVisible(bool)
		menu_references["through_walls"]:setVisible(bool)
		for player, info in player_data do
			local highlight = info["highlight"]
			if highlight then
				highlight.Enabled = bool
			end
		end
	end, true)
	menu_references["highlight_outline"]:setVisible(false)
	menu_references["through_walls"]:setVisible(false)

	utility.newConnection(menu_references["skeleton_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_skeleton = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				for i = 8, 17 do
					drawings[i]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["skeleton_toggle"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
		for player, info in player_data do
			local drawings = info["drawings"]

			for i = 8, 17 do
				drawings[i]["Color"] = i < 13 and color or colorfromrgb(0,0,0)
				drawings[i]["Transparency"] = transparency
			end
		end
	end), true)

	utility.newConnection(menu_references["weapon_toggle"].onToggleChange, function(bool)
		menu_references["weapon_size"]:setVisible(bool)
	end, true)
	menu_references["weapon_size"]:setVisible(false)
	
	utility.newConnection(menu_references["weapon_toggle"].onColorChange, function(color, transparency)
		for player, info in player_data do
			local drawings = info["drawings"]
	
			if drawings then
				local weapon = drawings[6]
	
				if weapon then
					weapon["Color"] = color
					weapon["Transparency"] = -transparency+1
				end
			end
		end
	end, true)
end

utility.newConnection(menu_references["esp_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if find(heartbeat_callbacks, renderESP) then
		remove(heartbeat_callbacks, renderESP)
	end
	if not bool then
		for player, info in player_data do
			info["not_on_screen"] = true
			local drawings = info["drawings"]
			if drawings then
				for _, drawing in drawings do
					drawing:Destroy()
				end
			end
			local highlight = info["highlight"]
			if highlight then
				highlight:Destroy()
			end
			local chams = info["chams"]
			if chams then
				for _, box in chams["hidden"] do
					box:Destroy()
				end
				for _, box in chams["visible"] do
					box:Destroy()
				end
			end
		end
	else
		insert(heartbeat_callbacks, renderESP)
		for player, info in player_data do
			info["not_on_screen"] = true
			local drawings = info["drawings"]
			if drawings then
				for _, drawing in drawings do
					drawing:Destroy()
				end
			end
			local highlight = info["highlight"]
			if highlight then
				highlight:Destroy()
			end
			local chams = info["chams"]
			if chams then
				for _, box in chams["hidden"] do
					box:Destroy()
				end
				for _, box in chams["visible"] do
					box:Destroy()
				end
			end
			local drawings, highlight, chams = createESPObjects(player)
			info["drawings"] = drawings
			info["highlight"] = highlight
			info["chams"] = chams
		end
	end
end), true)

utility.newConnection(menu_references["world_exposure"].onSliderChange, function(value)
	if not flags["world_exposure"] then
		return end

	lighting.ExposureCompensation = value
end, true)

utility.newConnection(menu_references["world_exposure"].onToggleChange, function(bool)
	lighting.ExposureCompensation = bool and flags["world_exposure_value"] or spoof_properties["ExposureCompensation"]
end, true)

utility.newConnection(menu_references["world_time"].onSliderChange, function(value)
	if not flags["world_time"] then
		return end

	lighting.ClockTime = value
end, true)

utility.newConnection(menu_references["world_time"].onToggleChange, function(bool)
	lighting.ClockTime = bool and flags["world_time_value"] or spoof_properties["ClockTime"]
end, true)

utility.newConnection(menu_references["world_ambient"].onColorChange, function(color)
	if not flags["world_ambient"] then
		return end

	lighting.Ambient = color
end, true)

utility.newConnection(menu_references["world_ambient"].onToggleChange, function(bool)
	lighting.Ambient = bool and flags["world_ambient_color"] or spoof_properties["Ambient"]
end, true)

utility.newConnection(menu_references["world_brightness"].onSliderChange, function(value)
	if not flags["world_brightness"] then
		return end

	lighting.Brightness = value
end, true)

utility.newConnection(menu_references["world_brightness"].onToggleChange, function(bool)
	lighting.Brightness = bool and flags["world_brightness_value"] or spoof_properties["Brightness"]
end, true)

utility.newConnection(menu_references["remove_shadows"].onToggleChange, function(bool)
	lighting.GlobalShadows = not bool
end, true)

utility.newConnection(menu_references["fog_changer"].onColorChange, function(color)
	if not flags["fog_changer"] then
		return end

	lighting.FogColor = color
end, true)

utility.newConnection(menu_references["fog_end"].onSliderChange, function(value)
	if not flags["fog_changer"] then
		return end

	lighting.FogEnd = value
end, true)

utility.newConnection(menu_references["fog_start"].onSliderChange, function(value)
	if not flags["fog_changer"] then
		return end

	lighting.FogStart = value
end, true)

utility.newConnection(menu_references["fog_changer"].onToggleChange, function(bool)
	if bool then
		lighting.FogStart = flags["fog_start"]
		lighting.FogEnd = flags["fog_end"]
		lighting.FogColor = flags["fog_color"]
	else
		lighting.FogStart = spoof_properties["FogStart"]
		lighting.FogEnd = spoof_properties["FogEnd"]
		lighting.FogColor = spoof_properties["FogColor"]
	end
	menu_references["fog_start"]:setVisible(bool)
	menu_references["fog_end"]:setVisible(bool)
end, true)
menu_references["fog_start"]:setVisible(false)
menu_references["fog_end"]:setVisible(false)

utility.newConnection(menu_references["players_box"].onSelectionChange, function(selected)
	local player = plrs:FindFirstChild(selected)

	if not player then
		return end 
end, true)

local skyboxes = {
	["Default"] = {
		["SkyboxBk"] = "",
		["SkyboxDn"] = "",
		["SkyboxFt"] = "",
		["SkyboxLf"] = "",
		["SkyboxRt"] = "",
		["SkyboxUp"] = ""
	},
	["Retro"] = {
		["SkyboxBk"] = "rbxasset://Sky/null_plainsky512_bk.jpg",
		["SkyboxDn"] = "rbxasset://Sky/null_plainsky512_dn.jpg",
		["SkyboxFt"] = "rbxasset://Sky/null_plainsky512_ft.jpg",
		["SkyboxLf"] = "rbxasset://Sky/null_plainsky512_lf.jpg",
		["SkyboxRt"] = "rbxasset://Sky/null_plainsky512_rt.jpg",
		["SkyboxUp"] = "rbxasset://Sky/null_plainsky512_up.jpg",
	},
	["Crimson Night"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=570555736",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=570555964",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=570555800",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=570555840",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=570555882",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=570555929",
	},
	["Blue Galaxy"] = {
		["SkyboxBk"] = "rbxassetid://393845394",
		["SkyboxDn"] = "rbxassetid://393845204",
		["SkyboxFt"] = "rbxassetid://393845629",
		["SkyboxLf"] = "rbxassetid://393845750",
		["SkyboxRt"] = "rbxassetid://393845533",
		["SkyboxUp"] = "rbxassetid://393845287",
	},
	["Abyssal Blues"] = {
		["SkyboxBk"] = "rbxassetid://16269815885",
		["SkyboxDn"] = "rbxassetid://16269839652",
		["SkyboxFt"] = "rbxassetid://16269798011",
		["SkyboxLf"] = "rbxassetid://16269813852",
		["SkyboxRt"] = "rbxassetid://16269814948",
		["SkyboxUp"] = "rbxassetid://16269829700",
	},
	["Sunrise"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=158664655",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=158664673",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=158664598",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=158664558",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=158664624",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=158664465",
	},
	["Orange Sunset"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=458016711",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=458016826",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=458016532",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=458016655",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=458016782",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=458016792",
	},
	["Stormy Night"] = {
		["SkyboxBk"] = "rbxassetid://323479840",
		["SkyboxDn"] = "rbxassetid://323481190",
		["SkyboxFt"] = "rbxassetid://323480314",
		["SkyboxLf"] = "rbxassetid://323480786",
		["SkyboxRt"] = "rbxassetid://323480131",
		["SkyboxUp"] = "rbxassetid://323478865",
	},
	["Snowy"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=155657655",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=155674246",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=155657609",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=155657671",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=155657619",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=155674931",
	},
	["Spongebob"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=277099484",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=277099500",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=277099554",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=277099531",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=277099589",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=277101591",
	}
}

if sky then
	for property, value in skyboxes["Default"] do
		skyboxes["Default"][property] = sky[property]
	end
end

utility.newConnection(menu_references["world_skybox"].onDropdownChange, function(selected)
	if not flags["world_skybox"] then
		return end

	local selected = selected[1]
	for property, value in skyboxes[selected] do
		sky[property] = value
	end
end, true)

utility.newConnection(menu_references["world_skybox"].onToggleChange, function(bool)
	if not bool then
		for property, value in skyboxes["Default"] do
			sky[property] = value
		end
	else
		local selected = flags["world_skybox_skybox"][1]

		for property, value in skyboxes[selected] do
			sky[property] = value
		end
	end
end, true)

utility.newConnection(menu_references["notifications_"].onToggleChange, function(bool)
	menu_references["notification_style"]:setVisible(bool)
	menu_references["notification_font"]:setVisible(bool)
	menu_references["notification_y_offset"]:setVisible(bool)
end)
menu_references["notification_style"]:setVisible(false)
menu_references["notification_font"]:setVisible(false)
menu_references["notification_y_offset"]:setVisible(false)

local data_ping = stats.Network.ServerStatsItem["Data Ping"]

utility.newConnection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
	for _, callback in heartbeat_callbacks do
		_spawn(callback, dt)
	end

	for _, callback in anti_callbacks do
		_spawn(callback, dt)
	end
end), true)

for _, player in plrs:GetPlayers() do
	if player == lplr then
		continue 
	end

	_spawn(playerAdded, player)
end

if getgenv().autoload and getgenv().autoload ~= "" then
	utility.loadConfig(getgenv().autoload)
	menu.on_load:Fire()
end

if getgenv().streamable then
	menu.blocked = true
	_screenGui.Enabled = false

	getgenv().juju = {}

	getgenv().juju.unload = LPH_NO_VIRTUALIZE(function()
		for player, info in player_data do
			local highlight = info["highlight"]
			if highlight then
				highlight:Destroy()
			end
			local drawings = info["drawings"]
			if drawings then
				for _, drawing in drawings do
					drawing:Destroy()
				end
			end
		end
		for flag, value in pairs(flags) do
			if typeof(value) == "boolean" then
				flags[flag] = false
			end
		end
		menu.on_load:Fire()
		for _, connection in utility.connections do
			connection:Disconnect()
		end
		_screenGui:Destroy()
		for _, drawing in keybinder.drawings do
			drawing:Destroy()
		end
		for lua, _ in script_environment do
			task.cancel(script_environment[lua])
			script_environment[lua] = nil
			script_unloaded:Fire(lua)
		end
		getgenv().juju = nil
	end)

	getgenv().juju.load_config = LPH_NO_VIRTUALIZE(function(name)
		utility.loadConfig(name)
		menu.on_load:Fire()
	end)
end