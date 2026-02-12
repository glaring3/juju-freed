-----------------------------------
-- * Service & Cache Variables * --
-----------------------------------

local uis = game:GetService("UserInputService")
local tws = game:GetService("TweenService")
local hs = game:GetService("HttpService")
local plrs = game:GetService("Players")
local ts = game:GetService("TextService")
local hs = game:GetService("HttpService")
local cg = game:GetService("CoreGui")
local rs = game:GetService("RunService")
local stats = game:GetService("Stats")
local lighting = game:GetService("Lighting")
local server_stats_item = stats.Network.ServerStatsItem

local mouseButton1 = Enum.UserInputType.MouseButton1
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
local match = string.match
local upper = string.upper

local angles = CFrame.Angles
local rad = math.rad
local lower = string.lower
local mathrandom = math.random
local getinfo = debug.getinfo
local rpg_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/rpg_warning.png")
local line_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/line.png")
local health_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/healthbar.png")
local ammo_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/ammobar.png")

local lplr = plrs.LocalPlayer
	local lplr_gui = lplr.PlayerGui
		local main_gui = lplr_gui:WaitForChild("MainScreenGui")
		local crosshair = main_gui:FindFirstChild("Aim")
	local mouse = lplr:GetMouse()
	local char = lplr.Character
	local lplr_parts = {}
	local lplr_data = {
		crew = nil,
		gun = nil,
		position_body = nil,
		viewing = nil,
		cframe_body = nil
	}

local player_data = {}

local camera = workspace.CurrentCamera

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

		utility.newConnection(object.InputBegan, function(input, gpe)
			if gpe then return end
			if input.UserInputType == mouseButton1 and not utility.is_dragging_blocked then
				local mouse_location = uis:GetMouseLocation()
				local startPosX = mouse_location.X
				local startPosY = mouse_location.Y
				local objPosX = object.Position.X.Offset
				local objPosY = object.Position.Y.Offset
				dragging = true
				task.spawn(function()
					while dragging and not utility.is_dragging_blocked do
						mouse_location = uis:GetMouseLocation()
						object.Position = udim2new(0, objPosX - (startPosX - mouse_location.X), 0, objPosY - (startPosY - mouse_location.Y))
						task.wait()
					end
				end)
			end
		end)

		utility.newConnection(object.InputEnded, function(input, gpe)
			if gpe then return end
			if input.UserInputType == mouseButton1 then
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

		object.Name = properties["Name"] or hs:GenerateGUID(false)

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
		task.spawn(callback, ...)
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

function utility.saveConfig(name)
	local new_flags = utility.copyTable(flags)
	for flag, info in new_flags do
		if typeof(info) == "Color3" then
			new_flags[flag] = {utility.round(info.R*255, 0), utility.round(info.G*255, 0), utility.round(info.B*255, 0)}
		elseif typeof(info) == "table" and info["key"] then
			new_flags[flag]["key"] = info["key"].Name
		end
	end
	writefile(config_location.."/configs/"..name..".cfg", hs:JSONEncode(new_flags))
end

function utility.loadConfig(name)
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
					config[flag]["key"] = Enum.KeyCode[info["key"]] or Enum.UserInputType[info["key"]]
				end
			end
			menu.flags[flag] = config[flag]
		end
	end

	menu.on_load:Fire()
end

function utility.getConfigList()
	local list = {}
	for _, config in listfiles(config_location.."/configs/") do
		utility.insert(list, string.sub(config, #`{config_location.."/configs/"}`+1, #config-4))
	end
	return list
end

local _screenGui = nil

do
	local shortened_characters = {
		[Enum.KeyCode.LeftShift] = "LSHF",
		[Enum.KeyCode.RightShift] = "RSHF",
		[Enum.UserInputType.MouseButton1] = "M1",
		[Enum.UserInputType.MouseButton2] = "M2",
		[Enum.UserInputType.MouseButton3] = "M3",
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
				if input.UserInputType == mouseButton1 then
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_sat then
			dragging_sat = false
			mouse_connection:Disconnect()
		end
	end)

	utility.newConnection(HueFrame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_hue then
			dragging_hue = false
			mouse_connection:Disconnect()
		end
	end)

	utility.newConnection(TransparencyFrame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_trans then
			dragging_trans = false
			mouse_connection:Disconnect()
		end
	end)

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
			if input.UserInputType == mouseButton1 and not menu.busy then
				local startPosition = uis:GetMouseLocation()
				local oldSize = Border.Size
				isDragging = true
				utility.is_dragging_blocked = true
				task.spawn(function()
					while isDragging do
						local change = uis:GetMouseLocation()-(Border.AbsolutePosition + Border.AbsoluteSize + vector2new(0,36))
						Border.Size = udim2new(0, clamp(oldSize.X.Offset + change.X, 658, 5000), 0, clamp(oldSize.Y.Offset + change.Y, 558, 5000))
						oldSize = Border.Size
						startPosition = (Border.AbsolutePosition + Border.AbsoluteSize)
						BottomGap.Size = udim2new(0, 73, 0, 22 + Border.Size.Y.Offset-558)
						BottomGap.Position = udim2new(0, 0, 1, -BottomGap.Size.Y.Offset)
						task.wait()
					end
				end)
			end
		end)	

		utility.newConnection(Dragger.InputEnded, function(input, gpe)
			if gpe then return end
			if input.UserInputType == mouseButton1 then
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
			tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Border2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Background, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(TabHolder, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopGap, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopSideFix, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopSideFix2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomGap, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomSideFix, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomSideFix2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopBar_2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(BlackBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Border2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Background, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(TabHolder, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopGap, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopSideFix, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopSideFix2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomGap, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomSideFix, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomSideFix2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopBar_2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(BlackBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
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
			tween(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(BottomBar2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(SideBar2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(SideBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopBar2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Icon, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			tween(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = self.active_tab == int and 1 or 0})
			tween(BottomBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(BottomBar2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(SideBar2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(SideBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopBar2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Icon, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
		end, true)

		utility.newConnection(Button.InputBegan, function(input, gpe)
			if gpe then return end
			local inputType = input.UserInputType
			if inputType == mouseButton1 then
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
			tween(_TopLine2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(_TopLine, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(ScrollBackground, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Scroller, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 1})
			tween(TopShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(BottomShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(ArrowUp, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
			tween(TopLine2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(TopLine, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(Inside3, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tween(SectionLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
			tween(DragImage, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			if not self.frame.Visible then return end
			tween(_TopLine2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(_TopLine, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Scroller, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = Scroller.ScrollingEnabled and 0 or 1})
			tween(TopShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(BottomShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(ArrowUp, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
			tween(TopLine2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(TopLine, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(Inside3, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
			tween(SectionLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
			tween(DragImage, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
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
				if input.UserInputType == mouseButton1 and not menu.busy then
					local mouseLocation = uis:GetMouseLocation()
					if not isDragging then
						isDragging = true
						Inside2.BackgroundColor3 = colorfromrgb(153, 196, 39)
						_TopLine.BackgroundColor3 = colorfromrgb(153, 196, 39)
						TopLine.BackgroundColor3 = colorfromrgb(153, 196, 39)
						DragImage.ImageColor3 = colorfromrgb(153, 196, 39)
						utility.is_dragging_blocked = true
						task.spawn(function()
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
								task.wait()
							end
						end)
					end
				end
			end)

			utility.newConnection(Section.InputBegan, function(input, gpe)
				if gpe then return end
				if input.UserInputType == mouseButton1 then
					local absolutePosition = SectionLabel.AbsolutePosition
					local mouseLocation = uis:GetMouseLocation()
					if mouseLocation.Y - absolutePosition.Y < 52 then
						isMoving = true
						utility.is_dragging_blocked = true
						SectionLabel.TextColor3 = colorfromrgb(153, 196, 39)

						task.spawn(function()
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
								task.wait()
							end
						end)
					end
				end
			end)

			utility.newConnection(DragImage.InputEnded, function(input, gpe)
				if gpe then return end
				if input.UserInputType == mouseButton1 then
					if isDragging then isDragging = false; utility.is_dragging_blocked = false; Inside2.BackgroundColor3 = colorfromrgb(40,40,40); TopLine.BackgroundColor3 = colorfromrgb(40,40,40); _TopLine.BackgroundColor3 = colorfromrgb(40, 40, 40); DragImage.ImageColor3 = colorfromrgb(40, 40, 40) end
				end
			end)

			utility.newConnection(Section.InputEnded, function(input, gpe)
				if gpe then return end
				if input.UserInputType == mouseButton1 then
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
					tween(Box, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Box, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
				end, true)

				local h,s,v = colorfromrgb(153, 196, 39):ToHSV()

				new_element.onToggleChange = signal.new()

				new_element.toggled = false

				flags[_info.flag] = false

				local function onHover()
					Inside.BackgroundColor3 = new_element.toggled == true and Color3.fromHSV(h,s,v*1.1) or colorfromrgb(85,85,85)
				end

				local function onLeave()
					Inside.BackgroundColor3 = new_element.toggled == true and colorfromrgb(153, 196, 39) or colorfromrgb(77,77,77)
				end

				local function onClick(input, gpe)
					if gpe then return end
					if input.UserInputType == mouseButton1 then
						new_element:setToggle(not new_element.toggled)
					end
				end

				local last_bool = _info.default

				function new_element:setToggle(bool, dont)
					if last_bool ~= bool or dont then
						new_element.onToggleChange:Fire(bool)
					end
					last_bool = bool
					Inside.BackgroundColor3 = bool and colorfromrgb(153, 196, 39) or colorfromrgb(77,77,77)
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

					isOpen = false
					menu.busy = false
					utility.is_dragging_blocked = false

					if isOnBorder then onHover() else onLeave() end
				end

				local function openDropdown()
					local newPosition = Border.AbsolutePosition
					DropdownOpen.Size = udim2new(0, Border.AbsoluteSize.X, 0, 20)
					DropdownOpen.Position = udim2new(0, newPosition.X, 0, newPosition.Y + 2 + Border.AbsoluteSize.Y)
					DropdownOpen.Visible = true

					clickOutConnection = utility.newConnection(uis.InputBegan, function(input, gpe)
						if gpe then return end
						if input.UserInputType == mouseButton1 then
							local pos = input.Position
							if not isInFrame(Border, pos) and not isInFrame(DropdownOpen, pos) then closeDropdown() end
						end
					end, true)

					isOpen = true; menu.busy = true; utility.is_dragging_blocked = true
				end

				function new_element:setSelected(options)
					local string = ""
					for _, label in OpenInside:GetChildren() do
						if label.ClassName ~= "TextLabel" then continue end
						local option = label.Name
						if find(options, option) then
							string = #string == 0 and option or string..", "..option
							label.Font = Enum.Font.SourceSansBold
							label.TextColor3 = colorfromrgb(153, 196, 39)
						else
							label.Font = Enum.Font.SourceSans
							label.TextColor3 = colorfromrgb(208, 208, 208)
						end
					end
					DropdownLabel.Text = string == "" and "-" or string
					new_element.onDropdownChange:Fire(options)
					flags[_info.flag] = options
				end

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
								if input.UserInputType == mouseButton1 then
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
								if input.UserInputType == mouseButton1 then
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
					tween(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(_Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(DropdownLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
					if isOpen then closeDropdown() end
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(_Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(DropdownLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
				end, true)

				utility.newConnection(Border.MouseEnter, onHover)
				utility.newConnection(Border.MouseLeave, onLeave)

				utility.newConnection(Border.InputEnded, function(input, gpe)
					if gpe then return end
					if input.UserInputType == mouseButton1 then
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
					BackgroundColor3 = colorfromrgb(153, 196, 39);
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
				local ValueLabel = newObject("TextLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -1, 0, 5);
					Font = Enum.Font.SourceSansBold;
					Text = _info.prefix.._info.min.._info.suffix;
					TextColor3 = colorfromrgb(205, 205, 205);
					TextSize = 13.000;
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
					Visible = false;
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
					Visible = true;
					Parent = Border
				})

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
					flags[_info.flag] = value
					if _info.changers then
						Down.Visible = value > _info.min
						Up.Visible = value < _info.max
					end 
					new_element.onSliderChange:Fire(value)		
				end

				if _info.changers then
					utility.newConnection(Down.InputBegan, function(input)
						if input.UserInputType == mouseButton1 then
							new_element:setValue(flags[_info.flag]-_info.changers)
						end
					end)

					utility.newConnection(Up.InputBegan, function(input)
						if input.UserInputType == mouseButton1 then
							new_element:setValue(flags[_info.flag]+_info.changers)
						end
					end)
				end

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Fill, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(ValueLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
					tween(Down, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
					tween(Up, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
					if dragging then
						utility.is_dragging_blocked = false 
						dragging = false
					end
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Fill, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(ValueLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
					tween(Down, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
					tween(Up, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
				end, true)

				utility.newConnection(Inside.InputBegan, function(input)
					if input.UserInputType == mouseButton1 and not menu.busy then
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
					if input.UserInputType == mouseButton1 and dragging then
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

					isOpen = false; menu.busy = false; utility.is_dragging_blocked = false
				end

				local function openColorpicker()
					local newPosition = ColorBox.AbsolutePosition
					ColorpickerOpen.Position = udim2new(0, newPosition.X, 0, newPosition.Y + 2 + ColorBox.AbsoluteSize.Y)
					ColorpickerOpen.Visible = true

					menu.active_colorpicker = new_element

					new_element:setColor(flags[_info.flag], flags[_info.transparency_flag])

					clickOutConnection = utility.newConnection(uis.InputBegan, function(input, gpe)
						if gpe then return end
						if input.UserInputType == mouseButton1 then
							local pos = input.Position
							if not isInFrame(ColorBox, pos) and not isInFrame(ColorpickerOpen, pos) then closeColorpicker() end
						end
					end, true)

					isOpen = true; menu.busy = true; utility.is_dragging_blocked = true
				end

				utility.newConnection(ColorBox.InputEnded, function(input, gpe)
					if gpe then return end
					if input.UserInputType == mouseButton1 then
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
					tween(ColorBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(ColorBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
				end, true)

				function new_element:setColor(color, transparency, no_move)
					if menu.active_colorpicker ~= new_element or no_move then
						flags[_info.flag] = color
						flags[_info.transparency_flag] = transparency
						Inside.BackgroundColor3 = color
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
					tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside3, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(ButtonLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Border, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside3, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(ButtonLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
				end, true)

				local function onHover()
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(36, 36, 36)), ColorSequenceKeypoint.new(1.00, colorfromrgb(41, 41, 41))};
				end

				local function onLeave()
					UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(31, 31, 31)), ColorSequenceKeypoint.new(1.00, colorfromrgb(36, 36, 36))};
				end

				utility.newConnection(Border.InputBegan, function(input, gpe)
					if gpe then return end
					if input.UserInputType == mouseButton1 then
						UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(26, 26, 26)), ColorSequenceKeypoint.new(1.00, colorfromrgb(31, 31, 31))};
					end
				end)

				utility.newConnection(Border.InputEnded, function(input, gpe)
					if gpe then return end
					if input.UserInputType == mouseButton1 then
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
					object.TextColor3 = colorfromrgb(153, 196, 39)
					if method == 1 and not just_visual then
						new_element:setActive(true)
					end
				end

				function new_element:setKey(keycode)
					task.wait()
					local old_keycode = flags[_info.flag]["key"]
					if old_keycode then
						local keybind = menu.keybinds[old_keycode]
						if keybind then
							if #keybind == 1 then
								menu.keybinds[old_keycode] = nil
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
					if keycode == nil then
						KeybindLabel.Text = "[-]"
						flags[_info.flag]["key"] = nil
						flags[_info.flag]["active"] = flags[_info.flag]["method"] == 1
						return
					end
					if menu.keybinds[keycode] then
						print(keycode, "inserted ?")
						utility.insert(menu.keybinds[keycode], {new_element, _info.flag})
					else
						menu.keybinds[keycode] = {{new_element, _info.flag}}
					end
					flags[_info.flag]["key"] = keycode
					local shortened = shortened_characters[keycode] and shortened_characters[keycode] or keycode.Name
					KeybindLabel.Text = `[{string.upper(shortened)}]`
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
					task.wait()
					KeybindLabel.TextColor3 = colorfromrgb(200,0,0)
					keyListenConnection = utility.newConnection(uis.InputBegan, function(input, gpe)
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
					end, true)
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

						clickOutConnection = utility.newConnection(uis.InputBegan, function(input, gpe)
							if gpe then return end
							if input.UserInputType == mouseButton1 then
								local pos = input.Position
								if not isInFrame(KeybindLabel, pos) and not isInFrame(KeybindOpen, pos) then closeKeybind() end
							end
						end, true)

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
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not menu.busy then
							startKeybind()
						end
					end
				end)

				utility.newConnection(menu.on_closing, function()
					if not tab_frame.Visible then return end
					tween(KeybindLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1, TextStrokeTransparency = 1})
					if isOpen then closeKeybind() end
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(KeybindLabel, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0, TextStrokeTransparency = 0})
				end, true)

				utility.newConnection(KeybindLabel.MouseEnter, onHover)
				utility.newConnection(KeybindLabel.MouseLeave, onLeave)

				utility.newConnection(menu.on_load, function()
					new_element:setKey(flags[_info.flag]["key"])
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
						TextBox.TextColor3 = colorfromrgb(153, 196, 39);
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
						tween(Search, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(SearchInside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(SearchInside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(TextBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
						tween(ScrollBackground, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(BottomShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(TopShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowUp, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Scroller, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 1})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
							end
						end
					end, true)

					utility.newConnection(menu.on_opening, function()
						if not tab_frame.Visible then return end
						tween(Search, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(SearchInside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(SearchInside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(TextBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
						tween(ScrollBackground, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(BottomShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(TopShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(ArrowUp, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Scroller, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 0})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
							end
						end
					end, true)
				else
					utility.newConnection(menu.on_closing, function()
						if not tab_frame.Visible then return end
						tween(ScrollBackground, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(BottomShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(TopShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(ArrowUp, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 1})
						tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
						tween(Scroller, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 1})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
							end
						end
					end, true)

					utility.newConnection(menu.on_opening, function()
						if not tab_frame.Visible then return end
						tween(ScrollBackground, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(BottomShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(TopShadow, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(ArrowUp, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0})
						tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
						tween(Scroller, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ScrollBarImageTransparency = 0})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
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

				function new_element:setSelected(text)
					text = text or ""
					if new_element.selected_option == text then
						return end

					local old_option = new_element.selected_option and OptionHolder:FindFirstChild(new_element.selected_option) or nil

					if old_option then
						old_option.Font = Enum.Font.SourceSans
						old_option.TextColor3 = colorfromrgb(208, 208, 208)
					end

					local option = OptionHolder:FindFirstChild(text)

					if not option then
						new_element.selected_option = nil
						return
					end

					new_element.selected_option = text

					new_element.onSelectionChange:Fire(text)

					option.Font = Enum.Font.SourceSansBold
					option.TextColor3 = colorfromrgb(153, 196, 39)
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
						if input.UserInputType == mouseButton1 then
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
					TextBox.TextColor3 = colorfromrgb(153, 196, 39);
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
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(Inside3, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					tween(TextBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1})
				end, true)

				utility.newConnection(menu.on_opening, function()
					if not tab_frame.Visible then return end
					tween(Inside, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(Inside3, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0})
					tween(TextBox, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0})
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

	utility.newConnection(uis.InputBegan, function(input, gpe)
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
	end)

	utility.newConnection(uis.InputEnded, function(input, gpe)
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
	end)
end

------------------------
-- * Game Functions * --
------------------------

local menu_references = {}

local event = game:GetService("ReplicatedStorage").MainEvent

local notifications = 0
local notification_removed = signal.new()

local shop_items = {}
local shop_ignore = {
    ["foodscart"] = true,
    ["flowers"] = true,
    ["antibodies"] = true,
    ["defaultmoveset"] = true,
    ["tele"] = true,
    ["key"] = true,
}

local function purchaseItem(name)
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp or lplr_data["force_cframe"] then
		return end

	setfflag("S2PhysicsSenderRate", "15")
	local shop = shop_items[name]
	local ammo = shop_items[name.."ammo"]
	local bought = false
	local ping = lplr_data["ping"]/1000
	local old_cf = hrp.CFrame

	for _, tool in lplr.Backpack:GetChildren() do
		if lower(tool.Name):find(name) then
			bought = true
			break
		end
	end

	if ammo and flags["purchase_ammo"] > 0 then
		if not bought then
			lplr_data["force_cframe"] = cframenew(shop[1].Position-vector3new(0,5.25,0))
			task.wait(ping*3)
			fireclickdetector(shop[2])
			task.wait(ping)
		end
		lplr_data["force_cframe"] = cframenew(ammo[1].Position-vector3new(0,5.25,0))
		task.wait(ping*3)
		for i = 1, flags["purchase_ammo"] do
			fireclickdetector(ammo[2])
			task.wait(0.7 + ping)
		end
		task.wait(ping*2)
	else
		lplr_data["force_cframe"] = cframenew(shop[1].Position-vector3new(0,5.25,0))
		task.wait(ping*3)
		fireclickdetector(shop[2])
		task.wait(ping*2)
	end

	lplr_data["force_cframe"] = old_cf

	task.delay(0.03, function()
		lplr_data["force_cframe"] = nil
		if flags["character_lag"] then
			setfflag("S2PhysicsSenderRate", tostring(15-flags["character_lag_amount"]))
		end
	end)
end

local function newNotification(text)
	notifications+=1

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
			ZIndex = 4;
			Font = 2
		}),
	}

	local x_size = drawings[4]["TextBounds"]["X"]+20
	local y = camera.ViewportSize.Y - (camera.ViewportSize.Y/6 + -35 + notifications*35)
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
			local y = camera.ViewportSize.Y - (camera.ViewportSize.Y/6 + -35 + (notification-1)*35)
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
			local tween_value = tws:GetValue((elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
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

	task.wait(1.5)

	local old_value = 1
	local value = 0
	local elapsed_time = 0
	local new_value = 0

	tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
		if elapsed_time < 0.22 then
			local tween_value = tws:GetValue((elapsed_time / 0.22), Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
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
			Data = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/line.png");
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

function keybinder:add(element, name, flag)
	local flag = flags[flag]
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
				Text = `[{flag["method"] == 1 and "always" or flag["method"] == 2 and "held" or flag["method"] == 3 and "toggle"}]`;
				Transparency = 0;
				Outline = true;
				Font = 2
			}),
		},
		active = flag["active"],
		tween_connection = nil,
		flag = flag
	}

	function keybind:show()
		if not flags["keybinds_list"] then
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
				new_value = old_value + ((value-old_value)*tws:GetValue((elapsed_time / 0.1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
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
	end

	function keybind:hide()
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
				new_value = old_value + ((value-old_value)*tws:GetValue((elapsed_time / 0.1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
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
	end

	function keybind:move(position)
		keybind.drawings[1].Position = keybinder.drawings[1].Position + vector2new(0, 12 + 16*position)
		keybind.drawings[2].Position = keybind.drawings[1].Position + vector2new(180 - keybind.drawings[2].TextBounds.X/2, 0)
	end

	insert(keybinder.all, keybind)

	if keybind.active then
		keybind:show()
	end

	utility.newConnection(element.onActiveChange, function(active)
		local do_show = flags["keybinds_list"]
		keybind.active = active

		if do_show then
			if active then
				keybind:show()
			else
				keybind:hide()
			end

			keybinder:refresh()
		end

		keybind.drawings[2]["Text"] = `[{flag["method"] == 1 and "always" or flag["method"] == 2 and "held" or flag["method"] == 3 and "toggle"}]`;
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
		if keybind.active then
			count+=1
			keybind:move(count)
		end
	end
	flags["keybind_position"] = {"A", position.X, position.Y}
end

function keybinder:close()
	if keybinder.tween_connection then
		keybinder.tween_connection:Disconnect()
	end
	local old_value = keybinder.drawings[1].Transparency
	local value = 0
	local elapsed_time = 0
	for _, keybind in keybinder.all do
		if keybind.drawings[1]["Transparency"] ~= 0 then
			keybind:hide()
		end
	end
	keybinder.tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
		if elapsed_time < 0.15 then
			new_value = old_value + ((value-old_value)*tws:GetValue((elapsed_time / 0.15), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
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
end

function keybinder:refresh()
	local count = 0
	for _, keybind in keybinder.all do
		if keybind.active then
			count+=1
			keybind:show()
			keybind:move(count)
		else
			keybind:hide()
		end
	end
	if count == 0 then
		keybinder:close()
	else
		keybinder:open()
	end
end

function keybinder:open()
	if keybinder.tween_connection then
		keybinder.tween_connection:Disconnect()
	end
	local old_value = keybinder.drawings[1].Transparency
	local value = 1
	local elapsed_time = 0
	local count = 0
	for _, keybind in keybinder.all do
		if keybind.active then
			count+=1
			keybind:show()
			keybind:move(count)
		end
	end
	keybinder.tween_connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
		if elapsed_time < 0.15 then
			new_value = old_value + ((value-old_value)*tws:GetValue((elapsed_time / 0.15), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
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
end

keybinder:move(camera.ViewportSize/2)
flags["keybind_position"] = {(camera.ViewportSize/2).X, (camera.ViewportSize/2).Y}

local rpg_indicators = {}
local hitmarker_indicators = {}

function utility.newRPGIndicator(rocket, pos)
	local indicator = {
		utility.newDrawing("Image", {
			Data = rpg_image,
			Color = colorfromrgb(255,255,255),
			ZIndex = 1
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 2,
			Text = "RPG",
			Color = colorfromrgb(255,255,255),
			Font = tonumber(flags["esp_font"][1])
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 2,
			Text = "23m away",
			Color = colorfromrgb(255,255,255),
			Font = tonumber(flags["esp_font"][1])
		}),
		rocket,
		pos,
		true,
		os.clock()
	}

	local connection = nil

	connection = utility.newConnection(rocket.AncestryChanged, function()
		connection:Disconnect()
		remove(rpg_indicators, indicator)
		indicator[1]:Destroy()
		indicator[2]:Destroy()
		indicator[3]:Destroy()
	end, true)

	insert(rpg_indicators, indicator)
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
	fov = 10
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
	["CFrame"] = cframenew()
}

local aimbotTargetChange = signal.new()
local onBulletFired = signal.new()
local lplrHitPlayer = signal.new()

local hitsounds = {RIFK7 = "rbxassetid://9102080552", Bubble = "rbxassetid://9102092728", Minecraft = "rbxassetid://5869422451", Cod = "rbxassetid://160432334", Bameware = "rbxassetid://6565367558", Neverlose = "rbxassetid://6565370984", Gamesense = "rbxassetid://4817809188", Rust = "rbxassetid://6565371338"}

local bounding_box_object = utility.newObject("SelectionBox", {
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

local function getAimbotCandidate(mouse_position)
	local closest = 9e9
	local candidate = nil
	local position = nil
	local hrp_position = lplr_parts["HumanoidRootPart"].Position
	local max_target_distance = flags["max_target_distance"]
	local checks = flags["target_checks"]
	for player, info in player_data do
		local character = info["character"]

		if not character or info["whitelisted"] then
			continue end

		local upperTorso = info.character_parts["UpperTorso"]

		if not upperTorso then
			continue end

		local pos, on_screen = camera:WorldToViewportPoint(upperTorso.Position)

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
			if check == "Knocked" and info["knocked"] then
				stop = true 
				break 
			elseif check == "Grabbed" and info["grabbed"] then
				stop = true
				break
			elseif check == "Crew" and info["crew"] == lplr_data["crew"] then
				stop = true
				break
			elseif check == "Visible" and #camera:GetPartsObscuringTarget({hrp_position, upperTorso.Position}, {character, char, camera, workspace.Ignored}) ~= 0 then
				break
			end
		end

		if stop then
			continue end

		if info["aimbot_priority"] then
			return candidate, position
		end

		if distance < closest then
			closest = distance
			candidate = player
			position = pos
		end
	end
	return candidate, position
end

local impact_clone = utility.newObject("Part", {
	CanCollide = false;
	Material = Enum.Material.Neon;
	Anchored = true
})
utility.newObject("SelectionBox", {
	LineThickness = 0.01;
	Transparency = 0;
	SurfaceTransparency = 1;
	Adornee = impact_clone;
	Visible = true;
	Name = "Outline";
	Parent = impact_clone
})

local beam_clone = utility.newObject("Beam", {
	Texture = "rbxassetid://446111271";
	TextureMode = Enum.TextureMode.Wrap;
	TextureLength = 10;
	LightEmission = 1;
	LightInfluence = 1;
	FaceCamera = true;
	ZOffset = -1;
	Enabled = true
})

local function getClosestHitbox(mouse_pos, character_parts)
	local closest = math.huge
	local closest_part = character_parts["HumanoidRootPart"]

	for i = 1, #part_list do
		local part_name = part_list[i]
		local part = character_parts[part_name]
		if not part then continue end
		local pos, on_screen = camera:WorldToViewportPoint(part.Position)
		if on_screen then
			local distance = (mouse_pos - vector2new(pos.X, pos.Y)).magnitude
			if distance < closest then
				closest = distance
				closest_part = part
			end
		end
	end

	return closest_part
end

----------------------
-- * Player Setup * --
----------------------

function utility.doCustomTween(data, property, value)
	local old_tween = data.tweens[property]

	if old_tween then
		old_tween:Disconnect()
	end

	local old_value = data[property]

	if property ~= "ammo" and abs(old_value-value) < 2 then
		data[property] = value
		return
	end

	local elapsed_time = 0
	local style = Enum.EasingStyle.Quad
	local direction = Enum.EasingDirection.Out
	local connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
        data[property] = old_value + ((value-old_value)*tws:GetValue((elapsed_time / 0.15), style, direction))
	end, true)
	data.tweens[property] = connection
	task.delay(0.15, function()
		if connection then
            data[property] = value
			connection:Disconnect()
		end
	end)
end

local function createESPObjects(player)
	local highlight = utility.newObject("Highlight", {
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
			Data = health_image,
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
			Data = ammo_image
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 3,
			Size = 14,
			Color = flags["number_color"],
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
			Data = health_image,
			Color = flags["armor_color"],
			Transparency = -flags["armor_transparency"]+1
		}),
		utility.newDrawing("Text", {
			Center = true,
			Outline = true,
			ZIndex = 3,
			Size = 14,
			Color = flags["ammo_number_color"],
			Transparency = -flags["ammo_number_transparency"]+1
		}),
	}, highlight
end

local function playerCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")

	if not humanoid then
		return end

	local player = plrs:FindFirstChild(character.Name)

	if not player then
		return end

	local body_effects = character:WaitForChild("BodyEffects")

	if not body_effects then
		return end

	local hrp = character:WaitForChild("HumanoidRootPart")

	local armor = body_effects:WaitForChild("Armor")
	local grabbed = body_effects:WaitForChild("Grabbed")
	local knocked = body_effects:WaitForChild("K.O")

	local data = player_data[player]

	data["character_parts"] = {}
	data["character"] = character
	data["tool"] = nil
	data["gun"] = false
	data["knocked"] = knocked.Value
	data["grabbed"] = grabbed.Value

	if lplr_data["viewing"] == player then
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
	utility.doCustomTween(data, "armor", armor.Value)	

	if aimbot.target == player then
		if flags["bounding_box"] then
			bounding_box_object.Adornee = character
		end
	end
	
	utility.newConnection(humanoid:GetPropertyChangedSignal("Health"), function()
		utility.doCustomTween(data, "health", humanoid.Health)
		if lplr_data["recently_shot"] then
			local remainder = old_health-humanoid.Health
			if remainder > 0 then
				lplrHitPlayer:Fire(player, floor(remainder))
			end
		end
		old_health = humanoid.Health
	end, true)

	utility.newConnection(grabbed:GetPropertyChangedSignal("Value"), function()
		data["grabbed"] = grabbed.Value
	end, true)

	utility.newConnection(knocked:GetPropertyChangedSignal("Value"), function()
		data["knocked"] = knocked.Value
		if aimbot.target == player and flags["untarget"][1] then
			aimbot.target = nil
			aimbotTargetChange:Fire(nil)
		end	
	end, true)

	utility.newConnection(armor:GetPropertyChangedSignal("Value"), function()
		utility.doCustomTween(data, "armor", armor.Value)
	end, true)

	utility.newConnection(character.ChildAdded, function(object)
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			data["tool"] = utility.removeBrackets(object.Name)
			if object:FindFirstChild("Ammo") then
				data["gun"] = true
				data["ammo"] = object.Ammo.Value
				data["max_ammo"] = object.MaxAmmo.Value

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
	end, true)

	utility.newConnection(character.ChildRemoved, function(object)
		data["character_parts"][object.Name] = nil
		if object.ClassName == "Tool" then
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
end

local function playerAdded(player)
	player_data[player] = {
		character = nil,
		highlight = nil,
		health = 0,
		ammo = 0,
		max_ammo = 0,
		armor = 0,
		tool = nil,
		gun = false,
		knocked = false,
		grabbed = false,
		crew = 0,
		character_parts = {},
		drawings = {},
		connections = {},
		forcefield = false,
		whitelisted = false,
		aimbot_priority = false,
		tweens = {}
	}

	utility.newConnection(player.CharacterAdded, playerCharacterAdded)

	if player.Character then
		playerCharacterAdded(player.Character)
	end

	if flags["esp"] then
		local drawings, highlight = createESPObjects(player)
		player_data[player]["drawings"] = drawings
		player_data[player]["highlight"] = highlight
	end

	menu_references["players_box"]:addOption(player.Name)

	local data_folder = player:WaitForChild("DataFolder", 60)
		if not data_folder then
			return end
		local information = data_folder:WaitForChild("Information", 5)
			if not information then
				return end
			local crew = information:WaitForChild("Crew", 5)

	if crew then
		player_data[player]["crew"] = crew.Value

		utility.newConnection(crew:GetPropertyChangedSignal("Value"), function()
			player_data[player]["crew"] = crew.Value
		end, true)
	end
end

local function playerRemoving(player)
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
end

utility.newConnection(plrs.PlayerAdded, playerAdded, true)
utility.newConnection(plrs.PlayerRemoving, playerRemoving, true)

----------------------
-- * Client Setup * --
----------------------

local function lplrCharacterAdded(character)
	char = character
	lplr_parts = {}

	local body_effects = character:WaitForChild("BodyEffects", 120)
	local firearmor = body_effects:WaitForChild("FireArmor", 120)
	local armor = body_effects:WaitForChild("Armor", 120)

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

			local ammo = object:FindFirstChild("Ammo")
			if ammo then
				local old_ammo_value = ammo.Value

				local gunType = getGunType(object.Name)
				lplr_data["gun"] = gunType
				if gunType ~= "Default" and not flags[`{gunType}_override_general`] then
					gunType = "Default"
				end
				aimbot["fov"] = flags[`{gunType}_field_of_view`]*3.33
				aimbot.circle.Radius = aimbot["fov"]
				aimbot.circle_outline.Radius = aimbot["fov"]
				activate_connection = utility.newConnection(object.Activated, function()
					local aim_location = aimbot.target_position
					if aim_location and flags["anti_aim_viewer"] then
						event:FireServer("UpdateMousePos", aim_location)
					end
				end, true)

				ammo_connection = utility.newConnection(object.Ammo:GetPropertyChangedSignal("Value"), function()
					if ammo.Value < old_ammo_value then
						lplr_data["recently_shot"] = true
						task.delay(0.03, function()
							lplr_data["recently_shot"] = false
						end)
						if flags["auto_reload"] then
							if ammo.Value == 0 then
								event:FireServer("Reload", object)
							end
						end
					end
					old_ammo_value = ammo.Value
				end, true)
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
			aimbot["fov"] = flags["Default_field_of_view"]*3.33
			aimbot.circle.Radius = aimbot["fov"]
			aimbot.circle_outline.Radius = aimbot["fov"]
		end
	end, true)

	utility.newConnection(humanoid:GetPropertyChangedSignal("MoveDirection"), function(direction)
		if humanoid.MoveDirection == vector3new() and flags["quick_stop"] then
			lplr_parts["HumanoidRootPart"].Velocity*=vector3new(0,1,0)
		end
	end, true)

	lplr_data["fire_armor"] = firearmor.Value

	utility.newConnection(firearmor:GetPropertyChangedSignal("Value"), function()
		lplr_data["fire_armor"] = firearmor.Value
		if flags["auto_fire_armor"] and firearmor.Value/130 < flags["fire_threshold"]/100 then
			purchaseItem("firearmor")
		end
	end, true)

	lplr_data["armor"] = armor.Value

	utility.newConnection(armor:GetPropertyChangedSignal("Value"), function()
		lplr_data["armor"] = armor.Value
		if flags["auto_armor"] and armor.Value/130 < flags["armor_threshold"]/100 then
			purchaseItem("high-mediumarmor")
		end
	end, true)

	if flags["spinbot"] then
		humanoid.AutoRotate = false
	end

	if flags["no_sit"] then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	end

	task.wait(1)

	lplr_gui = lplr.PlayerGui

	main_gui = lplr_gui:WaitForChild("MainScreenGui")
	crosshair = main_gui:FindFirstChild("Aim")

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
end

utility.newConnection(lplr.CharacterAdded, lplrCharacterAdded, true)

if lplr.Character then
	task.spawn(lplrCharacterAdded, lplr.Character)
end

task.spawn(function()
	local data_folder = lplr:WaitForChild("DataFolder")
		local information = data_folder:WaitForChild("Information")
			local crew = information:WaitForChild("Crew", 30)

	if crew then
		lplr_data["crew"] = crew.Value

		utility.newConnection(crew:GetPropertyChangedSignal("Value"), function()
			lplr_data["crew"] = crew.Value
		end, true)
	end
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

local anti_aim = window:getTab(2)
	local anti_lock_section = anti_aim:newSection({name = "Anti lock", is_changeable = true, scale = 0.5})
		menu_references["anti_lock"] = anti_lock_section:newElement({name = "Enabled", types = {toggle = {flag = "anti_lock"}, keybind = {flag = "anti_lock_keybind", method = 3}}}); keybinder:add(menu_references["anti_lock"], "Anti lock", "anti_lock_keybind")
		menu_references["anti_lock_style"] = anti_lock_section:newElement({name = "Style", types = {dropdown = {flag = "anti_lock_style", options = {"Multiplier", "Underground", "Random", "Zero", "Sky"}}}})
		menu_references["anti_lock_multiplier"] = anti_lock_section:newElement({name = "Multiplier amount", types = {slider = {flag = "anti_lock_multiplier", min = 0.1, max = 5, suffix = "x", decimal = 1, prefix = ""}}})
	local misc_section = anti_aim:newSection({name = "Misc", is_changeable = true, y = 0.5, scale = 0.5})
		menu_references["cframe_desync"] = misc_section:newElement({name = "CFrame desync", types = {toggle = {flag = "cframe_desync"}, keybind = {flag = "cframe_desync_keybind", method = 3}}}); keybinder:add(menu_references["cframe_desync"], "CFrame desync", "cframe_desync_keybind")
		menu_references["horizontal_offset"] = misc_section:newElement({name = "Horizontal offset", types = {slider = {flag = "horizontal_offset", suffix = "", prefix = "", min = 1, max = 50}}})
		menu_references["vertical_offset"] = misc_section:newElement({name = "Vertical offset", types = {slider = {flag = "vertical_offset", suffix = "", prefix = "", min = 1, max = 50}}})
		menu_references["cframe_randomization"] = misc_section:newElement({name = "Randomization", types = {slider = {flag = "cframe_randomization", suffix = "", prefix = "", min = 1, max = 50}}})
		menu_references["cframe_body"] = misc_section:newElement({name = "Position body", types = {toggle = {flag = "cframe_body"}, colorpicker = {flag = "cframe_body_color", transparency_flag = "cframe_body_transparency"}, dropdown = {flag = "cframe_body_material", no_none = true, default = {"ForceField"}, options = {"ForceField", "Neon"}}}})
		menu_references["character_lag"] = misc_section:newElement({name = "Character lag", types = {toggle = {flag = "character_lag"}}})
		menu_references["character_lag_amount"] = misc_section:newElement({name = "Lag amount", types = {slider = {flag = "character_lag_amount", min = 1, max = 14, suffix = "t", prefix = ""}}})
		menu_references["spinbot"] = misc_section:newElement({name = "Spinbot", types = {toggle = {flag = "spinbot"}}})
		menu_references["spinbot_speed"] = misc_section:newElement({name = "Spin speed", types = {slider = {flag = "spinbot_speed", min = 1, max = 100, suffix = "%", prefix = ""}}})
local legit = window:getTab(3)
	local aimbot_section = legit:newSection({name = "Aimbot", is_changeable = false, scale = 0.5})
		menu_references["aimbot_toggle"] = aimbot_section:newElement({name = "Enabled", types = {toggle = {flag = "aimbot"}, keybind = {flag = "aimbot_keybind", method = 2}}}); keybinder:add(menu_references["aimbot_toggle"], "Aimbot", "aimbot_keybind")
		menu_references["silent_aim"] = aimbot_section:newElement({name = "Silent aim", types = {toggle = {flag = "silent_aim"}}})
		menu_references["mouse_aim"] = aimbot_section:newElement({name = "Mouse aim", types = {toggle = {flag = "mouse_aim"}, keybind = {flag = "mouse_aim_keybind"}}}); keybinder:add(menu_references["mouse_aim"], "Mouse aim", "mouse_aim_keybind")
		menu_references["lock_bind"] = aimbot_section:newElement({name = "Lock bind", types = {keybind = {flag = "lock_bind", method = 3, method_locked = true}}})
		menu_references["mouse_tp"] = aimbot_section:newElement({name = "Mouse tp", types = {keybind = {flag = "mouse_tp_keybind", method = 3, method_locked = true}}})
		menu_references["shake"]  = aimbot_section:newElement({name = "Shake", types = {toggle = {flag = "shake"}}})
		menu_references["horizontal_shake"] = aimbot_section:newElement({name = "Horizontal shake", types = {slider = {flag = "horizontal_shake", min = 1, max = 100, prefix = "", suffix = "%", changers = 1}}})
		menu_references["vertical_shake"] = aimbot_section:newElement({name = "Vertical shake", types = {slider = {flag = "vertical_shake", min = 1, max = 100, prefix = "", suffix = "%", changers = 1}}})
		aimbot_section:newElement({name = "Max target distance", types = {slider = {flag = "max_target_distance", min = 50, max = 2500, suffix = "", prefix = "", changers = 1}}})
		aimbot_section:newElement({name = "Horizontal smoothness", types = {slider = {flag = "horizontal_smoothness", min = 1, max = 100, prefix = "", suffix = "%", changers = 1}}})
		aimbot_section:newElement({name = "Vertical smoothness", types = {slider = {flag = "vertical_smoothness", min = 1, max = 100, prefix = "", suffix = "%", changers = 1}}})
		aimbot_section:newElement({name = "Smoothing style", types = {dropdown = {flag = "smoothing_style", no_none = true, default = {"Linear"}, options = {"Linear", "Circular", "Sine", "Quad"}}}})
		aimbot_section:newElement({name = "Target checks", types = {dropdown = {flag = "target_checks", multi = true, options = {"Grabbed", "Knocked", "Visible", "Crew"}}}})
		aimbot_section:newElement({name = "Aim checks", types = {dropdown = {flag = "aim_checks", multi = true, options = {"Gun equipped", "Target visible", "Third person", "On screen", "In fov"}}}})
		aimbot_section:newElement({name = "Untarget", types = {dropdown = {flag = "untarget", options = {"Knocked"}}}})
	local gun_settings = legit:newSection({name = "Gun settings", is_changeable = false, scale = 0.3, y = 0.5})
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
					gun_settings:newElement({name = "Override general config", types = {toggle = {flag = `{gun}_override_general`}}}),
					gun_settings:newElement({name = "Horizontal prediction", types = {slider = {flag = `{gun}_horizontal_prediction`, min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Vertical prediction", types = {slider = {flag = `{gun}_vertical_prediction`, min = 0, decimal = 3, max = 0.4, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Field of view", types = {slider = {flag = `{gun}_field_of_view`, min = 5, max = 100, default = 15, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Air hitbox", types = {dropdown = {flag = `{gun}_air_hitbox`, no_none = true, default = {"LowerTorso"}, options = {"Head", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Hitbox", types = {dropdown = {flag = `{gun}_hitbox`, no_none = true, default = {"Head"}, options = {"Head", "UpperTorso", "LowerTorso", "Closest"}}}})
				}
				utility.newConnection(_["settings"][4].onSliderChange, function(value)
					if lplr_data["gun"] == gun and flags[`{gun}_override_general`] then
						aimbot["fov"] = value*3.33
						aimbot.circle.Radius = aimbot["fov"]
						aimbot.circle_outline.Radius = aimbot["fov"]
					end
				end)
				utility.newConnection(_["settings"][1].onToggleChange, function(bool)
					local tool = lplr_data["gun"]
					if tool and tool == gun then
						aimbot["fov"] = bool and flags[`{gun}_field_of_view`]*3.33 or flags["Default_field_of_view"]*3.33
						aimbot.circle.Radius = aimbot["fov"]
						aimbot.circle_outline.Radius = aimbot["fov"]
					end
				end)
			else
				_["settings"] = {
					gun_settings:newElement({name = "Horizontal prediction", types = {slider = {flag = `{gun}_horizontal_prediction`, min = 0, decimal = 3, max = 1, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Vertical prediction", types = {slider = {flag = `{gun}_vertical_prediction`, min = 0, decimal = 3, max = 1, min_text = "Auto", suffix = "", prefix = "", changers = 0.001}}}),
					gun_settings:newElement({name = "Field of view", types = {slider = {flag = `{gun}_field_of_view`, min = 5, max = 100, suffix = "°", prefix = "", changers = 1}}}),
					gun_settings:newElement({name = "Air hitbox", types = {dropdown = {flag = `{gun}_air_hitbox`, no_none = true, default = {"LowerTorso"}, options = {"Head", "UpperTorso", "LowerTorso", "Closest"}}}}),
					gun_settings:newElement({name = "Hitbox", types = {dropdown = {flag = `{gun}_hitbox`, no_none = true, default = {"Head"}, options = {"Head", "UpperTorso", "LowerTorso", "Closest"}}}})
				}
				utility.newConnection(_["settings"][3].onSliderChange, function(value)
					local gun = lplr_data["gun"]
					if gun == "Default" or not gun then
						aimbot["fov"] = value*3.33
						aimbot.circle.Radius = aimbot["fov"]
						aimbot.circle_outline.Radius = aimbot["fov"]
					end
				end)
			end
		end
		updateGunTab({"Default"})
		utility.newConnection(menu_references["selected_gun"].onDropdownChange, updateGunTab, true)
	local aimbot_visualization = legit:newSection({name = "Aimbot visualization", is_changeable = false, scale = 0.4, x = 0.5})
		menu_references["show_fov"] = aimbot_visualization:newElement({name = "Show fov", types = {toggle = {default = true, flag = "show_fov"}, colorpicker = {flag = "fov_color", transparency_flag = "fov_transparency"}}})
		menu_references["active_color"] = aimbot_visualization:newElement({name = "Active color", types = {colorpicker = {flag = "active_color", transparency_flag = "active_transparency"}}})
		menu_references["position_line"] = aimbot_visualization:newElement({name = "Position line", types = {toggle = {flag = "position_line"}, colorpicker = {flag = "line_color", transparency_flag = "line_transparency"}}})
		menu_references["line_origin"] = aimbot_visualization:newElement({name = "Origin", types = {dropdown = {flag = "line_origin", options = {"Character", "Mouse"}, default = {"Character"}, no_none = true}}})
		menu_references["line_position"] = aimbot_visualization:newElement({name = "Position", types = {dropdown = {flag = "line_position", options = {"Predicted position", "Character position"}, default = {"Character position"}, no_none = true}}})
		menu_references["position_body"] = aimbot_visualization:newElement({name = "Position body", types = {toggle = {flag = "position_body"}, colorpicker = {flag = "position_body_color", transparency_flag = "position_body_transparency"}, dropdown = {flag = "position_body_material", no_none = true, options = {"ForceField", "Neon"}, default = {"ForceField"}}}})
		menu_references["bounding_box"] = aimbot_visualization:newElement({name = "Bounding box", types = {toggle = {flag = "bounding_box"}, colorpicker = {flag = "bounding_box_color", transparency_flag = "bounding_box_transparency"}}})
		menu_references["bounding_box_filled"] = aimbot_visualization:newElement({name = "Filled", types = {toggle = {flag = "bounding_box_filled"}}})
	local aimbot_settings = legit:newSection({name = "Settings", is_changeable = false, scale = 0.2, y = 0.8})
		aimbot_settings:newElement({name = "Anti aim viewer", types = {toggle = {flag = "anti_aim_viewer"}}})
		menu_references["resolver"] = aimbot_settings:newElement({name = "Resolver", types = {toggle = {flag = "resolver"}}})
		menu_references["resolver_refresh"] = aimbot_settings:newElement({name = "Refresh rate", types = {slider = {flag = "resolver_refresh", min = 1, max = 200, prefix = "", suffix = "ms", changers = 1}}})
local visuals = window:getTab(4)
	local player_esp_section = visuals:newSection({name = "Player ESP", is_changeable = true, scale = 0.6})
		menu_references["esp_toggle"] = player_esp_section:newElement({name = "Enabled", types = {toggle = {flag = "esp"}}})
		menu_references["box_toggle"] = player_esp_section:newElement({name = "Box", types = {toggle = {flag = "box"}, colorpicker = {flag = "box_color", transparency_flag = "box_transparency"}}})
		menu_references["fill_toggle"] = player_esp_section:newElement({name = "Filled", types = {toggle = {flag = "box_fill"}}})
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
		menu_references["ammo_number"] = player_esp_section:newElement({name = "Ammo number", types = {toggle = {flag = "ammo_number"}, colorpicker = {flag = "ammo_number_color", default = colorfromrgb(76,76,76), transparency_flag = "ammo_number_transparency"}}})
		menu_references["ammo_number_size"] = player_esp_section:newElement({name = "Size", types = {slider = {flag = "ammo_number_size", min = 10, max = 24, default = 14, decimal = 0, prefix = "", suffix = "px"}}})
		menu_references["esp_font"] = player_esp_section:newElement({name = "Text font", types = {dropdown = {flag = "esp_font", no_none = true, default = {"2"}, options = {"1", "2", "3"}}}})
	local self_esp_section = visuals:newSection({name = "Self ESP", is_changeable = true, y = 0.6, scale = 0.4})
		menu_references["forcefield_tools"] = self_esp_section:newElement({name = "Forcefield tools", types = {toggle = {flag = "forcefield_tools"}, colorpicker = {flag = "forcefield_tools_color", transparency_flag = "forcefield_tools_transparency"}}})
		menu_references["forcefield_body"] = self_esp_section:newElement({name = "Forcefield body", types = {toggle = {flag = "forcefield_body"}, colorpicker = {flag = "forcefield_body_color", transparency_flag = "forcefield_body_transparency"}}})
		menu_references["forcefield_hats"] = self_esp_section:newElement({name = "Forcefield hats", types = {toggle = {flag = "forcefield_hats"}, colorpicker = {flag = "forcefield_hats_color", transparency_flag = "forcefield_hats_transparency"}}})
		menu_references["headless"] = self_esp_section:newElement({name = "Headless", types = {toggle = {flag = "headless"}}})
	local world_section = visuals:newSection({name = "World", is_changeable = true, x = 0.5, scale = 0.3})
		menu_references["world_brightness"] = world_section:newElement({name = "World brightness", types = {toggle = {flag = "world_brightness"}, slider = {flag = "world_brightness", prefix = "", suffix = "", min = 0, max = 5, decimal = 1, default = spoof_properties["Brightness"]}}})
		menu_references["remove_shadows"] = world_section:newElement({name = "Remove shadows", types = {toggle = {flag = "remove_shadows"}}})
		menu_references["world_exposure"] = world_section:newElement({name = "World exposure", types = {toggle = {flag = "world_exposure"}, slider = {flag = "world_exposure_value", prefix = "", suffix = "", min = -2, decimal = 1, max = 3, default = spoof_properties["ExposureCompensation"]}}})
		menu_references["world_ambient"] = world_section:newElement({name = "World ambient", types = {toggle = {flag = "world_ambient"}, colorpicker = {flag = "world_ambient_color", default = spoof_properties["Ambient"], transparency_flag = "world_ambient_transparency"}}})
		menu_references["world_skybox"] = world_section:newElement({name = "World skybox", types = {toggle = {flag = "world_skybox"}, dropdown = {flag = "world_skybox_skybox", no_none = true, default = {"Crimson Night"}, options = {"Crimson Night", "Orange Sunset", "Stormy Night", "Spongebob", "Snowy", "Retro"}}}})
		menu_references["world_time"] = world_section:newElement({name = "World time", types = {toggle = {flag = "world_time"}, slider = {flag = "world_time_value", prefix = "", suffix = "", min = 0, max = 24, decimal = 1, default = spoof_properties["ClockTime"]}}})
		menu_references["fog_changer"] = world_section:newElement({name = "World fog", types = {toggle = {flag = "fog_changer"}, colorpicker = {flag = "fog_color", transparency_flag = "fog_transparency", default = spoof_properties["FogColor"]}}})
		menu_references["fog_start"] = world_section:newElement({name = "Fog start", types = {slider = {flag = "fog_start", prefix = "", suffix = "", min = 1, max = 5000, default = spoof_properties["FogStart"]}}})
		menu_references["fog_end"] = world_section:newElement({name = "Fog end", types = {slider = {flag = "fog_end", prefix = "", suffix = "", min = 1, max = 5000, default = spoof_properties["FogEnd"]}}})
	local hud_section = visuals:newSection({name = "Hud", is_changeable = true, x = 0.5, y = 0.3, scale = 0.2})
		menu_references["spinning_crosshair"] = hud_section:newElement({name = "Spinning crosshair", types = {toggle = {flag = "spinning_crosshair"}, slider = {flag = "spinning_speed", min = 1, max = 100, suffix = "%", prefix = ""}}})
		menu_references["notifications_"] = hud_section:newElement({name = "Target notifications", types = {toggle = {flag = "notifications"}}})
		menu_references["hit_logs"] = hud_section:newElement({name = "Hit notifications", types = {toggle = {flag = "hit_logs"}}})
		utility.newConnection(hud_section:newElement({name = "Keybinds list", types = {toggle = {flag = "keybinds_list"}}}).onToggleChange, function(bool)
			if bool then
				keybinder:open()
			else
				keybinder:close()
			end
		end, true)
	local other_section = visuals:newSection({name = "Other", is_changeable = true, x = 0.5, y = 0.5, scale = 0.5})
		menu_references["rpg_warnings"] = other_section:newElement({name = "RPG warnings", types = {toggle = {flag = "rpg_warnings"}}})
		menu_references["local_bullet_impacts"] = other_section:newElement({name = "Local bullet impacts", types = {toggle = {flag = "local_bullet_impacts"}, colorpicker = {flag = "local_bullet_impacts_color", transparency_flag = "local_bullet_impacts_transparency"}}})
		menu_references["local_bullet_impacts_lifetime"] = other_section:newElement({name = "Impact lifetime", types = {slider = {flag = "local_bullet_impacts_lifetime", min = 0.1, max = 1.5, suffix = "s", decimal = 1, default = 0.5, prefix = ""}}})
		menu_references["local_bullet_impacts_size"] = other_section:newElement({name = "Impact size", types = {slider = {flag = "local_bullet_impacts_size", min = 0.1, max = 1, suffix = " studs", decimal = 1, default = 0.5, prefix = ""}}})
		menu_references["local_bullet_tracers"] = other_section:newElement({name = "Local bullet tracers", types = {toggle = {flag = "local_bullet_tracers"}, colorpicker = {flag = "local_bullet_tracers_color", transparency_flag = "local_bullet_tracers_transparency"}}})
		menu_references["local_bullet_tracers_lifetime"] = other_section:newElement({name = "Tracer lifetime", types = {slider = {flag = "local_bullet_tracers_lifetime", min = 0.1, max = 1.5, suffix = "s", decimal = 1, default = 0.5, prefix = ""}}})
		menu_references["enemy_bullet_tracers"] = other_section:newElement({name = "Enemy bullet tracers", types = {toggle = {flag = "enemy_bullet_tracers"}, colorpicker = {flag = "enemy_bullet_tracers_color", transparency_flag = "enemy_bullet_tracers_transparency"}}})
		menu_references["enemy_bullet_tracers_lifetime"] = other_section:newElement({name = "Tracer lifetime", types = {slider = {flag = "enemy_bullet_tracers_lifetime", min = 0.1, max = 1.5, suffix = "s", decimal = 1, default = 0.5, prefix = ""}}})
		menu_references["hit_effect"] = other_section:newElement({name = "Hit effect", types = {toggle = {flag = "hit_effect"}, colorpicker = {flag = "hit_effect_color", transparency_flag = "hit_effect_transparency"}, dropdown = {options = {"Bubble", "Sparks"}, flag = "hit_effect_effect", default = {"Bubble"}, no_none = true}}})
		menu_references["hit_chams"] = other_section:newElement({name = "Hit chams", types = {toggle = {flag = "hit_chams"}, dropdown = {options = {"ForceField", "Neon"}, flag = "hit_chams_material", default = {"ForceField"}, no_none = true}, colorpicker = {flag = "hit_chams_color", default = colorfromrgb(255,0,0), transparency_flag = "hit_chams_transparency"}}})
		menu_references["hit_chams_lifetime"] = other_section:newElement({name = "Chams lifetime", types = {slider = {flag = "hit_chams_lifetime", min = 0.1, max = 1.5, prefix = "", suffix = "s", decimal = 1}}})
		menu_references["hitmarker"] = other_section:newElement({name = "Hitmarker", types = {toggle = {flag = "hitmarker"}, colorpicker = {flag = "hitmarker_color", transparency_flag = "hitmarker_tranparency"}, dropdown = {options = {"2D", "3D"}, flag = "hitmarker_style", default = {"2D"}, no_none = true}}})
		menu_references["hitmarker_size"] = other_section:newElement({name = "Size", types = {slider = {flag = "hitmarker_size", min = 5, max = 30, suffix = "", decimal = 1, default = 10, prefix = ""}}})
		menu_references["hitmarker_gap"] = other_section:newElement({name = "Gap", types = {slider = {flag = "hitmarker_gap", min = 5, max = 30, suffix = "", decimal = 1, default = 10, prefix = ""}}})
		menu_references["hitsound"] = other_section:newElement({name = "Hitsound", types = {toggle = {flag = "hitsound"}, dropdown = {options = {"Minecraft", "Gamesense", "Neverlose", "Bameware", "Bubble", "RIFK7", "Rust", "Cod"}, flag = "hitsound_sound", default = {"Gamesense"}, no_none = true}}})
		menu_references["hitsound_volume"] = other_section:newElement({name = "Volume", types = {slider = {flag = "volume", min = 0.1, max = 5, suffix = "", decimal = 1, default = 1, prefix = ""}}})
local misc = window:getTab(5)
	local movement_section = misc:newSection({name = "Movement", is_changeable = false, scale = 0.5})
		movement_section:newElement({name = "No jump cooldown", types = {toggle = {flag = "no_jump_cooldown"}}})
		menu_references["cframe_speed"] = movement_section:newElement({name = "CFrame speed", types = {toggle = {flag = "cframe_speed"}, keybind = {flag = "cframe_speed_keybind", method = 2}}}); keybinder:add(menu_references["cframe_speed"], "CFrame speed", "cframe_speed_keybind")
		menu_references["cframe_speed_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_speed_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		movement_section:newElement({name = "No slowdown", types = {toggle = {flag = "no_slowdown"}}})
		menu_references["cframe_fly"] = movement_section:newElement({name = "CFrame fly", types = {toggle = {flag = "cframe_fly"}, keybind = {flag = "cframe_fly_keybind", method = 2}}}); keybinder:add(menu_references["cframe_fly"], "CFrame fly", "cframe_fly_keybind")
		menu_references["cframe_fly_speed"] = movement_section:newElement({name = "Speed", types = {slider = {flag = "cframe_fly_speed", min = 1, max = 100, suffix = "%", decimal = 0, default = 1, prefix = ""}}})
		movement_section:newElement({name = "Quick stop", types = {toggle = {flag = "quick_stop"}}})
		menu_references["noclip"] = movement_section:newElement({name = "Noclip", types = {toggle = {flag = "noclip"}}})
	local game_section = misc:newSection({name = "Game modifiers", is_changeable = true, y = 0.5, scale = 0.5})
		local flashbang_connection = nil
		local blur_connection = nil
		utility.newConnection(game_section:newElement({name = "No pepper spray blur", types = {toggle = {flag = "no_blur"}}}).onToggleChange, function(bool)
			if blur_connection then
				blur_connection:Disconnect()
			end
			if bool then
				blur_connection = utility.newConnection(lighting.PepperSprayBlur:GetPropertyChangedSignal("Enabled"), function()
					if lighting.PepperSprayBlur.Enabled then
						lighting.PepperSprayBlur.Enabled = false
					end
				end, true)
			end
		end, true)
		utility.newConnection(game_section:newElement({name = "Infinite zoom out", types = {toggle = {flag = "infinite_zoom_out"}}}).onToggleChange, function(bool)
			lplr.CameraMaxZoomDistance = bool and 9e9 or spoof_properties["CameraMaxZoomDistance"]
		end, true)
		utility.newConnection(game_section:newElement({name = "No flashbang", types = {toggle = {flag = "no_flashbang"}}}).onToggleChange, function(bool)
			if flashbang_connection then
				flashbang_connection:Disconnect()
			end
			if bool then
				flashbang_connection = utility.newConnection(main_gui.ChildAdded, function(object)
					if object.Name == "whiteScreen" then
						task.delay(0, function()
							object:Destroy()
						end)
					end
				end, true)
			end
		end, true)
		utility.newConnection(game_section:newElement({name = "No void kill", types = {toggle = {flag = "no_void_kill"}}}).onToggleChange, function(bool)
			workspace.FallenPartsDestroyHeight = bool and -9e9 or -500
		end, true)
		game_section:newElement({name = "No recoil", highlight = true, types = {toggle = {flag = "no_recoil"}}})
		utility.newConnection(game_section:newElement({name = "Show chat", types = {toggle = {flag = "show_chat"}}}).onToggleChange, function(bool)
			lplr_gui.Chat.Frame.ChatChannelParentFrame.Visible = bool
		end, true)
		utility.newConnection(game_section:newElement({name = "No sit", types = {toggle = {flag = "no_sit"}}}).onToggleChange, function(bool)
			local humanoid = lplr_parts["Humanoid"]

			if not humanoid then
				return end

			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not bool)
		end, true)	
	local utilities_section = misc:newSection({name = "Utilities", is_changeable = true, x = 0.5, scale = 1})
		menu_references["auto_fire_armor"] = utilities_section:newElement({name = "Auto fire armor", types = {toggle = {flag = "auto_fire_armor"}}})
		menu_references["fire_threshold"] = utilities_section:newElement({name = "Threshold", types = {slider = {min = 1, max = 100, suffix = "%", prefix = "", flag = "fire_threshold"}}})
		menu_references["auto_stomp"] = utilities_section:newElement({name = "Auto stomp", types = {toggle = {flag = "auto_stomp"}}})
		utilities_section:newElement({name = "Auto reload", types = {toggle = {flag = "auto_reload"}}})
		menu_references["auto_armor"] = utilities_section:newElement({name = "Auto armor", types = {toggle = {flag = "auto_armor"}}})
		menu_references["armor_threshold"] = utilities_section:newElement({name = "Threshold", types = {slider = {min = 1, max = 100, suffix = "%", prefix = "", flag = "armor_threshold"}}})
		menu_references["auto_shoot"] = utilities_section:newElement({name = "Auto shoot", types = {toggle = {flag = "auto_shoot"}, keybind = {flag = "auto_shoot_keybind"}}})
		menu_references["auto_sort"] = utilities_section:newElement({name = "Auto sort", types = {toggle = {flag = "auto_sort"}, keybind = {flag = "auto_sort_keybind", method = 3, method_locked = true}}})
		for i = 1, 9 do
			menu_references["slot_"..i] = utilities_section:newElement({name = "Slot "..i, types = {textbox = {flag = "slot_"..i}}})
		end
local skins_tab = window:getTab(6)
	local purchases_section = skins_tab:newSection({name = "Purchases", is_changeable = true, scale = 1})
		menu_references["purchases"] = purchases_section:newElement({name = "Purchases", types = {multibox = {max = 16, search = true}}})
		menu_references["ammo_"] = purchases_section:newElement({name = "Ammo", types = {slider = {min = 1, max = 20, suffix = "x", prefix = "", flag = "purchase_ammo"}}})
		purchases_section:newElement({name = "Purchase", types = {button = {text = "Purchase", callback = function()
			if not menu_references["purchases"].selected_option then
				return end

			task.spawn(purchaseItem, menu_references["purchases"].selected_option)
		end}}})
local players_tab = window:getTab(7)
	local players_section = players_tab:newSection({name = "Players", is_changeable = true, x = 0, scale = 1})
		menu_references["players_box"] = players_section:newElement({name = "_", types = {multibox = {max = 12, search = true}}})
		menu_references["aimbot_priority"] = players_section:newElement({name = "Aimbot priority", types = {toggle = {no_load = true, flag = "aimbot_priority"}}})
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
	local config_section = configuration:newSection({name = "Configs", is_changeable = false, scale = 1})
		local config_list = config_section:newElement({name = "Config list", types = {multibox = {max = 8, search = true}}})
		config_section:newElement({name = "Config name", types = {textbox = {no_load = true, flag = "config_name"}}})
		local save_config = config_section:newElement({name = "Save config", types = {button = {text = "Save config", 
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
		local load_config = config_section:newElement({name = "Load config", types = {button = {text = "Load config",
			callback = function()
				if config_list.selected_option then
					utility.loadConfig(config_list.selected_option)
					if flags["keybind_position"] then
						keybinder:move(vector2new(flags["keybind_position"][2], flags["keybind_position"][3]))
					end
				end
			end
		}}})
		local refresh_list = config_section:newElement({name = "Refresh list", types = {button = {text = "Refresh list",
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
	local menu_section = configuration:newSection({name = "Other", is_changeable = false, x = 0.5, scale = 1})
		utility.newConnection(menu_section:newElement({name = "Menu toggle key", types = {keybind = {flag = "menu_key", key = Enum.KeyCode.Insert, method = 2, method_locked = true}}}).onActiveChange, function()
			if flags["menu_key"]["key"] ~= nil then
				menu["toggle"] = upper(flags["menu_key"]["key"]["Name"])
			end
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
			end
		}}})
local move_connection = utility.newConnection(uis.InputBegan, function(input, gpe)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and flags["keybinds_list"] then
		if utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
			task.spawn(function()
				while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					task.wait()
					keybinder:move(uis:GetMouseLocation())
				end
			end)
		end
	end
end, true)

utility.newConnection(menu.on_opening, function()
	if move_connection then
		move_connection:Disconnect()
	end
	move_connection = utility.newConnection(uis.InputBegan, function(input, gpe)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and flags["keybinds_list"] then
			if utility.isInDrawing(keybinder.drawings[1], uis:GetMouseLocation()) then
				task.spawn(function()
					while uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						task.wait()
						keybinder:move(uis:GetMouseLocation())
					end
				end)
			end
		end
	end, true)
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

utility.newConnection(menu_references["highlight_outline"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.OutlineColor = color
			highlight.OutlineTransparency = transparency
		end
	end
end)

utility.newConnection(menu_references["highlight_toggle"].onColorChange, function(color, transparency)
	for player, info in player_data do
		local highlight = info["highlight"]
		if highlight then
			highlight.FillColor = color
			highlight.FillTransparency = transparency
		end
	end
end)

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
end)
menu_references["highlight_outline"]:setVisible(bool)

utility.newConnection(menu_references["box_toggle"].onToggleChange, function(bool)
	menu_references["fill_toggle"]:setVisible(bool)
end)
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
end)

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
end)

utility.newConnection(menu_references["esp_font"].onDropdownChange, function(selected)
	local font = tonumber(selected[1])
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
end)

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
	menu_references["ammo_number_size"]:setVisible(bool)
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
	menu_references["armor_overlay"]:setVisible(bool)
end, true)
menu_references["health_number"]:setVisible(false)
menu_references["armor_overlay"]:setVisible(false)

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

utility.newConnection(aimbotTargetChange, function(target)
	aimbot.line.Visible = target ~= nil and flags["position_line"] or false
	aimbot.line_outline.Visible = aimbot.line.Visible
	local old_last_target = last_target
	last_target = target
	bounding_box_object.Adornee = target and target.Character or nil
	if not flags["bounding_box"] then
		bounding_box_object.Adornee = nil
	end
	if flags["notifications"] and target ~= old_last_target then
		task.spawn(newNotification, target and `Locked onto player {target.Name}` or `Unlocked`)
	end
	if lplr_data["position_body"] then
		lplr_data["position_body"]:Destroy()
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

		model.Parent = workspace.Ignored

		lplr_data["position_body"] = model
	end
end, true)

utility.newConnection(menu_references["aimbot_toggle"].onActiveChange, function(bool)
	aimbot.target = nil
	aimbotTargetChange:Fire(nil)
	aimbot.circle.Color = bool and flags["active_color"] or flags["fov_color"]
end, true)

utility.newConnection(menu_references["mouse_tp"].onActiveChange, function(bool)
	if aimbot.target and aimbot.target_position then
		aimbot.do_tp = true
	end
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
		end 
	end
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
	["CFrame"] = "no_recoil"
}

local old_index = nil

old_index = hookmetamethod(game, "__index", function(self, index)
	if not checkcaller() then
		if self == mouse and lower(index) == "hit" then
			if flags["anti_aim_viewer"] then
				return old_index(self, index)
			end
			if aimbot.target_position and flags["silent_aim"] then
				return cframenew(aimbot.target_position)
			end
		elseif lplr_data["hrp_cframe"] then
			if self == lplr_parts["HumanoidRootPart"] and index == "CFrame" then
				return lplr_data["hrp_cframe"]
			end
		end
	end
	return old_index(self, index)
end)

local old_new_index = nil

old_new_index = hookmetamethod(game, "__newindex", function(self, index, value)
	if not checkcaller() then
		if spoof_properties[index] then
			spoof_properties[index] = value
			if flags[skip_indexes[index]] then
				if index == "JumpPower" and value >= 50 then
					return old_new_index(self, index, value)
				elseif index == "WalkSpeed" and value >= 16 then
					return old_new_index(self, index, value)
				elseif index == "CFrame" and self == camera then
					if getcallingscript()["Name"] == "Framework" then
						return
					end
					return old_new_index(self, index, value)
				end
				return
			end
		end
	end
	return old_new_index(self, index, value)
end)

-----------------------------
-- * Cheat Core Features * --
-----------------------------

local heartbeat_callbacks = {}
local anti_callbacks = {}

local function renderESP()
	for player, info in player_data do
		local drawings = info["drawings"]

		for _, drawing in drawings do
			drawing.Visible = false
		end

		local hrp, humanoid = info.character_parts["UpperTorso"], info.character_parts["Humanoid"]

		if hrp and humanoid then
			local hrp_pos = hrp.Position

			local bottom, bottom_visible = camera:WorldToViewportPoint(hrp_pos - vector3new(0, 3.65, 0)) 
			local top, top_visible = nil, nil

			if not bottom_visible then
				top, top_visible = camera:WorldToViewportPoint(hrp_pos + vector3new(0, 2.9, 0))
			end

			if bottom_visible or top_visible then
				if top == nil then 
					top = camera:WorldToViewportPoint(hrp_pos + vector3new(0, 2.9, 0))
				end

				local size = (bottom.Y - top.Y) / 2
				local box_size = vector2new((size * 1.4), (size * 1.9))
				local box_pos = vector2new((bottom.X - size * 1.4 / 2), (bottom.Y - size * 3.8 / 2))
				local box_size_y = box_size.Y
				local box_size_x = box_size.X
				local box_pos_x = box_pos.X
				local box_pos_y = box_pos.Y

				if flags["box"] then
					local outline = drawings[1]
					local box = drawings[2]

					box["Size"] = box_size
					box["Position"] = box_pos
					outline["Size"] = box_size
					outline["Position"] = box_pos
					outline["Visible"] = true
					box["Visible"] = true
				end

				if flags["name"] then
					local name = drawings[3]

					name["Position"] = vector2new(box_size_x / 2 + box_pos_x, box_pos_y - name.TextBounds.Y - 2)
					name["Visible"] = true
				end

				local no_armor = false

				if flags["health"] then
					local bar = drawings[5]
					local outline = drawings[4]
					local ratio = info["health"] / humanoid.MaxHealth

					bar.Position = vector2new((box_pos_x - 5), box_pos_y + box_size_y)
					bar.Size = vector2new(1, -ratio * box_size_y)
					outline.From = vector2new(bar.Position.X, box_pos_y + box_size_y + 1)
					outline.To = vector2new(bar.Position.X, bar.Position.Y - box_size_y - 1)
					outline.Visible = true
					bar.Visible = true

					if ratio < 0.99 and flags["health_number"] then
						local text = drawings[9]
						text.Text = tostring(floor(humanoid.Health))
						text.Position = bar.Position - vector2new(text.TextBounds.X/2 + 2, 6)
						text.Visible = true
					end

					if flags["armor"] and flags["armor_overlay"] then
						no_armor = true
						local fill = drawings[11]
						fill.From = bar.Position
						fill.To = vector2new(bar.Position.X, bar.Position.Y - (info["armor"] / 130) * box_size_y)
						fill.Visible = true
					end
				end

				local armor = flags["armor"]

				if not no_armor and flags["armor"] then
					local health_flag = flags["health"]
					if not health_flag or not flags["armor_overlay"] then
						local bar = drawings[11]
						local outline = drawings[10]
						local ratio = info["armor"] / 130

						bar.Position = vector2new((box_pos_x - (health_flag and 11 or 3)), box_pos_y + box_size_y)
						bar.Size = vector2new(1, -ratio * box_size_y)
						outline.From = vector2new(bar.Position.X, box_pos_y + box_size_y + 1)
						outline.To = vector2new(bar.Position.X, bar.Position.Y - box_size_y - 1)

						bar.Visible = true
						outline.Visible = true
					end
				end

				local weapon_text_offset = false
				local gun = info["gun"]

				if flags["ammo"] then
					if gun then
						local bar = drawings[8]
						local outline = drawings[7]
						local ammo = info["ammo"]
						local max_ammo = info["max_ammo"]
						local ratio = ammo/max_ammo

						if ammo ~= 0 then
							bar.Position = vector2new(box_pos_x + 1, box_pos_y + box_size_y + 4)
							bar.Size = vector2new((ratio * box_size_x) - 2, 1)
							bar.Visible = true
						end

						outline.From = vector2new(box_pos_x, box_pos_y + box_size_y + 4)
						outline.To = vector2new(outline.From.X + box_size_x, outline.From.Y)
						outline.Visible = true
						weapon_text_offset = true
					end
				end

				local ammo_text_offset = false

				if flags["weapon"] then
					local text = info["tool"]
					if text then
						local tool = drawings[6]

						tool.Text = text
						tool.Position = vector2new(box_size_x / 2 + box_pos_x, (box_pos_y + box_size_y) + (weapon_text_offset and 6 or 1))
						tool.Visible = true

						ammo_text_offset = true
					end
				end

				if flags["ammo_number"] and gun then
					local text = drawings[12]

					text.Position = vector2new(box_size_x / 2 + box_pos_x, (box_pos_y + box_size_y) + (ammo_text_offset and drawings[6]["TextBounds"]["Y"]+2 or weapon_text_offset and 6 or 1))
					text.Visible = true
				end
			end
		end
	end
end

local auto_shoot_stopped = false

local function doAimbot(dt)
	local circle = aimbot.circle
	local circle_outline = aimbot.circle_outline
	local mouse_position = uis:GetMouseLocation()
	circle.Position = mouse_position
	circle_outline.Position = mouse_position
	local target = aimbot.target
	local aimbot_position = nil
	local line = aimbot.line
	local line_outline = aimbot.line_outline
	local body = lplr_data["position_body"]
	local tool = lplr_data["tool"]
	line.Visible = false
	line_outline.Visible = false

	if target and flags["aimbot_keybind"]["active"] then
		local gun = lplr_data["gun"]
		local stop = false
		local check_screen = false
		local check_fov = false
		local check_visibility = false
		for _, check in flags["aim_checks"] do
			if check == "Gun equipped" and gun == nil then
				stop = true
				break;
			elseif check == "Third person" and uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
				stop = true;
				break
			elseif check == "Target visible" then
				check_visibility = true
			elseif check == "On screen" then
				check_screen = true
			elseif check == "In fov" then
				check_fov = true
			end
		end
		if not stop then
			local gun = gun
			if gun == nil then
				gun = "Default"
			end
			if gun ~= "Default" and not flags[`{gun}_override_general`] then
				gun = "Default"
			end

			local character_parts = player_data[target].character_parts
			local part = character_parts["Humanoid"].FloorMaterial == Enum.Material.Air and flags[`{gun}_air_hitbox`][1] or flags[`{gun}_hitbox`][1]

			if part == "Closest" then
				part = getClosestHitbox(mouse_position, character_parts)
			else
				part = character_parts[part]
			end

			if not part then
				aimbot.target_position = nil
				return end

			local hrp = character_parts["HumanoidRootPart"]

			if not hrp then
				aimbot.target_position = nil
				return end

			local velocity = (flags["resolver"] and aimbot.target_velocity or hrp.Velocity)
			local ping = lplr_data["ping"]/500

			local horizontal_prediction = flags[`{gun}_horizontal_prediction`]
			local vertical_prediction = flags[`{gun}_vertical_prediction`]

			if horizontal_prediction == 0 then
				velocity = velocity * vector3new(ping, 1, ping)
			else
				velocity = velocity * vector3new(horizontal_prediction, 1, horizontal_prediction)
			end

			if vertical_prediction == 0 then
				velocity = velocity * vector3new(1, ping/3, 1)
			else
				velocity = velocity * vector3new(1, vertical_prediction, 1)
			end

			if flags["shake"] then
				local horizontal = flags["horizontal_shake"]
				local vertical = flags["vertical_shake"]
				velocity = velocity + vector3new(mathrandom(1, horizontal+1)/50, mathrandom(1, vertical+1)/50, mathrandom(1, horizontal+1)/50)
			end

			local part_position = part.Position + velocity
			local uppertorso_pos = lplr_parts["UpperTorso"].Position

			if check_visibility and #camera:GetPartsObscuringTarget({uppertorso_pos, part_position}, {char, player_data[target]["character"], camera, workspace.Ignored}) ~= 0 then
				aimbot.target_position = nil
				return 
			end

			local pos, on_screen = camera:WorldToViewportPoint(part_position)

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
			
			aimbot_position = part_position

			if flags["position_line"] then
				local origin = flags["line_origin"][1] == "Mouse" and mouse_position or nil
				if not origin then
					local _pos, on_screen = camera:WorldToViewportPoint(uppertorso_pos)
					if on_screen then
						origin = vector2new(_pos.X, _pos.Y)
					end
				end
				local destination = flags["line_position"][1] == "Predicted position" and new_pos or nil
				if not destination then
					local _pos, on_screen = camera:WorldToViewportPoint(part.Position)
					if on_screen then
						destination = vector2new(_pos.X, _pos.Y)
					end
				end
				if destination and origin then
					line.From = origin
					line_outline.From = origin
					line.To = destination
					line_outline.To = destination
				else
					line.Visible = false
					line_outline.Visible = false
				end
			end

			if flags["position_body"] then
				local children = body:GetChildren()
				local velocity = velocity.magnitude == 0 and vector3new(9999,9999,9999) or velocity

				for i = 1, #children do
					local child = children[i]
					child.CFrame = character_parts[child.Name]["CFrame"] + velocity
				end
			end

			if flags["mouse_aim"] and flags["mouse_aim_keybind"]["active"] then
				if aimbot.do_tp then
					mousemoverel(distance.X, distance.Y)
					aimbot.do_tp = false
				else
					local ease_style = Enum.EasingStyle[flags["smoothing_style"][1]]
					mousemoverel(distance.X * tws:GetValue(((101-flags["horizontal_smoothness"])/100), ease_style, Enum.EasingDirection.Out), distance.Y * tws:GetValue((101-flags["vertical_smoothness"])/100, ease_style, Enum.EasingDirection.Out))	
				end
			end
		end
	end
	if aimbot_position then
		if flags["position_line"] then
			line.Visible = true
			line_outline.Visible = true
		end
		if not last_aimbot_position then
			if body and body.Parent == cg then
				body.Parent = workspace.Ignored
			end
		end
		last_aimbot_position = true
	elseif last_aimbot_position then
		last_aimbot_position = false
		line.Visible = false
		line_outline.Visible = false
		if body and body.Parent == workspace.Ignored then
			body.Parent = cg
		end
	end
	aimbot.target_position = aimbot_position
end

local function fixVelocity(dt)
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
end

local function renderRPGWarnings()
	local new_tick = os.clock()
	local hrp = lplr_parts["HumanoidRootPart"]

	for _, warning in rpg_indicators do
		local image = warning[1]
		local text = warning[2]
		local distance = warning[3]

		image["Visible"] = false
		text["Visible"] = false
		distance["Visible"] = false

		local rocket = warning[4]
		local pos = warning[5]
		local visible = warning[6]
		local last_refresh = warning[7]

		if new_tick-last_refresh > 0.150 then
			warning[7] = new_tick

			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Blacklist
			params.FilterDescendantsInstances = {workspace.Ignored}

			local lookVector = rocket.CFrame.lookVector
		
			local result = workspace:Raycast(rocket.Position, lookVector*-1000, params)
	
			if result then
				local parts = camera:GetPartsObscuringTarget({result.Position + lookVector*1, hrp_pos}, {char, rocket.Parent, camera, workspace.Ignored, workspace.Players})
				warning[5] = result.Position
				warning[6] = #parts == 0
				visible = warning[6]
				pos = result.Position
			end
		end

		if hrp then
			local hrp_pos = hrp.Position

			local screen_pos, on_screen = camera:WorldToViewportPoint(pos)
			screen_pos = vector2new(screen_pos.X, screen_pos.Y)
			if on_screen then
				if visible then
					local size = (screen_pos.Y - camera:WorldToViewportPoint(pos + vector3new(0, 2.8, 0)).Y)/2
					size = floor(size*3)
					image["Visible"] = true
					image["Position"] = screen_pos - vector2new(size/2, size/2)
					image["Size"] = vector2new(size, size)
					text["Visible"] = true
					text["Size"] = size/3
					text["Position"] = screen_pos - vector2new(0, text["TextBounds"]["Y"]*2)
					distance["Visible"] = true
					distance["Size"] = size/3
					distance["Text"] = `{floor((hrp_pos-pos).magnitude)} studs`
					distance["Position"] = screen_pos + vector2new(0, size/3)
				end
			end
		end
	end
end

local is_auto_shooting = false

local function autoShoot()
	local target = aimbot.target

	if not target or not flags["auto_shoot_keybind"]["active"] then
		if is_auto_shooting then
			is_auto_shooting = false
			local tool = lplr_data["tool"]
			if tool and lplr_data["gun"] then
				tool:Deactivate()
			end
		end
		return end

	if player_data[target]["forcefield"] then
		if is_auto_shooting then
			is_auto_shooting = false
			local tool = lplr_data["tool"]
			if tool and lplr_data["gun"] then
				tool:Deactivate()
			end
		end
		return end

	local position = aimbot.target_position

	if not position then
		if is_auto_shooting then
			is_auto_shooting = false
			local tool = lplr_data["tool"]
			if tool and lplr_data["gun"] then
				tool:Deactivate()
			end
		end
		return end

	if #camera:GetPartsObscuringTarget({lplr_parts["HumanoidRootPart"].Position, position}, {char, target.Character, camera, workspace.Ignored}) ~= 0 then
		if is_auto_shooting then
			is_auto_shooting = false
			local tool = lplr_data["tool"]
			if tool and lplr_data["gun"] then
				tool:Deactivate()
			end
		end
		return end

	is_auto_shooting = true

	local tool = lplr_data["tool"]
	if tool and lplr_data["gun"] then
		tool:Activate()
	end
end

local rpg_added_connection = nil

utility.newConnection(menu_references["rpg_warnings"].onToggleChange, function(bool)
	if rpg_added_connection then
		rpg_added_connection:Disconnect()
	end
	if bool then
		insert(heartbeat_callbacks, renderRPGWarnings)
		rpg_added_connection = utility.newConnection(workspace.Ignored.ChildAdded, function(object)
			if object.Name == "Model" then
				local part = object:WaitForChild("Launcher", 1)
				if part then
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Blacklist
					params.FilterDescendantsInstances = {workspace.Ignored}

					local lookVector = part.CFrame.lookVector
				
					local result = workspace:Raycast(part.Position, lookVector*-1000, params)
			
					if result then
						task.spawn(utility.newRPGIndicator, part, result.Position + lookVector*-1)
					end
				end
			end
		end, true)
	else
		remove(heartbeat_callbacks, renderRPGWarnings)
	end
end, true)

utility.newConnection(menu_references["lock_bind"].onActiveChange, function()
	task.wait()
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
end, true)

utility.newConnection(menu_references["esp_toggle"].onToggleChange, function(bool)
	if not bool then
		remove(heartbeat_callbacks, renderESP)
		for player, info in player_data do
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
end, true)

utility.newConnection(menu_references["resolver"].onToggleChange, function(bool)
	if bool then
		insert(heartbeat_callbacks, fixVelocity)
	else
		remove(heartbeat_callbacks, fixVelocity)
	end
	menu_references["resolver_refresh"]:setVisible(bool)
end, true)
menu_references["resolver_refresh"]:setVisible(false)
menu_references["resolver"]:setToggle(true)

utility.newConnection(menu_references["aimbot_toggle"].onToggleChange, function(bool)
	local aimbot_circle = aimbot.circle
	aimbot.target = nil
	aimbotTargetChange:Fire(nil)
	aimbot_circle.Visible = (bool and flags["show_fov"] or false)
	aimbot.circle_outline.Visible = aimbot_circle.Visible
	if bool then
		insert(heartbeat_callbacks, doAimbot)
	else
		remove(heartbeat_callbacks, doAimbot)
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

utility.newConnection(menu_references["hit_chams"].onToggleChange, function(bool)
	menu_references["hit_chams_lifetime"]:setVisible(bool)
end, true)
menu_references["hit_chams_lifetime"]:setVisible(false)

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

utility.newConnection(workspace.Ignored.Siren.Radius.ChildAdded, function(object)
	task.wait()
	if object.Name == "BULLET_RAYS" then
		local bullet_beam = object:FindFirstChild("GunBeam")
		if bullet_beam then
			local position = object.Position
			if lplr_data["recently_shot"] or position == lplr_data["last_shot_position"] then
				lplr_data["last_shot_position"] = position
				onBulletFired:Fire(object, bullet_beam, true, bullet_beam.Attachment1.WorldCFrame.Position)
			else
				onBulletFired:Fire(object, bullet_beam, false)
			end
		end
	end
end, true)

utility.newConnection(menu_references["local_bullet_impacts"].onToggleChange, function(bool)
	menu_references["local_bullet_impacts_size"]:setVisible(bool)
	menu_references["local_bullet_impacts_lifetime"]:setVisible(bool)
end, true)
menu_references["local_bullet_impacts_size"]:setVisible(false)
menu_references["local_bullet_impacts_lifetime"]:setVisible(false)

utility.newConnection(menu_references["enemy_bullet_tracers"].onToggleChange, function(bool)
	menu_references["enemy_bullet_tracers_lifetime"]:setVisible(bool)
end, true)
menu_references["enemy_bullet_tracers_lifetime"]:setVisible(false)

utility.newConnection(menu_references["local_bullet_tracers"].onToggleChange, function(bool)
	menu_references["local_bullet_tracers_lifetime"]:setVisible(bool)
end, true)
menu_references["local_bullet_tracers_lifetime"]:setVisible(false)

utility.newConnection(menu_references["hitmarker"].onToggleChange, function(bool)
	menu_references["hitmarker_size"]:setVisible(bool)
	menu_references["hitmarker_gap"]:setVisible(bool)
end, true)
menu_references["hitmarker_size"]:setVisible(false)
menu_references["hitmarker_gap"]:setVisible(false)

utility.newConnection(menu_references["hitsound"].onToggleChange, function(bool)
	menu_references["hitsound_volume"]:setVisible(bool)
end, true)
menu_references["hitsound_volume"]:setVisible(false)

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

utility.newConnection(menu_references["position_body"].onToggleChange, function(bool)
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

		model.Parent = workspace.Ignored

		lplr_data["position_body"] = model
	end
end, true)

local function renderBulletImpact(object, beam, position)
	local impact = impact_clone:Clone()
	local outline = impact.Outline
	local impact_size = flags["local_bullet_impacts_size"]
	local impact_color = flags["local_bullet_impacts_color"]
	local impact_transparency = flags["local_bullet_impacts_transparency"]

	impact.Size = vector3new(impact_size, impact_size, impact_size)
	impact.Color = impact_color
	impact.Transparency = impact_transparency
	impact.Position = position
	outline.Color3 = impact_color
	outline.Adornee = impact
	impact.Parent = workspace.Ignored

	task.wait(flags["local_bullet_impacts_lifetime"])

	tween(outline, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
	tween(impact, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})

	task.wait(0.25)

	impact:Destroy()
end

local function renderBulletTracer(object, beam, is_lplr)
	local end_position = beam.Attachment1.WorldCFrame
	local start_position = object.CFrame

	local beam = beam_clone:Clone()
	beam.Transparency = NumberSequence.new(is_lplr and flags["local_bullet_tracers_transparency"] or flags["enemy_bullet_tracers_transparency"])
	beam.Color = ColorSequence.new(is_lplr and flags["local_bullet_tracers_color"] or flags["enemy_bullet_tracers_color"], colorfromrgb(0, 0, 0))

	local attachment1 = utility.newObject("Attachment", {
		CFrame = object.CFrame,
		Parent = workspace.Terrain
	})

	local attachment2 = utility.newObject("Attachment", {
		CFrame = end_position,
		Parent = workspace.Terrain
	})

	beam.Attachment0 = attachment1
	beam.Attachment1 = attachment2
	beam.Parent = workspace.Ignored

	local tween = nil
	local total_time = 0

	object:Destroy()

	task.wait(is_lplr and flags["local_bullet_tracers_lifetime"] or flags["enemy_bullet_tracers_lifetime"])

	tween = utility.newConnection(rs.Heartbeat, function(dt)
		total_time+=dt
		beam.Transparency = NumberSequence.new(tws:GetValue((total_time / 0.2), Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
	end, true)

	task.wait(0.2)

	tween:Disconnect()
	beam:Destroy()
	attachment1:Destroy()
	attachment2:Destroy()
end

local offsets = {
	vector2new(1,1),
	vector2new(-1,1),
	vector2new(1,-1),
	vector2new(-1,-1)
}	

local function renderHitmarker(is_2d, player)
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
			local tween_value = tws:GetValue((time_elapsed / .6), Enum.EasingStyle.Sine, Enum.EasingDirection.In)

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
			local position_on_screen, on_screen = camera:WorldToViewportPoint(position)
			if on_screen then
				local mouse_pos = vector2new(position_on_screen.X, position_on_screen.Y)
				local tween_value = tws:GetValue((time_elapsed / .6), Enum.EasingStyle.Sine, Enum.EasingDirection.In)

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

	task.wait(0.6)

	for _, info in hitmarker do
		for _, drawing in info do
			drawing:Destroy()
		end
	end

	render_connection:Disconnect()
end

local function renderHitCham(player)
	local character = player.Character
	character.Archivable = true; local character_cloned = character:Clone(); character.Archivable = false
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

	task.delay(lifetime, function()
		character_cloned:Destroy()
	end)

	character_cloned.Parent = workspace.Ignored
end

local bubble_part = utility.newObject("Part", {
	Size = vector3new(1,1,1),
	Transparency = 1,
	CanCollide = false,
	Anchored = true,
	Parent = workspace.Ignored
})

utility.newObject("ParticleEmitter", {
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
	Parent = bubble_part
})
utility.newObject("ParticleEmitter", {
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
	Parent = bubble_part
})
utility.newObject("ParticleEmitter", {
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
	Parent = bubble_part
})

local sparks_part = utility.newObject("Part", {
	Size = vector3new(1,1,1),
	Transparency = 1,
	CanCollide = false,
	Anchored = true,
	Parent = workspace.Ignored
})

utility.newObject("ParticleEmitter", {
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
	Parent = sparks_part
})

local hit_effects = {
	["Bubble"] = {
		bubble_part,
		1,
		false
	},
	["Sparks"] = {
		sparks_part,
		30,
		false
	}
}

local function renderHitEffect(player)
	local hit_effect = hit_effects[flags["hit_effect_effect"][1]]
	local hrp = player.Character.HumanoidRootPart
	local hit_part = hit_effect[1]
	hit_part.CFrame = hrp.CFrame
	for _, particle in hit_part:GetChildren() do
		particle:Emit(hit_effect[2])
	end
end

local function spinningCrosshair(dt)
	local rotation = crosshair.Rotation
	crosshair.Rotation = rotation == 360 and 0 or rotation+((flags["spinning_speed"]*5)*dt)
end

local function antiLock(dt)
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
end

local function spinbot(dt)
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	hrp.CFrame = (hrp.CFrame * angles(0,rad((flags["spinbot_speed"]*20)*dt),0))
end

local last_auto_stomp = os.clock()

local function autoStomp(dt)
	local hrp = lplr_parts["HumanoidRootPart"]

	if not hrp then
		return end

	local new_tick = os.clock()

	if new_tick-last_auto_stomp > .033 then
		event:FireServer("Stomp")
		last_auto_stomp = new_tick
	end
end

utility.newConnection(onBulletFired, function(object, beam, is_lplr, hit)
	if is_lplr then
		if flags["local_bullet_impacts"] then
			task.spawn(renderBulletImpact, object, beam, hit)
		end
		if flags["local_bullet_tracers"] then
			task.spawn(renderBulletTracer, object, beam, is_lplr)
		end
	else
		if flags["enemy_bullet_tracers"] then
			task.spawn(renderBulletTracer, object, beam, is_lplr)
		end
	end
end, true)

utility.newConnection(lplrHitPlayer, function(player, damage)
	if flags["hitmarker"] then
		local is_2d = flags["hitmarker_style"][1] == "2D"
		task.spawn(renderHitmarker, is_2d, player)
	end
	if flags["hit_logs"] then
		task.spawn(newNotification, `Hit {player.Name} for {damage} damage`)
	end
	if flags["hitsound"] then
		local sound = utility.newObject("Sound", {
			Volume = flags["hitsound_volume"];
			PlayOnRemove = true;
			SoundId = hitsounds[flags["hitsound_sound"][1]];
			Parent = gethui()
		})
		sound:Destroy()
	end
	if flags["hit_chams"] then
		task.spawn(renderHitCham, player)
	end
	if flags["hit_effect"] then
		task.spawn(renderHitEffect, player)
	end
end)

utility.newConnection(menu_references["character_lag_amount"].onSliderChange, function(value)
	if flags["character_lag"] then
		setfflag("S2PhysicsSenderRate", tostring(15-value))
	end
end)

utility.newConnection(menu_references["character_lag"].onToggleChange, function(bool)
	setfflag("S2PhysicsSenderRate", bool and tostring(15-flags["character_lag_amount"]) or "15")
end)

utility.newConnection(menu_references["spinning_crosshair"].onToggleChange, function(bool)
	crosshair.Rotation = 0
	if bool then
		insert(heartbeat_callbacks, spinningCrosshair)
	else
		remove(heartbeat_callbacks, spinningCrosshair)
	end
end, true)

utility.newConnection(menu_references["spinbot"].onToggleChange, function(bool)
	local humanoid = lplr_parts["Humanoid"]
	if humanoid then
		humanoid.AutoRotate = not bool 
	end

	if bool then
		insert(heartbeat_callbacks, spinbot)
	else
		remove(heartbeat_callbacks, spinbot)
	end
	menu_references["spinbot_speed"]:setVisible(bool)
end, true)
menu_references["spinbot_speed"]:setVisible(bool)

utility.newConnection(menu_references["anti_lock"].onToggleChange, function(bool)
	if bool then
		insert(anti_callbacks, antiLock)
	else
		remove(anti_callbacks, antiLock)
	end
end, true)

utility.newConnection(menu_references["anti_lock_style"].onDropdownChange, function(selected)
	menu_references["anti_lock_multiplier"]:setVisible(find(selected, "Multiplier") and true or false)
end, true)
menu_references["anti_lock_multiplier"]:setVisible(false)

utility.newConnection(menu_references["hit_effect"].onColorChange, function(color)
	for effect, info in hit_effects do
		local part = info[1]
		for _, particle in part:GetChildren() do
			particle.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(1.00, color)}
		end
	end
end, true)

utility.newConnection(menu_references["auto_shoot"].onActiveChange, function(bool)
	local tool = lplr_data["tool"]

	if not tool or not lplr_data["gun"] then
		return end

	tool:Deactivate()
end, true)

utility.newConnection(menu_references["auto_shoot"].onToggleChange, function(bool)
	if bool then
		insert(heartbeat_callbacks, autoShoot)
	else
		remove(heartbeat_callbacks, autoShoot)
	end

	local tool = lplr_data["tool"]

	if not tool or not lplr_data["gun"] then
		return end

	tool:Deactivate()
end, true)

utility.newConnection(menu_references["auto_stomp"].onToggleChange, function(bool)
	if bool then
		insert(heartbeat_callbacks, autoStomp)
	else
		remove(heartbeat_callbacks, autoStomp)
	end	
end, true)

local function cframeSpeed(dt)
	if not flags["cframe_speed_keybind"]["active"] then
		return end 

	local hrp = lplr_parts["HumanoidRootPart"]
	local humanoid = lplr_parts["Humanoid"]

	if not hrp or not humanoid then
		return end
		
	hrp.CFrame+=((humanoid.MoveDirection*dt)*(flags["cframe_speed_speed"]*5))
end

local function cframeFly(dt)
	if not flags["cframe_fly_keybind"]["active"] then
		return end 

	local hrp = lplr_parts["HumanoidRootPart"]
	local humanoid = lplr_parts["Humanoid"]

	if not hrp or not humanoid then
		return end

	local speed = flags["cframe_fly_speed"]

	hrp.Velocity = vector3new(hrp.Velocity.X, 1.8, hrp.Velocity.Z)
	
	hrp.CFrame+=(((humanoid.MoveDirection*dt)*(speed*5))*vector3new(1,0,1)) + vector3new(0,(uis:IsKeyDown(Enum.KeyCode.Space) and 1+((speed*0.85)*dt)) or (uis:IsKeyDown(Enum.KeyCode.LeftShift) and -1-((speed*0.85)*dt)) or 0,0)
end

local noclip_connection = nil

utility.newConnection(menu_references["noclip"].onToggleChange, function(bool)
	if noclip_connection then
		noclip_connection:Disconnect()
	end
	if bool then
		noclip_connection = utility.newConnection(rs.Stepped, function()
			for _, part in lplr_parts do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end 
			end
		end, true)
	end	
end, true)

utility.newConnection(menu_references["cframe_fly"].onToggleChange, function(bool)
	if bool then
		insert(heartbeat_callbacks, cframeFly)
	else
		remove(heartbeat_callbacks, cframeFly)
	end	
	menu_references["cframe_fly_speed"]:setVisible(bool)
end, true)
menu_references["cframe_fly_speed"]:setVisible(false)

utility.newConnection(menu_references["cframe_speed"].onToggleChange, function(bool)
	if bool then
		insert(heartbeat_callbacks, cframeSpeed)
	else
		remove(heartbeat_callbacks, cframeSpeed)
	end
	menu_references["cframe_speed_speed"]:setVisible(bool)
end, true)
menu_references["cframe_speed_speed"]:setVisible(false)

utility.newConnection(menu_references["aimbot_priority"].onToggleChange, function(bool)
	local player = plrs:FindFirstChild(menu_references["players_box"]["selected_option"])

	if not player then
		return end 

	player_data[player]["aimbot_priority"] = bool
end, true)

utility.newConnection(menu_references["whitelisted"].onToggleChange, function(bool)
	local player = plrs:FindFirstChild(menu_references["players_box"]["selected_option"])

	if not player then
		return end 

	player_data[player]["whitelisted"] = bool
end, true)

utility.newConnection(menu_references["players_box"].onSelectionChange, function(selected)
	local player = plrs:FindFirstChild(selected)

	if not player then
		return end 

	menu_references["aimbot_priority"]:setToggle(player_data[player]["aimbot_priority"], true)
	menu_references["whitelisted"]:setToggle(player_data[player]["whitelisted"], true)
end, true)

local function autoSort()
	local list = {}

	for i = 1, 9 do
		if flags["slot_"..i] then
			insert(list, lower(flags["slot_"..i]))
		end
	end

	local inventory = {}

	for _, tool in lplr.Backpack:GetChildren() do
		insert(inventory, tool)
		tool.Parent = cg
	end

	task.wait()

	local priority = {}
	local not_priority = {}

	for _, tool in inventory do
		local priority_ = false
		for _, tool_name in list do
			print(tool_name, "What")
			if not priority_ and lower(tool.Name):find(tool_name) then
				print(toolName)
				priority_ = true
				insert(priority, tool)
				break
			end
		end
		if not priority_ then
			insert(not_priority, tool)
		end
 	end

	for _, tool in priority do
		tool.Parent = lplr.Backpack
		task.wait()
	end

	for _, tool in not_priority do
		tool.Parent = lplr.Backpack
		task.wait()
	end
end

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
		task.spawn(autoSort)
	end
end, true)

utility.newConnection(menu_references["auto_armor"].onToggleChange, function(bool)
	menu_references["armor_threshold"]:setVisible(bool)

	if not lplr_parts["HumanoidRootPart"] then
		return end

	if bool and lplr_data["armor"]/130 < flags["armor_threshold"]/100 then
		purchaseItem("high-mediumarmor")
	end
end, true)
menu_references["armor_threshold"]:setVisible(true)

utility.newConnection(menu_references["auto_fire_armor"].onToggleChange, function(bool)
	menu_references["fire_threshold"]:setVisible(bool)

	if not lplr_parts["HumanoidRootPart"] then
		return end

	if bool and lplr_data["fire_armor"]/200 < flags["fire_threshold"]/100 then
		purchaseItem("firearmor")
	end
end, true)
menu_references["fire_threshold"]:setVisible(true)

local function cframeDesync(dt)
	local hrp = lplr_parts["HumanoidRootPart"]
	lplr_data["hrp_cframe"] = nil

	if not hrp or not flags["cframe_desync_keybind"]["active"] or lplr_data["force_cframe"] then
		return end

	local old_cframe = hrp.CFrame
	local horizontal_offset = flags["horizontal_offset"]
	local vertical_offset = flags["vertical_offset"]
	local randomization = flags["cframe_randomization"]+1

	lplr_data["hrp_cframe"] = hrp.CFrame

	hrp.CFrame+=vector3new(math.random(2) == 1 and -horizontal_offset or horizontal_offset, math.random(2) == 2 and -vertical_offset or vertical_offset, math.random(2) == 2 and -horizontal_offset or horizontal_offset) * vector3new(1 + math.random(0, randomization)/100, 1 + math.random(0, randomization)/100, 1 + math.random(0, randomization)/100)

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
end

utility.newConnection(menu_references["cframe_desync"].onActiveChange, function(bool)
	lplr_data["hrp_cframe"] = nil

	if lplr_data["cframe_body"] then
		lplr_data["cframe_body"].Parent = bool and workspace.Ignored or cg
	end
end, true)

utility.newConnection(menu_references["cframe_body"].onToggleChange, function(bool)
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
			model.Parent = workspace.Ignored
		else
			model.Parent = cg
		end
	end
end, true)

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

utility.newConnection(menu_references["cframe_desync"].onToggleChange, function(bool)
	menu_references["horizontal_offset"]:setVisible(bool)
	menu_references["vertical_offset"]:setVisible(bool)
	menu_references["cframe_randomization"]:setVisible(bool)
	menu_references["cframe_body"]:setVisible(bool)

	if lplr_data["cframe_body"] then
		lplr_data["cframe_body"]:Destroy()
		lplr_data["cframe_body"] = nil
	end

	lplr_data["hrp_cframe"] = nil

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
				model.Parent = workspace.Ignored
			else
				model.Parent = cg
			end
		end

		insert(anti_callbacks, cframeDesync)
	else
		remove(anti_callbacks, cframeDesync)
	end
end, true)

menu_references["horizontal_offset"]:setVisible(false)
menu_references["vertical_offset"]:setVisible(false)
menu_references["cframe_randomization"]:setVisible(false)
menu_references["cframe_body"]:setVisible(false)

for _, shop in workspace.Ignored.Shop:GetChildren() do
    local name = match(shop.Name, "%b[]")

    if not name or name:find("Phone") or name:find("Mask") then
        continue end

    name = sub(lower(gsub(name, "%s", "")), 2, -2)

    if shop_items[name] or shop_ignore[name] then
        continue end

	local head = shop:FindFirstChild("Head")

	if not head then
		continue end

	if head.Position.Y < -30 then
		continue end

    shop_items[name] = {
		head,
		shop.ClickDetector	
	}
end

for name, _ in shop_items do
	if name:find("ammo") then
		continue end

	menu_references["purchases"]:addOption(name)
end

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

local data_ping = server_stats_item["Data Ping"]

utility.newConnection(rs.Heartbeat, function(dt)
	lplr_data["ping"] = tonumber(split(data_ping:GetValueString(),'(')[1])

	local hrp = lplr_parts["HumanoidRootPart"]

	if hrp then
		for _, connection in getconnections(hrp:GetPropertyChangedSignal("CFrame")) do
			connection:Disconnect()
		end
	end

	for _, callback in heartbeat_callbacks do
		task.spawn(callback, dt)
	end

	for _, callback in anti_callbacks do
		task.spawn(callback, dt)
	end

	local force_cframe = lplr_data["force_cframe"]

	if hrp and force_cframe then
		hrp.CFrame = force_cframe
		hrp.Velocity = vector3new(0,1.85,0)
	end
end, true)

for i,v in getconnections(game:GetService("LogService").MessageOut) do
	v:Disable()
end

for _, player in plrs:GetPlayers() do
	if player == lplr then
		continue 
	end

	task.spawn(playerAdded, player)
end

if isfile(config_location.."/configs/".."autoload"..".cfg") then
	utility.loadConfig("autoload")
end