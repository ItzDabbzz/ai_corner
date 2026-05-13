# Context Menu (lib.registerContext)

Use this rule when creating right-click style context menus with ox_lib.

## lib.registerContext

Registers one or more context menus.

```lua
lib.registerContext(context)
```

### Context Parameters

| Field | Type | Description |
|-------|------|-------------|
| id | `string` | Unique menu identifier |
| title | `string` | Menu title (supports markdown) |
| position | `string` | `'top-left'`, `'top-right'`, `'bottom-left'`, `'bottom-right'` (default: `'top-right'`) |
| menu | `string` | Parent menu id (adds back arrow) |
| canClose | `boolean` | If `false`, user cannot exit without pressing a button |
| onExit | `function()` | Called when menu closed with ESC |
| onBack | `function()` | Called when back button pressed |
| options | `table[]` | Array of option buttons |

### Option Parameters

| Field | Type | Description |
|-------|------|-------------|
| title | `string` | Button title (supports markdown) |
| disabled | `boolean` | Grays out and disables the button |
| readOnly | `boolean` | Removes hover/active styles, disables onSelect |
| menu | `string` | Navigate to another menu |
| onSelect | `function()` | Function called on click |
| icon | `string` | FontAwesome icon or image URL |
| iconColor | `string` | Icon color |
| iconAnimation | `string` | Animation type |
| progress | `number` | Progress bar percentage |
| colorScheme | `string` | Progress bar color |
| arrow | `boolean` | Show navigation arrow |
| description | `string` | Description under title (supports markdown) |
| image | `string` | Image URL for metadata |
| metadata | `table[]` or `table` | Side-panel info on hover |
| event | `string` | Client event to trigger |
| serverEvent | `string` | Server event to trigger |
| args | `any` | Arguments passed to events or onSelect |

### Metadata Format

```lua
metadata = {
    {label = 'Value 1', value = 'Some value'},
    {label = 'Value 2', value = 300, progress = 50, colorScheme = 'blue'},
}
```

## Control Functions

```lua
-- Show a registered context menu
lib.showContext(id)

-- Hide any visible context menu
lib.hideContext(onExit)  -- onExit: boolean

-- Get the currently open context menu id
local id = lib.getOpenContextMenu()
```

## Example

```lua
lib.registerContext({
    id = 'police_menu',
    title = 'Police Actions',
    options = {
        {
            title = 'Search Suspect',
            icon = 'magnifying-glass',
            onSelect = function()
                TriggerEvent('police:search')
            end,
            metadata = {
                {label = 'Range', value = '2 meters'},
            }
        },
        {
            title = 'Cuff',
            icon = 'handcuffs',
            event = 'police:cuff',
            args = {type = 'soft'}
        },
        {
            title = 'Submenu',
            menu = 'police_submenu',
            icon = 'bars'
        }
    }
})

lib.registerContext({
    id = 'police_submenu',
    title = 'More Actions',
    menu = 'police_menu',
    options = {
        {title = 'Put in Vehicle'},
        {title = 'Take out of Vehicle'},
    }
})

RegisterCommand('policemenu', function()
    lib.showContext('police_menu')
end)
```

## Sorting

- Use keys (named table entries) for alphabetical sorting
- Use array-style tables for order-preserving menus

## Best Practices

- Register static menus once at resource start
- Use `event` or `serverEvent` for simple triggers, `onSelect` for complex logic
- Pass `args` to avoid hardcoding values in event handlers
