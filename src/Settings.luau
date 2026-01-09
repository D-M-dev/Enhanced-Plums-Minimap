local Settings = 
	{
		["Tags"] = { -- Tags - can be parts, mesh whatever you want it needs to have a cframe and tag - For better working I suggest you to put these tags in ReplicatedStorage because of streaming
			{
				tagName = "CarSpawn";
				toolTip = "CarSpawn";
				iconID = 74530163668542;
				color = Color3.fromRGB(255,255,255);
				size = UDim2.new(0, 29, 0, 29); 
				snapToBorder = true;
				rotate = false;
			};
	
		};

		["Teams"] = { -- Config for teams visible
			enabled = true; -- if player is in that team, he will see on the minimap players in same team.
			showAllTeams = false; -- true = for everyone

			teams = {
				["NAME-OF-YOUR-TEAM-HERE"] = {
					enabled = true;
					color = Color3.fromRGB(255, 0, 4); -- blue
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				
			};
		};


		["Gui"] = { -- Gui settings
			["mapSize"] = UDim2.new(.19,0,.19,0);
			["borderSize"] = 3;
			["anchorPoint"] = Vector2.new(0,1);
			["mapPosition"] = UDim2.new(0.008, -10, 0.915, -5);

			-- Large Map settings
			["largeMapSize"] = UDim2.new(0.7, 0, 0.7, 0);
			["largeMapPosition"] = UDim2.new(0.5, 0, 0.5, 0);
			["largeMapAnchorPoint"] = Vector2.new(0.5, 0.5);

			["Ratio"] = nil;

			-- Colours
			["mapColor"] = Color3.fromRGB(103, 161, 255);
			["borderColor"] = Color3.fromRGB(176, 176, 176);

			-- Transparency
			["mapTransparency"] = .5;
			["borderTransparency"] = 0.4;

			-- Corners
			["mapCornerRoundness"] = UDim.new(0, 5);
			["borderCornerRoundness"] = UDim.new(0, 5);

			["blipColor"] = Color3.fromRGB(255,255,255);
			["blipTransparency"] = 1;
			["blipBorderSizePixel"] = 0;
			["blipBorderColor"] = Color3.fromRGB(0,0,0);

			-- Player
			["playerSize"] = UDim2.new(0,18,0,18);
			["playerLargeSize"] = UDim2.new(0,25,0,25);
			["playerIcon"] = 5483943698;

			-- Tooltip
			["toolTipHeight"] = 18;
			["toolTipColor"] = Color3.fromRGB(30, 30, 30);
			["toolTipBorderColor"] = Color3.fromRGB(200, 200, 200);
			["toolTipTransparency"] = .3;
			["toolTipBorderSize"] = 2;
			["toolTipTextColor"] = Color3.fromRGB(255, 255, 255);

			-- Zoom buttons
			["zoomButtonSize"] = UDim2.new(0, 30, 0, 30);
			["zoomButtonColor"] = Color3.fromRGB(51, 51, 51);
			["zoomButtonTextColor"] = Color3.fromRGB(255, 255, 255);
			["zoomButtonTransparency"] = 0.2;
		};

		["Map"] = {----- here you put your image ids of your map you can use rorender for a render of your map or you can do it by parts here is example
			["images"] = {
				-- Up left
				{
					["mapId"] = 82958275526624,
					["center"] = Vector3.new(
						848.805 - 2060.697,
						425.081,
						27.15 - 2179.790
					),
					["size"] = Vector2.new(
						4121.394,
						4359.581
					),
				},

				-- Up right
				{
					["mapId"] = 85471014684493,
					["center"] = Vector3.new(
						848.805 + 2060.697,
						425.081,
						27.15 - 2179.790
					),
					["size"] = Vector2.new(
						4121.394,
						4359.581
					),
				},

				-- Bottom left
				{
					["mapId"] = 135569291863770,
					["center"] = Vector3.new(
						848.805 - 2060.697,
						425.081,
						27.15 + 2179.790
					),
					["size"] = Vector2.new(
						4121.394,
						4359.581
					),
				},

				-- Bottom right
				{
					["mapId"] = 108408112197531,---kdyžtak je návod v dev infu
					["center"] = Vector3.new(
						848.805 + 2060.697,
						425.081,
						27.15 + 2179.790
					),
					["size"] = Vector2.new(
						4121.394,
						4359.581
					),
				},
			}
		};

		["Technical"] = { -- Technical settings
			["onePixel"] = 3;
			["maxBlipDistance"] = 100000;-----You can also use math.huge
			["rotation"] = true;
			["Visible"] = true;
			["mapRotation"] = -180;

			-- Zoom settings
			["zoomLevel"] = 1;
			["minZoom"] = 0.5;
			["maxZoom"] = 3;
			["zoomStep"] = 0.25;

			-- Large Map settings
			["isLargeMap"] = false;
			["autoRecenterTime"] = 3;
			["dragSmoothness"] = 0.15;--patched
		};
	}

return Settings
