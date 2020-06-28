----------------------------------------
-- Namespace / Locals
----------------------------------------
local _, addon = ...;




----------------------------------------
-- Functions
----------------------------------------
function addon:Init(event, name)
	if (name ~= "BigOlCritties") then return end 

	
	----------------------------------
	-- Register Slash Commands!
	----------------------------------
	SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
	SlashCmdList.RELOADUI = ReloadUI;

	SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_Toggle();
	end

	
	addon.Crit.StartListening()
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", addon.Init);