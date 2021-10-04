local Players = game:GetService("Players")

local PlayerUtil = {}

--- Returns a list of all alive characters
function PlayerUtil.GetAliveCharacters()
	local players = Players:GetPlayers()
	local characterList = {}

	for _, player in pairs(players) do
		local character = player.Character
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
			table.insert(characterList, character)
		end
	end

	return characterList
end


return PlayerUtil