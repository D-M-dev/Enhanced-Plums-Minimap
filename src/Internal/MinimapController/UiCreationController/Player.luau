-- PLAYER COMPONENT - FIXED
-- Ikona hráče na minimapě - OPRAVENO PRO DRAGGING + BORDER CLIPPING

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))
local BorderSnap = require(script.Parent.Blip.BorderSnap)

local plr = game:GetService("Players").LocalPlayer
local cam = game.Workspace.CurrentCamera

local player = Roact.Component:extend("Player")

function player:init()
	self:setState({
		Rotation = 0;
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Visible = true; -- Přidána viditelnost
	})
end

function player:render()
	local Rot = self.state.Rotation
	local Pos = self.state.Position
	local Vis = self.state.Visible

	-- Dynamicky zvolit velikost podle large map módu
	local playerSize = self.props.isLargeMap and Settings["Gui"]["playerLargeSize"] or Settings["Gui"]["playerSize"]

	return Roact.createElement("ImageLabel", {
		Image = "rbxassetid://"..Settings["Gui"]["playerIcon"];
		Size = playerSize;

		BackgroundTransparency = 1;
		Position = Pos;
		AnchorPoint = Vector2.new(.5,.5);
		ZIndex = 10;
		Visible = Vis; -- Použití viditelnosti ze state

		Rotation = Rot;

		[Roact.Ref] = function(rbx)
			self.playerRef = rbx
		end,
	})
end

-- Získání úhlu kolem Y osy
local function getAngleAboutYAxis(R)
	local px, py, pz,
	xx, yx, zx,
	xy, yy, zy,
	xz, yz, zz = R:components()

	return math.atan2(zx - xz, xx + zz)
end

-- Konverze 3D pozice na 2D viewport
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

function player:didMount()
	self.renderLoop = game:GetService("RunService").RenderStepped:connect(function()
		local char = plr.Character or plr.CharacterAdded:wait()
		local rootpart = char:FindFirstChild("HumanoidRootPart")

		if rootpart and self.playerRef and self.playerRef.Parent then
			local heading = math.deg(getAngleAboutYAxis(cam.CFrame))
			local orientation = math.deg(getAngleAboutYAxis(rootpart.CFrame))

			local newRotation = 0
			if Settings["Technical"]["rotation"] == true then
				newRotation = heading - orientation
			else
				newRotation = -orientation
			end

			-- OPRAVENÝ KÓD PRO DRAGGING KOMPENZACI + BORDER CLIPPING
			local newPosition = UDim2.new(0.5, 0, 0.5, 0) -- Default střed
			local newVisible = true

			-- Pouze pokud je large map a existuje parent (mapa)
			if Settings["Technical"]["isLargeMap"] and self.playerRef.Parent then
				local map = self.playerRef.Parent

				-- Získat pozici hráče ve světové souřadnici
				local playerWorldPos = Vector3.new(rootpart.Position.X, 0, rootpart.Position.Z) / Settings["Divide"]

				-- Získat viewport pozici hráče
				local vps = Vector2.new(map.AbsoluteSize.X, map.AbsoluteSize.Y)
				local playerViewportPos = pointToViewport(game.Workspace.MinimapCamera, playerWorldPos, vps)

				-- Kontrola, zda je hráč v rozsahu mapy (včetně zaoblených rohů)
				local cornerRadius = Settings["Gui"]["mapCornerRoundness"]
				local isInside = BorderSnap:IsInsideBorder(playerViewportPos, vps, cornerRadius)

				if isInside then
					-- Hráč je uvnitř - zobrazit na správné pozici
					newPosition = UDim2.new(0, playerViewportPos.X, 0, playerViewportPos.Y)
					newVisible = true
				else
					-- Hráč je mimo mapu - SKRÝT IKONU
					newVisible = false
				end
			end

			self:setState({
				Rotation = newRotation;
				Position = newPosition;
				Visible = newVisible;
			})
		end
	end)
end

function player:willUnmount()
	if self.renderLoop then
		self.renderLoop:Disconnect()
	end
end

return player