#!/usr/bin/env sh
# install.sh — deploys the repo's category folders to user system directories
#
# Destinations are configured in install.conf at the repo root.
#
# install.conf format:
#   <category>/*    <destination>
#
# Examples:
#   skills/*        ~/.claude/skills
#   agents/*        ~/.agents
#   commands/*      ~/.codex/commands
#   prompts/*       ~/.claude/prompts
#   mcps/*          ~/.config/mcps
#
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_FILE="$SCRIPT_DIR/install.conf"

# ── Colours ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; RESET='\033[0m'
info()    { printf "${GREEN}[install]${RESET} %s\n" "$1"; }
section() { printf "\n${CYAN}── %s ──${RESET}\n" "$1"; }
warn()    { printf "${YELLOW}[warn]${RESET}    %s\n" "$1"; }
error()   { printf "${RED}[error]${RESET}   %s\n" "$1"; }

# ── Flags ──────────────────────────────────────────────────────────────────────
DRY_RUN=0
FORCE=0

for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --force|-f)   FORCE=1 ;;
    --help|-h)
      printf "Usage: install.sh [--dry-run] [--force]\n"
      printf "  --dry-run   Show what would be installed without copying\n"
      printf "  --force     Overwrite existing files without prompting\n"
      exit 0
      ;;
  esac
done

[ "$DRY_RUN" = "1" ] && warn "Dry-run mode — nothing will be written"

# ── Preflight ──────────────────────────────────────────────────────────────────
if [ ! -f "$CONF_FILE" ]; then
  error "install.conf not found at: $CONF_FILE"
  exit 1
fi

# ── Install function ───────────────────────────────────────────────────────────
install_category() {
  category="$1"
  dest_dir="$(eval echo "$2")"   # expand ~, $HOME, $XDG_* etc.

  src_dir="$SCRIPT_DIR/$category"

  if [ ! -d "$src_dir" ]; then
    warn "Source folder not found: $category/ (did you run build.sh?)"
    return
  fi

  section "$category/  →  $dest_dir"

  find "$src_dir" -type f | sort | while read -r src_file; do
    relative="${src_file#"$src_dir"/}"
    dest_file="$dest_dir/$relative"
    dest_parent="$(dirname "$dest_file")"

    if [ -f "$dest_file" ] && [ "$FORCE" = "0" ]; then
      warn "  exists (--force to overwrite): $dest_file"
      continue
    fi

    if [ "$DRY_RUN" = "1" ]; then
      info "  [dry] → $dest_file"
    else
      mkdir -p "$dest_parent"
      cp "$src_file" "$dest_file"
      info "  → $dest_file"
    fi
  done
}

# ── Parse install.conf ─────────────────────────────────────────────────────────
info "Reading install.conf..."

while IFS= read -r line; do
  case "$line" in '#'*|'') continue ;; esac

  category=$(echo "$line" | awk '{print $1}' | sed 's|/\*$||')
  dest=$(echo "$line"     | awk '{print $2}')

  if [ -z "$category" ] || [ -z "$dest" ]; then
    warn "Skipping malformed line: $line"
    continue
  fi

  install_category "$category" "$dest"
done < "$CONF_FILE"

printf "\n"
info "Install complete."