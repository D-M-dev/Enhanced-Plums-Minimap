
local BorderSnap = {}


local function getCornerPositions(absoluteSize, cornerSize)
	return {
		topLeft = Vector2.new(cornerSize, cornerSize),
		topRight = Vector2.new(absoluteSize.X - cornerSize, cornerSize),
		bottomLeft = Vector2.new(cornerSize, absoluteSize.Y - cornerSize),
		bottomRight = Vector2.new(absoluteSize.X - cornerSize, absoluteSize.Y - cornerSize)
	}
end


local function getRadius(cornerRadius, absoluteSize)
	local minimumSize = math.min(absoluteSize.X, absoluteSize.Y)
	local cornerSize = minimumSize * math.clamp(cornerRadius.Scale, 0, 0.5) + math.clamp(cornerRadius.Offset, 0, minimumSize / 2)
	return cornerSize, getCornerPositions(absoluteSize, cornerSize)
end


local function detectCorner(pos, corners)
	if pos.X < corners.topLeft.X and pos.Y < corners.topLeft.Y then
		return "topLeft", corners.topLeft
	elseif pos.X > corners.topRight.X and pos.Y < corners.topRight.Y then
		return "topRight", corners.topRight
	elseif pos.X < corners.bottomLeft.X and pos.Y > corners.bottomLeft.Y then
		return "bottomLeft", corners.bottomLeft
	elseif pos.X > corners.bottomRight.X and pos.Y > corners.bottomRight.Y then
		return "bottomRight", corners.bottomRight
	end
	return nil, nil
end


local function clampToCircularCorner(pos, center, radius)
	local offset = pos - center
	local distance = offset.Magnitude


	if distance > radius then
		local normalized = offset.Unit
		return center + (normalized * radius)
	end

	return pos
end


function BorderSnap:ClampToBorder(position, absoluteSize, cornerRadius)
	-- Výpočet poloměru a pozic rohů
	local radius, corners = getRadius(cornerRadius, absoluteSize)

	-- Detekce rohu
	local cornerType, cornerCenter = detectCorner(position, corners)

	local pos = position

	-- Pokud je blip v oblasti rohu, aplikovat kruhový clamp
	if cornerType and cornerCenter then
		pos = clampToCircularCorner(pos, cornerCenter, radius)
	end

	-- Finální clamp do hranic minimapy (základní obdélník)
	pos = Vector2.new(
		math.clamp(pos.X, 0, absoluteSize.X),
		math.clamp(pos.Y, 0, absoluteSize.Y)
	)

	return pos
end

-- Funkce pro kontrolu, zda je bod uvnitř minimapy
function BorderSnap:IsInsideBorder(position, absoluteSize, cornerRadius)
	local radius, corners = getRadius(cornerRadius, absoluteSize)
	local cornerType, cornerCenter = detectCorner(position, corners)

	-- Základní kontrola hranic
	if position.X < 0 or position.X > absoluteSize.X or 
		position.Y < 0 or position.Y > absoluteSize.Y then
		return false
	end

	-- Pokud je v rohu, zkontrolovat vzdálenost od středu rohu
	if cornerType and cornerCenter then
		local distance = (position - cornerCenter).Magnitude
		return distance <= radius
	end

	return true
end

-- Funkce pro získání nejbližšího bodu na okraji
function BorderSnap:GetNearestBorderPoint(position, absoluteSize, cornerRadius)
	local radius, corners = getRadius(cornerRadius, absoluteSize)

	-- Pokud je bod uvnitř, vrátit původní pozici
	if self:IsInsideBorder(position, absoluteSize, cornerRadius) then
		return position
	end

	-- Jinak použít ClampToBorder
	return self:ClampToBorder(position, absoluteSize, cornerRadius)
end

-- Debug funkce - vrací informace o snappingu
function BorderSnap:GetSnapInfo(position, absoluteSize, cornerRadius)
	local radius, corners = getRadius(cornerRadius, absoluteSize)
	local cornerType, cornerCenter = detectCorner(position, corners)
	local snappedPos = self:ClampToBorder(position, absoluteSize, cornerRadius)

	return {
		originalPosition = position,
		snappedPosition = snappedPos,
		isSnapped = position ~= snappedPos,
		cornerType = cornerType,
		cornerCenter = cornerCenter,
		cornerRadius = radius,
		isInside = self:IsInsideBorder(position, absoluteSize, cornerRadius)
	}
end

return BorderSnap
