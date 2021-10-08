local RunService = game:GetService("RunService")
local Scarlet = require(game:GetService("ReplicatedStorage").Scarlet)

local myObject = {}
myObject.__index = myObject

function myObject.new()
	local self = setmetatable({}, myObject)
	self._numValue = Instance.new("NumberValue")
	self._numValue.Value = 0

	return self
end

function myObject:OnPlayerAdded(player)
	print(player, " has entered the game")
end

function myObject:OnValueChange()
	print("value changed ", self._numValue.Value)
end

function myObject:OnPhysicsStep(step)
	self._numValue.Value += step
end

--> instancing a new class
local object = myObject.new()

Scarlet.Implements(object, Scarlet.Extend(Scarlet.Interfaces.MyObject, {
	OnPhysicsStep = {
		self = RunService,
		Event = RunService.Stepped
	},
	OnValueChange = {
		self = object._numValue,
		Event = object._numValue:GetPropertyChangedSignal("Value"),
		GetExisting = object._numValue.Value
	}
}))

--> example usage with knit
local servicesFolder
local Knit = require(game:GetService("ReplicatedStorage").Knit)
Scarlet.Mount(Knit.Services, Scarlet.TestInterface.Knit)

Knit.AddServices(servicesFolder)

Knit.Start():Catch(warn):Await()