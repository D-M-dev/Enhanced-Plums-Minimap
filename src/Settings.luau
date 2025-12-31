local Settings = 
	{
		["Tags"] = { -- Tagy pro zobrazení na minimapě
			{
				tagName = "CarSpawn";
				toolTip = "CarSpawn";
				iconID = 74530163668542;
				color = Color3.fromRGB(255,255,255);
				size = UDim2.new(0, 29, 0, 29); 
				snapToBorder = true;
				rotate = false;
			};

			{
				tagName = "Nemocnice";
				toolTip = "";
				text = "Nemocnice";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Vozovna";
				toolTip = "";
				text = "Vozovna";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Hasičský záchr. sbor";
				toolTip = "";
				text = "Hasičský záchr. sbor";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Nákupní zóna";
				toolTip = "";
				text = "Nákupní zóna";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Benzinová pumpa";
				toolTip = "";
				text = "Benzinová pumpa";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Autobusové nádraží";
				toolTip = "";
				text = "Autobusové nádraží";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Cihelna";
				toolTip = "";
				text = "Cihelna";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Podolí";
				toolTip = "";
				text = "Podolí";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Závodní okruh";
				toolTip = "";
				text = "Závodní okruh";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Kocourov";
				toolTip = "";
				text = "Kocourov";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Psikov";
				toolTip = "";
				text = "Psíkov";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Dealership";
				toolTip = "Dealership";
				iconID = 81004738963933;
				color = Color3.fromRGB(255,255,255);
				size = UDim2.new(0, 26, 0, 26); 
				snapToBorder = true;
				rotate = false;
			};
			
			
			{
				tagName = "Rakvice";
				toolTip = "";
				text = "Rakvice";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Městská policie";
				toolTip = "";
				text = "Městská policie";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "Policie České republiky";
				toolTip = "";
				text = "Policie České republiky";
				color = Color3.fromRGB(255, 255, 255);
				size = UDim2.new(0, 24, 0, 24); 
				snapToBorder = false;
				rotate = false;
			};
			
			{
				tagName = "EggDog Sídliště";
				toolTip = "";
				text = "EggDog Sídliště";
				color = Color3.fromRGB(255,255,255);
				size = UDim2.new(0, 32, 0, 32); 
				snapToBorder = false;
				rotate = false;
				
			};
			
		};

		["Teams"] = { -- Nastavení týmů pro zobrazení na minimapě
			enabled = true; -- Zapnout/vypnout zobrazení týmů
			showAllTeams = false; -- true = vidět všechny týmy, false = jen své

			teams = {
				["Hasičský Záchranný Sbor"] = {
					enabled = true;
					color = Color3.fromRGB(255, 0, 4); -- Modrá
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				["Místní Oddělení Policie"] = {
					enabled = true;
					color = Color3.fromRGB(60, 0, 255); -- Modrá
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				["Cizinecká Policie"] = {
					enabled = true;
					color = Color3.fromRGB(255, 0, 4); -- Modrá
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				["Oddělení Hlídkové Služby"] = {
					enabled = true;
					color = Color3.fromRGB(255, 0, 4); -- Modrá
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				["Pohotovostní Motorizovaná Jednotka"] = {
					enabled = true;
					color = Color3.fromRGB(38, 0, 255); -- Modrá
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				["Policie České republiky"] = {
					enabled = true;
					color = Color3.fromRGB(0, 38, 255); -- Modrá
					icon = 5483943698;
					size = UDim2.new(0, 18, 0, 18);
				};
				
			};
		};


		["Gui"] = { -- Nastavení GUI
			["mapSize"] = UDim2.new(.19,0,.19,0);
			["borderSize"] = 3;
			["anchorPoint"] = Vector2.new(0,1);
			["mapPosition"] = UDim2.new(0.008, -10, 0.915, -5);

			-- Large Map nastavení
			["largeMapSize"] = UDim2.new(0.7, 0, 0.7, 0);
			["largeMapPosition"] = UDim2.new(0.5, 0, 0.5, 0);
			["largeMapAnchorPoint"] = Vector2.new(0.5, 0.5);

			["Ratio"] = nil;

			-- Barvy
			["mapColor"] = Color3.fromRGB(103, 161, 255);
			["borderColor"] = Color3.fromRGB(176, 176, 176);

			-- Průhlednost
			["mapTransparency"] = .5;
			["borderTransparency"] = 0.4;

			-- Zaoblené rohy
			["mapCornerRoundness"] = UDim.new(0, 5);
			["borderCornerRoundness"] = UDim.new(0, 5);

			["blipColor"] = Color3.fromRGB(255,255,255);
			["blipTransparency"] = 1;
			["blipBorderSizePixel"] = 0;
			["blipBorderColor"] = Color3.fromRGB(0,0,0);

			-- Hráč
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

			-- Zoom tlačítka
			["zoomButtonSize"] = UDim2.new(0, 30, 0, 30);
			["zoomButtonColor"] = Color3.fromRGB(51, 51, 51);
			["zoomButtonTextColor"] = Color3.fromRGB(255, 255, 255);
			["zoomButtonTransparency"] = 0.2;
		};

		["Map"] = {
			["images"] = {
				-- HORNÍ LEVÁ
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

				-- HORNÍ PRAVÁ
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

				-- DOLNÍ LEVÁ
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

				-- DOLNÍ PRAVÁ
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

		["Technical"] = { -- Technické nastavení
			["onePixel"] = 3;
			["maxBlipDistance"] = 100000;
			["rotation"] = true;
			["Visible"] = true;
			["mapRotation"] = -180;

			-- Zoom nastavení
			["zoomLevel"] = 1;
			["minZoom"] = 0.5;
			["maxZoom"] = 3;
			["zoomStep"] = 0.25;

			-- Large Map nastavení
			["isLargeMap"] = false;---Hlavní promměnýá při Large Cyklu
			["autoRecenterTime"] = 3;
			["dragSmoothness"] = 0.15;--patched
		};
	}

return Settings