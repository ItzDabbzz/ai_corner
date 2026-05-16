# ox_doorlock

Use this rule when configuring door locks with ox_doorlock.

ox_doorlock manages locked doors with group/item access control, automatic locking, and sound effects.

## Dependencies

- oxmysql
- ox_lib

## Configuration

Door configuration is handled in `config.lua` or via the in-game UI (`/doorlock`).

### Basic Door Config

```lua
Config.DoorList = {
    -- Simple door
    {
        objName = 'v_ilev_ph_door01',
        objCoords = vec3(434.7, -982.0, 30.8),
        textCoords = vec3(434.7, -982.0, 30.8),
        authorizedJobs = { ['police'] = 0 },
        locked = true,
        maxDistance = 2.0,
        size = 2,
    },
    -- Double doors
    {
        objName = 'v_ilev_ph_gendoor004',
        objCoords = vec3(449.6, -986.4, 30.7),
        textCoords = vec3(449.6, -986.4, 30.7),
        authorizedJobs = { ['police'] = 0 },
        locked = true,
        maxDistance = 2.5,
        doors = {
            {objName = 'v_ilev_ph_gendoor004', objYaw = 90.0},
            {objName = 'v_ilev_ph_gendoor002', objYaw = -90.0},
        },
    },
}
```

### Door Properties

| Property | Type | Description |
|----------|------|-------------|
| objName | `string` or `hash` | Door object model name |
| objCoords | `vector3` | Door position |
| textCoords | `vector3` | Position of the interaction text |
| authorizedJobs | `table` | Job access `{['job'] = minGrade}` |
| authorizedGangs | `table` | Gang access `{['gang'] = minRank}` |
| authorizedItems | `table` | Item access `{'item_name'}` |
| authorizedCitizenIDs | `table` | Specific citizen IDs |
| locked | `boolean` | Start locked |
| maxDistance | `number` | Interaction distance |
| size | `number` | Door size for sliding detection |
| doors | `table` | For double doors, array of door objects |
| hideLabel | `boolean` | Hide the interaction label |
| lockpick | `boolean` | Allow lockpicking |
| audioRemote | `boolean` | Play sound remotely |
| autoLock | `number` | Auto-lock after N seconds |
| doorRate | `number` | Animation speed multiplier |
| pickable | `boolean` | Can be lockpicked |
| holdOpen | `boolean` | Stay open while player is near |
| showNUI | `boolean` | Show lock status UI |

## Server Events

### ox_doorlock:setState

Set a door's lock state.

```lua
TriggerEvent('ox_doorlock:setState', doorId, state, source)
```

| Field | Type | Description |
|-------|------|-------------|
| doorId | `number` | Door index in Config.DoorList |
| state | `boolean` | `true` = locked, `false` = unlocked |
| source | `number` | Player source (optional, for logging) |

### ox_doorlock:editDoorlock

Edit an existing door configuration.

## Server Functions

### GetDoor

```lua
local door = exports.ox_doorlock:GetDoor(doorId)
```

### GetAllDoors

```lua
local doors = exports.ox_doorlock:GetAllDoors()
```

### SetDoorState

```lua
exports.ox_doorlock:SetDoorState(doorId, state, source)
```

## Client Functions

### useClosestDoor

```lua
exports.ox_doorlock:useClosestDoor()
```

Triggers the closest door interaction.

## In-Game UI

Use `/doorlock` to open the door configuration UI:

- Add new doors by aiming at them
- Edit existing doors
- Set access permissions
- Configure auto-lock and other properties

Doors configured via UI are saved to the database.

## Examples

### Police department doors

```lua
Config.DoorList = {
    {
        objName = 'v_ilev_ph_door01',
        objCoords = vec3(434.7, -982.0, 30.8),
        textCoords = vec3(434.7, -982.0, 30.8),
        authorizedJobs = { ['police'] = 0, ['sheriff'] = 0 },
        locked = true,
        maxDistance = 2.0,
        autoLock = 300,  -- Auto-lock after 5 minutes
    },
    -- Evidence room (higher rank required)
    {
        objName = 'v_ilev_arm_secdoor',
        objCoords = vec3(459.5, -989.0, 24.9),
        textCoords = vec3(459.5, -989.0, 24.9),
        authorizedJobs = { ['police'] = 2 },  -- Rank 2+
        locked = true,
        maxDistance = 2.0,
    },
}
```

### Item-locked door

```lua
{
    objName = 'prop_gate_prison_01',
    objCoords = vec3(1844.9, 2604.8, 44.6),
    textCoords = vec3(1844.9, 2604.8, 44.6),
    authorizedItems = {'prison_key'},
    locked = true,
    maxDistance = 2.5,
    size = 5,
}
```

### Lockpickable door

```lua
{
    objName = 'v_ilev_fh_frontdoor',
    objCoords = vec3(7.5, 539.2, 176.0),
    textCoords = vec3(7.5, 539.2, 176.0),
    locked = true,
    maxDistance = 2.0,
    pickable = true,
}
```

## Best Practices

1. **Use the in-game UI for most configuration** — Easier than editing config.lua
2. **Set appropriate `maxDistance`** — Too large causes unintended interactions
3. **Use `autoLock` for security doors** — Prevents doors being left open
4. **Set minimum job grades** — Don't give everyone access to evidence/armory
5. **Test double doors carefully** — Ensure `objYaw` is correct for both doors
6. **Use `textCoords` for large doors** — Place interaction point where players expect it
