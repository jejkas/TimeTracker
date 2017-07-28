TT_UI_Tabs["ProcList"] = {}
-- Funcs

TT_UI_Tabs["ProcList"]["OnLoad"] = function (name) TT_UI_ProcBars_ReloadDropDown() end;
TT_UI_Tabs["ProcList"]["OnShow"] = function (name) end;
TT_UI_Tabs["ProcList"]["OnHide"] = function (name) end;

-- Select bar

TT_UI_Tabs["ProcList"]["SelectBar"] = CreateFrame("Button", "TT_UI_ProcBars_SelectBar_Frame", TT_UI_MainFrame, "UIDropDownMenuTemplate")
TT_UI_Tabs["ProcList"]["SelectBar"]:ClearAllPoints()
TT_UI_Tabs["ProcList"]["SelectBar"]:SetPoint("TOP", 100, -70)
TT_UI_Tabs["ProcList"]["SelectBar"]:SetText("TimeTracker Settings!");


function TT_UI_ProcBars_ReloadDropDown()
	UIDropDownMenu_Initialize(TT_UI_Tabs["ProcList"]["SelectBar"],
	function()
		if TT_Settings ~= nil and TT_Settings["Tracking"] ~= nil
		then
			for k,v in pairs(TT_Settings["Tracking"])
			do
				if v ~= nil
				then
					local info = {};
					info.text = v["Name"]
					info.func = function()
						UIDropDownMenu_SetSelectedID(TT_UI_Tabs["ProcList"]["SelectBar"], this:GetID())
						TT_UI_ProcBars_PrintBarSettings(this.value);
						-- this.value -- get our name
					end
					UIDropDownMenu_AddButton(info, level)
					--TT_printDebug(info);
				end;
			end
		end
	end
	)
end


function TT_UI_ProcBars_PrintBarSettings(name)
	if name ~= nil
	then
		TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue = name;
	
		TT_UI_Tabs["ProcList"]["NewBarNameInput"]:SetText(name);
		
		
		local trackerSettings = TT_GetTracking(name);
		local padding = 10;
		local xWidth = 150;
		local x = 0;
		local line = -110;
		
		for k,v in pairs(trackerSettings)
		do
			if k ~= "Name"
			then
				line = line - 25;
				if TT_UI_Tabs["ProcList"][k.."_title"] == nil
				then
					TT_UI_Tabs["ProcList"][k.."_title"] = PrintText(k, xWidth*x + padding, line, "TOPLEFT");
				end;
				TT_UI_Tabs["ProcList"][k.."_title"]:SetText(k);
				line = line - 15;
				
				if type(trackerSettings[k]) == "number" or type(trackerSettings[k]) == "string"
				then
					-- If this is a string, then we use a input box.
					if TT_UI_Tabs["ProcList"][k.."_".."INPUT"] == nil
					then
						TT_UI_Tabs["ProcList"][k.."_".."INPUT"] = MakeInputBox();
					end;
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"]:SetText(v);
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"].targetCategory = k;
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"].texture:SetTexture(0,0,0,1);
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"]:SetWidth(120)  -- Set These to whatever height/width is needed 
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"]:SetHeight(15) -- for your Texture
					TT_UI_Tabs["ProcList"][k.."_".."INPUT"]:SetScript("OnChar", function(self)
						if type(TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue][this.targetCategory]) == "number"
						then
							local tFinal = ""
							string.gsub(this:GetText(), "%d+", function(i) tFinal = tFinal .. i end)
							TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue][this.targetCategory] = tonumber(tFinal);
							--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
						else
							TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue][this.targetCategory] = this:GetText();
							--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
						end
					end)
				
				elseif type(trackerSettings[k]) == "boolean"
				then
					-- IF a bool use a button.
					if TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"] == nil
					then
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"] = CreateFrame("Button", nil, TT_UI_MainFrame);
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"].texture = TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:CreateTexture(nil,"background");
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"].targetCategory = k;
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"].texture:SetAllPoints(TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"])
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetFrameStrata("background")
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetWidth(120)  -- Set These to whatever height/width is needed 
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetHeight(15) -- for your Texture
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetScript("OnClick", function(self)
							--TT_printDebug(this.targetCategory .. " -> " .. this.targetSetting);
							if string.lower(this:GetText()) == "true"
							then
								this:SetText("false");
								this.texture:SetTexture(1,0,0,1);
								TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue][this.targetCategory] = false;
								--TT_printDebug(TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue])
								--TT_printDebug("false text")
							else
								this:SetText("true");
								this.texture:SetTexture(0,1,0,1);
								TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue][this.targetCategory] = true;
								--TT_printDebug(TT_Settings["Tracking"][TT_UI_Tabs["ProcList"]["SelectBar"].selectedValue])
								--TT_printDebug("true text")
							end;
						end)
					end;
					if v
					then
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetText("true");
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"].texture:SetTexture(0,1,0,1);
					else
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"]:SetText("false");
						TT_UI_Tabs["ProcList"][k.."_".."BOOLEAN"].texture:SetTexture(1,0,0,1);
					end;
				end;
			end;
		end;
	end;
end;




UIDropDownMenu_SetWidth(100, TT_UI_Tabs["ProcList"]["SelectBar"]);
UIDropDownMenu_SetButtonWidth(124, TT_UI_Tabs["ProcList"]["SelectBar"])
UIDropDownMenu_JustifyText("LEFT", TT_UI_Tabs["ProcList"]["SelectBar"])




--PrintText(text, x, y, anchor)



-- Add new bar

-- If this is a string, then we use a input box.
TT_UI_Tabs["ProcList"]["NewBarNameInput"] = MakeInputBox();
TT_UI_Tabs["ProcList"]["NewBarNameInput"]:SetText("Proc Name Here");
TT_UI_Tabs["ProcList"]["NewBarNameInput"]:SetPoint("TOPLEFT", 10, -100)
TT_UI_Tabs["ProcList"]["NewBarNameInput"].texture:SetTexture(0,0,0,1);
TT_UI_Tabs["ProcList"]["NewBarNameInput"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["ProcList"]["NewBarNameInput"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["ProcList"]["NewBarNameInput"]:SetHeight(15) -- for your Texture




TT_UI_Tabs["ProcList"]["SaveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["ProcList"]["SaveButton"]:SetFrameStrata("background")
TT_UI_Tabs["ProcList"]["SaveButton"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["ProcList"]["SaveButton"]:SetHeight(15) -- for your Texture
TT_UI_Tabs["ProcList"]["SaveButton"].texture = TT_UI_Tabs["ProcList"]["SaveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["ProcList"]["SaveButton"].texture:SetTexture(0,1,0,1);
TT_UI_Tabs["ProcList"]["SaveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["ProcList"]["SaveButton"]:SetPoint("TOPLEFT", 10,-60)
TT_UI_Tabs["ProcList"]["SaveButton"]:SetText("Create / Reset");
TT_UI_Tabs["ProcList"]["SaveButton"].texture:SetAllPoints(TT_UI_Tabs["ProcList"]["SaveButton"])
TT_UI_Tabs["ProcList"]["SaveButton"]:SetScript("OnMouseDown", function()
	local name = TT_UI_Tabs["ProcList"]["NewBarNameInput"]:GetText()
	if name ~= nil and TT_Settings ~= nil and TT_Settings["Tracking"] ~= nil
	then
		local newList = TT_GetTracking(name);
		TT_Settings["Tracking"][name] = newList;
		TT_UI_ProcBars_ReloadDropDown();
		--TT_printDebug(TT_Settings["Tracking"][name]);
	end;
end)



TT_UI_Tabs["ProcList"]["RemoveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetFrameStrata("background")
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetHeight(15) -- for your Texture
TT_UI_Tabs["ProcList"]["RemoveButton"].texture = TT_UI_Tabs["ProcList"]["RemoveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["ProcList"]["RemoveButton"].texture:SetTexture(1,0,0,1);
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetPoint("TOPLEFT", 10,-80)
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetText("Remove (No warrning)");
TT_UI_Tabs["ProcList"]["RemoveButton"].texture:SetAllPoints(TT_UI_Tabs["ProcList"]["RemoveButton"])
TT_UI_Tabs["ProcList"]["RemoveButton"]:SetScript("OnMouseDown", function()
	local name = TT_UI_Tabs["ProcList"]["NewBarNameInput"]:GetText()
	if name ~= nil and TT_Settings ~= nil and TT_Settings["Tracking"] ~= nil
	then
		TT_Settings["Tracking"][name] = nil;
		TT_UI_ProcBars_ReloadDropDown();
	end;
end)


-- Need to reload the UI when we have added a new page.
--TT_UpdateUI();