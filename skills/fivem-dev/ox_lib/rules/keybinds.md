# Keybinds (lib.addKeybind)

Use this rule when registering custom keybinds that appear in the FiveM settings menu.

`lib.addKeybind` wraps RegisterKeyMap with additional functionality: press/release detection, disable/enable, and state tracking.

## CKeybind Class

A keybind object with these properties:

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Command name (no whitespace) |
| description | `string` | Label in Settings -> Key Bindings -> FiveM |
| currentKey | `string` | Key the player has bound |
| disabled | `boolean` | Whether the keybind is disabled |
| isPressed | `boolean` | Current press state |
| hash | `number` | Internal game hash |
| defaultKey | `string` | Default key for new players |
| defaultMapper | `string` | Input mapper (default: `'keyboard'`) |
| secondaryKey | `string` | Optional secondary key |
| secondaryMapper | `string` | Optional secondary mapper |
| disable | `function(self, boolean)` | Enable/disable the keybind |
| isControlPressed | `function(self)` | Get current pressed state |
| onPressed | `function(self)` | Called on key press |
| onReleased | `function(self)` | Called on key release |

## lib.addKeybind

```lua
local keybind = lib.addKeybind(data)
```

| Field | Type | Description |
|-------|------|-------------|
| name | `string` | Command name (required, no spaces) |
| description | `string` | Display name in settings |
| defaultKey | `string` | Default key (default: `'None'`) |
| defaultMapper | `string` | Input mapper (default: `'keyboard'`) |
| secondaryKey | `string` | Secondary key |
| secondaryMapper | `string` | Secondary mapper |
| disabled | `boolean` | Start disabled |
| onPressed | `function(self)` | Press callback |
| onReleased | `function(self)` | Release callback |

## Examples

### Basic keybind

```lua
local keybind = lib.addKeybind({
    name = 'respects',
    description = 'Press F to pay respects',
    defaultKey = 'F',
    onPressed = function(self)
        print(('Pressed %s (%s)'):format(self.currentKey, self.name))
    end,
    onReleased = function(self)
        print(('Released %s (%s)'):format(self.currentKey, self.name))
    end
})
```

### Toggleable keybind

```lua
local handsUp = lib.addKeybind({
    name = 'handsup',
    description = 'Put hands up',
    defaultKey = 'X',
    onPressed = function(self)
        if not self.disabled then
            PlayAnim('missminuteman_1ig_2', 'handsup_base', 49)
        end
    end,
    onReleased = function(self)
        StopAnimTask(cache.ped, 'missminuteman_1ig_2', 'handsup_base', 1.0)
    end
})

-- Disable during cuffing
RegisterNetEvent('police:cuff', function()
    handsUp:disable(true)
end)

RegisterNetEvent('police:uncuff', function()
    handsUp:disable(false)
end)
```

### Checking press state

```lua
local sprintBind = lib.addKeybind({
    name = 'sprint_check',
    description = 'Sprint state tracker',
    defaultKey = 'LSHIFT',
    onPressed = function(self)
        print('Sprint pressed')
    end,
    onReleased = function(self)
        print('Sprint released')
    end
})

-- Elsewhere in code
if sprintBind:isControlPressed() then
    print('Player is holding sprint')
end
```

## Input Mapper IDs

Common mapper values for `defaultMapper`:

- `'keyboard'` — Keyboard keys
- `'mouse_button'` — Mouse buttons
- `'mouse_wheel'` — Mouse wheel
- `'pad_digitalbutton'` — Controller buttons
- `'pad_analogstick'` — Controller sticks

Full list: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/

## Best Practices

- Use descriptive `name` values — they become console commands
- Set sensible `defaultKey` values — don't conflict with common binds
- Always disable keybinds during cutscenes, menus, or when player is incapacitated
- Use `onReleased` for actions that should stop when the key is released
- Check `self.disabled` before executing action in callbacks
