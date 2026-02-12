-- * Global Variables

local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")
local lplr = players.LocalPlayer
local mouse = lplr:GetMouse()

-- * Main Utility

local signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua"))()

local lib = {
    busy = false,
    accent_color = Color3.fromRGB(170, 170, 255),
    on_gui_move = signal.new("on_gui_move"),
    open = true
}

local utility = {
    connections = {}
}

function utility.insert(array, object)
    array[#array+1] = object
end

function utility.new_connection(signal, callback)
    local connection = signal:Connect(callback)
    utility.insert(utility.connections, connection)
    return connection
end

-- * Drawing Utility

local drawing = {}

do
    local new_drawing = Drawing.new

    function drawing.new(class, properties)
        local object = new_drawing(class)

        for property, value in pairs(properties) do
            object[property] = value
        end

        return object
    end

    function drawing:is_in_square(object)
        local abs_pos = object.Position
        local abs_size = object.Size
        local mouse_pos = uis:GetMouseLocation()
        local m_x, m_y = mouse_pos.X, mouse_pos.Y
        local p_x, p_y = abs_pos.X, abs_pos.Y

        local x = p_y <= m_y and m_y <= p_y + abs_size.Y
        local y = p_x <= m_x and m_x <= p_x + abs_size.X
    
        return (x and y)
    end

    function drawing:tween_integer(object, property, tween_info)
        local time_elapsed = 0
        local duration = tween_info.time
        local style = tween_info.style
        local direction = tween_info.direction
        local goal = tween_info.goal
        local current = object[property]
        local on_heartbeat = nil; on_heartbeat = utility.new_connection(rs.Heartbeat, function(dt)
            time_elapsed+=dt
            object[property] = current + (goal-current) * ts:GetValue((time_elapsed / duration), style, direction)
            if time_elapsed > duration then
                on_heartbeat:Disconnect()
                object[property] = goal
            end
        end)

        return on_heartbeat
    end

    function drawing:set_draggable(object, signal)
        local dragging = false
        utility.new_connection(uis.InputBegan, function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not lib.busy and drawing:is_in_square(object) then
                local position = object.Position
                local original_mouse_position = uis:GetMouseLocation()

                dragging = true

                while dragging do
                    object.Position = position + (uis:GetMouseLocation()-original_mouse_position)
                    if signal then
                        signal:Fire(object.Position)
                    end
                    task.wait()
                end
            end
        end)

        utility.new_connection(uis.InputEnded, function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
end

local drawing_mouse = {
    [1] = drawing.new("Triangle", {Visible = true, ZIndex = 999, Filled = true, Transparency = 1, Color = Color3.fromRGB(226,226,226)})
}

function drawing_mouse.move(position)
    local x,y = position.X, position.Y
    local triangle = drawing_mouse[1]
    triangle.PointA = Vector2.new(x, y + 36)
    triangle.PointB = Vector2.new(x, y + 36 + 15)
    triangle.PointC = Vector2.new(x + 10, y + 46)
end

-- * UI Library

function lib.new()
    local background = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = false, Transparency = 0.9, Position = Vector2.new(300, 300), Size = Vector2.new(522,610), Color = Color3.fromRGB(0,0,0)})
    local background2 = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = false, Transparency = 0.9, Position = Vector2.new(301, 301), Size = Vector2.new(520,608), Color = Color3.fromRGB(76,76,76)})
    local background3 = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = false, Transparency = 0.4, Position = Vector2.new(302, 302), Size = Vector2.new(518,606), Color = Color3.fromRGB(55,55,55)})
    local background4 = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = false, Transparency = 0.4, Position = Vector2.new(303, 303), Size = Vector2.new(516,604), Color = Color3.fromRGB(55,55,55)})
    local background5 = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = false, Transparency = 0.4, Position = Vector2.new(304, 304), Size = Vector2.new(514,602), Color = Color3.fromRGB(55,55,55)})
    local background6 = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = false, Transparency = 0.9, Position = Vector2.new(305, 305), Size = Vector2.new(512,600), Color = Color3.fromRGB(76,76,76)})
    local background7 = drawing.new("Square", {Visible = true, ZIndex = 1, Thickness = 1, Filled = true, Transparency = 0.6, Position = Vector2.new(306, 306), Size = Vector2.new(510,598), Color = Color3.fromRGB(0,0,0)})

    drawing:set_draggable(background, lib.on_gui_move)

    utility.new_connection(lib.on_gui_move, function(position)
        background2.Position = position + Vector2.new(1,1)
        background3.Position = position + Vector2.new(2,2)
        background4.Position = position + Vector2.new(3,3)
        background5.Position = position + Vector2.new(4,4)
        background6.Position = position + Vector2.new(5,5)
        background7.Position = position + Vector2.new(6,6)
    end)

    utility.new_connection(mouse.Move, function()
        drawing_mouse.move(Vector2.new(mouse.X, mouse.Y))
    end)
end

lib.new()