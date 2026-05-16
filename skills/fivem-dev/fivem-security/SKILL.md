# FiveM Security and Anti-Exploit Principles

Architectural guidance for securing FiveM resources against cheats, unauthorized events, and malicious data manipulation. Core principle: NEVER TRUST THE CLIENT. 

The client is in the hands of the user, which means it can be fully compromised. Every action that affects the game state, economy, or other players MUST be validated on the server.

## 📂 Core Concepts & Rules

Detailed rules are broken down into specific topics within the `rules/` directory:

- **[events.md](rules/events.md)**: How to properly structure and validate `RegisterNetEvent` / `TriggerServerEvent` to prevent unauthorized execution.

## ⚠️ The Golden Rules of FiveM Security

1. **Server Authority**: The server dictates the truth. The client only requests actions.
2. **Never Trust Parameters**: Always validate arguments sent from the client (e.g., if a client says "give me $50", the server must check if the client *earned* it, not just blindly accept the amount).
3. **Distance Checks**: Always check the distance on the server side before allowing an interaction (e.g., looting, selling, entering a zone).
4. **Rate Limiting**: Prevent event spamming by implementing server-side cooldowns or debouncing for critical actions.