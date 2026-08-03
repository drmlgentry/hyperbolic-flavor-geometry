# HFG Program Audit Snapshot — 2026-06-20

## Session summary
Full-day audit of all SSRN submissions, local Downloads folder (197 .tex files),
and repo (121 .tex files). 318 total .tex files scanned; 151 unique content items.

---

## SSRN STATUS (30 entries total)

### IN PROCESS (1)
- 6876278 | Sextic-Octic Decomposition | PRELIMINARY_UPLOAD | needs formal submit

### LIVE / DISTRIBUTED (19)
| ID | Title (short) | Notes |
|---|---|---|
| 6851440 | Peripheral Determinant Invariant, disc -283 | clean |
| 6845778 | Meyerhoff as Dehn Filling, Gal Z/2 and S4 | clean |
| 6840418 | Lepton Masses as BPS States on X0(11) | clean |
| 6840324 | Gauss Polynomial and Homological Blocks | clean |
| 6840322 | Galois-Gauge Correspondence | retracts Q(sqrt(17)); corrects sigma_opt |
| 6808878 | Quadratic Cover Prime Formula (Farey tower) | earlier version of Z/5 result |
| 6775158 | Comprehensive Account | **NEEDS CORRECTION NOTE** (see below) |
| 6761978 | Two-Tier Geodesic Spectrum | June 2026 note added; stat evidence weakened |
| 6689678 | Geometric Origin of CP Phases | clean |
| 6689441 | Discrete Mixing Operators | clean |
| 6689419 | Weeks Manifold, Dehn Surgery, Lepton Sector | clean |
| 6688021 | Homology Class Asymmetry | clean |
| 6687838 | Topologically Protected Qubit Gates | clean |
| 6669600 | GW Peak Frequencies, phi-Lattice | clean |
| 6631218 | Neutrino Masses (restricted by publisher) | prediction mnu=71.4meV, falsifiable CMB-S4 |
| 6583553 | Lepton Mixing from Borel Structure | clean |
| 6583551 | CP Violation from Twist Angles | clean |
| 6583550 | Quark Mixing from Hyperbolic Geometry | clean |
| 6583549 | Twist Angle Spectrum | clean |

### INACTIVE / REMOVED (10)
| ID | Title (short) | Reason removed | Successor |
|---|---|---|---|
| 6859979 | Meyerhoff as Volume Quantum, m019+m178 | numerical obs, not proved | still open |
| 6854378 | Lucas Numbers as Holonomy Traces | Binet error in earlier versions | v4 (in repo) |
| 6848478 | Minimum Eisenstein Norm Function | superseded | v2 (in repo) |
| 6815721 | Common Level-11 Automorphic Structure | Q(sqrt(17)) error | retracted |
| 6761981 | Arithmetic of Dehn Filling Slopes (v1) | superseded | 6689898 |
| 6754501 | Lucas Numbers Geodesic Spectrum (May v1) | Binet error | v4 (in repo) |
| 6689898 | Arithmetic of Dehn Filling Slopes (v2) | superseded | v4 Lucas |
| 6670778 | Universal Spectral Phase Transition | superseded | 6761978 |
| 6670398 | Dark Sector Conjectures | speculative | abstract pending |
| 6660598 | Lucas Sequence as Arithmetic Bridge | superseded | v4 Lucas |

---

## CORRECTIONS REQUIRED

### CORRECTION 1: Q(sqrt(17)) as CKM trace field — RETRACTED
- Real quadratic fields cannot be invariant trace fields of arithmetic Kleinian groups
- Retracted in: 6840322 (Galois-Gauge)
- **Still live in: 6775158** (Comprehensive Account) — needs correction note
- Removed papers affected: 6815721 (correctly removed)

### CORRECTION 2: sigma_opt = (3/2)log(phi) — WRONG
- Correct value: sigma_opt = (3/2)log(sqrt(13/5)) = (3/4)log(13/5) = 0.71663...
- Previous value: (3/2)log(phi) = 0.72182... (0.72% error)
- Structural formula: sigma_opt = (3/2)log(sqrt(N_slope/|H_1|)) = (3/2)log(sqrt(13/5))
- Retracted in: 6840322 (Galois-Gauge)
- **Still live in: 6775158** (Comprehensive Account) — needs correction note
- Impact: PMNS fitness 0.005087 was computed with wrong sigma; recompute for new papers

### CORRECTION 3: Binet bifurcation — L_k = phi^k+phi^{-k} only for EVEN k
- For ODD k: phi^k+phi^{-k} = sqrt(5)*F_k (Fibonacci), NOT L_k
- Corrected in: gentry_lucas_structure_v4.tex (now in repo, committed this session)
- Removed papers affected: 6754501, 6689898 (both removed, no live action needed)
- v4 also corrects Q(sqrt(-3)) error: cusped m003 field is Q(sqrt(-3)),
  but closed M_PMNS=m003(-2,3) has DIFFERENT trace field k(Gamma)=Q[x]/(x^4+x^3-1), disc -283

### CORRECTION 4: Lucas universality statistical evidence — WEAKENED
- Monte Carlo tests show only 1 significant result out of multiple tests
- Universal spectral gap conjecture FALSIFIED by Z/47 counterexample
- Acknowledged: June 2026 note added to live paper 6761978 — no further action

### CORRECTION 5: Prime 13 predicted to activate at degree>=7 — SUPERSEDED
- Later version (6689898) already showed 13 did not appear through degree 9
- Both papers removed — no live action needed

---

## PAPERS SECURED THIS SESSION

### gentry_lucas_structure_v4.tex
- Contains: Binet bifurcation lemma, corrected trace bridge, unconditional field obstruction
- k(Gamma)=Q[x]/(x^4+x^3-1), disc -283, NO proper subfields including Q(sqrt(5))
- Odd-k geodesics arithmetically FORBIDDEN
- Status: NOW IN REPO (committed to lucas-v2-bifurcation-correction, merged to main)
- SSRN action: resubmit to replace REMOVED 6854378

### gentry-mu-function-v2.tex
- Contains: mu_{m019}(12)=283=|disc(tau_{m019})|; mu_{m019}(5)=3=|disc(tau_{m003})|
- New arithmetic invariant of pair (M, Z[omega])
- Status: NOW IN REPO (committed this session)
- SSRN action: resubmit to replace REMOVED 6848478

---

## NEW RESULTS NOT YET ON SSRN

### gentry_z5_bridge.tex (2026-06-13)
- Z/5 bridge from Farey covering towers to X_0(11) via rational torsion
- General law: a_p ≡ p+1 (mod 5) for every good prime p (proved, not just observed)
- Extended verification: k=60, 30 prime cover-levels, p_k up to 18,301, zero exceptions
- Substack post published (this session)
- SSRN action: submit before any journal submission

### gentry-galois-gauge-v4.tex (2026-06-01)
- Galois groups of cusp shapes = Weyl groups of SU(2), SU(3), SU(4)
- v4 with Annales de l'Institut Fourier rejection incorporated
- Status: Downloads only — needs to be copied to repo

### gentry_hfg_arithmetic_v2.tex (2026-06-11)
- Newer than repo's gentry-hfg-arithmetic.tex
- Status: Downloads only — needs to be copied to repo

---

## KEY OPEN QUESTIONS (research level)

1. Proving vol(m019)=3*v_0 and vol(m178)=4*v_0 analytically (currently numerical to 10 sig figs)
2. Proving D(w^3)=v_0 algebraically where w is root of x^4-x-1=0
3. Physical interpretation of L'(E_1/K,1)=0.4172 and period Omega=17.50
4. Whether Q(sqrt(17)) can be REPLACED by a correct CKM-side base field for the X_0(11) bridge
5. Mechanism for why level 8773=283*31 has new cuspidal dim=3 with eigenvalue field Q(sqrt(5))
   (falsified as general pattern at p_3=61 and p_5=151; still unexplained for p_2=31 specifically)
6. Completing the SSRN submission of the three papers above before any journal submission

---

## IMMEDIATE ACTION LIST

1. [ ] Get 6670398 (Dark Sector) abstract from HFG_conjectures_formal.tex
2. [ ] Add correction note to SSRN 6775158 (Comprehensive Account):
       - Retract Q(sqrt(17)) claim
       - Correct sigma_opt to (3/2)log(sqrt(13/5))
3. [ ] Submit gentry_z5_bridge.tex to SSRN
4. [ ] Resubmit gentry_lucas_structure_v4.tex to SSRN (replaces 6854378)
5. [ ] Resubmit gentry-mu-function-v2.tex to SSRN (replaces 6848478)
6. [ ] Formally submit 6876278 (Sextic-Octic, currently PRELIMINARY_UPLOAD)
7. [ ] Copy gentry-galois-gauge-v4.tex to repo and commit
8. [ ] Copy gentry_hfg_arithmetic_v2.tex to repo and commit
9. [ ] Update hyperbolicflavorgeometry.org index.html with Z/5 Bridge result

---

## FILES IN REPO (as of this session)
Repo: C:\dev\hyperbolic-flavor-geometry
Branch: main (after merge from lucas-v2-bifurcation-correction)
Last commit: c3f3739 — "Add Lucas structure v4 (Binet bifurcation + unconditional
field obstruction) and mu-function v2 from Downloads - both missing from repo"

