# SESSION_COMMIT.ps1
# Run at the END of every Cowork/research session.
# Usage: .\SESSION_COMMIT.ps1 "Brief session summary"
# Creates a session log, commits all session work, pushes to GitHub.
#
# If no summary provided, opens a prompt.

param(
    [string]$Summary = ""
)

Set-Location "C:\dev\hyperbolic-flavor-geometry"

$Date = Get-Date -Format "yyyy-MM-dd"
$SessionFile = "SESSIONS\$Date.md"

if ($Summary -eq "") {
    $Summary = Read-Host "One-line session summary"
}

Write-Host "`n=== HFG Session Commit — $Date ===" -ForegroundColor Cyan
Write-Host "Summary: $Summary" -ForegroundColor Yellow

# ── 1. Verify session log exists ────────────────────────────────────────────
if (-not (Test-Path $SessionFile)) {
    Write-Host "`n[WARN] No session log found at $SessionFile" -ForegroundColor Yellow
    Write-Host "       Create it before committing (use SESSIONS\TEMPLATE.md)" -ForegroundColor Yellow
    $continue = Read-Host "Continue without session log? (y/N)"
    if ($continue -ne "y") { exit 1 }
}

# ── 2. Show what will be staged ─────────────────────────────────────────────
Write-Host "`nModified files:" -ForegroundColor Yellow
git status --short

# ── 3. Stage everything (tracked modifications + new files in key dirs) ─────
git add -u                              # all tracked modifications
git add .gitattributes 2>$null
git add RELEASE_v1.2.0.ps1 2>$null
git add SESSION_COMMIT.ps1 2>$null
git add SESSIONS\ 2>$null
git add exploratory\ 2>$null
git add reproduce\README.md 2>$null
git add reproduce\verify_peripheral.py 2>$null
git add data\peripheral_determinant.json 2>$null
git add papers\farey_tower\gentry_farey_tower.tex 2>$null
git add papers\04_new_needs_journal\gentry-galois-gauge-v4.tex 2>$null

Write-Host "`nStaged:" -ForegroundColor Yellow
git diff --cached --stat

# ── 4. Commit ────────────────────────────────────────────────────────────────
$CommitMsg = "$Date`: $Summary

Session log: SESSIONS\$Date.md
See CLAUDE.md (C:\dev\CLAUDE.md) for current hot-cache state."

git commit -m $CommitMsg

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[ERROR] Commit failed." -ForegroundColor Red
    exit 1
}

# ── 5. Push ──────────────────────────────────────────────────────────────────
Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=== Session committed and pushed. ===" -ForegroundColor Green
    Write-Host "Next session: read CLAUDE.md + HFG_STATUS.md + git log --oneline -5" -ForegroundColor Green
} else {
    Write-Host "`n[WARN] Push failed — committed locally. Run 'git push origin main' when online." -ForegroundColor Yellow
}
