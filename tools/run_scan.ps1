# run_scan.ps1 — bypass execution policy by calling Python directly
# No signing required. Drop in C:\dev\framework\tools\ alongside scan_papers.py
#
# Usage examples:
#   .\run_scan.ps1
#   .\run_scan.ps1 -NoApi
#   .\run_scan.ps1 -Dir "C:\Users\YourName\Downloads" -Filter gentry
#   .\run_scan.ps1 -Dir "C:\Users\YourName\Downloads" -All
#   .\run_scan.ps1 -Limit 10
#
# To fix the execution policy permanently (run once as admin):
#   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

param(
    [string]$Dir    = "$env:USERPROFILE\Downloads",
    [string]$Filter = "gentry",
    [string]$Out    = "$env:USERPROFILE\Downloads\paper_dispositions.md",
    [int]   $Limit  = 0,
    [switch]$NoApi,
    [switch]$All
)

# Activate venv
$venv = @(
    "C:\dev\framework\.venv\Scripts\python.exe",
    "C:\dev\CKM-Geometry\.venv\Scripts\python.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

$py = if ($venv) { $venv } else { "python" }

# Find scan_papers.py
$script = Join-Path $PSScriptRoot "scan_papers.py"
if (-not (Test-Path $script)) {
    Write-Error "scan_papers.py not found next to run_scan.ps1"
    exit 1
}

# Build args
$args_list = @("--dir", $Dir, "--out", $Out)
$args_list += if ($All) { @("--filter", "") } else { @("--filter", $Filter) }
if ($Limit -gt 0) { $args_list += @("--limit", "$Limit") }
if ($NoApi)        { $args_list += "--no-api" }

Write-Host "Scanner: $script" -ForegroundColor Cyan
Write-Host "Python:  $py" -ForegroundColor Cyan
Write-Host "Dir:     $Dir" -ForegroundColor Cyan
Write-Host ""

& $py $script @args_list

if (Test-Path $Out) {
    Write-Host ""
    Write-Host "Report: $Out" -ForegroundColor Green
    $open = Read-Host "Open? (Y/n)"
    if ($open -ne 'n' -and $open -ne 'N') { Start-Process $Out }
}
