# organize_papers.ps1
# Creates a clean folder structure in C:\dev\framework\papers
# and moves relevant files from Downloads and existing directories.
# Run from PowerShell as: powershell -ExecutionPolicy Bypass -File organize_papers.ps1

$base     = "C:\dev\framework\papers"
$dl       = "$env:USERPROFILE\Downloads"

# ── Folder structure ────────────────────────────────────────────────────────
$folders = @(
    "01_active_plb",          # 4 papers with Kitano at PLB
    "02_active_npb_ptep",     # NPB + PTEP submissions
    "03_active_other",        # Exp.Math, Universe, JMP, JPA, JGP
    "04_new_needs_journal",   # Galois-Gauge, Meyerhoff, BPS, X011, WRT
    "05_rejected_archived",   # All rejected papers — keep for reference
    "06_orphaned",            # Papers with no current home
    "07_core_master",         # CORE_MASTER versions
    "08_figures_scripts",     # Figures and Python/Sage scripts
    "09_submission_docs"      # Cover letters, declaration forms, etc.
)

foreach ($f in $folders) {
    $path = Join-Path $base $f
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Created: $path" -ForegroundColor Green
    }
}

# ── File mapping: (source_pattern, destination_folder) ─────────────────────
$moves = @(

    # 01 ACTIVE PLB
    @("gentry-pmns-plb.*",        "01_active_plb"),
    @("gentry-torsion-plb.*",     "01_active_plb"),
    @("gentry-ckm-plb*.*",        "01_active_plb"),   # v1 and v2
    @("gentry-holonomy-cp-ahp.*", "01_active_plb"),   # same content as PLB-01448

    # 02 ACTIVE NPB / PTEP
    @("gentry-cp-npb2.*",         "02_active_npb_ptep"),
    @("gentry-hfg-unified-v3.*",  "02_active_npb_ptep"),
    @("gentry-hfg-unified-v2.*",  "02_active_npb_ptep"),  # keep for reference

    # 03 ACTIVE OTHER
    @("gentry_farey_tower.*",     "03_active_other"),
    @("gentry-farey-tower.*",     "03_active_other"),
    @("gentry-twist-symmetry.p*", "03_active_other"),   # Universe
    @("gentry-qubit-gates-jmp.*", "03_active_other"),   # JMP
    @("gentry-mixing-jpa.*",      "03_active_other"),   # JPA
    @("gentry-flavor-mixing-jgp.*","03_active_other"),  # JGP transfer

    # 04 NEW — NEEDS JOURNAL
    @("gentry-galois-gauge.*",    "04_new_needs_journal"),
    @("gentry_meyerhoff_gauss.*", "04_new_needs_journal"),
    @("gentry-gauss-wrt.*",       "04_new_needs_journal"),  # earlier draft
    @("gentry-bps-lepton.*",      "04_new_needs_journal"),
    @("gentry-wrt-x011.*",        "04_new_needs_journal"),
    @("gentry-x011-bridge-v2.*",  "04_new_needs_journal"),
    @("gentry-hfg-arithmetic.*",  "04_new_needs_journal"),

    # 05 REJECTED — ARCHIVED
    @("gentry-cp-final.*",        "05_rejected_archived"),
    @("gentry-ckm-prd.*",         "05_rejected_archived"),
    @("gentry-ckm-rip.*",         "05_rejected_archived"),
    @("gentry-pmns-rip*.*",       "05_rejected_archived"),
    @("gentry-pmns-final.*",      "05_rejected_archived"),
    @("gentry-pmns-jgp.*",        "05_rejected_archived"),
    @("gentry-hfg-unified.p*",    "05_rejected_archived"),   # v1 (not v2 or v3)
    @("gentry-hfg-unified-npb.*", "05_rejected_archived"),
    @("gentry-holonomy-cp.p*",    "05_rejected_archived"),   # non-ahp version
    @("gentry-twist-final.*",     "05_rejected_archived"),
    @("gentry-twist-dc.*",        "05_rejected_archived"),
    @("gentry-neutrino*.*",       "05_rejected_archived"),
    @("gentry-hyperbolic-flavor-cp-epjc.*", "05_rejected_archived"),
    @("gentry-flavor-mixing.p*",  "05_rejected_archived"),
    @("gentry-covering-tower.*",  "05_rejected_archived"),
    @("gentry_covering_tower.*",  "05_rejected_archived"),
    @("gentry_lucas_pure.*",      "05_rejected_archived"),
    @("gentry_lucas_structure.*", "05_rejected_archived"),
    @("gentry-ckm-rip-final.*",   "05_rejected_archived"),
    @("gentry-pmns-rip-final.*",  "05_rejected_archived"),

    # 06 ORPHANED
    @("gentry-rigidity.*",        "06_orphaned"),
    @("gentry-weeks-dehn.*",      "06_orphaned"),
    @("gentry-cof-lattice.*",     "06_orphaned"),
    @("gentry-hyperbolic-lattice.*","06_orphaned"),
    @("gentry_covering_tower_mmj.*","06_orphaned"),
    @("SU_paper_short.*",         "06_orphaned"),
    @("GW_phi_lattice.*",         "06_orphaned"),
    @("gentry-qubit-gates.p*",    "06_orphaned"),   # non-jmp version

    # 07 CORE MASTER
    @("CORE_MASTER_v*.*",         "07_core_master"),

    # 08 FIGURES / SCRIPTS
    @("fig1_*.*",                 "08_figures_scripts"),
    @("fig2_*.*",                 "08_figures_scripts"),
    @("fig3_*.*",                 "08_figures_scripts"),
    @("hfg_fig*.*",               "08_figures_scripts"),
    @("verify_zhat.sage",         "08_figures_scripts"),
    @("scan_papers.py",           "08_figures_scripts"),
    @("run_scan.ps1",             "08_figures_scripts"),
    @("make_twist_figures.py",    "08_figures_scripts"),

    # 09 SUBMISSION DOCS
    @("declarationStatement*.*",  "09_submission_docs"),
    @("cover_*.*",                "09_submission_docs"),
    @("author_statement*.*",      "09_submission_docs"),
    @("correction_letter*.*",     "09_submission_docs")
)

# ── Move files ───────────────────────────────────────────────────────────────
$moved = 0
$skipped = 0

foreach ($rule in $moves) {
    $pattern = $rule[0]
    $dest    = Join-Path $base $rule[1]

    # Search both Downloads and existing papers directory
    foreach ($searchDir in @($dl, $base)) {
        $files = Get-ChildItem -Path $searchDir -Filter $pattern -File -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            $target = Join-Path $dest $file.Name
            # Don't move if already in destination
            if ($file.DirectoryName -eq $dest) { continue }
            # Don't overwrite newer files
            if ((Test-Path $target) -and
                (Get-Item $target).LastWriteTime -ge $file.LastWriteTime) {
                $skipped++
                continue
            }
            Copy-Item $file.FullName -Destination $target -Force
            $moved++
            Write-Host "  $($file.Name) -> $($rule[1])" -ForegroundColor Cyan
        }
    }
}

Write-Host ""
Write-Host "Done. Moved/copied: $moved files. Skipped (newer exists): $skipped" -ForegroundColor Yellow
Write-Host ""
Write-Host "Folder summary:" -ForegroundColor White
foreach ($f in $folders) {
    $path  = Join-Path $base $f
    $count = (Get-ChildItem $path -File -ErrorAction SilentlyContinue).Count
    Write-Host "  $f : $count files"
}
Write-Host ""
Write-Host "NOTE: Original files in Downloads are NOT deleted." -ForegroundColor DarkYellow
Write-Host "Review, then delete Downloads copies manually once confirmed." -ForegroundColor DarkYellow
