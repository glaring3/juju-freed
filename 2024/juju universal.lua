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
	local tool_images = {
		["revolver"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/revolver.png"),
		["doublebarrelsg"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/doublebarrelsg.png"),
		["flamethrower"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/flamethrower.png"),
		["ar"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/ar.png"),
		["drumgun"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/drumgun.png"),
		["glock"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/glock.png"),
		["p90"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/p90.png"),
		["tacticalshotgun"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/tactical.png"),
		["silencer"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/silencer.png"),
		["shotgun"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/shotgun.png"),		
		["rifle"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/rifle.png"),
		["lmg"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/lmg.png"),
		["silencerar"] =  game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/silencerar.png"),
		["smg"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/smg.png"),
		["rpg"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/rpg.png"),
		["drumshotgun"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/drumshotgun.png"),
		["knife"] = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/knife.png")
	}
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
		mouse_positions = {},
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
		local new = #array+1
		array[new] = _
		return new
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
	flags = {
		loaded_scripts = {}
	},
	active_keybind = nil,
	active_colorpicker = nil,
	accent_color = colorfromrgb(153, 196, 39),
	on_accent_change = signal.new(),
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
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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
			_screenGui.Enabled = Border.BackgroundTransparency ~= 1
			menu.is_open = _screenGui.Enabled
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
			if string.lower(_element) == "toggle" then
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
			elseif string.lower(_element) == "dropdown" then
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

				utility.newConnection(menu.on_load, function()
					new_element:setSelected(flags[_info.flag])
				end, true)
			elseif string.lower(_element) == "slider" then
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
				end, true)

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
							new_element:setValue(round(flags[_info.flag]+_info.changers, _info.decimal))
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
			elseif string.lower(_element) == "colorpicker" then
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
			elseif string.lower(_element) == "button" then
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
			elseif string.lower(_element) == "keybind" then
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
			elseif string.lower(_element) == "multibox" then
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
						local text = string.lower(TextBox.Text)

						if text == "_" then
							return end

						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								if text == "" or string.lower(object.Name):find(text) then
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
			elseif string.lower(_element) == "textbox" then
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
					local text = string.lower(TextBox.Text)

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
		if gpe and input.UserInputType == Enum.UserInputType.Keyboard then 
			lplr_data["typing"] = true
			if find(flags["untarget"], "Typing") and aimbot.target then
				aimbot.target = nil
				aimbotTargetChange:Fire(nil)
			end
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
		if gpe then 
			if input.UserInputType == Enum.UserInputType.Keyboard then 
				lplr_data["typing"] = false
			end
			return 
		end
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
-- * Game Functions * --
------------------------

local menu_references = {}

local game_args = {
	[5743757818] = "MOUSE",
	[1958807588] = "MousePos",
	[3634139746] = "MousePosUpdate",
	[5235037897] = "MOUSE",
	[5646083046] = "UpdateMousePos",
	[5738501053] = "MOUSE"
}

local game_arg =  game_args[game.GameId] or "UpdateMousePos"
local second_arg = game.GameId == 1958807588 and "P"

local event = nil
local ignored_folder = nil
local effects_folder = nil

local potential_names = {
	knocked = {
		"K.O"
	},
	grabbed = {
		"Grabbed"
	},
	armor = {
		"Armor"
	},
}

local folder_name = nil

local found_values = {
	knocked = false,
	grabbed = false,
	armor = false,
}

for _, folder in game.StarterPlayer.StarterCharacterScripts:GetChildren() do
	local children = folder:GetChildren()
	for needed, names in potential_names do
		for _, name in names do
			if folder:FindFirstChild(name) then
				folder_name = folder.Name
				found_values[needed] = name
				break
			end
		end
	end
end

for _, object in workspace:GetDescendants() do
	if lower(object.Name):find("ignore") and not ignored_folder then
		ignored_folder = folder
		break
	end
end

for _, remote in reps:GetDescendants() do
	if remote.ClassName == "RemoteEvent" and lower(remote.Name):find("main") and remote.Name ~= "OnMainChannelSet" then
		event = remote
		break
	end
end

if event == nil then 
	lplr:Kick("Failed to find main remote!")
end

ignored_folder = ignored_folder or workspace:FindFirstChildOfClass("Folder")
if ignored_folder == nil then
	lplr:Kick("Failed to find ignored folder!")
end

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
				Text = "for";
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

local target_info = {
	drawings = {
		utility.newDrawing("Square", {
			Position = vector2new(50,500);
			Size = vector2new(240,120);
			Color = colorfromrgb(12,12,12);
			ZIndex = 1;
			Filled = true
		}),
		utility.newDrawing("Square", {
			Position = vector2new(50,500);
			Size = vector2new(238,118);
			Color = colorfromrgb(60,60,60);
			ZIndex = 2;
			Filled = true
		}),
		utility.newDrawing("Square", {
			Position = vector2new(50,500);
			Size = vector2new(236,116);
			Color = colorfromrgb(40,40,40);
			ZIndex = 3;
			Filled = true
		}),
		utility.newDrawing("Square", {
			Position = vector2new(50,500);
			Size = vector2new(232,112);
			Color = colorfromrgb(60,60,60);
			ZIndex = 4;
			Filled = true
		}),
		utility.newDrawing("Square", {
			Position = vector2new(50,500);
			Size = vector2new(230,110);
			Color = colorfromrgb(12,12,12);
			ZIndex = 5;
			Filled = true
		}),
		utility.newDrawing("Square", {
			Position = vector2new(50,500);
			Size = vector2new(230,25);
			Color = colorfromrgb(20,20,20);
			ZIndex = 5;
			Filled = true
		}),
		utility.newDrawing("Image", {
			Data = line_image;
			Color = colorfromrgb(255, 255, 255);
			Size = vector2new(230,2);
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(255, 255, 255);
			Size = 16;
			Text = "target info";
			Center = true;
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(255, 255, 255);
			Size = 16;
			Text = "target";
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(153, 196, 39);
			Size = 16;
			Text = "no one";
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(255, 255, 255);
			Size = 16;
			Text = "health";
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(153, 196, 39);
			Size = 16;
			Text = "100/100";
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(255, 255, 255);
			Size = 16;
			Text = "armor";
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(153, 196, 39);
			Size = 16;
			Text = "100/130";
			Font = 2;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(255, 255, 255);
			Size = 16;
			Text = "";
			Font = 2;
			Visible = false;
			ZIndex = 6
		}),
		utility.newDrawing("Text", {
			Color = colorfromrgb(153, 196, 39);
			Size = 16;
			Text = "";
			Font = 2;
			Visible = false;
			ZIndex = 6
		}),
	},
	tween_connection = nil
}

function target_info:move(position)
	local drawings = target_info.drawings
	for i = 1, 6 do
		local addon = i
		if addon > 3 and addon < 6 then
			addon+=1
		end
		local drawing = drawings[i]
		drawing.Position = position + vector2new(addon, addon)
	end
	drawings[8].Position = position + vector2new(120,10)
	drawings[7].Size = vector2new(230,2)
	drawings[7].Position = position + vector2new(6,33)
	drawings[9].Position = position + vector2new(12,38)
	drawings[10].Position = position + vector2new(230 - drawings[10].TextBounds.X - 3,38)
	drawings[11].Position = position + vector2new(12,56)
	drawings[12].Position = position + vector2new(230 - drawings[12].TextBounds.X - 3,56)
	drawings[13].Position = position + vector2new(12,74)
	drawings[14].Position = position + vector2new(230 - drawings[14].TextBounds.X - 3,74)
	drawings[15].Position = position + vector2new(12,92)
	drawings[16].Position = position + vector2new(230 - drawings[16].TextBounds.X - 3,92)
	flags["target_info_position"] = {"A", position.X, position.Y}
end

function target_info:set_target(target)
	target_info.drawings[10].Text = target
	target_info.drawings[10].Position = target_info.drawings[1].Position + vector2new(230 - target_info.drawings[10].TextBounds.X - 3, 38)
end

function target_info:set_health(health, max_health)
	target_info.drawings[12].Text = tostring(floor(health)).."/"..tostring(max_health)
	target_info.drawings[12].Position = target_info.drawings[1].Position + vector2new(230 - target_info.drawings[12].TextBounds.X - 3,56)
end

function target_info:set_armor(armor)
	target_info.drawings[14].Text = tostring(floor(armor)).."/130"
	target_info.drawings[14].Position = target_info.drawings[1].Position + vector2new(230 - target_info.drawings[14].TextBounds.X - 3,74)
end

function target_info:set_gun(gun)
	target_info.drawings[15].Text = gun and "gun" or ""
	target_info.drawings[16].Text = gun or ""
	if gun then
		target_info.drawings[16].Position = target_info.drawings[1].Position + vector2new(230 - target_info.drawings[16].TextBounds.X - 3,92)
		target_info.drawings[1].Size = vector2new(240,120)
		target_info.drawings[2].Size = vector2new(238,118)
		target_info.drawings[3].Size = vector2new(236,116)
		target_info.drawings[4].Size = vector2new(232,112)
		target_info.drawings[5].Size = vector2new(230,110)
	else
		target_info.drawings[1].Size = vector2new(240,100)
		target_info.drawings[2].Size = vector2new(238,98)
		target_info.drawings[3].Size = vector2new(236,96)
		target_info.drawings[4].Size = vector2new(232,92)
		target_info.drawings[5].Size = vector2new(230,90)
	end
end

function target_info:open()
	for _, drawing in target_info.drawings do
		drawing.Visible = true
	end
end

function target_info:close()
	for _, drawing in target_info.drawings do
		drawing.Visible = false
	end
end

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
target_info:move(vector2new(30, camera.ViewportSize.Y/2))
flags["keybind_position"] = {"A", (camera.ViewportSize/2).X, (camera.ViewportSize/2).Y}
flags["target_info_position"] = {"A", 30, (camera.ViewportSize/2).Y}

local spoof_properties = {
	["FogColor"] = lighting.FogColor,
	["ExposureCompensation"] = lighting.ExposureCompensation,
	["FogEnd"] = lighting.FogEnd,
	["FogStart"] = lighting.FogStart,
	["GlobalShadows"] = lighting.GlobalShadows,
	["ClockTime"] = floor(lighting.ClockTime),
	["Brightness"] = lighting.Brightness,
	["Ambient"] = lighting.Ambient,
	["CameraMaxZoomDistance"] = lplr.CameraMaxZoomDistance,
	["JumpPower"] = 50,
	["WalkSpeed"] = 16,
	["CFrame"] = cframenew()
}

local aimbotTargetChange = signal.new()

local bounding_box_object = newObject("SelectionBox", {
	LineThickness = 0.01,
	SurfaceColor3 = colorfromrgb(255,255,255),
	SurfaceTransparency = 1,
	Color3 = colorfromrgb(255,255,255),
	Parent = gethui and gethui()
})

local gun_types = {
	["Default"] = {},
	["Pistols"] = {},
	["Shotguns"] = {},
	["Automatics"] = {}
}

local gun_type = {
	["[LMG]"] = "Automatics",
	["[Double-Barrel SG]"] = "Shotguns",
	["[TacticalShotgun]"] = "Shotguns",
	["[AUG]"] = "Automatics",
	["[P90]"] = "Automatics",
	["[Glock]"] = "Pistols",
	["[DrumGun]"] = "Automatics",
	["[Rifle]"] = "Default",
	["[Shotgun]"] = "Shotguns",
	["[SMG]"] = "Automatics",
	["[AR]"] = "Automatics",
	["[Revolver]"] = "Pistols",
	["[AK47]"] = "Automatics",
	["[SilencerAR]"] = "Automatics",
	["[Silencer]"] = "Pistols"
}

local limb_descriptions = {
	["Head"] = "HeadColor",
	["UpperTorso"] = "TorsoColor",
	["LowerTorso"] = "TorsoColor",
	["LeftFoot"] = "LeftLegColor",
	["LeftLowerLeg"] = "LeftLegColor",
	["LeftUpperLeg"] = "LeftLegColor",
	["RightFoot"] = "RightLegColor",
	["RightLowerLeg"] = "RightLegColor",
	["RightUpperLeg"] = "RightLegColor",
	["LeftHand"] = "LeftArmColor",
	["LeftLowerArm"] = "LeftArmColor",
	["LeftUpperArm"] = "LeftArmColor",
	["RightHand"] = "RightArmColor",
	["RightLowerArm"] = "RightArmColor",
	["RightUpperArm"] = "RightArmColor",
}

local part_list = {"Head", "UpperTorso", "LowerTorso", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm"}

local function getGunType(name)
	return gun_type[name] or "Default"
end

local getAimbotCandidate = LPH_NO_VIRTUALIZE(function(mouse_position)
	local closest = 9e9
	local candidate = nil
	local position = nil
	local camera_pos = camera.CFrame.p
	local max_target_distance = flags["max_target_distance"]
	local checks = flags["target_checks"]
	local fov = aimbot["silent_aim_fov"] > aimbot["aim_assist_fov"] and aimbot["silent_aim_fov"] or aimbot["aim_assist_fov"]
	for player, info in player_data do
		local character = info["character"]

		if not character or info["whitelisted"] then
			continue end

		local upperTorso = info.character_parts["UpperTorso"]

		if not upperTorso then
			continue end

		local pos, on_screen = wtvp(camera, upperTorso.Position)

		if not on_screen then
			continue end

		local pos = vector2new(pos.X, pos.Y)
		local distance = (mouse_position - pos).magnitude

		if distance > fov then
			continue end

		local obj_distance = (camera_pos-upperTorso.Position).magnitude

		if obj_distance > max_target_distance then
			continue end

		local stop = false
	
		for _, check in checks do
			if check == "Knocked" and info["knocked"] then
				stop = true 
				break 
			elseif check == "Grabbed" and info["grabbed"] then
				stop = true
				break
			elseif check == "Forcefield" and info["forcefield"] then
				stop = true
				break
			elseif check == "Behind wall" then
				local raycast_params = RaycastParams.new()
				raycast_params.IgnoreWater = true;
				raycast_params.FilterDescendantsInstances = {character, char, ignored_folder}
				raycast_params.FilterType = Enum.RaycastFilterType.Exclude
				
				if raycast(workspace, camera_pos, (upperTorso.Position-camera_pos).unit * obj_distance, raycast_params) then
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

local impact_clone = newObject("Part", {
	CanCollide = false;
	Material = Enum.Material.Neon;
	Anchored = true
})
newObject("SelectionBox", {
	LineThickness = 0.01;
	Transparency = 0;
	SurfaceTransparency = 1;
	Adornee = impact_clone;
	Visible = true;
	Name = "Outline";
	Parent = impact_clone
})

local getClosestHitbox = LPH_NO_VIRTUALIZE(function(mouse_pos, character_parts)
	local closest = math.huge
	local closest_part = character_parts["HumanoidRootPart"]

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

utility.doCustomTween = LPH_NO_VIRTUALIZE(function(data, property, value)
	local old_tween = data.tweens[property]

	if old_tween then
		old_tween:Disconnect()
	end

	local old_value = data[property]

	if property ~= "ammo" and abs(old_value-value) < 2 or data["not_on_screen"] then
		data[property] = value
		return
	end

	local elapsed_time = 0
	local style = Enum.EasingStyle.Quad
	local direction = Enum.EasingDirection.Out
	local connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
        data[property] = old_value + ((value-old_value)*getValue(tws, (elapsed_time / 0.15), style, direction))
	end, true)
	data.tweens[property] = connection
	task.delay(0.15, function()
		if connection then
            data[property] = value
			connection:Disconnect()
		end
	end)
end)

local createESPObjects = LPH_NO_VIRTUALIZE(function(player)
	local highlight = newObject("Highlight", {
		Adornee = nil;
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
		Enabled = false;
		FillColor = flags["highlight_color"];
		FillTransparency = flags["highlight_transparency"];
		OutlineColor = flags["outline_color"];
		OutlineTransparency = flags["outline_transparency"];
		Parent = gethui and gethui() or cg
	})

	return {
		utility.newDrawing("Square", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["box_transparency"]+1,
		}),
		utility.newDrawing("Square", {
			Thickness = 1,
			ZIndex = 2,
			Filled = false,
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
			Font = fonts[tonumber(flags["esp_font"][1])]
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
			Font = fonts[tonumber(flags["esp_font"][1])],
			Color = flags["weapon_color"],
			Transparency = -flags["weapon_transparency"]+1
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Color = colorfromrgb(0,0,0),
			Transparency = -flags["ammo_transparency"]+1
		}),
		utility.newDrawing("Image", {
			ZIndex = 2,
			Color = flags["ammo_color"],
			Transparency = -flags["ammo_transparency"]+1,
			Data = flags["gradient_bars"] and ammo_image or pixel_image
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 3,
			Size = 14,
			Color = flags["number_color"],
			Font = fonts[tonumber(flags["esp_font"][1])],
			Transparency = -flags["number_transparency"]+1
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Color = colorfromrgb(0,0,0),
			Transparency = -flags["armor_transparency"]+1
		}),
		utility.newDrawing("Image", {
			ZIndex = 4,
			Data = flags["gradient_bars"] and health_image or pixel_image,
			Color = flags["armor_color"],
			Transparency = -flags["armor_transparency"]+1
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 3,
			Size = 14,
			Color = flags["ammo_number_color"],
			Font = fonts[tonumber(flags["esp_font"][1])],
			Transparency = -flags["ammo_number_transparency"]+1
		}),
		utility.newDrawing("Image", {
			ZIndex = 3,
			Color = flags["weapon_icon_color"],
			Transparency = -flags["weapon_icon_transparency"]+1,
			Data = ""
		}),
		utility.newDrawing("Square", {
			Thickness = 1,
			ZIndex = 1,
			Filled = true,
			Color = flags["box_fill_color"],
			Transparency = -flags["box_fill_transparency"]+1,
		})
	}, highlight
end)

local playerCharacterAdded = LPH_NO_VIRTUALIZE(function(character)
	local humanoid = character:WaitForChild("Humanoid", 60)

	if not humanoid then
		return end

	local player = plrs:FindFirstChild(character.Name)

	if not player then
		return end

	local data = player_data[player]

	data["character_parts"] = {}
	data["character"] = character
	data["tool"] = nil
	data["gun"] = false
	data["knocked"] = false
	data["grabbed"] = false

	local hrp = character:WaitForChild("UpperTorso", 60)

	if not hrp then
		return 
	end

	if lplr_data["viewing"] == player or (aimbot.target == player and flags["view_target"]) then
		camera.CameraSubject = character
	end

	for _, object in character:GetChildren() do
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			data["tool"] = utility.removeBrackets(object.Name)
			if object:FindFirstChild("Ammo") then
				data["gun"] = getGunType(object.Name)
				data["ammo"] = object.Ammo.Value
				data["max_ammo"] = object.MaxAmmo.Value

				if data["drawings"] then
					local text = data["drawings"][12]
					if text then
						text["Text"] = object.Ammo.Value.."/"..object.MaxAmmo.Value
					end
					local image = data["drawings"][13]
					if image then
						image["Data"] = tool_images[data["tool"]]
					end
				end

				

				ammo_connection = utility.newConnection(object.Ammo:GetPropertyChangedSignal("Value"), function()
					utility.doCustomTween(data, "ammo", object.Ammo.Value)
					if data["drawings"] then
						local text = data["drawings"][12]
						if text then
							text["Text"] = object.Ammo.Value.."/"..object.MaxAmmo.Value
						end
					end
				end, true)
			end
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = true
		end
	end

	local ammo_connection = nil
	local old_health = humanoid.Health
	utility.doCustomTween(data, "health", humanoid.Health)	

	if aimbot.target == player then
		if flags["bounding_box"] then
			bounding_box_object.Adornee = character
		end
	end
	
	utility.newConnection(humanoid:GetPropertyChangedSignal("Health"), function()
		utility.doCustomTween(data, "health", humanoid.Health)
		if flags["target_information"] and aimbot.target == player then
			target_info:set_health(health, max_health)
		end
		old_health = humanoid.Health
	end, true)

	utility.newConnection(character.ChildAdded, function(object)
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			data["tool"] = utility.removeBrackets(object.Name)
			if object:FindFirstChild("Ammo") then
				data["gun"] = true
				data["ammo"] = object.Ammo.Value
				data["max_ammo"] = object.MaxAmmo.Value

				if flags["target_information"] and aimbot.target == player then
					target_info:set_gun(data["tool"])
				end

				if data["drawings"] then
					local text = data["drawings"][12]
					if text then
						text["Text"] = object.Ammo.Value.."/"..object.MaxAmmo.Value
					end
					local image = data["drawings"][13]
					if image then
						image["Data"] = tool_images[data["tool"]]
					end
				end

				ammo_connection = utility.newConnection(object.Ammo:GetPropertyChangedSignal("Value"), function()
					utility.doCustomTween(data, "ammo", object.Ammo.Value)
					if data["drawings"] then
						local text = data["drawings"][12]
						if text then
							text["Text"] = object.Ammo.Value.."/"..object.MaxAmmo.Value
						end
					end
				end, true)
			end
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = true
			data["knocked"] = false
			data["grabbed"] = false
		end
	end, true)

	utility.newConnection(character.ChildRemoved, function(object)
		data["character_parts"][object.Name] = nil
		if object.ClassName == "Tool" then
			if flags["target_information"] and aimbot.target == player then
				target_info:set_gun(nil)
			end
			data["tool"] = nil
			data["gun"] = false
			data["ammo"] = 0
			data["max_ammo"] = 0
			if ammo_connection then
				ammo_connection:Disconnect() 
			end
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = false
		end
	end, true)

	local highlight = data["highlight"]
	if highlight then
		highlight.Adornee = character
	end
	
	if folder_name then
		local folder = character:WaitForChild(folder_name, 60)

		local knocked, grabbed, armor = found_values["knocked"],found_values["grabbed"],found_values["armor"]

		if knocked then
			knocked = folder:WaitForChild(knocked, 60)

			if knocked and data then
				data["knocked"] = knocked.Value
				utility.newConnection(knocked:GetPropertyChangedSignal("Value"), function()
					data["knocked"] = knocked.Value
					if aimbot.target == player and find(flags["untarget"], "Target knocked") then
						aimbot.target = nil
						aimbotTargetChange:Fire(nil)
					end	
				end)
			end
		end

		if grabbed and data then
			grabbed = folder:WaitForChild(grabbed, 60)

			if grabbed and data then
				data["grabbed"] = grabbed.Value
				utility.newConnection(grabbed:GetPropertyChangedSignal("Value"), function()
					data["grabbed"] = grabbed.Value
				end)
			end
		end

		if armor then
			armor = folder:WaitForChild(armor, 60)

			if armor and data then
				data["armor"] = armor.Value
				utility.newConnection(armor:GetPropertyChangedSignal("Value"), function()
					data["armor"] = armor.Value
					if flags["target_information"] and aimbot.target == player then
						target_info:set_armor(armor.Value)
					end
				end)
				utility.doCustomTween(data, "armor", armor.Value)
			end
		end
	end
end)

local playerAdded = LPH_NO_VIRTUALIZE(function(player)
	player_data[player] = {
		character = nil,
		highlight = nil,
		health = 0,
		ammo = 0,
		max_ammo = 0,
		tool = nil,
		gun = false,
		knocked = false,
		armor = 0,
		grabbed = false,
		not_on_screen = true,
		character_parts = {},
		drawings = {},
		connections = {},
		forcefield = false,
		whitelisted = lplr_data["whitelisted"][player.Name] and true or false,
		aimbot_priority = lplr_data["priority"][player.Name] and true or false,
		dont_render = false,
		tweens = {}
	}

	utility.newConnection(player.CharacterAdded, playerCharacterAdded)

	if player.Character then
		_spawn(playerCharacterAdded, player.Character)
	end

	if flags["esp"] then
		local drawings, highlight = createESPObjects(player)
		player_data[player]["drawings"] = drawings
		player_data[player]["highlight"] = highlight
	end

	local info = player_data[player]

	local show_all = find(flags["render"], "Players")
	local show_priority = find(flags["render"], "Priority")
	local show_target = find(flags["render"], "Target")
	local show_whitelisted = find(flags["render"], "Whitelisted")
	local highlight = info["highlight"]
	local done = false

	if show_all then
		info["dont_render"] = false
		done = true
		if highlight and flags["highlight"] then
			highlight["Enabled"] = true
		end
	end

	if show_priority and info["aimbot_priority"] then
		info["dont_render"] = false
		done = true
		if highlight and flags["highlight"] then
			highlight["Enabled"] = true
		end
	end

	if show_target and aimbot.target == player then
		info["dont_render"] = false
		done = true
		if highlight and flags["highlight"] then
			highlight["Enabled"] = true
		end
	end

	if show_whitelisted and info["whitelisted"] then
		info["dont_render"] = false
		done = true
		if highlight and flags["highlight"] then
			highlight["Enabled"] = true
		end
	end

	if not done then
		info["dont_render"] = true
		if highlight and flags["highlight"] then
			highlight["Enabled"] = false
		end
	end

	menu_references["players_box"]:addOption(player.Name)
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

	if aimbot.target == player then
		aimbot.target = nil
		aimbotTargetChange:Fire(nil)
	end	

	menu_references["players_box"]:removeOption(player.Name)

	player_data[player] = nil
end)

utility.newConnection(plrs.PlayerAdded, playerAdded, true)
utility.newConnection(plrs.PlayerRemoving, playerRemoving, true)

----------------------
-- * Client Setup * --
----------------------

local getClosestPosition = LPH_NO_VIRTUALIZE(function(target)
	local closest = nil
	local distance = 9e9

	local max_distance = flags["backtrack_max_distance"]
	local screen_pos = wtvp(camera, target)
	screen_pos = vector2new(screen_pos.X, screen_pos.Y)

	for _, pos in lplr_data["mouse_positions"] do
		local on_screen_pos = wtvp(camera, pos)
		local dist = (vector2new(on_screen_pos.X, on_screen_pos.Y)-screen_pos).magnitude
		if dist < distance and dist <= max_distance then
			distance = dist
			closest = pos
		end
	end

	return closest or (flags["backtrack_fallback"][1] == "Mouse" and mouse.Hit.p or target)
end)

local lplrCharacterAdded = LPH_JIT_MAX(function(character)
	char = character
	lplr_parts = {}

	local humanoid = character:WaitForChild("Humanoid")

	for _, object in character:GetChildren() do
		lplr_parts[object.Name] = object
	end

	local activate_connection = nil
	local ammo_connection = nil
	lplr_data["gun"] = nil

	utility.newConnection(character.ChildAdded, function(object)
		lplr_parts[object.Name] = object
		if object.ClassName == "Tool" then
			lplr_data["tool"] = object
			local handle = object:FindFirstChild("Handle")
			if handle then
				local flag = flags["forcefield_tools"]
				local material = flag and Enum.Material.ForceField or Enum.Material.Plastic
				local default = object:FindFirstChild("Default")
				local color = flag and flags["forcefield_tools_color"] or colorfromrgb(163, 162, 165)
				handle.Material = material
				handle.Color = flag and color or colorfromrgb(163, 162, 165)
				if default then
					default.Material = material
					default.Color = color
				end 
			end

			local old = object.Grip

			activate_connection = utility.newConnection(object.Activated, LPH_JIT_MAX(function()
				local aim_location = aimbot.target_position
				if aim_location and flags["anti_aim_viewer"] then
					aim_location = (game.GameId == 3634139746 and aim_location or aim_location)

					event:FireServer(game_arg, flags["aim_backtrack"] and (getClosestPosition(aim_location) or aim_location) + vector3new(25,100,25), second_arg)
				end
				if aim_location and flags["bullet_tp"] then
					local old = object.Grip
					object.Grip = cframenew(aim_location):ToObjectSpace(lplr_parts["HumanoidRootPart"].CFrame)
					object.Parent = lplr.Backpack
					object.Parent = char
					_wait(lplr_data["ping"]/1000)
					object.Grip = old
					object.Parent = lplr.Backpack
					object.Parent = char
					_wait(lplr_data["ping"]/1000)
				end
			end), true)
			
			local ammo = object:FindFirstChild("Ammo")
			if ammo then
				local old_ammo_value = ammo.Value

				local gunType = getGunType(object.Name)
				lplr_data["gun"] = gunType
				if gunType ~= "Default" and not flags[gunType.."_override_general"] then
					gunType = "Default"
				end
				aimbot["silent_aim_fov"] = flags[gunType.."_silent_field_of_view"]*3.33
				aimbot.circle.Radius = aimbot["silent_aim_fov"]
				aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
				aimbot["aim_assist_fov"] = flags[gunType.."_aim_assist_field_of_view"]*3.33
				aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
				aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]

				ammo_connection = utility.newConnection(object.Ammo:GetPropertyChangedSignal("Value"), LPH_JIT_MAX(function()
					if ammo.Value < old_ammo_value then
						lplr_data["recently_shot"] = true
						task.delay(0.015, function()
							lplr_data["recently_shot"] = false
						end)
					end
					old_ammo_value = ammo.Value
				end), true)
			end
		elseif object:IsA("BasePart") and object.Name ~= "HumanoidRootPart" then
			if object.Name == "Head" and flags["headless"] then
				local face = object:FindFirstChildOfClass("Decal")
				if face then
					face.Transparency = 1
				end
				object.Transparency = 1
			end
		end
	end, true)

	utility.newConnection(character.ChildRemoved, function(object)
		lplr_parts[object.Name] = nil
		if object.ClassName == "Tool" then
			if activate_connection then
				activate_connection:Disconnect()
			end
			if ammo_connection then
				ammo_connection:Disconnect()
			end
			lplr_data["gun"] = nil
			lplr_data["tool"] = nil
			aimbot["silent_aim_fov"] = flags["Default_silent_field_of_view"]*3.33
			aimbot.circle.Radius = aimbot["silent_aim_fov"]
			aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
			aimbot["aim_assist_fov"] = flags["Default_aim_assist_field_of_view"]*3.33
			aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
			aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
		end
	end, true)

	utility.newConnection(humanoid:GetPropertyChangedSignal("MoveDirection"), function(direction)
		if flags["quick_stop"] and humanoid.MoveDirection == vector3new() then
			lplr_parts["HumanoidRootPart"].Velocity*=vector3new(0,1,0)
		end
	end, true)

	if flags["spinbot"] then
		humanoid.AutoRotate = false
	end

	if flags["no_sit"] then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	end

	_wait(1)

	if flags["korblox"] then
		local right_upper_leg = lplr_parts["RightUpperLeg"]
		local right_lower_leg = lplr_parts["RightLowerLeg"]
		local right_foot = lplr_parts["RightFoot"]

		if right_upper_leg and right_lower_leg and right_foot then
			right_upper_leg.TextureID = "rbxassetid://902843398"
			right_upper_leg.MeshId = "rbxassetid://9598310133"
			right_lower_leg.Transparency = 1
			right_foot.Transparency = 1
		end
	end

	if flags["accessory_adder"] then
		for id, object in lplr_data["accessories"] do
			local accessory = object:Clone()
			accessory.Name = id
			humanoid:AddAccessory(accessory)
			local attachment = accessory.Handle:FindFirstChildOfClass("Attachment")
			local weld = newObject("Weld", {
				Name = "AccessoryWeld",
				Part0 = accessory.Handle,
				Part1 = lplr_parts["Head"],
				C0 = attachment.CFrame,
				C1 = CFrame.new(0,0.6,0),
				Parent = accessory.Handle
			})
		end
	end

	if flags["forcefield_body"] then
		local color = flags["forcefield_body_color"]
		local transparency = flags["forcefield_body_transparency"]

		for name, part in lplr_parts do
			if name ~= "HumanoidRootPart" and part:IsA("BasePart") then
				part.Material = Enum.Material.ForceField
				part.Color = color
				part.Transparency = transparency
				if name == "Head" and flags["headless"] then part.Transparency = 1 end
			end 
		end
	end

	if flags["forcefield_hats"] then
		local color = flags["forcefield_hats_color"]
		local transparency = flags["forcefield_hats_transparency"]

		for name, part in lplr_parts do
			if part.ClassName == "Accessory" then
				local part = part:FindFirstChildOfClass("Part") or part:FindFirstChildOfClass("MeshPart")
				if part then
					part.Material = Enum.Material.ForceField
					part.Color = color
					part.Transparency = transparency
				end
			end 
		end
	end

	if flags["headless"] then
		local head = lplr_parts["Head"]
		local face = head:WaitForChild("face", 1)
		if face then
			face.Transparency = 1
		end
		head.Transparency = 1
	end

	if folder_name then
		local folder = character:WaitForChild(folder_name, 60)

		local knocked = found_values["knocked"]

		if knocked then
			knocked = folder:WaitForChild(knocked, 60)

			if knocked then
				utility.newConnection(knocked:GetPropertyChangedSignal("Value"), function()
					if aimbot.target == player and find(flags["untarget"], "Self knocked") then
						aimbot.target = nil
						aimbotTargetChange:Fire(nil)
					end	
				end)
			end
		end
	end
end)

utility.newConnection(lplr.CharacterAdded, lplrCharacterAdded, true)

if lplr.Character then
	_spawn(lplrCharacterAdded, lplr.Character)
end

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
local script_environment = {}

local config_list = nil
do
local rage = window:getTab(1)
	local target_section = rage:newSection({name = "Target", is_changeable = true, scale = 1})
		menu_references["look_at"] = target_section:newElement({name = "Look at target", types = {toggle = {flag = "look_at"}}})
		menu_references["view_target"] = target_section:newElement({name = "View target", types = {toggle = {flag = "view_target"}}})
		menu_references["target_strafe"] = target_section:newElement({name = "Target strafe", types = {toggle = {flag = "target_strafe"}, keybind = {method = 3, flag = "target_strafe_keybind"}}}); keybinder:add(menu_references["target_strafe"], "Target strafe", "target_strafe_keybind", "target_strafe")
		menu_references["horizontal_strafe"] = target_section:newElement({name = "Horizontal distance", types = {slider = {flag = "horizontal_strafe", suffix = "", prefix = "", min = 1, max = 12}}})
		menu_references["vertical_strafe"] = target_section:newElement({name = "Vertical distance", types = {slider = {flag = "vertical_strafe", suffix = "", prefix = "", min = 1, max = 12}}})
		menu_references["strafe_speed"] = target_section:newElement({name = "Strafe speed", types = {slider = {flag = "strafe_speed", min = 1, max = 100, suffix = "%", prefix = ""}}})
local anti_aim = window:getTab(2)
local anti_lock_section = anti_aim:newSection({name = "Desync", is_changeable = true, scale = 1})
		menu_references["anti_lock"] = anti_lock_section:newElement({name = "Velocity desync", types = {toggle = {flag = "anti_lock"}, keybind = {flag = "anti_lock_keybind", method = 3}}}); keybinder:add(menu_references["anti_lock"], "Velocity desync", "anti_lock_keybind", "anti_lock")
		menu_references["anti_lock_style"] = anti_lock_section:newElement({name = "Style", types = {dropdown = {flag = "anti_lock_style", options = {"Multiplier", "Underground", "Random", "Zero", "Sky"}}}})
		menu_references["anti_lock_multiplier"] = anti_lock_section:newElement({name = "Multiplier amount", types = {slider = {flag = "anti_lock_multiplier", min = 0.1, max = 5, suffix = "x", decimal = 1, prefix = ""}}})
		menu_references["cframe_desync"] = anti_lock_section:newElement({name = "CFrame desync", types = {toggle = {flag = "cframe_desync"}, keybind = {flag = "cframe_desync_keybind", method = 3}}}); keybinder:add(menu_references["cframe_desync"], "CFrame desync", "cframe_desync_keybind", "cframe_desync")
		menu_references["horizontal_offset"] = anti_lock_section:newElement({name = "Horizontal offset", types = {slider = {flag = "horizontal_offset", suffix = "", prefix = "", min = 1, max = 50}}})
		menu_references["vertical_offset"] = anti_lock_section:newElement({name = "Vertical offset", types = {slider = {flag = "vertical_offset", suffix = "", prefix = "", min = 1, max = 50}}})
		menu_references["cframe_randomization"] = anti_lock_section:newElement({name = "Randomization", types = {slider = {flag = "cframe_randomization", suffix = "", prefix = "", min = 1, max = 50}}})
		menu_references["cframe_body"] = anti_lock_section:newElement({name = "Position body", types = {toggle = {flag = "cframe_body"}, colorpicker = {flag = "cframe_body_color", transparency_flag = "cframe_body_transparency"}, dropdown = {flag = "cframe_body_material", no_none = true, default = {"ForceField"}, options = {"ForceField", "Neon"}}}})
		menu_references["character_lag"] = anti_lock_section:newElement({name = "Character lag", types = {toggle = {flag = "character_lag"}}})
		menu_references["character_lag_amount"] = anti_lock_section:newElement({name = "Lag amount", types = {slider = {flag = "character_lag_amount", min = 1, max = 14, suffix = "t", prefix = ""}}})
		menu_references["network_desync"] = anti_lock_section:newElement({name = "Network desync", types = {toggle = {flag = "network_desync"}, dropdown = {flag = "network_desync_type", options = {"Invisible", "Moving"}, no_none = true, default = {"Invisible"}}, keybind = {flag = "network_desync_keybind", method = 3}}}); keybinder:add(menu_references["network_desync"], "Network desync", "network_desync_keybind", "network_desync")
		menu_references["spinbot"] = anti_lock_section:newElement({name = "Spinbot", types = {toggle = {flag = "spinbot"}}})
		menu_references["spinbot_speed"] = anti_lock_section:newElement({name = "Spin speed", types = {slider = {flag = "spinbot_speed", min = 1, max = 100, suffix = "%", prefix = ""}}})
local legit = window:getTab(3)
	local aimbot_section = legit:newSection({name = "Aimbot settings", is_changeable = false, scale = 0.7})
		menu_references["aimbot_toggle"] = aimbot_section:newElement({name = "Enabled", types = {toggle = {flag = "aimbot"}, keybind = {flag = "aimbot_keybind", method = 1}}}); keybinder:add(menu_references["aimbot_toggle"], "Aimbot", "aimbot_keybind", "aimbot")
		menu_references["auto_select_target"] = aimbot_section:newElement({name = "Auto select target", types = {toggle = {flag = "auto_select_target"}}})
		menu_references["lock_bind"] = aimbot_section:newElement({name = "Lock bind", types = {keybind = {flag = "lock_bind", method = 3, method_locked = true}}})
		menu_references["anti_aim_viewer"] = aimbot_section:newElement({name = "Anti aim viewer", types = {toggle = {flag = "anti_aim_viewer"}}})
		menu_references["aim_backtrack"] = aimbot_section:newElement({name = "Aim backtrack", types = {toggle = {flag = "aim_backtrack"}}})
		menu_references["backtrack_max_distance"] = aimbot_section:newElement({name = "Max distance", types = {slider = {flag = "backtrack_max_distance", min = 0, decimal = 0, default = 100, max = 500, suffix = "px", prefix = ""}}})
		menu_references["backtrack_lifetime"] = aimbot_section:newElement({name = "Lifetime", types = {slider = {flag = "backtrack_lifetime", min = 0.1, max = 1, suffix = "s", prefix = "", decimal = 2, default = 0.1}}})
		menu_references["backtrack_fallback"] = aimbot_section:newElement({name = "Fallback", types = {dropdown = {flag = "backtrack_fallback", options = {"Mouse", "Target"}, no_none = true, default = {"Mouse"}}}})
		menu_references["clamp_y"]  = aimbot_section:newElement({name = "Y threshold", types = {toggle = {flag = "clamp_y"}, slider = {flag = "clamp_y_value", min = -40, max = 0, default = -20, suffix = "", prefix = ""}}})
		menu_references["clamp_multiplier"]  = aimbot_section:newElement({name = "Multiplier", types = {slider = {flag = "clamp_multiplier", min = 0, max = 1, decimal = 2, default = 0.15, suffix = "", prefix = ""}}})
		menu_references["multipoint"]  = aimbot_section:newElement({name = "Multipoint", types = {toggle = {flag = "multipoint"}, slider = {flag = "multipoint_value", min = 1, max = 100, suffix = "%", prefix = ""}}})
		menu_references["resolver"] = aimbot_section:newElement({name = "Resolver", types = {toggle = {flag = "resolver"}}})
		menu_references["not_on_vehicles"] = aimbot_section:newElement({name = "Not on vehicles", types = {toggle = {flag = "not_on_vehicles"}}})
		menu_references["resolver_refresh"] = aimbot_section:newElement({name = "Refresh rate", types = {slider = {flag = "resolver_refresh", min = 1, default = 18, max = 200, prefix = "", suffix = "ms", changers = 1}}})
		menu_references["silent_aim"] = aimbot_section:newElement({name = "Silent aim", types = {toggle = {flag = "silent_aim"}}})
		menu_references["bullet_tp"] = aimbot_section:newElement({name = "Bullet tp", types = {toggle = {flag = "bullet_tp"}}})
		menu_references["max_curve"] = aimbot_section:newElement({name = "Max curve", types = {toggle = {flag = "max_curve"}, slider = {flag = "max_curve_value", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}})
		menu_references["dont_curve_y"] = aimbot_section:newElement({name = "Don't curve vertically", types = {toggle = {flag = "dont_curve_y"}}})
		menu_references["hit_chance"] = aimbot_section:newElement({name = "Hit chance", types = {slider = {flag = "hit_chance", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}})
		menu_references["silent_aim_disable_when"] = aimbot_section:newElement({name = "Disable when", types = {dropdown = {flag = "silent_aim_disable_when", multi = true, options = {"Out of fov", "Behind wall", "Off screen"}}}})
		menu_references["aim_assist"] = aimbot_section:newElement({name = "Aim assist", types = {toggle = {flag = "aim_assist"}, dropdown = {flag = "aim_assist_style", options = {"Mouse", "Camera"}, default = {"Camera"}, no_none = true}, keybind = {flag = "aim_assist_keybind"}}}); keybinder:add(menu_references["aim_assist"], "Aim assist", "aim_assist_keybind", "aim_assist")
		menu_references["aim_assist_disable_when"] = aimbot_section:newElement({name = "Disable when", types = {dropdown = {flag = "aim_assist_disable_when", multi = true, options = {"Not holding gun", "In third person", "Out of fov", "Off screen", "Behind wall", "Typing"}}}})
		menu_references["frame_skip"] = aimbot_section:newElement({name = "Frame skip", types = {keybind = {flag = "mouse_tp", method = 3, method_locked = true}}})
		menu_references["camera_360"] = aimbot_section:newElement({name = "Camera 360", types = {toggle = {flag = "camera_360"}, keybind = {flag = "camera_360_bind", method = 3, method_locked = true}}})
		menu_references["360_speed"] = aimbot_section:newElement({name = "Speed", types = {slider = {min = 1, max = 100, suffix = "%", prefix = "", flag = "360_speed"}}})
		aimbot_section:newElement({name = "Max target distance", types = {slider = {flag = "max_target_distance", min = 50, default = 150, max = 2500, suffix = "", prefix = "", changers = 1}}})
		aimbot_section:newElement({name = "Target checks", types = {dropdown = {flag = "target_checks", multi = true, options = {"Behind wall", "Forcefield", "Grabbed", "Knocked"}}}})
		aimbot_section:newElement({name = "Untarget when", types = {dropdown = {flag = "untarget", options = {"Target knocked", "Self knocked", "Typing"}, multi = true}}})
	local gun_settings = legit:newSection({name = "Gun settings", is_changeable = false, x = 0.5, scale = 1})
		menu_references["selected_gun"] = gun_settings:newElement({name = "Selected gun", types = {dropdown = {flag = "selected_gun", no_none = true, default = {"Default"}, options = {"Default", "Pistols", "Shotguns", "Automatics"}}}})
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
					gun_settings:newElement({name = "Silent aim horizontal prediction", types = {slider = {flag = gun.."_silent_aim_horizontal_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Silent aim vertical prediction", types = {slider = {flag = gun.."_silent_aim_vertical_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Silent aim air hitbox", types = {dropdown = {flag = gun.."_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Silent aim hitbox", types = {dropdown = {flag = gun.."_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Aim assist field of view", types = {slider = {flag = gun.."_aim_assist_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal prediction", types = {slider = {flag = gun.."_aim_assist_horizontal_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Aim assist vertical prediction", types = {slider = {flag = gun.."_aim_assist_vertical_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Aim assist horizontal smoothness", types = {slider = {flag = gun.."_aim_assist_horizontal_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical smoothness", types = {slider = {flag = gun.."_aim_assist_vertical_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal shake", types = {slider = {flag = gun.."_aim_assist_horizontal_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical shake", types = {slider = {flag = gun.."_aim_assist_vertical_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist smoothing direction", types = {dropdown = {flag = gun.."_smoothing_direction", no_none = true, default = {"Out"}, options = {"InOut", "Out", "In"}}}}),
					gun_settings:newElement({name = "Aim assist smoothing style", types = {dropdown = {flag = gun.."_smoothing_style", no_none = true, default = {"Linear"}, options = {"Linear", "Circular", "Sine", "Quad", "Quint", "Bounce", "Exponential", "Back", "Cubic", "Elastic"}}}}),
					gun_settings:newElement({name = "Aim assist air hitbox", types = {dropdown = {flag = gun.."_cam_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Aim assist hitbox", types = {dropdown = {flag = gun.."_cam_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Jump offset", types = {toggle = {flag = gun.."_jump_offset"}, slider = {flag = gun.."_jump_offset_value", min = 0, max = 1.25, default = 0, suffix = "", prefix = "", changers = 0.01, decimal = 2}}})
				}
				utility.newConnection(_["settings"][2].onSliderChange, function(value)
					if lplr_data["gun"] == gun and flags[gun.."_override_general"] then
						aimbot["silent_aim_fov"] = value*3.33
						aimbot.circle.Radius = aimbot["silent_aim_fov"]
						aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
					end
				end)
				utility.newConnection(_["settings"][7].onSliderChange, function(value)
					if lplr_data["gun"] == gun and flags[gun.."_override_general"] then
						aimbot["aim_assist_fov"] = value*3.33
						aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
						aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
					end
				end)
				utility.newConnection(_["settings"][1].onToggleChange, function(bool)
					local tool = lplr_data["gun"]
					if tool and tool == gun then
						aimbot["silent_aim_fov"] = bool and flags[gun.."silent_field_of_view"]*3.33 or flags["Default_silent_field_of_view"]*3.33
						aimbot["aim_assist_fov"] = bool and flags[gun.."aim_assist_field_of_view"]*3.33 or flags["Default_aim_assist_field_of_view"]*3.33
						aimbot.circle.Radius = aimbot["silent_aim_fov"]
						aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
						aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
						aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
					end
				end)
			else
				_["settings"] = {
					gun_settings:newElement({name = "Silent aim field of view", types = {slider = {flag = gun.."_silent_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Silent aim horizontal prediction", types = {slider = {flag = gun.."_silent_aim_horizontal_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Silent aim vertical prediction", types = {slider = {flag = gun.."_silent_aim_vertical_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Silent aim air hitbox", types = {dropdown = {flag = gun.."_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Silent aim hitbox", types = {dropdown = {flag = gun.."_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Aim assist field of view", types = {slider = {flag = gun.."_aim_assist_field_of_view", min = 5, max = 350, default = 20, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal prediction", types = {slider = {flag = gun.."_aim_assist_horizontal_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Aim assist vertical prediction", types = {slider = {flag = gun.."_aim_assist_vertical_prediction", min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Aim assist horizontal smoothness", types = {slider = {flag = gun.."_aim_assist_horizontal_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical smoothness", types = {slider = {flag = gun.."_aim_assist_vertical_smoothness", min = 1, max = 100, default = 90, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist horizontal shake", types = {slider = {flag = gun.."_aim_assist_horizontal_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist vertical shake", types = {slider = {flag = gun.."_aim_assist_vertical_shake", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}),
					gun_settings:newElement({name = "Aim assist smoothing direction", types = {dropdown = {flag = gun.."_smoothing_direction", no_none = true, default = {"Out"}, options = {"InOut", "Out", "In"}}}}),
					gun_settings:newElement({name = "Aim assist smoothing style", types = {dropdown = {flag = gun.."_smoothing_style", no_none = true, default = {"Linear"}, options = {"Linear", "Circular", "Sine", "Quad", "Quint", "Bounce", "Exponential", "Back", "Cubic", "Elastic"}}}}),
					gun_settings:newElement({name = "Aim assist air hitbox", types = {dropdown = {flag = gun.."_cam_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Aim assist hitbox", types = {dropdown = {flag = gun.."_cam_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Jump offset", types = {toggle = {flag = gun.."_jump_offset"}, slider = {flag = gun.."_jump_offset_value", min = 0, max = 1.25, default = 0, suffix = "", prefix = "", changers = 0.01, decimal = 2}}})
				}
				utility.newConnection(_["settings"][1].onSliderChange, function(value)
					local gun = lplr_data["gun"]
					if gun == "Default" or not gun then
						aimbot["silent_aim_fov"] = value*3.33
						aimbot.circle.Radius = aimbot["silent_aim_fov"]
						aimbot.circle_outline.Radius = aimbot["silent_aim_fov"]
					end
				end)
				utility.newConnection(_["settings"][6].onSliderChange, function(value)
					local gun = lplr_data["gun"]
					if gun == "Default" or not gun then
						aimbot["aim_assist_fov"] = value*3.33
						aimbot.assist_circle.Radius = aimbot["aim_assist_fov"]
						aimbot.assist_circle_outline.Radius = aimbot["aim_assist_fov"]
					end
				end)
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
		menu_references["position_line"] = aimbot_visualization:newElement({name = "Position line", types = {toggle = {flag = "position_line"}, colorpicker = {flag = "line_color", transparency_flag = "line_transparency"}}})
		menu_references["line_origin"] = aimbot_visualization:newElement({name = "Origin", types = {dropdown = {flag = "line_origin", options = {"Character", "Mouse"}, default = {"Character"}, no_none = true}}})
		menu_references["line_position"] = aimbot_visualization:newElement({name = "Position", types = {dropdown = {flag = "line_position", options = {"Predicted position", "Character position"}, default = {"Character position"}, no_none = true}}})
		menu_references["position_body"] = aimbot_visualization:newElement({name = "Position body", types = {toggle = {flag = "position_body"}, colorpicker = {flag = "position_body_color", transparency_flag = "position_body_transparency"}, dropdown = {flag = "position_body_material", no_none = true, options = {"ForceField", "Neon"}, default = {"ForceField"}}}})
		menu_references["bounding_box"] = aimbot_visualization:newElement({name = "Bounding box", types = {toggle = {flag = "bounding_box"}, colorpicker = {flag = "bounding_box_color", transparency_flag = "bounding_box_transparency"}}})
		menu_references["bounding_box_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {flag = "bounding_box_filled"}}})
local visuals = window:getTab(4)
	local player_esp_section = visuals:newSection({name = "Player ESP", is_changeable = true, scale = 0.6})
		menu_references["esp_toggle"] = player_esp_section:newElement({name = "Enabled", types = {toggle = {flag = "esp"}}})
		menu_references["render_dropdown"] = player_esp_section:newElement({name = "Render", types = {dropdown = {flag = "render", options = {"Whitelisted", "Players", "Priority", "Target"}, multi = true, default = {"Players", "Target"}}}})
		menu_references["box_toggle"] = player_esp_section:newElement({name = "Box", types = {toggle = {flag = "box"}, colorpicker = {flag = "box_color", transparency_flag = "box_transparency"}}})
		menu_references["fill_toggle"] = player_esp_section:newElement({name = "Fill", types = {toggle = {flag = "box_fill"}, colorpicker = {flag = "box_fill_color", transparency_flag = "box_fill_transparency", default_transparency = 0.5}}})
		menu_references["name_toggle"] = player_esp_section:newElement({name = "Name", types = {toggle = {flag = "name"}, colorpicker = {flag = "name_color", transparency_flag = "name_transparency"}}})
		menu_references["name_display"] = player_esp_section:newElement({name = "Use display name", types = {toggle = {flag = "name_display"}}})
		menu_references["name_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "name_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["weapon_toggle"] = player_esp_section:newElement({name = "Weapon",types = {toggle = {flag = "weapon"}, colorpicker = {flag = "weapon_color", transparency_flag = "weapon_transparency"}}})
		menu_references["weapon_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "weapon_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["ammo_toggle"] = player_esp_section:newElement({name = "Ammo bar", types = {toggle = {flag = "ammo"}, colorpicker = {flag = "ammo_color", default = colorfromrgb(52, 180, 235), transparency_flag = "ammo_transparency"}}})
		menu_references["armor_bar"] = player_esp_section:newElement({name = "Armor bar", types = {toggle = {flag = "armor"}, colorpicker = {flag = "armor_color", default = colorfromrgb(120, 174, 250), transparency_flag = "armor_transparency"}}})
		menu_references["armor_overlay"] = player_esp_section:newElement({name = "Overlay health bar", types = {toggle = {flag = "armor_overlay"}}})
		menu_references["health_toggle"] = player_esp_section:newElement({name = "Health bar", types = {toggle = {flag = "health"}, colorpicker = {flag = "health_color", default = colorfromrgb(105, 255, 117), transparency_flag = "health_transparency"}}})
		menu_references["health_number"] = player_esp_section:newElement({name = "Number", types = {toggle = {flag = "health_number"}, colorpicker = {flag = "number_color", transparency_flag = "number_transparency"}}})
		menu_references["highlight_toggle"] = player_esp_section:newElement({name = "Highlight", types = {toggle = {flag = "highlight"}, colorpicker = {flag = "highlight_color", default_transparency = 0.6, default = colorfromrgb(93, 169, 240), transparency_flag = "highlight_transparency"}}})
		menu_references["highlight_outline"] = player_esp_section:newElement({name = "Outline", types = {colorpicker = {flag = "outline_color", default = colorfromrgb(255, 105, 247), transparency_flag = "outline_transparency"}}})
		menu_references["weapon_icon"] = player_esp_section:newElement({name = "Weapon icon", types = {toggle = {flag = "weapon_icon"}, colorpicker = {flag = "weapon_icon_color", transparency_flag = "weapon_icon_transparency"}}})
		menu_references["ammo_number"] = player_esp_section:newElement({name = "Ammo number", types = {toggle = {flag = "ammo_number"}, colorpicker = {flag = "ammo_number_color", default = colorfromrgb(76,76,76), transparency_flag = "ammo_number_transparency"}}})
		menu_references["ammo_number_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "ammo_number_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["gradient_bars"] = player_esp_section:newElement({name = "Gradient bars", types = {toggle = {default = true, flag = "gradient_bars"}}})
		menu_references["esp_font"] = player_esp_section:newElement({name = "Text font", types = {dropdown = {flag = "esp_font", no_none = true, default = {"2"}, options = {"1", "2", "3", "4"}}}})
	local self_esp_section = visuals:newSection({name = "Self ESP", is_changeable = true, y = 0.6, scale = 0.4})
		menu_references["forcefield_tools"] = self_esp_section:newElement({name = "Forcefield tools", types = {toggle = {flag = "forcefield_tools"}, colorpicker = {flag = "forcefield_tools_color", transparency_flag = "forcefield_tools_transparency"}}})
		menu_references["forcefield_body"] = self_esp_section:newElement({name = "Forcefield body", types = {toggle = {flag = "forcefield_body"}, colorpicker = {flag = "forcefield_body_color", transparency_flag = "forcefield_body_transparency"}}})
		menu_references["forcefield_hats"] = self_esp_section:newElement({name = "Forcefield hats", types = {toggle = {flag = "forcefield_hats"}, colorpicker = {flag = "forcefield_hats_color", transparency_flag = "forcefield_hats_transparency"}}})
		menu_references["accessory_adder"] = self_esp_section:newElement({name = "Accessory adder", types = {toggle = {flag = "accessory_adder"}}})
		menu_references["accessories"] = self_esp_section:newElement({name = "Accessories", types = {multibox = {max = 3}}})
		menu_references["remove_accessory"] = self_esp_section:newElement({name = "Remove hat", types = {button = {text = "Remove accessory", callback = function()
			local id = menu_references["accessories"].selected_option

			if not id or not tonumber(id) then
				return end

			if lplr_data["accessories"][id] then
				lplr_data["accessories"][id]:Destroy()
				lplr_data["accessories"][id] = nil
			end

			if find(lplr_data["equipped_accessories"], id) then
				remove(lplr_data["equipped_accessories"], id)
			end

			menu_references["accessories"]:removeOption(id)

			if char then
				local accessory = lplr_parts[tostring(id)]
				if accessory then
					accessory:Destroy()
				end
			end

			flags["equipped_accessories"] = lplr_data["equipped_accessories"]
		end}}})
		menu_references["accessory_id"] = self_esp_section:newElement({name = "Hat id", types = {textbox = {flag = "accessory_id", no_load = true}}})
		menu_references["add_accessory"] = self_esp_section:newElement({name = "Add hat", types = {button = {text = "Add Hat", callback = function()
			local id = flags["accessory_id"]

			if not id or not tonumber(id) then
				return end

			if lplr_data["accessories"][id] then
				return end

			lplr_data["accessories"][id] = is:LoadLocalAsset("rbxassetid://"..id)
			menu_references["accessories"]:addOption(id)
			insert(lplr_data["equipped_accessories"], id)

			if char then
				local accessory = lplr_data["accessories"][id]:Clone()
				accessory.Name = id
				lplr_parts["Humanoid"]:AddAccessory(accessory)
				local attachment = accessory.Handle:FindFirstChildOfClass("Attachment")
				local weld = newObject("Weld", {
					Name = "AccessoryWeld",
					Part0 = accessory.Handle,
					Part1 = lplr_parts["Head"],
					C0 = attachment.CFrame,
					C1 = CFrame.new(0,0.6,0),
					Parent = accessory.Handle
				})
			end

			flags["equipped_accessories"] = lplr_data["equipped_accessories"]
		end}}})
		menu_references["headless"] = self_esp_section:newElement({name = "Headless", types = {toggle = {flag = "headless"}}})
		menu_references["korblox"] = self_esp_section:newElement({name = "Korblox", types = {toggle = {flag = "korblox"}}})
		menu_references["trail"] = self_esp_section:newElement({name = "Trail", types = {toggle = {flag = "trail"}, colorpicker = {flag = "trail_color", transparency_flag = "trail_transparency"}}})
		menu_references["trail_lifetime"] = self_esp_section:newElement({name = "Lifetime", types = {slider = {flag = "trail_lifetime", min = 0.1, max = 1.5, prefix = "", suffix = "s", decimal = 1, default = 0.5}}})
		menu_references["trail_lifetime"]:setVisible(false)
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
	local hud_section = visuals:newSection({name = "Hud", is_changeable = true, x = 0.5, y = 0.3, scale = 0.7})
		menu_references["drawing_crosshair"] = hud_section:newElement({name = "Drawing crosshair", types = {toggle = {flag = "drawing_crosshair"}, colorpicker = {flag = "drawing_crosshair_color", transparency_flag = "drawing_crosshair_transparency"}}})
		menu_references["drawing_crosshair_spin"] = hud_section:newElement({name = "Spin", types = {toggle = {flag = "drawing_crosshair_spin"}, slider = {flag = "drawing_crosshair_speed", suffix = "%", prefix = "", min = 1, max = 100}}})
		menu_references["drawing_crosshair_location"] = hud_section:newElement({name = "Location", types = {dropdown = {flag = "drawing_crosshair_location", options = {"Mouse", "Center", "Target"}, no_none = true, default = {"Mouse"}}}})
		menu_references["drawing_crosshair_length"] = hud_section:newElement({name = "Length", types = {slider = {flag = "drawing_crosshair_length", suffix = "px", prefix = "", min = 5, max = 100}}})
		menu_references["drawing_crosshair_gap"] = hud_section:newElement({name = "Gap", types = {slider = {flag = "drawing_crosshair_gap", suffix = "px", prefix = "", min = 5, max = 100}}})
		menu_references["target_information"] = hud_section:newElement({name = "Target information", types = {toggle = {flag = "target_information"}, colorpicker = {flag = "target_information_color", transparency_flag = "target_information_transparency"}}})
		menu_references["target_style"] = hud_section:newElement({name = "Style", types = {dropdown = {options = {"Default", "Gradient", "Color"}, no_none = true, default = {"Default"}, flag = "target_style"}}})
		menu_references["target_font"] = hud_section:newElement({name = "Font", types = {dropdown = {options = {"1", "2", "3", "4"}, no_none = true, flag = "target_font", default = {"2"}}}})
		menu_references["target_font"]:setVisible(false)
		menu_references["target_style"]:setVisible(false)
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
local misc = window:getTab(5)
	local movement_section = misc:newSection({name = "Movement", is_changeable = false, scale = 0.5})
		movement_section:newElement({name = "No jump cooldown", types = {toggle = {flag = "no_jump_cooldown"}}})
		menu_references["cframe_speed"] = movement_section:newElement({name = "CFrame speed", types = {toggle = {flag = "cframe_speed"}, keybind = {flag = "cframe_speed_keybind", method = 2}}}); keybinder:add(menu_references["cframe_speed"], "CFrame speed", "cframe_speed_keybind", "cframe_speed")
		menu_references["cframe_speed_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_speed_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		movement_section:newElement({name = "No slowdown", types = {toggle = {flag = "no_slowdown"}}})
		menu_references["cframe_fly"] = movement_section:newElement({name = "CFrame fly", types = {toggle = {flag = "cframe_fly"}, keybind = {flag = "cframe_fly_keybind", method = 2}}}); keybinder:add(menu_references["cframe_fly"], "CFrame fly", "cframe_fly_keybind", "cframe_fly")
		menu_references["cframe_fly_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_fly_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		movement_section:newElement({name = "Quick stop", types = {toggle = {flag = "quick_stop"}}})
		menu_references["noclip"] = movement_section:newElement({name = "Noclip", types = {toggle = {flag = "noclip"}, keybind = {flag = "noclip_keybind"}}}); keybinder:add(menu_references["noclip"], "Noclip", "noclip_keybind", "noclip")
	local game_section = misc:newSection({name = "Game modifiers", is_changeable = true, y = 0.5, scale = 0.5})
		local flashbang_connection = nil
		local blur_connection = nil
		utility.newConnection(game_section:newElement({name = "Infinite zoom out", types = {toggle = {flag = "infinite_zoom_out"}}}).onToggleChange, function(bool)
			lplr.CameraMaxZoomDistance = bool and 9e9 or spoof_properties["CameraMaxZoomDistance"]
		end, true)
		utility.newConnection(game_section:newElement({name = "No void kill", types = {toggle = {flag = "no_void_kill"}}}).onToggleChange, function(bool)
			workspace.FallenPartsDestroyHeight = bool and -9e9 or -500
		end, true)
		utility.newConnection(game_section:newElement({name = "Show chat", types = {toggle = {flag = "show_chat"}}}).onToggleChange, function(bool)
			lplr_gui.Chat.Frame.ChatChannelParentFrame.Visible = bool
		end, true)
		utility.newConnection(game_section:newElement({name = "No sit", types = {toggle = {flag = "no_sit"}}}).onToggleChange, function(bool)
			local humanoid = lplr_parts["Humanoid"]

			if not humanoid then
				return end

			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not bool)
		end, true)	
	local utilities_section = misc:newSection({name = "Utilities", is_changeable = true, x = 0.5, scale = 0.5})
		menu_references["speed_macro"] = utilities_section:newElement({name = "Speed macro", types = {toggle = {flag = "speed_macro"}, keybind = {method = 2, flag = "speed_macro_keybind"}}}); keybinder:add(menu_references["speed_macro"], "Speed macro", "speed_macro_keybind", "speed_macro")
		menu_references["speed_macro_delay"] = utilities_section:newElement({name = "Zoom delay", types = {slider = {flag = "speed_macro_delay", min = 0, max = 30, suffix = "ms", decimal = 1, prefix = ""}}})
		menu_references["auto_shoot"] = utilities_section:newElement({name = "Auto shoot", types = {toggle = {flag = "auto_shoot"}, keybind = {flag = "auto_shoot_keybind"}}}); keybinder:add(menu_references["auto_shoot"], "Auto shoot", "auto_shoot_keybind", "auto_shoot")
		menu_references["auto_shoot_delay"] = utilities_section:newElement({name = "Delay", types = {slider = {flag = "auto_shoot_delay", min = 0, max = 500, prefix = "", suffix = "ms"}}})
		menu_references["auto_sort"] = utilities_section:newElement({name = "Auto sort", types = {toggle = {flag = "auto_sort"}, keybind = {flag = "auto_sort_keybind", method = 3, method_locked = true}}})
		for i = 1, 9 do
			menu_references["slot_"..i] = utilities_section:newElement({name = "Slot "..i, types = {textbox = {flag = "slot_"..i}}})
		end
	local server_section = misc:newSection({name = "Server", is_changeable = false, x = 0.5, y = 0.5, scale = 0.5})
		server_section:newElement({name = "Rejoin server", types = {button = {text = "Rejoin server",
			callback = function()
				tps:TeleportToPlaceInstance(game.PlaceId, game.JobId)
			end
		}}})
		server_section:newElement({name = "Copy job id", types = {button = {text = "Copy job id",
			callback = function()
				setclipboard(game.JobId)
			end
		}}})
		server_section:newElement({name = "Job id", types = {textbox = {flag = "job_id", no_load = true}}})
		server_section:newElement({name = "Join server", types = {button = {text = "Join server",
			callback = function()
				tps:TeleportToPlaceInstance(game.PlaceId, flags["job_id"])
			end
		}}})
local players_tab = window:getTab(7)
	local players_section = players_tab:newSection({name = "Players", is_changeable = true, x = 0, scale = 1})
		menu_references["players_box"] = players_section:newElement({name = "_", types = {multibox = {max = 12, search = true}}})
		menu_references["aimbot_priority"] = players_section:newElement({name = "Priority", types = {toggle = {no_load = true, flag = "aimbot_priority"}}})
		menu_references["whitelisted"] = players_section:newElement({name = "Whitelisted", types = {toggle = {no_load = true, flag = "whitelisted"}}})
		players_section:newElement({name = "View player", types = {button = {text = "View player", callback = function()
			if not menu_references["players_box"].selected_option then
				return end

			local player = plrs:FindFirstChild(menu_references["players_box"].selected_option)

			if not player then
				return end 

			local hrp = player_data[player].character_parts["HumanoidRootPart"]

			if not hrp then
				return end

			if lplr_data["viewing"] == player then
				camera.CameraSubject = char
				lplr_data["viewing"] = nil
				return
			end
			camera.CameraSubject = player.Character
			lplr_data["viewing"] = player
		end}}})
		players_section:newElement({name = "Teleport to", types = {button = {text = "Teleport to", callback = function()
			if not menu_references["players_box"].selected_option then
				return end

			local player = plrs:FindFirstChild(menu_references["players_box"].selected_option)

			if not player then
				return end 

			local hrp = player_data[player].character_parts["HumanoidRootPart"]

			if not hrp then
				return end

			local lplr_hrp = lplr_parts["HumanoidRootPart"]

			if not lplr_hrp then 
				return end

			lplr_hrp.CFrame = hrp.CFrame
		end}}})
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
				for lua, _ in script_environment do
					task.cancel(script_environment[lua])
					script_environment[lua] = nil
					script_unloaded:Fire(lua)
					flags["loaded_scripts"] = {}
				end
				local config = utility.loadConfig(config_list.selected_option)
				if flags["equipped_accessories"] then
					for id, object in lplr_data["accessories"] do
						object:Destroy()
						lplr_data["accessories"][id] = nil
					end

					lplr_data["equipped_accessories"] = {}
					
					for _, id in flags["equipped_accessories"] do
						if not id or not tonumber(id) then
							continue end

						lplr_data["accessories"][id] = is:LoadLocalAsset("rbxassetid://"..id)
						menu_references["accessories"]:addOption(id)
						insert(lplr_data["equipped_accessories"], id)
					end

					menu_references["accessory_adder"].onToggleChange:Fire(flags["accessory_adder"])
				end
				pcall(function()
					if flags["keybind_position"] then
						keybinder:move(vector2new(flags["keybind_position"][2], flags["keybind_position"][3]))
					end
					if flags["target_info_position"] then
						target_info:move(vector2new(flags["target_info_position"][2], flags["target_info_position"][3]))
					end
				end)
				if config["loaded_scripts"] then
					for _, script in config["loaded_scripts"] do
						local data = nil
						pcall(function()
							data = readfile(config_location.."/scripts/"..script..".lua")
						end)
	
						if not data then
							continue
						end
	
						task.wait()
	
						local s, err = pcall(function()
							script_environment[script] = task.spawn(loadstring(data))
						end)
					end
				end
				menu.on_load:Fire()
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
					if find(flags["loaded_scripts"], lua) then
						remove(flags["loaded_scripts"], lua)
					end
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
		local script_unloaded = signal.new()
		getgenv().juju = {
			aimbot_target_changed = aimbotTargetChange,
			script_unloaded = script_unloaded,
			menu_references = menu_references,
			flags = flags,
			section = lua_section,
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
							if find(flags["loaded_scripts"], name) then
								remove(flags["loaded_scripts"], name)
							end
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
					if find(flags["loaded_scripts"], lua) then
						remove(flags["loaded_scripts"], lua)
					end
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
	end
local move_connection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		if flags["keybinds_list"] and utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
			_spawn(function()
				while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					_wait()
					keybinder:move(uis:GetMouseLocation())
				end
			end)
		elseif flags["target_information"] and utility.isInDrawing(target_info.drawings[1], uis:GetMouseLocation()) then
			_spawn(function()
				while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					_wait()
					target_info:move(uis:GetMouseLocation())
				end
			end)
		end
	end
end), true)

utility.newConnection(menu.on_opening, function()
	if move_connection then
		move_connection:Disconnect()
	end
	if not aimbot.target and flags["target_information"] then
		target_info:open()
	end
	move_connection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
		if ((input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) or input.UserInputType == Enum.UserInputType.Touch) then
			if flags["keybinds_list"] and utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
				_spawn(function()
					while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						_wait()
						keybinder:move(uis:GetMouseLocation())
					end
				end)
			elseif flags["target_information"] and utility.isInDrawing(target_info.drawings[1], uis:GetMouseLocation()) then
				_spawn(function()
					while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						_wait()
						target_info:move(uis:GetMouseLocation())
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
	if not aimbot.target and flags["target_information"] then
		target_info:close()
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

utility.newConnection(menu_references["anti_aim_viewer"].onToggleChange, LPH_JIT_MAX(function(bool)
	menu_references["aim_backtrack"]:setVisible(bool)
	menu_references["backtrack_lifetime"]:setVisible(bool and flags["aim_backtrack"] or false)
	menu_references["backtrack_max_distance"]:setVisible(bool and flags["aim_backtrack"] or false)
	menu_references["backtrack_fallback"]:setVisible(bool and flags["aim_backtrack"] or false)
end), true)
utility.newConnection(menu_references["aim_backtrack"].onToggleChange, LPH_JIT_MAX(function(bool)
	menu_references["backtrack_lifetime"]:setVisible(bool)
	menu_references["backtrack_max_distance"]:setVisible(bool)
	menu_references["backtrack_fallback"]:setVisible(bool)
end), true)
menu_references["aim_backtrack"]:setVisible(false)
menu_references["backtrack_lifetime"]:setVisible(false)
menu_references["backtrack_max_distance"]:setVisible(false)
menu_references["backtrack_fallback"]:setVisible(false)

utility.newConnection(menu_references["camera_360"].onToggleChange, function(bool)
	menu_references["360_speed"]:setVisible(bool)
end, true)
menu_references["360_speed"]:setVisible(false)

utility.newConnection(menu_references["camera_360"].onActiveChange, function()
	if not aimbot.doing_360 and flags["camera_360"] then
		aimbot.doing_360 = true
		local angle = 0
		local connection = nil; connection = utility.newConnection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
			local add_angle = flags["360_speed"]*dt*100
			camera.CFrame*=angles(0,math.rad(add_angle),0)
			angle+=add_angle
			if angle >= 360 then
				connection:Disconnect()
				aimbot.doing_360 = false
			end
		end), true)
	end
end, true)


utility.newConnection(menu_references["render_dropdown"].onDropdownChange, LPH_NO_VIRTUALIZE(function()
	local show_all = find(flags["render"], "Players")
	local show_priority = find(flags["render"], "Priority")
	local show_target = find(flags["render"], "Target")
	local show_whitelisted = find(flags["render"], "Whitelisted")

	for player, info in player_data do
		local highlight = info["highlight"]

		if show_all then
			info["dont_render"] = false
			if highlight then
				highlight["Enabled"] = true
			end
			continue 
		end

		if show_priority and info["aimbot_priority"] then
			info["dont_render"] = false
			if highlight then
				highlight["Enabled"] = true
			end
			continue
		end

		if show_target and aimbot.target == player then
			info["dont_render"] = false
			if highlight then
				highlight["Enabled"] = true
			end
			continue
		end

		if show_whitelisted and info["whitelisted"] then
			info["dont_render"] = false
			if highlight then
				highlight["Enabled"] = true
			end
			continue
		end

		if highlight then
			highlight["Enabled"] = false
		end
		info["dont_render"] = true
	end
end), true)

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

utility.newConnection(menu_references["max_curve"].onToggleChange, function(bool)
	menu_references["dont_curve_y"]:setVisible(bool)
	menu_references["max_curve"]:changeSliderVisiblity(bool)
end)
menu_references["dont_curve_y"]:setVisible(false)
menu_references["max_curve"]:changeSliderVisiblity(false)

utility.newConnection(menu_references["target_information"].onToggleChange, function(bool)
	if bool then
		target_info:open()
	else
		target_info:close()
	end
	menu_references["target_font"]:setVisible(bool)
	menu_references["target_style"]:setVisible(bool)
end, true)

utility.newConnection(menu_references["target_information"].onToggleChange, function(bool)
	if bool then
		target_info:open()
	else
		target_info:close()
	end
	menu_references["target_font"]:setVisible(bool)
	menu_references["target_style"]:setVisible(bool)
end, true)

utility.newConnection(menu_references["target_style"].onDropdownChange, function(selected)
	if selected[1] == "Default" then
		target_info.drawings[7].Data = line_image
		target_info.drawings[7].Color = colorfromrgb(255,255,255)
	elseif selected[1] == "Color" then
		target_info.drawings[7].Data = pixel_image
		target_info.drawings[7].Color = flags["target_information_color"]
	elseif selected[1] == "Gradient" then
		target_info.drawings[7].Data = gradient_image
		target_info.drawings[7].Color = flags["target_information_color"]
	end
end, true)

utility.newConnection(menu_references["target_font"].onDropdownChange, function(selected)
	local font = fonts[tonumber(selected[1])]
	for i = 8, 16 do
		target_info.drawings[i].Font = font
	end
end, true)

utility.newConnection(menu_references["target_information"].onColorChange, function(color)
	if flags["target_style"][1] ~= "Default" then
		target_info.drawings[7].Color = color
	end
	for i = 8, 16 do
		if i % 2 == 0 then
			target_info.drawings[i].Color = color
		end
	end
end, true)

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

utility.newConnection(uis:GetPropertyChangedSignal("MouseBehavior"), function()
	lplr_data["third_person"] = uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter
end)

utility.newConnection(menu_references["silent_aim"].onToggleChange, function(bool)
	menu_references["silent_aim_disable_when"]:setVisible(bool)
	menu_references["hit_chance"]:setVisible(bool)
	menu_references["bullet_tp"]:setVisible(bool)
	menu_references["max_curve"]:setVisible(bool)
end)
menu_references["silent_aim_disable_when"]:setVisible(false)
menu_references["hit_chance"]:setVisible(false)
menu_references["max_curve"]:setVisible(false)
menu_references["bullet_tp"]:setVisible(false)

utility.newConnection(menu_references["aim_assist"].onToggleChange, function(bool)
	menu_references["aim_assist_disable_when"]:setVisible(bool)
end)
menu_references["aim_assist_disable_when"]:setVisible(false)


utility.newConnection(menu_references["multipoint"].onToggleChange, function(bool)
	menu_references["multipoint"]:changeSliderVisiblity(bool)
end)
menu_references["multipoint"]:changeSliderVisiblity(false)

utility.newConnection(menu_references["clamp_y"].onToggleChange, function(bool)
	menu_references["clamp_y"]:changeSliderVisiblity(bool)
	menu_references["clamp_multiplier"]:setVisible(bool)
end)
menu_references["clamp_y"]:changeSliderVisiblity(false)
menu_references["clamp_multiplier"]:setVisible(false)


utility.newConnection(menu_references["accessory_adder"].onToggleChange, function(bool)
	menu_references["accessories"]:setVisible(bool)
	menu_references["add_accessory"]:setVisible(bool)
	menu_references["remove_accessory"]:setVisible(bool)
	menu_references["accessory_id"]:setVisible(bool)

	local humanoid = lplr_parts["Humanoid"]

	if not humanoid then
		return end

	for id, object in lplr_data["accessories"] do
		local part = lplr_parts[id]

		if part then
			part:Destroy()
		end
	end

	if bool then	
		for id, object in lplr_data["accessories"] do
			local accessory = object:Clone()
			accessory.Name = id
			humanoid:AddAccessory(accessory)
			local attachment = accessory.Handle:FindFirstChildOfClass("Attachment")
			local weld = newObject("Weld", {
				Name = "AccessoryWeld",
				Part0 = accessory.Handle,
				Part1 = lplr_parts["Head"],
				C0 = attachment.CFrame,
				C1 = CFrame.new(0,0.6,0),
				Parent = accessory.Handle
			})
		end
	end
end)
menu_references["accessories"]:setVisible(false)
menu_references["add_accessory"]:setVisible(false)
menu_references["remove_accessory"]:setVisible(false)
menu_references["accessory_id"]:setVisible(false)

utility.newConnection(menu_references["auto_select_target"].onToggleChange, function(bool)
	menu_references["lock_bind"]:setVisible(not bool)
end)
menu_references["lock_bind"]:setVisible(not bool)

utility.newConnection(menu_references["highlight_outline"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.OutlineColor = color
			highlight.OutlineTransparency = transparency
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

utility.newConnection(menu_references["highlight_toggle"].onToggleChange, function(bool)
	menu_references["highlight_outline"]:setVisible(bool)
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.Enabled = not info["dont_render"] and bool or false
			local character = info["character"]
			if character then
				highlight.Adornee = bool and character or nil
			end
		end
	end
end, true)
menu_references["highlight_outline"]:setVisible(bool)

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
	local font = fonts[tonumber(selected[1])]
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local name = drawings[3]
			local weapon = drawings[6]
			local health = drawings[9]
			local ammo = drawings[12]

			if name then
				name["Font"] = font
			end

			if weapon then
				weapon["Font"] = font
			end

			if health then
				health["Font"] = font
			end

			if ammo then
				ammo["Font"] = font
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

utility.newConnection(menu_references["armor_bar"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local outline = drawings[10]
			local fill = drawings[11]

			if outline and fill then
				fill["Color"] = color
				fill["Transparency"] = -transparency+1
				outline["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["ammo_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local outline = drawings[7]
			local fill = drawings[8]

			if outline and fill then
				fill["Color"] = color
				fill["Transparency"] = -transparency+1
				outline["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["ammo_number_size"].onSliderChange, function(value)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local ammo_number = drawings[12]

			if ammo_number then
				ammo_number["Size"] = value
			end
		end
	end
end, true)

utility.newConnection(menu_references["ammo_number"].onToggleChange, function(bool)
	if not bool then
		for player, info in player_data do
			local drawings = info["drawings"]

			if drawings then
				local text = drawings[12]

				if text then
					text["Visible"] = false
				end
			end
		end
	end
end, true)
menu_references["ammo_number_size"]:setVisible(false)

utility.newConnection(menu_references["ammo_number"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local ammo_number = drawings[12]

			if ammo_number then
				ammo_number["Color"] = color
				ammo_number["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["health_number"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local health_number = drawings[9]

			if health_number then
				health_number["Color"] = color
				health_number["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["health_toggle"].onToggleChange, function(bool)
	menu_references["health_number"]:setVisible(bool)
	if found_values["armor"] then
		menu_references["armor_overlay"]:setVisible(bool)
	end
end, true)
menu_references["health_number"]:setVisible(false)
menu_references["armor_overlay"]:setVisible(false)
menu_references["armor_bar"]:setVisible(found_values["armor"] and true or false)

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

utility.newConnection(menu_references["fill_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local fill = drawings[14]

			if fill then
				fill["Color"] = color
				fill["Transparency"] = -transparency+1
			end
		end
	end
end, true)

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

local last_target = nil

utility.newConnection(aimbotTargetChange, LPH_NO_VIRTUALIZE(function(target)
	aimbot.line.Visible = target ~= nil and flags["position_line"] or false
	aimbot.line_outline.Visible = aimbot.line.Visible
	local old_last_target = last_target
	if old_last_target then
		local info = player_data[old_last_target]

		if info then
			local show_all = find(flags["render"], "Players")
			local show_priority = find(flags["render"], "Priority")
			local show_target = find(flags["render"], "Target")
			local show_whitelisted = find(flags["render"], "Whitelisted")
			local highlight = info["highlight"]
			local done = false
		
			if show_all then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if show_priority and info["aimbot_priority"] then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if show_whitelisted and info["whitelisted"] then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if not done then
				info["dont_render"] = true
				if highlight then
					highlight["Enabled"] = false
				end
			end
		end
	end
	if target then
		local info = player_data[target]

		if info then
			local show_all = find(flags["render"], "Players")
			local show_priority = find(flags["render"], "Priority")
			local show_target = find(flags["render"], "Target")
			local show_whitelisted = find(flags["render"], "Whitelisted")
			local highlight = info["highlight"]
			local done = false
		
			if show_all then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if show_priority and info["aimbot_priority"] then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if show_target then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if show_whitelisted and info["whitelisted"] then
				info["dont_render"] = false
				done = true
				if highlight and flags["highlight"] then
					highlight["Enabled"] = true
				end
			end
	
			if not done then
				info["dont_render"] = true
				if highlight then
					highlight["Enabled"] = false
				end
			end
		end
	end
	last_target = target
	bounding_box_object.Adornee = target and target.Character or nil
	if not flags["bounding_box"] then
		bounding_box_object.Adornee = nil
	end
	if flags["notifications"] and find(flags["notifications_selected"], "Target changes") and target ~= old_last_target then
		_spawn(newNotification, target and "locked onto player "..target.Name or "unlocked", flags["notification_style"][1])
	end
	if lplr_data["position_body"] then
		lplr_data["position_body"]:Destroy()
	end
	if flags["view_target"] then
		camera.CameraSubject = target and target.Character or char
		lplr_data["viewing"] = nil
	end
	if flags["target_information"] then
		if not target then
			target_info:close()
		else
			local hum = target.Character.Humanoid
			target_info:set_target(target.Name)
			target_info:set_health(hum.Health, hum.MaxHealth)
			target_info:set_armor(player_data[target]["armor"])
			target_info:set_gun(player_data[target]["gun"] and player_data[target]["tool"] or nil)
			target_info:open()
		end
	end
	gradient_glow.Parent = (flags["gradient_overlay"] and target) and ignored_folder or cg
	if flags["gradient_overlay"] then
		if target then
			tween(gradient_glow, newtweeninfo(0.15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 6, 1)})
		else
			tween(gradient_glow, newtweeninfo(0.08, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 0, 1)})
		end
	end
	if flags["position_body"] and target then
		local character = target.Character
		character.Archivable = true; local model = character:Clone(); character.Archivable = false

		local all_parts = model:GetChildren()
		local material = Enum.Material[flags["position_body_material"][1]]
		local color = flags["position_body_color"]
		local transparency = flags["position_body_transparency"]
		model.Archivable = true

		for i = 1, #all_parts do
			local part = all_parts[i]
			local class_name = part.ClassName
			local name = part.Name
			if class_name == "MeshPart" then
				part.Color = color
				part.Material = material
				part.Transparency = transparency
				part.CanCollide = false
				part.Anchored = true
				if name == "Head" then
					local decal = part:FindFirstChild("face")
					if decal then decal:Destroy() end
				end
			else
				part:Destroy()
			end	
		end

		model.Parent = cg

		lplr_data["position_body"] = model
	end
end), true)

utility.newConnection(menu_references["aimbot_toggle"].onActiveChange, function(bool)
	aimbot.target = nil
	aimbotTargetChange:Fire(nil)
	aimbot.circle.Color = bool and flags["active_color"] or flags["fov_color"]
end, true)

utility.newConnection(menu_references["position_line"].onToggleChange, function(bool)
	menu_references["line_position"]:setVisible(bool)
	menu_references["line_origin"]:setVisible(bool)
end)
menu_references["line_position"]:setVisible(false)
menu_references["line_origin"]:setVisible(false)

utility.newConnection(menu_references["frame_skip"].onActiveChange, function(bool)
	if aimbot.target and aimbot.target_position then
		aimbot.do_tp = true
	end
end, true)


utility.newConnection(menu_references["position_line"].onColorChange, function(color, transparency)
	aimbot.line.Color = color
	aimbot.line.Transparency = -transparency+1
	aimbot.line_outline.Transparency = -transparency+1
end, true)

utility.newConnection(menu_references["forcefield_hats"].onColorChange, function(color, transparency)
	if not flags["forcefield_hats"] then
		return end

	for name, part in lplr_parts do
		if part.ClassName == "Accessory" then
			local part = part:FindFirstChildOfClass("Part") or part:FindFirstChildOfClass("MeshPart")
			if part then
				part.Material = Enum.Material.ForceField
				part.Transparency = transparency
				part.Color = color 
			end
		end 
	end
end, true)

utility.newConnection(menu_references["forcefield_hats"].onToggleChange, function(bool)
	local material = bool and Enum.Material.ForceField or Enum.Material.Plastic
	local color = bool and flags["forcefield_hats_color"] or colorfromrgb(163, 162, 165)
	for name, part in lplr_parts do
		if part.ClassName == "Accessory" then
			local part = part:FindFirstChildOfClass("Part") or part:FindFirstChildOfClass("MeshPart")
			if part then
				part.Material = material
				part.Transparency = flags["forcefield_hats_transparency"]
				part.Color = color 
			end
		end 
	end
end, true)

utility.newConnection(menu_references["forcefield_body"].onColorChange, function(color, transparency)
	if not flags["forcefield_body"] then
		return end

	for name, part in lplr_parts do
		if name ~= "HumanoidRootPart" and part:IsA("BasePart") then
			part.Color = color
			part.Transparency = transparency
			if name == "Head" and flags["headless"] then part.Transparency = 1 end
			if flags["korblox"] then
				if name == "RightUpperLeg" or name == "RightLowerLeg" or name == "RightFoot" then
					part.Transparency = 1
				end
			end
		end 
	end
end, true)

utility.newConnection(menu_references["forcefield_body"].onToggleChange, function(bool)
	local humanoid = lplr_parts["Humanoid"]

	if not humanoid then
		return end

	local humanoid_description = humanoid.HumanoidDescription

	if not humanoid_description then
		return end

	local material = bool and Enum.Material.ForceField or Enum.Material.Plastic
	local color = flags["forcefield_body_color"]
	local transparency = flags["forcefield_body_transparency"]
	for name, part in lplr_parts do
		if name ~= "HumanoidRootPart" and part:IsA("BasePart") then
			local _color = limb_descriptions[name] and humanoid_description[limb_descriptions[name]] or colorfromrgb(163, 162, 165)
			part.Material = material
			part.Color = bool and color or _color
			part.Transparency = bool and transparency or 0
			if name == "Head" and flags["headless"] then part.Transparency = 1 end
			if flags["korblox"] then
				if name == "RightUpperLeg" or name == "RightLowerLeg" or name == "RightFoot" then
					part.Transparency = 1
				end
			end
		end 
	end
end, true)

utility.newConnection(menu_references["korblox"].onToggleChange, function(bool)
	local right_upper_leg = lplr_parts["RightUpperLeg"]
	local right_lower_leg = lplr_parts["RightLowerLeg"]
	local right_foot = lplr_parts["RightFoot"]

	if not right_upper_leg or not right_lower_leg or not right_foot then
		return end

	right_upper_leg.TextureID = bool and "rbxassetid://902843398" or ""
	right_upper_leg.MeshId = bool and "rbxassetid://9598310133" or "rbxassetid://532220018"
	right_lower_leg.Transparency = bool and 1 or 0
	right_foot.Transparency = bool and 1 or 0
end, true)

utility.newConnection(menu_references["headless"].onToggleChange, function(bool)
	local head = lplr_parts["Head"]

	if not head then
		return end

	local face = head:FindFirstChild("face")
	if face then
		face.Transparency = bool and 1 or 0
	end
	head.Transparency = bool and 1 or 0
end, true)

utility.newConnection(menu_references["forcefield_tools"].onColorChange, function(color, transparency)
	local material = flags["forcefield_tools"] and Enum.Material.ForceField or Enum.Material.Plastic
	local color = flags["forcefield_tools"] and color or colorfromrgb(163, 162, 165)
	for name, part in lplr_parts do
		if part.ClassName == "Tool" then
			local handle = part:FindFirstChild("Handle")
			if handle then
				local default = part:FindFirstChild("Default")
				handle.Material = material
				handle.Color = color
				if default then
					default.Material = material
					default.Color = color
				end 
			end
			break
		end 
	end
end, true)

utility.newConnection(menu_references["forcefield_tools"].onToggleChange, function(bool)
	local material = bool and Enum.Material.ForceField or Enum.Material.Plastic
	local color = bool and flags["forcefield_tools_color"] or colorfromrgb(163, 162, 165)
	for name, part in lplr_parts do
		if part.ClassName == "Tool" then
			local handle = part:FindFirstChild("Handle")
			if handle then
				local default = part:FindFirstChild("Default")
				handle.Material = material
				handle.Color = color
				if default then
					default.Material = material
					default.Color = color
				end 
			end
			break
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
	["JumpPower"] = "no_jump_cooldown",
	["WalkSpeed"] = "no_slowdown",
}

local old_new_index = nil

old_new_index = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, index, value)
	if not checkcaller() and self and index and value then
		if spoof_properties[index] then
			spoof_properties[index] = value
			if flags[skip_indexes[index]] then
				if index == "JumpPower" and value >= 50 then
					return old_new_index(self, index, value)
				elseif index == "WalkSpeed" and value >= 16 then
					return old_new_index(self, index, value)
				end
				return
			end
		end
	end
	return old_new_index(self, index, value)
end))

if game.GameId == 3634139746 then

end

local old_index = nil

old_index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, index)
	if not checkcaller() then
		if self == mouse and lower(index) == "hit" then
			if flags["anti_aim_viewer"] then
				if flags["aim_backtrack"] then
					local old = old_index(self, index)
					if old then
						local index = insert(lplr_data["mouse_positions"], old.p)
						task.delay(flags["backtrack_lifetime"], function()
							lplr_data["mouse_positions"][index] = nil
						end)
					end
					return old
				end
				return old_index(self, index)
			end
			if aimbot.target_position and flags["silent_aim"] then
				if flags["hit_chance"] < 100 and flags["hit_chance"] <= mathrandom(1, 100) then
					return old_index(self, index)
				end
				return cframenew(aimbot.target_position)
			end
		elseif self == lplr_parts["HumanoidRootPart"] then
			if lplr_data["hrp_cframe"] and index == "CFrame" then
				return lplr_data["hrp_cframe"]
			end
		elseif spoof_properties[index] and flags[skip_indexes[index]] then
			return spoof_properties[index]
		end
	end
	return old_index(self, index)
end))

-----------------------------
-- * Cheat Core Features * --
-----------------------------

local heartbeat_callbacks = {}
local anti_callbacks = {}

do
	local go_up = false
	local do_macro = true

	local doMacro = LPH_NO_VIRTUALIZE(function()
		if flags["speed_macro_keybind"]["active"] and do_macro then
			go_up = not go_up
			mousescroll(go_up and -camera.ViewportSize.Y/8 or camera.ViewportSize.Y/8)
			if flags["speed_macro_delay"] > 0 then
				do_macro = false
				task.delay(flags["speed_macro_delay"]/1000, function()
					do_macro = true
				end)
			end
		end
	end)

	utility.newConnection(menu_references["speed_macro"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doMacro) then
			remove(heartbeat_callbacks, doMacro)
		end
		menu_references["speed_macro_delay"]:setVisible(bool)
		if bool then
			do_macro = true
			go_up = false
			insert(heartbeat_callbacks, doMacro)
		end
	end, true)
	menu_references["speed_macro_delay"]:setVisible(false)
end

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
				local hrp = player_data[aimbot.target]["character_parts"]["HumanoidRootPart"]

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
	local part = newObject("Part", {
		CFrame = CFrame.new(-169.848083,0.5,-116.794434,1,0,0,0,1,0,0,0,1);
		CanCollide = false;
		Size = Vector3.new(1,1,1);
		TopSurface = Enum.SurfaceType.Smooth;
		Transparency = 1;
		Anchored = true;
		Parent = ignored_folder
	})
	local attachment1 = newObject("Attachment", {
		CFrame = CFrame.new(0,0,0.5,1,0,0,0,1,0,0,0,1),
		Parent = part
	})
	local attachment2 = newObject("Attachment", {
		CFrame = CFrame.new(0,0,-0.5,1,0,0,0,1,0,0,0,1),
		Parent = part
	})
	local trail = newObject("Trail", {
		Attachment0 = attachment1;
		Attachment1 = attachment2;
		Brightness = 20;
		FaceCamera = true;
		Lifetime = 0.5;
		LightEmission = 1;
		MinLength = 0;
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)};
		WidthScale = NumberSequence.new{NumberSequenceKeypoint.new(0,0.08,0),NumberSequenceKeypoint.new(1,0.08,0)};
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))};
		Parent = part
	})
	part.Parent = cg

	local doTrail = LPH_NO_VIRTUALIZE(function()
		local hrp = lplr_parts["HumanoidRootPart"]

		if not hrp then
			return end

		part.CFrame = hrp.CFrame
	end)

	utility.newConnection(menu_references["trail"].onToggleChange, function(bool)
		part.Parent = bool and ignored_folder or cg
		menu_references["trail_lifetime"]:setVisible(bool)
		if find(heartbeat_callbacks, doTrail) then
			remove(heartbeat_callbacks, doTrail)
		end
		if bool then
			insert(heartbeat_callbacks, doTrail)
		end
	end)

	utility.newConnection(menu_references["trail"].onColorChange, function(color, transparency)
		trail["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)}
		trail["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0,transparency,0),NumberSequenceKeypoint.new(1,transparency,0)}
	end)

	utility.newConnection(menu_references["trail_lifetime"].onSliderChange, function(value)
		trail["Lifetime"] = value
	end)
end

local doNetworkDesync = LPH_NO_VIRTUALIZE(function()
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp or not flags["network_desync_keybind"]["active"] then
		return end

	if flags["network_desync_type"][1] == "Invisible" then
		setfflag("S2PhysicsSenderRate", 2)
		sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
		setfflag("PhysicsSenderMaxBandwidthBps", math.pi/3)
		
		local old_linear_velocity = hrp.AssemblyLinearVelocity
		local old_velocity = hrp.Velocity

		hrp.AssemblyLinearVelocity = vector3new(mathrandom(-16000, 16000),mathrandom(-16000, 16000) ,mathrandom(-16000, 16000))
		hrp.Velocity = vector3new(mathrandom(-16000, 16000),mathrandom(-16000, 16000) ,mathrandom(-16000, 16000))

		rs.RenderStepped:Wait()

		hrp.Velocity = old_velocity
		hrp.AssemblyLinearVelocity = old_linear_velocity

		setfflag("S2PhysicsSenderRate", 1)
	
		do_sleep = not do_sleep
	else
		sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
		do_sleep = not do_sleep
	end
end)

utility.newConnection(menu_references["network_desync"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, doNetworkDesync) then
		remove(heartbeat_callbacks, doNetworkDesync)
	end
	if not bool then
		rs.RenderStepped:Wait()
		rs.RenderStepped:Wait()
		rs.RenderStepped:Wait()
		rs.RenderStepped:Wait()
		setfflag("S2PhysicsSenderRate", flags["character_lag"] and flags["character_lag_amount"] or 15)
		setfflag("PhysicsSenderMaxBandwidthBps", 38760)
	else
		insert(heartbeat_callbacks, doNetworkDesync)
	end
	menu_references["network_desync"]:setDropdownVisiblity(bool)
end, true)

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
				local hrp = player_data[target]["character_parts"]["HumanoidRootPart"]

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

local renderESP = nil

do	
	local do_box = flags["box"]
	local do_name = flags["name"]
	local do_health = flags["health"]
	local do_health_number = flags["health_number"]
	local do_armor = flags["armor"]
	local do_armor_overlay = flags["armor_overlay"]
	local do_ammo = flags["ammo"]
	local do_weapon = flags["weapon"]
	local do_ammo_number = flags["ammo_number"]
	local do_weapon_icon = flags["weapon_icon"]
	local do_fill = flags["box_fill"]

	local below = vector3new(0, -3.65, 0)
	local above = vector3new(0, 2.9, 0)

	renderESP = LPH_NO_VIRTUALIZE(function()
		for player, info in player_data do
			local drawings = info["drawings"]
			local character_parts = info.character_parts
			local hrp, humanoid = character_parts["UpperTorso"], character_parts["Humanoid"]

			if hrp and humanoid and not info["dont_render"] then
				local hrp_pos = hrp.Position

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

					if do_fill then
						local fill = drawings[14]

						fill["Size"] = box_size
						fill["Position"] = box_pos
						fill["Visible"] = true
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
					end

					if do_name then
						local name = drawings[3]

						name["Position"] = vector2new(box_size_x / 2 + box_pos_x, box_pos_y - name.TextBounds.Y - 2)
						name["Visible"] = true
					end

					local no_armor = false

					if do_health then
						local bar = drawings[5]
						local outline = drawings[4]
						local ratio = info["health"] / humanoid.MaxHealth

						bar.Position = vector2new(box_pos_x - 5, box_pos_y + box_size_y)
						bar.Size = vector2new(1, -ratio * box_size_y)
						outline.From = vector2new(bar.Position.X, box_pos_y + box_size_y + 1)
						outline.To = vector2new(bar.Position.X, bar.Position.Y - box_size_y - 1)
						outline.Visible = true
						bar.Visible = true

						if do_health_number then
							local text = drawings[9]

							text.Visible = ratio < 0.99 and true or false

							if text.Visible then
								text.Text = tostring(floor(humanoid.Health))
								text.Position = bar.Position - vector2new(text.TextBounds.X/2 + 2, 6 - bar.Size.Y)
							end
						end

						if do_armor and do_armor_overlay then
							no_armor = true
							local fill = drawings[11]
							fill.Position = bar.Position
							fill.Size = vector2new(1,  -info["armor"] / 130 * box_size_y)
							fill.Visible = true
						end
					end

					if not no_armor and do_armor then
						local health_flag = do_health
						if not health_flag or not do_armor_overlay then
							local bar = drawings[11]
							local outline = drawings[10]
							local ratio = info["armor"] / 130

							bar.Position = vector2new(box_pos_x - (health_flag and 11 or 3), box_pos_y + box_size_y)
							bar.Size = vector2new(1, -ratio * box_size_y)
							outline.From = vector2new(bar.Position.X, box_pos_y + box_size_y + 1)
							outline.To = vector2new(bar.Position.X, bar.Position.Y - box_size_y - 1)

							bar.Visible = true
							outline.Visible = true
						end
					end

					local gun = info["gun"]
					local y_offset = 1

					if do_ammo then
						local bar = drawings[8]
						local outline = drawings[7]
						local ammo = info["ammo"]
						local max_ammo = info["max_ammo"]

						outline.Visible = gun and true or false
						bar.Visible = false

						if gun then
							local ammo = info["ammo"]
							local max_ammo = info["max_ammo"]

							if ammo ~= 0 then
								bar.Position = vector2new(box_pos_x + 1, box_pos_y + box_size_y + 4)
								bar.Size = vector2new(ammo/max_ammo * box_size_x - 2, 1)
								bar.Visible = true
							end

							outline.From = vector2new(box_pos_x, box_pos_y + box_size_y + 4)
							outline.To = vector2new(outline.From.X + box_size_x, outline.From.Y)
							y_offset+=6
						end
					end

					if do_weapon then
						local text = info["tool"]
						local tool = drawings[6]

						tool.Visible = text and true or false

						if text then
							tool.Text = text
							tool.Position = vector2new(box_size_x / 2 + box_pos_x, box_pos_y + box_size_y + y_offset)
							y_offset+=tool.TextBounds.Y
						end
					end

					if do_weapon_icon then
						local image = drawings[13]

						image.Visible = gun and true or false

						if gun then
							image.Size = vector2new(20, 10)
							image.Position = box_pos + vector2new((box_size_x-image.Size.X)/2, box_size_y + y_offset)

							y_offset+=10
						end
					end

					if do_ammo_number then
						local text = drawings[12]

						text.Visible = gun and true or false

						if gun then
							text.Position = vector2new(box_size_x / 2 + box_pos_x, box_pos_y + box_size_y + y_offset)
						end
					end
				elseif not info["not_on_screen"] then
					info["not_on_screen"] = true
					for _, drawing in drawings do
						drawing.Visible = false
					end		
				end
			elseif not info["not_on_screen"] then
				info["not_on_screen"] = true
				for _, drawing in drawings do
					drawing.Visible = false
				end	
			end
		end
	end)

	utility.newConnection(menu_references["armor_overlay"].onToggleChange, function(bool)
		do_armor_overlay = bool
		for player, info in player_data do
			local drawings = info["drawings"]

			if drawings then
				local box = drawings[10]

				if box then
					box["Visible"] = not bool
				end
			end
		end
	end)

	utility.newConnection(menu_references["fill_toggle"].onToggleChange, function(bool)
		do_fill = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]
	
				if drawings then
					local box = drawings[14]
	
					if box then
						box["Visible"] = false
					end
				end
			end
		end
	end, true)

	utility.newConnection(menu_references["weapon_icon"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings and drawings[13] then
					drawings[13]["Color"] = color
					drawings[13]["Transparency"] = -transparency+1
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["weapon_icon"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_weapon_icon = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings and drawings[13] then
					drawings[13]["Visible"] = false
				end
			end
		end
	end), true)

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
					drawings[9]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["armor_bar"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_armor = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[11]["Visible"] = false
					drawings[10]["Visible"] = false
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
					drawings[9]["Visible"] = false
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

	utility.newConnection(menu_references["ammo_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_ammo = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[8]["Visible"] = false
					drawings[7]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["ammo_number"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_ammo_number = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[12]["Visible"] = false
				end
			end
		end
	end), true)
end

local auto_shoot_stopped = false

local doAimbot = LPH_NO_VIRTUALIZE(function(dt)
	local mouse_position = uis:GetMouseLocation()
		aimbot.circle.Position = mouse_position
		aimbot.circle_outline.Position = mouse_position
		aimbot.assist_circle.Position = mouse_position
		aimbot.assist_circle_outline.Position = mouse_position
	local target = not flags["auto_select_target"] and aimbot.target or nil
	local aimbot_position = nil
		local line = aimbot.line
		local line_outline = aimbot.line_outline
			line.Visible = false
			line_outline.Visible = false
	local body = lplr_data["position_body"]
	local max_target_distance = flags["max_target_distance"]

	if (target or flags["auto_select_target"]) and flags["aimbot_keybind"]["active"] then
		target = flags["auto_select_target"] and getAimbotCandidate(mouse_position) or target
		local gun = lplr_data["gun"]
		if not stop and target then
			local gun = gun == nil and "Default" or (not flags[gun.."_override_general"] and "Default") or gun
			local data = player_data[target]
			local character_parts = data.character_parts
			local part = character_parts["Humanoid"].FloorMaterial == Enum.Material.Air and flags[gun.."_air_hitbox"][1] or flags[gun.."_hitbox"][1]

			part = part == "Closest" and getClosestHitbox(mouse_position, character_parts) or character_parts[part]

			if not part then
				aimbot.target_position = nil
				line.Visible = false
				line_outline.Visible = false
				if body and body.Parent == ignored_folder then
					body.Parent = cg
				end
				return 
			end

			local hrp = character_parts["HumanoidRootPart"]
			local local_hrp = lplr_parts["HumanoidRootPart"]

			if not local_hrp then
				aimbot.target_position = nil
				line.Visible = false
				line_outline.Visible = false
				if body and body.Parent == ignored_folder then
					body.Parent = cg
				end
				return 
			end

			local hrp_pos = local_hrp.Position 
			
			local old_velocity = hrp.Velocity

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

			if flags["resolver"] then
				old_velocity = aimbot.target_velocity or hrp.Velocity
			end

			local velocity = old_velocity

			if flags["clamp_y"] and old_velocity.Y < flags["clamp_y_value"] then
				velocity*=vector3new(1,flags["clamp_multiplier"],1)
			end

			local ping = lplr_data["ping"]/500

			local part_position = part.Position
			if flags["multipoint"] then
				local cf = part.CFrame:PointToObjectSpace(mouse.Hit.p)
				local size = part.Size*(flags["multipoint_value"]/200)

				part_position = part.CFrame * vector3new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
			end

			if flags[gun.."_jump_offset"] and old_velocity.Y > 12 then
				part_position-=vector3new(0,flags[gun.."_jump_offset_value"],0)
			end

			local did_check_on_screen = nil
			local did_check_visible = nil
			local did_position_line = false
			local did_position_body = false

			if flags["look_at"] then
				local_hrp.CFrame = cframenew(local_hrp.Position, vector3new(part_position.X, local_hrp.Position.Y, part_position.Z))
			end

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
						raycast_params.FilterDescendantsInstances = {target.Character, char, ignored_folder}
						raycast_params.FilterType = Enum.RaycastFilterType.Exclude

						if raycast(workspace, hrp_pos, (part_position - hrp_pos).unit * (part_position - hrp_pos).magnitude, raycast_params) then
							did_check_on_screen = false
							stop = true
							break
						end
					end
				end

				if not stop then
					local velocity = velocity

					local horizontal_prediction = flags[gun.."_silent_aim_horizontal_prediction"] 
					velocity*=(horizontal_prediction == 0 and vector3new(ping, 1, ping) or vector3new(horizontal_prediction, 1, horizontal_prediction))
					local vertical_prediction = flags[gun.."_silent_aim_vertical_prediction"] 
					velocity*=(vertical_prediction == 0 and vector3new(1, ping/3, 1) or vector3new(1, vertical_prediction, 1))

					aimbot_position = part_position+velocity
					aimbot.velocity = velocity

					if flags["max_curve"] then
						local pos = wtvp(camera, aimbot_position)
						local world_position = mouse_position+((vector2new(pos.X, pos.Y)-mouse_position)*(flags["max_curve_value"]/100))
						local ray = camera:ViewportPointToRay(world_position.X, flags["dont_curve_y"] and mouse_position.Y or world_position.Y)
						aimbot_position = ray.Origin + ray.Direction * (ray.Origin-part_position).magnitude
					end

					if flags["position_line"] then
						did_position_line = true
						local origin = flags["line_origin"][1] == "Mouse" and mouse_position or nil
						if not origin then
							local _pos, on_screen = wtvp(camera, hrp_pos)
							origin = on_screen and vector2new(_pos.X, _pos.Y) or nil
						end
						local _pos, on_screen = flags["line_position"][1] == "Predicted position" and wtvp(camera, aimbot_position) or wtvp(camera, part.Position)
						destination = on_screen and vector2new(_pos.X, _pos.Y) or nil
						if destination and origin then
							line.Visible = true
							line_outline.Visible = true
							line.From = origin
							line_outline.From = origin
							line.To = destination
							line_outline.To = destination
						else
							line.Visible = false
							line_outline.Visible = false
						end
					end

					if flags["position_body"] and body then
						local children = body:GetChildren()
						local velocity = old_velocity.magnitude == 0 and vector3new(9999,9999,9999) or velocity
						for i = 1, #children do
							local child = children[i]
							child.CFrame = character_parts[child.Name]["CFrame"] + velocity
						end
					end
				end
			end

			if flags["aim_assist"] and flags["aim_assist_keybind"]["active"] then
				local stop = false

				local part = character_parts["Humanoid"].FloorMaterial == Enum.Material.Air and flags[gun.."_cam_air_hitbox"][1] or flags[gun.."_cam_hitbox"][1]

				part = part == "Closest" and getClosestHitbox(mouse_position, character_parts) or character_parts[part]

				if not part then
					aimbot.target_position = nil
					line.Visible = false
					line_outline.Visible = false
					if body and body.Parent == ignored_folder then
						body.Parent = cg
					end
					return 
				end

				local part_position = part.Position
				if flags["multipoint"] then
					local cf = part.CFrame:PointToObjectSpace(mouse.Hit.p)
					local size = part.Size*(flags["multipoint_value"]/200)

					part_position = part.CFrame * vector3new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
				end

				if flags[gun.."_jump_offset"] and old_velocity.Y > 12 then
					part_position-=vector3new(0,flags[gun.."_jump_offset_value"],0)
				end

				for _, check in flags["aim_assist_disable_when"] do
					if check == "Typing" and lplr_data["typing"] then
						stop = true
						break
					elseif check == "Not holding gun" and not lplr_data["tool"] then
						stop = true
						break
					elseif check == "In third person" and lplr_data["third_person"] then
						stop = true
						break
					elseif check == "Out of fov" then
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
							raycast_params.FilterDescendantsInstances = {target.Character, char, ignored_folder}
							raycast_params.FilterType = Enum.RaycastFilterType.Exclude

							if raycast(workspace, hrp_pos, (part_position - hrp_pos).unit * (part_position - hrp_pos).magnitude, raycast_params) then
								stop = true
								break
							end
						elseif not did_check_visible then
							stop = true
							break
						end
					end
				end

				if not stop then
					local velocity = velocity

					local horizontal_prediction = flags[gun.."_aim_assist_horizontal_prediction"] 
					velocity*=(horizontal_prediction == 0 and vector3new(ping, 1, ping) or vector3new(horizontal_prediction, 1, horizontal_prediction))
					local vertical_prediction = flags[gun.."_aim_assist_vertical_prediction"] 
					velocity*=(vertical_prediction == 0 and vector3new(1, ping/3, 1) or vector3new(1, vertical_prediction, 1))
					local horizontal = flags[gun.."_aim_assist_horizontal_shake"]
					local vertical = flags[gun.."_aim_assist_horizontal_shake"]
					if horizontal > 0 then
						velocity+=vector3new(mathrandom(1, horizontal+1)/(mathrandom(2) == 1 and -50 or 50),1,mathrandom(1, horizontal+1)/(mathrandom(2) == 1 and -50 or 50))
					end
					if vertical > 0 then
						velocity+=vector3new(1,mathrandom(1, vertical+1)/(mathrandom(2) == 1 and -50 or 50),1)
					end

					local position = part_position+velocity
					
					if flags["aim_assist_style"][1] == "Mouse" then
						local pos = wtvp(camera, position)
						local new_pos = vector2new(pos.X, pos.Y)
						local distance = new_pos-mouse_position

						if aimbot.do_tp then
							mousemoverel(distance.X, distance.Y)
							task.delay(dt*2.5, function()
								aimbot.do_tp = false
							end)
						else
							local ease_style = Enum.EasingStyle[flags[gun.."_smoothing_style"][1]]
							local direction = Enum.EasingDirection[flags[gun.."_smoothing_direction"][1]]
							mousemoverel(distance.X * getValue(tws, ((100.01-flags[gun.."_aim_assist_horizontal_smoothness"])/100), ease_style, direction), distance.Y * getValue(tws, (100.01-flags[gun.."_aim_assist_vertical_smoothness"])/100, ease_style, direction))	
						end
					else
						if aimbot.do_tp then
							camera.CFrame = cframenew(camera.CFrame.p, position)
							aimbot.do_tp = false
						else
							camera.CFrame = camera.CFrame:Lerp(cframenew(camera.CFrame.p, position), getValue(tws, ((100.01-flags[gun.."_aim_assist_horizontal_smoothness"])/100), Enum.EasingStyle[flags[gun.."_smoothing_style"][1]], Enum.EasingDirection[flags[gun.."_smoothing_direction"][1]]))
						end
					end

					if not did_position_line then
						if flags["position_line"] then
							local origin = flags["line_origin"][1] == "Mouse" and mouse_position or nil
							if not origin then
								local _pos, on_screen = wtvp(camera, hrp_pos)
								origin = on_screen and vector2new(_pos.X, _pos.Y) or nil
							end
							local destination = flags["line_position"][1] == "Predicted position" and new_pos or nil
							if not destination then
								local _pos, on_screen = wtvp(camera, position)
								destination = on_screen and vector2new(_pos.X, _pos.Y) or nil
							end
							if destination and origin then
								line.Visible = true
								line_outline.Visible = true
								line.From = origin
								line_outline.From = origin
								line.To = destination
								line_outline.To = destination
							else
								line.Visible = false
								line_outline.Visible = false
							end
						end
					end

					if not did_position_body then
						if flags["position_body"] and body then
							local children = body:GetChildren()
							local velocity = old_velocity.magnitude == 0 and vector3new(9999,9999,9999) or velocity
							did_position_body = true
							for i = 1, #children do
								local child = children[i]
								child.CFrame = character_parts[child.Name]["CFrame"] + velocity
							end
						end
					end
				end
			end
		end
	end
	if aimbot_position then
		if body and body.Parent == cg then
			body.Parent = ignored_folder
		end
	else
		line.Visible = false
		line_outline.Visible = false
		if body and body.Parent == ignored_folder then
			body.Parent = cg
		end
	end
	if target ~= aimbot.target then
		aimbotTargetChange:Fire(target)
		aimbot.target = target
	end
	aimbot.target_position = aimbot_position
end)

local fixVelocity = LPH_NO_VIRTUALIZE(function(dt)
	local target = aimbot.target

	if not target then
		return end

	local refresh_time = tick()-aimbot.last_refresh
	local do_refresh = refresh_time > flags["resolver_refresh"]/1000

	if target then
		local data = player_data[target]
		if data then
			local hrp = data.character_parts["HumanoidRootPart"]
			if hrp then
				if do_refresh then
					if not aimbot.last_position then 
						aimbot.last_position = hrp.Position
					else
						aimbot.target_velocity = (hrp.Position - aimbot.last_position) / refresh_time
						aimbot.last_position = hrp.Position
					end
				end
			end
		end
	end

	if do_refresh then
		aimbot.last_refresh = tick()
	end
end)

local is_auto_shooting = false

local autoShoot = LPH_NO_VIRTUALIZE(function()
	local target = aimbot.target
	local tool = lplr_data["tool"]
	local gun = lplr_data["gun"]

	if not target or not flags["auto_shoot_keybind"]["active"] or lplr_data["auto_shoot_delay"] then
		if is_auto_shooting then
			is_auto_shooting = false
			if tool and gun then
				tool:Deactivate()
			end
		end
		return end

	if player_data[target]["forcefield"] or player_data[target]["knocked"] then
		if is_auto_shooting then
			is_auto_shooting = false
			if tool and gun then
				tool:Deactivate()
			end
		end
		return end

	local position = aimbot.target_position

	if not position then
		if is_auto_shooting then
			is_auto_shooting = false
			if tool and gun then
				tool:Deactivate()
			end
		end
		return end

	local raycast_params = RaycastParams.new()
	raycast_params.IgnoreWater = true;
	raycast_params.FilterDescendantsInstances = {char, target.Character, camera, ignored_folder}
	raycast_params.FilterType = Enum.RaycastFilterType.Exclude

	local pos = tool and tool.Handle.Position or lplr_parts["HumanoidRootPart"].Position

	if raycast(workspace, pos, (position-pos).unit*(position-pos).magnitude, raycast_params) then
		if is_auto_shooting then
			is_auto_shooting = false
			if tool and gun then
				tool:Deactivate()
			end
		end
		return end

	is_auto_shooting = true

	local tool = lplr_data["tool"]
	if tool and lplr_data["gun"] then
		tool:Activate()
		if flags["auto_shoot_delay"] > 0 then
			lplr_data["auto_shoot_delay"] = true
			task.delay(flags["auto_shoot_delay"]/1000, function()
				lplr_data["auto_shoot_delay"] = false
			end)
		end
	end
end)

utility.newConnection(menu_references["lock_bind"].onActiveChange, LPH_JIT(function()
	_wait()
	if flags["aimbot"] and flags["aimbot_keybind"]["active"] then
		local candidate, position = getAimbotCandidate(uis:GetMouseLocation())
		if candidate == aimbot.target then
			candidate = nil
		end
		aimbotTargetChange:Fire(candidate)
		aimbot.target = candidate
		aimbot.last_position = nil
		aimbot.target_velocity = vector3new()
		aimbot.target_screen_position = position
	end
end), true)

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
			local drawings, highlight = createESPObjects(player)
			info["drawings"] = drawings
			info["highlight"] = highlight
			if player.Character then
				highlight.Adornee = player.Character
				highlight.Enabled = not info["dont_render"] and flags["highlight"] or false
			end
		end
	end
end), true)

utility.newConnection(menu_references["resolver"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, fixVelocity) then
		remove(heartbeat_callbacks, fixVelocity)
	end 
	if bool then
		insert(heartbeat_callbacks, fixVelocity)
	end
	menu_references["resolver_refresh"]:setVisible(bool)
end, true)
menu_references["resolver_refresh"]:setVisible(false)

utility.newConnection(menu_references["aimbot_toggle"].onToggleChange, function(bool)
	local aimbot_circle = aimbot.circle
	aimbot.target = nil
	aimbotTargetChange:Fire(nil)
	aimbot_circle.Visible = (bool and flags["show_fov"] or false)
	aimbot.circle_outline.Visible = aimbot_circle.Visible
	if find(heartbeat_callbacks, doAimbot) then
		remove(heartbeat_callbacks, doAimbot)
	end
	if bool then
		insert(heartbeat_callbacks, doAimbot)
	end
end, true)

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

utility.newConnection(menu_references["bounding_box"].onColorChange, function(color, transparency)
	bounding_box_object.SurfaceColor3 = color
	bounding_box_object.SurfaceTransparency = flags["bounding_box_filled"] and transparency or 1
	bounding_box_object.Transparency = transparency
	bounding_box_object.Color3 = color
end, true)

utility.newConnection(menu_references["bounding_box_filled"].onToggleChange, function(bool)
	bounding_box_object.SurfaceTransparency = bool and flags["bounding_box_transparency"] or 1
end, true)

utility.newConnection(menu_references["bounding_box"].onToggleChange, function(bool)
	if bool then
		bounding_box_object.Adornee = aimbot.target and aimbot.target.Character or nil
	else
		bounding_box_object.Adornee = nil
	end
	menu_references["bounding_box_filled"]:setVisible(bool)
end, true)
menu_references["bounding_box_filled"]:setVisible(false)

utility.newConnection(menu_references["position_body"].onColorChange, function(color, transparency)
	local body = lplr_data["position_body"]
	if body then
		for _, part in body:GetChildren() do
			part.Color = color
			part.Transparency = transparency
		end
	end
end, true)

utility.newConnection(menu_references["position_body"].onDropdownChange, function(selected)
	local body = lplr_data["position_body"]
	if body then
		local material = Enum.Material[selected[1]]
		for _, part in body:GetChildren() do
			part.Material = material
		end
	end
end, true)

utility.newConnection(menu_references["position_body"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	local body = lplr_data["position_body"]
	if body then
		body:Destroy()
	end
	if bool and aimbot.target then
		local character = aimbot.target.Character
		character.Archivable = true; local model = character:Clone(); character.Archivable = false

		local all_parts = model:GetChildren()
		local material = Enum.Material[flags["position_body_material"][1]]
		local color = flags["position_body_color"]
		local transparency = flags["position_body_transparency"]
		model.Archivable = true

		for i = 1, #all_parts do
			local part = all_parts[i]
			local class_name = part.ClassName
			local name = part.Name
			if class_name == "MeshPart" then
				part.Color = color
				part.Material = material
				part.Transparency = transparency
				part.CanCollide = false
				part.Anchored = true
				if name == "Head" then
					local decal = part:FindFirstChild("face")
					if decal then decal:Destroy() end
				end
			else
				part:Destroy()
			end	
		end

		model.Parent = ignored_folder

		lplr_data["position_body"] = model
	end
end), true)

local offsets = {
	vector2new(1,1),
	vector2new(-1,1),
	vector2new(1,-1),
	vector2new(-1,-1)
}	

local antiLock = LPH_JIT(function(dt)
	if not flags["anti_lock_keybind"]["active"] then
		return end

	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	local old_velocity = hrp.Velocity
	local style = flags["anti_lock_style"][1]

	if style == "Multiplier" then
		hrp.Velocity*=flags["anti_lock_multiplier"]
	elseif style == "Random" then
		hrp.Velocity = vector3new(mathrandom(-50,50), mathrandom(-50,50), mathrandom(-50,50))
	elseif style == "Underground" then
		hrp.Velocity = vector3new(old_velocity.X, -25000, old_velocity.Z)
	elseif style == "Sky" then
		hrp.Velocity = vector3new(old_velocity.X, 25000, old_velocity.Z)
	elseif style == "Zero" then
		hrp.Velocity = vector3new()
	end

	rs.RenderStepped:Wait()

	hrp.Velocity = old_velocity
end)

local spinbot = LPH_NO_VIRTUALIZE(function(dt)
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	hrp.CFrame = (hrp.CFrame * angles(0,rad((flags["spinbot_speed"]*20)*dt),0))
end)

utility.newConnection(menu_references["character_lag_amount"].onSliderChange, function(value)
	if flags["character_lag"] then
		setfflag("S2PhysicsSenderRate", tostring(15-value))
	end
end)

utility.newConnection(menu_references["character_lag"].onToggleChange, function(bool)
	setfflag("S2PhysicsSenderRate", bool and tostring(15-flags["character_lag_amount"]) or "15")
end)

utility.newConnection(menu_references["spinbot"].onToggleChange, function(bool)
	local humanoid = lplr_parts["Humanoid"]
	if humanoid then
		humanoid.AutoRotate = not bool 
	end
	if find(heartbeat_callbacks, spinbot) then
		remove(heartbeat_callbacks, spinbot)
	end
	if bool then
		insert(heartbeat_callbacks, spinbot)
	end
	menu_references["spinbot_speed"]:setVisible(bool)
end, true)
menu_references["spinbot_speed"]:setVisible(bool)

utility.newConnection(menu_references["anti_lock"].onToggleChange, function(bool)
	if find(anti_callbacks, antiLock) then
		remove(anti_callbacks, antiLock)
	end
	if bool then
		insert(anti_callbacks, antiLock)
	end
end, true)

utility.newConnection(menu_references["anti_lock_style"].onDropdownChange, function(selected)
	menu_references["anti_lock_multiplier"]:setVisible(find(selected, "Multiplier") and true or false)
end, true)
menu_references["anti_lock_multiplier"]:setVisible(false)

utility.newConnection(menu_references["auto_shoot"].onActiveChange, function(bool)
	local tool = lplr_data["tool"]

	if not tool or not lplr_data["gun"] then
		return end

	tool:Deactivate()
end, true)

utility.newConnection(menu_references["auto_shoot"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, autoShoot) then
		remove(heartbeat_callbacks, autoShoot)
	end
	if bool then
		insert(heartbeat_callbacks, autoShoot)
	end
	menu_references["auto_shoot_delay"]:setVisible(bool)

	local tool = lplr_data["tool"]

	if not tool or not lplr_data["gun"] then
		return end

	tool:Deactivate()
end, true)
menu_references["auto_shoot_delay"]:setVisible(false)

local function cframeSpeed(dt)
	if not flags["cframe_speed_keybind"]["active"] then
		return end 

	local hrp = lplr_parts["HumanoidRootPart"]
	local humanoid = lplr_parts["Humanoid"]

	if not hrp or not humanoid then
		return end
		
	hrp.CFrame+=((humanoid.MoveDirection*dt)*(flags["cframe_speed_speed"]*5))
end

local cframeFly = LPH_JIT(function(dt)
	if not flags["cframe_fly_keybind"]["active"] then
		return end 

	local hrp = lplr_parts["HumanoidRootPart"]
	local humanoid = lplr_parts["Humanoid"]

	if not hrp or not humanoid then
		return end

	local speed = flags["cframe_fly_speed"]

	hrp.Velocity = vector3new(hrp.Velocity.X, 1.8, hrp.Velocity.Z)
	
	hrp.CFrame+=(((humanoid.MoveDirection*dt)*(speed*5))*vector3new(1,0,1)) + vector3new(0,(uis:IsKeyDown(Enum.KeyCode.Space) and 1+((speed*0.85)*dt)) or (uis:IsKeyDown(Enum.KeyCode.LeftShift) and -1-((speed*0.85)*dt)) or 0,0)
end)

local targetStrafe = LPH_JIT(function(dt)
	if not flags["target_strafe_keybind"]["active"] then
		return end 

	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	local target = aimbot.target

	if not target then
		return end

	local parts = player_data[target].character_parts

	local target_hrp = parts["HumanoidRootPart"]

	if not target_hrp then
		return end

	if (target_hrp.Position-vector3new(0,0,0)).magnitude > 9e5 then
		return end

	local hrp_pos = target_hrp.Position + vector3new(0, flags["vertical_strafe"], 0)
	local strafe_distance = flags["horizontal_strafe"]
	lplr_data["strafe_angle"]+=clamp((flags["strafe_speed"]*15)*dt, 0, 360)
	if lplr_data["strafe_angle"] > 360 then lplr_data["strafe_speed"] = 0 end
	hrp.CFrame = angles(0,rad(lplr_data["strafe_angle"]),0) * cframenew(0,0,strafe_distance) + hrp_pos
end)

local noclip_connection = nil

utility.newConnection(menu_references["noclip"].onToggleChange, function(bool)
	if noclip_connection then
		noclip_connection:Disconnect()
	end
	if bool then
		noclip_connection = utility.newConnection(rs.Stepped, LPH_NO_VIRTUALIZE(function()
			if not flags["noclip_keybind"]["active"] then
				return end

			for _, part in lplr_parts do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end 
			end
		end), true)
	end	
end, true)

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

utility.newConnection(menu_references["aimbot_priority"].onToggleChange, function(bool)
	local player = plrs:FindFirstChild(menu_references["players_box"]["selected_option"])

	if not player then
		return end 

	local info = player_data[player]

	if info then
		local show_all = find(flags["render"], "Players")
		local show_priority = find(flags["render"], "Priority")
		local show_target = find(flags["render"], "Target")
		local show_whitelisted = find(flags["render"], "Whitelisted")
		local highlight = info["highlight"]
		local done = false
	
		if show_all then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if show_priority and bool then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if show_target and aimbot.target == player then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if show_whitelisted and info["whitelisted"] then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if not done then
			info["dont_render"] = true
			if highlight then
				highlight["Enabled"] = false
			end
		end
	end

	lplr_data["priority"][player.Name] = bool
	info["aimbot_priority"] = bool
end, true)

utility.newConnection(menu_references["whitelisted"].onToggleChange, function(bool)
	local player = plrs:FindFirstChild(menu_references["players_box"]["selected_option"])

	if not player then
		return end 

	local info = player_data[player]

	if info then
		local show_all = find(flags["render"], "Players")
		local show_priority = find(flags["render"], "Priority")
		local show_target = find(flags["render"], "Target")
		local show_whitelisted = find(flags["render"], "Whitelisted")
		local highlight = info["highlight"]
		local done = false
	
		if show_all then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if show_priority and info["aimbot_priority"] then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if show_target and aimbot.target == player then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if show_whitelisted and bool then
			info["dont_render"] = false
			done = true
			if highlight then
				highlight["Enabled"] = true
			end
		end

		if not done then
			info["dont_render"] = true
			if highlight then
				highlight["Enabled"] = false
			end
		end
	end

	lplr_data["whitelisted"][player.Name] = bool
	info["whitelisted"] = bool
end, true)

utility.newConnection(menu_references["players_box"].onSelectionChange, function(selected)
	local player = plrs:FindFirstChild(selected)

	if not player then
		return end 

	menu_references["aimbot_priority"]:setToggle(player_data[player]["aimbot_priority"], true)
	menu_references["whitelisted"]:setToggle(player_data[player]["whitelisted"], true)
end, true)

local autoSort = LPH_JIT_MAX(function()
	local sort_positions = {}

	for i = 1, 9 do
		sort_positions[i] = lower(tostring(flags["slot_"..tostring(i)]))
	end

	local backpack = lplr.Backpack

	if not backpack then return end


	local children = backpack:GetChildren()
	local done = {}

	for i = 1, #children do
		children[i].Parent = lplr
	end

	for i = 1, 9 do
		local item = sort_positions[i]
		for i = 1, #children do
			local child = children[i]
			local name = lower(tostring(child))
			if name:find(item) then
				child.Parent = backpack
				done[tostring(child)] = true
			end
		end
	end

	for i = 1, #children do
		local child = children[i]
		if not done[child.Name] then
			child.Parent = backpack
		end
	end
end)

utility.newConnection(menu_references["auto_sort"].onToggleChange, function(bool)
	for i = 1, 9 do
		menu_references["slot_"..i]:setVisible(bool)
	end
end, true)
for i = 1, 9 do
	menu_references["slot_"..i]:setVisible(false)
end

utility.newConnection(menu_references["auto_sort"].onActiveChange, function(active)
	if not flags["auto_sort"] then
		return end

	if lplr_parts["Humanoid"] then
		_spawn(autoSort)
	end
end, true)


local cframeDesync = LPH_NO_VIRTUALIZE(function(dt)
	local hrp = lplr_parts["HumanoidRootPart"]
	lplr_data["hrp_cframe"] = nil

	if not hrp or not flags["cframe_desync_keybind"]["active"] or lplr_data["force_cframe"] then
		return end

	local old_cframe = hrp.CFrame
	local horizontal_offset = flags["horizontal_offset"]
	local vertical_offset = flags["vertical_offset"]
	local randomization = flags["cframe_randomization"]+1

	lplr_data["hrp_cframe"] = hrp.CFrame

	hrp.CFrame+=vector3new(mathrandom(2) == 1 and -horizontal_offset or horizontal_offset, mathrandom(2) == 2 and -vertical_offset or vertical_offset, mathrandom(2) == 2 and -horizontal_offset or horizontal_offset) * vector3new(1 + mathrandom(0, randomization)/10, 1 + mathrandom(0, randomization)/10, 1 + mathrandom(0, randomization)/10)

	local body = lplr_data["cframe_body"]

	if body then
		for part, _ in limb_descriptions do
			local _part = body[part]
			if _part then
				_part.CFrame = char[part].CFrame
			end
		end
	end

	rs.RenderStepped:Wait()

	hrp.CFrame = old_cframe
end)

utility.newConnection(menu_references["cframe_desync"].onActiveChange, function(bool)
	lplr_data["hrp_cframe"] = nil

	if lplr_data["cframe_body"] then
		lplr_data["cframe_body"].Parent = bool and ignored_folder or cg
	end
end, true)

utility.newConnection(menu_references["cframe_body"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lplr_data["hrp_cframe"] = nil

	if lplr_data["cframe_body"] then
		lplr_data["cframe_body"]:Destroy()
		lplr_data["cframe_body"] = nil
	end

	if char and bool then
		local color = flags["cframe_body_color"]
		local material = Enum.Material[flags["cframe_body_material"][1]]
		local transparency = flags["cframe_body_transparency"]

		char.Archivable = true; local model = char:Clone(); char.Archivable = false

		local all_parts = model:GetChildren()
		model.Archivable = true

		for i = 1, #all_parts do
			local part = all_parts[i]
			local class_name = part.ClassName
			local name = part.Name
			if class_name == "MeshPart" then
				part.Color = color
				part.Material = material
				part.Transparency = transparency
				part.CanCollide = false
				part.Anchored = true
				if name == "Head" then
					local decal = part:FindFirstChild("face")
					if decal then decal:Destroy() end
				end
			else
				part:Destroy()
			end	
		end

		lplr_data["cframe_body"] = model

		if flags["cframe_desync_keybind"]["active"] then
			model.Parent = ignored_folder
		else
			model.Parent = cg
		end
	end
end), true)

utility.newConnection(menu_references["cframe_body"].onDropdownChange, function(material)
	local body = lplr_data["cframe_body"]

	if body then
		for _, part in body:GetChildren() do
			part.Material = Enum.Material[material[1]]
		end
	end
end, true)

utility.newConnection(menu_references["cframe_body"].onColorChange, function(color, transparency)
	local body = lplr_data["cframe_body"]

	if body then
		for _, part in body:GetChildren() do
			part.Color = color
			part.Transparency = transparency
		end
	end
end, true)

utility.newConnection(menu_references["cframe_desync"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	menu_references["horizontal_offset"]:setVisible(bool)
	menu_references["vertical_offset"]:setVisible(bool)
	menu_references["cframe_randomization"]:setVisible(bool)
	menu_references["cframe_body"]:setVisible(bool)

	if lplr_data["cframe_body"] then
		lplr_data["cframe_body"]:Destroy()
		lplr_data["cframe_body"] = nil
	end

	lplr_data["hrp_cframe"] = nil

	if find(anti_callbacks, cframeDesync) then
		remove(anti_callbacks, cframeDesync)
	end

	if bool then
		if char and flags["cframe_body"] then
			local color = flags["cframe_body_color"]
			local material = Enum.Material[flags["cframe_body_material"][1]]
			local transparency = flags["cframe_body_transparency"]
	
			char.Archivable = true; local model = char:Clone(); char.Archivable = false
			model.Archivable = true
			local all_parts = model:GetChildren()

			for i = 1, #all_parts do
				local part = all_parts[i]
				local class_name = part.ClassName
				local name = part.Name
				if class_name == "MeshPart" then
					part.Color = color
					part.Material = material
					part.Transparency = transparency
					part.CanCollide = false
					part.Anchored = true
					if name == "Head" then
						local decal = part:FindFirstChild("face")
						if decal then decal:Destroy() end
					end
				else
					part:Destroy()
				end	
			end

			lplr_data["cframe_body"] = model

			if flags["cframe_desync_keybind"]["active"] then
				model.Parent = ignored_folder
			else
				model.Parent = cg
			end
		end

		insert(anti_callbacks, cframeDesync)
	end
end), true)

menu_references["horizontal_offset"]:setVisible(false)
menu_references["vertical_offset"]:setVisible(false)
menu_references["cframe_randomization"]:setVisible(false)
menu_references["cframe_body"]:setVisible(false)

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

for property, value in skyboxes["Default"] do
	skyboxes["Default"][property] = sky[property]
end

utility.newConnection(menu_references["world_skybox"].onDropdownChange, function(selected)
	if not flags["world_skybox"] then
		return end

	for property, value in skyboxes[selected[1]] do
		sky[property] = value
	end
end, true)

utility.newConnection(menu_references["world_skybox"].onToggleChange, function(bool)
	if not bool then
		for property, value in skyboxes["Default"] do
			sky[property] = value
		end
	else
		for property, value in skyboxes[flags["world_skybox_skybox"][1]] do
			sky[property] = value
		end
	end
end, true)
utility.newConnection(menu_references["view_target"].onToggleChange, function(bool)
	if aimbot.target then
		camera.CameraSubject = bool and aimbot.target.Character or char
	end
end)

utility.newConnection(menu_references["target_strafe"].onToggleChange, function(bool)
	menu_references["horizontal_strafe"]:setVisible(bool)
	menu_references["vertical_strafe"]:setVisible(bool)
	menu_references["strafe_speed"]:setVisible(bool)
	if find(heartbeat_callbacks, targetStrafe) then
		remove(heartbeat_callbacks, targetStrafe)
	end
	if bool then
		insert(heartbeat_callbacks, targetStrafe)
	end
end)
menu_references["horizontal_strafe"]:setVisible(false)
menu_references["vertical_strafe"]:setVisible(false)
menu_references["strafe_speed"]:setVisible(false)

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
	lplr_data["ping"] = tonumber(split(data_ping:GetValueString(),'(')[1])

	local hrp = lplr_parts["HumanoidRootPart"]

	if hrp then
		for _, connection in getconnections(hrp:GetPropertyChangedSignal("CFrame")) do
			connection:Disconnect()
		end
	end

	for _, callback in heartbeat_callbacks do
		_spawn(callback, dt)
	end

	for _, callback in anti_callbacks do
		_spawn(callback, dt)
	end

	local force_cframe = lplr_data["force_cframe"]

	if hrp and force_cframe then
		hrp.CFrame = force_cframe
		hrp.Velocity = vector3new(0,1.85,0)
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
			if find(flags["loaded_scripts"], lua) then
				remove(flags["loaded_scripts"], lua)
			end
		end
		getgenv().juju = nil
	end)

	getgenv().juju.load_config = LPH_NO_VIRTUALIZE(function(name)
		utility.loadConfig(name)
		menu.on_load:Fire()
	end)
end

if game.GameId == 3634139746 then
	loadstring([[
		local old = getreg()
		for _, v in old do
			if _ == "Instance" then
				local old = v.__index
				setreadonly(v, false)
				v.__index = function(self, index)
					if tostring(getcallingscript()) == "Anticheat_SOURCE" then
						return
					end
					return old(self, index)
				end
				setreadonly(v, true)
			end
		end
	]])()
else
	loadstring([[
		for _,v in getgc(true) do
			if typeof(v) == "table" then
				local found = rawget(v, "indexInstance")
				if found then
					for _, a in v do
						if _ ~= "eqEnum" and typeof(a) == "table" then
							a[2] = function()
								return false
							end
						end
					end
				end
			end
		end
	]])()
end