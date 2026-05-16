# ox_target

Use this rule when creating targeting options (third-eye interactions) with ox_target.

ox_target is a performant standalone targeting system with framework integration for ox_core, ESX, and QBCore.

## Dependencies

- ox_lib (required)

## Convars

```bash
# Toggle targeting on press instead of hold
setr ox_target:toggleHotkey 0

# Target activation key
setr ox_target:defaultHotkey LMENU

# Draw sprite at zone centroid
setr ox_target:drawSprite 1

# Enable built-in options (vehicle doors, etc.)
setr ox_target:defaults 1

# Enable debug mode
setr ox_target:debug 0

# Enable left-click selection
setr ox_target:leftClick 1
```

## Client Exports

### addZone

Add a targeting zone (poly, box, or sphere).

```lua
exports.ox_target:addZone(data)
```

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Unique identifier |
| coords | `vector3` | Center position |
| size | `vector3` | Box size (for box zones) |
| radius | `number` | Sphere radius (for sphere zones) |
| rotation | `number` | Rotation in degrees |
| debug | `boolean` | Show debug visualization |
| drawSprite | `boolean` | Draw target sprite |
| options | `table[]` | Array of interaction options |

### addModel

Add targeting to specific entity models.

```lua
exports.ox_target:addModel(models, options)
```

```lua
exports.ox_target:addModel(`prop_atm_01`, {
    {
        name = 'atm_interaction',
        icon = 'fa-solid fa-credit-card',
        label = 'Use ATM',
        onSelect = function(data)
            OpenATM()
        end,
        distance = 1.5,
    }
})
```

### addGlobalPed / addGlobalVehicle / addGlobalPlayer / addGlobalObject

Add global targeting options for entity types.

```lua
exports.ox_target:addGlobalPed(options)
exports.ox_target:addGlobalVehicle(options)
exports.ox_target:addGlobalPlayer(options)
exports.ox_target:addGlobalObject(options)
```

### addEntity

Add targeting to a specific entity instance.

```lua
exports.ox_target:addEntity(netId, options)
```

### removeZone / removeModel / removeGlobalPed / etc.

```lua
exports.ox_target:removeZone(name)
exports.ox_target:removeModel(models, optionName)
exports.ox_target:removeGlobalPed(optionName)
```

## Option Properties

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Unique option identifier |
| icon | `string` | FontAwesome icon class |
| label | `string` | Display text |
| onSelect | `function(data)` | Callback when selected |
| distance | `number` | Max interaction distance |
| groups | `table` | Job/gang restrictions `{['police'] = 0}` |
| items | `string` or `string[]` or `table` | Required item(s) |
| canInteract | `function(entity, distance, coords, name, bone)` | Dynamic visibility check |
| bones | `string[]` | Specific bones (for peds/vehicles) |

## Option Data (onSelect callback)

```lua
{
    entity = entityId,      -- Target entity
    coords = vector3,       -- Hit coordinates
    distance = number,      -- Distance to target
    zone = zoneData,        -- Zone data (if zone target)
}
```

## Examples

### ATM targeting

```lua
exports.ox_target:addModel({'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}, {
    {
        name = 'atm_use',
        icon = 'fa-solid fa-credit-card',
        label = 'Use ATM',
        onSelect = function(data)
            OpenBanking()
        end,
        distance = 1.5,
    }
})
```

### Vehicle targeting

```lua
exports.ox_target:addGlobalVehicle({
    {
        name = 'vehicle_trunk',
        icon = 'fa-solid fa-box-open',
        label = 'Open Trunk',
        onSelect = function(data)
            local netid = NetworkGetNetworkIdFromEntity(data.entity)
            exports.ox_inventory:openInventory('trunk', {netid = netid})
        end,
        distance = 2.0,
        bones = {'boot'},
    },
    {
        name = 'vehicle_hood',
        icon = 'fa-solid fa-car-battery',
        label = 'Open Hood',
        onSelect = function(data)
            SetVehicleDoorOpen(data.entity, 4, false, false)
        end,
        distance = 2.0,
        bones = {'bonnet'},
    },
})
```

### Zone targeting (shop)

```lua
exports.ox_target:addZone({
    name = 'general_store',
    coords = vec3(24.5, -1346.8, 29.5),
    size = vec3(2, 2, 2),
    rotation = 45,
    debug = false,
    options = {
        {
            name = 'shop_buy',
            icon = 'fa-solid fa-shop',
            label = 'Browse Shop',
            onSelect = function(data)
                exports.ox_inventory:openInventory('shop', {type = 'General', id = 1})
            end,
            distance = 2.0,
        }
    }
})
```

### Job-restricted targeting

```lua
exports.ox_target:addGlobalPed({
    {
        name = 'police_search',
        icon = 'fa-solid fa-magnifying-glass',
        label = 'Search',
        onSelect = function(data)
            TriggerServerEvent('police:searchPlayer', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
        end,
        distance = 2.0,
        groups = {['police'] = 0, ['sheriff'] = 0},
        canInteract = function(entity, distance, coords, name)
            return IsPedCuffed(entity)
        end,
    }
})
```

### Item-required targeting

```lua
exports.ox_target:addModel(`prop_door_rotating`, {
    {
        name = 'door_lockpick',
        icon = 'fa-solid fa-lock',
        label = 'Lockpick',
        onSelect = function(data)
            AttemptLockpick(data.entity)
        end,
        distance = 1.5,
        items = 'lockpick',
    }
})
```

## Best Practices

1. **Use `name` for all options** — Required for removal and identification
2. **Set appropriate `distance`** — Don't use 10m for an ATM interaction
3. **Use `canInteract` for dynamic checks** — Hide options when not applicable
4. **Remove options when no longer needed** — Prevents memory leaks and conflicts
5. **Use `bones` for precise vehicle interactions** — `boot`, `bonnet`, `door_dside_f`, etc.
6. **Group related options** — Use the same model/zone for multiple related interactions
