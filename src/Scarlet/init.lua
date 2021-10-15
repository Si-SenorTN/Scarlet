--!strict

-- Scarlet
-- Senor
-- 10/6/21

local MountUtils = require(script.Util.MountUtils)
local Disconnect = require(script.Util.Disconnect)

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
	local disconnect = Disconnect.new({})

	-- mount to existing objects
	for index, newObject in pairs(objectThatContainsManyObjects) do
		if type(index) == "string" and type(newObject) == "table" then
			disconnect:AddConnection(Scarlet.Implements(newObject, interface))
		end
	end

	-- observe and subscribe on new objects added
	MountUtils.observe(objectThatContainsManyObjects, function(_, newObject)
		disconnect:AddConnection(Scarlet.Implements(newObject, interface))
	end)

	return disconnect
end


function Scarlet.Implements(object: t, interface: InterfaceDictionary)
	local disconnect = Disconnect.new({})

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

		disconnect:AddConnection(methodData.Event:Connect(function(...)
			object[methodName](object, ...)
		end))
	end

	return disconnect
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