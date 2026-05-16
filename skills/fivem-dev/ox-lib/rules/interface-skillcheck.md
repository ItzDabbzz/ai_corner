# Skill Check (lib.skillCheck)

Use this rule when creating timing-based minigames with ox_lib.

## lib.skillCheck

Displays a skill check minigame where the player must press keys when the indicator is in the target zone.

```lua
local success = lib.skillCheck(difficulty, inputs)
```

### Parameters

| Field | Type | Description |
|-------|------|-------------|
| difficulty | `string` or `table` | Difficulty level(s) |
| inputs | `string[]` | Keys to press (default: `{'w', 'a', 's', 'd'}`) |

### Difficulty Levels

- `'easy'` — Large target zone
- `'medium'` — Medium target zone
- `'hard'` — Small target zone

Or pass a custom table of area sizes (0-1 scale):

```lua
{0.5, 0.3, 0.2}  -- Three stages with decreasing area sizes
```

## Example

```lua
-- Simple skill check
local success = lib.skillCheck('medium')
if success then
    print('Skill check passed!')
else
    print('Skill check failed!')
end

-- Multi-stage with custom keys
local success = lib.skillCheck({'easy', 'medium', 'hard'}, {'e', 'space', 'shift'})

-- Used in a progress bar context
if lib.progressBar({
    duration = 5000,
    label = 'Picking lock',
    canCancel = true,
    anim = {
        dict = 'mini@repair',
        clip = 'fixing_a_player'
    },
}) then
    local success = lib.skillCheck('hard')
    if success then
        UnlockDoor()
    end
end
```

## Best Practices

- Use skill checks for high-stakes actions (lockpicking, hacking, crafting rare items)
- Match difficulty to the action — don't make refueling a car require a hard check
- Always handle both success and failure cases
- Combine with progress bars for multi-step interactions
