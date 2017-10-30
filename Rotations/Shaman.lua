--- Shaman
Rotations.SHAMAN = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	Spec = "None",
	Activated = false
};
local Rotation = Rotations.SHAMAN;
function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Racials
	BloodFury = Spell.Create("Racial_Orc_BerserkerStrength", false, false, true, 0, "Racial");
	Berserking = Spell.Create("Racial_Troll_Berserk", false, false, true, 0, "Racial");
	-- Elemental
	ChainLightning = Spell.Create("Spell_Nature_ChainLightning", true, true, false, 30);
	EarthShock = Spell.Create("Spell_Nature_EarthShock", true, true, true, 20);
	EarthbindTotem = Spell.Create("Spell_Nature_StrengthOfEarthTotem02", false, false, true, 0);
	FireNovaTotem = Spell.Create("Spell_Fire_SealOfFire", false, false, true, 0);
	FlameShock = Spell.Create("Spell_Fire_FlameShock", true, true, true, 20);
	FrostShock = Spell.Create("Spell_Frost_FrostShock", true, true, true, 20);
	LightningBolt = Spell.Create("Spell_Nature_Lightning", true, true, true, 30);
	MagmaTotem = Spell.Create("Spell_Fire_SelfDestruct", false, false, true, 0);
	Purge = Spell.Create("Spell_Nature_Purge", true, true, true, 30);
	SearingTotem = Spell.Create("Spell_Fire_SearingTotem", false, false, true, 0);
	StoneclawTotem = Spell.Create("Spell_Nature_StoneClawTotem", false, false, true, 0);
	-- AstralRecall = Spell.Create("Spell_Nature_AstralRecal", false, false, false, 0);
	-- FarSight = Spell.Create("Spell_Nature_FarSight", false, false, false, 0);
	FireResistanceTotem = Spell.Create("Spell_FireResistanceTotem_01", false, false, true, 0);
	FlametongueTotem = Spell.Create("Spell_Nature_GuardianWard", false, false, true, 0);
	FlametongueWeapon = Spell.Create("Spell_Fire_FlameTounge", false, false, true, 0);
	FrostResistanceTotem = Spell.Create("Spell_FrostResistanceTotem_01", false, false, true, 20);
	FrostbrandWeapon = Spell.Create("Spell_Frost_FrostBrand", false, false, true, 0);
	GhostWolf = Spell.Create("Spell_Nature_SpiritWolf", false, false, true, 0);
	GraceOfAirTotem = Spell.Create("Spell_Nature_InvisibilityTotem", false, false, true, 0);
	-- GroundingTotem = Spell.Create("Spell_Nature_GoundingTotem", false, false, true, 0);
	LightningShield = Spell.Create("Spell_Nature_LightningShield", false, false, true, 0);
	NatureResistanceTotem = Spell.Create("Spell_Nature_NatureResistanceTotem", false, false, true, 0);
	RockbiterWeapon = Spell.Create("Spell_Nature_RockBiter", false, false, true, 0);
	-- SentryTotem = Spell.Create("Spell_Nature_RemoveCurse", false, false, true, 0);
	StoneskinTotem = Spell.Create("Spell_Nature_StoneSkinTotem", false, false, true, 0);
	Stormstrike = Spell.Create("Spell_Holy_SealOfMight", true, true, true, 5);
	StrengthOfEarthTotem = Spell.Create("Spell_Nature_EarthBindTotem", false, false, true, 0);
	-- WaterBreathing = Spell.Create("Spell_Frost_WindwalkOn", false, false, true, 30);
	WindfuryTotem = Spell.Create("Spell_Nature_Windfury", false, false, true, 0);
	WindfuryWeapon = Spell.Create("Spell_Nature_Cyclone", false, false, true, 0);
	WindwallTotem = Spell.Create("Spell_Nature_EarthBind", true, true, true, 0);
	AncestralSpirit = Spell.Create("Spell_Nature_Regenerate", false, false, false, 30);
	ChainHeal = Spell.Create("Spell_Nature_HealingWaveGreater", true, true, true, 40);
	CureDisease = Spell.Create("Spell_Nature_RemoveDisease", false, false, true, 30);
	CurePoison = Spell.Create("Spell_Nature_NullifyPoison", true, true, true, 30);
	DiseaseCleansingTotem = Spell.Create("Spell_Nature_DiseaseCleansingTotem", false, false, true, 0);
	HealingStreamTotem = Spell.Create("INV_Spear_04", false, false, true, 0);
	HealingWave = Spell.Create("Spell_Nature_MagicImmunity", false, false, true, 40);
	LesserHealingWave = Spell.Create("Spell_Nature_HealingWaveLesser", false, false, true, 40);
	ManaSpringTotem = Spell.Create("Spell_Nature_ManaRegenTotem", false, false, true, 0);
	PoisonCleansingTotem = Spell.Create("Spell_Nature_PoisonCleansingTotem", false, false, true, 0);
	TranquilAirTotem = Spell.Create("Spell_Nature_Brilliance", false, false, true, 0);
	TremorTotem = Spell.Create("Spell_Nature_TremorTotem", false, false, true, 0);

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();

	AddOption("General", "Interrupt", true, "Use Earth Shock to interrupt our current target.");
	AddOption("General", "Utility Totems", "header");
	AddOption("General", "Air Totem", true, 1, 5, 1, "Maintain a Air Totem. Choose which Totem you want to maintain."..C.TOOLTIP_VALUE.."1 - Grace of Air Totem // 2 - Nature Resistance Totem // 3 - Tranquil Air Totem // 4 - Windfury Totem // 5 - Windwall Totem");
	AddOption("General", "Earth Totem", true, 1, 3, 2, "Maintain a Earth Totem. Choose which Totem you want to maintain."..C.TOOLTIP_VALUE.."1 - Stoneskin Totem // 2 - Strength Of Earth Totem // 3 - Tremor Totem");
	AddOption("General", "Water Totem", true, 1, 5, 3, "Maintain a Water Totem. Choose which Totem you want to maintain."..C.TOOLTIP_VALUE.."1 - Disease Cleansing Totem // 2 - Fire Resistance Totem // 3 - Healing Stream Totem // 4 - Mana Spring Totem // 5 - Poison Cleansing Totem");
	AddOption("General", "Fire Totems", "header");
	AddOption("General", "Fire Totem", true, 1, 3, 3, "Maintain a Fire Totem. Choose which Totem you want to maintain. Choosing Automatic Damaging Totems will change between Searing, Fire Nova and Magma totem based on the situation."..C.TOOLTIP_VALUE.."1 - Flametongue Totem // 2 - Frost Resistance Totem // 3 - Automatic Damaging Totems");
	AddOption("General", "Magma Totem", "none", 1, 10, 2, "Maintain a Magma Totem."..C.TOOLTIP_VALUE.."Use Magma Totem instead of Searing Totem when the amount of units in 5 yard exceed this value.");
	AddOption("General", "Fire Nova Totem", "none", 1, 10, 2, "Use Fire Nova Totem on cooldown."..C.TOOLTIP_VALUE.."Use Fire Nova Totem when the amount of units in 5 yards exceed this value.");

	AddOption("Offensive", "Cooldowns", "header");
	AddOption("Offensive", "Offensive Racials", false, "Use on cooldown.");
	AddOption("Offensive", "Abilities", "header");
	AddOption("Offensive", "Chain Lightning", false, 1, 3, 2, "Use Chain Lightning in AoE."..C.TOOLTIP_VALUE.."Use Chain Lightning when the amount of units in 5 yards around the Target exceed this value.");
	AddOption("Offensive", "Earth Shock", false, 1, 100, 20, "Use on cooldown during Stormstrike debuff."..C.TOOLTIP_VALUE.."Only use if our mana is above this threshold.");
	AddOption("Offensive", "Flame Shock", false, 1, 100, 60, "Maintain Flame Shock on our Target."..C.TOOLTIP_VALUE.."Only use if our mana is above this threshold.");
	AddOption("Offensive", "Frost Shock", true, 1, 100, 60, "Use on cooldown."..C.TOOLTIP_VALUE.."Only use if our mana is above this threshold.");
	AddOption("Offensive", "Lightning Shield", false, "Keep Lightning Shield buff up.");
	AddOption("Offensive", "Weapon Imbue", true, 1, 4, 4, "Keep Imbue Weapon buff up. Choose which Imbue you want to maintain."..C.TOOLTIP_VALUE.."1 - Flametongue // 2 - Frostbrand // 3 - Rockbiter // 4 - Windfury");

	AddOption("Defensive", "Cooldowns", "header");
	AddOption("Defensive", "Stoneclaw Totem", false, 1, 100, 20, "Use when we get Low Health."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Defensive", "Abilities", "header");
	AddOption("Defensive", "Healing Wave", false, 1, 100, 80, "Use Healing Wave on ourself when we got Low Health."..C.TOOLTIP_VALUE.."Health threshold.");

	-- Enhance / Ele
	-- http://db.vanillagaming.org/?talent#hVf0xzZxifdV0ut
	--Rotation Notification
	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Shaman Rotation Initialized.");
	end
	
	--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Elemental - Not Supported" or Talent.Create(2, 7, 2):Rank() > 0 and "Enhancement" or Talent.Create(3, 7, 2):Rank() > 0 and "Restoration" or "Leveling or Hybrid";
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
		if not LightningBolt:IsOnCooldown() then
			self:Combat();
			return;
		end
	else
		self:OutOfCombat();
	end
end

-- Defensive Abilities that are not on GCD
function Rotation:Defensives ()
	-- Healing Wave
	if HealingWave:Exists() and IsOptionEnabled("Healing Wave") and Player:HealthPercentage() < GetOptionValue("Healing Wave") and Player:CanCast(HealingWave) then
		Player:Cast(HealingWave);
		return;
	end
	-- Stoneclaw Totem
	if StoneclawTotem:Exists() and IsOptionEnabled("Stoneclaw Totem") and Player:HealthPercentage() < GetOptionValue("Stoneclaw Totem") and Player:CanCast(StoneclawTotem) then
		StoneclawTotem.LastCastTime = GetTime();
		Player:Cast(StoneclawTotem);
		return;
	end
end

-- Abilities that are not on GCD
function Rotation:OffGCDAbilities ()

end

-- Tables will be refreshed every 0.5s from the Pulse
function Rotation:UnitTables ()
	if UseAOE() then
		Enemies_5y, NumEnemies_5y = Player:EnemiesWithinDistance(5, true);
		TargetEnemies_5y, NumTargetEnemies_5y = Target:EnemiesWithinDistance(5, true);
	else
		Enemies_5y, NumEnemies_5y = {}, 0;
		TargetEnemies_5y, NumTargetEnemies_5y = {}, 0;
	end
end

WINDFURY = "Windfury";
FLAMETONGUE = "Flametongue";
FROSTBRAND = "Frostbrand";
ROCKBITER = "Rockbiter"
WINDFURY_TOTEM = "Windfury Totem";
function Rotation:HasImbue (Type)
	local MainHandId, Texture, CheckRelic = GetInventorySlotInfo("MainHandSlot");
	ScanningTooltip:ClearLines();
	ScanningTooltip:SetInventoryItem("player", MainHandId, false);
	local ThisTextFrame, ThisTextFrameText;
	for i = 1, 10 do
		ThisTextFrame = getglobal("ScanningTooltipTextLeft"..i) or nil;
		if ThisTextFrame ~= nil then
			ThisTextFrameText = ThisTextFrame:GetText();
			if Type == WINDFURY and string.find(ThisTextFrameText, WINDFURY) ~= nil and string.find(ThisTextFrameText, WINDFURY_TOTEM) == nil then
				return true;
			elseif Type ~= WINDFURY and string.find(ThisTextFrameText, Type) ~= nil then
				return true;
			end
		end
	end
	return false;
end

function Rotation:Totems ()
	WeaponTexture, WeaponSpellID = GetInventoryItemTexture("player", 16);
	-- Earth Totems
	if IsOptionEnabled("Earth Totem") and (StoneclawTotem:TimeSinceCast() > 15 or (StoneclawTotem:TimeSinceCast() > 3 and UnitIsUnit("player", "targettarget"))) then
		-- Stoneskin (1)
		if GetOptionValue("Earth Totem") == 1 and not Player:Buff(StoneskinTotem) and Player:CanCast(StoneskinTotem) then
			Player:Cast(StoneskinTotem);
			return;
		end
		-- Strenght of Earth (2)
		if GetOptionValue("Earth Totem") == 2 and not Player:Buff(StrengthOfEarthTotem) and Player:CanCast(StrengthOfEarthTotem) then
			Player:Cast(StrengthOfEarthTotem);
			return;
		end
		-- Tremor (3) - No Buff
		if GetOptionValue("Earth Totem") == 3 and Player:CanCast(TremorTotem) then
			if TremorTotem:TimeSinceCast() > 110 or TremorPosition == nil or TremorPosition:DistanceTo(Player:Position()) > 25 then
				TremorTotem.LastCastTime, TremorPosition = GetTime(), Vector3.Create(Player.X, Player.Y, Player.Z);
				Player:Cast(TremorTotem);
				return;
			end
		end
	end
	-- Fire Totems
	if IsOptionEnabled("Fire Totem") then
		-- Flametongue (1) - No Buff
		if GetOptionValue("Fire Totem") == 1 and Player:CanCast(FlametongueTotem) then
			if FlametongueTotem:TimeSinceCast() > 110 or FlametonguePosition == nil or FlametonguePosition:DistanceTo(Player:Position()) > 15 then
				FlametongueTotem.LastCastTime, FlametonguePosition = GetTime(), Vector3.Create(Player.X, Player.Y, Player.Z);
				Player:Cast(FlametongueTotem);
				return;
			end
		end
		-- Frost Resistance
		if GetOptionValue("Fire Totem") == 2 and not Player:Buff(FrostResistanceTotem) and Player:CanCast(FrostResistanceTotem) then
			Player:Cast(FlametongueTotem);
			return;
		end
		-- Auto
		if GetOptionValue("Fire Totem") == 3 and Player:CanCast(SearingTotem) then
			-- Fire Nova (AoE, CD)
			if NumEnemies_5y >= 2 and Player:CanCast(FireNovaTotem) then
				FireNovaTotem.LastCastTime = GetTime();
				Player:Cast(FireNovaTotem);
				return;
			end
			if FireNovaTotem:TimeSinceCast() == 100 or FireNovaTotem:TimeSinceCast() > 5 then
				if MagmaTotem:Exists() and NumEnemies_5y >= 2 then
					-- Magma (AOE)
					if MagmaTotem:TimeSinceCast() > 20 or MagmaPosition == nil or MagmaPosition:DistanceTo(Player:Position()) > 15 then
						MagmaTotem.LastCastTime, MagmaPosition = GetTime(), Vector3.Create(Player.X, Player.Y, Player.Z);
						Player:Cast(MagmaTotem);
						return;
					end
				else
					-- Searing Totem
					if SearingTotem:TimeSinceCast() > 55 or SearingPosition == nil or SearingPosition:DistanceTo(Player:Position()) > 15 then
						SearingTotem.LastCastTime, SearingPosition = GetTime(), Vector3.Create(Player.X, Player.Y, Player.Z);
						Player:Cast(SearingTotem);
						return;
					end
				end
			end
		end
	end
	-- Water Totems
	if IsOptionEnabled("Water Totem") then
		-- Disease (1)
		if GetOptionValue("Water Totem") == 5 and Player:CanCast(DiseaseCleansingTotem) then
			if DiseaseCleansingTotem:TimeSinceCast() > 110 or DiseaseCleansingPosition == nil or DiseaseCleansingPosition:DistanceTo(Player:Position()) > 15 then
				DiseaseCleansingTotem.LastCastTime, DiseaseCleansingPosition = GetTime(), Vector3.Create(Player.X, Player.Y, Player.Z);
				Player:Cast(DiseaseCleansingTotem);
				return;
			end
		end
		-- Fire Resistance (2)
		if GetOptionValue("Water Totem") == 2 and not Player:Buff(FireResistanceTotem) and Player:CanCast(FireResistanceTotem) then
			Player:Cast(FireResistanceTotem);
			return;
		end
		-- Healing Stream Totem (3)
		if GetOptionValue("Water Totem") == 3 and not Player:Buff(HealingStreamTotem) and Player:CanCast(HealingStreamTotem) then
			Player:Cast(HealingStreamTotem);
			return;
		end
		-- Mana Spring Totem (4)
		if GetOptionValue("Water Totem") == 4 and not Player:Buff(ManaSpringTotem) and Player:CanCast(ManaSpringTotem) then
			Player:Cast(ManaSpringTotem);
			return;
		end
		-- Poison Cleansing Totem (5)
		if GetOptionValue("Water Totem") == 5 and Player:CanCast(PoisonCleansingTotem) then
			if PoisonCleansingTotem:TimeSinceCast() > 110 or PoisonCleansingPosition == nil or PoisonCleansingPosition:DistanceTo(Player:Position()) > 15 then
				PoisonCleansingTotem.LastCastTime, PoisonCleansingPosition = GetTime(), Vector3.Create(Player.X, Player.Y, Player.Z);
				Player:Cast(PoisonCleansingTotem);
				return;
			end
		end
	end
	-- Air Totems
	if IsOptionEnabled("Air Totem") then
		-- Grace of Air (1)
		if GetOptionValue("Air Totem") == 1 and not Player:Buff(GraceOfAirTotem) and Player:CanCast(GraceOfAirTotem) then
			Player:Cast(GraceOfAirTotem);
			return;
		end
		-- Nature Resistance Totem (2)
		if GetOptionValue("Air Totem") == 2 and not Player:Buff(NatureResistanceTotem) and Player:CanCast(NatureResistanceTotem) then
			Player:Cast(NatureResistanceTotem);
			return;
		end
		-- Tranquil Air Totem (3)
		if GetOptionValue("Air Totem") == 3 and not Player:Buff(TranquilAirTotem) and Player:CanCast(TranquilAirTotem) then
			Player:Cast(TranquilAirTotem);
			return;
		end
		-- Windfury Totem (4)
		if GetOptionValue("Air Totem") == 4 and Player:CanCast(WindfuryTotem) then
			if WindfuryTotem:TimeSinceCast() > 110 or WindfuryPosition == nil or WindfuryPosition:DistanceTo(Player:Position()) > 15 then
				WindfuryTotem.LastCastTime, WindfuryPosition = GetTime(), Vector3(Player.X, Player.Y, Player.Z);
				Player:Cast(WindfuryTotem);
				return;
			end
		end
		-- Windwall Totem (5)
		if GetOptionValue("Air Totem") == 5 and not Player:Buff(WindwallTotem) and Player:CanCast(WindwallTotem) then
			Player:Cast(WindwallTotem);
			return;
		end
	end
end

-- Combat
function Rotation:Combat ()

	local targetExists = Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer());

	-- Check if Target is valid
	if targetExists then

		--Enable Auto Attack
		if IsOptionEnabled("Auto Attack") and WeaponPosition and not IsCurrentAction(WeaponPosition) then
			UseAction(WeaponPosition);
		end

		-- Interrupt with Earth Shock
		if Target:UseInterrupt(EarthShock) then
			return;
		end

		-- Check if Target is in range
		if Player:DistanceTo(Target) < 5 then
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
			end

			-- Windfury Weapon
			if IsOptionEnabled("Weapon Imbue") and Player:CanCast(FlametongueWeapon) then
				if GetOptionValue("Weapon Imbue") == 1 and not self:HasImbue(FLAMETONGUE) then
					Player:Cast(FlametongueWeapon);
					return;
				end
				if GetOptionValue("Weapon Imbue") == 2 and not self:HasImbue(FROSTBRAND) then
					Player:Cast(FrostbrandWeapon);
					return;
				end
				if GetOptionValue("Weapon Imbue") == 3 and not self:HasImbue(ROCKBITER) then
					Player:Cast(RockbiterWeapon);
					return;
				end
				if GetOptionValue("Weapon Imbue") == 4 and not self:HasImbue(WINDFURY) then
					Player:Cast(WindfuryWeapon);
					return;
				end
			end

			self:Totems();

			-- Lightning Shield
			if IsOptionEnabled("Lightning Shield") and not Player:Buff(LightningShield) and Player:CanCast(LightningShield) then
				Player:Cast(LightningShield);
				return;
			end
			-- Aoe: 
			-- Fire Nova Totem
			-- Magma Totem
			-- Chain Lightning
			if IsOptionEnabled("Chain Lightning") and NumTargetEnemies_5y >= GetOptionValue("Chain Lightning") then
				if Target:CanCast(ChainLightning) then
					Target:Cast(ChainLightning);
					return;
				end
				return;
			end

			-- Single target: 
			-- Searing Totem
			-- Stormstrike (use everytime cd is down)
			if Target:CanCast(Stormstrike) then
				Target:Cast(Stormstrike);
				return;
			end
			-- Flameshock (Keep up, will not work in mc & bwl due to mobs fire resist, will work in zg,aq & naxx) 
			if IsOptionEnabled("Flame Shock") and Player:ManaPercentage() > GetOptionValue("Flame Shock") and Target:CanCast(FlameShock) and not Target:Debuff(FlameShock) and (PlayerTargetGuid() ~= LastFlameShockedTargetGUID or NextFlameShockTime < GetTime()) then
				LastFlameShockedTargetGUID, NextFlameShockTime = PlayerTargetGuid(), GetTime() + 12;
				Target:Cast(FlameShock);
				return;
			end
			-- Frostshock (Use when flameshock is up), remember to use Stormstrike 1000% prio over other spells. Cake. 
			if IsOptionEnabled("Frost Shock") and Player:ManaPercentage() > GetOptionValue("Frost Shock") and Target:CanCast(FrostShock) then
				Target:Cast(FrostShock);
				return;
			end
			-- Be careful with earthshock, high threat. But if you know you can use it, do it. Awesome dmg if used with storsmstrike. 
			if IsOptionEnabled("Earth Shock") and Player:ManaPercentage() > GetOptionValue("Earth Shock") and Target:Debuff(Stormstrike) and Target:CanCast(EarthShock) then
				Target:Cast(EarthShock);
				return;
			end
		end
	end
end

function Rotation:OutOfCombat ()
	-- Windfury Weapon
	if IsOptionEnabled("Weapon Imbue") and Player:CanCast(FlametongueWeapon) then
		if GetOptionValue("Weapon Imbue") == 1 and not self:HasImbue(FLAMETONGUE) then
			Player:Cast(FlametongueWeapon);
			return;
		end
		if GetOptionValue("Weapon Imbue") == 2 and not self:HasImbue(FROSTBRAND) then
			Player:Cast(FrostbrandWeapon);
			return;
		end
		if GetOptionValue("Weapon Imbue") == 3 and not self:HasImbue(ROCKBITER) then
			Player:Cast(RockbiterWeapon);
			return;
		end
		if GetOptionValue("Weapon Imbue") == 4 and not self:HasImbue(WINDFURY) then
			Player:Cast(WindfuryWeapon);
			return;
		end
	end
	-- Lightning Shield
	if IsOptionEnabled("Lightning Shield") and not Player:Buff(LightningShield) and Player:CanCast(LightningShield) then
		Player:Cast(LightningShield);
		return;
	end
	-- Offensive / Engage
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		if IsOptionEnabled("Initiate Combat") then
			self:Combat();
		end
	end
end