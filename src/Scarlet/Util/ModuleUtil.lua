-- ModuleUtil
-- Senor
-- 3/20/2021

--[[

	ModuleUtil.CreateMap(directory: Instance) -> map[moduleName: string, loadedModule: table]
		-- shallow checks children for module scripts

	ModuleUtil.CreateMapDeep(directory: Instance) -> map[moduleName: string, loadedModule: table]
		-- same as CreateMap except does a recursive check

	ModuleUtil.LoadShallow(directory: Instance) -> ()
		-- shallow requires any child module script from directory instance

	ModuleUtil.LoadDeep(directory: Instance) -> ()
		-- same as LoadShallow except does a recursive check

--]]

local ModuleUtil = {}


function ModuleUtil.CreateMap(directory)
	local map = {}

	for _, module in pairs(directory:GetChildren()) do
		if module:IsA("ModuleScript") then
			local loadedModule = require(module)
			map[module.Name] = loadedModule
		end
	end

	return map
end


function ModuleUtil.CreateMapDeep(directory)
	local map = {}

	for _, module in pairs(directory:GetDescendants()) do
		if module:IsA("ModuleScript") then
			local loadedModule = require(module)
			map[module.Name] = loadedModule
		end
	end

	return map
end


function ModuleUtil.LoadShallow(directory)
	for _, module in pairs(directory:GetChildren()) do
		if module:IsA("ModuleScript") then
			require(module)
		end
	end
end


function ModuleUtil.LoadDeep(directory)
	for _, module in pairs(directory:GetDescendants()) do
		if module:IsA("ModuleScript") then
			require(module)
		end
	end
end


return ModuleUtil