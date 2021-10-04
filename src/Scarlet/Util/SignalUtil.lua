-- SignalUtil
-- Senor
-- 3/21/2021

--[[

	SignalUtil.nextEvent(event: RBXScriptSignal, func: ()) -> RBXScriptConnection

	SignalUtil.onNextStep(func: ()) -> RBXScriptConnection

	SignalUtil.onNextRenderStep(func: ()) -> RBXScriptConnection

	SignalUtil.onNextHeartbeat(func: ()) -> RBXScriptConnection

--]]


local RunService = game:GetService("RunService")

local Error = require(script.Parent.Error)

local SignalUtil = {}


function SignalUtil.nextEvent(event, func)
	assert(type(func) == "function", "Function argument must be a function")

	local connection
	connection = event:Connect(function(...)
		connection:Disconnect()
		Error.createAdvancer(func, ...)
	end)

	return connection
end


function SignalUtil.onNextStep(func)
	return SignalUtil.nextEvent(RunService.Stepped, func)
end


function SignalUtil.onNextRenderStep(func)
	return SignalUtil.nextEvent(RunService.RenderStepped, func)
end


function SignalUtil.onNextHeartbeat(func)
	return SignalUtil.nextEvent(RunService.Heartbeat, func)
end


return SignalUtil