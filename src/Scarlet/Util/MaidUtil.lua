local MaidTaskUtils = {}


function MaidTaskUtils.isValidTask(maidTask)
	return type(maidTask) == "function"
		or (typeof(maidTask) == "RBXScriptConnection" or maidTask.Disconnect)
		or type(maidTask) == "table" and type(maidTask.Destroy) == "function"
end


function MaidTaskUtils.doTask(maidTask)
	if type(maidTask) == "function" then
		task.defer(maidTask)
	elseif typeof(maidTask) == "RBXScriptConnection" or maidTask.Disconnect then
		maidTask:Disconnect()
	elseif type(maidTask) == "table" or type(maidTask.Destroy) == "function" then
		maidTask:Destroy()
	else
		error("Bad task")
	end
end


function MaidTaskUtils.delayed(time, maidTask)
	return function()
		task.delay(time, function()
			MaidTaskUtils.doTask(maidTask)
		end)
	end
end


return MaidTaskUtils