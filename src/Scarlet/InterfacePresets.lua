--!strict

--[[
	template:

	interfaces {
		string {
			Interface {
				InterfaceObject {
					Event: RBXScriptSignal,
					self: table,
					GetExisting: ((...any) -> ...any?) | Instance?
				},
			},
		}
	}
]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

type t = {
	[any]: any
}

type InterfaceName = string

type Interface = {
	Event: RBXScriptSignal,
	self: t,
	GetExisting: ((...any) -> t?) | Instance?
}

type InterfaceDictionary = {
	[InterfaceName]: Interface
}

type Objects = {
	[t]: InterfaceDictionary
}


local interfaces: Objects = {}

-- inject a test object
interfaces.MyObject = {}

if RunService:IsServer() then
	local playerAddedInterface = {
		self = Players,
		Event = Players.PlayerAdded,
		GetExisting = Players.GetPlayers
	}

	interfaces.MyObject.OnPlayerAdded = playerAddedInterface

	interfaces.Knit = {
		OnPlayerAdded = playerAddedInterface
	}
elseif RunService:IsClient() then
	local player = Players.LocalPlayer

	interfaces.MyObject.OnCharacterAdded = {
		self = player,
		Event = player.CharacterAdded,
		GetExisting = player.Character
	}
end

return interfaces