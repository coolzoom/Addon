--TO DO
-- Add all blessing buff checks to might so they dont overwrite
--- Paladin
Rotations.PALADIN = {
	TablesRefreshed = 0,
	SpamPrevention = 0,
	selectedJudgement = nil;
};
local Rotation = Rotations.PALADIN;

function Rotation:Initialize ()
	-- Spell.Create(SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, IsRacial)
	-- Holy
	HolyLight = Spell.Create("Spell_Holy_HolyBolt", false, false, false);
	FlashOfLight = Spell.Create("Spell_Holy_FlashHeal", false, false, false);
	DivineShield = Spell.Create("Spell_Holy_DivineIntervention", false, false, true);
	DivineProtection = Spell.Create("Spell_Holy_Restoration", false, false, true);
	LayOnHands = Spell.Create("Spell_Holy_LayOnHands", false, false, true);

	Judgement = Spell.Create("Spell_Holy_RighteousFury", true, true, true);

	SealOfRighteousness = Spell.Create("Ability_ThunderBolt", false, false, true);
	SealOfTheCrusader = Spell.Create("Spell_Holy_HolySmite", false, false, true);
	SealOfWisdom = Spell.Create("Spell_Holy_RighteousnessAura", false, false, true);
	SealOfCommand = Spell.Create("Ability_Warrior_InnerRage", false, false, true, 0, "Rank", 1);

	HammerOfWrath = Spell.Create("Ability_ThunderClap", true, true, false);
	Exorcism = Spell.Create("Spell_Holy_Excorcism_02", true, true, true);
	
	Consecration = Spell.Create("Spell_Holy_InnerFire", false, false, true, 0, "Rank", 1);
	HammerOfJustice = Spell.Create("Spell_Holy_SealOfMight", true, true, true);

	Purify = Spell.Create("Spell_Holy_Purify", false, false, true);
	Forbearance = Spell.Create("Spell_Holy_RemoveCurse", false, false, true);
	Cleanse = Spell.Create("Spell_Holy_Renew", false, false, true);

	-- Options
	-- (Name, Checked, Min, Max, Default)
	AddAllClassOptions();
	AddOption("General", "Seal Selection", "header");
	AddOption("General", "Seal Of Command", true);
	AddOption("General", "Seal Of The Crusader", false);
	AddOption("General", "Seal Of Righteousness", true);
	--AddOption("General", "Seal Of Light", false);
	--AddOption("General", "Seal Of Justice", false);
	AddOption("General", "Seal of Wisdom", true, 1, 100, 10, "Will use Seal of Wisdom if we fall below this mana percent"..C.TOOLTIP_VALUE.."Mana threshold.");
	AddOption("General", "Seal of Wisdom Max", "none", 1, 100, 70, "Will no longer use seal of wisdom once we get above this mana percent."..C.TOOLTIP_VALUE.."Mana threshold.");

	AddOption("Offensive", "Exorcism", true, 1, 100, 25, "Use Exorcism on undead when above this mana percent."..C.TOOLTIP_VALUE.."Mana threshold.");
	AddOption("Offensive", "Hammer of Wrath", true, 1, 100, 30, "Use Hammer of Wrath when above this mana percent."..C.TOOLTIP_VALUE.."Mana threshold.");
	AddOption("Offensive", "Consecration", true, 1, 100, 25, "Use Consecration when above this mana percent."..C.TOOLTIP_VALUE.."Mana threshold.");
	AddOption("Offensive", "Judgement Options", "header");
	AddOption("Offensive", "Judgement", true, 1, 100, 20, "Use Judgement when above this mana percent."..C.TOOLTIP_VALUE.."Mana threshold.");
	AddOption("Offensive", "Maintain Crusader Debuff", false, "Will maintain the debuff applied by juding Seal of the Crusader on your target.");
	AddOption("Offensive", "Maintain Wisdom Debuff", false, "Will maintain the debuff applied by juding Seal of Wisdom on your target.");
	AddOption("Offensive", "SoC Judgement Stun", false, "If Hammer of Justice will come off of cooldown and can be used before our judgement can cooldown, it will wait to use it on a stunned target." );
	
	AddOption("Defensive", "Divine Shield", true, 1, 100, 10, "Use Divine Shield when below this health percent. Will follow Holy Light OOC Health values for healing with shield up."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Defensive", "Lay on Hands", true, 1, 100, 10, "Use Lay on Hands when below this health percent and don't have Divine Shield buff."..C.TOOLTIP_VALUE.."Health threshold.");
	AddOption("Defensive", "Purify/Cleanse", true, "Use purify/cleanse to dispel poison, disease and magic from the player.");
	AddOption("Defensive", "Holy Light", true, 0, 100, 25);
	AddOption("Defensive", "Holy Light OOC", true, 0, 100, 75);
	AddOption("Advanced", "Command Rank", "none", 1, 5, 5, "Use a different rank of Seal of Command."..C.TOOLTIP_VALUE.."Rank threshold.", SealOfCommand);
	AddOption("Advanced", "Consecration Rank", "none", 1, 5, 5, "Use a different rank of Consecration."..C.TOOLTIP_VALUE.."Rank threshold.", Consecration);

	if not Rotation.Activated then
		Rotation.Activated = true;
		print("|cFFFFDD11[DPSEngine]|r Paladin Rotation Initialized.");
	end
	--Spec Notification
	local Spec = Talent.Create(1, 7, 2):Rank() > 0 and "Holy - Not Supported" or Talent.Create(2, 7, 2):Rank() > 0 and "Protection - Not Supported" or Talent.Create(3, 7, 2):Rank() > 0 and "Retribution" or "Leveling or Hybrid";
	if Rotation.Spec ~= Spec then
		Rotation.Spec = Spec;
		print("|cFFFFDD11[DPSEngine]|r Rotation Tuning: "..Spec);
	end
	-- Find Attack Actions (Slot ID for Weapon = WeaponPosition // Slot ID for Bow/Wand = BowWandPosition)
	SpellBook:FindAttackActions();

end
-- Tables will be refreshed every 0.5s from the Pulse
function Rotation:UnitTables ()
	if UseAOE() and Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) then
		Enemies_5y, NumEnemies_5y = Target:EnemiesWithinDistance(5, true);
	else
		Enemies_5y, NumEnemies_5y = { Target }, 1;
	end
end

function Rotation:Pulse ()
	if not Player:IsReady() or GetTime() < Rotation.SpamPrevention or Player:IsCastingSpell() then
		return;
	end

	Rotation.SpamPrevention = GetTime() + 0.05;

	if Player:IsInCombat() then	

		--self:Defensives();
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not SealOfRighteousness:IsOnCooldown() then
			self:Combat();
			return;
		end
	else
		self:OutOfCombat();
	end
end

-- Abilities that are not on GCD
function Rotation:OffGCDAbilities ()
	local targetExists = Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer());
	if targetExists and Rotation.selectedJudgement and IsOptionEnabled("Judgement") then
		--SoC Stun damage
		if Player:Buff(SealOfCommand) and IsOptionEnabled("SoC Judgement Stun") then
			if Target:CanCast(Judgement) and HammerOfJustice:Cooldown() > 8 then
				Target:Cast(Judgement);
			end
		elseif Target:CanCast(Judgement) and Player:ManaPercentage() > GetOptionValue("Judgement") then
			if not Player:Buff(SealOfCommand) and not Player:Buff(SealOfRighteousness) then
				--Refresh our seals debuff
				if not Target:Debuff(Rotation.selectedJudgement) and ((Rotation.selectedJudgement == SealOfWisdom and IsOptionEnabled("Maintain Wisdom Debuff")) or (Rotation.selectedJudgement == SealOfTheCrusader and IsOptionEnabled("Maintain Crusader Debuff"))) then
					Target:Cast(Judgement);
				end
			else
				--Do some damage
				Target:Cast(Judgement);
			end
		end
	end
end

function Rotation:Combat ()
	local shieldAbility = DivineShield:Exists() and DivineShield or DivineProtection;
	if Player:IsInCombat() then
		--Divine Shield		
		if IsOptionEnabled("Divine Shield") and Player:CanCast(shieldAbility) and Player:HealthPercentage() <= GetOptionValue("Divine Shield") then
			Player:Cast(shieldAbility);
			return;
		end
		--Lay on Hands
		if IsOptionEnabled("Lay on Hands") and Player:CanCast(LayOnHands) and Player:HealthPercentage() <= GetOptionValue("Lay on Hands") and not Player:Buff(shieldAbility) then
			Player:Cast(LayOnHands);
			return;
		end
	end
	--Cleanse
	local dispelAbility = Cleanse:Exists() and Cleanse or Purify;
	if IsOptionEnabled("Purify/Cleanse") and Player:CanCast(dispelAbility) and Player:HasDebuffType("Poison", "Disease", dispelAbility == Cleanse and "Magic" or nil) then
		Player:Cast(dispelAbility);
		return;
	end
	--Holy Light - Divine Shield
	if IsOptionEnabled("Holy Light OOC") and Player:Buff(shieldAbility) and Player:HealthPercentage() <= GetOptionValue("Holy Light OOC") and Player:CanCast(HolyLight) then
		Player:Cast(HolyLight);
		return;
	end
	-- Holy Light
	if IsOptionEnabled("Holy Light") and Player:HealthPercentage() <= GetOptionValue("Holy Light") and Player:CanCast(HolyLight) then
		Player:Cast(HolyLight);
		return;
	end

	local targetExists = Target:Exists() and not Target:IsDeadOrGhost() and Player:CanAttack(Target) and (Target:IsInCombat() or IsOptionEnabled("Initiate Combat")) and (not IsOptionEnabled("Avoid Tapped Monsters") or Target:IsTappedByPlayer());
	if targetExists then
		--Enable Auto Attack
		if IsOptionEnabled("Auto Attack") and WeaponPosition and not IsCurrentAction(WeaponPosition) then
			UseAction(WeaponPosition);
		end
		-- Hammer of Justice
		if IsOptionEnabled("SoC Judgement Stun") and IsOptionEnabled("Judgement") and Player:ManaPercentage() > GetOptionValue("Judgement") and Target:CanCast(HammerOfJustice) and not Judgement:IsOnCooldown() and Player:Buff(SealOfCommand) then
			Target:Cast(HammerOfJustice);
			return;
		end
		--Exorcism
		if IsOptionEnabled("Exorcism") and (Target:CreatureType() == "Undead" or Target:CreatureType() == "Demon") and Player:ManaPercentage() > GetOptionValue("Exorcism") and Target:CanCast(Exorcism) and not Player:Buff(SealOfWisdom) then
			Target:Cast(Exorcism);
			return;
		end
		--Hammer of Wrath
		if IsOptionEnabled("Hammer of Wrath") and Player:ManaPercentage() > GetOptionValue("Hammer of Wrath") and Target:CanCast(HammerOfWrath) and not Player:Buff(SealOfWisdom) then
			Target:Cast(HammerOfWrath);
			return;
		end
		--Seal Selector
		if IsOptionEnabled("Seal of Wisdom") and SealOfWisdom:Exists() and ((not Player:Buff(SealOfWisdom) and Player:ManaPercentage() < GetOptionValue("Seal of Wisdom")) or (Rotation.selectedJudgement == SealOfWisdom and Player:ManaPercentage() < GetOptionValue("Seal of Wisdom Max"))) then
			Rotation.selectedJudgement = SealOfWisdom;
		elseif IsOptionEnabled("Judgement") and IsOptionEnabled("Maintain Wisdom Debuff") and SealOfWisdom:Exists() and not Target:Debuff(SealOfWisdom) and not Judgement:NeedsResources() and Judgement:Cooldown() <= 1.5 then
			Rotation.selectedJudgement = SealOfWisdom;
		elseif IsOptionEnabled("Judgement") and IsOptionEnabled("Maintain Crusader Debuff") and SealOfTheCrusader:Exists() and not Target:Debuff(SealOfTheCrusader) and not Judgement:NeedsResources() and Judgement:Cooldown() <= 1.5 then
			Rotation.selectedJudgement = SealOfTheCrusader;
		elseif IsOptionEnabled("Seal Of Command") and SealOfCommand:Exists() then
			Rotation.selectedJudgement = SealOfCommand;
		elseif IsOptionEnabled("Seal Of The Crusader") and SealOfTheCrusader:Exists() then
			Rotation.selectedJudgement = SealOfTheCrusader;
		elseif IsOptionEnabled("Seal Of Righteousness") and SealOfRighteousness:Exists() then
			Rotation.selectedJudgement = SealOfRighteousness;
		elseif IsOptionEnabled("Seal Of Wisdom") and SealOfWisdom:Exists() then
			Rotation.selectedJudgement = SealOfWisdom;
		elseif IsOptionEnabled("Seal Of Light") and SealOfLight:Exists() then
			Rotation.selectedJudgement = SealOfLight;
		elseif IsOptionEnabled("Seal Of Justice") and SealOfJustice:Exists() then
			Rotation.selectedJudgement = SealOfJustice;
		else 
			Rotation.selectedJudgement = nil;
		end
		--Cast Seal
		if Rotation.selectedJudgement and not Player:Buff(Rotation.selectedJudgement) and Player:CanCast(Rotation.selectedJudgement) then
			Player:Cast(Rotation.selectedJudgement);
			return;
		end
		--Consecration
		if IsOptionEnabled("Consecration") and not Player:Buff(SealOfWisdom) and Player:ManaPercentage() > GetOptionValue("Consecration") and Player:CanCast(Consecration) and Player:DistanceTo(Target) <= 5 then
			Player:Cast(Consecration);
		end
	end
end

function Rotation:OutOfCombat ()
	-- Holy Light
	if IsOptionEnabled("Holy Light OOC") and Player:HealthPercentage() <= GetOptionValue("Holy Light OOC") and Player:CanCast(HolyLight) then
		Player:Cast(HolyLight);
		return;
	end
	if IsOptionEnabled("Initiate Combat") then
		self:OffGCDAbilities();
		--- Global Cooldown Check
		if not SealOfRighteousness:IsOnCooldown() then
			self:Combat();
			return;
		end
	end

end