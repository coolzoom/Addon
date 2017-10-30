DebugString, DebugTime = "", 0;
function Bug (String)
	if IsOptionEnabled("Chat Debug") and (DebugString ~= String or GetTime() - DebugTime > 1) then
		DebugString, DebugTime = String, GetTime();
		print(Colors.Gold.Hex.."[Debug]|r "..String);
	end
end

function Print (String)
	if IsOptionEnabled("Chat Notifications") then
		print(Colors.Gold.Hex.."[DPSEngine]|r "..String);
	end
end

function AddAllClassOptions ()
	AddOption("General", "Initiate Combat", false, "Will start combat.");
	AddOption("General", "Avoid Tapped Monsters", true, "Will avoid attacking monsters that are not tapped by the player or their group.");
	if Player:Class() ~= "HUNTER" and Player:Class() ~= "WARLOCK" and Player:Class() ~= "MAGE" and Player:Class() ~= "PRIEST" then
		AddOption("Offensive", "Auto Attack", true);
	else
		AddOption("Offensive", "Auto Shot / Attack", true);
	end
	AddOption("Advanced", "Anti AFK", false);
	AddOption("Advanced", "Chat Notifications", true);
	AddOption("Advanced", "Chat Debug", false);
end

--- Refreshing Units Tables
function Rotations:RefreshUnitTables (Identifier)
	if Rotations[Identifier].TablesRefreshed < GetTime() then
		Rotations[Identifier]:UnitTables();
		Rotations[Identifier].TablesRefreshed = GetTime() + 0.05;
	end
end

--- Get if the AoE is enabled
function UseAOE ()
	return GetSetting("AoE");
end

--- Get if the CDs are enabled
function CooldownsAllowed ()
	return GetSetting("CDs");
end