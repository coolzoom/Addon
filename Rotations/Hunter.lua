--- Hunter
Rotations.HUNTER = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	petAttack = false,
	shotTime = 0,
	Spec = "None",
	Activated = false
};
local Rotation = Rotations.HUNTER;
function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Racials
	
	BloodFury = Spell.Create("Racial_Orc_BerserkerStrength", false, false, true, 0, "Racial");
	Berserking = Spell.Create("Racial_Troll_Berserk", false, false, true, 0, "Racial");
	-- Beastmaster
	-- AspectOfTheBeast = Spell.Create("Ability_Mount_PinkTiger", false, false, true, 0);
	Intimidation = Spell.Create("Ability_Devour", false, false, true, 0);
	BestialWrath = Spell.Create("Ability_Druid_FerociousBite", false, false, true, 0);
	-- AspectOfTheCheetah = Spell.Create("Ability_Mount_JungleTiger", false, false, true, 0);
	AspectOfTheHawk = Spell.Create("Spell_Nature_RavenForm", false, false, true, 0, nil, "Spell_Nature_WispSplode");
	-- AspectOfTheMonkey = Spell.Create("Ability_Hunter_AspectOfTheMonkey", false, false, true, 0);
	-- AspectOfThePack = Spell.Create("Ability_Mount_WhiteTiger", false, false, true, 0);
	-- AspectOfTheWild = Spell.Create("AspectOfTheWild", false, false, true, 0);
	-- BeastLore = Spell.Create("Ability_Physical_Taunt");
	-- EagleEye = Spell.Create("Ability_Hunter_EagleEye");
	-- EyesOfTheBeast = Spell.Create("Ability_EyeOfTheOwl");
	-- MendPet = Spell.Create("Ability_Hunter_MendPet");
	-- ScareBeast = Spell.Create("Ability_Druid_Cower");
	-- Marksmanship
	AimedShot = Spell.Create("INV_Spear_07", true, true, false, 41);
	ArcaneShot = Spell.Create("Ability_ImpalingBolt", true, true, true, 41);
	ConcussiveShot = Spell.Create("Spell_Frost_Stun", true, true, true, 41);
	-- DistractingShot = Spell.Create("Spell_Arcane_Blink", true, true, true, 41);
	-- Flare = Spell.Create("Spell_Fire_Flare");
	HuntersMark = Spell.Create("Ability_Hunter_SniperShot", true, true, true, 100);
	MultiShot = Spell.Create("Ability_UpgradeMoonGlaive", true, true, true, 41);
	RapidFire = Spell.Create("Ability_Hunter_RunningShot", false, false, true, 0);
	ScorpidSting = Spell.Create("Ability_Hunter_CriticalShot", true, true, true, 41);
	SerpentSting = Spell.Create("Ability_Hunter_Quickshot", true, true, true, 41);
	TrueshotAura = Spell.Create("Ability_TrueShot", false, false, true, 0);
	ViperSting = Spell.Create("Ability_Hunter_AimedShot", true, true, true, 41);
	-- Volley = Spell.Create("Ability_Marksmanship");
	-- Survival
	-- Disengage = Spell.Create("Ability_Rogue_Feint", true, true, true, 5);
	-- ExplosiveTrap = Spell.Create("Spell_Fire_SelfDestruct");
	FeignDeath = Spell.Create("Ability_Rogue_FeignDeath", false, false, true, 0);
	-- FreezingTrap = Spell.Create("Spell_Frost_ChainsOfIce");
	-- FrostTrap = Spell.Create("Spell_Frost_FreezingBreath");
	-- ImmolationTrap = Spell.Create("Spell_Fire_FlameShock");
	MongooseBite = Spell.Create("Ability_Hunter_SwiftStrike", true, true, true, 5);
	RaptorStrike = Spell.Create("Ability_MeleeDamage", true, true, true, 5);
	-- TrackBeasts = Spell.Create("Ability_Tracking");
	-- TrackDemons = Spell.Create("Spell_Shadow_SummonFelHunter");
	-- TrackDragonkin = Spell.Create("INV_Misc_Head_Dragon_01");
	-- TrackElemental = Spell.Create("Spell_Frost_SummonWaterElemental");
	-- TrackGiants = Spell.Create("Ability_Racial_Avatar");
	-- TrackHidden = Spell.Create("Ability_Stealth");
	-- TrackHumanoids = Spell.Create("Spell_Holy_PrayerOfHealing");
	-- TrackUndead = Spell.Create("Spell_Shadow_DarkSummoning");
	WingClip = Spell.Create("Ability_Rogue_Trip", true, true, true, 5);

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();

	--AddOption("General", "Handle Pet", true);
	AddOption("General", "Pet Assist", true, "Will make sure your pet is always attacking your current target if you switch targets");
	AddOption("General", "Concussive Shot", true, "Use on cooldown.");
	AddOption("General", "Hunter's Mark", true, "Keep debuff up on our target.");
	AddOption("General", "Trueshot Aura", true, "Keep buff up on ourself.");
	AddOption("General", "Wing Clip", true, "Keep debuff up on our target.");

	AddOption("Offensive", "Cooldowns", "header");
	AddOption("Offensive", "Bestial Wrath", true, "Use on cooldown.");
	AddOption("Offensive", "Intimidation", true, "Use on cooldown.");
	AddOption("Offensive", "Rapid Fire", true, "Use on cooldown.");
	AddOption("Offensive", "Offensive Racials", false, "Use on cooldown.");
	AddOption("Offensive", "Abilities", "header");
	AddOption("Offensive", "Aimed Shot", false, "Use Aimed Shot. Disable it to use Arcane Shot instead.");
	AddOption("Offensive", "Multi-Shot", false, 1, 10, 3, "Use Multi-Shot."..C.TOOLTIP_VALUE.."Amount of units needed within 5 yards of our target to use.");
	AddOption("Offensive", "Serpent Sting", true, "Keep debuff up on our target.");
	AddOption("Offensive", "Scorpid Sting", false, "Keep debuff up on our target.");
	AddOption("Offensive", "Viper Sting", false, "Keep debuff up on our target.");

	AddOption("Defensive", "Cooldowns", "header");
	AddOption("Defensive", "Feign Death", false, 1, 100, 20, "Use when we get Low Health."..C.TOOLTIP_VALUE.."Health threshold.");
	--AddOption("Defensive", "Abilities", "header");
	--AddOption("Defensive", "Mend Pet", true, 1, 100, 80, "Use when our Pet get Low Health."..C.TOOLTIP_VALUE.."Health threshold.");

	-- AddOption("General", "Rotations Specs", "header");
	-- AddOption("General", "Spec 1: Beastmaster", "none");
	-- AddOption("General", "Spec 2: Marksmanship", "none");
	-- AddOption("General", "Spec 3: Survival", "none");
	ShouldMongoose = 0;
	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Hunter Rotation Initialized.");
	end
	--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Beast Mastery" or Talent.Create(2, 7, 2):Rank() > 0 and "Marksmanship" or Talent.Create(3, 7, 2):Rank() > 0 and "Survival - Not Supported" or "Leveling or Hybrid";
	if Rotation.Spec ~= Spec then
		Rotation.Spec = Spec;
		print("|cFFFFDD11[DPSEngine]|r Rotation Tuning: "..Spec);
	end
	-- Find Attack Actions (Slot ID for Weapon = WeaponPosition // Slot ID for Bow/Wand = BowWandPosition)
	SpellBook:FindAttackActions();
end

function Rotation:Pulse ()
	if not Player:IsReady() or GetTime() < Rotation.SpamPrevention or Player:Buff(FeignDeath) then
		return;
	end
	Rotation.SpamPrevention = GetTime() + 0.05;

	if Player:IsInCombat() then	

		self:Defensives();
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not WingClip:IsOnCooldown() then
			self:Combat();
			return;
		end
	else
		self:OutOfCombat();
	end
end

-- Defensive Abilities that are not on GCD
function Rotation:Defensives ()
	-- Feign Death
	if IsOptionEnabled("Feign Death") and Player:HealthPercentage() < GetOptionValue("Feign Death") and Player:CanCast(FeignDeath) then
		Player:Cast(FeignDeath);
		return;
	end
end


-- Abilities that are not on GCD
function Rotation:OffGCDAbilities ()

end

-- Tables will be refreshed every 0.5s from the Pulse
function Rotation:UnitTables ()
	if UseAOE() and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		Enemies_5y, NumEnemies_5y = Target:EnemiesWithinDistance(5, true);
	else
		Enemies_5y, NumEnemies_5y = { Target }, 1;
	end
end

-- 
function Rotation:Combat ()



	-- Trueshot Aura
	if IsOptionEnabled("Trueshot Aura") and Player:CanCast(TrueshotAura) and not Player:Buff(TrueshotAura) then
		Player:Cast(TrueshotAura);
		return;
	end
	-- Check if Target is valid
	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer()) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) then
		-- Check if Target is in shot range
		if Player:DistanceTo(Target) <= 35 and Player:DistanceTo(Target) >= 8 then

			--Pet Attack
			if IsOptionEnabled("Pet Assist") and Player:PetExists() and Rotation.petAttack == false then
				Bug("Casting "..Colors.Green.Hex.."Pet Attack |cffFFFFFFon "..Colors.Red.Hex..Target:Name().." ("..Target.UnitID..")");
				PetAttack();
				Rotation.petAttack = true;
			end

			-- Hunter's Mark
			if IsOptionEnabled("Hunter's Mark") and Target:CanCast(HuntersMark) and not Target:Debuff(HuntersMark) then
				Target:Cast(HuntersMark);
				return;
			end
			if CooldownsAllowed() then
				if IsOptionEnabled("Intimidation") and Player:CanCast(Intimidation) and Player:PetExists() then
					Player:Cast(Intimidation);
					return;
				end
				-- Rapid Fire
				if IsOptionEnabled("Rapid Fire") and Player:CanCast(RapidFire) then
					Player:Cast(RapidFire);
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
				if IsOptionEnabled("Bestial Wrath") and Player:CanCast(BestialWrath) and Player:PetExists() then
					Player:Cast(BestialWrath);
					return;
				end
			end
			--Concussive Shot
			if IsOptionEnabled("Concussive Shot") and Target:CanCast(ConcussiveShot) then
				Target:Cast(ConcussiveShot);
				return;
			end	
			-- Serpent Sting
			if IsOptionEnabled("Serpent Sting") and Target:CanCast(SerpentSting) and not Target:Debuff(SerpentSting) then
				Target:Cast(SerpentSting);
				return;
			end
			-- Multi-Shot
			if IsOptionEnabled("Multi-Shot") and NumEnemies_5y >= GetOptionValue("Multi-Shot") and Target:CanCast(MultiShot) then
				Target:Cast(MultiShot);
				return;
			end
			if AimedShot:Exists() and IsOptionEnabled("Aimed Shot") then
				-- Aimed Shot
				if Target:CanCast(AimedShot) then
					Target:Cast(AimedShot);
					return;
				end
			else
				-- Arcane Shot
				if Target:CanCast(ArcaneShot) then
					Target:Cast(ArcaneShot);
					return;
				end
			end
			--Auto Shot
			if IsOptionEnabled("Auto Shot / Attack") then
				if GetTime() - Rotation.shotTime > 1 and BowWandPosition and not IsAutoRepeatAction(BowWandPosition) and IsActionInRange(BowWandPosition) == 1 then
					Bug("Casting "..Colors.Green.Hex.."Auto Shot |cffFFFFFFon "..Colors.Red.Hex..Target:Name().." ("..Target.UnitID..")");
					UseAction(BowWandPosition);
					Rotation.shotTime = GetTime();
				end
			end
		elseif Player:DistanceTo(Target) < 8 then
			-- OverPower if BT and WW are on CD and our rage is low
			if Target:CanCast(MongooseBite) and ShouldMongoose > GetTime() then			
				Target:Cast(MongooseBite);
				return;
			end
			-- Raptor Strike
			if Target:CanCast(RaptorStrike) then
				Target:Cast(RaptorStrike);
				return;
			end
			-- Wing Clip
			if IsOptionEnabled("Wing Clip") and not Target:Debuff(WingClip) and Target:CanCast(WingClip) then
				Target:Cast(WingClip);
				return;
			end
		end
	end
end

function Rotation:OutOfCombat ()
	-- Trueshot Aura
	if IsOptionEnabled("Trueshot Aura") and Player:CanCast(TrueshotAura) and not Player:Buff(TrueshotAura) then
		Player:Cast(TrueshotAura);
		return;
	end

	if Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		-- Hunter's Mark
		if IsOptionEnabled("Hunter's Mark") and Target:CanCast(HuntersMark) and not Target:Debuff(HuntersMark) then
			Target:Cast(HuntersMark);
			return;
		end
		if IsOptionEnabled("Initiate Combat") then

			--Pet Attack
			if IsOptionEnabled("Pet Assist") and Player:PetExists() and Rotation.petAttack == false then
				Bug("Casting "..Colors.Green.Hex.."Pet Attack |cffFFFFFFon "..Colors.Red.Hex..Target:Name().." ("..Target.UnitID..")");
				PetAttack();
				Rotation.petAttack = true;
			end
			--Concussive Shot
			if IsOptionEnabled("Concussive Shot") and Target:CanCast(ConcussiveShot) then
				Target:Cast(ConcussiveShot);
				return;
			end	
			--Arcane Shot
			if Target:CanCast(ArcaneShot) then
				Target:Cast(ArcaneShot);
				return;
			end
			--Auto Shot
			if IsOptionEnabled("Auto Shot / Attack") then
				if GetTime() - Rotation.shotTime > 1 and BowWandPosition and not IsAutoRepeatAction(BowWandPosition) and IsActionInRange(BowWandPosition) == 1 then
					Bug("Casting "..Colors.Green.Hex.."Auto Shot |cffFFFFFFon "..Colors.Red.Hex..Target:Name().." ("..Target.UnitID..")");
					UseAction(BowWandPosition);
					Rotation.shotTime = GetTime();
				end
			end
		end
	end

end