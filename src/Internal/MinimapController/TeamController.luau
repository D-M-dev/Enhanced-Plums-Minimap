-- TEAM CONTROLLER

local TeamController = {}

local Settings = require(script.Parent.Parent.Parent:WaitForChild("Settings"))
local Players = game:GetService("Players")

local plr = Players.LocalPlayer

-- Získání konfigurace týmu
function TeamController:GetTeamConfig(teamName)
	if not Settings["Teams"]["enabled"] then
		return nil
	end

	return Settings["Teams"]["teams"][teamName]
end

-- Kontrola, zda má tým povolenou konfiguraci
function TeamController:IsTeamEnabled(teamName)
	local config = self:GetTeamConfig(teamName)
	return config and config.enabled
end

-- Kontrola, zda se má hráč zobrazit
function TeamController:ShouldShowPlayer(player)
	if not Settings["Teams"]["enabled"] then
		return false
	end

	if player == plr then
		return false -- Nezobrazovat sebe
	end

	-- Pokud showAllTeams je true, zobraz všechny
	if Settings["Teams"]["showAllTeams"] then
		if player.Team then
			return self:IsTeamEnabled(player.Team.Name)
		end
		return false
	end

	-- Jinak zobraz jen hráče ze stejného týmu
	if not plr.Team or not player.Team then
		return false
	end

	if plr.Team.Name == player.Team.Name then
		return self:IsTeamEnabled(player.Team.Name)
	end

	return false
end

-- Získání barvy ikony hráče podle týmu
function TeamController:GetPlayerIconColor(player)
	if not player.Team then
		return Color3.fromRGB(255, 255, 255)
	end

	local config = self:GetTeamConfig(player.Team.Name)
	if config then
		return config.color
	end

	return Color3.fromRGB(255, 255, 255)
end

-- Získání velikosti ikony hráče
function TeamController:GetPlayerIconSize(player)
	if not player.Team then
		return Settings["Gui"]["playerSize"]
	end

	local config = self:GetTeamConfig(player.Team.Name)
	if config then
		return config.size
	end

	return Settings["Gui"]["playerSize"]
end

-- Získání ikony hráče
function TeamController:GetPlayerIcon(player)
	if not player.Team then
		return Settings["Gui"]["playerIcon"]
	end

	local config = self:GetTeamConfig(player.Team.Name)
	if config then
		return config.icon
	end

	return Settings["Gui"]["playerIcon"]
end

-- Získání všech hráčů, kteří se mají zobrazit
function TeamController:GetVisiblePlayers()
	local visiblePlayers = {}

	for _, player in pairs(Players:GetPlayers()) do
		if self:ShouldShowPlayer(player) then
			table.insert(visiblePlayers, player)
		end
	end

	return visiblePlayers
end

return TeamController