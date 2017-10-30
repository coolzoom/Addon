--- Rogue
Rotations.ROGUE = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	Energy = 0,
	End = 0,
	Start = 0,
	Tick = 2,
	Spec = "None",
	Activated = false
};
local Rotation = Rotations.ROGUE;
function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Racials
	BloodFury = Spell.Create("Racial_Orc_BerserkerStrength", false, false, true, 0, "Racial");
	Berserking = Spell.Create("Racial_Troll_Berserk", false, false, true, 0, "Racial");
	-- Assassination
	ColdBlood = Spell.Create("Spell_Ice_Lament", false, false, true);
	Ambush = Spell.Create("Ability_Rogue_Ambush", true, true, true, 5);
	CheapShot = Spell.Create("Ability_CheapShot", true, true, true, 5);
	Eviscerate = Spell.Create("Ability_Rogue_Eviscerate", true, true, true, 5);
	ExposeArmor = Spell.Create("Ability_Warrior_Riposte", true, true, true, 5);
	-- Garrote = Spell.Create("Ability_Rogue_Garrote", true, true, true, 5);
	KidneyShot = Spell.Create("Ability_Rogue_KidneyShot", true, true, true, 5);
	-- Rupture = Spell.Create("Ability_Rogue_Rupture", true, true, true, 5);
	SliceAndDice = Spell.Create("Ability_Rogue_SliceDice", false, false, true, 0);
	-- Combat
	AdrenalineRush = Spell.Create("Spell_Shadow_ShadowWordDominate", false, false, true, 0);
	Backstab = Spell.Create("Ability_BackStab", true, true, true, 5);
	BladeFlurry = Spell.Create("Ability_Warrior_PunishingBlow", false, false, true, 0);
	Evasion = Spell.Create("Spell_Shadow_ShadowWard", false, false, true, 0);
	-- Feint = Spell.Create("Ability_Rogue_Feint", false, false, true, 0);
	Gouge = Spell.Create("Ability_Gouge", true, true, true, 5);
	Kick = Spell.Create("Ability_Kick", true, true, true, 5);
	Riposte = Spell.Create("Ability_Warrior_Challange", true, true, true, 5);
	SinisterStrike = Spell.Create("Spell_Shadow_RitualOfSacrifice");
	-- Sprint = Spell.Create("Ability_Rogue_Sprint", false, false, true, 0);
	-- Subtlety
	-- Blind = Spell.Create("Spell_Shadow_MindSteal");
	-- DetectTraps = Spell.Create("Ability_Spy");
	-- DisarmTraps = Spell.Create("Spell_Shadow_GrimWard");
	-- Distract = Spell.Create("Ability_Rogue_Distract");
	-- PickPocket = Spell.Create("INV_Misc_Bag_11");
	-- SafeFall = Spell.Create("INV_Feather_01");
	-- Sap = Spell.Create("Ability_Sap", true, true, true, 5);
	Stealth = Spell.Create("Ability_Stealth", false, false, true, 0, nil, "Spell_Nature_Invisibilty");
	-- Vanish = Spell.Create("Ability_Vanish", false, false, true, 0);

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();

	AddOption("General", "Interrupt", true, "Use Kick to interrupt our current target.");
	AddOption("General", "Stealth", false, "Enable to use Stealth when leaving combat.");
	AddOption("General", "Cheap Shot", true, "Enable the use of Cheap Shot, otherwise will use Ambush.");

	AddOption("Offensive", "Cooldowns", "header");
	AddOption("Offensive", "Cold Blood", true, "Will use with Eviscerate.");
	AddOption("Offensive", "Adrenaline Rush", true, "Use on cooldown.");
	AddOption("Offensive", "Blade Flurry", true, 1, 10, 2, "Use on cooldown."..C.TOOLTIP_VALUE.."Amount of units that need to be in Melee Range to use.");
	AddOption("Offensive", "Offensive Racials", false, "Use on cooldown.");
	AddOption("Offensive", "Abilities", "header");
	AddOption("Offensive", "Gouge", true, "Will use gouge when in front of a unit.");
	AddOption("Offensive", "Expose Armor", false, "Use with 5 Combo Points when the debuff is not on our target.");
	AddOption("Offensive", "Kidney Shot", true, "Use with 5 Combo Points.");
	AddOption("Offensive", "Backstab Pooling", true, "If enabled, will pool energy before using abilities like Kidney Shot and Gouge to maximize backstab. Will also wait until enery is about to tick before using Cheap Shot.");
	AddOption("Offensive", "Slice And Dice", true, "Use with 5 Combo Points when the buff is not on us or 2 combo points entering combat.");

	AddOption("Defensive", "Cooldowns", "header");
	AddOption("Defensive", "Evasion", true, 1, 100, 35, "Use when we get Low Health."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Defensive", "Abilities", "header");
	AddOption("Defensive", "Riposte", false, "Use when we get procs");

	
	-- Swords
	-- http://db.vanillagaming.org/?talent#f0efoxZMhqbbVzxfo
	-- Daggers
	-- http://db.vanillagaming.org/?talent#f0xfoLZMIVbbEz0boV
	-- AddOption("General", "Spec 3: Subtlety", "header");
	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Rogue Rotation Initialized.");
	end

	--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Assassination" or Talent.Create(2, 7, 2):Rank() > 0 and "Combat" or Talent.Create(3, 7, 2):Rank() > 0 and "Subtlety - Not Supported" or "Leveling or Hybrid";
	if Rotation.Spec ~= Spec then
		Rotation.Spec = Spec;
		print("|cFFFFDD11[DPSEngine]|r Rotation Tuning: "..Spec);
	end
	-- Find Attack Actions (Slot ID for Weapon = WeaponPosition // Slot ID for Bow/Wand = BowWandPosition)
	SpellBook:FindAttackActions();
end


function Rotation:UpdateEnergy ()
	local Energy = UnitMana("player");
	local Status = GetTime();
		
	if( Energy > Rotation.Energy or Status >= Rotation.End) then		
		
		Rotation.Energy = Energy;
		Rotation.Start = Status;
		Rotation.End = Status + Rotation.Tick;
	else
		if( Rotation.Energy ~= Energy ) then
			Rotation.Energy = Energy;
		end
	end

end

function Rotation:NextEnergy ()
	return Rotation.End - GetTime();
end

function Rotation:Pulse ()
	self:UpdateEnergy();
	if not Player:IsReady() or GetTime() < Rotation.SpamPrevention then
		return;
	end

	Rotation.SpamPrevention = GetTime() + 0.05;

	if Player:IsInCombat() then	
		self:Defensives();
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not SinisterStrike:IsOnCooldown() then
			self:Combat();
			return;
		end
	else
		self:OutOfCombat();
	end
end

-- Defensive Abilities that are not on GCD
function Rotation:Defensives ()
	-- Evasion
	if Evasion:Exists() and not Evasion:IsOnCooldown() and IsOptionEnabled("Evasion") and Player:HealthPercentage() < GetOptionValue("Evasion") then
		Player:Cast(Evasion);
	end
end

-- Abilities that are not on GCD
function Rotation:OffGCDAbilities ()
	if IsOptionEnabled("Cold Blood") and CooldownsAllowed() and ((Player:ComboPoints() >= 5 and (not IsOptionEnabled("Kidney Shot") or KidneyShot:Cooldown() > 3)) or (Player:ComboPoints() >= 2 and Target:HealthPercentage() < 15 and Target:TimeToDie() < 7)) and Player:CanCast(ColdBlood) and Eviscerate:Cooldown() < .5 then
		Player:Cast(ColdBlood);
	end
	-- Check if Target is valid
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		-- Riposte
		if IsOptionEnabled("Riposte") and Target:CanCast(Riposte) then
			Target:Cast(Riposte);
			return;
		end
	end
end

-- Tables will be refreshed every 0.5s from the Pulse
function Rotation:UnitTables ()
	if UseAOE() then
		Enemies_5y, NumEnemies_5y = Player:EnemiesWithinDistance(5, true);
	else
		Enemies_5y, NumEnemies_5y = {}, 0;
	end
end

-- 
function Rotation:Combat ()
	-- Check if Target is valid
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer()) then
		-- Check if Target is in range
		if Player:DistanceTo(Target) <= 5 then

			-- Interrupt with Kick
			if Target:UseInterrupt(Kick) then
				return;
			end
			if Player:Buff(Stealth) then
				-- Cheap Shot
				if IsOptionEnabled("Cheap Shot") and Stealth:Exists() and Player:Buff(Stealth) and Target:CanCast(CheapShot) then
					if Rotation:NextEnergy() > .2 then
						return;
					end
					Target:Cast(CheapShot);
					return;
				end

				-- Ambush
				if Stealth:Exists() and Player:Buff(Stealth) and Target:CanCast(Ambush) and Player:IsBehind(Target) then
					Target:Cast(Ambush);
					return;
				end
				return;
			end
			local energyVariable = IsOptionEnabled("Backstab Pooling") and Player:MainHandType() == "Dagger" and 20 or 0;
			if IsOptionEnabled("Gouge") and not Player:IsBehind(Target) and Target:CanCast(Gouge) and Player:ComboPoints() < 5 and not Target:Debuff(KidneyShot) and not Target:Debuff(CheapShot) and Player:Energy() >= 45 + energyVariable and Rotation:NextEnergy() < 1.5 then
				Target:Cast(Gouge);
				return;
			end
			--Enable Auto Attack
			if IsOptionEnabled("Auto Attack") and WeaponPosition and not IsCurrentAction(WeaponPosition) and not Player:Buff(Stealth) and not Target:Debuff(Gouge) then
				UseAction(WeaponPosition);
			end
			if CooldownsAllowed() then
				-- Adrenaline Rush
				if IsOptionEnabled("Adrenaline Rush") and Player:CanCast(AdrenalineRush) then
					Player:Cast(AdrenalineRush);
					return;
				end
				-- Blade Flurry
				if IsOptionEnabled("Blade Flurry") and NumEnemies_5y >= GetOptionValue("Blade Flurry") and Player:CanCast(BladeFlurry) then
					Player:Cast(BladeFlurry);
					return;
				end
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
			end
			local comboPoints = Player:ComboPoints();
			-- Expose Armor
			if IsOptionEnabled("Expose Armor") and Target:CanCast(ExposeArmor) and comboPoints >= 5 and not Target:Debuff(ExposeArmor) then
				Target:Cast(ExposeArmor);
				return;
			end
			if not IsOptionEnabled("Expose Armor") or Target:Debuff(ExposeArmor) or not ExposeArmor:Exists() then
				if IsOptionEnabled("Kidney Shot") and comboPoints >= 5 and Target:CanCast(KidneyShot) and (not IsOptionEnabled("Backstab Pooling") or Player:Energy() >= Player:EnergyMax()-20) and Rotation:NextEnergy() > 1.5 and not Target:Debuff(Gouge) and not Target:Debuff(CheapShot) then
					Target:Cast(KidneyShot);
					return;
				end

				-- Slice And Dice
				if IsOptionEnabled("Slice And Dice") and Player:CanCast(SliceAndDice) and Player:BuffDuration(SliceAndDice) < 3 and ((CombatTime() < 10 and comboPoints >= 2) or (comboPoints >= 5 and not UnitIsPlayer(Target.UnitID))) then
					SliceAndDiceBuffEnds = GetTime()+(6+(3*comboPoints));
					Target:Cast(SliceAndDice);
					return;
				end

				-- Eviscerate
				if Target:CanCast(Eviscerate) and ((Player:Level() < 10 and comboPoints >= 2) or (comboPoints >= 5 and (not IsOptionEnabled("Kidney Shot") or KidneyShot:IsOnCooldown())) or (comboPoints >= 2 and Target:HealthPercentage() < 20 and Target:TimeToDie() < 7)) then
					Target:Cast(Eviscerate);
					return;
				end
			end

			if Player:ComboPoints() < 5 then
				-- Backstab
				if Target:CanCast(Backstab) and Backstab:TimeSinceCast() >= 0.3 and Player:IsBehind(Target) then
					BackstabAttempt = GetTime() + 0.3;
					Target:Cast(Backstab);
					return;
				end
				-- Sinister Strike
				if Target:CanCast(SinisterStrike) and (Player:EnergyPercentage() >= 80 or Player:MainHandType() ~= "Dagger" or (Target:HealthPercentage() < 15 and Target:TimeToDie() < 7)) then
					Target:Cast(SinisterStrike);
					return;
				end
			end
		end
	end
end

function Rotation:OutOfCombat ()
	-- Stealth
	if IsOptionEnabled("Stealth") and not Player:Buff(Stealth) and Player:CanCast(Stealth) then
		Player:Cast(Stealth);
		return;
	end
	--Enable Auto Attack
	if IsOptionEnabled("Initiate Combat") then
		self:Combat();
	end

end