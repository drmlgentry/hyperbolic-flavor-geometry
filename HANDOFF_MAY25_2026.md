# HFG Research Handoff — May 25, 2026

## Session Summary

Major session: new bridges discovered, WRT theorem proved, trace field
corrections identified. All papers updated or drafted.

---

## New Results This Session

### 1. WRT Slope Norm Theorem (PROVED)
For M_PMNS = m003(-2,3) with H_1=Z/5, CS=1/4:

  |WRT_r(M_PMNS)|^2 = |3 + 2i^r|^2 / r

Specifically:
  r ≡ 1,3 mod 4:  |WRT|^2 = 13/r = L_6/r
  r ≡ 0 mod 4:    |WRT|^2 = 25/r
  r ≡ 2 mod 4:    |WRT|^2 = 1/r

At Lucas prime levels:
  |WRT_11|^2 = 13/11 = L_6/L_5  (cover prime)
  |WRT_13|^2 = 1                 (self-normalization at slope norm)
  |WRT_29|^2 = 13/29 = L_6/L_7  (CKM slope norm)

The (3,2) linking form split: 3=|ker Q|, 2=|coker Q|, 3^2+2^2=13=N(-2+3i)
This is the Gaussian norm of the PMNS filling slope (-2,3).

### 2. Golden Ratio Correction
phi^2 = 2.618 approximates 13/5 = 2.600 to 0.69%.
The EXACT smearing parameter is sigma_opt = (3/2)*log(sqrt(13/5)).
Golden ratio should be REMOVED from all papers and replaced with sqrt(13/5).

### 3. X_0(11) Bridge (SSRN 6815721 — already submitted)
Verified: base change of X_0(11) to Q(sqrt(-3)) gives Bianchi form 2.0.3.1-121.1-a
Verified: base change of X_0(11) to Q(sqrt(17)) gives Hilbert form 2.2.17.1-121.1-a
12/12 Hecke eigenvalues match in both cases.

### 4. CRITICAL TRACE FIELD CORRECTIONS (discovered end of session)

The claim K_CKM = Q(sqrt(17)) is INCORRECT in principle:
- Real quadratic fields have 0 complex places
- Arithmetic Kleinian groups require exactly 1 complex place
- Q(sqrt(17)) CANNOT be the invariant trace field of any arithmetic hyperbolic 3-manifold

Correct trace fields from literature:
  m003 (cusped):     Q(sqrt(-3)), disc=-3     [VERIFIED, used for X_0(11) bridge]
  m006 (cusped):     CUBIC, disc=-59          [Long-Reid, verified]
  m003(-2,3) PMNS:   DEGREE 4, disc=-283      [Chinburg-Friedman-Jones-Reid table]
  m003(-3,1) Weeks:  CUBIC, disc=-23          [Reid table]
  m006(-5,2) CKM:    UNKNOWN                  [needs computation]

The Q(sqrt(17)) likely entered through holonomy eigenvalues or shape
parameters — a different object from the invariant trace field.

### 5. Quaternion Algebra of M_PMNS (from Reid table)
  - Trace field: Q(alpha), alpha^4-alpha-1=0, disc=-283, sig=(2,1)
  - Real ramification: BOTH real places [1,2]
  - FINITE ramification: EMPTY (no finite primes ramified!)
  - QA = M_2(k) — the matrix algebra, not a division algebra

This means the JL identification is more subtle than expected:
the QA of M_PMNS is unramified at all finite primes.

---

## Papers Status

### Submitted this session
- PTEP T06112 (Unified HFG, Paper) — Posted May 23
- PTEP T06113 (CP phase, Letter) — Posted May 23
- SSRN 6815721 (X_0(11) bridge) — Posted May 23

### New papers drafted (not yet submitted)
- gentry-wrt-x011.tex/.pdf — WRT Slope Norm Theorem (8 pages, CLEAN)
  Status: Complete, needs trace field section update re: Q(sqrt(17)) correction
  Target: Annals of Physics or Research in Mathematical Sciences

### Papers needing correction
- SSRN 6815721 (X_0(11) bridge): The Hilbert form connection via Q(sqrt(17))
  needs re-examination. The Bianchi form connection via Q(sqrt(-3)) is CORRECT.

---

## What Needs To Happen Next

### Immediate (before any new submissions)
1. Find correct trace field of M_CKM = m006(-5,2)
   - Search CFKR (2001) paper for m006(-5,2) entry
   - Or search Reid arithmetic zoo / Snap database
   - URL: http://www.numdam.org/item/ASNSP_2001_4_30_1_1_0.pdf

2. Determine what Q(sqrt(17)) actually represents in HFG
   - Check the original SnapPy computation that gave Q(sqrt(17))
   - Script: /mnt/c/dev/hyperbolic-flavor-scan/hfg_reproduce.py
   - The shape parameters or holonomy eigenvalues may involve Q(sqrt(17))

3. Update WRT paper with corrected trace field statements

4. Update SSRN 6815721 with a correction note or revised version

### Medium term
5. Complete compile and commit of all new files
6. Retarget CKM and PMNS papers (formerly JGP) to Annals of Physics
7. Compute Z-hat invariant of M_PMNS via DGG 3d/3d correspondence

---

## Key Files This Session
- /mnt/user-data/outputs/gentry-wrt-x011.pdf — WRT theorem paper
- /mnt/user-data/outputs/gentry-wrt-x011.tex — WRT theorem source
- /mnt/user-data/outputs/gentry-x011-bridge-v2.pdf — X_0(11) bridge (corrected)
- /mnt/user-data/outputs/x011_bridge_diagram.pdf — Bridge diagram figure
- /mnt/user-data/outputs/x011_farey_eigenvalues.pdf — Farey+eigenvalue figure

## Canonical Scripts
- WSL conda sage: conda run -n sage python reproduce/hfg_reproduce.py
- Windows: does not reproduce PMNS (holonomy issue)
- Always use OrientableClosedCensus[1] for PMNS, [43] for CKM

## Git Status
- Need to commit: gentry-wrt-x011.tex, updated figures, this handoff
- Repos: hyperbolic-flavor-geometry, hyperbolic-flavor-scan
