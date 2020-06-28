----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, addon = ...;
addon.Crit = {}; -- adds Crit table to addon namespace
local Crit = addon.Crit;
local critListener = CreateFrame("Frame");

local yLoc = 0;
local xLoc = 0;
local yMin = 0;
local yMax = 0;
local xMin = 0;
local xMax = 0;



local t = UIParent:CreateTexture(nil,"OVERLAY",nil);

----------------------------------------
-- Functions
----------------------------------------
-- Backing function to play the sound files.
local function _playSound(soundFileName)
	PlaySoundFile("Interface\\AddOns\\BigOlCritties\\Sounds\\" .. soundFileName, BigOlCrittiesDB[GetRealmName()][UnitName("player")].SoundChannel)
end

local function _showTits(titsFileName,x,y)
	t:Show()
	t:SetTexture("Interface\\AddOns\\BigOlCritties\\Tits\\" .. titsFileName)
	t:SetHeight(BigOlCrittiesDB[GetRealmName()][UnitName("player")].TitSize)
	t:SetWidth(BigOlCrittiesDB[GetRealmName()][UnitName("player")].TitSize)
	t:SetPoint("CENTER",x,y)
	t:SetAlpha(BigOlCrittiesDB[GetRealmName()][UnitName("player")].Transparency)
	end
	
	--{} DEBUGGING: COMMENT OUT ON RELEASE
	-- print(titsFileName .. ", x = " .. x .. ", y = " .. y)
	-- print(BigOlCrittiesDB[GetRealmName()][UnitName("player")].ScreenSizeH .. " high, by " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].ScreenSizeW .. " wide.")
	-- print("X: " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].xLeftMax .. " to " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].xLeftMin .. " , " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].xRightMin .. " to " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].xRightMax)
	-- print("Y: " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].yBottMax .. " to " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].yBottMin .. " , " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].yTopMin .. " to " .. BigOlCrittiesDB[GetRealmName()][UnitName("player")].yTopMax)
--end

local function hideTits()
	t:Hide()
end	

--local function locateTits()
	-- Set minimum and maximum ranges to be used to locate tits on crit.

--end

-- Fucntion to play sound file.
local function playSound()
	_playSound("wow"..math.random(1,5)..".mp3")
end

-- Function to show tits file.
local function showTits()

	--Localize DB screen parameters
	yBMax2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].yBottMax
	yBMin2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].yBottMin
	yTMax2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].yTopMax
	yTMin2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].yTopMin
	xLMax2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].xLeftMax
	xLMin2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].xLeftMin
	xRMin2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].xRightMin
	xRMax2 = BigOlCrittiesDB[GetRealmName()][UnitName("player")].xRightMax
	
	-- randomize locations while maintaining visibility
	yMin = math.random(yBMax2, yBMin2) 
	yMax = math.random(yTMin2, yTMax2)
	xMin = math.random(xLMax2, xLMin2)
	xMax = math.random(xRMin2, xRMax2)
	
	-- place tits within confines of screen parameters
	yLoc = math.random(yMin,yMax)
	xLoc = math.random(xMin,xMax)
	_showTits("tits" .. math.random(1,23) .. ".tga",xLoc,yLoc)
	
	-- store crit amount in variable
	--critAmount = amount
	
end

-- Function to play highest crit sound file
--local function playMax()
--	_playSound("KACHOW.mp3")
--end

-- Function to play top 10% crit sound file
--local function playTop()
--	_playSound("wowDOM.mp3")
--end


----------------------------------------
-- Events / Handlers
----------------------------------------
-- Subscribes to combat event.
function Crit:StartListening()
	critListener:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	critListener:SetScript("OnEvent", function(self, event) self:OnEvent(event, CombatLogGetCurrentEventInfo()) end);
end


-- Parses event, plays sound if its a crit.
function critListener:OnEvent(event, ...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
	local spellId, spellName, spellSchool
	local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

	if subevent == "SWING_DAMAGE" then
		amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "RANGE_DAMAGE" then
		spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
	elseif subevent == "SPELL_HEAL" then
		spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
    end
		if critical and sourceGUID == BigOlCrittiesDB[GetRealmName()][UnitName("player")].GUID then					
			C_Timer.After(BigOlCrittiesDB[GetRealmName()][UnitName("player")].SoundDelay, playSound)
			showTits()
			C_Timer.After(BigOlCrittiesDB[GetRealmName()][UnitName("player")].TitsDisplay, hideTits) 	--clear screen of titties
		end
end