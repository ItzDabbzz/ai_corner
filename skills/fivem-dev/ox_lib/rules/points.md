# Points (lib.points)

Use this rule when creating distance-based points with enter/exit/nearby callbacks.

Points are simpler than zones — they use a center coordinate and radius for circular distance checking. They're ideal for single-location interactions.

## CPoint Class

A point object with these properties:

| Field | Type | Description |
|-------|------|-------------|
| id | `number` | Unique point identifier |
| coords | `vector3` | Center position |
| distance | `number` | Radius for "inside" detection |
| currentDistance | `number` | Player's current distance from center |
| isClosest | `boolean` | Whether this is the closest point to the player |
| remove | `function()` | Removes the point from the registry |
| onEnter | `function(self)` | Called when player enters distance |
| onExit | `function(self)` | Called when player exits distance |
| nearby | `function(self)` | Called every frame while within distance |

## lib.points.new

Creates a new point.

```lua
local point = lib.points.new(data)
```

| Field | Type | Description |
|-------|------|-------------|
| coords | `vector3` | Center position |
| distance | `number` | Detection radius |
| ... | `any` | Custom properties are passed through to the point object |

## Utility Functions

```lua
-- Get all points created in this resource
local points = lib.points.getAllPoints()

-- Get points currently in range
local nearby = lib.points.getNearbyPoints()

-- Get the closest point
local closest = lib.points.getClosestPoint()
```

## Examples

### Basic interaction point

```lua
local point = lib.points.new({
    coords = GetEntityCoords(cache.ped),
    distance = 5,
})

function point:onEnter()
    print('Entered range of point', self.id)
end

function point:onExit()
    print('Left range of point', self.id)
end

function point:nearby()
    DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)

    if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
        print('Interacted with point', self.id)
    end
end
```

### Shop interaction point

```lua
local shopPoint = lib.points.new({
    coords = vec3(24.5, -1346.8, 29.5),
    distance = 10,
    shopType = 'general',
})

function shopPoint:onEnter()
    lib.showTextUI('[E] - Open Shop', {position = 'right-center', icon = 'shop'})
end

function shopPoint:onExit()
    lib.hideTextUI()
end

function shopPoint:nearby()
    if self.currentDistance < 1.5 and IsControlJustReleased(0, 38) then
        exports.ox_inventory:openInventory('shop', {type = 'General', id = 1})
    end
end
```

### Removing a point

```lua
-- When no longer needed
point:remove()
```

## Points vs Zones

| Feature | Points | Zones |
|---------|--------|-------|
| Shape | Circle (radius) | Poly, box, or sphere |
| Complexity | Simple | More complex |
| Performance | Lighter | Slightly heavier |
| Use case | Single interactions, markers | Complex areas, regions |
| Built-in editor | No | Yes (`/zone`) |

## Best Practices

- Use points for simple single-location interactions (shops, ATMs, NPCs)
- Use zones for complex or irregularly shaped areas (gangs territories, safe zones)
- Keep `nearby` callbacks lightweight — they run every frame while in range
- Call `point:remove()` when a point is no longer needed
- Access custom properties via `self.propertyName` in callbacks
