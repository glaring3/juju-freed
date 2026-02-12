-- * Service & Cache Variables

local uis = game:GetService("UserInputService")
local hs = game:GetService("HttpService")
local cg = game:GetService("CoreGui")

-- * UI Utility

local utility = {
	is_dragging_blocked = false
}

do
	local newInstance = Instance.new

	utility.setDraggable = function(object)
		local dragging = false

		object.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 and not utility.is_dragging_blocked then
				local mouse_location = uis:GetMouseLocation()
				local startPosX = mouse_location.X
				local startPosY = mouse_location.Y
				local objPosX = object.Position.X.Offset
				local objPosY = object.Position.Y.Offset
				dragging = true
				task.spawn(function()
					while dragging and not utility.is_dragging_blocked do
						mouse_location = uis:GetMouseLocation()
						object.Position = UDim2.new(0, objPosX - (startPosX - mouse_location.X), 0, objPosY - (startPosY - mouse_location.Y))
						task.wait()
					end
				end)
			end
		end)

		object.InputEnded:Connect(function(input, gpe)
			if gpe then return end
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	end

	utility.newObject = function(class, properties)
		local object = newInstance(class)

		for property, value in pairs(properties) do
			object[property] = value
		end

		object.Name = hs:GenerateGUID(false)

		return object
	end
end

-- * UI

local menu = {}
local window = {}
window.__index = window
local tab = {}
tab.__index = tab
local section = {}
section.__index = section

do
	local newObject = utility.newObject

	local _screenGui = newObject("ScreenGui", {
		Parent = game.Players.LocalPlayer.PlayerGui
	})

	function menu:init(tabs)
		local Border = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(60, 60, 60);
			BorderColor3 = Color3.fromRGB(12, 12, 12);
			Position = UDim2.new(0, 500, 0, 300);
			Size = UDim2.new(0, 658, 0, 558);
			Parent = _screenGui
		})
		local Border2 = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			BorderColor3 = Color3.fromRGB(40, 40, 40);
			Position = UDim2.new(0, 2, 0, 2);
			Size = UDim2.new(1, -4, 1, -4);
			Parent = Border;
		})
		local Background = newObject("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderColor3 = Color3.fromRGB(60, 60, 60);
			Position = UDim2.new(0, 3, 0, 3);
			Size = UDim2.new(1, -6, 1, -6);
			Image = "rbxassetid://15453092054";
			ScaleType = Enum.ScaleType.Tile;
			TileSize = UDim2.new(0, 4, 0, 548);
			Parent = Border2
		})
		local TabHolder = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12);
			BackgroundTransparency = 1.000;
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 0, 14);
			Size = UDim2.new(0, 73, 0, 0);
			Parent = Background
		})
		local TabLayout = newObject("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Parent = TabHolder
		})
		local TopGap = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(0, 73, 0, 14);
			Parent = Background
		})
		local TopSideFix = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 73, 0, 0);
			Size = UDim2.new(0, 1, 1, 0);
			Parent = TopGap
		})
		local TopSideFix2 = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(1, 0, 0, 0);
			Size = UDim2.new(0, 1, 1, 0);
			Parent = TopSideFix
		})
		local BottomGap = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 1, -22);
			Size = UDim2.new(0, 73, 0, 22);
			Parent = Background
		})
		local BottomSideFix = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 73, 0, 0);
			Size = UDim2.new(0, 1, 1, 0);
			Parent = BottomGap
		})
		local BottomSideFix2 = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(1, 0, 0, 0);
			Size = UDim2.new(0, 1, 1, 0);
			Parent = BottomSideFix
		})
		local TopBar_2 = newObject("ImageLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderColor3 = Color3.fromRGB(12, 12, 12);
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 0, 2);
			ZIndex = 2;
			Image = "rbxassetid://15453122383";
			Parent = Background
		})
		local BlackBar = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(6, 6, 6);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 0, 1, 0);
			Size = UDim2.new(1, 0, 0, 1);
			ZIndex = 2;
			Parent = TopBar_2
		})

		utility.setDraggable(Border)

		local new_window = {
			tab_holder = TabHolder,
            active_tab = nil,
			background = Background,
			tabs = {}
		}

		setmetatable(new_window, window)

		local window_tabs = new_window.tabs
		local is_first_tab = true
		
		for int = 1, 8 do
			new_window:_registerTab(int, tabs[int], is_first_tab)
			is_first_tab = false
		end

		return new_window
	end

	function window:_registerTab(int, info, is_first_tab)
		local new_tab = {
			sections = {},
			is_open = false
		}

        local Button = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(12, 12, 12);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(0, 73, 0, 64);
            Parent = self.tab_holder
        })
        local BottomBar = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, 1);
            Size = UDim2.new(1, 0, 0, 1);
            Visible = false;
            ZIndex = 2;
            Parent = Button
        })
        local BottomBar2 = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, -1);
            Size = UDim2.new(1, 2, 1, 0);
            ZIndex = 2;
            Parent = BottomBar
        })
        local Icon = newObject("ImageLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            Image = info.icon;
            ImageColor3 = Color3.fromRGB(109, 109, 109);
            Parent = Button
        })
        local TopBar = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, -2);
            Size = UDim2.new(1, 0, 0, 1);
            Visible = false;
            ZIndex = 2;
            Parent = Button
        })
        local TopBar2 = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 0, 1);
            Size = UDim2.new(1, 2, 1, 0);
            ZIndex = 2;
            Parent = TopBar
        })
        local SideBar = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 73, 0, 0);
            Size = UDim2.new(0, 1, 1, 0);
            Parent = Button
        })
        local SideBar2 = newObject("Frame", {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0, 1, 1, 0);
            Parent = SideBar    
        })

		local _Tab = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 96, 0, 23);
			Size = UDim2.new(0, 532, 0, 506);
			Visible = false;
			Parent = self.background
		})

		Button.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 then
				if self.active_tab == int then return end
				self:_setActiveTab(int)
			end
		end)

		Button.MouseEnter:Connect(function()
			if self.active_tab == int then return end
			Icon.ImageColor3 = Color3.fromRGB(204, 204, 204)
		end)

		Button.MouseLeave:Connect(function()
			if self.active_tab == int then return end
			Icon.ImageColor3 = Color3.fromRGB(109, 109, 109)
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
			tab.icon.ImageColor3 = is_active_tab and Color3.fromRGB(255,255,255) or Color3.fromRGB(109,109,109)
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

	local _minimumSize = {
		x = 0.11,
		y = 0.048
	}

	function tab:newSection(info)
		local Section = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(12, 12, 12);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Size = UDim2.new(0.5, -9, info.scale, -9);
			Parent = self.frame
		})
		local Inside = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			Parent = Section
		})
		local Inside2 = newObject("Frame", {
			BackgroundColor3 = Color3.fromRGB(23, 23, 23);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 1, 0, 1);
			Size = UDim2.new(1, -2, 1, -2);
			Parent = Inside
		})
		local SectionLabel = newObject("TextLabel", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0, 12, 0, -2);
			Font = Enum.Font.SourceSansBold;
			Text = info.name;
			TextColor3 = Color3.fromRGB(198, 198, 198);
			TextSize = 14.000;
			TextXAlignment = Enum.TextXAlignment.Left;
			Parent = Inside2
		})

		local new_section = {
			frame = Section
		}

		setmetatable(new_section, section)

		if info.is_changeable then
			local DragImage = newObject("ImageLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(1, -5, 1, -5);
				Size = UDim2.new(0, 5, 0, 5);
				Image = "rbxassetid://15501723105";
				Parent = Inside2
			})

			local Frame = self.frame

			local isMoving = false
			local isDragging = false

			DragImage.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mouseLocation = uis:GetMouseLocation()
					if not isDragging then
						isDragging = true
						utility.is_dragging_blocked = true
						task.spawn(function()
							while isDragging do
								local minimumXDistance = Frame.AbsoluteSize.X/20
								local minimumYDistance = Frame.AbsoluteSize.Y/20
								local _mouseLocation = uis:GetMouseLocation()
								local xDifference = _mouseLocation.X-mouseLocation.X 
								local yDifference = _mouseLocation.Y-mouseLocation.Y
								if math.abs(xDifference) > minimumXDistance or math.abs(yDifference) > minimumYDistance then
									local xAdd = math.round(xDifference/minimumXDistance)
									local yAdd = math.round(yDifference/minimumYDistance)
									absolutePosition = SectionLabel.AbsolutePosition
									mouseLocation = uis:GetMouseLocation()
									Section.Size = UDim2.new(math.clamp(Section.Size.X.Scale + xAdd * 0.05, 0.11, 1), Section.Size.X.Offset, math.clamp(Section.Size.Y.Scale + yAdd * 0.05, 0.048, 1), Section.Size.Y.Offset)
								end
								task.wait()
							end
						end)
					end
				end
			end)

			local function collidesWith(gui1, gui2)
				local gui1_topLeft = gui1.AbsolutePosition
				local gui1_bottomRight = gui1_topLeft + gui1.AbsoluteSize
			
				local gui2_topLeft = gui2.AbsolutePosition
				local gui2_bottomRight = gui2_topLeft + gui2.AbsoluteSize
				 
				return ((gui1_topLeft.x < gui2_bottomRight.x and gui1_bottomRight.x > gui2_topLeft.x) and (gui1_topLeft.y < gui2_bottomRight.y and gui1_bottomRight.y > gui2_topLeft.y))
			end

			Section.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local absolutePosition = SectionLabel.AbsolutePosition
					local mouseLocation = uis:GetMouseLocation()
					if mouseLocation.Y - absolutePosition.Y < 50 then
						isMoving = true
						utility.is_dragging_blocked = true

						task.spawn(function()
							while isMoving do
								local minimumXDistance = Frame.AbsoluteSize.X/20
								local minimumYDistance = Frame.AbsoluteSize.Y/20
								local _mouseLocation = uis:GetMouseLocation()
								local xDifference = _mouseLocation.X-mouseLocation.X 
								local yDifference = _mouseLocation.Y-mouseLocation.Y
								local oldPosition = Section.Position
								if math.abs(xDifference) > minimumXDistance or math.abs(yDifference) > minimumYDistance then
									local xAdd = math.round(xDifference/minimumXDistance)
									local yAdd = math.round(yDifference/minimumYDistance)
									absolutePosition = SectionLabel.AbsolutePosition
									mouseLocation = uis:GetMouseLocation()
									Section.Position = UDim2.new(math.clamp(Section.Position.X.Scale + xAdd * 0.05, 0, 0.5), Section.Position.X.Offset, math.clamp(Section.Position.Y.Scale + yAdd * 0.05, 0, 1), Section.Position.Y.Offset)
									for _, section in pairs(self.sections) do
										if section.frame == Section then continue end
										if collidesWith(section.frame, Section) then
											local oldSize = section.frame.Size
											local _oldPosition = section.frame.Position
											section.frame.Position = oldPosition
											section.frame.Size = Section.Size
											Section.Size = oldSize
											Section.Position = _oldPosition
											continue
										end
									end
								end
								task.wait()
							end
						end)
					end
				end
			end)

			DragImage.InputEnded:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if isDragging then isDragging = false; utility.is_dragging_blocked = false end
				end
			end)

			Section.InputEnded:Connect(function(input, gpe)
				if gpe then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if isMoving then isMoving = false; utility.is_dragging_blocked = false end
				end
			end)
		end

		self.sections[info.name] = new_section

		return new_section
	end


end

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
	}
)

local rage = window:getTab(1)
rage:newSection({
	name = "Aimbot",
	is_changeable = true,
	scale = 0.1
})

task.wait(5)

rage:newSection({
	name = "Tww",
	is_changeable = true,
	scale = 0.2
})