--!strict

local MountUtils = require(script.Util.MountUtils)
local Connection = require(script.Util.Connection)
local Types = require(script.Types)

--[[
	@class Scarlet
]]
local Scarlet = {}
--[[
	@interface Interfaces
]]
Scarlet.Interfaces = require(script.InterfacePresets)
Scarlet.interfaces = Scarlet.Interfaces

--[[
	@param object any
	@param interfaces Dictionary<Interfaces>
	@return Connection

	Implements the passed `interface` onto the passed `t` object.

	```lua
	local testObject = {}
	Scarlet.implements(testObject, {
		OnPlayerAdded = {
			self = Players,
			Event = Players.PlayerAdded,
			GetExisting = Players.GetPlayers
		}
	})

	function testObject:OnPlayerAdded(player)
		print(player.Name.. " has entered the game!")
	end
	```
]]
function Scarlet.Implements(object: any, interfaces: Types.Interfaces)
	local connection = Connection.new({})

	for methodName, interface in pairs(interfaces) do
		if not object[methodName] then
			continue
		end

		local getExisting = interface.GetExisting
		local method = object[methodName]

		task.defer(function()
			if getExisting then
				if type(getExisting) == "function" then
					local recieved = getExisting(interface.self)

					if recieved then
						if type(recieved) == "table" then
							for _, v in pairs(recieved) do
								task.spawn(method, object, v)
							end
						else
							method(object, recieved)
						end
					end
				else
					method(object, getExisting)
				end
			end

			connection:Add(interface.Event:Connect(function(...)
				method(object, ...)
			end))
		end)
	end

	return connection
end
Scarlet.implements = Scarlet.Implements

--[[
	@param objectThatContainsManyObjects any
	@param interfaces Interface
	@return Connection

	Mounts and listens to added tables from `t`, internally calls `Scarlet.Implemets()` on all tables implementing the passed `interface`.
]]
function Scarlet.Mount(objectThatContainsManyObjects: any, interfaces: Types.Interfaces)
	local connection = Connection.new({})

	-- mount to existing objects
	for _, newObject in pairs(objectThatContainsManyObjects) do
		if type(newObject) == "table" then
			connection:Add(Scarlet.Implements(newObject, interfaces))
		end
	end

	-- observe and subscribe on new objects added
	MountUtils.observe(objectThatContainsManyObjects, function(_, newObject)
		connection:Add(Scarlet.Implements(newObject, interfaces))
	end)

	return connection
end
Scarlet.mount = Scarlet.Mount

do
	local warnedOnce = false

	--[[
		@param t table
		@return table
		@deprecated v1.1 -- Use `table.clone` instead

		performs a shallow copy on a table

		```lua
		local t = { hello = "world" }
		local newt = Scarlet.copy(t)

		assert(t == newt)
		```
	]]
	function Scarlet.Copy(t)
		if not warnedOnce then
			warnedOnce = true
			warn("Method is deprecated in favor of `table.clone` please use that instead")
		end
		return table.clone(t)
	end
	Scarlet.copy = Scarlet.Copy
end

--[[
	@param t table
	@param extension table
	@return table

	immutably extends and replaces table `t` fields with fields from table `extension`

	intended use for extending interfaces on the fly

	```lua
	Scarlet.mount(services, Scarlet.extend(Scarlet.Interfaces.Services, {
		OnHeartbeat = {
			self = RunService,
			Event = RunService.Heartbeat
		}
	}))
	```
]]
function Scarlet.Extend(t: any, extension)
	return MountUtils.Extend(table.clone(t), extension)
end
Scarlet.extend = Scarlet.Extend

return Scarlet
