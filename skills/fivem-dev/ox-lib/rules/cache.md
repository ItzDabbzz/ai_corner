# Cache (cache / lib.onCache)

Use this rule when working with cached player state values to avoid repeated native calls.

## What is cache?

The `cache` table stores frequently accessed values that rarely change, eliminating the need to call expensive natives repeatedly. It is automatically populated when ox_lib is imported.

## Shared Defaults

| Key | Type | Description |
|-----|------|-------------|
| resource | `string` | Current resource name (`GetCurrentResourceName()`) |
| game | `string` | `'fxserver'`, `'fivem'`, or `'redm'` |

## Client Defaults

| Key | Type | Description |
|-----|------|-------------|
| ped | `number` | Player entity id |
| playerId | `number` | Player id |
| serverId | `number` | Player server id |
| weapon | `number` or `false` | Current weapon hash |
| vehicle | `number` or `false` | Vehicle entity id |
| seat | `number` or `false` | Vehicle seat index |
| coords | `vector3` | Current player coords (only populated with zones/points) |
| mount | `number` or `false` | Mount entity id (RedM only) |

## lib.onCache

Register a handler that fires when a cached value changes.

```lua
lib.onCache(key, function(value, oldValue)
    -- Handle cache change
end)
```

### Available Keys for onCache

- `ped` — Player entity changed (e.g., respawned)
- `vehicle` — Entered/exited a vehicle
- `seat` — Changed vehicle seat
- `weapon` — Changed equipped weapon
- `mount` — Mount changed (RedM only)

Note: `coords` cannot be listened to with `lib.onCache`.

## Examples

### Basic cache usage

```lua
-- Instead of calling PlayerPedId() repeatedly
local ped = cache.ped

-- Instead of GetVehiclePedIsIn(PlayerPedId(), false)
local vehicle = cache.vehicle

-- Check if armed
if cache.weapon then
    print('Current weapon hash:', cache.weapon)
end
```

### Reacting to vehicle entry/exit

```lua
lib.onCache('vehicle', function(value, oldValue)
    if value then
        print('Entered vehicle:', value)
        -- Enable vehicle-specific UI
    else
        print('Exited vehicle:', oldValue)
        -- Disable vehicle-specific UI
    end
end)
```

### Reacting to weapon changes

```lua
lib.onCache('weapon', function(value)
    if value then
        print('Equipped weapon:', value)
    else
        print('Holstered weapon')
    end
end)
```

## Custom Cache Values

You can add your own cached values with optional timeout:

```lua
cache(key, func, timeout)
```

```lua
local i = 0
while true do
    Wait(1000)
    i += 1
    -- Caches for 5 seconds, then recalculates
    print(cache('counter', function() return i end, 5000))
end
```

## Best Practices

1. **Always use `cache.ped` instead of `PlayerPedId()`** — It's faster and auto-updates
2. **Use `lib.onCache` instead of polling** — Let the library notify you of changes
3. **Don't cache `coords` for precise positioning** — Use `GetEntityCoords(cache.ped)` for real-time position
4. **Cache expensive computations** — Use custom cache for database lookups or complex calculations
