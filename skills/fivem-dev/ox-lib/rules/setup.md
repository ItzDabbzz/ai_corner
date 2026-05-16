# ox_lib Setup and Import

Use this rule when configuring a resource to use ox_lib, or when troubleshooting import issues.

## fxmanifest.lua Import

Add `@ox_lib/init.lua` as a shared script. This must come before any script that uses `lib`.

```lua
shared_scripts {
    '@ox_lib/init.lua',
}
```

If ox_lib is the only shared script:

```lua
shared_script '@ox_lib/init.lua'
```

## Eager Loading with ox_libs

Declare modules in `fxmanifest.lua` to load them automatically at resource start:

```lua
ox_libs {
    'locale',
    'table',
    'math',
}
```

Available modules include: `locale`, `table`, `math`, `string`, `callback`, `cache`, `points`, `zones`, `require`, `version`, `waitFor`, `print`, `class`, `cron`, `grid`, `selector`, `timer`, `array`, `stream`, `raycast`, `scaleform`, `marker`, `playAnim`, `disableControls`, `vehicleProperties`, `getClosestObject`, `getClosestPed`, `getClosestPlayer`, `getClosestVehicle`, `getNearbyObjects`, `getNearbyPeds`, `getNearbyPlayers`, `getNearbyVehicles`, `getFilesInDirectory`, `dui`, `streaming`, `interface`.

## Globals Provided

After importing ox_lib, these globals become available:

- `lib` — Dynamically import ox_lib modules on demand
- `require` — Import modules from your own script
- `cache` — Cached values (see cache.md)

## JavaScript/TypeScript

Install the npm package for JS/TS resources:

```bash
npm install @overextended/ox_lib
```

Import scoped to client or server:

```ts
import lib from '@overextended/ox_lib/client';
import { notify } from '@overextended/ox_lib/client';
```

Note: The npm package does not support all Lua functions. Check the `resource` folder in the package for available functions.

## Convars

Configure ox_lib UI theming via convars in `server.cfg`:

```bash
setr ox:primaryColor blue
setr ox:primaryShade 8
setr ox:userLocales 1        # Allow /ox_lib locale command
setr ox:progressPropLimit 2  # Max props for progressbar
```

Ace permissions (required):

```bash
add_ace resource.ox_lib command.add_ace allow
add_ace resource.ox_lib command.remove_ace allow
add_ace resource.ox_lib command.add_principal allow
add_ace resource.ox_lib command.remove_principal allow
```

## Building the UI (for development)

If editing ox_lib's built-in UI elements:

```bash
cd ox_lib/web
bun i
bun run build
```

For in-browser development with hot reload:

```bash
bun start
```

For in-game development (writes to disk, restart resource to see changes):

```bash
bun start:game
```

## Icons

ox_lib uses Font Awesome 6.0. Pass a string for solid icons, or a table for other types:

```lua
-- Solid icon (default)
icon = 'ban'

-- Brand icon
icon = {'fab', 'apple'}
```
