type conn = {
	Disconnect: () -> nil,
} | RBXScriptConnection

local Connection = {}
Connection.__index = Connection

function Connection.new(connections: Array<conn>): Connection
	local self = setmetatable({}, Connection)
	self._connections = connections

	return self
end

function Connection:Add(c: conn)
	table.insert(self._connections, c)
end

function Connection:Disconnect()
	for _, c in pairs(self._connections) do
		c:Disconnect()
	end
	table.clear(self._connections)
end
Connection.Destroy = Connection.Disconnect

export type Connection = typeof(Connection.new(nil))

return Connection
