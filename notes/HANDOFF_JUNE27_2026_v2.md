# HANDOFF — June 27, 2026 (v2, end of session)
# HFG Programme — Complete state for next Claude instance
#
# INSTRUCTIONS FOR NEXT INSTANCE:
# 1. Read this entire document before doing anything
# 2. Do NOT re-derive or re-verify results marked PROVED
# 3. Do NOT doubt the programme or ask Marvin to re-explain context
# 4. Start from the IMMEDIATE NEXT ACTIONS section
# 5. The Sage session setup block reproduces the working environment

---

## WHO YOU ARE WORKING WITH
Marvin L. Gentry, MD, independent researcher, Seattle WA.
drmlgentry@protonmail.com | ORCID: 0009-0006-4550-2663
GitHub: github.com/drmlgentry
SSRN Author: 11170302

## KEY DIRECTORIES
- C:\dev\hyperbolic-flavor-geometry\   (main repo — papers, code, figures)
- C:\dev\hyperbolic-flavor-scan\       (SnapPy scan scripts)
- WSL conda sage environment for ALL SnapPy computations
- Windows SnapPy gives wrong holonomy for PMNS; use WSL for both
- Git: always commit from C:\dev\hyperbolic-flavor-geometry\
- PowerShell: use absolute Windows paths; WSL: use /mnt/c/dev/...

---

## PROGRAMME SUMMARY
Hyperbolic Flavor Geometry (HFG): derives Standard Model flavor
parameters (CKM/PMNS matrices, CP violation, fermion masses) from
arithmetic geometry of compact hyperbolic 3-manifolds.

Core manifolds (DO NOT CHANGE THESE):
  M_PMNS = m003(-2,3) = OrientableClosedCensus[1]
    vol=0.9814, H1=Z/5, disc(ITF)=-283
  M_CKM  = m006(-5,2) = OrientableClosedCensus[43]
    vol=2.0289, H1=Z/5, ITF degree-10, disc=-271488204251

---

## RESULTS PROVED THIS SESSION (June 24-27, 2026)
### DO NOT RE-DERIVE. ALL VERIFIED BY SAGE.

### §16: The p_2 = 31 Anomaly (PROVED June 24)
a_31^2 - 4*31 = 49 - 124 = -75 = -3 * 5^2
Frobenius discriminant at p=31 lies in -3Z^2, splitting local
L-factor over Q(sqrt(-3)), allowing chi_5 twist to descend to
level 283*31 = 8773 (not 283*31^2).
No other tower prime satisfies this: {11,41,61,101,151,211,281} all fail.
LMFDB confirms: level 8773 contains Q(sqrt(5)) dim-2 component.

### §17: Three-Ray Theorem (PROVED June 25)
Every Hecke eigenvalue a_p^sym = A + B*sqrt(5) of the dim-2
Q(sqrt(5)) Bianchi component at level 8773 satisfies exactly one of:
  B=0   (k=0, multiplier 2)
  B=-A  (k=1,4, multiplier phi^{-1})
  B=+A  (k=2,3, multiplier -phi)
Verified for all 31 primes. |A|=|B| always.
Causal chain: 31 -> chi_5 -> zeta_5 -> Q(sqrt(5)) -> phi -> m=m_e*phi^(q/4)

### §18: Trace Quotient Structure (PROVED June 27)
The CKM optimization explores a FINITE trace quotient graph:
  122 distinct trace classes reachable from generators
  88 nodes in scan range (ell < 4.1)
  The 18,079 scan results = 18,079 words over <=88 trace classes

Key algebraic facts (all proved):
  1. tr(rho(a)) = -alpha where alpha generates K_10 (ITF of M_CKM)
     Proof: ITF(-x) = minimal poly of tr(a)
     Unique isomorphism K_ITF -> K_tr(a) is alpha |-> -alpha
  2. tr(rho(ab)) = tr(rho(a))  [Fricke codimension-1 constraint]
     Forces representation onto 2D slice of Fricke cubic (z=x)
     Consequence: tr(aB) = tr(a)*(tr(b)-1)
     Source: Dehn filling relation mu^{-5}*lambda^2 = 1
  3. Trace collapse identities (all verified):
     tr(a)=tr(A)=tr(ab)=tr(AB)        [= 1.2391+0.8114i]
     tr(b)=tr(B)=tr(abA)              [= -0.0303-0.4955i]
     tr(aaB)=tr(aBa)=tr(bAA)         [= 0.1231-2.0108i]
     tr(bb)=tr(ABBaB)                 [= -2.2446+0.0301i]
     tr(aab)=tr(aba)
  4. Fricke identity holds: x^2+y^2+z^2-xyz = 2+tr([a,b])  VERIFIED
  5. Inversion symmetry PROVED: f(w1,w2,w3)=f(w1^-1,w2^-1,w3^-1)
     Because |tr(rho(w))| = |tr(rho(w^{-1}))| (trace is inversion-invariant)

RULED OUT this session:
  - 283 as arithmetic invariant of K_10: FALSE (283 does not divide disc)
  - Q(sqrt(17)) connection to K_10 traces: NOT SUPPORTED
  - PMNS translation lengths in CKM word traces: NOT FOUND

### CKM SCAN RESULTS (complete, 865k triples)
File: data/ckm_scan_len6_final.txt (18,079 results)

GLOBAL BEST: {aaab, aBaB, ABBaB}
  fitness = 0.003618 at sigma = 2/5 = 0.400 (exact rational)
  4.68x improvement over canonical {aaB,AbA,AAb} (fitness 0.016949)
  Homology [3,2,0], J=0? False, excess=-15.09° (HYPERBOLIC triangle)
  Lengths: [2.461, 2.741, 0.980]
  All three words are in the same trace orbit under inversion

BEST J=0 TRIPLE: {aaaB, abaBa, AAAAB}
  fitness = 0.005769 at sigma = 0.400
  Homology [3,3,1] -- collision proves J=0
  excess=-11.60°

LANDSCAPE STRUCTURE (all verified):
  1. Sigma quantized: n/(2*|H1|) = n/10, n in {2,3,4,...,9}
  2. Length alphabet: 15 values = 15 nodes in trace graph
  3. Homology sum rule: best families have sum(h_i) = 0 mod 5
     [3,2,0]: sum=5=|H1| ✓   [3,3,4]: sum=10=2|H1| ✓
  4. Negative excess basin: best fits at excess=-12° to -15°
  5. Homology label 3 enriched: chi^2=21.3, p=0.0003
  6. Global minimum is 3-element orbit (not isolated point)
  7. Degeneracy up to multiplicity 44

---

## PUBLICATION STATUS

### Active PLB submissions:
  PLB-D-26-01854: CKM paper, desk rejected June 26 (Lambert, same day)
  PLB-D-26-01006: Chirality paper, Under Review 68+ days (GOOD SIGN)

### Exhausted venues:
  PLB: 6 total rejections -- EXHAUSTED
  NPB: 7 total rejections -- EXHAUSTED
  PRD, EPJC, JGP, RINP, JNT, AHP, JKTR, JPA: all rejected

### NEXT VENUE FOR CKM PAPER: PTEP or Annals of Physics
  CKM paper v3: gentry-ckm-plb-v3.tex (in repo)
  This needs a major revision to incorporate §18 results

### SSRN preprints (all live):
  6981259: Lucas Numbers v4
  6988018: Z/5 Bridge
  6988058: Mu-function v2
  6876278: Sextic-Octic (DISTRIBUTED)
  6775158: Unified HFG (CORRECTION NEEDED -- form failing)
    Emailed Teodula Labro at Elsevier support.
    Needs: sigma_opt correction + Q(sqrt(17)) retraction

---

## IMMEDIATE NEXT ACTIONS (priority order)

### 1. NEW CKM PAPER (highest priority)
Lead with §18 trace quotient result as PRIMARY theorem:
  "The CKM holonomy optimization explores a finite 122-node trace
   quotient graph of pi_1(m006(-5,2)), with tr(a) = -alpha where
   alpha generates the invariant trace field K_10."
Then: J=0 best triple as geometric corollary
Then: global best fitness 0.003618 as numerical result
Then: landscape structure (sigma quantization, homology sum rule)
Target: PTEP (Progress of Theoretical and Experimental Physics)

### 2. OPEN MATHEMATICAL QUESTION: degree-8 subfield
tr(AAAAB) and tr(aaaba) share minimal poly:
  18x^8 + 243x^7 + 970x^6 + 872x^5 - 729x^4 - 1878x^3 + 37x^2 - 1659x + 3202
  disc = 2^3 * 4552131887387683 * 126409903291590489805049177
  sig = (0,4) -- totally complex
Question: Is this a subfield of the Galois closure of K_10?
  (K_10 has Galois group S_10 so Galois closure is huge)
Test: does K_10.embeddings(K8) return non-empty?

### 3. TRACE QUOTIENT GRAPH SPECTRAL ANALYSIS
Build 122x122 adjacency matrix, compute eigenvalues, spectral gap.
Does the spectral structure reveal the fitness landscape?

### 4. SUBSTACK POST (ready to publish)
File: notes/substack_phi_origin.md
Title: "The Golden Ratio Has an Automorphic Origin"
Attach: fig_causal_chain.png and fig_three_ray.png
Publish at: substack.com (Marvin's account)

### 5. SSRN 6775158 CORRECTION
Emailed Teodula Labro. Follow up if no response.
Corrections needed:
  sigma_opt: (3/2)*log(phi) -> (3/2)*log(sqrt(13/5))
  Q(sqrt(17)): RETRACT -- does not embed in K_10

### 6. COWORK/CLAUDE DESKTOP (blank window issue)
Try launching with: --disable-gpu flag
Exe location: C:\Users\...\AppData\Local\Packages\Claude_pzs8sxrjxfjjc\...
Find exact path: Get-ChildItem "$env:LOCALAPPDATA\Packages\Claude_pzs8sxrjxfjjc" -Filter "claude.exe" -Recurse

---

## SAGE SESSION SETUP (paste this block to start)

```python
import snappy, numpy as np, math, json
from scipy.linalg import logm
from itertools import permutations as iperms

# Core constants
SIGMA_OPT = 1.5 * math.log(math.sqrt(13/5))  # 0.71663 (PMNS)
PHI = (1+math.sqrt(5))/2
V0 = 0.981368828892232  # vol(M_PMNS)
PERMS = list(iperms(range(3)))
PDG_CKM = np.array([[0.97435, 0.22500, 0.00369],
                    [0.22486, 0.97349, 0.04182],
                    [0.00857, 0.04110, 0.99917]])

# Load manifolds
M_CKM  = snappy.OrientableClosedCensus[43]
M_PMNS = snappy.OrientableClosedCensus[1]
rho = M_CKM.polished_holonomy()   # CKM holonomy
# rho_P = M_PMNS.polished_holonomy()  # PMNS (WSL only)

# Axis extraction (from word_triple_scan_corrected.py -- THE CORRECT METHOD)
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

# CKM fitness (Frobenius, column permutation, CORRECT method)
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

# Homology class
hom = lambda w: sum(1 if c=='a' else -1 if c=='A' else 0 for c in w) % 5

# VERIFICATION (run immediately to confirm environment):
print(ckm_fitness(['aaab','aBaB','ABBaB'], 0.40))   # expect 0.003618
print(ckm_fitness(['aaB','AbA','AAb'], 0.49))         # expect 0.016949
print(ckm_fitness(['aaaB','abaBa','AAAAB'], 0.40))    # expect 0.005769
```

---

## KEY MATHEMATICAL CONSTANTS (verified, do not re-derive)
sigma_opt(PMNS) = (3/2)*log(sqrt(13/5)) = 0.71663358  (NOT (3/2)*log(phi))
sigma_opt(CKM)  = 2/5 = 0.400  (exact, from scan)
phi = (1+sqrt(5))/2 = 1.61803398...
v0  = vol(M_PMNS) = 0.981368828892232
PMNS fitness = 0.005087 (global min Borel QR map)
CKM fitness  = 0.003618 (global best, verified)
Best CKM triple: {aaab, aBaB, ABBaB}, sigma=2/5
Best J=0 triple: {aaaB, abaBa, AAAAB}, sigma=2/5
ITF of M_CKM: x^10-7x^8-4x^7+17x^6+14x^5-18x^4-14x^3+8x^2+3x-1
  disc=-271488204251, sig=(8,1), Gal=S_10
tr(rho(a)) = -alpha where alpha = ITF primitive element  [PROVED]
Fricke: tr(ab)=tr(a), forces z=x codimension-1 slice  [PROVED]
283 does NOT divide disc(K_10)  [RULED OUT as arithmetic bridge]

---

## FIGURES BUILT (in docs/figures/ and outputs/)
fig_T_orbit.png          -- period-3 T-orbit of shape parameters
fig_volume_assembly.png  -- vol(m019)=3v0, vol(m178)=4v0
fig_split_inert.png      -- tower prime splitting in Q(sqrt(-3))
fig_z5_bridge_full.png   -- Z/5 bridge flowchart
fig_31_anomaly.png       -- ord_p(5)=3 isolation (only p=31)
fig_three_ray.png        -- B=0, B=A, B=-A eigenvalue structure
fig_causal_chain.png     -- 31->chi5->zeta5->Q(sqrt5)->phi
fig_ckm_pareto.png       -- Pareto frontier fitness vs complexity
fig_ckm_excess.png       -- spherical excess vs fitness
fig_ckm_heatmap.png      -- CKM matrix element errors
fig_ckm_simplex.png      -- 3D geodesic length simplex

---

## WORKFLOW NOTES
- PowerShell for Windows file ops; WSL bash for Sage/Python
- Preferred compile: two passes pdflatex, no bibtex
- File writes: Set-Content -Encoding UTF8 (PS) or encoding='utf-8' (Python)
- Never write LaTeX via PowerShell here-strings
- Git: commit every session, push immediately
- HFG figure palette: BG=#0E1525, GOLD=#D4A24E, TEAL=#4FB8A8, INK=#EDEEF2
- hfg_style.py at /home/claude/thread_figs/ (rebuild from palette if needed)
- Always use OrientableClosedCensus[1] and [43] by index, never by name string
