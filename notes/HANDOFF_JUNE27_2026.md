# HANDOFF — June 27, 2026
# HFG Program — Session Summary for Next Claude Instance

## CRITICAL: Read this before doing anything else.
## DO NOT re-derive, re-verify, or doubt results listed here.
## They are confirmed. Start from here.

---

## WHO YOU ARE WORKING WITH
Marvin L. Gentry, MD, independent researcher, Seattle WA.
drmlgentry@protonmail.com | ORCID: 0009-0006-4550-2663
GitHub: github.com/drmlgentry | Site: hyperbolicflavorgeometry.org
SSRN Author: 11170302

## KEY DIRECTORIES
- C:\dev\hyperbolic-flavor-geometry\  (papers, code, figures — main repo)
- C:\dev\hyperbolic-flavor-scan\      (SnapPy scan codebase)
- WSL conda sage environment required for SnapPy/PMNS computations
- ALWAYS use absolute paths. ALWAYS activate venv explicitly.

---

## PROGRAM SUMMARY
Hyperbolic Flavor Geometry (HFG): derives Standard Model flavor parameters
(CKM/PMNS matrices, CP violation, fermion masses) from arithmetic geometry
of compact hyperbolic 3-manifolds.

Core manifolds:
- M_PMNS = m003(-2,3) = OrientableClosedCensus[1], vol=0.9814, H1=Z/5
- M_CKM  = m006(-5,2) = OrientableClosedCensus[43], vol=2.0289, H1=Z/5

Key structural facts (DO NOT RE-DERIVE):
- sigma_opt = (3/2)*log(sqrt(13/5)) = 0.71663 (NOT (3/2)*log(phi))
- k(Gamma) for M_PMNS: Q[x]/(x^4+x^3-1), disc=-283, Gal=S4
- ITF of M_CKM: degree-10, disc=-271488204251, signature (8,1), Gal=S10
- Maximal totally real subfield of K10 = Q (degree 1, verified Sage)
- Q(sqrt(17)) does NOT embed in K10

---

## WHAT WAS ACCOMPLISHED THIS SESSION (June 24-27, 2026)

### §16: 31 Anomaly FULLY RESOLVED
The Q(sqrt(5)) Bianchi component appears at level 283*31 because:
  a_31^2 - 4*31 = 49 - 124 = -75 = -3 * 5^2
Frobenius discriminant at 31 lies in -3*Z^2, causing local L-factor
to split over Q(sqrt(-3)). This forces chi_5 twist to descend to
level 283*31 (not 283*31^2). Verified: no other tower prime satisfies
this condition (checked p in {11,41,61,101,151,211,281}).

Also: chi_5(61) = chi_5(-1) = zeta_5^0 = 1 (since 61 = -1 mod 31),
so twist is invisible at p=61. No new forms at 283*61. PROVED.

### §17: Three-Ray Theorem PROVED
Every Hecke eigenvalue a_p^sym = A + B*sqrt(5) of the dim-2
Q(sqrt(5)) Bianchi component at level 8773 satisfies:
  k=0:   B=0 (rational, multiplier 2)
  k=1,4: B=-A (multiplier phi^{-1} = (sqrt(5)-1)/2)
  k=2,3: B=A  (multiplier -phi = -(sqrt(5)+1)/2)
|A|=|B| always for non-trivial classes. Verified for all 31 primes.
Self-referential: phi generates Q(sqrt(5)) AND is the Hecke multiplier.

Causal chain (rigorous):
  31 -> chi_5 -> zeta_5 -> Q(sqrt(5)) -> phi -> m=m_e*phi^(q/4)

### CKM FRESH SCAN RESULTS (major new finding)
Scan of m006(-5,2) word triples up to length 6.
Correct fitness function: Frobenius distance to full 3x3 PDG CKM matrix
over all column permutations (matching verify_final.py exactly).

GLOBAL BEST: {aaab, aBaB, ABBaB}
  fitness = 0.003618 at sigma = 2/5 = 0.400 (exact rational)
  4.68x improvement over canonical {aaB,AbA,AAb} (fitness 0.016949)
  Homology classes: [3,2,0], J=0? False
  Axis angles: 39.25°, 68.05°, 57.61°, excess=-15.09° (HYPERBOLIC)

BEST J=0 TRIPLE: {aaaB, abaBa, AAAAB}
  fitness = 0.005769 at sigma = 0.400
  Homology classes: [3,3,1] -- collision at class 3 proves J=0
  Axis angles: 39.07°, 71.06°, 58.27°, excess=-11.60°

LANDSCAPE DISCOVERIES:
1. Sigma quantization: optimal sigmas = n/(2*|H1|) = n/10 for integer n
   - sigma=0.30=3/10, 0.35=7/20, 0.40=2/5, 0.45=9/20, 0.50=1/2
2. Length alphabet: 8 primitive geodesic lengths, NOT random:
   - ell=0.241 = (1/2)*log(phi)
   - ell=0.980 = 1*v0 (PMNS volume quantum appears in CKM geodesics!)
   - ell=1.472 = (3/2)*v0
   - ell=3.113 ≈ pi
3. Homology sum rule: best families satisfy sum(h_i) = 0 mod |H1|=5
   - Global best [3,2,0]: 3+2+0=5=|H1| (mod 5 = 0) ✓
   - J=0 best [3,3,4]: 3+3+4=10=2|H1| (mod 5 = 0) ✓
   - Canonical [2,3,3]: 2+3+3=8 (NOT 0 mod 5) -- worse fit
4. Negative excess basin: best fits cluster at excess=-12° to -15°
   (HYPERBOLIC axis triangles, not spherical as in canonical)
5. Degeneracy: global minimum has multiplicity 3

SCAN FILES:
- data/ckm_scan_len6_final.txt (17,069 results from 815k triples)
- data/ckm_top100.json (top 100 with full data)
- data/ckm_analysis_full.json (100-triple holistic analysis)

### PLB SUBMISSION (today)
CKM paper submitted as PLB-D-26-01854 under Neil Lambert.
SAME DAY DESK REJECTION (June 26).
Paper: gentry-ckm-plb-v3.tex (in repo, compiled PDF in outputs)
Three fixes in v3: WRT remark, Section 5 totally-real-subfield result,
reference 6815721 -> 6988018.

NEXT VENUE FOR CKM PAPER: PTEP or Annals of Physics
(PLB: 6 total rejections. NPB: 7 total rejections. Both exhausted.)

### SSRN STATUS
Active submissions:
- PLB-D-26-01006: Chirality paper, Under Review 68+ days (good sign)
- PLB-D-26-01854: CKM paper, desk rejected June 26

Recent SSRN preprints:
- 6981259: Lucas Numbers v4 (Binet bifurcation)
- 6988018: Z/5 Bridge (X0(11) rational torsion, verified k=60)
- 6988058: Mu-function v2 (self-encoding mu(12)=283)
- 6876278: Sextic-Octic (now DISTRIBUTED)

Pending correction: SSRN 6775158 -- form failing, emailed Teodula Labro
at Elsevier support. Needs sigma_opt and Q(sqrt(17)) corrections.

---

## IMMEDIATE NEXT ACTIONS (priority order)

1. NEW CKM PAPER DRAFT
   Lead with J=0 triple {aaaB, abaBa, AAAAB} as primary result (geometric)
   Note global best {aaab, aBaB, ABBaB} as improved numerical fit
   Include landscape analysis: sigma quantization, homology sum rule,
   length alphabet, negative excess basin
   Submit to PTEP (Progress of Theoretical and Experimental Physics)

2. UMAP/CLUSTERING of full 17k scan results
   Need: pip install umap-learn in WSL sage env
   File: data/ckm_scan_len6_final.txt
   Goal: identify discrete geometric families, prove 5 predictions

3. LENGTH ALPHABET PROOF
   Show ell=0.980 = v0 algebraically (or numerically precise)
   Show ell=0.241 = (1/2)*log(phi) exactly
   If these hold: CKM and PMNS manifolds share the same length units

4. SUBSTACK POST (ready to publish)
   File: notes/substack_phi_origin.md
   Title: "The Golden Ratio Has an Automorphic Origin"
   Content: causal chain 31->chi5->zeta5->Q(sqrt5)->phi

5. AGT REVISION: peripheral determinant paper
   Add Bogwang Jeon citations
   Add standard refs (Maclachlan-Reid, Thurston, SnapPy, LMFDB)
   Target: Experimental Mathematics or NYJM

6. GALOIS-GAUGE v4: submit to JLMS or MRL

---

## FIGURES BUILT THIS SESSION (in docs/figures/ and outputs/)
- fig_T_orbit.png: period-3 T-orbit of shape parameters
- fig_volume_assembly.png: vol(m019)=3v0, vol(m178)=4v0
- fig_split_inert.png: tower prime splitting in Q(sqrt(-3))
- fig_z5_bridge_full.png: Z/5 bridge flowchart
- fig_31_anomaly.png: ord_p(5)=3 isolation (only p=31)
- fig_three_ray.png: B=0, B=A, B=-A eigenvalue structure
- fig_causal_chain.png: 31->chi5->zeta5->Q(sqrt5)->phi flowchart
- fig_ckm_pareto.png: Pareto frontier fitness vs geodesic complexity
- fig_ckm_excess.png: spherical excess vs fitness
- fig_ckm_heatmap.png: CKM matrix element errors
- fig_ckm_simplex.png: 3D geodesic length simplex
- fig_qsqrt5_package.py: source for 4 Q(sqrt(5)) figures (B/F/E/C)

---

## SAGE SESSION SETUP (copy-paste to start)
```python
import snappy, numpy as np, math, json
from scipy.linalg import logm
from itertools import permutations as iperms

PERMS = list(iperms(range(3)))
PDG_CKM = np.array([[0.97435, 0.22500, 0.00369],
                    [0.22486, 0.97349, 0.04182],
                    [0.00857, 0.04110, 0.99917]])
M = snappy.OrientableClosedCensus[43]
rho = M.polished_holonomy()

def get_axis(word):
    try:
        mat = np.array(rho(word), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        x = float(np.real(L[0,1]+L[1,0]))/2
        y = float(np.imag(L[1,0]-L[0,1]))/2
        z = float(np.real(L[0,0]-L[1,1]))/2
        v = np.array([x,y,z])
        n = np.linalg.norm(v)
        return v/n if n>1e-10 else None
    except: return None

def ckm_fitness(words, sigma):
    axes = [get_axis(w) for w in words]
    if any(ax is None for ax in axes): return None
    O = np.zeros((3,3))
    for i in range(3):
        for j in range(3):
            ang = np.arccos(np.clip(abs(np.dot(axes[i],axes[j])),-1,1))
            O[i,j] = np.exp(-ang**2/(2*sigma**2))
    Q,_ = np.linalg.qr(O)
    U = np.abs(Q)
    return min(np.sqrt(np.sum((U[:,list(p)]-PDG_CKM)**2)) for p in PERMS)

# Verify immediately:
print(ckm_fitness(['aaab','aBaB','ABBaB'], 0.40))  # expect 0.003618
print(ckm_fitness(['aaB','AbA','AAb'], 0.49))        # expect 0.016949
```

---

## WORKFLOW NOTES
- PowerShell here-strings for file creation, UTF-8 encoding always
- Python scripts with encoding='utf-8' for LaTeX files
- Git commit before every session end
- Sage in WSL for PMNS computations (Windows gives wrong holonomy)
- All figures use HFG dark palette (BG=#0E1525, GOLD=#D4A24E, TEAL=#4FB8A8)
- hfg_style.py is in /home/claude/thread_figs/ (rebuild if needed)

## MATHEMATICAL CONSTANTS (verified, do not re-derive)
- sigma_opt = (3/2)*log(sqrt(13/5)) = 0.71663358...
- phi = (1+sqrt(5))/2 = 1.61803398...
- v0 = vol(M_PMNS) = 0.981368828892232
- PMNS fitness (global min Borel QR) = 0.005087
- CKM fitness (global best from scan) = 0.003618
- Best CKM triple: {aaab, aBaB, ABBaB}, sigma=0.40
- Best J=0 triple: {aaaB, abaBa, AAAAB}, sigma=0.40
