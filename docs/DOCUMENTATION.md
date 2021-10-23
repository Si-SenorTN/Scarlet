* [Usage](#Usage)
	* [Implements](#implements)
	* [Extend](#extending-interfaces-on-the-fly)
	* [Mount](#mount)
	* [Connection](#connection)
* [Frameworks](#usage-with-frameworks)
	* [Knit](#knit)

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

type t = {
	[any]: any
}

type Interface = {
	self: t | Instance,
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

Thats it! this object will now listen to player added events, and our print will run correctly.

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
this object will now listen to `RunService.RenderStepped`, and update accordingly.

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

Once extended, it will **not** overwrite the original interface, this makes using template interfaces much more convenient.

## Mount

Onto the main event, Scarlet has the ability to 'Mount' dictionaries/arrays of objects and call `Scarlet.Implemets()` on them automatically.

An example of this could be:

```lua
local services = {}
services.MyService = {
	init = function() end,
	OnPlayerAdded = function(player)
		print(player.Name.." has entered the game")
	end

}

Scarlet.Mount(services, Scarlet.Interfaces.myTest)
```

Obviously this is a pretty impractical setup, but the idea is there nonetheless.

`Scarlet.Mount()` also listens to table additions, automatically calling `Scarlet.Implements()` on the newly added table

```lua
local services = Scarlet.Mount({}, Scarlet.Interfaces.myTest)

services.MyService = {
	init = function() end,
	OnPlayerAdded = function(player)
		print(player.Name.." has entered the game")
	end
}
```

## Connection

All of Scarlets constructor methods return a `Connection` object.
This object is safe to pass to a [`Maid`](https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Shared/Events/Maid.lua), [`Janitor`](https://github.com/howmanysmall/Janitor), and various of other cleanup classes that consume `Disconnect` and or `Destroy` methods.

```lua
local connection = Scarlet.Implements(self, Scarlet.Interfaces.myTest)

connection:Add(rbxScriptConnection)

connection:Disconnect()
connection:Destroy()

maid:GiveTask(connection)
janitor:Add(connection, "Connection", "Destroy")
```

# Usage with frameworks

Scarlet can easily mount itself onto other frameworks.

## Knit

lets take a look at a current popular framework, such as [Knit](https://github.com/Sleitnick/Knit).

Knit has `Controllers` and `Services` dictionaries we can mount onto. Take for example:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local someServiceDirectory

local Scarlet = require(ReplicatedStorage.Scarlet)
local Knit = require(ReplicatedStorage.Knit)

Scarlet.Mount(Knit.Services, Scarlet.Interfaces.myTest)

Knit.AddServices(someServiceDirectory)

Knit.Start()
```

Scarlet will listen to every added service and implement our interface.
Now we can create behaviors such as this:

```lua
local Knit = require(game:GetService("ReplicatedStorage").Knit)

local test = Knit.CreateService {
	Name = "test",
	Client = {},
}


function test:OnPlayerAdded(player)

end


function test:KnitStart()

end


function test:KnitInit()

end


return test
```

On the client this method is identical. Just index `Knit.Controllers` rather than `Knit.Services`

There are many other frameworks that implement this pattern, such as [AeroGameFramework](https://github.com/Sleitnick/AeroGameFramework)