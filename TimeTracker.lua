function TT_GetbarSettings(name)
	--TT_printDebug("Got name: "..name);
	local barSettings =
	{
		["background"] = 
		{
			["width"] = 300,
			["height"] = 10,
			["x"] = 0,
			["y"] = 0,
			["anchor"] = "center",
			["color"] = {1,1,1,0.1},
			["active"] = false
		},
		["bar"] = 
		{
			["x"] = 0,
			["y"] = 0,
			["anchor"] = "center",
			["color"] = {1,1,1,1},
			["grow"] = true,
			--["blink"] = false, -- Make the bar blink (pulse) last 10 seconds.
			["timeleft"] = true,
			["vertical"] = true
		},
		["text"] = 
		{
			["x"] = 0,
			["y"] = 0,
			["anchor"] = "center",
			["font"] = "Fonts\\FRIZQT__.TTF",
			["size"] = 20,
			["text"] = name
		},
		["icon"] = 
		{
			["x"] = 0,
			["y"] = 0,
			["width"] = 64,
			["height"] = 64,
			["anchor"] = "center",
			["texture"] = "Interface\\Tooltips\\UI-Tooltip-Background",
			["active"] = false;
		}
	}
	
	if TT_Settings["bars"][name] ~= nil
	then
		for framePart, d in pairs(TT_Settings["bars"][name])
		do
			if barSettings[framePart] ~= nil
			then
				for setting, value in pairs(TT_Settings["bars"][name][framePart])
				do
					if barSettings[framePart][setting] ~= nil
					then
						if type(barSettings[framePart][setting]) == "number"
						then
							barSettings[framePart][setting] = tonumber(value);
						else
							barSettings[framePart][setting] = value;
						end;
					end;
				end;
			end;
		end;
	end;
	return barSettings;
end;

TT_OneTick = true;

function TT_GetTracking(name)
	--TT_printDebug("Got name: "..name);
	local barSettings =
	{
		["Name"] = name,
		["Duration"] = 0; -- 0 is no overwrite of duration.
		["Make bar"] = true;
		["Track stats"] = true;
		["UseIcon"] = false; -- 0 is no overwrite of duration.
	}
	
	
	if TT_Settings["Tracking"][name] ~= nil
	then
		for framePart,d in pairs(TT_Settings["Tracking"][name])
		do
			if barSettings[framePart] ~= nil
			then
				barSettings[framePart] = TT_Settings["Tracking"][name][framePart];
			end;
		end;
	end;
	return barSettings;
end;


function TT_GetCooldownSettings(name)
	--TT_printDebug("Got name: "..name);
	local barSettings =
	{
		["Name"] = name,
		["Duration"] = 0; -- 0 is no overwrite of duration.
		["UseIcon"] = true; -- 0 is no overwrite of duration.
	}
	
	
	if TT_Settings["Cooldown"][name] ~= nil
	then
		for framePart,d in pairs(TT_Settings["Cooldown"][name])
		do
			if barSettings[framePart] ~= nil
			then
				barSettings[framePart] = TT_Settings["Cooldown"][name][framePart];
			end;
		end;
	end;
	return barSettings;
end;


TT_TimerFrameArray = {}
TT_BarNumber = 0;
-- /script TT_MakeCountdown("test", 10);
function TT_MakeCountdown(name, duration)
	if name == nil or duration == nil
	then
		return;
	end;
	
	local barSettings = TT_GetbarSettings(name);
	
	--TT_printDebug(barSettings["background"]["active"]);
	
	if barSettings["background"]["active"] == false
	then
		return;
	end;
	
	--TT_printDebug("-------------------"); TT_printDebug(barSettings);
	
	
	if TT_TimerFrameArray[name] == nil
	then
		--TT_printDebug("New frame, lets create it.");
		TT_BarNumber = TT_BarNumber + 1;
		TT_TimerFrameArray[name] = {};
		TT_TimerFrameArray[name]["Name"] = name;
		TT_TimerFrameArray[name]["frame"] = {};
		TT_TimerFrameArray[name]["frame"]["background"] = CreateFrame("Frame", "TT_FRAME_" .. TT_BarNumber .. "_background",UIParent);
		TT_TimerFrameArray[name]["frame"]["background"].name = name;
		if TT_UI_MainFrame:IsShown()
		then
			TT_TimerFrameArray[name]["frame"]["background"]:SetMovable(true);
			TT_TimerFrameArray[name]["frame"]["background"]:EnableMouse(true);
		end;
		TT_TimerFrameArray[name]["frame"]["background"]:SetScript("OnMouseDown", function()
			if arg1 == "LeftButton" and not this.isMoving and TT_UI_MainFrame:IsShown()
			then
				this:StartMoving();
				this.isMoving = true;
			end
		end)

		TT_TimerFrameArray[name]["frame"]["background"]:SetScript("OnMouseUp", function()
			if arg1 == "LeftButton" and this.isMoving
			then
				TT_printDebug("We are not moving any more, time to save!");
				point, relativeTo, relativePoint, xOfs, yOfs = TT_TimerFrameArray[this.name]["frame"]["background"]:GetPoint()
				TT_Settings["bars"][this.name]["background"]["x"] = xOfs;
				TT_Settings["bars"][this.name]["background"]["y"] = yOfs;
				TT_Settings["bars"][this.name]["background"]["anchor"] = point;
				if TT_CurrentTab == "Bars" and TT_UI_Tabs["Bars"]["SelectBar"].selectedValue == this.name and TT_UI_MainFrame:IsShown()
				then
					TT_UI_Bars_PrintBarSettings(this.name)
				end;
				this:StopMovingOrSizing();
				this.isMoving = false;
			end
		end)


		TT_TimerFrameArray[name]["frame"]["background"]:SetScript("OnHide", function()
			if ( this.isMoving ) then
				this:StopMovingOrSizing();
				this.isMoving = false;
			end
		end)
		
		
		TT_TimerFrameArray[name]["frame"]["bar"] = CreateFrame("Frame", "TT_FRAME_" .. TT_BarNumber .. "_bar",TT_TimerFrameArray[name]["frame"]["background"]);
		
		
		-- FONT
		TT_TimerFrameArray[name]["frame"]["bar"].fontstring = TT_TimerFrameArray[name]["frame"]["bar"]:CreateFontString("IT_FRAME_"..name.."_bar_FONTSTRING", "OVERLAY");
		TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetFont(barSettings["text"]["font"], barSettings["text"]["size"], "OUTLINE, MONOCHROME");
		TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetText(barSettings["text"]["text"]);

		
		
		-- background
		TT_TimerFrameArray[name]["frame"]["background"].texture = TT_TimerFrameArray[name]["frame"]["background"]:CreateTexture(nil,"background");
		TT_TimerFrameArray[name]["frame"]["background"].texture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background");
		TT_TimerFrameArray[name]["frame"]["background"].texture:SetVertexColor(barSettings["background"]["color"][1],barSettings["background"]["color"][2],barSettings["background"]["color"][3],barSettings["background"]["color"][4])
		TT_TimerFrameArray[name]["frame"]["background"]:SetFrameStrata("background")
		TT_TimerFrameArray[name]["frame"]["background"].texture:SetAllPoints(TT_TimerFrameArray[name]["frame"]["background"])
		
		-- Icon
		TT_TimerFrameArray[name]["frame"]["icon"] = CreateFrame("Frame", "TT_FRAME_" .. TT_BarNumber .. "_icon",TT_TimerFrameArray[name]["frame"]["background"]);
		TT_TimerFrameArray[name]["frame"]["icon"].texture = TT_TimerFrameArray[name]["frame"]["icon"]:CreateTexture(nil,"background");
		TT_TimerFrameArray[name]["frame"]["icon"].texture:SetTexture(barSettings["icon"]["texture"]);
--		TT_TimerFrameArray[name]["frame"]["icon"].texture:SetVertexColor(1,1,1,1)
		TT_TimerFrameArray[name]["frame"]["icon"].texture:SetAllPoints(TT_TimerFrameArray[name]["frame"]["icon"])
		TT_TimerFrameArray[name]["frame"]["icon"]:SetFrameStrata("background");
		
		
		-- bar
		TT_TimerFrameArray[name]["frame"]["bar"].texture = TT_TimerFrameArray[name]["frame"]["bar"]:CreateTexture(nil,"OVERLAY");
		TT_TimerFrameArray[name]["frame"]["bar"].texture:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background");
		TT_TimerFrameArray[name]["frame"]["bar"].texture:SetVertexColor(barSettings["bar"]["color"][1],barSettings["bar"]["color"][2],barSettings["bar"]["color"][3],barSettings["bar"]["color"][4])
		TT_TimerFrameArray[name]["frame"]["bar"].texture:SetAllPoints(TT_TimerFrameArray[name]["frame"]["bar"])
		TT_TimerFrameArray[name]["frame"]["bar"]:SetFrameStrata("background");
	end;
	
	TT_TimerFrameArray[name]["StartTime"] = GetTime();
	TT_TimerFrameArray[name]["EndTime"] = GetTime() + duration;
	
	
	TT_TimerFrameArray[name]["frame"]["background"]:SetWidth(barSettings["background"]["width"])  -- Set These to whatever height/width is needed 
	TT_TimerFrameArray[name]["frame"]["background"]:SetHeight(barSettings["background"]["height"]) -- for your Texture
	
	TT_TimerFrameArray[name]["frame"]["icon"]:SetWidth(barSettings["icon"]["width"])  -- Set These to whatever height/width is needed 
	TT_TimerFrameArray[name]["frame"]["icon"]:SetHeight(barSettings["icon"]["height"]) -- for your Texture
	
	TT_TimerFrameArray[name]["frame"]["bar"]:SetWidth(0)  -- Set These to whatever height/width is needed 
	TT_TimerFrameArray[name]["frame"]["bar"]:SetHeight(barSettings["background"]["height"]) -- for your Texture
	
	
	TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetFont(barSettings["text"]["font"], barSettings["text"]["size"], "OUTLINE, MONOCHROME");
	TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetText(barSettings["text"]["text"]);
	
	TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetPoint(barSettings["text"]["anchor"], barSettings["text"]["x"], barSettings["text"]["y"])
	
	local d = TT_TimerFrameArray[name];
	
	if barSettings["bar"]["timeleft"]
	then
		if d["EndTime"] - GetTime() < 10
		then
			tLeftStr = TT_round(d["EndTime"] - GetTime() , 1)
		else
			tLeftStr = TT_round(d["EndTime"] - GetTime() , 0)
		end;
		TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetText(barSettings["text"]["text"] .. " [BACON] " .. tLeftStr);
	else
		TT_TimerFrameArray[name]["frame"]["bar"].fontstring:SetText(barSettings["text"]["text"] .. " [BACON]");
	end;
	
	

	local point = "center"
	if TT_IsValidPoint(barSettings["background"]["anchor"])
	then
		point = barSettings["background"]["anchor"];
	end;

	
	TT_TimerFrameArray[name]["frame"]["background"]:SetPoint(point,barSettings["background"]["x"],barSettings["background"]["y"])


	local point = "center"
	if TT_IsValidPoint(barSettings["bar"]["anchor"])
	then
		point = barSettings["bar"]["anchor"];
	end;
	
	TT_TimerFrameArray[name]["frame"]["bar"]:SetPoint(point, barSettings["bar"]["x"],barSettings["bar"]["y"])
	
	local point = "center"
	if TT_IsValidPoint(barSettings["icon"]["anchor"])
	then
		TT_printDebug("anchor:" .. barSettings["icon"]["anchor"])
		point = barSettings["icon"]["anchor"];
	end;
	
	TT_TimerFrameArray[name]["frame"]["icon"]:SetPoint(point, barSettings["icon"]["x"], barSettings["icon"]["y"])
	
	if barSettings["icon"]["active"]
	then
		TT_TimerFrameArray[name]["frame"]["icon"]:Show()
	else
		TT_TimerFrameArray[name]["frame"]["icon"]:Hide()
	end;
	
	TT_TimerFrameArray[name]["frame"]["background"]:Show()
	TT_TimerFrameArray[name]["frame"]["bar"]:Show()
end;

function TT_IsValidPoint(str)
	local p = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT", "CENTER"}
	for _, point in p
	do
		if string.lower(str) == string.lower(point)
		then
			return true;
		end;
	end;
	return false;
end;

TT_LastbarUpdate = 0;
TT_LastBuffCheck = 0;

function TT_OnUpdateEvent()
	--if TT_HaveBuff("Player", "Fury of Forgewright")
	--then
	--	TT_RemoveBuffIcon("Spell_Fire_Incinerate"); -- Lets remove it every damn frame. Remove this later.
	--end
	
	if true
	then
		--return
	end
	
	
	if TT_LastBuffCheck + 0.01 <= GetTime()
	then
		TT_LastBuffCheck = GetTime();
		if TT_Settings ~= nil and TT_Settings["Tracking"] ~= nil
		then
			--TT_printDebug("Checking buffs");
			for buff,data in pairs(TT_Settings["Tracking"])
			do
				local trackSettings = TT_GetTracking(buff)
				--TT_printDebug("buff: " .. buff);
				if trackSettings["Make bar"]
				then
					--TT_printDebug("Make bar");
					--TT_printDebug(buff);
					local t, isMinute = TT_GetBuffDurationLeft(buff);
					if t ~= false
					then
						if isMinute
						then
							t = t * 60;
						end;
						t = tonumber(t);
						--TT_printDebug(t);
						if TT_TimerFrameArray[buff] ~= nil
						then
							--TT_printDebug(tostring(TT_TimerFrameArray[buff]["EndTime"]) .." < ".. tostring(GetTime()+t));
						end;
						
						if TT_TimerFrameArray[buff] == nil or TT_TimerFrameArray[buff]["EndTime"] < GetTime()
						then
							if(t > 1)
							then
								TT_printDebug("Making a new bar.");
								TT_MakeCountdown(buff, t)
							end
						elseif ( t <= 60 ) and TT_TimerFrameArray[buff]["EndTime"] + 1 < GetTime()+t
						then
							TT_printDebug("Buff less then 60 sec, update time.");
							TT_TimerFrameArray[buff]["EndTime"] = GetTime()+t;
							-- Adding start time here since if a buff was refreshed it would not reset the start time.
							TT_TimerFrameArray[buff]["StartTime"] = GetTime();
						elseif ( TT_TimerFrameArray[buff]["EndTime"] < GetTime()+t-60 and t > 60 )
						then
							TT_printDebug("Setting the time for our buff.");
							TT_TimerFrameArray[buff]["StartTime"] = GetTime();
							TT_TimerFrameArray[buff]["EndTime"] = GetTime()+t;
						end;
					end;
				end;
				
				if TT_TimerFrameArray[buff] ~= nil
				then
					--TT_printDebug("Current bar");
					local t, isMinute = TT_GetBuffDurationLeft(buff);
					if t
					then
						if trackSettings ~= nil and trackSettings["Make bar"] == true and TT_TimerFrameArray[buff] ~= nil
						then
							if isMinute
							then
								t = t * 60;
							end;
							if GetTime() + t >= TT_TimerFrameArray[buff]["EndTime"] + 60 -- Adding 1 second here to fix problems that can happen.
							then
								-- We reset the time of this buff.
								TT_printDebug("Updating times for: " .. buff)
								TT_TimerFrameArray[buff]["StartTime"] = GetTime();
								TT_TimerFrameArray[buff]["EndTime"] = GetTime() + t;
							end;
						end
					else
						-- We do not have this buff, but we have a bar for it. Lets remove it.
						-- We only wanna do this when not showing the settings windows.
						if not TT_UI_MainFrame:IsVisible() or (trackSettings == nil or trackSettings["Duration"] == 0)
						then
							TT_TimerFrameArray[buff]["EndTime"] = GetTime()-1;
						end;
					end;
				end;
			end;
		end;
	end;
	
	
	if TT_LastbarUpdate + 0.01 <= GetTime()
	then
		local i = 0;
		TT_LastbarUpdate = GetTime();
		local height = 0;
		for _, d in pairs(TT_TimerFrameArray)
		do
			local barSettings = TT_GetbarSettings(d["Name"]);
			local background = d["frame"]["background"];
			local bar = d["frame"]["bar"];
			local icon = d["frame"]["icon"];
			
			
			-- If we have the settings window open, do some force updates.
			if TT_UI_MainFrame:IsShown()
			then
				bar.texture:SetVertexColor(barSettings["bar"]["color"][1],barSettings["bar"]["color"][2],barSettings["bar"]["color"][3],barSettings["bar"]["color"][4])
				background.texture:SetVertexColor(barSettings["background"]["color"][1],barSettings["background"]["color"][2],barSettings["background"]["color"][3],barSettings["background"]["color"][4])
				background:SetWidth(barSettings["background"]["width"])  -- Set These to whatever height/width is needed 
				background:SetHeight(barSettings["background"]["height"]) -- for your Texture
				bar.fontstring:SetText(barSettings["text"]["text"]);
				bar.fontstring:SetFont(barSettings["text"]["font"], barSettings["text"]["size"], "OUTLINE, MONOCHROME");
				if TT_IsValidPoint(barSettings["text"]["anchor"])
				then
					--TT_printDebug(barSettings["text"]["anchor"]);
					bar.fontstring:SetPoint(barSettings["text"]["anchor"], barSettings["text"]["x"], barSettings["text"]["y"])
				end
				if TT_IsValidPoint(barSettings["icon"]["anchor"])
				then
					--TT_printDebug(barSettings["icon"]["anchor"]);
					--TT_printDebug(barSettings["text"]["anchor"]);
					icon:SetPoint(barSettings["icon"]["anchor"], barSettings["icon"]["x"], barSettings["icon"]["y"])
				end
				icon:SetWidth(barSettings["icon"]["width"])  -- Set These to whatever height/width is needed 
				icon:SetHeight(barSettings["icon"]["height"])
				icon.texture:SetTexture(barSettings["icon"]["texture"]);
				if barSettings["icon"]["active"]
				then
					icon:Show()
				else
					icon:Hide()
				end;
			end;
			
			if d["EndTime"] >= GetTime()
			then
				--TT_printDebug("We have a bar that we need to update.");
				if barSettings["background"]["active"]
				then
					background:Show()
				else
					background:Hide()
					return;
				end;
				--background:SetPoint("CENTER",0,height*i+-100);
				
				height = height + barSettings["background"]["height"];
				
				local tLeftStr = "";
				
				if barSettings["bar"]["timeleft"]
				then
					if d["EndTime"] - GetTime() < 10
					then
						tLeftStr = TT_round(d["EndTime"] - GetTime() , 1)
					else
						tLeftStr = TT_round(d["EndTime"] - GetTime() , 0)
					end;
					bar.fontstring:SetText(barSettings["text"]["text"] .. " " .. tLeftStr);
				else
					bar.fontstring:SetText(barSettings["text"]["text"]);
				end;
				
				if barSettings["bar"]["vertical"]
				then
					bar:SetHeight(background:GetHeight())
					if barSettings["bar"]["grow"]
					then
						bar:SetWidth( background:GetWidth() * (GetTime() - d["StartTime"]) / ( d["EndTime"] - d["StartTime"] ) );
					else
						bar:SetWidth( background:GetWidth() *( 1- (GetTime() - d["StartTime"]) / ( d["EndTime"] - d["StartTime"] ) ) );
					end;
				else
					bar:SetWidth(background:GetWidth());
					if barSettings["bar"]["grow"]
					then
						bar:SetHeight( background:GetHeight() * (GetTime() - d["StartTime"]) / ( d["EndTime"] - d["StartTime"] ) );
					else
						bar:SetHeight( background:GetHeight() *( 1- (GetTime() - d["StartTime"]) / ( d["EndTime"] - d["StartTime"] ) ) );
					end;
				end
			else
				background:Hide();
			end;
			
			i = i + 1;
		end;
	end;
end;


function ResetTracking()
	TT_printDebug("TRACKING RESETED");
	TT_Tracking = {};
	TT_Tracking["CombatStart"] = 0;
	TT_Tracking["CombatEnd"] = 0;
	TT_Tracking["CombatDuration"] = 0;
	TT_Tracking["Hits"] = 0;
	TT_Tracking["Crits"] = 0;
	TT_Tracking["Glancing"] = 0;
	TT_Tracking["Dodge"] = 0;
	TT_Tracking["Parry"] = 0;
	TT_Tracking["Miss"] = 0;
	TT_Tracking["RageGain"] = 0;
	TT_Tracking["Buffs"] = {}
end;

function TT_OnLoad()
	
end;

TT_NextAttack = 1;

function TT_ResetSettings()
	TT_Settings = {};
	TT_Settings["Settings"] = {};
	
	TT_Settings["Tracking"] = {} -- Used to create custom proc bars (with duration) -- ProcList.lua
	
	TT_Settings["Cooldown"] = {} -- Cooldown bars ["Spell Name"] = true
	
	TT_Settings["bars"] = {}
	TT_Settings["bars"]["TwoHandAutoAttack"] = TT_GetbarSettings("TwoHandAutoAttack")
	TT_Settings["bars"]["MainHandAutoAttack"] = TT_GetbarSettings("MainHandAutoAttack")
	TT_Settings["bars"]["OffHandAutoAttack"] = TT_GetbarSettings("OffHandAutoAttack")
end

function TT_eventHandler()
	if true
	then
		--return
	end
	
	TT_printDebug(event);
	if event == "ADDON_LOADED"
	then
		if arg1 == "TimeTracker"
		then
			ResetTracking();
			TT_UpdateUI();
			TT_UI_OnLoad();
			--TT_Settings = nil; -- To reset it every time while we make this.
			if TT_Settings == nil
			then
				TT_ResetSettings();
			end;
			DisplayInterface(false)
		end;
	end
	
	if event == "SPELL_UPDATE_COOLDOWN"
	then
		for _,d in TT_Settings["Cooldown"]
		do
			local d = TT_GetCooldownSettings(d["Name"]);
			local cd, spellID, book = TT_IsSpellOffCoolDown(d["Name"]);
			
			if type(cd) ~= "boolean"
			then
				local spellTexture = GetSpellTexture(spellID, book);
				if cd > 2 and spellTexture ~= nil and TT_Settings["bars"][d["Name"]] ~= nil
				then
					local barSettings = TT_GetbarSettings(d["Name"]);
					TT_printDebug("Checking spell for cooldown: " .. d["Name"] .. " and CD: " .. cd)
					
					if d["UseIcon"]
					then
						TT_printDebug(spellTexture);
						TT_Settings["bars"][d["Name"]]["icon"]["texture"] = spellTexture;
					end;
					--TT_printDebug(TT_Settings["Tracking"][d["Name"]]);
					
					
					
					if TT_TimerFrameArray[d["Name"]] == nil or TT_TimerFrameArray[d["Name"]]["EndTime"] < GetTime()
					then
						if d["Duration"] > 0
						then
							TT_printDebug(d["Name"] .. " We used a spell we are tracking with duration");
							TT_MakeCountdown(d["Name"], d["Duration"]);
						else
							TT_printDebug(d["Name"] .. " We used a spell we are tracking with NO duration: " .. cd);
							TT_MakeCountdown(d["Name"], cd);
						end;
					end;
				end;
			end;
		end;
	end;
	
	
	if event == "CHAT_MSG_COMBAT_SELF_MISSES"
	then
		TT_HandleAutoAttack(0, 1);
	end;
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE"
	then
		TT_printDebug("CHAT_MSG_SPELL_SELF_DAMAGE: " .. arg1);
		TT_spellhit(arg1)
	end
	if event == "CHAT_MSG_COMBAT_SELF_HITS"
	then
		--TT_printDebug("CHAT_MSG_COMBAT_SELF_HITS: " .. arg1);
		if string.find(arg1, "suffer")
		then
			return;
		end;
		local start,stop = string.find(arg1, "%d+");
		local damage = tonumber(string.sub(arg1, start, stop));
		local critMod = 1;
		
		if string.find(arg1, "crit")
		then
			critMod = 2;
		end;
		
		TT_HandleAutoAttack(damage, critMod)
	end;
	
	if event == "COMBAT_TEXT_UPDATE" 
	then
		--TT_printDebug(arg1);
		--TT_printDebug(arg2);
		if string.lower(arg1) == "rage" -- We gained rage 
		then
			if arg2 == 10
			then
				-- Blood rage?
			else
				
			end;
		end;
		if string.lower(arg1) == "aura_start" -- We gained an aura. 
		then
			if TT_Settings["Tracking"][arg2] ~= nil
			then
				local d = TT_GetCooldownSettings(arg2);
				local r, texture = TT_HaveBuff("Player", arg2)
				
				if d["UseIcon"] and r
				then
					TT_Settings["bars"][arg2]["icon"]["texture"] = texture;
				end;
				
				
				TT_printDebug("We gained: " .. arg2)
				if TT_Settings["Tracking"][arg2]["Track stats"]
				then
				
				end;
				
				if TT_Settings["Tracking"][arg2]["Make bar"]
				then
					TT_printDebug("Found a proc that we are tracking.");
					if TT_Settings["Tracking"][arg2]["Duration"] ~= 0
					then
						TT_MakeCountdown(arg2, TT_Settings["Tracking"][arg2]["Duration"])
					else
						local t, isMinute = TT_GetBuffDurationLeft(buff);
						if t ~= false
						then
							if isMinute
							then
								t = t * 60;
							end;
							t = tonumber(t);
							TT_MakeCountdown(arg2, t)
						end
					end
				end;
			end;
		end;
		if string.lower(arg1) == "aura_end" -- We lost an aura. 
		then
			if TT_Settings["Tracking"][arg2] == nil
			then
				return
			end;
			
			TT_printDebug("Removing aura: " .. arg2);
			
			if TT_TimerFrameArray[arg2] ~= nil and TT_Settings["Tracking"][arg2]["Make bar"] == true
			then
				TT_TimerFrameArray[arg2]["EndTime"] = GetTime()-0.1;
			end;
		end;
		
		
		if true
		then
			return
		end;
		TT_printDebug("------------COMBAT_TEXT_UPDATE--------------");
		TT_printDebug("arg1: "..arg1);
		if arg2 ~= nil
		then
			TT_printDebug("arg2: " .. arg2);
		end;
		if arg3 ~= nil
		then
			TT_printDebug("arg3: " .. arg3);
		end;
		if arg4 ~= nil
		then
			TT_printDebug("arg4: " .. arg4);
		end;
	end;
	
	if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"
	then
		if true
		then
			return;
		end;
		TT_printDebug("------------CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS--------------");
		TT_printDebug(arg1);
		if arg2 ~= nil
		then
			TT_printDebug(arg2);
		end;
	end;
end

-- Taken from Bearcast attack bars.
function TT_spellhit(arg1)
	a,b,spell=string.find (arg1, "Your (.+) hits")
	if not spell then 	a,b,spell=string.find (arg1, "Your (.+) crit") end
	if not spell then 	a,b,spell=string.find (arg1, "Your (.+) is") end
	if not spell then	a,b,spell=string.find (arg1, "Your (.+) miss") end
	if not spell then	a,b,spell=string.find (arg1, "Your (.+) was") end
	
	if not spell then return end;
	TT_printDebug("spellhit: " .. spell);
	
	if (spell == "Raptor Strike" or spell == "Heroic Strike" or spell == "Maul" or spell == "Cleave")
	then
		TT_HandleAutoAttack(0, 1);
	end
end

function TT_HandleAutoAttack(damage, critMod)
	local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("Player");
	-- We hit a player.
	local mainSpeed, offSpeed = UnitAttackSpeed("Player");
	
	
	if offSpeed ~= nil
	then
		if damage > 0
		then
			if damage > tonumber(lowDmg)*0.8*critMod
			then
				if offlowDmg ~= nil
				then
					TT_NextAttack = 2;
				end;
				TT_MakeCountdown("MainHandAutoAttack", mainSpeed);
			end;
			
			if damage < tonumber(lowDmg)*0.8*critMod
			then
				TT_NextAttack = 1;
				TT_MakeCountdown("OffHandAutoAttack", offSpeed);
			end;
		end;
	else
		TT_MakeCountdown("TwoHandAutoAttack", mainSpeed);
	end;
end;

-- Event stuff

TT_MainFrame = CreateFrame("FRAME", "TTMainFrame");
TT_MainFrame:SetScript("OnUpdate", TT_OnUpdateEvent);
TT_MainFrame:SetScript("OnEvent", TT_eventHandler);
TT_MainFrame:RegisterEvent("ENTER_WORLD");
TT_MainFrame:RegisterEvent("ADDON_LOADED");
TT_MainFrame:RegisterEvent("COMBAT_TEXT_UPDATE");
TT_MainFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
TT_MainFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
TT_MainFrame:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
TT_MainFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
TT_MainFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
TT_MainFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN");

TT_MainFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS"); -- Gain buffs (Like crusader, felstriker etc)

-- Generic functions

function TT_HaveBuff(targetUnit, str)
	for i=1,40
	do
		local buffName = TT_GetBuffName(targetUnit,i);
		
		if(buffName == nil or str == nil)
		then
			return false;
		end;
		
		--TT_printDebug(buffTexture .. " == ".. str);
		if str == buffName
		then
			local texture = UnitBuff(targetUnit, i);
			return true, texture;
		end;
	end;
end;

-- /script TT_PrintAllBuffs("Player")
function TT_PrintAllBuffs(targetUnit)
	for i=0,40
	do
		local buffName = TT_GetBuffName("Player",i);
		local texture = UnitBuff(targetUnit, i);
		
		if(buffName ~= nil)
		then
			TT_printDebug(i .. " -> " .. " name: " .. buffName)
		end;
		
		if(texture ~= nil)
		then
			TT_printDebug(i .. " -> " .. " texture: " .. texture)
		end;
	end;
end;

function TT_GetBuffName(unit, nr)
	TTToolTip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
	--TTToolTip:ClearLines();
	--TTToolTip:SetPlayerBuff(i);
	TTToolTip:SetUnitBuff(unit,nr);
	local debuff_name = TTToolTipTextLeft1:GetText();
	return debuff_name;
end



function TT_GetSpellDuration(str)
	local rrank = -1;
	local id;
	for i = 1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
	   
		if not name then
			break;
		end
	   
		for s = offset + 1, offset + numSpells
		do
			local	spell, rank = GetSpellName(s, BOOKTYPE_SPELL);
			
			rank = string.gsub(rank, "Rank ", "");
			
			
			
			if(string.lower(spell) == string.lower(str))
			then
				if type(tonumber(rank)) == "number" and tonumber(rank) > rrank
				then
					--TT_printDebug("Spell: " .. spell .. " rank: " .. tonumber(rank));
					id = s;
					rrank = tonumber(rank);
				end
			end;
		  
			--DEFAULT_CHAT_FRAME:AddMessage(name..": "..spell);
		end
	end
	--TT_printDebug("id: " .. id .. " rrank: " .. rrank);
	TTToolTip:ClearLines();
	TTToolTip:SetSpell(id, BOOKTYPE_SPELL);
	--TT_printDebug(TTToolTipTextLeft4:GetText());
	local start,stop = string.find(TTToolTipTextLeft4:GetText(), "%d+ sec");
	--TT_printDebug(string.sub(TTToolTipTextLeft4:GetText(), start, stop-4)); -- Remove 4 " sec"
end;


-- Debug stuff


function TT_printDebug(str)
	if true
	then
		--return;
	end;
	
	local c = ChatFrame5
	
	if str == nil
	then
		c:AddMessage('DEBUG: NIL');
	elseif type(str) == "boolean"
	then
		if str == true
		then
			c:AddMessage('DEBUG: true');
		else
			c:AddMessage('DEBUG: false');
		end;
	elseif type(str) == "table"
	then
		c:AddMessage('DEBUG: array');
		TT_printArray(str);
	else
		c:AddMessage('DEBUG: '..str);
	end;
end;


function TT_printArray(arr, n)
	if n == nil
	then
		 n = "arr";
	end
	for key,value in pairs(arr)
	do
		if type(arr[key]) == "table"
		then
			TT_printArray(arr[key], n .. "[\"" .. key .. "\"]");
		else
			if type(arr[key]) == "string"
			then
				TT_printDebug(n .. "[\"" .. key .. "\"] = \"" .. arr[key] .."\"");
			elseif type(arr[key]) == "number" 
			then
				TT_printDebug(n .. "[\"" .. key .. "\"] = " .. arr[key]);
			elseif type(arr[key]) == "boolean" 
			then
				if arr[key]
				then
					TT_printDebug(n .. "[\"" .. key .. "\"] = true");
				else
					TT_printDebug(n .. "[\"" .. key .. "\"] = false");
				end;
			else
				TT_printDebug(n .. "[\"" .. key .. "\"] = " .. type(arr[key]));
				
			end;
		end;
	end
end;



function TT_strsplit(sep,str)
	local arr = {}
	local tmp = "";
	
	--TT_printDebug(string.len(str));
	local chr;
	for i = 1, string.len(str)
	do
		chr = string.sub(str, i, i);
		if chr == sep
		then
			table.insert(arr,tmp);
			tmp = "";
		else
			tmp = tmp..chr;
		end;
	end
	table.insert(arr,tmp);
	
	return arr
end

function TT_RemoveBuffIcon(str)
	for i=0,40
	do
		local buffTexture = GetPlayerBuffTexture(i);
		
		if buffTexture
		then
			buffTexture = string.gsub(buffTexture,"%\\","");
		end;
		
		
		if(buffTexture == nil or str == nil)
		then
			return false;
		end;
		
		--TT_printDebug(buffTexture .. " == ".."InterfaceIcons".. str);
		if string.find(buffTexture,str)
		then
			--TT_printDebug("Found buff, remove it: " .. i);
			CancelPlayerBuff(GetPlayerBuff(i))
		end;
	end;
end;

function TT_GetBuffDurationLeft(str)
	if str == nil
	then
		return;
	end;
	for i=0,40
	do
		TTToolTip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
		TTToolTip:ClearLines();
		TTToolTip:SetPlayerBuff(i);
		
		
		if TTToolTipTextLeft1:GetText() == nil
		then
			return false;
		end
		
		if string.lower(TTToolTipTextLeft1:GetText()) == string.lower(str)
		then
			local start,stop = string.find(TTToolTipTextLeft3:GetText(), "%d+");
			local isMinute = false;
			if string.find(TTToolTipTextLeft3:GetText(), "minutes")
			then
				isMinute = true;
			end;
			local r = string.sub(TTToolTipTextLeft3:GetText(), start, stop)
			TTToolTip:Hide();
			return r, isMinute;
		end;
	end;
end;


function TT_GetBuffDurationLeft2(str)
	if str == nil
	then
		return 0;
	end;
	for i=0,40
	do
		TTToolTip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
		TTToolTip:ClearLines();
		TTToolTip:SetPlayerBuff(i);
		
		
		if TTToolTipTextLeft1:GetText() == nil
		then
			return 0;
		end
		
		if string.lower(TTToolTipTextLeft1:GetText()) == string.lower(str)
		then
			local start,stop = string.find(TTToolTipTextLeft3:GetText(), "%d+");
			local isMinute = false;
			if string.find(TTToolTipTextLeft3:GetText(), "minutes")
			then
				isMinute = true;
			end;
			local r = string.sub(TTToolTipTextLeft3:GetText(), start, stop)
			TTToolTip:Hide();
			return r, isMinute;
		end;
	end;
end;


function TT_IsSpellOffCoolDown(str)
	local spellID = TT_GetSpellIDFromName(str);
	if spellID == false
	then
		return false;
	end;
	local start, duration, enabled = GetSpellCooldown(spellID, BOOKTYPE_SPELL);
	
	if ( start > 0)
	then
		return (duration + start) - GetTime(), spellID, BOOKTYPE_SPELL;
	else
		return true;
	end;
end;

function TT_GetSpellIDFromName(str)
	local rS = nil;
	local r = -1;
	for i = 1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
	   
		if not name then
			break;
		end
	   
		for s = offset + 1, offset + numSpells
		do
			local	spell, rank = GetSpellName(s, BOOKTYPE_SPELL);
			rank = string.gsub(rank, "Rank ", ""); -- Remove the word "rank";
			rank = tonumber(rank);
		  
			if(string.lower(spell) == string.lower(str))
			then
				if rank == nil or rank > r
				then
					rS = s;
					r = rank;
				end;
			end;
		
			if rank then
				spell = spell.." "..rank;
			end
		  
			--DEFAULT_CHAT_FRAME:AddMessage(name..": "..spell);
		end
	end
	if rS ~= nil
	then
		return rS;
	end;
	return false;
end;

function TT_PrintBuffTexture()
	for i=0,40
	do
		local buffTexture = GetPlayerBuffTexture(i);
		
		
		
		if buffTexture
		then
			buffTexture = string.gsub(buffTexture,"%\\","");
			--TT_printDebug(buffTexture);
		end;
	end;
end;

function TT_round(val, decimal)
	val = tonumber(val);
	if (decimal)
	then
		return math.floor( (val * 10^decimal) + 0.5) / (10^decimal);
	else
		return math.floor(val+0.5);
	end;
end;
