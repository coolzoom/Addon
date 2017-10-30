Options = {
	PagesCount = 0,
	AllClass = { 
		UI_Visible = true, 
		UI_X = 900, 
		UI_Y = -250, 
		IsRunning = false, 
		AoE = true, 
		CDs = false,
		Spec = 1
	}
};
function AddOption (Page, Name, Checked, Min, Max, Value, Tooltip, Spell)
	-- Create a new page if needed
	if not Options[Page] then
		Options[Page] = { PageIndex = Options.PagesCount, OptionsCount = 0 };
		Options.PagesCount = Options.PagesCount + 1;
	end
	-- Get the Tooltip
	if type(Min) == "string" then
		Tooltip = Min;
	end
	-- Create option
	Options[Page].OptionsCount = Options[Page].OptionsCount + 1;
	Options[Page][Name] = { Index = Options[Page].OptionsCount, Checked = Checked, Min = Min, Max = Max, Value = Value, Tooltip = Tooltip, Spell = Spell };
end


LocalClass, GlobalClass = UnitClass("player");
CurrentProfile = GlobalClass;
OptionsPages = { "General", "Offensive", "Defensive", "Advanced" };

--- We Need to store values as 
-- Evasion_Check=true
-- Evasion_Value=65
function Manager:SaveSettings ()
	local String = "";
    for OptionPageKey, OptionPageValue in next, Options, nil do
	    if type(OptionPageValue) == "table" then
	    	for OptionKey, OptionValue in next, OptionPageValue, nil do
	    		if OptionKey ~= "OptionsCount" and OptionKey ~= "PageIndex" then
		    		if type(OptionValue) == "table" then
		    			for OptionSubKey, OptionSubValue in next, OptionValue, nil do
		    				if OptionSubKey ~= "Min" and OptionSubKey ~= "Max" and OptionSubKey ~= "Index" and OptionSubKey ~= "Tooltip" and OptionSubKey ~= Spell then
								String = String ..OptionKey.."_"..OptionSubKey.."="..tostring(OptionSubValue).."\n"
							end
		    			end
		    		else
						String = String .. ""..OptionKey.."="..tostring(OptionValue).."\n"
					end
				end
			end
		end
	end
	WriteFile(GetManagerDirectory().."\\Profiles\\"..CurrentProfile..".txt", String);
end

function Manager:ReadSettings (Name)
	local String = ReadFile(GetManagerDirectory().."\\Profiles\\"..CurrentProfile..".txt");
	local NewLinePosition, Item, ValueKey, Value = 0, "", "", "";
	while String and string.len(String) > 1 do
		-- Find the Item
		NewLinePosition = string.find(String, "\n");
		Item = string.sub(String, 1, NewLinePosition);
		---- Store the Item
		-- If it is a Value
		if string.find(Item, "_Value") then
			ValueKey, Value = string.sub(Item, 1, string.find(Item, "_Value")-1), string.sub(Item, string.find(Item, "=")+1, string.len(Item)-1);
    		for OptionPageKey, OptionPageValue in next, Options, nil do
    			if type(OptionPageValue) == "table" then
		    		for OptionKey, OptionValue in next, OptionPageValue, nil do
		    			if OptionKey == ValueKey and type(OptionValue) == "table" then
		    				if Options[OptionPageKey][OptionKey].Value ~= nil then
								Options[OptionPageKey][OptionKey].Value = tonumber(Value);
								if Options[OptionPageKey][OptionKey].Spell ~= nil then
									Options[OptionPageKey][OptionKey].Spell:Refresh(tonumber(Value));
								end
							end
						end
					end
				end
			end
		-- If it is a Check
		elseif string.find(Item, "_Check") then
			ValueKey, Value = string.sub(Item, 1, string.find(Item, "_Check")-1), string.sub(Item, string.find(Item, "=")+1, string.len(Item)-1);
    		for OptionPageKey, OptionPageValue in next, Options, nil do
    			if type(OptionPageValue) == "table" then
		    		for OptionKey, OptionValue in next, OptionPageValue, nil do
		    			if OptionKey == ValueKey and type(OptionValue) == "table" then
		    				if Options[OptionPageKey][OptionKey].Checked ~= "none" and Options[OptionPageKey][OptionKey].Checked ~= "header" then
			    				if Value == "true" then
									Options[OptionPageKey][OptionKey].Checked = true;
								else
									Options[OptionPageKey][OptionKey].Checked = false;
								end
							end
						end
					end
				end
			end
		else
			ValueKey, Value = string.sub(Item, 1, string.find(Item, "=")-1), string.sub(Item, string.find(Item, "=")+1, string.len(Item)-1);
			if Value == "true" then
   				Options.AllClass[ValueKey] = true;
   			elseif Value == "false" then
   				Options.AllClass[ValueKey] = false;
   			else
   				Options.AllClass[ValueKey] = tonumber(Value);
   			end
		end
		-- Rebuild the remaining String
		String = string.sub(String, NewLinePosition + 1);
	end
end

--- Get the status of an option from the Options table
function IsOptionEnabled (OptionName)
	for i = 1, 4 do
		if Options[OptionsPages[i]] and Options[OptionsPages[i]][OptionName] ~= nil then
			return Options[OptionsPages[i]][OptionName].Checked;
		end
	end
	-- print("Option "..OptionName.." was not found.");
end

--- Get the value of an option from the Options table
function GetOptionValue (OptionName)
	for i = 1, 4 do
		if Options[OptionsPages[i]] and Options[OptionsPages[i]][OptionName] ~= nil then
			return Options[OptionsPages[i]][OptionName].Value;
		end
	end
	-- print("Option "..OptionName.." was not found.");
end

--- Set a value in AllClass options
function SetSetting (OptionName, Value)
	Options.AllClass[OptionName] = Value;
	Manager:SaveSettings();
end

--- Get a value from AllClass options
function GetSetting (OptionName)
	return Options.AllClass[OptionName];
end