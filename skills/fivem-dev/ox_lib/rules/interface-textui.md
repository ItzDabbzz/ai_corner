# Text UI (lib.showTextUI / lib.hideTextUI)

Use this rule when displaying persistent on-screen text prompts with ox_lib.

## lib.showTextUI

Displays a text prompt on screen, typically for interaction hints.

```lua
lib.showTextUI(text, options)
```

### Parameters

| Field | Type | Description |
|-------|------|-------------|
| text | `string` | The text to display (supports markdown) |
| options | `table` | Optional display settings |

### Options

| Field | Type | Description |
|-------|------|-------------|
| position | `string` | `'top-center'`, `'top-left'`, `'top-right'`, `'left-center'`, `'right-center'`, `'bottom-center'`, `'bottom-left'`, `'bottom-right'` (default: `'right-center'`) |
| icon | `string` | FontAwesome icon |
| iconColor | `string` | Icon color |
| iconAnimation | `string` | Animation type |
| style | `table` | React CSS styling |

## lib.hideTextUI

Hides the currently displayed text UI.

```lua
lib.hideTextUI()
```

## Example

```lua
-- Show interaction prompt
lib.showTextUI('[E] - Open Door', {
    position = 'right-center',
    icon = 'door-open'
})

-- Hide when no longer near
lib.hideTextUI()
```

## Common Pattern: Proximity-Based TextUI

```lua
local showing = false

CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(cache.ped)
        local dist = #(playerCoords - doorCoords)

        if dist < 2.0 then
            sleep = 0
            if not showing then
                showing = true
                lib.showTextUI('[E] - Open Door', {
                    position = 'right-center',
                    icon = 'door-open'
                })
            end

            if IsControlJustReleased(0, 38) then -- E key
                OpenDoor()
            end
        else
            if showing then
                showing = false
                lib.hideTextUI()
            end
        end

        Wait(sleep)
    end
end)
```

## Best Practices

- Always pair `showTextUI` with a corresponding `hideTextUI`
- Use a state flag to avoid calling `showTextUI` every frame
- Keep text concise — this is an interaction hint, not a paragraph
- Use consistent keybinds across your resource (E for interact, H for holster, etc.)
