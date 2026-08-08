# CORE_MASTER Gap Report

## Aug 6 2026 — Session updates

**Resolved this session:**
- Substack post "The Dual Surgery Identity" published and linked from `HFG_STATUS.md`
- Q-001 memory-heartbeat script fixed — was hardcoded to a stale PID (720, lost on a WSL reboot);
  now self-heals via `pgrep -f q001_primdec.sage` and relaunched against the current PID (703)
- Narration script + deck NOTES corrected "twenty-two preprints" → "twenty-one" (verified against
  live ORCID: 21 works currently listed) — **the printed `HFG_shoot_scripts_onepager.pdf` still
  says twenty-two**; say twenty-one when Slide 18 is actually shot on location
- `HFG_STATUS.md` SSRN table corrected: 6840418 confirmed still live on ORCID as of today
  (put-code 217382443, last-modified 2026-06-11, unchanged) — a "removed/confirmed" claim
  circulating this session was not accurate; 6845778/6775158's Aug 2 fixes also not yet reflected
  on the public ORCID record (last-modified 2026-07-29 for both)

**New gaps found this session:**
- `gentry-galois-gauge-v4.tex` has no mention of the CKM negative-result search (no "negative
  result," candidate manifold list, or slope bound anywhere in the file) — the result currently
  only lives in `CLAIMS_REGISTER.md` and the Substack post, not in the paper body itself
- 2TB drive (WD Elements, disk 5, GPT, stable) showing pre-failure SMART status, still needs a
  ddrescue clone before any recovery attempt. The candidate 4TB destination ("SSD SSD", disk 1)
  was ruled out Aug 6 2026: repeated Event ID 51 disk I/O errors on it, which got denser (not
  better) after a physical reseat on a different port/cable — points to the drive/enclosure
  itself failing, not a connection issue. Marvin is sourcing a different destination drive.
  Do not use disk 1 ("SSD SSD") as a clone destination.

**Still open, carried forward:**
- SU(2)_R factor of Pati-Salam unaddressed by any current result
- Class S / 3D-3D field-theoretic derivation: proposed, not proved
- Linear disjointness of K_m003/K_m019 with K_m006 not yet checked
- Q-001 (primary decomposition, WSL/Sage) still running — PID 703 (changed from 720 after a WSL
  reboot today), continuously alive ~7 hours since the reboot, resumed cleanly from its cached
  Groebner-basis checkpoint, still on "computing elimination ideal for x-coordinate," no new
  milestone since the last check
- Poincaré Disk Explorer: specced, not built — next session

---

## Aug 3 2026 — Session updates

**Resolved this session:**
- Publications section synced to ORCID (0009-0006-4550-2663), BPS paper omitted with note
- Full Substack archive (12 posts) added to the site — previously only 1 of 12 was linked
- m206 order-6 downgraded in 4 locations (3 on `index.html`, 4 on `article4.html`)
- `article4.html` correction banner added
- CKM search range corrected to |p|,|q| ≤ 15 — verified directly from
  `reproduce/dual_surgery_exploration.py`, not from memory or secondhand tracking notes
- `CLAIMS_REGISTER.md` created (see repo root)

**Still open, carried forward:**
- SU(2)_R factor of Pati-Salam unaddressed by any current result
- Class S / 3D-3D field-theoretic derivation: proposed, not proved
- Linear disjointness of K_m003/K_m019 with K_m006 not yet checked
- Q-001 (primary decomposition, WSL/Sage) still running — PID 720, ~223+ CPU-hours as of last check
- SSRN 6840418 removal: requested, not yet confirmed
- Poincaré Disk Explorer: specced, not built — next session
- CORE_MASTER_v12 still has no Galois-Weyl correspondence section (unchanged from the finding below)
- `HFG_STATUS.md` and this file were themselves stale before this update — worth a habit of
  updating them at the end of a working session, not just at the start of the next one

---

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

## Addendum — Aug 2–3 2026 findings (not covered by the July 29 comparison above)

CORE_MASTER_v12 was repurposed (per CLAUDE.md, July 15 decision) into a dedicated golden-ratio-mass-lattice paper and no longer covers the unified-framework ground at all, so **none** of the following are expected to be "in" it — this section is a record of what's new, not a gap against v12 specifically.

| Finding / claim | Status | Where documented |
|---|---|---|
| Dual surgery identity m003(−2,3) ≅ m019(2,1) ≅ M_PMNS | [Proved] | `class_s_verification.txt`, `CLAUDE.md`, `gentry-galois-gauge-v4.tex` |
| Galois closure of compositum = S₄ × ℤ/2 = Weyl(SU(4)) × Weyl(SU(2)_L) | [Proved] | Same three sources |
| CKM negative-result search bounds (no S₄ parent for M_CKM) | [Computed] — resolved Aug 3: |p|,|q| ≤ 15, 9 candidate manifolds, coprime pairs only, script-verified | `reproduce/dual_surgery_exploration.py` (now committed). Two other figures (≤12, ≤20) were circulating in the corpus and are both wrong. |
| Eisenstein-norm BPS mass ratio claims (muon/tau) | [Refuted as evidence] | `class_s_verification.txt`; SSRN 6840418 withdrawal requested but not yet reflected live |
| m206(1,2) "order-6 Eisenstein torsion" / complete torsion taxonomy | [Retracted] — H₁(m206(1,2))=ℤ/5, not order 6 | Fixed in `docs/index.html` (3 locations) and `docs/article4.html` (4 locations) Aug 3 2026; **not yet fixed** in the underlying `article4.html`-adjacent source data or any paper `.tex` that may assert it |
| ORCID/SSRN/Substack sync gaps | Website was out of sync with ORCID (missing 12 of 21 works, one stale SSRN number) and with the live Substack archive (11 of 12 posts unlinked) | Fixed on `docs/index.html` Aug 3 2026 |
| `HFG_STATUS.md` and this file's own staleness | Both had drifted from the day's actual work before this addendum | This edit |
| Two-tier universal geodesic spectrum in Dehn fillings of m003/m006 *(A Universal Spectral Phase Transition / Two-Tier Geodesic Spectrum Structure)* | §6 "Spectral gap" is adjacent but this specific universality-scan result — **NOT CLEARLY IN MASTER** |
| Charge conjugation = orientation reversal, confirmed chirality via Chern-Simons sign *(Charge Conjugation as Orientation Reversal)* | §5 "Chirality and charge conjugation" — **IN MASTER** |
| 134-manifold census, ITF signature (8,1) selection criterion, no fitting *(Quark Mixing from an Arithmetically Selected Hyperbolic 3-Manifold)* | Likely in §1/§2 selection narrative — **LIKELY IN MASTER**, specific "134" figure not independently confirmed here |
| EFT feasibility analysis, spectrum obstruction for logarithmic mass lattice *(Uniqueness-First EFT Realization)* | §3 "Methods...discrete lattice hypothesis" is adjacent but this EFT-specific feasibility/obstruction analysis — **NOT CLEARLY IN MASTER** |
| Three conjectures: dark matter as non-Lucas primes, matter/dark-energy transition, information geometry *(HFG: Conjectures on Dark Sector, Dark Energy)* | §13 "Cosmological Implications" exists but these specific three conjectures — **NOT CLEARLY IN MASTER, needs verification** |
| Frobenius discriminant forces p=31 as tower prime; Bianchi descent, character variety theorems *(Frobenius Discriminant, Bianchi Descent, and the Character Variety)* | **NOT IN MASTER** — this proves the "31-exception" claim referenced elsewhere in the program's own reasoning, but the theorem itself isn't in v12 |
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
