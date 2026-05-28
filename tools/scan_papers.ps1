# scan_papers.ps1
# HFG Paper Disposition Scanner — PowerShell wrapper
# Run from any directory; scans C:\Users\<you>\Downloads by default.
#
# Usage:
#   .\scan_papers.ps1                          # scan Downloads, all gentry-* PDFs
#   .\scan_papers.ps1 -Dir "C:\dev\papers"     # different directory
#   .\scan_papers.ps1 -Filter "gentry" -Limit 20  # first 20 matches
#   .\scan_papers.ps1 -NoApi                   # skip Claude, use known status only
#   .\scan_papers.ps1 -All                     # include non-gentry PDFs too
#
# Requirements:
#   pip install pypdf pdfplumber requests
#   Set $env:ANTHROPIC_API_KEY before running (or add to your profile)

param(
    [string]$Dir       = "$env:USERPROFILE\Downloads",
    [string]$Filter    = "gentry",
    [string]$Out       = "$env:USERPROFILE\Downloads\paper_dispositions.md",
    [int]   $Limit     = 0,
    [switch]$NoApi,
    [switch]$All       # if set, filter becomes empty (scan all PDFs)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Locate the Python script ────────────────────────────────────────────────
$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$PyScan     = Join-Path $ScriptDir "scan_papers.py"

# If not next to the PS1, check common locations
if (-not (Test-Path $PyScan)) {
    $candidates = @(
        "C:\dev\framework\tools\scan_papers.py",
        "$env:USERPROFILE\Downloads\scan_papers.py",
        ".\scan_papers.py"
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { $PyScan = $c; break }
    }
}

if (-not (Test-Path $PyScan)) {
    Write-Error "Cannot find scan_papers.py. Place it next to this script or in C:\dev\framework\tools\"
    exit 1
}

# ── Activate venv if present ────────────────────────────────────────────────
$VenvActivate = @(
    "C:\dev\framework\.venv\Scripts\Activate.ps1",
    "C:\dev\CKM-Geometry\.venv\Scripts\Activate.ps1",
    ".\\.venv\Scripts\Activate.ps1"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($VenvActivate) {
    Write-Host "Activating venv: $VenvActivate" -ForegroundColor DarkGray
    & $VenvActivate
} else {
    Write-Host "No venv found, using system Python" -ForegroundColor DarkYellow
}

# ── Check API key ────────────────────────────────────────────────────────────
if (-not $NoApi -and -not $env:ANTHROPIC_API_KEY) {
    Write-Warning "ANTHROPIC_API_KEY not set. Running in --no-api mode."
    $NoApi = $true
}

if ($env:ANTHROPIC_API_KEY) {
    Write-Host "API key: found (***$(($env:ANTHROPIC_API_KEY)[-4..-1] -join ''))" -ForegroundColor DarkGray
}

# ── Build Python arguments ───────────────────────────────────────────────────
$PyArgs = @(
    $PyScan,
    "--dir", $Dir,
    "--out", $Out
)

if ($All) {
    $PyArgs += @("--filter", "")
} else {
    $PyArgs += @("--filter", $Filter)
}

if ($Limit -gt 0) {
    $PyArgs += @("--limit", $Limit.ToString())
}

if ($NoApi) {
    $PyArgs += "--no-api"
}

# ── Run ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "  HFG PAPER DISPOSITION SCANNER" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "  Scanning : $Dir" -ForegroundColor White
Write-Host "  Filter   : '$Filter'" -ForegroundColor White
Write-Host "  Output   : $Out" -ForegroundColor White
Write-Host "  API      : $(if ($NoApi) { 'OFF (known status only)' } else { 'ON (Claude classification)' })" -ForegroundColor White
Write-Host ""

$timer = [System.Diagnostics.Stopwatch]::StartNew()
python @PyArgs
$timer.Stop()

Write-Host ""
Write-Host "Completed in $($timer.Elapsed.TotalSeconds.ToString('F1'))s" -ForegroundColor DarkGray

# ── Open output ──────────────────────────────────────────────────────────────
if (Test-Path $Out) {
    Write-Host ""
    $open = Read-Host "Open report in browser? (Y/n)"
    if ($open -ne 'n' -and $open -ne 'N') {
        # Convert .md to html preview or just open with default app
        Start-Process $Out
    }
}
