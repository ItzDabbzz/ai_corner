---
name: mini-shai-hulud-defense
description: >
  Protect JavaScript/TypeScript projects from mini shai-hulud (supply-chain) attacks
  by enforcing minimum package release ages, pinning exact dependency versions, and
  locking the resolved tree. Covers npm, pnpm, yarn, and bun.
  Use when setting up a new JS/TS project, onboarding a repo, hardening CI,
  hardening a developer machine, or when the user asks about supply-chain security,
  dependency safety, or "shai-hulud" / "package age" protection.
metadata:
  author: ItzDabbzz
  version: "1.0"
  license: MIT
---

# mini-shai-hulud-defense

Enforce minimum release-age gates on all package managers. Prevents freshly-published malicious packages from entering the dependency tree.

## Overview

The "mini shai-hulud" attack vector: an attacker publishes a malicious package (or a compromised update to an existing one) and relies on automated installs pulling it in before it is detected and removed. Setting a **minimum release age** ensures no package younger than N days can be installed, giving the ecosystem time to flag and yank bad releases.

This skill configures that protection for **npm**, **pnpm**, **yarn**, and **bun**.

Default: **7 days** (168 hours / 10080 minutes / 604800 seconds).

## When to Use

- Bootstrapping a new JS/TS repository
- Onboarding / hardening an existing repo
- Setting up CI/CD pipelines that install dependencies
- User asks about supply-chain security, dependency hardening, or "shai-hulud"
- Auditing whether current projects have age-gates enabled

## Quick Reference

| PM     | Config target | Key / Flag | 7-day value | Scope |
|--------|---------------|------------|-------------|-------|
| npm    | `.npmrc`      | `min-release-age` | `7` | days |
| pnpm   | `.npmrc`      | `minimumReleaseAge` | `10080` | minutes |
| yarn   | `.yarnrc.yml` | `npmMinimalAgeGate` | `"168h"` | duration string |
| bun    | `bunfig.toml` | `install.minimumReleaseAge` | `604800` | seconds |

## Per-Manager Setup

### NPM

```bash
npm config set min-release-age=7
```

Or in `.npmrc`:

```ini
min-release-age=7
ignore-scripts=true
```

Docs: https://docs.npmjs.com/cli/v11/using-npm/config#min-release-age

### pnpm

```bash
pnpm config set minimumReleaseAge 10080
```

Or in `.npmrc`:

```ini
minimumReleaseAge=10080
```

Docs: https://pnpm.io/settings#minimumreleaseage

### Yarn

```bash
yarn config set npmMinimalAgeGate "168h"
```

Or in `.yarnrc.yml`:

```yaml
npmMinimalAgeGate: "168h"
```

Docs: https://yarnpkg.com/configuration/yarnrc#npmMinimalAgeGate

### Bun

In `bunfig.toml` (project root or `$HOME/.bunfig.toml` for global):

```toml
[install]
minimumReleaseAge = 604800
```

Docs: https://bun.com/docs/runtime/bunfig#install-minimumreleaseage

## One-Shot: Harden a Repo

1. Detect which PM is in use:
   ```bash
   ls bunfig.toml package-lock.json pnpm-lock.yaml yarn.lock 2>/dev/null
   ```
2. Apply the matching config from the table above.
3. Verify: attempt to install a package published within the gate window — it should fail or warn.

## CI/CD Hardening

Ensure CI runners also respect the gate:

- **GitHub Actions**: set the config step before `npm|pnpm|yarn|bun install`.
- **Docker builds**: copy `.npmrc` / `.yarnrc.yml` / `bunfig.toml` into the image before install.
- **Global fallback**: set user-level config on the runner (`npm config set ...`, etc.) so all jobs inherit it.

## Common Pitfalls

1. **Wrong units.** npm = days, pnpm = minutes, yarn = duration string, bun = seconds. Double-check the value matches the unit.
2. **Local-only config.** A `.npmrc` in the project root is safest; per-user config won't protect teammates or CI.
3. **Yarn version mismatch.** `npmMinimalAgeGate` requires Yarn 4+. On Yarn 1/2/3, use alternative mitigations (e.g., `--frozen-lockfile`, audit tools).
4. **Bun global vs project.** `bunfig.toml` in `$HOME` applies globally; in project root applies per-project. Both are valid — pick intentionally.
5. **Forgetting lockfiles.** Age gates block fresh installs but a compromised version can still lurk in an old lockfile. Combine with `npm audit`, `pnpm audit`, or `yarn npm audit`.
6. **Zero-day legitimate need.** Sometimes you genuinely need a package released today. Use `--force` or temporarily lower the gate, install, verify the package, then restore the gate.

## Full Machine + Repo Hardening (4 Steps)

Run this when onboarding a new machine or hardening an existing project.

### Step 1 — Global `.npmrc`

Edit `~/.npmrc`. Keep every existing line (auth tokens, registries, etc). Append:

```ini
min-release-age=7
minimum-release-age=10080
save-exact=true
ignore-scripts=true
```

- `min-release-age=7` — npm's native gate (days)
- `minimum-release-age=10080` — pnpm's gate (minutes) when falling back through npm config
- `save-exact=true` — future `npm install` commands pin exact versions instead of `^`/`~`

### Step 2 — Global `~/.bunfig.toml`

Create or edit `~/.bunfig.toml`. Keep existing content. Append:

```toml
[install]
minimumReleaseAge = 604800
```

### Step 3 — Pin All Existing Dependencies

Open the project's `package.json`. Strip `^` and `~` from **every** version under:

- `dependencies`
- `devDependencies`
- `peerDependencies` (if present)

Before:
```json
"dependencies": {
  "react": "^18.2.0",
  "lodash": "~4.17.21"
}
```

After:
```json
"dependencies": {
  "react": "18.2.0",
  "lodash": "4.17.21"
}
```

Exact versions only. No ranges.

### Step 4 — Lock and Commit

1. Re-install to update the lockfile with the now-exact versions:
   ```bash
   bun install   # or npm install / pnpm install / yarn install
   ```
2. Commit the lockfile:
   ```bash
   git add bun.lock package.json   # or package-lock.json / pnpm-lock.yaml / yarn.lock
   git commit -m "chore(security): pin deps + lock tree for supply-chain hardening"
   ```

### Report

After the 4 steps, report:
- Files changed
- Dependencies pinned (count)
- Anything unexpected (unresolvable ranges, peer-dep conflicts, etc.)

## Verification Checklist

- [ ] `~/.npmrc` has `min-release-age=7`, `minimum-release-age=10080`, `save-exact=true`
- [ ] `~/.bunfig.toml` has `[install] minimumReleaseAge = 604800`
- [ ] `package.json` has zero `^` or `~` prefixes in all dependency blocks
- [ ] Lockfile is committed and matches the exact versions in `package.json`
- [ ] CI pipeline applies the same config before install
- [ ] Team docs mention the gate and how to bypass for legitimate zero-day needs
