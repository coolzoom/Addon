SpellsTable = {};
Manager.IsRunning = false;
--- Toggle's the rotation's pulse on and off
function Manager:Toggle ()
	Manager.IsRunning = not Manager.IsRunning;
	Print("The Rotation Pulse is now "..(Manager.IsRunning and "Enabled" or "Disabled")..".");
	Color = Manager.IsRunning and Colors.Green or Colors.Red;
	VanillaUI.Tools.Rota:SetBackdropColor(Color.R, Color.G, Color.B, 0.75);
	VanillaUI.Tools.Rota.Text:SetText(Manager.IsRunning and "ON" or "OFF");
	SetSetting("Running", Manager.IsRunning);
end

Manager.AoE = false;
--- Toggle's the rotation's pulse on and off
function Manager:ToggleAoE ()
	Manager.AoE = not Manager.AoE;
	Print("The AoE is now "..(Manager.AoE and "Enabled" or "Disabled")..".");
	Color = Manager.AoE and Colors.Green or Colors.Red;
	VanillaUI.Tools.AoE:SetBackdropColor(Color.R, Color.G, Color.B, 0.75);
	SetSetting("AoE", Manager.AoE);
end

Manager.CDs = false;
--- Toggle's the rotation's pulse on and off
function Manager:ToggleCDs ()
	Manager.CDs = not Manager.CDs;
	Print("The Cooldowns are now "..(Manager.CDs and "Enabled" or "Disabled")..".");
	Color = Manager.CDs and Colors.Green or Colors.Red;
	VanillaUI.Tools.CDs:SetBackdropColor(Color.R, Color.G, Color.B, 0.75);
	SetSetting("CDs", Manager.CDs);
end

Manager.Spec = 1;
--- Set the current Spec in the toolbox
function Manager:SetSpec (Spec)
	Manager.Spec = Spec;
	SetSetting("Spec", Spec);
	for i = 1, 3 do
		if Spec == i then
			VanillaUI.Tools["Spec"..i]:SetBackdropColor(Colors.Gold.R, Colors.Gold.G, Colors.Gold.B, 0.75);
		else
			VanillaUI.Tools["Spec"..i]:SetBackdropColor(Colors.Blue.R, Colors.Blue.G, Colors.Blue.B, 0.75);
		end
	end
end

local CommandsList = {
	"toggle - Enable / Disable the rotation Pulse.",
	"aoe - Enable / Disable the AoE. The AoE will still only be used when enough units are in range of AoE abilities.",
	"cds - Enable / Disable the Cooldowns.",
	"ui - Display / Hide the User Interface.",
	"toggleoption OptionName - Toggle an option in the UI for the current class. The OptionName must be properly capitalized and use the same words as the option. In example, Warrior's Charge toggle will be /dpsengine toggleoption Charge",
	"changevalue OptionName;Value - Change an option's value in the UI for the current class. The OptionName must be properly capitalized and use the same words as the option. The Value must be within the option value's limits. In example, Warrior's Strike / Cleave value can be changed with /dpsengine changevalue Strike / Cleave;40"
}

function Manager:Commands ()
	print("|cffFFDD11[DPSEngine]|r Here's a list of all the available commands in DPSEngine.")
	for i = 1, table.getn(CommandsList) do
		local CommandValue = CommandsList[i];
		local DashPosition = string.find(CommandValue, "-");
		local CommandName = string.sub(CommandValue, 1, DashPosition - 1);
		local CommandExplanation = string.sub(CommandValue, DashPosition);
		print(Colors.Blue.Hex.."/dpse "..CommandName.."|r"..CommandExplanation);
	end
end

SlashCmdList["DPSENGINE"] = function (Parts) 
	local LowerParts = string.lower(Parts);
	if string.find(LowerParts, "toggleoption") then
		local OptionName = string.sub(Parts, string.find(LowerParts, "toggleoption") + 13);
		VanillaUI:ToggleOption(OptionName);
	elseif string.find(LowerParts, "changevalue") then
		local OptionName = string.sub(Parts, string.find(LowerParts, "changevalue") + 12, string.find(Parts, ";") - 1);
		local Value = tonumber(string.sub(Parts, string.find(Parts, ";") + 1));
		VanillaUI:SetOptionValue(OptionName, Value);
	elseif string.find(LowerParts, "commands") then
		Manager:Commands();
	elseif string.find(LowerParts, "toggle") then
		Manager:Toggle();
	elseif string.find(LowerParts, "aoe") then
		Manager:ToggleAoE();
	elseif string.find(LowerParts, "cds") then
		Manager:ToggleCDs();
	elseif string.find(LowerParts, "spells") then
		SpellBook:Dump(1);
	elseif string.find(LowerParts, "items") then
		Equipment:Dump(1);
	elseif string.find(LowerParts, "ui") then
		VanillaUI:ToggleDisplay();
	elseif string.find(LowerParts, "cast") then
		local SpellName = string.sub(Parts, string.find(LowerParts, "cast") + 5);
		Manager:QueueSpell(SpellName);
	end
end;