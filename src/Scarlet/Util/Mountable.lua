local Mountable = {}
Mountable.__index = Mountable


function Mountable.new()
	local self = setmetatable({}, Mountable)

	return self
end


function Mountable:Destroy()

end


return Mountable