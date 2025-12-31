-- TEAM PLAYERS CONTAINER
-- Kontejner pro všechny týmové hráče na minimapě

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))
local TeamPlayer = require(script.Parent.TeamPlayer)
local TeamController = require(script.Parent.Parent.TeamController)

local Players = game:GetService("Players")

local teamPlayersContainer = Roact.Component:extend("TeamPlayersContainer")

-- Vytvoření ikony pro každého hráče
local function createPlayerIcons(isLargeMap)
	local playerIcons = {}
	local visiblePlayers = TeamController:GetVisiblePlayers()

	for _, player in pairs(visiblePlayers) do
		playerIcons[player.Name] = Roact.createElement(TeamPlayer, {
			Player = player;
			isLargeMap = isLargeMap;
		})
	end

	return Roact.createFragment(playerIcons)
end

function teamPlayersContainer:init()
	self:setState({
		updateTrigger = 0;
	})
end

function teamPlayersContainer:render()
	if not Settings["Teams"]["enabled"] then
		return nil
	end

	return Roact.createElement("Frame", {
		Name = "Team Players Container";
		Size = UDim2.new(1, 0, 1, 0);
		Position = UDim2.new(.5, 0, .5, 0);
		AnchorPoint = Vector2.new(.5, .5);
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		ZIndex = 8;
	}, {
		Roact.createElement(createPlayerIcons, {
			isLargeMap = self.props.isLargeMap
		})
	})
end

function teamPlayersContainer:didMount()
	-- Sledování přidání/odebrání hráčů
	self.playerAddedConnection = Players.PlayerAdded:Connect(function()
		self:setState(function(state)
			return { updateTrigger = state.updateTrigger + 1 }
		end)
	end)

	self.playerRemovingConnection = Players.PlayerRemoving:Connect(function()
		self:setState(function(state)
			return { updateTrigger = state.updateTrigger + 1 }
		end)
	end)

	-- Sledování změn týmů
	for _, player in pairs(Players:GetPlayers()) do
		player:GetPropertyChangedSignal("Team"):Connect(function()
			self:setState(function(state)
				return { updateTrigger = state.updateTrigger + 1 }
			end)
		end)
	end

	Players.PlayerAdded:Connect(function(player)
		player:GetPropertyChangedSignal("Team"):Connect(function()
			self:setState(function(state)
				return { updateTrigger = state.updateTrigger + 1 }
			end)
		end)
	end)
end

function teamPlayersContainer:willUnmount()
	if self.playerAddedConnection then
		self.playerAddedConnection:Disconnect()
	end

	if self.playerRemovingConnection then
		self.playerRemovingConnection:Disconnect()
	end
end

return teamPlayersContainer