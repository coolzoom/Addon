--- Hunter
Rotations.WARLOCK = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	petAttack = false,
	lastSpell = "none";
	lastSpellTime = 0;
	LifeTapCasted = 0,
	shotTime = 0,
	CooldownTriggered = false,
	FearUnit = nil;
	Spec = "None",
	Activated = false
};
local Rotation = Rotations.WARLOCK;
function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Racials
	BloodFury = Spell.Create("Racial_Orc_BerserkerStrength", false, false, true, 0, "Racial");
	Berserking = Spell.Create("Racial_Troll_Berserk", false, false, true, 0, "Racial");

	AmplifyCurse = Spell.Create("Spell_Shadow_Contagion", false, false, true, 0);
	Conflagrate = Spell.Create("Spell_Fire_Fireball", true, true, true, 30);
	Shadowburn = Spell.Create("Spell_Shadow_ScourgeBuild", false, false, true, 20);
	SoulLink = Spell.Create("Spell_Shadow_GatherShadows", false, false, true, 0);
	FelDomination = Spell.Create("Spell_Nature_RemoveCurse", false, false, true, 0);

	Imp = Spell.Create("Spell_Shadow_SummonImp", false, false, false, 0);
	Voidwalker = Spell.Create("Spell_Shadow_SummonVoidWalker", false, false, false, 0);
	Felhunter = Spell.Create("Spell_Shadow_SummonFelHunter", false, false, false, 0);
	Succubus = Spell.Create("Spell_Shadow_SummonSuccubus", false, false, false, 0);

	DemonArmor = Spell.Create("Spell_Shadow_RagingScream", false, false, true, 0);
	DemonicSacrafice = Spell.Create("Spell_Shadow_PsychicScream", false, false, true, 0);
	LifeTap = Spell.Create("Spell_Shadow_BurningSpirit", false, false, true, 0);

	ShadowBolt = Spell.Create("Spell_Shadow_ShadowBolt", true, true, false, 30);
	DrainLife = Spell.Create("Spell_Shadow_LifeDrain02", true, true, false, 24);
	
	DrainSoul = Spell.Create("Spell_Shadow_Haunting", true, true, false, 30, "Rank", 1);

	Corruption = Spell.Create("Spell_Shadow_AbominationExplosion", false, true, false, 30);
	Immolate = Spell.Create("Spell_Fire_Immolation", true, true, false, 30);
	Doom = Spell.Create("Spell_Shadow_AuraOfDarkness", false, true, true, 30);
	Elements = Spell.Create("Spell_Shadow_ChillTouch", false, true, true, 36);
	Shadow = Spell.Create("Spell_Shadow_CurseOfAchimonde", false, true, true, 36);
	Exhaustion = Spell.Create("Spell_Shadow_GrimWard", false, true, true, 36);
	Agony = Spell.Create("Spell_Shadow_CurseOfSargeras", false, true, true, 36);
	SiphonLife = Spell.Create("Spell_Shadow_Requiem", false, true, true, 36);

	DeathCoil = Spell.Create("Spell_Shadow_DeathCoil", true, true, true, 36);
	Fear = Spell.Create("Spell_Shadow_Possession", false, true, false, 24);


	Nightfall = "Spell_Shadow_Twilight";

	--TalismanOfEphemeralPower = Item.Create("INV_Misc_StoneTablet_11");

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();

	--AddOption("General", "Handle Pet", true);
	AddOption("General", "Pet Assist", true, "Will make sure your pet is always attacking your current target if you switch targets");
	AddOption("General", "Demon Armor", true, "Make sure you place the highest rank Demon Armor on your bars");
	AddOption("General", "Drain Soul", true, 1, 100, 10, "Use Drain Soul on enemies below this health percent."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("General", "Fel Domination", true, 1, 4, 2, "Will use Fel Domination and summon a pet if yours dies in combat."..C.TOOLTIP_VALUE.."1.Imp, 2.Voidwalker, 3.Felhunter, 4.Succubus");
	AddOption("General", "Demonic Sacrafice", false, 1, 4, 4, "Will use Demonic Sacrifice if this is your active pet."..C.TOOLTIP_VALUE.."1.Imp, 2.Voidwalker, 3.Felhunter, 4.Succubus");
	AddOption("General", "Life Tap Usage", "header");
	AddOption("General", "Life Tap", true, "Use Life Tap if we don't have enough mana to use our next ability.");
	AddOption("General", "Life Tap Filler", true, 1, 100, 90, "Use Life Tap Filler when below this much mana"..C.TOOLTIP_VALUE.."Mana threshold.");
	AddOption("General", "Life Tap Min Health", true, 1, 100, 20, "Will not use life tap when health is below this %"..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("General", "Life Tap Repeat", true, 1, 5, 2, "Will use this number of life taps back to back if we still need mana."..C.TOOLTIP_VALUE.."Repeat threshold.");

	AddOption("Offensive", "Conflagrate", true, "Use on cooldown.");
	AddOption("Offensive", "Shadowburn", false, 1, 100, 5, "Use Shadowburn when a target is below this health percent."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Offensive", "Cooldowns", "header");
	--AddOption("Offensive", "Talisman of Ephemeral Power", true, "Will use ToEP if equipped.");
	AddOption("Offensive", "Offensive Racials", true, "Use on cooldown.");
	AddOption("Offensive", "Amplify Curse", true, "Use on cooldown.");
	AddOption("Offensive", "DoT Priority", "header");
	AddOption("Offensive", "Corruption", true, "Use Corruption.");
	AddOption("Offensive", "Curses", "header");
	AddOption("Offensive", "Curse of Doom", false, "Use Curse Of Agony.");
	AddOption("Offensive", "Curse of Elements", false, "Use Curse Of Elements.");
	AddOption("Offensive", "Curse of Shadow", false, "Use Curse Of Shadow.");
	AddOption("Offensive", "Curse of Exhaustion", false, "Use Curse Of Exhaustion.");
	AddOption("Offensive", "Curse of Agony", true, "Use Curse Of Agony.");
	AddOption("Offensive", "Immolate", true, "Use Curse Of Immolate.");
	AddOption("Offensive", "Siphon Life", true, "Use Siphon Life.");
	AddOption("Offensive", "Filler Spells", "header");
	AddOption("Offensive", "Drain Life Filler", true, 1, 100, 80, "This will use Drain Life as a filler spell when your health is below or equal to this amount."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Offensive", "Shadow Bolt Filler", true, "Use non-nightfall Shadow Bolts");
	
	AddOption("Defensive", "Drain Life", true, 1, 100, 20, "This will use Drain Life when your health is below this amount."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Defensive", "Soul Link", true, "Use Curse Of Soul Link.");
	AddOption("Defensive", "Fear", true, 8, 24, 15, "Use fear when the target gets within this distance."..C.TOOLTIP_VALUE.."Distance threshold.");
	AddOption("Defensive", "Cooldowns", "header");
	AddOption("Defensive", "Death Coil", true, 8, 36, 15, "Use death coil when the target gets within this distance."..C.TOOLTIP_VALUE.."Distance threshold.");
	AddOption("Advanced", "Modify Spell Ranks", "header");
	AddOption("Advanced", "Drain Soul Rank", "none", 1, 4, 4, "Use a different rank of Drain Soul."..C.TOOLTIP_VALUE.."Rank threshold.", DrainSoul);
	

	
	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Warlock Rotation Initialized.");
	end
		--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Affliction" or Talent.Create(2, 7, 2):Rank() > 0 and "Demonology" or Talent.Create(3, 7, 2):Rank() > 0 and "Destruction" or "Leveling or Hybrid";
	if Rotation.Spec ~= Spec then
		Rotation.Spec = Spec;
		print("|cFFFFDD11[DPSEngine]|r Rotation Tuning: "..Spec);
	end

	-- Find Attack Actions (Slot ID for Weapon = WeaponPosition // Slot ID for Bow/Wand = BowWandPosition)
	SpellBook:FindAttackActions();
	
end

function Rotation:HasDemon (SelectedDemon)
	if not SelectedDemon or not Player:PetExists() then return false; end
	local Icon = SelectedDemon == 1 and "Spell_Fire_FireBolt" or SelectedDemon == 2 and "Spell_Shadow_GatherShadows" or SelectedDemon == 3 and "Spell_Nature_Purge" or SelectedDemon == 4 and "Spell_Shadow_Curse";
	local petFound = false
	for i = 4, 7 do 
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if texture == "Interface\\Icons\\"..Icon then
			petFound = true;
		end
	end
	return petFound;
end

function Rotation:CastingHandler ()
 	if Player:IsCasting(ShadowBolt) or Player:IsCasting(Imp) or Player:IsCasting(Voidwalker) or Player:IsCasting(Felhunter) or Player:IsCasting(Succubus) then
 		return true;
 	end
 	if Player:IsCasting(Fear) or Player:IsCasting(Corruption) or Player:IsCasting(Immolate) then
 		if ShadowBolt:Cooldown() < .2 then
			Rotation.lastSpell = Player:IsCasting(Fear) and "Fear" or Player:IsCasting(Corruption) and "Corruption" or Player:IsCasting(Immolate) and "Immolate"; 
			Rotation.lastSpellTime = GetTime();
		end
		return true;
	end
	return false;
end

function Rotation:Pulse ()	


	if not Player:IsReady() or GetTime() < Rotation.SpamPrevention or (Player:Buff(DrainSoul) and Target:HealthPercentage() <= GetOptionValue("Drain Soul")) then
		return;
	end

	Rotation.SpamPrevention = GetTime() + 0.05;

	-- Pause While Casting
	if self:CastingHandler() then return; end

	if Player:IsInCombat() then	

		self:Defensives();
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not DemonArmor:IsOnCooldown() then

			if Rotation.CooldownTriggered and (not BowWandPosition or not IsAutoRepeatAction(BowWandPosition)) then
				Rotation.CooldownTriggered = false;
				Rotation.SpamPrevention = GetTime() + 0.1;
				return;
			end

			Rotation.CooldownTriggered = false;

			self:Combat();
			return;
		else
			Rotation.CooldownTriggered = true;
		end
	else
		self:OutOfCombat();
	end
end

-- Defensive Abilities that are not on GCD
function Rotation:Defensives ()

end


-- Abilities that are not on GCD
function Rotation:OffGCDAbilities ()
end

-- Abilities that are not on GCD
function Rotation:ShouldLifeTap ()
	return IsOptionEnabled("Life Tap") and Player:HealthPercentage() > GetOptionValue("Life Tap Min Health") and Player:CanCast(LifeTap);
end

-- Tables will be refreshed every 0.5s from the Pulse
function Rotation:UnitTables ()
	if UseAOE() and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		Enemies_5y, NumEnemies_5y = Target:EnemiesWithinDistance(5, true);
	else
		Enemies_5y, NumEnemies_5y = { Target }, 1;
	end
end


function Rotation:Combat ()

	-- Demon Armor
	if IsOptionEnabled("Demon Armor") and not Player:Buff(DemonArmor) then
		if Player:CanCast(DemonArmor) then 
			Player:Cast(DemonArmor);
			return;
		elseif DemonArmor:NeedsResources() and self:ShouldLifeTap() then
			Player:Cast(LifeTap);
			return;
		end
	end

	if IsOptionEnabled("Soul Link") and SoulLink:Exists() and not Player:Buff(SoulLink) and Player:PetExists() and Player:CanCast(SoulLink) then
		Player:Cast(SoulLink);
		return;
	end

	if IsOptionEnabled("Fel Domination") and FelDomination:Exists() and not Player:Buff(FelDomination) and (not Player:PetExists() and (not IsOptionEnabled("Demonic Sacrafice") or not Player:Buff(DemonicSacrafice))) and Player:CanCast(FelDomination) then
		Player:Cast(FelDomination);
	end

	if Player:Buff(FelDomination) and IsOptionEnabled("Fel Domination") then
		local SelectedPet = GetOptionValue("Fel Domination");
		local summonPet = (SelectedPet == 2 and Voidwalker) or (SelectedPet == 3 and Felhunter) or (SelectedPet == 4 and Succubus) or Imp;
		if summonPet:Exists() and Player:CanCast(summonPet) then
			Player:Cast(summonPet);
			return;
		elseif Player:CanCast(Imp) then
			Player:Cast(Imp);
			return;
		end
	end

	if IsOptionEnabled("Demonic Sacrafice") and DemonicSacrafice:Exists() and not Player:Buff(DemonicSacrafice) and Player:PetExists() and Rotation:HasDemon(GetOptionValue("Demonic Sacrafice")) then
		Player:Cast(DemonicSacrafice);
	end

	-- Check if Target is valid
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer()) and ShadowBolt:IsInRange() then
		--Pet Attack
		if IsOptionEnabled("Pet Assist") and Player:PetExists() and Rotation.petAttack == false then		
			PetAttack();
			Rotation.petAttack = true;
		end

		if not IsOptionEnabled("Drain Soul") and not Player:IsMoving() and Target:HealthPercentage() <= GetOptionValue("Drain Soul") and not Target:IsTrivial() and not Voidwalker:NeedsResources() and not Voidwalker:IsUsable() then
			if Target:CanCast(DrainSoul) then
				Target:Cast(DrainSoul);
				return;
			elseif DrainSoul:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end
		--Drail soul
		if IsOptionEnabled("Drain Soul") and not Player:IsMoving() and Target:HealthPercentage() <= GetOptionValue("Drain Soul") and not Target:IsTrivial() then
			if Target:CanCast(DrainSoul) then
				Target:Cast(DrainSoul);
				return;
			elseif DrainSoul:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		if CooldownsAllowed() and (Player:Buff(Nightfall, true) or (Rotation.LifeTapCasted == 0 or Rotation.LifeTapCasted >= GetOptionValue("Life Tap Repeat"))) then
			-- Blood Fury
			if IsOptionEnabled("Offensive Racials") and Player:CanCast(BloodFury) then
				Player:Cast(BloodFury);
				return;
			end
			--Berserking
			if IsOptionEnabled("Offensive Racials") and Player:CanCast(Berserking) then
				Player:Cast(Berserking);
				return;
			end
			-- Talisman Of Ephemeral Power
			--[[if IsOptionEnabled("Talisman of Ephemeral Power") and TalismanOfEphemeralPower:IsUsable() then
				Player:UseItem(TalismanOfEphemeralPower);
			end]]
		end

		--Shadowburn
		if IsOptionEnabled("Shadowburn") and Shadowburn:Exists() then
			if Target:CanCast(Shadowburn) and Target:HealthPercentage() < GetOptionValue("Shadowburn") then
				Target:Cast(Shadowburn);
				return;
			elseif Shadowburn:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Nightfall Shadow Bolt Procs
		if Player:Buff(Nightfall, true) then
			if Target:CanCast(ShadowBolt, _, _, true) then
				Target:Cast(ShadowBolt);
				return;
			elseif ShadowBolt:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Death Coil
		if IsOptionEnabled("Death Coil") and CooldownsAllowed() and not Target:Debuff(Fear) and Player:DistanceTo(Target) <= GetOptionValue("Death Coil") then
			if Target:CanCast(DeathCoil) then
				Target:Cast(DeathCoil);
				return;
			elseif DeathCoil:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Conflagrate
		if IsOptionEnabled("Conflagrate") and Target:Debuff(Immolate) then
			if Target:CanCast(Conflagrate) then
				Target:Cast(Conflagrate);
				return;
			elseif Conflagrate:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Drain Live Defensive
		if IsOptionEnabled("Drain Life") and not Player:IsMoving() and Player:HealthPercentage() <= GetOptionValue("Drain Life") and Target:CanCast(DrainLife) then
			Target:Cast(DrainLife);
			return;
		end

		--Life Tap Repeat
		if IsOptionEnabled("Life Tap Repeat") and Rotation.LifeTapCasted > 0 and Rotation.LifeTapCasted < GetOptionValue("Life Tap Repeat") and self:ShouldLifeTap() and Player:CanCast(LifeTap) then
			Rotation.LifeTapCasted = Rotation.LifeTapCasted + 1;
			Player:Cast(LifeTap);
			return;
		end
		--Resetting the Life Tap Repeat Timer
		Rotation.LifeTapCasted = 0;
		--Fear
		if IsOptionEnabled("Fear") and not Player:IsMoving() and not Target:Debuff(Fear) and Player:DistanceTo(Target) <= GetOptionValue("Fear") and (Rotation.lastSpell ~= "Fear" or GetTime()-Rotation.lastSpellTime > 0.5) and (not Rotation.FearUnit or not Target:Debuff(Fear, Rotation.FearUnit)) and Player:IsUnit(TargetTarget) then
			if Target:CanCast(Fear) then
				Rotation.FearUnit = PlayerTargetGuid();
				Target:Cast(Fear);
				return;
			elseif Fear:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end
		
		--Corruption
		
		if IsOptionEnabled("Corruption") and not Target:Debuff(Corruption) and (Rotation.lastSpell ~= "Corruption" or GetTime()-Rotation.lastSpellTime > 0.5) then
			local bypassMoving = Talent.Create(1, 1, 3):Rank() > 4 and true or false;
			if Target:CanCast(Corruption, _, _, bypassMoving) then
				Rotation.CorruptionCasting = true;
				Target:Cast(Corruption);
				return;
			elseif Corruption:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Curses
		local Curse = (IsOptionEnabled("Curse of Doom") and Doom) or (IsOptionEnabled("Curse of Elements") and Elements) or (IsOptionEnabled("Curse of Shadow") and Shadow) or (IsOptionEnabled("Curse of Exhaustion") and Exhaustion) or (IsOptionEnabled("Curse of Agony") and Agony) or nil;
		if Curse and not Target:Debuff(Curse) then
			if Target:CanCast(Curse) then
				if IsOptionEnabled("Amplify Curse") and CooldownsAllowed() and Player:CanCast(AmplifyCurse) then
					Player:Cast(AmplifyCurse);
				end
				Target:Cast(Curse);
				return;
			elseif Curse:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Immolate
		if IsOptionEnabled("Immolate") and not Player:IsMoving() and not Target:Debuff(Immolate) and (Rotation.lastSpell ~= "Immolate" or GetTime()-Rotation.lastSpellTime > 0.5) then
			if Target:CanCast(Immolate) then
				Rotation.ImmolateCasting = true;
				Target:Cast(Immolate);
				return;
			elseif Immolate:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Siphon Life
		if IsOptionEnabled("Siphon Life") and not Target:Debuff(SiphonLife) then
			if Target:CanCast(SiphonLife) then
				Target:Cast(SiphonLife);
				return;
			elseif SiphonLife:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Don't Interrupt Drain Life Channels with other fillers
		if Target:Debuff(DrainLife) then
			return;
		end

		--Drain Life Filler
		if IsOptionEnabled("Drain Life Filler") and not Player:IsMoving() and Player:HealthPercentage() <= GetOptionValue("Drain Life Filler") then
			if Target:CanCast(DrainLife) then
				Target:Cast(DrainLife);
				return;
			elseif DrainLife:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Shadow Bolt Filler
		if IsOptionEnabled("Shadow Bolt Filler") and not Player:IsMoving() then
			if Target:CanCast(ShadowBolt) then
				Target:Cast(ShadowBolt);
				return;
			elseif ShadowBolt:NeedsResources() and self:ShouldLifeTap() then
				Rotation.LifeTapCasted = 1;
				Player:Cast(LifeTap);
				return;
			end
		end

		--Life Tap Filler
		if IsOptionEnabled("Life Tap Filler") and Player:ManaPercentage() < GetOptionValue("Life Tap Filler") and Player:HealthPercentage() > GetOptionValue("Life Tap Min Health") and Player:CanCast(LifeTap) then
			Player:Cast(LifeTap);
			return;
		end

		--Wand
		--Wand / Melee
		if IsOptionEnabled("Auto Shot / Attack") then
			if GetTime() - Rotation.shotTime > 1 and BowWandPosition and not IsAutoRepeatAction(BowWandPosition) and IsActionInRange(BowWandPosition) == 1 and not Player:IsMoving() then
				UseAction(BowWandPosition);
				Rotation.shotTime = GetTime();
			end
			if not BowWandPosition or not IsActionInRange(BowWandPosition) == 1 then
				if WeaponPosition and not IsCurrentAction(WeaponPosition) then
					UseAction(WeaponPosition);
				end
			end
		end
	end
end

function Rotation:OutOfCombat ()
	-- Demon Armor
	if IsOptionEnabled("Demon Armor") and Player:CanCast(DemonArmor) and not Player:Buff(DemonArmor) then
		Player:Cast(DemonArmor);
		return;
	end

	--Soul Link
	if IsOptionEnabled("Soul Link") and SoulLink:Exists() and not Player:Buff(SoulLink) and Player:PetExists() and Player:CanCast(SoulLink) then
		Player:Cast(SoulLink);
		return;
	end

	--Initiate Combat
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and IsOptionEnabled("Initiate Combat") then
		self:Combat();
	end
end