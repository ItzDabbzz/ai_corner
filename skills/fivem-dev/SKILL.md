---
name: fivem-dev
description: Complete FiveM resource development guide. Covers resource structure, Lua scripting, NUI UI development, security hardening, ESX/QBCore frameworks, and ox_lib utilities. Use when developing, debugging, or reviewing any FiveM resource, script, interface, or framework code.
license: MIT
metadata:
  version: "1.0.0"
  author: ItzDabbzz
  hermes:
    tags: [fivem, gta5, lua, nui, esx, qbcore, gaming, security]
    related_skills: []
---

# FiveM Development

Complete guide for FiveM server/client resource development. Orchestrates 9 specialized sub-skills for deep domain knowledge.

## What It Covers

FiveM is a modification framework for GTA V enabling multiplayer servers with custom resources written in Lua, JavaScript, or C#. This skill covers the full development stack:

- **Resource Structure** — fxmanifest.lua, client/server separation, exports, events
- **Lua Programming** — Functions, tables, metatables, performance optimization
- **NUI Interfaces** — HTML/CSS/JS UI development in-game with callbacks
- **Security** — Server authority, event validation, anti-exploit patterns
- **Frameworks** — ESX Legacy and QBCore player data, jobs, inventory, economy
- **UI Tooling** — ox_lib notifications, menus, dialogs, progress bars
- **Utilities** — ox_inventory, ox_target, ox_doorlock, oxmysql, fivemanage SDK

## When to Use

- Creating or debugging a FiveM resource
- Writing fxmanifest.lua or resource configuration
- Debugging client (F8) or server console errors
- Building in-game UI (NUI)
- Hardening resources against exploits
- Working with ESX or QBCore player systems
- Using ox_lib or other Overextended resources

## Topic Areas

Load the relevant topic file when the user's task matches:

- **Resource structure, fxmanifest, client/server, events, exports** → Read `fivem-basics/SKILL.md` then `fivem-basics/rules/`
- **Lua syntax, tables, functions, metatables, performance** → Read `lua-basics/SKILL.md` then `lua-basics/rules/`
- **NUI setup, HTML/CSS/JS interfaces, callbacks** → Read `fivem-nui/SKILL.md` then `fivem-nui/rules/`
- **Security, anti-exploit, server authority, event validation** → Read `fivem-security/SKILL.md` then `fivem-security/rules/`
- **Fivemanage SDK, screenshots, logging** → Read `fivemanage/SKILL.md` then `fivemanage/rules/`
- **ESX player data, jobs, economy, inventory** → Read `esx-framework/SKILL.md` then `esx-framework/rules/`
- **QBCore player data, jobs, gangs, economy** → Read `qbcore-framework/SKILL.md` then `qbcore-framework/rules/`
- **ox_lib UI, callbacks, cache, zones** → Read `ox-lib/SKILL.md` then `ox-lib/rules/`
- **ox_inventory, ox_target, ox_doorlock** → Read `ox-resources/SKILL.md` then `ox-resources/rules/`

## Golden Rules

All FiveM code must follow these core principles (see [Golden Rules](references/golden-rules.md) for details):

1. **Never trust the client** — All state changes validated server-side
2. **Server authority** — Server dictates truth, client requests only
3. **Validate parameters** — Check all client event arguments
4. **Distance checks** — Verify proximity server-side before interactions
5. **Rate limit** — Cooldown critical events to prevent spam

Plus 5 more in the full reference.

## Resources

- [Golden Rules](references/golden-rules.md)
- [Quick Reference Links](references/reference-links.md)
- [Common Pitfalls](references/common-pitfalls.md)
- [Verification Checklist](references/verification-checklist.md)

