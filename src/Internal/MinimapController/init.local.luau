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

-- Výpočet dělení pro velikost mapy
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

-- Vytvoření minimap kamery
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



-- Proměnné pro large map dragging
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

-- Sledování tlačítek myši
local mouseDown = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if Settings["Technical"]["isLargeMap"] and mapFrame then
			local mousePos = UserInputService:GetMouseLocation()
			local framePos = mapFrame.AbsolutePosition
			local frameSize = mapFrame.AbsoluteSize

			-- Kontrola, zda je myš nad mapou
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

				-- OPRAVENÁ KONVERZE: Invertovaný směr (myš doprava = mapa doleva)
				-- Citlivost se upravuje podle zoom levelu
				local zoomLevel = Settings["Technical"]["zoomLevel"]
				local divide = Settings["Divide"]

				-- Základní sensitivity upravená podle zoom levelu
				-- Čím větší zoom, tím menší pohyb potřebujeme
				local sensitivity = (Settings["Technical"]["onePixel"] * zoomLevel) / divide

				-- INVERTOVANÝ směr: delta se odečítá místo přičítá
				-- X osa zůstává stejná, Y osa se také invertuje
				dragOffset = dragOffset - Vector3.new(delta.X * sensitivity, 0, delta.Y * sensitivity)

				lastMousePos = currentMousePos
				lastDragTime = tick()

				print("Dragging - Offset:", dragOffset, "Zoom:", zoomLevel)
			end
		end
	end
end)

-- Auto-recentrování
spawn(function()
	while true do
		wait(0.1)

		if not Settings["Technical"]["isLargeMap"] then
			-- Reset když není large map mód
			dragOffset = Vector3.new(0, 0, 0)
		elseif not isDragging then
			-- Auto-recentrování po určitém čase nečinnosti
			if tick() - lastDragTime >= Settings["Technical"]["autoRecenterTime"] then
				-- Plynulé lerp k nule
				dragOffset = dragOffset:Lerp(Vector3.new(0, 0, 0), Settings["Technical"]["dragSmoothness"])

				-- Snap k nule když je velmi blízko
				if dragOffset.Magnitude < 1 then
					dragOffset = Vector3.new(0, 0, 0)
				end
			end
		end
	end
end)

-- Hlavní render loop
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

		-- Aplikace zoomu úpravou výšky Y
		local zoomedY = (y * onepixel) / zoomLevel

		-- OPRAVENÁ APLIKACE DRAG OFFSETU
		-- Offset se aplikuje přímo bez dalšího dělení
		local finalDragOffset = Vector3.new(0, 0, 0)
		if Settings["Technical"]["isLargeMap"] then
			finalDragOffset = dragOffset
		end

		-- Pozice kamery s aplikovaným offsetem
		local P = Vector3.new(ROOTPART_POS.X, zoomedY, ROOTPART_POS.Z) / divide + finalDragOffset

		local heading = 0
		if Settings["Technical"]["rotation"] == true then
			heading = math.deg(getAngleAboutYAxis(cam.CFrame))
		end

		MinimapCamera.CFrame = CFrame.new(P) * CFrame.Angles(math.rad(-90), 0, math.rad(heading))
	end
end)

print("Minimap modul načten")