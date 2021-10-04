local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Scarlet = {}

--[[
	THINGS WE WANT TO ACHIEVE

	patterns such as:

	require("name")

	function service:OnPlayerAdded(player: Player) end
	function service:OnCharacterAdded(character: Model) end

]]

if RunService:IsClient() then

elseif RunService:IsServer() then

end


function Scarlet.Start()

end


return Scarlet