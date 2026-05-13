# ox_inventory

Use this rule when working with ox_inventory exports, configuration, and integration patterns.

ox_inventory is a slot-based inventory system with item metadata support, replacing framework-native inventories.

## Dependencies

- oxmysql
- ox_lib
- Optional: ox_target (for shops, stashes, etc.)

## Resource Start Order

```bash
start oxmysql
start ox_lib
start framework      # es_extended, qbx_core, etc.
start ox_target      # optional
start ox_inventory
```

## Client Exports

### openInventory

```lua
exports.ox_inventory:openInventory(invType, data)
```

| invType | data | Description |
|---------|------|-------------|
| `'player'` | `playerId` | Open another player's inventory |
| `'shop'` | `{type, id}` | Open a shop by type and location index |
| `'stash'` | `stashId` or `{id, owner}` | Open a stash |
| `'crafting'` | `{id, index}` | Open a crafting location |
| `'container'` | `containerId` | Open a container |
| `'drop'` | `dropId` | Open a ground drop |
| `'glovebox'` | `{netid}` | Open vehicle glovebox |
| `'trunk'` | `{netid}` | Open vehicle trunk |
| `'dumpster'` | `dumpsterId` | Open a dumpster |
| `'policeevidence'` | `lockerNumber` | Open police evidence |

Examples:

```lua
-- Open shop
exports.ox_inventory:openInventory('shop', {type = 'General', id = 4})

-- Open stash
exports.ox_inventory:openInventory('stash', 1)
exports.ox_inventory:openInventory('stash', {id = 'police_locker', owner = 'license:xxx'})

-- Open vehicle trunk
local netid = NetworkGetNetworkIdFromEntity(cache.vehicle)
exports.ox_inventory:openInventory('trunk', {netid = netid})
```

### useItem

```lua
exports.ox_inventory:useItem(slot, cb)
```

### getCurrentWeapon

```lua
local weapon = exports.ox_inventory:getCurrentWeapon()
-- Returns: {name, slot, metadata, label, count, components, ammo}
```

### Items

```lua
local items = exports.ox_inventory:Items(itemName)
-- Returns all registered items, or specific item data
```

## Server Exports

### setPlayerInventory

```lua
exports.ox_inventory:setPlayerInventory(player, data)
```

Creates/sets a player's inventory. Called by framework bridges.

### AddItem

```lua
exports.ox_inventory:AddItem(inv, item, count, metadata, slot, cb)
```

| Field | Type | Description |
|-------|------|-------------|
| inv | `string` or `number` | Inventory id or player source |
| item | `string` | Item name |
| count | `number` | Amount to add |
| metadata | `table` | Item metadata (optional) |
| slot | `number` | Specific slot (optional) |
| cb | `function` | Callback with success/fail reason |

```lua
exports.ox_inventory:AddItem(source, 'water', 5)
exports.ox_inventory:AddItem(source, 'phone', 1, {number = '555-1234'})
```

### RemoveItem

```lua
exports.ox_inventory:RemoveItem(inv, item, count, metadata, slot)
```

### GetItem

```lua
local item = exports.ox_inventory:GetItem(inv, item, metadata, returnCount)
-- Returns item data or count
```

### GetItemCount

```lua
local count = exports.ox_inventory:GetItemCount(inv, item, metadata, strict)
```

### Search

```lua
local results = exports.ox_inventory:Search(inv, search, item, metadata)
```

| search | Description |
|--------|-------------|
| `1` | Return all slots containing the item |
| `2` | Return total count of the item |
| `3` | Return first slot containing the item |
| `'slots'` | Same as `1` |
| `'count'` | Same as `2` |
| `'metadata'` | Return metadata matching items |

### CanCarryItem

```lua
local canCarry = exports.ox_inventory:CanCarryItem(inv, item, count)
```

### RegisterStash

```lua
exports.ox_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
```

```lua
exports.ox_inventory:RegisterStash('police_locker', 'Police Locker', 50, 100000, false, {['police'] = 0})
```

### forceOpenInventory

```lua
exports.ox_inventory:forceOpenInventory(playerId, invType, data)
```

Opens an inventory bypassing normal security checks. Useful for admin commands.

## Item Configuration

Items are defined in `data/items.lua`:

```lua
return {
    ['water'] = {
        label = 'Water',
        weight = 500,
        stack = true,
        close = true,
        description = 'Refreshing bottled water',
        client = {
            status = {thirst = 200000},
            anim = {dict = 'mp_player_intdrink', clip = 'loop_bottle'},
            prop = {model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5)},
            usetime = 5000,
            cancel = true,
            disable = {move = true, car = true, combat = true},
        }
    },
    ['phone'] = {
        label = 'Phone',
        weight = 190,
        stack = false,
        close = true,
        description = 'A smartphone',
        client = {
            export = 'my_phone_resource.usePhone'
        }
    },
}
```

### Item Properties

| Property | Type | Description |
|----------|------|-------------|
| label | `string` | Display name |
| weight | `number` | Weight in grams |
| stack | `boolean` | Can stack multiple |
| close | `boolean` | Close inventory on use |
| description | `string` | Tooltip text |
| allowArmed | `boolean` | Can use while armed |
| consume | `number` | Amount consumed on use (0 = no consume) |
| server | `table` | Server-side config (export, validate) |
| client | `table` | Client-side config (anim, prop, export) |

## Shops

Shops are defined in `data/shops.lua`:

```lua
return {
    General = {
        name = '24/7 Supermarket',
        inventory = {
            {name = 'water', price = 10},
            {name = 'bread', price = 15},
        },
        locations = {
            vec3(24.5, -1346.8, 29.5),
            vec3(-47.6, -1757.2, 29.4),
        },
        targets = {
            {loc = vec3(24.5, -1346.8, 29.5), length = 0.6, width = 0.6},
        },
    },
}
```

## Stashes

Stashes are defined in `data/stashes.lua`:

```lua
return {
    {
        id = 'policelocker',
        label = 'Police Locker',
        slots = 50,
        weight = 100000,
        groups = {['police'] = 0},
        coords = vec3(451.7, -992.2, 30.7),
    },
}
```

## Crafting

Crafting locations are defined in `data/crafting.lua`:

```lua
return {
    ['weaponsmith'] = {
        items = {
            {
                name = 'weapon_pistol',
                ingredients = {
                    steel = 5,
                    plastic = 2,
                },
                duration = 10000,
                count = 1,
            },
        },
        locations = {
            vec3(123.4, -567.8, 29.5),
        },
    },
}
```

## Convars

### Shared

```bash
setr inventory:framework "esx"        # Framework: ox, esx, qbx, nd
setr inventory:slots 50               # Player inventory slots
setr inventory:weight 30000           # Max carry weight (grams)
setr inventory:target false           # Enable ox_target integration
setr inventory:police ["police"]      # Police job names
```

### Client

```bash
setr inventory:imagepath "nui://ox_inventory/web/images"
setr inventory:autoreload false
setr inventory:screenblur true
setr inventory:keys ["F2", "K", "TAB"]
setr inventory:weaponanims true
setr inventory:dropprops true
```

### Server

```bash
set inventory:versioncheck true
set inventory:clearstashes "6 MONTH"
set inventory:loglevel 1
set inventory:randomprices true
set inventory:randomloot true
```

## Best Practices

1. **Use metadata for unique items** — Serial numbers, phone numbers, owner info
2. **Register stashes server-side** — Don't rely on data files for dynamic stashes
3. **Validate item use server-side** — Use `server.export` or `server.validate`
4. **Set reasonable weights** — Total player weight should be achievable but limiting
5. **Use `close = true` for consumables** — Closes inventory so the player sees the effect
6. **Configure `consume` properly** — `0` for reusable items, `1` for single-use
