--!strict

local MountUtils = require(script.Util.MountUtils)
local Connection = require(script.Util.Connection)

local applyNameConvention = require(script.Util.applyNameConvention)
local interfaces = require(script.InterfacePresets)

local Scarlet = {}

function Scarlet.Mount(objectThatContainsManyObjects: interfaces.t, interface: interfaces.InterfaceDictionary)
	local connection = Connection.new({})

	-- mount to existing objects
	for _, newObject in pairs(objectThatContainsManyObjects) do
		if type(newObject) == "table" then
			connection:Add(Scarlet.Implements(newObject, interface))
		end
	end

	-- observe and subscribe on new objects added
	MountUtils.observe(objectThatContainsManyObjects, function(_, newObject)
		connection:Add(Scarlet.Implements(newObject, interface))
	end)

	return connection
end

function Scarlet.Implements(object: interfaces.t, interface: interfaces.InterfaceDictionary)
	local connection = Connection.new({})

	for methodName, methodData in pairs(interface) do
		if not object[methodName] then
			continue
		end

		local getExisting = methodData.GetExisting
		local method = object[methodName]

		if getExisting then
			if type(getExisting) == "function" then
				local recieved = getExisting(methodData.self)

				if type(recieved) == "table" then
					for _, v in pairs(recieved) do
						task.spawn(method, object, v)
					end
				else
					method(object, recieved)
				end
			else
				method(object, getExisting)
			end
		end

		connection:Add(methodData.Event:Connect(function(...)
			method(object, ...)
		end))
	end

	return connection
end

do
	Scarlet.Interfaces = interfaces

	Scarlet.Copy = MountUtils.Copy
	function Scarlet.Extend(tab: interfaces.t, extension)
		return MountUtils.Extend(MountUtils.Copy(tab), extension)
	end

	applyNameConvention(Scarlet)
end

return Scarlet