-- Enum
-- Senor
-- 3/21/2021

--[[

	Enum.new(name: string, enumList: table) -> Enum
		-- returns a new Enum list made of Symbols

	Enum:GetValues() -> EnumList[name: String, EnumItem: Symbol]
		-- retruns the map of Enum items

--]]

local Table = require(script.Parent.Table)
local Symbol = require(script.Parent.Symbol)

local Enum = {}


function Enum.new(name, enumList)
	local enums = {}

	for _, enumName in pairs(enumList) do
		table.insert(enums, Symbol.named(enumName))
	end
	local values = Table.readOnly(enums)

	return setmetatable({
		_values = values
	}, {
		__index = function(_, key)
			if Enum[key] then
				return Enum[key]
			end
			-- bad index will error due to the nature of a read only table
			return values[key]
		end,
		__newindex = function()
			error(("Cannot write to Enum List (%s)"):format(name), 2)
		end
	})
end


function Enum:GetValues()
	return self._values
end


return Enum