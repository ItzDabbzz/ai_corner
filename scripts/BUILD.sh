#!/usr/bin/env sh
# BUILD.sh — builds skills/ from outsourced vendor repos
#
# Scans vendor/*/skills/ for skill folders and deploys them into skills/.
# Handles multi-skill repos (e.g. caveman/ has caveman, caveman-commit,
# caveman-help, caveman-review, caveman-stats, compress, cavecrew).
#
# Conflict resolution: later repos in sorted order override earlier ones.
# A .source file is written alongside each skill documenting its origin.
#
# addons/ can provide overrides (full-file replacements) and patches.
#
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENDOR_DIR="$SCRIPT_DIR/../vendor"
ADDONS_DIR="$SCRIPT_DIR/../addons"
SKILLS_DIR="$SCRIPT_DIR/../skills"

# ── Colours ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

info()    { printf "${GREEN}[build]${RESET}  %s\n" "$1"; }
section() { printf "\n${CYAN}── %s ──${RESET}\n" "$1"; }
warn()    { printf "${YELLOW}[warn]${RESET}   %s\n" "$1"; }
error()   { printf "${RED}[error]${RESET}  %s\n" "$1"; }
source_tag() { printf "${MAGENTA}[source]${RESET} %s\n" "$1"; }

# ── Preflight ──────────────────────────────────────────────────────────────────
if [ ! -d "$VENDOR_DIR" ]; then
  error "vendor/ not found."
  exit 1
fi

mkdir -p "$SKILLS_DIR"

# ── Discover vendor repos with skills/ subdirectories ──────────────────────────
repos=""
for repo_dir in "$VENDOR_DIR"/*/; do
  [ -d "$repo_dir" ] || continue
  repo_name="$(basename "$repo_dir")"
  skills_src="$repo_dir/skills"
  if [ -d "$skills_src" ]; then
    repos="$repos $repo_name"
  fi
done

if [ -z "$repos" ]; then
  warn "No vendor repos with skills/ found."
  info "Build complete (no skills to deploy)."
  exit 0
fi

# ── Collect all skill names across all repos (for dedup reporting) ─────────────
# We'll track: skill_name -> last_winning_repo
declare -A skill_source_map

# ── Process each repo in sorted order ──────────────────────────────────────────
for repo_name in $(printf '%s\n' $repos | sort); do
  section "vendor/$repo_name"
  repo_dir="$VENDOR_DIR/$repo_name"
  skills_src="$repo_dir/skills"

  # Discover skill folders inside vendor/<repo>/skills/
  for skill_dir in "$skills_src"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    target_dir="$SKILLS_DIR/$skill_name"
    source_file="$target_dir/.source"

    # Check for existing skill (conflict / override)
    if [ -d "$target_dir" ] && [ -f "$target_dir/SKILL.md" ]; then
      existing_source=""
      if [ -f "$source_file" ]; then
        existing_source="$(cat "$source_file")"
      fi
      if [ "$existing_source" = "$repo_name" ]; then
        info "  update: $skill_name (from $repo_name)"
      else
        warn "  override: $skill_name (was from ${existing_source:-unknown}, now $repo_name)"
      fi
    else
      info "  install: $skill_name (from $repo_name)"
    fi

    # Wipe and copy from vendor
    rm -rf "$target_dir"
    mkdir -p "$target_dir"
    cp -r "$skill_dir"/* "$target_dir/" 2>/dev/null || cp -r "$skill_dir"/. "$target_dir/"

    # Write provenance marker
    printf "%s\n" "$repo_name" > "$source_file"

    # Track in map
    skill_source_map["$skill_name"]="$repo_name"
  done

  # ── Apply addons/ overrides for this repo ──────────────────────────────────
  addons_repo="$ADDONS_DIR/$repo_name"
  if [ -d "$addons_repo" ]; then
    # Copy any extra skill folders from addons
    for addon_skill in "$addons_repo"/*/; do
      [ -d "$addon_skill" ] || continue
      skill_name="$(basename "$addon_skill")"
      target_dir="$SKILLS_DIR/$skill_name"
      rm -rf "$target_dir"
      mkdir -p "$target_dir"
      cp -r "$addon_skill"/* "$target_dir/" 2>/dev/null || cp -r "$addon_skill"/. "$target_dir/"
      printf "%s (addon)\n" "$repo_name" > "$target_dir/.source"
      skill_source_map["$skill_name"]="$repo_name (addon)"
      info "  addon: $skill_name (from $repo_name)"
    done

    # Apply patches to existing skills
    find "$addons_repo" -type f -name "*.patch" 2>/dev/null | sort | while read -r patch_file; do
      relative="${patch_file#"$addons_repo"/}"
      target="$SKILLS_DIR/${relative%.patch}"

      if [ ! -d "$target" ]; then
        warn "  patch target missing: $relative (skipping)"
        continue
      fi

      # Find the file to patch within the skill directory
      target_file="$target/${relative#*/}"
      if [ ! -f "$target_file" ]; then
        # Try matching the skill folder name
        skill_folder="$(basename "$(dirname "$relative")")"
        target_file="$SKILLS_DIR/$skill_folder/${relative#*/}"
      fi

      if [ ! -f "$target_file" ]; then
        warn "  patch file not found: $relative (skipping)"
        continue
      fi

      if patch --dry-run -s "$target_file" < "$patch_file" > /dev/null 2>&1; then
        patch -s "$target_file" < "$patch_file"
        info "  patched: $relative"
      else
        error "  FAILED:  $relative (hunk mismatch)"
      fi
    done
  fi
done

# ── Summary ────────────────────────────────────────────────────────────────────
section "Summary"
total="${#skill_source_map[@]}"
info "Skills deployed: $total"
info "Location: $SKILLS_DIR/"

# List skills grouped by source
for repo_name in $(printf '%s\n' $repos | sort); do
  count=0
  for key in "${!skill_source_map[@]}"; do
    if [ "${skill_source_map[$key]}" = "$repo_name" ] || [ "${skill_source_map[$key]}" = "$repo_name (addon)" ]; then
      count=$((count + 1))
    fi
  done
  if [ "$count" -gt 0 ]; then
    info "  $repo_name: $count skill(s)"
  fi
done

# Check for addon-only entries
for key in "${!skill_source_map[@]}"; do
  if [ "${skill_source_map[$key]}" = *"(addon)"* ]; then
    info "  addon-only: $key"
  fi
done

printf "\n"
info "Build complete."
