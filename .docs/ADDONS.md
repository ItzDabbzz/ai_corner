# Addons & Patching Guide

This repo uses a **vendor + addons** pattern to manage upstream files from git subtrees while keeping local modifications clean, trackable, and easy to update.

If you want to modify a vendored skill, agent, prompt, command, or MCP — this is the right way to do it.

---

## How it works

```
DABZAICorner/
├── vendor/          # upstream files via git subtree — do not edit directly
├── addons/          # your modifications: patches and full overrides
├── skills/          # ← built output (reseeded by build script)
├── agents/          # ← built output
├── commands/        # ← built output
├── prompts/         # ← built output
├── install.conf     # maps category folders to user system dirs
├── build.sh / build.ps1
└── install.sh / install.ps1
```

**Two step workflow:**

```
vendor/ + addons/
        │
        │  build
        ▼
skills/, agents/, commands/, prompts/, ...   (repo folders, rebuilt each time)
        │
        │  install
        ▼
~/.claude/skills, ~/.agents, ~/.codex/commands, ...  (user system dirs)
```

You never edit `vendor/` directly. You never manually edit the category folders either — they are build output and will be overwritten. All modifications live in `addons/`.

---

## Two ways to modify a vendored file

### 1. Patch file (preferred for small changes)

A `.patch` file records a targeted diff against the vendor original. It's the right choice when you're tweaking a few lines and want to stay in sync with upstream updates.

**File naming:** mirror the vendor path, add `.patch`

```
vendor/skills/caveman/SKILL.md
addons/skills/caveman/SKILL.md.patch   ← your patch
```

**Creating a patch:**

```sh
# Make your edits on a temporary copy
cp vendor/skills/caveman/SKILL.md /tmp/SKILL.md
# ...edit /tmp/SKILL.md...

# Generate the patch
diff -u vendor/skills/caveman/SKILL.md /tmp/SKILL.md > addons/skills/caveman/SKILL.md.patch
```

Or from a staged git diff:

```sh
git diff vendor/skills/caveman/SKILL.md > addons/skills/caveman/SKILL.md.patch
```

### 2. Full override (for larger rewrites)

Drop a plain file in `addons/` at the same relative path. It replaces the vendor version entirely.

```
vendor/skills/caveman/SKILL.md
addons/skills/caveman/SKILL.md    ← replaces the whole file
```

Use this when your changes are large enough that a patch would be noisy, or when you're adding a net-new file that doesn't exist in vendor.

---

## Build

Wipes and rebuilds each category folder from `vendor/`, then layers `addons/` on top.

```sh
# Linux / Arch
sh build.sh

# Windows
.\build.ps1
```

What it does per category:

1. Deletes `skills/` (or `agents/`, etc.) and reseeds it from `vendor/skills/`
2. Finds every `.patch` in `addons/skills/`, dry-runs it, then applies it
3. Copies any plain files from `addons/skills/` as full overrides

New categories are picked up automatically — if `addons/mcps/` exists but there's no `vendor/mcps/`, it still gets built.

Patch failures are printed with the file path but don't abort the build. Check for any `FAILED` lines before running install.

---

## Install

Copies the built category folders to your user system directories as configured in `install.conf`.

```sh
# Linux / Arch
sh install.sh

# Preview without writing anything
sh install.sh --dry-run

# Overwrite existing files
sh install.sh --force
```

```powershell
# Windows
.\install.ps1
.\install.ps1 -DryRun
.\install.ps1 -Force
```

---

## install.conf

Maps each category to a destination on your system. One rule per line.

```
# <category>/*    <destination>
skills/*           ~/.claude/skills
agents/*           ~/.agents
commands/*         ~/.codex/commands
prompts/*          ~/.claude/prompts
```

The `/*` on the source side is just convention to make it visually clear it's a folder. The install script strips it automatically.

Linux supports `~`, `$HOME`, `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`.
Windows supports `$env:USERPROFILE`, `$env:APPDATA`, `$env:LOCALAPPDATA`.

The included `install.conf` has both platforms with the Windows lines commented out — uncomment and adjust to match your setup.

---

## Keeping patches in sync after a vendor update

When you `git subtree pull` and the vendor file changes significantly, your patch may fail with a hunk mismatch. The build script will report it. To fix:

```sh
# 1. See what failed
patch --dry-run skills/caveman/SKILL.md < addons/skills/caveman/SKILL.md.patch

# 2. Re-apply your changes to the updated vendor file
cp vendor/skills/caveman/SKILL.md /tmp/SKILL.md
# ...re-apply your edits...

# 3. Regenerate the patch
diff -u vendor/skills/caveman/SKILL.md /tmp/SKILL.md > addons/skills/caveman/SKILL.md.patch
```

A good habit: always run `build.sh` and check the output after any `git subtree pull`, before running `install.sh`.

---

## Prerequisites

| Tool | Linux (Arch) | Windows |
|------|-------------|---------|
| `patch` | `sudo pacman -S patch` | `winget install GnuWin32.Patch` or `scoop install patch` |
| `sh` | built-in | Git Bash, WSL, or MSYS2 |
| PowerShell | — | v5.1+ (built-in on Win10+) |

---

## Quick reference

| Goal | What to do |
|------|-----------|
| Modify a few lines of a vendored file | Create a `.patch` in `addons/` |
| Replace a vendored file entirely | Drop a plain file in `addons/` at the same path |
| Add a new file with no vendor source | Drop it in `addons/` — it'll be built into the category folder |
| Rebuild category folders | `sh build.sh` or `.\build.ps1` |
| Deploy to user system dirs | `sh install.sh` or `.\install.ps1` |
| Preview install without writing | `--dry-run` / `-DryRun` |
| Fix a broken patch after vendor update | Re-apply edits manually, re-run `diff -u` |