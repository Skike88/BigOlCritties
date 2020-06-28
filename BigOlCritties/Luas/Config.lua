----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, addon = ...;
addon.Config = {};
local Config = addon.Config;
local UIOptions;
local debugValue;
local thisPlayer;
local mainBigOlCrittiesFrame = CreateFrame("Frame")
mainBigOlCrittiesFrame:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, event, ...)
end);




----------------------------------------
-- Defaults
----------------------------------------
local defaults = {
	Data = {
		Realm = GetRealmName(),
		Char = UnitName("player"),
		GUID = UnitGUID("player"),
	},
	Settings = {
		SoundDelay = .5,			-- Half a second.
		SoundChannel = "Dialog",	-- Master, SFX, Music, Ambience, Dialog.
		Debug = true,				-- Make sure this is set to false for releases.
		TitsDisplay = 2.5,			-- 2.5 seconds.
		--Share = true,				-- Default true, option to not share crit records
		Transparency = 100,			-- Default transparency (opaque)
		--TransparentTitties = false,	-- Default false, option to have mroe see through titties
		TitSize = 256,				-- Default size of the tits image to be called
		ScreenSizeH = 1,			-- Default screen height
		ScreenSizeW = 1,			-- Default screen width
		xLeftMax = 2,
		xLeftMin = 2,
		xRightMax = 2,
		xRightMin = 2,
		yBottMax = 2,
		yBottMin = 2,
		yTopMax = 2,
		yTopMin = 2,
	},
};


----------------------------------------
-- Events / Handlers
----------------------------------------
mainBigOlCrittiesFrame:RegisterEvent("PLAYER_LOGIN")
function mainBigOlCrittiesFrame.PLAYER_LOGIN(self, event)
	-- Build SavedVariables database if one has not been created. Also populates defaults.
	BigOlCrittiesDB = BigOlCrittiesDB or {}
	if (not BigOlCrittiesDB[defaults.Data.Realm]) then 
		BigOlCrittiesDB[defaults.Data.Realm] = {};
	end;
	if (not BigOlCrittiesDB[defaults.Data.Realm][defaults.Data.Char]) then 
		BigOlCrittiesDB[defaults.Data.Realm][defaults.Data.Char] = {};
    end;
	thisPlayer = BigOlCrittiesDB[defaults.Data.Realm][defaults.Data.Char];
	
	-- load each option, or set default if not there.
	if ( thisPlayer.GUID == nil ) then thisPlayer.GUID = defaults.Data.GUID; end;
	if ( thisPlayer.SoundDelay == nil ) then thisPlayer.SoundDelay = defaults.Settings.SoundDelay; end;
	if ( thisPlayer.SoundChannel == nil ) then thisPlayer.SoundChannel = defaults.Settings.SoundChannel; end;
	if ( thisPlayer.Debug == nil ) then thisPlayer.Debug = defaults.Settings.Debug;	end;
	--if ( thisPlayer.TransparentTitties == nil) then thisplayer.TransparentTitties = defaults.Settings.TransparentTitties; end;
	if ( thisPlayer.Share == nil ) then thisPlayer.Share = defaults.Settings.Share; end;
	if ( thisPlayer.TitsDisplay == nil ) then thisPlayer.TitsDisplay = defaults.Settings.TitsDisplay; end;
	if ( thisPlayer.TitSize == nil ) then thisPlayer.TitSize = defaults.Settings.TitSize; end;
	if ( thisPlayer.Transparency == nil ) then thisPlayer.Transparency = defaults.Settings.Transparency; end;	
	
	thisPlayer.ScreenSizeH = GetScreenHeight()
	thisPlayer.ScreenSizeW = GetScreenWidth()
	thisPlayer.xLeftMax = -((thisPlayer.ScreenSizeW/2)-(thisPlayer.TitSize/2))
	thisPlayer.xLeftMin = -(thisPlayer.ScreenSizeW/8)
	thisPlayer.xRightMax = (thisPlayer.ScreenSizeW/2)-(thisPlayer.TitSize/2)
	thisPlayer.xRightMin = thisPlayer.ScreenSizeW/8
	thisPlayer.yBottMax = -((thisPlayer.ScreenSizeH/2)-(thisPlayer.TitSize/2))
	thisPlayer.yBottMin = -(thisPlayer.ScreenSizeH/8)
	thisPlayer.yTopMax = (thisPlayer.ScreenSizeH/2)-(thisPlayer.TitSize/2)
	thisPlayer.yTopMin = thisPlayer.ScreenSizeH/8
	
	

	-- Creates frame for options panel.
	local loader = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	loader:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)

		if not mainBigOlCrittiesFrame.optionsPanel then
			mainBigOlCrittiesFrame.optionsPanel = mainBigOlCrittiesFrame:CreateOptionsUI("Big Ol Critties")
			InterfaceOptions_AddCategory(mainBigOlCrittiesFrame.optionsPanel);
		end
	end)
end




----------------------------------------
-- Functions
----------------------------------------
local uniquealyzerCheckbox = 1;
local uniquealyzerSlider = 1;


-- Makes all the checkboxes.
local function makeCheckbox(parent, x_loc, y_loc, displayText)
	uniquealyzerCheckbox = uniquealyzerCheckbox + 1;
	
	local checkbutton = CreateFrame("CheckButton", "bigOlCritties_optionsCheckbutton_0" .. uniquealyzerCheckbox, parent, "ChatConfigCheckButtonTemplate");
	checkbutton:SetPoint("TOPLEFT", x_loc, y_loc);
	getglobal(checkbutton:GetName() .. 'Text'):SetText(displayText);

	return checkbutton;
end


-- Makes all the sliders.
local function makeSlider(parent, x_loc, y_loc, displayText)
	uniquealyzerSlider = uniquealyzerSlider + 1;
	
	local slider = CreateFrame("Slider", "bigOlCritties_optionsSlider_0" .. uniquealyzerSlider, parent, "OptionsSliderTemplate");
	slider:SetPoint("TOPLEFT", x_loc, y_loc);
	slider:SetObeyStepOnDrag(true)
	getglobal(slider:GetName() .. 'Text'):SetText(displayText);

	return slider;
end

function roundToFirstDecimal(w)
  return tonumber(string.format("%." .. (1) .. "f", w))
end

function roundToSecondDecimal(f)
	return tonumber(string.format("%." .. (01) .. "f", f))
end

-- Main frame for addon.
function mainBigOlCrittiesFrame:CreateOptionsUI(name
, parent)
	-- Create mainBigOlCrittiesFrame options window frame.
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
	frame:Hide()
	frame.parent = parent
	frame.name = name
	frame:SetScript("OnShow", function(self)
        self.content.optionsDebug:SetChecked(thisPlayer.Debug)
        self.content.optionsSoundDelay:SetValue(thisPlayer.SoundDelay)
		self.content.optionsTitsDisplay:SetValue(thisPlayer.TitsDisplay)
		self.content.optionsTitSize:SetValue(thisPlayer.TitSize)	
		self.content.optionsTransparency:SetValue(thisPlayer.Transparency)
		--self.content.optionsShare:SetChecked(thisPlayer.Share)
    end)

	-- Label for addon options header.
	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	label:SetPoint("TOPLEFT", 10, -15)
	label:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 10, -45)
	label:SetJustifyH("LEFT")
    label:SetJustifyV("TOP")
	label:SetText(name)

	-- Set content for mainBigOlCrittiesFrame frame.
	local content = CreateFrame("Frame", "CADOptionsContent", frame)
	content:SetPoint("TOPLEFT", 10, -10)
    content:SetPoint("BOTTOMRIGHT", -10, 10)
	frame.content = content
	
	-- Checkbox for debug mode.
	local optionsDebug = makeCheckbox(frame, 10, -75, "  Turn on debug mode")
	content.optionsDebug = optionsDebug
	optionsDebug.tooltip = "Ignore this.  If I take it out the options menu breaks. ¯\\_(o.o)_/¯ ";
	optionsDebug:SetScript("OnClick", 
		function()
			thisPlayer.Debug = not thisPlayer.Debug;
		end
	);
	
		-- Checkbox for sharing mode.
	--local optionsShare = makeCheckbox(frame, 10, -225, "  Do you want to share your crits?")
	--content.optionsShare = optionsShare
	--optionsShare.tooltip = "Shares your highest crits with fellow critty lovers, and shares when you beat your highest!";
	--optionsShare:SetScript("OnClick", 
	--	function()
	--		thisPlayer.Share = not thisPlayer.Share;
	--	end
	--);
	
	-- Checkbox for transparent or opaque titties.
	--local optionsTransparent = makeCheckbox(frame, 10, -125, "  Transparent titties?")
	--content.optionsTransparent = optionsTransparent
	--optionsTransparent.tooltip = "Make them titties a little more see through?";
	--optionsTransparent:SetScript("OnClick", 
	--	function()
	--		thisPlayer.TransparentTitties = not thisPlayer.TransparentTitties;
	--	end
	--);

	-- Slider for sound delay.
	local optionsSoundDelay = makeSlider(frame, 320, -75, "Sound Delay")
	content.optionsSoundDelay = optionsSoundDelay
	optionsSoundDelay:SetMinMaxValues(0,1)
	optionsSoundDelay:SetValueStep(.1)
	optionsSoundDelay.tooltipText = "Adds a delay from when the crit was registered to when the sound is played. Note this is to help sync with seeing the crit in the combat text and hearing the clip. Default should line up with WoW's visual combat text, but if not, adjust here."
	optionsSoundDelay:SetScript("OnValueChanged",
		function(self, value)
			thisPlayer.SoundDelay = value;
			_G[optionsSoundDelay:GetName() .. 'Text']:SetText("Sound Delay: "..tostring(roundToFirstDecimal(value)).." Seconds")
		end
	);
	
	-- Slider for tits display.
	local optionsTitsDisplay = makeSlider(frame, 320, -125, "Tits Displayed")
	content.optionsTitsDisplay = optionsTitsDisplay
	optionsTitsDisplay:SetMinMaxValues(0,5)
	optionsTitsDisplay:SetValueStep(.1)
	optionsTitsDisplay.tooltipText = "How long you wanna look at tits?"
	optionsTitsDisplay:SetScript("OnValueChanged",
		function(self, value)
			thisPlayer.TitsDisplay = value;
			_G[optionsTitsDisplay:GetName() .. 'Text']:SetText("Tits Display: "..tostring(roundToFirstDecimal(value)).." Seconds")
		end
	);
	
	-- Slider for size of tits image.
	local optionsTitSize = makeSlider(frame, 320, -175, "Size of tits image shown")
	content.optionsTitSize = optionsTitSize
	optionsTitSize:SetMinMaxValues(64,512)
	optionsTitSize:SetValueStep(2)
	optionsTitSize.tooltipText = "How big them titties?"
	optionsTitSize:SetScript("OnValueChanged",
		function(self, value)
			thisPlayer.TitSize = value;
			_G[optionsTitSize:GetName() .. 'Text']:SetText("Image Size: "..tostring(roundToFirstDecimal(value)).." Pixels")
		end
	);
	
	-- Slider for transparency of tits image.
	local optionsTransparency = makeSlider(frame, 10, -125, "Transparency Level")
	content.optionsTransparency = optionsTransparency
	optionsTransparency:SetMinMaxValues(0,1)
	optionsTransparency:SetValueStep(.01)
	optionsTransparency.tooltipText = "How much you wanna see through them titties?"
	optionsTransparency:SetScript("OnValueChanged",
		function(self, value)
			thisPlayer.Transparency = value;
			_G[optionsTransparency:GetName() .. 'Text']:SetText("Opacity: "..tostring(roundToFirstDecimal(value*100)).." ")
		end
	);

	-- Create the dropdown, and configure its appearance
	local soundChannelLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	soundChannelLabel:SetPoint("TOPLEFT", 315, -261)	
	soundChannelLabel:SetJustifyH("LEFT")
    soundChannelLabel:SetJustifyV("TOP")
	soundChannelLabel:SetText("Sound Channel")

	local soundChannelDropDown = CreateFrame("FRAME", "SoundChannelDropDown", frame, "UIDropDownMenuTemplate")
	soundChannelDropDown:SetPoint("TOPLEFT", 295, -300)
	UIDropDownMenu_SetWidth(soundChannelDropDown, 100)
	UIDropDownMenu_SetText(soundChannelDropDown, thisPlayer.SoundChannel)

	-- Implement the function to change the Sound Channel
	function soundChannelDropDown:SetValue(newValue)
		thisPlayer.SoundChannel = newValue
		UIDropDownMenu_SetText(soundChannelDropDown, thisPlayer.SoundChannel)
		CloseDropDownMenus()
	end

	-- Makes each menu item for the drop down.
	function soundChannelDropDown:MakeDropDownItem(name, level)
		local info = UIDropDownMenu_CreateInfo();
		info.text = name;
		info.value = name;
		info.owner = soundChannelDropDown;
		info.func = function() self:SetValue(name); end;
		info.checked = thisPlayer.SoundChannel == info.value;
		UIDropDownMenu_AddButton(info, level); 
	end

	-- Create and bind the initialization function to the dropdown menu
	UIDropDownMenu_Initialize(soundChannelDropDown,	function(self)
		self:MakeDropDownItem("Master", 1)
		self:MakeDropDownItem("SFX", 1)
		self:MakeDropDownItem("Music", 1)
		self:MakeDropDownItem("Ambience", 1)
		self:MakeDropDownItem("Dialog", 1)
	end)

	return frame
end