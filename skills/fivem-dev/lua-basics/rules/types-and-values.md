# Types and Values

## Overview

FiveM uses **CfxLua**, a modified Lua 5.4. Only Lua features actually available in FiveM are documented here.

## Core Types

- nil
- boolean
- number (double-precision float)
- string
- table
- function
- thread
- userdata

## CfxLua Extensions

- vector3, vector4, vec3, vec4
- quat (quaternion)
- compile-time Jenkins hashes using backtick syntax (`adder`)

## LuaDoc Conventions

Use LuaDoc annotations for type hints and parameter documentation:

```lua
--- Creates a new player entity
---@param id number player ID
---@param name string player name
---@return number createdId the created entity ID
local function createPlayer(id, name)
    -- implementation
end
```

## Type Coercion

- Lua is weakly typed
- Strings concatenate automatically with numbers in some operations
- tonumber() converts strings/numbers to numbers
- tostring() converts values to strings
- type() returns the type as a string

## Gotchas

- nil vs false: they are different. `nil` means no value, `false` means boolean false.
- Tables are reference types: comparing with == checks identity, not content.
- Numbers vs strings from JSON/events: always validate types explicitly.

## Safe Patterns

- Always validate parameter types:
  - `if type(x) ~= "number" then return end`
  - `if type(x) ~= "string" then return end`
- Use pcall(xpcall) for error-prone operations.
