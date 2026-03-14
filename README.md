# Hyperbolic Flavor Geometry

A research program deriving Standard Model flavor structure from the geometry
of compact hyperbolic 3-manifolds. The central result: the CKM and PMNS
mixing matrices correspond to distinct factors of the Iwasawa decomposition
PSL(2,C) = KAN, realized geometrically via the holonomy of specific
hyperbolic 3-manifolds with first homology containing odd-prime torsion.

## Core Result

| Iwasawa Factor | Physical Object | Optimal Manifold | H1 | Fitness |
|---|---|---|---|---|
| K (maximal compact) | CKM quark mixing | m006, vol=2.029 | Z/5 | 0.01729 |
| N (unipotent Borel) | PMNS lepton mixing | m003, vol=0.981 | Z/5 | 0.01897 |
| A (diagonal Cartan) | CP phases | m003 (twist angles) | Z/5 | in progress |

CP phase prediction: phi_aa - phi_ab + phi_aB = 203.5 deg vs PDG delta_CP = 197 deg (3.3% error, no free parameters).

## Papers

| # | Title | Journal | Status | ID |
|---|-------|---------|--------|----|
| 1 | Geometric Origin of CP Phases from Hyperbolic Holonomy | Nuclear Physics B | Submitted | NPB-S-26-00539 |
| 2 | Hyperbolic Logarithmic Lattices and Discrete Weight Spectra | Geometriae Dedicata | Under review | rs-9071491 |
| 3 | Discrete Mixing Operators from Boundary Sector Geometry | Nuclear Physics B | Submitted | NPB-S-26-00540 |
| 4 | Scale-Free Quadratic Forms, Symmetric Space Geometry, and Arithmetic Logarithmic Lattices | Nuclear Physics B | Submitted | NPB-S-26-00538 |
| 5 | CKM Quark Mixing from Geodesic Axes of Hyperbolic 3-Manifold Holonomy | Phys. Rev. D | Submitted Mar 2026 | es2026mar11_966 |
| 6 | Lepton Mixing from Borel Structure of Hyperbolic Holonomy | Phys. Rev. D | Submitted Mar 2026 | es2026mar13_942 |
| 7 | CP Violation from A-Factor Twist Angles of Hyperbolic Holonomy | Phys. Rev. D | In preparation | — |

## Construction Pipeline
```
pi_1(M) -> PSL(2,C)        holonomy representation (SnapPy)
         -> loxodromic matrices
         -> log(rho(gamma))  matrix logarithm
         -> Re: axis directions n_i in S^2  (Pauli decomposition)
         -> Im: twist angles phi(gamma)     (A-factor / CP phases)
         -> overlap matrix O or L           (symmetric=CKM, lower-triangular=PMNS)
         -> QR decomposition
         -> |Q| = U_CKM or U_PMNS
         -> arg(phi combination) = delta_CP
```

## Odd-Torsion Selection Principle

Every manifold achieving Frobenius fitness F < 0.020 in either construction
has H_1(M;Z) containing p-torsion for an odd prime p in {3,5,7,13}.
No purely 2-primary manifold appears in the top results.

## Key Theorems

- **Symmetric QR floor**: No positive-definite symmetric overlap matrix can
  reproduce PMNS; proven floor F_min = 0.300 (kernel-independent).
- **Unifying quadratic**: The two Borel solution regimes are roots of a single
  quadratic whose coefficients are closed-form in PMNS angles theta_12, theta_23.
- **Row-phase invariance**: The Jarlskog invariant J is invariant under row
  rephasing of L; CP violation requires genuine off-diagonal complex structure.
- **Translation length theorem**: ell(aa) = 2*ell(aB) exactly on m003,
  with corollary that words a and aB are isospectral.

## Scan Code

Census scan scripts:
https://github.com/drmlgentry/hyperbolic-flavor-scan

Key scripts:
- word_triple_scan_corrected.py  -- CKM scan (symmetric QR)
- pmns_borel_scan.py             -- PMNS scan (Borel QR)

## Dependencies

- SnapPy (http://snappy.computop.org)
- Python 3.x: numpy, scipy, pandas
- TeXLive (full) + revtex4-2
- VS Code + LaTeX Workshop

## Author

Marvin L. Gentry
drmlgentry@protonmail.com
ORCID: 0009-0006-4550-2663
