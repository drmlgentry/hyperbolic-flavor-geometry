# Hyperbolic Flavor Geometry

A research program deriving Standard Model flavor parameters from the geometry of compact hyperbolic 3-manifolds via the Iwasawa decomposition PSL(2,C) = KAN.

## Core Result

The Iwasawa decomposition distributes SM flavor structure across two manifolds:

- **K-factor** -> CKM quark mixing | manifold m006 (OrientableClosedCensus[43], vol=2.029, H1=Z/5) | fitness F=0.01729
- **N-factor** -> PMNS lepton mixing | manifold m003 (Meyerhoff, OrientableClosedCensus[1], vol=0.981, H1=Z/5) | fitness F=0.01897
- **A-factor** -> CP phases from loxodromic twist angles, quantized by Z/5 torsion

Both optimal manifolds have H1=Z/5 (odd-torsion selection principle).

## Submission Portfolio (April 2026)

| # | Title | Journal | Status | ID |
|---|---|---|---|---|
| 1 | CKM from Geodesic Axes | Results in Physics | With editor | RINP-D-26-00327 |
| 2 | PMNS from Borel Structure | Results in Physics | With editor | RINP-D-26-00328 |
| 3 | CP Violation from A-Factor | Results in Physics | With editor | RINP-D-26-00329 |
| 4 | Twist Angle Spectrum | Results in Physics | With editor | RINP-D-26-00330 |
| 5 | Discrete Mixing Operators | Letters Math. Physics | Peer review | - |
| 6 | Geometric Origin of CP Phases | Letters Math. Physics | Peer review | - |
| 7 | Homology Class Asymmetry | Annales Inst. Fourier | With editor | 2026120 |
| 8 | Alexander Polynomial & Golden Ratio | J. Knot Theory Ramif. | With editor | JKTR-S-26-00044 |

## Key Numerical Results

**CKM (m006, OrientableClosedCensus[43])**
- Words: {aaB, AbA, AAb} | fitness=0.01729 | J=0 (topologically forced)
- All three words in same SU(2) conjugacy class
- Gaussian coherence length sigma=0.488 ~ l2(m006)=0.491 (0.5% match)

**PMNS (m003, OrientableClosedCensus[1])**
- Borel lower-triangular construction | fitness=0.01897 = theoretical minimum
- Symmetric QR floor theorem: no symmetric kernel can reach PMNS (floor=0.300)

**Alexander Polynomial / Mahler Measure**
- Alex(m003 cusped) = t^2+3t+1, roots -phi^2, -phi^{-2}
- Mahler measure = phi^2, log M = 2*Reg(Q(sqrt(5))) = 2*log(phi)

## New Results (April 2026)

- sigma = l2(m006): Gaussian coherence length = second geodesic of CKM manifold (0.5%)
- Conjugacy class theorem: J=0 in CKM sector is topologically forced
- PMNS Borel confirmed: fitness=0.01897 reproduced independently

## Repository Structure

    papers/
      hyperbolic-flavor-ckm/       CKM from geodesic axes (RINP-D-26-00327)
      hyperbolic-flavor-pmns/      PMNS from Borel structure (RINP-D-26-00328)
      hyperbolic-flavor-cp/        CP violation from A-factor (RINP-D-26-00329)
      hyperbolic-flavor-torsion/   Homology class asymmetry (AIF 2026120)
      hyperbolic-lattice/          Alexander polynomial (JKTR-S-26-00044)
    code/                          Utility scripts

Scan scripts: https://github.com/drmlgentry/hyperbolic-flavor-scan

## Author

Marvin L. Gentry | drmlgentry@protonmail.com | ORCID: 0009-0006-4550-2663
