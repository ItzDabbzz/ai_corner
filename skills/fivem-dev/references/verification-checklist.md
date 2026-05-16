# FiveM Resource Verification Checklist

Use this checklist when reviewing or debugging FiveM resources.

- [ ] `fxmanifest.lua` present with correct `fx_version`, `game`, and scoped scripts
- [ ] Client/server separation clear — no server logic in client files
- [ ] All net events use `RegisterNetEvent` with server-side validation
- [ ] Player objects checked for nil before use
- [ ] Distance checks on server for all interactions
- [ ] No global variable leaks — all locals explicitly declared
- [ ] NUI has `SetNuiFocus` + `SendNUIMessage` patterns correct
- [ ] Framework-specific code uses official APIs (ESX/QBCore)
- [ ] Security rules from fivem-security applied to all event handlers
- [ ] ox_lib imported in `fxmanifest.lua` when using ox_lib features
- [ ] oxmysql imported in `fxmanifest.lua` when using database functions
