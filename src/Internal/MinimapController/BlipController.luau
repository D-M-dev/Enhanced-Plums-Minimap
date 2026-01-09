
local Settings = require(script.Parent.Parent.Parent:WaitForChild("Settings"))

local plr = game:GetService("Players").LocalPlayer

local blipController = {}

-- conver 3D position to 2d viewportfram (autor: EgoMoose, enhanced by taco_system)
local function pointToViewport(camera, p, vps)
	local lp = camera.CFrame:pointToObjectSpace(p); -- relativní k kameře

	local r = vps.x/vps.y; -- poměr stran
	local h = -lp.z*math.tan(math.rad(camera.FieldOfView/2)); -- výška/2
	local w = r*h; -- šířka/2

	local corner = Vector3.new(-w, h, lp.z); -- levý horní roh
	local relative = lp - corner; -- 3D bod relativní k rohu

	local sx = relative.x / (w*2); -- x procento
	local sy = -relative.y / (h*2); -- y procento

	local onscreen = -lp.z > 0 and sx >=0 and sx <= 1 and sy >=0 and sy <= 1;

	-- return pixels
	return Vector2.new(sx*vps.x, sy*vps.y), onscreen;
end


function blipController:getUIPosition(objPosition, vps)
	local pos, onscreen = pointToViewport(game.Workspace.MinimapCamera, objPosition, vps)
	return pos
end


function blipController:getDistanceFromPlayer(pos)
	if plr.Character then
		if plr.Character:FindFirstChild("HumanoidRootPart") then
			return (pos - plr.Character.HumanoidRootPart.CFrame.p).Magnitude
		end
	end

	return math.huge
end


function blipController:isInRange(pos, maxDistance)
	local distance = self:getDistanceFromPlayer(pos)
	return distance <= maxDistance
end


function blipController:getDirectionToObject(objPosition)
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = plr.Character.HumanoidRootPart
		local direction = (objPosition - hrp.Position).Unit
		local angle = math.atan2(direction.X, direction.Z)
		return math.deg(angle)
	end
	return 0
end

return blipController
