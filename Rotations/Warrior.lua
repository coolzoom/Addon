--- Warrior
Rotations.WARRIOR = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	Spec = "None",
	Activated = false
};
local Rotation = Rotations.WARRIOR;
function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Racials
	BloodFury = Spell.Create("Racial_Orc_BerserkerStrength", false, false, true, 0, "Racial");
	Berserking = Spell.Create("Racial_Troll_Berserk", false, false, true, 0, "Racial");
	-- Arms
	BattleStance = Spell.Create("Ability_Warrior_OffensiveStance", false, false, true, 0);
	Charge = Spell.Create("Ability_Warrior_Charge", true, true, true, 31);
	Hamstring = Spell.Create("Ability_ShockWave", true, true, true, 5);
	HeroicStrike = Spell.Create("Ability_Rogue_Ambush", true, true, true, 5);
	MockingBlow = Spell.Create("Ability_Warrior_PunishingBlow", true, true, true, 5);
	MortalStrike = Spell.Create("Ability_Warrior_SavageBlow", true, true, true, 5);
	Overpower = Spell.Create("Ability_MeleeDamage", true, true, true, 5);
	Rend = Spell.Create("Ability_Gouge", true, true, true, 5);
	-- Retaliation = Spell.Create("Ability_Warrior_Challange", false, false, true, 0);
	SweepingStrikes = Spell.Create("Ability_Rogue_SliceDice", false, false, true, 0);
	ThunderClap = Spell.Create("Spell_Nature_ThunderClap", false, false, true, 0);
	-- Fury
	BattleShout = Spell.Create("Ability_Warrior_BattleShout", false, false, true, 0);
	BerserkerRage = Spell.Create("Spell_Nature_AncestralGuardian", false, false, true, 0);
	BerserkerStance = Spell.Create("Ability_Racial_Avatar", false, false, true, 0);
	Bloodthirst = Spell.Create("Spell_Nature_BloodLust", true, true, true, 5);
	-- ChallengingShout = Spell.Create("Ability_BullRush", false, false, true, 0);
	Cleave = Spell.Create("Ability_Warrior_Cleave", true, true, true, 5);
	DeathWish = Spell.Create("Spell_Shadow_DeathPact", false, false, true, 0)
	DemoralizingShout = Spell.Create("Ability_Warrior_WarCry", false, false, true, 0);
	Execute = Spell.Create("INV_Sword_48", true, true, true, 5);
	Intercept = Spell.Create("Ability_Rogue_Sprint", true, true, true, 25);
	-- IntimidatingShout = Spell.Create("Ability_GolemThunderClap", false, false, true, 0);
	-- PiercingHowl = Spell.Create("Spell_Shadow_DeathScream", false, false, true, 0);
	Pummel = Spell.Create("INV_Gauntlets_04", true, true, true, 5);
	Recklessness = Spell.Create("Ability_CriticalStrike", false, false, true, 0);
	Slam = Spell.Create("Ability_Warrior_DecisiveStrike", true, true, true, 5);
	Whirlwind = Spell.Create("Ability_Whirlwind", false, false, true, 0);
	-- Protection
	Bloodrage = Spell.Create("Ability_Racial_BloodRage", false, false, true, 0);
	ConcussionBlow = Spell.Create("Ability_ThunderBolt", true, true, true, 5);
	DefensiveStance = Spell.Create("Ability_Warrior_DefensiveStance", false, false, true, 0);
	Disarm = Spell.Create("Ability_Warrior_Disarm", true, true, true, 5);
	LastStand = Spell.Create("Spell_Holy_AshesToAshes", false, false, true, 0);
	Revenge = Spell.Create("Ability_Warrior_Revenge", true, true, true, 5);
	ShieldBash = Spell.Create("Ability_Warrior_ShieldBash", true, true, true, 5);
	ShieldBlock = Spell.Create("Ability_Defend", false, false, true, 0);
	ShieldSlam = Spell.Create("INV_Shield_05", true, true, true, 5);
	ShieldWall = Spell.Create("Ability_Warrior_ShieldWall", false, false, true, 0);
	SunderArmor = Spell.Create("Ability_Warrior_Sunder", true, true, true, 5);
	Taunt = Spell.Create("Spell_Nature_Reincarnation", true, true, true, 5);

	-- Talents
	ImprovedHeroicStrike = Talent.Create(1, 1, 1);

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();

	AddOption("General", "Interrupt", true, "Use Pummel or Shield Bash to interrupt our current target.");
	AddOption("General", "Battle Shout", true, "Use Battle Shout on ourself when do not have the buff.");
	AddOption("General", "Charge", true, "Use Charge when targetting an enemy units while Out of Combat.");
	AddOption("General", "Intercept", true, "Use Intercept when targetting an enemy units while Out of Combat.");
	AddOption("General", "Stances", "header");
	AddOption("General", "Auto Stance", true, "Use Battle Stance when Berserker Stance does not Exists or we need to use Overpower. Use Berserker Stance otherwise.");
	AddOption("General", "Protection Settings", "header");
	AddOption("General", "Protection", false, "Use the Protection rotation. Every Abilities under this option will only be used if the Protection option is enabled.");
	AddOption("General", "Concussion Blow", false, 1, 100, 35, "Use on cooldown."..C.TOOLTIP_VALUE.."Rage threshold.");
	AddOption("General", "Concussion Blow Interrupt", false, "Use to interrupt spell casts.");
	AddOption("General", "Mocking Blow", false, "Use when the current target does not target the player.");
	AddOption("General", "Shield Block", true, 1, 100, 80, "Use Shield Block."..C.TOOLTIP_VALUE.."Health threshold under which we should start using it.");
	AddOption("General", "Shield Slam", true, 1, 100, 40, "Use Shield Slam."..C.TOOLTIP_VALUE.."Rage threshold.");
	AddOption("General", "Sunder Armor", true, "Use when the current target does not have 5 Sunder Armor debuffs.");
	AddOption("General", "Taunt", false, "Use when the current target does not target the player.");

	AddOption("Offensive", "Cooldowns", "header");
	AddOption("Offensive", "Berserker Rage", true, "Use on cooldown when we are in Berserker Stance.");
	AddOption("Offensive", "Bloodrage", true, "Use on cooldown.");
	AddOption("Offensive", "Death Wish", true, "Use on cooldown when we are in Berserker Stance.");
	AddOption("Offensive", "Recklessness", true, "Use on cooldown when we are in Berserker Stance.");
	AddOption("Offensive", "Offensive Racials", false, "Use on cooldown.");
	AddOption("Offensive", "Sweeping Strikes", true, 1, 100, 50, "Use when 2 or more enemies are around and above this rage"..C.TOOLTIP_VALUE.."Rage threshold.");
	AddOption("Offensive", "Abilities", "header");
	AddOption("Offensive", "Mortal Strike", true, "Use on cooldown.");
	AddOption("Offensive", "Hamstring", false, "Maintain Hamstring.");
	AddOption("Offensive", "Rend", false, "Apply Rend to the current target.");
	AddOption("Offensive", "Cleave / Strike", true, 15, 100, 60, "Use Heroic Strike and Cleave."..C.TOOLTIP_VALUE.."Minimum amount of Rage needed to use. We recommand keeping this value at least 20 while soling to allow good usage of Overpower procs. We Recommand 60 for raiding.");

	AddOption("Defensive", "Cooldowns", "header");
	AddOption("Defensive", "Defensive Stance", false, 1, 100, 20, "Use when we get Low Health."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Defensive", "Abilities", "header");
	AddOption("Defensive", "Demoralizing Shout", false, 1, 100, 80, "Debuff Demoralizing Shout on our Target."..C.TOOLTIP_VALUE.."Health threshold under which we should start using it");
	AddOption("Defensive", "Last Stand", false, 1, 100, 80, "USe Last Stand when low health."..C.TOOLTIP_VALUE.."Health threshold under which we should use it.");
	AddOption("Defensive", "Thunder Clap", false, 1, 100, 80, "Debuff Thunder Clap on our Target."..C.TOOLTIP_VALUE.."Health threshold under which we should start using it.");

	-- Dual Sword
	-- http://db.vanillagaming.org/?talent#LbhxbhbZVV0VgxoVo
	-- Two Hander
	-- http://db.vanillagaming.org/?talent#LbhxbIbZVVbVMxoVo
	-- AddOption("General", "Spec 3: Protection", "none");
	ShouldOverpower = 0;
	LastRendedTargetGUID = nil;
	NextRendTime = 0;
	--Rotation Notification
	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Warrior Rotation Initialized.");
	end
	
	--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Arms" or Talent.Create(2, 7, 2):Rank() > 0 and "Fury - Disable Rend for more Berserker Stance uptime" or Talent.Create(3, 7, 2):Rank() > 0 and "Protection - Enable the Protection option in the General Settings to use the Protection rotation." or "Leveling or Hybrid";
	if Rotation.Spec ~= Spec then
		Rotation.Spec = Spec;
		print("|cFFFFDD11[DPSEngine]|r Rotation Tuning: "..Spec);
	end
	-- Find Attack Actions (Slot ID for Weapon = WeaponPosition // Slot ID for Bow/Wand = BowWandPosition)
	SpellBook:FindAttackActions();
end

function Rotation:Pulse ()
	if not Player:IsReady() or GetTime() < Rotation.SpamPrevention then
		return;
	end

	Rotation.SpamPrevention = GetTime() + 0.5;

	if Player:IsInCombat() then	
		self:Defensives();
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not BattleStance:IsOnCooldown() then
			self:Combat();
			return;
		end
	else
		self:OutOfCombat();
	end
end

-- Defensive Abilities that are not on GCD
function Rotation:Defensives ()
	-- Defensive Stance
	if DefensiveStance:Exists() and Player:Stance() ~= 3 and not DefensiveStance:IsOnCooldown() and IsOptionEnabled("Defensive Stance") and Player:HealthPercentage() < GetOptionValue("Defensive Stance") then
		Player:Cast(DefensiveStance);
		return;
	end
end

-- Berserker Stance
local PreventShapeShift = 0;
function Rotation:ChangeStance (Option1, Option2)
	-- Do not change Stance if we should remain in defensive
	if not DefensiveStance:Exists() or Player:Stance() ~= 3 or DefensiveStance:IsOnCooldown() or not IsOptionEnabled("Defensive Stance") or Player:HealthPercentage() > GetOptionValue("Defensive Stance") + 10 then
		if IsOptionEnabled("Auto Stance") and PreventShapeShift < GetTime() then
			if Option1 == 1 and Player:Stance() ~= 1 and Option2 ~= Player:Stance() then
				if Player:CanCast(BattleStance) then
					Player:Cast(BattleStance);
					PreventShapeShift = GetTime() + 1;
					return;
				end
			elseif Option1 == 2 and Player:Stance() ~= 2 and Option2 ~= Player:Stance() then
				if Player:CanCast(BerserkerStance) then
					Player:Cast(BerserkerStance);
					PreventShapeShift = GetTime() + 1;
					return;
				end
			elseif Option1 == 3 and Player:Stance() ~= 3 and Option2 ~= Player:Stance() then
				if Player:CanCast(DefensiveStance) then
					Player:Cast(DefensiveStance);
					PreventShapeShift = GetTime() + 1;
					return;
				end
			end
		end
	end
end

-- Abilities that are not on GCD
function Rotation:OffGCDAbilities ()
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and Player:DistanceTo(Target) <= 5 then

		if IsOptionEnabled("Sweeping Strikes") and NumEnemies_5y >= 2 and CooldownsAllowed() and Player:Rage() >= GetOptionValue("Sweeping Strikes") and Player:CanCast(SweepingStrikes) and Target:CanCast(MortalStrike) then
			Player:Cast(SweepingStrikes);
		end

		--Prevent spamming an already selected global
		if Overpower:IsBeingCasted() or Cleave:IsBeingCasted() or Hamstring:IsBeingCasted() or MortalStrike:IsBeingCasted() or HeroicStrike:IsBeingCasted() then
			return;
		end


		-- Priorise Overpower
		if not Overpower:Exists() or not (ShouldOverpower > GetTime() and (Player:Stance() == 1 or (not Bloodthirst:Exists() or Bloodthirst:Cooldown() > 3) and (not Whirlwind:Exists() or Whirlwind:Cooldown() > 3) and Player:Rage() < 45)) or Player:Rage() > 40 then
			local HSPoints = NumEnemies_5y >= 2 and 0 or ImprovedHeroicStrike:Rank();
			-- Heroic Strike / Cleave
			if IsOptionEnabled("Cleave / Strike") and (Player:Rage() >= (GetOptionValue("Cleave / Strike")-HSPoints) or (NumEnemies_5y >= 2 and Player:Buff(SweepingStrikes))) and Target:HealthPercentage() > 20 then
				if NumEnemies_5y >= 2 then
					-- Cleave
					if Target:CanCast(Cleave) then
						Target:Cast(Cleave);
						return;
					end
				else
					-- Heroic Strike
					if Target:CanCast(HeroicStrike) then
						Target:Cast(HeroicStrike);
						return;
					end
				end
			end
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

-- Combat
function Rotation:Combat ()

	local targetExists = Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer());

	-- Interrupt with Pummel
	if Player:Stance() == 2 and Target:UseInterrupt(Pummel) then
		return;
	end

	--Overpower
	if targetExists and Target:CanCast(Overpower) then			
		Target:Cast(Overpower);
		return;
	end

	-- Battle Shout
	if IsOptionEnabled("Battle Shout") and Player:CanCast(BattleShout) and not Player:Buff(BattleShout) then
		Player:Cast(BattleShout);
		return;
	end

	-- Check if Target is valid
	if targetExists then
		-- Check if Target is in range

		--Enable Auto Attack
		if IsOptionEnabled("Auto Attack") and WeaponPosition and not IsCurrentAction(WeaponPosition) then
			UseAction(WeaponPosition);
		end

		if Player:DistanceTo(Target) <= 5 then

			if CooldownsAllowed() then
				-- Death Wish
				if IsOptionEnabled("Death Wish") and Player:CanCast(DeathWish) then
					Player:Cast(DeathWish);
					return;
				end
				-- Berserker Rage
				if IsOptionEnabled("Berserker Rage") and Player:CanCast(BerserkerRage) then
					Player:Cast(BerserkerRage);
					return;
				end
				-- Bloodrage
				if IsOptionEnabled("Bloodrage") and Player:CanCast(Bloodrage) then
					Player:Cast(Bloodrage);
					return;
				end
				-- Recklessness
				if IsOptionEnabled("Recklessness") and Player:CanCast(Recklessness) then
					Player:Cast(Recklessness);
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

			-- Last Stand
			if IsOptionEnabled("Last Stand") and Player:HealthPercentage() <= GetOptionValue("Last Stand") and Player:CanCast(LastStand) then
				Player:Cast(LastStand);
				return;
			end
			if IsOptionEnabled("Protection") then
				if Player:Stance() == 2 then
					self:ChangeStance(3);
					return;
				end
				if IsOptionEnabled("Concussion Blow") and Player:Rage() >= GetOptionValue("Concussion Blow") and Target:CanCast(ConcussionBlow) then
					Target:Cast(ConcussionBlow);
					return;
				end
				-- Concussion Blow - if Target Is Casting
				if IsOptionEnabled("Concussion Blow Interrupt") and Target:UseInterrupt(ConcussionBlow) then
					return;
				end
				-- Shield Bash - if Target Is Casting - if Stance = battle, defensive
				if (Player:Stance() == 1 or Player:Stance() == 3) and Target:UseInterrupt(ShieldBash) then
					return;
				end
				-- Pummel - if Target Is Casting - if Stance = berserk
				-- Taunt - if Not Target Of Target - if TargetHasTarget - if Stance = defensive
				if IsOptionEnabled("Taunt") and Player:Stance() == 3 and UnitExists("targettarget") and not UnitIsUnit("player", "targettarget") and Target:CanCast(Taunt) then
					Target:Cast(Taunt);
					return;
				end
				-- Mocking Blow - if Not Target Of Target - if Target Has Target - if Stance = battle
				if IsOptionEnabled("Mocking Blow") and Player:Stance() == 1 and UnitExists("targettarget") and not UnitIsUnit("player", "targettarget") and Target:CanCast(MockingBlow) then
					Target:Cast(MockingBlow);
					return;
				end
				-- Battle Shout - if Not Player Has Buff = battle Shout
				-- Thunder Clap - if Target In Melee Range - if Stance = battle
				if IsOptionEnabled("Thunder Clap") and Player:Stance() == 1 and Player:DistanceTo(Target) <= 5 and Player:CanCast(ThunderClap) and not Target:Debuff(ThunderClap) then
					Player:Cast(ThunderClap);
					return;
				end
				-- Demo Shout - if Target In Melee Range - if Not Target Has Debuff = demo Shout
				if IsOptionEnabled("Demoralizing Shout") and Player:HealthPercentage() <= GetOptionValue("Demoralizing Shout") and Player:DistanceTo(Target) <= 5 and not Target:Debuff(DemoralizingShout) and Player:CanCast(DemoralizingShout) then
					Player:Cast(DemoralizingShout);
					return;
				end
				-- Disarm - if Stance = defensive
				-- Shield Block - if Stance = defensive - if Not Player Has Buff = shield Block
				if IsOptionEnabled("Shield Block") and Player:Stance() == 3 and not Player:Buff(ShieldBlock) and Player:CanCast(ShieldBlock) then
					Player:Cast(ShieldBlock);
					return;
				end
				-- Execute - if Stance = battle, berserk
				if (Player:Stance() == 1 or Player:Stance() == 2) and Target:CanCast(Execute) then
					Target:Cast(Execute);
					return;
				end
				-- Overpower - if Stance = battle
				if Overpower:Exists() and ShouldOverpower > GetTime() and Player:Stance() == 1 and Target:CanCast(Overpower) then
					Target:Cast(Overpower);
					return;
				end
				-- Shield Slam
				if Target:CanCast(ShieldSlam) then
					Target:Cast(ShieldSlam);
					return;
				end
				-- Sunder - if Target Has Debuff < 5 = sunder
				if IsOptionEnabled("Sunder Armor") and ((SunderTargetGuid == PlayerTargetGuid() and GetTime() - SunderTime > 25) or Target:DebuffCount(SunderArmor) < 5) and Target:CanCast(SunderArmor) then
					SunderTargetGuid, SunderTime = PlayerTargetGuid(), GetTime()
					Target:Cast(SunderArmor);
					return;
				end
				-- Revenge - if Stance = defensive
				if Target:CanCast(Revenge) then
					Target:Cast(Revenge);
					return;
				end
				-- Battle Shout
				-- Heroic Strike - if In Cooldown = shield Slam
				if IsOptionEnabled("Cleave / Strike") and Player:Rage() >= GetOptionValue("Cleave / Strike") then
					if NumEnemies_5y >= 3 then
						if Target:CanCast(Cleave) then
							Target:Cast(Cleave);
							return;
						end
					else
						if Target:CanCast(HeroicStrike) then
							Target:Cast(HeroicStrike);
							return;
						end
					end
				end
				return;
			end

			if IsOptionEnabled("Mortal Strike") and Target:CanCast(MortalStrike) then
				Target:Cast(MortalStrike);
				return;
			end
			-- Overpower if BT and WW are on CD and our rage is low
			if Overpower:Exists() and ShouldOverpower > GetTime() and (Player:Stance() == 1 or (not Bloodthirst:Exists() or Bloodthirst:Cooldown() > 3) and (not UseAOE() or not Whirlwind:Exists() or Whirlwind:Cooldown() > 3) and Player:Rage() < 45) then
				if Player:Stance() ~= 1 and ShouldOverpower > GetTime() + 1 then
					self:ChangeStance(1);
					return;
				end
				return;
			end
			-- Thunder Clap
			if IsOptionEnabled("Thunder Clap") and Player:HealthPercentage() <= GetOptionValue("Thunder Clap") and Player:DistanceTo(Target) <= 5 and Player:CanCast(ThunderClap) and not Target:Debuff(ThunderClap) then
				Player:Cast(ThunderClap);
				return;
			end
			-- Demoralizing Shout
			if IsOptionEnabled("Demoralizing Shout") and Player:HealthPercentage() <= GetOptionValue("Demoralizing Shout") and Player:DistanceTo(Target) <= 5 and Player:CanCast(DemoralizingShout) and not Target:Debuff(DemoralizingShout) then
				Player:Cast(DemoralizingShout);
				return;
			end
			-- Hamstring
			if IsOptionEnabled("Hamstring") and not Target:Debuff(Hamstring) and Target:CanCast(Hamstring) then
				Target:Cast(Hamstring);
				return;
			end
			if Target:HealthPercentage() > 20 then
				if Rend:Exists() and IsOptionEnabled("Rend") then
					self:ChangeStance(1);
				else
					self:ChangeStance(2);
				end
				if Player:Stance() == 1 then
					-- Rend
					if IsOptionEnabled("Rend") and Target:CanCast(Rend) and not Target:Debuff(Rend) and (PlayerTargetGuid() ~= LastRendedTargetGUID or NextRendTime < GetTime()) then
						LastRendedTargetGUID, NextRendTime = PlayerTargetGuid(), GetTime() + 20;
						Target:Cast(Rend);
						return;
					end
					-- Bloodthirst
					if Target:CanCast(Bloodthirst) then
						Target:Cast(Bloodthirst);
						return;
					end
				elseif Player:Stance() == 2 then
					-- Whirlwind
					if Player:CanCast(Whirlwind) and NumEnemies_5y >= 2 and Player:Rage() >= 25 then
						Player:Cast(Whirlwind);
						return;
					end
					-- Bloodthirst
					if Target:CanCast(Bloodthirst) then
						Target:Cast(Bloodthirst);
						return;
					end
					-- Whirlwind
					if UseAOE() and Player:CanCast(Whirlwind) and Player:Rage() >= 45 then
						Player:Cast(Whirlwind);
						return;
					end
				elseif Player:Stance() == 3 then
					-- Bloodthirst
					if Target:CanCast(Bloodthirst) then
						Target:Cast(Bloodthirst);
						return;
					end
				end
			else
				self:ChangeStance(2);
				-- Execute
				if Target:CanCast(Execute) then
					Target:Cast(Execute);
					return;
				end
			end
		end
	end
end

function Rotation:OutOfCombat ()
	-- Offensive / Engage
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		-- Intercept
		if Intercept:Exists() and IsOptionEnabled("Intercept") and Player:Stance() == 2 and Player:Rage() >= 10 and not Intercept:IsOnCooldown() and Player:IsFacing(Target) and Player:DistanceTo(Target) > 8 and Target:CanCast(Intercept) then
			Target:Cast(Intercept);
			return;
		end
		-- Charge
		if Charge:Exists() and IsOptionEnabled("Charge") and not Charge:IsOnCooldown() and Player:IsFacing(Target) and Player:DistanceTo(Target) > 8 then
			self:ChangeStance(1);
			if Target:CanCast(Charge) then
				Target:Cast(Charge);
				return;
			end
		end
		if IsOptionEnabled("Initiate Combat") then
			self:Combat();
		end
	end
end