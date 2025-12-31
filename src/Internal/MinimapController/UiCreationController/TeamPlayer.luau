-- TEAM PLAYER COMPONENT
-- Ikona jiného hráče na minimapě

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))
local BlipController = require(script.Parent.Parent.BlipController)
local TeamController = require(script.Parent.Parent.TeamController)
local ToolTip = require(script.Parent.ToolTip)
local BorderSnap = require(script.Parent.Blip.BorderSnap)

local plr = game:GetService("Players").LocalPlayer
local cam = game.Workspace.CurrentCamera

local teamPlayer = Roact.Component:extend("TeamPlayer")

function teamPlayer:init()
	self:setState({
		Rotation = 0;
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Visible = true;
	})
end

function teamPlayer:render()
	local Rot = self.state.Rotation
	local Pos = self.state.Position
	local Vis = self.state.Visible
	local targetPlayer = self.props.Player

	if not targetPlayer then
		return nil
	end

	local iconColor = TeamController:GetPlayerIconColor(targetPlayer)
	local iconSize = self.props.isLargeMap 
		and UDim2.new(0, 25, 0, 25) 
		or TeamController:GetPlayerIconSize(targetPlayer)
	local iconImage = TeamController:GetPlayerIcon(targetPlayer)

	return Roact.createElement("ImageLabel", {
		Image = "rbxassetid://"..iconImage;
		Size = iconSize;
		ImageColor3 = iconColor;

		BackgroundTransparency = 1;
		Position = Pos;
		AnchorPoint = Vector2.new(.5,.5);
		ZIndex = 9;
		Visible = Vis;

		Rotation = Rot;

		[Roact.Ref] = function(rbx)
			self.playerRef = rbx
		end,
	}, {
		MouseDetector = Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 1, 0);
			Position = UDim2.new(0, 0, 0, 0);
			BackgroundTransparency = 1;
			ImageTransparency = 1;
			AutoButtonColor = false;
			ZIndex = 10;

			[Roact.Event.MouseEnter] = function(rbx)
				self.toolTip = Roact.mount(Roact.createElement(ToolTip, {
					Text = targetPlayer.Name;
					Blip = self.playerRef;
				}), plr:WaitForChild("PlayerGui"))
			end;

			[Roact.Event.MouseLeave] = function(rbx)
				if self.toolTip then
					Roact.unmount(self.toolTip)
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

local function pointToViewport(camera, p, vps)
	local lp = camera.CFrame:pointToObjectSpace(p)

	local r = vps.x/vps.y
	local h = -lp.z*math.tan(math.rad(camera.FieldOfView/2))
	local w = r*h

	local corner = Vector3.new(-w, h, lp.z)
	local relative = lp - corner

	local sx = relative.x / (w*2)
	local sy = -relative.y / (h*2)

	return Vector2.new(sx*vps.x, sy*vps.y)
end

function teamPlayer:didMount()
	self.renderLoop = game:GetService("RunService").RenderStepped:connect(function()
		local targetPlayer = self.props.Player

		if not targetPlayer or not targetPlayer.Character then
			if self.state.Visible then
				self:setState({ Visible = false })
			end
			return
		end

		local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not targetRoot or not self.playerRef or not self.playerRef.Parent then
			if self.state.Visible then
				self:setState({ Visible = false })
			end
			return
		end

		local map = self.playerRef.Parent
		local heading = math.deg(getAngleAboutYAxis(cam.CFrame))
		local orientation = math.deg(getAngleAboutYAxis(targetRoot.CFrame))

		local newRotation = 0
		if Settings["Technical"]["rotation"] == true then
			newRotation = heading - orientation
		else
			newRotation = -orientation
		end

		-- Výpočet pozice na mapě
		local playerWorldPos = Vector3.new(targetRoot.Position.X, 0, targetRoot.Position.Z) / Settings["Divide"]
		local vps = Vector2.new(map.AbsoluteSize.X, map.AbsoluteSize.Y)
		local playerViewportPos = pointToViewport(game.Workspace.MinimapCamera, playerWorldPos, vps)

		-- Kontrola, zda je v rozsahu mapy
		local cornerRadius = Settings["Gui"]["mapCornerRoundness"]
		local isInside = BorderSnap:IsInsideBorder(playerViewportPos, vps, cornerRadius)

		local newPosition
		if isInside then
			newPosition = UDim2.new(0, playerViewportPos.X, 0, playerViewportPos.Y)
		else
			-- Snap na okraj
			local snappedPos = BorderSnap:ClampToBorder(playerViewportPos, vps, cornerRadius)
			newPosition = UDim2.new(0, snappedPos.X, 0, snappedPos.Y)
		end

		self:setState({
			Rotation = newRotation;
			Position = newPosition;
			Visible = true;
		})
	end)
end

function teamPlayer:willUnmount()
	if self.renderLoop then
		self.renderLoop:Disconnect()
	end

	if self.toolTip then
		Roact.unmount(self.toolTip)
	end
end

return teamPlayer