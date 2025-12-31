-- TOOLTIP COMPONENT
-- Zobrazení tooltipů při najetí na blipy

local Roact = require(game:GetService("ReplicatedStorage").Roact)
local Settings = require(script.Parent.Parent.Parent.Parent:WaitForChild("Settings"))

local UserInputService = game:GetService("UserInputService")

local toolTip = Roact.Component:extend("ToolTip")

function toolTip:init()
	self:setState({
		Position = UDim2.new(0, 0, 0, 0);
	})
end

function toolTip:render()
	local Text = self.props.Text
	local Pos = self.state.Position

	-- Pokud není žádný text, nezobrazovat tooltip
	if Text == "" or Text == nil then
		return nil
	end

	return Roact.createElement("ScreenGui", {
		Name = "ToolTip";
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		DisplayOrder = 100;
	}, {
		ToolTipFrame = Roact.createElement("Frame", {
			Size = UDim2.new(0, #Text * 7 + 10, 0, Settings["Gui"]["toolTipHeight"]);
			Position = Pos;
			BackgroundColor3 = Settings["Gui"]["toolTipColor"];
			BackgroundTransparency = Settings["Gui"]["toolTipTransparency"];
			BorderColor3 = Settings["Gui"]["toolTipBorderColor"];
			BorderSizePixel = Settings["Gui"]["toolTipBorderSize"];
			ZIndex = 100;

			[Roact.Ref] = function(rbx)
				self.toolTipRef = rbx
			end,
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 4);
			});

			TextLabel = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0);
				Position = UDim2.new(0, 0, 0, 0);
				BackgroundTransparency = 1;
				Text = Text;
				TextColor3 = Settings["Gui"]["toolTipTextColor"];
				TextSize = 12;
				Font = Enum.Font.GothamBold;
				TextXAlignment = Enum.TextXAlignment.Center;
				TextYAlignment = Enum.TextYAlignment.Center;
				ZIndex = 101;
			});
		})
	})
end

function toolTip:didMount()
	-- Update pozice tooltipu podle pozice myši
	self.updateConnection = UserInputService.InputChanged:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = input.Position

			-- Offset pro tooltip (nad myší)
			local offset = Vector2.new(10, -25)

			self:setState(function(state)
				return{
					Position = UDim2.new(0, mousePos.X + offset.X, 0, mousePos.Y + offset.Y);
				}
			end)
		end
	end)

	-- Nastav počáteční pozici
	local mousePos = UserInputService:GetMouseLocation()
	local offset = Vector2.new(10, -25)

	self:setState(function(state)
		return{
			Position = UDim2.new(0, mousePos.X + offset.X, 0, mousePos.Y + offset.Y);
		}
	end)
end

function toolTip:willUnmount()
	if self.updateConnection then
		self.updateConnection:Disconnect()
	end
end

return toolTip