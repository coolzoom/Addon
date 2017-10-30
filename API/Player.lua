function Player:IsReady ()
	return not UnitIsDeadOrGhost("player") and IsAoEPending() == 0 and not Player:IsMounted() and PlayerStandState() == 0;
end

function Player:IsCasting(Spell)
	if Spell.Position == nil then
		return false;
	elseif GetActionName(Spell.Position) ~= Spell:Name() then
		if CursorHasItem() or CursorHasSpell() then
			return false;
		else
			Rotations[Player:Class()].Initialized = false;
			return false;
		end
	else
		return IsCurrentAction(Spell.Position);
	end
end

function Player:IsCastingAny ()
	return GetUnitCastingSpellId("player") ~= 0;
end

--- Player Functions
--- Get the Player's Combo Points
function Player:ComboPoints ()
	return GetComboPoints();
end

--- Get the Player's Pet Status
function Player:PetExists ()
	return GetPetActionsUsable();
end


--- Get the Player's Energy
function Player:Energy ()
	return UnitMana("player");
end

function Player:EnergyMax ()
	return UnitManaMax("player");
end

--- Determine if the player is falling (or elevating)
function Player:IsFalling ()
	return Player.FallingStarted ~= 0;
end

--- Determine if player is mounted by their speed, only works with epic mounts
function Player:IsMounted ()
	return PlayerForwardSpeed() >= 14;
end

--- Determine if player is moving
function Player:IsMoving ()
	return PlayerCurrentSpeed() ~= 0 or PlayerIsFalling() ~= 0;
end

--- Get the Player's Energy Percentage
function Player:EnergyPercentage ()
	return UnitMana("player")/UnitManaMax("player")*100;
end

--- Get if the Player Currently has a Weapon in his Offhand
function Player:HasOffhandWeapon ()
	return OffhandHasWeapon() == 1;
end

StoredPositions = { X = Player.X, Y = Player.Y, Z = Player.Z };
Player.MovementStarted, Player.FallingStarted = 0, 0;
function Player:UpdateMovement ()
	-- Track Movement
	if Player.MovementStarted ~= 0 and Player.X == StoredPositions.X and Player.Y == StoredPositions.Y then
		Player.MovementStarted = 0;
	elseif Player.MovementStarted == 0 and (Player.X ~= StoredPositions.X or Player.Y ~= StoredPositions.Y) then
		Player.MovementStarted = GetTime();
	end
	-- Track Falling
	if Player.FallingStarted ~= 0 and Player.Z == StoredPositions.Z then
		Player.FallingStarted = 0;
	elseif Player.FallingStarted == 0 and Player.Z ~= StoredPositions.Z then
		Player.FallingStarted = GetTime();
	end
	StoredPositions = { X = Player.X, Y = Player.Y, Z = Player.Z };
end

INV_TYPE_DAGGER = "Dagger";
INV_TYPE_SWORD = "Sword";
--- Get the Player's Main Hand Type
MainHandId, Texture, CheckRelic = GetInventorySlotInfo("MainHandSlot");
function Player:MainHandType ()
	ScanningTooltip:ClearLines();
	ScanningTooltip:SetInventoryItem("player", MainHandId, false);
	local ThisTextFrame, ThisTextFrameText;
	for i = 1, 5 do
		ThisTextFrame = getglobal("ScanningTooltipTextRight"..i) or nil;
		if ThisTextFrame ~= nil then
			ThisTextFrameText = ThisTextFrame:GetText();
			if ThisTextFrameText == INV_TYPE_DAGGER then
				return "Dagger";
			elseif ThisTextFrameText == INV_TYPE_SWORD then
				return "Sword";
			end
		end
	end
	return "Unknown";
end

--- Get the Player's current Mana
function Player:Mana ()
	return UnitMana("player");
end

--- Get the Player's current Mana Percentage
function Player:ManaPercentage ()
	return UnitMana("player")/UnitManaMax("player")*100;
end

--- Get the Player's current Rage
function Player:Rage ()
	return UnitMana("player");
end

--- Get the player's current Shapeshift form.
Shapeshift = 0;
function Player:GetShapeshift ()
	return Shapeshift;
end

--- Set the player's current Shapeshift form.
function Player:SetShapeshift (Value)
	Shapeshift = Value;
end

--- Get the Player's Stance (Warrior Only)
function Player:Stance ()
	return BerserkerStance:Exists() and BerserkerStance:IsBeingCasted() and 2 or DefensiveStance:Exists() and DefensiveStance:IsBeingCasted() and 3 or 1;
end

function Player:BuffDuration (Spell)
	local Icon = Spell:Icon();
	for i=0,31 do
  		local id,cancel = GetPlayerBuff(i,"HELPFUL");
  		if id > -1 and GetPlayerBuffTexture(id) == Spell:Icon() then
    		return GetPlayerBuffTimeLeft(id);
   		end
  	end
  	return 0;
end

function Player:HasDebuffType (Type1, Type2, Type3)
	for i=0,31 do
  		local id,cancel = GetPlayerBuff(i,"HARMFUL");
  		if id > -1 then
    		return GetPlayerBuffDispelType(id) == Type1 or (Type2 and GetPlayerBuffDispelType(id) == Type2) or (Type3 and GetPlayerBuffDispelType(id) == Type3);
   		end
  	end
  	return false;
end