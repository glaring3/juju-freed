setfpscap(1000)

-- * Services
local character_folder_name = (game.GameId == 1958807588 and "I_LOADED_I") or (game.GameId == 4979740877 and "bodyvalues") or (game.GameId == 4979788697 and "bodyvalues") or (game.GameId == "4980114137" and "bodyvalues") or "BodyEffects"
local players, mouse, cg, hs, ts, uis, texts, camera, rs, debris = game:GetService("Players"), game:GetService("Players").LocalPlayer:GetMouse(), game:GetService("CoreGui"), game:GetService("HttpService"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("TextService"), workspace.CurrentCamera, game:GetService("RunService"), game:GetService("Debris")
local rs = game:GetService("RunService")
local signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua"))()
local lplr = players.LocalPlayer
local lighting = game.Lighting
local stats = game:GetService("Stats")
local clamp = math.clamp
local floor = math.floor
local rad = math.rad
local sin = math.sin
local atan2 = math.atan2
local max = math.max
local min = math.min
local cos = math.cos
local abs = math.abs
local pi = math.pi
local vect2 = Vector2.new
local vect3 = Vector3.new
local cfnew = CFrame.new
local angles = CFrame.Angles
local cflookat = CFrame.lookAt
local forcefield = Enum.Material.ForceField
local plastic = Enum.Material.Plastic
local neon = Enum.Material.Neon
local udimnew = UDim.new
local udim2new = UDim2.new
local lower = string.lower
local viewport_size =camera.ViewportSize

LPH_JIT = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end

camera:GetPropertyChangedSignal("ViewportSize"):Connect(LPH_JIT(function()
	viewport_size = camera.ViewportSize
end))

local lib = {
	config_location = "ratio",
	copied_color = nil,
	accent_color = Color3.fromRGB(189, 172, 255),
	on_config_load = signal.new("on_config_load"),
	flags = {},
	accent_objects = {},
	copied_color = Color3.fromRGB(255,255,255)
}

function lib:get_config_list()
    local location = lib.config_location.."/configs/"
    local cfgs = listfiles(location)
    local returnTable = {}
    for _, file in pairs(cfgs) do
        local str = tostring(file)
        if string.sub(str, #str-3, #str) == ".cfg" then
            table.insert(returnTable, string.sub(str, #location+2, #str-4))
        end
    end
    return returnTable
end

-- * Utility Functions

local util = {
	connections = {}
}

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function util:to_hex(color)
	return string.format("#%02X%02X%02X", color.R * 0xFF,
			color.G * 0xFF, color.B * 0xFF)
end

function util:encode64(data)
	return ((data:gsub('.', LPH_NO_VIRTUALIZE(function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end))..'0000'):gsub('%d%d%d?%d?%d?%d?', LPH_NO_VIRTUALIZE(function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end))..({ '', '==', '=' })[#data%3+1])
end

function util:decode64(data)
	local data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', LPH_NO_VIRTUALIZE(function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end)):gsub('%d%d%d?%d?%d?%d?%d?%d?', LPH_NO_VIRTUALIZE(function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end)))
end

function util:hex_to_color(hex)
	hex = hex:gsub("#","")
	local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
	return Color3.new(r,g,b)
end

function util:round(num, decimals)
	local mult = 10^(decimals or 0)
	return floor(num * mult + 0.5) / mult
end

function util:copy(original)
	local copy = {}
	for _, v in pairs(original) do
		if type(v) == "table" then
			v = util:copy(v)
		end
		copy[_] = v
	end
	return copy
end

function util:find(surge, target)
	for i = 1, #surge do
		local potential = surge[i]
		if potential == target then
			return i
		end
	end
end

function util:tween(...) 
	ts:Create(...):Play()
end

function util:set_draggable(obj)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		obj.Position = udim2new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not lib.busy then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	obj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch and not lib.busy then
			dragInput = input
		end
	end)

	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging and not lib.busy then
			update(input)
		end
	end)
end

function util:is_in_frame(object)
	local abs_pos = object.AbsolutePosition
	local abs_size = object.AbsoluteSize
	local x = abs_pos.Y <= mouse.Y and mouse.Y <= abs_pos.Y + abs_size.Y
	local y = abs_pos.X <= mouse.X and mouse.X <= abs_pos.X + abs_size.X

	return (x and y)
end

function util:create_new(classname, properties, custom)
	local object = Instance.new(classname)

	for prop, val in pairs(properties) do
		local prop, val = prop, val
		if prop == "Parent" and classname == "ScreenGui" then
			val = gethui and gethui() or lplr.PlayerGui
			if syn and syn.protect_gui then syn.protect_gui(object) end
		end
		if string.find(prop, "Color")then
			if val == lib.accent_color or (typeof(val) == "ColorSequence" and val.Keypoints[1].Value == lib.accent_color) then
				table.insert(lib.accent_objects, object)
			end
		end

		object[prop] = val
	end

	object.Name = hs:GenerateGUID(false)

	return object
end

function util:create_connection(signal, callback)
	local connection = signal:Connect(callback)

	table.insert(util.connections, connection)

	return connection
end

function util:get_text_size(title)
	return texts:GetTextSize(title, 12, "RobotoMono", vect2(999,999)).X
end

function lib:save_config(cfgName)
	local values_copy = util:copy(lib.flags)
	for i,element in pairs(values_copy) do
		if typeof(element) == "table" and element["color"] then
			element["color"] = {R = element["color"].R, G = element["color"].G, B = element["color"].B}
		end
	end

	if true then
		task.spawn(function()
			task.wait()
		end)
		writefile(lib.config_location.."/configs/"..cfgName..".cfg", util:encode64(hs:JSONEncode(values_copy)))
	else
		return hs:JSONEncode(values_copy)
	end
end

function lib:load_config(cfgName)
    local new_values = hs:JSONDecode(util:decode64(readfile((lib.config_location.."/configs/"..cfgName..".cfg"))))

    for i, element in pairs(new_values) do
        if typeof(element) == "table" and element["color"] then
            element["color"] = Color3.new(element["color"].R, element["color"].G, element["color"].B)
        end
        lib.flags[i] = element
    end

    task.spawn(function()
        task.wait()
        lib.on_config_load:Fire()
    end)
end


-- * Create Missing Folders

if not isfolder(lib.config_location) then
	makefolder(lib.config_location)
end

if not isfolder(lib.config_location.."/configs") then
	makefolder(lib.config_location.."/configs")
end

if not isfolder(lib.config_location.."/records") then
	makefolder(lib.config_location.."/records")
end

if not isfolder(lib.config_location.."/players") then
	makefolder(lib.config_location.."/players")
end


-- * Main Library

local window = {}; window.__index = window
local tab = {}; tab.__index = tab
local subtab = {}; subtab.__index = subtab
local section = {}; section.__index = section
local element = {}; element.__index = element

function window:set_title(text)
	local color = {R = util:round(lib.accent_color.R*255), G = util:round(lib.accent_color.G*255), B = util:round(lib.accent_color.B*255)}
	self.name_label.Text = text
end

function window:set_build(text)
	local color = {R = util:round(lib.accent_color.R*255), G = util:round(lib.accent_color.G*255), B = util:round(lib.accent_color.B*255)}
	self.build_label.Text = string.format("build: <font color=\"rgb(%s, %s, %s)\">%s</font>", color.R, color.G, color.B, text)
end

function window:set_user(text)
	local color = {R = util:round(lib.accent_color.R*255), G = util:round(lib.accent_color.G*255), B = util:round(lib.accent_color.B*255)}
	self.user_label.Text = string.format("active user: <font color=\"rgb(%s, %s, %s)\">%s</font>", color.R, color.G, color.B, text)
end

function window:set_tab(name)
	self.active_tab = name
	for _, v in pairs(self.tabs) do
		if v.name == name then v:set_active() else v:set_not_active() end
	end 
end

function window:close()
	local descendants = self.screen_gui:GetDescendants()
	util:tween(self.line, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(1, 0, 1, 1), Size = udim2new(0, 0, 0, 1)})
	util:tween(self.tab_holder, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(-1,0,0,0)})
	for i = 1, #descendants do
		local descendant = descendants[i]
		if descendant.ClassName == "Frame" then
			if descendant.BackgroundColor3 == Color3.fromRGB(255,255,255) then continue end
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
		elseif descendant.ClassName == "TextLabel" then
			if descendant.BackgroundColor3 == Color3.fromRGB(254,254,254) then continue end
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
		elseif descendant.ClassName == "ImageLabel" then
			if descendant.BackgroundColor3 == Color3.fromRGB(254,254,254) then continue end
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
			if descendant.ZIndex == 16 then
				util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
			end
		elseif descendant.ClassName == "TextBox" then
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
		elseif descendant.ClassName == "ScrollingFrame" then
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 1})
		end
	end
	task.delay(0.24, function()
		if self.screen_gui:FindFirstChildOfClass("Frame").BackgroundTransparency > 0.99 then
			self.on_close:Fire()
			self.screen_gui.Enabled = false
			self.opened = false
		end
	end)
end

function window:open()
	self.screen_gui.Enabled = true
	self.opened = true
	local descendants = self.screen_gui:GetDescendants()
	util:tween(self.line, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(1, -298, 1, 1), Size = udim2new(0.5, 0, 0, 1)})
	util:tween(self.tab_holder, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(0,0,0,0)})
	for i = 1, #descendants do
		local descendant = descendants[i]
		if descendant.ClassName == "Frame" then
			if descendant.BackgroundColor3 == Color3.fromRGB(255,255,255) or (string.sub(descendant.Name, 1, 1) == "t" and not descendant.Name:find(self.active_tab)) then continue end
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = (descendant.BackgroundColor3 == Color3.fromRGB(1,1,1) and 0.5 or 0)})
		elseif descendant.ClassName == "TextLabel" then
			if descendant.BackgroundColor3 == Color3.fromRGB(254,254,254) then continue end
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
		elseif descendant.ClassName == "ImageLabel" then
			if descendant.BackgroundColor3 == Color3.fromRGB(254,254,254) then continue end
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
			if descendant.ZIndex == 16 then
				util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
			end
		elseif descendant.ClassName == "TextBox" then
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
		elseif descendant.ClassName == "ScrollingFrame" then
			util:tween(descendant, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 0})
		end
	end
end

function window:new_tab(text)
	local TabButton = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = udim2new(0, 106, 0, 1);
		Size = udim2new(0, util:get_text_size(text) + 20, 0, 19);
		Parent = self.tab_holder
	}); TabName = "t-"..text
	local TabLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 2;
		Font = Enum.Font.RobotoMono;
		Text = text;
		TextColor3 = lib.accent_color;
		TextSize = 12.000;
		BackgroundTransparency = 1;
		Parent = TabButton
	})
	local UICorner = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 6);
		Parent = TabButton
	})
	local ButtonFix = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		Position = udim2new(0, 1, 0, 9);
		Size = udim2new(1, -2, 0, 10);
		Visible = false;
		Parent = TabButton
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, lib.accent_color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(32, 32, 32)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(32, 32, 32))};
		Rotation = 90;
		Offset = vect2(0,-0.19);
		Parent = TabButton
	})
	local UICorner_2 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 6);
		Parent = TabLabel
	})
	local ButtonFix2 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 1, 0);
		Size = udim2new(1, -2, 0, 1);
		Visible = false;
		Parent = TabButton
	})
	local TabFrame = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 12, 0, 34);
		Size = udim2new(1, -24, 0, 360);
		Parent = self.main;
		Visible = false
	})
	local SubtabHolder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		Size = udim2new(0, 116, 0, 360);
		Parent = TabFrame
	})
	local SubtabInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 6, 0, 6);
		Size = udim2new(1, -12, 1, -12);
		Parent = SubtabHolder
	})
	local UIListLayout = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = udimnew(0, 3);
		Parent = SubtabInside
	})

	local new_tab = {
		tab_button = TabButton,
		gradient = UIGradient,
		fix1 = ButtonFix,
		fix2 = ButtonFix2,
		label = TabLabel,
		name = text,
		frame = TabFrame,
		holder = SubtabInside,
		subtabs = {},
		active_subtab = nil,
		lib = self
	}

	local on_click = util:create_connection(TabButton.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.active_tab ~= text then
			TabLabel.TextColor3 = Color3.fromRGB(74,74,74)
		end
	end)

	local on_click = util:create_connection(TabButton.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:set_tab(text)
		end
	end)

	local on_hover = util:create_connection(TabButton.MouseEnter, function(input)
		if self.active_tab ~= text then
			TabLabel.TextColor3 = Color3.fromRGB(126,126,126)
		end
	end)

	local on_hover = util:create_connection(TabButton.MouseLeave, function(input)
		if self.active_tab ~= text then
			TabLabel.TextColor3 = Color3.fromRGB(74,74,74)
		end
	end)

	setmetatable(new_tab, tab); table.insert(self.tabs, new_tab)

	if #self.tabs == 1 then new_tab:set_active(); self.active_tab = text else new_tab:set_not_active() end

	return new_tab
end

function tab:set_active()
	local button = self.tab_button
	local fix1 = self.fix1
	local fix2 = self.fix2
	local gradient = self.gradient
	local label = self.label
	local frame = self.frame

	button.BackgroundTransparency = 0
	label.BackgroundTransparency = 0
	label.TextColor3 = lib.accent_color
	fix1.Visible = true
	fix2.Visible = true
	frame.Visible = true
	util:tween(gradient, TweenInfo.new(0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Offset = vect2(0,0)})
end

function tab:set_not_active()
	local button = self.tab_button
	local fix1 = self.fix1
	local fix2 = self.fix2
	local gradient = self.gradient
	local label = self.label
	local frame = self.frame

	button.BackgroundTransparency = 1
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(74,74,74)
	fix1.Visible = false
	fix2.Visible = false
	frame.Visible = false
	util:tween(gradient, TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Offset = vect2(0,-0.19)})
end

function tab:set_subtab(name)
	self.active_subtab = name
	for _, v in pairs(self.subtabs) do
		if v.name == name then v:set_active() else v:set_not_active() end
	end 
end

function tab:new_subtab(text)
	local SubtabButton = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 18);
		Parent = self.holder
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(17, 17, 17)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(9, 9, 9))};
		Parent = SubtabButton
	})
	local ButtonLine = util:create_new("Frame", {
		BackgroundColor3 = lib.accent_color;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 1, 1, 0);
		Parent = SubtabButton
	})
	local ButtonLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 8, 0, 0);
		Size = udim2new(1, -8, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = text;
		TextColor3 = lib.accent_color;
		TextSize = 12.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = SubtabButton
	})
	local Left = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		BorderSizePixel = 0;
		Position = udim2new(0, 127, 0, 0);
		Size = udim2new(0, 217, 0, 360);
		Visible = false;
		Parent = self.frame;
	})
	local UIListLayout = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = udimnew(0, 10);
		Parent = Left
	})
	local Right = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		BorderSizePixel = 0;
		Position = udim2new(1, -217, 0, 0);
		Size = udim2new(0, 217, 0, 360);
		Visible = false;
		Parent = self.frame
	})
	local UIListLayout_4 = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = udimnew(0, 10);
		Parent = Right
	})

	local on_click = util:create_connection(SubtabButton.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:set_subtab(text)
		end
	end)

	local on_hover = util:create_connection(SubtabButton.MouseEnter, function(input)
		if self.active_subtab ~= text then
			TextColor3 = Color3.fromRGB(126,126,126)
		end
	end)

	local on_hover = util:create_connection(SubtabButton.MouseLeave, function(input)
		if self.active_subtab ~= text then
			TextColor3 = Color3.fromRGB(74,74,74)
		end
	end)

	local new_subtab = {
		line = ButtonLine,
		label = ButtonLabel,
		name = text,
		whole = SubtabButton,
		left = Left,
		right = Right,
		lib = self.lib
	}

	setmetatable(new_subtab, subtab); table.insert(self.subtabs, new_subtab)

	if #self.subtabs == 1 then new_subtab:set_active(); self.active_subtab = text else new_subtab:set_not_active() end

	return new_subtab
end

function subtab:set_not_active()
	local h,s,v = lib.accent_color:ToHSV()
	local line, label = self.line, self.label
	line.BackgroundColor3 = Color3.fromHSV(h,s,v*.5)
	label.TextColor3 = Color3.fromRGB(74,74,74)
	self.right.Visible = false
	self.left.Visible = false
end

function subtab:set_active()
	local line, label = self.line, self.label
	line.BackgroundColor3 = lib.accent_color
	label.TextColor3 = lib.accent_color
	self.right.Visible = true
	self.left.Visible = true
end

function subtab:new_section(info)
	local name, side, size = info.name, info.side, info.size

	local SectionFrame = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		Size = udim2new(0, 217, 0, 38);
		Parent = info.side:lower() == "left" and self.left or self.right
	})
	local SectionTop = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 21);
		Parent = SectionFrame
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 16, 16)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 8))};
		Rotation = 90;
		Parent = SectionTop
	})
	local SectionLine = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 1, 0);
		Size = udim2new(1, -2, 0, 1);
		Parent = SectionTop
	})
	local UIGradient_2 = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 32, 32)), ColorSequenceKeypoint.new(0.15, Color3.fromRGB(32, 32, 32)), ColorSequenceKeypoint.new(0.35, Color3.fromRGB(8, 8, 8)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8, 8, 8)), ColorSequenceKeypoint.new(0.65, Color3.fromRGB(8, 8, 8)), ColorSequenceKeypoint.new(0.85, Color3.fromRGB(32, 32, 32)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(32, 32, 32))};
		Parent = SectionLine
	})
	local SectionLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 0);
		Size = udim2new(1, -5, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = name;
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = SectionTop
	})
	local SectionHolder = util:create_new("ScrollingFrame", {
		Active = false;
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 22);
		Size = udim2new(1, -2, 1, -22);
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
		ScrollBarImageColor3 = Color3.fromRGB(56,56,56);
		CanvasSize = udim2new(0, 0, 1, -22);
		ScrollBarThickness = 0;
		ScrollingEnabled = false;
		TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
		Parent = SectionFrame
	})
	local SectionList = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 14, 0, 8);
		Size = udim2new(1, -28, 1, -16);
		Parent = SectionHolder
	})
	local UIListLayout = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = udimnew(0, 9);
		Parent = SectionList
	})

	local new_section = {
		scroller = SectionHolder,
		frame = SectionFrame,
		elements = 0,
		max_size = size,
		holder = SectionList,
		lib = self.lib
	}

	local on_hover = util:create_connection(SectionFrame.MouseEnter, function() 
		if SectionHolder.ScrollingEnabled == true then
			util:tween(SectionHolder, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarThickness = 4})
		end
	end)

	local on_leave = util:create_connection(SectionFrame.MouseLeave, function() 
		if SectionHolder.ScrollingEnabled == true then
			util:tween(SectionHolder, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarThickness = 0})
		end
	end)

	setmetatable(new_section, section)

	return new_section
end

function section:update_size(size2, scroll)
	local frame = (self.frame.Size.Y.Offset >= self.max_size) and self.scroller or self.frame
	if frame.ClassName == "ScrollingFrame" then
		local size = frame.CanvasSize
		frame.ScrollingEnabled = true
		frame.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + size2)
	elseif frame.ClassName == "Frame" then
		self.scroller.ScrollingEnabled = false
		local size = frame.Size
		if frame.Size.Y.Offset + size2 >= self.max_size then
			local leftover = frame.Size.Y.Offset + size2 - self.max_size
			frame.Size = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, self.max_size)

			local frame = self.scroller
			local size = frame.CanvasSize
			frame.ScrollingEnabled = true
			frame.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + leftover)
		else
			frame.Size = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + size2)
		end
	end 
end

function section:remove(size, scroll)
	self.frame:Destroy()
end

function section:new_element(info)
	local name, flag, types, tooltip = info.name, info.flag or "", info.types or {}, info.tip

	local ElementFrame = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 8);
		Parent = self.holder
	})
	local ElementLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 12, 0, 0);
		Size = udim2new(0, util:get_text_size(name) + 4, 0, 7);
		Font = Enum.Font.RobotoMono;
		Text = name;
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = ElementFrame
	})
	local AddonHolder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -30, 0, 0);
		Size = udim2new(0, 30, 0, 8);
		Parent = ElementFrame
	})
	local UIListLayout = util:create_new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder;
		VerticalAlignment = Enum.VerticalAlignment.Center;
		Padding = udimnew(0, 5);
		Parent = AddonHolder
	})

	local new_element = {
		frame = ElementFrame,
		total_size = self.elements == 0 and 8 or 17,
		section = self,
		flag = flag,
		keybinds = 0,
		colorpickers = 0
	}

	if tooltip then
		local on_hover = util:create_connection(ElementLabel.MouseEnter, function()
			if lib.busy then return end
			local image, tip_label, label = self.lib.tip, self.lib.tip:GetChildren()[1], self.lib.build_label
			util:tween(image, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
			util:tween(tip_label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
			util:tween(label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
			tip_label.Text = info.tip
		end)

		local on_leave = util:create_connection(ElementLabel.MouseLeave, function()
			if lib.busy then return end
			local image, tip_label, label = self.lib.tip, self.lib.tip:GetChildren()[1], self.lib.build_label
			util:tween(image, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
			util:tween(tip_label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
			util:tween(label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
		end)
	end

	lib.flags[flag] = {}

	for element, info in pairs(types) do
		if element == "toggle" then 
			local no_load = info.no_load or false
			local on_toggle = info.on_toggle or function() end
			local default = info.default and info.default or false

			local ToggleBox = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(0, 6, 0, 6);
				Parent = ElementFrame
			})
			local ToggleInside = util:create_new("Frame", {
				BackgroundColor3 = lib.accent_color;
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Visible = false;
				Size = udim2new(0, 6, 0, 6);
				Parent = ToggleBox
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(195, 195, 195))};
				Rotation = 90;
				Parent = ToggleInside
			})

			new_element.on_toggle = signal.new("on_toggle")

			local on_hover = util:create_connection(ToggleBox.MouseEnter, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = Color3.fromRGB(126, 126, 126)
				ToggleInside.BackgroundTransparency = 0.5
				ToggleInside.Visible = true
			end)

			local on_hover = util:create_connection(ElementLabel.MouseEnter, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = Color3.fromRGB(126, 126, 126)
				ToggleInside.BackgroundTransparency = 0.5
				ToggleInside.Visible = true
			end)

			local on_leave = util:create_connection(ToggleBox.MouseLeave, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = Color3.fromRGB(74, 74, 74)
				ToggleInside.BackgroundTransparency = 1
				ToggleInside.Visible = false
			end)

			local on_leave = util:create_connection(ElementLabel.MouseLeave, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = Color3.fromRGB(74, 74, 74)
				ToggleInside.BackgroundTransparency = 1
				ToggleInside.Visible = false
			end)

			function new_element:set_toggle(toggle, callback)
				local is_in_toggle = util:is_in_frame(ElementLabel) or util:is_in_frame(ToggleBox)
				ElementLabel.TextColor3 = not toggle and (not is_in_toggle and Color3.fromRGB(74, 74, 74) or Color3.fromRGB(126, 126, 126)) or Color3.fromRGB(221,221,221)
				ToggleInside.BackgroundTransparency = not toggle and (not is_in_toggle and 1 or 0.5) or 0
				ToggleInside.Visible = not toggle and (not is_in_toggle and false or true) or true

				lib.flags[flag]["toggle"] = toggle

				if not callback then
					new_element.on_toggle:Fire(toggle)
				end
			end

			local on_click = util:create_connection(ToggleBox.InputEnded, function(input)
				if lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local toggle = not lib.flags[flag]["toggle"]; lib.flags[flag]["toggle"] = toggle
					new_element:set_toggle(toggle)
				end
			end)

			local on_click = util:create_connection(ElementLabel.InputEnded, function(input)
				if lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local toggle = not lib.flags[flag]["toggle"]; lib.flags[flag]["toggle"] = toggle
					new_element:set_toggle(toggle)
				end
			end)

			local on_window_close = self.lib.on_close:Connect(function()
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = Color3.fromRGB(74, 74, 74)
				ToggleInside.BackgroundTransparency = 1
				ToggleInside.Visible = false
			end)

			lib.flags[flag]["toggle"] = false

			if default and not info.no_load then new_element:set_toggle(default) end

			lib.on_config_load:Connect(function()
				if not info.no_load then
					new_element:set_toggle(lib.flags[flag]["toggle"])
				end
			end)
		elseif element == "keybind" then
			new_element.keybinds+=1

			local AddonImage = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(0, 9, 0, 9);
				Image = "rbxassetid://14138205253";
				ImageColor3 = Color3.fromRGB(74, 74, 74);
				ZIndex = 100;
				Parent = AddonHolder
			})
			local KeybindOpen = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 0, 0);
				Size = udim2new(0, 163, 0, 19);
				Parent = self.lib.screen_gui;
				ZIndex = 15;
				Visible = false
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = KeybindOpen
			})
			local OpenInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = KeybindOpen
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = OpenInside
			})
			local OpenLabel = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = OpenInside
			})
			local UICorner_3 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = OpenLabel
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 16, 16)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 8))};
				Rotation = 90;
				Parent = OpenLabel
			})
			local OpenText = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Font = Enum.Font.RobotoMono;
				Text = "keybind: unbound";
				TextColor3 = Color3.fromRGB(74, 74, 74);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Right;
				ZIndex = 15;
				RichText = true;
				Parent = OpenLabel
			}); local on_size_change = util:create_connection(OpenText:GetPropertyChangedSignal("Size"), function()
				local size = OpenText.Size.X.Offset
				OpenText.Position = udim2new(1, -size, 0, 0)
			end); OpenText.Size = udim2new(0, util:get_text_size("keybind: unbound"), 1, 0);
			local OpenMethod = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0.065750733, 0, 0.0604938269, 0);
				Size = udim2new(0, 65, 0, 60);
				ZIndex = 16;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = OpenMethod
			})
			local MethodInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 16;
				Parent = OpenMethod
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = MethodInside
			})
			local UIListLayout = util:create_new("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Parent = MethodInside
			})
			local HoldLabel = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(27, 27, 27);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 0, 19);
				Font = Enum.Font.RobotoMono;
				Text = " hold";
				TextColor3 = lib.accent_color;
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 16;
				Parent = MethodInside
			})
			local ToggleLabel = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(27, 27, 27);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 0, 20);
				Font = Enum.Font.RobotoMono;
				Text = " toggle";
				TextColor3 = Color3.fromRGB(126, 126, 126);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 16;
				Parent = MethodInside
			})
			local AlwaysLabel = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(27, 27, 27);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 0, 19);
				Font = Enum.Font.RobotoMono;
				Text = " always";
				TextColor3 = Color3.fromRGB(126, 126, 126);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 16;
				Parent = MethodInside
			})

			local is_open, binding, is_choosing_method = false, false, false
			local addon_cover = self.lib.addon_cover

			local on_enter_alt = util:create_connection(OpenText.MouseEnter, function()
				OpenText.TextColor3 = Color3.fromRGB(126,126,126)
			end)

			local on_leave_alt = util:create_connection(OpenText.MouseLeave, function()
				if binding then return end
				OpenText.TextColor3 = Color3.fromRGB(74,74,74)
			end)

			lib.flags[flag]["bind"] = {
				["key"] = "unbound",
				["method"] = "hold"
			}

			local method = info.method and info.method or "hold"
			local key = info.key and info.key or "unbound"

			local function start_binding()
				binding = true
				OpenText.Text = "keybind: <font color=\"rgb(189, 172, 255)\">"..string.sub(OpenText.Text, 10, #OpenText.Text).."</font>";
			end

			new_element.on_key_change = signal.new("on_key_change")
			new_element.on_method_change = signal.new("on_method_change")

			local function stop_binding()
				binding = false
				if not util:is_in_frame(OpenText) then
					OpenText.TextColor3 = Color3.fromRGB(74,74,74)
				end
			end

			local function set_key(key2)
				lib.flags[flag]["bind"]["key"] = key2
				key = key2
				OpenText.Text = "keybind: "..lib.flags[flag]["bind"]["key"]
				OpenText.Size = udim2new(0, util:get_text_size(OpenText.Text), 1, 0);
				new_element.on_key_change:Fire(key2)
			end

			local function open_method()
				if info.method_lock then return end
				is_choosing_method = true
				OpenMethod.Visible = true
				OpenMethod.Position = udim2new(0, mouse.X, 0, mouse.Y)
			end

			local function close_method()
				is_choosing_method = false
				OpenMethod.Visible = false
			end

			local function set_method(method2) 
				local label = (method2 == "always" and AlwaysLabel) or (method2 == "toggle" and ToggleLabel) or (method2 == "hold" and HoldLabel)
				local children = MethodInside:GetChildren()
				for i = 1, #children do
					local child = children[i]
					if child.ClassName == "TextLabel" then
						child.TextColor3 = Color3.fromRGB(126,126,126)
					end
				end
				label.TextColor3 = lib.accent_color
				lib.flags[flag]["bind"]["method"] = method2
				new_element.on_method_change:Fire(method2)
				method = method2
				if method2 == "always" then
					if lib.flags[flag]["toggle"] ~= nil then
						if not lib.flags[flag]["toggle"] then return end
					end
					new_element.on_activate:Fire()
				end
			end

			local children = MethodInside:GetChildren()

			for i = 1, #children do
				local child = children[i]
				if child.ClassName == "TextLabel" then
					local on_enter = util:create_connection(child.MouseEnter, function()
						child.BackgroundTransparency = 0
					end)

					local on_leave = util:create_connection(child.MouseLeave, function()
						child.BackgroundTransparency = 1
					end)

					local on_click = util:create_connection(child.InputBegan, function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							set_method(string.sub(child.Text, 2, #child.text))
						end 
					end)
				end
			end

			local on_close = self.lib.on_close:Connect(function()
				if is_open then
					close_keybind()
					addon_cover.Visible = false
				end
			end)

			local function open_keybind()
				lib.busy = true; is_open = true
				KeybindOpen.Visible = true
				AddonImage.ImageColor3 = Color3.fromRGB(255,255,255)
				addon_cover.Visible = true
				addon_cover.BackgroundTransparency = 1
				util:tween(addon_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

				local absPos = AddonImage.AbsolutePosition
				KeybindOpen.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function close_keybind()
				is_open = false
				KeybindOpen.Visible = false
				OpenText.TextColor3 = Color3.fromRGB(74,74,74)
				util:tween(addon_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
				task.delay(0.3, function()
					if addon_cover.BackgroundTransparency > 0.99 then
						addon_cover.Visible = false
					end
				end)
				AddonImage.ImageColor3 = Color3.fromRGB(74,74,74)
				if binding then stop_binding() end
				if is_choosing_method then close_method() end
				task.delay(0.03, function()
					lib.busy = false; 
				end)
			end

			local on_hover = util:create_connection(AddonImage.MouseEnter, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = Color3.fromRGB(126,126,126)
			end)

			local on_leave = util:create_connection(AddonImage.MouseLeave, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = Color3.fromRGB(74,74,74)
			end)

			local on_mouse1alt = util:create_connection(OpenText.InputEnded, function(input, gpe)
				if binding then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					task.delay(0.01, start_binding)
				elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
					if not is_choosing_method then
						open_method()
					end
				end
			end)

			local on_mouse1 = util:create_connection(AddonImage.InputBegan, function(input, gpe)
				if lib.busy or gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not lib.busy then AddonImage.ImageColor3 = Color3.fromRGB(255,255,255) end
				end
			end)

			local on_mouse1end = util:create_connection(AddonImage.InputEnded, function(input, gpe)
				if lib.busy or gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not lib.busy then open_keybind() end
				end
			end)

			local on_window_close = util:create_connection(self.lib.on_close, function()
				addon_cover.Visible = false
				if is_open then close_keybind() end
			end)

			local on_input = util:create_connection(uis.InputEnded, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and is_choosing_method then
					task.delay(0.01, close_method)
				end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and is_open and not util:is_in_frame(AddonImage) and not util:is_in_frame(KeybindOpen) then
					if is_choosing_method and util:is_in_frame(OpenMethod) then
					else
						close_keybind()
					end
				elseif binding then
					local inputType = input.UserInputType
					local key = (inputType == Enum.UserInputType.MouseButton2 and "mouse 2") or (inputType == Enum.UserInputType.MouseButton1 and "mouse 1") or (inputType == Enum.UserInputType.MouseButton3 and "mouse 3") or (input.KeyCode.Name == "Unknown" and "unbound") or (input.KeyCode.Name == "Escape" and "unbound")
					set_key(key and key or string.lower(input.KeyCode.Name))
					stop_binding()
				end
			end)

			new_element.on_deactivate = signal.new("on_deactivate")
			new_element.on_activate = signal.new("on_activate")

			local active = false

			function new_element:is_active()
				return method == "always" and true or active
			end

			local on_key_press = util:create_connection(uis.InputBegan, function(input, gpe)
				if gpe or method == "always" then return end
				if string.lower(input.KeyCode.Name) == key then
					if lib.flags[flag]["toggle"] ~= nil then
						if not lib.flags[flag]["toggle"] then return end
					end
					active = method == "hold" and true or method == "toggle" and not active
					if active then new_element.on_activate:Fire() else new_element.on_deactivate:Fire() end
				elseif string.find(key, "mouse") then
					if lib.flags[flag]["toggle"] ~= nil then
						if not lib.flags[flag]["toggle"] then return end
					end
					if input.UserInputType == Enum.UserInputType.MouseButton2 and key == "mouse 2" then
						active = method == "hold" and true or method == "toggle" and not active
						if active then new_element.on_activate:Fire() else new_element.on_deactivate:Fire() end
					elseif input.UserInputType == Enum.UserInputType.MouseButton3 and key == "mouse 3" then
						active = method == "hold" and true or method == "toggle" and not active
						if active then new_element.on_activate:Fire() else new_element.on_deactivate:Fire() end
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 and key == "mouse 1" then
						active = method == "hold" and true or method == "toggle" and not active
						if active then new_element.on_activate:Fire() else new_element.on_deactivate:Fire() end
					end
				end
			end)

			local on_key_stopped = util:create_connection(uis.InputEnded, function(input, gpe)
				if gpe or method == "always" then return end
				if string.lower(input.KeyCode.Name) == key and method == "hold" then
					if lib.flags[flag]["toggle"] ~= nil then
						if not lib.flags[flag]["toggle"] then return end
					end
					active = false
					new_element.on_deactivate:Fire()
				elseif string.find(key, "mouse") then
					if lib.flags[flag]["toggle"] ~= nil then
						if not lib.flags[flag]["toggle"] then return end
					end
					if input.UserInputType == Enum.UserInputType.MouseButton2 and key == "mouse2" then
						active = false
						new_element.on_deactivate:Fire()
					elseif input.UserInputType == Enum.UserInputType.MouseButton3 and key == "mouse3" then
						active = false
						new_element.on_deactivate:Fire()
					elseif input.UserInputType == Enum.UserInputType.MouseButton1 and key == "mouse1" then
						active = false
						new_element.on_deactivate:Fire()
					end
				end
			end)

			set_key(info.key and info.key or "unbound")
			set_method(info.method and info.method or "hold")

			lib.on_config_load:Connect(function()
				set_key(lib.flags[flag]["bind"]["key"])
				set_method(lib.flags[flag]["bind"]["method"])
			end)
		elseif element == "slider" then
			new_element.total_size+=13
			local SliderBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = udim2new(0, 12, 0, 15);
				Size = udim2new(1, -24, 0, 6);
				Parent = ElementFrame
			})
			local SliderFill = util:create_new("Frame", {
				BackgroundColor3 = lib.accent_color;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, 0);
				Parent = SliderBackground
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(195, 195, 195))};
				Rotation = 90;
				Parent = SliderFill
			})
			local SliderText = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -12, 0, 0);
				Size = udim2new(0, 0, 0, 7);
				Font = Enum.Font.RobotoMono;
				Text = "100%";
				TextColor3 = Color3.fromRGB(74, 74, 74);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Right;
				Parent = ElementFrame
			})

			local min, max, default, decimal, on_value_change, suffix, prefix = info.min, info.max, info.default, info.decimal or info.decimals, info.on_value_change or function() end, info.suffix or "", info.prefix or ""
			local dragging = false

			new_element.on_value_change = signal.new("on_value_change")

			lib.flags[flag]["value"] = min

			local function set_value(value, do_callback)
				local value = clamp(value, min, max)
				SliderFill.Size = udim2new((value - min)/(max-min), 0, 1, 0)
				SliderText.Text = prefix..value..suffix
				lib.flags[flag]["value"] = value
				if value > min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
					ElementLabel.TextColor3 = Color3.fromRGB(221,221,221)
				else
					ElementLabel.TextColor3 = util:is_in_frame(SliderBackground) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
				end
				new_element.on_value_change:Fire(value)
			end

			local on_input_began = util:create_connection(SliderBackground.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not lib.busy then
					lib.busy = true
					local distance = clamp((mouse.X - SliderBackground.AbsolutePosition.X)/SliderBackground.AbsoluteSize.X, 0, 1)
					local value = util:round(min + (max - min) * distance, decimal and decimal or 0)
					set_value(value, true)

					dragging = true
				end
			end)

			local on_input_end = util:create_connection(SliderBackground.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
					lib.busy = false
					dragging = false
				end
			end)

			--[[local on_window_close = lib.on_close:Connect(function()
				dragging = false
			end)--]]

			local on_mouse_move = util:create_connection(mouse.Move, function()
				if dragging then
					local distance = clamp((mouse.X - SliderBackground.AbsolutePosition.X)/SliderBackground.AbsoluteSize.X, 0, 1)
					local value = util:round(min + (max-min) * distance, decimal and decimal or 0)
					set_value(value, true)
				end
			end)

			local on_enter = util:create_connection(SliderBackground.MouseEnter, function()
				if lib.busy then return end
				if lib.flags[flag]["value"] == min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
					ElementLabel.TextColor3 = Color3.fromRGB(126,126,126)
				end
			end)

			local on_leave = util:create_connection(SliderBackground.MouseLeave, function()
				if lib.busy then return end
				if lib.flags[flag]["value"] == min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
					ElementLabel.TextColor3 = Color3.fromRGB(74,74,74)
				end
			end)

			set_value(default and default or min)

			lib.on_config_load:Connect(function()
				set_value(lib.flags[flag]["value"])
			end)
		elseif element == "dropdown" then
			new_element.total_size+=24

			local DropdownBorder = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 12);
				Size = udim2new(1, -24, 0, 20);
				Parent = ElementFrame
			})
			local DropdownBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = DropdownBorder
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(23, 23, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
				Rotation = 90;
				Parent = DropdownBackground
			})
			local DropdownImage = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -13, 0.5, -4);
				Size = udim2new(0, 8, 0, 8);
				Image = "http://www.roblox.com/asset/?id=14138109916";
				ImageColor3 = Color3.fromRGB(74, 74, 74);
				Parent = DropdownBackground
			})
			local DropdownText = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 5, 0, 0);
				Size = udim2new(1, -23, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = "-";
				TextColor3 = Color3.fromRGB(74, 74, 74);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextWrapped = true;
				ClipsDescendants = true;
				Parent = DropdownBackground
			})
			local OpenDropdown = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 440, 0, 54);
				Size = udim2new(0, 163, 0, 60);
				Parent = self.lib.screen_gui
			}); OpenDropdown.Visible = false
			local OpenInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				ClipsDescendants = true;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = OpenDropdown
			})
			local UIListLayout = util:create_new("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Parent = OpenInside
			})

			local is_open = false

			lib.flags[flag]["selected"] = {}

			local options = info.options and info.options or {}
			local default = info.default and info.default or {}
			local multi = info.multi and info.multi or false
			local no_none = info.no_none and info.no_none or false

			new_element.on_option_change = signal.new("on_option_change")


			local function set_options(options)
				lib.flags[flag]["selected"] = options
				for i,v in pairs(OpenInside:GetChildren()) do
					if v.ClassName == "TextLabel" then
						if util:find(options, v.Name) then 
							v.TextColor3 = lib.accent_color
							v.BackgroundTransparency = util:is_in_frame(v) and 0 or 1
						else
							v.TextColor3 = util:is_in_frame(v) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
							v.BackgroundTransparency = util:is_in_frame(v) and 0 or 1
						end
					end
				end
				local text = ""
				for i = 1, #options do
					local option = options[i]
					if text == "" then 
						text = option
					else
						text = text..", "..option
					end
				end
				DropdownText.Text = text ~= "" and text or "-"
				lib.flags[flag]["selected"] = options
				new_element.on_option_change:Fire(options)
			end

			OpenDropdown.Size = udim2new(0, 163, 0, #options*20)

			local function open_dropdown()
				local abspos = DropdownBorder.AbsolutePosition
				OpenDropdown.Position = udim2new(0, abspos.X + 1, 0, abspos.Y + 22)
				OpenDropdown.Visible = true
				ElementLabel.TextColor3 = Color3.fromRGB(221,221,221)
				DropdownText.TextColor3 = Color3.fromRGB(221,221,221)
				DropdownImage.ImageColor3 = Color3.fromRGB(221,221,221)
				is_open = true; lib.busy = true;
			end

			local function close_dropdown()
				OpenDropdown.Visible = false
				is_open = false; task.delay(0, function()
					lib.busy = false; 
				end)
				ElementLabel.TextColor3 = (#lib.flags[flag]["selected"] == 0 and (util:is_in_frame(DropdownBorder) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)) or Color3.fromRGB(221,221,221))
				DropdownText.TextColor3 = util:is_in_frame(DropdownBorder) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
				DropdownImage.ImageColor3 = util:is_in_frame(DropdownBorder) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
				Color = util:is_in_frame(DropdownBorder) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(33, 33, 33)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(23, 23, 23))} or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(23, 23, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
			end

			local on_close = self.lib.on_close:Connect(function()
				if is_open then
					close_dropdown()
				end
			end)

			for i = 1, #options do
				local option = options[i]
				local DropdownOption = util:create_new("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(24, 24, 24);
					BackgroundTransparency = 1.000;
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 20);
					Font = Enum.Font.RobotoMono;
					Text = " "..option;
					TextColor3 = Color3.fromRGB(74, 74, 74);
					TextSize = 12.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = OpenInside
				}); DropdownOption.Name = option

				local on_hover = util:create_connection(DropdownOption.MouseEnter, function()
					if not util:find(lib.flags[flag]["selected"], option) then
						DropdownOption.TextColor3 = Color3.fromRGB(126,126,126)
					end
					DropdownOption.BackgroundTransparency = 0
				end)

				local on_leave = util:create_connection(DropdownOption.MouseLeave, function()
					if not util:find(lib.flags[flag]["selected"], option) then
						DropdownOption.TextColor3 = Color3.fromRGB(74,74,74)
					end
					DropdownOption.BackgroundTransparency = 1
				end)

				local on_click = util:create_connection(DropdownOption.InputEnded, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local new_selected = util:copy(lib.flags[flag]["selected"])
						local is_found = util:find(lib.flags[flag]["selected"], option)
						if is_found then
							table.remove(new_selected, is_found)
						else
							if (#new_selected > 0 and multi) or #new_selected == 0 then
								table.insert(new_selected, option)
							elseif not multi then
								new_selected = {option}
							end
						end
						if #new_selected == 0 and no_none then 
							return 
						else
							set_options(new_selected)
							if not multi then
								close_dropdown()
							end
						end
					end
				end)
			end

			local on_click = util:create_connection(DropdownBorder.InputBegan, function(input, gpe)
				if gpe then return end
				if lib.busy and not is_open then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not lib.busy then
						open_dropdown()
					elseif is_open then
						close_dropdown()
					end
				end				
			end)

			--[[
			local on_window_close = util:create_connection(self.lib.on_close, function()
				if is_open then close_dropdown() end
			end)
			]]

			local on_enter = util:create_connection(DropdownBorder.MouseEnter, function()
				if is_open or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(33, 33, 33)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(23, 23, 23))};
				DropdownText.TextColor3 = Color3.fromRGB(126,126,126)
				DropdownImage.ImageColor3 = Color3.fromRGB(126,126,126)
				if #lib.flags[flag]["selected"] == 0 then
					ElementLabel.TextColor3 = Color3.fromRGB(126,126,126)
				end
			end)

			local on_enter = util:create_connection(DropdownBorder.MouseLeave, function()
				if is_open or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(23, 23, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
				DropdownText.TextColor3 = Color3.fromRGB(74,74,74)
				DropdownImage.ImageColor3 = Color3.fromRGB(74,74,74)
				if #lib.flags[flag]["selected"] == 0 then
					ElementLabel.TextColor3 = Color3.fromRGB(74,74,74)
				end
			end)

			local on_click = util:create_connection(uis.InputEnded, function(input, gpe)
				if gpe then return end
				if lib.busy and not is_open then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and is_open and not util:is_in_frame(DropdownBorder) and not util:is_in_frame(OpenDropdown) then 
					close_dropdown()
				end
			end)

			if default then
				set_options(default)
			end

			lib.on_config_load:Connect(function()
				set_options(lib.flags[flag]["selected"])
			end)	
		elseif element == "button" then
			new_element.total_size+=16

			local confirmation = info.confirmation and info.confirmation or false

			local Button = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 0);
				Size = udim2new(1, -24, 0, 24);
				Parent = ElementFrame
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 3);
				Parent = Button
			})
			local ButtonInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = Button
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 3);
				Parent = ButtonInside
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
				Rotation = 90;
				Parent = ButtonInside
			})
			local ButtonLabel = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = ElementLabel.Text;
				TextColor3 = Color3.fromRGB(74, 74, 74);
				TextSize = 12.000;
				Parent = ButtonInside
			}); ElementLabel:Destroy()

			local is_holding = false

			new_element.on_clicked = signal.new("on_clicked")

			local on_hover = util:create_connection(Button.MouseEnter, function()
				if is_holding or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}
				ButtonLabel.TextColor3 = Color3.fromRGB(221,221,221)
			end)

			local on_leave = util:create_connection(Button.MouseLeave, function()
				if is_holding or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
				ButtonLabel.TextColor3 = Color3.fromRGB(74,74,74)
			end)

			local on_click = util:create_connection(Button.InputBegan, function(input, gpe)
				if gpe or lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					is_holding = true
					ButtonLabel.TextColor3 = lib.accent_color
					Button.BackgroundColor3 = lib.accent_color
				end
			end)

			local confirmation_cover = self.lib.confirmation_cover
			local confirmation_frame = self.lib.confirmation

			local is_in_confirmation = false

			local on_stopclick = util:create_connection(Button.InputEnded, function(input, gpe)
				if gpe or lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and is_holding then
					is_holding = false
					ButtonLabel.TextColor3 = util:is_in_frame(Button) and Color3.fromRGB(221,221,221) or Color3.fromRGB(74,74,74)
					Color = util:is_in_frame(Button) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
					Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					if confirmation then
						confirmation_cover.Visible = true
						self.lib.cflabel.Text = confirmation.text
						self.lib.cftoplabel.Text = confirmation.top
						util:tween(confirmation_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
						confirmation_frame.Visible = true
						lib.busy = true
						is_in_confirmation = true
					else
						new_element.on_clicked:Fire()
					end
				end
			end)

			local on_close = self.lib.on_close:Connect(function()
				confirmation_cover.BackgroundTransparency = 1
				confirmation_cover.Visible = false
				lib.busy = false
				is_in_confirmation = false
			end)

			local on_confirmed = self.lib.confirmationsignal:Connect(function(t)
				if is_in_confirmation then
					if t then
						new_element.on_clicked:Fire()
					end
					task.delay(0.3, function() 
						if confirmation_cover.BackgroundTransparency > .99 then
							confirmation_cover.Visible = false
						end
					end)
					util:tween(confirmation_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
					confirmation_frame.Visible = false
					task.delay(0.03, function()
						lib.busy = false
					end)
					is_in_confirmation = false
				end
			end)
		elseif element == "multibox" then
			new_element.total_size+=(21+(info.maxsize*17))
			ElementLabel:Destroy()
			local MultiboxTextbox = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 0);
				Size = udim2new(1, -24, 0, 19);
				Parent = ElementFrame
			})
			local DropdownBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(24, 24, 24);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = MultiboxTextbox
			})
			local TextBox = util:create_new("TextBox", {
				Parent = DropdownBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 5, 0, 0);
				Size = udim2new(1, -5, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = "";
				TextColor3 = Color3.fromRGB(74, 74, 74);
				TextSize = 12.000;
				ClearTextOnFocus = false;
				TextXAlignment = Enum.TextXAlignment.Left
			}); local on_focus = util:create_connection(TextBox.Focused, function()
				if lib.busy then TextBox:ReleaseFocus(); return end
			end)
			local MultiboxOpen = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 19);
				Size = udim2new(1, -24, 0, 2 + info.maxsize*17);
				Parent = ElementFrame
			})
			local MultiboxScroll = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = MultiboxOpen
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 23, 22)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
				Rotation = 90;
				Parent = MultiboxScroll
			})
			local MultiboxInside = util:create_new("ScrollingFrame", {
				Active = true;
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, 0);
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				CanvasSize = udim2new(0, 0, 1, 0);
				ScrollBarImageColor3 = Color3.fromRGB(56,56,56);
				ScrollBarThickness = 4;
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				ScrollingEnabled = false;
				Parent = MultiboxScroll
			}); local on_text_change = util:create_connection(TextBox:GetPropertyChangedSignal("Text"), function()
				local text = string.lower(TextBox.Text)
				local all_labels = MultiboxInside:GetChildren()
				for i = 1, #all_labels do
					local label = all_labels[i]
					if label.ClassName == "TextLabel" then
						if string.lower(label.Name):find(text) or text == " " or text == "" then
							label.Visible = true
						else
							label.Visible = false
						end
					end
				end
			end)
			local UIListLayout = util:create_new("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical;
				SortOrder = Enum.SortOrder.Name;
				VerticalAlignment = Enum.VerticalAlignment.Top;
				Padding = udimnew(0,0);
				Parent = MultiboxInside
			})

			new_element.on_option_change = signal.new("on_option_change")

			local options = 0

			local selected = nil

			local function set_option(option)
				local all_labels = MultiboxInside:GetChildren()
				for i = 1, #all_labels do
					local label = all_labels[i]
					if label.ClassName == "TextLabel" then
						label.Line.Visible = false
						label.Line.Fade.Visible = false
						label.TextColor3 = util:is_in_frame(label) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
					end
				end
				local label = MultiboxInside:FindFirstChild(option)
				label.Line.Visible = true
				label.Line.Fade.Visible = true
				label.TextColor3 = Color3.fromRGB(221,221,221)
				selected = option
				new_element.on_option_change:Fire(selected)
			end

			function new_element:add_option(option)
				options+=1
				local MultiboxLabel = util:create_new("TextLabel", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 17);
					ZIndex = 2;
					Font = Enum.Font.RobotoMono;
					Text = " "..option;
					TextColor3 = Color3.fromRGB(74, 74, 74);
					TextSize = 12.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = MultiboxInside
				}); MultiboxLabel.Name = option
				local MultiLine = util:create_new("Frame", {
					BackgroundColor3 = lib.accent_color;
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 1, 1, 0);
					Visible = false;
					ZIndex = 2;
					Parent = MultiboxLabel
				}); MultiLine.Name = "Line"
				local LabelFade = util:create_new("Frame", {
					BackgroundColor3 = Color3.fromRGB(254, 254, 254);
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 40, 1, 0);
					Visible = false;
					Parent = MultiLine
				}); LabelFade.Name = "Fade"
				local UIGradient_2 = util:create_new("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))};
					Parent = LabelFade
				})

				local on_enter = util:create_connection(MultiboxLabel.MouseEnter, function()
					if selected == option or lib.busy then return end
					MultiboxLabel.TextColor3 = Color3.fromRGB(126,126,126)
				end)

				local on_leave = util:create_connection(MultiboxLabel.MouseLeave, function()
					if selected == option or lib.busy then return end
					MultiboxLabel.TextColor3 = Color3.fromRGB(74,74,74)
				end)

				local on_leave = util:create_connection(MultiboxLabel.InputBegan, function(input, gpe)
					if gpe or lib.busy then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if selected == option then return end
						set_option(option)
					end
				end)
				if options > info.maxsize then
					local size = MultiboxInside.CanvasSize
					MultiboxInside.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + 17)
					MultiboxInside.ScrollingEnabled = true
				else
					MultiboxInside.ScrollingEnabled = false
				end
				if selected == nil then set_option(option) end
			end

			function new_element:remove_option(option)
				if options > info.maxsize then
					local size = MultiboxInside.CanvasSize
					MultiboxInside.CanvasSize = udim2new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset - 17)
					MultiboxInside.ScrollingEnabled = true
				else
					MultiboxInside.ScrollingEnabled = false
				end
				options-=1
				local label = MultiboxInside:FindFirstChild(option)
				if label then
				label:Destroy()
				end
				if selected == nil then
				local all_labels = MultiboxInside:GetChildren()
					for i = 1, #all_labels do
						local label = all_labels[i]
						if label.ClassName == "TextLabel" then
							set_option(label.Name)
							return
						end
					end
				end
				if selected == option then selected = nil end
			end
		elseif element:find("colorpicker") then
			new_element.colorpickers+=1
			local AddonImage = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(0, 9, 0, 9);
				Image = "rbxassetid://14138205253";
				ImageColor3 = Color3.fromRGB(74, 74, 74);
				ZIndex = 14;
				Parent = AddonHolder
			})
			local ColorpickerOpen = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0.329400182, 0, 0.683950603, 0);
				Size = udim2new(0, 163, 0, 181);
				ZIndex = 15;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerOpen
			})
			local ColorpickerBorder = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = ColorpickerOpen
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerBorder
			})
			local ColorpickerInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = ColorpickerBorder
			})
			local UICorner_3 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerInside
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 16, 16)), ColorSequenceKeypoint.new(0.35, Color3.fromRGB(8, 8, 8)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 8))};
				Rotation = 90;
				Parent = ColorpickerInside
			})
			local SaturationImage = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(170, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = udim2new(0, 3, 0, 17);
				Size = udim2new(0, 141, 0, 145);
				ZIndex = 16;
				Image = "rbxassetid://13966897785";
				Parent = ColorpickerInside
			})
			local SaturationMover = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				BackgroundTransparency = 1;
				ZIndex = 17;
				Size = udim2new(0, 4, 0, 4);
				Image = "http://www.roblox.com/asset/?id=14138315296";
				Parent = SaturationImage
			})
			local HueFrame = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = udim2new(1, -11, 0, 17);
				Size = udim2new(0, 8, 0, 145);
				ZIndex = 15;
				Parent = ColorpickerInside
			})
			local UIGradient_2 = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(170, 0, 0)), ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(175, 0, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(170, 0, 0))};
				Rotation = 90;
				Parent = HueFrame
			})
			local HueMover = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, -1, 0, 0);
				Size = udim2new(0, 10, 0, 3);
				ZIndex = 15;
				Image = "http://www.roblox.com/asset/?id=14138375431";
				Parent = HueFrame
			})
			local TransparencyFrame = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = udim2new(0, 3, 1, -11);
				Size = udim2new(0, 141, 0, 8);
				ZIndex = 15;
				Parent = ColorpickerInside
			})
			local TransparencyMover = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -3, 0, -1);
				Size = udim2new(0, 3, 0, 10);
				ZIndex = 15;
				Image = "http://www.roblox.com/asset/?id=14138391128";
				Parent = TransparencyFrame
			})
			local ColorpickerOpen2 = util:create_new("ImageLabel", {
				Parent = self.lib.screen_gui;
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 0, 0);
				Size = udim2new(0, 100, 0, 60);
				ZIndex = 15;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerOpen2
			})
			local ColorpickerBorder2 = util:create_new("Frame", {
				Parent = ColorpickerOpen2;
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerBorder2
			})
			local ColorpickerInside2 = util:create_new("Frame", {
				Parent = ColorpickerBorder2;
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15	
			})
			local UICorner_3 = util:create_new("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerInside2
			})
			local UIGradient = util:create_new("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 16, 16)), ColorSequenceKeypoint.new(0.35, Color3.fromRGB(8, 8, 8)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 8))};
				Rotation = 90;
				Parent = ColorpickerInside2
			})
			local ColorBox2 = util:create_new("Frame", {
				Parent = ColorpickerInside2;
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -12, 0, 2);
				Size = udim2new(0, 10, 0, 10);
				ZIndex = 66
			})
			local HexLabel = util:create_new("TextLabel", {
				Parent = ColorpickerInside2;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 80, 0, 1);
				Size = udim2new(0, 0, 0, 12);
				ZIndex = 66;
				Font = Enum.Font.RobotoMono;
				Text = "#ffffff";
				TextColor3 = Color3.fromRGB(126, 126, 126);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Right;
				Parent = ColorpickerInside2
			})
			local PasteLabel = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 1, -16);
				Size = udim2new(1, 0, 0, 12);
				ZIndex = 66;
				Font = Enum.Font.RobotoMono;
				Text = "paste color";
				TextColor3 = Color3.fromRGB(126, 126, 126);
				TextSize = 12.000;
				Parent = ColorpickerInside2
			})
			local CopyLabel = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 1, -34);
				Size = udim2new(1, 0, 0, 12);
				ZIndex = 66;
				Font = Enum.Font.RobotoMono;
				Text = "copy color";
				TextColor3 = Color3.fromRGB(126, 126, 126);
				TextSize = 12.000;
				Parent = ColorpickerInside2
			})

			lib.flags[flag]["color"] = info.color and info.color or Color3.fromRGB(255,255,255)
			lib.flags[flag]["transparency"] = info.transparency and info.transparency or 0

			local is_open = false
			local is_open2 = false
			local addon_cover = self.lib.addon_cover

			new_element.on_color_change = signal.new("on_color_change")
			new_element.on_transparency_change = signal.new("on_transparency_change")

			local function open_colorpicker()
				lib.busy = true; is_open = true
				ColorpickerOpen.Visible = true
				AddonImage.ImageColor3 = Color3.fromRGB(255,255,255)
				addon_cover.Visible = true
				addon_cover.BackgroundTransparency = 1
				AddonImage.ZIndex = 16
				util:tween(addon_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

				local absPos = AddonImage.AbsolutePosition
				ColorpickerOpen.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function open_colorpicker_alt()
				lib.busy = true; is_open2 = true
				ColorpickerOpen2.Visible = true
				AddonImage.ImageColor3 = Color3.fromRGB(255,255,255)
				addon_cover.Visible = true
				addon_cover.BackgroundTransparency = 1
				AddonImage.ZIndex = 67
				util:tween(addon_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

				local absPos = AddonImage.AbsolutePosition
				ColorpickerOpen2.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function close_colorpicker_alt()
				task.delay(0.03, function()
					lib.busy = false
				end)
				is_open2 = false
				ColorpickerOpen2.Visible = false
				AddonImage.ZIndex = 14
				util:tween(addon_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
				task.delay(0.3, function()
					if addon_cover.BackgroundTransparency > 0.99 then
						addon_cover.Visible = false
					end
				end)
				AddonImage.ImageColor3 = Color3.fromRGB(74,74,74)
			end

			local function close_colorpicker()
				task.delay(0.03, function()
					lib.busy = false
				end)
				is_open = false
				ColorpickerOpen.Visible = false
				AddonImage.ZIndex = 14
				util:tween(addon_cover, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
				task.delay(0.3, function()
					if addon_cover.BackgroundTransparency > 0.99 then
						addon_cover.Visible = false
					end
				end)
				AddonImage.ImageColor3 = Color3.fromRGB(74,74,74)
			end

			local on_close = self.lib.on_close:Connect(function()
				if is_open then
					close_colorpicker()
					addon_cover.Visible = false
				end
				if is_open2 then
					close_colorpicker_alt()
					addon_cover.Visible = false
				end
			end)

			local on_hover = util:create_connection(AddonImage.MouseEnter, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = Color3.fromRGB(126,126,126)
			end)

			local on_leave = util:create_connection(AddonImage.MouseLeave, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = Color3.fromRGB(74,74,74)
			end)

			local on_hover = util:create_connection(CopyLabel.MouseEnter, function()
				CopyLabel.TextColor3 = Color3.fromRGB(221,221,221)
			end)

			local on_leave = util:create_connection(CopyLabel.MouseLeave, function()
				CopyLabel.TextColor3 = Color3.fromRGB(126,126,126)
			end)

			local on_hover = util:create_connection(PasteLabel.MouseEnter, function()
				PasteLabel.TextColor3 = Color3.fromRGB(221,221,221)
			end)

			local on_leave = util:create_connection(PasteLabel.MouseLeave, function()
				PasteLabel.TextColor3 = Color3.fromRGB(126,126,126)
			end)

			local on_mouse1 = util:create_connection(CopyLabel.InputBegan, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					CopyLabel.TextColor3 = lib.accent_color
					if is_open2 then lib.copied_color = lib.flags[flag]["color"] end
				end
			end)
		
			local on_mouse1_end = util:create_connection(CopyLabel.InputEnded, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					CopyLabel.TextColor3 = util:is_in_frame(CopyLabel) and Color3.fromRGB(221,221,221) or Color3.fromRGB(126,126,126)
				end
			end)

			local on_mouse1 = util:create_connection(AddonImage.InputBegan, function(input, gpe)
				if lib.busy or gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not lib.busy then AddonImage.ImageColor3 = Color3.fromRGB(255,255,255) end
				end
			end)

			local on_mouse1end = util:create_connection(AddonImage.InputEnded, function(input, gpe)
				if lib.busy or gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not lib.busy then open_colorpicker() elseif is_open then close_colorpicker() end
					if is_open2 then close_colorpicker_alt() end
				elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
					if not lib.busy then open_colorpicker_alt() elseif is_open2 then close_colorpicker_alt() end
				end
			end)

			local on_mouse1end = util:create_connection(uis.InputBegan, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if is_open and not util:is_in_frame(AddonImage) and not util:is_in_frame(ColorpickerOpen) then
						close_colorpicker()
					elseif is_open2 and not util:is_in_frame(AddonImage) and not util:is_in_frame(ColorpickerOpen2) then
						close_colorpicker_alt()
					end
				end
			end)

			local hue, saturation, value = 0, 0, 255

            local color = info.color and info.color or Color3.fromRGB(255,255,255)
            local transparency =  info.transparency and info.transparency or 0

            local dragging_sat, dragging_hue, dragging_trans = false, false, false
			local on_transparency_change = info.on_transparency_change and info.on_transparency_change or function() end
			local on_color_change = info.on_color_change and info.on_color_change or function() end

            local function update_sv(val, sat, nocallback)
                saturation = sat
                value = val 
                color = Color3.fromHSV(hue/360, saturation/255, value/255)
                SaturationMover.Position = udim2new(clamp(sat/255, 0, 0.98), 0, 1 - clamp(val/255, 0.02, 1), 0)
                lib.flags[flag]["color"] = color
				ColorBox2.BackgroundColor3 = color
				HexLabel.Text = util:to_hex(color)
                new_element.on_color_change:Fire(color)
            end

            local function update_hue(hue2)
                SaturationImage.BackgroundColor3 = Color3.fromHSV(hue2/360, 1, 1)
                HueMover.Position = udim2new(0, -1, clamp(hue2/360, 0, 0.99), -1)
                color = Color3.fromHSV(hue2/360, saturation/255, value/255)
                hue = hue2
                lib.flags[flag]["color"] = color
				HexLabel.Text = util:to_hex(color)
				ColorBox2.BackgroundColor3 = color
                new_element.on_color_change:Fire(color)
            end

            local function update_transparency(o, nocallback)
                TransparencyMover.Position = udim2new(clamp(1 - o, 0, 0.98), 0, 0, -1)
                lib.flags[flag]["transparency"] = o
                transparency = o
                new_element.on_transparency_change:Fire(transparency)
				TransparencyFrame.BackgroundColor3 = Color3.new(0.75 - o*.5, 0.75 - o*.5, 0.75 - o*.5)
            end

            util:create_connection(SaturationImage.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
                	local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
                    local sat = 255 * xdistance
                    local val = 255 * ydistance
                    update_sv(val, sat)
                    dragging_sat = true
                end
            end)

            util:create_connection(SaturationImage.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_sat then
                    dragging_sat = false
                end
            end)

            util:create_connection(mouse.Move, function()
                if dragging_sat then
                    local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
                    local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
                    local sat = 255 * xdistance
                    local val = 255 * ydistance
                    update_sv(val, sat)
                elseif dragging_hue then
                    local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
                    local hue = 360 * xdistance
                    update_hue(hue)
                elseif dragging_trans then
                    local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
                    update_transparency(1 - 1 * xdistance)
                end
            end)

            util:create_connection(HueFrame.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
                    local hue = 360 * xdistance
                    update_hue(hue)
                    dragging_hue = true
                end
            end)

            util:create_connection(HueFrame.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_hue then
                    dragging_hue = false
                end
            end)

            util:create_connection(TransparencyFrame.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
                    update_transparency(1 - 1 * xdistance)
                    dragging_trans = true
                end
            end)

            util:create_connection(TransparencyFrame.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_trans then
                    dragging_trans = false
                end
            end)

			do
				local h,s,v = lib.flags[flag]["color"]:ToHSV()
				update_sv(v*255, s*255, true)
				update_hue(h*360)
				update_transparency(lib.flags[flag]["transparency"])
			end

			local on_mouse1 = util:create_connection(PasteLabel.InputBegan, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local color = lib.copied_color
					local h,s,v = color:ToHSV()
					update_sv(v*255, s*255, true)
					update_hue(h*360)
					update_transparency(lib.flags[flag]["transparency"])
					PasteLabel.TextColor3 = lib.accent_color
				end
			end)
		
			local on_mouse1_end = util:create_connection(PasteLabel.InputEnded, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					PasteLabel.TextColor3 = util:is_in_frame(PasteLabel) and Color3.fromRGB(221,221,221) or Color3.fromRGB(126,126,126)
				end
			end)

			lib.on_config_load:Connect(function()
				local h,s,v = lib.flags[flag]["color"]:ToHSV()
				update_sv(v*255, s*255, true)
				update_hue(h*360)
				update_transparency(lib.flags[flag]["transparency"])
			end)	
		elseif element == "textbox" then
			new_element.total_size+=(23)
			local MultiboxTextbox = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 11);
				Size = udim2new(1, -24, 0, 19);
				Parent = ElementFrame
			})
			local DropdownBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(24, 24, 24);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = MultiboxTextbox
			})
			local TextBox = util:create_new("TextBox", {
				Parent = DropdownBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 5, 0, 0);
				Size = udim2new(1, -5, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = "";
				TextColor3 = Color3.fromRGB(74, 74, 74);
				TextSize = 12.000;
				ClearTextOnFocus = false;
				TextXAlignment = Enum.TextXAlignment.Left
			}); local on_focus = util:create_connection(TextBox.Focused, function()
				if lib.busy then TextBox:ReleaseFocus(); return end
			end)

			new_element.on_text_change = signal.new("on_text_change")

			local on_text_change = util:create_connection(TextBox:GetPropertyChangedSignal("Text"), function()
				lib.flags[flag]["text"] = TextBox.Text
				new_element.on_text_change:Fire(TextBox.Text)
			end)

			if info.text then TextBox.Text = info.text end

			lib.on_config_load:Connect(function()
				TextBox.Text = lib.flags[flag]["text"] or ""
			end)
		end
	end

	ElementFrame.Size = udim2new(1, 0, 0, self.elements ~= 0 and new_element.total_size-9 or new_element.total_size)

	setmetatable(new_element, element); self.elements+=1

	self:update_size(new_element.total_size)

	return new_element
end

function element:remove()
	self.frame:Destroy()
	self.section:update_size(-self.total_size)
	lib.flags[self.flag] = nil
	self = nil
end

function element:set_visible(visible)
	if self.frame.Visible == visible then return end
	self.frame.Visible = visible
	self.section:update_size(visible and self.total_size or -self.total_size)
end

function lib.new()
	local ScreenGui = util:create_new("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
		Parent = cg,
		Enabled = false
	})
	local MainBackground = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0.132718891, 0, 0.122222222, 0);
		Size = udim2new(0, 600, 0, 430);
		Parent = ScreenGui
	})
	local AddonCover = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(1, 1, 1);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = udim2new(0, 0, 0, 25);
		Size = udim2new(1, 0, 0, 381);
		Visible = false;
		ZIndex = 14;
		Parent = MainBackground
	})
	local ConfirmCover = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(1, 1, 1);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = udim2new(0, 0, 0, 25);
		Size = udim2new(1, 0, 0, 381);
		Visible = false;
		ZIndex = 14;
		Parent = MainBackground
	})
	local UICorner = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainBackground
	})
	local MainBorder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainBackground
	})
	local UICorner_2 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainBorder
	})
	local MainInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainBorder    
	})
	local UICorner_3 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainInside
	})
	local MainTop = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 0, 20);
		Parent = MainBorder  
	})
	local UICorner_4 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainTop
	})
	local TopInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainTop
	})
	local UICorner_5 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = TopInside
	})
	local TopFix = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		Position = udim2new(0, 0, 0, 9);
		Size = udim2new(1, 0, 0, 9);
		Parent = TopInside
	})
	local TopFix2 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, -1);
		Size = udim2new(1, 0, 0, 1);
		Parent = TopFix
	})
	local NameLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 0);
		Size = udim2new(0, 95, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "ratio.lol";
		TextColor3 = lib.accent_color;
		TextSize = 12.000;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		RichText = true;
		Parent = TopInside
	})
	local TopCover = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 1, 0);
		Size = udim2new(1, 0, 0, 1);
		Parent = MainTop
	})
	local MainBottom = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 1, -21);
		Size = udim2new(1, -2, 0, 20);
		Parent = MainBorder
	})
	local UICorner_8 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainBottom
	})
	local BottomInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainBottom
	})
	local TipImage = util:create_new("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 3);
		Size = udim2new(0, 12, 0, 12);
		ImageTransparency = 1;
		Visible = true;
		ZIndex = 3;
		Image = "http://www.roblox.com/asset/?id=14151711445";
		Parent = BottomInside
	})
	local TipLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 21, 0, 0);
		Size = udim2new(0, 350, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "This is an example tip.";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		TextWrapped = true;
		TextTransparency = 1;
		TextXAlignment = Enum.TextXAlignment.Left;
		ZIndex = 3;
		Parent = TipImage
	})
	local UICorner_9 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = BottomInside
	})
	local BottomFix = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		Size = udim2new(1, 0, 0, 9);
		Parent = BottomInside
	})
	local BottomFix2 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, 9);
		Size = udim2new(1, 0, 0, 1);
		Parent = BottomFix
	})
	local BuildLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 0);
		Size = udim2new(0, 95, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "build: <font color=\"rgb(189, 172, 255)\">live</font>";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		TextWrapped = true;
		RichText = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = BottomInside
	})
	local UserLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -305, 0, 0);
		Size = udim2new(0, 300, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "active user: <font color=\"rgb(189, 172, 255)\">xander</font>";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		RichText = true;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Right;
		Parent = BottomInside
	})
	local BottomCover = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, -1);
		Size = udim2new(1, 0, 0, 1);
		Parent = MainBottom
	})
	local TabSlider = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		ClipsDescendants = true;
		Position = udim2new(0, 106, 0, 1);
		Size = udim2new(1, -212, 1, 0);
		Parent = MainTop
	})
	local TabHolder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(-1, 0, 0, 0);
		Size = udim2new(1, 0, 1, 0);
		Parent = TabSlider
	})
	local UIListLayout = util:create_new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		SortOrder = Enum.SortOrder.LayoutOrder;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		Padding = udimnew(0, 5);
		Parent = TabHolder
	})
	local FadeLine = util:create_new("Frame", {
		BackgroundColor3 = lib.accent_color;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -298, 1, 1);
		Size = udim2new(0.5, 0, 0, 1);
		Parent = MainTop
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(11, 11, 11)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))};
		Parent = FadeLine
	})
	local ConfirmationFrame = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0.5, -121, 0.5, -48);
		Size = udim2new(0, 242, 0, 96);
		ZIndex = 101;
		Visible = false;
		Parent = MainBackground
	})
	local UICorner = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = ConfirmationFrame
	})
	local CF2 = util:create_new("Frame", {
		Parent = ConfirmationFrame;
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = ConfirmationFrame
	})
	local UICorner_2 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CF2
	})
	local CF3 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = CF2
	})
	local UICorner_3 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CF3
	})
	local CFTOP = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_4 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CFTOP
	})
	local CFFIX = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 1, -4);
		Size = udim2new(1, 0, 0, 4);
		ZIndex = 101;
		Parent = CFTOP
	})
	local UICorner_5 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CFFIX
	})
	local CFLINE = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 1, 0);
		Size = udim2new(1, 0, 0, 1);
		ZIndex = 101;
		Parent = CFTOP
	})
	local CFLABEL = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 1, 0);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Load config";
		TextColor3 = lib.accent_color;
		TextSize = 12.000;
		Parent = CFTOP
	})
	local CFTEXTLABEL = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 1, -10);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Are you sure you want to load your config?";
		TextColor3 = Color3.fromRGB(221, 221, 221);
		TextSize = 12.000;
		TextWrapped = true;
		Parent = CF3
	})
	local CancelButton = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 34, 1, -33);
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_7 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = CancelButton
	})
	local CancelInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = CancelButton	
	})
	local UICorner_8 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = CancelInside
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
		Rotation = 90;
		Parent = CancelInside
	})
	local CancelLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Cancel";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		Parent = CancelInside
	})
	local ConfirmButton = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -114, 1, -33);
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_9 = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = ConfirmButton
	})
	local ConfirmInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = ConfirmButton
	})
	local UICorner_10  = util:create_new("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = ConfirmInside
	})
	local UIGradient_2 = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
		Rotation = 90;
		Parent = ConfirmInside
	})
	local ConfirmLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Confirm";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 12.000;
		Parent = ConfirmInside
	})

	util:set_draggable(MainBackground)

	local new_window = {
		screen_gui = ScreenGui,
		name_label = NameLabel,
		build_label = BuildLabel,
		user_label = UserLabel,
		tab_holder = TabHolder,
		active_tab = nil,
		main = MainBackground,
		line = FadeLine,
		opened = false,
		hotkey = "x",
		tip = TipImage,
		addon_cover = AddonCover,
		confirmation_cover = ConfirmCover,
		confirmation = ConfirmationFrame,
		on_close = signal.new("on_close"),
		confirmationsignal = signal.new("confirmation"),
		cflabel = CFTEXTLABEL,
		cftoplabel = CFLABEL,
		tabs = {}
	}

	local is_holding = false

	local on_hover = util:create_connection(CancelButton.MouseEnter, function()
		if is_holding then return end
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}
		CancelLabel.TextColor3 = Color3.fromRGB(221,221,221)
	end)

	local on_leave = util:create_connection(CancelButton.MouseLeave, function()
		if is_holding then return end
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
		CancelLabel.TextColor3 = Color3.fromRGB(74,74,74)
	end)

	local on_click = util:create_connection(CancelButton.InputBegan, function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			is_holding = true
			CancelLabel.TextColor3 = lib.accent_color
			CancelButton.BackgroundColor3 = lib.accent_color
		end
	end)

	local on_stopclick = util:create_connection(CancelButton.InputEnded, function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			is_holding = false
			CancelLabel.TextColor3 = util:is_in_frame(CancelButton) and Color3.fromRGB(221,221,221) or Color3.fromRGB(74,74,74)
			Color = util:is_in_frame(CancelButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
			CancelButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			new_window.confirmationsignal:Fire(false)
		end
	end)

	local on_hover = util:create_connection(ConfirmButton.MouseEnter, function()
		if is_holding then return end
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}
		ConfirmLabel.TextColor3 = Color3.fromRGB(221,221,221)
	end)

	local on_leave = util:create_connection(ConfirmButton.MouseLeave, function()
		if is_holding then return end
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
		ConfirmLabel.TextColor3 = Color3.fromRGB(74,74,74)
	end)

	local on_click = util:create_connection(ConfirmButton.InputBegan, function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			is_holding = true
			ConfirmLabel.TextColor3 = lib.accent_color
			ConfirmButton.BackgroundColor3 = lib.accent_color
		end
	end)

	local on_stopclick = util:create_connection(ConfirmButton.InputEnded, function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			is_holding = false
			ConfirmLabel.TextColor3 = util:is_in_frame(ConfirmButton) and Color3.fromRGB(221,221,221) or Color3.fromRGB(74,74,74)
			UIGradient_2.Color = util:is_in_frame(ConfirmButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
			ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			new_window.confirmationsignal:Fire(true)
		end
	end)

	local on_input = uis.InputBegan:Connect(function(input, gpe)
		if gpe then return end

		if input.KeyCode.Name:lower() == new_window.hotkey then
			if new_window.opened then new_window:close() else new_window:open() end
		end
	end)

	setmetatable(new_window, window)

	new_window:close()

	return new_window
end

local flags = lib.flags

local function set_dependent(dependency, dependent_on)
	dependency:set_visible(false)
	util:create_connection(dependent_on.on_toggle, function(toggle)
		dependency:set_visible(toggle)
	end)
end

local function set_dropdown_dependent(dependency, dependent_on, value)
	dependency:set_visible(false)
	util:create_connection(dependent_on.on_option_change, function(option)
		if option[1] == value then
			dependency:set_visible(true)
		end
	end)
end

local keybind = {}
keybind.__index = keybind

local KeybindBackground = Instance.new("Frame")

do
	local ScreenGui = Instance.new("ScreenGui")
	local UICorner = Instance.new("UICorner")
	local KeybindInside = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local KeybindDeeper = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local KeybindDepeerer = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local KeybindLabel = Instance.new("TextLabel")
	local KeybindHolder = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	
	ScreenGui.Parent = gethui and gethui() or cg
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Enabled = false

	KeybindBackground.Name = "KeybindBackground"
	KeybindBackground.Parent = ScreenGui
	KeybindBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	KeybindBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindBackground.BorderSizePixel = 0
	KeybindBackground.Position = udim2new(0, 150, 0, 150)
	KeybindBackground.Size = udim2new(0, 150, 0, 24); util:set_draggable(KeybindBackground)
	util:create_connection(KeybindBackground:GetPropertyChangedSignal("Position"), function()
		flags["keybind_position"] = {KeybindBackground.Position.X.Offset, KeybindBackground.Position.Y.Offset}
	end)
	
	UICorner.CornerRadius = udimnew(0, 4)
	UICorner.Parent = KeybindBackground
	
	KeybindInside.Name = "KeybindInside"
	KeybindInside.Parent = KeybindBackground
	KeybindInside.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	KeybindInside.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindInside.BorderSizePixel = 0
	KeybindInside.Position = udim2new(0, 1, 0, 1)
	KeybindInside.Size = udim2new(1, -2, 1, -2)
	
	UICorner_2.CornerRadius = udimnew(0, 4)
	UICorner_2.Parent = KeybindInside
	
	KeybindDeeper.Name = "KeybindDeeper"
	KeybindDeeper.Parent = KeybindInside
	KeybindDeeper.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	KeybindDeeper.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindDeeper.BorderSizePixel = 0
	KeybindDeeper.Position = udim2new(0, 1, 0, 1)
	KeybindDeeper.Size = udim2new(1, -2, 1, -2)
	
	UICorner_3.CornerRadius = udimnew(0, 4)
	UICorner_3.Parent = KeybindDeeper
	
	KeybindDepeerer.Name = "KeybindDepeerer"
	KeybindDepeerer.Parent = KeybindDeeper
	KeybindDepeerer.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	KeybindDepeerer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindDepeerer.BorderSizePixel = 0
	KeybindDepeerer.Position = udim2new(0, 1, 0, 1)
	KeybindDepeerer.Size = udim2new(1, -2, 1, -2)
	
	UICorner_4.CornerRadius = udimnew(0, 4)
	UICorner_4.Parent = KeybindDepeerer
	
	KeybindLabel.Name = "KeybindLabel"
	KeybindLabel.Parent = KeybindDepeerer
	KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindLabel.BackgroundTransparency = 1.000
	KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindLabel.BorderSizePixel = 0
	KeybindLabel.Size = udim2new(1, 0, 1, 0)
	KeybindLabel.Font = Enum.Font.RobotoMono
	KeybindLabel.Text = "Keybinds"
	KeybindLabel.TextColor3 = lib.accent_color
	KeybindLabel.TextSize = 12.000
	
	KeybindHolder.Name = "KeybindHolder"
	KeybindHolder.Parent = KeybindBackground
	KeybindHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindHolder.BackgroundTransparency = 1.000
	KeybindHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindHolder.BorderSizePixel = 0
	KeybindHolder.Position = udim2new(0, 2, 1, 2)
	KeybindHolder.Size = udim2new(1, -4, 0, 0)
	
	UIListLayout.Parent = KeybindHolder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = udimnew(0, 3)

	function keybind.new(text, element, flag)
		local KeybindText = Instance.new("TextLabel")
		local KeyText = Instance.new("TextLabel")

		KeybindText.Name = "KeybindText"
		KeybindText.Parent = KeybindHolder
		KeybindText.Visible = false
		KeybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		KeybindText.BackgroundTransparency = 1.000
		KeybindText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		KeybindText.BorderSizePixel = 0
		KeybindText.Size = udim2new(1, 0, 0, 8)
		KeybindText.Font = Enum.Font.RobotoMono
		KeybindText.Text = text
		KeybindText.TextColor3 = Color3.fromRGB(226, 226, 226)
		KeybindText.TextSize = 12.000
		KeybindText.TextStrokeTransparency = 0.500
		KeybindText.TextXAlignment = Enum.TextXAlignment.Left

		KeyText.Name = "KeyText"
		KeyText.Parent = KeybindText
		KeyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		KeyText.BackgroundTransparency = 1.000
		KeyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		KeyText.BorderSizePixel = 0
		KeyText.Position = udim2new(1, 0, 0, 0)
		KeyText.Size = udim2new(0, 0, 0, 8)
		KeyText.Font = Enum.Font.RobotoMono
		KeyText.Text = "[unbound]"
		KeyText.TextColor3 = lib.accent_color
		KeyText.TextSize = 12.000
		KeyText.TextStrokeTransparency = 0.700
		KeyText.TextXAlignment = Enum.TextXAlignment.Right

		local kb = {}
		kb.text = KeybindText
		kb.key_text = KeyText

		local flag = flags[flag]

		setmetatable(kb, keybind)

		if element.on_toggle then
			util:create_connection(element.on_toggle, function(t)
				kb:set_visible((t and element:is_active()) and true or false)
			end)
		end

		util:create_connection(element.on_key_change, function(key)
			kb:set_key(key)
		end)

		util:create_connection(element.on_activate, function()
			kb:set_visible(true)
		end)

		util:create_connection(element.on_deactivate, function()
			kb:set_visible(false)
		end)

		return kb
	end

	function keybind:set_visible(visible)
		self.text.Visible = visible
	end

	function keybind:set_key(key)
		self.key_text.Text = string.format("[%s]", key)
	end

	function keybind:set_list_visible(visible)
		ScreenGui.Enabled = visible
	end
end

local new_drawing = Drawing.new

local draw = {}

function draw:new(class, properties)
	local surge = new_drawing(class)
	surge.Visible = false
	for property, value in pairs(properties) do
		surge[property] = value
	end
	return surge
end

local on_load = signal.new("on_load")

local function do_load_animation(signal)
	local box = draw:new("Square", {
		Thickness = 1;
		Filled = true;
		Color = Color3.fromRGB(0,0,0);
		Transparency = 0;
		Visible = true;
		Size = vect2(9000,9000);
		ZIndex = 1
	})
	local logo = draw:new("Image", {
		Size = vect2(64, 64);
		Position = vect2(viewport_size.X/2-32, viewport_size.Y/2-32);
		Data = game:HttpGet("https://raw.githubusercontent.com/refinanced/robloxscripts/main/logo.png");
		Visible = true;
		Transparency = 0
	})
	local text = draw:new("Text", {
		Outline = true;
		Size = 16;
		ZIndex = 100;
		Center = true;
		Text = "ratio is initalizing";
		Color = Color3.fromRGB(225,225,225);
		Visible = true;
		Font = Drawing.Fonts[3];
		Transparency = 0
	})

	local delta = 0
	local delta2 = 0
	local delta3 = 0
	local load_connection; load_connection = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
		local viewport_size = viewport_size/2
		delta+=dt
		delta3+=dt
		if delta3 < 1 then
			local tween_value = ts:GetValue((delta3 / 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			box.Transparency = 0 + (0.4*tween_value)
		end
		if delta < 1 then
			local tween_value = ts:GetValue((delta / 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			logo.Transparency = 0 + (1*tween_value)
		elseif delta2 < 1 then
			delta2+=dt
			local tween_value = ts:GetValue((delta2 / 1), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			text.Transparency = 0 + (1*tween_value)
		end
		logo.Position = viewport_size - vect2(32,32)
		text.Position = viewport_size + vect2(0,28)
	end))

	signal:Wait()

	delta,delta2,delta3 = 0,0,0

	load_connection:Disconnect()

	local unload_connection; unload_connection = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
		local viewport_size = viewport_size/2
		delta+=dt
		delta2+=dt
		delta3+=dt
		if delta < 1 then
			local tween_value = ts:GetValue((delta / 0.8), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			logo.Transparency = 1 - (1*tween_value)
		end
		if delta2 < 1 then
			local tween_value = ts:GetValue((delta2 / 0.8), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			text.Transparency = 1 - (1*tween_value)
		end
		if delta3 < 1 then
			local tween_value = ts:GetValue((delta3 / 0.81), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			box.Transparency = 0.4 - (1*tween_value)
		end
		logo.Position = viewport_size - vect2(32,32)
		text.Position = viewport_size + vect2(0,28)
	end))

	task.wait(0.81)

	unload_connection:Disconnect()
	text:Remove()
	logo:Remove()
	box:Remove()
end

-- ? Cache & Other Init

local draw_3d = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()

local cache = {
	ping = 0,
	strafe_angle = 0,
	strafe_circle = draw_3d:New3DCircle(),
	camera_cframe = cfnew(),
	no_stand_box = draw_3d:New3DCube(),
	force_cframe = nil,
	stomp_delay = false,
	world_time = lighting.ClockTime,
	fog_color = lighting.FogColor,
	fog_start = lighting.FogStart,
	fog_end = lighting.FogEnd,
	world_hue = lighting.Ambient,
	compensation = lighting.ExposureCompensation,
	auto_kill = false,
	auto_ready = false,
	viewed_player = nil,
	whitelisted = {},
	opps = {},
	average = {},
	recently_shot = false,
	siren_pos = vect3(),
	macro_bool = false,
	last_crosshair_rotation = tick(),
	rpg_indicators = {},
	tick_walk = false,
	tick_cooldown = false,
	fov = camera.FieldOfView,
	brightness = lighting.Brightness,
	block_delay = false,
	block_func = nil,
	mouse_arg = "UpdateMousePos",
	hitmarkers = {},
	hitsounds = {RIFK7 = "rbxassetid://9102080552", Bubble = "rbxassetid://9102092728", Minecraft = "rbxassetid://5869422451", Cod = "rbxassetid://160432334", Bameware = "rbxassetid://6565367558", Neverlose = "rbxassetid://6565370984", Gamesense = "rbxassetid://4817809188", Rust = "rbxassetid://6565371338"}
}

local main_event = nil

local ignored_folder = workspace:FindFirstChild("Ignored") or workspace:FindFirstChild("Ignore") or (workspace:FindFirstChild("MAP") and workspace.MAP:FindFirstChild("Ignored")) or nil
local exact_dh_clones = {4997645706, 4503807869, 1008451066}

if ignored_folder == nil then -- oh boy
	LPH_NO_VIRTUALIZE(function()
		local descendants = workspace:GetDescendants()
		for i = 1, #descendants do
			local descendant = descendants[i]
			local name = string.lower(descendant.Name)
			if descendant.ClassName == "Folder" and name:find("ignore") then
				ignored_folder = descendant
				return
			end
		end
	end)
end

local whitelisted = cache.whitelisted
local opps = cache.opps
local indicators = cache.rpg_indicators

local character_holder = workspace:FindFirstChild("Players") or workspace:FindFirstChild("Characters")

-- ? UI Creation

local window = lib.new(""); window:set_user(game.Players.LocalPlayer.Name)
	local combat = window:new_tab("Combat")
		local general = combat:new_subtab("General")
			local aimbot_section = general:new_section({name = "Aimbot", side = "left", size = 185})
				local aimbot_enabled = aimbot_section:new_element({name = "Enabled", flag = "aimbot", types = {toggle = {}, keybind = {}}}); keybind.new("Aimbot", aimbot_enabled, "aimbot")
				local anti_aim_viewer = aimbot_section:new_element({name = "Anti aim viewer", flag = "anti_aim_viewer", types = {toggle = {}}})
				local only_forced = aimbot_section:new_element({name = "Only target forced", flag = "only_forced", types = {toggle = {}}})
				local force_target = aimbot_section:new_element({name = "Force target", flag = "force_target", types = {keybind = {method_lock = true, method = "toggle"}}})
				local alwayss = aimbot_section:new_element({name = "Always target", flag = "always", tip = "Locks onto target even if not visible or in field of view", types = {toggle = {}}})
				local unforce_when = aimbot_section:new_element({name = "Unforce target when", flag = "unforce_when", types = {dropdown = {options = {"Knocked", "Dead"}, multi = true}}})
				local silent_aim = aimbot_section:new_element({name = "Silent aim", flag = "silent_aim", types = {toggle = {}}})
				local camlock = aimbot_section:new_element({name = "Camlock", flag = "camlock", types = {toggle = {}, keybind = {}}}); keybind.new("Camlock", camlock, "camlock"); camlock.on_deactivate:Connect(function()
					util:tween(camera, TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = camera.CFrame})
				end); camlock.on_toggle:Connect(function(t)
					if not t then
						util:tween(camera, TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = camera.CFrame})
					end
				end)
				do
					local camlock_style = aimbot_section:new_element({name = "Style", flag = "camlock_style", types = {dropdown = {options = {"Linear", "Sine", "Quad", "Circular"}, no_none = true, default = {"Linear"}}}}); set_dependent(camlock_style, camlock)
					local camlock_speed = aimbot_section:new_element({name = "Speed", flag = "camlock_speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); set_dependent(camlock_speed, camlock); 
					local look_at = aimbot_section:new_element({name = "Look at", flag = "look_at", types = {toggle = {}}})
					local aimbot_fov = aimbot_section:new_element({name = "Field of view", flag = "fov", types = {slider = {min = 1, max = 100}}})
					local max_distance = aimbot_section:new_element({name = "Max distance", flag = "max_distance2", types = {slider = {min = 50, max = 350}}})
					local shake = aimbot_section:new_element({name = "Shake", flag = "shake", types = {toggle = {}}})
					local horizontal_shake = aimbot_section:new_element({name = "Horizontal", flag = "horizontal_shake", types = {slider = {min = 1, max = 100, suffix = "%"}}}); set_dependent(horizontal_shake, shake)
					local vertical_shake = aimbot_section:new_element({name = "Vertical", flag = "vertical_shake", types = {slider = {min = 1, max = 100, suffix = "%"}}}); set_dependent(vertical_shake, shake)
					local aimbot_checks = aimbot_section:new_element({name = "Checks", flag = "checks", types = {dropdown = {options = {"Visible", "Grabbed", "Knocked", "Friend"}, multi = true}}});
					local air_part = aimbot_section:new_element({name = "Air Part", flag = "air_part", types = {dropdown = {options = {"Head", "HumanoidRootPart", "LowerTorso", "Random", "Closest"}, no_none = true, default = {"Head"}}}});
					local aimbot_part = aimbot_section:new_element({name = "Part", flag = "aimbot_part", types = {dropdown = {options = {"Head", "HumanoidRootPart", "LowerTorso", "Random", "Closest"}, no_none = true, default = {"Head"}}}});
				end
			do
				local aimbot_prediction = general:new_section({name = "Prediction", side = "left", size = 360})
				local use_custom_prediction = aimbot_prediction:new_element({name = "Use custom prediction", flag = "custom_prediction", types = {toggle = {}}})
				local horizontal_prediction = aimbot_prediction:new_element({name = "Horizontal prediction", flag = "horizontal_prediction", types = {slider = {min = 0.08, default = 0.1, max = 0.300, decimal = 3}}})
				local vertical_prediction = aimbot_prediction:new_element({name = "Vertical prediction", flag = "vertical_prediction", types = {slider = {min = 0, max = 0.200, default = 0, decimal = 3}}})
				local resolver = aimbot_prediction:new_element({name = "Resolver", flag = "resolver", types = {toggle = {}}})
				local refresh_rate = aimbot_prediction:new_element({name = "Refresh rate", flag = "refresh_rate", tip = "Calculates velocity every x ms, higher = smoother, lower = jittier but more accurate", types = {slider = {min = 1, max = 100, suffix = "ms"}}}); set_dependent(refresh_rate, resolver)
			local aimbot_fov_section = general:new_section({name = "Aimbot fov", side = "right", size = 360})
				local show_fov = aimbot_fov_section:new_element({name = "Show fov", flag = "show_fov", types = {toggle = {}, colorpicker = {}}})
				local fov_outline = aimbot_fov_section:new_element({name = "Outline", flag = "fov_outline", types = {toggle = {}}}); set_dependent(fov_outline, show_fov)
				local fov_filled = aimbot_fov_section:new_element({name = "Filled", flag = "fov_filled", types = {toggle = {}}}); set_dependent(fov_filled, show_fov)
			local aimbot_visualization = general:new_section({name = "Visualization", side = "right", size = 360})
				local predicted_position = aimbot_visualization:new_element({name = "Show predicted position", flag = "predicted_position", types = {toggle = {}}})
				local predicted_line = aimbot_visualization:new_element({name = "Line", flag = "predicted_line", types = {toggle = {}, colorpicker = {}}}); set_dependent(predicted_line, predicted_position)
				local predicted_box = aimbot_visualization:new_element({name = "Box", flag = "predicted_box", types = {toggle = {}, colorpicker = {}}}); set_dependent(predicted_box, predicted_position)
			end
			local aimbot_other = general:new_section({name = "Other", side = "right", size = 360})
				local target_strafe = aimbot_other:new_element({name = "Target strafe", flag = "target_strafe", types = {toggle = {}, colorpicker = {}, keybind = {}}}); keybind.new("Target strafe", target_strafe, "target_strafe")
				local y_offset = aimbot_other:new_element({name = "Y Offset", flag = "y_offset", types = {slider = {min = 0, max = 10}}}); set_dependent(y_offset, target_strafe)
				local strafe_distance = aimbot_other:new_element({name = "Distance", flag = "strafe_distance", types = {slider = {min = 1, max = 10}}}); set_dependent(strafe_distance, target_strafe)
				local strafe_angle = aimbot_other:new_element({name = "Angle", flag = "strafe_angle", types = {slider = {min = 1, max = 180, suffix = "°"}}}); set_dependent(strafe_angle, target_strafe)
				local auto_shoot = aimbot_other:new_element({name = "Auto shoot", flag = "auto_shoot", types = {toggle = {}, keybind = {}}}); keybind.new("Auto shoot", auto_shoot, "auto_shoot")
	local actual_misc = window:new_tab("Game")
			local main = actual_misc:new_subtab("General")
			local character_section = main:new_section({name = "Character", side = "left", size = 360})
			local cframe_speed = character_section:new_element({name = "CFrame speed", flag = "speed", types = {toggle = {}, keybind = {}, slider = {min = 1, max = 100, suffix = "%"}}}); keybind.new("CFrame speed", cframe_speed, "speed")
			local cframe_fly = character_section:new_element({name = "CFrame fly", flag = "fly", types = {toggle = {}, keybind = {}, slider = {min = 1, max = 100, suffix = "%"}}}); keybind.new("CFrame fly", cframe_fly, "fly")
			local spinbot = character_section:new_element({name = "Spinbot", flag = "spinbot", types = {toggle = {}, slider = {min = 1, max = 180, suffix = "°"}}})
			local noclip = character_section:new_element({name = "Noclip", flag = "noclip", types = {toggle = {}, keybind = {}}}); keybind.new("Noclip", noclip, "noclip")
			local macro = character_section:new_element({name = "Macro", flag = "macro", types = {toggle = {}, keybind = {}}}); keybind.new("Macro", macro, "macro")
		local anti_aim = main:new_section({name = "Anti aim", side = "right", size = 360})
			local physics_rate = anti_aim:new_element({name = "Physics send rate", flag = "physics_rate", tip = "Changes the S2PhysicsSenderRate fflag", types = {slider = {min = 1, max = 100, default = 15}}}); physics_rate.on_value_change:Connect(function(val)
				setfflag("S2PhysicsSenderRate", tostring(val))
			end)
			local tick_walk = anti_aim:new_element({name = "Tick walk", flag = "tick_walk", tip = "Freezes your character for x ms and unfreezes after for a tick", types = {toggle = {}, keybind = {}, slider = {min = 100, max = 2000, suffix = "ms"}}}); keybind.new("Tick walk", tick_walk, "tick_walk")
			local no_stand = anti_aim:new_element({name = "No stand", flag = "no_stand", types = {toggle = {}, colorpicker = {}, keybind = {}}}); keybind.new("No stand", no_stand, "no_stand")
			local no_stand_y = anti_aim:new_element({name = "Y offset", flag = "no_stand_y", types = {toggle = {}}}); set_dependent(no_stand_y, no_stand)
			local no_stand_distance = anti_aim:new_element({name = "Distance", flag = "no_stand_distance", types = {slider = {min = 2, max = 16}}}); set_dependent(no_stand_distance, no_stand)
			local anti_lock = anti_aim:new_element({name = "Anti lock", flag = "anti_lock", types = {toggle = {}, keybind = {}}}); keybind.new("Anti lock", anti_lock, "anti_lock")
			local lock_type = anti_aim:new_element({name = "Anti type", flag = "lock_type", types = {dropdown = {options = {"Legit", "Underground", "Sky", "Rage", "Void"}, default = {"Legit"}, no_none = true}}}); set_dependent(lock_type, anti_lock)
		local other_section = main:new_section({name = "Game", side = "right", size = 360})
			local no_jump_cooldown = other_section:new_element({name = "No jump cooldown", flag = "no_jump_cooldown", types = {toggle = {}}})
			local no_slowdown = other_section:new_element({name = "No slowdown", flag = "no_slowdown", types = {toggle = {}}})
		local misc_other = main:new_section({name = "Other", side = "left", size = 120})
			local no_void_kill = misc_other:new_element({name = "No void kill", flag = "no_void_kill", types = {toggle = {}}}); no_void_kill.on_toggle:Connect(function(t)
				workspace.FallenPartsDestroyHeight = t and -9e9 or -500
			end)				
			do
				if util:find(exact_dh_clones, game.GameId) then
					local auto_reload = misc_other:new_element({name = "Auto reload", flag = "auto_reload", types = {toggle = {}}})
					local money_aura = misc_other:new_element({name = "Money aura", flag = "money_aura", types = {toggle = {}}})
				end
				local anti_stomp = misc_other:new_element({name = "Anti stomp", flag = "anti_stomp", types = {toggle = {}}})
				local auto_stomp = misc_other:new_element({name = "Auto stomp", flag = "auto_stomp", types = {toggle = {}}})
				local no_sit = misc_other:new_element({name = "No sit", flag = "no_sit", types = {toggle = {}}}); no_sit.on_toggle:Connect(function(t)
					if lplr.Character then
						local humanoid = lplr.Character:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not t)
						end
					end
				end)
				local force_reset = misc_other:new_element({name = "Force reset", flag = "", types = {button = {}}}); force_reset.on_clicked:Connect(function()
					if lplr.Character then
						local hum = lplr.Character:FindFirstChildOfClass("Humanoid")
						if hum then
							hum.Health = 0
						end 
					end
				end)
			end
	local visuals = window:new_tab("Visuals")
		local players_section = visuals:new_subtab("Players")
			local enemy_esp = players_section:new_section({name = "Player esp", side = "left", size = 260})
			do
				local esp_enabled = enemy_esp:new_element({name = "Enabled", flag = "esp", types = {toggle = {}}})
				local only_specifics = enemy_esp:new_element({name = "Only specifics", flag = "only_specifics", tip = "Only shows on people that are whitelisted or opps or friends", types = {toggle = {}}})
				local specifics = enemy_esp:new_element({name = "Specifics", flag = "specifics", types = {dropdown = {options = {"Whitelisted", "Friends", "Opps"}, multi = true}}}); set_dependent(specifics, only_specifics)
				local max_distance = enemy_esp:new_element({name = "Max distance", flag = "max_distance", types = {toggle = {}}})
				local distance = enemy_esp:new_element({name = "Distance", flag = "distance_max", types = {slider = {min = 50, max = 800}}}); set_dependent(distance, max_distance)
				local esp_animations = enemy_esp:new_element({name = "Animations", flag = "animations", types = {toggle = {}}})
				local esp_offscreen = enemy_esp:new_element({name = "Offscreen", flag = "offscreen", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0), transparency = 0.8}}})
				local offscreen_distance = enemy_esp:new_element({name = "Distance", flag = "offscreen_distance", types = {slider = {min = 1, max = 1000}}}); set_dependent(offscreen_distance, esp_offscreen)
				local offscreen_size = enemy_esp:new_element({name = "Size", flag = "offscreen_size", types = {slider = {min = 1, max = 100}}}); set_dependent(offscreen_size, esp_offscreen)
				local esp_highlight = enemy_esp:new_element({name = "Highlight", flag = "highlight", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0), transparency = 0.5}}})
				local esp_outline = enemy_esp:new_element({name = "Outline", flag = "outline", types = {colorpicker = {color = Color3.fromRGB(0,0,0)}}}); set_dependent(esp_outline, esp_highlight)
				local esp_health = enemy_esp:new_element({name = "Health", flag = "health", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,255,0)}}})
				local esp_number = enemy_esp:new_element({name = "Number", flag = "number", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,255,0)}}}); set_dependent(esp_number, esp_health)
				local esp_armor = enemy_esp:new_element({name = "Armor", flag = "armor", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,0,255)}}}); set_dependent(esp_armor, esp_health)
				local esp_tool = enemy_esp:new_element({name = "Tool", flag = "weapon", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,255,255)}}})
				local esp_ammo = enemy_esp:new_element({name = "Ammo", flag = "ammo", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,175,255)}}})
				local esp_name = enemy_esp:new_element({name = "Name", flag = "name", types = {toggle = {}, colorpicker = {}}})
				local esp_box = enemy_esp:new_element({name = "Box", flag = "box", types = {toggle = {}, colorpicker = {}}})
			end
			local friendly_esp = players_section:new_section({name = "Friendly esp", side = "right", size = 360})
				do
					local friendly_esp_highlight = friendly_esp:new_element({name = "Highlight", flag = "friendly_highlight", types = {colorpicker = {color = Color3.fromRGB(0,255,0), transparency = 0.5}}})
					local friendly_esp_outline = friendly_esp:new_element({name = "Outline", flag = "friendly_outline", types = {colorpicker = {color = Color3.fromRGB(0,0,0)}}})
					local friendly_esp_health = friendly_esp:new_element({name = "Health", flag = "friendly_health", types = {colorpicker = {color = Color3.fromRGB(0,255,0)}}})
					local friendly_esp_number = friendly_esp:new_element({name = "Number", flag = "friendly_number", types = {colorpicker = {color = Color3.fromRGB(0,255,0)}}})
					local friendly_esp_armor = friendly_esp:new_element({name = "Armor", flag = "friendly_armor", types = {colorpicker = {color = Color3.fromRGB(0,0,255)}}})
					local friendly_esp_tool = friendly_esp:new_element({name = "Tool", flag = "friendly_weapon", types = {colorpicker = {color = Color3.fromRGB(255,255,255)}}})
					local friendly_esp_ammo = friendly_esp:new_element({name = "Ammo", flag = "friendly_ammo", types = {colorpicker = {color = Color3.fromRGB(0,175,255)}}})
					local friendly_esp_name = friendly_esp:new_element({name = "Name", flag = "friendly_name", types = {colorpicker = {}}})
					local friendly_esp_box = friendly_esp:new_element({name = "Box", flag = "friendly_box", types = {colorpicker = {}}})
				end
			local opp_esp = players_section:new_section({name = "Opp esp", side = "left", size = 360})
			do
				local aim_viewer = opp_esp:new_element({name = "Aim viewer", flag = "aim_viewer", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,255,0), transparency = 0}}})
			end
			local self_esp = players_section:new_section({name = "Self esp", side = "right", size = 168})
				if game.GameId == 1008451066 then
					local bullet_tracers = self_esp:new_element({name = "Local bullet tracers", flag = "bullet_tracers", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0)}}})
					local lifetime = self_esp:new_element({name = "Lifetime", flag = "lifetime", types = {slider = {min = 0.1, max = 5, default = 0.5, suffix = "s", decimal = 1}}}); set_dependent(lifetime, bullet_tracers)
					local texture = self_esp:new_element({name = "Texture", flag = "texture", types = {textbox = {text = "rbxassetid://446111271"}}}); set_dependent(texture, bullet_tracers)
					local bullet_impacts = self_esp:new_element({name = "Local bullet impacts", flag = "bullet_impacts", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0)}}})
					local impact_fade = self_esp:new_element({name = "Fade", flag = "impact_fade", types = {toggle = {}}}) ; set_dependent(impact_fade, bullet_impacts)
					local impact_lifetime = self_esp:new_element({name = "Lifetime", flag = "impact_lifetime", types = {slider = {min = 0.1, max = 5, default = 0.5, suffix = "s", decimal = 1}}}); set_dependent(impact_lifetime, bullet_impacts)
					local impact_size = self_esp:new_element({name = "Size", flag = "impact_size", types = {slider = {min = 0.1, max = 1.5, default = 0.5, suffix = "", decimal = 1}}}); set_dependent(impact_size, bullet_impacts)	
				end
				local forcefield_tools = self_esp:new_element({name = "Forcefield tools", flag = "forcefield_tools", types = {toggle = {}, colorpicker = {}}})
				local forcefield_body = self_esp:new_element({name = "Forcefield body", flag = "forcefield_body", types = {toggle = {}, colorpicker = {}}}); util:create_connection(forcefield_body.on_toggle, function(t)
					local character = lplr.Character
					if character then
						local hum = character:FindFirstChild("Humanoid")
						if hum then
							local description = hum.HumanoidDescription
							local parts = character:GetChildren()
							local color = flags["forcefield_body"]["color"]
							for i = 1, #parts do
								local part = parts[i]
								if part.ClassName == "MeshPart" then
									if part.Name:find("Foot") or part.Name:find("Leg") then
										part.Material = t and forcefield or plastic
										part.Color = t and color or (part.Name:find("Left") and description.LeftLegColor or description.RightLegColor)
									elseif part.Name:find("Arm") or part.Name:find("Hand") then
										part.Material = t and forcefield or plastic
										part.Color = t and color or (part.Name:find("Left") and description.LeftArmColor or description.RightArmColor)
									elseif part.Name:find("Torso") then
										part.Material = t and forcefield or plastic
										part.Color = t and color or description.TorsoColor
									elseif part.Name == "Head" then
										part.Material = t and forcefield or plastic
										part.Color = t and color or description.HeadColor
									end
								end
							end
						end
					end
				end); util:create_connection(forcefield_body.on_color_change, function(color)
					if flags["forcefield_body"]["toggle"] then
						local character = lplr.Character
						if character then
							local hum = character:FindFirstChild("Humanoid")
							if hum then
								local parts = character:GetChildren()
								for i = 1, #parts do
									local part = parts[i]
									if part.ClassName == "MeshPart" then
										if part.Name:find("Foot") or part.Name:find("Leg") then
											part.Color = color
										elseif part.Name:find("Arm") or part.Name:find("Hand") then
											part.Color = color
										elseif part.Name:find("Torso") then
											part.Color = color
										elseif part.Name == "Head" then
											part.Color = color
										end
									end
								end
							end
						end
					end
				end)
				local forcefield_hats = self_esp:new_element({name = "Forcefield hats", flag = "forcefield_hats", types = {toggle = {}, colorpicker = {}}}); util:create_connection(forcefield_hats.on_toggle, function(t)
					local character = lplr.Character
					if character then
						local hum = character:FindFirstChild("Humanoid")
						if hum then
							local parts = character:GetChildren()
							local color = flags["forcefield_hats"]["color"]
						
							for i = 1, #parts do
								local part = parts[i]
								if part.ClassName == "Accessory" then
									local part = part:FindFirstChildOfClass("Part") or part:FindFirstChildOfClass("MeshPart")
									part.Material = t and forcefield or plastic
									part.Color = t and color or Color3.fromRGB(163, 162, 165)
								end
							end
						end
					end
				end); util:create_connection(forcefield_hats.on_color_change, function(color)
					if flags["forcefield_hats"]["toggle"] then
						local character = lplr.Character
						if character then
							local hum = character:FindFirstChild("Humanoid")
							if hum then
								local parts = character:GetChildren()
							
								for i = 1, #parts do
									local part = parts[i]
									if part.ClassName == "Accessory" then
										local part = part:FindFirstChildOfClass("Part") or part:FindFirstChildOfClass("MeshPart")
										part.Material = forcefield
										part.Color = color
									end
								end
							end
						end
					end
				end);
				local headless = self_esp:new_element({name = "Headless", flag = "headless", types = {toggle = {}}}); util:create_connection(headless.on_toggle, function(t)
					local character = lplr.Character
					if character then
						local head = character:FindFirstChild("Head")
						if head then
							local decal = head:FindFirstChildOfClass("Decal")
							if decal then
								decal.Transparency = t and 1 or 0
							end
							head.Transparency = t and 1 or 0
						end
					end
				end)
		local other_section = visuals:new_subtab("Other")
			local other_hud = other_section:new_section({name = "Hud", side = "Right", size = 360})
				local spinning_crosshair = other_hud:new_element({name = "Spinning crosshair", flag = "spinning_crosshair", types = {toggle = {}}}); util:create_connection(spinning_crosshair.on_toggle, function(t)
					if not t then
						local plrgui = lplr.PlayerGui
						if plrgui then
							local msui = plrgui:FindFirstChild("MainScreenGui")
							if msui then
								local crosshair = msui:FindFirstChild("Aim")
								if crosshair then
									crosshair.Rotation = 0
								end
							end 
						end
					end
				end)
				do
					local spin_speed = other_hud:new_element({name = "Speed", flag = "spin_speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); set_dependent(spin_speed, spinning_crosshair)
					local keybind_list = other_hud:new_element({name = "Keybinds list", flag = "keybind_list", types = {toggle = {}}}); util:create_connection(keybind_list.on_toggle, function(t)
						keybind:set_list_visible(t)
					end)
				end
				local field_of_view = other_hud:new_element({name = "Field of view", flag = "field_of_view", types = {toggle = {}}}); field_of_view.on_toggle:Connect(function(t)
					camera.FieldOfView = t and flags["fov_value"]["value"] or cache.fov
				end)
				local fov_value = other_hud:new_element({name = "FOV", flag = "fov_value", types = {slider = {min = 70, max = 120, suffix = "°"}}}); set_dependent(fov_value, field_of_view); fov_value.on_value_change:Connect(function(val)
					camera.FieldOfView = flags["field_of_view"]["toggle"] and val or cache.fov
				end)
				local aspect_ratio = other_hud:new_element({name = "Aspect ratio", flag = "aspect_ratio", types = {toggle = {}}})
				local ratio = other_hud:new_element({name = "Ratio", flag = "ratio", types = {slider = {min = 1, max = 100, default = 100, suffix = "%"}}}); set_dependent(ratio, aspect_ratio)
				local show_chat = other_hud:new_element({name = "Show chat", flag = "show_chat", types = {toggle = {}}}); show_chat.on_toggle:Connect(function(t)
					local plrgui = lplr.PlayerGui
					if plrgui then
						plrgui.Chat.Frame.ChatChannelParentFrame.Visible = t
					end
				end)
			local other_game = other_section:new_section({name = "Game", side = "right", size = 150})
				if util:find(exact_dh_clones, game.GameId) then
					if game.GameId == 1008451066 then
						local other_bullet_tracers = other_game:new_element({name = "Other bullet tracers", flag = "other_bullet_tracers", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0)}}})
						local other_lifetime = other_game:new_element({name = "Lifetime", flag = "other_lifetime", types = {slider = {min = 0.1, default = 0.5, max = 5, suffix = "s", decimal = 1}}}); set_dependent(other_lifetime, other_bullet_tracers)
						local texture = other_game:new_element({name = "Texture", flag = "other_texture", types = {textbox = {text = "rbxassetid://446111271"}}}); set_dependent(texture, other_bullet_tracers)
					end
					local rpg_indicator = other_game:new_element({name = "RPG indicators", flag = "rpg_indicator", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0)}}})
					local hit_effect = other_game:new_element({name = "Hit effect", flag = "hit_effect", types = {colorpicker = {}, toggle = {}}})
					local effect = other_game:new_element({name = "Effect", flag = "effect", types = {dropdown = {options = {"Confetti", "Nova"}, no_none = true, default = {"Nova"}}}}); set_dependent(effect, hit_effect)
					local hit_sound = other_game:new_element({name = "Hit sound", flag = "hit_sound", types = {toggle = {}}})
					local volume = other_game:new_element({name = "Volume", flag = "volume", types = {slider = {min = 0.1, max = 5, default = 1, decimal = 1}}}); set_dependent(volume, hit_sound)
					local sound = other_game:new_element({name = "Sound", flag = "sound", types = {dropdown = {options = {"Minecraft", "Gamesense", "Neverlose", "Bameware", "Custom", "Bubble", "RIFK7", "Rust", "Cod"}, no_none = true, default = {"Minecraft"}}}}); set_dependent(sound, hit_sound)
					local sound_id = other_game:new_element({name = "ID", flag = "sound_id", types = {textbox = {}}}); set_dropdown_dependent(sound_id, sound, "Custom"); hit_sound.on_toggle:Connect(function(t)
						sound_id:set_visible(false)
						if t then
							sound_id:set_visible(flags["sound"]["selected"][1] == "Custom")
						end
					end)
					local hitmarker = other_game:new_element({name = "Hitmarker", flag = "hitmarker", types = {toggle = {}, colorpicker = {}}})
					local hitmarker_size = other_game:new_element({name = "Size", flag = "hitmarker_size", types = {slider = {min = 5, max = 100}}}); set_dependent(hitmarker_size, hitmarker)
					local hitmarker_gap = other_game:new_element({name = "Gap", flag = "hitmarker_gap", types = {slider = {min = 5, max = 100}}}); set_dependent(hitmarker_gap, hitmarker)
					local hit_chams = other_game:new_element({name = "Hit chams", flag = "hit_chams", types = {toggle = {}, colorpicker = {}}})
					local hit_fade = other_game:new_element({name = "Fade", flag = "hit_fade", types = {toggle = {}}}) ; set_dependent(hit_fade, hit_chams)
					local hit_lifetime = other_game:new_element({name = "Lifetime", flag = "hit_lifetime", types = {slider = {min = 0.1, default = 1.5, max = 5, suffix = "s", decimal = 1}}}); set_dependent(hit_lifetime, hit_chams)
					local hit_material = other_game:new_element({name = "Material", flag = "hit_material", types = {dropdown = {options = {"ForceField", "Neon", "Glass"}, no_none = true, default = {"ForceField"}}}}); set_dependent(hit_material, hit_chams)
				end
				do
				local no_flashbang = other_game:new_element({name = "No flashbang", flag = "no_flashbang", types = {toggle = {}}})
				local no_recoil = other_game:new_element({name = "No recoil", flag = "no_recoil", types = {toggle = {}}})
				local no_blur = other_game:new_element({name = "No blur", flag = "no_blur", tip = "Removes the blur from pepper spray", types = {toggle = {}}})
				end 
			local visuals_world = other_section:new_section({name = "World", side = "left", size = 360})
				local exposure_changer = visuals_world:new_element({name = "Exposure changer", flag = "exposure", types = {toggle = {}}}); util:create_connection(exposure_changer.on_toggle, function(t)
					if t then
						lighting.ExposureCompensation = flags["compensation"]["value"]
					else
						lighting.ExposureCompensation = cache.compensation
					end
				end)
				local compensation = visuals_world:new_element({name = "Compensation", flag = "compensation", types = {slider = {min = -2, max = 3, decimal = 1, default = cache.compensation}}}); util:create_connection(compensation.on_value_change, function(v)
					if flags["exposure"]["toggle"] then
						lighting.ExposureCompensation = v
					end
				end); set_dependent(compensation, exposure_changer)
				local fog_changer = visuals_world:new_element({name = "Fog changer", flag = "fog_changer", types = {toggle = {}, colorpicker = {color = lighting.FogColor}}}); util:create_connection(fog_changer.on_toggle, function(t)
					if t then
						lighting.FogColor = flags["fog_changer"]["color"]
						lighting.FogStart = flags["fog_start"]["value"]
						lighting.FogEnd = flags["fog_end"]["value"]
					else
						lighting.FogColor = cache.fog_color
						lighting.FogStart = cache.fog_start
						lighting.FogEnd = cache.fog_end
					end
				end); util:create_connection(fog_changer.on_color_change, function(color)
					if flags["fog_changer"]["toggle"] then
						lighting.FogColor = color
					end
				end)
				local fog_start = visuals_world:new_element({name = "Fog start", flag = "fog_start", types = {slider = {min = 1, max = 5000, default = lighting.FogStart}}}); set_dependent(fog_start, fog_changer)
				util:create_connection(fog_start.on_value_change, function(v)
					if flags["fog_changer"]["toggle"] then
						lighting.FogStart = v
					end
				end)
				local fog_end = visuals_world:new_element({name = "Fog end", flag = "fog_end", types = {slider = {min = 1, max = 5000, default = lighting.FogEnd}}}); set_dependent(fog_end, fog_changer)
				util:create_connection(fog_end.on_value_change, function(v)
					if flags["fog_changer"]["toggle"] then
						lighting.FogEnd = v
					end
				end)
				local sky_changer = visuals_world:new_element({name = "Sky changer", flag = "sky_changer", types = {toggle = {}}})
				local sky = visuals_world:new_element({name = "Sky", flag = "sky", types = {dropdown = {}}}); set_dependent(sky, sky_changer)
				local no_shadows = visuals_world:new_element({name = "No shadows", flag = "no_shadows", types = {toggle = {}}}); util:create_connection(no_shadows.on_toggle, function(t)
					lighting.GlobalShadows = not t
				end)
				local world_time = visuals_world:new_element({name = "World time", flag = "world_time", types = {toggle = {}, slider = {min = 1, max = 24, decimal = 1, default = lighting.ClockTime}}}); util:create_connection(world_time.on_toggle, function(t)
					if t then
						lighting.ClockTime = flags["world_time"]["value"]
					else
						lighting.ClockTime = cache.world_time
					end
				end); util:create_connection(world_time.on_value_change, function(v)
					if flags["world_time"]["toggle"] then
						lighting.ClockTime = v
					end
				end)
				local world_hue = visuals_world:new_element({name = "World hue", flag = "world_hue", types = {toggle = {}, colorpicker = {color = lighting.Ambient}}}); util:create_connection(world_hue.on_toggle, function(t)
					if t then
						lighting.Ambient = flags["world_hue"]["color"]
					else
						lighting.Ambient = cache.world_hue
					end
				end); util:create_connection(world_hue.on_color_change, function(color)
					if flags["world_hue"]["toggle"] then
						lighting.Ambient = color
					end
				end)
				local brightness = visuals_world:new_element({name = "Brightness", flag = "brightness", types = {toggle = {}, slider = {min = 0, max = 15, decimal = 1, default = lighting.Brightness}}}); util:create_connection(brightness.on_toggle, function(t)
					if t then
						lighting.Brightness = flags["brightness"]["value"]
					else
						lighting.Brightness = cache.brightness
					end
				end); util:create_connection(brightness.on_value_change, function(v)
					if flags["brightness"]["toggle"] then
						lighting.Brightness = v
					end
				end)
	local misc = window:new_tab("Settings")
		local main = misc:new_subtab("General")
			local configurations = main:new_section({name = "Configurations", side = "left", size = 360})
				local config_name = configurations:new_element({name = "Config name", flag = "config_name", types = {textbox = {}, no_load = true}})
				local save_config = configurations:new_element({name = "Update config", flag = "save_config", types = {button = {confirmation = {top = "Update config", text = "Are you sure you want to update this config?"}}}})
				local create_config = configurations:new_element({name = "Create config", flag = "create_config", types = {button = {}}})
				local config_list = configurations:new_element({name = "", flag = "config_list", types = {multibox = {maxsize = 5}}})
				local load_config = configurations:new_element({name = "Load config", flag = "load_config", types = {button = {confirmation = {top = "Load config", text = "Are you sure you want to load this config?"}}}})
				local refresh_configs = configurations:new_element({name = "Refresh configs", flag = "refresh_configs", types = {button = {}}})
			local ui_settings = main:new_section({name = "UI Settings", side = "right", size = 360})
				local ui_keybind = ui_settings:new_element({name = "UI hotkey", flag = "ui_hotkey", types = {keybind = {key = "x", method = "toggle", method_lock = true}}}); ui_keybind.on_key_change:Connect(function(key)
					window.hotkey = key
				end)
			local purchase = nil;
			if util:find(exact_dh_clones, game.GameId) then
				local misc_purchases = main:new_section({name = "Purchases", side = "right", size = 360})
				local auto_buy_armor = misc_purchases:new_element({name = "Auto armor", flag = "auto_armor", types = {toggle = {}}})
				local selected_ammo = misc_purchases:new_element({name = "Ammo", flag = "selected_ammo", types = {slider = {min = 0, max = 20}}})
				local selected_item = misc_purchases:new_element({name = "Items", flag = "selected_item", types = {dropdown = {options = {"Double-Barrel SG", "TacticalShotgun", "Revolver", "DrumGun", "Shotgun", "AK47", "P90", "RPG", "SMG", "LMG", "Pizza", "Chicken", "High-Medium Armor"}}}})
				purchase = misc_purchases:new_element({name = "Purchase", flag = "", types = {button = {}}})
			end
		local misc_players = misc:new_subtab("Players")
			local player_options = misc_players:new_section({name = "Options", side = "left", size = 360})
				local selected_player = player_options:new_element({name = "Player list", flag = "selected_player", types = {multibox = {maxsize = 5}}})
				local selected_plr = nil
				local teleport = player_options:new_element({name = "Teleport to", flag = "teleport", types = {button = {confirmation = {top = "Teleport to", text = "Are you sure you want to teleport to this player?"}}}}); util:create_connection(teleport.on_clicked, function()
					if lplr.Character then
						local hrp = lplr.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							local plr = selected_plr ~= nil and players:FindFirstChild(selected_plr) or nil
							if plr then
								local character = plr.Character
								if character then
									local upper_torso = character:FindFirstChild("UpperTorso")
									if upper_torso then
										task.spawn(function()
											cache.force_cframe = upper_torso.CFrame
											task.wait(0.03)
											cache.force_cframe = nil
										end)
									end
								end
							end
						end
					end
				end)
				local is_whitelisted; is_whitelisted = player_options:new_element({name = "Is whitelisted", flag = "is_whitelisted", types = {toggle = {no_load = true}}}); util:create_connection(is_whitelisted.on_toggle, function(t)
					if selected_plr then
						local find = util:find(cache.whitelisted, selected_plr)
						if find then
							table.remove(cache.whitelisted, find)
						else
							table.insert(cache.whitelisted, selected_plr)
						end
					end
				end)
				local is_opposition = player_options:new_element({name = "Is opposition", flag = "is_opposition", types = {toggle = {no_load = true}}}); util:create_connection(is_opposition.on_toggle, function(t)
					if selected_plr then
						local find = util:find(cache.opps, selected_plr)
						if find then
							table.remove(cache.opps, find)
						else
							table.insert(cache.opps, selected_plr)
						end
					end
				end)
				local auto_kill = player_options:new_element({name = "Auto kill", flag = "auto_kill", types = {toggle = {no_load = true}}}); util:create_connection(auto_kill.on_toggle, function(t)
					cache.auto_kill = t and selected_plr or nil
				end)
				local view_player = player_options:new_element({name = "View", flag = "view_player", types = {toggle = {}}}); util:create_connection(view_player.on_toggle, function(t)
					cache.viewed_player = t and players:FindFirstChild(selected_plr) or nil
					if cache.viewed_player == nil then
						local character = lplr.Character
						if character then
							camera.CameraSubject = character
						end	
					end
				end)
				util:create_connection(selected_player.on_option_change, function(option)
					selected_plr = option
					auto_kill:set_toggle(cache.auto_kill == option)
					is_opposition:set_toggle(util:find(cache.opps, option) and true or false, true)
					is_whitelisted:set_toggle(util:find(cache.whitelisted, option) and true or false, true)
				end)

-- ? UI Init

local all_configs = lib:get_config_list()
local selected_config = nil
local current_configs = {}

local function refresh_all_configs()
	local all_configs = lib:get_config_list()
	local config_list_copy = util:copy(current_configs)

	for i,v in pairs(config_list_copy) do
		if not table.find(all_configs, v) then
			table.remove(current_configs, table.find(current_configs, v))
			config_list:remove_option(v)
		end
	end

	for i,v in pairs(all_configs) do
		if not table.find(config_list_copy, v) then
			table.insert(current_configs, v)
			config_list:add_option(v)
		end
	end
end

-- ? UI Connections

util:create_connection(config_list.on_option_change, LPH_JIT(function(option)
	selected_config = option
end))

util:create_connection(create_config.on_clicked, LPH_JIT(function()
	local text = flags["config_name"]["text"] 
	if text ~= "" and not table.find(current_configs, text) then
		table.insert(current_configs, text)
		lib:save_config(text)
		config_list:add_option(text)
	end
end))

util:create_connection(save_config.on_clicked, LPH_JIT(function()
	if selected_config then
		lib:save_config(selected_config)
	end
end))

util:create_connection(load_config.on_clicked, LPH_JIT(function()
	if selected_config then
		lib:load_config(selected_config)
		if flags["keybind_position"] then
			KeybindBackground.Position = udim2new(0, flags["keybind_position"][1], 0, flags["keybind_position"][2])
		end
	end
end))

util:create_connection(refresh_configs.on_clicked, refresh_all_configs)

util:create_connection(forcefield_tools.on_toggle, LPH_JIT(function(t)
	local character = lplr.Character
	if character then
		local tool = character:FindFirstChildOfClass("Tool")
		if tool then
			local handle = tool:FindFirstChild("Handle")
			local default = tool:FindFirstChild("Default")
			if handle then
				handle.Material = t and forcefield or plastic
				handle.Color = t and flags["forcefield_tools"]["color"] or Color3.fromRGB(163, 162, 165)
			end 
			if default then
				default.Material = t and forcefield or plastic
				default.Color = t and flags["forcefield_tools"]["color"] or Color3.fromRGB(163, 162, 165)
			end 
		end
	end
end))

util:create_connection(forcefield_tools.on_color_change, LPH_JIT(function()
	local character = lplr.Character
	if character then
		local tool = character:FindFirstChildOfClass("Tool")
		if tool then
			local handle = tool:FindFirstChild("Handle")
			local default = tool:FindFirstChild("Default")
			if handle then
				handle.Color = flags["forcefield_tools"]["color"]
			end 
			if default then
				default.Color = flags["forcefield_tools"]["color"]
			end 
		end
	end
end))

-- ? Drawing Setup

local draw_3d = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()

-- ? Cache & Stats

LPH_NO_VIRTUALIZE(function()
	for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
		if (remote.Name == "MainEvent" or remote.Name == "MainRemote") and remote.ClassName == "RemoteEvent" then
			main_event = remote
		end 
	end
end)()

do 
	local pos_box = cache.no_stand_box

	pos_box.Visible = false
	pos_box.ZIndex = 5
	pos_box.Thickness = 1
	pos_box.Filled = false
	pos_box.Size = vect3(1.5,3.5,1.5)
end

do
	local circle = cache.strafe_circle
	circle.Visible = false
	circle.ZIndex = 5
	circle.Thickness = 1
end

-- ? Aimbot

local aimbot = {
	active_target = nil,
	aim_position = nil,
	prediction = nil,
	refresh_tick = tick(),
	forced_target = nil,
	fov_outline_drawing = draw:new("Circle", {
		Filled = false,
        Thickness = 3,
		Color = Color3.fromRGB(0,0,0),
        ZIndex = 99
	}),
	fov_drawing = draw:new("Circle", {
		Filled = false,
        Thickness = 1,
		ZIndex = 3,
        ZIndex = 100
	}),
	pos_line = draw:new("Line", {
        Thickness = 2
    }),
	pos_box = draw_3d:New3DCube()
}

do 
	local pos_box = aimbot.pos_box

	pos_box.Visible = true
	pos_box.ZIndex = 5
	pos_box.Thickness = 1
	pos_box.Filled = false
	pos_box.Size = vect3(1.5,3.5,1.5)
end

-- ? ESP

local esp = {
	cache = {}
}

function esp:setup(instance)
	local esp_table = {instance, {
		box_outline = draw:new("Square", {
            Thickness = 3,
            ZIndex = 1
        }),
		box = draw:new("Square", {
            Thickness = 1,
            ZIndex = 2
        }),
		name = draw:new("Text", {
			Center = true,
			Outline = true,
			Size = 18,
			ZIndex = 2,
			Text = tostring(instance),
            Font = Drawing.Fonts[2]
		}),
		triangle = draw:new("Triangle", {
			Thickness = 1,
			ZIndex = 4,
			Filled = true,
		}),
		weapon = draw:new("Text", {
            Center = true,
            Outline = true,
            Size = 14,
            Font = Drawing.Fonts[2],
            ZIndex = 2
        }),
        health_outline = draw:new("Line", {
            Thickness = 4,
            ZIndex = 1,
            Color = Color3.fromRGB(0,0,0)
        }),
        health = draw:new("Line", {
            Thickness = 2,
            ZIndex = 2
        }),
        ammo_outline = draw:new("Line", {
            Thickness = 4,
            ZIndex = 1,
            Color = Color3.fromRGB(0,0,0)
        }),
        ammo_fill = draw:new("Line", {
            Thickness = 2,
            ZIndex = 2
        }),
        armor = draw:new("Line", {
            Thickness = 2,
            ZIndex = 2
        }),
        health_text = draw:new("Text", {
            Center = true,
            Outline = true,
            ZIndex = 2,
			Size = 14,
            Color = Color3.fromRGB(255,255,255)
        }),
		aim = draw:new("Line", {
			Thickness = 2,
			ZIndex = 4
		}),
	}}

	if esp_table[2].box.Filled ~= nil then -- KRNL Support
		esp_table[2].box.Filled = false
		esp_table[2].box_outline.Filled = false
	end

	local highlight = util:create_new("Highlight", {
        Enabled = false,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        Parent = gethui and gethui() or cg
    }); table.insert(esp_table, highlight)

	table.insert(esp.cache, esp_table)
end

function esp:remove(player)
	local surge = nil
	local index = 0
	for i = 1, #esp.cache do
		local cache = esp.cache[i]
		if cache[1] == player then
			surge = cache
			index = i
			break
		end
	end
	local drawings = surge[2]
	for _, drawing in pairs(drawings) do
		drawing:Remove()
	end
	surge[3]:Destroy()
	table.remove(esp.cache, index)
end

-- ? All Players

local all_players = {}

-- ? Functions I was too lazy to move

local wtvp_orig = camera.WorldToViewportPoint

local wtvp = LPH_JIT(function(position)
    local coords, visible = wtvp_orig(camera, position)
    return vect2(coords.X, coords.Y), visible
end)

local is_visible = LPH_JIT(function(start, result, part, other)
    return #camera:GetPartsObscuringTarget({start, result}, {lplr.Character, part, part.Parent, ignored_folder, other}) == 0
end)

local do_hit_chams = LPH_JIT(function(char)
	char.Archivable = true
	local character = char:Clone(); char.Archivable = false
	local children = character:GetChildren()

	
	local flag = flags["hit_chams"]
	local clr = flag["color"]
	local transparency = flag["transparency"]
	local material = flags["hit_material"]["selected"][1]
	local lifetime = flags["hit_lifetime"]["value"]

	local fade = flags["hit_fade"]["toggle"]

	for i = 1, #children do 
		local child = children[i]
		local classname = child.ClassName
		local name = child.Name
		if (classname == "Part" or classname == "MeshPart") and name ~= "HumanoidRootPart" then
			child.Material = Enum.Material[material]
			child.Transparency = transparency
			child.Color = clr
			child.Anchored = true
			child.CanCollide = false
			if fade then
				util:tween(child, TweenInfo.new(lifetime-0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
			end
			if name == "Head" then
				local decal = child:FindFirstChildOfClass("Decal")
				if decal then decal:Destroy() end
			end
		else
			child:Destroy()
		end
	end

	task.spawn(function()
		task.wait(lifetime)
		character:Destroy()
	end)

	character.Parent = ignored_folder
end)

local create_beam = LPH_JIT(function(from, to, color, transparency, lifetime, cloned, texture)
    local beam = Instance.new("Beam")
    beam.Texture = texture
    beam.TextureMode = Enum.TextureMode.Wrap
    beam.TextureLength = 10
	beam.LightEmission = 1
    beam.LightInfluence = 1
    beam.FaceCamera = true
	beam.ZOffset = -1
	beam.Transparency = NumberSequence.new(transparency)
    beam.Color = ColorSequence.new(color, Color3.new(0, 0, 0))
    beam.Attachment0 = from
    beam.Attachment1 = to
    beam.Parent = ignored_folder
	beam.Enabled = true
	task.spawn(function()
		task.wait(lifetime)
		if beam then
			beam:Destroy()
		end
		if from then
			from:Destroy()
		end
		if to then
			to:Destroy()
		end
		if cloned then
			cloned:Destroy()
		end
	end)
end)

local tween_player_value = LPH_JIT(function(name, prop, value, old_value)
	if flags["animations"]["toggle"] and abs(value-old_value) > 2 then
		local player = all_players[name]
		local tweens = player.tweens
		for i,v in pairs(tweens) do
			local tween = v
			local property, conn = tween[1], tween[2]
			if property == prop then
				conn:Disconnect()
				tweens[i] = nil
			end
		end
		local delta = 0
		local connection = nil
		connection = rs.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
			delta+=dt
			if delta < 0.11 then
				local tween_value = ts:GetValue((delta / 0.11), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
				player[prop] = old_value + ((value-old_value)*tween_value)
			else
				connection:Disconnect()
				player[prop] = value
			end
		end))
		table.insert(tweens, {prop, connection, value})
	else
		all_players[name][prop] = value
	end
end)

local hit_effect = {}

hit_effect.__index = hit_effect

function hit_effect.new(folder, emit, dont_override)
	local effect = {
		folder = folder,
		emit = emit,
		dont_override = dont_override
	}

	setmetatable(effect, hit_effect)

	return effect
end

function hit_effect:get_clone()
	return self.folder:Clone()
end

local nova = Instance.new("Folder")
do
	local particle1 = util:create_new("ParticleEmitter", {
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
		Parent = nova
	})
	local particle2 = util:create_new("ParticleEmitter", {
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
		Parent = nova
	})
	local particle3 = util:create_new("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))};
		Lifetime = NumberRange.new(0.2,0.5);
		LockedToPart = true;
		Orientation = Enum.ParticleOrientation.VelocityParallel;
		Rate = 0;
		Rotation = NumberRange.new(-90,90);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,8.5,1.5)};
		Speed = NumberRange.new(0.1,0.1);
		SpreadAngle = vect2(180,180);
		Texture = [[http://www.roblox.com/asset/?id=6820680001]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.200791,0,0),NumberSequenceKeypoint.new(0.699605,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1.5;
		Parent = nova
	})
end

local confetti = Instance.new("Folder")
do
	local particle1 = util:create_new("ParticleEmitter", {
		Acceleration = vect3(0,-10,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,1,0.886275)),ColorSequenceKeypoint.new(1,Color3.new(0,1,0.886275))};
		Lifetime = NumberRange.new(1,2);
		Rate = 0;
		RotSpeed = NumberRange.new(260,260);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
		Speed = NumberRange.new(15,15);
		SpreadAngle = vect2(360,360);
		Texture = [[http://www.roblox.com/asset/?id=241685484]];
		Parent = confetti
	})
	local particle2 = util:create_new("ParticleEmitter", {
		Acceleration = vect3(0,-10,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0.0980392,1)),ColorSequenceKeypoint.new(1,Color3.new(0,0,1))};
		Lifetime = NumberRange.new(1,2);
		Rate = 0;
		RotSpeed = NumberRange.new(260,260);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
		Speed = NumberRange.new(15,15);
		SpreadAngle = vect2(360,360);
		Texture = [[http://www.roblox.com/asset/?id=241685484]];
		Parent = confetti
	})
	local particle3 = util:create_new("ParticleEmitter", {
		Acceleration = vect3(0,-10,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.901961,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0.933333,0))};
		Lifetime = NumberRange.new(1,2);
		Rate = 0;
		RotSpeed = NumberRange.new(260,260);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
		Speed = NumberRange.new(15,15);
		SpreadAngle = vect2(360,360);
		Texture = [[http://www.roblox.com/asset/?id=241685484]];
		Parent = confetti
	})
	local particle4 = util:create_new("ParticleEmitter", {
		Acceleration = vect3(0,-10,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.180392,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.180392,1,0))};
		Lifetime = NumberRange.new(1,2);
		Rate = 0;
		RotSpeed = NumberRange.new(260,260);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
		Speed = NumberRange.new(15,15);
		SpreadAngle = vect2(360,360);
		Texture = [[http://www.roblox.com/asset/?id=241685484]];
		Parent = confetti
	})
	local particle5 = util:create_new("ParticleEmitter", {
		Acceleration = vect3(0,-10,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))};
		Lifetime = NumberRange.new(1,2);
		Rate = 0;
		RotSpeed = NumberRange.new(260,260);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.1,0)};
		Speed = NumberRange.new(15,15);
		SpreadAngle = vect2(360,360);
		Texture = [[http://www.roblox.com/asset/?id=241685484]];
		Parent = confetti
	})
end

local hit_effects = {
	["Confetti"] = hit_effect.new(confetti, 10, true),
	["Nova"] = hit_effect.new(nova, 1, false),
}

local do_hit_effect = LPH_JIT(function(hrp)
	local hit_effect = hit_effects[flags["effect"]["selected"][1]]
	local new_particles = hit_effect:get_clone()
	local attachment = Instance.new("Attachment")
	attachment.Parent = hrp
	local children = new_particles:GetChildren()
	local color = flags["hit_effect"]["color"]
	local color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(1.00, color)}
	local emit_count = hit_effect.emit
	local dont_override = hit_effect.dont_override
	for i = 1, #children do
		local child = children[i]
		child.Parent = attachment
		if not dont_override then
			child.Color = color
		end
		task.delay(0, function()
			child:Emit(emit_count)
		end)
	end
	task.delay(2, function()
		attachment:Destroy()
	end)
	new_particles:Destroy()
end)

local function new_rpg_indicator(rocket, pos, max)
	local indicator = {
		drawings = {
			outline = draw:new("Circle", {
				Filled = false,
				Thickness = 3,
				Color = Color3.fromRGB(0,0,0),
				ZIndex = 99
			}),
			outline2 = draw:new("Circle", {
				Filled = false,
				Thickness = 2,
				Color = Color3.fromRGB(255,0,0),
				ZIndex = 99
			}),
			fill = draw:new("Circle", {
				Filled = true,
				Thickness = 1,
				Color = Color3.fromRGB(128,0,0),
				Transparency = 0.2,
				ZIndex = 99
			}),
			text = draw:new("Text", {
				Center = true,
				Outline = true,
				Size = 16,
				ZIndex = 100,
				Text = "RPG",
				Color = Color3.fromRGB(235,0,0),
				Font = Drawing.Fonts[2]
			}),
			bar_outline = draw:new("Line", {
				Thickness = 4,
				ZIndex = 1,
				Color = Color3.fromRGB(0,0,0)
			}),
			bar_fill = draw:new("Line", {
				Thickness = 2,
				ZIndex = 2
			}),
		},
		rocket = rocket,
		pos = pos,
		max = max
	}

	table.insert(cache.rpg_indicators, indicator)
end

local function new_hitmarker()
	local hitmarker = {}

	for i = 1, 4 do
		hitmarker[i] = {
			outline = draw:new("Line", {
				Thickness = 3,
				ZIndex = 1,
				Color = Color3.fromRGB(0,0,0)
			}),
			line = draw:new("Line", {
				Thickness = 1,
				ZIndex = 1,
				Color = Color3.fromRGB(255,255,255)
			})
		}
	end

	hitmarker["start"] = tick()

	table.insert(cache.hitmarkers, hitmarker)
end

-- ? Player Class

local player = {}
player.__index = player

function player.new(instance)
	local player_class = setmetatable({
		connections = {},
		player = instance,
		velocity = vect3(),
		is_loaded_cache = false,
		last_position = nil,
		health = 100,
		armor = 0,
		tweens = {}
	}, player)

	local name = instance.Name

	instance.CharacterAdded:Connect(LPH_JIT(function(character)
		local humanoid = character:WaitForChild("Humanoid", 1)

		if humanoid then
			local old_health = 100
			all_players[name].health = 100
			humanoid:GetPropertyChangedSignal("Health"):Connect(LPH_JIT(function()
				local health = humanoid.Health
				tween_player_value(name, "health", health, old_health)
				if health < old_health and cache.recently_shot then
					local hrp = character.HumanoidRootPart
					local hrp_pos = character.HumanoidRootPart.Position
					local visible = is_visible(hrp_pos, lplr.Character.HumanoidRootPart.Position, hrp, character_holder)
					local pos, on_screen = wtvp(hrp_pos)
					if visible or on_screen then
						if flags["hit_chams"]["toggle"] then
							do_hit_chams(character)
						end
						if flags["hitmarker"]["toggle"] then
							new_hitmarker(character)
						end
						if flags["hit_sound"]["toggle"] then
							local selected = flags["sound"]["selected"][1]
							local sound = Instance.new("Sound", lplr.PlayerGui)
							sound.Volume = flags["volume"]["value"]
							sound.PlayOnRemove = true
							sound.SoundId = selected ~= "Custom" and cache.hitsounds[flags["sound"]["selected"][1]] or flags["sound_id"]["text"]
							sound:Destroy()
						end
						if flags["hit_effect"]["toggle"] then
							do_hit_effect(hrp)
						end
					end
				end 
				old_health = health
			end))
		end

		local bodyeffects = character:WaitForChild(character_folder_name, 100)

		if bodyeffects then
			local armor = bodyeffects:WaitForChild("Armor", 0.1)
			local old_armor = 0
			if armor then
				armor:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
					local defense = armor.Value
					tween_player_value(name, "armor", defense, old_armor)
					old_armor = defense
				end))
			end 
		end
	end))

	local character = instance.Character

	if character then
		task.spawn(function()
			local humanoid = character:WaitForChild("Humanoid", 1)

			if humanoid then
				local old_health = humanoid.Health
				player_class.health = old_health
				humanoid:GetPropertyChangedSignal("Health"):Connect(LPH_JIT(function()
					local health = humanoid.Health
					tween_player_value(name, "health", health, old_health)
					if health < old_health and cache.recently_shot then
						local hrp = character.HumanoidRootPart
						local hrp_pos = character.HumanoidRootPart.Position
						local visible = is_visible(hrp_pos, lplr.Character.HumanoidRootPart.Position, hrp, character_holder)
						local pos, on_screen = wtvp(hrp_pos)
						if visible or on_screen then
							if flags["hit_chams"]["toggle"] then
								do_hit_chams(character)
							end
							if flags["hitmarker"]["toggle"] then
								new_hitmarker(character)
							end
							if flags["hit_sound"]["toggle"] then
								local sound = Instance.new("Sound", lplr.PlayerGui)
								sound.Volume = flags["volume"]["value"]
								sound.PlayOnRemove = true
								sound.SoundId = cache.hitsounds[flags["sound"]["selected"][1]]
								sound:Destroy()
							end
							if flags["hit_effect"]["toggle"] then
								do_hit_effect(hrp)
							end
						end
					end 
					old_health = health
				end))
			end

			local bodyeffects = character:WaitForChild(character_folder_name, 100)

			if bodyeffects then
				local armor = bodyeffects:WaitForChild("Armor", 1)
				if armor then
					local old_armor = armor.Value
					player_class.armor = old_armor
					armor:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
						local defense = armor.Value
						tween_player_value(name, "armor", defense, old_armor)
						old_armor = defense
					end))
				end 
			end
		end)
	end

	return player_class
end

function player:is_character_loaded()
	local character = self.player.character
	if character then
		local hrp, humanoid = character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
		if hrp and humanoid then
			return hrp, humanoid
		end
	end
	return false
end

-- ? Purchases

local all_item_names = {
	["Double-Barrel SG"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["TacticalShotgun"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["Shotgun"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["Revolver"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["DrumGun"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["AK47"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["LMG"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["SMG"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["P90"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["RPG"] = {
		purchase = nil,
		ammo_purchase = nil
	},
	["Pizza"] = {
		purchase = nil
	},
	["Chicken"] = {
		purchase = nil
	},
	["High-Medium Armor"] = {
		purchase = nil
	},
}

-- ? Game Connections

local on_player_added = util:create_connection(players.PlayerAdded, LPH_JIT(function(instance)
	all_players[instance.Name] = player.new(instance)
	selected_player:add_option(instance.Name)
	esp:setup(instance)
end))

local on_player_removing = util:create_connection(players.PlayerRemoving, LPH_JIT(function(instance)
	all_players[instance.Name] = nil
	if aimbot.forced_target == instance then aimbot.forced_target = nil end
	if aimbot.active_target == instance then aimbot.active_target = nil end
	if cache.viewed_player == instance then
		cache.viewed_player = nil
		local character = lplr.Character
		if character then
			camera.CameraSubject = character
		end	
	end
	selected_player:remove_option(instance.Name)
	esp:remove(instance)
end))

if game.GameId == 1008451066 then
local on_bullet_tracer_added = util:create_connection(ignored_folder.Siren.Radius.ChildAdded, LPH_JIT(function(siren)
	if siren.ClassName == "Part" and siren.Name ~= "\255" and lplr.Character then
		task.wait()
		local gunbeam = siren:FindFirstChildOfClass("Beam")
		if gunbeam then		
			local flag = flags["bullet_tracers"]
			local other_bullet_tracers = flags["other_bullet_tracers"]
			local bullet_impacts = flags["bullet_impacts"]
			local is_other = other_bullet_tracers["toggle"]
			if cache.recently_shot or siren.Position == cache.siren_pos then
				if bullet_impacts["toggle"] then
					local cf = gunbeam.Attachment1.WorldCFrame
					local size = flags["impact_size"]["value"]
					task.spawn(function()
						local clr = bullet_impacts["color"]
						local transparency = bullet_impacts["transparency"]
						local impact = Instance.new("Part")
						impact.CanCollide = false
						impact.Material = neon
						impact.Size = vect3(size,size,size)
						impact.Transparency = transparency
						impact.Color = clr
						impact.Position = cf.p
						impact.Anchored = true
						local outline = Instance.new("SelectionBox")
						outline.LineThickness = 0.01
						outline.Transparency = 0
						outline.Color3 = clr
						outline.SurfaceTransparency = 1
						outline.Parent = impact
						outline.Adornee = impact
						outline.Visible = true
						impact.Parent = ignored_folder
						if flags["impact_fade"]["toggle"] then
							util:tween(impact, TweenInfo.new(flags["impact_lifetime"]["value"]-0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
							util:tween(outline, TweenInfo.new(flags["impact_lifetime"]["value"]-0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
						end
						task.wait(flags["impact_lifetime"]["value"])
						impact:Destroy()
					end)
				end
				if flag["toggle"] then
					cache.siren_pos = siren.Position
					local from = nil
					local to = nil
					local cloned = siren:Clone()
					cloned.Name = "\255"
					cloned.Parent = ignored_folder.Siren.Radius
					local children = cloned:GetChildren()
					for i = 1, #children do
						local child = children[i]
						if child.ClassName == "Attachment" then
							if from then
								to = child
							else
								from = child
							end
						else
							child:Destroy()
						end 
					end
					create_beam(from, to, flag["color"], flag["transparency"], flags["lifetime"]["value"], cloned, flags["texture"]["text"])
					siren:Destroy()
				end
			elseif is_other then
				if other_bullet_tracers["toggle"] then
					local from = nil
					local to = nil
					local cloned = siren:Clone()
					cloned.Name = "\255"
					cloned.Parent = ignored_folder.Siren.Radius
					local children = cloned:GetChildren()
					for i = 1, #children do
						local child = children[i]
						if child.ClassName == "Attachment" then
							if from then
								to = child
							else
								from = child
							end
						else
							child:Destroy()
						end 
					end
					create_beam(from, to, other_bullet_tracers["color"], other_bullet_tracers["transparency"], flags["other_lifetime"]["value"], cloned, flags["other_texture"]["text"])
					siren:Destroy()
				end
			end
		end
	end
end))

local on_object_added = util:create_connection(ignored_folder.ChildAdded, LPH_JIT(function(object)
	if object.Name == "Launcher" then
		local rpg = flags["rpg_indicator"]
		if rpg["toggle"] then
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Blacklist
			params.FilterDescendantsInstances = {ignored_folder, character_holder}
	
			local result = workspace:Raycast(object.Position, object.CFrame.lookVector*-1000, params)

			if result then
				local max = (object.Position-result.Position).magnitude
				new_rpg_indicator(object, result.Position, max)
			end
		end
	end
end))
end

-- ? Hack Functions

local parts_to_check = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm"}

local get_closest_part = LPH_NO_VIRTUALIZE(function(character) 
    local closest = math.huge
    local target = character.HumanoidRootPart

    for i = 1, #parts_to_check do
        local part_name = parts_to_check[i]
        local part = character:FindFirstChild(part_name)
        if not part then continue end
        local hv, visible = wtvp(part.Position)
        if visible then
            local distance = (vect2(mouse.X, mouse.Y) - vect2(hv.X, hv.Y)).magnitude
            if distance < closest then
                closest = distance
                target = part
            end
        end
    end

    return target
end)

local do_aimbot_checks = LPH_JIT(function(character)
	local checks = flags["checks"]["selected"]
	local bodyeffects = character:FindFirstChild(character_folder_name)
	if bodyeffects then
		if util:find(checks, "Visible") then
			local is_visible = is_visible(character.HumanoidRootPart.Position, lplr.Character.HumanoidRootPart.Position, character.HumanoidRootPart)
			if not is_visible then return false end
		end
		if util:find(checks, "Grabbed") then
			local grabbed = bodyeffects:FindFirstChild("Grabbed")
			if grabbed and grabbed.Value == true then return false end
		end
		if util:find(checks, "Knocked") then
			local ko = bodyeffects:FindFirstChild("K.O") or bodyeffects:FindFirstChild("KO")
			if ko and ko.Value == true then return false end
		end
		if util:find(checks, "Friend") then
			local player = players:FindFirstChild(character.Name)
			if player and player:IsFriendsWith(lplr.UserId) then return false end
		end
	else
		return false
	end
	return true
end)

local do_target_checks = LPH_JIT(function(character)
	local bodyeffects = character:FindFirstChild(character_folder_name)
	if bodyeffects then
		local ko = bodyeffects:FindFirstChild("K.O") or bodyeffects:FindFirstChild("KO")
		if ko and ko.Value == true then return false end
	end
	return true
end)

local get_closest = LPH_JIT(function(ignore)  
	local closest, target = math.huge, nil
    local players = players:GetPlayers()

	local forced_target = aimbot.forced_target

	if forced_target then
		local unforce_when = flags["unforce_when"]["selected"]
		local character = forced_target.Character

		if util:find(unforce_when, "Dead") and (character == nil) then
			aimbot.forced_target = nil
		end

		if util:find(unforce_when, "Knocked") and not do_target_checks(forced_target.Character) then
			aimbot.forced_target = nil
		end

		if flags["always"]["toggle"] then
			return forced_target.Character
		end
	elseif flags["only_forced"]["toggle"] and not ignore then
		return nil
	end

	local hrp_pos = lplr.Character.HumanoidRootPart.Position
	local mouse_vector = vect2(mouse.X, mouse.Y)

	for i = 1, #players do
        plr = players[i]
		if plr ~= lplr then
			if util:find(cache.whitelisted, plr.Name) then continue end
			local character = plr.Character

			if character then
				local hrp = character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local hv, visible = wtvp(hrp.Position)
					if visible then
						local distance = (mouse_vector - vect2(hv.X, hv.Y)).magnitude
						local threshold = (flags["fov"]["value"]*10)
						if distance <= threshold then
							if (hrp.Position-hrp_pos).magnitude > flags["max_distance2"]["value"] then continue end
							if not do_aimbot_checks(character) then continue end
                            if aimbot.forced_target == plr then return character end
                            if distance < closest then
                                target = character
                                closest = distance
                            end
						end
					end
				end
			end
		end
	end

	if forced_target and (flags["only_forced"]["toggle"] and target ~= forced_target.Character) and not ignore then return nil end

	return target
end)

local function get_ping()
    return tonumber(string.split(stats.Network.ServerStatsItem["Data Ping"]:GetValueString(),'(')[1])
end

local purchase_item = util:find(exact_dh_clones, game.GameId) and LPH_JIT(function(name, ammo)
	setfflag("S2PhysicsSenderRate", "15")
	local item = all_item_names[name]
	local ping = get_ping()*2/1000
	local old_cf = lplr.Character.HumanoidRootPart.CFrame
	if item then
		if not lplr.Backpack:FindFirstChild(string.format("[%s]", name)) then
			cache.force_cframe = item.purchase.CFrame - vect3(0,4,0)
			task.wait(ping*2)
			local click_dectector = item.purchase.Parent:FindFirstChildOfClass("ClickDetector")
			fireclickdetector(click_dectector)
		end
		if ammo and item.ammo_purchase then
			task.wait(ping*2)
			cache.force_cframe = item.ammo_purchase.CFrame - vect3(0,4,0)
			local click_dectector = item.ammo_purchase.Parent:FindFirstChildOfClass("ClickDetector")
			for i = 1, ammo do
				fireclickdetector(click_dectector)
				task.wait(1 + ping)
			end
		end
		task.wait(ping)
		cache.force_cframe = old_cf
		task.delay(0.03, function()
			cache.force_cframe = nil
		end)
	end
	setfflag("S2PhysicsSenderRate", tostring(flags["physics_rate"]["value"]))
end) or LPH_JIT(function() end)

local function get_average_ping()
    if #cache.average ~= 20 then return cache.ping end
    local total = 0
    for _, ping in pairs(cache.average) do
        total+=ping
    end
    return total/20
end

local function do_tick_walk(hrp)
	cache.tick_cooldown = true
	cache.tick_walk = true
	task.wait(flags["tick_walk"]["value"]/1000)
	cache.tick_walk = false
	task.wait(cache.ping/1500)
	cache.tick_cooldown = false
end

local get_aimbot_location = LPH_JIT(function(character)
	local part = character.Humanoid.FloorMaterial == Enum.Material.Air and flags["air_part"]["selected"][1] or flags["aimbot_part"]["selected"][1]
	if part == "Random" then
		part = math.random(1,2) == 2 and "Head" or "HumanoidRootPart"
	end
	if part == "Closest" then
		part = tostring(get_closest_part(character))
	end
	local part = character:FindFirstChild(part)
	local hrp = character.HumanoidRootPart
	local velocity = flags["resolver"]["toggle"] and all_players[character.Name].velocity or hrp.Velocity
	local average_ping = get_average_ping()
	local ping = ((average_ping > cache.ping) and cache.ping or average_ping)/500
	local prediction = vect3()

	if flags["custom_prediction"]["toggle"] then
		prediction = (velocity * vect3(flags["horizontal_prediction"]["value"], flags["vertical_prediction"]["value"], flags["horizontal_prediction"]["value"]))
	else
		prediction = (velocity * vect3(ping, ping/2.5, ping))
	end

	if flags["shake"]["toggle"] then
		local horizontal_shake = flags["horizontal_shake"]["value"]
		local vertical_shake = flags["vertical_shake"]["value"]

		if horizontal_shake > 0 then
			if math.random(2) == 1 then
				prediction = prediction + vect3(((math.random(2) == 1) and -1 or 1) * math.random(1,horizontal_shake)/50, 0, ((math.random(2) == 1) and -1 or 1) * math.random(1,horizontal_shake)/50)
			end
		end

		if vertical_shake > 0 then
			if math.random(2) == 1 then
				prediction = prediction + vect3(0, ((math.random(2) == 1) and -1 or 1) * math.random(1,horizontal_shake)/50, 0)
			end
		end
	end

	aimbot.prediction = prediction

	return part.Position + prediction
end)

local on_input = util:create_connection(uis.InputBegan, LPH_JIT(function(input, gpe)
    if gpe then return end
    if input.KeyCode.Name:lower() == flags["force_target"]["bind"]["key"] then
        local closest = get_closest(true)
        aimbot.forced_target = (closest and players:FindFirstChild(tostring(closest)) ~= aimbot.forced_target) and players:FindFirstChild(tostring(closest)) or nil
    end
end))

-- ? RunService Connections

local offsets = {
	vect2(1,1),
	vect2(-1,1),
	vect2(1,-1),
	vect2(-1,-1)
}

do
	local on_heartbeat = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
		local character = lplr.Character

		cache.ping = get_ping()

		if not util:find(cache.average, cache.ping) then
			if #cache.average == 20 then
				table.remove(cache.average, util:find(cache.average, cache.average[1]))
			end
			table.insert(cache.average, cache.ping)
		end
		
		local closest = nil

		local circle = cache.strafe_circle
		local circle_visible = false
		local box_visible = false
		local box = cache.no_stand_box
		local old_closest = aimbot.active_target

		local viewed_player = cache.viewed_player

		if viewed_player then
			local character = viewed_player.Character
			if character then
				camera.CameraSubject = character
			end
		end

		if character then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if hrp and humanoid then
				local plrgui = lplr.PlayerGui
				if flags["no_flashbang"]["toggle"] then
					if plrgui then
						local msui = plrgui:FindFirstChild("MainScreenGui")
						if msui then
							local flashbang = msui:FindFirstChild("whiteScreen")
							if flashbang then flashbang:Destroy() end
						end 
					end
				end
				if flags["spinning_crosshair"]["toggle"] then
					local msui = plrgui:FindFirstChild("MainScreenGui")
					if msui then
						local crosshair = msui:FindFirstChild("Aim")
						if crosshair then
							local rotation = crosshair.Rotation
							if rotation == 360 then
								cache.last_crosshair_rotation = tick()
							end
							local elapsed_time = tick() - cache.last_crosshair_rotation
							local tween_value = ts:GetValue((elapsed_time / ((130-flags["spin_speed"]["value"])/100)), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
							crosshair.Rotation = tween_value * 360
						end
					end 
				end
				if flags["tick_walk"]["toggle"] and tick_walk:is_active() then
					if not cache.tick_cooldown then
						do_tick_walk()
					end
					if cache.tick_walk then
						sethiddenproperty(hrp, "NetworkIsSleeping", true)
					else
						sethiddenproperty(hrp, "NetworkIsSleeping", false)
					end
				end
				if flags["macro"]["toggle"] and macro:is_active() then
					cache.macro_bool = not cache.macro_bool
					if cache.macro_bool then
						keypress(0x49)
						keyrelease(0x49)
					else
						keypress(0x4F)
						keyrelease(0x4F)
					end
				end			
				if flags["money_aura"] and flags["money_aura"]["toggle"] and ignored_folder then
					local drop = ignored_folder:FindFirstChild("Drop")
					if drop then
						local money = drop:GetChildren()
						for i = 1, #money do
							local cash = money[i]
							if cash.Name == "MoneyDrop" then
								if (cash.Position-hrp.Position).magnitude < 12 then
									local click_detector = cash:FindFirstChild("ClickDetector")
									if click_detector then 
										fireclickdetector(click_detector) 
									end
								end
							end
						end 
					end
				end
				local connections = getconnections(hrp:GetPropertyChangedSignal("CFrame"))
				for i = 1, #connections do
					local connection = connections[i]
					connection:Disable()
				end
				local target = aimbot.forced_target 
				if flags["auto_stomp"]["toggle"] or cache.auto_kill then
					if not cache.stomp_delay then
						main_event:FireServer("Stomp")
						task.spawn(function()
							cache.stomp_delay = true
							task.wait(0.03)
							cache.stomp_delay = false
						end)
					end
				end
				if target then
					local character = target.Character
					if flags["target_strafe"]["toggle"] and target_strafe:is_active() and character and character:FindFirstChild("HumanoidRootPart") then
						local hrp_pos = character.HumanoidRootPart.Position + vect3(0,flags["y_offset"]["value"], 0)
						local target_strafe = flags["target_strafe"]
						local strafe_distance = flags["strafe_distance"]["value"]
						circle.Color = target_strafe["color"]
						circle.Transparency = -target_strafe["transparency"]+1
						circle.Radius = strafe_distance
						circle.Position = hrp_pos
						circle_visible = true
						cache.strafe_angle = clamp(cache.strafe_angle+flags["strafe_angle"]["value"], 0, 360)
						if cache.strafe_angle == 360 then cache.strafe_angle = 0 end
						hrp.CFrame = angles(0,rad(cache.strafe_angle),0) * cfnew(0,0,strafe_distance) + hrp_pos
					end
				end
				if flags["aimbot"]["toggle"] and aimbot_enabled:is_active() then
					closest = get_closest() or nil
					aimbot.active_target = closest
				end
				aimbot.aim_position = aimbot.active_target and get_aimbot_location(aimbot.active_target) or nil
				if aimbot.active_target and flags["auto_shoot"]["toggle"] and auto_shoot:is_active() then 
					local tool = character:FindFirstChildOfClass("Tool")
					if tool then
						local handle = tool:FindFirstChild("Handle")
						if handle then
							local visible = is_visible(aimbot.aim_position, handle.Position, aimbot.active_target)
							if visible then
								local ammo = tool:FindFirstChild("Ammo")
								if ammo and ammo.Value > 0 then
									tool:Activate()
									tool:Deactivate()
								end
							end
						end
					end
				end
				local is_spinbot = flags["spinbot"]["toggle"]
				humanoid.AutoRotate = not is_spinbot
				if flags["speed"]["toggle"] and cframe_speed:is_active() then
					hrp.CFrame = hrp.CFrame + character.Humanoid.MoveDirection * (flags["speed"]["value"]/30)
				end
				if flags["fly"]["toggle"] and cframe_fly:is_active() then
					local vel = hrp.Velocity
					local add = character.Humanoid.MoveDirection * (flags["fly"]["value"]/30)
					if uis:IsKeyDown(Enum.KeyCode.Space) then add+=vect3(0,1.5,0) end
					if uis:IsKeyDown(Enum.KeyCode.C) then add-=vect3(0,1.5,0) end
					hrp.CFrame = hrp.CFrame + add
					hrp.Velocity = vect3(vel.X, 2, vel.Z)
				end
				if is_spinbot then
					hrp.CFrame = hrp.CFrame * angles(0,rad(1+flags["spinbot"]["value"]),0)
				end
				if aimbot.aim_position then
					if flags["look_at"]["toggle"] then
						humanoid.AutoRotate = false
						local pos = aimbot.aim_position
						hrp.CFrame = cfnew(hrp.Position, vect3(pos.X, hrp.Position.Y, pos.Z))
					end
				end

				local anti_lock2 = flags["anti_lock"]

				if cache.force_cframe then
					hrp.CFrame = cache.force_cframe
					hrp.Velocity = vect3(0,1.1,0)
				end

				if flags["auto_armor"] and flags["auto_armor"]["toggle"] then
					local bodyeffects = character:FindFirstChild(character_folder_name)
					if bodyeffects then
						local armor = bodyeffects:FindFirstChild("Armor")
						if armor and armor.Value < 29 and cache.force_cframe == nil then
							purchase_item("High-Medium Armor", 0)
						end
					end
				end

				if cache.auto_kill then
					local player = players:FindFirstChild(cache.auto_kill)
					if player then
						local character = player.Character
						if character then
							local upper_torso = character:FindFirstChild("UpperTorso")
							if upper_torso then
								if lplr.Character:FindFirstChildOfClass("Highlight") and not cache.auto_ready then
									task.spawn(function()
										cache.auto_ready = true
										task.wait(1)
										cache.auto_ready = false
									end)
								end
								local bodyeffects = character:FindFirstChild(character_folder_name)
								local cf = cache.auto_ready and upper_torso.CFrame or upper_torso.CFrame - vect3(0,8,0)
								if bodyeffects then
									local ko = bodyeffects:FindFirstChild("K.O") or bodyeffects:FindFirstChild("KO")
									if ko and ko.Value == true then 
										cf = cfnew(upper_torso.Position + vect3(0,2.5,0))
									else 		
										local combat = 	lplr.Character:FindFirstChild("Combat")	
										if not combat then
											local combat = lplr.Backpack:FindFirstChild("Combat")
											if combat then
												humanoid:EquipTool(combat)
											end
										else
											combat:Activate()
										end
									end
								end
								hrp.CFrame = cf
							end
						end
					end	
				end

				local old_velocity = hrp.Velocity
				local oldcf = hrp.CFrame

				if anti_lock2["toggle"] and anti_lock:is_active() then
					local anti_type = flags["lock_type"]["selected"][1]
					
					if anti_type == "Rage" then
						hrp.Velocity = vect3(math.random(45,88), -math.random(20,50), math.random(45,80))
					elseif anti_type == "Legit" then
						hrp.Velocity = vect3(0, 0, 0)
					elseif anti_type == "Underground" then
						hrp.Velocity = vect3(old_velocity.X, -10000, old_velocity.Z)
					elseif anti_type == "Sky" then
						hrp.Velocity = vect3(old_velocity.X, 10000, old_velocity.Z)
					elseif anti_type == "Void" then
						hrp.Velocity = vect3(math.random(4000,5000), math.random(4000,5000), math.random(4000,5000))
					end
				end

				local no_stand_flag = flags["no_stand"]

				if no_stand_flag["toggle"] and no_stand:is_active() then
					local value = flags["no_stand_distance"]["value"]
					hrp.CFrame = hrp.CFrame + vect3(math.random(2) == 1 and -value or value, flags["no_stand_y"]["toggle"] and math.random(1,value) or 0, math.random(2) == 2 and -value or value)
					box.Position = hrp.CFrame.p
					box.Color = no_stand_flag["color"]
					box.Transparency = -no_stand_flag["transparency"]+1
					box_visible = true
				end

				cache.camera_cframe = oldcf
				
				rs.RenderStepped:Wait()

				if no_stand_flag["toggle"] and no_stand:is_active() then
					hrp.CFrame = oldcf
				end

				hrp.Velocity = old_velocity
			end
		end; if aimbot.active_target ~= old_closest then
			util:tween(camera, TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = camera.CFrame})
		end; aimbot.active_target = closest; circle.Visible = circle_visible; box.Visible = box_visible
		if flags["camlock"]["toggle"] and camlock:is_active() and aimbot.aim_position then
			local camera_pos = camera.CFrame.p
			util:tween(camera, TweenInfo.new(1-flags["camlock_speed"]["value"]/100, Enum.EasingStyle[flags["camlock_style"]["selected"][1]], Enum.EasingDirection.Out), {CFrame = cfnew(camera_pos, aimbot.aim_position)})
		end
	end))

	local velocity_fix = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
		local tick_time = tick()-aimbot.refresh_tick
		
		local is_tick_time = tick_time > flags["refresh_rate"]["value"]/1000
		for _, player in pairs(all_players) do
			local hrp, humanoid = player:is_character_loaded()
			player.is_loaded_cache = hrp and hrp or false
			if hrp then
				if is_tick_time then
					local hrp_pos = hrp.Position
					if not player.last_position then player.last_position = hrp_pos; continue end
					player.velocity = (hrp_pos - player.last_position) / tick_time
					player.last_position = hrp_pos
				end
			end
		end
		if is_tick_time then aimbot.refresh_tick = tick() end
	end))

	local on_render = util:create_connection(rs.RenderStepped, LPH_NO_VIRTUALIZE(function()
		local fov = aimbot.fov_drawing
		local outline = aimbot.fov_outline_drawing
		local show_fov = flags["show_fov"]
		fov.Visible = show_fov["toggle"]
		outline.Visible = flags["fov_outline"]["toggle"] and fov.Visible or false

		if fov.Visible then
			fov.Filled = flags["fov_filled"]["toggle"]
			fov.Color = show_fov["color"]
			fov.Transparency = -show_fov["transparency"]+1
			fov.Position = vect2(mouse.X, mouse.Y + 38)
			fov.Radius = flags["fov"]["value"]*10
			outline.Position = fov.Position
			outline.Radius = fov.Radius
		end

		local pos = aimbot.aim_position
		local line = aimbot.pos_line 
		local box = aimbot.pos_box 
		line.Visible = false
		box.Visible = false

		local active_target = aimbot.active_target 

		if flags["predicted_position"]["toggle"] and pos and active_target then
			local predicted_line = flags["predicted_line"]
			local predicted_box = flags["predicted_box"]
			if predicted_line["toggle"] then
				local pos2, on_screen = wtvp(pos)
				if on_screen then
					line.Visible = true
					line.Color = predicted_line["color"]
					line.Transparency = -predicted_line["transparency"]+1
					line.From = vect2(mouse.X, mouse.Y + 38)
					line.To = vect2(pos2.X, pos2.Y)
				end
			end
			if predicted_box["toggle"] then
				local hrp = active_target:FindFirstChild("HumanoidRootPart")
				if hrp then
					box.Position = hrp.Position + aimbot.prediction
					box.Visible = true
					box.Transparency = -predicted_box["transparency"]+1
					box.Color = predicted_box["color"]
				end
			end
		end

		local is_esp = flags["esp"]["toggle"]
		local only_specifics = flags["only_specifics"]["toggle"]
		local specifics = flags["specifics"]["selected"]
		local max_distance = flags["max_distance"]["toggle"]
		local distance_max = flags["distance_max"]["value"]

		local hrp_position = (lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") ~= nil) and lplr.Character.HumanoidRootPart.Position or vect3()
		local screen_size = viewport_size

		local cache2 = esp.cache
		for i = 1, #cache2 do
			local cache = cache2[i]
			local instance, drawings, highlight = cache[1], cache[2], cache[3]

			for _, drawing in pairs(drawings) do
				drawing.Visible = false
			end
			highlight.Enabled = false

			if not is_esp then continue end

			local name = instance.Name

			local is_good_to_go = not only_specifics
			local prefix = (util:find(specifics, "Whitelisted") and (instance:IsFriendsWith(lplr.UserId) or util:find(whitelisted, name))) and "friendly_" or ""
			local is_opp = util:find(opps, name)

			if only_specifics then
				if util:find(specifics, "Opps") and is_opp then 
					is_good_to_go = true
				end
				if prefix == "friendly_" then 
					is_good_to_go = true
				end
			end

			if not is_good_to_go then continue end

			local player = all_players[name]
			
			local hrp = player.is_loaded_cache

			if hrp then
				if max_distance then 
					if (hrp_position-hrp.Position).magnitude > distance_max then
						continue
					end
				end

				local bottom_wtvp, visible = wtvp(hrp.Position - vect3(0, 3.3, 0)) 
				local top_wtvp, visible2 = nil, nil

				if not visible then
					top_wtvp, visible2 = wtvp(hrp.Position + vect3(0, 2.9, 0))
				end

				if visible or visible2 then		
					if top_wtvp == nil then top_wtvp = wtvp(hrp.Position + vect3(0, 2.9, 0)) end
					local size = (bottom_wtvp.Y - top_wtvp.Y) / 2
					local box_size = vect2(floor(size * 1.4), floor(size * 1.9))
					local box_pos = vect2(floor(bottom_wtvp.X - size * 1.4 / 2), floor(bottom_wtvp.Y - size * 3.8 / 2))

					local hflag = flags["highlight"]
					local character = instance.Character

					if hflag["toggle"] then
						local oflag = flags["outline"]
						local color_flag2 = flags[prefix.."outline"]
						local color_flag = flags[prefix.."highlight"]

						highlight.FillColor = color_flag["color"]
						highlight.FillTransparency = color_flag["transparency"]
						highlight.OutlineColor = color_flag2["color"]
						highlight.OutlineTransparency = color_flag2["transparency"]
						highlight.Adornee = character
						highlight.Enabled = true
					end

					local nflag = flags["name"]

					if nflag["toggle"] then
						local name = drawings.name
						local color_flag = flags[prefix.."name"]

						name.Position = vect2(box_size.X / 2 + box_pos.X, box_pos.Y - name.TextBounds.Y - 2)
						name.Color = color_flag["color"]
						name.Transparency = -color_flag["transparency"]+1
						name.Visible = true
					end

					local bflag = flags["box"]

					if bflag["toggle"] then
						local box = drawings.box
						local outline = drawings.box_outline
						local color_flag = flags[prefix.."box"]

						box.Size = box_size
						box.Position = box_pos
						box.Color = color_flag["color"]
						box.Transparency = -color_flag["transparency"]+1
						outline.Transparency = -color_flag["transparency"]+1
						outline.Size = box_size
						outline.Position = box_pos
						box.Visible = true
						outline.Visible = true
					end

					local aflag, is_weapon_offset = flags["ammo"], false
					local tool = character:FindFirstChildOfClass("Tool")
					local bodyeffects = character:FindFirstChild(character_folder_name)

					if aflag["toggle"] then
						if tool then
							local ammo, max_ammo = tool:FindFirstChild("Ammo"), tool:FindFirstChild("MaxAmmo")
							if ammo and max_ammo then
								local ammo_fill = drawings.ammo_fill
								local outline = drawings.ammo_outline
								local last_ammo = ammo.Value
								local last_max_ammo = max_ammo.Value
								local color_flag = flags[prefix.."ammo"]

								if last_ammo ~= 0 then
									ammo_fill.From = vect2(box_pos.X + 1, box_pos.Y + box_size.Y + 5)
									ammo_fill.To = vect2((ammo_fill.From.X + ((last_ammo/last_max_ammo) * box_size.X)) - 2, ammo_fill.From.Y)
									ammo_fill.Color = color_flag["color"]
									ammo_fill.Transparency = -color_flag["transparency"]+1
									ammo_fill.Visible = true
								end

								outline.From = vect2(box_pos.X, box_pos.Y + box_size.Y + 5)
								outline.To = vect2(outline.From.X + box_size.X, outline.From.Y)
								outline.Transparency = -color_flag["transparency"]+1
								outline.Visible = true

								is_weapon_offset = true
							end
						end
					end

					local aim_viewer = flags["aim_viewer"]

					if aim_viewer["toggle"] and is_opp then
						if bodyeffects and tool then
							local mousepos = bodyeffects:FindFirstChild("MousePos")
							if mousepos then
								local handle = tool:FindFirstChild("Handle")

								if handle then
									local line = drawings.aim

									local screen_pos, on_screen = wtvp(handle.Position)
									if on_screen then
										local screen_pos2, on_screen2 = wtvp(mousepos.Value)

										if on_screen2 then
											line.From = screen_pos
											line.To = screen_pos2
											line.Color = aim_viewer["color"]
											line.Transparency = -aim_viewer["transparency"]+1
											line.Visible = true
										end
									end
								end 
							end
						end
					end

					local wflag = flags["weapon"]

					if wflag["toggle"] then
						if tool then
							local last_weapon = tool.Name
							local weapon = drawings.weapon
							local color_flag = flags[prefix.."weapon"]

							weapon.Text = tool.Name
							weapon.Color = color_flag["color"]
							weapon.Transparency = -color_flag["transparency"]+1
							weapon.Position = vect2(box_size.X / 2 + box_pos.X, (box_pos.Y + box_size.Y) + (not is_weapon_offset and 1 or 5))
							weapon.Visible = true
						end
					end

					local hflag = flags["health"]

					if hflag["toggle"] then
						local hum = character:FindFirstChildOfClass("Humanoid")

						if hum and bodyeffects then
							local health = drawings.health
							local outline = drawings.health_outline
							local health_text = drawings.health_text
							local armor = drawings.armor

							local hum_health = hum.Health
							local color_flag = flags[prefix.."health"]

							health.From = vect2((box_pos.X - 5), box_pos.Y + box_size.Y)
							health.To = vect2(health.From.X, health.From.Y - (player.health / hum.MaxHealth) * box_size.Y)
							health.Color = color_flag["color"]
							health.Transparency = -color_flag["transparency"]+1
							outline.From = vect2(health.From.X, box_pos.Y + box_size.Y + 1)
							outline.To = vect2(health.From.X, health.From.Y - box_size.Y - 1)
							outline.Transparency = -color_flag["transparency"]+1
							outline.Visible = true
							health.Visible = true

							if flags["number"]["toggle"] and hum_health < 100 then
								health_text.Text = tostring(util:round(hum_health))
								local text_bounds = health_text.TextBounds
								health_text.Position = health.To - vect2(text_bounds.X/2 + 2, 6)
								health_text.Visible = true
							end

							local defense = bodyeffects:FindFirstChild("Armor")
							local is_armor = flags["armor"]

							if defense and is_armor["toggle"] then
								local color_flag = flags[prefix.."armor"]

								local defense_val = defense.Value
								armor.From = health.From
								armor.To = vect2(health.From.X, health.From.Y - (player.armor / 130) * box_size.Y)
								armor.Color = color_flag["color"]
								armor.Transparency = -color_flag["transparency"]+1
								armor.Visible = true
							end
						end                        
					end
				else
					local tweens = player.tweens
					for i,v in pairs(tweens) do
						v[2]:Disconnect()
						player[v[1]] = v[3]
						tweens[i] = nil
					end
					local offscreen = flags["offscreen"]
					if offscreen["toggle"] then
						local triangle = drawings.triangle

						local camera_cframe = camera.CFrame
						camera_cframe = cflookat(camera_cframe.p, camera_cframe.p + camera_cframe.LookVector * vect3(1, 0, 1))
		
						local projected = camera_cframe:PointToObjectSpace(hrp.Position)
						local angle = atan2(projected.z, projected.x)
		
						local cx, sy = cos(angle), sin(angle)
						local cx1, sy1 = cos(angle + pi/2), sin(angle + pi/2)
						local cx2, sy2 = cos(angle + pi/2*3), sin(angle + pi/2*3)
		
						local big, small = max(screen_size.x, screen_size.y), min(screen_size.x, screen_size.y)
		
						local arrow_origin = screen_size/2 + vect2(cx * big * 75/200, sy * small * 75/200) * flags["offscreen_distance"]["value"]/1000

						local arrow_size = flags["offscreen_size"]["value"]/100
		
						triangle.PointA = arrow_origin + vect2(30 * cx, 30 * sy) * arrow_size
						triangle.PointB = arrow_origin + vect2(15 * cx1, 15 * sy1) * arrow_size
						triangle.PointC = arrow_origin + vect2(15 * cx2, 15 * sy2) * arrow_size
						
						triangle.Color = offscreen["color"]
						triangle.Transparency = -offscreen["transparency"]+1
						triangle.Visible = true
					end
				end
			end
		end

		local rpg_indicators = flags["rpg_indicator"]

		if #indicators > 0 then
			for i,v in pairs(indicators) do
				local drawings, rocket, pos, max = v.drawings, v.rocket, v.pos, v.max

				for _, drawing in pairs(drawings) do
					drawing.Visible = false
				end

				if rpg_indicators["toggle"] and rocket ~= nil and rocket.Parent == ignored_folder then
					local screen_pos, on_screen = wtvp(pos)
					if on_screen and hrp_position ~= vect3() then
						local visible = is_visible(rocket.Position, hrp_position, rocket)
						if visible then
							local size = (wtvp(pos - vect3(0, 1.4, 0)).Y - wtvp(pos + vect3(0, 1.4, 0)).Y) / 2
							local size = floor(size * 1.4)
							local color = rpg_indicators["color"]
							local outline = drawings.outline
							outline.Visible = true
							outline.Position = screen_pos
							outline.Radius = size
							local outline2 = drawings.outline2
							outline2.Visible = true
							outline2.Position = screen_pos
							outline2.Radius = size
							outline2.Color = color
							local fill = drawings.fill
							fill.Visible = true
							fill.Position = screen_pos
							fill.Radius = size
							fill.Color = color
							local text = drawings.text
							text.Visible = true
							text.Size = floor(size/1.6)
							text.Color = color
							text.Position = screen_pos - vect2(0,text.TextBounds.Y/2)
							local bar_outline = drawings.bar_outline
							bar_outline.Visible = true
							bar_outline.From = screen_pos + vect2(-(size/2 - 6),text.TextBounds.Y/2 + 1)
							bar_outline.To = screen_pos + vect2((size/2 - 6),text.TextBounds.Y/2 + 1)
							local bar_fill = drawings.bar_fill
							bar_fill.Visible = true
							bar_fill.From = bar_outline.From
							bar_fill.To = bar_outline.From + vect2((bar_outline.To.X-screen_pos.X) * ((rocket.Position-pos).magnitude/max), 0)
							bar_fill.Color = color
						end
					end
				else
					for _, drawing in pairs(drawings) do
						drawing:Remove()
					end
					indicators[i] = nil
				end
			end
		end

		local hitmarkers = cache.hitmarkers

		if #hitmarkers > 0 then
			local mouse_pos = vect2(mouse.X, mouse.Y + 36)
			local gap = flags["hitmarker_gap"]["value"]
			local size = flags["hitmarker_size"]["value"]
			local hitmarker_color = flags["hitmarker"]["color"]

			for i,v in pairs(hitmarkers) do
				local start_tick = v['start']
				local time_elapsed = tick()-start_tick
				local tween_value = ts:GetValue((time_elapsed / .6), Enum.EasingStyle.Sine, Enum.EasingDirection.In)
				for i = 1, 4 do
					local lines = v[i]
					local outline = lines.outline
					local line = lines.line
					if tween_value >= .99 then
						outline:Remove()
						line:Remove()
						continue
					end
					local offset = offsets[i]
					local offset_pos = offset * gap

					line.Visible = true
					outline.Visible = true
					line.From = mouse_pos + offset_pos
					line.To = line.From + offset * size
					line.Color = flags["hitmarker"]["color"]
					line.Transparency = 1-tween_value
					outline.Transparency = line.Transparency
					outline.From = line.From
					outline.To = line.To
				end
				if tween_value >= .99 then
					hitmarkers[i] = nil
				end
			end
		end
	end))

	local on_stepped = util:create_connection(rs.Stepped, LPH_NO_VIRTUALIZE(function()
		local character = lplr.Character
		if character then
			if noclip:is_active() and flags["noclip"]["toggle"] then
				local children = character:GetChildren()
				for i = 1, #children do
					local child = children[i]
					local classname = child.ClassName
					if classname == "Part" or classname == "MeshPart" or classname == "BasePart" then
						child.CanCollide = false
					end 
				end 
			end
		end
	end))
end

-- ? Metamethod Hooks

do
	local new_index = nil; new_index = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, index, value)
		if not checkcaller() then
			if self == workspace.CurrentCamera then
				if getcallingscript().Name == "Framework" then
					if typeof(value) == "CFrame" and flags["no_recoil"]["toggle"] then
						return
					end
				elseif index == "CFrame" and flags["aspect_ratio"]["toggle"] then
					local stretch_ratio = flags["ratio"]["value"]/100
					return new_index(self, index, value * cfnew(0, 0, 0, 1, 0, 0, 0, stretch_ratio, 0, 0, 0, 1))
				elseif index == "FieldOfView" then
					cache.fov = value
					if flags["field_of_view"]["toggle"] then
						return
					end
				end
			elseif self == game.Lighting then
				if index == "ClockTime" then
					cache.world_time = value
					if flags["world_time"]["toggle"] then return end
				elseif index == "FogColor" then
					cache.fog_color = value
					if flags["fog_changer"]["toggle"] then return end
				elseif index == "FogStart" then
					cache.fog_start = value
					if flags["fog_changer"]["toggle"] then return end
				elseif index == "FogEnd" then
					cache.fog_end = value
					if flags["fog_changer"]["toggle"] then return end
				elseif index == "Ambient" then
					cache.world_hue = value
					if flags["world_hue"]["toggle"] then return end
				elseif index == "ExposureCompensation" then
					cache.compensation = value
					if flags["exposure"]["toggle"] then return end
				elseif index == "Brightness" then
					cache.brightness = value
					if flags["brightness"]["toggle"] then return end
				end
			elseif typeof(self) == "Instance" then
				if self.ClassName == "Humanoid" and (lplr.Character and self.Parent == lplr.Character) then
					if index == "JumpPower" and value == 0 and flags["no_jump_cooldown"]["toggle"] then
						return
					elseif index == "WalkSpeed" and value < 16 and flags["no_slowdown"]["toggle"] then
						return
					end
				elseif self.Name == "PepperSprayBlur" and flags["no_blur"]["toggle"] then
					if value then
						return
					end
				end
			end
		end
		return new_index(self, index, value)
	end))

	local old_index = nil; old_index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, index)
		if not checkcaller() then
			if self == mouse and lower(index) == "hit" then
				if flags["anti_aim_viewer"]["toggle"] then
					return old_index(self, index)
				end
				if aimbot.aim_position and flags["silent_aim"]["toggle"] then
					return cfnew(aimbot.aim_position)
				end
			elseif typeof(self) == "Instance" and index == "CFrame" and self.Name == "HumanoidRootPart" and (lplr.Character and self.Parent == lplr.Character) and no_stand:is_active() and flags["no_stand"]["toggle"] then
				return cache.camera_cframe
			end
		end
		return old_index(self, index)
	end))
end

-- ? Main Init

for _, instance in pairs(players:GetPlayers()) do
	if instance == lplr then continue end
	esp:setup(instance)
	all_players[instance.Name] = player.new(instance)
end

if lplr.Backpack then
    for _, tool in pairs(lplr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
			local on_ammo_change = nil
			local ammo = tool:WaitForChild("Ammo", 0.03)
			if ammo then
				local old_value = ammo.Value

				on_ammo_change = ammo:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
					local ammo = ammo.Value
					if ammo < old_value then
						if ammo == 0 then
							if flags["auto_reload"]["toggle"] then
								main_event:FireServer("Reload", tool)
							end
						end
						cache.recently_shot = true
						task.spawn(function()
							task.wait()
							task.wait()
							cache.recently_shot = false
						end)
					end
					old_value = ammo
				end))
			end

            local on_tool_activated = tool.Activated:Connect(LPH_JIT(function()
                if flags["anti_aim_viewer"]["toggle"] then
                    main_event:FireServer(cache.mouse_arg, aimbot.aim_position)
                end
            end))

            local self_connection = nil

            task.wait()

            self_connection = tool:GetPropertyChangedSignal("Parent"):Connect(LPH_JIT(function()
                if lplr:FindFirstChild("Backpack") and tool.Parent == lplr.Backpack then
                    self_connection:Disconnect()
                    on_tool_activated:Disconnect()
					if on_ammo_change then on_ammo_change:Disconnect() end
                end
            end))
        end
    end

    util:create_connection(lplr.Backpack.ChildAdded, LPH_JIT(function(tool)
        if tool:IsA("Tool") then
			local on_ammo_change = nil
			local ammo = tool:WaitForChild("Ammo", 0.03)
			if ammo then
				local old_value = ammo.Value

				on_ammo_change = ammo:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
					local ammo = ammo.Value
					if ammo < old_value then
						if ammo == 0 then
							if flags["auto_reload"]["toggle"] then
								main_event:FireServer("Reload", tool)
							end
						end
						cache.recently_shot = true
						task.spawn(function()
							task.wait()
							task.wait()
							cache.recently_shot = false
						end)
					end
					old_value = ammo
				end))
			end

            local on_tool_activated = tool.Activated:Connect(LPH_JIT(function()
                if flags["anti_aim_viewer"]["toggle"] then
                    main_event:FireServer(cache.mouse_arg, aimbot.aim_position)
                end
            end))
    
            local self_connection = nil
    
            task.wait()
            
            self_connection = tool:GetPropertyChangedSignal("Parent"):Connect(LPH_JIT(function()
                if lplr:FindFirstChild("Backpack") and tool.Parent == lplr.Backpack then
                    self_connection:Disconnect()
                    on_tool_activated:Disconnect()
					if on_ammo_change then on_ammo_change:Disconnect() end
                end
            end))
        end
    end))
end

if lplr.Character then
	local hum = lplr.Character:WaitForChild("Humanoid", 1)
    local on_child_added = util:create_connection(lplr.Character.ChildAdded, LPH_JIT(function(tool)
        if tool:IsA("Tool") then
            local handle = tool:WaitForChild("Handle", 1)
			if handle then
				local flag = flags["forcefield_tools"]
				local default = tool:FindFirstChild("Default")
				local t = flag["toggle"]
				handle.Material = t and forcefield or plastic
				handle.Color = t and flag["color"] or Color3.fromRGB(163, 162, 165)
				if default then
					default.Material = t and forcefield or plastic
					default.Color = t and flag["color"] or Color3.fromRGB(163, 162, 165)
				end 
			end
		elseif tool:IsA("MeshPart") then
			local flag = flags["forcefield_body"]
			if flag["toggle"] then
				local color = flag["forcefield_body"]["color"]
				local part = tool
				if part.Name:find("Foot") or part.Name:find("Leg") then
					part.Color = color
				elseif part.Name:find("Arm") or part.Name:find("Hand") then
					part.Color = color
				elseif part.Name:find("Torso") then
					part.Color = color
				elseif part.Name == "Head" then
					part.Color = color
				end
			end
        end
    end))

	local bodyeffects = lplr.Character:WaitForChild(character_folder_name, 1)

	if bodyeffects then
		local ko = bodyeffects:WaitForChild("K.O", 1) or bodyeffects:WaitForChild("KO", 1)
		if ko then
			local value_change = ko:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
				local value = ko.Value
				if value == true and flags["anti_stomp"]["toggle"] then
					hum.Health = 0
				end
			end))
		end
	end
end

local on_character_added = util:create_connection(lplr.CharacterAdded, LPH_JIT(function(character)
    lplr:WaitForChild("Backpack")

	local hum = character:WaitForChild("Humanoid")
	hum:SetStateEnabled(Enum.HumanoidStateType.Seated, not flags["no_sit"]["toggle"])

	if flags["forcefield_body"]["toggle"] then
		local parts = character:GetChildren()
		local color = flags["forcefield_body"]["color"]

		for i = 1, #parts do
			local part = parts[i]
			if part.Name:find("Foot") or part.Name:find("Leg") then
				part.Color = color
				part.Material = forcefield
			elseif part.Name:find("Arm") or part.Name:find("Hand") then
				part.Color = color
				part.Material = forcefield
			elseif part.Name:find("Torso") then
				part.Color = color
				part.Material = forcefield
			elseif part.Name == "Head" then
				part.Color = color
				part.Material = forcefield
			end
		end
	end

	if flags["forcefield_hats"]["toggle"] then
		local parts = character:GetChildren()
		local color = flags["forcefield_hats"]["color"]

		for i = 1, #parts do
			local part = parts[i]
			if part.ClassName == "Accessory" then
				local part = part:FindFirstChildOfClass("Part") or part:FindFirstChildOfClass("MeshPart")
				if part then
					part.Material = forcefield
					part.Color = color 
				end
			end
		end
	end

    local on_child_added = util:create_connection(character.ChildAdded, function(tool)
        if tool:IsA("Tool") then
            local handle = tool:WaitForChild("Handle", 1)
			if handle then
				local flag = flags["forcefield_tools"]
				local default = tool:FindFirstChild("Default")
				local t = flag["toggle"]
				handle.Material = t and forcefield or plastic
				handle.Color = t and flag["color"] or Color3.fromRGB(163, 162, 165)
				if default then
					default.Material = t and forcefield or plastic
					default.Color = t and flag["color"] or Color3.fromRGB(163, 162, 165)
				end 
			end
		elseif tool:IsA("MeshPart") then
			local flag = flags["forcefield_body"]
			if flag["toggle"] then
				local color = flag["color"]
				local part = tool
				if part.Name:find("Foot") or part.Name:find("Leg") then
					part.Color = color
				elseif part.Name:find("Arm") or part.Name:find("Hand") then
					part.Color = color
				elseif part.Name:find("Torso") then
					part.Color = color
				elseif part.Name == "Head" then
					part.Color = color
				end
			end
        end
    end)
            
    local on_tool_added = util:create_connection(lplr.Backpack.ChildAdded, function(tool)
        if tool:IsA("Tool") then
			local on_ammo_change = nil
			local ammo = tool:WaitForChild("Ammo", 0.03)
			if ammo then
				local old_value = ammo.Value

				on_ammo_change = ammo:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
					local ammo = ammo.Value
					if ammo < old_value then
						if ammo == 0 then
							if flags["auto_reload"]["toggle"] then
								main_event:FireServer("Reload", tool)
							end
						end
						cache.recently_shot = true
						task.spawn(function()
							task.wait()
							task.wait()
							cache.recently_shot = false
						end)
					end
					old_value = ammo
				end))
			end

            local on_tool_activated = tool.Activated:Connect(LPH_JIT(function()
                if flags["anti_aim_viewer"]["toggle"] then
                    main_event:FireServer(cache.mouse_arg, aimbot.aim_position)
                end
            end))
    
            local self_connection = nil
    
            task.wait()
            
            self_connection = tool:GetPropertyChangedSignal("Parent"):Connect(LPH_JIT(function()
                if lplr:FindFirstChild("Backpack") and tool.Parent == lplr.Backpack then
                    self_connection:Disconnect()
                    on_tool_activated:Disconnect()
					if on_ammo_change then on_ammo_change:Disconnect() end
                end
            end))
        end
    end)

	local headless = flags["headless"]["toggle"] 
	if headless then
		local head = character:WaitForChild("Head")
		local decal = head:WaitForChild("face", 1)
		if decal then
			decal.Transparency = 1
		end
		head.Transparency = 1
	end

	local bodyeffects = character:WaitForChild(character_folder_name, 1)

	if bodyeffects then
		local ko = bodyeffects:WaitForChild("K.O", 1) or bodyeffects:WaitForChild("KO", 1)
		if ko then
			local value_change = ko:GetPropertyChangedSignal("Value"):Connect(LPH_JIT(function()
				local value = ko.Value
				if value == true and flags["anti_stomp"]["toggle"] then
					hum.Humanoid = 0
				end
			end))
		end
	end
end))

do
	if util:find(exact_dh_clones, game.GameId) then
		LPH_JIT(function()
			local all_shop = ignored_folder.Shop:GetChildren()

			for i = 1, #all_shop do
				local shop_item = all_shop[i]
				local new_name = string.match(shop_item.Name, "%b[]")
				local head = shop_item:FindFirstChild("Head")
				if head and head.CFrame.p.Y > -35 then
					if new_name then
						new_name = new_name:sub(2, -2)
						local item_in_table = not new_name:find("Ammo") and all_item_names[new_name] or all_item_names[new_name:sub(1, -6)]
						if item_in_table then
							if shop_item.Name:find("Ammo") and item_in_table.ammo_purchase == nil then
								item_in_table.ammo_purchase = head
							elseif item_in_table.purchase == nil then
								item_in_table.purchase = head
							end
						end
					end
				end
			end

			util:create_connection(purchase.on_clicked, function()
				local selected = flags["selected_item"]["selected"][1]
				if selected and cache.force_cframe == nil then
					purchase_item(selected, flags["selected_ammo"]["value"])
				end
			end)
		end)()
	end
end

do
	local players = players:GetPlayers()
	for i = 1, #players do
		local player = players[i]
		if player ~= lplr then
			selected_player:add_option(player.Name)
		end
	end
end

-- ? Anti-Cheat Bypasses

for i,v in pairs(getconnections(camera:GetPropertyChangedSignal("CFrame"))) do
	v:Disable()
end

for i,v in pairs(getconnections(game:GetService("LogService").MessageOut)) do
	v:Disable()
end

-- ? Finished

for i = 1, #all_configs do
	local config = all_configs[i]
	config_list:add_option(config)
	table.insert(current_configs, config)
end

task.wait(1)