# Callbacks (lib.callback)

Use this rule when implementing request/response patterns between client and server with ox_lib.

Callbacks are the preferred alternative to raw TriggerServerEvent/TriggerClientEvent when you need data back. They handle timeouts automatically and keep code cleaner.

## Client → Server

### Trigger a server callback (async)

```lua
lib.callback(name, delay, cb, ...)
```

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Callback identifier |
| delay | `number` or `false` | Cooldown before callback can be triggered again |
| cb | `function` | Callback function receiving the response |
| ... | `any` | Arguments passed to the server handler |

```lua
lib.callback('ox_inventory:getItemCount', false, function(count)
    print('You have', count, 'water bottles')
end, 'water', {type = 'fresh'})
```

### Await server callback (blocking)

```lua
local result = lib.callback.await(name, delay, ...)
```

```lua
local count = lib.callback.await('ox_inventory:getItemCount', false, 'water', {type = 'fresh'})
print(count)
```

## Server → Client

### Trigger a client callback (async)

```lua
lib.callback(name, playerId, cb, ...)
```

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Callback identifier |
| playerId | `number` | Target player server id |
| cb | `function` | Callback function receiving the response |
| ... | `any` | Arguments passed to the client handler |

```lua
lib.callback('ox:getNearbyVehicles', source, function(vehicles)
    for i = 1, #vehicles do
        print(vehicles[i].plate)
    end
end, 10.0)
```

### Await client callback (blocking)

```lua
local result = lib.callback.await(name, playerId, ...)
```

```lua
local vehicles = lib.callback.await('ox:getNearbyVehicles', source, 10.0)
```

## Registering Callbacks

### Server-side registration

```lua
lib.callback.register(name, cb)
```

```lua
lib.callback.register('ox_inventory:getItemCount', function(source, item, metadata, target)
    local inventory = target and Inventory(target) or Inventory(source)
    return (inventory and Inventory.GetItem(inventory, item, metadata, true)) or 0
end)
```

### Client-side registration

```lua
lib.callback.register('ox:getNearbyVehicles', function(radius)
    local nearbyVehicles = lib.getNearbyVehicles(GetEntityCoords(cache.ped), radius, true)
    return nearbyVehicles
end)
```

## Key Principles

1. **Use `lib.callback.await` for simple flows** — Cleaner than separate callback functions
2. **Always return values from registered callbacks** — The return value is what the caller receives
3. **Validate on the server** — Even with callbacks, never trust client-provided data
4. **Use delays to prevent spam** — Set a reasonable cooldown for expensive callbacks
5. **Keep callbacks focused** — One callback should do one thing; don't build monolithic handlers
