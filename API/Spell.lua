--- Spell Book Functions
SpellBook = {}
SpellBook.Spells = {};
function SpellBook:Dump (SartIndex)
	local i = SartIndex;
	print("|cffFFDD11Spell Book Dump Begins");
	while GetSpellTexture(i, "spell") ~= nil do
		print(GetSpellName(i, "spell") .. " = " .. GetSpellTexture(i, "spell"))
		i = i + 1;
	end
end

--- Get the number of spell tabs in the player's spell book.
function SpellBook:TabsCount ()
	return GetNumSpellTabs();
end

--- Get the Spell Book Tab informations
function SpellBook:TabInfos (Tab)
	return {GetSpellTabInfo(Tab)};
end

--- Get the spell book tab name
function SpellBook:TabName (Tab)
	return SpellBook:TabInfos(Tab)[1];
end

--- Get the spell book tab icon
function SpellBook:TabIcon (Tab)
	return SpellBook:TabInfos(Tab)[2];
end

--- Get the spell book tab id
function SpellBook:TabID (Tab)
	return SpellBook:TabInfos(Tab)[3];
end

--- Get the spell book tab name
function SpellBook:TabSpellCount (Tab)
	return SpellBook:TabInfos(Tab)[4];
end

-- 1 - 12	Action Bar 1
-- 13 - 24	Action Bar 2
-- 25 - 36	Action Bar 3 (Right)
-- 37 - 48	Action Bar 4 (Right-2)
-- 49 - 60	Action Bar 5 (Bottom Left)
-- 61 - 72	Action Bar 6 (Bottom Right)
-- 73 - 84	Battle Stance (Warrior) or Stealth (Rogue)
-- 85 - 96	Defensive Stance (Warrior)
-- 97 - 108	Berserker Stance (Warrior)

WeaponPosition = nil;
BowWandPosition = nil;

function SpellBook:FindAttackActions ()
	local WeaponTexture, WeaponSpellID, BowWandTexture, BowWandSpellID;
	-- We will only scan while doing racials to avoid hammering the scan over and over again
	WeaponTexture, WeaponSpellID = GetInventoryItemTexture("player", 16) or nil, nil;
	if Player:Class() == "HUNTER" or Player:Class() == "WARLOCK" or Player:Class() == "MAGE" or Player:Class() == "PRIEST" then
		BowWandTexture, BowWandSpellID = GetInventoryItemTexture("player", 18) or nil, nil;
	end
	local i = 1;
	while GetSpellTexture(i, "spell") ~= nil and (iMax == nil or i <= iMax) do
		ThisIcon = GetSpellTexture(i, "spell");
		if WeaponTexture ~= nil and ThisIcon == WeaponTexture then
			WeaponSpellID = i;
		end
		if BowWandTexture ~= nil and ThisIcon == BowWandTexture then
			BowWandSpellID = i;
		end
		i = i + 1;
	end
	if WeaponSpellID ~= nil then
		local MaxActions = Player:Class() == "WARRIOR" and 108 or Player:Class() == "ROGUE" and 84 or 72;
		WeaponPosition = nil;
		for i = 1, MaxActions do
			if GetActionText(i) == nil and (GetActionTexture(i) == WeaponTexture) then
				WeaponPosition = i;
				break;
			end
		end
		-- If the spell is not in the player's Bars then we add it
		if WeaponPosition == nil then
			SpellBook.MovingActions = true;
		   	-- PickupSpell(spellID, "bookType")
		   	PickupSpell(WeaponSpellID, "spell");
		   	-- PlaceAction(slot)
		   	for i = 25, 80 do
		   		if GetActionText(i) == nil and GetActionTexture(i) == nil then
		   			EmptyIndex = i;
		   			break;
		   		end
		   	end
		   	PlaceAction(EmptyIndex);
		   	-- Clear Cursor to avoid diplaying it to the end user
		   	ClearCursor();
		   	SpellBook.MovingActions = false;
		   	WeaponPosition = EmptyIndex;
			print(Colors.Gold.Hex.."[DPSEngine]|r Auto Attack not found, adding it to slot #"..EmptyIndex..".");
		end
	end
	if BowWandSpellID ~= nil then
		local MaxActions = Player:Class() == "WARRIOR" and 108 or Player:Class() == "ROGUE" and 84 or 72;
		BowWandPosition = nil;
		for i = 1, MaxActions do
			if GetActionText(i) == nil and (GetActionTexture(i) == BowWandTexture) then
				BowWandPosition = i;
				break;
			end
		end
		-- If the spell is not in the player's Bars then we add it
		if BowWandPosition == nil then
			SpellBook.MovingActions = true;
		   	-- PickupSpell(spellID, "bookType")
		   	PickupSpell(BowWandSpellID, "spell");
		   	-- PlaceAction(slot)
		   	for i = 25, 80 do
		   		if GetActionText(i) == nil and GetActionTexture(i) == nil then
		   			EmptyIndex = i;
		   			break;
		   		end
		   	end
		   	PlaceAction(EmptyIndex);
		   	-- Clear Cursor to avoid diplaying it to the end user
		   	ClearCursor();
		   	SpellBook.MovingActions = false;
		   	BowWandPosition = EmptyIndex;
			print(Colors.Gold.Hex.."[DPSEngine]|r Auto Shot // Shoot not found, adding it to slot #"..EmptyIndex..".");
		end
	end
end

--- Parse the Spell Book
function SpellBook:FindSpellInfos (SpellIcon, RequiresFacing, IsHostile, Instant, MaxRange, Condition, AlternateIcon)
	local i, iMax, ThisIcon, StoredSpellIndex, StoredSpellPosition, Invalid, StoredSpellName, MaxRank, Counter = 1, nil, nil, nil, nil, nil, nil, nil, 0;
	-- Find the Spell in the Spell Book, Racials are in Tab 1 others are in tab 2-4
	local Tab1SpellCount = SpellBook:TabSpellCount(1);
	if Condition ~= "Racial" then
		i = Tab1SpellCount + 1;
	else
		iMax = Tab1SpellCount;
	end
	-- Rank Variable
	if Condition == "Rank" then
		MaxRank = AlternateIcon;
	end
	local excludedIcons = "Interface\\Icons\\Spell_Frost_FrostArmor02";
	while GetSpellTexture(i, "spell") ~= nil and (iMax == nil or i <= iMax) do
		ThisIcon = GetSpellTexture(i, "spell");
		--- If All went well, we add the spell to our spell book
		if ThisIcon == SpellIcon and (StoredSpellName == nil or StoredSpellName == GetSpellName(i, "spell") or ThisIcon == excludedIcons) then
			if MaxRank == nil or Counter < MaxRank then
				--print(ThisIcon.." is a valid spell found as ID: "..i);
				if StoredSpellName == nil or ThisIcon == excludedIcons then
					StoredSpellName = GetSpellName(i, "spell");
				end
				StoredSpellIndex = i;
				Counter = Counter + 1;
			end
		end
		i = i + 1;
	end
	if StoredSpellIndex ~= nil then
		ClearCursor();
		-- Look for the player's spells in their bars
		local MaxActions = Player:Class() == "WARRIOR" and 108 or Player:Class() == "ROGUE" and 84 or 72;
		StoredSpellPosition = nil;
		for i = 1, MaxActions do
			if GetActionText(i) == nil and StoredSpellName == GetActionName(i) then
				-- print(StoredSpellName.." was found in slot "..i)
				StoredSpellPosition = i;
				break;
			end
		end
		-- If the spell is not in the player's Bars then we add it
		if StoredSpellPosition == nil then
			SpellBook.MovingActions = true;
		   	-- PickupSpell(spellID, "bookType")
		   	PickupSpell(StoredSpellIndex, "spell");
		   	-- PlaceAction(slot)
		   	for i = 25, 80 do
		   		if GetActionText(i) == nil and GetActionTexture(i) == nil then
		   			EmptyIndex = i;
		   			break;
		   		end
		   	end
		   	PlaceAction(EmptyIndex);
		   	StoredSpellPosition = EmptyIndex;
		   	-- Clear Cursor to avoid diplaying it to the end user
		   	ClearCursor();
		   	SpellBook.MovingActions = false;
			print(Colors.Gold.Hex.."[DPSEngine]|r "..StoredSpellName.." not found, adding it to slot #"..EmptyIndex..".");
		else
			--- Replace Spells anyways to make sure they have high level ones
			SpellBook.MovingActions = true;
		   	PickupSpell(StoredSpellIndex, "spell");
		   	PlaceAction(StoredSpellPosition);
		   	ClearCursor();
		   	SpellBook.MovingActions = false;
		end
		return {StoredSpellIndex, GetSpellName(StoredSpellIndex, "spell"), StoredSpellPosition};
	end
	return {0, nil, 0};
end

function GetActionName (SlotID)
	if SlotID == nil then 
		return "";
	else
		ScanningTooltip:ClearLines();
		ScanningTooltip:SetAction(SlotID);
		return getglobal("ScanningTooltipTextLeft1"):GetText();
	end
end

--- MetaTable that will be the parent of every Spells objects
Spell = {};
Spell.__index = Spell;

--- Constructor
function Spell.Create (Icon, RequiresFacing, IsHostile, Instant, Range, Condition, AlternateIcon)
	local SpellIcon, AlternateIcon = "Interface\\Icons\\"..Icon, AlternateIcon ~= nil and type(AlternateIcon) == "string" and "Interface\\Icons\\"..AlternateIcon or AlternateIcon;
	-- Create a new Table that will represent the Object
	local NewObject = {};
	-- Define the MetaTable that will be the parent of the Object
	setmetatable(NewObject, Spell);
	-- Initialize our object, define it's specific values
	NewObject.SpellIcon = Icon;
	NewObject.Texture = SpellIcon
	local ThisSpellInfos = SpellBook:FindSpellInfos(SpellIcon, RequiresFacing, IsHostile, Instant, Range, Condition, AlternateIcon);
	NewObject.SpellID, NewObject.SpellName, NewObject.Position = ThisSpellInfos[1], ThisSpellInfos[2], ThisSpellInfos[3];
	if NewObject.SpellID ~= 0 then
	   	NewObject.Identifier = SpellIcon;
	   	NewObject.RequiresFacing = RequiresFacing;
	   	NewObject.IsHostile = IsHostile;
	   	NewObject.Instant = Instant;
	   	NewObject.Range = Range;
	   	NewObject.Condition = Condition;
	   	NewObject.AlternateIcon = AlternateIcon;
	end
	-- Add to the Spells Table so that we can use it with macros
	if NewObject.SpellName ~= nil then
		SpellsTable[NewObject.SpellName] = {Spell = NewObject, Position = NewObject.Position, IsHostile = NewObject.IsHostile, SpellID = NewObject.SpellID};
	end
   	-- Return the built Object
   	return NewObject;
end

--- Spell Functions
function Spell:Cooldown ()
	local LastUsed, Time = GetSpellCooldown(self.SpellID, "spell");
	local Cooldown = math.floor((Time + LastUsed - GetTime())*100)/100;
	return Cooldown > 0 and Cooldown or 0;
end

--- Get wether a spell exists by seeing if we added it's ID with our spell book scan
function Spell:Exists ()
	return self.SpellID ~= 0;
end

--- Get a Spell ID from our Database
function Spell:ID ()
	return self.SpellID;
end
--- Get A Spell's Name
function Spell:Name ()
	return self.SpellName;
end

--- Get a spell's current Icon
function Spell:Icon ()
	return self.Texture;
end

--- Get if the action is being casted
function Spell:IsBeingCasted ()
	if self.Position == nil then
		return false;
	elseif GetActionName(self.Position) ~= self:Name() then
		if CursorHasItem() or CursorHasSpell() then
			return false;
		else
			Rotations[Player:Class()].Initialized = false;
			return false;
		end
	else
		return IsCurrentAction(self.Position) == 1;
	end
end

--- Get if the action is in range
function Spell:IsInRange ()
	return IsActionInRange(self.Position) == 1;

end

--- Get wether a spell is on cooldown
function Spell:IsOnCooldown ()
	if not self:Exists() then return false; end
	return self:Cooldown() ~= 0;
end

function Spell:NeedsResources ()
	if not self:Exists() then return false; end
	local isUsable, notEnoughMana = IsUsableAction(self.Position);
	return notEnoughMana == 1;
end

function Spell:IsUsable ()
	if not self:Exists() then return false; end
	local isUsable, notEnoughMana = IsUsableAction(self.Position);
	return isUsable;
end

function Spell:Refresh (Rank)
	local OldSpell = self;
	self = Spell.Create(OldSpell.SpellIcon, OldSpell.RequiresFacing, OldSpell.IsHostile, OldSpell.Instant, OldSpell.Range, OldSpell.Condition, Rank);
end

--- Get the time since we last casted the spell
function Spell:TimeSinceCast ()
	return not self.LastCastTime and 100 or GetTime() - self.LastCastTime;
end