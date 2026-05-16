# Utility Modules

Use this rule when working with ox_lib's shared utility functions for tables, math, strings, and other common operations.

## Table Utilities (lib.table)

```lua
-- Merge tables (shallow)
local merged = lib.table.merge(t1, t2)

-- Deep clone a table
local copy = lib.table.clone(t)

-- Check if table contains value
local has = lib.table.contains(t, 'value')

-- Filter a table
local filtered = lib.table.filter(t, function(k, v) return v > 5 end)

-- Map values
local mapped = lib.table.map(t, function(k, v) return v * 2 end)

-- Reduce to single value
local sum = lib.table.reduce(t, function(acc, k, v) return acc + v end, 0)
```

## Math Utilities (lib.math)

```lua
-- Convert color to RGBA
local r, g, b, a = lib.math.torgba('#eb4034')

-- Round a number
local rounded = lib.math.round(3.7)  -- 4

-- Clamp a number
local clamped = lib.math.clamp(15, 0, 10)  -- 10

-- Generate random number in range
local rand = lib.math.random(1, 100)

-- Format number with commas
local formatted = lib.math.groupdigits(1000000)  -- "1,000,000"

-- Convert degrees to radians
local rad = lib.math.toRadians(180)

-- Convert radians to degrees
local deg = lib.math.toDegrees(math.pi)
```

## String Utilities (lib.string)

```lua
-- Check if string starts with prefix
local starts = lib.string.starts('hello world', 'hello')  -- true

-- Check if string ends with suffix
local ends = lib.string.ends('hello world', 'world')  -- true

-- Split string by delimiter
local parts = lib.string.split('a,b,c', ',')  -- {'a', 'b', 'c'}

-- Trim whitespace
local trimmed = lib.string.trim('  hello  ')  -- 'hello'

-- Format string (like string.format but safer)
local formatted = lib.string.format('Hello %s', 'world')
```

## Print (lib.print)

Enhanced printing with log levels and formatting:

```lua
lib.print.info('Information message')
lib.print.warn('Warning message')
lib.print.error('Error message')
lib.print.debug('Debug message')
```

## WaitFor (lib.waitFor)

Wait for a condition with timeout:

```lua
local success = lib.waitFor(function()
    return DoesEntityExist(vehicle)
end, 'Vehicle failed to spawn', 5000)
```

## Require (lib.require)

Import modules from your own resource:

```lua
local utils = lib.require('modules.utils')
local config = lib.require('config')
```

## Cron (lib.cron)

Schedule tasks to run at specific times:

```lua
-- Run every day at 9 AM
lib.cron.new('0 9 * * *', function()
    print('Daily reset triggered')
end)
```

## Logger (Server)

Send logs to external services:

```lua
lib.logger(source, 'event_name', message, metadata)
```

## Best Practices

1. **Use `lib.table.clone` for deep copies** — Prevents unintended mutations
2. **Use `lib.math.clamp` for bounded values** — Cleaner than manual min/max
3. **Use `lib.string.starts`/`ends`** — More readable than pattern matching for simple cases
4. **Use `lib.waitFor` instead of busy loops** — Cleaner timeout handling
5. **Use `lib.cron` for scheduled tasks** — More reliable than manual timer math
