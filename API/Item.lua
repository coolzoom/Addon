Equipment = {};
function Equipment:Dump ()
	local i = 1;
	print("|cffFFDD11Equipment Book Dump Begins");
	while i < 20 do
		if GetInventoryItemTexture("player", i) ~= nil then
			print("Slot "..i..": "..GetInventoryItemTexture("player", i));
		end
		i = i + 1;
	end
end

function Equipment:FindItemInfos (ItemIcon)
	local i, iMax, ThisIcon, StoredEquipmentIndex, StoredEquipmentPosition = 13, 15, nil, nil, nil;
	while i < iMax do
		ThisIcon = GetInventoryItemTexture("player", i);
		if ThisIcon == ItemIcon then
			StoredEquipmentIndex = i;
			break;
		end
		i = i + 1;
	end
	if StoredEquipmentIndex ~= nil then
		-- Look for the player's spells in their bars
		local MaxActions = Player:Class() == "WARRIOR" and 108 or Player:Class() == "ROGUE" and 84 or 72;
		for i = 1, MaxActions do
			if GetActionTexture(i) == ItemIcon then
				StoredEquipmentPosition = i;
				break;
			end
		end
		if StoredEquipmentPosition == nil then
			PickupInventoryItem(StoredEquipmentIndex);
		   	-- PlaceAction(slot)
		   	for i = 25, 80 do
		   		if GetActionText(i) == nil and GetActionTexture(i) == nil then
		   			EmptyIndex = i;
		   			break;
		   		end
		   	end
		   	PlaceAction(EmptyIndex);
		   	StoredEquipmentPosition = EmptyIndex;
			print(Colors.Gold.Hex.."[DPSEngine]|r "..ItemIcon.." not found, adding it to slot #"..EmptyIndex..".");
		end
		return {StoredEquipmentIndex, StoredEquipmentPosition};
	end
	return {0, 0};
end

--- MetaTable that will be the parent of every Items objects
Item = {};
Item.__index = Item;

function Item.Create (ItemIcon)
	local ItemIcon = "Interface\\Icons\\"..ItemIcon;
	-- Create a new Table that will represent the Object
	local NewObject = {};
	-- Define the MetaTable that will be the parent of the Object
	setmetatable(NewObject, Item);
	-- Initialize our object, define it's specific values
	NewObject.Texture = ItemIcon
	local ThisItemInfos = Equipment:FindItemInfos(ItemIcon);
	NewObject.Index, NewObject.Position = ThisItemInfos[1], ThisItemInfos[2];
   	-- Return the built Object
   	return NewObject;
end

--Determine if the Item in the action slot is equipped on the player
function Item:IsEquipped ()
	return IsEquippedAction(self.Position);
end

--Determine if the Item in the action slot can be triggered
function Item:IsTriggerable ()
	local start, duration, enable = GetActionCooldown(self.Position);
	return enable ~= 0;
end

--Determine if the item is on cooldown
function Item:IsOnCooldown ()
	local start = GetActionCooldown(self.Position);
	return start ~= 0;
end

function Item:IsUsable ()
	-- If an ability could not be found in the Action Bars, Initialize again
	if GetActionTexture(self.Position) ~= self.Texture then
		if CursorHasItem() or CursorHasSpell() then
			return false;
		else
			Rotations[Player:Class()].Initialized = false;
			return false;
		end
	end
	return self:IsEquipped() and self:IsTriggerable() and not self:IsOnCooldown();
end