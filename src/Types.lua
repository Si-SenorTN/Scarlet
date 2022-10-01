export type Interface = {
	Event: RBXScriptSignal,
	self: any,
	GetExisting: ((...any) -> any) | Instance?,
}

export type Interfaces = Dictionary<Interface>

return {}
