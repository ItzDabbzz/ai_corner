---
name: fivem-dev
description: >
  Master skill for FiveM development. Orchestrates 9 sub-skills covering
  FiveM fundamentals (fxmanifest, client/server, events, exports), Lua best practices,
  NUI (HTML/CSS/JS UI), security (server authority, event validation), Fivemanage SDK
  (screenshots, logs), ESX Framework, QBCore Framework, ox_lib (Overextended UI and utilities),
  and Overextended resources (ox_inventory, ox_target, ox_doorlock).
  Use when developing, reviewing, or debugging any FiveM resource, Lua script,
  NUI interface, or framework-specific code. Not for general non-FiveM tasks.
version: 1.0.0
author: ItzDabbzz
license: MIT
metadata:
  hermes:
    tags: [fivem, gta5, lua, nui, esx, qbcore, gaming, security]
    related_skills: []
---

# FiveM Development

Orchestrated guide for FiveM server/client resource development. Delegates to sub-skills for deep domain knowledge.

## Overview

FiveM is a modification framework for GTA V enabling multiplayer servers with custom resources written in Lua, JavaScript, or C#. This skill covers the full stack: resource structure, Lua patterns, UI development, security hardening, third-party SDKs, and the two dominant roleplay frameworks (ESX and QBCore).

## When to Use

- Creating or editing a FiveM resource (any `.lua`, `.js`, `.html` file in a FiveM context)
- Writing or reviewing `fxmanifest.lua`
- Debugging client (F8) or server console errors
- Building NUI interfaces (HTML/CSS/JS rendered in-game)
- Hardening resources against cheaters/exploiters
- Integrating Fivemanage (screenshots, logs)
- Working with ESX or QBCore player data, jobs, inventory, economy
- Using ox_lib for UI (notifications, menus, progress bars, input dialogs, etc.)
- Working with ox_inventory, ox_target, or ox_doorlock exports and configuration

## When NOT to Use

- General programming tasks unrelated to FiveM
- Non-GTA V multiplayer platforms (RedM, Alt:V, etc. — may overlap but not guaranteed)

## Sub-Skill Directory

| Sub-skill | Path | Covers |
|-----------|------|--------|
| **fivem-basics** | `fivem-basics/SKILL.md` | Resource structure, fxmanifest, client/server split, events, exports, debugging, optimization |
| **lua-basics** | `lua-basics/SKILL.md` | Lua functions, tables, variables, conditionals, error handling, performance |
| **fivem-nui** | `fivem-nui/SKILL.md` | NUI setup, fullscreen UIs, callbacks, SendNUIMessage, SetNUIFocus |
| **fivem-security** | `fivem-security/SKILL.md` | Server authority, event validation, distance checks, rate limiting, anti-exploit |
| **fivemanage** | `fivemanage/SKILL.md` | SDK install, screenshots (takeImage, takeServerImage), logs (Log/Info/Warn/Error) |
| **esx-framework** | `esx-framework/SKILL.md` | ESX Legacy: xPlayer, PlayerData, jobs, economy, inventory, weapons, callbacks |
| **qbcore-framework** | `qbcore-framework/SKILL.md` | QBCore: Player object, PlayerData, jobs, gangs, economy, inventory, callbacks |
| **ox_lib** | `ox_lib/SKILL.md` | Overextended ox_lib: UI elements (notify, menu, context, input, progress, radial, textUI, skillcheck), callbacks, cache, zones, points, keybinds, utilities, oxmysql |
| **ox_resources** | `ox_resources/SKILL.md` | Overextended resources: ox_inventory (exports, items, shops, stashes), ox_target (targeting system), ox_doorlock (door locking) |

## Workflow

1. **Identify the layer** — Is this about resource structure, Lua syntax, UI, security, SDK integration, or framework code?
2. **Load the matching sub-skill** — Use the table above.
3. **Follow the sub-skill's rule files** — Each sub-skill has a `rules/` directory with focused topics.
4. **Cross-reference** — Security rules apply to ALL sub-skills. Framework-specific code still needs event validation and server authority.

## Golden Rules (Apply Everywhere)

1. **NEVER TRUST THE CLIENT** — The client is compromised by definition. All state-changing actions must be validated server-side.
2. **Server Authority** — The server dictates truth. The client only requests.
3. **Validate Parameters** — Always check arguments from client events (money amounts, item IDs, positions).
4. **Distance Checks** — Verify player proximity server-side before interactions.
5. **Rate Limit** — Cooldown/debounce critical events to prevent spam.
6. **Check for nil** — `if xPlayer then ... end` / `if Player then ... end` before using framework player objects.
7. **Use Framework Patterns** — Don't reinvent callbacks, notifications, or player retrieval. Use `ESX.GetPlayerFromId` or `QBCore.Functions.GetPlayer`.
8. **Prefer ox_lib for UI** — Menus, dialogs, notifications, progress bars. Don't use legacy ESX/QBCore UI systems.
9. **Cache Natives** — `local playerPed = PlayerPedId()` in loops, not repeated native calls.
10. **Minimal Globals** — Keep variables `local` unless they genuinely need global scope.

## Quick Reference Links

- FiveM Natives: https://docs.fivem.net/natives/
- FiveM Docs: https://docs.fivem.net/docs/
- Cfx.re Forums: https://forum.cfx.re/
- Lua 5.4 Reference: https://www.lua.org/manual/5.4/
- ox_lib Docs: https://overextended.dev/ox_lib
- ox_inventory Docs: https://overextended.dev/ox_inventory
- ox_target Docs: https://overextended.dev/ox_target

## Common Pitfalls

1. **Missing fxmanifest.lua** — Every resource needs one. No exceptions.
2. **Wrong fx_version** — Use `cerulean` or newer. Old versions lack features.
3. **Client-side validation only** — Any check on the client can be bypassed. Duplicate on server.
4. **Forgetting `RegisterNetEvent`** — Server events without it are exploitable.
5. **Global variable pollution** — Accidentally creating globals causes conflicts between resources.
6. **Not using `local` for loops** — Repeated native calls in `while`/`for` tanks performance.
7. **NUI without `SetNuiFocus`** — UI renders but can't receive keyboard/mouse input.
8. **ESX vs QBCore mix-up** — They have similar concepts but different APIs. Confirm which framework the resource targets.
9. **Hardcoding framework calls** — Use abstraction layers when possible to support both ESX and QBCore.
10. **Ignoring F8 logs** — Client errors only appear in the in-game console (F8). Ask the user for them when debugging client issues.
11. **Not importing ox_lib** — Add `@ox_lib/init.lua` to shared_scripts when using ox_lib features.
12. **Using legacy UI systems** — Prefer ox_lib over ESX/QBCore native menus, notifications, and progress bars.

## Verification Checklist

- [ ] `fxmanifest.lua` present with correct `fx_version`, `game`, and scoped scripts
- [ ] Client/server separation clear — no server logic in client files
- [ ] All net events use `RegisterNetEvent` with server-side validation
- [ ] Player objects checked for nil before use
- [ ] Distance checks on server for all interactions
- [ ] No global variable leaks — all locals explicitly declared
- [ ] NUI has `SetNuiFocus` + `SendNUIMessage` patterns correct
- [ ] Framework-specific code uses official APIs (ESX/QBCore)
- [ ] Security rules from `fivem-security` applied to all event handlers
- [ ] ox_lib imported in `fxmanifest.lua` when using ox_lib features
- [ ] oxmysql imported in `fxmanifest.lua` when using database functions
