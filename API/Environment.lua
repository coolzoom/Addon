
--- Events Reader
CreateFrame("Frame", "Events");
Events:SetScript('OnEvent', function() 
	Events.ParseEvents(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
end)

--- Combat Events Reader
CreateFrame("Frame", "CombatEvents");
CombatEvents:SetScript('OnEvent', function() 
	CombatEvents.ParseEvents(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
end)

SLASH_DPSENGINE1 = "/dpse";

--- Randomisation Algorythm
--@param Length - Number - The number of caracters the string should be
--@returns - String - A string of random alphanumeric values
function Randomize (Length)
	local Length = Length or math.random(10,24);
	local RandomValues, StringValue = { [1]={"a","A"}, [2]={"b","B"}, [3]={"c","C"},[4]={"d","D"}, [5]={"e","E"}, [6]={"f","F"}, [7]={"g","G"}, [8]={"h","H"}, [9]={"i","I"}, [10]={"j","J"}, [11]={"k","K"}, [12]={"l","L"}, [13]={"m","M"}, [14]={"n","N"}, [15]={"o","O"}, [16]={"p","P"}, [17]={"q","Q"}, [18]={"r","R"}, [19]={"s","S"}, [20]={"t","T"}, [21]={"u","U"}, [22]={"v","V"}, [23]={"w","W"}, [24]={"x","X"}, [25]={"y","Y"}, [26]={"z","Z"}, [27]={"1","2"}, [28]={"3","4"}, [29]={"5","6"}, [30]={"7","8"}, [31]={"9","0"} }, "";
	for i = 1, Length do
		StringValue = StringValue..RandomValues[math.random(1,31)][math.random(1,2)];
	end
	return StringValue;
end

Manager = CreateFrame("Frame", Randomize());

Colors = {
	Blue = { R = 7/255, G = 152/255, B = 231/255, Hex = "|cff26BAFF" },
	Gold = { R = 255/255, G = 204/255, B = 0/255, Hex = "|cffFFCC00" },
	Gray = { R = 75/255, G = 75/255, B = 75/255, Hex = "|cff4B4B4B" },
	Green = { R = 10/255, G = 235/255, B = 10/255, Hex = "|cff0AEB0A" },
	Red = { R = 237/255, G = 37/255, B = 36/255, Hex = "|cffED2524" },
	White = { R = 255/255, G = 255/255, B = 255/255, Hex = "|cffFFFFFF" },
	Yellow = { R = 254/255, G = 242/255, B = 0/255, Hex = "|cffFEF200" }
};

-- Constants
C = {
	-- Tooltip Constants
	TOOLTIP_DESCRIPTION = "|cFF26BAFFDescription|cFFFFFFFF\n",
	TOOLTIP_VALUE = "\n\n|cFF26BAFFValue|cFFFFFFFF\n",
	TOOLTIP_VALUE_1 = "\n\n|cFF26BAFFValue 1|cFFFFFFFF\n",
	TOOLTIP_VALUE_2 = "\n\n|cFF26BAFFValue 2|cFFFFFFFF\n",
	TOOLTIP_DEFAULT_STATE = "\n\n|cFFFFD800Checked Default:|cFFFFFFFF ",
	TOOLTIP_DEFAULT_VALUE = "\n|cFFFFD800Default Value:|cFFFFFFFF ",
	TOOLTIP_DEFAULT_VALUE_1 = "\n|cFFFFD800Default First Option:|cFFFFFFFF ",
	TOOLTIP_DEFAULT_VALUE_2 = "\n|cFFFFD800Default Second Option:|cFFFFFFFF ",
	TOOLTIP_SUBVALUE = function (Text, NoLineReturn) return NoLineReturn and "|cFF26BAFF"..Text..":|cFFFFFFFF " or "\n|cFF26BAFF"..Text..":|cFFFFFFFF " end,
	TOOLTIP_HINT = function (Text) return "\n\n|cFF26BAFF"..Text.."|r" end,
};

Rotations, Player, Target = {}, nil, nil;


function print (String)
    DEFAULT_CHAT_FRAME:AddMessage(tostring(String));
end

--- Custom Lua select
function select (Position, Function)
	local Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10 = Function;
	local Args = { Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10 };
	return Args[Position];
end

ScanningTooltip = CreateFrame("GameTooltip", "ScanningTooltip", nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
ScanningTooltip:SetOwner(getglobal("WorldFrame"), "ANCHOR_NONE");
ScanningTooltip:AddFontStrings(
	ScanningTooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
	ScanningTooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
);