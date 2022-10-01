--!strict

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Types = require(script.Parent.Types)

--[[
	The pattern goes:

	```lua
	["MethodName"] = { Interface }
	```

	`Interface:`

	`Event: RBXScriptSignal` field for the method to be linked to

	`self: any` reference field to comply with OOP laws

	`GetExisting: ((...any) -> any) | Instance` **optional** field holding a reference to either a function or non nil value that will be used an an `init` method to kick off state
	```lua
	local Services = {
		OnPlayerAdded = {
			Event = Players.PlayerAdded,
			self = Players,
			GetExisting = Players.GetPlayers
		},
	}
	```
]]
local interfaces: Dictionary<Types.Interfaces> = {
	Services = {
		OnPlayerAdded = {
			self = Players,
			Event = Players.PlayerAdded,
			GetExisting = Players.GetPlayers,
		},
		OnPlayerRemoving = {
			self = Players,
			Event = Players.PlayerRemoving,
		},
	},
}

if RunService:IsClient() then
	local player = Players.LocalPlayer

	interfaces.Controllers = {
		OnCharacterAdded = {
			self = player,
			Event = player.CharacterAdded,
			GetExisting = player.Character,
		},
	}
end

return interfaces
