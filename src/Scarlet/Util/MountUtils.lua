--!strict

type tab = {
	[any]: any
}

local MountUtils = {}

local function copy(t: tab)
	local copiedTable = {}

	for i, v in pairs(t) do
		copiedTable[i] = v
	end

	return copiedTable
end

local function extend(t: tab, extension: tab)
	for i, v in pairs(extension) do
		t[i] = v
	end
	return t
end

local function respectOldMethod(newindex, ...)
	if type(newindex) == "function" then
		newindex(...)
	end
end

local function respectMetatableAndExtend(t: tab, metatable: tab)
	local existingMetatable = getmetatable(t)
	local __newindex = nil
	if existingMetatable and type(existingMetatable) == "table" then
		__newindex = existingMetatable.__newIndex
		metatable = extend(copy(existingMetatable), metatable)
	end
	return setmetatable(t, metatable), __newindex
end

--- Observes additions made to a table, respecting existing metatables
function MountUtils.observe(t: tab, onSubscribe: (name: string, newObject: tab) -> nil)
	local extendedObject, __newindex
	extendedObject, __newindex  = respectMetatableAndExtend(t, {
		__newindex = function(self: tab, newIndex: string?, newValue: tab?)
			if type(newIndex) == "string" and type(newValue) == "table" then
				onSubscribe(newIndex, newValue)
			end
			if __newindex then
				respectOldMethod(__newindex, self, newIndex, newValue)
			end
		end
	})

	return extendedObject
end

MountUtils.Extend = extend
MountUtils.Copy = copy

return MountUtils