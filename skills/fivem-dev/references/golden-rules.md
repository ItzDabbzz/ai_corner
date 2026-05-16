# Golden Rules for FiveM Development

These rules apply to **all** FiveM code—frameworks, NUI, resources, everything.

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
