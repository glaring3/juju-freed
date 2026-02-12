cleardrawcache()

-----------------------
-- * LURAPH MACROS * --
-----------------------

if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_JIT = function(...) return ... end
end


----------------------------------
-- * SERVICE / FAST VARIABLES * --
----------------------------------

local uis = game:GetService("UserInputService")
local tws = game:GetService("TweenService")
	local getValue = tws.GetValue
local plrs = game:GetService("Players")
    local lplr = plrs.LocalPlayer
    local mouse = lplr:GetMouse()
local rs = game:GetService("RunService")

-------------------------
-- * UTILITY LIBRARY * --
-------------------------

local utility = {
    connections = {}
}

do
    utility.newConnection = function(signal, callback, cache)
        local connection = signal:Connect(callback)

        if cache then
            utility.connections[#utility.connections] = connection
        end

        return connection
    end

    utility.find = function(array, find)
        for _, obj in array do
            if find == obj then return  _ end
        end
    end

    utility.insert = function(array, _)
        array[#array+1] = _
    end

    utility.length = function(array)
        local length = 0
        for _, obj in array do length+=1 end
        return length
    end

    utility.remove = function(array, _, z)
        array[z or utility.find(array, _)] = nil
    end

    utility.isInDrawing = LPH_NO_VIRTUALIZE(function(object, pos)
        local abs_pos = object.Position
        local abs_size = tonumber(object.Size) and object["TextBounds"] or object.Size
        local x = abs_pos.Y <= pos.Y and pos.Y <= abs_pos.Y + abs_size.Y
        local y = abs_pos.X <= pos.X and pos.X <= abs_pos.X + abs_size.X

        return (x and y)
    end)

    utility.tweenDrawing = function(object, info, object_info)
        local property = nil
        for _property, _ in object_info do
            property = _property
            break
        end
        if rawget(object, "Tweens")[property] then
            rawget(object, "Tweens")[property]:Disconnect()
        end
        local old_value = property == "Position" and rawget(object, "FakePosition") or object[property]
        local new_value = object_info[property]
        local elapsed_time = 0
        local time = info[1]
        local style = info[2]
        local direction = info[3]
        local connection = nil; connection = utility.newConnection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
            elapsed_time+=dt
            if elapsed_time < time then
                object[property] = old_value + (new_value-old_value)*getValue(tws, (elapsed_time / time), style, direction)
            else
                object[property] = new_value
                connection:Disconnect()
            end
        end), true)
        rawget(object, "Tweens")[property] = connection
    end

    utility.newDrawing = function(class, properties)
        local object = Drawing.new(class)

        local clone = {}

        setmetatable(clone, {
            __index = function(self, index)
                return object[index] or rawget(clone, index)
            end,
            __newindex = function(self, index, value)
                local parent = rawget(clone, "Parent") 
                if index == "Position" then
                    if parent then
                        object["Position"] = parent["Position"] + value
                        rawset(clone, "FakePosition", value)
                    else
                        object[index] = value
                    end
                    for _, child in rawget(clone, "Children") do
                        child["Position"] = rawget(child, "FakePosition")
                    end
                elseif index == "Visible" then
                    for _, child in rawget(clone, "Children") do
                        child["Visible"] = value and not rawget(child, "Hidden")
                    end
                    object[index] = value
                else
                    object[index] = value
                end
            end
        })

        local function destroyObject()
            object:Remove()
            setmetatable(clone, nil)
            for _, child in clone.Children do
                child.Remove()
            end
            clone = nil
        end

        rawset(clone, "Remove", destroyObject)
        rawset(clone, "Destroy", destroyObject)
        rawset(clone, "Children", {})
        rawset(clone, "Tweens", {})

        if properties["Parent"] then 
            rawset(clone, "Parent", properties["Parent"])
            utility.insert(rawget(properties["Parent"], "Children"), clone)
            properties["Parent"] = nil
        end

        for property, value in properties do
            clone[property] = value
        end
        
        return clone
    end
end

------------------------
-- * SIGNAL LIBRARY * --
------------------------

local signal = {}

do

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
end

--------------------
-- * UI LIBRARY * --
--------------------

local menu = {
    busy = false,
    dragging = false,
    connections = {},
    click_connections = {},
    hover_connections = {},
    accent_color = Color3.fromRGB(225,0,0),
}

local on_opening = signal.new()
local on_closing = signal.new()

local window = {}; window.__index = window
local tab = {}; tab.__index = tab
local section = {}; section.__index = section
local element = {}; element.__index = element
local toggle = {}; toggle.__index = toggle

do
    local sword_image = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/sword%20pixel.png")
    local sword_hover = game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/sword_hover.png")

    local menu_connections = {
        connections = {}
    }

    utility.newConnection(on_opening, function()
        for _, connection in menu_connections.connections do
            connection[3] = utility.newConnection(connection[1], connection[2], true)
        end
    end, true)

    utility.newConnection(on_closing, function()
        for _, connection in menu_connections.connections do
            connection[3]:Disconnect()
            connection[3] = nil
        end
    end, true)

    menu_connections.newConnection = function(signal, callback)
        local connection = signal:Connect(callback)

        utility.insert(menu_connections.connections, {signal, callback, connection})

        return connection
    end

    function menu:init()
        local main_window = utility.newDrawing("Square", {
            Size = Vector2.new(550, 640),
            Position = workspace.CurrentCamera.ViewportSize/2-Vector2.new(240, 270),
            Visible = true,
            Filled = true,
            ZIndex = 1,
            Color = Color3.fromRGB(13,13,13)
        })
        local top_bar_border = utility.newDrawing("Square", {
            Size = Vector2.new(536, 42),
            Position = Vector2.new(7,7),
            Color = Color3.fromRGB(50,50,50),
            Filled = true,
            Visible = true,
            ZIndex = 2,
            Parent = main_window
        })
        local top_bar = utility.newDrawing("Square", {
            Size = Vector2.new(534, 40),
            Position = Vector2.new(1,1),
            Color = Color3.fromRGB(10,10,10),
            Filled = true,
            Visible = true,
            ZIndex = 3,
            Parent = top_bar_border
        })
        local overlay = utility.newDrawing("Square", {
            Size = Vector2.new(536, 0),
            Position = Vector2.new(7, 49),
            Color = Color3.fromRGB(13,13,13),
            Filled = true,
            Visible = true,
            ZIndex = 99,
            Parent = main_window
        })
        local top_text = utility.newDrawing("Text", {
            Size = 23,
            Color = Color3.fromRGB(226,226,226),
            Position = Vector2.new(8, 2),
            Visible = true,
            Text = "juju",
            ZIndex = 4,
            Font = 1,
            Parent = top_bar
        })
        local top_text_version = utility.newDrawing("Text", {
            Size = 13,
            Color = menu.accent_color,
            Position = Vector2.new(8, 25),
            Visible = true,
            Text = "beta",
            ZIndex = 4,
            Font = 1,
            Parent = top_bar
        })
        local sword_pixel = utility.newDrawing("Image", {
            Size = Vector2.new(38,38),
            Color = Color3.fromRGB(226,226,226),
            Visible = true,
            Data = sword_image,
            Position = Vector2.new(),
            ZIndex = 4,
            Parent = top_bar
        })

        local new_window = {
            tabs = {},
            active_tab = nil,
            top_bar = top_bar,
            is_open = true,
            active_tween = false,
            sword_image = sword_pixel,
            background = main_window,
            overlay = overlay,
            hotkey = "leftalt",
        }

        local click_connections = {}

        utility.newConnection(on_opening, LPH_NO_VIRTUALIZE(function()
            local property = {Transparency = 1}
            local info = {0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out}
            utility.tweenDrawing(main_window, info, property)
            utility.tweenDrawing(top_bar_border, info, property)
            utility.tweenDrawing(top_bar, info, property)
            utility.tweenDrawing(top_text, info, property)
            utility.tweenDrawing(top_text_version, info, property)
            utility.tweenDrawing(sword_pixel, info, property)
        end), true)

        utility.newConnection(on_closing, LPH_NO_VIRTUALIZE(function()
            local property = {Transparency = 0}
            local info = {0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out}
            utility.tweenDrawing(main_window, info, property)
            utility.tweenDrawing(top_bar_border, info, property)
            utility.tweenDrawing(top_bar, info, property)
            utility.tweenDrawing(top_text, info, property)
            utility.tweenDrawing(top_text_version, info, property)
            utility.tweenDrawing(sword_pixel, info, property)
        end), true)

        setmetatable(new_window, window)

        local hovering = nil

        menu_connections.newConnection(mouse.Move, LPH_NO_VIRTUALIZE(function()
            local new_hovering = nil
            for _, tab in new_window.tabs do
                local text = tab["text_object"]
                if utility.isInDrawing(text, uis:GetMouseLocation()) then
                    sword_pixel["Data"] = sword_hover
                    utility.tweenDrawing(sword_pixel, {0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Position = rawget(text, "FakePosition") - Vector2.new(8, 24)})

                    new_hovering = _
                end
            end
            hovering = new_hovering
            if hovering == nil or hovering == new_window["active_tab"] then
                local active_tab = new_window["tabs"][new_window["active_tab"]]
                sword_pixel["Data"] = sword_image
                active_tab["text_object"].Position = Vector2.new(rawget(active_tab["text_object"], "FakePosition").X, 6)
                local middle = active_tab["text_object"].Position + Vector2.new(active_tab["text_object"]["TextBounds"]["X"]/2, active_tab["text_object"]["TextBounds"]["Y"]/2)
                utility.tweenDrawing(sword_pixel, {0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Position = rawget(active_tab["text_object"], "FakePosition") + Vector2.new((active_tab["text_object"]["TextBounds"]["X"]/2) - 19, active_tab["text_object"]["TextBounds"]["Y"]/2 - 8)})
            else
                local active_tab = new_window["tabs"][new_window["active_tab"]]
                active_tab["text_object"].Position = Vector2.new(rawget(active_tab["text_object"], "FakePosition").X, 11)
            end
        end))
  
        utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
            if gpe then
                return end
            local position = uis:GetMouseLocation()
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and new_window.is_open then
                if not menu.dragging and not menu.busy then
                    if hovering then
                        new_window:setActiveTab(hovering)
                    elseif utility.isInDrawing(main_window, position) then
                        menu.dragging = true

                        local mouse_location = uis:GetMouseLocation()
                        local start_pos_x = mouse_location.X
                        local start_pos_y = mouse_location.Y
                        local obj_pos_x = main_window.Position.X
                        local obj_pos_y = main_window.Position.Y

                        while menu.dragging and not menu.busy do
                            mouse_location = uis:GetMouseLocation()
                            main_window.Position = Vector2.new(obj_pos_x - (start_pos_x - mouse_location.X), obj_pos_y - (start_pos_y - mouse_location.Y))
                            task.wait()
                        end
                    end
                end
            elseif string.lower(input.KeyCode.Name) == new_window["hotkey"] then
                if not menu.active_tween then
                    if new_window.is_open then
                        new_window:close()
                    else
                        new_window:open()
                    end 
                end
            end
        end))

        menu_connections.newConnection(uis.InputEnded, LPH_NO_VIRTUALIZE(function(input, gpe)
            if gpe then
                return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                menu.dragging = false
            end
        end))

        return new_window
    end

    function window:open()
        self.is_open = true
        self.active_tween = true
        task.delay(0.15, function()
            self.active_tween = false
        end)
        on_opening:Fire()
    end

    function window:close()
        self.is_open = false
        self.active_tween = true
        task.delay(0.15, function()
            self.active_tween = false
        end)
        on_closing:Fire()
    end

    function window:setActiveTab(active)
        if self["active_tween"] then
            return 
        end
        self["active_tween"] = true
        local old_active = self.active_tab
        if old_active then
            old_active = self.tabs[old_active]
            old_active["text_object"].Position = Vector2.new(rawget(old_active["text_object"], "FakePosition").X, 11)
            old_active["text_object"]["Color"] = Color3.fromRGB(176,176,176)
        end
        local active_tab = self.tabs[active]
        active_tab["text_object"]["Color"] = menu.accent_color
        active_tab["text_object"].Position = Vector2.new(rawget(active_tab["text_object"], "FakePosition").X, 6)
        local middle = active_tab["text_object"].Position + Vector2.new(active_tab["text_object"]["TextBounds"]["X"]/2, active_tab["text_object"]["TextBounds"]["Y"]/2)
        utility.tweenDrawing(self["sword_image"], {0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {Position = rawget(active_tab["text_object"], "FakePosition") + Vector2.new((active_tab["text_object"]["TextBounds"]["X"]/2) - 19, active_tab["text_object"]["TextBounds"]["Y"]/2 - 8)})

        self["active_tab"] = active
        task.delay(0.01, function()
            self["sword_image"]["Data"] = sword_image
        end)
        for i = 1, 6 do
			local blood_effect = utility.newDrawing("Square", {
                Filled = true,
                Color = menu.accent_color,
                Size = Vector2.new(6,6),
                Visible = true,
                ZIndex = 5,
                Position = middle
            })

            utility.tweenDrawing(blood_effect, {0.55, Enum.EasingStyle.Circular, Enum.EasingDirection.Out}, {Position = middle + Vector2.new(math.random(-45,45), -math.random(35,45))})
            utility.tweenDrawing(blood_effect, {0.55, Enum.EasingStyle.Circular, Enum.EasingDirection.Out}, {Transparency = 0})

			task.delay(0.5, function()
				blood_effect:Destroy()
			end)
		end
        if old_active then
            old_active["visible"] = false
        end
        active_tab["visible"] = true
        utility.tweenDrawing(self["overlay"], {0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {Size = Vector2.new(536, 591)})
        task.wait(0.3)
        if old_active then
            old_active["tab_object"]["Visible"] = false
        end
        active_tab["tab_object"]["Visible"] = true
        utility.tweenDrawing(self["overlay"], {0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {Position = Vector2.new(7, 640)})
        utility.tweenDrawing(self["overlay"], {0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {Size = Vector2.new(536, 0)})

        task.delay(0.3, function()
            task.wait()
            self["active_tween"] = false
            self["overlay"]["Position"] = Vector2.new(7, 49)
        end)
    end

    function window:newTab(name)
        local text = utility.newDrawing("Text", {
            Color = Color3.fromRGB(176,176,176),
            Text = name,
            Parent = self.top_bar,
            Font = 1,
            Size = 18,
            Visible = true,
            ZIndex = 4,
        })
        local main_frame = utility.newDrawing("Square", {
            Parent = self.background,
            Visible = false,
            Transparency = 0,
            Size = Vector2.new(534, 576),
            Position = Vector2.new(7, 56),
            ZIndex = 0,
        })

        local offset = 3 + text["TextBounds"]["X"]
        local count = 0
        for _, tab in self.tabs do
            count+=1
            offset+=(tab["text_object"]["TextBounds"]["X"] + 8)
        end

        text["Position"] = Vector2.new(534 - offset, 11)

        local new_tab = {
            text_object = text,
            tab_object = main_frame,
            visible = false,
            sections = {}
        }

        setmetatable(new_tab, tab)

        self.tabs[name] = new_tab

        if count == 0 then
            self:setActiveTab(name)
        end

        utility.newConnection(on_opening, LPH_NO_VIRTUALIZE(function()
            local property = {Transparency = 1}
            local info = {0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out}
            utility.tweenDrawing(text, info, property)
        end), true)

        utility.newConnection(on_closing, LPH_NO_VIRTUALIZE(function()
            local property = {Transparency = 0}
            local info = {0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out}
            utility.tweenDrawing(text, info, property)
        end), true)

        return new_tab
    end

    function tab:newSection(name, side, size, y_pos)
        local frame = utility.newDrawing("Square", {
            Parent = self["tab_object"],
            Size = Vector2.new(264, size or 30),
            Color = Color3.fromRGB(50,50,50),
            Position = Vector2.new(side == "left" and 0 or 272, y_pos),
            Filled = true,
            ZIndex = 5,
        })
        local inside = utility.newDrawing("Square", {
            Size = Vector2.new(262, (size and size-2) or 28),
            Position = Vector2.new(1, 1),
            Color = Color3.fromRGB(13,13,13),
            Filled = true,
            Parent = frame,
            ZIndex = 6,
        })
        local text = utility.newDrawing("Text", {
            Color = Color3.fromRGB(226,226,226),
            Parent = frame,
            Position = Vector2.new(8, 8),
            Size = 16,
            Text = name,
            Font = 1,
            Outline = true,
            ZIndex = 8,
        })

        local offset = 0

        for section_name, section in self["sections"] do
            if section["side"] == side then
                offset+=(section["size"]+8)
            end
        end

        utility.newConnection(on_opening, LPH_NO_VIRTUALIZE(function()
            if not self["visible"] then
                return end

            local property = {Transparency = 1}
            local info = {0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out}
            utility.tweenDrawing(frame, info, property)
            utility.tweenDrawing(inside, info, property)
            utility.tweenDrawing(text, info, property)
            utility.tweenDrawing(divider, info, property)
        end), true)

        utility.newConnection(on_closing, LPH_NO_VIRTUALIZE(function()
            if not self["visible"] then
                return end

            local property = {Transparency = 0}
            local info = {0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out}
            utility.tweenDrawing(frame, info, property)
            utility.tweenDrawing(inside, info, property)
            utility.tweenDrawing(text, info, property)
            utility.tweenDrawing(divider, info, property)
        end), true)

        local new_section = {
            content_size = 0,
            auto_scale = size == nil,
            inside = inside,
            elements = {}
        }

        setmetatable(new_section, section)

        return new_section
    end

    function section:newElement(args)
        local y_offset = 10
        local element_pos = #self["elements"]

        for i = 1, element_pos do
            local element = self["elements"][i]
            y_offset+=(element["content_size"] + 2)
        end

        local y_size = 0
        local label = utility.newDrawing("Text", {
            Position = Vector2.new(args["indent"] and 42 or 25, y_offset),
            Text = args["text"],
            Font = 1,
            Outline = true,
            Size = 16,
            Visible = true,
            Color = Color3.fromRGB(176,176,176),
            Parent = self["inside"],
            ZIndex = 8
        })
        y_size+=label["TextBounds"]["Y"]

        local new_element = {
            content_size = y_size
        }

        setmetatable(new_element, element)

        for name, info in args["elements"] do
            if name == "toggle" then
                new_element["toggle"] = toggle.new(label, info)
            end
        end

        utility.insert(self["elements"], new_element)

        return new_element
    end

    function toggle.new(label, args)
        local box = utility.newDrawing("Square", {
            Position = rawget(label, "FakePosition") - Vector2.new(17,-3),
            ZIndex = 8,
            Size = Vector2.new(10,10),
            Color = Color3.fromRGB(50,50,50),
            Parent = rawget(label, "Parent")
        })
        local inside = utility.newDrawing("Square", {
            Position = Vector2.new(1,1),
            ZIndex = 9,
            Filled = true,
            Size = Vector2.new(8,8),
            Color = Color3.fromRGB(13,13,13),
            Parent = box
        })
    end
end

local window = menu:init()

local settings = window:newTab("settings")
local visuals = window:newTab("visuals")
local legit = window:newTab("legit")
local rage = window:newTab("rage")

local a = rage:newSection("aimbot", "left", 500, 0)
    a:newElement({
        text = "enabled", 
        elements = {
            toggle = {}
        }
    })
    a:newElement({
        text = "resolver", 
        indent = true,
        elements = {
            toggle = {}
        }
    })
rage:newSection("visualization", "right", 500, 0)


legit:newSection("awesome", "left", 500, 0)
legit:newSection("coolness", "right", 500, 0)