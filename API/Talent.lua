--- Talents Panel Functions
TalentsPanel = {};
function TalentsPanel:Dump (TabIndex)
	local i = 1;
	local Name, IconTexture, Tier, Column, Rank, MaxRank, IsExceptional, MeetsPrereq;
	print("|cffFFDD11Talents Tab Dump Begins");
	while GetTalentInfo(TabIndex, i) ~= nil do
		Name, IconTexture, Tier, Column, Rank, MaxRank, IsExceptional, MeetsPrereq = GetTalentInfo(TabIndex, i);
		print(Name .. " = Tier: "..Tier.." Column: "..Column.." Rank: ".. Rank);
		i = i + 1;
	end
end

-- TalentsPanel:Dump(1);
function TalentsPanel:FindTalentsInfos(Tab, ThisTier, ThisColumn)
	local i = 1;
	local Name, IconTexture, Tier, Column, Rank, MaxRank, IsExceptional, MeetsPrereq;
	while GetTalentInfo(Tab, i) ~= nil do
		Name, IconTexture, Tier, Column, Rank, MaxRank, IsExceptional, MeetsPrereq = GetTalentInfo(Tab, i);
		if ThisTier == Tier and ThisColumn == Column then
			return {Name, Tier, Column, Rank, MaxRank, i};
		end
		i = i + 1;
	end
	return {"Not Found", 0, 0, 0, 0, 0};
end

--- MetaTable that will be the parent of every objects
Talent = {};
Talent.__index = Talent;

--- Constructor
function Talent.Create (Tab, Tier, Column)
	-- Create a new Table that will represent the Object
	local NewObject = {};
	-- Define the MetaTable that will be the parent of the Object
	setmetatable(NewObject, Talent);
	-- Initialize our object, define it's specific values
	NewObject.Tab = Tab;
	local ThisTalentInfos = TalentsPanel:FindTalentsInfos(Tab, Tier, Column);
	NewObject.TalentName, NewObject.Tier, NewObject.Column, NewObject.CurrentRank, NewObject.NormalMaxRank, NewObject.Position = ThisTalentInfos[1], ThisTalentInfos[2], ThisTalentInfos[3], ThisTalentInfos[4], ThisTalentInfos[5], ThisTalentInfos[6];
   	-- Return the built Object
   	return NewObject;
end

--- Get if a talent is selected
function Talent:Exists ()
	return self.Rank > 0;
end

--- Get the Talent's Name (localised)
function Talent:Name ()
	return self.TalentName;
end

--- Get a talent's position in it's tab
function Talent:Index ()
	return self.Position;
end

--- Get the Talent's Maximum Rank
function Talent:MaxRank ()
	return self.NormalMaxRank;
end

--- Get the Talent's Rank
function Talent:Rank ()
	return self.CurrentRank;
end