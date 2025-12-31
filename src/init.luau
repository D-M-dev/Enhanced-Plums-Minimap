---Kredit: Plum
local Minimap = {}

local Settings = require(script:WaitForChild("Settings"))
local TagController = require(script:WaitForChild("Internal"):WaitForChild("TagController"))
 
local CollectionService = game:GetService("CollectionService")

local events = script:WaitForChild("Internal"):WaitForChild("Events")
	local updateEvent = events:WaitForChild("Update")


function Minimap:Toggle()
	Settings["Technical"]["Visible"] = not Settings["Technical"]["Visible"]
	
	updateEvent:Fire()
end

function Minimap:SetOnePixel(newOnePixel: number) --Set what one pixel on the map is in the gameworld.
	Settings["Technical"]["onePixel"] = newOnePixel
	updateEvent:Fire()
end

function Minimap:Resize(newSize: UDim2)
	if not newSize then
		error("No size was given...")
	end
	
	Settings["Gui"]["mapSize"] = newSize
	
	updateEvent:Fire()
end

function Minimap:Reposition(newPosition: UDim2, newAnchorPoint: Vector2)
	if not newPosition then
		newPosition = Settings["Gui"]["mapPosition"]
	end
	
	if not newAnchorPoint then
		newAnchorPoint = Settings["Gui"]["anchorPoint"]
	end

	Settings["Gui"]["mapPosition"] = newPosition
	Settings["Gui"]["anchorPoint"] = newAnchorPoint

	updateEvent:Fire()
end

function Minimap:AddBlip(obj: BasePart, tagName: string)
	if obj then
		if tostring(tagName) and obj:IsA("BasePart") then
			if TagController:findTag(tagName) then
				CollectionService:AddTag(obj, tagName)
			end
		else
			error("The tag or object is not correct! Check if they're a string and basepart.")
		end
	else
		error("Got no object")
	end
end

function Minimap:RemoveBlip(obj: Instance)
	if obj then
		for _, tag in pairs(CollectionService:GetTags(obj)) do
			if TagController:findTag(tag) then
				CollectionService:RemoveTag(obj, tag)
			end
		end
		
	else
		error("Got no object")
	end
end

function Minimap:ChangeRoundness(newRoundness: UDim)
	if newRoundness then
		if typeof(newRoundness) == "UDim" then
			Settings["Gui"]["mapCornerRoundness"] = newRoundness
			Settings["Gui"]["borderCornerRoundness"] = newRoundness

			updateEvent:Fire()
		end
	end
end

type MapData = {
	{
		mapId: number,
		center: Vector3,
		size: Vector2,
	}
}

function Minimap:ChangeMapData(newData: MapData)
	if not newData then
		return error("No mapdata was gotten!")
	end
	
	Settings["Map"]["images"] = newData
	updateEvent:Fire()
end

return Minimap
