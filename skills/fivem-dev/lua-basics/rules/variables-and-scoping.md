# Variables and Scoping

## Local vs Global

- Use local for all variables unless there is a clear reason not to.
- Global variables can leak across resources.
- Local variables are faster and safer.

Example (BAD):

```lua
config = { speed = 100 }
```

Example (GOOD):

```lua
local config = { speed = 100 }
```

## Closures

- Closures are functions that capture variables from their outer scope.
- Commonly used for event handlers and callbacks.

Example:

```lua
local function createHandler(prefix)
    return function(message)
        print(prefix .. message)
    end
end

local handler = createHandler("[MY_RESOURCE] ")
handler("Hello")  -- prints: [MY_RESOURCE] Hello
```

## _ENV Awareness

- _ENV exists in CfxLua (Lua 5.4) but is not a sandboxing tool you should rely on.
- Don’t use _ENV to create custom sandboxes for resources.
- FiveM uses its own sandboxing model internally.

## Typical Patterns

- Resource-local variables:
  - All module-level variables should be local.
  - Avoid global state that other resources might read/write.

Example (GOOD):

```lua
local config = {
    maxPlayers = 100,
    debug = false
}

local function getConfig()
    return config
end
```
