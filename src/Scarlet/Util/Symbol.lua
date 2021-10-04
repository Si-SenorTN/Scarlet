-- Symbol
-- Senor
-- 9/14/2021

--[[

	Symbol.new(name: string) -> Symbol
		-- returns an opaque marker type, on printing returns its modified symbol name

--]]


local Symbol = {}

function Symbol.named(name)
	assert(type(name) == "string", "Symbol name must be a string")

	local self = newproxy(true)
	self.Name = name

	getmetatable(self).__tostring = function()
		return ("Symbol(%s)"):format(name)
	end

	return self
end


return Symbol