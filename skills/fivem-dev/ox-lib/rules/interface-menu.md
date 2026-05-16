# Menu (lib.registerMenu)

Use this rule when creating keyboard-navigable menus with ox_lib.

## lib.registerMenu

Registers and caches a menu under a unique id.

```lua
lib.registerMenu(data, cb)
```

### Data Parameters

| Field | Type | Description |
|-------|------|-------------|
| id | `string` | Unique menu identifier |
| title | `string` | Menu title |
| options | `table[]` | Array of menu options |
| position | `string` | `'top-left'`, `'top-right'`, `'bottom-left'`, `'bottom-right'` (default: `'top-left'`) |
| disableInput | `boolean` | Default: `false` |
| canClose | `boolean` | If `false`, user cannot exit without pressing a button |
| onClose | `function(keyPressed?)` | Called on ESC/Backspace exit |
| onSelected | `function(selected, secondary, args)` | Called when selection changes |
| onSideScroll | `function(selected, scrollIndex, args)` | Called when scroll list changes |
| onCheck | `function(selected, checked, args)` | Called when checkbox toggles |

### Option Parameters

| Field | Type | Description |
|-------|------|-------------|
| label | `string` | Button text |
| progress | `number` | Progress bar percentage |
| colorScheme | `string` | Progress bar color |
| icon | `string` | FontAwesome icon (or image URL) |
| iconColor | `string` | Icon color |
| iconAnimation | `string` | Animation type |
| values | `string[]` or `{label, description}[]` | Side-scrollable list |
| checked | `boolean` | Makes button a checkbox |
| description | `string` | Tooltip text |
| defaultIndex | `number` | Default scroll list index |
| args | `table` | Arguments passed to callbacks |
| close | `boolean` | If `false`, menu stays open on click |

### Callback

```lua
function(selected, scrollIndex, args)
    -- selected: button index
    -- scrollIndex: current scroll position (if values provided)
    -- args: option args table
end
```

## Menu Control Functions

```lua
-- Show a registered menu
lib.showMenu(id)

-- Hide the current menu
lib.hideMenu(onExit)  -- onExit: boolean, runs onClose if true

-- Get the currently open menu id
local id = lib.getOpenMenu()

-- Update options for a registered menu
lib.setMenuOptions(id, options, index)  -- index: optional, specific option to replace
```

## Example

```lua
lib.registerMenu({
    id = 'job_menu',
    title = 'Job Actions',
    position = 'top-right',
    onClose = function(keyPressed)
        print('Menu closed')
    end,
    options = {
        {label = 'Clock In', icon = 'clock'},
        {label = 'View Roster', icon = 'users', values = {'Today', 'Week', 'Month'}},
        {label = 'Settings', checked = true, description = 'Toggle notifications'},
    }
}, function(selected, scrollIndex, args)
    print('Selected:', selected)
end)

RegisterCommand('jobmenu', function()
    lib.showMenu('job_menu')
end)
```

## Best Practices

- Register static menus once at resource start, not repeatedly
- Use `lib.setMenuOptions` to update dynamic content instead of re-registering
- Set `canClose = false` only for critical flows where the user must make a choice
