# install.ps1 — deploys the repo's category folders to user system directories
#
# Destinations are configured in install.conf at the repo root.
#
# install.conf format:
#   <category>/*    <destination>
#
# Examples:
#   skills/*        $env:USERPROFILE\.claude\skills
#   agents/*        $env:USERPROFILE\.agents
#   commands/*      $env:USERPROFILE\.codex\commands
#   prompts/*       $env:USERPROFILE\.claude\prompts
#   mcps/*          $env:APPDATA\mcps
#
#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$ConfFile  = Join-Path $ScriptDir 'install.conf'

# ── Helpers ────────────────────────────────────────────────────────────────────
function Info($msg)    { Write-Host "[install] $msg" -ForegroundColor Green }
function Section($msg) { Write-Host "`n── $msg ──" -ForegroundColor Cyan }
function Warn($msg)    { Write-Host "[warn]    $msg" -ForegroundColor Yellow }
function Err($msg)     { Write-Host "[error]   $msg" -ForegroundColor Red }

if ($DryRun) { Warn "Dry-run mode — nothing will be written" }

# ── Preflight ──────────────────────────────────────────────────────────────────
if (-not (Test-Path $ConfFile)) {
    Err "install.conf not found at: $ConfFile"
    exit 1
}

# ── Install function ───────────────────────────────────────────────────────────
function Install-Category {
    param([string]$Category, [string]$DestDir)

    # Expand environment variables in destination
    $DestDir = [System.Environment]::ExpandEnvironmentVariables($DestDir)
    # Also expand ~ as $HOME shorthand
    $DestDir = $DestDir -replace '^~', $env:USERPROFILE

    $SrcDir = Join-Path $ScriptDir $Category

    if (-not (Test-Path $SrcDir)) {
        Warn "Source folder not found: $Category\ (did you run build.ps1?)"
        return
    }

    Section "$Category\  →  $DestDir"

    Get-ChildItem -Path $SrcDir -Recurse -File | Sort-Object FullName | ForEach-Object {
        $SrcFile  = $_.FullName
        $Relative = $SrcFile.Substring($SrcDir.Length).TrimStart('\','/')
        $DestFile = Join-Path $DestDir $Relative
        $DestParent = Split-Path $DestFile -Parent

        if ((Test-Path $DestFile) -and -not $Force) {
            Warn "  exists (-Force to overwrite): $DestFile"
            return
        }

        if ($DryRun) {
            Info "  [dry] → $DestFile"
        } else {
            if (-not (Test-Path $DestParent)) {
                New-Item -ItemType Directory -Path $DestParent | Out-Null
            }
            Copy-Item -Path $SrcFile -Destination $DestFile -Force
            Info "  → $DestFile"
        }
    }
}

# ── Parse install.conf ─────────────────────────────────────────────────────────
Info "Reading install.conf..."

Get-Content $ConfFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -match '^#' -or $line -eq '') { return }

    $parts = $line -split '\s+', 2
    if ($parts.Count -lt 2) {
        Warn "Skipping malformed line: $line"
        return
    }

    # Strip trailing /* from category glob
    $category = $parts[0].Trim() -replace '/\*$', '' -replace '\\\*$', ''
    $dest     = $parts[1].Trim()

    Install-Category -Category $category -DestDir $dest
}

Write-Host ""
Info "Install complete."