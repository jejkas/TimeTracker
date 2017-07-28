TT_UI_Tabs["Cooldown"] = {}
-- Funcs

TT_UI_Tabs["Cooldown"]["OnLoad"] = function (name) TT_UI_Cooldown_ReloadDropDown() end;
TT_UI_Tabs["Cooldown"]["OnShow"] = function (name) end;
TT_UI_Tabs["Cooldown"]["OnHide"] = function (name) end;

-- Select bar

TT_UI_Tabs["Cooldown"]["SelectBar"] = CreateFrame("Button", "TT_UI_Cooldown_SelectBar_Frame", TT_UI_MainFrame, "UIDropDownMenuTemplate")
TT_UI_Tabs["Cooldown"]["SelectBar"]:ClearAllPoints()
TT_UI_Tabs["Cooldown"]["SelectBar"]:SetPoint("TOP", 100, -70)
TT_UI_Tabs["Cooldown"]["SelectBar"]:SetText("TimeTracker Settings!");


function TT_UI_Cooldown_ReloadDropDown()
	UIDropDownMenu_Initialize(TT_UI_Tabs["Cooldown"]["SelectBar"],
	function()
		if TT_Settings ~= nil and TT_Settings["Cooldown"] ~= nil
		then
			for k,v in pairs(TT_Settings["Cooldown"])
			do
				if v ~= nil
				then
					local info = {};
					info.text = v["Name"]
					info.func = function()
						UIDropDownMenu_SetSelectedID(TT_UI_Tabs["Cooldown"]["SelectBar"], this:GetID())
						TT_UI_Cooldown_PrintBarSettings(this.value);
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


function TT_UI_Cooldown_PrintBarSettings(name)
	if name ~= nil
	then
		TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue = name;
	
		TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:SetText(name);
		
		
		local cooldownSettings = TT_GetCooldownSettings(name);
		TT_printDebug(cooldownSettings)
		local padding = 10;
		local xWidth = 150;
		local x = 0;
		local line = -110;
		
		for k,v in pairs(cooldownSettings)
		do
			if k ~= "Name"
			then
				line = line - 25;
				if TT_UI_Tabs["Cooldown"][k.."_title"] == nil
				then
					TT_UI_Tabs["Cooldown"][k.."_title"] = PrintText(k, xWidth*x + padding, line, "TOPLEFT");
				end;
				TT_UI_Tabs["Cooldown"][k.."_title"]:SetText(k);
				line = line - 15;
				
				if type(cooldownSettings[k]) == "number" or type(cooldownSettings[k]) == "string"
				then
					-- If this is a string, then we use a input box.
					if TT_UI_Tabs["Cooldown"][k.."_".."INPUT"] == nil
					then
						TT_UI_Tabs["Cooldown"][k.."_".."INPUT"] = MakeInputBox();
					end;
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"]:SetText(v);
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"].targetCategory = k;
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"].texture:SetTexture(0,0,0,1);
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"]:SetWidth(120)  -- Set These to whatever height/width is needed 
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"]:SetHeight(15) -- for your Texture
					TT_UI_Tabs["Cooldown"][k.."_".."INPUT"]:SetScript("OnChar", function(self)
						if type(TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue][this.targetCategory]) == "number"
						then
							local tFinal = ""
							string.gsub(this:GetText(), "%d+", function(i) tFinal = tFinal .. i end)
							TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue][this.targetCategory] = tonumber(tFinal);
							--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
						else
							TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue][this.targetCategory] = this:GetText();
							--TT_printDebug(tmp[1] .. " -> " .. v2:GetText());
						end
					end)
				
				elseif type(cooldownSettings[k]) == "boolean"
				then
					-- IF a bool use a button.
					if TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"] == nil
					then
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"] = CreateFrame("Button", nil, TT_UI_MainFrame);
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"].texture = TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:CreateTexture(nil,"background");
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"].targetCategory = k;
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"].texture:SetAllPoints(TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"])
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetPoint("TOPLEFT", xWidth*x + padding, line)
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetFrameStrata("background")
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetWidth(120)  -- Set These to whatever height/width is needed 
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetHeight(15) -- for your Texture
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetScript("OnClick", function(self)
							--TT_printDebug(this.targetCategory .. " -> " .. this.targetSetting);
							if string.lower(this:GetText()) == "true"
							then
								this:SetText("false");
								this.texture:SetTexture(1,0,0,1);
								TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue][this.targetCategory] = false;
								--TT_printDebug(TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue])
								--TT_printDebug("false text")
							else
								this:SetText("true");
								this.texture:SetTexture(0,1,0,1);
								TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue][this.targetCategory] = true;
								--TT_printDebug(TT_Settings["Cooldown"][TT_UI_Tabs["Cooldown"]["SelectBar"].selectedValue])
								--TT_printDebug("true text")
							end;
						end)
					end;
					if v
					then
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetText("true");
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"].texture:SetTexture(0,1,0,1);
					else
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"]:SetText("false");
						TT_UI_Tabs["Cooldown"][k.."_".."BOOLEAN"].texture:SetTexture(1,0,0,1);
					end;
				end;
			end;
		end;
	end;
end;




UIDropDownMenu_SetWidth(100, TT_UI_Tabs["Cooldown"]["SelectBar"]);
UIDropDownMenu_SetButtonWidth(124, TT_UI_Tabs["Cooldown"]["SelectBar"])
UIDropDownMenu_JustifyText("LEFT", TT_UI_Tabs["Cooldown"]["SelectBar"])




--PrintText(text, x, y, anchor)



-- Add new bar

-- If this is a string, then we use a input box.
TT_UI_Tabs["Cooldown"]["NewBarNameInput"] = MakeInputBox();
TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:SetText("Proc Name Here");
TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:SetPoint("TOPLEFT", 10, -100)
TT_UI_Tabs["Cooldown"]["NewBarNameInput"].texture:SetTexture(0,0,0,1);
TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:SetHeight(15) -- for your Texture




TT_UI_Tabs["Cooldown"]["SaveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetFrameStrata("background")
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetHeight(15) -- for your Texture
TT_UI_Tabs["Cooldown"]["SaveButton"].texture = TT_UI_Tabs["Cooldown"]["SaveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["Cooldown"]["SaveButton"].texture:SetTexture(0,1,0,1);
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetPoint("TOPLEFT", 10,-60)
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetText("Create / Reset");
TT_UI_Tabs["Cooldown"]["SaveButton"].texture:SetAllPoints(TT_UI_Tabs["Cooldown"]["SaveButton"])
TT_UI_Tabs["Cooldown"]["SaveButton"]:SetScript("OnMouseDown", function()
	local name = TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:GetText()
	if name ~= nil and TT_Settings ~= nil and TT_Settings["Cooldown"] ~= nil
	then
		local newList = TT_GetCooldownSettings(name);
		TT_Settings["Cooldown"][name] = newList;
		TT_UI_Cooldown_ReloadDropDown();
		--TT_printDebug(TT_Settings["Cooldown"][name]);
	end;
end)



TT_UI_Tabs["Cooldown"]["RemoveButton"] = CreateFrame("Button", nil, TT_UI_MainFrame);
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetFrameStrata("background")
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetWidth(240)  -- Set These to whatever height/width is needed 
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetHeight(15) -- for your Texture
TT_UI_Tabs["Cooldown"]["RemoveButton"].texture = TT_UI_Tabs["Cooldown"]["RemoveButton"]:CreateTexture(nil,"background");
TT_UI_Tabs["Cooldown"]["RemoveButton"].texture:SetTexture(1,0,0,1);
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetPoint("TOPLEFT", 10,-80)
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetText("Remove (No warrning)");
TT_UI_Tabs["Cooldown"]["RemoveButton"].texture:SetAllPoints(TT_UI_Tabs["Cooldown"]["RemoveButton"])
TT_UI_Tabs["Cooldown"]["RemoveButton"]:SetScript("OnMouseDown", function()
	local name = TT_UI_Tabs["Cooldown"]["NewBarNameInput"]:GetText()
	if name ~= nil and TT_Settings ~= nil and TT_Settings["Cooldown"] ~= nil
	then
		TT_Settings["Cooldown"][name] = nil;
		TT_UI_Cooldown_ReloadDropDown();
	end;
end)


-- Need to reload the UI when we have added a new page.
--TT_UpdateUI();