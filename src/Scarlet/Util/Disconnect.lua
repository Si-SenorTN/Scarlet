type Connection = {
	Disconnect: () -> ()
}

type ConnectionArray = {
	[any]: Connection
}

local Disconnect = {}
Disconnect.__index = Disconnect

function Disconnect.new(connections: ConnectionArray): Disconnect
	local self = setmetatable({}, Disconnect)
	self._connections = connections

	return self
end

function Disconnect:AddConnection(conn: Connection)
	table.insert(self._connections, conn)
end

function Disconnect:Disconnect()
	for _, connection in pairs(self._connections) do
		connection:Disconnect()
	end
end
Disconnect.Destroy = Disconnect.Disconnect

export type Disconnect = typeof(Disconnect.new(nil))