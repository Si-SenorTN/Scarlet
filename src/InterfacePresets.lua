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

export type t = {
	[any]: any
}

export type Interface = {
	Event: RBXScriptSignal,
	self: t,
	GetExisting: ((...any) -> t?) | Instance?
}

export type InterfaceDictionary = {
	[string]: Interface
}

type Objects = {
	[t]: InterfaceDictionary,
}


local interfaces: Objects = {}

-- inject a test object
interfaces = {
	Services = {},
	Controllers = {}
}

if RunService:IsServer() then
	local playerAddedInterface = {
		self = Players,
		Event = Players.PlayerAdded,
		GetExisting = Players.GetPlayers
	}

	interfaces.Services.OnPlayerAdded = playerAddedInterface
elseif RunService:IsClient() then
	local player = Players.LocalPlayer

	local characterAddedInterface = {
		self = player,
		Event = player.CharacterAdded,
		GetExisting = player.Character
	}

	interfaces.Controllers.OnCharacterAdded = characterAddedInterface
end

return interfaces