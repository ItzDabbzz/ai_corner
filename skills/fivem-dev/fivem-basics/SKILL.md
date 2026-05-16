---
name: fivem-basics
description: FiveM resource structure, fxmanifest, client/server scripting, events, exports, and debugging. Use when creating or editing FiveM resources or Lua scripts, or when working with resource structure and communication patterns.
license: MIT
compatibility: FiveM framework for GTA V
metadata:
  version: "1.0.0"
  author: ItzDabbzz
  hermes:
    tags: [fivem, lua, fxmanifest, client-server, events, exports]
    related_skills: [fivem-dev]
---

# FiveM Basics

Resource structure, manifest configuration, client/server scripting, events, and exports.

## When to use

- User asks how FiveM resources or scripts work.
- Editing or creating `fxmanifest.lua`, `client_*.lua`, or `server.lua`.
- Questions about client/server, events, or exports.
- Need to look up natives or detailed docs → point to https://docs.fivem.net/natives/ and https://docs.fivem.net/docs/.

## How to use

Read individual rule files for detailed explanations and examples:

- **rules/structure.md** — Resource structure and organization: scope, client/server separation, logical grouping, naming conventions.
- **rules/fxmanifest.md** — Resource manifest (fxmanifest.lua): fx_version, game, client_scripts, server_script, files, dependencies, ox_lib integration.
- **rules/client-server.md** — Client vs server scripts, shared code, communication patterns.
- **rules/events.md** — Events in Lua: RegisterNetEvent, TriggerServerEvent, TriggerClientEvent, naming conventions, security.
- **rules/exports.md** — Defining and consuming exports between resources.
- **rules/debugging.md** — Server vs client (F8) logs; when to ask the user for F8 logs if there's no server-side error.
- **rules/optimization.md** — Lua/FiveM optimization: locals, loops, natives (PlayerPedId, vector distance), state bags, cache, zones, security, readability, folder structure.
- **rules/reference-links.md** — Official docs and natives reference.
