# Hyperbolic Flavor Geometry

A research program deriving Standard Model flavor structure from the geometry
of compact hyperbolic 3-manifolds. The central result: the CKM and PMNS
mixing matrices correspond to distinct factors of the Iwasawa decomposition
PSL(2,C) = KAN, realized geometrically via the holonomy of specific
hyperbolic 3-manifolds with first homology containing odd-prime torsion.

## Core Result

| Iwasawa Factor | Physical Object | Optimal Manifold | H₁ | Fitness |
|---|---|---|---|---|
| K (maximal compact) | CKM quark mixing | m006, vol=2.029 | Z/5 | 0.01729 |
| N (unipotent Borel) | PMNS lepton mixing | m003, vol=0.981 | Z/5 | 0.01897 |
| A (diagonal Cartan) | CP phases / masses | m003 (twist angles) | Z/5 | in progress |

The CP phase prediction from A-factor twist angles: φ_aa − φ_ab + φ_aB = 203.5°
vs PDG δ_CP = 197° (3.3% error, no free parameters).

## Papers

| # | Title | Journal | Status | ID |
|---|-------|---------|--------|----|
| 1 | Geometric Origin of CP Phases from Hyperbolic Holonomy | PRD (pending resubmission) | Desk-rejected JGP12746 | — |
| 2 | Hyperbolic Logarithmic Lattices and Discrete Weight Spectra | Geom. Dedicata | Under review | rs-9071491 |
| 3 | Discrete Mixing Operators from Boundary Sector Geometry | TBD | Desk-rejected JGP12747 | — |
| 4 | Scale-Free Quadratic Forms, Symmetric Space Geometry, and Arithmetic Logarithmic Lattices | JGP | Under review | JGP12753 |
| 5 | CKM Quark Mixing from Geodesic Axes of Hyperbolic 3-Manifold Holonomy | PRD | Submitted Mar 2026 | es2026mar11_966 |
| 6 | Lepton Mixing from Borel Structure of Hyperbolic Holonomy | PRD | Submitted Mar 2026 | es2026mar13_942 |
| 7 | CP Violation from A-Factor Twist Angles of Hyperbolic Holonomy | PRD | In preparation | — |

## Construction

The pipeline from manifold to mixing matrix:
```
π₁(M) → PSL(2,C)     holonomy representation (SnapPy)
       → loxodromic matrices
       → log(ρ(γ))    matrix logarithm
       → axis directions n̂ᵢ ∈ S²   (Pauli decomposition, real parts)
       → overlap matrix O or L      (symmetric for CKM, lower-triangular for PMNS)
       → QR decomposition
       → |Q| ≈ U_CKM or U_PMNS
```

For CP violation (Paper 7), the imaginary parts of log(ρ(γ)) — the twist
angles φ(γ) — enter as complex axis components, generating J ≠ 0.

## Odd-Torsion Selection Principle

Every manifold achieving Frobenius fitness F < 0.020 in either construction
has H₁(M;Z) containing p-torsion for an odd prime p ∈ {3,5,7,13}.
No purely 2-primary manifold appears in the top results.

## Scan Code

Census scan scripts are in a separate repository:
https://github.com/drmlgentry/hyperbolic-flavor-scan

Key scripts:
- `word_triple_scan_corrected.py` — CKM scan (symmetric QR)
- `pmns_borel_scan.py` — PMNS scan (Borel/lower-triangular QR)

## Dependencies

- [SnapPy](http://snappy.computop.org) — hyperbolic manifold census and holonomy
- Python 3.x: numpy, scipy, pandas
- TeXLive (full) + revtex4-2
- VS Code + LaTeX Workshop

## Author

Marvin L. Gentry
drmlgentry@protonmail.com
ORCID: 0009-0006-4550-2663
