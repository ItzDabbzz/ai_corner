# ox_lib (Overextended)

Modern FiveM library providing reusable modules, UI elements, and utility functions. Replaces legacy framework UI systems and simplifies common development patterns.

## When to use

- Writing code that imports or uses `lib` from ox_lib
- Building UI: notifications, menus, progress bars, input dialogs, context menus, radial menus, text UI
- Setting up callbacks between client and server
- Using cache, zones, points, or keybinds
- Working with locales, tables, math, or string utilities
- Integrating oxmysql for database operations
- Replacing ESX/QBCore native UI with modern ox_lib equivalents

## How to use

Read individual rule files for detailed explanations and examples:

- **rules/setup.md** — Importing ox_lib via `fxmanifest.lua`, `@ox_lib/init.lua`, `ox_libs` manifest entries, npm package
- **rules/interface-notify.md** — `lib.notify` with types, positions, icons, styling, sounds
- **rules/interface-progress.md** — `lib.progressBar`, `lib.progressCircle`, animations, props, cancellation
- **rules/interface-menu.md** — `lib.registerMenu`, `lib.showMenu`, keyboard navigation, dynamic options
- **rules/interface-context.md** — `lib.registerContext`, `lib.showContext`, nested menus, events, metadata
- **rules/interface-input.md** — `lib.inputDialog` with all field types (input, number, checkbox, select, slider, color, date, time, textarea)
- **rules/interface-radial.md** — `lib.registerRadial`, `lib.showRadial`, submenus
- **rules/interface-textui.md** — `lib.showTextUI`, `lib.hideTextUI`, positioning, styling
- **rules/interface-skillcheck.md** — `lib.skillCheck`, difficulty areas, callbacks
- **rules/callbacks.md** — `lib.callback`, `lib.callback.await`, `lib.callback.register` (client and server)
- **rules/cache.md** — `cache` table, `lib.onCache`, client defaults (ped, vehicle, weapon, coords)
- **rules/zones.md** — `lib.zones.poly`, `lib.zones.box`, `lib.zones.sphere`, onEnter/onExit/inside, debug
- **rules/points.md** — `lib.points.new`, distance checking, onEnter/onExit/nearby callbacks
- **rules/keybinds.md** — `lib.addKeybind`, RegisterKeyMap integration, onPressed/onReleased, disable
- **rules/utility.md** — Table, math, string utilities; `lib.print`, `lib.waitFor`, `lib.require`
- **rules/oxmysql.md** — MySQL.query, MySQL.insert, MySQL.update, MySQL.scalar, MySQL.prepare, MySQL.transaction, placeholders
- **rules/reference-links.md** — Official Overextended documentation links

## Key principles

1. **Always import ox_lib first** — Add `@ox_lib/init.lua` as a shared_script before any other script that uses `lib`
2. **Use `ox_libs` manifest for eager loading** — Declare modules like `'locale'`, `'table'`, `'math'` in `fxmanifest.lua`
3. **Prefer `lib.callback.await` over raw events** — Cleaner request/response pattern with automatic timeout handling
4. **Cache expensive lookups** — Use `cache.ped`, `cache.vehicle`, `cache.weapon` instead of calling natives repeatedly
5. **Use zones/points instead of polling loops** — Let ox_lib handle distance checks efficiently
6. **Replace legacy UI with ox_lib** — `lib.notify` replaces ESX.ShowNotification/QBCore.Notify, `lib.progressBar` replaces progress systems
7. **Validate inputs server-side** — Even when using `lib.inputDialog`, never trust client-submitted data
8. **Use named placeholders with oxmysql** — Prevents SQL injection and improves readability
