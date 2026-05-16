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

## Sub-Skills

This skill delegates deep work to 9 focused sub-skills. See [Sub-Skills Reference](references/subskills.md) for the complete directory and workflow.

## Golden Rules

All FiveM code must follow these core principles (see [Golden Rules](references/golden-rules.md) for details):

1. **Never trust the client** — All state changes validated server-side
2. **Server authority** — Server dictates truth, client requests only
3. **Validate parameters** — Check all client event arguments
4. **Distance checks** — Verify proximity server-side before interactions
5. **Rate limit** — Cooldown critical events to prevent spam

Plus 5 more in the full reference.

## Resources

- [Sub-Skills Directory](references/subskills.md)
- [Golden Rules](references/golden-rules.md)
- [Quick Reference Links](references/reference-links.md)
- [Common Pitfalls](references/common-pitfalls.md)
- [Verification Checklist](references/verification-checklist.md)

