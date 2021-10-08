# Scarlet

## `Scarlet.Interfaces: [InterfaceDictionary]: Interface`
dictionary containing template interfaces for scarlet

## `Scarlet.Copy(t: [any]: any)` -> `[any]: any`
copies a table

## `Scarlet.Extend(t: [any]: any, extension: [any]: any)` -> `[any]: any`
copies and extends a table, leaving the original table alone

## `Scarlet.Mount(t: [any]: any, interface: Interface)` -> `t`
Mounts and listens to added tables from `t` natively calls `Scarlet.Implemets()` on all tables using the passed `interface`

## `Scarlet.Implements(t: [any]: any, interface: Interface)` -> `t`
Implements the passed `interface` onto the passed `t` object