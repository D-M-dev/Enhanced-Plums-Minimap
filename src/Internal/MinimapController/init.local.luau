-- INIT LOCAL

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer

local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	print("Načítám minimap modul - vytvořeno RealPlum, upraveno taco_system")
end

local function getAngleAboutYAxis(R)
	local px, py, pz,
	xx, yx, zx,
	xy, yy, zy,
	xz, yz, zz = R:components()

	return math.atan2(zx - xz, xx + zz)
end

local Settings = require(script.Parent.Parent:WaitForChild("Settings"))

Settings["Divide"] = 1


if Settings["Map"]["mapId"] then
	if Settings["Map"]["size"].Y > 1024 or Settings["Map"]["size"].X > 1024 then
		Settings["Divide"] = math.max(Settings["Map"]["size"].Y, Settings["Map"]["size"].X) / 1024
	end
else
	local max = 0
	for _, data in Settings["Map"]["images"] do
		local thisMax = math.max(data.size.X, data.size.Y)
		if thisMax > max then
			max = thisMax
		end
	end

	if max > 1024 then
		Settings["Divide"] = max / 1024
	end
end

local Roact = require(script.Parent:WaitForChild("Roact"))

script.Parent:WaitForChild("Roact").Parent = game:GetService("ReplicatedStorage")


local MinimapCamera = Instance.new("Camera")
MinimapCamera.Name = "MinimapCamera"
MinimapCamera.FieldOfView = 70
MinimapCamera.Parent = workspace	

local cam = game.Workspace.CurrentCamera

local uiCreationController = require(script:WaitForChild("UiCreationController"))

local ui = uiCreationController:Init()

local Handle = Roact.mount(ui,plr:WaitForChild("PlayerGui"))

local vps = Vector2.new(1920, 1080)
local mapsize = Settings["Gui"]["mapSize"]
Settings["Y"] = (mapsize.Y.Offset + (mapsize.Y.Scale*vps.Y) / (math.tan(math.rad(35)) * 2)) + (mapsize.X.Offset + (mapsize.X.Scale*vps.X) / 2)




local dragOffset = Vector3.new(0, 0, 0)
local isDragging = false
local lastMousePos = nil
local lastDragTime = 0
local minimapGui = nil
local mapFrame = nil

-- Počkat na načtení GUI
task.wait(0.5)
minimapGui = plr.PlayerGui:WaitForChild("RoactTree", 5)
if minimapGui then
	mapFrame = minimapGui.Background:WaitForChild("Map", 5)
	print("Minimap GUI nalezeno!")
end


local mouseDown = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Settings["Technical"]["isLargeMap"] and mapFrame then
			local mousePos = UserInputService:GetMouseLocation()
			local framePos = mapFrame.AbsolutePosition
			local frameSize = mapFrame.AbsoluteSize


			if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
				mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then
				mouseDown = true
				isDragging = true
				lastMousePos = mousePos
				print("Začátek draggingu!")
			end
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDown = false
		if isDragging then
			isDragging = false
			lastDragTime = tick()
			print("Konec draggingu!")
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if isDragging and mouseDown and Settings["Technical"]["isLargeMap"] then
			local currentMousePos = UserInputService:GetMouseLocation()

			if lastMousePos then
				local delta = currentMousePos - lastMousePos


				local zoomLevel = Settings["Technical"]["zoomLevel"]
				local divide = Settings["Divide"]


				local sensitivity = (Settings["Technical"]["onePixel"] * zoomLevel) / divide


				dragOffset = dragOffset - Vector3.new(delta.X * sensitivity, 0, delta.Y * sensitivity)

				lastMousePos = currentMousePos
				lastDragTime = tick()

				print("Dragging - Offset:", dragOffset, "Zoom:", zoomLevel)
			end
		end
	end
end)


spawn(function()
	while true do
		wait(0.1)

		if not Settings["Technical"]["isLargeMap"] then

			dragOffset = Vector3.new(0, 0, 0)
		elseif not isDragging then

			if tick() - lastDragTime >= Settings["Technical"]["autoRecenterTime"] then

				dragOffset = dragOffset:Lerp(Vector3.new(0, 0, 0), Settings["Technical"]["dragSmoothness"])


				if dragOffset.Magnitude < 1 then
					dragOffset = Vector3.new(0, 0, 0)
				end
			end
		end
	end
end)


RunService.RenderStepped:connect(function()
	local char = plr.Character or plr.CharacterAdded:wait()

	local rootpart = char:FindFirstChild("HumanoidRootPart")
	if rootpart then

		local ROOTPART_POS = rootpart.CFrame.p

		local vps = Vector2.new(1920, 1080)
		local currentMapSize = Settings["Technical"]["isLargeMap"] and Settings["Gui"]["largeMapSize"] or Settings["Gui"]["mapSize"]
		local y = (currentMapSize.Y.Offset + (currentMapSize.Y.Scale*vps.Y) / (math.tan(math.rad(35)) * 2)) + (((currentMapSize.X.Offset + (currentMapSize.X.Scale*vps.X)) / Settings["Ratio"]) / 2)
		Settings["Y"] = y

		local onepixel = Settings["Technical"]["onePixel"]
		local divide = Settings["Divide"]
		local zoomLevel = Settings["Technical"]["zoomLevel"]


		local zoomedY = (y * onepixel) / zoomLevel

		local finalDragOffset = Vector3.new(0, 0, 0)
		if Settings["Technical"]["isLargeMap"] then
			finalDragOffset = dragOffset
		end


		local P = Vector3.new(ROOTPART_POS.X, zoomedY, ROOTPART_POS.Z) / divide + finalDragOffset

		local heading = 0
		if Settings["Technical"]["rotation"] == true then
			heading = math.deg(getAngleAboutYAxis(cam.CFrame))
		end

		MinimapCamera.CFrame = CFrame.new(P) * CFrame.Angles(math.rad(-90), 0, math.rad(heading))
	end
end)

print("Minimap module loaded")
