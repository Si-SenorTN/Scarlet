-- Table
-- Senor
-- 3/21/2021

--[[

	Table.readonly(t: table) -> table
		-- read only table that errors on bad index's

	Table.deepReadonly(t: table) -> table
		-- recursively makes all table elements read only

	Table.shallow(target: table) -> table
		-- shallow copy of the target table

	Table.deep(target: table, _context: table?) -> table
		-- returns a deep copy of the target table including metatables

	Table.merge(original: table, new: table) -> table
		-- retruns a shallow merge of the two passed tables

	Table.filter(t: table, func: (t: table, k: (string?) | any, v: any) -> boolean) -> table

	Table.extend(t: table, extension: table) -> table

	Table.reverse(t: table) -> table

	Table.shuffle(t: table) -> table

	Table.random(t: table) -> any

	Table.toJSON(t: table) -> JSONString

	Table.fromJSON(s: JSONString) -> table

--]]

local HttpService = game:GetService("HttpService")

local RANDOM = Random.new()

local Table = {}

local function readOnly(t: table)
	return setmetatable(t, {
		__index = function(_, index)
			error(("(%s) is not a member"):format(tostring(index)), 2)
		end,

		__newindex = function()
			error("Cannot write into a read only table", 2)
		end
	})
end
Table.readonly = readOnly


local function deepReadonly(t: table)
	for _, v in pairs(t) do
		if type(v) == "table" then
			deepReadonly(v)
		end
	end
	return readOnly(t)
end
Table.deepReadonly = deepReadonly

local function shallowCopy(t: table)
	local copy = {}
	for i, v in pairs(t) do
		copy[i] = v
	end

	return copy
end
Table.shallow = shallowCopy


local function deepCopy(target: table, _context: table)
	_context = _context or  {}
	if _context[target] then
		return _context[target]
	end

	if type(target) == "table" then
		local new = {}
		_context[target] = new
		for index, value in pairs(target) do
			new[deepCopy(index, _context)] = deepCopy(value, _context)
		end
		return setmetatable(new, deepCopy(getmetatable(target), _context))
	else
		return target
	end
end
Table.deep = deepCopy


local function merge(org: table, new: table)
	local mergedTable = {}

	for index, value in pairs(org) do
		mergedTable[index] = value
	end

	for index, value in pairs(new) do
		mergedTable[index] = value
	end

	return mergedTable
end
Table.merge = merge


local function filter(t: table, func: (t: table, key: (string?) | any, value: any) -> boolean)
	assert(type(t) == "table", "First argument must be a table")
	assert(type(func) == "function", "Second argument must be a function")
	local newT = table.create(#t)
	if #t > 0 then
		local n = 0
		for i = 1,#t do
			local v = t[i]
			if func(t, i, v) then
				n += 1
				newT[n] = v
			end
		end
	else
		for k,v in pairs(t) do
			if func(t, k, v) then
				newT[k] = v
			end
		end
	end
	return newT
end
Table.filter = filter


local function extend(t: table, extension: table)
	for index, value in pairs(extension) do
		t[index] = value
	end
end
Table.extend = extend


local function reverse(t: table)
	local n = #t
	local tblRev = table.create(n)
	for i = 1,n do
		tblRev[i] = t[n - i + 1]
	end
	return tblRev
end
Table.reverse = reverse


local function shuffle(t: table)
	for i = #t, 2, -1 do
		local j = RANDOM:NextInteger(1, i)
		t[i], t[j] = t[j], t[i]
	end
end
Table.shuffle = shuffle


local function random(t: table)
	return t[RANDOM:NextInteger(1, #t)]
end
Table.random = random


local function JSONEncode(t: table)
	return HttpService:JSONEncode(t)
end
Table.toJSON = JSONEncode


local function JSONDecode(s: string)
	return HttpService:JSONDecode(s)
end
Table.fromJSON = JSONDecode


local function isEmpty(t: table)
	return next(t) == nil
end
Table.isempty = isEmpty

return Table