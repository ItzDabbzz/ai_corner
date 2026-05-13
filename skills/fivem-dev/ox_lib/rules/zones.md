# Zones (lib.zones)

Use this rule when creating spatial zones for player detection, using poly, box, or sphere shapes.

Zones are a faster alternative to PolyZone, utilizing glm.polygon for efficient collision detection.

## Zone Types

### Poly Zone

```lua
lib.zones.poly(data)
```

| Field | Type | Description |
|-------|------|-------------|
| points | `vector3[]` | Array of 3D points defining the polygon shape |
| thickness | `number` | Height of the polygon (default: `4`) |
| onEnter | `function(self)` | Called when player enters zone |
| onExit | `function(self)` | Called when player exits zone |
| inside | `function(self)` | Called every frame while inside zone |
| debug | `boolean` | Show debug visualization |

### Box Zone

```lua
lib.zones.box(data)
```

| Field | Type | Description |
|-------|------|-------------|
| coords | `vector3` | Center position |
| size | `vector3` | Dimensions (default: `vec3(2, 2, 2)`) |
| rotation | `number` | Angle in degrees (default: `0`) |
| onEnter | `function(self)` | Called when player enters zone |
| onExit | `function(self)` | Called when player exits zone |
| inside | `function(self)` | Called every frame while inside zone |
| debug | `boolean` | Show debug visualization |

### Sphere Zone

```lua
lib.zones.sphere(data)
```

| Field | Type | Description |
|-------|------|-------------|
| coords | `vector3` | Center position |
| radius | `number` | Sphere radius (default: `2`) |
| onEnter | `function(self)` | Called when player enters zone |
| onExit | `function(self)` | Called when player exits zone |
| inside | `function(self)` | Called every frame while inside zone |
| debug | `boolean` | Show debug visualization |

## Zone Methods

### remove

```lua
zone:remove()
```

Removes the zone from the registry. Data is preserved and can be used to recreate it.

### contains

```lua
local inside = zone:contains(vec3(1, 1, 1))
```

Tests if a point is inside the zone.

### setDebug

```lua
zone:setDebug(true)                          -- Enable with default colors
zone:setDebug(true, vec4(255, 0, 0, 100))    -- Enable with custom color
zone:setDebug(false)                         -- Disable
```

## Utility Functions

```lua
-- Get all registered zones
local zones = lib.zones.getAllZones()

-- Get zones the player is currently inside
local currentZones = lib.zones.getCurrentZones()

-- Get zones near the player
local nearbyZones = lib.zones.getNearbyZones()
```

## Examples

### Police station zone

```lua
local policeZone = lib.zones.poly({
    points = {
        vec(413.8, -1026.1, 29),
        vec(411.6, -1023.1, 29),
        vec(412.2, -1018.0, 29),
        vec(417.2, -1016.3, 29),
        vec(422.3, -1020.0, 29),
        vec(426.8, -1015.9, 29),
        vec(431.8, -1013.0, 29),
        vec(437.3, -1018.4, 29),
        vec(432.4, -1027.2, 29),
        vec(424.7, -1023.5, 29),
        vec(420.0, -1030.2, 29),
        vec(409.8, -1028.4, 29),
    },
    thickness = 2,
    debug = true,
    onEnter = function(self)
        print('Entered police station zone')
        lib.notify({title = 'Police Station', description = 'You entered the police station', type = 'inform'})
    end,
    onExit = function(self)
        print('Left police station zone')
    end,
    inside = function(self)
        -- Runs every frame while inside
        DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
    end
})
```

### ATM box zone

```lua
local atmZone = lib.zones.box({
    coords = vec3(-296.5, -896.3, 31.1),
    size = vec3(1, 1, 2),
    rotation = 45,
    debug = false,
    onEnter = function(self)
        lib.showTextUI('[E] - Use ATM', {position = 'right-center', icon = 'credit-card'})
    end,
    onExit = function(self)
        lib.hideTextUI()
    end,
    inside = function(self)
        if IsControlJustReleased(0, 38) then -- E key
            OpenATM()
        end
    end
})
```

### Safe zone sphere

```lua
local safeZone = lib.zones.sphere({
    coords = vec3(215.0, -809.0, 30.7),
    radius = 50.0,
    onEnter = function(self)
        lib.notify({title = 'Safe Zone', description = 'You entered a safe zone. PVP is disabled.', type = 'success'})
        SetEntityInvincible(cache.ped, true)
    end,
    onExit = function(self)
        lib.notify({title = 'Safe Zone', description = 'You left the safe zone. PVP is enabled.', type = 'warning'})
        SetEntityInvincible(cache.ped, false)
    end
})
```

## Zone Creator

Use the built-in zone creator command:

```
/zone poly
/zone box
/zone sphere
```

Controls are displayed on-screen. Zones are saved to `ox_lib/created_zones.lua`.

## Best Practices

- Use zones instead of distance-checking loops whenever possible
- Enable `debug` during development to visualize zone boundaries
- Call `zone:remove()` when a zone is no longer needed (e.g., mission ended)
- Keep `inside` callbacks lightweight — they run every frame
- Use `onEnter`/`onExit` for state changes, `inside` for per-frame actions
