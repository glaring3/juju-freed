-- * Variables & Global Tables

--setfpscap(1000)

local core_gui = game.Players.LocalPlayer.PlayerGui or game:GetService("CoreGui")
local players = game:GetService("Players")
local texts = game:GetService("TextService")
local lplr = players.LocalPlayer
local mouse = lplr:GetMouse()
local http = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")

local signal = require(game.ReplicatedStorage.Signal)

local viewport_size = workspace.CurrentCamera.ViewportSize
local camera = workspace.CurrentCamera

local connections = {}

local sc_parent = core_gui
local global_sg = nil

local accent_color = Color3.fromRGB(161,240,145)

LPH_JIT = function(...) return ... end
LPH_NO_VIRTUALIZE = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end

-- * Util Library

local util = {}

do
	local instance_new = Instance.new
	local new_drawing = Drawing and Drawing.new

	util.new_object = LPH_NO_VIRTUALIZE(function(class, properties)
		local object = instance_new(class)

		for property, value in pairs(properties) do
			object[property] = value
		end

		object.Name = http:GenerateGUID(false)

		return object
	end)

	function util:new_connection(signal, callback)
		local connection = signal:Connect(callback)

		table.insert(connections, connection)

		return connection
	end

	function util:get_text_size(text)
		return texts:GetTextSize(text, 11, "ArialBold", Vector2.new(999,999)).X
	end

	function util:set_draggable(obj) -- from dev forum ^o^
		local dragging
		local dragInput
		local dragStart
		local startPos

		local function update(input)
			local delta = input.Position - dragStart
			obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
			if input == dragInput and dragging then
				update(input)
			end
		end)
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

	function util:round(num, decimals)
		local mult = 10^(decimals or 0)
		return math.floor(num * mult + 0.5) / mult
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

	function util:is_in_frame(object)
		local abs_pos = object.AbsolutePosition
		local abs_size = object.AbsoluteSize
		local x = abs_pos.Y <= mouse.Y and mouse.Y <= abs_pos.Y + abs_size.Y
		local y = abs_pos.X <= mouse.X and mouse.X <= abs_pos.X + abs_size.X

		return (x and y)
	end
end

global_sg = util.new_object("ScreenGui", {
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	ResetOnSpawn = false,
	Parent = sc_parent
})

-- * Variable Updates

util:new_connection(camera:GetPropertyChangedSignal("ViewportSize"), LPH_JIT(function()
	viewport_size = camera.ViewportSize
end))

-- * Watermark

local watermark = {}

watermark.__index = watermark

watermark.new = LPH_JIT(function(user, game)
	local wm = {
		label = nil,
		user = user,
		game = game,
		main = nil
	}

	do
		local Watermark = util.new_object("Frame", {
			BackgroundColor3 = Color3.fromRGB(35, 35, 35);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(0, 0, 0, 30);
			Position = UDim2.new(0,0,0,0);
			Parent = global_sg
		}); wm.main = Watermark
		local BackCorner = util.new_object("UICorner", {
			CornerRadius = UDim.new(0, 3);
			Parent = Watermark
		})
		local Border = util.new_object("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
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
			Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 20))};
			Rotation = 90;
			Parent = Border
		})
		local Logo = util.new_object("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(0, 28, 0, 28);
			Image = "http://www.roblox.com/asset/?id=14720232130";
			Parent = Border
		})
		local Text = util.new_object("TextLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 28, 0, 0);
			Size = UDim2.new(1, -33, 1, 0);
			Font = Enum.Font.ArialBold;
			TextColor3 = Color3.fromRGB(70, 70, 70);
			TextSize = 11.000;
			TextWrapped = true;
			TextXAlignment = Enum.TextXAlignment.Left;
			RichText = true;
			Parent = Border
		})

		wm.label = Text
		wm.main = Watermark

		util:set_draggable(Watermark)
	end

	setmetatable(wm, watermark)

	return wm
end)

function watermark:update_text()
	local user, game_name = self.user, self.game

	local label = self.label
	local time_text = os.date("%I:%M")
	local time_suffix = string.lower(os.date("%p"))
	local color = tostring(util:round(accent_color.R*255))..", "..tostring(util:round(accent_color.G*255))..", "..tostring(util:round(accent_color.B*255))

	self.main.Size = UDim2.new(0, util:get_text_size((string.format("%s | %s | %s %s", user, game_name, time_text, time_suffix))) + 37, 0, 30)
	self.label.Text = string.format("%s <font color=\"rgb(35, 35, 35)\">|</font> %s <font color=\"rgb(35, 35, 35)\">|</font> <font color=\"rgb("..color..")\">%s</font> %s", user, game_name, time_text, time_suffix)
end

-- * Hitlogs

local notifications = {
	cache = {}
}

function notifications:new_notification(notification)
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
				Text = "[ rinzu ]";
				Color = accent_color;
				Font = Drawing.Fonts[1];
				Transparency = 0;
				Visible = true;
			}),
			text = util:new_drawing("Text", {
				Size = 18;
				ZIndex = 1;
				Text = notification;
				Color = Color3.fromRGB(226,226,226);
				Font = Drawing.Fonts[1];
				Transparency = 0;
				Visible = true;
			})
		}
	}; notification.info.target = notification.objects.prefix.TextBounds.X + 7

	table.insert(notifications.cache, notification)
end

local notification_loop = util:new_connection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
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
			prefix.Position = Vector2.new(5, 61 + (16*i + 2))
			text.Position = prefix.Position + Vector2.new(target, 0)
			prefix.Transparency = transparency
			text.Transparency = transparency
			if transparency < 0.01 then
				table.remove(cache, i)
				prefix:Remove()
				text:Remove()
			end
		else
			local transparency = ts:GetValue((info.delta / 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local transparency2 = ts:GetValue((info.delta / 1.5), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local textboundsx = prefix.TextBounds.X
			prefix.Position = Vector2.new(-textboundsx + ((5+textboundsx) * transparency2), 61 + (16*i + 2))
			text.Position = prefix.Position + Vector2.new(-target + (target*2 * transparency), 0)
			info.delta+=dt
			prefix.Transparency = transparency2
			text.Transparency = transparency
		end
	end
end))

-- * UI Lib

local lib = {
	config_location = "rinzu"
}

local on_accent_change = signal.new("on_accent_change")
local on_opening = signal.new("on_opening")
local on_closing = signal.new("on_closing")
local on_opened = signal.new("on_opened")
local on_close = signal.new("on_close")

local window = {}; window.__index = window
local tab = {}; tab.__index = tab
local subtab = {}; subtab.__index = subtab
local multitab = {}; multitab.__index = multitab

lib.new = LPH_JIT(function()
	local Holder = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 355, 0, 155);
		Size = UDim2.new(0, 786, 0, 46);
		Visible = false;
		Parent = global_sg
	})
	local Background = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 786, 0, 481);
		ClipsDescendants = true;
		Parent = Holder
	})
	local BorderCorner = util.new_object("UICorner", {
		CornerRadius = UDim.new(0, 3);
		Parent = Background
	})
	local TopBar = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 0, 46);
		Parent = Background
	})
	local TopBarGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(29, 29, 29)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 20))};
		Rotation = 90;
		Parent = TopBar
	})
	local TopLogo = util.new_object("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 46, 0, 46);
		Image = "http://www.roblox.com/asset/?id=14720232130";
		ImageColor3 = accent_color;
		Parent = TopBar
	})
	local BottomBar = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 1, -25);
		Size = UDim2.new(1, -2, 0, 24);
		Parent = Background
	})
	local BottomDivider = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(35, 35, 35);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, -1);
		Size = UDim2.new(1, 0, 0, 1);
		Parent = BottomBar
	})
	local BuildLabel = util.new_object("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 4, 0, 1);
		Size = UDim2.new(0, 200, 1, -1);
		Font = Enum.Font.ArialBold;
		Text = "";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 11.000;
		RichText = true;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = BottomBar
	})
	local ActiveUserLabel = util.new_object("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(1, -204, 0, 1);
		Size = UDim2.new(0, 200, 1, -1);
		Font = Enum.Font.ArialBold;
		Text = "";
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 11.000;
		TextXAlignment = Enum.TextXAlignment.Right;
		RichText = true;
		Parent = BottomBar
	})
	local SideBar = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(18, 18, 18);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 47);
		Size = UDim2.new(0, 148, 1, -73);
		Parent = Background
	})
	local SideDivider = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(35, 35, 35);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(1, 0, 0, 0);
		Size = UDim2.new(0, 1, 1, 0);
		Parent = SideBar
	})
	local BottomShadow = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 1, -36);
		Size = UDim2.new(1, -2, 0, 10);
		Parent = Background
	})
	local BottomGradient = util.new_object("UIGradient", {
		Rotation = 270;
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.65), NumberSequenceKeypoint.new(1.00, 1.00)};
		Parent = BottomShadow
	})
	local TopLine = util.new_object("Frame", {
		BackgroundColor3 = accent_color;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(1, -392, 0, 47);
		Size = UDim2.new(0, 391, 0, 1);
		Parent = Background
	})
	local TopGradient = util.new_object("UIGradient", {
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)};
		Parent = TopLine
	})
	local TopLine2 = util.new_object("Frame", {
		BackgroundColor3 = accent_color;
		BackgroundTransparency = 0.500;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 1);
		Size = UDim2.new(0, 391, 0, 1);
		Parent = TopLine
	})
	local TopShadow = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 47);
		Size = UDim2.new(1, -2, 0, 10);
		Parent = Background
	})
	local TopShadowGradient = util.new_object("UIGradient", {
		Rotation = 90;
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.65), NumberSequenceKeypoint.new(1.00, 1.00)};
		Parent = TopShadow
	})
	local TopGradient2 = util.new_object("UIGradient", {
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)};
		Parent = TopLine2
	})
	local TabHolder = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(1, -501, 0, 0);
		Size = UDim2.new(0, 500, 0, 46);
		Parent = Background
	})
	local TabListLayout = util.new_object("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = TabHolder
	})

	util:set_draggable(Holder)

	local new_window = {
		objects = {
			screen_gui = Holder,
			user_label = ActiveUserLabel,
			build_label = BuildLabel,
			opened = true,
			line = TopLine,
			tab_holder = TabHolder,
			side_bar = SideBar,
			background = Background
		},
		tabs = {},
		info = {
			user = nil,
			build = nil,
			key = "INSERT",
			tab = nil
		}
	}

	setmetatable(new_window, window)

	new_window:close()

	util:new_connection(on_accent_change, function()
		new_window:set_user(new_window.info.user)
		new_window:set_build(new_window.info.build)
		TopLogo.ImageColor3 = accent_color
		TopLine.BackgroundColor3 = accent_color
		TopLine2.BackgroundColor3 = accent_color
	end)

	util:new_connection(uis.InputBegan, function(input, gpe)
		if gpe then return end
		local input_type = input.UserInputType
		if not gpe and string.upper(input.KeyCode.Name) == new_window.info.key then
			if new_window.info.opened then new_window:close() else new_window:open() end
		end
	end)

	return new_window
end)

function window:set_accent_color(color)
	accent_color = color
	on_accent_change:Fire(color)
end

function window:set_user(user)
	local user_label = self.objects.user_label
	local color = tostring(util:round(accent_color.R*255))..", "..tostring(util:round(accent_color.G*255))..", "..tostring(util:round(accent_color.B*255))

	user_label.Text = string.format("active user: <font color=\"rgb(%s)\">%s</font>", color, user)
	self.info.user = user
end

function window:set_build(build)
	local build_label = self.objects.build_label
	local color = tostring(util:round(accent_color.R*255))..", "..tostring(util:round(accent_color.G*255))..", "..tostring(util:round(accent_color.B*255))

	build_label.Text = string.format("build: <font color=\"rgb(%s)\">%s</font>", color, build)
	self.info.build = build
end

function window:close()
	local objects = self.objects
	local descendants = objects.screen_gui:GetDescendants()
	on_closing:Fire()
	util:tween(objects.tab_holder, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, 1, 0, 0)})
	util:tween(objects.line, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 47), Size = UDim2.new(0, 0, 0, 1)})
	for i = 1, #descendants do
		local descendant = descendants[i]
		if descendant.ClassName == "Frame" then
			if descendant.BackgroundTransparency == 1 then continue end
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.99})
		elseif descendant.ClassName == "TextLabel" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.99})
		elseif descendant.ClassName == "ImageLabel" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0.99})
			if descendant.ZIndex == 16 then
				util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.99})
			end
		elseif descendant.ClassName == "TextBox" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.99})
		elseif descendant.ClassName == "ScrollingFrame" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 0.99})
		end
	end
	task.delay(0.36, function()
		if objects.screen_gui:FindFirstChildOfClass("Frame").BackgroundTransparency > 0.98 then
			on_close:Fire()
			objects.screen_gui.Visible = false
			self.info.opened = false
		end
	end)
end

function window:open()
	local objects = self.objects
	self.info.opened = true
	on_opening:Fire()
	objects.screen_gui.Visible = true
	local descendants = objects.screen_gui:GetDescendants()
	task.delay(0.04, function()
		util:tween(objects.tab_holder, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, -501, 0, 0)})
		util:tween(objects.line, TweenInfo.new(0.32, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, -392, 0, 47), Size = UDim2.new(0, 391, 0, 1)})
	end)
	for i = 1, #descendants do
		local descendant = descendants[i]
		if descendant.ClassName == "Frame" then
			if descendant.BackgroundTransparency == 1 then continue end
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
		elseif descendant.ClassName == "TextLabel" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
		elseif descendant.ClassName == "ImageLabel" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0})
			if descendant.ZIndex == 16 then
				util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
			end
		elseif descendant.ClassName == "TextBox" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
		elseif descendant.ClassName == "ScrollingFrame" then
			util:tween(descendant, TweenInfo.new(0.36, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ScrollBarImageTransparency = 0})
		end
	end
	task.delay(0.36, function()
		if objects.screen_gui:FindFirstChildOfClass("Frame").BackgroundTransparency < 0.01 then
			on_opened:Fire()
		end
	end)
end

function window:set_active_tab(name)
	self.info.tab = name
	for tab_name, tab in pairs(self.tabs) do
		if tab_name == name then
			tab:set_active(true)
			tab.subtab_holder.Visible = true
			tab.subtab_frame.Visible = true
		else
			tab.subtab_holder.Visible = false
			tab.subtab_frame.Visible = false
			tab:set_active(false)
		end
	end
end

function window:new_tab(text, icon)
	local TabImage = util.new_object("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 46, 0, 46);
		Image = icon;
		ImageColor3 = Color3.fromRGB(74, 74, 74);
		Parent = self.objects.tab_holder
	})
	local TabHover = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(35, 35, 35);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, texts:GetTextSize(text, 14, "SourceSansBold", Vector2.new(999,999)).X + 16, 0, 21);
		Visible = false;
		BackgroundTransparency = 1;
		Parent = global_sg
	})
	local HoverCorner = util.new_object("UICorner", {
		CornerRadius = UDim.new(0, 3);
		Parent = TabHover
	})
	local HoverLabel = util.new_object("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Font = Enum.Font.SourceSansBold;
		Text = text;
		TextColor3 = Color3.fromRGB(126, 126, 126);
		TextSize = 14.000;
		BackgroundTransparency = 1;
		TextTransparency = 1;
		Parent = TabHover
	})
	local SubtabHolder = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 12);
		Size = UDim2.new(1, 0, 1, -24);
		Visible = false;
		Parent = self.objects.side_bar
	})
	local SubtabListLayout = util.new_object("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = SubtabHolder
	})
	local SubtabFrame = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 164, 0, 61);
		Size = UDim2.new(1, -178, 1, -101);
		Visible = false;
		Parent = self.objects.background
	})

	local function on_hover()
		local abs_pos = TabImage.AbsolutePosition
		if self.info.tab ~= text then
			util:tween(TabImage, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(126,126,126)})
		end
		util:tween(HoverLabel, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
		util:tween(TabHover, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
		TabHover.Position = UDim2.new(0, abs_pos.X - (TabHover.Size.X.Offset-46)/2, 0, abs_pos.Y + 40)
		TabHover.Visible = true
	end

	local function on_leave(bypass)
		local abs_pos = TabImage.AbsolutePosition
		if self.info.tab ~= text or bypass == "b" then
			util:tween(TabImage, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(74,74,74)})
		end
		util:tween(HoverLabel, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1, TextTransparency = 1})
		util:tween(TabHover, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
		task.delay(0.19, function()
			if TabHover.BackgroundTransparency > 0.98 then
				TabHover.Visible = false
			end
		end)
	end

	util:new_connection(TabImage:GetPropertyChangedSignal("AbsolutePosition"), function()
		local abs_pos = TabImage.AbsolutePosition
		if util:is_in_frame(TabImage) then
			TabHover.Position = UDim2.new(0, abs_pos.X - (TabHover.Size.X.Offset-46)/2, 0, abs_pos.Y + 21 + 15)
		end
	end)

	util:new_connection(on_opened, function()
		if util:is_in_frame(TabImage) then
			on_hover()
		end
	end)

	util:new_connection(TabImage.MouseEnter, on_hover)
	util:new_connection(TabImage.MouseLeave, on_leave)

	local new_tab = {
		subtab_holder = SubtabHolder,
		hover_label = HoverLabel,
		tab_image = TabImage,
		subtab_frame = SubtabFrame,
		subtabs = {},
		info = {
			subtab = nil
		}
	}

	setmetatable(new_tab, tab)

	util:new_connection(TabImage.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if self.info.tab ~= text then
				self:set_active_tab(text)
			end
		end
	end)

	util:new_connection(on_closing, function()
		on_leave("b")
		new_tab:set_active(false)
	end)

	util:new_connection(on_opened, function()
		if self.info.tab == text then
			new_tab:set_active(true)
		end
	end)

	util:new_connection(on_accent_change, function()
		if self.info.tab == text then
			HoverLabel.TextColor3 = accent_color
			TabImage.ImageColor3 = accent_color
		end
	end)

	self.tabs[text] = new_tab

	if self.info.tab == nil then self:set_active_tab(text) end

	return new_tab
end

function tab:set_active(active)
	util:tween(self.tab_image, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageColor3 = active and accent_color or Color3.fromRGB(74, 74, 74)})
	util:tween(self.hover_label, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = active and accent_color or Color3.fromRGB(74, 74, 74)})
end

function tab:set_active_subtab(name)
	self.info.subtab = name
	for subtab_name, subtab in pairs(self.subtabs) do
		if subtab_name == name then
			subtab:set_active(true)
			subtab.subtab_frame.Visible = true
		else
			subtab.subtab_frame.Visible = false
			subtab:set_active(false)
		end
	end
end 

function tab:new_subtab(text)
	local SubtabButton = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 0, 30);
		BackgroundTransparency = 1;
		Parent = self.subtab_holder
	})
	local SubtabLine = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(163, 243, 147);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 2, 1, 0);
		BackgroundTransparency = 1;
		Parent = SubtabButton
	})
	local SubtabLineGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
		Parent = SubtabLine
	})
	local SubtabButtonGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(18, 18, 18))};
		Parent = SubtabButton
	})
	local SubtabLabel = util.new_object("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 14, 0, 0);
		Size = UDim2.new(1, -30, 1, -1);
		Font = Enum.Font.SourceSansBold;
		Text = text;
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 14.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = SubtabButton
	})
	local SubtabFrame = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		Visible = false;
		Parent = self.subtab_frame
	})

	local new_subtab = {
		background = SubtabButton,
		label = SubtabLabel,
		subtab_frame = SubtabFrame,
		line = SubtabLine,
		multitabs = {},
		info = {
			multitab = nil
		}
	}

	local function on_hover()
		if self.info.subtab ~= text then
			util:tween(SubtabButton, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
			util:tween(SubtabLine, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
			util:tween(SubtabLabel, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(126,126,126)})
		end
	end

	local function on_leave()
		if self.info.subtab ~= text then
			util:tween(SubtabButton, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
			util:tween(SubtabLine, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
			util:tween(SubtabLabel, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(74,74,74)})
		end
	end

	util:new_connection(on_accent_change, function()
		SubtabLine.BackgroundColor3 = accent_color
		if self.info.subtab == text then
			SubtabLabel.TextColor3 = accent_color
		end
	end)

	util:new_connection(SubtabButton.MouseEnter, on_hover)
	util:new_connection(SubtabButton.MouseLeave, on_leave)

	util:new_connection(on_opened, function()
		if self.info.subtab == text then
			new_subtab:set_active(true)
		end
	end)

	util:new_connection(on_opening, function()
		task.wait()
		if self.info.subtab == text then
			util:tween(SubtabButton, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = SubtabButton.BackgroundTransparency})
			util:tween(SubtabLine, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = SubtabLine.BackgroundTransparency})
			util:tween(SubtabLabel, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = SubtabLabel.TextColor3})
		end
	end)

	util:new_connection(on_closing, function()
		task.wait()
		if self.info.subtab == text then
			new_subtab:set_active(false)
		end
	end)

	util:new_connection(SubtabButton.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if self.info.subtab ~= text then
				self:set_active_subtab(text)
			end
		end
	end)

	util:new_connection(on_accent_change, function()
		if self.info.subtab == text then
			SubtabLabel.TextColor3 = accent_color
			SubtabLine.BackgroundColor3 = accent_color
		end
	end)

	setmetatable(new_subtab, subtab)

	self.subtabs[text] = new_subtab

	if self.info.subtab == nil then self:set_active_subtab(text) end

	return new_subtab
end

function tab:new_multi_subtab(text)
	local SubtabButton = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(1, 0, 0, 30);
		BackgroundTransparency = 1;
		Parent = self.subtab_holder
	})
	local SubtabLine = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(163, 243, 147);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 2, 1, 0);
		BackgroundTransparency = 1;
		Parent = SubtabButton
	})
	local SubtabLineGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 125, 125))};
		Parent = SubtabLine
	})
	local SubtabButtonGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(24, 24, 24)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(18, 18, 18))};
		Parent = SubtabButton
	})
	local SubtabLabel = util.new_object("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 14, 0, 0);
		Size = UDim2.new(1, -30, 1, -1);
		Font = Enum.Font.SourceSansBold;
		Text = text;
		TextColor3 = Color3.fromRGB(74, 74, 74);
		TextSize = 14.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = SubtabButton
	})
	local SubtabFrame = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		Visible = false;
		Parent = self.subtab_frame
	})
	local MultiSubtabTop = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Size = UDim2.new(0, 609, 0, 32);
		Parent = SubtabFrame
	})
	local MultiSubtabTop2 = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(35, 35, 35);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Parent = MultiSubtabTop
	})
	local MultiSubtabTop3 = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0, 1, 0, 1);
		Size = UDim2.new(1, -2, 1, -2);
		Parent = MultiSubtabTop2
	})
	local UIListLayout = util.new_object("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal;
		HorizontalAlignment = Enum.HorizontalAlignment.Center;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Padding = UDim.new(0, 1);
		Parent = MultiSubtabTop3
	})

	local new_subtab = {
		background = SubtabButton,
		label = SubtabLabel,
		line = SubtabLine,
		subtab_frame = SubtabFrame,
		multi_top = MultiSubtabTop3,
		multitabs = {},
		info = {
			multitab = nil
		}
	}

	local function on_hover()
		if self.info.subtab ~= text then
			util:tween(SubtabButton, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
			util:tween(SubtabLine, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
			util:tween(SubtabLabel, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(126,126,126)})
		end
	end

	local function on_leave()
		if self.info.subtab ~= text then
			util:tween(SubtabButton, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
			util:tween(SubtabLine, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
			util:tween(SubtabLabel, TweenInfo.new(0.19, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(74,74,74)})
		end
	end

	util:new_connection(SubtabButton.MouseEnter, on_hover)
	util:new_connection(SubtabButton.MouseLeave, on_leave)

	util:new_connection(on_opened, function()
		if self.info.subtab == text then
			new_subtab:set_active(true)
		end
	end)

	util:new_connection(on_opening, function()
		task.wait()
		if self.info.subtab == text then
			util:tween(SubtabButton, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = SubtabButton.BackgroundTransparency})
			util:tween(SubtabLine, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = SubtabLine.BackgroundTransparency})
			util:tween(SubtabLabel, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = SubtabLabel.TextColor3})
		end
	end)

	util:new_connection(on_closing, function()
		task.wait()
		if self.info.subtab == text then
			new_subtab:set_active(false)
		end
	end)

	util:new_connection(SubtabButton.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if self.info.subtab ~= text then
				self:set_active_subtab(text)
			end
		end
	end)

	util:new_connection(on_accent_change, function()
		SubtabLine.BackgroundColor3 = accent_color
		if self.info.subtab == text then
			SubtabLabel.TextColor3 = accent_color
		end
	end)

	setmetatable(new_subtab, subtab)

	self.subtabs[text] = new_subtab

	if self.info.subtab == nil then self:set_active_subtab(text) end

	return new_subtab
end

function subtab:set_active(active)
	util:tween(self.background, TweenInfo.new(active and 0.21 or 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = active and 0 or 1})
	util:tween(self.label, TweenInfo.new(active and 0.21 or 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = active and accent_color or Color3.fromRGB(74,74,74)})
	util:tween(self.line, TweenInfo.new(active and 0.21 or 0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = active and 0 or 1})
end

function subtab:set_active_multitab(name)
	self.info.multitab = name
	for multitab_name, multitab in pairs(self.multitabs) do
		if multitab_name == name then
			multitab:set_active(true)
		else
			multitab:set_active(false)
		end
	end
end

function subtab:new_multi_option(name, icon, img_size)
	local MultiSubtabOption = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		Size = UDim2.new(0, 100, 1, 0);
		Parent = self.multi_top
	})
	local MultiSubtabOptionGradient = util.new_object("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 18, 18)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))};
		Rotation = 270;
		Parent = MultiSubtabOption
	})
	local MultiLine = util.new_object("Frame", {
		BackgroundColor3 = Color3.fromRGB(163, 243, 147);
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(0.5, 0, 1, -2);
		Size = UDim2.new(0, 0, 0, 2);
		BackgroundTransparency = 1;
		Parent = MultiSubtabOption
	}); util:new_connection(MultiLine:GetPropertyChangedSignal("Size"), function()
		local size = MultiLine.AbsoluteSize.X
		MultiLine.Position = UDim2.new(0.5, -size/2, 1, -2)
	end)
	local MultiLineGradient = util.new_object("UIGradient", {
		Rotation = 270;
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(0.50, 0.50), NumberSequenceKeypoint.new(1.00, 0.50)};
		Parent = MultiLine
	})
	local pos_offset = (1-img_size)/2
	local MultiImage = util.new_object("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(0, 0, 0);
		BorderSizePixel = 0;
		Position = UDim2.new(pos_offset, 0, pos_offset, 0);
		Size = UDim2.new(img_size, 0, img_size, 0);
		Image = "http://www.roblox.com/asset/?id=14745280004";
		ImageColor3 = Color3.fromRGB(52, 52, 52);
		ScaleType = Enum.ScaleType.Slice;
		Parent = MultiSubtabOption
	})

	local new_multitab = {
		background = MultiSubtabOption,
		image = MultiImage,
		line = MultiLine
	}

	setmetatable(new_multitab, multitab)

	util:new_connection(MultiSubtabOption.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.info.multitab ~= name then
			self:set_active_multitab(name)
		end
	end)

	util:new_connection(on_closing, function()
		task.wait()
		if self.info.multitab == name then
			new_multitab:set_active(false)
		end
	end)

	util:new_connection(on_opened, function()
		task.wait()
		if self.info.multitab == name then
			new_multitab:set_active(true)
		end
	end)

	util:new_connection(MultiSubtabOption.MouseEnter, function()
		if self.info.multitab ~= name then
			util:tween(MultiImage, TweenInfo.new(0.31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(74,74,74)})
		end
	end)

	util:new_connection(MultiSubtabOption.MouseLeave, function()
		if self.info.multitab ~= name then
			util:tween(MultiImage, TweenInfo.new(0.31, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(52,52,52)})
		end
	end)

	util:new_connection(on_accent_change, function()
		MultiLine.BackgroundColor3 = accent_color
		if self.info.multitab == name then
			MultiImage.ImageColor3 = accent_color
		end
	end)

	self.multitabs[name] = new_multitab

	if self.info.multitab == nil then self:set_active_multitab(name) end

	return new_multitab
end

function multitab:set_active(active)
	util:tween(self.background, TweenInfo.new(active and 0.28 or 0.21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = active and 0 or 1})
	util:tween(self.image, TweenInfo.new(multi and 0.28 or 0.21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = active and accent_color or Color3.fromRGB(52,52,52)})
	util:tween(self.line, TweenInfo.new(active and 0.28 or 0.21, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = active and UDim2.new(1, 0, 0, 2) or UDim2.new(0, 0, 0, 2), BackgroundTransparency = active and 0 or 1})
end

-- * Create Missing Folders

if isfolder then

if not isfolder(lib.config_location) then
	makefolder(lib.config_location)
end

if not isfolder(lib.config_location.."/configs") then
	makefolder(lib.config_location.."/configs")
end

if not isfolder(lib.config_location.."/scripts") then
	makefolder(lib.config_location.."/scripts")
end

end

-- * Menu Setup

local win = lib.new(); win:set_user(lplr.Name); win:set_build("debug")
local on_load = signal.new("on_load")

local rage = win:new_tab("RAGE", "http://www.roblox.com/asset/?id=14748408713")
local profile = win:new_tab("PROFILE", "http://www.roblox.com/asset/?id=14732511974")
local scripting = win:new_tab("SCRIPTING", "http://www.roblox.com/asset/?id=14732452620")

local test = scripting:new_subtab("TEST")
local test = scripting:new_multi_subtab("HELP ME 1313")
local ragebot = rage:new_multi_subtab("whats goodie gang")

local revolver = ragebot:new_multi_option("revolver", "rbxassetid://14745280004", 0.8)
local revolver = ragebot:new_multi_option("doubebarrel", "rbxassetid://14745280004", 0.8)

task.wait(2.5)

on_load:Fire()