
local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))
local TeamPlayersContainer = require(script.Parent.TeamPlayersContainer)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local PlayerComponent = require(script.Parent.Player)
local BlipContainerComponent = require(script.Parent.BlipContainer)
local CompassComponent = require(script.Parent.Compass)

local events = script.Parent.Parent.Parent.Events

local mainMinimap = Roact.Component:extend("MainMinimap")





function mainMinimap:init()
	self:setState({
		isLargeMap = false,
	})

	-- Bind M key for toggling large map
	self.inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.M then
			self:toggleLargeMap()
		end
	end)
end



function mainMinimap:toggleLargeMap()
	local newState = not self.state.isLargeMap
	Settings["Technical"]["isLargeMap"] = newState

	self:setState({
		isLargeMap = newState,
	})

	local mapBorder = self.mapBorderRef
	if mapBorder then
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local targetProps
		if newState then
			targetProps = {
				Size = Settings["Gui"]["largeMapSize"] + UDim2.new(0, Settings["Gui"]["borderSize"]*2, 0, Settings["Gui"]["borderSize"]*2),
				Position = Settings["Gui"]["largeMapPosition"] + UDim2.new(0, 0, 0, 5), -- jemný posun pro efekt "slide"
				AnchorPoint = Settings["Gui"]["largeMapAnchorPoint"],
			}
		else
			targetProps = {
				Size = Settings["Gui"]["mapSize"] + UDim2.new(0, Settings["Gui"]["borderSize"]*2, 0, Settings["Gui"]["borderSize"]*2),
				Position = Settings["Gui"]["mapPosition"] - UDim2.new(0, 0, 0, 5), -- posun zpět
				AnchorPoint = Settings["Gui"]["anchorPoint"],
			}
		end

		local tween = TweenService:Create(mapBorder, tweenInfo, targetProps)
		tween:Play()
	end




end

function mainMinimap:handleZoomIn()
	local currentZoom = Settings["Technical"]["zoomLevel"]
	local newZoom = math.min(currentZoom + Settings["Technical"]["zoomStep"], Settings["Technical"]["maxZoom"])
	Settings["Technical"]["zoomLevel"] = newZoom



	-- Force update
	self:setState({})
end

function mainMinimap:handleZoomOut()
	local currentZoom = Settings["Technical"]["zoomLevel"]
	local newZoom = math.max(currentZoom - Settings["Technical"]["zoomStep"], Settings["Technical"]["minZoom"])
	Settings["Technical"]["zoomLevel"] = newZoom

	print("Zoom Out - New zoom level:", newZoom)

	-- Force update
	self:setState({})
end

function mainMinimap:render()
	local vps = Vector2.new(1920,1080)
	local mapsize = self.state.isLargeMap and Settings["Gui"]["largeMapSize"] or Settings["Gui"]["mapSize"]
	local mapPosition = self.state.isLargeMap and Settings["Gui"]["largeMapPosition"] or Settings["Gui"]["mapPosition"]
	local anchorPoint = self.state.isLargeMap and Settings["Gui"]["largeMapAnchorPoint"] or Settings["Gui"]["anchorPoint"]

	local y = (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y) / (math.tan(math.rad(35)) * 2)) + (mapsize.X.Offset + (mapsize.X.Scale*vps.X) / 2)
	Settings["Y"] = y

	if not Settings["Gui"]["Ratio"] then
		Settings["Ratio"] = (mapsize.X.Offset + (mapsize.X.Scale*vps.X)) / (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y))
	else
		Settings["Ratio"] = Settings["Gui"]["Ratio"]
	end

	local parts = {
		Roact.createElement("UICorner", {
			CornerRadius = Settings["Gui"]["mapCornerRoundness"];
		});
	}

	--Create all parts
	if Settings["Map"]["mapId"] then
		--Insert the map like normal
		if RunService:IsStudio() then
			warn("This minimap uses the legacy map method. Consider switching to the new method!")
		end

		table.insert(parts, Roact.createElement("Part", { --The is the map that will be displayed :D
			Size = Vector3.new(Settings["Map"]["size"].X / Settings["Divide"], 0, Settings["Map"]["size"].Y / Settings["Divide"]);
			Position = Settings["Map"]["mapCenter"] and Vector3.new(Settings["Map"]["mapCenter"].X, 0, Settings["Map"]["mapCenter"].Z) / Settings["Divide"] or Vector3.new(0,0,0);
			Orientation = Vector3.new(0, Settings["Technical"]["mapRotation"], 0);
			Transparency = 1
		}, {
			Roact.createElement("Decal", { --Put the textureid here :DDDDDDD
				Texture = "rbxassetid://"..Settings["Map"]["mapId"];
				Face = "Top";
			})
		}))
	else
		--Add all images to parts table
		for _, data in Settings["Map"]["images"] do
			local mapPosition = if data.center then data.center else Vector3.new(0,0,0)

			table.insert(parts, Roact.createElement("Part", { --The is the map that will be displayed :D
				Size = Vector3.new(data.size.X / Settings["Divide"], 0, data.size.Y / Settings["Divide"]);
				Position =  Vector3.new(mapPosition.X, 0, mapPosition.Z) / Settings["Divide"];
				Orientation = Vector3.new(0, Settings["Technical"]["mapRotation"], 0);
				Transparency = 1
			}, {
				Roact.createElement("Decal", { --Put the textureid here :DDDDDDD
					Texture = "rbxassetid://"..data.mapId;
					Face = "Top";
				})
			}))
		end
	end

	-- Create zoom buttons
	local zoomButtons = {
		-- Zoom In Button (+)
		ZoomInButton = Roact.createElement("TextButton", {
			Name = "ZoomInButton",
			Size = Settings["Gui"]["zoomButtonSize"],
			Position = UDim2.new(1, -5, 0, 5),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Settings["Gui"]["zoomButtonColor"],
			BackgroundTransparency = Settings["Gui"]["zoomButtonTransparency"],
			BorderSizePixel = 0,
			Text = "+",
			TextColor3 = Settings["Gui"]["zoomButtonTextColor"],
			TextSize = 24,
			Font = Enum.Font.SourceSansBold,
			ZIndex = 15,

			[Roact.Event.MouseButton1Click] = function()
				self:handleZoomIn()
			end,
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 5)
			}),
			Roact.createElement("UIStroke", {
				Color = Color3.fromRGB(255, 255, 255),
				Transparency = 0.7,
				Thickness = 1,
			})
		}),

		-- Zoom Out Button (-)
		ZoomOutButton = Roact.createElement("TextButton", {
			Name = "ZoomOutButton",
			Size = Settings["Gui"]["zoomButtonSize"],
			Position = UDim2.new(1, -5, 0, 40),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Settings["Gui"]["zoomButtonColor"],
			BackgroundTransparency = Settings["Gui"]["zoomButtonTransparency"],
			BorderSizePixel = 0,
			Text = "-",
			TextColor3 = Settings["Gui"]["zoomButtonTextColor"],
			TextSize = 24,
			Font = Enum.Font.SourceSansBold,
			ZIndex = 15,

			[Roact.Event.MouseButton1Click] = function()
				self:handleZoomOut()
			end,
		}, {
			Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 5)
			}),
			Roact.createElement("UIStroke", {
				Color = Color3.fromRGB(255, 255, 255),
				Transparency = 0.7,
				Thickness = 1,
			})
		}),
	}

	return Roact.createElement("ScreenGui", {
		Name = "Minimap";
		ResetOnSpawn = false;
		Enabled = Settings["Technical"]["Visible"];
		ZIndexBehavior = Enum.ZIndexBehavior.Global;
	}, {
		Background = Roact.createElement("Frame", { --This is the border.
			Name = "MinimapBorder";

			Size = mapsize + UDim2.new(0, Settings["Gui"]["borderSize"]*2, 0, Settings["Gui"]["borderSize"]*2);
			AnchorPoint = anchorPoint;
			Position = mapPosition;
			BackgroundColor3 = Settings["Gui"]["borderColor"];
			BackgroundTransparency = Settings["Gui"]["borderTransparency"];
			BorderSizePixel = 0;

			[Roact.Ref] = function(rbx)
				self.mapBorderRef = rbx
			end,
		},{
			Roact.createElement("UIAspectRatioConstraint", {
				DominantAxis = Enum.DominantAxis.Width;
				AspectType = Enum.AspectType.FitWithinMaxSize;
				AspectRatio = Settings["Ratio"];
			});

			-- Scale constraint for responsive design
			Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(150, 150), -- Minimum size for mobile
				MaxSize = Vector2.new(2000, 2000), -- Maximum size
			});

			Roact.createElement("UICorner", {
				CornerRadius = Settings["Gui"]["borderCornerRoundness"]
			});

			Compass = Settings["Gui"]["showCompass"] and Roact.createElement(CompassComponent) or nil;

			-- PLAYER IKONA - MIMO VIEWPORTFRAME
			-- ZÅ¯stane vÅ¾dy na mÃ­stÄ› (uprostÅ™ed) pÅ™i draggingu
			PlayerIcon = Roact.createElement(PlayerComponent, {
				isLargeMap = self.state.isLargeMap,
			});

			Map = Roact.createElement("ViewportFrame", { --This is the map gui.
				Name = "Map";

				Size = UDim2.new(1, -Settings["Gui"]["borderSize"]*2, 1, -Settings["Gui"]["borderSize"]*2);
				AnchorPoint = Vector2.new(.5,.5);
				Position = UDim2.new(.5,0,.5,0);
				BackgroundColor3 = Settings["Gui"]["mapColor"];
				BackgroundTransparency = Settings["Gui"]["mapTransparency"];
				BorderSizePixel = 0;
				CurrentCamera = game.Workspace.MinimapCamera;
				ZIndex = 5,
			}, Roact.createFragment(parts));

			BlipContainer = Roact.createElement(BlipContainerComponent);

			TeamPlayersContainer = Roact.createElement(TeamPlayersContainer, {
				isLargeMap = self.state.isLargeMap,
			});

			-- Add zoom buttons
			ZoomButtons = Roact.createFragment(zoomButtons);
		})
	})
end

function mainMinimap:didMount()
	self.updateEvent = events.Update.Event:connect(function()
		self:setState(function(state)
			return{}
		end)
	end)
end

function mainMinimap:willUnmount()
	self.updateEvent:Disconnect()

	if self.inputConnection then
		self.inputConnection:Disconnect()
	end
end

return mainMinimap