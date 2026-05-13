# BUILD.ps1 -- builds skills/ from outsourced vendor repos
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
#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$ScriptDir   = $PSScriptRoot
$VendorDir   = Join-Path $ScriptDir '../vendor'
$AddonsDir   = Join-Path $ScriptDir '../addons'
$SkillsDir   = Join-Path $ScriptDir '../skills'

# -- Helpers --
function Info($msg)     { Write-Host "[build]  $msg" -ForegroundColor Green }
function Section($msg)  { Write-Host "`n-- $msg --" -ForegroundColor Cyan }
function Warn($msg)     { Write-Host "[warn]   $msg" -ForegroundColor Yellow }
function Err($msg)      { Write-Host "[error]  $msg" -ForegroundColor Red }

# -- Preflight --
if (-not (Test-Path $VendorDir)) {
    Err "vendor\ not found."
    exit 1
}

New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null

# -- Discover vendor repos with skills/ subdirectories --
$repos = @()
Get-ChildItem -Path $VendorDir -Directory | Sort-Object Name | ForEach-Object {
    $repoName = $_.Name
    $skillsSrc = Join-Path $_.FullName 'skills'
    if (Test-Path $skillsSrc) {
        $repos += $repoName
    }
}

if ($repos.Count -eq 0) {
    Warn "No vendor repos with skills\ found."
    Info "Build complete (no skills to deploy)."
    exit 0
}

# -- Track provenance: skill_name -> last_winning_repo --
$skillSourceMap = [System.Collections.Generic.Dictionary[string,string]]::new()

# -- Process each repo in sorted order --
foreach ($repoName in $repos) {
    Section "vendor/$repoName"
    $repoDir = Join-Path $VendorDir $repoName
    $skillsSrc = Join-Path $repoDir 'skills'

    # Discover skill folders inside vendor/<repo>/skills/
    Get-ChildItem -Path $skillsSrc -Directory | Sort-Object Name | ForEach-Object {
        $skillName = $_.Name
        $targetDir = Join-Path $SkillsDir $skillName
        $sourceFile = Join-Path $targetDir '.source'

        # Check for existing skill (conflict / override)
        $existingSource = $null
        if ((Test-Path $targetDir) -and (Test-Path (Join-Path $targetDir 'SKILL.md'))) {
            if (Test-Path $sourceFile) {
                $existingSource = Get-Content $sourceFile -Raw
            }
            if ($existingSource -eq $repoName) {
                Info "  update: $skillName (from $repoName)"
            } else {
                $origLabel = if ($existingSource) { $existingSource } else { 'unknown' }
                Warn "  override: $skillName (was from $origLabel, now $repoName)"
            }
        } else {
            Info "  install: $skillName (from $repoName)"
        }

        # Wipe and copy from vendor
        if (Test-Path $targetDir) { Remove-Item $targetDir -Recurse -Force }
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item -Path (Join-Path $_.FullName '\*') -Destination $targetDir -Recurse -Force

        # Write provenance marker
        Set-Content -Path $sourceFile -Value $repoName -NoNewline

        # Track in map
        $skillSourceMap[$skillName] = $repoName
    }

    # -- Apply addons/ overrides for this repo --
    $addonsRepo = Join-Path $AddonsDir $repoName
    if (Test-Path $addonsRepo) {
        # Copy any extra skill folders from addons
        Get-ChildItem -Path $addonsRepo -Directory | Sort-Object Name | ForEach-Object {
            $skillName = $_.Name
            $targetDir = Join-Path $SkillsDir $skillName
            if (Test-Path $targetDir) { Remove-Item $targetDir -Recurse -Force }
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            Copy-Item -Path (Join-Path $_.FullName '\*') -Destination $targetDir -Recurse -Force
            Set-Content -Path (Join-Path $targetDir '.source') -Value "$repoName (addon)" -NoNewline
            $skillSourceMap[$skillName] = "$repoName (addon)"
            Info "  addon: $skillName (from $repoName)"
        }

        # Apply patches to existing skills
        $patchFiles = Get-ChildItem -Path $addonsRepo -Recurse -Filter '*.patch' | Sort-Object FullName
        if ($patchFiles) {
            foreach ($patchFile in $patchFiles) {
                $patchPath = $patchFile.FullName
                $relative = $patchPath.Substring($addonsRepo.Length).TrimStart('\','/')

                # Determine the skill folder and target file
                $parts = $relative -split '[\/]'
                $skillFolder = $parts[0]
                $targetFile = Join-Path $SkillsDir (Join-Path $skillFolder ($parts -join '\'))

                $targetDir = Join-Path $SkillsDir $skillFolder
                if (-not (Test-Path $targetDir)) {
                    Warn "  patch target missing: $relative (skipping)"
                    continue
                }

                if (-not (Test-Path $targetFile)) {
                    Warn "  patch file not found: $relative (skipping)"
                    continue
                }

                $dryRun = & patch --dry-run -s $targetFile $patchPath 2>&1
                if ($LASTEXITCODE -eq 0) {
                    & patch -s $targetFile $patchPath | Out-Null
                    Info "  patched: $relative"
                } else {
                    Err "  FAILED:  $relative (hunk mismatch)"
                }
            }
        }
    }
}

# -- Summary --
Section "Summary"
Info "Skills deployed: $($skillSourceMap.Count)"
Info "Location: $SkillsDir\"

# List skills grouped by source
foreach ($repoName in $repos) {
    $count = 0
    foreach ($key in $skillSourceMap.Keys) {
        if ($skillSourceMap[$key] -eq $repoName -or $skillSourceMap[$key] -eq "$repoName (addon)") {
            $count++
        }
    }
    if ($count -gt 0) {
        Info "  ${repoName}: $count skill(s)"
    }
}

# Check for addon-only entries
foreach ($key in $skillSourceMap.Keys) {
    if ($skillSourceMap[$key] -like "* (addon)*") {
        Info "  addon-only: $key"
    }
}

Write-Host ""
Info "Build complete."
