# HFG v1.2.0 Zenodo Release Script
# Run from: C:\dev\hyperbolic-flavor-geometry\
# Purpose: Fix verify_peripheral.py J_CKM error, add exploratory/ directory
#
# Changes in v1.2.0:
#   - verify_peripheral.py: fixed J_CKM 3.06e-4 → 3.06e-5 (PDG 2022 value)
#   - verify_peripheral.py: reframed as EXPLORATORY (not a verification claim)
#   - exploratory/ directory: added with README explaining the non-result
#   - reproduce/README.md: updated to note verify_peripheral.py status

Set-Location "C:\dev\hyperbolic-flavor-geometry"

Write-Host "=== HFG v1.2.0 Release Prep ===" -ForegroundColor Cyan

# Stage changes
git add reproduce/verify_peripheral.py
git add exploratory/verify_peripheral.py
git add exploratory/README.md
git add reproduce/README.md 2>$null  # only if it exists

# Show what we're committing
Write-Host "`nStaged changes:" -ForegroundColor Yellow
git diff --cached --stat

# Commit
git commit -m "v1.2.0: Fix J_CKM in verify_peripheral.py; add exploratory/

- verify_peripheral.py: corrected J_CKM from 3.06e-4 to 3.06e-5 (PDG 2022)
- verify_peripheral.py: reframed as exploratory calculation, not a verification
- exploratory/: new directory with README explaining delta != J_CKM result
- The peripheral determinant claim (delta ~ J_CKM) does not hold;
  J_CKM = 0 is the HFG zeroth-order prediction (SSRN 6775158, open problem #1)

Citable scripts remain: verify_bloch_quantum.py, verify_trace.py, census_null_test.py"

# Tag v1.2.0
git tag -a v1.2.0 -m "Meyerhoff volume quantum verification v1.2.0 - corrected J_CKM"

Write-Host "`nTag created:" -ForegroundColor Yellow
git tag -l "v1.2.0" -n1

# Push
Write-Host "`nPushing to GitHub..." -ForegroundColor Yellow
git push origin main
git push origin v1.2.0

Write-Host @"

=== NEXT STEP: Zenodo ===
1. Go to https://zenodo.org/records/21125014
2. Click 'New version'
3. Zenodo should auto-detect the v1.2.0 GitHub release
   (or manually upload the new zip if webhook not configured)
4. Update the Zenodo description to remove 'verify_peripheral.py'
   from the 'Key scripts' list
5. Publish — you will get a new DOI for v1.2.0
6. Use the v1.2.0 DOI in the Bloch volume quantum paper submission

"@ -ForegroundColor Green
