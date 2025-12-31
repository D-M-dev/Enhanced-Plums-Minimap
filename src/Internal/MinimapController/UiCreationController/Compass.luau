

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))

local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera

local compass = Roact.Component:extend("Compass")

function compass:init()
	self:setState({
		heading = 0,
	})
end

function compass:render()
	local heading = self.state.heading

	local directions = {
		{ label = "S", offset = 0 },
		{ label = "SV", offset = 45 },
		{ label = "V", offset = 90 },
		{ label = "JV", offset = 135 },
		{ label = "J", offset = 180 },
		{ label = "JZ", offset = 225 },
		{ label = "Z", offset = 270 },
		{ label = "SZ", offset = 315 },
	}

	local directionElements = {}

	for _, dir in ipairs(directions) do
		local relativeAngle = (dir.offset - heading + 180) % 360 - 180

		if math.abs(relativeAngle) <= 90 then
			local xPos = 0.5 + (relativeAngle / 180)
			local isMainDirection = dir.label == "S" or dir.label == "J" or dir.label == "V" or dir.label == "Z"

			directionElements[dir.label] = Roact.createElement("TextLabel", {
				Name = dir.label;
				Size = UDim2.new(0, 22, 0, 16);
				Position = UDim2.new(xPos, 0, 0.5, 0);
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundTransparency = 1;
				Text = dir.label;
				TextColor3 = isMainDirection 
					and Color3.fromRGB(255, 255, 255) 
					or Color3.fromRGB(120, 120, 120);
				TextSize = isMainDirection and 11 or 9;
				Font = isMainDirection and Enum.Font.GothamBold or Enum.Font.Gotham;
				TextTransparency = math.abs(relativeAngle) / 120;
				ZIndex = 22;
			})
		end
	end

	return Roact.createElement("Frame", {
		Name = "Compass";
		Size = Settings["Gui"]["compassSize"];
		Position = Settings["Gui"]["compassPosition"];
		AnchorPoint = Vector2.new(0.5, 0);
		BackgroundColor3 = Color3.fromRGB(20, 20, 20);
		BackgroundTransparency = 0.3;
		BorderSizePixel = 0;
		ClipsDescendants = true;
		ZIndex = 20;
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 5);
		});

		Stroke = Roact.createElement("UIStroke", {
			Color = Color3.fromRGB(255, 255, 255);
			Transparency = 0.8;
			Thickness = 1;
		});

		CenterIndicator = Roact.createElement("Frame", {
			Name = "CenterIndicator";
			Size = UDim2.new(0, 2, 0, 6);
			Position = UDim2.new(0.5, 0, 0, 0);
			AnchorPoint = Vector2.new(0.5, 0);
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BorderSizePixel = 0;
			ZIndex = 23;
		});

		Directions = Roact.createFragment(directionElements);
	})
end

function compass:didMount()
	self.renderLoop = RunService.RenderStepped:Connect(function()
		local direction = cam.CFrame.LookVector
		local heading = math.deg(math.atan2(direction.X, direction.Z))
		heading = (heading + 360) % 360

		self:setState({
			heading = heading
		})
	end)
end

function compass:willUnmount()
	if self.renderLoop then
		self.renderLoop:Disconnect()
	end
end

return compass