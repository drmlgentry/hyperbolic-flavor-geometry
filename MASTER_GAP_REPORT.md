# CORE_MASTER Gap Report

Generated 2026-07-29. Compares `hyperbolic-flavor-geometry/papers/07_core_master/CORE_MASTER_v12.tex`
(current section structure below) against the abstract/opening claim of each of the other 43 distinct
paper titles found in `hyperbolic-flavor-geometry/papers/`. No content was rewritten or merged — this is
a map only.

## CORE_MASTER_v12 section structure (for reference)

1. Introduction
2. Geometric foundation: the golden ratio lattice
3. Methods (encoding, discrete lattice hypothesis, bounded scan, uncertainties, null tests, reproducibility)
4. Mass clustering results (null test outcomes, neutrino mass prediction — speculative)
5. Extension to mixing and CP violation (geodesic axes, flat U(1) CP phases, chirality/charge conjugation)
6. Spectral gap of the underlying manifolds
7. The Lucas Structure: Arithmetic Unification
8. Covering tower and lepton–quark asymmetry (incl. Alexander polynomial, Weeks manifold subsection)
9. Homological origin of CP suppression in the CKM sector
10. Statistical validation: Haar-random unitary null tests (incl. qubit structure, σ=log φ)
11. New geometric results (May 2026): surgery formula, Eisenstein cusp, Farey tower prime formula, volume adjacency
12. Discussion (established / not claimed / falsifiability / interpretive caution)
13. Cosmological Implications
14. Conclusion

## Headline finding

CORE_MASTER_v12 §8 ("The Weeks manifold and the Dehn surgery hierarchy") **already states the correct
Meyerhoff/Weeks distinction** precisely and correctly — volume hierarchy, homology reduction, everything
right. It never propagated to `results.json` R-001, the monograph, or the video narration scripts, all of
which had the wrong claim until fixed earlier in this session. This is the clearest concrete case of the
"lost findings" pattern: the correct result already existed, just not in the documents that needed it.

## Gap table

| Finding / claim (source paper) | In CORE_MASTER_v12? |
|---|---|
| CKM matrix from real trace field K=Q(√17), discriminant 68, explains CP suppression directly *(Quark Mixing from Hyperbolic Geometry, both CKM titles)* | **SUPERSEDED, not restated** — §9 uses a homology-based CP-suppression mechanism instead; the real-trace-field/discriminant-68 explanation isn't mentioned in v12 |
| Cusp shape = Eisenstein unit, surgery formula \|H₁(m003(p,q))\|=5\|2p+q\| *(Hyperbolic Flavor Geometry: Mixing, CP Violation, Fermion Masses)* | §11 "Surgery formula (theorem)" — **IN MASTER** |
| PMNS via Borel/Iwasawa KAN decomposition; symmetric-overlap impossibility theorem, Frobenius floor 0.300 *(Lepton Mixing from Borel Structure)* | §5 "Mixing from geodesic axes" exists but is brief — **the specific Borel/KAN theorem and 0.300 floor are NOT clearly restated** |
| CP phases as flat U(1) holonomy invariants; orientation-reversing isometry ⇒ complex conjugation *(Geometric Origin of CP Phases)* | §5 "CP violation from flat U(1) connections" — **IN MASTER** |
| Homology-resolved spectral floor invariant, complete census to word length 12 *(Homology Class Asymmetry...)* | Related to §9 but this specific extreme-value/spectral-floor construction and length-12 census — **NOT CLEARLY IN MASTER** |
| δ = 195.91° formula (twist angles aaB, baa), 0.55% vs PDG *(CP Violation from Twist Angles...Parameter-Free Prediction)* | §5 CP section — **IN MASTER** (this is the headline result used throughout the video presentation) |
| Farey tower quadratic cover prime formula, prime dictionary *(A Quadratic Cover Prime Formula for a Farey Tower)* | §11 "Farey tower cover prime formula (computational theorem)" — **IN MASTER** |
| Mixing matrices as overlap operators between boundary-localized Hilbert-space sectors; uniqueness up to rephasing *(Discrete Mixing Operators from Boundary Sector Geometry)* | Different theoretical framework entirely (boundary/Hilbert-space vs. geodesic-axis) — **NOT IN MASTER** |
| Qubit rotation gates from holonomy; Borel construction reproduces PMNS exactly, fitness=0.01897 *(Topologically Protected Qubit Gate Configurations / Ising Anyons...)* | §10 mentions qubit structure/σ=log φ but the specific topological-qubit-gate/anyon framing — **NOT CLEARLY IN MASTER** |
| Lepton mass ratios as BPS states of Class S theory on X₀(11) at Eisenstein point *(Lepton Masses as BPS States)* | Entirely separate SUSY gauge-theory framework — **NOT IN MASTER** |
| Galois-Weyl correspondence: cusp-shape Galois groups = Weyl groups of SU(2)/SU(3)(/SU(4)) *(Galois Groups of Cusp Shapes / The Galois-Gauge Correspondence)* | **NOT IN MASTER** — no Galois/Weyl section exists in v12, despite this being one of the most-cited results in the video presentation script |
| WRT invariant exact formula \|WRT(M)\|²=13/r *(Arithmetic Invariants..., The Slope Norm Theorem, The Gauss Polynomial...)* | **NOT IN MASTER** — no WRT/Witten-Reshetikhin-Turaev section in v12 |
| μ(n) Eisenstein norm function for Dehn surgery, self-encoding of cusp discriminants *(A Minimum Eisenstein Norm Function)* | §11 "Eisenstein cusp (theorem)" is related but the μ(n) construction itself — **NOT CLEARLY IN MASTER** |
| Sextic-octic factorization of Meyerhoff shape polynomial as field norm *(The Sextic-Octic Decomposition)* | **NOT IN MASTER** |
| X₀(11) base change to Q(√-3)/Q(√-59); Bianchi/Hilbert modular form bridge *(A Common Arithmetic Origin for PMNS and CKM, Arithmetic Invariants...X₀(11) Bridge)* | **NOT IN MASTER** — referenced in the video presentation ("Arithmetic Bridges: X₀(11) → Bianchi newform → Meyerhoff") but not in v12's section list |
| Z/5 bridge: covering towers ↔ X₀(11) rational torsion ↔ Hecke eigenvalues *(The Z/5 Bridge)* | §7 (Lucas Structure) / §8 (Covering tower) are adjacent but this specific modular-curve/Hecke connection — **NOT CLEARLY IN MASTER** |
| Neutrino masses: unique triple (q₁,q₂,q₃)=(-149,-146,-134), χ²=0.58 *(Neutrino Masses from Golden Ratio Lattice)* | §4 "Neutrino mass prediction (speculative)" — **LIKELY IN MASTER**, exact numbers not independently confirmed here |
| Weeks/Meyerhoff Dehn surgery hierarchy, correct distinction *(The Weeks Manifold, Dehn Surgery, and the Lepton Sector)* | §8 "The Weeks manifold and the Dehn surgery hierarchy" — **IN MASTER, confirmed correct** (see headline finding above) |
| Prime dictionary {2,3,5,7,11,13,29} from covering tower slopes *(Arithmetic of Dehn Filling Slopes)* | §8 "Covering tower and lepton-quark asymmetry" — **LIKELY IN MASTER** |
| Lucas-geodesic bridge; correction: Lucas for even k, √5·Fibonacci for odd k (v3/v4 fix an earlier "=Lₖ for all k" error) *(Lucas Numbers in the Geodesic Length Spectrum, v1/v3/v4)* | §7 "The Lucas Structure" — section exists, but **NEEDS VERIFICATION that v12 has the v3/v4 parity correction and not the earlier erroneous version** |
| Golden ratio lattice in COF non-radiative decay rates *(materials-science extension)* | Out of scope for HFG proper — **NOT IN MASTER** (expected; different physical domain) |
| Alexander polynomial of (-2,3,7) pretzel knot, Mahler measure = regulator *(The Alexander Polynomial...)* | §8 "Alexander polynomial and the golden ratio" — **IN MASTER** |
| Three rigidity properties of logarithmic weight spectra (abstract lattice-action theorems) *(Three Rigidity Properties...)* | **NOT IN MASTER** |
| GW peak frequency quantization / dark matter mass conjecture *(Golden Ratio Quantisation of GW Peak Frequencies)* | §13 "Cosmological Implications" exists but this specific GW-freeze-in conjecture — **NOT CLEARLY IN MASTER** |
| Two-tier universal geodesic spectrum in Dehn fillings of m003/m006 *(A Universal Spectral Phase Transition / Two-Tier Geodesic Spectrum Structure)* | §6 "Spectral gap" is adjacent but this specific universality-scan result — **NOT CLEARLY IN MASTER** |
| Charge conjugation = orientation reversal, confirmed chirality via Chern-Simons sign *(Charge Conjugation as Orientation Reversal)* | §5 "Chirality and charge conjugation" — **IN MASTER** |
| 134-manifold census, ITF signature (8,1) selection criterion, no fitting *(Quark Mixing from an Arithmetically Selected Hyperbolic 3-Manifold)* | Likely in §1/§2 selection narrative — **LIKELY IN MASTER**, specific "134" figure not independently confirmed here |
| EFT feasibility analysis, spectrum obstruction for logarithmic mass lattice *(Uniqueness-First EFT Realization)* | §3 "Methods...discrete lattice hypothesis" is adjacent but this EFT-specific feasibility/obstruction analysis — **NOT CLEARLY IN MASTER** |
| Three conjectures: dark matter as non-Lucas primes, matter/dark-energy transition, information geometry *(HFG: Conjectures on Dark Sector, Dark Energy)* | §13 "Cosmological Implications" exists but these specific three conjectures — **NOT CLEARLY IN MASTER, needs verification** |
| Frobenius discriminant forces p=31 as tower prime; Bianchi descent, character variety theorems *(Frobenius Discriminant, Bianchi Descent, and the Character Variety)* | **NOT IN MASTER** — this proves the "31-exception" claim referenced elsewhere in the programme's own reasoning, but the theorem itself isn't in v12 |
| Scale-free quadratic forms ≅ symmetric space SL(n,R)/SO(n) *(Scale-Free Quadratic Forms, Symmetric Space Geometry)* | Foundational/background math, not tied to a specific v12 section — **NOT IN MASTER** |

## Notes on method

- "IN MASTER" = the corresponding section exists and its title/content clearly matches the paper's claim.
- "NOT CLEARLY IN MASTER" = an adjacent section exists but the specific theorem, number, or construction from
  the paper isn't verifiably restated there from the section headers alone — would need a full-text check to
  confirm, not just headers.
- "NOT IN MASTER" = no corresponding section exists at all in v12's structure.
- Several papers share findings (e.g., the four separate WRT-invariant papers, the three Lucas-structure
  versions, the two qubit-gate papers) — those are noted once per underlying finding, not once per file.

## Correction log

**2026-07-29 — MATHEMATICAL ERROR — §7 Lucas Structure:**
CORE_MASTER_v12 states `|tr(γ)| = L_k` for all k. This is incorrect for odd k.
Correct formula: `L_k` for even k, `√5·F_k` for odd k.
Follows from Binet's formula since φ⁻¹ = −ψ (verified numerically: k=1 gives φ+φ⁻¹=2.236..=√5·F₁,
not L₁=1; k=3 gives 4.472..=√5·F₃, not L₃=4; discrepancy is exact, not a rounding artifact).
Source of correct formula: `gentry_lucas_structure` v3/v4 (papers/lucas-structure/).
Fix needed before any submission citing this theorem.
Checked whether the error has propagated into active submissions: `01_active_plb/` and
`02_active_npb_ptep/` only cite specific integers as Lucas numbers (11=L₅, 199=L₁₁, etc. — torsion-prime
facts) and do not state the general blanket formula, so the error is currently confined to
CORE_MASTER_v12 and has not propagated into active submissions.
Discovered: July 2026. Verified numerically.
