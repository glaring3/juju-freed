-- * Services

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
local pi = math.pi

local lib = {
	config_location = "ratio",
	copied_color = nil,
	accent_color = Color3.fromRGB(189, 172, 255),
	on_config_load = signal.new("on_config_load"),
	flags = {}
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

function util:encode64(data)
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

function util:decode64(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
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
	game.TweenService:Create(...):Play()
end

function util:set_draggable(obj)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
	local x = object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= object.AbsolutePosition.Y + object.AbsoluteSize.Y
	local y = object.AbsolutePosition.X <= mouse.X and mouse.X <= object.AbsolutePosition.X + object.AbsoluteSize.X

	return (x and y)
end

function util:create_new(classname, properties, custom)
	local object = Instance.new(classname)

	for prop, val in pairs(properties) do
		local prop, val = prop, val
		if prop == "Parent" and classname == "ScreenGui" then
			val = gethui and gethui() or game.Players.LocalPlayer.PlayerGui
			if syn and syn.protect_gui then syn.protect_gui(object) end
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
	return texts:GetTextSize(title, 12, "RobotoMono", Vector2.new(999,999)).X
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
	util:tween(self.line, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 1, 1), Size = UDim2.new(0, 0, 0, 1)})
	util:tween(self.tab_holder, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1,0,0,0)})
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
	util:tween(self.line, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -298, 1, 1), Size = UDim2.new(0.5, 0, 0, 1)})
	util:tween(self.tab_holder, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)})
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
		Position = UDim2.new(0, 106, 0, 1);
		Size = UDim2.new(0, util:get_text_size(text) + 20, 0, 19);
		Parent = self.tab_holder
	}); TabName = "t-"..text
	local TabLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		ZIndex = 2;
		Font = Enum.Font.RobotoMono;
		Text = text;
		TextColor3 = Color3.fromRGB(189, 172, 255);
		TextSize = 12.000;
		BackgroundTransparency = 1;
		Parent = TabButton
	})
	local UICorner = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 6);
		Parent = TabButton
	})
	local ButtonFix = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		Position = UDim2.new(0, 1, 0, 9);
		Size = UDim2.new(1, -2, 0, 10);
		Visible = false;
		Parent = TabButton
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(189, 172, 255)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(189, 172, 255)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(32, 32, 32)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(32, 32, 32))};
		Rotation = 90;
		Offset = Vector2.new(0,-0.19);
		Parent = TabButton
	})
	local UICorner_2 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 6);
		Parent = TabLabel
	})
	local ButtonFix2 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 1, 0);
		Size = UDim2.new(1, -2, 0, 1);
		Visible = false;
		Parent = TabButton
	})
	local TabFrame = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 12, 0, 34);
		Size = UDim2.new(1, -24, 0, 360);
		Parent = self.main;
		Visible = false
	})
	local SubtabHolder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		Size = UDim2.new(0, 116, 0, 360);
		Parent = TabFrame
	})
	local SubtabInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 6, 0, 6);
		Size = UDim2.new(1, -12, 1, -12);
		Parent = SubtabHolder
	})
	local UIListLayout = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = UDim.new(0, 3);
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
	util:tween(gradient, TweenInfo.new(0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Offset = Vector2.new(0,0)})
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
	util:tween(gradient, TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Offset = Vector2.new(0,-0.19)})
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
		Size = UDim2.new(1, 0, 0, 18);
		Parent = self.holder
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(17, 17, 17)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(9, 9, 9))};
		Parent = SubtabButton
	})
	local ButtonLine = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(189, 172, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 1, 1, 0);
		Parent = SubtabButton
	})
	local ButtonLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 8, 0, 0);
		Size = UDim2.new(1, -8, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = text;
		TextColor3 = Color3.fromRGB(189, 172, 255);
		TextSize = 12.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = SubtabButton
	})
	local Left = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 127, 0, 0);
		Size = UDim2.new(0, 217, 0, 360);
		Visible = false;
		Parent = self.frame;
	})
	local UIListLayout = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = UDim.new(0, 10);
		Parent = Left
	})
	local Right = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(32, 32, 32);
		BorderSizePixel = 0;
		Position = UDim2.new(1, -217, 0, 0);
		Size = UDim2.new(0, 217, 0, 360);
		Visible = false;
		Parent = self.frame
	})
	local UIListLayout_4 = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = UDim.new(0, 10);
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
		Size = UDim2.new(0, 217, 0, 38);
		Parent = info.side:lower() == "left" and self.left or self.right
	})
	local SectionTop = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 0, 21);
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
		Position = UDim2.new(0, 1, 1, 0);
		Size = UDim2.new(1, -2, 0, 1);
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
		Position = UDim2.new(0, 5, 0, 0);
		Size = UDim2.new(1, -5, 1, 0);
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
		Position = UDim2.new(0, 1, 0, 22);
		Size = UDim2.new(1, -2, 1, -22);
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
		ScrollBarImageColor3 = Color3.fromRGB(56,56,56);
		CanvasSize = UDim2.new(0, 0, 1, -22);
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
		Position = UDim2.new(0, 14, 0, 8);
		Size = UDim2.new(1, -28, 1, -16);
		Parent = SectionHolder
	})
	local UIListLayout = util:create_new("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = UDim.new(0, 9);
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
		frame.CanvasSize = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + size2)
	elseif frame.ClassName == "Frame" then
		self.scroller.ScrollingEnabled = false
		local size = frame.Size
		if frame.Size.Y.Offset + size2 >= self.max_size then
			local leftover = frame.Size.Y.Offset + size2 - self.max_size
			frame.Size = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, self.max_size)

			local frame = self.scroller
			local size = frame.CanvasSize
			frame.ScrollingEnabled = true
			frame.CanvasSize = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + leftover)
		else
			frame.Size = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + size2)
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
		Size = UDim2.new(1, 0, 0, 8);
		Parent = self.holder
	})
	local ElementLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 12, 0, 0);
		Size = UDim2.new(0, util:get_text_size(name) + 4, 0, 7);
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
		Position = UDim2.new(1, -30, 0, 0);
		Size = UDim2.new(0, 30, 0, 8);
		Parent = ElementFrame
	})
	local UIListLayout = util:create_new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder;
		VerticalAlignment = Enum.VerticalAlignment.Center;
		Padding = UDim.new(0, 5);
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
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(0, 6, 0, 6);
				Parent = ElementFrame
			})
			local ToggleInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(189, 172, 255);
				BackgroundTransparency = 1;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Visible = false;
				Size = UDim2.new(0, 6, 0, 6);
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
				Size = UDim2.new(0, 9, 0, 9);
				Image = "rbxassetid://14138205253";
				ImageColor3 = Color3.fromRGB(74, 74, 74);
				ZIndex = 100;
				Parent = AddonHolder
			})
			local KeybindOpen = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, 0, 0);
				Size = UDim2.new(0, 163, 0, 19);
				Parent = self.lib.screen_gui;
				ZIndex = 15;
				Visible = false
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
				Parent = KeybindOpen
			})
			local OpenInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = KeybindOpen
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
				Parent = OpenInside
			})
			local OpenLabel = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = OpenInside
			})
			local UICorner_3 = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
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
				OpenText.Position = UDim2.new(1, -size, 0, 0)
			end); OpenText.Size = UDim2.new(0, util:get_text_size("keybind: unbound"), 1, 0);
			local OpenMethod = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0.065750733, 0, 0.0604938269, 0);
				Size = UDim2.new(0, 65, 0, 60);
				ZIndex = 16;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
				Parent = OpenMethod
			})
			local MethodInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				ZIndex = 16;
				Parent = OpenMethod
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
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
				Size = UDim2.new(1, 0, 0, 19);
				Font = Enum.Font.RobotoMono;
				Text = " hold";
				TextColor3 = Color3.fromRGB(189, 172, 255);
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
				Size = UDim2.new(1, 0, 0, 20);
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
				Size = UDim2.new(1, 0, 0, 19);
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
				OpenText.Size = UDim2.new(0, util:get_text_size(OpenText.Text), 1, 0);
				new_element.on_key_change:Fire(key2)
			end

			local function open_method()
				if info.method_lock then return end
				is_choosing_method = true
				OpenMethod.Visible = true
				OpenMethod.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
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
				label.TextColor3 = Color3.fromRGB(189, 172, 255)
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
				KeybindOpen.Position = UDim2.new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function close_keybind()
				lib.busy = false; is_open = false
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
				Position = UDim2.new(0, 12, 0, 15);
				Size = UDim2.new(1, -24, 0, 6);
				Parent = ElementFrame
			})
			local SliderFill = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(189, 172, 255);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Size = UDim2.new(1, 0, 1, 0);
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
				Position = UDim2.new(1, -12, 0, 0);
				Size = UDim2.new(0, 0, 0, 7);
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
				SliderFill.Size = UDim2.new((value - min)/(max-min), 0, 1, 0)
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
				Position = UDim2.new(0, 12, 0, 12);
				Size = UDim2.new(1, -24, 0, 20);
				Parent = ElementFrame
			})
			local DropdownBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
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
				Position = UDim2.new(1, -13, 0.5, -4);
				Size = UDim2.new(0, 8, 0, 8);
				Image = "http://www.roblox.com/asset/?id=14138109916";
				ImageColor3 = Color3.fromRGB(74, 74, 74);
				Parent = DropdownBackground
			})
			local DropdownText = util:create_new("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 5, 0, 0);
				Size = UDim2.new(1, -23, 1, 0);
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
				Position = UDim2.new(0, 440, 0, 54);
				Size = UDim2.new(0, 163, 0, 60);
				Parent = self.lib.screen_gui
			}); OpenDropdown.Visible = false
			local OpenInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(16, 16, 16);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				ClipsDescendants = true;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
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
							v.TextColor3 = Color3.fromRGB(189, 172, 255)
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

			OpenDropdown.Size = UDim2.new(0, 163, 0, #options*20)

			local function open_dropdown()
				local abspos = DropdownBorder.AbsolutePosition
				OpenDropdown.Position = UDim2.new(0, abspos.X + 1, 0, abspos.Y + 22)
				OpenDropdown.Visible = true
				ElementLabel.TextColor3 = Color3.fromRGB(221,221,221)
				DropdownText.TextColor3 = Color3.fromRGB(221,221,221)
				DropdownImage.ImageColor3 = Color3.fromRGB(221,221,221)
				is_open = true; lib.busy = true;
			end

			local function close_dropdown()
				OpenDropdown.Visible = false
				is_open = false; lib.busy = false
				ElementLabel.TextColor3 = (#lib.flags[flag]["selected"] == 0 and (util:is_in_frame(DropdownBorder) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)) or Color3.fromRGB(221,221,221))
				DropdownText.TextColor3 = util:is_in_frame(DropdownBorder) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
				DropdownImage.ImageColor3 = util:is_in_frame(DropdownBorder) and Color3.fromRGB(126,126,126) or Color3.fromRGB(74,74,74)
				UIGradient.Color = util:is_in_frame(DropdownBorder) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(33, 33, 33)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(23, 23, 23))} or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(23, 23, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
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
					Size = UDim2.new(1, 0, 0, 20);
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

				local on_click = util:create_connection(DropdownOption.InputBegan, function(input, gpe)
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
				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(33, 33, 33)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(23, 23, 23))};
				DropdownText.TextColor3 = Color3.fromRGB(126,126,126)
				DropdownImage.ImageColor3 = Color3.fromRGB(126,126,126)
				if #lib.flags[flag]["selected"] == 0 then
					ElementLabel.TextColor3 = Color3.fromRGB(126,126,126)
				end
			end)

			local on_enter = util:create_connection(DropdownBorder.MouseLeave, function()
				if is_open or lib.busy then return end
				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(23, 23, 23)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
				DropdownText.TextColor3 = Color3.fromRGB(74,74,74)
				DropdownImage.ImageColor3 = Color3.fromRGB(74,74,74)
				if #lib.flags[flag]["selected"] == 0 then
					ElementLabel.TextColor3 = Color3.fromRGB(74,74,74)
				end
			end)

			local on_click = util:create_connection(uis.InputBegan, function(input, gpe)
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
				Position = UDim2.new(0, 12, 0, 0);
				Size = UDim2.new(1, -24, 0, 24);
				Parent = ElementFrame
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 3);
				Parent = Button
			})
			local ButtonInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				Parent = Button
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 3);
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
				Size = UDim2.new(1, 0, 1, 0);
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
				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}
				ButtonLabel.TextColor3 = Color3.fromRGB(221,221,221)
			end)

			local on_leave = util:create_connection(Button.MouseLeave, function()
				if is_holding or lib.busy then return end
				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
				ButtonLabel.TextColor3 = Color3.fromRGB(74,74,74)
			end)

			local on_click = util:create_connection(Button.InputBegan, function(input, gpe)
				if gpe or lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					is_holding = true
					ButtonLabel.TextColor3 = Color3.fromRGB(189, 172, 255)
					Button.BackgroundColor3 = Color3.fromRGB(189, 172, 255)
				end
			end)

			local confirmation_cover = self.lib.confirmation_cover
			local confirmation_frame = self.lib.confirmation

			local is_in_confirmation = false

			local on_stopclick = util:create_connection(Button.InputEnded, function(input, gpe)
				if gpe or lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					is_holding = false
					ButtonLabel.TextColor3 = util:is_in_frame(Button) and Color3.fromRGB(221,221,221) or Color3.fromRGB(74,74,74)
					UIGradient.Color = util:is_in_frame(Button) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
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
					lib.busy = false
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
				Position = UDim2.new(0, 12, 0, 0);
				Size = UDim2.new(1, -24, 0, 19);
				Parent = ElementFrame
			})
			local DropdownBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(24, 24, 24);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				Parent = MultiboxTextbox
			})
			local TextBox = util:create_new("TextBox", {
				Parent = DropdownBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 5, 0, 0);
				Size = UDim2.new(1, -5, 1, 0);
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
				Position = UDim2.new(0, 12, 0, 19);
				Size = UDim2.new(1, -24, 0, 2 + info.maxsize*17);
				Parent = ElementFrame
			})
			local MultiboxScroll = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
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
				Size = UDim2.new(1, 0, 1, 0);
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				CanvasSize = UDim2.new(0, 0, 1, 0);
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
				Padding = UDim.new(0,0);
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
					Size = UDim2.new(1, 0, 0, 17);
					ZIndex = 2;
					Font = Enum.Font.RobotoMono;
					Text = " "..option;
					TextColor3 = Color3.fromRGB(74, 74, 74);
					TextSize = 12.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = MultiboxInside
				}); MultiboxLabel.Name = option
				local MultiLine = util:create_new("Frame", {
					BackgroundColor3 = Color3.fromRGB(189, 172, 255);
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = UDim2.new(0, 1, 1, 0);
					Visible = false;
					ZIndex = 2;
					Parent = MultiboxLabel
				}); MultiLine.Name = "Line"
				local LabelFade = util:create_new("Frame", {
					BackgroundColor3 = Color3.fromRGB(254, 254, 254);
					BorderColor3 = Color3.fromRGB(0, 0, 0);
					BorderSizePixel = 0;
					Size = UDim2.new(0, 40, 1, 0);
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
					MultiboxInside.CanvasSize = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + 17)
					MultiboxInside.ScrollingEnabled = true
				else
					MultiboxInside.ScrollingEnabled = false
				end
				if selected == nil then set_option(option) end
			end

			function new_element:remove_option(option)
				if options > info.maxsize then
					local size = MultiboxInside.CanvasSize
					MultiboxInside.CanvasSize = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset - 17)
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
				Size = UDim2.new(0, 9, 0, 9);
				Image = "rbxassetid://14138205253";
				ImageColor3 = Color3.fromRGB(74, 74, 74);
				ZIndex = 14;
				Parent = AddonHolder
			})
			local ColorpickerOpen = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0.329400182, 0, 0.683950603, 0);
				Size = UDim2.new(0, 163, 0, 181);
				ZIndex = 15;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
				Parent = ColorpickerOpen
			})
			local ColorpickerBorder = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(32, 32, 32);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = ColorpickerOpen
			})
			local UICorner_2 = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
				Parent = ColorpickerBorder
			})
			local ColorpickerInside = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = ColorpickerBorder
			})
			local UICorner_3 = util:create_new("UICorner", {
				CornerRadius = UDim.new(0, 4);
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
				Position = UDim2.new(0, 3, 0, 17);
				Size = UDim2.new(0, 141, 0, 145);
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
				Size = UDim2.new(0, 4, 0, 4);
				Image = "http://www.roblox.com/asset/?id=14138315296";
				Parent = SaturationImage
			})
			local HueFrame = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = UDim2.new(1, -11, 0, 17);
				Size = UDim2.new(0, 8, 0, 145);
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
				Position = UDim2.new(0, -1, 0, 0);
				Size = UDim2.new(0, 10, 0, 3);
				ZIndex = 15;
				Image = "http://www.roblox.com/asset/?id=14138375431";
				Parent = HueFrame
			})
			local TransparencyFrame = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				Position = UDim2.new(0, 3, 1, -11);
				Size = UDim2.new(0, 141, 0, 8);
				ZIndex = 15;
				Parent = ColorpickerInside
			})
			local TransparencyMover = util:create_new("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(1, -3, 0, -1);
				Size = UDim2.new(0, 3, 0, 10);
				ZIndex = 15;
				Image = "http://www.roblox.com/asset/?id=14138391128";
				Parent = TransparencyFrame
			})

			lib.flags[flag]["color"] = info.color and info.color or Color3.fromRGB(255,255,255)
			lib.flags[flag]["transparency"] = info.transparency and info.transparency or 0

			local is_open = false
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
				ColorpickerOpen.Position = UDim2.new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function close_colorpicker()
				lib.busy = false; is_open = false
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
			end)

			local on_hover = util:create_connection(AddonImage.MouseEnter, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = Color3.fromRGB(126,126,126)
			end)

			local on_leave = util:create_connection(AddonImage.MouseLeave, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = Color3.fromRGB(74,74,74)
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
				end
			end)

			local on_mouse1end = util:create_connection(uis.InputBegan, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and is_open and not util:is_in_frame(AddonImage) and not util:is_in_frame(ColorpickerOpen) then
					close_colorpicker()
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
                SaturationMover.Position = UDim2.new(clamp(sat/255, 0, 0.98), 0, 1 - clamp(val/255, 0.02, 1), 0)
                lib.flags[flag]["color"] = color
                new_element.on_color_change:Fire(color)
            end

            local function update_hue(hue2)
                SaturationImage.BackgroundColor3 = Color3.fromHSV(hue2/360, 1, 1)
                HueMover.Position = UDim2.new(0, -1, clamp(hue2/360, 0, 0.99), -1)
                color = Color3.fromHSV(hue2/360, saturation/255, value/255)
                hue = hue2
                lib.flags[flag]["color"] = color
                new_element.on_color_change:Fire(color)
            end

            local function update_transparency(o, nocallback)
                TransparencyMover.Position = UDim2.new(clamp(1 - o, 0, 0.98), 0, 0, -1)
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
				Position = UDim2.new(0, 12, 0, 11);
				Size = UDim2.new(1, -24, 0, 19);
				Parent = ElementFrame
			})
			local DropdownBackground = util:create_new("Frame", {
				BackgroundColor3 = Color3.fromRGB(24, 24, 24);
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 1, 0, 1);
				Size = UDim2.new(1, -2, 1, -2);
				Parent = MultiboxTextbox
			})
			local TextBox = util:create_new("TextBox", {
				Parent = DropdownBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 5, 0, 0);
				Size = UDim2.new(1, -5, 1, 0);
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
				TextBox.Text = lib.flags[flag]["text"]
			end)
		end
	end

	ElementFrame.Size = UDim2.new(1, 0, 0, self.elements ~= 0 and new_element.total_size-9 or new_element.total_size)

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
		Position = UDim2.new(0.132718891, 0, 0.122222222, 0);
		Size = UDim2.new(0, 600, 0, 430);
		Parent = ScreenGui
	})
	local AddonCover = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(1, 1, 1);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0, 25);
		Size = UDim2.new(1, 0, 0, 381);
		Visible = false;
		ZIndex = 14;
		Parent = MainBackground
	})
	local ConfirmCover = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(1, 1, 1);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0, 25);
		Size = UDim2.new(1, 0, 0, 381);
		Visible = false;
		ZIndex = 14;
		Parent = MainBackground
	})
	local UICorner = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = MainBackground
	})
	local MainBorder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Parent = MainBackground
	})
	local UICorner_2 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = MainBorder
	})
	local MainInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Parent = MainBorder    
	})
	local UICorner_3 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = MainInside
	})
	local MainTop = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 0, 20);
		Parent = MainBorder  
	})
	local UICorner_4 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = MainTop
	})
	local TopInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Parent = MainTop
	})
	local UICorner_5 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = TopInside
	})
	local TopFix = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		Position = UDim2.new(0, 0, 0, 9);
		Size = UDim2.new(1, 0, 0, 9);
		Parent = TopInside
	})
	local TopFix2 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, -1);
		Size = UDim2.new(1, 0, 0, 1);
		Parent = TopFix
	})
	local NameLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 5, 0, 0);
		Size = UDim2.new(0, 95, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "ratio.lol";
		TextColor3 = Color3.fromRGB(189, 172, 255);
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
		Position = UDim2.new(0, 0, 1, 0);
		Size = UDim2.new(1, 0, 0, 1);
		Parent = MainTop
	})
	local MainBottom = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 1, -21);
		Size = UDim2.new(1, -2, 0, 20);
		Parent = MainBorder
	})
	local UICorner_8 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = MainBottom
	})
	local BottomInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Parent = MainBottom
	})
	local TipImage = util:create_new("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(254, 254, 254);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 5, 0, 3);
		Size = UDim2.new(0, 12, 0, 12);
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
		Position = UDim2.new(0, 21, 0, 0);
		Size = UDim2.new(0, 350, 1, 0);
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
		CornerRadius = UDim.new(0, 4);
		Parent = BottomInside
	})
	local BottomFix = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		Size = UDim2.new(1, 0, 0, 9);
		Parent = BottomInside
	})
	local BottomFix2 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(8, 8, 8);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 9);
		Size = UDim2.new(1, 0, 0, 1);
		Parent = BottomFix
	})
	local BuildLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 5, 0, 0);
		Size = UDim2.new(0, 95, 1, 0);
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
		Position = UDim2.new(1, -305, 0, 0);
		Size = UDim2.new(0, 300, 1, 0);
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
		Position = UDim2.new(0, 0, 0, -1);
		Size = UDim2.new(1, 0, 0, 1);
		Parent = MainBottom
	})
	local TabSlider = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		ClipsDescendants = true;
		Position = UDim2.new(0, 106, 0, 1);
		Size = UDim2.new(1, -212, 1, 0);
		Parent = MainTop
	})
	local TabHolder = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(-1, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		Parent = TabSlider
	})
	local UIListLayout = util:create_new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		SortOrder = Enum.SortOrder.LayoutOrder;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		Padding = UDim.new(0, 5);
		Parent = TabHolder
	})
	local FadeLine = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(189, 172, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(1, -298, 1, 1);
		Size = UDim2.new(0.5, 0, 0, 1);
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
		Position = UDim2.new(0.5, -121, 0.5, -48);
		Size = UDim2.new(0, 242, 0, 96);
		ZIndex = 101;
		Visible = false;
		Parent = MainBackground
	})
	local UICorner = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = ConfirmationFrame
	})
	local CF2 = util:create_new("Frame", {
		Parent = ConfirmationFrame;
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = ConfirmationFrame
	})
	local UICorner_2 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = CF2
	})
	local CF3 = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(11, 11, 11);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = CF2
	})
	local UICorner_3 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = CF3
	})
	local CFTOP = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_4 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = CFTOP
	})
	local CFFIX = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 1, -4);
		Size = UDim2.new(1, 0, 0, 4);
		ZIndex = 101;
		Parent = CFTOP
	})
	local UICorner_5 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 4);
		Parent = CFFIX
	})
	local CFLINE = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(32, 32, 32);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 1, 0);
		Size = UDim2.new(1, 0, 0, 1);
		ZIndex = 101;
		Parent = CFTOP
	})
	local CFLABEL = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 1, 0);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Load config";
		TextColor3 = Color3.fromRGB(189, 172, 255);
		TextSize = 12.000;
		Parent = CFTOP
	})
	local CFTEXTLABEL = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 1, -10);
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
		Position = UDim2.new(0, 34, 1, -33);
		Size = UDim2.new(0, 80, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_7 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 3);
		Parent = CancelButton
	})
	local CancelInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = CancelButton	
	})
	local UICorner_8 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 3);
		Parent = CancelInside
	})
	local UIGradient = util:create_new("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))};
		Rotation = 90;
		Parent = CancelInside
	})
	local CancelLabel = util:create_new("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 80, 0, 20);
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
		Position = UDim2.new(1, -114, 1, -33);
		Size = UDim2.new(0, 80, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_9 = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 3);
		Parent = ConfirmButton
	})
	local ConfirmInside = util:create_new("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = ConfirmButton
	})
	local UICorner_10  = util:create_new("UICorner", {
		CornerRadius = UDim.new(0, 3);
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
		Size = UDim2.new(0, 80, 0, 20);
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
		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}
		CancelLabel.TextColor3 = Color3.fromRGB(221,221,221)
	end)

	local on_leave = util:create_connection(CancelButton.MouseLeave, function()
		if is_holding then return end
		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
		CancelLabel.TextColor3 = Color3.fromRGB(74,74,74)
	end)

	local on_click = util:create_connection(CancelButton.InputBegan, function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			is_holding = true
			CancelLabel.TextColor3 = Color3.fromRGB(189, 172, 255)
			CancelButton.BackgroundColor3 = Color3.fromRGB(189, 172, 255)
		end
	end)

	local on_stopclick = util:create_connection(CancelButton.InputEnded, function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			is_holding = false
			CancelLabel.TextColor3 = util:is_in_frame(CancelButton) and Color3.fromRGB(221,221,221) or Color3.fromRGB(74,74,74)
			UIGradient.Color = util:is_in_frame(CancelButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(35, 35, 35)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(16, 16, 16))}
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
			ConfirmLabel.TextColor3 = Color3.fromRGB(189, 172, 255)
			ConfirmButton.BackgroundColor3 = Color3.fromRGB(189, 172, 255)
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

local function set_dependent(dependency, dependent_on)
	dependency:set_visible(false)
	util:create_connection(dependent_on.on_toggle, function(toggle)
		dependency:set_visible(toggle)
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
	KeybindBackground.Position = UDim2.new(0, 150, 0, 150)
	KeybindBackground.Size = UDim2.new(0, 150, 0, 24); util:set_draggable(KeybindBackground)
	util:create_connection(KeybindBackground:GetPropertyChangedSignal("Position"), function()
		lib.flags["keybind_position"] = {KeybindBackground.Position.X.Offset, KeybindBackground.Position.Y.Offset}
	end)
	
	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = KeybindBackground
	
	KeybindInside.Name = "KeybindInside"
	KeybindInside.Parent = KeybindBackground
	KeybindInside.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	KeybindInside.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindInside.BorderSizePixel = 0
	KeybindInside.Position = UDim2.new(0, 1, 0, 1)
	KeybindInside.Size = UDim2.new(1, -2, 1, -2)
	
	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = KeybindInside
	
	KeybindDeeper.Name = "KeybindDeeper"
	KeybindDeeper.Parent = KeybindInside
	KeybindDeeper.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	KeybindDeeper.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindDeeper.BorderSizePixel = 0
	KeybindDeeper.Position = UDim2.new(0, 1, 0, 1)
	KeybindDeeper.Size = UDim2.new(1, -2, 1, -2)
	
	UICorner_3.CornerRadius = UDim.new(0, 4)
	UICorner_3.Parent = KeybindDeeper
	
	KeybindDepeerer.Name = "KeybindDepeerer"
	KeybindDepeerer.Parent = KeybindDeeper
	KeybindDepeerer.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	KeybindDepeerer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindDepeerer.BorderSizePixel = 0
	KeybindDepeerer.Position = UDim2.new(0, 1, 0, 1)
	KeybindDepeerer.Size = UDim2.new(1, -2, 1, -2)
	
	UICorner_4.CornerRadius = UDim.new(0, 4)
	UICorner_4.Parent = KeybindDepeerer
	
	KeybindLabel.Name = "KeybindLabel"
	KeybindLabel.Parent = KeybindDepeerer
	KeybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindLabel.BackgroundTransparency = 1.000
	KeybindLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindLabel.BorderSizePixel = 0
	KeybindLabel.Size = UDim2.new(1, 0, 1, 0)
	KeybindLabel.Font = Enum.Font.RobotoMono
	KeybindLabel.Text = "Keybinds"
	KeybindLabel.TextColor3 = Color3.fromRGB(189, 172, 255)
	KeybindLabel.TextSize = 12.000
	
	KeybindHolder.Name = "KeybindHolder"
	KeybindHolder.Parent = KeybindBackground
	KeybindHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	KeybindHolder.BackgroundTransparency = 1.000
	KeybindHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindHolder.BorderSizePixel = 0
	KeybindHolder.Position = UDim2.new(0, 2, 1, 2)
	KeybindHolder.Size = UDim2.new(1, -4, 0, 0)
	
	UIListLayout.Parent = KeybindHolder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3)

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
		KeybindText.Size = UDim2.new(1, 0, 0, 8)
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
		KeyText.Position = UDim2.new(1, 0, 0, 0)
		KeyText.Size = UDim2.new(0, 0, 0, 8)
		KeyText.Font = Enum.Font.RobotoMono
		KeyText.Text = "[unbound]"
		KeyText.TextColor3 = Color3.fromRGB(189, 172, 255)
		KeyText.TextSize = 12.000
		KeyText.TextStrokeTransparency = 0.700
		KeyText.TextXAlignment = Enum.TextXAlignment.Right

		local kb = {}
		kb.text = KeybindText
		kb.key_text = KeyText

		local flag = lib.flags[flag]

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

-- ? Cache

local draw_3d = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()

local cache = {
	ping = 0,
	strafe_angle = 0,
	camera_cframe = CFrame.new(),
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
	whitelisted = {}
}

-- ? UI Creation

local window = lib.new(""); window:set_user(game.Players.LocalPlayer.Name)
	local combat = window:new_tab("Combat")
		local general = combat:new_subtab("General")
			local aimbot_section = general:new_section({name = "Aimbot", side = "left", size = 185})
				local aimbot_enabled = aimbot_section:new_element({name = "Enabled", flag = "aimbot", types = {toggle = {}, keybind = {}}}); keybind.new("Silent aim", aimbot_enabled, "aimbot")
				local anti_aim_viewer = aimbot_section:new_element({name = "Anti aim viewer", flag = "anti_aim_viewer", types = {toggle = {}}}); set_dependent(anti_aim_viewer, aimbot_enabled)
				local only_forced = aimbot_section:new_element({name = "Only target forced", flag = "only_forced", types = {toggle = {}}}); set_dependent(only_forced, aimbot_enabled)
				local force_target = aimbot_section:new_element({name = "Force target", flag = "force_target", types = {keybind = {method_lock = true, method = "toggle"}}}); set_dependent(force_target, aimbot_enabled)
				local alwayss = aimbot_section:new_element({name = "Always target", flag = "always", tip = "Locks onto target even if not visible or in field of view", types = {toggle = {}}}); set_dependent(alwayss, aimbot_enabled)
				local unforce_when = aimbot_section:new_element({name = "Unforce target when", flag = "unforce_when", types = {dropdown = {options = {"Knocked", "Dead"}, multi = true}}}); set_dependent(unforce_when, aimbot_enabled)
				local silent_aim = aimbot_section:new_element({name = "Silent aim", flag = "silent_aim", types = {toggle = {}}}); set_dependent(silent_aim, aimbot_enabled)
				local aimbot_fov = aimbot_section:new_element({name = "Field of view", flag = "fov", types = {slider = {min = 1, max = 100}}}); set_dependent(aimbot_fov, aimbot_enabled)
				local max_distance = aimbot_section:new_element({name = "Max distance", flag = "max_distance", types = {slider = {min = 50, max = 350}}}); set_dependent(max_distance, aimbot_enabled)
				local aimbot_checks = aimbot_section:new_element({name = "Checks", flag = "checks", types = {dropdown = {options = {"Visible", "Grabbed", "Knocked", "Friend", "Crew"}, multi = true}}}); set_dependent(aimbot_checks, aimbot_enabled)
				local air_part = aimbot_section:new_element({name = "Air Part", flag = "air_part", types = {dropdown = {options = {"Head", "HumanoidRootPart", "Random", "Closest"}, no_none = true, default = {"Head"}}}}); set_dependent(air_part, aimbot_enabled)
				local aimbot_part = aimbot_section:new_element({name = "Part", flag = "aimbot_part", types = {dropdown = {options = {"Head", "HumanoidRootPart", "Random", "Closest"}, no_none = true, default = {"Head"}}}}); set_dependent(aimbot_part, aimbot_enabled)
		local aimbot_fov_section = general:new_section({name = "Aimbot fov", side = "right", size = 360})
				local show_fov = aimbot_fov_section:new_element({name = "Show fov", flag = "show_fov", types = {toggle = {}, colorpicker = {}}})
				local fov_outline = aimbot_fov_section:new_element({name = "Outline", flag = "fov_outline", types = {toggle = {}}}); set_dependent(fov_outline, show_fov)
				local fov_filled = aimbot_fov_section:new_element({name = "Filled", flag = "fov_filled", types = {toggle = {}}}); set_dependent(fov_filled, show_fov)
	local movement = window:new_tab("Movement")
		local movement_general = movement:new_subtab("General")
			local character_section = movement_general:new_section({name = "Character", side = "left", size = 360})
				local cframe_speed = character_section:new_element({name = "CFrame speed", flag = "speed", types = {toggle = {}, keybind = {}, slider = {min = 1, max = 100, suffix = "%"}}}); keybind.new("CFrame speed", cframe_speed, "speed")
				local cframe_fly = character_section:new_element({name = "CFrame fly", flag = "fly", types = {toggle = {}, keybind = {}, slider = {min = 1, max = 100, suffix = "%"}}}); keybind.new("CFrame fly", cframe_fly, "fly")
				local invisible = character_section:new_element({name = "Invisible", flag = "invisible", types = {toggle = {}, keybind = {}}}); keybind.new("Invisible", invisible, "invisible")
	local visuals = window:new_tab("Visuals")
		local players_section = visuals:new_subtab("Players")
			local enemy_esp = players_section:new_section({name = "Enemy esp", side = "left", size = 360})
				local esp_enabled = enemy_esp:new_element({name = "Enabled", flag = "esp", types = {toggle = {}}})
				local esp_offscreen = enemy_esp:new_element({name = "Offscreen", flag = "offscreen", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0), transparency = 0.8}}})
				local offscreen_distance = enemy_esp:new_element({name = "Distance", flag = "offscreen_distance", types = {slider = {min = 1, max = 1000}}}); set_dependent(offscreen_distance, esp_offscreen)
				local offscreen_size = enemy_esp:new_element({name = "Size", flag = "offscreen_size", types = {slider = {min = 1, max = 100}}}); set_dependent(offscreen_size, esp_offscreen)
				local esp_highlight = enemy_esp:new_element({name = "Highlight", flag = "highlight", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0), transparency = 0.5}}})
				local esp_outline = enemy_esp:new_element({name = "Outline", flag = "outline", types = {colorpicker = {color = Color3.fromRGB(0,0,0)}}}); set_dependent(esp_outline, esp_highlight)
				local esp_health = enemy_esp:new_element({name = "Health", flag = "health", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,255,0)}}})
				local esp_number = enemy_esp:new_element({name = "Number", flag = "number", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(0,255,0)}}}); set_dependent(esp_number, esp_health)
				local esp_name = enemy_esp:new_element({name = "Name", flag = "name", types = {toggle = {}, colorpicker = {}}})
				local esp_box = enemy_esp:new_element({name = "Box", flag = "box", types = {toggle = {}, colorpicker = {}}})
			local self_esp = players_section:new_section({name = "Self esp", side = "right", size = 360})
				local bullet_tracers = self_esp:new_element({name = "Local bullet tracers", flag = "bullet_tracers", types = {toggle = {}, colorpicker = {color = Color3.fromRGB(255,0,0)}}})
				local lifetime = self_esp:new_element({name = "Lifetime", flag = "lifetime", types = {slider = {min = 1, max = 5, suffix = "s"}}}); set_dependent(lifetime, bullet_tracers)
		local other_section = visuals:new_subtab("Other")
			local other_hud = other_section:new_section({name = "Hud", side = "Right", size = 360})
				local keybind_list = other_hud:new_element({name = "Keybinds list", flag = "keybind_list", types = {toggle = {}}}); util:create_connection(keybind_list.on_toggle, function(t)
					keybind:set_list_visible(t)
				end)
			local other_game = other_section:new_section({name = "Game", side = "right", size = 360})
				local no_recoil = other_game:new_element({name = "No recoil", flag = "no_recoil", types = {toggle = {}}})
			local visuals_world = other_section:new_section({name = "World", side = "left", size = 360})
				local fog_changer = visuals_world:new_element({name = "Fog changer", flag = "fog_changer", types = {toggle = {}, colorpicker = {color = lighting.FogColor}}}); util:create_connection(fog_changer.on_toggle, function(t)
					if t then
						lighting.FogColor = lib.flags["fog_changer"]["color"]
						lighting.FogStart = lib.flags["fog_start"]["value"]
						lighting.FogEnd = lib.flags["fog_end"]["value"]
					else
						lighting.FogColor = cache.fog_color
						lighting.FogStart = cache.fog_start
						lighting.FogEnd = cache.fog_end
					end
				end); util:create_connection(fog_changer.on_color_change, function(color)
					if lib.flags["fog_changer"]["toggle"] then
						lighting.FogColor = color
					end
				end)
				local fog_start = visuals_world:new_element({name = "Fog start", flag = "fog_start", types = {slider = {min = 1, max = 5000, default = lighting.FogStart}}}); set_dependent(fog_start, fog_changer)
				util:create_connection(fog_start.on_value_change, function(v)
					if lib.flags["fog_changer"]["toggle"] then
						lighting.FogStart = v
					end
				end)
				local fog_end = visuals_world:new_element({name = "Fog end", flag = "fog_end", types = {slider = {min = 1, max = 5000, default = lighting.FogEnd}}}); set_dependent(fog_end, fog_changer)
				util:create_connection(fog_end.on_value_change, function(v)
					if lib.flags["fog_changer"]["toggle"] then
						lighting.FogEnd = v
					end
				end)
				local exposure_changer = visuals_world:new_element({name = "Exposure changer", flag = "exposure", types = {toggle = {}}}); util:create_connection(exposure_changer.on_toggle, function(t)
					if t then
						lighting.ExposureCompensation = lib.flags["compensation"]["value"]
					else
						lighting.ExposureCompensation = cache.compensation
					end
				end)
				local compensation = visuals_world:new_element({name = "Compensation", flag = "compensation", types = {slider = {min = 0, max = 3, default = cache.compensation}}}); util:create_connection(compensation.on_value_change, function(v)
					if lib.flags["exposure"]["toggle"] then
						lighting.ExposureCompensation = v
					end
				end)
				local no_shadows = visuals_world:new_element({name = "No shadows", flag = "no_shadows", types = {toggle = {}}}); util:create_connection(no_shadows.on_toggle, function(t)
					lighting.GlobalShadows = not t
				end)
				local world_time = visuals_world:new_element({name = "World time", flag = "world_time", types = {toggle = {}, slider = {min = 1, max = 24, default = lighting.ClockTime}}}); util:create_connection(world_time.on_toggle, function(t)
					if t then
						lighting.ClockTime = lib.flags["world_time"]["value"]
					else
						lighting.ClockTime = cache.world_time
					end
				end); util:create_connection(world_time.on_value_change, function(v)
					if lib.flags["world_time"]["toggle"] then
						lighting.ClockTime = v
					end
				end)
				local world_hue = visuals_world:new_element({name = "World hue", flag = "world_hue", types = {toggle = {}, colorpicker = {color = lighting.Ambient}}}); util:create_connection(world_hue.on_toggle, function(t)
					if t then
						lighting.Ambient = lib.flags["world_hue"]["color"]
					else
						lighting.Ambient = cache.world_hue
					end
				end); util:create_connection(world_hue.on_color_change, function(color)
					if lib.flags["world_hue"]["toggle"] then
						lighting.Ambient = color
					end
				end)
	local misc = window:new_tab("Misc")
		local main = misc:new_subtab("General")
			local configurations = main:new_section({name = "Configurations", side = "left", size = 360})
				local config_name = configurations:new_element({name = "Config name", flag = "config_name", types = {textbox = {}, no_load = true}})
				local save_config = configurations:new_element({name = "Update config", flag = "save_config", types = {button = {}}})
				local create_config = configurations:new_element({name = "Create config", flag = "create_config", types = {button = {}}})
				local config_list = configurations:new_element({name = "", flag = "config_list", types = {multibox = {maxsize = 5}}})
				local load_config = configurations:new_element({name = "Load config", flag = "load_config", types = {button = {}}})
				local refresh_configs = configurations:new_element({name = "Refresh configs", flag = "refresh_configs", types = {button = {}}})
			local ui_settings = main:new_section({name = "UI Settings", side = "right", size = 360})
				local ui_keybind = ui_settings:new_element({name = "UI hotkey", flag = "ui_hotkey", types = {keybind = {key = "x", method = "toggle", method_lock = true}}}); ui_keybind.on_key_change:Connect(function(key)
					window.hotkey = key
				end)
			local misc_other = main:new_section({name = "Other", side = "right", size = 360})
				local no_void_kill = misc_other:new_element({name = "No void kill", flag = "no_void_kill", types = {toggle = {}}}); no_void_kill.on_toggle:Connect(function(t)
					workspace.FallenPartsDestroyHeight = t and -9e9 or -500
				end)				
				local force_reset = misc_other:new_element({name = "Force reset", flag = "", types = {button = {}}}); force_reset.on_clicked:Connect(function()
					if lplr.Character then
						local hum = lplr.Character:FindFirstChildOfClass("Humanoid")
						if hum then
							hum.Health = 0
						end 
					end
				end)
		local misc_players = misc:new_subtab("Players")
			local player_options = misc_players:new_section({name = "Options", side = "left", size = 360})
				local selected_player = player_options:new_element({name = "Player list", flag = "selected_player", types = {multibox = {maxsize = 5}}})
				local selected_plr = nil
				local teleport = player_options:new_element({name = "Teleport to", flag = "teleport", types = {button = {}}}); util:create_connection(teleport.on_clicked, function()
					if lplr.Character then
						local hrp = lplr.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							local plr = selected_plr ~= nil and players:FindFirstChild(selected_plr) or nil
							if plr then
								local character = plr.Character
								if character then
									local upper_torso = character:FindFirstChild("HumanoidRootPart")
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
				local is_whitelisted; is_whitelisted = player_options:new_element({name = "Is whitelisted", flag = "is_whitelisted",  no_load = true, types = {toggle = {}}}); util:create_connection(is_whitelisted.on_toggle, function(t)
					if selected_plr then
						local find = util:find(cache.whitelisted, selected_plr)
						if find then
							table.remove(cache.whitelisted, find)
						else
							table.insert(cache.whitelisted, selected_plr)
						end
					end
				end)
				util:create_connection(selected_player.on_option_change, function(option)
					selected_plr = option
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

util:create_connection(config_list.on_option_change, function(option)
	selected_config = option
end)

util:create_connection(create_config.on_clicked, function()
	local text = lib.flags["config_name"]["text"] 
	if text ~= "" and not table.find(current_configs, text) then
		table.insert(current_configs, text)
		lib:save_config(text)
		config_list:add_option(text)
	end
end)

util:create_connection(save_config.on_clicked, function()
	if selected_config then
		lib:save_config(selected_config)
	end
end)

util:create_connection(load_config.on_clicked, function()
	if selected_config then
		lib:load_config(selected_config)
		if lib.flags["keybind_position"] then
			KeybindBackground.Position = UDim2.new(0, lib.flags["keybind_position"][1], 0, lib.flags["keybind_position"][2])
		end
	end
end)

util:create_connection(refresh_configs.on_clicked, refresh_all_configs)

-- ? Drawing Setup

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

local draw_3d = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()

-- ? Aimbot

local aimbot = {
	active_target = nil,
	aim_position = nil,
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
	})
}

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
        health_outline = draw:new("Line", {
            Thickness = 4,
            ZIndex = 1,
            Color = Color3.fromRGB(0,0,0)
        }),
        health = draw:new("Line", {
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

-- ? Player Class

local player = {}
player.__index = player

function player.new(instance)
	local player_class = setmetatable({
		connections = {},
		player = instance,
		velocity = Vector3.new(),
		is_loaded_cache = false,
		last_position = nil
	}, player)
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

-- ? Game Connections

local on_player_added = util:create_connection(players.PlayerAdded, function(instance)
	all_players[instance.Name] = player.new(instance)
	selected_player:add_option(instance.Name)
	esp:setup(instance)
end)

local on_player_removing = util:create_connection(players.PlayerRemoving, function(instance)
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
end)

-- ? Optimization Functions

local wtvp_orig = camera.WorldToViewportPoint

local function wtvp(position)
    local coords, visible = wtvp_orig(camera, position)
    return Vector2.new(coords.X, coords.Y), visible
end

local function is_visible(start, result, part)
    return #camera:GetPartsObscuringTarget({start, result}, {lplr.Character, part, part.Parent, workspace.Ignored, workspace.CurrentCamera}) == 0
end

-- ? Hack Functions

local parts_to_check = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm"}

local function get_closest_part(character) 
    local closest = math.huge
    local target = character.HumanoidRootPart

    for i = 1, #parts_to_check do
        local part_name = parts_to_check[i]
        local part = character:FindFirstChild(part_name)
        if not part then continue end
        local hv, visible = wtvp(part.Position)
        if visible then
            local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(hv.X, hv.Y)).magnitude
            if distance < closest then
                closest = distance
                target = part
            end
        end
    end

    return target
end

local function do_aimbot_checks(character)
	local checks = lib.flags["checks"]["selected"]
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		if humanoid.Health == 0 then return false end
	else
		return false
	end
	return true
end

local function get_closest(ignore)
    local flags = lib.flags
	local closest, target = math.huge, nil
    local players = players:GetPlayers()

	local forced_target = aimbot.forced_target

	if forced_target then
		local unforce_when = flags["unforce_when"]["selected"]
		local character = forced_target.Character

		if util:find(unforce_when, "Dead") and (character == nil) then
			aimbot.forced_target = nil
		end

		if flags["always"]["toggle"] then
			return forced_target.Character
		end
	elseif flags["only_forced"]["toggle"] and not ignore then
		return nil
	end

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
						local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(hv.X, hv.Y)).magnitude
						local threshold = (flags["fov"]["value"]*10)
						if distance <= threshold then
							if (hrp.Position-lplr.Character.HumanoidRootPart.Position).magnitude > flags["max_distance"]["value"] then continue end
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
end

local function get_ping()
    return tonumber(string.split(stats.Network.ServerStatsItem["Data Ping"]:GetValueString(),'(')[1])
end

local function get_aimbot_location(character)
	local flags = lib.flags
	local part = character.Humanoid.FloorMaterial == Enum.Material.Air and flags["air_part"]["selected"][1] or flags["aimbot_part"]["selected"][1]
	if part == "Random" then
		part = math.random(1,2) == 2 and "Head" or "HumanoidRootPart"
	end
	if part == "Closest" then
		part = tostring(get_closest_part(character))
	end
	local part = character:FindFirstChild(part)
	aimbot.aim_part = part
	return part.CFrame
end

function tween_drawing(Render, RenderInfo, RenderTo)
    local Start = {}
    local CurrentTime = 0
    local Connection
    for Index, Value in pairs(RenderTo) do
        Start[Index] = Render[Index]
        RenderTo[Index] = (Value - Start[Index])
    end
    Connection = rs.Heartbeat:Connect(function(Delta)
        if CurrentTime < RenderInfo.Time then
            CurrentTime = CurrentTime + Delta
            local TweenedValue = ts:GetValue((CurrentTime / RenderInfo.Time), RenderInfo.EasingStyle, RenderInfo.EasingDirection)
            for Index, Value in pairs(RenderTo) do
                if typeof(Value) == "number" then
                    Render[Index] = (Value * TweenedValue) + Start[Index]
                elseif typeof(Value) == "Vector2" then
                    Render[Index] = Vector2.new((Value.X * TweenedValue) + Start[Index].X, (Value.Y * TweenedValue) + Start[Index].Y)
                elseif typeof(Value) == "function" then
                    Render[Index] = Value(TweenedValue)
                end
            end
        else
            Connection:Disconnect()
        end
    end)
end

local function create_beam(cf, color, transparency, lifetime)
    local beam = Instance.new("Beam")
    beam.Texture = "http://www.roblox.com/asset/?id=446111271"
    beam.TextureMode = Enum.TextureMode.Wrap
    beam.TextureSpeed = 8
    beam.LightEmission = 1
    beam.LightInfluence = 1
    beam.TextureLength = 12
    beam.FaceCamera = true
    beam.ZOffset = -1
	beam.Transparency = NumberSequence.new(transparency)
    beam.Color = ColorSequence.new(color, Color3.new(0, 0, 0))
	local from = Instance.new("Attachment")
	from.Parent = workspace.Terrain
	from.CFrame = lplr.Character.RightHand.CFrame
	local to = Instance.new("Attachment")
	to.Parent = workspace.Terrain
	to.CFrame = cf
    beam.Attachment0 = from
    beam.Attachment1 = to
    beam.Parent = workspace.Terrain
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
	end)
end

local on_input = util:create_connection(uis.InputBegan, function(input, gpe)
    if gpe then return end
    if input.KeyCode.Name:lower() == lib.flags["force_target"]["bind"]["key"] then
        local closest = get_closest(true)
        aimbot.forced_target = (closest and players:FindFirstChild(tostring(closest)) ~= aimbot.forced_target) and players:FindFirstChild(tostring(closest)) or nil
    end
end)

-- ? RunService Connections

local on_heartbeat = util:create_connection(rs.Heartbeat, function(dt)
	local character = lplr.Character
	local flags = lib.flags

	cache.ping = get_ping()
	
	local closest = nil

	local circle_visible = false
	local box_visible = false
	local old_closest = aimbot.active_target

	local viewed_player = cache.viewed_player

	if viewed_player then
		local character = viewed_player.Character
		if character then
			camera.CameraSubject = character
		end
	end

	for _, player in pairs(all_players) do
		local hrp, humanoid = player:is_character_loaded()
		player.is_loaded_cache = hrp and hrp or false
	end

	if character then
		local hrp = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if hrp and humanoid then
			local target = aimbot.forced_target 
			if flags["aimbot"]["toggle"] and aimbot_enabled:is_active() then
				closest = get_closest() or nil
				aimbot.active_target = closest
			end
			aimbot.aim_position = aimbot.active_target and get_aimbot_location(aimbot.active_target) or nil
			if flags["speed"]["toggle"] and cframe_speed:is_active() then
				hrp.CFrame = hrp.CFrame + character.Humanoid.MoveDirection * (lib.flags["speed"]["value"]/55)
			end
			if flags["fly"]["toggle"] and cframe_fly:is_active() then
                local vel = hrp.Velocity
                local final_add = character.Humanoid.MoveDirection * (lib.flags["fly"]["value"]/55)
                if uis:IsKeyDown(Enum.KeyCode.Space) then final_add+=Vector3.new(0,1.5,0) end
                if uis:IsKeyDown(Enum.KeyCode.C) then final_add-=Vector3.new(0,1.5,0) end
                hrp.CFrame = hrp.CFrame + final_add
                hrp.Velocity = Vector3.new(vel.X, 2, vel.Z)
            end
		end
	end; aimbot.active_target = closest
end)

local on_render = util:create_connection(rs.RenderStepped, function()
	local flags = lib.flags
	local fov = aimbot.fov_drawing
	local outline = aimbot.fov_outline_drawing
	local show_fov = flags["show_fov"]
	fov.Visible = show_fov["toggle"]
	outline.Visible = flags["fov_outline"]["toggle"] and fov.Visible or false

	if fov.Visible then
		fov.Filled = flags["fov_filled"]["toggle"]
        fov.Color = show_fov["color"]
        fov.Transparency = -show_fov["transparency"]+1
        fov.Position = Vector2.new(mouse.X, mouse.Y + 38)
        fov.Radius = flags["fov"]["value"]*10
		outline.Position = fov.Position
		outline.Radius = fov.Radius
	end

	local opps = cache.opps

	for i = 1, #esp.cache do
		local cache = esp.cache[i]
		local instance, drawings, highlight = cache[1], cache[2], cache[3]

		for _, drawing in pairs(drawings) do
			drawing.Visible = false
		end

		highlight.Enabled = false

		if not flags["esp"]["toggle"] then continue end
		local team = lplr.Team
		if instance.Team == team and team ~= nil then continue end

		local player = all_players[instance.Name]

		local hrp = player.is_loaded_cache
		local health = instance:FindFirstChild("health")
		local health_val = health.Value

		if hrp and health and health_val > 0 then
			local pos, visible = wtvp(hrp.Position)

			if visible then		
				local size = (wtvp(hrp.Position - Vector3.new(0, 3.3, 0)).Y - wtvp(hrp.Position + Vector3.new(0, 2.9, 0)).Y) / 2
				local box_size = Vector2.new(floor(size * 1.4), floor(size * 1.9))
				local box_pos = Vector2.new(floor(pos.X - size * 1.4 / 2), floor(pos.Y - size * 1.6 / 2))

				local hflag = flags["highlight"]
				local character = instance.Character

				if hflag["toggle"] then
					local oflag = flags["outline"]

					highlight.FillColor = hflag["color"]
					highlight.FillTransparency = hflag["transparency"]
					highlight.OutlineColor = oflag["color"]
					highlight.OutlineTransparency = oflag["transparency"]
					highlight.Adornee = character
					highlight.Enabled = true
				end

				local nflag = flags["name"]

				if nflag["toggle"] then
					local name = drawings.name

					name.Position = Vector2.new(box_size.X / 2 + box_pos.X, box_pos.Y - name.TextBounds.Y - 2)
					name.Color = nflag["color"]
					name.Transparency = -nflag["transparency"]+1
					name.Visible = true
				end

				local bflag = flags["box"]

				if bflag["toggle"] then
					local box = drawings.box
					local outline = drawings.box_outline
					
					box.Size = box_size
					box.Position = box_pos
					box.Color = bflag["color"]
					box.Transparency = -bflag["transparency"]+1
					outline.Transparency = -bflag["transparency"]+1
					outline.Size = box_size
					outline.Position = box_pos
					box.Visible = true
					outline.Visible = true
				end

                local hflag = flags["health"]

                if hflag["toggle"] then
                    local health = drawings.health
                    local outline = drawings.health_outline
                    local health_text = drawings.health_text

                    health.From = Vector2.new((box_pos.X - 5), box_pos.Y + box_size.Y)
                    health.To = Vector2.new(health.From.X, health.From.Y - (health_val / 100) * box_size.Y)
                    health.Color = hflag["color"]
                    health.Transparency = -hflag["transparency"]+1
                    outline.From = Vector2.new(health.From.X, box_pos.Y + box_size.Y + 1)
                    outline.To = Vector2.new(health.From.X, health.From.Y - box_size.Y - 1)
                    outline.Transparency = -hflag["transparency"]+1
                    outline.Visible = true
                    health.Visible = true

                    if flags["number"]["toggle"] and health_val < 100 then
                        health_text.Text = tostring(util:round(health_val))
                    	local text_bounds = health_text.TextBounds
                        health_text.Position = health.To - Vector2.new(text_bounds.X/2 + 2, 6)
                        health_text.Visible = true
                    end
                end
			else
				local offscreen = flags["offscreen"]
				if offscreen["toggle"] then
					local triangle = drawings.triangle

					local screen_size = camera.ViewportSize
					local camera_cframe = camera.CFrame
					camera_cframe = CFrame.lookAt(camera_cframe.p, camera_cframe.p + camera_cframe.LookVector * Vector3.new(1, 0, 1))
	
					local projected = camera_cframe:PointToObjectSpace(hrp.Position)
					local angle = atan2(projected.z, projected.x)
	
					local cx, sy = cos(angle), sin(angle)
					local cx1, sy1 = cos(angle + pi/2), sin(angle + pi/2)
					local cx2, sy2 = cos(angle + pi/2*3), sin(angle + pi/2*3)
	
					local big, small = max(screen_size.x, screen_size.y), min(screen_size.x, screen_size.y)
	
					local arrow_origin = screen_size/2 + Vector2.new(cx * big * 75/200, sy * small * 75/200) * flags["offscreen_distance"]["value"]/1000

					local arrow_size = flags["offscreen_size"]["value"]/100
	
					triangle.PointA = arrow_origin + Vector2.new(30 * cx, 30 * sy) * arrow_size
					triangle.PointB = arrow_origin + Vector2.new(15 * cx1, 15 * sy1) * arrow_size
					triangle.PointC = arrow_origin + Vector2.new(15 * cx2, 15 * sy2) * arrow_size
					
					triangle.Color = offscreen["color"]
					triangle.Transparency = -offscreen["transparency"]+1
					triangle.Visible = true
				end
			end
		elseif hrp then
			local pos, visible = wtvp(hrp.Position)

			if visible and drawings.name.Transparency ~= 0 then		
				local size = (wtvp(hrp.Position - Vector3.new(0, 3.3, 0)).Y - wtvp(hrp.Position + Vector3.new(0, 2.9, 0)).Y) / 2
				local box_size = Vector2.new(math.floor(size * 1.4), math.floor(size * 1.9))
				local box_pos = Vector2.new(math.floor(pos.X - size * 1.4 / 2), math.floor(pos.Y - size * 1.6 / 2))

				local nflag = flags["name"]
	
				if nflag["toggle"] then
					local name = drawings.name

					if name.Transparency == -nflag["transparency"]+1 then
						name.Transparency-=0.01
						tween_drawing(name, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 0})
					end
	
					name.Position = Vector2.new(box_size.X / 2 + box_pos.X, box_pos.Y - name.TextBounds.Y - 2)
					name.Color = nflag["color"]
					name.Visible = true
				end
	
				local bflag = flags["box"]
	
				if bflag["toggle"] then
					local box = drawings.box
					local outline = drawings.box_outline
					if box.Transparency == -bflag["transparency"]+1 then
						box.Transparency-=0.01
						outline.Transparency-=0.01
						tween_drawing(box, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 0})
						tween_drawing(outline, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 0})
					end
				
					box.Size = box_size
					box.Position = box_pos
					box.Color = bflag["color"]
					outline.Size = box_size
					outline.Position = box_pos
					box.Visible = true
					outline.Visible = true
				end

				local hflag = flags["health"]

                if hflag["toggle"] then
                    if health then
						local hum_health = tonumber(health.Value)
                        local health = drawings.health
                        local outline = drawings.health_outline
                        local health_text = drawings.health_text

                        health.From = Vector2.new((box_pos.X - 5), box_pos.Y + box_size.Y)
                        health.To = Vector2.new(health.From.X, health.From.Y - (hum_health / 100) * box_size.Y)
                        health.Color = hflag["color"]
                        health.Transparency = -hflag["transparency"]+1
                        outline.From = Vector2.new(health.From.X, box_pos.Y + box_size.Y + 1)
                        outline.To = Vector2.new(health.From.X, health.From.Y - box_size.Y - 1)
                        outline.Transparency = -hflag["transparency"]+1
                        outline.Visible = true
                        health.Visible = true

						if health.Transparency == -bflag["transparency"]+1 then
							health.Transparency-=0.01
							outline.Transparency-=0.01
							tween_drawing(health, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 0})
							tween_drawing(outline, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 0})
						end
					

                        if flags["number"]["toggle"] and hum_health < 100 then
                            health_text.Text = tostring(util:round(hum_health))
                            local text_bounds = health_text.TextBounds
                            health_text.Position = health.To - Vector2.new(text_bounds.X/2 + 2, 6)
                            health_text.Visible = true
                        end
                    end                        
                end
			end
		end
	end
end)

-- ? Metamethod Hooks

local old_namecall = nil; old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
	local args = {...}
	local method = getnamecallmethod()
	if not checkcaller() then
		if method == "FireServer" then
			local flags = lib.flags
			if tostring(self) == "Replicator" and args[1] == "Neck" and flags["invisible"] and invisible:is_active() then
				args[2]["C1"] = CFrame.new(math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1), math.random(1))  
				return old_namecall(self, unpack(args))
			elseif tostring(self) == "bulletreplicator" and args[2] == "bulleth" then
				if flags["bullet_tracers"]["toggle"] then
					local flag = flags["bullet_tracers"]
					create_beam(aimbot.aim_position or args[3], flag["color"], flag["transparency"], flags["lifetime"]["value"])
				end
				if flags["silent_aim"]["toggle"] and aimbot_enabled:is_active() then
					args[3] = aimbot.aim_position
					return old_namecall(self, unpack(args))
				end
			end
		end
	end
	return old_namecall(self, ...)
end)

local new_index = nil; new_index = hookmetamethod(game, "__newindex", function(self, index, value)
	local flags = lib.flags
	if self == game.Lighting then
		if not checkcaller() then
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
			end
		end
	end
	return new_index(self, index, value)
end)

-- ? Main Init

for _, instance in pairs(players:GetPlayers()) do
	if instance == lplr then continue end
	esp:setup(instance)
	all_players[instance.Name] = player.new(instance)
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

window:open()