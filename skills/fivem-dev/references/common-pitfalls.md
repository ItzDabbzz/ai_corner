# Common Pitfalls in FiveM Development

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
