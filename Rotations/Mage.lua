--- Hunter
Rotations.MAGE = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	shotTime = 0,
	arcticTalents = 0,
	Combo = 0,
	ComboMana = 100,
	ScorchDebuffExpire = 0,
	Spec = "None",
	PoMCasted = 0;
	Activated = false
};
local Rotation = Rotations.MAGE;
function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Racials

	ArcaneBrilliance = Spell.Create("Spell_Holy_ArcaneIntellect", false, false, true, 0);
	ArcaneIntellect = Spell.Create("Spell_Holy_MagicalSentry", false, false, true, 0);
	IceArmor = Spell.Create("Spell_Frost_FrostArmor02", false, false, true, 0);
	MageArmor = Spell.Create("Spell_MageArmor", false, false, true, 0);

	ArcanePower = Spell.Create("Spell_Nature_Lightning", false, false, true, 0, nil, "Spell_Nature_WispSplode");
	PresenceOfMind = Spell.Create("Spell_Nature_EnchantArmor", false, false, true, 0);
	Combustion = Spell.Create("Spell_Fire_SealOfFire", false, false, true, 0);
	BloodFury = Spell.Create("Racial_Orc_BerserkerStrength", false, false, true, 0, "Racial");
	Berserking = Spell.Create("Racial_Troll_Berserk", false, false, true, 0, "Racial");

	ArcaneExplosion = Spell.Create("Spell_Nature_WispSplode", false, false, true, 0);
	Counterspell = Spell.Create("Spell_Frost_IceShock", true, true, true, 0);
	Evocation = Spell.Create("Spell_Nature_Purge", false, false, false, 0);

	
	BlastWave = Spell.Create("Spell_Holy_Excorcism_02", false, false, true, 0);
	Scorch = Spell.Create("Spell_Fire_SoulBurn", true, true, false, 0);
	FireBlast = Spell.Create("Spell_Fire_Fireball", true, true, true, 0);
	Fireball = Spell.Create("Spell_Fire_FlameBolt", true, true, false, 0);
	Pyroblast = Spell.Create("Spell_Fire_Fireball02", true, true, false, 0);

	Frozen = Spell.Create("Spell_Frost_FrostArmor", true, true, true, 0);
	Frostbolt = Spell.Create("Spell_Frost_FrostBolt02", true, true, false, 0);
	IceBarrier = Spell.Create("Spell_Ice_Lament", false, false, true, 0);
	ConeOfCold = Spell.Create("Spell_Frost_Glacier", false, false, true, 0);
	IceBlock = Spell.Create("Spell_Frost_Frost", false, false, true, 0);
	FrostNova = Spell.Create("Spell_Frost_FrostNova", false, false, true, 0);

	--TalismanOfEphemeralPower = Item.Create("INV_Misc_StoneTablet_11");

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();

	AddOption("General", "Interrupt", true, "Use Counterspell to interrupt our current target.");
	AddOption("General", "Arcane Intellect", true, "Use Arcane Intellect.");
	AddOption("General", "Arcane Brilliance", true, "Use Arcane Brilliance.");
	AddOption("General", "Ice Armor", true, "Use Ice Armor.");
	AddOption("General", "Mage Armor", false, "Use Mage Armor.");
	AddOption("General", "Shatter Combo", false, "Will save Arcane Power, Presence of Mind and Fire Blast to be used on frozen targets following a frostbolt or fireball.");
	
	AddOption("Offensive", "Cooldowns", "header");
	--AddOption("Offensive", "Talisman of Ephemeral Power", true, "Will use ToEP if equipped.");
	AddOption("Offensive", "Presence of Mind", true, "Will use Pyroblast if it exists, otherwise Frostbolt or Fireball.");
	AddOption("Offensive", "Arcane Power", true, "Use with Presence of Mind(if enabled, otherwise on cooldown).");
	AddOption("Offensive", "Combustion", true, "Use on cooldown.");
	AddOption("Offensive", "Offensive Racials", true, "Use on cooldown.");

	AddOption("Offensive", "Arcane Spells", "header");
	AddOption("Offensive", "Arcane Explosion", true, 1, 10, 4, "Use Arcane Explosion for AoE."..C.TOOLTIP_VALUE.."Amount of units that need to be in range to use.");

	AddOption("Offensive", "Fire Spells", "header");
	AddOption("Offensive", "Blast Wave", true, 1, 10, 4, "Use Blast Wave for AoE."..C.TOOLTIP_VALUE.."Amount of units that need to be in range to use.");
	AddOption("Offensive", "Fire Blast", true, "Use Fire Blast.");
	AddOption("Offensive", "Improved Scorch", true, "Will apply 5 stacks of Improved Scorch and maintain if it drops below 7 seconds.");
	AddOption("Offensive", "Scorch", false, "Use Scorch.");
	AddOption("Offensive", "Fireball", true, "Use Fireball.");

	AddOption("Offensive", "Frost Spells", "header");
	AddOption("Offensive", "Ice Barrier", true, "Use Ice Barrier on cooldown.");
	AddOption("Offensive", "Cone of Cold", true, "Use Cone of Cold.");
	AddOption("Offensive", "Frostbolt", true, "Use Frostbolt.");
	

	AddOption("Defensive", "Frost Nova", true, "Use Frost Nova.");
	AddOption("Defensive", "Ice Block", true, 1, 100, 20, "Use when we get Low Health."..C.TOOLTIP_VALUE.."Health threshold.");
	


	local arcticTalents = Talent.Create(3, 4, 1):Rank();

	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Mage Rotation Initialized.");
	end
		--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Arcane" or Talent.Create(2, 7, 2):Rank() > 0 and "Fire" or Talent.Create(3, 7, 2):Rank() > 0 and "Frost" or "Leveling or Hybrid";
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
	
	-- Pause While Casting
	if Player:IsCasting(Fireball) or Player:IsCasting(Frostbolt) or Player:IsCasting(Pyroblast) or Player:IsCasting(Scorch) then
		if Player:IsCasting(Scorch) then Rotation.ScorchStarted = true; end
		if not Fireball:IsOnCooldown() then
			Rotation.Combo = 1;
			Rotation.ComboMana = Player:ManaPercentage();
		end
		return;
	end

	--Pause During Ice Block and Evocation
	if Player:Buff(IceBlock) or (Player:Buff(Evocation) and Player:ManaPercentage() < 100) then
		return;
	end

	Rotation.SpamPrevention = GetTime() + 0.05;

	if Player:IsInCombat() then	

		self:Defensives();
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not IceArmor:IsOnCooldown() then

			--prevent spam queueing our wand
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
			--Make sure we don't double cast thinking we have PoM
			if Rotation.PoMCasted == 1 then
				Rotation.PoMCasted = 2;
			end

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

-- Tables will be refreshed every 0.5s from the Pulse
function Rotation:UnitTables ()
	if UseAOE() then
		Enemies_10y, NumEnemies_10y = Player:EnemiesWithinDistance(10, true);
	else
		Enemies_10y, NumEnemies_10y = { Player }, 1;
	end
end

-- 
function Rotation:Combat ()
	--Determine if either Frostrbolt of Fireball finished casting
	if Rotation.Combo == 1 and Player:ManaPercentage() >= Rotation.ComboMana then
		Rotation.Combo = 0;
	end

	--Determine if scorch finished casting
	if Rotation.ScorchStarted == true and Player:ManaPercentage() < Rotation.ComboMana then
		Rotation.ScorchDebuffExpire = GetTime()+30;
	end
	Rotation.ScorchStarted = false;

	-- Interrupt with Counterspell
	if Target:UseInterrupt(Counterspell) then
		return;
	end

	--Ice Barrier
	if IsOptionEnabled("Ice Barrier") and not Player:Buff(IceBarrier) and Player:CanCast(IceBarrier) then
		Player:Cast(IceBarrier);
		return;
	end

	--Ice Block
	if IsOptionEnabled("Ice Block") and not Player:Buff(IceBlock) and Player:CanCast(IceBlock) and Player:HealthPercentage() < GetOptionValue("Ice Block") then
		Player:Cast(IceBlock);
		return;
	end

	--Ice Armor
	if IsOptionEnabled("Ice Armor") then
		if not Player:Buff(IceArmor) and Player:CanCast(IceArmor) then
			Player:Cast(IceArmor);
			return;
		end
	--Mage Armor
	elseif IsOptionEnabled("Mage Armor") and not Player:Buff(MageArmor) and Player:CanCast(MageArmor) then
		Player:Cast(MageArmor);
		return;
	end

	--Arcane Brilliance
	if IsOptionEnabled("Arcane Brilliance") and not Player:Buff(ArcaneIntellect) and not Player:Buff(ArcaneBrilliance) and Player:CanCast(ArcaneBrilliance) then
		Player:Cast(ArcaneBrilliance);
		return;
	end

	--Arcane Intellect
	if IsOptionEnabled("Arcane Intellect") and not Player:Buff(ArcaneIntellect) and not Player:Buff(ArcaneBrilliance) and Player:CanCast(ArcaneIntellect) then
		Player:Cast(ArcaneIntellect);
		return;
	end

	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (IsOptionEnabled("Initiate Combat") or Target:IsInCombat()) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer()) and Fireball:IsInRange() then

		--Frost Nova
		if IsOptionEnabled("Frost Nova") and Player:DistanceTo(Target, false, true) < 10+Rotation.arcticTalents and Player:CanCast(FrostNova) then
			Player:Cast(FrostNova);
			return;
		end

		if CooldownsAllowed() then
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
			--Arcane Power
			if IsOptionEnabled("Arcane Power") and Player:CanCast(ArcanePower) and not Player:Debuff(ArcanePower) and (Player:Buff(PresenceOfMind) or not IsOptionEnabled("Presence of Mind")) then
				Player:Cast(ArcanePower);
			end
			--Combustion
			if IsOptionEnabled("Combustion") and Player:CanCast(Combustion) then
				Player:Cast(Combustion);
				return;
			end
		end

		--PoM Combo
		if Player:Buff(PresenceOfMind) and Rotation.PoMCasted < 2 then
			if Pyroblast:Exists() then
				if Target:CanCast(Pyroblast, _, _, true) then
					Rotation.PoMCasted = 1;
					Target:Cast(Pyroblast);
					return;
				end
			elseif IsOptionEnabled("Frostbolt") and Target:CanCast(Frostbolt, _, _, true) then
				Rotation.PoMCasted = 1;
				Target:Cast(Frostbolt);
				return;
			elseif IsOptionEnabled("Fireball") and Target:CanCast(Fireball, _, _, true) then
				Rotation.PoMCasted = 1;
				Target:Cast(Fireball);
				return;
			end
		end
		Rotation.PoMCasted = 0;
		--Blast Wave
		if IsOptionEnabled("Blast Wave") and NumEnemies_10y >= GetOptionValue("Blast Wave") and Player:CanCast(BlastWave) then
			Player:Cast(BlastWave);
			return;
		end

		--Fire Blast Combo Prioritizer
		local shouldFireBlast = false;
		if IsOptionEnabled("Fire Blast") and not FireBlast:IsOnCooldown() then
			if IsOptionEnabled("Shatter Combo") and FrostNova:Exists() then
				if Rotation.Combo > 1 then
					shouldFireBlast = true;
				elseif (Target:Debuff(Frozen) or Target:Debuff(FrostNova)) and (Rotation.Combo > 0 or Player:IsMoving()) then
					shouldFireBlast = true;
				end
			elseif Player:IsMoving() then
				shouldFireBlast = true;
			end
		end

		--Presence of Mind
		if IsOptionEnabled("Presence of Mind") and (not IsOptionEnabled("Shatter Combo") or shouldFireBlast) and Player:CanCast(PresenceOfMind) and CooldownsAllowed() then
			Player:Cast(PresenceOfMind);
			Rotation.Combo = 2;
			return;
		end

		--Fire Blast
		if shouldFireBlast and Target:CanCast(FireBlast) then
			Target:Cast(FireBlast);
			return;
		end
		
		--Cone of Cold
		if IsOptionEnabled("Cone of Cold") and Player:DistanceTo(Target, false, true) < 10 and Player:IsFacing(Target) and Player:CanCast(ConeOfCold) then
			Player:Cast(ConeOfCold);
			return;
		end

		--Arcane Explosion
		if IsOptionEnabled("Arcane Explosion") and NumEnemies_10y >= GetOptionValue("Arcane Explosion") and Player:CanCast(ArcaneExplosion) then
			Player:Cast(ArcaneExplosion);
			return;
		end

		--Reset Fire Blast Combo Priority
		Rotation.Combo = 0;

		--Improved Scorch
		local ImprovedScorchTalent = Talent(2, 4, 1):Rank() > 0;
		if IsOptionEnabled("Improved Scorch") and ImprovedScorchTalent and (Target:DebuffCount(Scorch) < 5 or Rotation.ScorchDebuffExpire-GetTime() < 7) and not Player:IsMoving() and Target:CanCast(Scorch) then
			Target:Cast(Scorch);
			return;
		end 

		--Scorch
		if IsOptionEnabled("Scorch") and not Player:IsMoving() and Target:CanCast(Scorch) then
			Target:Cast(Scorch);
			return;
		end

		if IsOptionEnabled("Fireball") and IsOptionEnabled("Frostbolt") then
			local _, _, firePointsSpent = GetTalentTabInfo(2);
			local _, _, frostPointsSpent = GetTalentTabInfo(3);
			local favoredSpell = firePointsSpent > frostPointsSpent and Fireball or Frostbolt;
			if Target:CanCast(favoredSpell) and not Player:IsMoving() then
				Target:Cast(favoredSpell);
				return;
			end
		end

		--Frostbolt
		if IsOptionEnabled("Frostbolt") and not Player:IsMoving() and Target:CanCast(Frostbolt) then
			Target:Cast(Frostbolt);
			return;
		end

		--Fireball
		if IsOptionEnabled("Fireball") and not Player:IsMoving() and Target:CanCast(Fireball) then
			Target:Cast(Fireball);
			return;
		end



		--Wand / Melee
		if IsOptionEnabled("Auto Shot / Attack") then
			if GetTime() - Rotation.shotTime > 1 and BowWandPosition and not IsAutoRepeatAction(BowWandPosition) and IsActionInRange(BowWandPosition) == 1 and not Player:IsMoving()  then
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
	--Ice Barrier
	if IsOptionEnabled("Ice Barrier") and not Player:Buff(IceBarrier) and Player:CanCast(IceBarrier) then
		Player:Cast(IceBarrier);
		return;
	end

	--Ice Armor
	if IsOptionEnabled("Ice Armor") then
		if not Player:Buff(IceArmor) and Player:CanCast(IceArmor) then
			Player:Cast(IceArmor);
			return;
		end
	--Mage Armor
	elseif IsOptionEnabled("Mage Armor") and not Player:Buff(MageArmor) and Player:CanCast(MageArmor) then
		Player:Cast(MageArmor);
		return;
	end

	--Arcane Brilliance
	if IsOptionEnabled("Arcane Brilliance") and not Player:Buff(ArcaneIntellect) and not Player:Buff(ArcaneBrilliance) and Player:CanCast(ArcaneBrilliance) then
		Player:Cast(ArcaneBrilliance);
		return;
	end

	--Arcane Intellect
	if IsOptionEnabled("Arcane Intellect") and not Player:Buff(ArcaneIntellect) and not Player:Buff(ArcaneBrilliance) and Player:CanCast(ArcaneIntellect) then
		Player:Cast(ArcaneIntellect);
		return;
	end

	--Initiate Combat
	if IsOptionEnabled("Initiate Combat") then
		self:Combat();
	end
end