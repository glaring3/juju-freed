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
		viewing = nil,
		strafe_angle = 0,
		cframe_body = nil,
		team = lplr.Team,
		match = lplr:GetAttribute("Match"),
		accessories = {},
		equipped_accessories = {},
		triggerbot_delay = os.clock()
	}

local player_data = {}
local camera = workspace.CurrentCamera
	local wtvp = camera.WorldToViewportPoint
	local raycast = workspace.Raycast

for i,v in getconnections(game:GetService("LogService").MessageOut) do
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
		if gpe then return end
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
	fov = 50
}

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
	["Icon"] = "",
	["CFrame"] = cframenew()
}

local aimbotTargetChange = signal.new()
local lplrHitPlayer = signal.new()

local bounding_box_object = newObject("SelectionBox", {
	LineThickness = 0.01,
	SurfaceColor3 = colorfromrgb(255,255,255),
	SurfaceTransparency = 1,
	Color3 = colorfromrgb(255,255,255),
	Parent = gethui and gethui()
})

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

local getAimbotCandidate = LPH_NO_VIRTUALIZE(function(mouse_position)
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	local closest = 9e9
	local candidate = nil
	local position = nil
	local hrp_position = hrp.Position
	local camera_pos = camera.CFrame.p
	local max_target_distance = flags["max_target_distance"]
	local checks = flags["target_checks"]
	for player, info in player_data do
		local character = info["character"]

		if not character or not info["visible"] or (player.Team == lplr.Team) or info["match"] ~= lplr_data["match"] then
			continue end

		local upperTorso = info.character_parts["UpperTorso"]

		if not upperTorso then
			continue end

		local pos, on_screen = wtvp(camera, upperTorso.Position)

		if not on_screen then
			continue end

		local pos = vector2new(pos.X, pos.Y)
		local distance = (mouse_position - pos).magnitude

		if distance > aimbot.fov then
			continue end

		if (hrp_position-upperTorso.Position).magnitude > max_target_distance then
			continue end

		local stop = false

		for _, check in checks do						
			if check == "Visible" then				
				local raycast_params = RaycastParams.new()
				raycast_params.IgnoreWater = true;
				raycast_params.FilterDescendantsInstances = {character, char}
				raycast_params.FilterType = Enum.RaycastFilterType.Exclude

				local obj_distance = (camera_pos-upperTorso.Position).magnitude
								
				if raycast(workspace, camera_pos, (upperTorso.Position-camera_pos).unit * obj_distance, raycast_params) then		
					stop = true
					break
				end
			end
		end

		if stop then
			continue end

		if distance < closest then
			closest = distance
			candidate = player
			position = pos
		end
	end
	return candidate, position
end)

local getClosestHitbox = LPH_NO_VIRTUALIZE(function(mouse_pos, character_parts)
	local closest = math.huge
	local closest_part = character_parts["UpperTorso"]

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
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Line", {
			Thickness = 3,
			ZIndex = 1,
			Transparency = -flags["skeleton_transparency"]+1,
		}),
		utility.newDrawing("Line", {
			Thickness = 1,
			ZIndex = 2,
			Transparency = -flags["skeleton_transparency"]+1,
			Color = flags["skeleton_color"],
		}),
		utility.newDrawing("Square", {
			Thickness = 1,
			ZIndex = 1,
			Filled = true,
			Color = flags["box_fill_color"],
			Transparency = -flags["box_fill_transparency"]+1,
		}),
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
	data["visible"] = data["match"] == lplr_data["match"]

	local hrp = character:WaitForChild("UpperTorso", 60)

	if lplr_data["viewing"] == player then
		camera.CameraSubject = character
	end

	for _, object in character:GetChildren() do
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			data["tool"] = utility.removeBrackets(object.Name)
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = true
		end
	end

	if aimbot.target == player then
		if flags["bounding_box"] then
			bounding_box_object.Adornee = character
		end
	end

	utility.newConnection(character.ChildAdded, function(object)
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			data["tool"] = utility.removeBrackets(object.Name)
		end
	end, true)

	utility.newConnection(character.ChildRemoved, function(object)
		data["character_parts"][object.Name] = nil
		if object.ClassName == "Tool" then
			data["tool"] = nil
			
		end
	end, true)

	utility.newConnection(character.AncestryChanged, function()
		data["visible"] = character.Parent == workspace
	end)

	local highlight = data["highlight"]
	if highlight then
		highlight.Adornee = character
	end

	_wait(1)

	local hrp = character:FindFirstChild("HumanoidRootPart")

	if flags["hitbox_expander"] and hrp then
		hrp["Color"] = flags["hitbox_color"]
		hrp["Transparency"] = flags["hitbox_transparency"]
		hrp["Material"] = Enum.Material[flags["hitbox_material"][1]]
	end
end)

local playerAdded = LPH_NO_VIRTUALIZE(function(player)
	player_data[player] = {
		character = nil,
		highlight = nil,
		tool = nil,
		not_on_screen = true,
		team = player.Team == lplr.Team,
		match = player:GetAttribute("Match"),
		character_parts = {},
		drawings = {},
		connections = {},
		tweens = {},
		last_backtrack_update = vector3new(),
	}

	utility.newConnection(player:GetPropertyChangedSignal("Team"), function()
		player_data[player]["team"] = player.Team == lplr.Team
	end)

	utility.newConnection(player:GetAttributeChangedSignal("Match"), function()
		player_data[player]["match"] = player:GetAttribute("Match")
	end)

	utility.newConnection(player.CharacterAdded, playerCharacterAdded)

	if player.Character then
		_spawn(playerCharacterAdded, player.Character)
	end

	if flags["esp"] then
		local drawings, highlight = createESPObjects(player)
		player_data[player]["drawings"] = drawings
		player_data[player]["highlight"] = highlight
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

local lplrCharacterAdded = LPH_JIT(function(character)
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
			lplr_data["tool"] = nil
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

	lplr_gui = lplr.PlayerGui

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
end)

utility.newConnection(lplr.CharacterAdded, lplrCharacterAdded, true)

if lplr.Character then
	_spawn(lplrCharacterAdded, lplr.Character)
end

utility.newConnection(lplr:GetAttributeChangedSignal("Match"), function()
	lplr_data["match"] = lplr:GetAttribute("Match")
end)

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
local script_environment = {}

do
local rage = window:getTab(1)
	local exploits_section = rage:newSection({name = "Exploits", is_changeable = true, scale = 1})
		menu_references["kill_all"] = exploits_section:newElement({name = "Kill all", types = {toggle = {flag = "kill_all"}}})
local anti_aim = window:getTab(2)
	local misc_section = anti_aim:newSection({name = "Misc", is_changeable = true, scale = 0.5})
		menu_references["character_lag"] = misc_section:newElement({name = "Character lag", types = {toggle = {flag = "character_lag"}}})
		menu_references["character_lag_amount"] = misc_section:newElement({name = "Lag amount", types = {slider = {flag = "character_lag_amount", min = 1, max = 14, suffix = "t", prefix = ""}}})
		menu_references["spinbot"] = misc_section:newElement({name = "Spinbot", types = {toggle = {flag = "spinbot"}}})
		menu_references["spinbot_speed"] = misc_section:newElement({name = "Spin speed", types = {slider = {flag = "spinbot_speed", min = 1, max = 100, suffix = "%", prefix = ""}}})
local legit = window:getTab(3)
	local aimbot_section = legit:newSection({name = "Aimbot", is_changeable = false, scale = 1})
		menu_references["aimbot_toggle"] = aimbot_section:newElement({name = "Enabled", types = {toggle = {flag = "aimbot"}, keybind = {flag = "aimbot_keybind", method = 2}}}); keybinder:add(menu_references["aimbot_toggle"], "Aimbot", "aimbot_keybind", "aimbot")
		menu_references["silent_aim"] = aimbot_section:newElement({name = "Silent aim", types = {toggle = {flag = "silent_aim"}}})
		menu_references["max_curve"] = aimbot_section:newElement({name = "Max curve", types = {toggle = {flag = "max_curve"}, slider = {flag = "max_curve_value", min = 1, max = 100, default = 100, suffix = "%", prefix = ""}}})
		menu_references["dont_curve_y"] = aimbot_section:newElement({name = "Don't curve vertically", types = {toggle = {flag = "dont_curve_y"}}})
		menu_references["hit_chance"] = aimbot_section:newElement({name = "Hit chance", types = {slider = {flag = "hit_chance", max = 100, default = 100, min = 1, suffix = "%", prefix = ""}}})
		menu_references["mouse_aim"] = aimbot_section:newElement({name = "Mouse aim", types = {toggle = {flag = "mouse_aim"}, keybind = {flag = "mouse_aim_keybind"}}}); keybinder:add(menu_references["mouse_aim"], "Mouse aim", "mouse_aim_keybind", "mouse_aim")
		menu_references["smoothing_style"] = aimbot_section:newElement({name = "Smoothing style", types = {dropdown = {flag = "smoothing_style", no_none = true, default = {"Linear"}, options = {"Linear", "Circular", "Sine", "Quad", "Quint", "Bounce", "Exponential", "Back", "Elastic"}}}})
		menu_references["smoothing_direction"] = aimbot_section:newElement({name = "Smoothing direction", types = {dropdown = {flag = "smoothing_direction", no_none = true, default = {"Out"}, options = {"InOut", "Out", "In"}}}})
		menu_references["horizontal_smoothness"] = aimbot_section:newElement({name = "Horizontal smoothness", types = {slider = {flag = "horizontal_smoothness", decimal = 1, min = 1, max = 100, prefix = "", suffix = "%", changers = 0.1}}})
		menu_references["vertical_smoothness"] = aimbot_section:newElement({name = "Vertical smoothness", types = {slider = {flag = "vertical_smoothness", decimal = 1, min = 1, max = 100, prefix = "", suffix = "%", changers = 0.1}}})
		menu_references["auto_select_target"] = aimbot_section:newElement({name = "Auto select target", types = {toggle = {flag = "auto_select_target"}}})
		menu_references["lock_bind"] = aimbot_section:newElement({name = "Target bind", types = {keybind = {flag = "lock_bind", method = 3, method_locked = true}}})
		menu_references["multipoint"]  = aimbot_section:newElement({name = "Multipoint", types = {toggle = {flag = "multipoint"}, slider = {flag = "multipoint_value", min = 1, max = 100, suffix = "%", prefix = ""}}})
		menu_references["field_of_view"] = aimbot_section:newElement({name = "Field of view", types = {slider = {flag = "field_of_view", min = 5, max = 300, default = 20, suffix = "°", prefix = "", changers = 1}}})
		menu_references["shake"]  = aimbot_section:newElement({name = "Shake", types = {toggle = {flag = "shake"}}})
		menu_references["horizontal_shake"] = aimbot_section:newElement({name = "Horizontal shake", types = {slider = {flag = "horizontal_shake", min = 1, max = 100, prefix = "", suffix = "%", changers = 1}}})
		menu_references["vertical_shake"] = aimbot_section:newElement({name = "Vertical shake", types = {slider = {flag = "vertical_shake", min = 1, max = 100, prefix = "", suffix = "%", changers = 1}}})
		aimbot_section:newElement({name = "Max target distance", types = {slider = {flag = "max_target_distance", min = 50, default = 150, max = 2500, suffix = "", prefix = "", changers = 1}}})
		aimbot_section:newElement({name = "Target checks", types = {dropdown = {flag = "target_checks", multi = true, options = {"Visible"}}}})
		aimbot_section:newElement({name = "Aim checks", types = {dropdown = {flag = "aim_checks", multi = true, options = {"Tool equipped", "Target visible", "On screen", "In fov"}}}})
		aimbot_section:newElement({name = "Hitbox", types = {dropdown = {flag = "hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "UpperTorso", "LowerTorso", "Closest"}}}})
	local other_section = legit:newSection({name = "Other", is_changeable = false, x = 0.5, scale = 0.5})
		menu_references["hitbox_expander"] = other_section:newElement({name = "Hitbox expander", types = {toggle = {flag = "hitbox_expander"}, colorpicker = {flag = "hitbox_color", transparency_flag = "hitbox_transparency", transparency = 0.8}}})
		menu_references["hitbox_material"] = other_section:newElement({name = "Hitbox material", types = {dropdown = {flag = "hitbox_material", default = {"Neon"}, options = {"ForceField", "Neon"}}}})
		menu_references["hitbox_horizontal_size"] = other_section:newElement({name = "Horizontal size", types = {slider = {flag = "hitbox_horizontal_size", min = 3, max = 50, prefix = "", suffix = "", changers = 1}}})
		menu_references["hitbox_vertical_size"] = other_section:newElement({name = "Vertical size", types = {slider = {flag = "hitbox_vertical_size", min = 2, max = 50, prefix = "", suffix = "", changers = 1}}})
		menu_references["triggerbot"] = other_section:newElement({name = "Triggerbot", types = {toggle = {flag = "triggerbot"}, keybind = {flag = "triggerbot_keybind"}}}); keybinder:add(menu_references["triggerbot"], "Triggerbot", "triggerbot_keybind", "triggerbot")
		menu_references["ignore_dismiss"] = other_section:newElement({name = "Ignore if dismissing", types = {toggle = {flag = "ignore_dismiss"}}})
		menu_references["triggerbot_hitboxes"] = other_section:newElement({name = "Hitboxes", types = {dropdown = {flag = "triggerbot_hitboxes", default = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm"}, multi = true}}})
		menu_references["triggerbot_delay"] = other_section:newElement({name = "Delay", types = {slider = {flag = "triggerbot_delay", min = 0, max = 250, suffix = "ms", prefix = "", changers = 1}}})
		menu_references["fast_shoot"] = other_section:newElement({name = "Fast shoot", types = {toggle = {flag = "fast_shoot"}, slider = {flag = "shoot_speed", prefix = "", min = 1, max = 100, suffix = "%"}}})
		menu_references["backtrack"] = other_section:newElement({name = "Backtrack", types = {toggle = {flag = "backtrack"}, slider = {flag = "backtrack_delay", prefix = "", min = 1, max = 1500, suffix = "ms"}}})
		menu_references["show_model"] = other_section:newElement({name = "Show model", types = {toggle = {flag = "show_model"}, colorpicker = {flag = "backtrack_color", transparency_flag = "backtrack_transparency"}}})
		menu_references["model_material"] = other_section:newElement({name = "Material", types = {dropdown = {flag = "model_material", options = {"ForceField", "Neon"}, no_none = true, default = {"ForceField"}}}})
	local aimbot_visualization = legit:newSection({name = "Aimbot visualization", is_changeable = false, scale = 0.5, x = 0.5, y = 0.5})
		menu_references["show_fov"] = aimbot_visualization:newElement({name = "Show fov", types = {toggle = {default = true, flag = "show_fov"}, colorpicker = {flag = "fov_color", transparency_flag = "fov_transparency"}}})
		menu_references["show_fov_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {default = false, flag = "show_fov_filled"}}})
		menu_references["active_color"] = aimbot_visualization:newElement({name = "Active color", types = {colorpicker = {flag = "active_color", transparency_flag = "active_transparency"}}})
		menu_references["gradient_overlay"] = aimbot_visualization:newElement({name = "Gradient overlay", types = {toggle = {flag = "gradient_overlay"}, colorpicker = {flag = "gradient_overlay_color", transparency_flag = "gradient_overlay_transparency"}}})
		menu_references["gradient_glow"] = aimbot_visualization:newElement({name = "Glow", types = {toggle = {flag = "gradient_glow"}}})
		menu_references["position_line"] = aimbot_visualization:newElement({name = "Position line", types = {toggle = {flag = "position_line"}, colorpicker = {flag = "line_color", transparency_flag = "line_transparency"}}})
		menu_references["line_origin"] = aimbot_visualization:newElement({name = "Origin", types = {dropdown = {flag = "line_origin", options = {"Character", "Mouse"}, default = {"Character"}, no_none = true}}})
		menu_references["line_position"] = aimbot_visualization:newElement({name = "Position", types = {dropdown = {flag = "line_position", options = {"Character position"}, default = {"Character position"}, no_none = true}}})
		menu_references["bounding_box"] = aimbot_visualization:newElement({name = "Bounding box", types = {toggle = {flag = "bounding_box"}, colorpicker = {flag = "bounding_box_color", transparency_flag = "bounding_box_transparency"}}})
		menu_references["bounding_box_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {flag = "bounding_box_filled"}}})
local visuals = window:getTab(4)
	local player_esp_section = visuals:newSection({name = "Player ESP", is_changeable = true, scale = 0.6})
		menu_references["esp_toggle"] = player_esp_section:newElement({name = "Enabled", types = {toggle = {flag = "esp"}}})
		menu_references["box_toggle"] = player_esp_section:newElement({name = "Box", types = {toggle = {flag = "box"}, colorpicker = {flag = "box_color", transparency_flag = "box_transparency"}}})
		menu_references["fill_toggle"] = player_esp_section:newElement({name = "Fill", types = {toggle = {flag = "box_fill"}, colorpicker = {flag = "box_fill_color", transparency_flag = "box_fill_transparency", default_transparency = 0.5}}})
		menu_references["name_toggle"] = player_esp_section:newElement({name = "Name", types = {toggle = {flag = "name"}, colorpicker = {flag = "name_color", transparency_flag = "name_transparency"}}})
		menu_references["name_display"] = player_esp_section:newElement({name = "Use display name", types = {toggle = {flag = "name_display"}}})
		menu_references["name_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "name_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["weapon_toggle"] = player_esp_section:newElement({name = "Weapon",types = {toggle = {flag = "weapon"}, colorpicker = {flag = "weapon_color", transparency_flag = "weapon_transparency"}}})
		menu_references["weapon_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "weapon_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["skeleton_toggle"] = player_esp_section:newElement({name = "Skeleton" ,types = {toggle = {flag = "skeleton"}, colorpicker = {flag = "skeleton_color", transparency_flag = "skeleton_transparency"}}})
		menu_references["highlight_toggle"] = player_esp_section:newElement({name = "Highlight", types = {toggle = {flag = "highlight"}, colorpicker = {flag = "highlight_color", default_transparency = 0.6, default = colorfromrgb(93, 169, 240), transparency_flag = "highlight_transparency"}}})
		menu_references["highlight_outline"] = player_esp_section:newElement({name = "Outline", types = {colorpicker = {flag = "outline_color", default = colorfromrgb(255, 105, 247), transparency_flag = "outline_transparency"}}})
		menu_references["esp_font"] = player_esp_section:newElement({name = "Text font", types = {dropdown = {flag = "esp_font", no_none = true, default = {"2"}, options = {"1", "2", "3", "4"}}}})
	local self_esp_section = visuals:newSection({name = "Self ESP", is_changeable = true, y = 0.6, scale = 0.4})
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
	local hud_section = visuals:newSection({name = "Hud", is_changeable = true, x = 0.5, y = 0.3, scale = 0.2})
		menu_references["drawing_crosshair"] = hud_section:newElement({name = "Drawing crosshair", types = {toggle = {flag = "drawing_crosshair"}, colorpicker = {flag = "drawing_crosshair_color", transparency_flag = "drawing_crosshair_transparency"}}})
		menu_references["drawing_crosshair_spin"] = hud_section:newElement({name = "Spin", types = {toggle = {flag = "drawing_crosshair_spin"}, slider = {flag = "drawing_crosshair_speed", suffix = "%", prefix = "", min = 1, max = 100}}})
		menu_references["drawing_crosshair_location"] = hud_section:newElement({name = "Location", types = {dropdown = {flag = "drawing_crosshair_location", options = {"Mouse", "Center", "Target"}, no_none = true, default = {"Mouse"}}}})
		menu_references["drawing_crosshair_length"] = hud_section:newElement({name = "Length", types = {slider = {flag = "drawing_crosshair_length", suffix = "px", prefix = "", min = 5, max = 100}}})
		menu_references["drawing_crosshair_gap"] = hud_section:newElement({name = "Gap", types = {slider = {flag = "drawing_crosshair_gap", suffix = "px", prefix = "", min = 5, max = 100}}})
		menu_references["custom_crosshair"] = hud_section:newElement({name = "Custom crosshair", types = {toggle = {flag = "custom_crosshair"}}})
		menu_references["crosshair_id"] = hud_section:newElement({name = "h", types = {textbox = {flag = "crosshair", default = ""}}})
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
	local other_section = visuals:newSection({name = "Other", is_changeable = true, x = 0.5, y = 0.5, scale = 0.5})
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
	local movement_section = misc:newSection({name = "Movement", is_changeable = false, scale = 1})
		menu_references["cframe_speed"] = movement_section:newElement({name = "CFrame speed", types = {toggle = {flag = "cframe_speed"}, keybind = {flag = "cframe_speed_keybind", method = 2}}}); keybinder:add(menu_references["cframe_speed"], "CFrame speed", "cframe_speed_keybind", "cframe_speed")
		menu_references["cframe_speed_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_speed_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		menu_references["cframe_fly"] = movement_section:newElement({name = "CFrame fly", types = {toggle = {flag = "cframe_fly"}, keybind = {flag = "cframe_fly_keybind", method = 2}}}); keybinder:add(menu_references["cframe_fly"], "CFrame fly", "cframe_fly_keybind", "cframe_fly")
		menu_references["cframe_fly_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_fly_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		movement_section:newElement({name = "Quick stop", types = {toggle = {flag = "quick_stop"}}})
		menu_references["noclip"] = movement_section:newElement({name = "Noclip", types = {toggle = {flag = "noclip"}, keybind = {flag = "noclip_keybind"}}}); keybinder:add(menu_references["noclip"], "Noclip", "noclip_keybind", "noclip")
	local game_section = misc:newSection({name = "Game modifiers", is_changeable = true, x = 0.5, scale = 0.5})
		utility.newConnection(game_section:newElement({name = "Infinite zoom out", types = {toggle = {flag = "infinite_zoom_out"}}}).onToggleChange, function(bool)
			lplr.CameraMaxZoomDistance = bool and 9e9 or spoof_properties["CameraMaxZoomDistance"]
		end, true)
		utility.newConnection(game_section:newElement({name = "No void kill", types = {toggle = {flag = "no_void_kill"}}}).onToggleChange, function(bool)
			workspace.FallenPartsDestroyHeight = bool and -9e9 or -500
		end, true)
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
			hit_player = lplrHitPlayer,
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
							script_environment[name] = nil
							if find(flags["loaded_scripts"], name) then
								remove(flags["loaded_scripts"], name)
							end
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
					if find(flags["loaded_scripts"], lua) then
						remove(flags["loaded_scripts"], lua)
					end
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
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and flags["keybinds_list"] then
		if utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
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
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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

utility.newConnection(menu_references["hit_chams"].onToggleChange, function(bool)
	menu_references["hit_chams_lifetime"]:setVisible(bool)
	menu_references["hit_chams_fade"]:setVisible(bool)
end, true)
menu_references["hit_chams_lifetime"]:setVisible(false)
menu_references["hit_chams_fade"]:setVisible(false)

utility.newConnection(menu_references["fast_shoot"].onToggleChange, function(bool)
	menu_references["fast_shoot"]:changeSliderVisiblity(bool)
end, true)
menu_references["fast_shoot"]:changeSliderVisiblity(false)

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
			gradient_glow.Parent = workspace.KnifeProjectiles
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
	gradient_glow.Parent = (bool and aimbot.target) and workspace.KnifeProjectiles or cg
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

utility.newConnection(menu_references["custom_crosshair"].onToggleChange, function(bool)
	menu_references["crosshair_id"]:setVisible(bool)
	if mouse.Icon ~= "" and not bool then
		mouse.Icon = "http://www.roblox.com/asset/?id=12591004690"
	elseif bool and mouse.Icon ~= "" then
		mouse.Icon = flags["crosshair"]
	end
end)
menu_references["crosshair_id"]:setVisible(false)

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

utility.newConnection(menu_references["max_curve"].onToggleChange, function(bool)
	menu_references["dont_curve_y"]:setVisible(bool)
	menu_references["max_curve"]:changeSliderVisiblity(bool)
end)
menu_references["dont_curve_y"]:setVisible(false)
menu_references["max_curve"]:changeSliderVisiblity(false)

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

utility.newConnection(menu_references["mouse_aim"].onToggleChange, function(bool)
	menu_references["horizontal_smoothness"]:setVisible(bool)
	menu_references["vertical_smoothness"]:setVisible(bool)
	menu_references["smoothing_style"]:setVisible(bool)
	menu_references["smoothing_direction"]:setVisible(bool)
end)
menu_references["horizontal_smoothness"]:setVisible(false)
menu_references["vertical_smoothness"]:setVisible(false)
menu_references["smoothing_style"]:setVisible(false)
menu_references["smoothing_direction"]:setVisible(false)

utility.newConnection(menu_references["multipoint"].onToggleChange, function(bool)
	menu_references["multipoint"]:changeSliderVisiblity(bool)
end)
menu_references["multipoint"]:changeSliderVisiblity(false)

utility.newConnection(menu_references["silent_aim"].onToggleChange, function(bool)
	menu_references["max_curve"]:setVisible(bool)
	menu_references["hit_chance"]:setVisible(bool)
end)
menu_references["max_curve"]:setVisible(false)
menu_references["hit_chance"]:setVisible(false)

utility.newConnection(menu_references["auto_select_target"].onToggleChange, function(bool)
	menu_references["lock_bind"]:setVisible(not bool)
end)
menu_references["lock_bind"]:setVisible(not bool)

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

utility.newConnection(menu_references["field_of_view"].onSliderChange, function(value)
	aimbot["fov"] = value*3.33
	aimbot.circle.Radius = aimbot["fov"]
	aimbot.circle_outline.Radius = aimbot["fov"]
end)

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
			highlight.Enabled = bool
			local character = info["character"]
			if character then
				highlight.Adornee = bool and character or nil
			end
		end
	end
end, true)
menu_references["highlight_outline"]:setVisible(bool)

utility.newConnection(menu_references["fill_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			local fill = drawings[25]

			if fill then
				fill["Color"] = color
				fill["Transparency"] = -transparency+1
			end
		end
	end
end, true)

utility.newConnection(menu_references["skeleton_toggle"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	for player, info in player_data do
		local drawings = info["drawings"]

		if drawings then
			for i = 1, 20 do
				local count = 4+i
				local drawing = drawings[count]

				if not drawing then
					continue end
				
				if count % 2 == 0 then
					drawing["Color"] = color
				end

				drawing["Transparency"] = -transparency+1
			end
		end
	end
end), true)

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
			local weapon = drawings[4]

			if name then
				name["Font"] = font
			end

			if weapon then
				weapon["Font"] = font
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
			local weapon = drawings[4]

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
			local weapon = drawings[4]

			if weapon then
				weapon["Color"] = color
				weapon["Transparency"] = -transparency+1
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

utility.newConnection(menu_references["show_fov"].onToggleChange, function(bool)
	aimbot.circle.Visible = flags["aimbot"] and bool or false
	aimbot.circle_outline.Visible = aimbot.circle.Visible
end, true)

utility.newConnection(menu_references["active_color"].onColorChange, function(color, transparency)
	aimbot.circle.Color = flags["aimbot_keybind"]["active"] and color or flags["fov_color"]
	aimbot.circle.Transparency = flags["aimbot_keybind"]["active"] and -transparency+1 or -flags["fov_transparency"]+1
	aimbot.circle_outline.Transparency = aimbot.circle.Transparency
end, true)

utility.newConnection(menu_references["show_fov"].onColorChange, function(color, transparency)
	aimbot.circle.Color = flags["aimbot_keybind"]["active"] and flags["active_color"] or color
	aimbot.circle.Transparency = flags["aimbot_keybind"]["active"] and -flags["active_transparency"]+1 or -transparency+1
	aimbot.circle_outline.Transparency = aimbot.circle.Transparency
end, true)

local last_target = nil

utility.newConnection(aimbotTargetChange, LPH_JIT(function(target)
	aimbot.line.Visible = target ~= nil and flags["position_line"] or false
	aimbot.line_outline.Visible = aimbot.line.Visible
	local old_last_target = last_target
	last_target = target
	bounding_box_object.Adornee = target and target.Character or nil
	if not flags["bounding_box"] then
		bounding_box_object.Adornee = nil
	end
	if flags["notifications"] and find(flags["notifications_selected"], "Target changes") and target ~= old_last_target then
		_spawn(newNotification, target and "locked onto player "..target.Name or "unlocked", flags["notification_style"][1])
	end
	gradient_glow.Parent = (flags["gradient_overlay"] and target) and workspace.KnifeProjectiles or cg
	if flags["gradient_overlay"] then
		if target then
			tween(gradient_glow, newtweeninfo(0.15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 6, 1)})
		else
			tween(gradient_glow, newtweeninfo(0.08, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = vector3new(1, 0, 1)})
		end
	end
end), true)

utility.newConnection(menu_references["aimbot_toggle"].onActiveChange, function(bool)
	aimbot.target = nil
	aimbotTargetChange:Fire(nil)
	aimbot.circle.Color = bool and flags["active_color"] or flags["fov_color"]
end, true)

utility.newConnection(menu_references["position_line"].onColorChange, function(color, transparency)
	aimbot.line.Color = color
	aimbot.line.Transparency = -transparency+1
	aimbot.line_outline.Transparency = -transparency+1
end, true)

utility.newConnection(menu_references["shake"].onToggleChange, function(bool)
	menu_references["horizontal_shake"]:setVisible(bool)
	menu_references["vertical_shake"]:setVisible(bool)
end, true)
menu_references["horizontal_shake"]:setVisible(false)
menu_references["vertical_shake"]:setVisible(false)

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

local old_index = nil

old_index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, index)
	if not checkcaller() then
		if self == lplr_parts["HumanoidRootPart"] then
			if lplr_data["hrp_cframe"] and index == "CFrame" then
				return lplr_data["hrp_cframe"]
			end
		elseif self == mouse and lower(index) == "hit" then
			if aimbot.target_position and flags["silent_aim"] then
				if flags["hit_chance"] < 100 and flags["hit_chance"] <= mathrandom(1, 100) then
					return old_index(self, index)
				end
				return cframenew(aimbot.target_position)
			end
		elseif self == mouse and lower(index) == "unitray" then
			if aimbot.target_position and flags["silent_aim"] then
				if flags["hit_chance"] < 100 and flags["hit_chance"] <= mathrandom(1, 100) then
					return old_index(self, index)
				end
				return Ray.new(self.Origin.p, (aimbot.target_position - self.Origin.p).Unit)
			end
		elseif tostring(self) == "HumanoidRootPart" and index == "Size" then
			return vector3new(2,2,1)
		elseif tostring(self) == "Advertisement" and index == "FireServer" then
			return function(...)
			end
		end
	end
	return old_index(self, index)
end))

local old_new_index = nil

old_new_index = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, index, value)
	if not checkcaller() then
		if spoof_properties[index] then
			spoof_properties[index] = value
			if index == "Icon" and self == mouse and flags["custom_crosshair"] and value ~= "" then
				value = flags["crosshair"]
			end
			if flags[skip_indexes[index]] then
				return
			end
		end
	end
	return old_new_index(self, index, value)
end))

local old_namecall = nil

old_namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)
	if not checkcaller() then
		if getnamecallmethod() == "FireServer" then
			if tostring(self) == "Shoot" and flags["backtrack"] then
				local args = {...}
				local part = args[3]

				if part and part.Parent and part.Parent.Name == "\255" then
					local player = plrs:FindFirstChild(part.Parent:GetAttribute("Player"))

					if player then
						args[3] = player_data[player]["character_parts"][part.Name]
					end
				end

				self.FireServer(self, unpack(args))

				return
			end
		elseif getnamecallmethod() == "GetAttribute" then
			local args = {...}
			if args[1] == "Cooldown" and flags["fast_shoot"] and tostring(getcallingscript()) == "GunController" then
				local old = self.GetAttribute(self, ...)

				return old*(100-flags["shoot_speed"])
			end
		end
	end
	return old_namecall(self, ...)
end))

-----------------------------
-- * Cheat Core Features * --
-----------------------------

local heartbeat_callbacks = {}
local anti_callbacks = {}

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
	local killAll = LPH_NO_VIRTUALIZE(function(dt)
		if lplr_data["match"] == nil then
			return end

		for player, info in player_data do
			local character = info["character"]
	
			if not character or not info["visible"] then
				continue end			
	
			local head = info["character_parts"]["LeftLowerLeg"]
	
			if not head then
				continue end
	
			if player.Team == lplr.Team then
				continue end

			for _, tool in lplr.Backpack:GetChildren() do
				if tool:FindFirstChild("Reload") then
					tool.Parent = char
				end
			end

			reps.Remotes.Shoot:FireServer(head.Position, head.Position, head, head.Position)
		end
	end)

	utility.newConnection(menu_references["kill_all"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, killAll) then
			remove(heartbeat_callbacks, killAll)
		end
		if bool then
			insert(heartbeat_callbacks, killAll)
		end
	end, true)
end

do
	local part = newObject("Part", {
		CFrame = CFrame.new(-169.848083,0.5,-116.794434,1,0,0,0,1,0,0,0,1);
		CanCollide = false;
		Size = Vector3.new(1,1,1);
		TopSurface = Enum.SurfaceType.Smooth;
		Transparency = 1;
		Anchored = true;
		Parent = workspace.KnifeProjectiles
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
		part.Parent = bool and workspace.KnifeProjectiles or cg
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


local doHitboxes = LPH_JIT(function()
	for player, info in player_data do
		local character = info["character"]

		if not character or not info["visible"] then
			continue end			

		local hrp = info["character_parts"]["HumanoidRootPart"]

		if not hrp then
			continue end

		if player.Team == lplr.Team then
			hrp["Size"] = vector3new(2,2,1)
			hrp["Transparency"] = 1
			continue end

		hrp["CanCollide"] = false
		hrp["Size"] = vector3new(flags["hitbox_horizontal_size"], flags["hitbox_vertical_size"], flags["hitbox_horizontal_size"])
	end
end)

utility.newConnection(menu_references["hitbox_expander"].onToggleChange, function(bool)
	menu_references["hitbox_horizontal_size"]:setVisible(bool)
	menu_references["hitbox_vertical_size"]:setVisible(bool)
	menu_references["hitbox_material"]:setVisible(bool)
	if find(heartbeat_callbacks, doHitboxes) then
		remove(heartbeat_callbacks, doHitboxes)
	end
	if bool then
		insert(heartbeat_callbacks, doHitboxes)
		for player, info in player_data do
			local character = info["character"]

			if not character then
				continue end

			local hrp = info["character_parts"]["HumanoidRootPart"]

			if not hrp then
				continue end

			hrp["Color"] = flags["hitbox_color"]
			hrp["Transparency"] = flags["hitbox_transparency"]
			hrp["Material"] = Enum.Material[flags["hitbox_material"][1]]
		end
	else
		for player, info in player_data do
			local character = info["character"]

			if not character then
				continue end

			local hrp = info["character_parts"]["HumanoidRootPart"]

			if not hrp then
				continue end

			hrp["Size"] = vector3new(2,2,1)
			hrp["Transparency"] = 1
		end
	end
end, true)
menu_references["hitbox_horizontal_size"]:setVisible(false)
menu_references["hitbox_vertical_size"]:setVisible(false)
menu_references["hitbox_material"]:setVisible(false)

utility.newConnection(menu_references["hitbox_material"].onDropdownChange, function(material)
	if not flags["hitbox_expander"] then
		return end

	local material = Enum.Material[material[1]]
	for player, info in player_data do
		local character = info["character"]

		if not character then
			continue end

		local hrp = info["character_parts"]["HumanoidRootPart"]

		if not hrp then
			continue end

		hrp["Material"] = material
	end
end, true)

utility.newConnection(menu_references["hitbox_expander"].onColorChange, function(color, transparency)
	if not flags["hitbox_expander"] then
		return end

	for player, info in player_data do
		local character = info["character"]

		if not character then
			continue end

		local hrp = info["character_parts"]["HumanoidRootPart"]

		if not hrp then
			continue end

		hrp["Color"] = color
		hrp["Transparency"] = transparency
	end
end, true)

local renderESP = nil 

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

do	
	renderESP = LPH_NO_VIRTUALIZE(function()
		local do_box = flags["box"]
		local do_name = flags["name"]
		local do_weapon = flags["weapon"]
		local do_skeleton = flags["skeleton"]
		local do_fill = flags["box_fill"]

		local below = vector3new(0, -3.65, 0)
		local above = vector3new(0, 2.9, 0)
		for player, info in player_data do
			local drawings = info["drawings"]
	
			local character_parts = info.character_parts
			local hrp, humanoid = character_parts["UpperTorso"], character_parts["Humanoid"]
	
			if info["visible"] and humanoid then
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
						local fill = drawings[25]

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
	
					if do_weapon then
						local text = info["tool"]
						local tool = drawings[4]

						tool.Visible = text and true or false

						if text then
							tool.Text = text
							tool.Position = vector2new(box_size_x / 2 + box_pos_x, box_pos_y + box_size_y + 1)
						end
					end
	
					if do_skeleton then
						local upper_pos, _ = wtvp(camera, hrp.Position + vector3new(0,0.5,0)) 
						local lower_pos, _ = wtvp(camera, character_parts["LowerTorso"].Position) 
	
						local torso_line = drawings[5]
						local torso_outline = drawings[6]
	
						torso_line["Visible"] = true
						torso_outline["Visible"] = true
						torso_line["From"] = vector2new(upper_pos.X, upper_pos.Y)
						torso_outline["From"] = torso_line["From"]
						torso_line["To"] = vector2new(lower_pos.X, lower_pos.Y)
						torso_outline["To"] = torso_line["To"]
	
						local left_upper_arm, _ = wtvp(camera, character_parts["LeftUpperArm"].Position) 
	
						local left_upper_arm_line = drawings[7]
						local left_upper_arm_outline = drawings[8]
	
						left_upper_arm_line["Visible"] = true
						left_upper_arm_outline["Visible"] = true
						left_upper_arm_line["From"] = torso_line["From"]
						left_upper_arm_outline["From"] = left_upper_arm_line["From"]
						left_upper_arm_line["To"] = vector2new(left_upper_arm.X, left_upper_arm.Y)
						left_upper_arm_outline["To"] = left_upper_arm_line["To"]
	
						local right_upper_arm, _ = wtvp(camera, character_parts["RightUpperArm"].Position) 
	
						local right_upper_arm_line = drawings[9]
						local right_upper_arm_outline = drawings[10]
	
						right_upper_arm_line["Visible"] = true
						right_upper_arm_outline["Visible"] = true
						right_upper_arm_line["From"] = torso_line["From"]
						right_upper_arm_outline["From"] = right_upper_arm_line["From"]
						right_upper_arm_line["To"] = vector2new(right_upper_arm.X, right_upper_arm.Y)
						right_upper_arm_outline["To"] = right_upper_arm_line["To"]
	
						local left_hand, _ = wtvp(camera, character_parts["LeftHand"].Position) 
	
						local left_hand_line = drawings[11]
						local left_hand_outline = drawings[12]
	
						left_hand_line["Visible"] = true
						left_hand_outline["Visible"] = true
						left_hand_line["From"] = left_upper_arm_line["To"]
						left_hand_outline["From"] = left_hand_line["From"]
						left_hand_line["To"] = vector2new(left_hand.X, left_hand.Y)
						left_hand_outline["To"] = left_hand_line["To"]
	
						local right_hand, _ = wtvp(camera, character_parts["RightHand"].Position) 
	
						local right_hand_line = drawings[13]
						local right_hand_outline = drawings[14]
	
						right_hand_line["Visible"] = true
						right_hand_outline["Visible"] = true
						right_hand_line["From"] = right_upper_arm_line["To"]
						right_hand_outline["From"] = right_hand_line["From"]
						right_hand_line["To"] = vector2new(right_hand.X, right_hand.Y)
						right_hand_outline["To"] = right_hand_line["To"]
	
						local left_upper_leg, _ = wtvp(camera, character_parts["LeftUpperLeg"].Position) 
	
						local left_upper_leg_line = drawings[15]
						local left_upper_leg_outline = drawings[16]
	
						left_upper_leg_line["Visible"] = true
						left_upper_leg_outline["Visible"] = true
						left_upper_leg_line["From"] = torso_line["To"]
						left_upper_leg_outline["From"] = left_upper_leg_line["From"]
						left_upper_leg_line["To"] = vector2new(left_upper_leg.X, left_upper_leg.Y)
						left_upper_leg_outline["To"] = left_upper_leg_line["To"]
	
						local right_upper_leg, _ = wtvp(camera, character_parts["RightUpperLeg"].Position) 
	
						local right_upper_leg_line = drawings[17]
						local right_upper_leg_outline = drawings[18]
	
						right_upper_leg_line["Visible"] = true
						right_upper_leg_outline["Visible"] = true
						right_upper_leg_line["From"] = torso_line["To"]
						right_upper_leg_outline["From"] = right_upper_leg_line["From"]
						right_upper_leg_line["To"] = vector2new(right_upper_leg.X, right_upper_leg.Y)
						right_upper_leg_outline["To"] = right_upper_leg_line["To"]
	
						local left_foot, _ = wtvp(camera, character_parts["LeftFoot"].Position) 
	
						local left_foot_line = drawings[19]
						local left_foot_outline = drawings[20]
	
						left_foot_line["Visible"] = true
						left_foot_outline["Visible"] = true
						left_foot_line["From"] = left_upper_leg_line["To"]
						left_foot_outline["From"] = left_foot_line["From"]
						left_foot_line["To"] = vector2new(left_foot.X, left_foot.Y)
						left_foot_outline["To"] = left_foot_line["To"]
	
						local right_foot, _ = wtvp(camera, character_parts["RightFoot"].Position) 
	
						local right_foot_line = drawings[21]
						local right_foot_outline = drawings[22]
	
						right_foot_line["Visible"] = true
						right_foot_outline["Visible"] = true
						right_foot_line["From"] = right_upper_leg_line["To"]
						right_foot_outline["From"] = right_foot_line["From"]
						right_foot_line["To"] = vector2new(right_foot.X, right_foot.Y)
						right_foot_outline["To"] = right_foot_line["To"]

						local head, _ = wtvp(camera, character_parts["Head"].Position) 
	
						local head_line = drawings[23]
						local head_outline = drawings[24]
	
						head_line["Visible"] = true
						head_outline["Visible"] = true
						head_line["From"] = torso_line["From"]
						head_outline["From"] = head_line["From"]
						head_line["To"] = vector2new(head.X, head.Y)
						head_outline["To"] = head_line["To"]
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

	utility.newConnection(menu_references["fill_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_fill = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]
	
				if drawings then
					local box = drawings[25]
	
					if box then
						box["Visible"] = false
					end
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

	utility.newConnection(menu_references["weapon_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_name = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					drawings[4]["Visible"] = false
				end
			end
		end
	end), true)

	utility.newConnection(menu_references["skeleton_toggle"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		do_name = bool
		if not bool then
			for player, info in player_data do
				local drawings = info["drawings"]

				if drawings then
					for i = 1, 20 do
						drawings[4+i]["Visible"] = false
					end
				end
			end
		end
	end), true)
end

local auto_shoot_stopped = false

local doAimbot = LPH_NO_VIRTUALIZE(function(dt)
	local circle = aimbot.circle
	local circle_outline = aimbot.circle_outline
		local mouse_position = uis:GetMouseLocation()
		circle.Position = mouse_position
		circle_outline.Position = mouse_position
	local line = aimbot.line
	local line_outline = aimbot.line_outline
		line.Visible = false
		line_outline.Visible = false
	local target = not flags["auto_select_target"] and aimbot.target or nil
		local aimbot_position = nil
	local tool = lplr_data["tool"]

	if (target or flags["auto_select_target"]) and flags["aimbot_keybind"]["active"] then
		target = flags["auto_select_target"] and getAimbotCandidate(mouse_position) or target
		local stop = false
		local check_screen = false
		local check_fov = false
		local check_visibility = false
		for _, check in flags["aim_checks"] do
			if check == "Tool equipped" and tool == nil then
				stop = true
				break;
			elseif check == "Target visible" then
				check_visibility = true
			elseif check == "On screen" then
				check_screen = true
			elseif check == "In fov" then
				check_fov = true
			end
		end
		if not stop and target then
			local character_parts = player_data[target].character_parts
			local part = flags["hitbox"][1]

			part = part == "Closest" and getClosestHitbox(mouse_position, character_parts) or character_parts[part]

			if not part or part.Transparency == 1 then
				aimbot.target_position = nil
				return end

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
					gradient_glow.CFrame = CFrame.new(character_parts["HumanoidRootPart"].CFrame.p)
				end
			end

			local velocity = vector3new()

			if flags["shake"] then
				local horizontal = flags["horizontal_shake"]
				local vertical = flags["vertical_shake"]
				velocity+=vector3new(mathrandom(1, horizontal+1)/(mathrandom(2) == 1 and -50 or 50), mathrandom(1, vertical+1)/(mathrandom(2) == 1 and -50 or 50), mathrandom(1, horizontal+1)/(mathrandom(2) == 1 and -50 or 50))
			end

			local part_position = part.Position
			if flags["multipoint"] then
				local cf = part.CFrame:PointToObjectSpace(mouse.Hit.p)
				local size = part.Size*(flags["multipoint_value"]/200)

				part_position = part.CFrame * vector3new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
			end

			part_position+=velocity

			local hrp = lplr_parts["HumanoidRootPart"]

			local pos, on_screen = wtvp(camera, part_position)

			if check_screen and not on_screen then
				aimbot.target_position = nil
				return 
			end

			local new_pos = vector2new(pos.X, pos.Y)

			local distance = new_pos-mouse_position

			if check_fov and distance.magnitude > aimbot.fov then
				aimbot.target_position = nil
				return 
			end

			if check_visibility then 
				local raycast_params = RaycastParams.new()
				raycast_params.IgnoreWater = true
				raycast_params.FilterDescendantsInstances = {char, target.Character}
				raycast_params.FilterType = Enum.RaycastFilterType.Exclude
	
				local ray_position = tool and tool.Handle.Pos or hrp.Position
				
				if raycast(workspace, ray_position, (part_position - ray_position).unit * (part_position - ray_position).magnitude, raycast_params) then
					aimbot.target_position = nil
					return 
				end
			end
			
			aimbot_position = part_position

			if flags["silent_aim"] and flags["max_curve"] then
				local world_position = mouse_position+((new_pos-mouse_position)*(flags["max_curve_value"]/100))
				local ray = camera:ViewportPointToRay(world_position.X, flags["dont_curve_y"] and mouse_position.Y or world_position.Y)
				aimbot_position = ray.Origin + ray.Direction * (ray.Origin-part_position).magnitude
			end

			if flags["position_line"] then
				local origin = flags["line_origin"][1] == "Mouse" and mouse_position or nil
				if not origin then
					local _pos, on_screen = wtvp(camera, hrp.Position)
					origin = on_screen and vector2new(_pos.X, _pos.Y) or nil
				end
				local _pos, on_screen = wtvp(camera, aimbot_position)
				local destination = on_screen and vector2new(_pos.X, _pos.Y) or nil
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

			if flags["mouse_aim"] and flags["mouse_aim_keybind"]["active"] then
				local ease_style = Enum.EasingStyle[flags["smoothing_style"][1]]
				local direction = Enum.EasingDirection[flags["smoothing_direction"][1]]
				mousemoverel(distance.X * getValue(tws, ((100.01-flags["horizontal_smoothness"])/100), ease_style, direction), distance.Y * getValue(tws, (100.01-flags["vertical_smoothness"])/100, ease_style, direction))	
			end
		end
	end
	if aimbot_position then
		last_aimbot_position = true
	elseif last_aimbot_position then
		last_aimbot_position = false
		line.Visible = false
		line_outline.Visible = false
	end
	if target ~= aimbot.target then
		aimbotTargetChange:Fire(target)
		aimbot.target = target
	end
	aimbot.target_position = aimbot_position
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
				highlight.Enabled = flags["highlight"]
			end
		end
	end
end), true)

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

local spinbot = LPH_NO_VIRTUALIZE(function(dt)
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	hrp.CFrame = (hrp.CFrame * angles(0,rad((flags["spinbot_speed"]*20)*dt),0))
end)

local last_auto_stomp = os.clock()

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
menu_references["spinbot_speed"]:setVisible(false)

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

utility.newConnection(menu_references["players_box"].onSelectionChange, function(selected)
	local player = plrs:FindFirstChild(selected or "")

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
	["Orange Sunset"] = {
		["SkyboxBk"] = "http://www.roblox.com/asset/?id=458016711",
		["SkyboxDn"] = "http://www.roblox.com/asset/?id=458016826",
		["SkyboxFt"] = "http://www.roblox.com/asset/?id=458016532",
		["SkyboxLf"] = "http://www.roblox.com/asset/?id=458016655",
		["SkyboxRt"] = "http://www.roblox.com/asset/?id=458016782",
		["SkyboxUp"] = "http://www.roblox.com/asset/?id=458016792",
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
	skyboxes["Default"][property] = lighting.Sky[property]
end

utility.newConnection(menu_references["world_skybox"].onDropdownChange, function(selected)
	if not flags["world_skybox"] then
		return end

	for property, value in skyboxes[selected[1]] do
		lighting.Sky[property] = value
	end
end, true)

utility.newConnection(menu_references["world_skybox"].onToggleChange, function(bool)
	if not bool then
		for property, value in skyboxes["Default"] do
			lighting.Sky[property] = value
		end
	else
		for property, value in skyboxes[flags["world_skybox_skybox"][1]] do
			lighting.Sky[property] = value
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

local doBacktrack = LPH_NO_VIRTUALIZE(function()
	for player, info in player_data do
		local last_update = info["last_backtrack_update"]
		local character = player.Character

		if not character or player.Team == lplr.Team or not info["visible"] then
			continue
		end

		local character_parts = info["character_parts"]

		local hrp = character_parts["HumanoidRootPart"]

		if not hrp then
			continue
		end

		if (hrp.Position-last_update).magnitude > 1.01 then
			local new_model = newObject("Model", {
				Parent = workspace.KnifeProjectiles
			})
			
			for _, part in part_list do
				local new_part = character_parts[part]

				if new_part then
					local new_part = new_part:Clone()
					new_part.Anchored = true
					new_part.CanCollide = false 
					new_part.Material = Enum.Material[flags["model_material"][1]]
					new_part.Color = flags["backtrack_color"]
					new_part.Transparency = flags["show_model"] and flags["backtrack_transparency"] or 1
					for _, z in new_part:GetChildren() do
						z:Destroy()
					end
					new_part.Parent = new_model
				end
			end

			new_model:SetAttribute("Player", player.Name)
			new_model.Name = "\255"
			new_model.Parent = workspace.KnifeProjectiles

			task.delay(flags["backtrack_delay"]/1000, function()
				new_model:Destroy()
			end)

			info["last_backtrack_update"] = hrp.Position
		end
	end
end)

utility.newConnection(menu_references["backtrack"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, doBacktrack) then
		remove(heartbeat_callbacks, doBacktrack)
	end
	if bool then
		insert(heartbeat_callbacks, doBacktrack)
	end
	menu_references["show_model"]:setVisible(bool)
	menu_references["model_material"]:setVisible(bool and flags["show_model"])
	menu_references["backtrack"]:changeSliderVisiblity(bool)
end, true)

menu_references["show_model"]:setVisible(false)
menu_references["model_material"]:setVisible(false)
menu_references["backtrack"]:changeSliderVisiblity(false)

utility.newConnection(menu_references["show_model"].onToggleChange, function(bool)
	menu_references["model_material"]:setVisible(bool and flags["backtrack"])
end, true)

local doTriggerbot = LPH_NO_VIRTUALIZE(function()
	local tool = lplr_data["tool"]
	local hrp = lplr_parts["HumanoidRootPart"]

	if not tool or not flags["triggerbot_keybind"]["active"] or not hrp then
		return end

	local target = mouse.Target

	if not target then
		return end

	local target = target.Parent

	if not find(flags["triggerbot_hitboxes"], target.Name) and target.ClassName ~= "Accessory" then
		return end

	local player = player_data[plrs:FindFirstChild(target.Parent.Name)]

	if not player then
		return end

	if not player["visible"] or player["team"] or (flags["ignore_dismiss"] and target.Material == Enum.Material.ForceField) then
		return end

	local last_delay = lplr_data["triggerbot_delay"]

	if os.clock()-last_delay < flags["triggerbot_delay"]/1000 then
		return end

	local raycast_params = RaycastParams.new()
	raycast_params.IgnoreWater = true;
	raycast_params.FilterDescendantsInstances = {character, char, target.Parent, camera}
	raycast_params.FilterType = Enum.RaycastFilterType.Exclude

	local ray_position = hrp.Position
	
	if raycast(workspace, ray_position, (target.Position-ray_position).unit * (target.Position-ray_position).magnitude, raycast_params) then
		return end

	mouse1click()
	lplr_data["triggerbot_delay"] = os.clock()
end)

utility.newConnection(menu_references["triggerbot"].onToggleChange, function(bool)
	if find(heartbeat_callbacks, doTriggerbot) then
		remove(heartbeat_callbacks, doTriggerbot)
	end
	if bool then
		insert(heartbeat_callbacks, doTriggerbot)
	end
	menu_references["triggerbot_delay"]:setVisible(bool)
	menu_references["ignore_dismiss"]:setVisible(bool)
	menu_references["triggerbot_hitboxes"]:setVisible(bool)
end)
menu_references["triggerbot_delay"]:setVisible(false)
menu_references["triggerbot_hitboxes"]:setVisible(false)
menu_references["ignore_dismiss"]:setVisible(false)

local data_ping = stats.Network.ServerStatsItem["Data Ping"]

local offsets = {
	vector2new(1,1),
	vector2new(-1,1),
	vector2new(1,-1),
	vector2new(-1,-1)
}	

local renderHitmarker = LPH_NO_VIRTUALIZE(function(is_2d, player)
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
		local position = player.Character["HumanoidRootPart"].Position
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
	local character = player.Character
	character.Archivable = true; local character_cloned = character:Clone()
	local all_parts = character_cloned:GetChildren()
	local material = Enum.Material[flags["hit_chams_material"][1]]
	local color = flags["hit_chams_color"]
	local transparency = flags["hit_chams_transparency"]
	local lifetime = flags["hit_chams_lifetime"]

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

	if flags["hit_chams_fade"] then
		for i = 1, #all_parts do
			tween(all_parts[i], newtweeninfo(lifetime, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Transparency = 1})
		end
	end

	task.delay(lifetime, function()
		character_cloned:Destroy()
	end)

	character_cloned.Parent = workspace.KnifeProjectiles
end)

local particle_part = newObject("Part", {
	Size = vector3new(1,1,1),
	Transparency = 1,
	CanCollide = false,
	Anchored = true,
	Parent = workspace.KnifeProjectiles
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
	local hit_effect = hit_effects[flags["hit_effect_effect"][1]]
	local hrp = player.Character.HumanoidRootPart
	particle_part.CFrame = hrp.CFrame
	for _, particle in hit_effect[1] do
		local particle = particle_part[particle]
		particle.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, flags["hit_effect_color"]), ColorSequenceKeypoint.new(1.00, flags["hit_effect_color"])}
		particle:Emit(hit_effect[2])
	end
end)

local hitsounds = {RIFK7 = "rbxassetid://9102080552", Bubble = "rbxassetid://9102092728", Minecraft = "rbxassetid://5869422451", Cod = "rbxassetid://160432334", Bameware = "rbxassetid://6565367558", Neverlose = "rbxassetid://6565370984", Gamesense = "rbxassetid://4817809188", Rust = "rbxassetid://6565371338"}

utility.newConnection(reps.Remotes.OnPlayerKilled.OnClientEvent, LPH_JIT(function(player, killer)
	local data = player_data[player]
	if data then
		data["visible"] = false
		if aimbot.target == player then
			aimbot.target = nil
			aimbotTargetChange:Fire(nil)
		end
	end
	if killer == lplr then
		lplrHitPlayer:Fire(player)
	end
end), true)

utility.newConnection(lplrHitPlayer, LPH_JIT(function(player)
	local data = player_data[player]
	local character = data["character"]

	if not character then
		return end

	if flags["hitmarker"] then
		local is_2d = flags["hitmarker_style"][1] == "2D"
		_spawn(renderHitmarker, is_2d, player)
	end
	if flags["notifications"] and find(flags["notifications_selected"], "Hits") then
		_spawn(newNotification, "hit "..player.Name.." (@"..player.DisplayName..")", flags["notification_style"][1])
	end
	if flags["hitsound"] then
		local hitsound = flags["hitsound_sound"][1]
		newObject("Sound", {
			Volume = flags["hitsound_volume"];
			PlayOnRemove = true;
			SoundId = hitsound == "Custom" and (isfile(flags["custom_id"]) and getcustomasset(flags["custom_id"], false) or flags["custom_id"]) or hitsounds[flags["hitsound_sound"][1]];
			Parent = gethui()
		}):Destroy()
	end
	if flags["hit_chams"] then
		_spawn(renderHitCham, player)
	end
	if flags["hit_effect"] then
		_spawn(renderHitEffect, player)
	end
end), true)

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