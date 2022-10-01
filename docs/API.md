# Scarlet

## `Scarlet.Interfaces: Dictionary<Interfaces>`
Dictionary containing template interfaces for scarlet.

## `Scarlet.Extend(t: [any]: any, extension: [any]: any)` -> `[any]: any`
Copies and extends a table, leaving the original table alone.

## `Scarlet.Mount(t: [any]: any, interface: Interface)` -> `Connection`
Mounts and listens to added tables from `t`, internally calls `Scarlet.Implemets()` on all tables implementing the passed `interface`.

## `Scarlet.Implements(t: [any]: any, interface: Interface)` -> `Connection`
Implements the passed `interface` onto the passed `t` object.

# Interface
An Interface is a dictionary containing our necessary interface data.

## `Interface.self: [any]: any | Instance`
Holds a reference to the super object we're pointing to our events and methods from.
As per lua OOP laws, in order to call an instance method via `object[methodName](...)` we must include the `self` object as the first argument: `object[methodName](self, ...)`.

## `Interface.Event: RBXScriptSignal`
Holds a reference to the event we want to link our instance method to.

## `@opt Interface.GetExisting: ((...any) -> ...any) | any`
Optional field holding a reference to either a function or non nil value that will be used an an `init` method to use any pre existing value.

an example of this is a character added event, listening to the event and also calling a custom `onCharacterAdded` method to kick off state incase we miss the initial event invocation.

# Connection
Object returned by Scarlets constructor methods as a means to clean up connections made.

## `conn` = `{ Disconnect: () -> nil } | RBXScriptConnection`

## `Connection.new(connections: Array<conn>)` -> `Connection`

## `Connection:Add(c: conn)`
NOTE: Disconnect objects can consume themselves

## `Connection:Disconnect()`
Cleans all connection objects

## `@alias Connection:Destroy()`
Cleans all connection objects