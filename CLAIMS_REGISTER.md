# HFG Claims Register

Started Aug 3 2026. One entry per major public claim the programme makes, its evidence
tag, current status, and which papers assert it. When a claim is retracted or corrected,
update the entry here — this is the single place to check before citing anything.

Evidence tags follow `CLAUDE.md`'s convention: **[Proved]** (complete mathematical proof),
**[Computed]** (numerical verification at high precision), **[Statistical]** (Monte Carlo /
census test), **[Conjecture]** (unproved), **[Retracted]** (formerly asserted, now withdrawn).

---

## 1. Dual surgery identity
**Claim:** m003(−2,3) ≅ m019(2,1) ≅ M_PMNS — two arithmetically independent cusped
parents fill to the same closed manifold.
**Status:** [Proved]. Volumes agree to 15 significant figures; SnapPy `is_isometric_to`
returns True; both H₁ = ℤ/5.
**Papers:** SSRN 6845778, `gentry-galois-gauge-v4.tex`, orphaned `gentry-pati-salam.tex`
(Downloads, not tracked in any repo)
**Last verified:** Aug 2 2026 (`class_s_verification.txt`)

## 2. Galois closure of the compositum
**Claim:** Gal(L/ℚ) ≅ S₄ × ℤ/2 ≅ Weyl(SU(4)) × Weyl(SU(2)_L), where L is the Galois
closure of the compositum of m003's and m019's trace fields.
**Status:** [Proved]. Computed directly (GAP small-group id [48,48] matches independently
constructed S₄ × ℤ/2).
**Papers:** SSRN 6845778, `gentry-galois-gauge-v4.tex`
**Last verified:** Aug 2 2026

## 3. m019 cusp field Galois group
**Claim:** Cusp shape of m019 satisfies x⁴−x−1 (disc −283), Galois group S₄ ≅ Weyl(SU(4)).
**Status:** [Computed]. Independently re-verified Aug 2 2026; already documented since
`gentry-galois-gauge-v4.tex` (July 10 2026) — not a new result.
**Papers:** SSRN 6845778, 6840322, `gentry-galois-gauge-v4.tex`
**Last verified:** Aug 2 2026

## 4. Physical (Pati-Salam) interpretation of the Galois closure
**Claim:** S₄ × ℤ/2 corresponds to the gauge sector SU(4) × SU(2)_L of the Pati-Salam model.
**Status:** [Conjecture] — explicitly, not a derivation. The SU(2)_R factor is unaddressed;
the field-theoretic mechanism (Class S / 3D-3D bridge) is proposed, not established.
**Papers:** SSRN 6845778 (frames it as observation, correctly hedged)
**Last verified:** ongoing — this is the open question, not a settled claim

## 5. Eisenstein-norm BPS mass ratio claims (muon, tau)
**Claim:** N(16+12ω)=208 ≈ m_μ/m_e; N(68+37ω)=3477 ≈ m_τ/m_e, as evidence of a Class S /
X₀(11) BPS mass spectrum.
**Status:** **[Retracted]**. Monte Carlo look-elsewhere test (20,000 trials): p=0.106 (tau
range), p=0.862 (muon range). Neither survives correction — do not cite as evidence.
**Papers:** SSRN 6840418 — **withdrawal requested by author Aug 2 2026, not yet confirmed
removed** (still live on public ORCID record as of Aug 3 2026 check)
**Last verified:** Aug 2 2026 (`class_s_verification.txt`)

## 6. CKM invariant trace field = ℚ(√17)
**Claim:** The invariant trace field of M_CKM is the real quadratic field ℚ(√17).
**Status:** **[Retracted]** (F-002, filed June 2026). Real quadratic fields cannot serve as
invariant trace fields of arithmetic Kleinian groups (no complex place). Correct ITF is a
degree-10 field, disc −271,488,204,251, signature (8,1).
**Papers still asserting this uncorrected:** `gentry-hfg-unified-v3.tex` (9+ occurrences,
including abstract), several `05_rejected_archived/` CKM drafts (expected, archived),
`gentry-x011-bridge-v2.tex` (inactive)
**Last verified:** retraction paper is `gentry-hfg-arithmetic.tex` / `gentry_hfg_arithmetic_v2.tex`

## 7. Optimal smearing parameter σ_opt
**Claim (retracted form):** σ_opt = (3/2)log(φ)
**Claim (correct form):** σ_opt = (3/2)log(√(13/5)) exactly, where 13 = Gaussian norm of
the PMNS filling slope, 5 = |H₁(M_PMNS)|. Numerically 0.71663 vs 0.72183 (0.72% difference).
**Status:** [Proved] for the corrected form (F-003, filed June 2026).
**Papers still using the old form:** flagged as body-only quotes (in retraction context) in
`gentry-hfg-arithmetic.tex`, `gentry-wrt-x011.tex` — check these are quoting-to-retract, not
asserting

## 8. M_PMNS minimum-volume status
**Claim (wrong form):** "The unique closed orientable hyperbolic 3-manifold of minimum
volume" (unqualified).
**Claim (correct form):** The unique minimum-volume closed hyperbolic 3-manifold *with
H₁=ℤ/5*; the second-smallest known closed hyperbolic 3-manifold by volume globally (the
Weeks manifold is the true global minimum).
**Status:** [Proved] for the correct, qualified form.
**Fixed this session (Aug 2–3 2026):** `gentry-pati-salam.tex`, `gentry-galois-gauge-v4.tex`,
`docs/index.html` (hero statement), `youtube_hfg_overview.html`/narration script
**Still wrong as of last check:** `gentry-hfg-unified-v3.tex` (abstract + body),
`gentry_meyerhoff_gauss.tex` abstract (per catalogue text, not independently re-verified),
`docs/meyerhoff.html`, `HFG_Lecture_Script.md` (separate from the YouTube script)

## 9. m206(1,2) "order-6 Eisenstein torsion" / complete torsion taxonomy
**Claim:** m206(1,2) completes a taxonomy of order-2 (PMNS), order-4 (CKM), order-6 (m206)
torsion classes.
**Status:** **[Retracted]**, downgraded Aug 3 2026. Direct verification found
H₁(m206(1,2)) = ℤ/5, not order 6; an alternate eigenvalue-ratio reading of "order" also
fails (λ_b/λ_a is a cross-ratio of magnitude ≠1, not a root of unity). λ_b=−λ_a and mixing
angle ~74° remain as observed — only the order-6/taxonomy framing is retracted.
**Fixed this session:** `docs/index.html` (3 locations), `docs/article4.html` (4 locations)
**Flagged, not yet checked:** whether this claim appears uncorrected in any paper `.tex` or
in the live SSRN 6775158 abstract (user reported fixing the latter directly on SSRN;
not independently verified — SSRN blocked automated fetch twice)

## 10. CKM fitness value
**Claim (canonical):** F=0.002728 at σ=0.47, against a 134-manifold H₁=ℤ/5 census refinement,
null-tested (p=0.005, 200 Haar-random targets). M_CKM ranks 82nd of 134 by raw fitness —
explicitly NOT claimed as best-in-class; the fit quality is a property of the H₁=ℤ/5 torsion
class, not unique to M_CKM.
**Superseded values still in circulation:** F=0.016482 (SSRN 6583550, older PLB-targeted
draft), F=0.003618 (live SSRN 6775158 abstract as of last check, per user's own quote of it;
also `docs/index.html`'s "φ Has an Automorphic Origin" callout, not yet fixed)
**Papers with the canonical value:** `ckm-rebuild/gentry-ckm-v3.tex` (promoted to
`04_new_needs_journal/` Aug 2 2026 as the canonical CKM paper)
**Last verified:** R-064, `CLAUDE.md`, July 17 2026

## 11. CKM negative-result search (no S₄ parent for M_CKM)
**Claim:** No manifold among 9 named S₄-candidates fills to a manifold matching M_CKM's
volume/homology, within a bounded Dehn-filling slope search.
**Status:** [Computed]. Exact bounds, verified against the actual script Aug 3 2026:
slopes |p|,|q| ≤ 15 (same bound both coordinates), coprime pairs only, (0,0) excluded but
not other zero-pairs, no sign-equivalence deduplication, 9 named manifolds
(m011,m019,m026,m033,m079,m115,m141,m155,m178) — not an exhaustive census.
**Wrong figures previously circulating:** ≤12 (orphaned `gentry-pati-salam.tex`), ≤20
(this session's Substack draft before correction, and `CONFIRMED_abstracts.md`'s tracked
summary of SSRN 6845778's abstract — neither figure traces to the actual script)
**Script:** `reproduce/dual_surgery_exploration.py` (committed to repo Aug 3 2026)

## 12. Lucas number formula for geodesic traces
**Claim (wrong form):** φ^k + φ^(−k) = L_k (Lucas number) for all integer k.
**Claim (correct form):** True only for even k; for odd k, φ^k + φ^(−k) = √5·F_k (Fibonacci).
**Status:** [Proved] for the corrected form, v4 (June 21 2026).
**Papers still using the wrong form:** `05_rejected_archived/gentry_lucas_structure.tex`
(correctly archived), `lucas-structure/gentry_lucas_structure.tex` (v3, superseded by v4,
not yet marked as such)
**Correct version:** `lucas-structure/gentry_lucas_structure_v4.tex`, SSRN 6981259 (live,
per ORCID Aug 3 2026 check — supersedes withdrawn SSRN 6854378, which some tracking files
still reference)

## 13. Linear disjointness of K_m003 and K_m006
**Claim:** The cusp fields K_m003 = ℚ(√−3) (deg 2, disc −3) and K_m006 (deg 3, x³+2x+1,
disc −59, Gal=S₃) are linearly disjoint over ℚ.
**Status:** [Proved]. Sage: compositum K_m003·K_m006 has degree 6 = 2×3 (verified directly,
not assumed) — confirms disjointness. Galois closure of the compositum has degree 12,
Galois group D₆ (dihedral of order 12) — confirmed by Sage's `galois_group()` structure
description. This is a distinct result from Claim 2 (S₄×ℤ/2 for the m003/m019 compositum) —
different manifold pair, different closure group.
**Physical reading:** unlike the m003/m019 pair (which combine into the Pati-Salam
SU(4)×SU(2)_L Weyl group), D₆ is not a direct product of the individual Weyl groups ℤ/2 and
S₃, so this compositum does NOT extend the Pati-Salam correspondence to a three-factor
statement. The m006 field remains "arithmetically independent" in the linear disjointness
sense, but its Galois closure does not slot into the same product-group narrative as the
m003/m019 case. Report as-is; do not force into the existing physical framing.
**Script:** ad hoc Sage session (`K003 = NumberField(x^2-x+1)`, `K006 = NumberField(x^3+2*x+1)`,
`K003.composite_fields(K006)`, `.galois_closure().galois_group()`), Aug 11 2026. Not yet
saved as a `reproduce/` script.
**Last verified:** Aug 11 2026

## 14. Candidate manifold for the SU(2)_R factor
**Claim:** m010 (volume 2.6667, cusp field ℚ(√−7), minimal polynomial x²−x+2, field
discriminant −7) is linearly disjoint from the existing m003/m019 compositum, and the
Galois closure of the full three-field compositum (K_m003 · K_m019 · K_m010) has degree
96 and Galois group C₂ × C₂ × S₄ — the Weyl group of SU(2) × SU(2) × SU(4), i.e. the
complete Pati-Salam Weyl group including the SU(2)_R factor that Claim 4 flags as
unaddressed.
**Status:** [Computed]. Result independently re-derived twice from scratch (two separate
Sage sessions, same day) with matching output: field discriminants −3 / −283 / −7 (all
distinct, confirming genuine arithmetic independence — not a duplicate of K_m003),
compositum degree 8 then 16, closure degree 96, group order 96, structure C₂×C₂×S₄.
m010 was found via a structured census search (SnapPy 1-cusped manifolds, 2–6 ideal
tetrahedra, 1199 manifolds screened) for the smallest-volume manifold whose cusp field
is quadratic, arithmetically distinct from K_m003, and linearly disjoint from the
existing compositum — not selected after the fact to fit a wanted answer. m009 (same
volume) generates the same field ℚ(√−7) via a different generator polynomial and is not
a second independent candidate.
**Physical reading:** [Conjecture], not established. This is a candidate for the SU(2)_R
factor referenced in Claim 4, selected by the same minimum-volume-plus-disjointness
principle used for m003/m006/m019 — but no field-theoretic mechanism connects m010's
cusp geometry to a physical right-handed weak force, and no independent physical
argument singles out m010 over any other manifold that might pass the same screen at
slightly higher volume. Report as a candidate; do not upgrade to [Proved] or claim the
SU(2)_R gap is closed without further scrutiny (e.g. checking whether other small-volume
disjoint candidates exist beyond the top screen cutoff, and whether m010 has any other
distinguishing structural property beyond passing this one screen).
**Script:** `reproduce/su2r_candidate_search.py` (census screen + disjointness + closure),
independently re-verified via a second ad hoc Sage session, Aug 18 2026.
**Last verified:** Aug 18 2026

## 15. Full four-field Galois closure — complete Pati-Salam-plus-SU(3) Weyl group
**Claim:** The compositum of all four cusp fields (K_m003, K_m019, K_m010, K_m006 —
disc −3, −283, −7, −59 respectively) is Galois over ℚ with
Gal ≅ ℤ/2 × S₄ × ℤ/2 × S₃, order 576 — the full direct product of the four
individual Weyl groups Weyl(SU(2)) × Weyl(SU(4)) × Weyl(SU(2)) × Weyl(SU(3)).
**Status:** [Proved], not merely [Computed]. This is a genuine proof, not a numerical
coincidence: K_m003 and K_m010 are quadratic (automatically Galois); the Galois
closures of K_m019 (degree 24, group S₄) and K_m006 (degree 6, group S₃) are Galois
by construction. Mutual linear disjointness of all four was confirmed by direct,
exact degree computation at every step (24×6=144, ×2=288, ×2=576 — each compositum
degree matching the product exactly, computed in under 1 second total). For mutually
linearly disjoint Galois extensions, the compositum's Galois group is the direct
product of the individual groups — a standard theorem, not an assumption. As a
secondary check (not needed for the proof but corroborating it), the closure of
K_m006 has discriminant exactly −59³, confirming it ramifies only at 59, disjoint
from the other three fields' ramified primes {3, 283, 7}.
**How this was found:** the direct approach (`K1234.galois_closure()` on the raw
degree-48 compositum) ran 27 hours with zero progress signal (and 46 hours on an
earlier attempt) and was abandoned as intractable on this hardware. The actual
resolution came from computing the *individual* Galois closures of the two
non-Galois pieces first (degree 4→24 and degree 3→6, each near-instant) and composing
those instead of the raw fields — a reformulation suggested via a relayed GPT
analysis (Aug 22 2026), independently checked here (the discriminant/ramification
facts were already established in entries 2/3/13/14 before this suggestion arrived;
the specific reformulation of the problem was GPT's contribution) and confirmed by
direct computation rather than taken on trust.
**Physical reading:** [Conjecture], unchanged from entries 4 and 14 — the group
theory here is now fully proved, but no field-theoretic mechanism connects any of
these four cusp fields to actual physical gauge groups. This result does not
strengthen the physical interpretation, only the arithmetic scaffolding beneath it.
**Script:** `reproduce/fourway_ramification_check.py`, Aug 22 2026.
**Last verified:** Aug 22 2026

## 16. Geometry-only candidate selector for charged-lepton mass indices
**Claim:** A specific combination of arithmetic invariants already established elsewhere
in the corpus — H₁(M_PMNS)=ℤ/5, the Farey-tower conductor p₁=11=5·1·2+1, and the Hecke
eigenvalue a₆₁=12 for the level-11 curve E: y²+y=x³−x² at the first tower prime beyond
the order-5 character's conductor where that character is trivial — reproduces the
integer lattice indices Q_e=0, Q_μ=44, Q_τ=68 (equivalently k=Q/4 = 0, 11, 17) via
Q_μ−Q_e = 4·p₁ and Q_τ−Q_μ = 2·a₆₁, where 4 and 2 are the counts of nonzero classes and
inversion-orbits of ℤ/5 respectively. Comparing against the actual masses only after
computing the indices gives m_μ/m_e error 3.755% and m_τ/m_e error 2.697%.
**Status:** [Conjecture]. The script genuinely does not read particle masses before
producing Q_e/Q_μ/Q_τ — the execution order is real and was independently reproduced
here. But this is weaker than it sounds: the *specific* combinatorial rule (why this
transition uses 4×p₁ additively rather than some other invariant or coefficient, why the
second transition searches for "the first post-conductor tower prime with trivial
order-5 character" rather than a different selection rule, why 2×a_p rather than another
multiple) is not independently derived from any geometric argument — the source script's
own status note admits exactly this ("the rule is NOT yet canonically derived"). With
several free choices of which invariant, which arithmetic operation, and which specific
prime-selection criterion to combine, landing near two already-known target integers
(44 and 68, previously identified in the mass-lattice mechanism check, entry-independent)
carries a real look-elsewhere/multiple-comparisons risk: the rule may have been tuned
against those known targets during construction even though it does not consult them at
runtime. This is categorically weaker evidence than entries 15 or the m006 archimedean
root-labeling result (which involve no such free choices). For contrast: the analogous
attempt at a geometry-only selector for the six quark indices
(`reproduce/hfg_quark_selector_audit.py`) found no uniform rule at all — an honest
negative result, itself a caution against over-crediting the lepton case's apparent
success as more than a smaller-target-space coincidence.
**Script:** `reproduce/hfg_geometry_only_mass_selector.py` (independently rerun here,
output matches exactly: Q_μ=44 at 3.755% error, Q_τ=68 at 2.697% error).
**Last verified:** Aug 22 2026

## 17. Oriented G/H coset selector for the m006 cusp field (Stage 2)
**Claim:** For K=ℚ(α), α³+2α+1=0 (disc −59, the same field as entry 15's SU(3) factor
K_m006), with L its S₃ Galois closure and H=Gal(L/K)≅C₂, the three left cosets G/H
correspond exactly to the three ℚ-embeddings of K (equivalently the three conjugate
roots r_R, r₊, r₋ of the defining cubic). m006's oriented discrete-faithful holonomy
representation ρ_geo selects the r₊ embedding (Im>0) — SnapPy's independently computed
cusp shape matches r₊ to machine precision (~1e-16, already established in the m006
root-labeled-selector work). Tested here: does that selection survive a change of
peripheral (meridian,longitude) basis? For 7 tested SL(2,ℤ) basis changes (via SnapPy's
`set_peripheral_curves`, determinant ±1, including the identity as a sanity check), the
transformed cusp shape ALWAYS matches — to residuals of 1e-16–1e-17, i.e. exactly — the
r₊ embedding evaluated under the corresponding exact Möbius transform of α, and never
the r_R or r₋ embeddings. Reversing orientation swaps the selection to r₋ (up to an
overall sign from SnapPy's internal peripheral-convention reset upon reversal — verified
directly, residual ~3e-16), leaving the real embedding r_R untouched by either operation.
**Status:** [Proved] (upgraded from an initial [Computed] tag — proof written and checked
in `reproduce/stage2_invariance_proof.md`). The argument: (1) a peripheral basis change
does not alter the manifold, its orientation, or ρ_geo, so the recomputed shape is always
the SAME rational function (with rational, in fact integer, coefficients) of the SAME
fixed geometric quantity r₊; since field embeddings are ring homomorphisms fixing ℚ, they
commute with any rational-coefficient Möbius transform, so applying the SAME transform to
α and evaluating under σ₊ reproduces the recomputed shape exactly, for EVERY valid basis
change — this needs no case-by-case checking, only that a,b,c,d are rational. (2) Reversing
orientation replaces ρ_geo by its complex conjugate (standard: orientation-reversing
isometries of H³ conjugate PSL(2,ℂ)), and since r₋=conj(r₊) and r_R is real, conjugation
swaps σ₊↔σ₋ and fixes σ_R as embeddings — again exact algebra, not a numerical coincidence.
The only empirical inputs are (a) ι_geo=σ₊ for the default basis and (b) that SnapPy's
`set_peripheral_curves` implements the standard cusp-shape transformation law — both
confirmed to ~1e-16 against real computation, not assumed. Two real bugs were found and
fixed while building the underlying script, both instructive: (1) the originally-proposed
Möbius formula τ'=(cτ+d)/(aτ+b) — and, independently, a second relayed variant
τ'=(bτ+a)/(dτ+c) proposed alongside the proof sketch — both failed the identity-matrix
sanity check (predicting 1/τ instead of τ); the correct formula, τ'=(dτ+c)/(bτ+a), was
empirically calibrated against real SnapPy output before use, not assumed, either time;
(2) an initial verdict check compared the transformed cusp value directly against the
three *original* roots, exactly the invalid test the underlying write-up itself warned
against (post-transform, the cusp value generally is not one of the three original roots)
— fixed by comparing against the exact Möbius-transformed algebraic element evaluated at
each embedding instead.
**Combined with Stage 1** (this register's implicit companion result, not yet its own
entry): Stage 1 showed the canonical prime-lift construction always selects the same
transposition h∈H (a C₂ datum); Stage 2 shows the oriented holonomy selects one of 3
cosets G/H independent of coordinate choice. Together these give a genuine 2×3=6-element
geometric state space — but no map from those six states to the six actual quark mass
indices (12,18,43,65,75,106) has been attempted or found. That remains completely open
(Stage 3, explicitly not attempted this session).
**Physical reading:** [Conjecture]/open, same status as entries 4, 14, 15 — this
strengthens the arithmetic scaffolding (a genuine six-element geometric torsor now
exists) but supplies no mechanism connecting it to which quark occupies which slot.
**Script:** `reproduce/hfg_stage2_oriented_coset_selector.sage`, Aug 22 2026.
**Proof:** `reproduce/stage2_invariance_proof.md`, Aug 22 2026.
**Last verified:** Aug 22 2026

## 18. Stage 3A spin-lift binary state for the m006 CKM filling
**Claim:** H₁(m006;ℤ/2) ≅ ℤ/2 — verified directly from SnapPy's actual fundamental
group presentation (generators, relator `ababbAAbb`, peripheral words μ=Abb, λ=AAbA,
all matched verbatim, not assumed). The unique nontrivial character χ has χ(a)=1,
χ(b)=0; verified χ(μ)=1, χ(λ)=1, χ(s)=1 for the CKM filling slope s=−5μ+2λ. By
Menal-Ferrer–Porti (Prop. 3.8, arXiv:1001.2242), the set of SL(2,ℂ) lifts of m006's
PSL(2,ℂ) holonomy is a torsor over H¹(m006;ℤ/2), so there are exactly two lifts,
differing in sign exactly where χ is nonzero.
**Sign correction (from actual holonomy computation, not abstract reasoning):**
SnapPy's default discrete-faithful lift has tr(μ)=+2, tr(λ)=−2, tr(s)=+2 (exact,
computed via `G.SL2C(...)`, both multiplication orders for s agree). Working the
Thurston Dehn-surgery continuity argument directly for slope s (the same mechanism
as Menal-Ferrer–Porti's Lemma 3.9, applied without the auxiliary large-slope trick
since m006(−5,2) is already independently known to be hyperbolic): along the
deformation path α∈[0,2π], trace(ρ_α(s))=ε·2cos(α/2) for fixed sign ε; the filled
endpoint requires ρ(s)=I exactly (trace +2) at α=2π, forcing ε=−1, hence the
extending lift has trace(s)=−2 at the complete structure (α=0) — the *opposite* of
SnapPy's default lift. **The lift extending over m006(−5,2) is therefore the χ-twist
of SnapPy's default lift, not the default lift itself.** This gives the independent
binary parity bit ε the Stage 3A analysis called for:
ε=+1 ↔ χ-twisted lift (extends over the filling); ε=−1 ↔ default lift (does not
extend). Combined with Stage 2's 3-state G/H coset selector (entry 17), this gives a
canonical 6-element state space (2×3).
**Status:** [Structural]. The Menal-Ferrer–Porti framework (lifts as an H¹(M;ℤ/2)
torsor) is directly confirmed from the paper, verbatim. The continuity mechanism is
standard (Thurston; Neumann-Zagier; Hodgson-Kerckhoff for existence of the
deformation path) and correctly applied, with a concrete, falsifiable, checkable
numerical answer — not left as an open ±1 ambiguity. Not [Proved]: three specific
technical hypotheses have not been independently re-verified to the standard of
entry 17's proof — (1) existence of the continuous cone-manifold path is cited, not
re-derived; (2) the monotonicity argument at α=π was checked in Menal-Ferrer–Porti's
proof for their own auxiliary curve, not independently re-verified here for s
directly; (3) irreducibility of the representation along the full deformation path
has not been explicitly checked. See `reproduce/stage3_spin_lift_continuity_note.md`
for the complete argument and the exact gap.
**Combined with entry 17:** as with the mass-index selectors (entries 16, and the
quark-selector negative result), the six-slot state space here is now real and
concretely constructed — but no map from these six states to the six quark mass
indices (12,18,43,65,75,106) has been attempted. That remains Stage 3, untouched.
**Physical reading:** [Conjecture]/open, same status as entries 4, 14, 15, 17.
**Scripts:** `reproduce/hfg_stage3_binary_spin_selector.py`,
`reproduce/stage3_spin_lift_continuity_note.md`, Aug 23 2026.
**Last verified:** Aug 23 2026
