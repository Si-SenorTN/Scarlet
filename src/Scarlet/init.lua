--!strict

-- Scarlet
-- Senor
-- 10/6/21

local MountUtils = require(script.Util.MountUtils)
local Connection = require(script.Util.Connection)

local applyNameConvention = require(script.Util.applyNameConvention)
local interfaces = require(script.InterfacePresets)

local Scarlet = {}

type t = {
	[any]: any
}

type Interface = {
	Event: RBXScriptSignal,
	self: t,
	GetExisting: ((...any) -> t) | Instance?
}

type InterfaceDictionary = {
	[string]: Interface
}


function Scarlet.Mount(objectThatContainsManyObjects: t, interface: InterfaceDictionary)
	local connection = Connection.new({})

	-- mount to existing objects
	for index, newObject in pairs(objectThatContainsManyObjects) do
		if type(index) == "string" and type(newObject) == "table" then
			connection:Add(Scarlet.Implements(newObject, interface))
		end
	end

	-- observe and subscribe on new objects added
	MountUtils.observe(objectThatContainsManyObjects, function(_, newObject)
		connection:Add(Scarlet.Implements(newObject, interface))
	end)

	return connection
end


function Scarlet.Implements(object: t, interface: InterfaceDictionary)
	local connection = Connection.new({})

	for methodName, methodData in pairs(interface) do
		if not object[methodName] then
			continue
		end

		if methodData.GetExisting then
			if type(methodData.GetExisting) == "function" then
				-- TODO: match all cases, not just table returns
				for _, v in pairs(methodData.GetExisting(methodData.self)) do
					task.spawn(object[methodName], object, v)
				end
			else
				object[methodName](object, methodData.GetExisting)
			end
		end

		connection:Add(methodData.Event:Connect(function(...)
			object[methodName](object, ...)
		end))
	end

	return connection
end


do
	Scarlet.Interfaces = interfaces

	Scarlet.Copy = MountUtils.Copy
	function Scarlet.Extend(tab: t, extension)
		return MountUtils.Extend(MountUtils.Copy(tab), extension)
	end

	applyNameConvention(Scarlet)
end


return Scarlet