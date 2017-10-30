function SetChecked (Object, State, Toggle)
	if Options[VanillaUI.CurrentPage] then
		if Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()] then

			if Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()].Checked == "none" then
				Object:SetBackdropColor(0.35, 0.35, 0.35, 1);
			else
				if Toggle then 
					Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()].Checked = not Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()].Checked; 
				end
				if Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()].Checked == true then
					Object:SetBackdropColor(0.90, 0.90, 0.90, 1);
					Object:GetParent().Checked = true;
				else
					Object:SetBackdropColor(0.12, 0.12, 0.12, 1);
					Object:GetParent().Checked = false;
				end
			end
		end
	end
end

function SetStatus (Object, Lower, Higher)
	if Options[VanillaUI.CurrentPage] then
		if Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()] then
			ThisOption = Options[VanillaUI.CurrentPage][Object:GetParent().Text:GetText()];
			Object:SetMinMaxValues(ThisOption.Min, ThisOption.Max);
			if Higher and ThisOption.Value < ThisOption.Max then
				ThisOption.Value = ThisOption.Value + 1;
			elseif Lower and ThisOption.Value > ThisOption.Min then
				ThisOption.Value = ThisOption.Value - 1;
			end
			Object:SetValue(ThisOption.Value);
			Object.Text:SetText(ThisOption.Value);
			if ThisOption.Spell ~= nil then
				ThisOption.Spell:Refresh(ThisOption.Value);
			end
		end
	end
end

function Manager.RefreshOptions ()
	local OptionsPage, ThisOption, OptionsCount = Options[VanillaUI.CurrentPage] or {}, nil, 0;
    for OptionKey, OptionValue in next, OptionsPage, nil do
    	-- Prevent Attempting to Display non-options values
	    if OptionKey ~= "OptionsCount" and OptionKey ~= "PageIndex" then
	    	ThisOption = VanillaUI["Option"..OptionValue.Index];
    		ThisOption:Show();

	    	-- Text
			ThisOption.Text:SetText(OptionKey);
		    ThisOption.Checked = OptionValue.Checked;

	    	-- CheckBox
	    	if OptionValue.Checked == "header" then
		    	ThisOption.Check:Hide();
				ThisOption.Text:SetText(Colors.Blue.Hex..OptionKey);
			elseif OptionValue.Checked == "none" then
	    		ThisOption.Check:Show();
		    	ThisOption.Tooltip = OptionValue.Tooltip;
		    	SetChecked(ThisOption.Check, OptionValue.Checked);
			else
	    		ThisOption.Check:Show();
		    	ThisOption.Tooltip = OptionValue.Tooltip;
		    	SetChecked(ThisOption.Check, OptionValue.Checked);
		    end

	    	if OptionValue.Value then
		    	ThisOption.Minus:Show();
		    	ThisOption.Status:Show();
		    	ThisOption.Plus:Show();
		    	-- Status Bar
		    	ThisOption.Min, ThisOption.Max, ThisOption.Value = OptionValue.Min, OptionValue.Max, OptionValue.Value;
		    	SetStatus(ThisOption.Status);
		    else
		    	ThisOption.Minus:Hide();
		    	ThisOption.Status:Hide();
		    	ThisOption.Plus:Hide();
		    end
		    OptionsCount = OptionsCount + 1
		end
    end
    for i = OptionsCount + 1, 25 do
    	VanillaUI["Option"..i]:Hide();
    end
	-- Set Total Height as needed
	VanillaUI:SetHeight(OptionsCount*15+31);
	VanillaUI:SetPoint("TOPLEFT", GetSetting("UI_X"), GetSetting("UI_Y"));
	--- Refresh toolbox
	-- Rotation
	Manager.IsRunning = GetSetting("Running");
	Color = Manager.IsRunning and Colors.Green or Colors.Red;
	VanillaUI.Tools.Rota:SetBackdropColor(Color.R, Color.G, Color.B, 0.75);
	VanillaUI.Tools.Rota.Text:SetText(Manager.IsRunning and "ON" or "OFF");
	-- AoE
	Manager.AoE = GetSetting("AoE");
	Color = Manager.AoE and Colors.Green or Colors.Red;
	VanillaUI.Tools.AoE:SetBackdropColor(Color.R, Color.G, Color.B, 0.75);
	-- CDs
	Manager.CDs = GetSetting("CDs");
	Color = Manager.CDs and Colors.Green or Colors.Red;
	VanillaUI.Tools.CDs:SetBackdropColor(Color.R, Color.G, Color.B, 0.75);
	-- Spec Support
	-- Manager:SetSpec(GetSetting("Spec"));
	-- Hide UI is it's set to hidden in options
	if GetSetting("UI_Visible") == false then
		VanillaUI:Hide();
	end
end

---- UI
function Manager.LoadUI ()
	if Rotations[Player:Class()] ~= nil then
		local Backdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tileSize = 32,
			edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border",
			tile = 1,
			edgeSize = 3,
			insets = {
				top = 1,
				right = 1,
				left = 1,
				bottom = 1
			}
		};
		local CheckWidth, TextWidth, MinusWidth, StatusWidth, PlusWidth = 11, 100, 11, 34, 11;
		local CheckPosition, TextPosition, MinusPosition, StatusPosition, PlusPosition = 2, 2 + CheckWidth + 2, 2 + CheckWidth + 2 + TextWidth + 2, 2 + CheckWidth + 2 + TextWidth + 2 + MinusWidth, 2 + CheckWidth + 2 + TextWidth + 2 + MinusWidth + StatusWidth;
		local TotalWidth = 2 + CheckWidth + 2 + TextWidth + 2 + MinusWidth + StatusWidth + PlusWidth + 2;
		VanillaUI = CreateFrame("Frame", Randomize());
		VanillaUI:SetWidth(TotalWidth);
		VanillaUI:SetHeight(100);
		VanillaUI:SetPoint("TOPLEFT", GetSetting("UI_X"), GetSetting("UI_Y"));
		VanillaUI:SetFrameLevel(90);
		VanillaUI:SetMovable(true);
		VanillaUI:EnableMouse(true);
		VanillaUI:SetClampedToScreen(true);
		VanillaUI:Show();
		VanillaUI:SetBackdrop(Backdrop);
		VanillaUI:SetBackdropColor(0, 0, 0, 1);
		VanillaUI.Texture = VanillaUI:CreateTexture(nil, "BACKGROUND");
		VanillaUI.Texture:SetTexture(0.25, 0.25, 0.25, 1);
		VanillaUI.Texture:SetAllPoints(VanillaUI);
		VanillaUI.CurrentPage = "General";
		VanillaUI:SetScript("OnMouseDown", function ()
			VanillaUI:StartMoving();
		end);
		VanillaUI:SetScript("OnMouseUp", function ()
			VanillaUI:StopMovingOrSizing();
			local Point, RelativeTo, RelativePoint, X, Y = VanillaUI:GetPoint();
			SetSetting("UI_X", X);
			SetSetting("UI_Y", Y);
		end);

		--- Tools
		VanillaUI["Tools"] = CreateFrame("Frame", "Tools", VanillaUI);
		local Tools = VanillaUI["Tools"];
		Tools:SetPoint("TOPLEFT" , VanillaUI, "TOPLEFT" , 1, -1);
		Tools:SetWidth(TotalWidth-2);
		Tools:SetHeight(14);
		Tools.Texture = Tools:CreateTexture(nil, "BACKGROUND");
		Tools.Texture:SetTexture(0.15, 0.15, 0.15, 1);
		Tools.Texture:SetAllPoints(Tools);
		Tools:Show();

		--- Rota Button
		Tools.Rota = CreateFrame("Button", "Rota", Tools);
		local Rota = Tools.Rota;
		Rota:SetPoint("TOPLEFT", Tools, "TOPLEFT", 1, -1);
		Rota:SetWidth(57);
		Rota:SetHeight(13);
		Rota:SetBackdrop(Backdrop);
		Rota:SetBackdropColor(Colors.Red.R, Colors.Red.G, Colors.Red.B, 0.75);
		Rota.Text = Rota:CreateFontString();
		Rota.Text:SetPoint("TOPLEFT", Rota, "TOPLEFT", 0, 1);
		Rota.Text:SetPoint("BOTTOMRIGHT", Rota, "BOTTOMLEFT", 57, 0);
		Rota.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		Rota.Text:SetJustifyH("CENTER");
		Rota.Text:SetText("|cffFFFFFFOFF");
		Rota:Show();
		Rota:SetScript("OnClick", function ()
			Manager:Toggle();
			GameTooltip:Hide();
			GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
			GameTooltip:SetText("|cffFFFFFF"..(GetSetting("Running") and "Disable" or "Enable").." the Rotation Pulse.", nil,nil, nil, nil, 1);
		end);
		Rota:SetScript("OnEnter", function (self)
			GameTooltip:Hide();
			GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
			GameTooltip:SetText("|cffFFFFFF"..(GetSetting("Running") and "Disable" or "Enable").." the Rotation Pulse.", nil,nil, nil, nil, 1);
		end);
		Rota:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- AoE Button
		Tools.AoE = CreateFrame("Button", "AoE", Tools);
		local AoE = Tools.AoE;
		AoE:SetPoint("TOPLEFT", Tools, "TOPLEFT", 57, -1);
		AoE:SetWidth(57);
		AoE:SetHeight(13);
		AoE:SetBackdrop(Backdrop);
		AoE:SetBackdropColor(Colors.Red.R, Colors.Red.G, Colors.Red.B, 0.75);
		AoE.Text = AoE:CreateFontString();
		AoE.Text:SetPoint("TOPLEFT", AoE, "TOPLEFT", 0, 1);
		AoE.Text:SetPoint("BOTTOMRIGHT", AoE, "BOTTOMLEFT", 57, 0);
		AoE.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		AoE.Text:SetJustifyH("CENTER");
		AoE.Text:SetText("|cffFFFFFFAoE");
		AoE:Show();
		AoE:SetScript("OnClick", function ()
			Manager:ToggleAoE();
			GameTooltip:Hide();
			GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
			GameTooltip:SetText("|cffFFFFFF"..(GetSetting("AoE") and "Disable" or "Enable").." the AoE.", nil,nil, nil, nil, 1);
		end);
		AoE:SetScript("OnEnter", function (self)
			GameTooltip:Hide();
			GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
			GameTooltip:SetText("|cffFFFFFF"..(GetSetting("AoE") and "Disable" or "Enable").." the AoE.", nil,nil, nil, nil, 1);
		end);
		AoE:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- CDs Button
		Tools.CDs = CreateFrame("Button", "CDs", Tools);
		local CDs = Tools.CDs;
		CDs:SetPoint("TOPLEFT", Tools, "TOPLEFT", 114, -1);
		CDs:SetWidth(57);
		CDs:SetHeight(13);
		CDs:SetBackdrop(Backdrop);
		CDs:SetBackdropColor(Colors.Red.R, Colors.Red.G, Colors.Red.B, 0.75);
		CDs.Text = CDs:CreateFontString();
		CDs.Text:SetPoint("TOPLEFT", CDs, "TOPLEFT", 0, 1);
		CDs.Text:SetPoint("BOTTOMRIGHT", CDs, "BOTTOMLEFT", 57, 0);
		CDs.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		CDs.Text:SetJustifyH("CENTER");
		CDs.Text:SetText("|cffFFFFFFCDs");
		CDs:Show();
		CDs:SetScript("OnClick", function ()
			Manager:ToggleCDs();
			GameTooltip:Hide();
			GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
			GameTooltip:SetText("|cffFFFFFF"..(GetSetting("CDs") and "Disable" or "Enable").." the Cooldowns.", nil,nil, nil, nil, 1);
		end);
		CDs:SetScript("OnEnter", function (self)
			GameTooltip:Hide();
			GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
			GameTooltip:SetText("|cffFFFFFF"..(GetSetting("CDs") and "Disable" or "Enable").." the Cooldowns.", nil,nil, nil, nil, 1);
		end);
		CDs:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- Spec Support Buttons
		-- for i = 1, 3 do
		-- 	Tools["Spec"..i] = CreateFrame("Button", "Spec"..i, Tools);
		-- 	local ThisSpec = Tools["Spec"..i];
		-- 	ThisSpec:SetPoint("TOPLEFT", Tools, "TOPLEFT", 63+i*27, -1);
		-- 	ThisSpec:SetWidth(27);
		-- 	ThisSpec:SetHeight(13);
		-- 	ThisSpec:SetBackdrop(Backdrop);
		-- 	ThisSpec:SetBackdropColor(Colors.Red.R, Colors.Red.G, Colors.Red.B, 0.75);
		-- 	ThisSpec.Text = ThisSpec:CreateFontString();
		-- 	ThisSpec.Text:SetPoint("TOPLEFT", ThisSpec, "TOPLEFT", 0, 1);
		-- 	ThisSpec.Text:SetPoint("BOTTOMRIGHT", ThisSpec, "BOTTOMLEFT", 27, 0);
		-- 	ThisSpec.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		-- 	ThisSpec.Text:SetJustifyH("CENTER");
		-- 	ThisSpec.Text:SetText(i);
		-- 	ThisSpec:Show();
		-- 	ThisSpec:SetScript("OnClick", function ()
		-- 		Manager:SetSpec(tonumber(ThisSpec.Text:GetText()));
		-- 		GameTooltip:Hide();
		-- 		GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
		-- 		GameTooltip:SetText("|cffFFFFFFUse Spec "..ThisSpec.Text:GetText()..".", nil,nil, nil, nil, 1);
		-- 	end);
		-- 	ThisSpec:SetScript("OnEnter", function (self)
		-- 		GameTooltip:Hide();
		-- 		GameTooltip:SetOwner(Tools, "ANCHOR_RIGHT", -195);
		-- 		GameTooltip:SetText("|cffFFFFFFUse Spec "..ThisSpec.Text:GetText()..".", nil,nil, nil, nil, 1);
		-- 	end);
		-- 	ThisSpec:SetScript("OnLeave", function (self)
		-- 		GameTooltip:Hide();
		-- 	end);
		-- end

		--- Distance Display
		Tools.Distance = CreateFrame("Button", "Distance", Tools);
		local Distance = Tools.Distance;
		Distance:SetPoint("TOPLEFT", Tools, "TOPLEFT", 1, 13);
		Distance:SetWidth(30);
		Distance:SetHeight(13);
		Distance:SetBackdrop(Backdrop);
		Distance:SetBackdropColor(Colors.Gray.R, Colors.Gray.G, Colors.Gray.B, 1);
		Distance.Text = Distance:CreateFontString();
		Distance.Text:SetPoint("TOPLEFT", Distance, "TOPLEFT", 0, 0);
		Distance.Text:SetPoint("BOTTOMRIGHT", Distance, "BOTTOMLEFT", 30, 0);
		Distance.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		Distance.Text:SetJustifyH("CENTER");
		Distance.Text:SetText("");
		Distance:Show();
		Distance:SetScript("OnEnter", function (self)
			GameTooltip:Hide();
			GameTooltip:SetOwner(Distance, "ANCHOR_RIGHT", -37);
			GameTooltip:SetText("|cffFFFFFFDistance to the current Target.", nil,nil, nil, nil, 1);
		end);
		Distance:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- Debug Display
		Tools.Debug = CreateFrame("Button", "Debug", Tools);
		local Debug = Tools.Debug;
		Debug:SetPoint("TOPLEFT", Tools, "TOPLEFT", 30, 13);
		Debug:SetWidth(111);
		Debug:SetHeight(13);
		Debug:SetBackdrop(Backdrop);
		Debug:SetBackdropColor(Colors.Gray.R, Colors.Gray.G, Colors.Gray.B, 1);
		Debug.Text = Debug:CreateFontString();
		Debug.Text:SetPoint("TOPLEFT", Debug, "TOPLEFT", 2, 0);
		Debug.Text:SetPoint("BOTTOMRIGHT", Debug, "BOTTOMLEFT", 111, 0);
		Debug.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		Debug.Text:SetJustifyH("LEFT");
		Debug.Text:SetText("");
		Debug:Show();
		Debug:SetScript("OnEnter", function (self)
			GameTooltip:Hide();
			GameTooltip:SetOwner(Distance, "ANCHOR_RIGHT", -37);
			GameTooltip:SetText("|cffFFFFFFDebug.", nil,nil, nil, nil, 1);
		end);
		Debug:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- Distance Display
		Tools.TTD = CreateFrame("Button", "TTD", Tools);
		local TTD = Tools.TTD;
		TTD:SetPoint("TOPLEFT", Tools, "TOPLEFT", 141, 13);
		TTD:SetWidth(30);
		TTD:SetHeight(13);
		TTD:SetBackdrop(Backdrop);
		TTD:SetBackdropColor(Colors.Gray.R, Colors.Gray.G, Colors.Gray.B, 1);
		TTD.Text = TTD:CreateFontString();
		TTD.Text:SetPoint("TOPLEFT", TTD, "TOPLEFT", 0, 0);
		TTD.Text:SetPoint("BOTTOMRIGHT", TTD, "BOTTOMLEFT", 30, 0);
		TTD.Text:SetFont("Fonts\\FRIZQT__.ttf", 9, "OUTLINE");
		TTD.Text:SetJustifyH("CENTER");
		TTD.Text:SetText("");
		TTD:Show();
		TTD:SetScript("OnEnter", function (self)
			GameTooltip:Hide();
			GameTooltip:SetOwner(TTD, "ANCHOR_RIGHT", -37);
			GameTooltip:SetText("|cffFFFFFFTime to Die of the current Target.", nil,nil, nil, nil, 1);
		end);
		TTD:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- Header
		VanillaUI["Header"] = CreateFrame("Frame", "Header", VanillaUI);
		local Header = VanillaUI["Header"];
		Header:SetPoint("TOPLEFT" , VanillaUI, "TOPLEFT" , 1, -16);
		Header:SetWidth(TotalWidth-2);
		Header:SetHeight(14);
		Header.Texture = Header:CreateTexture(nil, "BACKGROUND");
		Header.Texture:SetTexture(0.15, 0.15, 0.15, 1);
		Header.Texture:SetAllPoints(Header);
		Header:Show();

		--- Header Text
		Header.Text = Header:CreateFontString();
		Header.Text:SetPoint("TOPLEFT", Header, "TOPLEFT", 2, -2);
		Header.Text:SetPoint("BOTTOMRIGHT", Header, "BOTTOMRIGHT", -2, 2);
		Header.Text:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE");
		Header.Text:SetJustifyH("CENTER");
		Header.Text:SetText("General");
		Header.Text:Show();

		--- Previous Button
		Header.Previous = CreateFrame("Button", "Header Previous", Header);
		local Previous = Header.Previous;
		Previous:SetPoint("TOPLEFT", Header, "TOPLEFT", 1, -1);
		Previous:SetWidth(13);
		Previous:SetHeight(13);
		Previous:SetBackdrop(Backdrop);
		Previous:SetBackdropColor(0, 0, 0, 0.25);
		Previous.Text = Previous:CreateFontString();
		Previous.Text:SetPoint("TOPLEFT", Previous, "TOPLEFT", 3, -2);
		Previous.Text:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE");
		Previous.Text:SetJustifyH("CENTER");
		Previous.Text:SetText("|cffFFFFFF<");
		Previous:Show();
		Previous:SetScript("OnClick", function ()
			if VanillaUI.CurrentPage ~= OptionsPages[1] then
				if VanillaUI.CurrentPage == OptionsPages[2] then
					VanillaUI.CurrentPage = OptionsPages[1];
					Header.Previous:SetBackdropColor(0, 0, 0, 0.25);
					Header.Text:SetText(VanillaUI.CurrentPage);
					Manager.RefreshOptions();
				elseif VanillaUI.CurrentPage == OptionsPages[3] then
					VanillaUI.CurrentPage = OptionsPages[2];
					Header.Text:SetText(VanillaUI.CurrentPage);
					Manager.RefreshOptions();
				elseif VanillaUI.CurrentPage == OptionsPages[4] then
					VanillaUI.CurrentPage = OptionsPages[3];
					Header.Next:SetBackdropColor(0, 0, 0, 1);
					Header.Text:SetText(VanillaUI.CurrentPage);
					Manager.RefreshOptions();
				end
			end
			GameTooltip:Hide();
			if VanillaUI.CurrentPage ~= OptionsPages[1] then
				GameTooltip:SetOwner(Header, "ANCHOR_RIGHT", -195);
				GameTooltip:SetText("|cffFFFFFFDisplay the previous page of options.", nil,nil, nil, nil, 1);
			end
		end);
		Previous:SetScript("OnEnter", function (self)
			if VanillaUI.CurrentPage ~= OptionsPages[1] then
				GameTooltip:Hide();
				GameTooltip:SetOwner(Header, "ANCHOR_RIGHT", -195);
				GameTooltip:SetText("|cffFFFFFFDisplay the previous page of options.", nil,nil, nil, nil, 1);
			end
		end);
		Previous:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);

		--- Next Button
		Header.Next = CreateFrame("Button", "Header Next", Header);
		local Next = Header.Next;
		Next:SetPoint("TOPRIGHT", Header, "TOPRIGHT", -1, -1);
		Next:SetWidth(13);
		Next:SetHeight(13);
		Next:SetBackdrop(Backdrop);
		Next:SetBackdropColor(0, 0, 0, 1);
		Next.Text = Next:CreateFontString();
		Next.Text:SetPoint("TOPLEFT", Next, "TOPLEFT", 2, -2);
		Next.Text:SetFont("Fonts\\ARIALN.ttf", 10, "OUTLINE");
		Next.Text:SetJustifyH("CENTER");
		Next.Text:SetText("|cffFFFFFF>");
		Next:Show();
		Next:SetScript("OnClick", function ()
			if VanillaUI.CurrentPage ~= OptionsPages[4] then
				if VanillaUI.CurrentPage == OptionsPages[1] then
					VanillaUI.CurrentPage = OptionsPages[2];
					Header.Previous:SetBackdropColor(0, 0, 0, 1);
					Header.Text:SetText(VanillaUI.CurrentPage);
					Manager.RefreshOptions();
				elseif VanillaUI.CurrentPage == OptionsPages[2] then
					VanillaUI.CurrentPage = OptionsPages[3];
					Header.Text:SetText(VanillaUI.CurrentPage);
					Manager.RefreshOptions();
				elseif VanillaUI.CurrentPage == OptionsPages[3] then
					VanillaUI.CurrentPage = OptionsPages[4];
					Header.Next:SetBackdropColor(0, 0, 0, 0.25);
					Header.Text:SetText(VanillaUI.CurrentPage);
					Manager.RefreshOptions();
				end
			end
			GameTooltip:Hide();
			if VanillaUI.CurrentPage ~= OptionsPages[3] then
				GameTooltip:SetOwner(Header, "ANCHOR_RIGHT", -195);
				GameTooltip:SetText("|cffFFFFFFDisplay the next page of options.", nil,nil, nil, nil, 1);
			end
		end);
		Next:SetScript("OnEnter", function (self)
			if VanillaUI.CurrentPage ~= OptionsPages[3] then
				GameTooltip:Hide();
				GameTooltip:SetOwner(Header, "ANCHOR_RIGHT", -195);
				GameTooltip:SetText("|cffFFFFFFDisplay the next page of options.", nil,nil, nil, nil, 1);
			end
		end);
		Next:SetScript("OnLeave", function (self)
			GameTooltip:Hide();
		end);



		-- Saved Options based on current class
		local LocalClass, GlobalClass = UnitClass("player");
		local CurrentPlayerClass = GlobalClass;

		Row = 0
		for i = 1, 25 do
			--- Option Row
			VanillaUI["Option"..i] = CreateFrame("Frame", "Option"..i, VanillaUI);
			local Option = VanillaUI["Option"..i];
			Option:SetPoint("TOPLEFT" , VanillaUI, "TOPLEFT" , 1, Row*-15-31);
			Option:SetWidth(TotalWidth-2);
			Option:SetHeight(14);
			Option.Texture = Option:CreateTexture(nil, "BACKGROUND");
			Option.Texture:SetTexture(0.35, 0.35, 0.35, 0.9);
			Option.Texture:SetAllPoints(Option);
			Option:Show();

			--- Option Text
			Option.Text = Option:CreateFontString();
			Option.Text:SetPoint("TOPLEFT", Option, "TOPLEFT", TextPosition, -2);
			Option.Text:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE");
			Option.Text:SetJustifyH("CENTER");
			Option.Text:SetText("|cffFFFFFFOption"..i);
			Option.Text:Show();

			--- Checkbox
			Option.Check = CreateFrame("Button", "Option"..i.."Check", Option);
			local Check = Option.Check;
			Check:SetPoint("TOPLEFT" , Option, "TOPLEFT" , CheckPosition, -1);
			Check:SetWidth(12);
			Check:SetHeight(12);
			Check:SetBackdrop(Backdrop);
			Check:Show();

			SetChecked(Check, false);

			-- Check Functions
			Check:SetScript("OnClick", function ()
				SetChecked(Check, State, true);
				Manager:SaveSettings();
				if Option.Tooltip == nil or type(Option.Tooltip) ~= "string" then
					GameTooltip:Hide();
					GameTooltip:SetOwner(Check, "ANCHOR_RIGHT", -16);
					if Option.Checked then
						GameTooltip:SetText("|cFFFFFFFFDisable "..Check:GetParent().Text:GetText(), nil,nil, nil, nil, 1);
					else
						GameTooltip:SetText("|cFFFFFFFFEnable "..Check:GetParent().Text:GetText(), nil,nil, nil, nil, 1);
					end
				end
			end);
			Check:SetScript("OnEnter", function (self)
				GameTooltip:Hide();
				GameTooltip:SetOwner(Check, "ANCHOR_RIGHT", -16);
				if Option.Tooltip ~= nil and type(Option.Tooltip) == "string" then
					GameTooltip:SetText("|cFF26BAFFDescription|cFFFFFFFF\n"..Option.Tooltip, nil,nil, nil, nil, 1);
				else
					if Option.Checked then
						GameTooltip:SetText("|cFFFFFFFFDisable "..Check:GetParent().Text:GetText(), nil,nil, nil, nil, 1);
					else
						GameTooltip:SetText("|cFFFFFFFFEnable "..Check:GetParent().Text:GetText(), nil,nil, nil, nil, 1);
					end
				end
			end);
			Check:SetScript("OnLeave", function (self)
				GameTooltip:Hide();
			end);

			--- Status Bar
			Option.Status = CreateFrame("StatusBar", "Option"..i.."Status", Option);
			local Status = Option.Status;
			Status:SetPoint("TOPLEFT", Option, "TOPLEFT", StatusPosition, -1);
			Status:SetMinMaxValues(0, 100);
			Status:SetValue(50);
			Status:SetWidth(34);
			Status:SetHeight(12);
		    Status:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
			Status.Text = Status:CreateFontString();
			Status.Text:SetPoint("CENTER", Status, "CENTER", 0, 0);
			Status.Text:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE");
			Status.Text:SetJustifyH("CENTER");
			Status.Text:SetText(50);
			Status:Show();

			--- Minus Button
			Option.Minus = CreateFrame("Button", "Option"..i.."Minus", Option);
			local Minus = Option.Minus;
			Minus:SetPoint("TOPLEFT", Option, "TOPLEFT", MinusPosition, 0);
			Minus:SetWidth(11);
			Minus:SetHeight(14);
			Minus:SetBackdrop(Backdrop);
			Minus:SetBackdropColor(0.12, 0.12, 0.12, 1);
			Minus:EnableMouseWheel(true);
			Minus.Text = Minus:CreateFontString();
			Minus.Text:SetPoint("TOPLEFT", Minus, "TOPLEFT", 2, -1);
			Minus.Text:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE");
			Minus.Text:SetJustifyH("CENTER");
			Minus.Text:SetText("|cffFFFFFF-");
			Minus:Show();
			Minus:SetScript("OnClick", function ()
				SetStatus(Minus:GetParent().Status, true, false);
				Manager:SaveSettings();
			end);
			Minus:SetScript("OnMouseWheel", function (self, delta)
				SetStatus(Minus:GetParent().Status, true, false);
				Manager:SaveSettings();
			end);
			Minus:SetScript("OnEnter", function (self)
				GameTooltip:Hide();
				GameTooltip:SetOwner(Minus, "ANCHOR_RIGHT");
				GameTooltip:SetText("|cFFFFFFFFDecrease value for "..Minus:GetParent().Text:GetText(), nil,nil, nil, nil, 1);
			end);
			Minus:SetScript("OnLeave", function (self)
				GameTooltip:Hide();
			end);

			--- Plus Button
			Option.Plus = CreateFrame("Button", "Option"..i.."Plus", Option);
			local Plus = Option.Plus;
			Plus:SetPoint("TOPLEFT", Option, "TOPLEFT", PlusPosition, 0);
			Plus:SetWidth(11);
			Plus:SetHeight(14);
			Plus:SetBackdrop(Backdrop);
			Plus:SetBackdropColor(0.12, 0.12, 0.12, 1);
			Plus:EnableMouseWheel(true);
			Plus.Text = Plus:CreateFontString();
			Plus.Text:SetPoint("TOPLEFT", Plus, "TOPLEFT", 1, -2);
			Plus.Text:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE");
			Plus.Text:SetJustifyH("CENTER");
			Plus.Text:SetText("|cffFFFFFF+");
			Plus:Show();
			Plus:SetScript("OnClick", function ()
				SetStatus(Plus:GetParent().Status, false, true);
				Manager:SaveSettings();
			end);
			Plus:SetScript("OnMouseWheel", function ()
				SetStatus(Plus:GetParent().Status, false, true);
				Manager:SaveSettings();
			end);
			Plus:SetScript("OnEnter", function (self)
				GameTooltip:Hide();
				GameTooltip:SetOwner(Plus, "ANCHOR_RIGHT");
				GameTooltip:SetText("|cFFFFFFFFIncrease value for "..Plus:GetParent().Text:GetText(), nil,nil, nil, nil, 1);
			end);
			Plus:SetScript("OnLeave", function (self)
				GameTooltip:Hide();
			end);

			Row = Row + 1;
		end

		-- Set Total Height as needed
		VanillaUI:SetHeight(Row*15+31);
		function VanillaUI:ToggleDisplay ()
			if VanillaUI:IsShown() then
				SetSetting("UI_Visible", false);
				VanillaUI:Hide();
			else
				VanillaUI:Show();
				SetSetting("UI_Visible", true);
			end
		end

		--- Get the status of an option from the Options table
		function VanillaUI:ToggleOption (OptionName)
			local Found = false;
			for i = 1, 4 do
				if Options[OptionsPages[i]] and Options[OptionsPages[i]][OptionName] ~= nil then
					Found = true;
					Options[OptionsPages[i]][OptionName].Checked = not Options[OptionsPages[i]][OptionName].Checked;
					print("|cFFFFDD11[DPSEngine]|r "..OptionName.." value successfully toggled.");
					Manager:SaveSettings();
					Manager.RefreshOptions();
				end
			end
			if not Found then
				print("|cFFFFDD11[DPSEngine]|r Option "..OptionName.." was not found.");
			end
		end

		--- Get the value of an option from the Options table
		function VanillaUI:SetOptionValue (OptionName, Value)
			local Found = false;
			for i = 1, 4 do
				if Options[OptionsPages[i]] and Options[OptionsPages[i]][OptionName] ~= nil then
					if Options[OptionsPages[i]][OptionName].Max ~= nil then
						if Value <= Options[OptionsPages[i]][OptionName].Max then
							if Value >= Options[OptionsPages[i]][OptionName].Min then
								Found = true;
								Options[OptionsPages[i]][OptionName].Value = Value;
								print("|cFFFFDD11[DPSEngine]|r "..OptionName.." value successfully changed to "..Value..".");
								Manager:SaveSettings();
								Manager.RefreshOptions();
							else
								print("|cFFFFDD11[DPSEngine]|r "..OptionName.." value was not changed to "..Value.." since the value was too low.");
							end
						else
							print("|cFFFFDD11[DPSEngine]|r "..OptionName.." value was not changed to "..Value.." since the value was too low.");
						end
					else
						print("|cFFFFDD11[DPSEngine]|r Option "..OptionName.." has no value attached to it.");
					end
				end
			end
			if not Found then
				print("|cFFFFDD11[DPSEngine]|r "..OptionName.."'s value was not changed.");
			end
		end
	end
end
