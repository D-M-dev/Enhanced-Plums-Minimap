
local Tag = {}

local Settings = require(script.Parent.Parent:WaitForChild("Settings"))

function Tag:findTag(tagName)
	for _, tag in pairs(Settings["Tags"]) do
		if tag.tagName == tagName then
			return tag
		end
	end
	return nil
end


function Tag:getAllTags()
	return Settings["Tags"]
end


function Tag:tagExists(tagName)
	return self:findTag(tagName) ~= nil
end

return Tag