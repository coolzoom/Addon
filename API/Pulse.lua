--- Pulse Function
Manager.FetchLimiter = 0; Manager.PulseLimiter = 0; TTDThrottle = 0; Manager.Queue = {};
function Manager.Pulse ()
	if GetUnitPosition == nil then
		return;
	end

	CurrentTime = GetTime();
	local Rotation = Rotations[Player:Class()];

	if Rotation ~= nil then
		if not Rotation.Initialized then
			Options = {
				PagesCount = 0,
				AllClass = { UI_Visible = true, UI_X = 900, UI_Y = -250 }
			};
			Rotation.Initialized = true;
			Rotation.SpelllInBars = 0;
			SpellsTable = {};
			Rotation:Initialize();
			Manager:ReadSettings(CurrentProfile..".txt");
			Manager.RefreshOptions();
		end
		UpdateUIDebug();
		-- Fetch every 0.2s
		if Manager.FetchLimiter == nil or Manager.FetchLimiter < GetTime() then
			Manager.FetchLimiter = GetTime() + 0.2;
			UnitsEngine.Fetch();
		end
		-- TimeToDie Handler
		if GetTime() > TTDThrottle then
			TTDThrottle = GetTime() + 0.2;
			TTDRefresh();
		end
		-- Always Update Player Position for the Movements check
		Player.X, Player.Y, Player.Z = GetUnitPosition(Player.UnitID);
		Player:UpdateMovement();

		--Anti-AFK
		if IsOptionEnabled("Anti AFK") and GetAutoAway() ~= 1 then 
			SetAutoAway(1); 
		elseif not IsOptionEnabled("Anti AFK") and GetAutoAway() == 1 then 
			SetAutoAway(0); 
		end 
		-- Pulse every 0.05s
		if Manager.IsRunning then--and Manager.PulseLimiter < GetTime() then
			Manager.PulseLimiter = GetTime() + 0.05;
			if Rotation.TablesRefreshed < GetTime() then
	    		Rotation:UnitTables();
	    	end
	    	if Manager.Queue.Position ~= nil then
	    		Manager:QueueParse();
	    	else
	    		Rotation:Pulse();
			end
	    end
	end
end

--- Pulse Frame
Pulse = CreateFrame("Frame", Randomize());
Pulse.EngineInitialized = false;
Pulse.EngineWarning = false;
Pulse:SetScript("OnUpdate", function (...) 
	if Manager.Loaded == true and GetUnitPosition ~= nil then
		-- Initialize The Engine
		if Pulse.EngineInitialized == false then
			local loadTime = DPSE_LoadEnd - DPSE_LoadBegin;
			local appLoadTime = GetTime() - DPSE_LoadBegin;
			print("|cFFFFDD11[DPSEngine]|r Add-On Loaded in "..string.format("%.2f", loadTime).." seconds.");
			print("|cFFFFDD11[DPSEngine]|r Total Load time: "..string.format("%.2f", appLoadTime));
			print("|cFFFFDD11[DPSEngine]|r File Version: "..RotationFileVersion);
			print("|cFFFFDD11[DPSEngine]|r Class Detected: "..Player:Class());
			print("|cFFFFDD11[DPSEngine]|r For a list of commands type: |cFFFFDD11/dpse commands");
			Manager.LoadUI();
			Pulse.EngineInitialized = true;
		end
		Manager.Pulse();
	elseif DPSEngine_Loaded == nil and Pulse.EngineWarning == false and GetTime() - DPSE_LoadEnd > 10 then
		Pulse.EngineWarning = true;
		message("Please run the DPSEngine.exe and connect it to this client in order to use the DPSEngine Addon.");
		return;
	end

end)

function UpdateUIDebug ()
	if Target:Exists() then
		-- Check if target distance is less than 100, if it is 100 or more, unit is too far
		if Player:DistanceTo(Target) < 100 then
			VanillaUI.Tools.Debug:Show();
			if Player:InLineOfSight(Target) then
				if Player:IsBehind(Target) then
					Debug(Colors.Green.Hex.."Behind Target");
				else
					Debug(Colors.Red.Hex.."In front of Target");
				end
			else
				Debug(Colors.Red.Hex.."Not In Line Of Sight");
			end
			VanillaUI.Tools.Distance:Show();
			VanillaUI.Tools.Distance.Text:SetText(math.floor(Player:DistanceTo(Target)*10)/10);
			VanillaUI.Tools.TTD:Show();
			VanillaUI.Tools.TTD.Text:SetText(Target:TimeToDie());
		else
			Debug(Colors.Red.Hex.."Target is too far.");
		end
	else
		VanillaUI.Tools.Distance:Hide();
		VanillaUI.Tools.Distance.Text:SetText("");
		VanillaUI.Tools.Debug:Hide();
		VanillaUI.Tools.Debug.Text:SetText("");
		VanillaUI.Tools.TTD:Hide();
		VanillaUI.Tools.TTD.Text:SetText("");
	end
end

function Debug (Value)
	VanillaUI.Tools.Debug.Text:SetText(Value);
end

-- Add a spell to the queue if it is valid
function Manager:QueueSpell (SpellName)
	if Manager.IsRunning then
		if SpellsTable[SpellName] ~= nil then
			if SpellsTable[SpellName].Spell:Cooldown() < 2.5 then
				Print(SpellName.." queued.");
				Manager.Queue = {Spell = SpellsTable[SpellName].Spell, SpellName = SpellName, SpellID = SpellsTable[SpellName].SpellID, Position = SpellsTable[SpellName].Position, IsHostile = SpellsTable[SpellName].IsHostile, Time = GetTime() + 5};
			else
				Print(SpellName.." is not ready.");
			end
		else
			Print(SpellName.." cannot be queued as it is not a registered spell. Please refer to the Development Team and ask for this spell to be added if you need it.");
		end
	else
		Print(SpellName.." was not queued as the manager is not running.")
	end
end

-- Parse Queued spell
function Manager:QueueParse ()
	if Manager.Queue.Time < GetTime() then
		Manager.Queue = {};
	end
	if Manager.Queue.Time ~= nil and not Player:IsCastingAny() then
		if not Manager.Queue.IsHostile then
			if Player:CanCast(Manager.Queue.Spell) then
				Bug("Casting "..Colors.Green.Hex..Manager.Queue.SpellName.." ("..Manager.Queue.SpellID..") |cffFFFFFFon "..Colors.Red.Hex..(Manager.Queue.IsHostile == false and Player:Name() or Target:Name()).." ("..(Manager.Queue.IsHostile == false and Player.UnitID or Target.UnitID)..")");
			   	UseAction(Manager.Queue.Position, false, true);
			   	Manager.Queue = {};
			end
		else
			if Target:CanCast(Manager.Queue.Spell) then
				Bug("Casting "..Colors.Green.Hex..Manager.Queue.SpellName.." ("..Manager.Queue.SpellID..") |cffFFFFFFon "..Colors.Red.Hex..(Manager.Queue.IsHostile == false and Player:Name() or Target:Name()).." ("..(Manager.Queue.IsHostile == false and Player.UnitID or Target.UnitID)..")");
				CastSpell(Manager.Queue.SpellID, "spell");
			   	Manager.Queue = {};
			end
		end
	end
end