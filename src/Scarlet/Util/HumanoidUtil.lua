local HumanoidUtil = {}

local STATELESS_STATES = {
	[Enum.HumanoidStateType.Climbing] = false, [Enum.HumanoidStateType.Freefall] = false, [Enum.HumanoidStateType.FallingDown] = false,
	[Enum.HumanoidStateType.GettingUp] = false, [Enum.HumanoidStateType.Flying] = false, [Enum.HumanoidStateType.Jumping] = false,
	[Enum.HumanoidStateType.StrafingNoPhysics] = false, [Enum.HumanoidStateType.RunningNoPhysics] = true, [Enum.HumanoidStateType.Swimming] = false,
	[Enum.HumanoidStateType.Ragdoll] = false, [Enum.HumanoidStateType.PlatformStanding] = false, [Enum.HumanoidStateType.Landed] = false,
}

function HumanoidUtil.CalculateHipHeight(rooPart, foot)
	local bottomOfHumanoidRootPart = rooPart.Position.Y - (.5 * rooPart.Size.Y)
	local bottomOfFoot = foot.Position.Y - (.5 * foot.Size.Y)

	return bottomOfHumanoidRootPart - bottomOfFoot
end


function HumanoidUtil.Stateless(hum)
	HumanoidUtil.SetStates(hum, STATELESS_STATES)
end


function HumanoidUtil.SetStates(hum, states)
	for state, enabled in pairs(states) do
		hum:SetStateEnabled(state, enabled)
	end
end


return HumanoidUtil