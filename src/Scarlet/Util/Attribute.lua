-- Attribute
-- Senor
-- 3/22/2021

--[[

	Attribute.new(value: any) -> Attribute
	Attribute.Is(object: table?) -> boolean

	Attribute:Set(value: any) -> ()
	Attribute:Get() -> any

	Attribute:Destroy() -> ()

--]]


local Signal = require(script.Parent.Signal)

local typeClassMap = {
	boolean = "BoolValue";
	string = "StringValue";
	table = true;
	CFrame = "CFrameValue";
	Color3 = "Color3Value";
	BrickColor = "BrickColorValue";
	number = "NumberValue";
	Instance = "ObjectValue";
	Ray = "RayValue";
	Vector3 = "Vector3Value";
	["nil"] = "ObjectValue";
}


local Attribute = {}
Attribute.__index = Attribute


function Attribute.Is(object)
	return type(object) == "table" and getmetatable(object) == Attribute
end


function Attribute.new(value)
	local t = typeof(value)
	local class = typeClassMap[t]
	assert(class, "Attribute does not support type \"" .. t .. "\"")

	local self = setmetatable({
		_value = value,
		_isTable = (t == "table")
	}, Attribute)

	if self._isTable then
		self.Changed = Signal.new()
	else
		self._object = Instance.new(class)
		self.Changed = self._object.Changed
	end

	return self
end


function Attribute:Set(value)
	if self._isTable then
		self.Changed:Fire(value)
	else
		self._object.Value = value
	end
	self._value = value
end


function Attribute:Get()
	return self._value
end


function Attribute:Destroy()
	if self._object then
		self._object:Destroy()
	end

	self._value = nil
	setmetatable(self, nil)
end


return Attribute