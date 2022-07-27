--!strict

--[[
	-- applyNameConvention
	-- Senor
	-- 10/6/21

	utility module to ensure all instance methods and constructors are backwards compatible
	with popular naming conventions
]]

type t = {
	[any]: any
}

local function toCamelCase(str: string)
	return str:gsub("^%a", string.lower)
end

local function toPascalCase(str: string)
	return str:gsub("^%a", string.upper)
end

local function setObjectMethods(object: t, callback: (str: string) -> string)
	for methodName: string, method: () -> any in pairs(object) do
		if type(method) == "function" and type(methodName) == "string" then
			object[callback(methodName)] = method
		end
	end
end

return function (object: t)
	assert(type(object) == "table", "Cannot apply name fixes to non table type")

	setObjectMethods(object, toCamelCase)
	setObjectMethods(object, toPascalCase)
	local metatable = getmetatable(object)
	if metatable and type(metatable) == "table" then
		setObjectMethods(metatable, toCamelCase)
		setObjectMethods(metatable, toPascalCase)
	end

	return object
end