--- MetaTable that will be the parent of every objects
Vector3 = {};
Vector3.__index = Vector3;

--- Defines the Vector3 Class Methods.

--- Get the Vector3 as a string.
-- @return The Vector3 as a string.
function Vector3:ToString ()
	return self.X .. ", " .. self.Y .. ", " .. self.Z;
end

--- Get the distance to another Vector3.
-- @param Other The other Vector3.
-- @return The distance between the Vector3s.
function Vector3:DistanceTo (Other)
	return Other.X and Other.Y and Other.Z and self.X and self.Y and self.Z and math.sqrt(((Other.X - self.X) ^ 2) + ((Other.Y - self.Y) ^ 2) + ((Other.Z - self.Z) ^ 2)) or 100;
end


--- Constructor
function Vector3.Create (X, Y, Z)
	-- Create a new Table that will represent the Object
   local NewObject = {};
   -- Define the MetaTable that will be the parent of the Object
   setmetatable(NewObject, Vector3);
   -- Initialize our object, define it's specific values
   NewObject.X = X;
   NewObject.Y = Y;
   NewObject.Z = Z;
   -- Return the built Object
   return NewObject;
end