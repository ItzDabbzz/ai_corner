# Radial Menu (lib.registerRadial)

Use this rule when creating radial (pie) menus with ox_lib.

## lib.registerRadial

Registers a radial menu with options arranged in a circular layout.

```lua
lib.registerRadial(data)
```

### Data Parameters

| Field | Type | Description |
|-------|------|-------------|
| id | `string` | Unique menu identifier |
| items | `table[]` | Array of radial options |

### Item Parameters

| Field | Type | Description |
|-------|------|-------------|
| label | `string` | Button label |
| icon | `string` | FontAwesome icon |
| iconColor | `string` | Icon color |
| onSelect | `function()` | Callback on selection |
| menu | `string` | Navigate to submenu |

## Control Functions

```lua
-- Show a registered radial menu
lib.showRadial(id)

-- Hide the radial menu
lib.hideRadial()

-- Get the currently open radial menu id
local id = lib.getOpenRadialMenu()
```

## Example

```lua
lib.registerRadial({
    id = 'vehicle_menu',
    items = {
        {
            label = 'Engine',
            icon = 'car-battery',
            onSelect = function()
                ToggleVehicleEngine()
            end
        },
        {
            label = 'Doors',
            icon = 'door-open',
            menu = 'door_submenu'
        },
        {
            label = 'Trunk',
            icon = 'box-open',
            onSelect = function()
                ToggleTrunk()
            end
        }
    }
})

lib.registerRadial({
    id = 'door_submenu',
    items = {
        {label = 'Driver', icon = 'door-closed', onSelect = function() ToggleDoor(0) end},
        {label = 'Passenger', icon = 'door-closed', onSelect = function() ToggleDoor(1) end},
        {label = 'Rear Left', icon = 'door-closed', onSelect = function() ToggleDoor(2) end},
        {label = 'Rear Right', icon = 'door-closed', onSelect = function() ToggleDoor(3) end},
    }
})

-- Bind to a key
lib.addKeybind({
    name = 'vehicle_radial',
    description = 'Open vehicle radial menu',
    defaultKey = 'F6',
    onPressed = function()
        if cache.vehicle then
            lib.showRadial('vehicle_menu')
        end
    end
})
```

## Best Practices

- Keep radial menus to 6-8 items for usability
- Use submenus for related options instead of overcrowding
- Check game state (in vehicle, on foot) before showing context-specific radials
