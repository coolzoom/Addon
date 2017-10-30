--- MetaTable that will be the parent of every objects
Unit = {};
Unit.__index = Unit;

--- Constructor
function Unit.Create (Identifier)
	-- Create a new Table that will represent the Object
   local NewObject = {};
   -- Define the MetaTable that will be the parent of the Object
   setmetatable(NewObject, Unit);
   -- Initialize our object, define it's specific values
   NewObject.Identifier = Identifier;
   NewObject.UnitID = Identifier;
   -- Return the built Object
   return NewObject;
end

--- Get units from the Object Manager and filter them.
UnitsEngine = CreateFrame("Frame", Randomize());
UnitsEngine.Units = {Friendly = {}, Hostile = {}, HostileCount = 1, FriendlyCount = 1};

function UnitsEngine.Fetch ()
	local TempHostile, TempFriendly = {}, {};
	UnitsEngine.Units.HostileCount = 1; 
	UnitsEngine.Units.FriendlyCount = 1;
	local ThisUnit, IsFriendly, IsType, Attackable;
	local X, Y, Z = GetUnitPosition("player");
	for Index = 1, GetUnitNearPositionCount(X, Y, Z, 70) do
		ThisUnit = Unit.Create(GetUnitNearPositionByIndex(Index));
		if ThisUnit:Exists() and not ThisUnit:IsDeadOrGhost() then
			Attackable = Player:CanAttack(ThisUnit);
			ThisUnit.X, ThisUnit.Y, ThisUnit.Z = GetUnitPosition(ThisUnit.UnitID);
			if Attackable then
				TempHostile[UnitsEngine.Units.HostileCount] = ThisUnit;
				UnitsEngine.Units.HostileCount = UnitsEngine.Units.HostileCount + 1;
			else
				TempFriendly[UnitsEngine.Units.FriendlyCount] = ThisUnit;
				UnitsEngine.Units.FriendlyCount = UnitsEngine.Units.FriendlyCount + 1;
			end
		end
	end
	-- Set the totals so they can be used as index counts
	UnitsEngine.Units.HostileCount = UnitsEngine.Units.HostileCount - 1;
	UnitsEngine.Units.FriendlyCount = UnitsEngine.Units.FriendlyCount - 1;
	-- Transsfer temp tables to their tables
	UnitsEngine.Units.Hostile = TempHostile;
	UnitsEngine.Units.Friendly = TempFriendly;
	-- Get the common unit's Positions
	if Target:Exists() then
		Target.X, Target.Y, Target.Z = GetUnitPosition(Target.UnitID);
	end
end

---------------------------------------------------
----------- Units Gathering Functions -------------
---------------------------------------------------
--- Get the player enemies within a distance of the unit.
--@param Distance - Number - The maximum distance from the unit.
--@param PlayerCenteredAoE - Boolean - Set to true if the distance is for an AoE Spell casted by the Player.
--@return - Table - A table containing the enemies within the given distance from the unit.
function Unit:EnemiesWithinDistance (Distance, PlayerCenteredAoE)
	local EnemiesTable, EnemiesCount, EnemyUnits, ThisUnit = {}, 0, UnitsEngine.Units.Hostile, nil;
	for i = 1, UnitsEngine.Units.HostileCount do
		ThisUnit = UnitsEngine.Units.Hostile[i];
		if ThisUnit and ThisUnit:Exists() and not ThisUnit:IsDeadOrGhost() and self:DistanceTo(ThisUnit, false, PlayerCenteredAoE) <= Distance and ThisUnit:IsInCombat() and Player:CanAttack(ThisUnit) then
			table.insert(EnemiesTable, ThisUnit);
			EnemiesCount = EnemiesCount + 1;
		end
	end
	return EnemiesTable, EnemiesCount;
end

function Unit:CanAttack (Other)
	return UnitCanAttack(self.UnitID, Other.UnitID) == 1;
end

--Returns the units creature type as a local string
function Unit:CreatureType ()
	return UnitCreatureType(self.UnitID);
end
local function TestPrint (TestMode, String)
	if TestMode then
		print("|cFFFFDD11[CanCast] |cFFFFFFFF" .. String);
	end
end
--- See if a spell can be casted (Use slot 26 (Right Action Bar Action 2))
function Unit:CanCast (Spell, SkipUsable, SkipRange, SkipMoving, TestMode)
	--local TestMode = true;
	if Spell:Exists() then
		-- If an ability could not be found in the Action Bars, Initialize again
		if GetActionName(Spell.Position) ~= Spell:Name() then
			if CursorHasItem() or CursorHasSpell() then
				return false;
			else
				Rotations[Player:Class()].Initialized = false;
				return false;
			end
		end
		if Spell:Cooldown() == 0 then
		   	TestPrint(TestMode, Spell:Name().." - Added Spell - IsHostile = ".. (Spell.IsHostile == true and "true" or Spell.IsHostile == false and "false" or "wrong"));
		   	-- Range Check
		   	if not Spell:IsBeingCasted() and (Spell.IsHostile == false or SkipRange or (IsActionInRange(Spell.Position) and IsActionInRange(Spell.Position) == 1)) then
		   		TestPrint(TestMode, Spell:Name().." - IsActionInRange Worked - IsUsableAction = "..(IsUsableAction(Spell.Position) == true and "true" or IsUsableAction(Spell.Position) == false and "false" or "wrong"));
		   		-- IsUsable Check (Includes Stances / Rage / Mana / Energy / Combos checks)
		   		if SkipUsable or (IsUsableAction(Spell.Position) and GetActionCooldown(Spell.Position) == 0) then
		   			TestPrint(TestMode, Spell:Name().." - IsUsableAction Worked - Spell.RequiresFacing = "..(Spell.RequiresFacing == true and "true" or Spell.RequiresFacing == false and "false" or "wrong"));
		   			--Check Moving
		   			if SkipMoving or Spell.Instant or not Player:IsMoving() then
		   				-- Check Facing if needed
			   			if not Spell.RequiresFacing or Player:IsFacing(self) then
		   					TestPrint(TestMode, Spell:Name().." - Facing Worked - InLineOfSight = "..(Player:InLineOfSight(self) == true and "true" or Player:InLineOfSight(self) == false and "false" or "wrong"));
				   			-- If all went well, check Line of sight
				   			if Player:InLineOfSight(self) then
		   						TestPrint(TestMode, Spell:Name().." - Line of Sight Worked");
								return true;
							end
						end
					end
				end
			end
		end
	end
end

--- Cast a Spell
function Unit:Cast (Spell, Silent)
	if not Silent then
		Bug("Casting "..Colors.Green.Hex..Spell:Name().." ("..Spell:ID()..") |cffFFFFFFon "..Colors.Red.Hex..self:Name().." ("..self.UnitID..")");
	end
   	-- If it is cast on us, set 3rd arg to true
	if self:IsUnit(Player) then
	   	UseAction(Spell.Position, false, true);
	else
		CastSpell(Spell:ID(), "spell");
	end
	Spell.LastCastTime = GetTime();
end

--- Get the Unit's Class
function Unit:Class ()
	local LocalClass, GlobalClass = UnitClass(self.UnitID);
	return GlobalClass;
end

--- Get if a unit has a specific Debuff
--@param Spell - The spell icon
--@param RawIcon - The Icon string
function Unit:Buff (Spell, RawIcon)
	if RawIcon then Icon = RawIcon;  else Icon = Spell:Icon(); end
	local i = 1;
	while i < 41 do
		if UnitBuff(self.UnitID, i) == Icon then
			return true;
		end
		i = i + 1;
	end
	return false;
end

--- Get if a unit has a specific Debuff
--@param Spell - The spell icon
function Unit:Debuff (Spell, rawGuid)
	local unit = rawGuid and rawGuid or self.UnitID;
	local i, Icon = 1, Spell:Icon();
	while i < 17 do
		if UnitDebuff(unit, i) == Icon then
			return true;
		end
		i = i + 1;
	end
	return false;
end

function Unit:DebuffCount (Spell)
	local i, Icon = 1, Spell:Icon();
	while i < 17 do
		local icon, count = UnitDebuff(self.UnitID, i);
		if icon == Icon then
			return count;
		end
		i = i + 1;
	end
	return 0;
end

--- Get if a Unit is casting a specific spell
function Unit:IsCastingSpell (SpellID)
	return GetUnitCastingSpellId(self.UnitID) == SpellID;
end

--- Get if a Unit is casting any spell
function Unit:IsCasting ()
	return self:Exists() and not self:IsCastingSpell(0) or false;
end

--- Interrupt Handler
function Unit:UseInterrupt (InterruptSpell)
	if IsOptionEnabled("Interrupt") and self:IsCasting() and self:CanCast(InterruptSpell) then
		Bug("Using interrupt on "..Target:Name()..".")
		self:Cast(InterruptSpell);
		return true;
	end
end

--- Get the Unit's Combat Reach
--@return Number - The Unit's Combat Reach
function Unit:CombatReach ()
	return GetUnitCombatReach(self.UnitID);
end

--- Get the unit's melee range toward another unit.
-- @param Other The other unit.
-- @return The unit's melee range toward the other unit.
function Unit:MeleeRange (Other)
	return self:CombatReach() and Other:CombatReach() and math.max(self:CombatReach() + Other:CombatReach() + 4 / 3, 5) or 1;
end

--- Get the distance between the unit and another unit.
--@param Other - Unit Object - The other unit.
--@return Number - The distance between the units.
function Unit:DistanceTo (Other, AbsoluteDistance, PlayerCenteredAoE)

	if Other == nil or not Other:Exists() then return 100; end
	local SelfPosition = self:Position();
	local OtherPosition = Other:Position();
	local Reach1 = self:CombatReach() or 0;
	local Reach2 = Other:CombatReach() or 0;
	local MeleeRange = self:MeleeRange(Other);
	local WeirdZone = math.min(MeleeRange+0.1, 7.9);
	local DistanceMelee = SelfPosition:DistanceTo(OtherPosition)/MeleeRange*5;
	local DistanceReach = SelfPosition:DistanceTo(OtherPosition)-(Reach1+Reach2);
	local DistancePlayerCenteredAoE = SelfPosition:DistanceTo(OtherPosition)-Reach2;
	if AbsoluteDistance then
		return SelfPosition:DistanceTo(OtherPosition);
	end
	if PlayerCenteredAoE then
		return DistancePlayerCenteredAoE;
	elseif DistanceMelee <= 5 then
		return DistanceMelee;
	elseif DistanceReach <= WeirdZone then
		return WeirdZone;
	else
		return DistanceReach;
	end
end

--- Get if the Unit Exists
function Unit:Exists ()
	return UnitExists(self.UnitID) == 1;
end

--- Get the units facing direction in radians
function Unit:Facing ()
	return GetUnitFacing(self.UnitID);
end

--- Get the Unit's GUID
function Unit:GUID ()
	return PlayerTargetGuid();
end

--- Get the Unit's Health
function Unit:Health ()
	return UnitHealth(self.UnitID);
end

--- Get Unit's Max Health
function Unit:MaxHealth ()
	return UnitHealthMax(self.UnitID);
end

--- Determine if the unit is tapped by the player or their group
function Unit:IsTappedByPlayer ()
	return not UnitIsTapped(self.UnitID) or UnitIsTappedByPlayer(self.UnitID);
end

--Return true if the unit is grey to us
function Unit:IsTrivial ()
	return UnitIsTrivial(self.UnitID);
end
--- Get the Unit's Health Percentage
function Unit:HealthPercentage ()
	return UnitHealth(self.UnitID)/UnitHealthMax(self.UnitID)*100;
end

--- Get the Unit's Identifier
function Unit:Identifier ()
	return self.UnitID;
end

--- Get if a unit is behind another
function Unit:IsBehind (Other)
	return not Other:IsFacing(self);
end

--- See if a unit is In Line of Sight of another unit
function Unit:InLineOfSight (Other)
	if self:Exists() and Other:Exists() then
		if self:DistanceTo(Other) >= 100 then
			return false;
		end
		local SelfX, SelfY, SelfZ = Player.X, Player.Y, Player.Z;
		local OtherX, OtherY, OtherZ = Other.X, Other.Y, Other.Z;
		if SelfX and SelfY and SelfZ and OtherX and OtherY and OtherZ then
			return TraceLine(SelfX, SelfY, SelfZ + 2.25, OtherX, OtherY, OtherZ + 2.25) == nil;
		end
	else
		return false;
	end
end

--- Get if a unit is Dead or Ghost
function Unit:IsDeadOrGhost ()
	return UnitIsDeadOrGhost(self.UnitID);
end

--- Get whether the unit is facing another unit.
-- @param Other The other unit.
-- @return Whether the unit is facing the other unit.
function Unit:IsFacing (Other)
	local SelfX, SelfY = self.X, self.Y;
	local SelfFacing = self:Facing();
	local OtherX, OtherY = Other.X, Other.Y;
	local Angle = SelfX and SelfY and OtherX and OtherY and SelfFacing and ((SelfX - OtherX) * math.cos(-SelfFacing)) - ((SelfY - OtherY) * math.sin(-SelfFacing)) or 0
	return Angle < 0;
end

--- Get if a unit is in combat
function Unit:IsInCombat ()
	return UnitAffectingCombat(self.UnitID) == 1;
end

--- Get if two units are the same
function Unit:IsUnit (Other)
	return UnitIsUnit(self.UnitID, Other.UnitID) == 1;
end

--- Get Unit's Level
function Unit:Level ()
	return UnitLevel(self.UnitID);
end

--- Get the Unit's Name
function Unit:Name ()
	return UnitName(self.UnitID);
end

--- Get the Unit's Position
function Unit:Position ()
	return Vector3.Create(self.X, self.Y, self.Z);
end

--- Get the Unit's Race
function Unit:Race ()
	return UnitRace(self.UnitID);
end

--@ TimeToDie
TTDUnits = {};
TTDMinimumTime = 5;
TTDBugEnabled = false;
function TTDBug (String)
	if TTDBugEnabled then
		print(Colors.Red.Hex.."[TTD] "..Colors.White.Hex..String)
	end
end

function TTDRefresh ()
	local FetchedUnits = UnitsEngine.Units.Hostile;
	local FetchedUnitsCount = UnitsEngine.Units.HostileCount;
	local Found;
	--- Remove Dead Units
	for Key, Value in pairs(TTDUnits) do
		Found = false;
		for i = 1, UnitsEngine.Units.HostileCount do
			if UnitsEngine.Units.Hostile[i].UnitID == Key then
				Found = true;
				break;
			end
		end
		if not Found then
			TTDBug("Removing Unit "..Key);
			TTDUnits[Key] = nil;
		end
	end
	--- Refresh Units Health
	local ThisUnit, ThisUnitString, ThisUnitHealth, ThisUnitHealthMax, Values, Time;
	for i = 1, UnitsEngine.Units.HostileCount do
		ThisUnit = UnitsEngine.Units.Hostile[i];
		TTDUnit = TTDUnits[ThisUnit.UnitID];
		if ThisUnit:Health() < ThisUnit:MaxHealth() then
			--- Add Unit if it's not there yet
			if TTDUnit == nil then
				TTDUnits[ThisUnit.UnitID] = { Health = ThisUnit:Health(), MaxHealth = ThisUnit:MaxHealth(), Engaged = GetTime() };
			else 
				TTDUnit.Health = ThisUnit:Health();
				if GetTime() - TTDUnit.Engaged > TTDMinimumTime then
					-- Health Lost per second
					TTDUnit.HealthLostPerSecond = (TTDUnit.MaxHealth - TTDUnit.Health) / (GetTime() - TTDUnit.Engaged);
					-- Health Lost per second
					TTDUnit.TimeToDie = math.floor((TTDUnit.Health / TTDUnit.HealthLostPerSecond*10))/10;
					TTDBug("TTD "..TTDUnit.TimeToDie);
				else
					TTDUnit.TimeToDie = 30;
					TTDBug("Base TTD 30");
				end
			end
		end
	end
end

function Unit:TimeToDie ()
	local GUID = self.UnitID == "target" and PlayerTargetGuid() or self.UnitID;
	return TTDUnits[GUID] and TTDUnits[GUID].TimeToDie or 60;
end

--- Use an Item
function Unit:UseItem (Item)
	Bug("Using Trinket "..Colors.Green.Hex..(Item.Index == 13 and "1" or "2").." |cffFFFFFFon "..Colors.Red.Hex..self:Name().." ("..self.UnitID..")");
   	-- If it is cast on us, set 3rd arg to true
	if self:IsUnit(Player) then
	   	UseAction(Item.Position, false, true);
	else
		UseAction(Item.Position, false, false);
	end
	Item.LastUseTime = GetTime();
end

--- Units
local Unit = Unit.Create;
Player = Unit("player");
Target = Unit("target");
TargetTarget = Unit("targettarget");
PetTarget = Unit("pettarget");