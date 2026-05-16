---
name: fivem-nui
description: FiveM NUI development for creating HTML/CSS/JS graphical interfaces. Covers setup, fullscreen UIs, callbacks, messaging, and focus management. Use when building or debugging in-game UI elements.
license: MIT
compatibility: FiveM framework for GTA V
metadata:
  version: "1.0.0"
  author: ItzDabbzz
  hermes:
    tags: [fivem, nui, html, css, javascript, ui]
    related_skills: [fivem-dev]
---

# FiveM NUI Development

HTML/CSS/JS UI development in FiveM with callbacks, messaging, and focus management.

## When to use

- User asks how to create a UI for FiveM.
- Creating or editing HTML/CSS/JS files for FiveM resources.
- Setting up `ui_page` in fxmanifest.lua.
- Questions about NUI callbacks, SendNUIMessage, or SetNUIFocus.
- Need to look up natives → point to https://docs.fivem.net/natives/.

## How to use

Read individual rule files for detailed explanations and examples:

- **rules/setup.md** — Setting up NUI in a resource: ui_page, files entry, folder structure.
- **rules/fullscreen-nui.md** — Creating fullscreen NUI pages: SEND_NUI_MESSAGE, SET_NUI_FOCUS, developer tools, referencing assets.
- **rules/nui-callbacks.md** — NUI callbacks: RegisterNUICallback, fetch requests, data handling, security.
- **rules/best-practices.md** — Best practices: performance, security, communication patterns, error handling.
- **rules/reference-links.md** — Official docs and natives reference.
