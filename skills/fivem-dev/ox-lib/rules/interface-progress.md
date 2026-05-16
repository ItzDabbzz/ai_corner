# Progress Bars (lib.progressBar / lib.progressCircle)

Use this rule when creating progress bars or circles with animations, props, and cancellation.

## lib.progressBar

Displays a horizontal progress bar.

```lua
local success = lib.progressBar(data)
```

Returns `true` if completed, `false` if cancelled.

## lib.progressCircle

Displays a circular progress indicator.

```lua
local success = lib.progressCircle(data)
```

## Common Parameters

| Field | Type | Description |
|-------|------|-------------|
| duration | `number` | Duration in milliseconds |
| label | `string` | Text displayed on the progress |
| useWhileDead | `boolean` | Allow while player is dead |
| allowRagdoll | `boolean` | Allow while ragdolled |
| allowSwimming | `boolean` | Allow while swimming |
| allowCuffed | `boolean` | Allow while cuffed |
| allowFalling | `boolean` | Allow while falling |
| canCancel | `boolean` | Allow cancellation |
| anim | `table` | Animation/scenario config |
| prop | `table` or `table[]` | Prop model config |
| disable | `table` | Disable movement, car, combat, mouse, sprint |

### Animation Config

```lua
anim = {
    dict = 'mp_player_intdrink',  -- Required if no scenario
    clip = 'loop_bottle',         -- Required
    flag = 49,                    -- Default: 49
    blendIn = 3.0,                -- Default: 3.0
    blendOut = 1.0,               -- Default: 1.0
    duration = -1,                -- Default: -1
    playbackRate = 0,             -- Default: 0
    lockX = false,
    lockY = false,
    lockZ = false,
    scenario = 'WORLD_HUMAN_SMOKING',  -- Alternative to dict/clip
    playEnter = true,             -- Default: true
}
```

### Prop Config

```lua
prop = {
    model = `prop_ld_flow_bottle`,
    bone = 60309,                 -- Default: 60309
    pos = vec3(0.03, 0.03, 0.02),
    rot = vec3(0.0, 0.0, -1.5),
    rotOrder = 0,                 -- Default: 0
}
```

Multiple props: pass an array of prop tables.

### Disable Config

```lua
disable = {
    move = true,
    car = true,
    combat = true,
    mouse = false,
    sprint = true,
}
```

## Circle-Specific Parameters

| Field | Type | Description |
|-------|------|-------------|
| position | `string` | `'middle'` (default) or `'bottom'` |

## Control Functions

```lua
-- Check if a progress bar is active
local active = lib.progressActive()

-- Cancel the current progress (if canCancel is true)
lib.cancelProgress()
```

## Examples

### Basic progress bar

```lua
if lib.progressBar({
    duration = 2000,
    label = 'Drinking water',
    useWhileDead = false,
    canCancel = true,
    disable = { car = true },
    anim = {
        dict = 'mp_player_intdrink',
        clip = 'loop_bottle'
    },
    prop = {
        model = `prop_ld_flow_bottle`,
        pos = vec3(0.03, 0.03, 0.02),
        rot = vec3(0.0, 0.0, -1.5)
    },
}) then
    print('Complete!')
else
    print('Cancelled!')
end
```

### Progress circle at bottom

```lua
if lib.progressCircle({
    duration = 3000,
    position = 'bottom',
    label = 'Repairing',
    canCancel = true,
    anim = {
        scenario = 'WORLD_HUMAN_WELDING'
    },
}) then
    print('Repair done')
end
```
