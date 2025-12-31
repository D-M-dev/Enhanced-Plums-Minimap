local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))
local BlipController = require(script.Parent.Parent.BlipController)
local ToolTip = require(script.Parent.ToolTip)
local TagController = require(script.Parent.Parent.Parent.TagController)
local BorderSnap = require(script:WaitForChild("BorderSnap"))

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local cam = game.Workspace.CurrentCamera

local blip = Roact.Component:extend("Blip")

local function getObjectPosition(object)
	if object:IsA("Model") then
		return object:GetPivot().Position
	elseif object:IsA("BasePart") then
		return object.Position
	else
		local primaryPart = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
		if primaryPart then
			return primaryPart.Position
		end
		return Vector3.new(0, 0, 0)
	end
end

local function getObjectCFrame(object)
	if object:IsA("Model") then
		return object:GetPivot()
	elseif object:IsA("BasePart") then
		return object.CFrame
	else
		local primaryPart = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
		if primaryPart then
			return primaryPart.CFrame
		end
		return CFrame.new()
	end
end

function blip:init()
	self:setState({
		Position = UDim2.new(0, 0, 0, 0);
		Rotation = 0;
		Visible = true;
	})
end

function blip:render()
	local Pos = self.state.Position
	local Rot = self.state.Rotation
	local Vis = self.state.Visible

	local TagInfo = TagController:findTag(self.props.TagName)
	local blipSize = TagInfo.size
	local jeText = TagInfo.text ~= nil and TagInfo.text ~= ""

	local props = {
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		AnchorPoint = Vector2.new(0.5, 0.5);
		ZIndex = 19;
		Size = blipSize;
		Position = Pos;
		Rotation = Rot;
		Visible = Vis;
		[Roact.Ref] = function(rbx) self.blipRef = rbx end;
	}

	if jeText then
		props.Text = TagInfo.text
		props.TextColor3 = TagInfo.color
		props.TextSize = 16
		props.Font = Enum.Font.SourceSansBold
		props.TextStrokeTransparency = 0.5
	else
		props.Image = "rbxassetid://"..TagInfo.iconID
		props.ImageColor3 = TagInfo.color
		
		if TagInfo.snapToBorder then
			props.ImageTransparency = 0
		else 
			props.ImageTransparency = 0
		end
		
	end

	return Roact.createElement(jeText and "TextLabel" or "ImageLabel", props, {
		MouseDetector = Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 1, 0);
			Position = UDim2.new(0, 0, 0, 0);
			BackgroundTransparency = 1;
			ImageTransparency = 1;
			AutoButtonColor = false;
			ZIndex = 20;

			[Roact.Event.MouseEnter] = function()
				if TagInfo.toolTip and TagInfo.toolTip ~= "" then
					self.toolTip = Roact.mount(Roact.createElement(ToolTip, {
						Text = TagInfo.toolTip;
						Blip = self.blipRef;
					}), plr:WaitForChild("PlayerGui"))
				end
			end;

			[Roact.Event.MouseLeave] = function()
				if self.toolTip then
					Roact.unmount(self.toolTip)
					self.toolTip = nil
				end
			end;
		})
	})
end

local function getAngleAboutYAxis(R)
	local px, py, pz,
	xx, yx, zx,
	xy, yy, zy,
	xz, yz, zz = R:components()
	return math.atan2(zx - xz, xx + zz)
end

function blip:didMount()
	self.renderLoop = game:GetService("RunService").RenderStepped:Connect(function()
		local map = self.blipRef and self.blipRef.Parent
		if not map then return end

		local objectPosition = getObjectPosition(self.props.Object)

		if BlipController:getDistanceFromPlayer(objectPosition) <= Settings["Technical"]["maxBlipDistance"] then
			local Pos = BlipController:getUIPosition(Vector3.new(objectPosition.X, 0, objectPosition.Z) / Settings["Divide"], map.AbsoluteSize)
			local Rotation = 0
			local TagInfo = TagController:findTag(self.props.TagName)

			if TagInfo.snapToBorder then
				self.state.Visible = true
				Pos = BorderSnap:ClampToBorder(Pos, Vector2.new(map.AbsoluteSize.X, map.AbsoluteSize.Y), Settings["Gui"]["mapCornerRoundness"])
			else
				local n = BorderSnap:ClampToBorder(Pos, Vector2.new(map.AbsoluteSize.X, map.AbsoluteSize.Y), Settings["Gui"]["mapCornerRoundness"])
				if n.X ~= Pos.X or n.Y ~= Pos.Y then
					self.state.Visible = false
				elseif self.state.Visible == false then
					self.state.Visible = true
				end
			end

			if TagInfo.rotate then
				local direction = cam.CFrame.LookVector
				local heading = math.atan2(direction.X, direction.Z)
				heading = math.deg(heading)
				local objectCFrame = getObjectCFrame(self.props.Object)
				if Settings["Technical"]["rotation"] then
					Rotation = heading - math.deg(getAngleAboutYAxis(objectCFrame)) + 180
				else
					Rotation = -math.deg(getAngleAboutYAxis(objectCFrame))
				end
			end

			self:setState({
				Position = UDim2.new(0, Pos.X, 0, Pos.Y);
				Rotation = Rotation;
			})
		elseif self.state.Visible then
			self:setState({Visible = false})
		end
	end)
end

function blip:willUnmount()
	if self.renderLoop then
		self.renderLoop:Disconnect()
	end
	if self.toolTip then
		Roact.unmount(self.toolTip)
		self.toolTip = nil
	end
end

return blip
