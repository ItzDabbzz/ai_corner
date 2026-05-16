# Performance and Pitfalls

## General

- FiveM scripts run in a shared environment.
- Inefficient code can slow down the server and affect all players.

## Avoid Globals

- Globals are slower and risk collisions.
- Prefer local for all variables, functions, and modules.

Good:
  - local config = { debug = true }

Bad:
  - config = { debug = true }

## Cache Natives and Repeated Calls

- Native calls are relatively expensive.
- Cache results outside loops and frequent handlers.

Bad:
  - while true do
      local ped = GetPlayerPed(PlayerId())
      DoSomething(ped)
      Wait(0)
    end

Good:
  - local myPed = GetPlayerPed(PlayerId())

    while true do
        DoSomething(myPed)
        Wait(0)
    end

## Avoid Heavy Work in Tight Loops/Timers

- Don't do expensive operations every frame or very frequently.
- Use:
  - Cooldowns
  - Event-driven logic
  - Batch operations

Bad:
  - for i = 1, 1000 do
      DoSomethingExpensive(i)
    end
    -- inside a 0ms loop

Good:
  - Use larger Wait(500) or more
  - Limit loops to reasonable sizes

## Table Reuse

- Reuse tables where possible instead of recreating them.
- Especially important in tight loops or frequent callbacks.

Bad:
  - while true do
      local t = {}
      t[1] = 1
      DoSomething(t)
      Wait(0)
    end

Good:
  - local t = {}

    while true do
        t[1] = 1
        DoSomething(t)
        Wait(0)
    end

## Metatable Overhead

- Metatables add overhead for access and operations.
- Use them when they clearly improve clarity, not as a default.
- Avoid deeply nested metatables in performance-critical paths.

## Memory Leaks

Common patterns to avoid:

- Keeping references to:
  - players
  - vehicles
  - peds
  - timers/threads

Bad:
  - local allPlayers = {}

    AddEventHandler("playerDropped", function()
        -- never remove from allPlayers
    end)

Good:
  - local allPlayers = {}

    AddEventHandler("playerConnecting", function(name, _, deferrals)
        local src = source
        allPlayers[src] = true
    end)

    AddEventHandler("playerDropped", function()
        allPlayers[source] = nil
    end)

- Use weak tables for caches/tracking when appropriate:

  - local cache = setmetatable({}, { __mode = "v" })

## Export Calls

- Exports are relatively expensive.
- Avoid calling exports:
  - in tight loops
  - with huge payloads
- Prefer:
  - many small calls
  - accessor exports
  - batched operations where possible
