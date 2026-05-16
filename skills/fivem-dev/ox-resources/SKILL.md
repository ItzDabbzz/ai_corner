---
name: ox-resources
description: Overextended resources for FiveM. Covers ox_inventory (slot-based inventory with metadata), ox_target (targeting/third-eye system), and ox_doorlock (door locking). Use when working with these Overextended resources, their exports, configuration, or framework integration.
license: MIT
compatibility: FiveM with Overextended resources (ox_inventory, ox_target, ox_doorlock)
metadata:
  hermes:
    tags: [fivem, ox_inventory, ox_target, ox_doorlock, overextended, inventory, targeting]
    related_skills: [fivem-dev, ox-lib]
---

# Overextended Resources

Guides for ox_inventory, ox_target, and ox_doorlock — the core Overextended ecosystem resources.

## When to use

- Working with ox_inventory exports (openInventory, addItem, removeItem, etc.)
- Setting up shops, stashes, crafting, or item metadata
- Creating targeting options with ox_target (addZone, addModel, addGlobalPed, etc.)
- Configuring door locks with ox_doorlock
- Integrating these resources with ESX or QBCore
- Troubleshooting inventory, targeting, or doorlock issues

## How to use

Read individual rule files for detailed explanations and examples:

- **rules/ox_inventory.md** — Inventory exports, item metadata, shops, stashes, crafting, vehicle storage
- **rules/ox_target.md** — Targeting system, zones, models, global options, framework integration
- **rules/ox_doorlock.md** — Door configuration, locks, access control, events
- **rules/reference-links.md** — Official documentation links

## Key principles

1. **Start resources in correct order** — oxmysql → ox_lib → framework → ox_target → ox_inventory → ox_doorlock
2. **Use exports, not events** — All three resources expose functionality through exports
3. **Validate server-side** — Never trust client inventory/targeting requests
4. **Use item metadata** — ox_inventory's strength is metadata-driven item uniqueness
5. **Configure via data files** — ox_inventory uses `data/*.lua` for items, shops, stashes, crafting
