
Events.DebugStatus = false;
function Events:Debug (String)
	if Events.DebugStatus == true then
		print("[Events Debug] "..String);
	end
end

--- Start Attack Events
Events:RegisterEvent("PLAYER_ENTER_COMBAT");
Events:RegisterEvent("PLAYER_TARGET_CHANGED");
Events:RegisterEvent("PLAYER_LEAVE_COMBAT");

--- If the player learns spells
Events:RegisterEvent("SPELLS_CHANGED");

--- Error Messages
Events:RegisterEvent("UI_ERROR_MESSAGE");


--- Combat Time Events
Events.CombatTime = 0;
Events.OutOfCombatTime = GetTime();
Events:RegisterEvent("PLAYER_REGEN_DISABLED");
Events:RegisterEvent("PLAYER_REGEN_ENABLED");

function Events.ParseEvents (event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)

	--- When player leave's combat
	if event == "PLAYER_REGEN_ENABLED" then
		Events:Debug("PLAYER_REGEN_ENABLED");
		Events.CombatTime = nil;
		Events.OutOfCombatTime = GetTime();
	end

	--- When player enter's combat
	if event == "PLAYER_REGEN_DISABLED" then
		if IsOptionEnabled("Auto Attack") and Target and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
			Events:Debug("PLAYER_REGEN_DISABLED");
			Events.QueueAttack = GetTime() + 0.25;
		end
		Events.CombatTime = GetTime();
		Events.OutOfCombatTime = nil;
	end

	--- If the User used a Right Click, we do not try to start attack
	if event == "PLAYER_ENTER_COMBAT" then
		Events:Debug("PLAYER_ENTER_COMBAT");
		Events.QueueAttack = false;
	end

	--- If the User changes target or Leave Combat, we try to initiate attack 0.1s later
	if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_LEAVE_COMBAT" then
		Rotations.HUNTER.petAttack = false;
		Rotations.WARLOCK.petAttack = false;
		if IsOptionEnabled("Auto Attack") and Target and Player:CanAttack(Target) and not Target:IsDeadOrGhost() then
			Events:Debug("PLAYER_TARGET_CHANGED");
			if not (Stealth ~= nil and Stealth:Exists() and Player:Buff(Stealth)) then
				Events.QueueAttack = GetTime() + 0.25;
			end
		end
	end

	--- When the player learn spells
	if event == "SPELLS_CHANGED" then
		Events:Debug("SPELLS_CHANGED");
		Rotations[Player:Class()].Initialized = false;
	end

	if event == "UI_ERROR_MESSAGE" then
		if arg1 == "Interrupted" then
			Events:Debug("Casting interrupted.");
		elseif arg1 == "Target needs to be in front of you" then
			Events:Debug("Casting not facing.");
		end
	end
end

--- Queues Handler
Events:SetScript("OnUpdate", function (...) 
	if Events.QueueAttack and Events.QueueAttack < GetTime() then
		Events:Debug("Queued Attack");
		--AttackTarget();
		Events.QueueAttack = false;
	end
	if Events.AbilityChanged and Events.AbilityChanged < GetTime() then
		Rotations[Player:Class()].Initialized = false;
		Events.AbilityChanged = false;
	end
end);

--- Combat Reader
CombatEvents:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS"); -- Melee hits
CombatEvents:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES"); -- Melee Misses
CombatEvents:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE"); -- Spell hits
CombatEvents:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"); -- Dots
CombatEvents:RegisterEvent("CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF");	-- Thorned damage
CombatEvents:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS"); -- Enemy hits on me
CombatEvents:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES"); -- Enemy miss on me
CombatEvents:RegisterEvent("SPELLCAST_START");
CombatEvents:RegisterEvent("SPELLCAST_STOP");
CombatEvents:RegisterEvent("SPELLCAST_DELAYED");

function CombatEvents.ParseEvents (event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
	local Args = {arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15};
	local ArgsString = event.." ";
	for i = 1, 15 do
		if Args[i] ~= nil and Args[i] ~= "" then
			ArgsString = ArgsString.."Arg"..tostring(i).."="..Args[i].."  ";
		end
	end
	if ArgsString ~= "" then
		Events:Debug(ArgsString);
	end

	---- Warrior
	--- Overpower Proc
	if event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_DAMAGESHIELDS_ON_SELF" or event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		local TargetName = Target:Name();
		if TargetName ~= nil then
			if string.find(arg1, "You") and string.find(arg1, TargetName.." dodge") then
				Events:Debug("Overpower Procced");
				ShouldOverpower = GetTime() + 3;
			elseif string.find(arg1, "Your Overpower") then
				Events:Debug("Overpower Procced");
				ShouldOverpower = GetTime() + 3;
			end
		end
	end
	--- Overpower used
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, "Overpower") then
		Events:Debug("Overpower Casted");
		ShouldOverpower = 0;
	end
	---- Hunter
	--- Mongoose Bite Proc
	if event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
		local TargetName = Target:Name();
		if TargetName ~= nil then
			if string.find(arg1, "You dodge") then
				Events:Debug("Mongoose Bite Procced");
				ShouldMongoose = GetTime() + 3;
			end
		end
	end
	--- Mongoose Bite used
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and string.find(arg1, "Mongoose Bite") then
		Events:Debug("Mongoose Bite Casted");
		ShouldMongoose = 0;
	end
end

--- Get The time that elapsed since the combat started
function CombatTime ()
	return Events.CombatTime ~= nil and GetTime() - Events.CombatTime or 0;
end

--- Get The time that elapsed since the combat ended
function OutOfCombatTime ()
	return Events.OutOfCombatTime ~= nil and GetTime() - Events.OutOfCombatTime or 0;
end
