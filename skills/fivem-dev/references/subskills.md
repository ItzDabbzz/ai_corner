# FiveM Development Sub-Skills

## Directory

| Sub-skill | Path | Covers |
| --- | --- | --- |
| **fivem-basics** | `fivem-basics/` | Resource structure, fxmanifest, client/server split, events, exports, debugging, optimization |
| **lua-basics** | `lua-basics/` | Lua functions, tables, variables, conditionals, error handling, performance |
| **fivem-nui** | `fivem-nui/` | NUI setup, fullscreen UIs, callbacks, SendNUIMessage, SetNUIFocus |
| **fivem-security** | `fivem-security/` | Server authority, event validation, distance checks, rate limiting, anti-exploit |
| **fivemanage** | `fivemanage/` | SDK install, screenshots (takeImage, takeServerImage), logs (Log/Info/Warn/Error) |
| **esx-framework** | `esx-framework/` | ESX Legacy: xPlayer, PlayerData, jobs, economy, inventory, weapons, callbacks |
| **qbcore-framework** | `qbcore-framework/` | QBCore: Player object, PlayerData, jobs, gangs, economy, inventory, callbacks |
| **ox_lib** | `ox-lib/` | Overextended ox_lib: UI elements (notify, menu, context, input, progress, radial, textUI, skillcheck), callbacks, cache, zones, points, keybinds, utilities, oxmysql |
| **ox_resources** | `ox-resources/` | Overextended resources: ox_inventory (exports, items, shops, stashes), ox_target (targeting system), ox_doorlock (door locking) |

## Workflow

1. **Identify the layer** — Is this about resource structure, Lua syntax, UI, security, SDK integration, or framework code?
2. **Load the matching sub-skill** — Use the table above.
3. **Follow the sub-skill's rule files** — Each sub-skill has a `rules/` directory with focused topics.
4. **Cross-reference** — Security rules apply to ALL sub-skills. Framework-specific code still needs event validation and server authority.
