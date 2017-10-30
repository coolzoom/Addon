DPSE_LoadBegin = GetTime();
PlayerClass, PlayerClassCaps = UnitClass("player");
if PlayerClassCaps ~= "ROGUE" and PlayerClassCaps ~= "WARRIOR" and PlayerClassCaps ~= "HUNTER" and PlayerClassCaps ~= "WARLOCK" and PlayerClassCaps ~= "MAGE" and PlayerClassCaps ~= "PALADIN" and PlayerClassCaps ~= "SHAMAN" then
	DEFAULT_CHAT_FRAME:AddMessage("|cFFFFDD11[DPSEngine]|r ".. PlayerClass .. " is not yet supported.");
	return;
end

RotationFileVersion = "10.30.2017-01";