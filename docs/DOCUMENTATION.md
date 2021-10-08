* [Usage](#Usage)
	* [Implements](#Implements)
	* [Extend](#Extending-interfaces-on-the-fly)
	* [Mount](#Mount)

# Usage

Scarlet follows a familiar programming pattern, where objects implement "Interfaces".

A dictionary containing interfaces can look something like this:

```lua
type InterfaceDictionary = {
	[string]: Interface
}

interfaces: InterfaceDictionary = {
	OnPlayerAdded = INTERFACE
}
```

An interface dictionary contains subtables of interfaces.

An interfaces hierarchy is as follows:

```lua
local Players = game:GetService("Players")

type Interface = {
	self: [any]: any | Instance,
	Event: RBXScriptSignal,
	GetExisting: ((...any) -> ...any?) | Instance?
}

interfaces: InterfaceDictionary = {
	OnPlayerAdded = {
		self = Players,
		Event = Players.PlayerAdded,
		GetExisting = Players.GetPlayers
	}
}
```

All in all, your new interface file should look something like this:

```lua
local Players = game:GetService("Players")

type Interface = {
	self: [any]: any | Instance,
	Event: RBXScriptSignal,
	GetExisting: ((...any) -> ...any?) | Instance?
}

type InterfaceDictionary = {
	[InterfaceName]: Interface
}

type Objects = {
	[t]: InterfaceDictionary
}

local interfaces: Objects = {
	myTest = {
		OnPlayerAdded = {
			self = Players,
			Event = Players.PlayerAdded,
			GetExisting = Players.GetPlayers
		}
	}
}

return interfaces
```

Notice how I've subtabled our interface dictionary. This is done to better organize our interfaces, which you will see in a moment.

## Implements

Lets put this into practice. Classes are a great example of objects that can implement interfaces. Take this class for example:

```lua
local testObject = {}
testObject.__index = testObject

function testObject.new()
	local self = setmetatable({}, testObject)

	return self
end

function testObject:OnPlayerAdded(player)
	print(player.Name.. " has entered the game!")
end

return testObject
```

Obviously, this instance method `OnPlayerAdded` will not do anything yet. Lets add our test interface to this class:

```lua
local Scarlet = require(game:GetService("Scarlet")) -- NEW

local testObject = {}
testObject.__index = testObject

function testObject.new()
	local self = setmetatable({}, testObject)
	Scarlet.Implements(self, Scarlet.Interfaces.myTest) -- NEW

	return self
end

function testObject:OnPlayerAdded(player)
	print(player.Name.. " has entered the game!")
end

return testObject
```

Thats it! this object will now listen to player added events, and out print will run correctly.

Our interfaces can also be expanded upon, take for example:

```lua
myTest = {
	OnPlayerAdded = {
		self = Players,
		Event = Players.PlayerAdded,
		GetExisting = Players.GetPlayers
	},
	OnRenderUpdate = {
		self = RunService,
		Event = RunService.RenderStepped
	}
}
```

now:

```lua
function testObject:OnPlayerAdded(player)
	print(player.Name.. " has entered the game!")
end

function testObject:OnRenderUpdate(deltaTime)
	print(deltaTime)
end

return testObject
```
this object will now listen to `RunService.RenderStep`, and update accordingly.

## Extending interfaces on the fly

Scarlet can also extend an interface within its `Implement` constructor.

for example:

```lua
function testObject.new(instance: Instance)

	local self = setmetatable({}, testObject)
	Scarlet.Implements(self, Scarlet.Extend(Scarlet.Interfaces.myTest, {
		OnInstanceChanged = {
			self = instance,
			Event = instance.Changed
		}
	}))

	return self
end
```

 Once extended, it will **not** overwrite the original interface, this makes it using template interfaces much more convenient.

 ## Mount

