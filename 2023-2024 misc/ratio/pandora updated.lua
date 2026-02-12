setfpscap(1000)

-- * Services

local core_gui = game:GetService("CoreGui")
local players = game:GetService("Players")
local texts = game:GetService("TextService")
local lplr = players.LocalPlayer
local mouse = lplr:GetMouse()
local http = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local hs = game:GetService("HttpService")
local stats = game:GetService("Stats")
local camera = workspace.CurrentCamera

-- * Optimization

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
local gsub = string.gsub
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
local viewport_size = camera.ViewportSize
local mouse_pos = uis:GetMouseLocation()
local twinfo = TweenInfo.new
local colorfromrgb = Color3.fromRGB

-- * External Libraries

local signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua"))()
local draw_3d = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()

-- * Luraph Macros

LPH_JIT = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end

-- * Global Variable Updaters

camera:GetPropertyChangedSignal("ViewportSize"):Connect(LPH_JIT(function()
	viewport_size = camera.ViewportSize
end))

-- * UI Library

local lib = {
	config_location = "juju",
	accent_color = colorfromrgb(189, 172, 255),
	on_config_load = signal.new("on_config_load"),
    on_accent_change = signal.new("on_accent_change"),
	flags = {},
	copied_color = colorfromrgb(255,255,255)
}

function lib:get_config_list()
    local location = lib.config_location.."/configs/"
    local cfgs = listfiles(location)
    local returnTable = {}
    for _, file in pairs(cfgs) do
        local str = tostring(file)
        if string.sub(str, #str-3, #str) == ".cfg" then
            table.insert(returnTable, string.sub(str, #location+1, #str-4))
        end
    end
    return returnTable
end

function lib:get_script_list()
    local location = lib.config_location.."/scripts/"
    local cfgs = listfiles(location)
    local returnTable = {}
    for _, file in pairs(cfgs) do
        local str = tostring(file)
        if string.sub(str, #str-3, #str) == ".lua" then
            table.insert(returnTable, string.sub(str, #location+2, #str-4))
        end
    end
    return returnTable
end

-- * Utility Functions

local util = {
	connections = {}
}

do
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local new_drawing = Drawing.new

    function util:to_hex(color)
        return string.format("#%02X%02X%02X", color.R * 0xFF,
                color.G * 0xFF, color.B * 0xFF)
    end

    function util:new_drawing(class, properties)
		local surge = new_drawing(class)
		surge.Visible = false
		for property, value in pairs(properties) do
			surge[property] = value
		end
		return surge
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

	util.has_property = LPH_NO_VIRTUALIZE(function(object, propertyName)
		local success, _ = pcall(function() 
			object[propertyName] = object[propertyName]
		end)
		return success
	end)

    util.new_object = LPH_NO_VIRTUALIZE(function(classname, properties, custom)
        local object = Instance.new(classname)

        for prop, val in pairs(properties) do
            local prop, val = prop, val

            object[prop] = val
        end

        object.Name = hs:GenerateGUID(false)

        return object
    end)

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

    global_sg = util.new_object("ScreenGui", {
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        Parent = gethui and gethui() or core_gui
    })
end

-- * Create Missing Folders

if not isfolder(lib.config_location) then
	makefolder(lib.config_location)
end

if not isfolder(lib.config_location.."/configs") then
	makefolder(lib.config_location.."/configs")
end

if not isfolder(lib.config_location.."/scripts") then
	makefolder(lib.config_location.."/scripts")
end

-- * Main Library

do

local window = {}; window.__index = window
local tab = {}; tab.__index = tab
local subtab = {}; subtab.__index = subtab
local section = {}; section.__index = section
local element = {}; element.__index = element

function window:set_title(text)
	self.name_label.Text = text
    self.name_label.TextColor3 = lib.accent_color
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

function window:set_accent_color(color)
    lib.on_accent_change:Fire(color)
end

do
	local has_property = util.has_property

	function window:open()
		self.screen_gui.Enabled = true
		self.opened = true
		local descendants = self.screen_gui:GetDescendants()
		util:tween(self.line, twinfo(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(1, -298, 1, 1), Size = udim2new(0.5, 0, 0, 1)})
		util:tween(self.tab_holder, twinfo(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(0,0,0,0)})
	end

	function window:close()
		local descendants = self.screen_gui:GetDescendants()
		util:tween(self.line, twinfo(0.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(1, 0, 1, 1), Size = udim2new(0, 0, 0, 1)})
		util:tween(self.tab_holder, twinfo(0.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2new(-1,0,0,0)})
		self.screen_gui.Enabled = false
		self.opened = false
	end
end

function window:new_tab(text)
	local TabButton = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = udim2new(0, 106, 0, 1);
		Size = udim2new(0, util:get_text_size(text) + 20, 0, 19);
		Parent = self.tab_holder
	}); TabName = "t-"..text
	local TabLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(11, 11, 11);
		BorderColor3 = colorfromrgb(32, 32, 32);
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
	local UICorner = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 6);
		Parent = TabButton
	})
	local ButtonFix = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(11, 11, 11);
		BorderColor3 = colorfromrgb(32, 32, 32);
		Position = udim2new(0, 1, 0, 9);
		Size = udim2new(1, -2, 0, 10);
		Visible = false;
		Parent = TabButton
	})
	local UIGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, lib.accent_color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
		Rotation = 90;
		Offset = vect2(0,-0.19);
		Parent = TabButton
	})
	local UICorner_2 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 6);
		Parent = TabLabel
	})
	local ButtonFix2 = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(11, 11, 11);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 1, 0);
		Size = udim2new(1, -2, 0, 1);
		Visible = false;
		Parent = TabButton
	})
	local TabFrame = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 12, 0, 34);
		Size = udim2new(1, -24, 0, 360);
		Parent = self.main;
		Visible = false
	})
	local SubtabHolder = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(32, 32, 32);
		Size = udim2new(0, 116, 0, 360);
		Parent = TabFrame
	})
	local SubtabInside = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 6, 0, 6);
		Size = udim2new(1, -12, 1, -12);
		Parent = SubtabHolder
	})
	local UIListLayout = util.new_object("UIListLayout", {
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

    local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
        if self.active_tab == text then
            TabLabel.TextColor3 = color
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
		end
    end)

	local on_click = util:create_connection(TabButton.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.active_tab ~= text then
			TabLabel.TextColor3 = colorfromrgb(74,74,74)
		end
	end)

	local on_click = util:create_connection(TabButton.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:set_tab(text)
		end
	end)

	local on_hover = util:create_connection(TabButton.MouseEnter, function(input)
		if self.active_tab ~= text then
			TabLabel.TextColor3 = colorfromrgb(126,126,126)
		end
	end)

	local on_hover = util:create_connection(TabButton.MouseLeave, function(input)
		if self.active_tab ~= text then
			TabLabel.TextColor3 = colorfromrgb(74,74,74)
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
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, lib.accent_color), ColorSequenceKeypoint.new(0.10, lib.accent_color), ColorSequenceKeypoint.new(0.20, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
	util:tween(gradient, twinfo(0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Offset = vect2(0,0)})
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
	label.TextColor3 = colorfromrgb(74,74,74)
	fix1.Visible = false
	fix2.Visible = false
	frame.Visible = false
	util:tween(gradient, twinfo(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Offset = vect2(0,-0.19)})
end

function tab:set_subtab(name)
	self.active_subtab = name
	for _, v in pairs(self.subtabs) do
		if v.name == name then v:set_active() else v:set_not_active() end
	end 
end

function tab:new_subtab(text)
	local SubtabButton = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(254, 254, 254);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 18);
		Parent = self.holder
	})
	local UIGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(17, 17, 17)), ColorSequenceKeypoint.new(1.00, colorfromrgb(9, 9, 9))};
		Parent = SubtabButton
	})
	local ButtonLine = util.new_object("Frame", {
		BackgroundColor3 = lib.accent_color;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 1, 1, 0);
		Parent = SubtabButton
	})
	local ButtonLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
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
	local Left = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(32, 32, 32);
		BorderSizePixel = 0;
		Position = udim2new(0, 127, 0, 0);
		Size = udim2new(0, 217, 0, 360);
		Visible = false;
		Parent = self.frame;
	})
	local UIListLayout = util.new_object("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = udimnew(0, 10);
		Parent = Left
	})
	local Right = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(32, 32, 32);
		BorderSizePixel = 0;
		Position = udim2new(1, -217, 0, 0);
		Size = udim2new(0, 217, 0, 360);
		Visible = false;
		Parent = self.frame
	})
	local UIListLayout_4 = util.new_object("UIListLayout", {
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
			ButtonLabel.TextColor3 = colorfromrgb(126,126,126)
		end
	end)

	local on_hover = util:create_connection(SubtabButton.MouseLeave, function(input)
		if self.active_subtab ~= text then
			ButtonLabel.TextColor3 = colorfromrgb(74,74,74)
		end
	end)

    local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
        if self.active_subtab == text then
            ButtonLabel.TextColor3 = color
            ButtonLine.BackgroundColor3 = color
		else
			local h,s,v = color:ToHSV()
			ButtonLine.BackgroundColor3 = Color3.fromHSV(h,s,v*.5)
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
	label.TextColor3 = colorfromrgb(74,74,74)
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

	local SectionFrame = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(32, 32, 32);
		Size = udim2new(0, 217, 0, 38);
		Parent = info.side:lower() == "left" and self.left or self.right
	})
	local SectionTop = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(254, 254, 254);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 21);
		Parent = SectionFrame
	})
	local UIGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
		Rotation = 90;
		Parent = SectionTop
	})
	local SectionLine = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(254, 254, 254);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 1, 0);
		Size = udim2new(1, -2, 0, 1);
		Parent = SectionTop
	})
	local UIGradient_2 = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(0.15, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(0.35, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(0.50, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(0.65, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(0.85, colorfromrgb(32, 32, 32)), ColorSequenceKeypoint.new(1.00, colorfromrgb(32, 32, 32))};
		Parent = SectionLine
	})
	local SectionLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 0);
		Size = udim2new(1, -5, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = name;
		TextColor3 = colorfromrgb(74, 74, 74);
		TextSize = 12.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = SectionTop
	})
	local SectionHolder = util.new_object("ScrollingFrame", {
		Active = false;
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 22);
		Size = udim2new(1, -2, 1, -22);
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
		ScrollBarImageColor3 = colorfromrgb(56,56,56);
		CanvasSize = udim2new(0, 0, 1, -22);
		ScrollBarThickness = 0;
		ScrollingEnabled = false;
		TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
		Parent = SectionFrame
	})
	local SectionList = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 14, 0, 8);
		Size = udim2new(1, -28, 1, -16);
		Parent = SectionHolder
	})
	local UIListLayout = util.new_object("UIListLayout", {
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
		element_holder = {},
		lib = self.lib
	}

	local on_hover = util:create_connection(SectionFrame.MouseEnter, function() 
		if SectionHolder.ScrollingEnabled == true then
			util:tween(SectionHolder, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarThickness = 4})
		end
	end)

	local on_leave = util:create_connection(SectionFrame.MouseLeave, function() 
		if SectionHolder.ScrollingEnabled == true then
			util:tween(SectionHolder, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ScrollBarThickness = 0})
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
	for _, element in pairs(self.element_holder) do
		element:remove()
	end
	self.frame:Destroy()
end

function section:new_element(info)
	local name, flag, types, tooltip = info.name, info.flag or "", info.types or {}, info.tip

	local ElementFrame = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 8);
		Parent = self.holder
	})
	local ElementLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 12, 0, 0);
		Size = udim2new(0, util:get_text_size(name) + 4, 0, 7);
		Font = Enum.Font.RobotoMono;
		Text = name;
		TextColor3 = colorfromrgb(74, 74, 74);
		TextSize = 12.000;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = ElementFrame
	})
	local AddonHolder = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -30, 0, 0);
		Size = udim2new(0, 30, 0, 8);
		Parent = ElementFrame
	})
	local UIListLayout = util.new_object("UIListLayout", {
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
			util:tween(image, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0})
			util:tween(tip_label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
			util:tween(label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
			tip_label.Text = info.tip
		end)

		local on_leave = util:create_connection(ElementLabel.MouseLeave, function()
			if lib.busy then return end
			local image, tip_label, label = self.lib.tip, self.lib.tip:GetChildren()[1], self.lib.build_label
			util:tween(image, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
			util:tween(tip_label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
			util:tween(label, twinfo(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
		end)
	end

	lib.flags[flag] = {}

	for element, info in pairs(types) do
		if element == "toggle" then 
			local no_load = info.no_load or false
			local on_toggle = info.on_toggle or function() end
			local default = info.default and info.default or false
			local no_touch = info.no_touch or false

			local ToggleBox = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(32, 32, 32);
				BorderColor3 = colorfromrgb(0, 0, 0);
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(0, 6, 0, 6);
				Parent = ElementFrame
			})
			local ToggleInside = util.new_object("Frame", {
				BackgroundColor3 = lib.accent_color;
				BackgroundTransparency = 1;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Visible = false;
				Size = udim2new(0, 6, 0, 6);
				Parent = ToggleBox
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(195, 195, 195))};
				Rotation = 90;
				Parent = ToggleInside
			})

			new_element.on_toggle = signal.new("on_toggle")

			local on_hover = util:create_connection(ToggleBox.MouseEnter, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = colorfromrgb(126, 126, 126)
				ToggleInside.BackgroundTransparency = 0.5
				ToggleInside.Visible = true
			end)

			local on_hover = util:create_connection(ElementLabel.MouseEnter, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = colorfromrgb(126, 126, 126)
				ToggleInside.BackgroundTransparency = 0.5
				ToggleInside.Visible = true
			end)

			local on_leave = util:create_connection(ToggleBox.MouseLeave, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = colorfromrgb(74, 74, 74)
				ToggleInside.BackgroundTransparency = 1
				ToggleInside.Visible = false
			end)

			local on_leave = util:create_connection(ElementLabel.MouseLeave, function()
				if lib.busy then return end
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = colorfromrgb(74, 74, 74)
				ToggleInside.BackgroundTransparency = 1
				ToggleInside.Visible = false
			end)

			function new_element:set_toggle(toggle, callback)
				local is_in_toggle = util:is_in_frame(ElementLabel) or util:is_in_frame(ToggleBox)
				ElementLabel.TextColor3 = not toggle and (not is_in_toggle and colorfromrgb(74, 74, 74) or colorfromrgb(126, 126, 126)) or colorfromrgb(221,221,221)
				ToggleInside.BackgroundTransparency = not toggle and (not is_in_toggle and 1 or 0.5) or 0
				ToggleInside.Visible = not toggle and (not is_in_toggle and false or true) or true

				lib.flags[flag]["toggle"] = toggle

				if not callback then
					new_element.on_toggle:Fire(toggle)
				end
			end

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                ToggleInside.BackgroundColor3 = color
            end)

			local on_click = util:create_connection(ToggleBox.InputEnded, function(input)
				if lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not no_touch then
					local toggle = not lib.flags[flag]["toggle"]; lib.flags[flag]["toggle"] = toggle
					new_element:set_toggle(toggle)
				end
			end)

			local on_click = util:create_connection(ElementLabel.InputEnded, function(input)
				if lib.busy then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not no_touch then
					local toggle = not lib.flags[flag]["toggle"]; lib.flags[flag]["toggle"] = toggle
					new_element:set_toggle(toggle)
				end
			end)

			local on_window_close = util:create_connection(self.lib.on_close, function()
				if lib.flags[flag]["toggle"] then return end
				ElementLabel.TextColor3 = colorfromrgb(74, 74, 74)
				ToggleInside.BackgroundTransparency = 1
				ToggleInside.Visible = false
			end)

			lib.flags[flag]["toggle"] = false

			if default and not info.no_load then new_element:set_toggle(default) end

			util:create_connection(lib.on_config_load, function()
				if not info.no_load then
					new_element:set_toggle(lib.flags[flag]["toggle"])
				end
			end)
		elseif element == "keybind" then
			new_element.keybinds+=1

			local AddonImage = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(0, 9, 0, 9);
				Image = "rbxassetid://14138205253";
				ImageColor3 = colorfromrgb(74, 74, 74);
				ZIndex = 100;
				Parent = AddonHolder
			})
			local KeybindOpen = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 0, 0);
				Size = udim2new(0, 163, 0, 19);
				Parent = self.lib.screen_gui;
				ZIndex = 15;
				Visible = false
			})
			local UICorner = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = KeybindOpen
			})
			local OpenInside = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(32, 32, 32);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = KeybindOpen
			})
			local UICorner_2 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = OpenInside
			})
			local OpenLabel = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = OpenInside
			})
			local UICorner_3 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = OpenLabel
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
				Rotation = 90;
				Parent = OpenLabel
			})
			local OpenText = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Font = Enum.Font.RobotoMono;
				Text = "keybind: unbound";
				TextColor3 = colorfromrgb(74, 74, 74);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Right;
				ZIndex = 15;
				RichText = true;
				Parent = OpenLabel
			}); local on_size_change = util:create_connection(OpenText:GetPropertyChangedSignal("Size"), function()
				local size = OpenText.Size.X.Offset
				OpenText.Position = udim2new(1, -size, 0, 0)
			end); OpenText.Size = udim2new(0, util:get_text_size("keybind: unbound"), 1, 0);
			local OpenMethod = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0.065750733, 0, 0.0604938269, 0);
				Size = udim2new(0, 65, 0, 60);
				ZIndex = 16;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = OpenMethod
			})
			local MethodInside = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(16, 16, 16);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 16;
				Parent = OpenMethod
			})
			local UICorner_2 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = MethodInside
			})
			local UIListLayout = util.new_object("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Parent = MethodInside
			})
			local HoldLabel = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(27, 27, 27);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
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
			local ToggleLabel = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(27, 27, 27);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 0, 20);
				Font = Enum.Font.RobotoMono;
				Text = " toggle";
				TextColor3 = colorfromrgb(126, 126, 126);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 16;
				Parent = MethodInside
			})
			local AlwaysLabel = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(27, 27, 27);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 0, 19);
				Font = Enum.Font.RobotoMono;
				Text = " always";
				TextColor3 = colorfromrgb(126, 126, 126);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 16;
				Parent = MethodInside
			})

			local is_open, binding, is_choosing_method = false, false, false
			local addon_cover = self.lib.addon_cover

			local on_enter_alt = util:create_connection(OpenText.MouseEnter, function()
				OpenText.TextColor3 = colorfromrgb(126,126,126)
			end)

			local on_leave_alt = util:create_connection(OpenText.MouseLeave, function()
				if binding then return end
				OpenText.TextColor3 = colorfromrgb(74,74,74)
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
					OpenText.TextColor3 = colorfromrgb(74,74,74)
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
						child.TextColor3 = colorfromrgb(126,126,126)
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

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                local method2 = lib.flags[flag]["bind"]["method"]
                local label = (method2 == "always" and AlwaysLabel) or (method2 == "toggle" and ToggleLabel) or (method2 == "hold" and HoldLabel)
                label.TextColor3 = color
            end)

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

			util:create_connection(self.lib.on_close, function()
				if is_open then
					close_keybind()
					addon_cover.Visible = false
				end
			end)

			local function open_keybind()
				lib.busy = true; is_open = true
				KeybindOpen.Visible = true
				AddonImage.ImageColor3 = colorfromrgb(255,255,255)
				addon_cover.Visible = true
				addon_cover.BackgroundTransparency = 1
				util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

				local absPos = AddonImage.AbsolutePosition
				KeybindOpen.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function close_keybind()
				is_open = false
				KeybindOpen.Visible = false
				OpenText.TextColor3 = colorfromrgb(74,74,74)
				util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
				task.delay(0.3, function()
					if addon_cover.BackgroundTransparency > 0.99 then
						addon_cover.Visible = false
					end
				end)
				AddonImage.ImageColor3 = colorfromrgb(74,74,74)
				if binding then stop_binding() end
				if is_choosing_method then close_method() end
				task.delay(0.03, function()
					lib.busy = false; 
				end)
			end

			local on_hover = util:create_connection(AddonImage.MouseEnter, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = colorfromrgb(126,126,126)
			end)

			local on_leave = util:create_connection(AddonImage.MouseLeave, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = colorfromrgb(74,74,74)
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
					if not lib.busy then AddonImage.ImageColor3 = colorfromrgb(255,255,255) end
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
					set_key(key and key or lower(input.KeyCode.Name))
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
				if lower(input.KeyCode.Name) == key then
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
				if lower(input.KeyCode.Name) == key and method == "hold" then
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

			util:create_connection(lib.on_config_load, function()
				set_key(lib.flags[flag]["bind"]["key"])
				set_method(lib.flags[flag]["bind"]["method"])
			end)
		elseif element == "slider" then
			new_element.total_size+=13
			local SliderBackground = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(32, 32, 32);
				BorderColor3 = colorfromrgb(0, 0, 0);
				Position = udim2new(0, 12, 0, 15);
				Size = udim2new(1, -24, 0, 6);
				Parent = ElementFrame
			})
			local SliderFill = util.new_object("Frame", {
				BackgroundColor3 = lib.accent_color;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, 0);
				Parent = SliderBackground
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(195, 195, 195))};
				Rotation = 90;
				Parent = SliderFill
			})
			local SliderText = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -12, 0, 0);
				Size = udim2new(0, 0, 0, 7);
				Font = Enum.Font.RobotoMono;
				Text = "100%";
				TextColor3 = colorfromrgb(74, 74, 74);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Right;
				Parent = ElementFrame
			})

			local min, max, default, decimal, on_value_change, suffix, prefix = info.min, info.max, info.default, info.decimal or info.decimals, info.on_value_change or function() end, info.suffix or "", info.prefix or ""
			local dragging = false

			new_element.on_value_change = signal.new("on_value_change")

			lib.flags[flag]["value"] = min

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                SliderFill.BackgroundColor3 = color
            end)

			function new_element:set_value(value, do_callback)
				local value = clamp(value, min, max)
				SliderFill.Size = udim2new((value - min)/(max-min), 0, 1, 0)
				SliderText.Text = prefix..value..suffix
				lib.flags[flag]["value"] = value
				if value > min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
					ElementLabel.TextColor3 = colorfromrgb(221,221,221)
				else
					ElementLabel.TextColor3 = util:is_in_frame(SliderBackground) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
				end
				new_element.on_value_change:Fire(value)
			end

			local on_input_began = util:create_connection(SliderBackground.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not lib.busy then
					lib.busy = true
					local distance = clamp((mouse.X - SliderBackground.AbsolutePosition.X)/SliderBackground.AbsoluteSize.X, 0, 1)
					local value = util:round(min + (max - min) * distance, decimal and decimal or 0)
					new_element:set_value(value, true)

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
					new_element:set_value(value, true)
				end
			end)

			local on_enter = util:create_connection(SliderBackground.MouseEnter, function()
				if lib.busy then return end
				if lib.flags[flag]["value"] == min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
					ElementLabel.TextColor3 = colorfromrgb(126,126,126)
				end
			end)

			local on_leave = util:create_connection(SliderBackground.MouseLeave, function()
				if lib.busy then return end
				if lib.flags[flag]["value"] == min and (lib.flags[flag]["toggle"] ~= nil and lib.flags[flag]["toggle"] or true) then
					ElementLabel.TextColor3 = colorfromrgb(74,74,74)
				end
			end)

			new_element:set_value(default and default or min)

			util:create_connection(lib.on_config_load, function()
				new_element:set_value(lib.flags[flag]["value"])
			end)
		elseif element == "dropdown" then
			new_element.total_size+=24

			local DropdownBorder = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 12);
				Size = udim2new(1, -24, 0, 20);
				Parent = ElementFrame
			})
			local DropdownBackground = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = DropdownBorder
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(23, 23, 23)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
				Rotation = 90;
				Parent = DropdownBackground
			})
			local DropdownImage = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -13, 0.5, -4);
				Size = udim2new(0, 8, 0, 8);
				Image = "http://www.roblox.com/asset/?id=14138109916";
				ImageColor3 = colorfromrgb(74, 74, 74);
				Parent = DropdownBackground
			})
			local DropdownText = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 5, 0, 0);
				Size = udim2new(1, -23, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = "-";
				TextColor3 = colorfromrgb(74, 74, 74);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextWrapped = true;
				ClipsDescendants = true;
				Parent = DropdownBackground
			})
			local OpenDropdown = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 440, 0, 54);
				Size = udim2new(0, 163, 0, 60);
				Parent = self.lib.screen_gui
			}); OpenDropdown.Visible = false
			local OpenInside = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(16, 16, 16);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				ClipsDescendants = true;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = OpenDropdown
			})
			local UIListLayout = util.new_object("UIListLayout", {
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

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                local options = lib.flags[flag]["selected"]
                for i,v in pairs(OpenInside:GetChildren()) do
					if v.ClassName == "TextLabel" then
						if util:find(options, v.Name) then 
							v.TextColor3 = color
						end
					end
				end
            end)

			local function set_options(options)
				lib.flags[flag]["selected"] = options
				for i,v in pairs(OpenInside:GetChildren()) do
					if v.ClassName == "TextLabel" then
						if util:find(options, v.Name) then 
							v.TextColor3 = lib.accent_color
							v.BackgroundTransparency = util:is_in_frame(v) and 0 or 1
						else
							v.TextColor3 = util:is_in_frame(v) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
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
				ElementLabel.TextColor3 = colorfromrgb(221,221,221)
				DropdownText.TextColor3 = colorfromrgb(221,221,221)
				DropdownImage.ImageColor3 = colorfromrgb(221,221,221)
				is_open = true; lib.busy = true;
			end

			local function close_dropdown()
				OpenDropdown.Visible = false
				is_open = false; task.delay(0, function()
					lib.busy = false; 
				end)
				ElementLabel.TextColor3 = (#lib.flags[flag]["selected"] == 0 and (util:is_in_frame(DropdownBorder) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)) or colorfromrgb(221,221,221))
				DropdownText.TextColor3 = util:is_in_frame(DropdownBorder) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
				DropdownImage.ImageColor3 = util:is_in_frame(DropdownBorder) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
				Color = util:is_in_frame(DropdownBorder) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(33, 33, 33)), ColorSequenceKeypoint.new(1.00, colorfromrgb(23, 23, 23))} or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(23, 23, 23)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
			end

			local on_close = util:create_connection(self.lib.on_close, function()
				if is_open then
					close_dropdown()
				end
			end)

			for i = 1, #options do
				local option = options[i]
				local DropdownOption = util.new_object("TextLabel", {
					BackgroundColor3 = colorfromrgb(24, 24, 24);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 20);
					Font = Enum.Font.RobotoMono;
					Text = " "..option;
					TextColor3 = colorfromrgb(74, 74, 74);
					TextSize = 12.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = OpenInside
				}); DropdownOption.Name = option

				local on_hover = util:create_connection(DropdownOption.MouseEnter, function()
					if not util:find(lib.flags[flag]["selected"], option) then
						DropdownOption.TextColor3 = colorfromrgb(126,126,126)
					end
					DropdownOption.BackgroundTransparency = 0
				end)

				local on_leave = util:create_connection(DropdownOption.MouseLeave, function()
					if not util:find(lib.flags[flag]["selected"], option) then
						DropdownOption.TextColor3 = colorfromrgb(74,74,74)
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
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(33, 33, 33)), ColorSequenceKeypoint.new(1.00, colorfromrgb(23, 23, 23))};
				DropdownText.TextColor3 = colorfromrgb(126,126,126)
				DropdownImage.ImageColor3 = colorfromrgb(126,126,126)
				if #lib.flags[flag]["selected"] == 0 then
					ElementLabel.TextColor3 = colorfromrgb(126,126,126)
				end
			end)

			local on_enter = util:create_connection(DropdownBorder.MouseLeave, function()
				if is_open or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(23, 23, 23)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
				DropdownText.TextColor3 = colorfromrgb(74,74,74)
				DropdownImage.ImageColor3 = colorfromrgb(74,74,74)
				if #lib.flags[flag]["selected"] == 0 then
					ElementLabel.TextColor3 = colorfromrgb(74,74,74)
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

			util:create_connection(lib.on_config_load, function()
				set_options(lib.flags[flag]["selected"])
			end)	
		elseif element == "button" then
			new_element.total_size+=16

			local confirmation = info.confirmation and info.confirmation or false

			local Button = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 0);
				Size = udim2new(1, -24, 0, 24);
				Parent = ElementFrame
			})
			local UICorner = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 3);
				Parent = Button
			})
			local ButtonInside = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = Button
			})
			local UICorner_2 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 3);
				Parent = ButtonInside
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
				Rotation = 90;
				Parent = ButtonInside
			})
			local ButtonLabel = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = ElementLabel.Text;
				TextColor3 = colorfromrgb(74, 74, 74);
				TextSize = 12.000;
				Parent = ButtonInside
			}); ElementLabel:Destroy()

			local is_holding = false

			new_element.on_clicked = signal.new("on_clicked")

			local on_hover = util:create_connection(Button.MouseEnter, function()
				if is_holding or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}
				ButtonLabel.TextColor3 = colorfromrgb(221,221,221)
			end)

			local on_leave = util:create_connection(Button.MouseLeave, function()
				if is_holding or lib.busy then return end
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
				ButtonLabel.TextColor3 = colorfromrgb(74,74,74)
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
					ButtonLabel.TextColor3 = util:is_in_frame(Button) and colorfromrgb(221,221,221) or colorfromrgb(74,74,74)
					Color = util:is_in_frame(Button) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
					Button.BackgroundColor3 = colorfromrgb(0, 0, 0)
					if confirmation then
						confirmation_cover.Visible = true
						self.lib.cflabel.Text = confirmation.text
						self.lib.cftoplabel.Text = confirmation.top
						util:tween(confirmation_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
						confirmation_frame.Visible = true
						lib.busy = true
						is_in_confirmation = true
					else
						new_element.on_clicked:Fire()
					end
				end
			end)

			local on_close = util:create_connection(self.lib.on_close, function()
				confirmation_cover.BackgroundTransparency = 1
				confirmation_cover.Visible = false
                confirmation_frame.Visible = false
				lib.busy = false
				is_in_confirmation = false
			end)

			local on_confirmed = util:create_connection(self.lib.confirmationsignal, function(t)
				if is_in_confirmation then
					if t then
						new_element.on_clicked:Fire()
					end
					task.delay(0.3, function() 
						if confirmation_cover.BackgroundTransparency > .99 then
							confirmation_cover.Visible = false
						end
					end)
					util:tween(confirmation_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
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
			local MultiboxTextbox = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 0);
				Size = udim2new(1, -24, 0, 19);
				Parent = ElementFrame
			})
			local DropdownBackground = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(24, 24, 24);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = MultiboxTextbox
			})
			local TextBox = util.new_object("TextBox", {
				Parent = DropdownBackground;
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 5, 0, 0);
				Size = udim2new(1, -5, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = "";
				TextColor3 = colorfromrgb(74, 74, 74);
				TextSize = 12.000;
				ClearTextOnFocus = false;
				TextXAlignment = Enum.TextXAlignment.Left
			}); local on_focus = util:create_connection(TextBox.Focused, function()
				if lib.busy then TextBox:ReleaseFocus(); return end
			end)
			local MultiboxOpen = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 19);
				Size = udim2new(1, -24, 0, 2 + info.maxsize*17);
				Parent = ElementFrame
			})
			local MultiboxScroll = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = MultiboxOpen
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 23, 22)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
				Rotation = 90;
				Parent = MultiboxScroll
			})
			local MultiboxInside = util.new_object("ScrollingFrame", {
				Active = true;
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, 0);
				BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				CanvasSize = udim2new(0, 0, 1, 0);
				ScrollBarImageColor3 = colorfromrgb(56,56,56);
				ScrollBarThickness = 4;
				TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
				ScrollingEnabled = false;
				Parent = MultiboxScroll
			}); local on_text_change = util:create_connection(TextBox:GetPropertyChangedSignal("Text"), function()
				local text = lower(TextBox.Text)
				local all_labels = MultiboxInside:GetChildren()
				for i = 1, #all_labels do
					local label = all_labels[i]
					if label.ClassName == "TextLabel" then
						if lower(label.Name):find(text) or text == " " or text == "" then
							label.Visible = true
						else
							label.Visible = false
						end
					end
				end
			end)
			local UIListLayout = util.new_object("UIListLayout", {
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
						label.TextColor3 = util:is_in_frame(label) and colorfromrgb(126,126,126) or colorfromrgb(74,74,74)
					end
				end
				local label = MultiboxInside:FindFirstChild(option)
				label.Line.Visible = true
				label.Line.Fade.Visible = true
				label.TextColor3 = colorfromrgb(221,221,221)
				selected = option
				new_element.on_option_change:Fire(selected)
			end

            local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
                local options = lib.flags[flag]["selected"]
                for i,v in pairs(MultiboxInside:GetChildren()) do
					if v.ClassName == "TextLabel" then
                        v.Line.BackgroundColor3 = color
					end
				end
            end)

			function new_element:add_option(option)
				options+=1
				local MultiboxLabel = util.new_object("TextLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 17);
					ZIndex = 2;
					Font = Enum.Font.RobotoMono;
					Text = " "..option;
					TextColor3 = colorfromrgb(74, 74, 74);
					TextSize = 12.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = MultiboxInside
				}); MultiboxLabel.Name = option
				local MultiLine = util.new_object("Frame", {
					BackgroundColor3 = lib.accent_color;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 1, 1, 0);
					Visible = false;
					ZIndex = 2;
					Parent = MultiboxLabel
				}); MultiLine.Name = "Line"
				local LabelFade = util.new_object("Frame", {
					BackgroundColor3 = colorfromrgb(254, 254, 254);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 40, 1, 0);
					Visible = false;
					Parent = MultiLine
				}); LabelFade.Name = "Fade"
				local UIGradient_2 = util.new_object("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(34, 34, 34)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))};
					Parent = LabelFade
				})

				local on_enter = util:create_connection(MultiboxLabel.MouseEnter, function()
					if selected == option or lib.busy then return end
					MultiboxLabel.TextColor3 = colorfromrgb(126,126,126)
				end)

				local on_leave = util:create_connection(MultiboxLabel.MouseLeave, function()
					if selected == option or lib.busy then return end
					MultiboxLabel.TextColor3 = colorfromrgb(74,74,74)
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
			local AddonImage = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(0, 9, 0, 9);
				Image = "rbxassetid://14138205253";
				ImageColor3 = colorfromrgb(74, 74, 74);
				ZIndex = 14;
				Parent = AddonHolder
			})
			local ColorpickerOpen = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0.329400182, 0, 0.683950603, 0);
				Size = udim2new(0, 163, 0, 181);
				ZIndex = 15;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerOpen
			})
			local ColorpickerBorder = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(32, 32, 32);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = ColorpickerOpen
			})
			local UICorner_2 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerBorder
			})
			local ColorpickerInside = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15;
				Parent = ColorpickerBorder
			})
			local UICorner_3 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerInside
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(0.35, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
				Rotation = 90;
				Parent = ColorpickerInside
			})
			local SaturationImage = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(170, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				Position = udim2new(0, 3, 0, 17);
				Size = udim2new(0, 141, 0, 145);
				ZIndex = 16;
				Image = "rbxassetid://13966897785";
				Parent = ColorpickerInside
			})
			local SaturationMover = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				BackgroundTransparency = 1;
				ZIndex = 17;
				Size = udim2new(0, 4, 0, 4);
				Image = "http://www.roblox.com/asset/?id=14138315296";
				Parent = SaturationImage
			})
			local HueFrame = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				Position = udim2new(1, -11, 0, 17);
				Size = udim2new(0, 8, 0, 145);
				ZIndex = 15;
				Parent = ColorpickerInside
			})
			local UIGradient_2 = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(170, 0, 0)), ColorSequenceKeypoint.new(0.15, colorfromrgb(255, 255, 0)), ColorSequenceKeypoint.new(0.30, colorfromrgb(0, 255, 0)), ColorSequenceKeypoint.new(0.45, colorfromrgb(0, 255, 255)), ColorSequenceKeypoint.new(0.60, colorfromrgb(0, 0, 255)), ColorSequenceKeypoint.new(0.75, colorfromrgb(175, 0, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(170, 0, 0))};
				Rotation = 90;
				Parent = HueFrame
			})
			local HueMover = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, -1, 0, 0);
				Size = udim2new(0, 10, 0, 3);
				ZIndex = 15;
				Image = "http://www.roblox.com/asset/?id=14138375431";
				Parent = HueFrame
			})
			local TransparencyFrame = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				Position = udim2new(0, 3, 1, -11);
				Size = udim2new(0, 141, 0, 8);
				ZIndex = 15;
				Parent = ColorpickerInside
			})
			local TransparencyMover = util.new_object("ImageLabel", {
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -3, 0, -1);
				Size = udim2new(0, 3, 0, 10);
				ZIndex = 15;
				Image = "http://www.roblox.com/asset/?id=14138391128";
				Parent = TransparencyFrame
			})
			local ColorpickerOpen2 = util.new_object("ImageLabel", {
				Parent = self.lib.screen_gui;
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 0, 0);
				Size = udim2new(0, 100, 0, 60);
				ZIndex = 15;
				Visible = false;
				Parent = self.lib.screen_gui
			})
			local UICorner = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerOpen2
			})
			local ColorpickerBorder2 = util.new_object("Frame", {
				Parent = ColorpickerOpen2;
				BackgroundColor3 = colorfromrgb(32, 32, 32);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15
			})
			local UICorner_2 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerBorder2
			})
			local ColorpickerInside2 = util.new_object("Frame", {
				Parent = ColorpickerBorder2;
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				ZIndex = 15	
			})
			local UICorner_3 = util.new_object("UICorner", {
				CornerRadius = udimnew(0, 4);
				Parent = ColorpickerInside2
			})
			local UIGradient = util.new_object("UIGradient", {
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(16, 16, 16)), ColorSequenceKeypoint.new(0.35, colorfromrgb(8, 8, 8)), ColorSequenceKeypoint.new(1.00, colorfromrgb(8, 8, 8))};
				Rotation = 90;
				Parent = ColorpickerInside2
			})
			local ColorBox2 = util.new_object("Frame", {
				Parent = ColorpickerInside2;
				BackgroundColor3 = colorfromrgb(254, 254, 254);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(1, -12, 0, 2);
				Size = udim2new(0, 10, 0, 10);
				ZIndex = 66
			})
			local HexLabel = util.new_object("TextLabel", {
				Parent = ColorpickerInside2;
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 80, 0, 1);
				Size = udim2new(0, 0, 0, 12);
				ZIndex = 66;
				Font = Enum.Font.RobotoMono;
				Text = "#ffffff";
				TextColor3 = colorfromrgb(126, 126, 126);
				TextSize = 12.000;
				TextXAlignment = Enum.TextXAlignment.Right;
				Parent = ColorpickerInside2
			})
			local PasteLabel = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 1, -16);
				Size = udim2new(1, 0, 0, 12);
				ZIndex = 66;
				Font = Enum.Font.RobotoMono;
				Text = "paste color";
				TextColor3 = colorfromrgb(126, 126, 126);
				TextSize = 12.000;
				Parent = ColorpickerInside2
			})
			local CopyLabel = util.new_object("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 1, -34);
				Size = udim2new(1, 0, 0, 12);
				ZIndex = 66;
				Font = Enum.Font.RobotoMono;
				Text = "copy color";
				TextColor3 = colorfromrgb(126, 126, 126);
				TextSize = 12.000;
				Parent = ColorpickerInside2
			})

			lib.flags[flag]["color"] = info.color and info.color or colorfromrgb(255,255,255)
			lib.flags[flag]["transparency"] = info.transparency and info.transparency or 0

			local is_open = false
			local is_open2 = false
			local addon_cover = self.lib.addon_cover

			new_element.on_color_change = signal.new("on_color_change")
			new_element.on_transparency_change = signal.new("on_transparency_change")

			local function open_colorpicker()
				lib.busy = true; is_open = true
				ColorpickerOpen.Visible = true
				AddonImage.ImageColor3 = colorfromrgb(255,255,255)
				addon_cover.Visible = true
				addon_cover.BackgroundTransparency = 1
				AddonImage.ZIndex = 16
				util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

				local absPos = AddonImage.AbsolutePosition
				ColorpickerOpen.Position = udim2new(0, absPos.X - 5, 0, absPos.Y - 5)
			end

			local function open_colorpicker_alt()
				lib.busy = true; is_open2 = true
				ColorpickerOpen2.Visible = true
				AddonImage.ImageColor3 = colorfromrgb(255,255,255)
				addon_cover.Visible = true
				addon_cover.BackgroundTransparency = 1
				AddonImage.ZIndex = 67
				util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})

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
				util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
				task.delay(0.3, function()
					if addon_cover.BackgroundTransparency > 0.99 then
						addon_cover.Visible = false
					end
				end)
				AddonImage.ImageColor3 = colorfromrgb(74,74,74)
			end

			local function close_colorpicker()
				task.delay(0.03, function()
					lib.busy = false
				end)
				is_open = false
				ColorpickerOpen.Visible = false
				AddonImage.ZIndex = 14
				util:tween(addon_cover, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
				task.delay(0.3, function()
					if addon_cover.BackgroundTransparency > 0.99 then
						addon_cover.Visible = false
					end
				end)
				AddonImage.ImageColor3 = colorfromrgb(74,74,74)
			end

			local on_close = util:create_connection(self.lib.on_close, function()
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
				AddonImage.ImageColor3 = colorfromrgb(126,126,126)
			end)

			local on_leave = util:create_connection(AddonImage.MouseLeave, function()
				if is_open or lib.busy then return end
				AddonImage.ImageColor3 = colorfromrgb(74,74,74)
			end)

			local on_hover = util:create_connection(CopyLabel.MouseEnter, function()
				CopyLabel.TextColor3 = colorfromrgb(221,221,221)
			end)

			local on_leave = util:create_connection(CopyLabel.MouseLeave, function()
				CopyLabel.TextColor3 = colorfromrgb(126,126,126)
			end)

			local on_hover = util:create_connection(PasteLabel.MouseEnter, function()
				PasteLabel.TextColor3 = colorfromrgb(221,221,221)
			end)

			local on_leave = util:create_connection(PasteLabel.MouseLeave, function()
				PasteLabel.TextColor3 = colorfromrgb(126,126,126)
			end)

			local on_mouse1 = util:create_connection(CopyLabel.InputBegan, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					CopyLabel.TextColor3 = lib.accent_color
					if is_open2 then lib.copied_color = lib.flags[flag]["color"] end
				end
			end)
		
			local on_mouse1_end = util:create_connection(CopyLabel.InputEnded, function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					CopyLabel.TextColor3 = util:is_in_frame(CopyLabel) and colorfromrgb(221,221,221) or colorfromrgb(126,126,126)
				end
			end)

			local on_mouse1 = util:create_connection(AddonImage.InputBegan, function(input, gpe)
				if lib.busy or gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not lib.busy then AddonImage.ImageColor3 = colorfromrgb(255,255,255) end
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

            local color = info.color and info.color or colorfromrgb(255,255,255)
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
					PasteLabel.TextColor3 = util:is_in_frame(PasteLabel) and colorfromrgb(221,221,221) or colorfromrgb(126,126,126)
				end
			end)

			util:create_connection(lib.on_config_load, function()
				local h,s,v = lib.flags[flag]["color"]:ToHSV()
				update_sv(v*255, s*255, true)
				update_hue(h*360)
				update_transparency(lib.flags[flag]["transparency"])
			end)	
		elseif element == "textbox" then
			new_element.total_size+=(23)
			local MultiboxTextbox = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, 11);
				Size = udim2new(1, -24, 0, 19);
				Parent = ElementFrame
			})
			local DropdownBackground = util.new_object("Frame", {
				BackgroundColor3 = colorfromrgb(24, 24, 24);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 1);
				Size = udim2new(1, -2, 1, -2);
				Parent = MultiboxTextbox
			})
			local TextBox = util.new_object("TextBox", {
				Parent = DropdownBackground;
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 5, 0, 0);
				Size = udim2new(1, -5, 1, 0);
				Font = Enum.Font.RobotoMono;
				Text = "";
				TextColor3 = colorfromrgb(74, 74, 74);
				TextSize = 12.000;
				TextWrapped = true;
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

			util:create_connection(lib.on_config_load, function()
				TextBox.Text = lib.flags[flag]["text"] or ""
			end)
		end
	end

	ElementFrame.Size = udim2new(1, 0, 0, self.elements ~= 0 and new_element.total_size-9 or new_element.total_size)

	setmetatable(new_element, element); self.elements+=1

	self:update_size(new_element.total_size)

	table.insert(self.element_holder, new_element)

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

lib.new = LPH_JIT(function()
	local ScreenGui = util.new_object("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
		Parent = gethui and gethui() or cg,
		Enabled = false
	})
	local MainBackground = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0.132718891, 0, 0.122222222, 0);
		Size = udim2new(0, 600, 0, 430);
		Parent = ScreenGui
	})
	local AddonCover = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(1, 1, 1);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = udim2new(0, 0, 0, 25);
		Size = udim2new(1, 0, 0, 381);
		Visible = false;
		ZIndex = 14;
		Parent = MainBackground
	})
	local ConfirmCover = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(1, 1, 1);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Position = udim2new(0, 0, 0, 25);
		Size = udim2new(1, 0, 0, 381);
		Visible = false;
		ZIndex = 14;
		Parent = MainBackground
	})
	local UICorner = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainBackground
	})
	local MainBorder = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(32, 32, 32);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainBackground
	})
	local UICorner_2 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainBorder
	})
	local MainInside = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(11, 11, 11);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainBorder    
	})
	local UICorner_3 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainInside
	})
	local MainTop = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 0, 20);
		Parent = MainBorder  
	})
	local UICorner_4 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainTop
	})
	local TopInside = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainTop
	})
	local UICorner_5 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = TopInside
	})
	local TopFix = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(0, 0, 0);
		Position = udim2new(0, 0, 0, 9);
		Size = udim2new(1, 0, 0, 9);
		Parent = TopInside
	})
	local TopFix2 = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, -1);
		Size = udim2new(1, 0, 0, 1);
		Parent = TopFix
	})
	local NameLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 0);
		Size = udim2new(0, 95, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "juju.lol";
		TextColor3 = lib.accent_color;
		TextSize = 12.000;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		RichText = true;
		Parent = TopInside
	})
	local TopCover = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(32, 32, 32);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 1, 0);
		Size = udim2new(1, 0, 0, 1);
		Parent = MainTop
	})
	local MainBottom = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 1, -21);
		Size = udim2new(1, -2, 0, 20);
		Parent = MainBorder
	})
	local UICorner_8 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = MainBottom
	})
	local BottomInside = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		Parent = MainBottom
	})
	local TipImage = util.new_object("ImageLabel", {
		BackgroundColor3 = colorfromrgb(254, 254, 254);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 3);
		Size = udim2new(0, 12, 0, 12);
		ImageTransparency = 1;
		Visible = true;
		ZIndex = 3;
		Image = "http://www.roblox.com/asset/?id=14151711445";
		Parent = BottomInside
	})
	local TipLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(254, 254, 254);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 21, 0, 0);
		Size = udim2new(0, 350, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "This is an example tip.";
		TextColor3 = colorfromrgb(74, 74, 74);
		TextSize = 12.000;
		TextWrapped = true;
		TextTransparency = 1;
		TextXAlignment = Enum.TextXAlignment.Left;
		ZIndex = 3;
		Parent = TipImage
	})
	local UICorner_9 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = BottomInside
	})
	local BottomFix = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(0, 0, 0);
		Size = udim2new(1, 0, 0, 9);
		Parent = BottomInside
	})
	local BottomFix2 = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(8, 8, 8);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, 9);
		Size = udim2new(1, 0, 0, 1);
		Parent = BottomFix
	})
	local BuildLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 5, 0, 0);
		Size = udim2new(0, 95, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "build: <font color=\"rgb(189, 172, 255)\">live</font>";
		TextColor3 = colorfromrgb(74, 74, 74);
		TextSize = 12.000;
		TextWrapped = true;
		RichText = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = BottomInside
	})
	local UserLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -305, 0, 0);
		Size = udim2new(0, 300, 1, 0);
		Font = Enum.Font.RobotoMono;
		Text = "active user: <font color=\"rgb(189, 172, 255)\">xander</font>";
		TextColor3 = colorfromrgb(74, 74, 74);
		TextSize = 12.000;
		RichText = true;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Right;
		Parent = BottomInside
	})
	local BottomCover = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(32, 32, 32);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, -1);
		Size = udim2new(1, 0, 0, 1);
		Parent = MainBottom
	})
	local TabSlider = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		ClipsDescendants = true;
		Position = udim2new(0, 106, 0, 1);
		Size = udim2new(1, -212, 1, 0);
		Parent = MainTop
	})
	local TabHolder = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(-1, 0, 0, 0);
		Size = udim2new(1, 0, 1, 0);
		Parent = TabSlider
	})
	local UIListLayout = util.new_object("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		SortOrder = Enum.SortOrder.LayoutOrder;
		VerticalAlignment = Enum.VerticalAlignment.Top;
		Padding = udimnew(0, 5);
		Parent = TabHolder
	})
	local FadeLine = util.new_object("Frame", {
		BackgroundColor3 = lib.accent_color;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -298, 1, 1);
		Size = udim2new(0.5, 0, 0, 1);
		Parent = MainTop
	})
	local UIGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(11, 11, 11)), ColorSequenceKeypoint.new(1.00, colorfromrgb(255, 255, 255))};
		Parent = FadeLine
	})
	local ConfirmationFrame = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0.5, -121, 0.5, -48);
		Size = udim2new(0, 242, 0, 96);
		ZIndex = 101;
		Visible = false;
		Parent = MainBackground
	})
	local UICorner = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = ConfirmationFrame
	})
	local CF2 = util.new_object("Frame", {
		Parent = ConfirmationFrame;
		BackgroundColor3 = colorfromrgb(32, 32, 32);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = ConfirmationFrame
	})
	local UICorner_2 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CF2
	})
	local CF3 = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(11, 11, 11);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = CF2
	})
	local UICorner_3 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CF3
	})
	local CFTOP = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_4 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CFTOP
	})
	local CFFIX = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 1, -4);
		Size = udim2new(1, 0, 0, 4);
		ZIndex = 101;
		Parent = CFTOP
	})
	local UICorner_5 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 4);
		Parent = CFFIX
	})
	local CFLINE = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(32, 32, 32);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 1, 0);
		Size = udim2new(1, 0, 0, 1);
		ZIndex = 101;
		Parent = CFTOP
	})
	local CFLABEL = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 1, 0);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Load config";
		TextColor3 = lib.accent_color;
		TextSize = 12.000;
		Parent = CFTOP
	})
	local CFTEXTLABEL = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 1, -10);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Are you sure you want to load your config?";
		TextColor3 = colorfromrgb(221, 221, 221);
		TextSize = 12.000;
		TextWrapped = true;
		Parent = CF3
	})
	local CancelButton = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 34, 1, -33);
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_7 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = CancelButton
	})
	local CancelInside = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(254, 254, 254);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = CancelButton	
	})
	local UICorner_8 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = CancelInside
	})
	local UIGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
		Rotation = 90;
		Parent = CancelInside
	})
	local CancelLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Cancel";
		TextColor3 = colorfromrgb(74, 74, 74);
		TextSize = 12.000;
		Parent = CancelInside
	})
	local ConfirmButton = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -114, 1, -33);
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Parent = CF3
	})
	local UICorner_9 = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = ConfirmButton
	})
	local ConfirmInside = util.new_object("Frame", {
		BackgroundColor3 = colorfromrgb(254, 254,254);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 101;
		Parent = ConfirmButton
	})
	local UICorner_10  = util.new_object("UICorner", {
		CornerRadius = udimnew(0, 3);
		Parent = ConfirmInside
	})
	local UIGradient_2 = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))};
		Rotation = 90;
		Parent = ConfirmInside
	})
	local ConfirmLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 80, 0, 20);
		ZIndex = 101;
		Font = Enum.Font.RobotoMono;
		Text = "Confirm";
		TextColor3 = colorfromrgb(74, 74, 74);
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
		hotkey = "insert",
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

    local on_accent_change = util:create_connection(lib.on_accent_change, function(color)
        lib.accent_color = color
        CFLABEL.TextColor3 = color
        FadeLine.BackgroundColor3 = color
        new_window:set_user("im not that dumb")
        new_window:set_build("live")
        new_window:set_title("juju.lol")
    end)

	local is_holding = false

	local on_hover = util:create_connection(CancelButton.MouseEnter, function()
		if is_holding then return end
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}
		CancelLabel.TextColor3 = colorfromrgb(221,221,221)
	end)

	local on_leave = util:create_connection(CancelButton.MouseLeave, function()
		if is_holding then return end
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
		CancelLabel.TextColor3 = colorfromrgb(74,74,74)
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
			CancelLabel.TextColor3 = util:is_in_frame(CancelButton) and colorfromrgb(221,221,221) or colorfromrgb(74,74,74)
			Color = util:is_in_frame(CancelButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
			CancelButton.BackgroundColor3 = colorfromrgb(0, 0, 0)
			new_window.confirmationsignal:Fire(false)
		end
	end)

	local on_hover = util:create_connection(ConfirmButton.MouseEnter, function()
		if is_holding then return end
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}
		ConfirmLabel.TextColor3 = colorfromrgb(221,221,221)
	end)

	local on_leave = util:create_connection(ConfirmButton.MouseLeave, function()
		if is_holding then return end
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
		ConfirmLabel.TextColor3 = colorfromrgb(74,74,74)
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
			ConfirmLabel.TextColor3 = util:is_in_frame(ConfirmButton) and colorfromrgb(221,221,221) or colorfromrgb(74,74,74)
			UIGradient_2.Color = util:is_in_frame(ConfirmButton) and ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(35, 35, 35)), ColorSequenceKeypoint.new(1.00, colorfromrgb(24, 24, 24))}	or ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(24, 24, 24)), ColorSequenceKeypoint.new(1.00, colorfromrgb(16, 16, 16))}
			ConfirmButton.BackgroundColor3 = colorfromrgb(0, 0, 0)
			new_window.confirmationsignal:Fire(true)
		end
	end)

	local on_input = util:create_connection(uis.InputBegan, function(input, gpe)
		if gpe then return end

		if input.KeyCode.Name:lower() == new_window.hotkey then
			if new_window.opened then new_window:close() else new_window:open() end
		end
	end)

	setmetatable(new_window, window)

	new_window:close()

	return new_window
end)

function lib:set_dependent(dependency, dependent_on)
	dependency:set_visible(false)
	util:create_connection(dependent_on.on_toggle, function(toggle)
		dependency:set_visible(toggle)
	end)
end

function lib:set_dropdown_dependent(dependency, dependent_on, value)
	dependency:set_visible(false)
	util:create_connection(dependent_on.on_option_change, function(option)
		dependency:set_visible(option[1] == value)
	end)
end

end

-- * Other GUI Setups

-- * Watermark

local watermark = {}

watermark.__index = watermark

watermark.new = LPH_JIT(function(user, game)
	local wm = {
		label = nil,
		user = user,
		game = game,
		main = nil,
		logo = nil
	}

	do
		local Watermark = util.new_object("Frame", {
			BackgroundColor3 = colorfromrgb(35, 35, 35);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(0, 0, 0, 30);
			Position = UDim2.new(0,0,0,0);
			Visible = false;
			Parent = global_sg
		}); wm.main = Watermark
		local BackCorner = util.new_object("UICorner", {
			CornerRadius = UDim.new(0, 3);
			Parent = Watermark
		})
		local Border = util.new_object("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			Parent = Watermark
		})
		local InsideCorner = util.new_object("UICorner", {
			CornerRadius = UDim.new(0, 3);
			Parent = Border
		})
		local Gradient = util.new_object("UIGradient", {
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(29, 29, 29)), ColorSequenceKeypoint.new(1.00, colorfromrgb(20, 20, 20))};
			Rotation = 90;
			Parent = Border
		})
		local Logo = util.new_object("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(0, 28, 0, 28);
			Image = "http://www.roblox.com/asset/?id=14720232130";
			Parent = Border
		})
		local Text = util.new_object("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 28, 0, 0);
			Size = UDim2.new(1, -33, 1, 0);
			Font = Enum.Font.ArialBold;
			TextColor3 = colorfromrgb(70, 70, 70);
			TextSize = 11.000;
			TextWrapped = true;
			TextXAlignment = Enum.TextXAlignment.Left;
            RichText = true;
			Parent = Border
		})

		wm.label = Text
		wm.main = Watermark
		wm.logo = Logo

		util:set_draggable(Watermark)
	end

	setmetatable(wm, watermark)

	return wm
end)

function watermark:update_text()
	local user, game_name = self.user, self.game
    local accent_color = lib.accent_color

	local label = self.label
	local time_text = os.date("%I:%M")
	local time_suffix = lower(os.date("%p"))
	local color = tostring(util:round(accent_color.R*255))..", "..tostring(util:round(accent_color.G*255))..", "..tostring(util:round(accent_color.B*255))

	self.logo.ImageColor3 = accent_color
	self.main.Size = UDim2.new(0, texts:GetTextSize((string.format("%s | %s | %s %s", user, game_name, time_text, time_suffix)), 11, "ArialBold", vect2(999,999)).X + 36, 0, 30)
	self.label.Text = string.format("%s <font color=\"rgb(35, 35, 35)\">|</font> %s <font color=\"rgb(35, 35, 35)\">|</font> <font color=\"rgb("..color..")\">%s</font> %s", user, game_name, time_text, time_suffix)
end

local keybind = {}
keybind.__index = keybind

local KeybindsHolder = util.new_object("Frame", {
	BackgroundColor3 = colorfromrgb(255, 255, 255);
	BackgroundTransparency = 1.000;
	BorderColor3 = colorfromrgb(0, 0, 0);
	BorderSizePixel = 0;
	Position = UDim2.new(0, 2, 1, 4);
	Size = UDim2.new(1, -4, 0, 500);
})

local new_keybind = nil

do
	local flags = lib.flags

	new_keybind = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BackgroundTransparency = 0.500;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 555, 0, 550);
		Size = UDim2.new(0, 165, 0, 20);
		ZIndex = 2;
		Font = Enum.Font.Ubuntu;
		Text = "keybinds";
		TextColor3 = colorfromrgb(255, 255, 255);
		TextSize = 12.000;
		Visible = false;
		Parent = global_sg
	}); KeybindsHolder.Parent = new_keybind; util:set_draggable(new_keybind); util:create_connection(new_keybind:GetPropertyChangedSignal("Position"), function()
		lib.flags["keybinds_position"] = {new_keybind.Position.X.Offset, new_keybind.Position.Y.Offset}
	end)
	local UICorner = util.new_object("UICorner", {
		CornerRadius = UDim.new(0, 6);
		Parent = new_keybind
	})
	local Shadow = util.new_object("ImageLabel", {
		BackgroundTransparency = 1.000;
		Position = UDim2.new(0, -7, 0, -7);
		Size = UDim2.new(1, 14, 1, 14);
		ZIndex = 0;
		Image = "rbxassetid://1316045217";
		ImageTransparency = 0.880;
		ScaleType = Enum.ScaleType.Slice;
		SliceCenter = Rect.new(10, 10, 118, 118);
		Parent = new_keybind
	})
	local UIListLayout = util.new_object("UIListLayout", {
		Parent = KeybindsHolder;
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	local TextLabel = util.new_object("TextLabel", {
		BackgroundColor3 = colorfromrgb(0, 0, 0);
		BackgroundTransparency = 11.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, 0, 1, 0);
		Font = Enum.Font.Ubuntu;
		Text = "keybinds";
		TextColor3 = colorfromrgb(0, 0, 0);
		TextSize = 12.000;
		Parent = new_keybind
	})

	function keybind.new(text, element, flag)
		local NameLabel = util.new_object("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(1, 0, 0, 16);
			ZIndex = 2;
			Font = Enum.Font.Ubuntu;
			Text = text;
			TextColor3 = colorfromrgb(255, 255, 255);
			TextSize = 12.000;
			TextStrokeColor3 = colorfromrgb(165, 165, 165);
			TextXAlignment = Enum.TextXAlignment.Left;
			Visible = false;
			Parent = KeybindsHolder
		})
		local NameOffset = util.new_object("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, 0, 1, 0);
			Font = Enum.Font.Ubuntu;
			Text = text;
			TextColor3 = colorfromrgb(0, 0, 0);
			TextSize = 12.000;
			TextStrokeColor3 = colorfromrgb(165, 165, 165);
			TextTransparency = 0.700;
			TextXAlignment = Enum.TextXAlignment.Left;
			Parent = NameLabel
		})
		local MethodLabel = util.new_object("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(1, 0, 1, 0);
			ZIndex = 2;
			Font = Enum.Font.Ubuntu;
			Text = "[unbound]";
			TextColor3 = colorfromrgb(255, 255, 255);
			TextSize = 12.000;
			TextStrokeColor3 = colorfromrgb(165, 165, 165);
			TextXAlignment = Enum.TextXAlignment.Right;
			Parent = NameLabel	
		})
		local MethodOffset = util.new_object("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, 0, 1, 0);
			Font = Enum.Font.Ubuntu;
			Text = "[unbound]";
			TextColor3 = colorfromrgb(0, 0, 0);
			TextSize = 12.000;
			TextStrokeColor3 = colorfromrgb(165, 165, 165);
			TextTransparency = 0.700;
			TextXAlignment = Enum.TextXAlignment.Right;
			Parent = MethodLabel
		})

		local kb = {}
		kb.text = NameLabel
		kb.key_label = MethodLabel

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
	end

	function keybind:set_visible(visible)
		local transparency = visible and 0 or 1
		if visible then
			self.text.Visible = true
		end
		util:tween(self.text, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = transparency})
		for _, text in pairs(self.text:GetDescendants()) do
			util:tween(text, twinfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = transparency})		
		end
		if not visible then
			task.delay(0.3, function()
				if self.text.TextTransparency > 0.99 then
					self.text.Visible = false
				end
			end)
		end
	end

	function keybind:set_key(key)
		local string2 = string.format("[%s]", key)
		self.key_label.Text = string2
		self.key_label:FindFirstChildOfClass("TextLabel").Text = string2
	end

	function keybind:set_color(color)
		Shadow.ImageColor3 = color
	end

	function keybind:set_transparency(transparency)
		Shadow.ImageTransparency = transparency
	end

	function keybind:set_list_visible(visible)
		new_keybind.Visible = visible
	end
end

-- * Misc

local flags = lib.flags
local all_players = {}
local client = {}
local cache = {
	world_time = lighting.ClockTime,
	fog_color = lighting.FogColor,
	fog_start = lighting.FogStart,
	fog_end = lighting.FogEnd,
	world_hue = lighting.Ambient,
	compensation = lighting.ExposureCompensation,
	fov = camera.FieldOfView,
	brightness = lighting.Brightness,
	color_shift_bottom = lighting.ColorShift_Bottom,
	color_shift_top = lighting.ColorShift_Top,
	last_crosshair_rotation = 0,
	viewed_player = nil,
	max_zoom_distance = lplr.CameraMaxZoomDistance,
	stomp_delay = false,
	strafe_angle = 0,
	mouse_tp = false,
	camera_cframe = cfnew(),
	auto_kill = false,
	auto_ready = false,
	character_clone = nil,
	force_cframe = nil,
	is_down = false,
	is_up = false
}

local main_event = nil

LPH_NO_VIRTUALIZE(function()
	for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
		if (remote.Name == "MainEvent" or remote.Name == "MainRemote" or remote.Name == "MAIN_EVENT" or remote.Name == "MAINEVENT") and remote.ClassName == "RemoteEvent" then
			main_event = remote
		end 
	end
end)()

local new_watermark = watermark.new(lower(lplr.Name), "da hood")

do
	local main = new_watermark.main
	new_watermark:update_text()

	util:create_connection(main:GetPropertyChangedSignal("Position"), function()
		flags["watermark_position"] = {main.Position.X.Offset, main.Position.Y.Offset}
	end)
end


-- * Hitlogs

local notifications = {
	cache = {}
}

do
	notifications.new_notification = LPH_NO_VIRTUALIZE(function(notification)
		local notification = {
			info = {
				start_time = tick(),
				delta = 0,
				delta2 = 0,
				target = nil
			},
			objects = {
				prefix = util:new_drawing("Text", {
					Size = 18;
					ZIndex = 1;
					Text = "[ratio]";
					Color = lib.accent_color;
					Font = Drawing.Fonts[1];
					Transparency = 0;
					Visible = true;
				}),
				text = util:new_drawing("Text", {
					Size = 18;
					ZIndex = 1;
					Text = notification;
					Color = colorfromrgb(226,226,226);
					Font = Drawing.Fonts[1];
					Transparency = 0;
					Visible = true;
				})
			}
		}; notification.info.target = notification.objects.prefix.TextBounds.X + 7

		table.insert(notifications.cache, notification)
	end)

	local notification_loop = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
		local cache = notifications.cache
		local amount = #cache
		for i = 1, amount do
			local notification = cache[i]
			if not notification then continue end
			local objects = notification.objects
			local info = notification.info
			local prefix = objects.prefix
			local text = objects.text
			local target = info.target
			info.delta+=dt
			if tick()-info.start_time > 2 then
				info.delta2+=dt
				local transparency = 1 - (1 * ts:GetValue((info.delta2 / 0.8), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				prefix.Position = vect2(5, 61 + (16*i + 2))
				text.Position = prefix.Position + vect2(target, 0)
				prefix.Transparency = transparency
				text.Transparency = transparency
				if transparency < 0.01 then
					table.remove(notifications.cache, i)
					prefix:Destroy()
					text:Destroy()
				end
			else
				local transparency = ts:GetValue((info.delta / 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local transparency2 = ts:GetValue((info.delta / 1.5), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local textboundsx = prefix.TextBounds.X
				prefix.Position = vect2(-textboundsx + ((5+textboundsx) * transparency2), 61 + (16*i + 2))
				text.Position = prefix.Position + vect2(-target + (target*2 * transparency), 0)
				info.delta+=dt
				prefix.Transparency = transparency2
				text.Transparency = transparency
			end
		end
	end))
end

-- * Hack Functions

local world = {}

do
	local ignored_folder = workspace.Ignored

	world.is_visible = LPH_JIT(function(start, result, other)
		return #camera:GetPartsObscuringTarget({start, result}, other) == 0
	end)
end

world.is_gun = LPH_JIT(function(tool)
	return tool:FindFirstChild("Ammo"), tool:FindFirstChild("MaxAmmo")
end)

local cheat = {
	hitsounds = {RIFK7 = "rbxassetid://9102080552", Bubble = "rbxassetid://9102092728", Minecraft = "rbxassetid://5869422451", Cod = "rbxassetid://160432334", Bameware = "rbxassetid://6565367558", Neverlose = "rbxassetid://6565370984", Gamesense = "rbxassetid://4817809188", Rust = "rbxassetid://6565371338"}
}

do
	local ignored_folder = workspace.Ignored

	cheat.do_hit_chams = LPH_NO_VIRTUALIZE(function(character) -- i ate here :3
		character.Archivable = true; local character_cloned = character:Clone(); character.Archivable = false
		local all_parts = character_cloned:GetChildren()
		local material = Enum.Material[flags["hit_chams_material"]["selected"][1]]
		local color = flags["hit_chams"]["color"]
		local transparency = flags["hit_chams"]["transparency"]
		local fade = flags["hit_chams_fade"]["toggle"]
		local lifetime = flags["hit_chams_lifetime"]["value"]

		for i = 1, #all_parts do
			local part = all_parts[i]
			local class_name = part.ClassName
			local name = part.Name
			if (class_name == "Part" or class_name == "MeshPart") and name ~= "HumanoidRootPart" then
				part.Color = color
				part.Material = material
				part.Transparency = transparency
				part.CanCollide = false
				part.Anchored = true
				if fade then
					util:tween(part, twinfo(lifetime-0.01, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
				end
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

		character_cloned.Parent = ignored_folder;
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

	local bubble = Instance.new("Folder")
	do
		local particle1 = util.new_object("ParticleEmitter", {
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
			Parent = bubble
		})
		local particle2 = util.new_object("ParticleEmitter", {
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
			Parent = bubble
		})
		local particle3 = util.new_object("ParticleEmitter", {
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
			Parent = bubble
		})
	end

	local confetti = Instance.new("Folder")
	do
		local particle1 = util.new_object("ParticleEmitter", {
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
		local particle2 = util.new_object("ParticleEmitter", {
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
		local particle3 = util.new_object("ParticleEmitter", {
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
		local particle4 = util.new_object("ParticleEmitter", {
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
		local particle5 = util.new_object("ParticleEmitter", {
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
	
	local stars = Instance.new("Folder")
	do
		local particle = util.new_object("ParticleEmitter", {
			Lifetime = NumberRange.new(1,1);
			LightEmission = 0.6;
			LightInfluence = 1;
			LockedToPart = true;
			Rate = 0;
			Lifetime = NumberRange.new(1,1);
			RotSpeed = NumberRange.new(-150,-150);
			Rotation = NumberRange.new(-360,360);
			Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(1,0.5,0)};
			Speed = NumberRange.new(14,14);
			SpreadAngle = vect2(50,50);
			Texture = [[rbxassetid://244221535]];
			Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.157738,0,0),NumberSequenceKeypoint.new(0.84003,0,0),NumberSequenceKeypoint.new(0.895833,0,0),NumberSequenceKeypoint.new(1,1,0)};	
			Parent = stars
		})
	end

	local sparks = Instance.new("Folder")
	do
		local particle = util.new_object("ParticleEmitter", {
			Acceleration = vect3(0,-50,0);
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0.999969,0.999985)),ColorSequenceKeypoint.new(0.25,Color3.new(0.333333,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,1,0.498039))};
			Lifetime = NumberRange.new(0.5,1);
			LightEmission = 1;
			Orientation = Enum.ParticleOrientation.VelocityParallel;
			Rate = 0;
			Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.6,0),NumberSequenceKeypoint.new(0.5,0.6,0),NumberSequenceKeypoint.new(1,0,0)};
			Speed = NumberRange.new(15,15);
			SpreadAngle = vect2(50,-50);
			Texture = [[http://www.roblox.com/asset/?id=7587238412]];
			Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,1,0)};
			Parent = sparks
		})
	end

	local hit_effects = {
		["Confetti"] = hit_effect.new(confetti, 10, true),
		["Bubble"] = hit_effect.new(bubble, 1, false),
		["Sparks"] = hit_effect.new(sparks, 30, false),
		["Stars"] = hit_effect.new(stars, 5, false),
	}

	local lightning = Instance.new("Folder")

	do
		local model1 = util.new_object("Model", {
			Parent = lightning
		}); model1.Name = "model1"
		local thunder = util.new_object("MeshPart", {
			MeshId = [[rbxassetid://6553232712]];
			CollisionFidelity = Enum.CollisionFidelity.Default;
			Anchored = true;
			BrickColor = BrickColor.new('Cyan');
			CFrame = CFrame.new(588.018066,928.855591,-841.772827,1,0,0,0,1,0,0,0,1);
			CanCollide = false;
			Color = Color3.new(0.0156863,0.686275,0.92549);
			EnableFluidForces = false;
			Material = Enum.Material.Neon;
			Size = Vector3.new(3.1219868659973145,136.94822692871094,3.576389789581299);
			Transparency = 0.6000000238418579;
			Name = [[Thunder]];
			Parent = model1
		}); thunder.Name = "thunder"
		local shockwave = util.new_object("MeshPart", {
			MeshId = [[rbxassetid://5694662480]];
			CollisionFidelity = Enum.CollisionFidelity.Default;
			Anchored = true;
			BrickColor = BrickColor.new('Cyan');
			CFrame = CFrame.new(588.415955,877.261902,-841.6922,0,-1,0,1,0,-0,0,0,1);
			CanCollide = false;
			Color = Color3.new(0.0156863,0.686275,0.92549);
			EnableFluidForces = false;
			Material = Enum.Material.Neon;
			Rotation = Vector3.new(0,0,90);
			Size = Vector3.new(33.26506042480469,6.936452388763428,6.362579822540283);
			Name = [[Shockwave]];
			Parent = model1
		}); shockwave.Name = "shockwave"
		model1.PrimaryPart = thunder

		local model2 = util.new_object("Model", {
			Parent = lightning
		}); model2.Name = "model2"
		local ball = util.new_object("MeshPart", {
			MeshId = [[rbxassetid://3375161112]];
			CollisionFidelity = Enum.CollisionFidelity.Default;
			Anchored = true;
			BrickColor = BrickColor.new('Cyan');
			CFrame = CFrame.new(588.002075,862.950012,-842.995972,-1,0,0,0,1,0,0,0,-1);
			CanCollide = false;
			Color = Color3.new(0.0156863,0.686275,0.92549);
			EnableFluidForces = false;
			Material = Enum.Material.Neon;
			Rotation = Vector3.new(180,0,180);
			Size = Vector3.new(11.19994831085205,5.599967002868652,11.19994831085205);
			Name = [[spikeyball]];
			Parent = model2
		}); ball.Name = "ball"
		model2.PrimaryPart = ball
	end

	cheat.do_stomp_effect = LPH_JIT(function(character)
		local effect = flags["stomp_effect"]["selected"][1]
		if effect == "Fade" then
			local children = character:GetDescendants()
			for i = 1, #children do
				local part = children[i]
				local classname = part.ClassName
				if classname == "MeshPart" or classname == "Part" then
					util:tween(part, twinfo(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
				end
			end
		elseif effect == "Lightning" then
			local new_effect = lightning:Clone()
			local lightning = new_effect.model1
			local shockwave = new_effect.model2
			local hrp = character.UpperTorso

			local new_sound = util.new_object("Sound", {
				Volume = 0.6,
				PlayOnRemove = true,
				SoundId = "rbxassetid://821439273",
				Parent = lplr.PlayerGui
			}); new_sound:Destroy()

			local selected = flags["sound"]["selected"][1]
			local sound = Instance.new("Sound", lplr.PlayerGui)
			sound.Volume = flags["volume"]["value"]
			sound.PlayOnRemove = true
			sound.SoundId = selected ~= "Custom" and cheat.hitsounds[flags["sound"]["selected"][1]] or flags["sound_id"]["text"]
			sound:Destroy()

			lightning:SetPrimaryPartCFrame(CFrame.new(hrp.Position)) 
			lightning:SetPrimaryPartCFrame(lightning:GetPrimaryPartCFrame() * CFrame.new(0, 15, 0))
			lightning.Parent = ignored_folder

			util:tween(lightning.PrimaryPart, twinfo(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(hrp.Position)})

			shockwave.Parent = ignored_folder
			shockwave:SetPrimaryPartCFrame(CFrame.new(hrp.Position)) 
			shockwave:SetPrimaryPartCFrame(shockwave:GetPrimaryPartCFrame() * CFrame.new(0, 0.2, 0))
			shockwave.PrimaryPart.Size = Vector3.new(0.1, 0.1, 0.1)
			shockwave.PrimaryPart.Transparency = 0.8

			util:tween(shockwave.PrimaryPart, twinfo(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(8, 8, 8), Transparency = 1})
			util:tween(lightning.PrimaryPart, twinfo(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1})
			util:tween(lightning.shockwave, twinfo(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1})

			task.delay(1, function()
				new_effect:Destroy()
				lightning:Destroy()
				shockwave:Destroy()
			end)
		elseif effect == "Soul" then
			character.Archivable = true; local cloned = character:Clone(); character.Archivable = false
			cloned.Humanoid:Destroy()
			local children = cloned:GetDescendants()
			for i = 1, #children do
				local part = children[i]
				local classname = part.ClassName
				if classname == "MeshPart" or classname == "Part" then
					part.Material = Enum.Material.ForceField
					part.Color = colorfromrgb(255,255,255)
					part.Anchored = true
					part.CanCollide = false
					util:tween(part, twinfo(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1, CFrame = part.CFrame + Vector3.new(0,50,0)})
				end
			end
			cloned.Parent = ignored_folder
			task.delay(2, function()
				cloned:Destroy()
			end)
		elseif effect == "Meteor" then

		end
	end)

	cheat.do_hit_sound = LPH_JIT(function()
		local selected = flags["sound"]["selected"][1]
		local sound = Instance.new("Sound", lplr.PlayerGui)
		sound.Volume = flags["volume"]["value"]
		sound.PlayOnRemove = true
		sound.SoundId = selected ~= "Custom" and cheat.hitsounds[flags["sound"]["selected"][1]] or flags["sound_id"]["text"]
		sound:Destroy()
	end)

	cheat.do_hit_effect = LPH_JIT(function(character)
		local hrp = character.HumanoidRootPart
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
			child:Emit(emit_count)
		end
		task.delay(2, function()
			attachment:Destroy()
		end)
		new_particles:Destroy()
	end)

	cheat.create_beam = LPH_JIT(function(from, to, color, transparency, lifetime, cloned, texture, fade)
		local beam = util.new_object("Beam", {
			Texture = texture;
			TextureMode = Enum.TextureMode.Wrap;
			TextureLength = 10;
			LightEmission = 1;
			LightInfluence = 1;
			FaceCamera = true;
			ZOffset = -1;
			Transparency = NumberSequence.new(transparency);
			Color = ColorSequence.new(color, Color3.new(0, 0, 0));
			Attachment0 = from;
			Attachment1 = to;
			Enabled = true;
			Parent = ignored_folder
		})

		local tween = nil

		if fade then
			local total_time = 0

			tween = util:create_connection(rs.Heartbeat, function(dt)
				total_time+=dt
				beam.Transparency = NumberSequence.new(ts:GetValue((total_time / lifetime), Enum.EasingStyle.Quad, Enum.EasingDirection.In));
			end)
		end

		task.delay(lifetime, function()
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
			if tween then
				tween:Disconnect()
			end
		end)
	end)

	local offsets = {
		vect2(1,1),
		vect2(-1,1),
		vect2(1,-1),
		vect2(-1,-1)
	}	

	cheat.new_hitmarker = LPH_JIT(function()
		local hitmarker = {}
	
		for i = 1, 4 do
			hitmarker[i] = {
				outline = util:new_drawing("Line", {
					Thickness = 3,
					ZIndex = 1,
					Color = Color3.fromRGB(0,0,0)
				}),
				line = util:new_drawing("Line", {
					Thickness = 1,
					ZIndex = 1,
					Color = Color3.fromRGB(255,255,255)
				})
			}
		end

		local time_elapsed = 0
	
		local render_connection = nil; render_connection = util:create_connection(rs.Heartbeat, function(dt)
			time_elapsed+=dt
			local mouse_pos = uis:GetMouseLocation()
			local gap = flags["hitmarker_gap"]["value"]
			local size = flags["hitmarker_size"]["value"]
			local hitmarker_color = flags["hitmarker"]["color"]
			local tween_value = ts:GetValue((time_elapsed / .6), Enum.EasingStyle.Sine, Enum.EasingDirection.In)

			for i = 1, 4 do
				local lines = hitmarker[i]
				local outline = lines.outline
				local line = lines.line
				if tween_value >= .988 then
					outline:Destroy()
					line:Destroy()
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

			if tween_value >= .988 then
				hitmarker = nil
				render_connection:Disconnect()
			end
		end)
	end)

	cheat.do_auto_sort = LPH_NO_VIRTUALIZE(function()
		local sort_positions = {}

		for i = 1, 9 do
			sort_positions[i] = lower(tostring(flags["slot_"..tostring(i)]["text"]))
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

	cheat.purchase_item = LPH_JIT(function(name, click_detector, head, click_detector2, head2)
		setfflag("S2PhysicsSenderRate", "15")
		local ping = client.ping*3/1000
		local old_cf = lplr.Character.HumanoidRootPart.CFrame
		local did_buy = false
		if not lplr.Backpack:FindFirstChild(string.format("[%s]", name)) then
			did_buy = true
			cache.force_cframe = head.CFrame - vect3(0,4,0)
			task.wait(ping)
			fireclickdetector(click_detector)
		end
		if click_detector2 then
			local ammo = flags["ammo_"]["value"]
			if ammo > 0 then
				task.wait(did_buy and .7 + ping or 0)
				cache.force_cframe = head2.CFrame - vect3(0,4,0)
				task.wait(ping)
				for i = 1, ammo do
					fireclickdetector(click_detector2)
					task.wait(i == ammo and ping or .7 + ping)
				end
			end
		end
		cache.force_cframe = old_cf
		task.delay(0.03, function()
			cache.force_cframe = nil
		end)
		setfflag("S2PhysicsSenderRate", tostring(flags["physics_rate"]["value"]))
	end)
end

client = {
	on_character_loaded = signal.new('on_character_loaded'),
	on_health_changed = signal.new("on_health_changed"),
	on_fire_armor_changed = signal.new("on_fire_armor_changed"),
	on_armor_changed = signal.new("on_armor_changed"),
	on_gun_equipped = signal.new("on_gun_equipped"),
	on_bullet_fired = signal.new("on_bullet_fired"),
	on_hurt_player = signal.new('on_hurt_player'),
	on_knocked = signal.new('on_knocked'),
	on_grabbed = signal.new('on_grabbed'),
	on_dropped = signal.new('on_dropped'),
	on_stomped = signal.new('on_stomped'),
	on_get_up = signal.new('on_get_up'),
	recently_shot = false,
	recently_stomped = false,
	siren_pos = vect3(),
	crew = 0,
	ping = 50,
	opps = {},
	whitelisted = {},
	animations = {},
	info = {
		has_forcefield = nil,
		gun_equipped = nil,
		grabbed = false,
		knocked = false,
		tool_equipped = nil,
		health = 100,
		fire_armor = 0,
		armor = 0,
	}
}

local aimbot = {
	aimbot_location = vect3(),
	active_target = nil,
	fov_size = 0,
	refresh_tick = tick(),
	active_target = nil,
	forced_target = nil,
	in_air = false
}

do
	local client_info = client.info
	local on_get_up = client.on_get_up
	local on_grabbed = client.on_grabbed
	local on_dropped = client.on_dropped
	local on_knocked = client.on_knocked
	local on_hurt_player = client.on_hurt_player
	local on_gun_equipped = client.on_gun_equipped
	local on_fire_armor_changed = client.on_fire_armor_changed
	local on_armor_changed = client.on_armor_changed
	local on_health_changed = client.on_health_changed
	local auto_sort = cheat.do_auto_sort
	local animations = client.animations

	util:create_connection(on_gun_equipped, function(gun)
		client_info.gun_equipped = gun
	end)

	util:create_connection(on_health_changed, function(health)
		client_info.health = health
	end)

	util:create_connection(on_armor_changed, function(armor)
		client_info.armor = armor
	end)

	util:create_connection(on_fire_armor_changed, function(armor)
		client_info.fire_armor = armor
	end)

	util:create_connection(on_grabbed, function()
		client_info.grabbed = true
	end)

	util:create_connection(on_dropped, function()
		client_info.grabbed = false
	end)

	util:create_connection(on_knocked, function()
		client_info.knocked = true
	end)

	util:create_connection(on_get_up, function()
		client_info.knocked = false
	end)

	function client:is_character_loaded()
		local character = lplr.Character
		if character then 
			return character:FindFirstChild("HumanoidRootPart"), character:FindFirstChild("Humanoid")
		end
	end

	function client.on_character_added(character)
		local hrp, humanoid = character:WaitForChild("HumanoidRootPart"), character:WaitForChild("Humanoid")

		util:create_connection(character.ChildAdded, LPH_JIT(function(object)
			if object:IsA("Tool") then
				client.info.tool = object
				local handle = object:FindFirstChild("Handle")
				if handle then
					local flag = flags["forcefield_tools"]
					local default = object:FindFirstChild("Default")
					local t = flag["toggle"]
					handle.Material = t and forcefield or plastic
					handle.Color = t and flag["color"] or colorfromrgb(163, 162, 165)
					if default then
						default.Material = t and forcefield or plastic
						default.Color = t and flag["color"] or colorfromrgb(163, 162, 165)
					end 
				end

				local ammo, max_ammo = world.is_gun(object)
				if ammo and max_ammo then 
					on_gun_equipped:Fire(object)

                    task.wait()

					local on_tool_activated = util:create_connection(object.Activated, LPH_JIT(function()
						local aim_location = aimbot.aimbot_location
						if flags["anti_aim_viewer"]["toggle"] and aim_location then
							main_event:FireServer("UpdateMousePos", aim_location)
						end
					end))

					local old_ammo = ammo.Value
					local on_ammo_change = util:create_connection(ammo:GetPropertyChangedSignal("Value"), function()
						local ammo = ammo.Value
						if ammo < old_ammo then
							if ammo == 0 then
								if flags["auto_reload"]["toggle"] then
									main_event:FireServer("Reload", object)
								end
							end
							client.on_bullet_fired:Fire()
							client.recently_shot = true
							task.wait()
							task.wait()
							client.recently_shot = false
						end
						old_ammo = ammo
					end)

					local on_parent_change = nil; on_parent_change = util:create_connection(object:GetPropertyChangedSignal("Parent"), function()
						on_parent_change:Disconnect()
						on_tool_activated:Disconnect()
						on_gun_equipped:Fire(nil)
					end)
				end

				local on_parent_change = nil; on_parent_change = util:create_connection(object:GetPropertyChangedSignal("Parent"), function()
					client.info.tool = nil
					on_parent_change:Disconnect()
				end)
			end
		end))

		client_info.knocked = false
		client_info.grabbed = false

		humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not flags["no_sit"]["toggle"])

		local headless = flags["headless"]["toggle"] 
		if headless then
			local head = character:WaitForChild("Head")
			local decal = head:WaitForChild("face", 1)
			if decal then
				decal.Transparency = 1
			end
			head.Transparency = 1
		end

		local character = lplr.Character
	
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

		if flags["auto_sort"]["toggle"] and flags["on_spawn"]["toggle"] then
			auto_sort()
		end

		local body_effects = character:WaitForChild("BodyEffects", 120)
		local grabbed = body_effects:WaitForChild("Grabbed", 120)
		local knocked = body_effects:WaitForChild("K.O", 120)
		local fire_armor = body_effects:WaitForChild("FireArmor", 120)

		local armor = body_effects:WaitForChild("Armor", 120)

		on_armor_changed:Fire(armor.Value)
		on_fire_armor_changed:Fire(fire_armor.Value)

		util:create_connection(armor:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			local value = armor.Value
			on_armor_changed:Fire(value)
		end))

		util:create_connection(fire_armor:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			local value = fire_armor.Value
			on_fire_armor_changed:Fire(value)
		end))

		util:create_connection(humanoid.HealthChanged, LPH_JIT(function(health)
			on_health_changed:Fire(health)
		end))

		util:create_connection(knocked:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			local value = knocked.Value
			if value then
				on_knocked:Fire()
			else
				on_get_up:Fire()
			end
		end))

		util:create_connection(grabbed:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			local value = grabbed.Value
			if value then
				on_grabbed:Fire()
			else
				on_dropped:Fire()
			end
		end))

		local greet_animation = util.new_object("Animation", {
			AnimationId = "rbxassetid://3189777795"
		})
	
		local lay_animation = util.new_object("Animation", {
			AnimationId = "rbxassetid://3152378852"
		})
	
		if animations.greet and animations.greet.instance then
			animations.greet.instance:Destroy()
		end
		if animations.lay and animations.lay.instance then
			animations.lay.instance:Destroy()
		end
	
		animations.greet = {
			instance = greet_animation,
			loaded = humanoid:LoadAnimation(greet_animation)
		}
	
		animations.lay = {
			instance = lay_animation,
			loaded = humanoid:LoadAnimation(lay_animation)
		}
	end

	local data_folder = lplr:WaitForChild("DataFolder", 120)
	local information = data_folder:WaitForChild("Information", 120)
	local wanted = information:WaitForChild("Wanted", 120)

	local old_value = wanted.Value

	util:create_connection(wanted:GetPropertyChangedSignal("Value"), function()
		local value = wanted.Value
		if value-old_value == 50 then
			client.recently_stomped = true
			task.wait()
			task.wait()
			client.recently_stomped = false
		end
		old_value = value
	end)

	util:create_connection(lplr.CharacterAdded, client.on_character_added)
end

local clients = {}; clients.__index = clients

function clients:is_character_loaded()
	local character = self.instance.Character
	if character then 
		return character:FindFirstChild("HumanoidRootPart"), character:FindFirstChild("Humanoid")
	end
end

do
	local tween_player_value = LPH_NO_VIRTUALIZE(function(name, prop, value, old_value)
		if flags["animations"]["toggle"] and (abs(value-old_value) > 2 or prop == "ammo") then
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
			connection = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
				delta+=dt
				if delta < 0.16 then
					local tween_value = ts:GetValue((delta / 0.16), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					player[prop] = old_value + ((value-old_value)*tween_value)
				else
					connection:Disconnect()
					player[prop] = value
				end
			end))
			table.insert(tweens, {prop, connection,	value})
		else
			all_players[name][prop] = value
		end
	end)

	local on_tool_added = LPH_JIT(function(tool)
		local ammo, max_ammo = world.is_gun(tool)
		local player = tool.Parent.Name
		local character_table = all_players[player]
		character_table.tool_equipped = tool.Name
		if ammo and max_ammo then
			character_table.ammo = ammo.Value
			character_table.max_ammo = max_ammo.Value
			character_table.gun_equipped = tool.Name

			task.wait()

			local on_ammo_change = util:create_connection(ammo:GetPropertyChangedSignal("Value"), LPH_JIT(function()
				local ammo = ammo.Value
				tween_player_value(player, "ammo", ammo, character_table.ammo)
				character_table.ammo = ammo
			end))

			local on_parent_change = nil; on_parent_change = util:create_connection(tool:GetPropertyChangedSignal("Parent"), LPH_JIT(function()
				on_ammo_change:Disconnect()
				on_parent_change:Disconnect()
			end))
		end
	end)

	local on_hurt_player = client.on_hurt_player
	local on_stomped = client.on_stomped

	local on_character_added = LPH_JIT(function(character)
		local hrp, humanoid = character:WaitForChild("HumanoidRootPart"), character:WaitForChild("Humanoid")
		local character_table = all_players[character.Name]

		local body_effects = character:WaitForChild("BodyEffects", 120)
		local grabbed = body_effects:WaitForChild("Grabbed", 120)
		local knocked = body_effects:WaitForChild("K.O", 120)
		local armor = body_effects:WaitForChild("Armor", 120)
		local dead = body_effects:WaitForChild("Dead", 120)

		local name = character.Name

		local instance = players:FindFirstChild(character.Name)

		character_table.alive = true
		character_table.health = humanoid.Health
		character_table.armor = armor.Value
		character_table.knocked = false
		character_table.grabbed = false
		character_table.tool_equipped = nil
		character_table.gun_equipped = nil

		util:create_connection(armor:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			local old_armor = character_table.armor
			local armor = armor.Value
			tween_player_value(name, "armor", armor, old_armor)
		end))

		util:create_connection(humanoid.HealthChanged, LPH_NO_VIRTUALIZE(function(health)
			local old_health = character_table.health
			tween_player_value(name, "health", health, old_health)
			task.spawn(function()
				task.wait()
				if old_health > health and client.recently_shot then
					local children = character:GetChildren()
					local part = nil
					for i = 1, #children do
						local child = children[i]
						local classname = child.ClassName
						if classname == "MeshPart" then
							if child:FindFirstChild("BloodSplatter") or child:FindFirstChild("BloodParticles") then
								part = child
								break
							end
						end
					end
					on_hurt_player:Fire(instance, old_health-health, part and tostring(part) or "Accessory")
				end
			end)
		end) )

		util:create_connection(knocked:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			character_table.knocked = knocked.Value
			if knocked.Value then
				if aimbot.forced_target == instance and util:find(flags["untarget_if"]["selected"], "Knocked") then
					aimbot.forced_target = nil
					if util:find(flags["notifications"]["selected"], "Target") then
						notifications.new_notification("Unlocked target")
					end
				end
			end
		end))

		util:create_connection(dead:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			task.wait()
			if dead.Value and client.recently_stomped then 
				local hrp, hum = client:is_character_loaded()
				if (hrp.Position-character.UpperTorso.Position).magnitude < 25 then
					on_stomped:Fire(character)
				end
			end
		end))

		util:create_connection(grabbed:GetPropertyChangedSignal("Value"), LPH_JIT(function()
			character_table.grabbed = grabbed.Value
		end))

		util:create_connection(humanoid.Died, LPH_JIT(function()
			character_table.alive = false
			if aimbot.forced_target == instance and util:find(flags["untarget_if"]["selected"], "Dead") then
				aimbot.forced_target = nil
				if util:find(flags["notifications"]["selected"], "Target") then
					notifications.new_notification("Unlocked target")
				end
			end
		end))

		util:create_connection(character.ChildAdded, LPH_JIT(function(tool)
			if tool.ClassName == "Tool" then
				on_tool_added(tool)
			end
		end))

		util:create_connection(character.ChildRemoved, LPH_JIT(function(tool)
			if tool.ClassName == "Tool" then
				character_table.ammo = 0
				character_table.max_ammo = 0
				character_table.gun_equipped = nil
				character_table.tool_equipped = nil
			end
		end))

		local tool = character:FindFirstChildOfClass("Tool")
		if tool then on_tool_added(tool) end
	end)

	function clients.new(instance)
		local client2 = {
			last_position = vect3(),
			instance = instance,
			health = 100,
			armor = 0,
			knocked = false,
			grabbed = false,
			alive = false,
			opp = false,
			whitelisted = false,
			crew = 0,
			tweens = {},
			ammo = 0,
			max_ammo = 0,
			tool_equipped = nil,
			gun_equipped = nil,
			highlight = nil,
			drawings = {
				fill = util:new_drawing("Square", {
					Thickness = 1,
					Filled = true,
					ZIndex = 1
				}),
				box_outline = util:new_drawing("Square", {
					Thickness = 3,
					ZIndex = 1
				}),
				box = util:new_drawing("Square", {
					Thickness = 1,
					ZIndex = 0
				}),
				name = util:new_drawing("Text", {
					Center = true,
					Outline = true,
					Size = 18,
					ZIndex = 1,
					Text = tostring(instance),
					Font = Drawing.Fonts[2]
				}),
				display_name = util:new_drawing("Text", {
					Center = true,
					Outline = true,
					Size = 16,
					ZIndex = 1,
					Text = instance.DisplayName,
					Font = Drawing.Fonts[2]
				}),
				health_outline = util:new_drawing("Line", {
					Thickness = 4,
					ZIndex = 1,
					Color = colorfromrgb(0,0,0)
				}),
				armor_outline = util:new_drawing("Line", {
					Thickness = 4,
					ZIndex = 1,
					Color = colorfromrgb(0,0,0)
				}),
				health = util:new_drawing("Line", {
					Thickness = 2,
					ZIndex = 1
				}),
				armor = util:new_drawing("Line", {
					Thickness = 2,
					ZIndex = 1
				}),
				tool = util:new_drawing("Text", {
					Center = true,
					Outline = true,
					Size = 14,
					ZIndex = 1,
					Text = "",
					Font = Drawing.Fonts[2]
				}),
				ammo_outline = util:new_drawing("Line", {
					Thickness = 4,
					ZIndex = 1,
					Color = colorfromrgb(0,0,0)
				}),
				ammo_fill = util:new_drawing("Line", {
					Thickness = 2,
					ZIndex = 1,
					Color = colorfromrgb(0,0,0)
				}),
				health_text = util:new_drawing("Text", {
					Center = true,
					Outline = true,
					ZIndex = 1,
					Size = 14,
					Color = colorfromrgb(255,255,255)
				}),
			}
		}

		client2.highlight = util.new_object("Highlight", {
			Enabled = false,
			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
			Adornee = nil,
			Parent = gethui and gethui() or cg
		})

		util:create_connection(instance.CharacterAdded, on_character_added)

		setmetatable(client2, clients)

		local name = instance.Name

		all_players[name] = client2

		local character = instance.Character
		if character then
			on_character_added(character)
		end
		
		if util:find(client.whitelisted, name) then
			all_players[name].whitelisted = true
		end
		if util:find(client.opps, name) then
			all_players[name].opp = true
		end
	end
end

local drawing_cache = {
	fov_outline = util:new_drawing("Circle", {
		Filled = false,
        Thickness = 2,
		Color = colorfromrgb(0,0,0),
        ZIndex = 1
	}),
	fov = util:new_drawing("Circle", {
		Filled = false,
        Thickness = 1,
		Color = colorfromrgb(255,255,255),
		ZIndex = 2,
	}),
	target_tracer = util:new_drawing("Line", {
        Thickness = 2,
		Color = colorfromrgb(255,255,255)
	}),
	bounding_box = draw_3d:New3DCube(),
	desync_box = draw_3d:New3DCube(),
	tracer_circle = util:new_drawing("Circle", {
		Filled = true,
        Thickness = 1,
		Color = colorfromrgb(255,255,255),
		Radius = 8,
		ZIndex = 3,
	}),
}

do
	local pos_box = drawing_cache.bounding_box

	pos_box.Visible = false
	pos_box.ZIndex = 5
	pos_box.Thickness = 1
	pos_box.Filled = false
	pos_box.Size = vect3(1.5,3.5,1.5)
end

do
	local desync_box = drawing_cache.desync_box

	desync_box.Visible = false
	desync_box.ZIndex = 6
	desync_box.Thickness = 1
	desync_box.Filled = false
	desync_box.Size = vect3(1.5,3.5,1.5)
end

do
	local part_list = {"Head", "UpperTorso", "LowerTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm"}
	local optimized_part_list = {"Head", "UpperTorso", "LowerTorso", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm"}

	aimbot.get_closest_part = LPH_JIT(function(character)
		local closest_distance = math.huge
		local closest = character.HumanoidRootPart
		local parts_to_check = util:find(flags["optimizations"], "Use less closest parts") and optimized_part_list or part_list
	
		for i = 1, #parts_to_check do
			local part_name = parts_to_check[i]
			local part = character:FindFirstChild(part_name)
			if not part then continue end
			local pos, on_screen = camera:WorldToViewportPoint(part.Position)
			if on_screen then
				local distance = (mouse_pos - vect2(pos.X, pos.Y)).magnitude
				if distance < closest_distance then
					closest_distance = distance
					closest = part
				end
			end
		end

		return closest
	end)
end

aimbot.get_closest = LPH_JIT(function()
	local lplr_hrp = lplr.Character.HumanoidRootPart
	local lplr_pos = lplr_hrp.Position
	local fov_value = aimbot.fov_size

	local checks = flags["ignore_if"]["selected"]
	local visible_check = util:find(checks, "Not visible")
	local forcefield_check = util:find(checks, "Forcefield")
	local knocked_check = util:find(checks, "Knocked")
	local grabbed_check = util:find(checks, "Grabbed")
	local friend_check = util:find(checks, "Friend")
	local max_distance = flags["max_distance"]["value"]

	local closest = nil
	local closest_distance = 9e9

	for name, player in pairs(all_players) do
		local hrp, hum = player:is_character_loaded() 
		if hrp and hum then
			if player.health > 0 and player.alive and (hrp.Position-lplr_pos).magnitude < max_distance then
				local pos, on_screen = camera:WorldToViewportPoint(hrp.Position)
				if not on_screen then continue end
				local distance = (mouse_pos - vect2(pos.X, pos.Y)).magnitude
				if distance > fov_value then continue end
				if distance < closest_distance then
					if forcefield_check then
						if hrp.Parent:FindFirstChildOfClass("ForceField") then
							continue
						end
					end
					if knocked_check then
						if player.knocked then
							continue
						end
					end
					if grabbed_check then
						if player.grabbed then
							continue
						end
					end
					if friend_check then
						if player.instance:IsFriendsWith(lplr.UserId) or player.whitelisted then
							continue
						end
					end
					if visible_check then
						if not world.is_visible(hrp.Position, lplr_hrp.Position, {hrp, hrp.Parent, lplr.Character, workspace.Ignored}) then
							continue
						end
					end
					closest_distance = distance
					closest = hrp
				end
			end
		end
	end

	return closest and closest.Parent or nil
end)

aimbot.get_aimbot_location = LPH_JIT(function(character)
	local in_air = character.Humanoid.FloorMaterial == Enum.Material.Air
	aimbot.in_air = in_air
	local part = in_air and flags["air_part"]["selected"][1] or flags["part"]["selected"][1]
	part = (part == "Closest" and aimbot.get_closest_part(character)) or (part == "Upper torso" and character:FindFirstChild("UpperTorso")) or (part == "Lower torso" and character:FindFirstChild("LowerTorso")) or (part == "Root" and character:FindFirstChild("HumanoidRootPart")) or (part == "Head" and character:FindFirstChild("Head"))
	if not part then return nil end
	local velocity = flags["resolver"]["toggle"] and all_players[tostring(character)].velocity or character.HumanoidRootPart.Velocity
	local prediction = vect3()
	local ping = client.ping/500

	if flags["use_custom_prediction"]["toggle"] then
		prediction = (velocity * vect3(flags["horizontal_prediction"]["value"], flags["vertical_prediction"]["value"], flags["horizontal_prediction"]["value"]))
	else
		prediction = (velocity * vect3(ping, ping/2.5, ping))
	end

	if flags["shake"]["toggle"] then
		local horizontal_shake = flags["horizontal_shake"]["value"]
		local vertical_shake = flags["vertical_shake"]["value"]

		if horizontal_shake > 0 then
			if math.random(2) == 1 then
				prediction = prediction + vect3(((math.random(2) == 1) and -1 or 1) * math.random(1,horizontal_shake)/25, 0, ((math.random(2) == 1) and -1 or 1) * math.random(1,horizontal_shake)/25)
			end
		end

		if vertical_shake > 0 then
			if math.random(2) == 1 then
				prediction = prediction + vect3(0, ((math.random(2) == 1) and -1 or 1) * math.random(1,horizontal_shake)/25, 0)
			end
		end
	end

	aimbot.prediction = prediction

	return part.Position + prediction
end)


-- * Menu Setup

local window = lib.new(); window:set_accent_color(colorfromrgb(189, 172, 255))
local selected_config = nil

local combat = window:new_tab("Combat")
    local combat_aimbot = combat:new_subtab("Aimbot")
		local aimbot_general = combat_aimbot:new_section({name = "General", side = "left", size = 360})
			local aimbot_enabled = aimbot_general:new_element({name = "Aimbot", flag = "aimbot", types = {toggle = {}, keybind = {method = "always"}}}) keybind.new("Aimbot", aimbot_enabled, "aimbot")
			local type = aimbot_general:new_element({name = "Type", flag = "type", types = {dropdown = {default = {"Closest"}, no_none = true, options = {"Target aim", "Closest"}}}})
			local target_bind = aimbot_general:new_element({name = "Target bind", flag = "target_bind", types = {keybind = {method = "toggle", method_lock = true}}}); lib:set_dropdown_dependent(target_bind, type, "Target aim")
			local untarget_when = aimbot_general:new_element({name = "Untarget if", flag = "untarget_if", types = {dropdown = {options = {"Knocked", "Dead"}, multi = true}}}); lib:set_dropdown_dependent(untarget_when, type, "Target aim")
			local dont_aim_if = aimbot_general:new_element({name = "Don't aim if", flag = "dont_aim_if", types = {dropdown = {options = {"Outside of fov", "Not visible"}, default = {"Outside of fov"}, multi = true}}}); lib:set_dropdown_dependent(dont_aim_if, type, "Target aim")
			local part = aimbot_general:new_element({name = "Part", flag = "part", types = {dropdown = {no_none = true, default = {"Closest"}, options = {"Upper torso", "Lower torso", "Closest", "Root", "Head"}}}})
			local air_part = aimbot_general:new_element({name = "Air part", flag = "air_part", types = {dropdown = {no_none = true, default = {"Closest"}, options = {"Upper torso", "Lower torso", "Closest", "Root", "Head"}}}})
			local ignore_if = aimbot_general:new_element({name = "Ignore if", flag = "ignore_if", types = {dropdown = {options = {"Not visible", "Forcefield", "Knocked", "Grabbed", "Friend", "Dead"}, multi = true}}})
			local optimizations = aimbot_general:new_element({name = "Optimizations", flag = "optimizations", types = {dropdown = {options = {"Use less closest parts"}, multi = true}}})
		local aimbot_other = combat_aimbot:new_section({name = "Other", side = "right", size = 155})
		local horizontal_prediction;
		local vertical_prediction;
		do
			local use_custom_prediction = aimbot_other:new_element({name = "Use custom prediction", flag = "use_custom_prediction", types = {toggle = {}}})
			horziontal_prediction = aimbot_other:new_element({name = "Horizontal prediction", flag = "horizontal_prediction", types = {slider = {min = 0.08, max = 0.250, decimals = 3}}}); lib:set_dependent(horziontal_prediction, use_custom_prediction)
			vertical_prediction = aimbot_other:new_element({name = "Vertical prediction", flag = "vertical_prediction", types = {slider = {min = 0.00, max = 0.250, decimals = 3}}}); lib:set_dependent(vertical_prediction, use_custom_prediction)
			local max_distance = aimbot_other:new_element({name = "Max distance", flag = "max_distance", types = {slider = {min = 75, max = 25000, suffix = "m", default = 10000}}})
			local silent_aim = aimbot_other:new_element({name = "Silent aim", flag = "silent_aim", types = {toggle = {}}})
			local anti_aim_viewer = aimbot_other:new_element({name = "Anti aim viewer", flag = "anti_aim_viewer", types = {toggle = {}}}); lib:set_dependent(anti_aim_viewer, silent_aim)
			local mouse_tp = aimbot_other:new_element({name = "Mouse tp", flag = "mouse_tp", types = {toggle = {}, keybind = {method = "toggle", method_lock = true}}})
			local tp_part = aimbot_other:new_element({name = "Part", flag = "tp_part", types = {dropdown = {options = {"Lower torso", "Head"}, no_none = true, default = {"Lower torso"}}}}); lib:set_dependent(tp_part, mouse_tp)
			local resolver = aimbot_other:new_element({name = "Resolver", flag = "resolver", types = {toggle = {}}})
			local refresh_rate = aimbot_other:new_element({name = "Refresh rate", flag = "refresh_rate", types = {slider = {min = 1, max = 100, suffix = "ms"}}}); lib:set_dependent(refresh_rate, resolver)
			local camlock = aimbot_other:new_element({name = "Camlock", flag = "camlock", types = {toggle = {}}}); util:create_connection(camlock.on_toggle, function(t)
				if not t then
					util:tween(camera, twinfo(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = camera.CFrame})
				end
			end)
			local style = aimbot_other:new_element({name = "Style", flag = "style", types = {dropdown = {options = {"Circular", "Linear", "Sine", "Quad"}, default = {"Sine"}, no_none = true}}}); lib:set_dependent(style, camlock)
			local air_speed = aimbot_other:new_element({name = "Air speed", flag = "air_speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(air_speed, camlock)
			local speed = aimbot_other:new_element({name = "Speed", flag = "speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(speed, camlock)
			local camlock_disablers = aimbot_other:new_element({name = "Disablers", flag = "camlock_disablers", types = {dropdown = {options = {"Third person", "No gun"}, multi = true}}}); lib:set_dependent(camlock_disablers, camlock)
			local look_at = aimbot_other:new_element({name = "Look at", flag = "look_at", types = {toggle = {}}})
			local shake = aimbot_other:new_element({name = "Shake", flag = "shake", types = {toggle = {}}})
			local horizontal_shake = aimbot_other:new_element({name = "Horizontal", flag = "horizontal_shake", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(horizontal_shake, shake)
			local vertical_shake = aimbot_other:new_element({name = "Vertical", flag = "vertical_shake", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(vertical_shake, shake)
		end
		local aimbot_visualization = combat_aimbot:new_section({name = "Visualization", side = "right", size = 360})
		do
			local field_of_view = aimbot_visualization:new_element({name = "Field of view", flag = "field_of_view", types = {slider = {min = 1, max = 200}}})
			local dynamic_fov = aimbot_visualization:new_element({name = "Dynamic", flag = "dynamic_fov", tip = "Changes the FOV based on range", types = {toggle = {}}})
			local dynamic_minimum = aimbot_visualization:new_element({name = "Minimum", flag = "dynamic_minimum", tip = "Minimum FOV size", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(dynamic_minimum, dynamic_fov)
			local show_fov = aimbot_visualization:new_element({name = "Show fov", flag = "show_fov", types = {toggle = {}, colorpicker = {}}}); util:create_connection(show_fov.on_toggle, function(t)
				drawing_cache.fov.Visible = t
				drawing_cache.fov_outline.Visible = t and flags["fov_outline"]["toggle"] or false
			end); util:create_connection(show_fov.on_color_change, function(c)
				drawing_cache.fov.Color = c
			end); util:create_connection(show_fov.on_transparency_change, function(t)
				drawing_cache.fov.Transparency = -t+1
				drawing_cache.fov_outline.Transparency = -t+1
			end)
			local outline = aimbot_visualization:new_element({name = "Outline", flag = "fov_outline", types = {toggle = {}}}); lib:set_dependent(outline, show_fov); util:create_connection(outline.on_toggle, function(t)
				drawing_cache.fov_outline.Visible = (t and drawing_cache.fov.Visible) and true or false
			end)
			local filled = aimbot_visualization:new_element({name = "Filled", flag = "fov_filled", types = {toggle = {}}}); lib:set_dependent(filled, show_fov); util:create_connection(filled.on_toggle, function(t)
				drawing_cache.fov.Filled = t
			end)
		end
	local other_aimbot = combat:new_subtab("Other")
		local other_general = other_aimbot:new_section({name = "General", side = "left", size = 360})
			local target_strafe = other_general:new_element({name = "Target strafe", flag = "target_strafe", types = {toggle = {}, keybind = {}}}); keybind.new("Target strafe", target_strafe, "target_strafe")
			do
			local horizontal_distance = other_general:new_element({name = "Horizontal distance", flag = "horizontal_distance", types = {slider = {min = 1, max = 12}}}); lib:set_dependent(horizontal_distance, target_strafe)
			local vertical_distance = other_general:new_element({name = "Vertical distance", flag = "vertical_distance", types = {slider = {min = 1, max = 12}}}); lib:set_dependent(vertical_distance, target_strafe)
			local angle = other_general:new_element({name = "Angle", flag = "strafe_angle", types = {slider = {min = 1, max = 15, suffix = "°"}}}); lib:set_dependent(angle, target_strafe)
			end
local player_ = window:new_tab("Player")
	local player_general = player_:new_subtab("General")
		local movement_ = player_general:new_section({name = "Movement", side = "left", size = 200})
		do
			local no_jump_cooldown = movement_:new_element({name = "No jump cooldown", flag = "no_jump_cooldown", types = {toggle = {}}})
			local no_slowdowns = movement_:new_element({name = "No slowdowns", flag = "no_slowdowns", types = {toggle = {}}})
		end
			local cframe_speed = movement_:new_element({name = "CFrame speed", flag = "cframe_speed", types = {toggle = {}, keybind = {}}}); keybind.new("CFrame speed", cframe_speed, "cframe_speed")
			local cf_speed = movement_:new_element({name = "Speed", flag = "cf_speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(cf_speed, cframe_speed)
			local cframe_fly = movement_:new_element({name = "CFrame fly", flag = "cframe_fly", types = {toggle = {}, keybind = {}}}); keybind.new("CFrame fly", cframe_fly, "cframe_fly")
			local down_key = movement_:new_element({name = "Down key", flag = "down_key", types = {keybind = {method_lock = true, method = "hold", key = "c"}}}); lib:set_dependent(down_key, cframe_fly)
			local y_factor = movement_:new_element({name = "Y factor", flag = "y_factor", types = {slider = {min = 1, max = 10}}}); lib:set_dependent(y_factor, cframe_fly)
			local fly_speed = movement_:new_element({name = "Speed", flag = "fly_speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(fly_speed, cframe_fly)
			local spinbot = movement_:new_element({name = "Spinbot", flag = "spinbot", types = {toggle = {}, slider = {min = 1, max = 180, suffix = "°"}}})
			local noclip = movement_:new_element({name = "Noclip", flag = "noclip", types = {toggle = {}, keybind = {}}}); keybind.new("Noclip", noclip, "noclip")
			do
			local greet_ = movement_:new_element({name = "Greet", flag = "greet", types = {keybind = {method = "toggle", method_lock = true}}})
			local lay_ = movement_:new_element({name = "Lay", flag = "lay", types = {keybind = {method = "toggle", method_lock = true}}})
			end
		local anti_aim = player_general:new_section({name = "Anti aim", side = "left", size = 135})
			local cframe_desync = nil
			local anti_lock = nil
			do
			local desync_box = drawing_cache.desync_box
			local physics_rate = anti_aim:new_element({name = "Physics sender rate", flag = "physics_rate", tip = "Changes the S2PhysicsSenderRate fflag", types = {slider = {min = 1, max = 100, default = 15}}}); physics_rate.on_value_change:Connect(function(val)
				setfflag("S2PhysicsSenderRate", tostring(val))
			end)
			cframe_desync = anti_aim:new_element({name = "CFrame desync", flag = "cframe_desync", types = {toggle = {}, keybind = {}}}); keybind.new("CFrame desync", cframe_desync, "cframe_desync")
			local show_model = anti_aim:new_element({name = "Show model", flag = "show_model", types = {toggle = {}, colorpicker = {}}}); lib:set_dependent(show_model, cframe_desync)
			util:create_connection(show_model.on_color_change, function(c)
				desync_box.Color = c
			end); util:create_connection(show_model.on_transparency_change, function(t)
				desync_box.Transparency = -t+1
			end)
			local horizontal_offset = anti_aim:new_element({name = "Horizontal offset", flag = "horizontal_offset", types = {slider = {min = 1, max = 16}}}); lib:set_dependent(horizontal_offset, cframe_desync)
			local vertical_offset = anti_aim:new_element({name = "Vertical offset", flag = "vertical_offset", types = {slider = {min = 1, max = 16}}}); lib:set_dependent(vertical_offset, cframe_desync)
			local randomization = anti_aim:new_element({name = "Randomization", flag = "randomization_", types = {slider = {min = 0, max = 100, suffix = "%"}}}); lib:set_dependent(randomization, cframe_desync)
			anti_lock = anti_aim:new_element({name = "Anti lock", flag = "anti_lock", types = {toggle = {}, keybind = {}}}); keybind.new("Anti lock", anti_lock, "anti_lock")
			local lock_type = anti_aim:new_element({name = "Anti type", flag = "lock_type", types = {dropdown = {options = {"Underground", "Zero", "Sky", "Rage", "Void"}, default = {"Zero"}, no_none = true}}}); lib:set_dependent(lock_type, anti_lock)
			end
		local utilities = player_general:new_section({name = "Utilities", side = "right", size = 360})
			do
			local no_void_kill = utilities:new_element({name = "No void kill", flag = "no_void_kill", types = {toggle = {}}}); no_void_kill.on_toggle:Connect(function(t)
				workspace.FallenPartsDestroyHeight = t and -9e9 or -500
			end)	
			local auto_reload = utilities:new_element({name = "Auto reload", flag = "auto_reload", types = {toggle = {}}})
			auto_shoot = utilities:new_element({name = "Auto shoot", flag = "auto_shoot", types = {toggle = {}, keybind = {}}}); keybind.new("Auto shoot", auto_shoot, "auto_shoot"); util:create_connection(auto_shoot.on_deactivate, function()
				local character = lplr.Character
				if character then
					local tool = character:FindFirstChildOfClass("Tool")
					if tool then
						tool:Deactivate()
					end
				end
			end); util:create_connection(auto_shoot.on_toggle, function(t)
				if t then return end
				local character = lplr.Character
				if character then
					local tool = character:FindFirstChildOfClass("Tool")
					if tool then
						tool:Deactivate()
					end
				end
			end)
			local money_aura = utilities:new_element({name = "Money aura", flag = "money_aura", types = {toggle = {}}})
			local auto_stomp = utilities:new_element({name = "Auto stomp", flag = "auto_stomp", types = {toggle = {}}})
			local no_sit = utilities:new_element({name = "No sit", flag = "no_sit", types = {toggle = {}}})
			util:create_connection(no_sit.on_toggle, function(t)
				local character = lplr.Character
				if character then
					local humanoid = lplr.Character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not t)
					end
				end
			end)
			local auto_sort = utilities:new_element({name = "Auto sort", flag = "auto_sort", types = {toggle = {}, keybind = {method = "toggle", method_lock = true}}})
			local on_spawn = utilities:new_element({name = "On spawn", flag = "on_spawn", tip = "Auto sorts automatically when you respawn & ignores keybind", types = {toggle = {}}})lib:set_dependent(on_spawn, auto_sort)
			for i = 1, 9 do
				local x = utilities:new_element({name = "Slot "..tostring(i), flag = "slot_"..tostring(i), types = {textbox = {}}})
				lib:set_dependent(x, auto_sort)
			end
			local force_reset = utilities:new_element({name = "Force reset", flag = "", types = {button = {}}}); force_reset.on_clicked:Connect(function()
				local character = lplr.Character
				if character then
					local hum = character:FindFirstChildOfClass("Humanoid")
					if hum then
						hum.Health = 0
					end 
				end
			end)
			end
	local player_other = player_:new_subtab("Other")
		local purchases_ = player_other:new_section({name = "Purchases", side = "left", size = 360})
			local auto_fire_armor = purchases_:new_element({name = "Auto fire armor", flag = "auto_fire_armor", types = {toggle = {}}})
			local fire_threshold = purchases_:new_element({name = "Threshold", flag = "fire_threshold", types = {slider = {min = 1, max = 100, suffix = "%", default = 50}}}); lib:set_dependent(fire_threshold, auto_fire_armor)
			local auto_armor = purchases_:new_element({name = "Auto armor", flag = "auto_armor", types = {toggle = {}}})
			local threshold = purchases_:new_element({name = "Threshold", flag = "threshold", types = {slider = {min = 1, max = 100, suffix = "%", default = 50}}}); lib:set_dependent(threshold, auto_armor)
			local selected_weapon = purchases_:new_element({name = "Gun", flag = "gun_", types = {multibox = {maxsize = 5}}})
			local weapon_ammo = purchases_:new_element({name = "Ammo", flag = "ammo_", types = {slider = {min = 0, max = 20, suffix = "x"}}})
			local purchase_weapon = purchases_:new_element({name = "Purchase gun", flag = "weapon_", types = {button = {}}})
			local selected_food_ = nil
			local selected_weapon_ = nil
			util:create_connection(selected_weapon.on_option_change, function(option)
				selected_weapon_ = option
			end)
			local selected_food = purchases_:new_element({name = "Food", flag = "food", types = {multibox = {maxsize = 5}}})
			util:create_connection(selected_food.on_option_change, function(option)
				selected_food_ = option
			end)
			local purchase_food = purchases_:new_element({name = "Purchase food", flag = "food_", types = {button = {}}})
			local purchase_fire_armor = purchases_:new_element({name = "Purchase fire armor", flag = "fire_armor_", types = {button = {}}}); util:create_connection(purchase_fire_armor.on_clicked, function()
				cheat.purchase_fire_armor()
			end)
			local purchase_armor = purchases_:new_element({name = "Purchase armor", flag = "armor_", types = {button = {}}}); util:create_connection(purchase_armor.on_clicked, function()
				cheat.purchase_armor()
			end)
local visuals = window:new_tab("Visuals")
	local visuals_players = visuals:new_subtab("Players")
		local player_esp = visuals_players:new_section({name = "Player esp", side = "left", size = 360})
		do
			local esp_enabled = player_esp:new_element({name = "Enabled", flag = "esp", types = {toggle = {}}})
			local box = player_esp:new_element({name = "Box", flag = "box", types = {colorpicker = {color = colorfromrgb(255,255,255)}, toggle = {}}})
			local box_outline = player_esp:new_element({name = "Outline", flag = "box_outline", types = {toggle = {}}}); lib:set_dependent(box_outline, box)
			local fill = player_esp:new_element({name = "Fill", flag = "fill", types = {colorpicker = {color = colorfromrgb(255,255,255), transparency = 0.5}, toggle = {}}})
			local name = player_esp:new_element({name = "Name", flag = "name", types = {colorpicker = {color = colorfromrgb(255,255,255)}, toggle = {}}})
			local show_display = player_esp:new_element({name = "Show display", flag = "show_display", types = {colorpicker = {color = colorfromrgb(126,126,126)}, toggle = {}}})
			local name_outline = player_esp:new_element({name = "Outline", flag = "name_outline", types = {toggle = {}}}); lib:set_dependent(name_outline, name)
			local tool_ = player_esp:new_element({name = "Tool", flag = "tool", types = {colorpicker = {color = colorfromrgb(255,255,255)}, toggle = {}}})
			local armor = player_esp:new_element({name = "Armor", flag = "armor", types = {toggle = {}, colorpicker = {color = colorfromrgb(0,0,255)}, dropdown = {options = {"Overlay", "Bar"}, no_none = true, default = {"Overlay"}}}})
			local ammo_bar = player_esp:new_element({name = "Ammo bar", flag = "ammo_bar", types = {colorpicker = {color = colorfromrgb(0,255,255)}, toggle = {}}})
			local highlight = player_esp:new_element({name = "Highlight", flag = "highlight", types = {colorpicker = {color = colorfromrgb(255,0,0)}, toggle = {}}})
			local outline = player_esp:new_element({name = "Outline", flag = "outline", types = {colorpicker = {color = colorfromrgb(255,0,0)}}}); lib:set_dependent(outline, highlight)
			local health_bar = player_esp:new_element({name = "Health bar", flag = "health_bar", types = {colorpicker = {color = colorfromrgb(0,255,0)}, toggle = {}}})
			local dynamic_color = player_esp:new_element({name = "Dynamic color", flag = "dynamic_color", types = {toggle = {}}}); lib:set_dependent(dynamic_color, health_bar)
			local show_number = player_esp:new_element({name = "Show number", flag = "show_number", types = {toggle = {}, colorpicker = {}}}); lib:set_dependent(show_number, health_bar)
			local animations = player_esp:new_element({name = "Animations", flag = "animations", types = {toggle = {}}})
			local specifics_only = player_esp:new_element({name = "Specifics only", flag = "specifics_only", types = {toggle = {}}})
			local filter = player_esp:new_element({name = "Filter", flag = "filter", types = {dropdown = {options = {"Friendly", "Target", "Opp"}, multi = true}}}); lib:set_dependent(filter, specifics_only)
			local max_esp_distance = player_esp:new_element({name = "Max distance", flag = "max_esp_distance", types = {slider = {min = 100, max = 10000, suffix = "m"}}})
		end
		local players_target = visuals_players:new_section({name = "Target esp", side = "right", size = 200})
		do
			local bounding_box = players_target:new_element({name = "Bounding box", flag = "bounding_box", types = {colorpicker = {color = colorfromrgb(255,255,255)}, toggle = {}}}); util:create_connection(bounding_box.on_color_change, function(c)
				drawing_cache.bounding_box.Color = c
			end); util:create_connection(bounding_box.on_transparency_change, function(t)
				drawing_cache.bounding_box.Transparency = -t+1
			end)
			local box_filled = players_target:new_element({name = "Filled", flag = "box_filled", types = {toggle = {}}}); lib:set_dependent(box_filled, bounding_box); util:create_connection(box_filled.on_toggle, function(t)
				drawing_cache.bounding_box.Filled = t
			end)
			local tracer_line = players_target:new_element({name = "Tracer line", flag = "target_tracer", types = {colorpicker = {color = colorfromrgb(255,255,255)}, toggle = {}}}); util:create_connection(tracer_line.on_color_change, function(c)
				drawing_cache.target_tracer.Color = c
			end); util:create_connection(tracer_line.on_transparency_change, function(t)
				drawing_cache.target_tracer.Transparency = -t+1
			end)
			local tracer_origin = players_target:new_element({name = "Origin", flag = "tracer_origin", types = {dropdown = {no_none = true, default = {"Character"}, options = {"Character", "Mouse"}}}}); lib:set_dependent(tracer_origin, tracer_line)
			local tracer_position = players_target:new_element({name = "Position", flag = "tracer_position", types = {dropdown = {no_none = true, default = {"Character"}, options = {"Character", "Predicted"}}}}); lib:set_dependent(tracer_position, tracer_line)
			local tracer_circle = players_target:new_element({name = "Circle", flag = "tracer_circle", types = {colorpicker = {color = colorfromrgb(255,255,255)}, toggle = {}}}); util:create_connection(tracer_circle.on_color_change, function(c)
				drawing_cache.tracer_circle.Color = c
			end); util:create_connection(tracer_circle.on_transparency_change, function(t)
				drawing_cache.tracer_circle.Transparency = -t+1
			end)
			local tracer_circle_size = players_target:new_element({name = "Size", flag = "tracer_circle_size", types = {slider = {min = 1, max = 10}}}); util:create_connection(tracer_circle_size.on_value_change, function(v)
				drawing_cache.tracer_circle.Radius = v
			end); lib:set_dependent(tracer_circle_size, tracer_circle)
		end
		local players_self = visuals_players:new_section({name = "Self esp", side = "right", size = 360})
			local forcefield_tools = players_self:new_element({name = "Forcefield tools", flag = "forcefield_tools", types = {toggle = {}, colorpicker = {}}})
			local forcefield_body = players_self:new_element({name = "Forcefield body", flag = "forcefield_body", types = {toggle = {}, colorpicker = {}}}); util:create_connection(forcefield_body.on_toggle, function(t)
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
			local forcefield_hats = players_self:new_element({name = "Forcefield hats", flag = "forcefield_hats", types = {toggle = {}, colorpicker = {}}}); util:create_connection(forcefield_hats.on_toggle, function(t)
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
								part.Color = t and color or colorfromrgb(163, 162, 165)
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
			local headless = players_self:new_element({name = "Headless", flag = "headless", types = {toggle = {}}}); util:create_connection(headless.on_toggle, function(t)
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
	local visuals_other = visuals:new_subtab("Other")
		local other_world = visuals_other:new_section({name = "World", side = "left", size = 360})
		do
			local bullet_tracers = other_world:new_element({name = "Local bullet tracers", flag = "bullet_tracers", types = {toggle = {}, colorpicker = {color = colorfromrgb(255,0,0)}}})
			local lifetime = other_world:new_element({name = "Lifetime", flag = "lifetime", types = {slider = {min = 0.1, max = 5, default = 0.5, suffix = "s", decimal = 1}}}); lib:set_dependent(lifetime, bullet_tracers)
			local texture = other_world:new_element({name = "Texture", flag = "texture", types = {textbox = {text = "rbxassetid://446111271"}}}); lib:set_dependent(texture, bullet_tracers)
			local beam_fade = other_world:new_element({name = "Fade", flag = "beam_fade", types = {toggle = {}}}); lib:set_dependent(beam_fade, bullet_tracers)
			local bullet_impacts = other_world:new_element({name = "Local bullet impacts", flag = "bullet_impacts", types = {toggle = {}, colorpicker = {color = colorfromrgb(255,0,0)}}})
			local impact_fade = other_world:new_element({name = "Fade", flag = "impact_fade", types = {toggle = {}}}); lib:set_dependent(impact_fade, bullet_impacts)
			local impact_lifetime = other_world:new_element({name = "Lifetime", flag = "impact_lifetime", types = {slider = {min = 0.1, max = 5, default = 0.5, suffix = "s", decimal = 1}}}); lib:set_dependent(impact_lifetime, bullet_impacts)
			local impact_size = other_world:new_element({name = "Size", flag = "impact_size", types = {slider = {min = 0.1, max = 1.5, default = 0.5, suffix = "", decimal = 1}}}); lib:set_dependent(impact_size, bullet_impacts)	
			local other_bullet_tracers = other_world:new_element({name = "Other bullet tracers", flag = "other_bullet_tracers", types = {toggle = {}, colorpicker = {color = colorfromrgb(255,0,0)}}})
			local other_lifetime = other_world:new_element({name = "Lifetime", flag = "other_lifetime", types = {slider = {min = 0.1, default = 0.5, max = 5, suffix = "s", decimal = 1}}}); lib:set_dependent(other_lifetime, other_bullet_tracers)
			local texture = other_world:new_element({name = "Texture", flag = "other_texture", types = {textbox = {text = "rbxassetid://446111271"}}}); lib:set_dependent(texture, other_bullet_tracers)
			local beam_fade = other_world:new_element({name = "Fade", flag = "other_beam_fade", types = {toggle = {}}}); lib:set_dependent(beam_fade, other_bullet_tracers)
			local stomp_effect = other_world:new_element({name = "Stomp effect", flag = "stomp_effect", types = {dropdown = {options = {"Lightning", "Soul", "Fade"}, no_none = true, default = {"Fade"}}, toggle = {}}})
			local hit_sound = other_world:new_element({name = "Hit sound", flag = "hit_sound", types = {toggle = {}}})
			local volume = other_world:new_element({name = "Volume", flag = "volume", types = {slider = {min = 0.1, max = 5, default = 1, decimal = 1}}}); lib:set_dependent(volume, hit_sound)
			local sound = other_world:new_element({name = "Sound", flag = "sound", types = {dropdown = {options = {"Minecraft", "Gamesense", "Neverlose", "Bameware", "Custom", "Bubble", "RIFK7", "Rust", "Cod"}, no_none = true, default = {"Minecraft"}}}}); lib:set_dependent(sound, hit_sound)
			local sound_id = other_world:new_element({name = "ID", flag = "sound_id", types = {textbox = {}}}); lib:set_dropdown_dependent(sound_id, sound, "Custom"); hit_sound.on_toggle:Connect(function(t)
				sound_id:set_visible(false)
				if t then
					sound_id:set_visible(flags["sound"]["selected"][1] == "Custom")
				end
			end)
			local hit_effect = other_world:new_element({name = "Hit effect", flag = "hit_effect", types = {colorpicker = {}, toggle = {}}})
			local effect = other_world:new_element({name = "Effect", flag = "effect", types = {dropdown = {options = {"Confetti", "Bubble", "Sparks", "Stars"}, no_none = true, default = {"Confetti"}}}}); lib:set_dependent(effect, hit_effect)
			local hitmarker = other_world:new_element({name = "Hitmarker", flag = "hitmarker", types = {toggle = {}, colorpicker = {}}})
			local hitmarker_size = other_world:new_element({name = "Size", flag = "hitmarker_size", types = {slider = {min = 5, max = 100}}}); lib:set_dependent(hitmarker_size, hitmarker)
			local hitmarker_gap = other_world:new_element({name = "Gap", flag = "hitmarker_gap", types = {slider = {min = 5, max = 100}}}); lib:set_dependent(hitmarker_gap, hitmarker)
			local hit_chams = other_world:new_element({name = "Hit chams", flag = "hit_chams", types = {toggle = {}, colorpicker = {}}})
			local hit_chams_fade = other_world:new_element({name = "Fade", flag = "hit_chams_fade", types = {toggle = {}}}); lib:set_dependent(hit_chams_fade, hit_chams)
			local hit_chams_lifetime = other_world:new_element({name = "Lifetime", flag = "hit_chams_lifetime", types = {slider = {min = 0.1, max = 5, decimals = 1, suffix = "s"}}}); lib:set_dependent(hit_chams_lifetime, hit_chams)
			local hit_chams_material = other_world:new_element({name = "Material", flag = "hit_chams_material", types = {dropdown = {options = {"ForceField", "Glass", "Neon"}}}}); lib:set_dependent(hit_chams_material, hit_chams)
		end
		local other_game = visuals_other:new_section({name = "Game", side = "Right", size = 200})
		do
			local color_shift_bottom = other_game:new_element({name = "Color shift bottom", flag = "color_shift_bottom", types = {toggle = {}, colorpicker = {}}}); util:create_connection(color_shift_bottom.on_toggle, function(t)
				if t then
					lighting.ColorShift_Bottom = flags["color_shift_bottom"]["color"]
				else
					lighting.ColorShift_Bottom = cache.color_shift_bottom
				end
			end); util:create_connection(color_shift_bottom.on_color_change, function(c)
				if flags["color_shift_bottom"]["toggle"] then
					lighting.ColorShift_Bottom = c
				end
			end)
			local color_shift_top = other_game:new_element({name = "Color shift top", flag = "color_shift_top", types = {toggle = {}, colorpicker = {}}}); util:create_connection(color_shift_top.on_toggle, function(t)
				if t then
					lighting.ColorShift_Top = flags["color_shift_top"]["color"]
				else
					lighting.ColorShift_Top = cache.color_shift_top
				end
			end); util:create_connection(color_shift_top.on_color_change, function(c)
				if flags["color_shift_top"]["toggle"] then
					lighting.ColorShift_Top = c
				end
			end)
			local exposure_changer = other_game:new_element({name = "Exposure changer", flag = "exposure", types = {toggle = {}}}); util:create_connection(exposure_changer.on_toggle, function(t)
				if t then
					lighting.ExposureCompensation = flags["compensation"]["value"]
				else
					lighting.ExposureCompensation = cache.compensation
				end
			end)
			local compensation = other_game:new_element({name = "Compensation", flag = "compensation", types = {slider = {min = -2, max = 3, decimal = 1, default = cache.compensation}}}); util:create_connection(compensation.on_value_change, function(v)
				if flags["exposure"]["toggle"] then
					lighting.ExposureCompensation = v
				end
			end); lib:set_dependent(compensation, exposure_changer)
			local field_of_view2 = other_game:new_element({name = "Field of view", flag = "field_of_view2", types = {toggle = {}}}); field_of_view2.on_toggle:Connect(function(t)
				camera.FieldOfView = t and flags["fov_value"]["value"] or cache.fov
			end)
			local fov_value = other_game:new_element({name = "FOV", flag = "fov_value", types = {slider = {min = 70, max = 120, suffix = "°"}}}); lib:set_dependent(fov_value, field_of_view2); fov_value.on_value_change:Connect(function(val)
				camera.FieldOfView = flags["field_of_view2"]["toggle"] and val or cache.fov
			end)
			local aspect_ratio = other_game:new_element({name = "Aspect ratio", flag = "aspect_ratio", types = {toggle = {}}})
			local ratio = other_game:new_element({name = "Ratio", flag = "ratio", types = {slider = {min = 1, max = 100, default = 100, decimal = 1, suffix = "%"}}}); lib:set_dependent(ratio, aspect_ratio)
			local fog_changer = other_game:new_element({name = "Fog changer", flag = "fog_changer", types = {toggle = {}, colorpicker = {color = lighting.FogColor}}}); util:create_connection(fog_changer.on_toggle, function(t)
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
			local fog_start = other_game:new_element({name = "Fog start", flag = "fog_start", types = {slider = {min = 1, max = 5000, default = lighting.FogStart}}}); lib:set_dependent(fog_start, fog_changer)
			util:create_connection(fog_start.on_value_change, function(v)
				if flags["fog_changer"]["toggle"] then
					lighting.FogStart = v
				end
			end)
			local fog_end = other_game:new_element({name = "Fog end", flag = "fog_end", types = {slider = {min = 1, max = 5000, default = lighting.FogEnd}}}); lib:set_dependent(fog_end, fog_changer)
			util:create_connection(fog_end.on_value_change, function(v)
				if flags["fog_changer"]["toggle"] then
					lighting.FogEnd = v
				end
			end)
			local no_shadows = other_game:new_element({name = "No shadows", flag = "no_shadows", types = {toggle = {}}}); util:create_connection(no_shadows.on_toggle, function(t)
				lighting.GlobalShadows = not t
			end)
			local brightness = other_game:new_element({name = "Brightness", flag = "brightness", types = {toggle = {}, slider = {min = 0, max = 15, decimal = 1, default = util:round(lighting.Brightness, 1)}}}); util:create_connection(brightness.on_toggle, function(t)
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
			local world_time = other_game:new_element({name = "World time", flag = "world_time", types = {toggle = {}, slider = {min = 1, max = 24, decimal = 1, default = util:round(lighting.ClockTime, 1)}}}); util:create_connection(world_time.on_toggle, function(t)
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
			local world_hue = other_game:new_element({name = "World hue", flag = "world_hue", types = {toggle = {}, colorpicker = {color = lighting.Ambient}}}); util:create_connection(world_hue.on_toggle, function(t)
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
		end
		local other_hud = visuals_other:new_section({name = "Other", side = "Right", size = 140})
			do
			local keybind_list = other_hud:new_element({name = "Keybinds list", flag = "keybind_list", types = {toggle = {}, colorpicker = {transparency = 0.880}}}); util:create_connection(keybind_list.on_toggle, function(t)
				keybind:set_list_visible(t)
			end); util:create_connection(keybind_list.on_color_change, function(c)
				keybind:set_color(c)
			end); util:create_connection(keybind_list.on_transparency_change, function(t)
				keybind:set_transparency(t)
			end)
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
			local spin_speed = other_hud:new_element({name = "Speed", flag = "spin_speed", types = {slider = {min = 1, max = 100, suffix = "%"}}}); lib:set_dependent(spin_speed, spinning_crosshair)
			local infinite_zoom = other_hud:new_element({name = "Infinite zoom", flag = "infinite_zoom", types = {toggle = {}}}); util:create_connection(infinite_zoom.on_toggle, function(t)
				lplr.CameraMaxZoomDistance = t and 9e9 or cache.max_zoom_distance
			end)
			local no_flashbang = other_hud:new_element({name = "No flashbang", flag = "no_flashbang", types = {toggle = {}}})
			local no_recoil = other_hud:new_element({name = "No recoil", flag = "no_recoil", types = {toggle = {}}})
			local show_chat = other_hud:new_element({name = "Show chat", flag = "show_chat", types = {toggle = {}}}); show_chat.on_toggle:Connect(function(t)
				local plrgui = lplr.PlayerGui
				if plrgui then
					plrgui.Chat.Frame.ChatChannelParentFrame.Visible = t
				end
			end)
			local no_blur = other_hud:new_element({name = "No blur", flag = "no_blur", tip = "Removes the blur from pepper spray", types = {toggle = {}}})
			end
local settings_ = window:new_tab("Settings")
    local misc_general = settings_:new_subtab("General")
        local general_configurations = misc_general:new_section({name = "Configurations", side = "left", size = 360})
            local config_name = general_configurations:new_element({name = "Config name", flag = "config_name", types = {textbox = {}, no_load = true}})
            local save_config = general_configurations:new_element({name = "Update config", flag = "save_config", types = {button = {confirmation = {top = "Update config", text = "Are you sure you want to update this config?"}}}})
            local create_config = general_configurations:new_element({name = "Create config", flag = "create_config", types = {button = {}}})
            local config_list = general_configurations:new_element({name = "", flag = "config_list", types = {multibox = {maxsize = 5}}})
            local load_config = general_configurations:new_element({name = "Load config", flag = "load_config", types = {button = {confirmation = {top = "Load config", text = "Are you sure you want to load this config?"}}}})
            local refresh_configs = general_configurations:new_element({name = "Refresh configs", flag = "refresh_configs", types = {button = {}}})
        local general_settings = misc_general:new_section({name = "UI Settings", side = "right", size = 360})
			local ui_notifications = general_settings:new_element({name = "Notifications", flag = "notifications", types = {dropdown = {options = {"Target", "Hits"}, multi = true}}})
			local watermark_ = general_settings:new_element({name = "Watermark", flag = "watermark", types = {toggle = {}}}); watermark_.on_toggle:Connect(function(t)
                new_watermark.main.Visible = t
            end)
            local ui_keybind = general_settings:new_element({name = "UI hotkey", flag = "ui_hotkey", types = {keybind = {key = "insert", method = "toggle", method_lock = true}}}); ui_keybind.on_key_change:Connect(function(key)
                window.hotkey = key
            end)
            local ui_accent = general_settings:new_element({name = "UI accent", flag = "ui_accent", types = {colorpicker = {color = lib.accent_color}}}); ui_accent.on_color_change:Connect(function(color)
                window:set_accent_color(color)
				new_watermark:update_text()
            end)
			local panic_button = general_settings:new_element({name = "Panic", flag = "panic_", types = {button = {confirmation = {top = "Panic (toggle everything off)", text = "Are you sure you want to do this?"}}}})
			local unload_cheat = general_settings:new_element({name = "Unload cheat", flag = "unload_cheat", types = {button = {confirmation = {top = "Unload cheat", text = "Are you sure you want to do this?"}}}})
	local misc_players = settings_:new_subtab("Players")
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
					local find = util:find(client.whitelisted, selected_plr)
					if find then
						all_players[selected_plr].whitelisted = false
						table.remove(client.whitelisted, find)
					else
						all_players[selected_plr].whitelisted = true
						table.insert(client.whitelisted, selected_plr)
					end
				end
			end)
			local is_opposition = player_options:new_element({name = "Is opposition", flag = "is_opposition", types = {toggle = {no_load = true}}}); util:create_connection(is_opposition.on_toggle, function(t)
				if selected_plr then
					local find = util:find(client.opps, selected_plr)
					if find then
						all_players[selected_plr].opp = false
						table.remove(client.opps, find)
					else
						all_players[selected_plr].opp = true
						table.insert(client.opps, selected_plr)
					end
				end
			end)
			local auto_kill = player_options:new_element({name = "Auto kill", flag = "auto_kill", types = {toggle = {no_load = true}}}); util:create_connection(auto_kill.on_toggle, function(t)
				cache.auto_kill = t and selected_plr or nil
			end)
			local view_player = player_options:new_element({name = "View", flag = "view_player", types = {toggle = {no_load = true}}}); util:create_connection(view_player.on_toggle, function(t)
				client.viewed_player = t and players:FindFirstChild(selected_plr) or nil
				if client.viewed_player == nil then
					local character = lplr.Character
					if character then
						camera.CameraSubject = character
					end	
				end
			end)
			util:create_connection(selected_player.on_option_change, function(option)
				selected_plr = option
				auto_kill:set_toggle(cache.auto_kill == option)
				view_player:set_toggle(client.viewed_player == option and true or false, true)
				is_opposition:set_toggle(util:find(client.opps, option) and true or false, true)
				is_whitelisted:set_toggle(util:find(client.whitelisted, option) and true or false, true)
			end)
local scripting_ = window:new_tab("Scripting")
	local misc_scripting = scripting_:new_subtab("General")
		local scripting_scripts = misc_scripting:new_section({name = "Scripts", side = "left", size = 360})
			local selected_script = nil
			local script_list = scripting_scripts:new_element({name = "Script list", flag = "script_list", types = {multibox = {maxsize = 8}}})
			local is_loaded = scripting_scripts:new_element({name = "Is loaded", flag = "is_loaded", types = {toggle = {no_touch = true, no_load = true}}})
            local load_script = scripting_scripts:new_element({name = "Load script", flag = "load_script", types = {button = {confirmation = {top = "Load script", text = "Are you sure you want to load this script?"}}}})
			local unload_script = scripting_scripts:new_element({name = "Unload script", flag = "unload_script", types = {button = {confirmation = {top = "Unload script", text = "Are you sure you want to unload this script?"}}}})
            local refresh_scripts = scripting_scripts:new_element({name = "Refresh scripts", flag = "refresh_scripts", types = {button = {}}})
	local script_environment = scripting_:new_subtab("Scripts")

-- ? UI Init

local scripting_api_table = {
	notifications = notifications,
	client = client,
	aimbot = aimbot,
	all_players = all_players,
	on_script_unloaded = signal.new("on_script_unloaded"),
	flags = lib.flags,
	set_fov = function(int)
		field_of_view:set_value(int)
	end,
	set_horizontal_prediction = function(int)
		horziontal_prediction:set_value(int)
	end,
	set_vertical_prediction = function(int)
		vertical_prediction:set_value(int)
	end,
	before_render = signal.new("before_render"),
	after_render = signal.new("after_render"),
	after_velocity_fix = signal.new("after_velocity_fix"),
	after_esp_render = signal.new("after_esp_render"),
	subtab = script_environment
}

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

local all_scripts = lib:get_script_list()
local current_scripts = {}

local function refresh_all_scripts()
	local all_scripts = lib:get_script_list()
	local script_list_copy = util:copy(current_scripts)

	for i,v in pairs(script_list_copy) do
		if not table.find(all_scripts, v) then
			table.remove(current_scripts, table.find(current_scripts, v))
			script_list:remove_option(v)
		end
	end

	for i,v in pairs(all_scripts) do
		if not table.find(script_list_copy, v) then
			table.insert(current_scripts, v)
			script_list:add_option(v)
		end
	end
end

local loaded_scripts = {}

do_load_script = LPH_JIT(function(name) -- ugghhh fuck this
	if name then
		local file_path = lib.config_location.."/scripts/"..name..".lua"
		if isfile(file_path) then
			local file_contents = readfile(file_path)
			if not loaded_scripts[name] then
				local thread = coroutine.create(loadstring(file_contents))
				loaded_scripts[name] = {
					thread = thread,
				}
				coroutine.resume(thread)
				is_loaded:set_toggle(true)
			end
		end
	end
end)

do_unload_script = LPH_JIT(function(name)
	if name then
		local file_path = lib.config_location.."/scripts/"..name..".lua"
		if isfile(file_path) then
			if loaded_scripts[name] then
				scripting_api_table.on_script_unloaded:Fire(name)
				task.wait()
				coroutine.close(loaded_scripts[name].thread)
				loaded_scripts[name] = nil
				is_loaded:set_toggle(false)
			end
		end
	end
end)

util:create_connection(script_list.on_option_change, function(option)
	selected_script = option
	is_loaded:set_toggle(loaded_scripts[selected_script] ~= nil and true or false)
end)

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
		if flags["watermark_position"] then
			new_watermark.main.Position = udim2new(0, flags["watermark_position"][1], 0, flags["watermark_position"][2])
		end
		if flags["keybinds_position"] then
			new_keybind.Position = udim2new(0, flags["keybinds_position"][1], 0, flags["keybinds_position"][2])
		end
	end
end))

util:create_connection(load_script.on_clicked, LPH_JIT(function()
	if selected_script then
		do_load_script(selected_script)
	end
end))

util:create_connection(unload_script.on_clicked, LPH_JIT(function()
	if selected_script then
		do_unload_script(selected_script)
	end
end))

util:create_connection(refresh_configs.on_clicked, refresh_all_configs)
util:create_connection(refresh_scripts.on_clicked, refresh_all_scripts)

-- * Init

local on_player_removed = nil;

do
	local function on_player_added(player)
		selected_player:add_option(player.Name)
		task.spawn(clients.new, player)
	end

	on_player_removed = LPH_JIT(function(player)
		local client = all_players[player.Name]
		for _, drawing in pairs(client.drawings) do
			drawing:Destroy()
		end
		client.highlight:Destroy()
		if aimbot.forced_target == player then 
			aimbot.forced_target = nil
			if util:find(flags["notifications"]["selected"], "Target") then
				notifications.new_notification("Unlocked target")
			end
		end
		all_players[player.Name] = nil
		selected_player:remove_option(player.Name)
		if client.viewed_player == instance then
			client.viewed_player = nil
			local character = lplr.Character
			if character then
				camera.CameraSubject = character
			end	
		end
	end)

	util:create_connection(players.PlayerRemoving, on_player_removed)
	util:create_connection(players.PlayerAdded, on_player_added)

	local player_list = players:GetPlayers()
	for i = 1, #player_list do
		local player = player_list[i]
		if player == lplr then continue end
		task.spawn(on_player_added, player)
	end

	util:create_connection(client.on_hurt_player, LPH_JIT(function(player, damage, part)
		local character = player.Character
		if flags["hit_chams"]["toggle"] then
			cheat.do_hit_chams(character)
		end
		if flags["hit_sound"]["toggle"] then
			cheat.do_hit_sound()
		end
		if flags["hit_effect"]["toggle"] then
			cheat.do_hit_effect(character)
		end
		if flags["hitmarker"]["toggle"] then
			cheat.new_hitmarker()
		end
		if util:find(flags["notifications"]["selected"], "Hits") then
			notifications.new_notification(string.format("Hit %s for %s damage in %s", tostring(player), tostring(floor(damage)), part)) 
		end
	end))

	util:create_connection(client.on_stomped, LPH_JIT(function(character)
		cheat.do_stomp_effect(character)
	end))

	local ignored_folder = workspace.Ignored
	local create_beam = cheat.create_beam

	util:create_connection(ignored_folder.Siren.Radius.ChildAdded, LPH_NO_VIRTUALIZE(function(siren)
		if siren.ClassName == "Part" and siren.Name ~= "\255" and lplr.Character then
			task.wait()
			local gunbeam = siren:FindFirstChildOfClass("Beam")
			if gunbeam then		
				local flag = flags["bullet_tracers"]
				local other_bullet_tracers = flags["other_bullet_tracers"]
				local bullet_impacts = flags["bullet_impacts"]
				local is_other = other_bullet_tracers["toggle"]
				if client.recently_shot or siren.Position == client.siren_pos then
					if bullet_impacts["toggle"] then
						local cf = gunbeam.Attachment1.WorldCFrame
						local size = flags["impact_size"]["value"]
						task.spawn(function()
							local clr = bullet_impacts["color"]
							local transparency = bullet_impacts["transparency"]
							local impact = util.new_object("Part", {
								CanCollide = false;
								Material = neon;
								Size = vect3(size,size,size);
								Transparency = transparency;
								Color = clr;
								Position = cf.p;
								Anchored = true;
								Parent = ignored_folder
							})
							local outline = util.new_object("SelectionBox", {
								LineThickness = 0.01;
								Transparency = 0;
								Color3 = clr;
								SurfaceTransparency = 1;
								Adornee = impact;
								Visible = true;
								Parent = impact
							})
							local impact_lifetime = flags["impact_lifetime"]["value"]
							if flags["impact_fade"]["toggle"] then
								util:tween(impact, twinfo(impact_lifetime-0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
								util:tween(outline, twinfo(impact_lifetime-0.01, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
							end
							task.wait(impact_lifetime)
							impact:Destroy()
						end)
					end
					if flag["toggle"] then
						client.siren_pos = siren.Position
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
						create_beam(from, to, flag["color"], flag["transparency"], flags["lifetime"]["value"], cloned, flags["texture"]["text"], flags["beam_fade"]["toggle"])
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
						create_beam(from, to, other_bullet_tracers["color"], other_bullet_tracers["transparency"], flags["other_lifetime"]["value"], cloned, flags["other_texture"]["text"], flags["other_beam_fade"]["toggle"])
						siren:Destroy()
					end
				end
			end
		end
	end))
end

do
	local auto_sort = cheat.do_auto_sort
	local new_notification = notifications.new_notification

	util:create_connection(uis.InputBegan, LPH_JIT(function(input, gpe)
		if gpe then return end
		local lowered = input.KeyCode.Name:lower() 
		if lowered == flags["target_bind"]["bind"]["key"] then
			local closest = aimbot.get_closest()
			local old = aimbot.active_target
			aimbot.forced_target = (closest and players:FindFirstChild(tostring(closest)) ~= aimbot.forced_target) and players:FindFirstChild(tostring(closest)) or nil
			if util:find(flags["notifications"]["selected"], "Target") then
				if aimbot.forced_target then 
					new_notification("Locked onto player "..tostring(closest)) 
				elseif old then
					new_notification("Unlocked target") 
				end
			end
		elseif flags["auto_sort"]["toggle"] and lowered == flags["auto_sort"]["bind"]["key"] then
			auto_sort()
		elseif flags["mouse_tp"]["toggle"] and lowered == flags["mouse_tp"]["bind"]["key"] then
			cache.mouse_tp = flags["tp_part"]["selected"][1]
		elseif lowered == flags["greet"]["bind"]["key"] then
			local character = lplr.Character
			if character then
				local hum = character:FindFirstChild("Humanoid")
				if hum then
					local animation = client.animations.greet.loaded
					animation:Play()
					
					local on_move_direction_change, on_finished, on_jumped = nil, nil, nil
					on_move_direction_change = util:create_connection(hum:GetPropertyChangedSignal("MoveDirection"), function()
						if animation.IsPlaying then
							animation:Stop() 
						end
						if on_jumped then on_jumped:Disconnect() end
						if on_finished then on_finished:Disconnect() end
						on_move_direction_change:Disconnect()
					end)

					on_finished = util:create_connection(animation.Stopped, function()
						if on_move_direction_change then on_move_direction_change:Disconnect() end
						if on_jumped then on_jumped:Disconnect() end
						on_finished:Disconnect()
					end)

					on_jumped = util:create_connection(hum.StateChanged, function(state)
						if state == Enum.HumanoidStateType.Jumping then
							if animation.IsPlaying then
								animation:Stop() 
							end
							if on_move_direction_change then on_move_direction_change:Disconnect() end
							if on_finished then on_finished:Disconnect() end
							on_jumped:Disconnect()
						end
					end)
				end
			end
		elseif lowered == flags["lay"]["bind"]["key"] then
			local character = lplr.Character
			if character then
				local hum = character:FindFirstChild("Humanoid")
				if hum then
					local animation = client.animations.lay.loaded
					animation:Play()
					
					local on_move_direction_change, on_finished, on_jumped = nil, nil, nil
					on_move_direction_change = util:create_connection(hum:GetPropertyChangedSignal("MoveDirection"), function()
						if animation.IsPlaying then
							animation:Stop() 
						end
						if on_jumped then on_jumped:Disconnect() end
						if on_finished then on_finished:Disconnect() end
						on_move_direction_change:Disconnect()
					end)

					on_finished = util:create_connection(animation.Stopped, function()
						if on_move_direction_change then on_move_direction_change:Disconnect() end
						if on_jumped then on_jumped:Disconnect() end
						on_finished:Disconnect()
					end)

					on_jumped = util:create_connection(hum.StateChanged, function(state)
						if state == Enum.HumanoidStateType.Jumping then
							if animation.IsPlaying then
								animation:Stop() 
							end
							if on_move_direction_change then on_move_direction_change:Disconnect() end
							if on_finished then on_finished:Disconnect() end
							on_jumped:Disconnect()
						end
					end)
				end
			end
		elseif lowered == flags["down_key"]["bind"]["key"] then
			cache.is_down = true
		elseif lowered == "space" then
			cache.is_up = true
		end
	end))

	util:create_connection(uis.InputEnded, LPH_JIT(function(input, gpe)
		if gpe then return end
		local lowered = input.KeyCode.Name:lower() 
		if lowered == flags["down_key"]["bind"]["key"] then
			cache.is_down = false
		elseif lowered == "space" then
			cache.is_up = false
		end
	end))
end

-- * Metamethod hooks

do
local new_index = nil; new_index = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, index, value)
	if not checkcaller() then
		if self == workspace.CurrentCamera then
			if getcallingscript().Name == "Framework" then
				if index == "CFrame" and flags["no_recoil"]["toggle"] then
					return
				end
			elseif index == "CFrame" and flags["aspect_ratio"]["toggle"] then
				local stretch_ratio = flags["ratio"]["value"]/100
				return new_index(self, index, value * cfnew(0, 0, 0, 1, 0, 0, 0, stretch_ratio, 0, 0, 0, 1))
			elseif index == "FieldOfView" then
				cache.fov = value
				if flags["field_of_view2"]["toggle"] then
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
			elseif index == "ColorShift_Top" then
				cache.color_shift_top = value
				if flags["color_shift_top"]["toggle"] then return end
			elseif index == "ColorShift_Bottom" then
				cache.color_shift_bottom = value
				if flags["color_shift_bottom"]["toggle"] then return end
			end
		elseif typeof(self) == "Instance" then
			if self.Name == "PepperSprayBlur" and flags["no_blur"]["toggle"] then
				if value then
					return
				end
			elseif self == lplr and index == "CameraMaxZoomDistance" then
				cache.max_zoom_distance = value
				if flags["infinite_zoom"]["toggle"] then return end
			elseif tostring(self) == "Humanoid" and (lplr and lplr.Character) and self:IsDescendantOf(lplr.Character) then
				if index == "WalkSpeed" and value < 16 then
					if flags["no_slowdowns"]["toggle"] then return end
				elseif index == "JumpPower" and value < 50 then
					if flags["no_jump_cooldown"]["toggle"] then return end
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
			if aimbot.aimbot_location and flags["silent_aim"]["toggle"] then
				return cfnew(aimbot.aimbot_location)
			end
		elseif typeof(self) == "Instance" and index == "CFrame" and self.Name == "HumanoidRootPart" and (lplr.Character and self.Parent == lplr.Character) and cframe_desync:is_active() and flags["cframe_desync"]["toggle"] then
			return cache.camera_cframe
		end
	else
		if self == game and lower(index) == "ratio" then
			return scripting_api_table
		end
	end
	return old_index(self, index)
end))
end

-- * Main Loops

do -- chat did he eat
	local fov, fov_outline, tracer_line, bounding_box, tracer_circle, debug_box = drawing_cache.fov, drawing_cache.fov_outline, drawing_cache.target_tracer, drawing_cache.bounding_box, drawing_cache.tracer_circle, drawing_cache.debug_box
	local server_stats_item = stats.Network.ServerStatsItem
	local ignored_folder = workspace.Ignored

	local after_esp_render = scripting_api_table.after_esp_render

	local on_render = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
		if window.opened and uis.MouseBehavior == Enum.MouseBehavior.LockCenter then uis.MouseBehavior = Enum.MouseBehavior.Default end; mouse_pos = uis:GetMouseLocation()
		if fov.Visible then
			fov.Position = mouse_pos
			fov_outline.Position = mouse_pos
		end

		local is_esp = flags["esp"]["toggle"]

		local hrp, hum = client:is_character_loaded()
		local hrp_pos = hrp and hrp.Position or vect3()
		local max_distance = flags["max_esp_distance"]["value"]

		if flags["watermark"]["toggle"] then
			new_watermark:update_text()
		end

		local filter = flags["specifics_only"]["toggle"]
		local friendly_filter = util:find(flags["filter"]["selected"], "Friendly")
		local target_filter = util:find(flags["filter"]["selected"], "Target")
		local opp_filter = util:find(flags["filter"]["selected"], "Opp")
		local lplr_userid = lplr.UserId

		for name, client in pairs(all_players) do
			local drawings = client.drawings

			for _, drawing in pairs(drawings) do
				drawing.Visible = false
			end
			
			local highlight = client.highlight
			highlight.Enabled = false

			if not is_esp then continue end

			local hrp, humanoid = client:is_character_loaded()
			if hrp then 
				if client.knocked and not client.grabbed then hrp = hrp.Parent:FindFirstChild("UpperTorso") end
			end
			if hrp and humanoid then
				local instance = client.instance
				if filter then
					local is_clear = false
					if friendly_filter and (client.whitelisted or instance:IsFriendsWith(lplr_userid)) then
						is_clear = true
					end
					if target_filter and tostring(aimbot.active_target) == instance then
						is_clear = true
					end
					if opp_filter and client.opp then
						is_clear = true
					end
					if not is_clear then continue end
				end
				if (hrp_pos-hrp.Position).magnitude > max_distance then continue end
				local bottom_wtvp, visible = camera:WorldToViewportPoint(hrp.Position - vect3(0, 3.3, 0)) 
				local top_wtvp, visible2 = nil, nil

				if not visible then
					top_wtvp, visible2 = camera:WorldToViewportPoint(hrp.Position + vect3(0, 2.9, 0))
				end

				if visible or visible2 then		
					if top_wtvp == nil then top_wtvp = camera:WorldToViewportPoint(hrp.Position + vect3(0, 2.9, 0)) end
					local size = (bottom_wtvp.Y - top_wtvp.Y) / 2
					local box_size = vect2(floor(size * 1.2), floor(size * 1.9))
					local box_pos = vect2(floor(bottom_wtvp.X - size * 1.2 / 2), floor(bottom_wtvp.Y - size * 3.8 / 2))
					local box_size_y = box_size.Y
					local box_size_x = box_size.X
					local box_pos_x = box_pos.X
					local box_pos_y = box_pos.Y

					local character = instance.Character

					local hflag = flags["highlight"]

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

						name.Position = vect2(box_size_x / 2 + box_pos_x, box_pos_y - name.TextBounds.Y - 2)
						name.Color = nflag["color"]
						name.Transparency = -nflag["transparency"]+1
						name.Visible = true
						name.Outline = flags["name_outline"]["toggle"]

						local dflag = flags["show_display"]

						if dflag["toggle"] and instance.DisplayName ~= instance.Name then
							local display_name = drawings.display_name

							display_name.Position = name.Position - vect2(0, display_name.TextBounds.Y/2 + 2)
							display_name.Color = dflag["color"]
							display_name.Transparency = -dflag["transparency"]+1
							display_name.Outline = name.Outline 
							display_name.Visible = true
						end
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
						outline.Visible = flags["box_outline"]["toggle"]
						box.Visible = true
					end

					local fflag = flags["fill"]

					if fflag["toggle"] then
						local fill = drawings.fill

						fill.Size = box_size
						fill.Position = box_pos
						fill.Color = fflag["color"]
						fill.Transparency = -fflag["transparency"]+1

						fill.Visible = true
					end

					local hflag = flags["health_bar"]
					local aflag = flags["armor"]
					local aflag_selected = aflag["selected"][1]
					local bar_offset = false

					if hflag["toggle"] then
						local health = drawings.health
						local outline = drawings.health_outline
						local health_value = client.health
						local health_ratio = health_value / humanoid.MaxHealth

						health.From = vect2((box_pos_x - 5), box_pos_y + box_size_y)
						health.To = vect2(health.From.X, health.From.Y - (health_ratio) * box_size_y)
						health.Color = flags["dynamic_color"]["toggle"] and Color3.fromHSV(health_ratio/3,1,1) or hflag["color"]
						health.Transparency = -hflag["transparency"]+1
						outline.From = vect2(health.From.X, box_pos_y + box_size_y + 1)
						outline.To = vect2(health.From.X, health.From.Y - box_size_y - 1)
						outline.Transparency = -hflag["transparency"]+1
						outline.Visible = true
						health.Visible = true

						bar_offset = true

						local nflag = flags["show_number"]

						if nflag["toggle"] and health_value < 100 then
							local health_text = drawings.health_text
							health_text.Text = tostring(floor(health_value))
							health_text.Position = health.To - vect2(health_text.TextBounds.X/2 + 2, 6)
							health_text.Visible = true
						end

						if aflag["toggle"] and aflag_selected == "Overlay" then
							local armor = drawings.armor
							armor.From = health.From
							armor.To = vect2(health.From.X, health.From.Y - (client.armor / 130) * box_size_y)
							armor.Color = aflag["color"]
							armor.Transparency = -aflag["transparency"]+1
							armor.Visible = true
						end
					end
					
					if aflag["toggle"] and aflag_selected == "Bar" then
						local armor = drawings.armor
						local outline = drawings.armor_outline
						local armor_ratio = client.armor / 130

						armor.From = vect2((box_pos_x - (bar_offset and 11 or 5)), box_pos_y + box_size_y)
						armor.To = vect2(armor.From.X, armor.From.Y - (armor_ratio) * box_size_y)
						armor.Color = aflag["color"]
						armor.Transparency = -aflag["transparency"]+1
						outline.From = vect2(armor.From.X, box_pos_y + box_size_y + 1)
						outline.To = vect2(armor.From.X, armor.From.Y - box_size_y - 1)
						outline.Transparency = -aflag["transparency"]+1
						outline.Visible = true
						armor.Visible = true
					end

					local bottom_offset = false

					local aflag = flags["ammo_bar"]

					if aflag["toggle"] then
						local tool = client.gun_equipped
						if tool then
							local ammo_fill = drawings.ammo_fill
							local outline = drawings.ammo_outline
							local last_ammo = client.ammo
							local last_max_ammo = client.max_ammo

							if last_ammo ~= 0 then
								ammo_fill.From = vect2(box_pos_x + 1, box_pos_y + box_size_y + 5)
								ammo_fill.To = vect2((ammo_fill.From.X + ((last_ammo/last_max_ammo) * box_size_x)) - 2, ammo_fill.From.Y)
								ammo_fill.Color = aflag["color"]
								ammo_fill.Transparency = -aflag["transparency"]+1
								ammo_fill.Visible = true
							end

							outline.From = vect2(box_pos_x, box_pos_y + box_size_y + 5)
							outline.To = vect2(outline.From.X + box_size_x, outline.From.Y)
							outline.Transparency = -aflag["transparency"]+1
							outline.Visible = true

							bottom_offset = true
						end
					end

					local tflag = flags["tool"]

					if tflag["toggle"] then
						local tool = client.tool_equipped
						if tool then
							local text = gsub(lower(tool), "%A", "")
							local tool = drawings.tool

							tool.Text = text
							tool.Color = tflag["color"]
							tool.Transparency = -tflag["transparency"]+1
							tool.Position = vect2(box_size_x / 2 + box_pos_x, (box_pos_y + box_size_y) + (bottom_offset and 5 or 1))
							tool.Visible = true
						end
					end
				end
			end
		end

		after_esp_render:Fire()
	end))

	local no_go = false
	local fov_circle = drawing_cache.fov
	local fov_outline = drawing_cache.fov_outline
	local strafe_circle = drawing_cache.strafe_circle
	local desync_box = drawing_cache.desync_box

	local s_keycode = Enum.KeyCode.S
	local w_keycode = Enum.KeyCode.W

	local before_render = scripting_api_table.before_render
	local after_render = scripting_api_table.after_render

	local on_heartbeat = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
		local hrp, hum = client:is_character_loaded()
		local tracer_line_visible = false
		local bounding_box_visible = false 
		local tracer_circle_visible = false
		local strafe_visible = false
		local desync_visible = false
		local dont_shoot = false
		local did_shoot = false

		local aimbot_location = nil
		local closest = nil
		local last_target = aimbot.active_target
		local old_nogo = no_go
		client.ping = tonumber(string.split(server_stats_item["Data Ping"]:GetValueString(),'(')[1])

		local viewed_player = client.viewed_player

		if viewed_player then
			local character = viewed_player.Character
			if character then
				camera.CameraSubject = character
			end
		end
		
		local plrgui = lplr.PlayerGui

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

		if flags["no_flashbang"]["toggle"] then
			if plrgui then
				local msui = plrgui:FindFirstChild("MainScreenGui")
				if msui then
					local flashbang = msui:FindFirstChild("whiteScreen")
					if flashbang then flashbang:Destroy() end
				end 
			end
		end

		if hrp and hum then
			local max_fov = flags["field_of_view"]["value"]*5
			if flags["dynamic_fov"]["toggle"] then
				local mouse_position = mouse.Hit.p
				local size = (camera:WorldToViewportPoint(mouse_position + vect3(0, 1, 0)).Y - camera:WorldToViewportPoint(mouse_position - vect3(0, 1, 0)).Y) / 2
				local multi = (max_fov*2)/-size
				aimbot.fov_size = max_fov - math.clamp(multi, 0, max_fov*((100-flags["dynamic_minimum"]["value"])/100))
			else
				aimbot.fov_size = max_fov
			end
			fov_circle.Radius = aimbot.fov_size
			fov_outline.Radius = aimbot.fov_size

			local connections = getconnections(hrp:GetPropertyChangedSignal("CFrame"))
			for i = 1, #connections do
				local connection = connections[i]
				connection:Disable()
			end

			if flags["money_aura"]["toggle"] then
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

			local is_spinbot = flags["spinbot"]["toggle"]
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
			hum.AutoRotate = not is_spinbot

			if is_spinbot then
				hrp.CFrame = hrp.CFrame * angles(0,rad(1+flags["spinbot"]["value"]),0)
			end

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

			local old_velocity = hrp.Velocity
			local new_velocity = false

			if flags["cframe_speed"]["toggle"] and cframe_speed:is_active() then
				hrp.CFrame = hrp.CFrame + ((dt * hum.MoveDirection) * flags["cf_speed"]["value"]*2.5)
			end

			if flags["cframe_fly"]["toggle"] and cframe_fly:is_active() then
				local movedirection = hum.MoveDirection
				local add = vect3(0, (cache.is_up and flags["y_factor"]["value"]/8 or cache.is_down and -flags["y_factor"]["value"]/8) or 0, 0)
				hrp.CFrame = hrp.CFrame + (movedirection * dt) * flags["fly_speed"]["value"]*3
				hrp.CFrame = hrp.CFrame + add
				hrp.Velocity = (hrp.Velocity * vect3(1,0,1)) + vect3(0,1.9,0)
			end

			if flags["target_strafe"]["toggle"] and target_strafe:is_active() then
				local closest = aimbot.active_target
				if closest then
					local hrp_pos = closest.HumanoidRootPart.Position + vect3(0,flags["vertical_distance"]["value"], 0)
					local strafe_distance = flags["horizontal_distance"]["value"]
					cache.strafe_angle = clamp(cache.strafe_angle+flags["strafe_angle"]["value"], 0, 360)
					if cache.strafe_angle == 360 then cache.strafe_angle = 0 end
					hrp.CFrame = angles(0,rad(cache.strafe_angle),0) * cfnew(0,0,strafe_distance) + hrp_pos
				end
			end

			local old_cframe = hrp.CFrame
			local old_velocity = hrp.Velocity
			local is_velocity_desynced = false
			local is_desynced = false
			local do_ignore = false

			if flags["cframe_desync"]["toggle"] and cframe_desync:is_active() then
				local horizontal_offset = flags["horizontal_offset"]["value"]
				local vertical_offset = flags["vertical_offset"]["value"]
				local randomization_ = flags["randomization_"]["value"]+1

				local final_cframe = old_cframe

				local add = vect3(math.random(2) == 1 and -horizontal_offset or horizontal_offset, math.random(2) == 2 and -vertical_offset or vertical_offset, math.random(2) == 2 and -horizontal_offset or horizontal_offset)
				add = add * vect3(1 + math.random(0, randomization_)/100, 1 + math.random(0, randomization_)/100, 1 + math.random(0, randomization_)/100)

				hrp.CFrame = final_cframe + add

				desync_box.Position = hrp.CFrame.p
				desync_visible = flags["show_model"]["toggle"]
				is_desynced = true
			end

			if cache.auto_kill then
				local player = all_players[cache.auto_kill]
				if player then
					local character = player.instance.Character
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
							local cf = cache.auto_ready and upper_torso.CFrame or upper_torso.CFrame - vect3(0,8,0)
							if player.knocked then 
								cf = cfnew(upper_torso.Position + vect3(0,2.5,0))
							else 		
								local combat = 	lplr.Character:FindFirstChild("Combat")	
								if not combat then
									local combat = lplr.Backpack:FindFirstChild("Combat")
									if combat then
										hum:EquipTool(combat)
									end
								else
									combat:Activate()
								end
							end
							hrp.CFrame = cf
						end
					end
				end	
			end

			if flags["anti_lock"]["toggle"] and anti_lock:is_active() then
				local anti_type = flags["lock_type"]["selected"][1]
				
				if anti_type == "Rage" then
					hrp.Velocity = vect3(math.random(45,88), -math.random(20,50), math.random(45,80))
				elseif anti_type == "Zero" then
					hrp.Velocity = vect3(0, 0, 0)
				elseif anti_type == "Underground" then
					hrp.Velocity = vect3(old_velocity.X, -10000, old_velocity.Z)
				elseif anti_type == "Sky" then
					hrp.Velocity = vect3(old_velocity.X, 10000, old_velocity.Z)
				elseif anti_type == "Void" then
					hrp.Velocity = vect3(math.random(4000,5000), math.random(4000,5000), math.random(4000,5000))
				end

				is_velocity_desynced = true
			end

			local pos = aimbot.aimbot_location

			if pos then
				if flags["look_at"]["toggle"] then
					hum.AutoRotate = false
					hrp.CFrame = cfnew(hrp.Position, vect3(pos.X, hrp.Position.Y, pos.Z))
				end
			end

			if flags["auto_armor"]["toggle"] then
				local armor = client.info.armor
				if armor/130 < flags["threshold"]["value"]/100 and cache.force_cframe == nil then
					cheat.purchase_armor()
				end
			end

			if flags["auto_fire_armor"]["toggle"] then
				local armor = client.info.fire_armor
				if armor/200 < flags["fire_threshold"]["value"]/100 and cache.force_cframe == nil then
					cheat.purchase_fire_armor()
				end
			end

			if cache.force_cframe then
				hrp.CFrame = cache.force_cframe
				hrp.Velocity = vect3(0,1.1,0)
			end

			cache.camera_cframe = old_cframe

			before_render:Fire()

			rs.RenderStepped:Wait()

			if is_desynced then
				hrp.CFrame = old_cframe
			end

			if is_velocity_desynced then
				hrp.Velocity = old_velocity
			end

			if flags["aimbot"]["toggle"] and aimbot_enabled:is_active() then
				closest = flags["type"]["selected"][1] ~= "Target aim" and aimbot.get_closest() or (aimbot.forced_target and aimbot.forced_target.Character)
				if closest and closest:FindFirstChild("Humanoid") then
					aimbot_location = aimbot.get_aimbot_location(closest)
					local dont_aim_if = flags["dont_aim_if"]["selected"]
					local skip = true
					if util:find(dont_aim_if, "Outside of fov") then
						local pos, on_screen = camera:WorldToViewportPoint(aimbot_location)
						local distance = (mouse_pos - vect2(pos.X, pos.Y)).magnitude
						if distance > aimbot.fov_size then skip = false end
					end
					if (not util:find(dont_aim_if, "Not visible") and aimbot_location or world.is_visible(aimbot_location, hrp.Position, {hrp, closest, lplr.Character, workspace.Ignored})) and skip and not client.info.knocked then
						if flags["auto_shoot"]["toggle"] and auto_shoot:is_active() then
							if not all_players[tostring(closest)].knocked then
								dont_shoot = false
								local tool = client.info.tool
								if tool then
									tool:Activate()
								end
							elseif not dont_shoot then
								dont_shoot = true
							end
						end
						local pre_no_go = false
						if flags["camlock"]["toggle"] then
							local disablers = flags["camlock_disablers"]["selected"]
							local speed = aimbot.in_air and flags["air_speed"]["value"]/100 or flags["speed"]["value"]/100
							if (util:find(disablers, "No gun") and client.info.gun_equipped == nil) then
								pre_no_go = true
							end
							if (util:find(disablers, "Third person") and uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter) then
								pre_no_go = true
							end
							if not pre_no_go then
								local camera_pos = camera.CFrame.p
								local mouse_tp_part = flags["tp_part"]["selected"][1]
								local position = not cache.mouse_tp and aimbot_location or closest:FindFirstChild(mouse_tp_part == "Head" and "Head" or "UpperTorso").Position
								util:tween(camera, twinfo(not cache.mouse_tp and 1-speed or 0, Enum.EasingStyle[flags["style"]["selected"][1]], Enum.EasingDirection.Out), {CFrame = cfnew(camera_pos, position)})
								cache.mouse_tp = false
							end
						end
						no_go = pre_no_go
						if flags["bounding_box"]["toggle"] then
							local _, bounding_box_size = closest:GetBoundingBox()
							bounding_box_visible = true
							bounding_box.Position = closest.HumanoidRootPart.Position
							bounding_box.Size = bounding_box_size/2
						end
						if flags["target_tracer"]["toggle"] then
							local pos, on_screen = (flags["tracer_origin"]["selected"][1] == "Mouse" and mouse_pos or nil), true
							if pos == nil then 
								pos, on_screen = camera:WorldToViewportPoint(hrp.Position) 
							end
							if on_screen then
								local pos2, on_screen2 = camera:WorldToViewportPoint(flags["tracer_position"]["selected"][1] == "Character" and closest.HumanoidRootPart.Position or aimbot_location)
								if on_screen2 then
									tracer_line.From = vect2(pos.X, pos.Y)
									tracer_line.To = vect2(pos2.X, pos2.Y)
									tracer_line_visible = true
								end
							end
						end
						if flags["tracer_circle"]["toggle"] then
							local pos, on_screen = camera:WorldToViewportPoint(closest.HumanoidRootPart.Position) 
							if on_screen then
								tracer_circle.Position = vect2(pos.X, pos.Y)
								tracer_circle_visible = true
							end
						end
					else
						no_go = true
						aimbot_location = nil
					end
				end
			end

			after_render:Fire()
		end; desync_box.Visible = desync_visible; tracer_line.Visible = tracer_line_visible; aimbot.aimbot_location = aimbot_location; aimbot.active_target = closest; bounding_box.Visible = bounding_box_visible; tracer_circle.Visible = tracer_circle_visible
		if (closest ~= last_target) or (old_nogo == false and no_go == true) then
			if flags["auto_shoot"]["toggle"] and auto_shoot:is_active() then
				local tool = client.info.tool
				if tool then
					tool:Deactivate()
				end
			end
			util:tween(camera, twinfo(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = camera.CFrame})
		elseif dont_shoot then
			if flags["auto_shoot"]["toggle"] and auto_shoot:is_active() then
				local tool = client.info.tool
				if tool then
					tool:Deactivate()
				end
			end
		end
	end))

	local after_velocity_fix = scripting_api_table.after_velocity_fix

	local velocity_fix = util:create_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function()
		local tick_time = tick()-aimbot.refresh_tick
		
		local is_tick_time = tick_time > flags["refresh_rate"]["value"]/1000
		for _, player in pairs(all_players) do
			local hrp, humanoid = player:is_character_loaded()
			if hrp and humanoid then
				if is_tick_time then
					local hrp_pos = hrp.Position
					if not player.last_position then player.last_position = hrp_pos; continue end
					player.velocity = (hrp_pos - player.last_position) / tick_time
					player.last_position = hrp_pos
				end
			end
		end
		after_velocity_fix:Fire()
		if is_tick_time then aimbot.refresh_tick = tick() end
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

-- ? Anti-Cheat Bypasses

for i,v in pairs(getconnections(camera:GetPropertyChangedSignal("CFrame"))) do
	v:Disable()
end

for i,v in pairs(getconnections(game:GetService("LogService").MessageOut)) do
	v:Disable()
end

-- * After load

for i = 1, #all_configs do
	local config = all_configs[i]
	config_list:add_option(config)
	table.insert(current_configs, config)
end

for i = 1, #all_scripts do
	local script = all_scripts[i]
	script_list:add_option(script)
	table.insert(current_scripts, script)
end

do
	local character = lplr.Character

	if character then task.spawn(client.on_character_added, character) end
end

do
	local ignored_folder = workspace.Ignored

	local all_shop = ignored_folder.Shop:GetChildren()
	local all_items = {}

	LPH_JIT(function()
		for i = 1, #all_shop do
			local shop_item = all_shop[i]
			local new_name = string.match(shop_item.Name, "%b[]")
			local head = shop_item:FindFirstChild("Head")
			if head and head.CFrame.p.Y > -35 then
				if new_name then
					new_name = new_name:sub(2, -2)
					if new_name:find("Ammo") then
						local non_ammo = new_name:sub(1, -6)
						if not all_items[non_ammo] then
							all_items[non_ammo] = {
								main = nil,
								ammo = head
							}
						elseif all_items[non_ammo].ammo == nil then
							all_items[non_ammo].ammo = head
						end
					else
						if not all_items[new_name] then
							all_items[new_name] = {
								main = head,
								ammo = nil
							}
						elseif all_items[new_name].main == nil then
							all_items[new_name].main = head
						end
					end
				end
			end
		end
	end)()

	for name, _ in pairs(all_items) do
		if _.ammo then
			selected_weapon:add_option(name)
		elseif _.main.Parent.Price.Value < 11 and name ~= "Default Moveset" and name ~= "Flashlight" and name ~= "Flowers" then
			selected_food:add_option(name)
		end
	end

	local armor = all_items["High-Medium Armor"]
	local fire_armor = all_items["Fire Armor"]

	cheat.purchase_armor = LPH_NO_VIRTUALIZE(function()
		cheat.purchase_item("High-Medium Armor", armor.main.Parent:FindFirstChildOfClass("ClickDetector"), armor.main)
	end)

	cheat.purchase_fire_armor = LPH_NO_VIRTUALIZE(function()
		cheat.purchase_item("Fire Armor", fire_armor.main.Parent:FindFirstChildOfClass("ClickDetector"), fire_armor.main)
	end)

	util:create_connection(purchase_food.on_clicked, function()
		if selected_food_ and cache.force_cframe == nil then
			cheat.purchase_item(selected_food_, all_items[selected_food_].main.Parent:FindFirstChildOfClass("ClickDetector"), all_items[selected_food_].main)
		end
	end)

	util:create_connection(purchase_weapon.on_clicked, function()
		if selected_weapon_ and cache.force_cframe == nil then
			local gun = all_items[selected_weapon_]
			cheat.purchase_item(selected_weapon_, gun.main.Parent:FindFirstChildOfClass("ClickDetector"), gun.main, gun.ammo.Parent:FindFirstChildOfClass("ClickDetector"), gun.ammo)
		end
	end)
end


util:create_connection(panic_button.on_clicked, LPH_NO_VIRTUALIZE(function()
	for thing, value in pairs(flags) do
		local a = flags[thing]["toggle"]
		if a then
			flags[thing]["toggle"] = false
		end
	end;
	task.wait()
	lib.on_config_load:Fire()
end))

util:create_connection(unload_cheat.on_clicked, LPH_NO_VIRTUALIZE(function()
	for thing, value in pairs(flags) do
		local a = flags[thing]["toggle"]
		if a then
			flags[thing]["toggle"] = false
		end
	end;
	task.wait()
	lib.on_config_load:Fire()
	for _, connection in pairs(util.connections) do
		connection:Disconnect()
	end
	for player, client in pairs(all_players) do
		task.spawn(on_player_removed, players:FindFirstChild(player))
	end
	for name, drawing in pairs(drawing_cache) do
		drawing:Destroy()
	end
	window.screen_gui:Destroy()
end))

task.wait(2.5)
            
notifications.new_notification("successfully loaded, press insert to open the menu")