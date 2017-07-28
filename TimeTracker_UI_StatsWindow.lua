TT_UI_StatsWindow = {}

TT_UI_Stats_Height = 140;

TT_UI_StatsWindow["background"] = CreateFrame("Frame", "TT_UI_Stats_Background",UIParent);
TT_UI_StatsWindow["background"].texture = TT_UI_StatsWindow["background"]:CreateTexture(nil,"background");
TT_UI_StatsWindow["background"].texture:SetTexture(0.2,0.2,0.2,0.8);
TT_UI_StatsWindow["background"]:SetFrameStrata("background")
TT_UI_StatsWindow["background"]:SetWidth(200)  -- Set These to whatever height/width is needed 
TT_UI_StatsWindow["background"]:SetHeight(TT_UI_Stats_Height) -- for your Texture
TT_UI_StatsWindow["background"]:SetPoint("CENTER",0,0)
TT_UI_StatsWindow["background"].texture:SetAllPoints(TT_UI_StatsWindow["background"])

--Frame drag
TT_UI_StatsWindow["background"]:SetMovable(true);
TT_UI_StatsWindow["background"]:EnableMouse(true);
TT_UI_StatsWindow["background"]:SetScript("OnMouseDown", function()
	if arg1 == "LeftButton" and not this.isMoving
	then
		this:StartMoving();
		this.isMoving = true;
	end
end)

TT_UI_StatsWindow["background"]:SetScript("OnMouseUp", function()
	if arg1 == "LeftButton" and this.isMoving then
		this:StopMovingOrSizing();
		this.isMoving = false;
	end
end)


TT_UI_StatsWindow["background"]:SetScript("OnHide", function()
	if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;
	end
end)

TT_UI_STATS_FirstScan = true;

function TT_UI_Stat_Print()
end;


TT_UI_StatsWindow["closeButton"] = CreateFrame("Button", nil, TT_UI_StatsWindow["background"]);
TT_UI_StatsWindow["closeButton"]:SetFrameStrata("background")
TT_UI_StatsWindow["closeButton"]:SetWidth(15)  -- Set These to whatever height/width is needed 
TT_UI_StatsWindow["closeButton"]:SetHeight(15) -- for your Texture
TT_UI_StatsWindow["closeButton"]:SetPoint("TOPRIGHT",0,0)
TT_UI_StatsWindow["closeButton"]:SetText("TEST BUTTON");
TT_UI_StatsWindow["closeButton"].texture = TT_UI_StatsWindow["closeButton"]:CreateTexture(nil,"background");
TT_UI_StatsWindow["closeButton"].texture:SetTexture(0,0,0,0.3);
TT_UI_StatsWindow["closeButton"]:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE", "");
TT_UI_StatsWindow["closeButton"]:SetPoint("TOP",0,0)
TT_UI_StatsWindow["closeButton"]:SetText("X");
TT_UI_StatsWindow["closeButton"].texture:SetAllPoints(TT_UI_StatsWindow["closeButton"])

TT_UI_StatsWindow["closeButton"]:SetScript("OnClick",
function(self)
	TT_UI_StatsWindow["background"]:Hide();
end)


TT_UI_StatsWindow["background"]:Hide();

