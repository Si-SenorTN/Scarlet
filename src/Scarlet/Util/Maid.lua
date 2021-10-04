-- Maid
-- Quenty - Senor
-- 9/14/2021

local MaidUtil = require(script.Parent.MaidUtil)

local Maid = {}
Maid.ClassName = "Maid"


function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid.Is(value)
	return type(value) == "table" and getmetatable(value) == Maid
end


function Maid:__index(index)
	if Maid[index] then
		return Maid[index]
	else
		return self._tasks[index]
	end
end


function Maid:__newindex(index, newTask)
	if Maid[index] ~= nil then
		error(("'%s' is reserved"):format(tostring(index)), 2)
	end

	local tasks = self._tasks
	local oldTask = tasks[index]

	if oldTask == newTask then
		return
	end

	tasks[index] = newTask

	if oldTask then
		MaidUtil.doTask(oldTask)
	end
end


function Maid:GiveTask(task)
	if not task then
		error("Task cannot be false or nil", 2)
	end

	if not MaidUtil.isValidTask(task) then
		error("Gave bad task", 2)
	end

	local taskId = #self._tasks + 1
	self[taskId] = task

	if type(task) == "table" and not task.Destroy then
		warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback())
	end

	return taskId
end
Maid.Add = Maid.GiveTask


function Maid:Remove(index)
	local oldTask = self._tasks[index]

	if oldTask then
		MaidUtil.doTask(oldTask)
		self._tasks[index] = nil
	end
end


function Maid:DoCleaning()
	local tasks = self._tasks

	for index, t in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			tasks[index] = nil
			t:Disconnect()
		end
	end

	local index, t = next(tasks)
	while t ~= nil do
		tasks[index] = nil
		MaidUtil.doTask(t)
		index, t = next(tasks)
	end
end
Maid.Destroy = Maid.DoCleaning


return Maid