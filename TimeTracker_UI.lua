SLASH_TT1 = "/TT"
SLASH_TTS1 = "/TTS"

SlashCmdList["TT"] = function(args)
	if args == "stats"
	then
		TT_UI_StatsWindow["background"]:Show();
	else
		DisplayInterface(true)
	end
end


SlashCmdList["TTS"] = function(args)
	TT_UI_StatsWindow["background"]:Show();
end

function DisplayInterface(state)
	if state == nil or state == true
	then
		TT_UI_MainFrame:Show()
	else
		TT_UI_MainFrame:Hide()
	end;
	
	for name,_ in pairs(TT_TimerFrameArray)
	do
		if state == nil or state == true
		then
			TT_TimerFrameArray[name]["frame"]["background"]:SetMovable(true);
			TT_TimerFrameArray[name]["frame"]["background"]:EnableMouse(true);
		else
			TT_TimerFrameArray[name]["frame"]["background"]:SetMovable(false);
			TT_TimerFrameArray[name]["frame"]["background"]:EnableMouse(false);
		end;
	end
end


TT_UI_MainFrame = CreateFrame("Frame", "TT_MAIN_FRAME",UIParent);
TT_UI_MainFrame.texture = TT_UI_MainFrame:CreateTexture(nil,"background");
TT_UI_MainFrame.texture:SetTexture(0.2,0.2,0.2,0.8);
TT_UI_MainFrame:SetFrameStrata("background")
TT_UI_MainFrame:SetWidth(600)  -- Set These to whatever height/width is needed 
TT_UI_MainFrame:SetHeight(630) -- for your Texture
TT_UI_MainFrame:SetPoint("CENTER",0,0)
TT_UI_MainFrame.texture:SetAllPoints(TT_UI_MainFrame)

--Frame drag
TT_UI_MainFrame:SetMovable(true);
TT_UI_MainFrame:EnableMouse(true);
TT_UI_MainFrame:SetScript("OnMouseDown", function()
	if arg1 == "LeftButton" and not this.isMoving
	then
		this:StartMoving();
		this.isMoving = true;
	end
end)

TT_UI_MainFrame:SetScript("OnMouseUp", function()
	if arg1 == "LeftButton" and this.isMoving then
		this:StopMovingOrSizing();
		this.isMoving = false;
	end
end)


TT_UI_MainFrame:SetScript("OnHide", function()
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;
	end
end)

-- Font stuff



TT_UI_MainFrame.TopText = TT_UI_MainFrame:CreateFontString();
TT_UI_MainFrame.TopText:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE", "");
TT_UI_MainFrame.TopText:SetPoint("TOP",0,-33)
TT_UI_MainFrame.TopText:SetText("TimeTracker Settings!");



-- Tabs
TT_UI_Tabs = {}
TT_UI_Tabs["Settings"] = {}

function TT_UI_OnLoad()
	for k,v in pairs(TT_UI_Tabs)
	do
		local func = TT_UI_Tabs[k]["OnLoad"]
		if func
		then
			func();
		end;
	end;
end;

function TT_UI_OnShow()
	for k,v in pairs(TT_UI_Tabs)
	do
		local func = TT_UI_Tabs[k]["OnShow"]
		if func
		then
			func();
		end;
	end;
end;

function TT_UI_OnHide()
	for k,v in pairs(TT_UI_Tabs)
	do
		local func = TT_UI_Tabs[k]["OnHide"]
		if func
		then
			func();
		end;
	end;
end;

TT_CurrentTab = "";

function TT_UpdateUI()
	--TT_printDebug(TT_UI_Tabs)
	--PrintText("TEST TEXT", 0, 0, "CENTER")
	
	
	local i = 0;
	local clickName = "";
	for k,v in pairs(TT_UI_Tabs)
	do
		if TT_UI_Tabs[k]["Button"] == nil
		then
			TT_UI_Tabs[k]["Button"] = CreateFrame("Button", nil, TT_UI_MainFrame);
			TT_UI_Tabs[k]["Button"]:SetScript("OnClick", function(self)
				TT_CurrentTab = this:GetText();
				for k,v in pairs(TT_UI_Tabs)
				do
					--TT_printDebug(k);
					for k2,v2 in pairs(TT_UI_Tabs[k])
					do
						--TT_printDebug(">"..k2)
						if k2 ~= "Button" and k2 ~= "OnShow" and  k2 ~= "OnHide" and  k2 ~= "OnLoad"
						then
							--TT_printDebug(k .. " -> " ..k2);
							if k == this:GetText()
							then
								v2:Show()
							else
								v2:Hide()
							end;
						end;
					end;
					if k == this:GetText()
					then
						TT_UI_Tabs[k]["Button"].texture:SetTexture(0,0,0,1);
					else
						TT_UI_Tabs[k]["Button"].texture:SetTexture(0.2,0.2,0.2,1);
					end
				end;
			end)
			TT_UI_Tabs[k]["Button"]:SetFrameStrata("background")
			TT_UI_Tabs[k]["Button"]:SetWidth(100)  -- Set These to whatever height/width is needed 
			TT_UI_Tabs[k]["Button"]:SetHeight(30) -- for your Texture
			TT_UI_Tabs[k]["Button"]:SetPoint("TOPLEFT",100*i,0)
			TT_UI_Tabs[k]["Button"]:SetText(k);
			TT_UI_Tabs[k]["Button"].texture = TT_UI_Tabs[k]["Button"]:CreateTexture(nil,"background");
			if i == 0
			then
				clickName = k;
			end
			TT_UI_Tabs[k]["Button"]:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE", "");
			TT_UI_Tabs[k]["Button"].texture:SetAllPoints(TT_UI_Tabs[k]["Button"])
			TT_UI_Tabs[k]["Button"]:Show()
		end;
		i = i + 1;
	end;
	TT_UI_Tabs[clickName]["Button"]:Click()
	TT_CurrentTab = clickName;
end;

function PrintText(text, x, y, anchor, fontSize)
	if anchor == nil
	then
		anchor = "TOPLEFT";
	end;
	if fontSize == nil
	then
		fontSize = 12;
	end;
	temp = TT_UI_MainFrame:CreateFontString();
	temp:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE", "");
	temp:SetPoint(anchor, x, y)
	temp:SetText(text);
	return temp;
end;


function MakeInputBox()
	local tmp = CreateFrame("Editbox", nil, TT_UI_MainFrame);
	tmp:SetFrameStrata("background")
	tmp:SetWidth(100)  -- Set These to whatever height/width is needed 
	tmp:SetHeight(10) -- for your Texture
	tmp.texture = tmp:CreateTexture(nil,"background");
	tmp.texture:SetTexture(0,0,1,1);
	tmp:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE", "");
	tmp:SetPoint("TOPLEFT",0,0)
	tmp:SetAutoFocus(false);
	tmp.texture:SetAllPoints(tmp)
	return tmp;
end;





local line = 0;



--- Fix this later.
function TT_printArrayUI(arr, d)
	if d == nil
	then
		line = 0;
		d = 1;
	end;
	for key,value in pairs(arr)
	do
		line = line + 1;
		if type(arr[key]) == "table"
		then
			PrintText("[\"" .. key .. "\"]", d*10, line*-20);
			TT_printArrayUI(value, d+1);
		else
			if type(arr[key]) == "string"
			then
				PrintText("[\"" .. key .. "\"] = \"" .. arr[key] .."\"", d*10, line*-20);
			elseif type(arr[key]) == "number" 
			then
				PrintText("[\"" .. key .. "\"] = " .. arr[key], d*10, line*-20);
			elseif type(arr[key]) == "boolean" 
			then
				if arr[key]
				then
					PrintText("[\"" .. key .. "\"] = true", d*10, line*-20);
				else
					PrintText("[\"" .. key .. "\"] = false", d*10, line*-20);
				end;
			else
				PrintText("[\"" .. key .. "\"] = " .. type(arr[key]), d*10, line*-20);
			end;
		end;
	end
end;



-- Buttons

-- Close button

CloseButton = CreateFrame("Button", nil, TT_UI_MainFrame);
CloseButton:SetFrameStrata("background")
CloseButton:SetWidth(30)  -- Set These to whatever height/width is needed 
CloseButton:SetHeight(30) -- for your Texture
CloseButton:SetPoint("TOPRIGHT",0,0)
CloseButton:SetText("TEST BUTTON");
CloseButton.texture = CloseButton:CreateTexture(nil,"background");
CloseButton.texture:SetTexture(0,0,0,0.3);
CloseButton:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE", "");
CloseButton:SetPoint("TOP",0,0)
CloseButton:SetText("X");
CloseButton.texture:SetAllPoints(CloseButton)

CloseButton:SetScript("OnClick",
function(self)
	TT_printDebug("Closing this window.")
	DisplayInterface(false);
end)








-- Text boxes
TextBox = CreateFrame("Editbox", nil, TT_UI_MainFrame);
TextBox:SetFrameStrata("background")
TextBox:SetWidth(300)  -- Set These to whatever height/width is needed 
TextBox:SetHeight(30) -- for your Texture
TextBox.texture = TextBox:CreateTexture(nil,"background");
TextBox.texture:SetTexture(0,0,1,1);
TextBox:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE", "");
TextBox:SetPoint("LEFT",0,0)
TextBox:SetText("NINJA");
TextBox:SetAutoFocus(false);
TextBox.texture:SetAllPoints(TextBox)
TextBox:Hide()


-- Slider

MySlider = CreateFrame("Slider", "MySlider", TT_UI_MainFrame)
MySlider.tooltipText = 'This is the Tooltip hint' --Creates a tooltip on mouseover.
MySlider:SetWidth(100)
MySlider:SetHeight(100)
MySlider:SetPoint("BOTTOM",0,0)
MySlider:SetOrientation('VERTICAL')



DisplayInterface(true);