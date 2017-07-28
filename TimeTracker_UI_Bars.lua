TT_UI_Tabs["Bars"] = {}
-- Funcs

TT_UI_Tabs["Bars"]["OnLoad"] = function (name) TT_UI_Bars_ReloadDropDown() end;
TT_UI_Tabs["Bars"]["OnShow"] = function (name) end;
TT_UI_Tabs["Bars"]["OnHide"] = function (name) end;

-- Select bar

TT_UI_Tabs["Bars"]["SelectBar"] = CreateFrame("Button", "bacontest", TT_UI_MainFrame, "UIDropDownMenuTemplate")
TT_UI_Tabs["Bars"]["SelectBar"]:ClearAllPoints()
TT_UI_Tabs["Bars"]["SelectBar"]:SetPoint("TOP", 100, -70)
TT_UI_Tabs["Bars"]["SelectBar"]:SetText("TimeTracker Settings!!!");

-- Save Button

TT_UI_Tabs["Bars"]["SaveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Bars"]["SaveButton"]:SetFrameStrata("background")
TT_UI_Tabs["Bars"]["SaveButton"]:SetWidth(120)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Bars"]["SaveButton"]:SetHeight(30) -- for your Texture
TT_UI_Tabs["Bars"]["SaveButton"].texture = TT_UI_Tabs["Bars"]["SaveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["Bars"]["SaveButton"].texture:SetTexture(0,0,0,1);
TT_UI_Tabs["Bars"]["SaveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE", "");
TT_UI_Tabs["Bars"]["SaveButton"]:SetPoint("TOPLEFT", 120, -70)
TT_UI_Tabs["Bars"]["SaveButton"]:SetText("Save");
TT_UI_Tabs["Bars"]["SaveButton"].texture:SetAllPoints(TT_UI_Tabs["Bars"]["SaveButton"])

TT_UI_Tabs["Bars"]["SaveButton"]:SetScript("OnMouseDown", function()
	--TT_UI_Tabs["Bars"]["SelectBar"].selectedValue
	--TT_printDebug(TT_UI_Tabs["Bars"]);
	for k2,v2 in pairs(TT_UI_Tabs["Bars"])
	do
		--TT_printDebug(k2);
		if string.find(k2, "_")
		then
			--TT_printDebug(k2)
			local tmp = TT_strsplit("_",k2)
			--TT_printDebug(tmp)
			if tmp[3] ~= nil
			then
				if tmp[3] == "INPUT"
				then
					if type(TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][tmp[1]][tmp[2]]) == "number"
					then
						TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][tmp[1]][tmp[2]] = tonumber(v2:GetText());
						--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
					else
						TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][tmp[1]][tmp[2]] = v2:GetText();
						--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
					end
				elseif tmp[3] == "BOOLEAN"
				then
					if string.lower(v2:GetText()) == "true"
					then
						TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][tmp[1]][tmp[2]] = true;
						--TT_printDebug(tmp[1] .. " -> true");
					else
						TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][tmp[1]][tmp[2]] = false;
						--TT_printDebug(tmp[1] .. " -> false");
					end;
				elseif tmp[3] == "COLOR"
				then
					--TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][tmp[1]][tmp[2]] = 
				else
					TT_printDebug("Cant save: " ..tmp[1]);
				end;
			end;
		end;
	end;
end)



-- Show Bar

TT_UI_Tabs["Bars"]["ShowBar"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Bars"]["ShowBar"]:SetFrameStrata("background")
TT_UI_Tabs["Bars"]["ShowBar"]:SetWidth(120)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Bars"]["ShowBar"]:SetHeight(30) -- for your Texture
TT_UI_Tabs["Bars"]["ShowBar"].texture = TT_UI_Tabs["Bars"]["ShowBar"]:CreateTexture(nil,"background");
TT_UI_Tabs["Bars"]["ShowBar"].texture:SetTexture(0,0,0,1);
TT_UI_Tabs["Bars"]["ShowBar"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
TT_UI_Tabs["Bars"]["ShowBar"]:SetPoint("TOPLEFT", 10, -70)
TT_UI_Tabs["Bars"]["ShowBar"]:SetText("Show bar");
TT_UI_Tabs["Bars"]["ShowBar"].texture:SetAllPoints(TT_UI_Tabs["Bars"]["ShowBar"])
TT_UI_Tabs["Bars"]["ShowBar"]:SetScript("OnMouseDown", function()
	if TT_UI_Tabs["Bars"]["SelectBar"].selectedValue ~= nil
	then
		TT_printDebug("OnMouseDown => TT_MakeCountdown");
		TT_MakeCountdown(TT_UI_Tabs["Bars"]["SelectBar"].selectedValue, 10)
		TT_printDebug("OnMouseDown => TT_MakeCountdown => DONE");
	end;
end)

-- Show all Bar

TT_UI_Tabs["Bars"]["ShowAllBar"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetFrameStrata("background")
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetWidth(120)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetHeight(30) -- for your Texture
TT_UI_Tabs["Bars"]["ShowAllBar"].texture = TT_UI_Tabs["Bars"]["ShowAllBar"]:CreateTexture(nil,"background");
TT_UI_Tabs["Bars"]["ShowAllBar"].texture:SetTexture(0,0,0,1);
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetPoint("TOPLEFT", 10, -40)
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetText("Show all bar");
TT_UI_Tabs["Bars"]["ShowAllBar"].texture:SetAllPoints(TT_UI_Tabs["Bars"]["ShowAllBar"])
TT_UI_Tabs["Bars"]["ShowAllBar"]:SetScript("OnMouseDown", function()
	if TT_Settings ~= nil and TT_Settings["bars"] ~= nil
	then
		for k2,v2 in pairs(TT_Settings["bars"])
		do
			TT_printDebug("bacon: "..k2);
			TT_MakeCountdown(k2, 60)
		end;
	end;
end)

-- 


function TT_UI_Bars_ReloadDropDown()
	UIDropDownMenu_Initialize(TT_UI_Tabs["Bars"]["SelectBar"],
	function()
		if TT_Settings ~= nil and TT_Settings["bars"] ~= nil
		then
			for k,v in pairs(TT_Settings["bars"])
			do
				local info = {};
				info.text = k
				info.func = function()
						UIDropDownMenu_SetSelectedID(TT_UI_Tabs["Bars"]["SelectBar"], this:GetID())
						TT_UI_Bars_PrintBarSettings(this.value);
						-- this.value -- get our name
					end
				UIDropDownMenu_AddButton(info, level)
			end
		end;
	end
	)
end


function TT_UI_Bars_PrintBarSettings(name)
	TT_UI_Tabs["Bars"]["SelectBar"].selectedValue = name;
	
	TT_UI_Tabs["Bars"]["NewBarInput"]:SetText(name);
	
	--TT_printDebug("Loading Bar Settings for: " .. name);
	local settings = TT_GetbarSettings(name);
	TT_printDebug(settings);
	local padding = 10;
	local xWidth = 150;
	local x = 0;
	for k,v in pairs(settings)
	do
		local line = -140;
		line = line - 30;
		if TT_UI_Tabs["Bars"] == nil
		then
			TT_UI_Tabs["Bars"] = {}
		end;
		if TT_UI_Tabs["Bars"][k.."_title"] == nil
		then
			TT_UI_Tabs["Bars"][k.."_title"] = PrintText(k, xWidth*x + padding, line, "TOPLEFT", 20);
			line = line - 20;
			TT_UI_Tabs["Bars"][k.."_stroke"] = PrintText("---------------------------------------------------------------------------", xWidth*x + padding, line, "TOPLEFT", 3);
		else
			line = line - 20;
			TT_UI_Tabs["Bars"][k.."_title"]:SetText(k);
		end;
		
		
		for k2,v2 in pairs(settings[k])
		do
			line = line - 20;
			if TT_UI_Tabs["Bars"][k.."_"..k2] == nil
			then
				TT_UI_Tabs["Bars"][k.."_"..k2] = PrintText(k2, xWidth*x + padding, line, "TOPLEFT");
			end;
			TT_UI_Tabs["Bars"][k.."_"..k2]:SetText(k2);
			--TT_printDebug(k2)
			
			line = line - 20;
			if type(v2) == "number" or type(v2) == "string"
			then
				-- If this is a string, then we use a input box.
				if TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"] == nil
				then
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"] = MakeInputBox();
				end;
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"]:SetText(v2);
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"].targetCategory = k;
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"].targetSetting = k2;
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"].texture:SetTexture(0,0,0,1);
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"]:SetWidth(120)  -- Set These to whatever height/width is needed 
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"]:SetHeight(15) -- for your Texture
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."INPUT"]:SetScript("OnChar", function(self)
					if type(TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][this.targetCategory][this.targetSetting]) == "number"
					then
						local tFinal = ""
						string.gsub(this:GetText(), "%d+", function(i) tFinal = tFinal .. i end)
						TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][this.targetCategory][this.targetSetting] = tonumber(tFinal);
						--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
					else
						if string.lower(this.targetSetting) == "anchor" and not TT_IsValidPoint(this:GetText())
						then
							return;
						end;
						TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][this.targetCategory][this.targetSetting] = this:GetText();
						--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
					end
				end)
			elseif type(v2) == "boolean"
			then
				-- IF a bool use a button.
				if TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"] == nil
				then
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"] = CreateFrame("Button", nil, TT_UI_MainFrame);
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"].texture = TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:CreateTexture(nil,"background");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"].targetCategory = k;
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"].targetSetting = k2;
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"].texture:SetAllPoints(TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"])
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetFrameStrata("background")
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetWidth(120)  -- Set These to whatever height/width is needed 
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetHeight(15) -- for your Texture
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetScript("OnClick", function(self)
						--TT_printDebug(this.targetCategory .. " -> " .. this.targetSetting);
						if string.lower(this:GetText()) == "true"
						then
							this:SetText("false");
							this.texture:SetTexture(1,0,0,1);
							TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][this.targetCategory][this.targetSetting] = false;
							--TT_printDebug("false text")
						else
							this:SetText("true");
							this.texture:SetTexture(0,1,0,1);
							TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][this.targetCategory][this.targetSetting] = true;
							--TT_printDebug("true text")
						end;
					end)
				end;
				if v2
				then
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetText("true");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"].texture:SetTexture(0,1,0,1);
				else
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"]:SetText("false");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."BOOLEAN"].texture:SetTexture(1,0,0,1);
				end;
				
			elseif type(v2) == "table"
			then
				if TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"] == nil
				then
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"] = CreateFrame("Button", nil, TT_UI_MainFrame);
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"].targetCategory = k;
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"].targetSetting = k2;
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetScript("OnClick", function(self)
						TT_ColorPick["Frame"] = this;
						TT_ColorPick["targetCategory"] = this.targetCategory;
						TT_ColorPick["targetSetting"] = this.targetSetting;
						ColorPickerFrame.hasOpacity = true;
						local r,g,b,a = this.texture:GetVertexColor();
						ColorPickerFrame:SetColorRGB(r, g, b, 1-a);
						ColorPickerFrame.opacity = 1-a;
						ColorPickerFrame.func = MY_COLOR_FUNCTION
						ColorPickerFrame:Show();
					end)
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetFrameStrata("background")
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetWidth(120)  -- Set These to whatever height/width is needed 
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetHeight(15) -- for your Texture
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"].texture = TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:CreateTexture(nil,"background");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"].texture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:SetText("Pick color" .. math.random(100));
							
					TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"].texture:SetAllPoints(TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"])
				end;
				
				--TT_printDebug(v2);
				
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"].texture:SetVertexColor(v2[1],v2[2],v2[3],v2[4]);
				
				TT_UI_Tabs["Bars"][k.."_"..k2.."_".."COLOR"]:Show()
			else
				--TT_printDebug(type(v2));
			end;
		end;
		x = x + 1
	end;
	--TT_printDebug(TT_Settings["bars"][name]);
	--TT_UpdateUI();
end;

TT_ColorPick = {};

function MY_COLOR_FUNCTION()
	if TT_ColorPick["Frame"] ~= nil
	then
		local R,G,B = ColorPickerFrame:GetColorRGB();
		local A = OpacitySliderFrame:GetValue();
		TT_ColorPick["Frame"].texture:SetVertexColor(R,G,B,1-A);
		TT_Settings["bars"][TT_UI_Tabs["Bars"]["SelectBar"].selectedValue][TT_ColorPick["targetCategory"]][TT_ColorPick["targetSetting"]] = {R,G,B,1-A};
	end;
end
--TT_printDebug("---------------------------------------")
--TT_printDebug(TT_UI_Tabs["Bars"]["SelectBar"])

UIDropDownMenu_SetWidth(100, TT_UI_Tabs["Bars"]["SelectBar"]);
UIDropDownMenu_SetButtonWidth(124, TT_UI_Tabs["Bars"]["SelectBar"])
UIDropDownMenu_JustifyText("LEFT", TT_UI_Tabs["Bars"]["SelectBar"])




--PrintText(text, x, y, anchor)



-- Add new bar

-- If this is a string, then we use a input box.
TT_UI_Tabs["Bars"]["NewBarInput"] = MakeInputBox();
TT_UI_Tabs["Bars"]["NewBarInput"]:SetText("New Bar Name" .. math.random(100000));
TT_UI_Tabs["Bars"]["NewBarInput"]:SetPoint("TOPLEFT", 10,-110)
TT_UI_Tabs["Bars"]["NewBarInput"].texture:SetTexture(0,0,0,1);
TT_UI_Tabs["Bars"]["NewBarInput"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["Bars"]["NewBarInput"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Bars"]["NewBarInput"]:SetHeight(15) -- for your Texture



TT_UI_Tabs["Bars"]["NewBarSaveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetFrameStrata("background")
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetHeight(15) -- for your Texture
TT_UI_Tabs["Bars"]["NewBarSaveButton"].texture = TT_UI_Tabs["Bars"]["NewBarSaveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["Bars"]["NewBarSaveButton"].texture:SetTexture(0,1,0,1);
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetPoint("TOPLEFT",  10,-130)
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetText("Make New Bar / Reset");
TT_UI_Tabs["Bars"]["NewBarSaveButton"].texture:SetAllPoints(TT_UI_Tabs["Bars"]["NewBarSaveButton"])
TT_UI_Tabs["Bars"]["NewBarSaveButton"]:SetScript("OnMouseDown", function()
	--TT_printDebug("Making a new bar: ".. TT_UI_Tabs["Bars"]["NewBarInput"]:GetText())
	if TT_Settings["bars"] ~= nil
	then
		-- Set it to nil so it will be reseted.
		TT_Settings["bars"][TT_UI_Tabs["Bars"]["NewBarInput"]:GetText()] = nil;
		
		
		local barSettings = TT_GetbarSettings(TT_UI_Tabs["Bars"]["NewBarInput"]:GetText());
		TT_Settings["bars"][TT_UI_Tabs["Bars"]["NewBarInput"]:GetText()] = barSettings;
		TT_UI_Bars_ReloadDropDown();
	end;
end)



TT_UI_Tabs["Bars"]["RemoveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Bars"]["RemoveButton"]:SetFrameStrata("background")
TT_UI_Tabs["Bars"]["RemoveButton"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Bars"]["RemoveButton"]:SetHeight(15) -- for your Texture
TT_UI_Tabs["Bars"]["RemoveButton"].texture = TT_UI_Tabs["Bars"]["RemoveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["Bars"]["RemoveButton"].texture:SetTexture(1,0,0,1);
TT_UI_Tabs["Bars"]["RemoveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["Bars"]["RemoveButton"]:SetPoint("TOPLEFT", 10,-150)
TT_UI_Tabs["Bars"]["RemoveButton"]:SetText("Remove (No warrning)");
TT_UI_Tabs["Bars"]["RemoveButton"].texture:SetAllPoints(TT_UI_Tabs["Bars"]["RemoveButton"])
TT_UI_Tabs["Bars"]["RemoveButton"]:SetScript("OnMouseDown", function()
	local name = TT_UI_Tabs["Bars"]["NewBarInput"]:GetText()
	if name ~= nil and TT_Settings ~= nil and TT_Settings["bars"] ~= nil
	then
		TT_Settings["bars"][name] = nil;
		TT_UI_Bars_ReloadDropDown();
	end;
end)



-- Need to reload the UI when we have added a new page.
--TT_UpdateUI();