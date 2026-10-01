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

## 19. m003(-2,3) invariant trace field is isomorphic to m019's cusp field
**Claim:** K_283 = Q[X]/(X^4+X^3-1), the invariant trace field of the closed manifold
M = m003(-2,3) (from `papers/gentry-m003-arithmetic-v5.tex`, Theorem 3.1), is isomorphic
to Q[x]/(x^4-x-1), the cusp field of m019 (entry 3 above) -- both fields, not merely
sharing a discriminant.
**Status:** [Proved]. Exact, not disc-coincidence inference: g(x)=x^4-x-1 acquires a
linear factor over Q(alpha) for every root alpha of f(x)=x^4+x^3-1 (sympy exact
factorization over an algebraic extension, all 4 embeddings), independently
cross-checked by a from-scratch resultant computation
(Res_alpha(f(alpha), y-alpha^2-alpha^3) = y^4-y-1 exactly, not derived from the
factorization step), plus an independently found and verified inverse map. Explicit
isomorphism, both directions, exact polynomial-remainder verified:
  alpha |-> alpha^2+alpha^3   (root of f -> root of g)
  gamma |-> gamma^3-1          (root of g -> root of f)
**Significance, precisely stated:** the algebraic isomorphism above is a fact about
two explicitly given quartics, true independent of any manifold (verified by
polynomial-remainder arithmetic alone) -- it is a category error to call it a
*consequence* of the dual surgery identity. What the dual surgery identity (entry 1)
DOES force, via the standard fact that k_inv is an isometry invariant (Maclachlan-Reid,
cited as `[2, Ch. 3]` in `gentry-m003-arithmetic-v5.tex`: isometric manifolds have
discrete-faithful representations conjugate in PSL2(C), and k_inv is manifestly
conjugation-invariant), is k_inv(m003(-2,3)) = k_inv(m019(2,1)) -- and since
k_inv(m003(-2,3)) = K_283 (Theorem 3.1 of that paper), this gives
**k_inv(m019(2,1)) = K_283 as well**, with no fresh computation on m019's own
presentation needed. Combined with entry 3 (m019's *unfilled* cusp field, also
K_283, established independently here as isomorphic rather than merely
disc-matched), the full, now fully resolved picture is: filling m003 (cusp field
Q(sqrt(-3)), degree 2) at slope (-2,3) *enlarges* the field to degree 4, landing on
K_283; filling m019 (cusp field already K_283, degree 4) at slope (2,1) leaves the
field *unchanged*. Both directions are now established, not merely the second.
**Not established:** any field-theoretic *explanation* (e.g. a Galois-theoretic
reason the (2,1) filling doesn't enlarge m019's field) -- this entry records the
fact, not a mechanism. Also not established: a census-wide base-rate check (how
common a quartic, signature-(2,1), disc-283-type field is among
`OrientableClosedCensus` manifolds) that would calibrate how surprising the
coincidence is -- flagged as a legitimate next step, needs SnapPy, not run here.
**Out of scope for `gentry-m003-arithmetic-v5.tex`:** that paper is deliberately pure
character-variety/arithmetic mathematics with all HFG/physics motivation removed
earlier in this same project (see MASTER_GAP_REPORT.md); this cross-manifold,
HFG-program-level observation belongs with the m003/m019 compositum material
(`gentry-galois-gauge-v4.tex`, SSRN 6845778 -- entries 1-3 above), not in that paper.
**Script:** `reproduce/m003_m019_field_isomorphism_certificate.py`, log committed.
**Last verified:** Sep 29 2026

## 20. Trace-collision test of the real PMNS/CKM word triples
**Claim (this entry only reports what was checked, not a new physical claim):** using
the ACTUAL historical word triples retrieved from source (not a relayed transcript),
tested pairwise trace collision on each manifold's own geometric component, via the
exact ideal-membership machinery of `gentry-m003-arithmetic-v5.tex`.
**Retrieved, verified against the real files:**
  - PMNS triple {aa, aaB, baa}, M_PMNS = m003(-2,3) (`gentry-pmns-plb.tex` line 215).
  - CKM triple {aaB, AbA, AAb}, M_CKM = m006(-5,2), NOT m003 (`gentry-ckm-plb-v3.tex`
    lines 38, 210). A relayed transcript's claimed CKM triple, {aaab, aabb, bAbAB},
    does not match the real paper and was not used.
**Status:** [Computed], exact (sympy Groebner ideal membership, no floating point).
Result:
  - PMNS: Delta_{aa,baa} = x^2-xz+y-2 = h exactly, hence aa and baa collide
    IDENTICALLY on X_0(m003) -- a genuine, previously-unstated fact (baa is not a
    cyclic rotation or inverse of aa, so this is not a trivial free-group symmetry).
    It is also a shorter witness for h (length 2/3) than the paper's own proof uses
    (length 4/5, eq. 34). (aa,aaB) and (aaB,baa) do NOT collide.
  - CKM: all three words have IDENTICAL trace polynomials (Delta=0 exactly, not
    merely ideal membership) -- but this is a TRIVIAL fact of free-group trace
    (tr(uv)=tr(vu) under cyclic rotation, tr(g)=tr(g^{-1}) under inversion): AAb is a
    cyclic rotation of AbA, and aaB's inverse bAA is also a cyclic rotation of AbA.
    True on every representation of every group; has nothing to do with m006's
    arithmetic, its relator, or its character variety.
**Scope, stated precisely, do not overclaim in either direction:** a positive
collision result means the two words have identical FRICKE TRACE POLYNOMIALS. It
does NOT mean the actual Borel/QR "axis direction" construction (papers'
sec:borel, extracting n_hat(gamma) in S^2 from the Pauli decomposition of
log(rho(gamma)) -- full matrix data) is insensitive to the words' distinction: trace
fixes only eigenvalues, not axis position, and both papers report non-degenerate
angle triples for these exact words, consistent with trace-equal-but-axis-different.
No claim is made here about whether the Borel construction itself is well-founded,
selection-biased, or physically meaningful -- only about the specific, narrow,
now-decidable trace-collision question.
**Script:** `reproduce/hfg_word_triple_collision_check.py`, log committed.
**Last verified:** Sep 29 2026

## 21. Strengthening of Theorem 5.7: J_infty = J_3, not merely J_5
**Claim:** the collision ideal of X_0(m003) stabilizes at word length 3, not 5 --
J_infty = J_3 = J_4 = J_5 = P0 cap I(N) = <h,q>. This is a strict strengthening of
the published theorem (which states, correctly but non-optimally, J_infty=J_5).
**Status:** [Proved], exact (sympy Groebner, no floating point).
`reproduce/m003_J3_strengthening_certificate.py`, log committed. Rests on two facts:
  Delta_{aa,baa} = h  exactly (coefficient 1, not (y+1)h or (y^2+y-1)h as in the
    paper's own length-4/5 witnesses, eq. 26-27)
  Delta_{AB,ABB} = -q exactly (already eq. 26 of the paper, words of length 2,3)
Both pairs consist of words of length <= 3 and both independently verified to
satisfy the defining collision condition (Delta in P0). Combined with the
already-published upper bound J_L subseteq K for every L (unconditional in L,
Theorem 5.7's own proof), the chain K subseteq J_3 subseteq J_infty subseteq K
closes exactly.
**Provenance:** the word pair aa/baa is the real historical PMNS word triple
{aa,aaB,baa} (entry 20 above) -- retrieved from the actual HFG corpus, not
invented for this purpose. A relayed message flagged that this specific
collision (Delta_{aa,baa}=h, not a multiple of h) implies the stronger
stabilization bound; independently re-derived and verified in full here rather
than accepted.
**Not yet done:** applying this as an edit to `gentry-m003-arithmetic-v5.tex`
(replacing the length-4/5 Bezout witnesses of eq. 26-27 with the shorter
length-2/3 pair, and changing "J_infty=J_5" to "J_infty=J_3" throughout,
including Corollary 5.8's "length five" wording). The math is verified; the
edit is a judgment call on presentation, deferred pending explicit approval,
since it changes a published theorem statement.
**Last verified:** Sep 29 2026

## 22. Independent re-verification of the length<=6 atlas's trace-collision structure
**Claim:** enumerating the paper's own stated atlas protocol (freely/cyclically
reduced words in a,A,b,B, length<=6, cyclic rotation + inversion + proper-power
quotient) and grouping the resulting classes by exact collision on X_0 (ideal
membership in P0) gives a specific collision structure, checked against a
relayed claim of "25 collision classes covering 54 of 99 words."
**Status:** [Computed], exact. `reproduce/m003_full_atlas_collision_classes.py`,
log committed. Independent enumeration reproduces the paper's stated 99 classes
exactly. Collision-class count matches the relayed claim (25 nontrivial
classes) but total word coverage does NOT (66 of 99 here, not 54 of 99 --
the relayed figure appears to be an error or artifact of a non-matching
enumeration, not reproduced). Zero classes straddle more than one |e_a| value
(1028 pairwise checks, |e_a| pre-filter), exactly as Lemma 5.5 forces --
independent confirmation, not new content. The two specific example triples
named in the relay, {ABaB,ABBaB,ABaBB} and {AAbAb,AABBAb,AAbABB}, do NOT appear
among this script's own 99 canonical representatives (a labeling/representative-
choice artifact, not a contradiction), but both were checked directly and DO
collide exactly on X_0 under the paper's own chart -- the underlying claim is
genuine even though the relay's summary statistics (54/99) were not accurately
reported.
**Last verified:** Sep 29 2026

## 23. Decisive result: the CKM axis-angle construction is gauge-dependent on the REAL m006 holonomy (SnapPy/Sage now confirmed working in WSL, miniforge3 env "sage")
**Claim:** run on the actual polished holonomy of M_CKM = m006(-5,2) (not generic
matrices) and the real word triple {aaB,AbA,AAb} (entry 20), using the exact,
verbatim `get_axis` function from `hyperbolic-flavor-scan/hfg_reproduce.py` (the
real construction, not a reinterpretation): do the pairwise Euclidean axis angles
survive the natural SL2(C) conjugation freedom of the discrete-faithful
representation?
**Status:** [Computed], exact tooling now available -- SnapPy 3.3.2 and Sage 10.9
both confirmed working in WSL at `~/miniforge3/envs/sage/` (not on PATH by
default; previous sessions' "SnapPy/Sage unavailable" conclusion was simply
wrong -- the tools were present the whole time, just not discovered). Script
`reproduce/m006_axis_gauge_conjugation_sweep.py`, log committed.
**Result:**
  - Base angles reproduce the published paper EXACTLY: theta(aaB,AbA)=48.1554,
    theta(aaB,AAb)=77.4835, theta(AbA,AAb)=68.4272 degrees (paper: 48.16, 77.48,
    68.43) -- confirms the script faithfully replicates the real construction,
    not an approximation of it.
  - Trace of each generator: invariant under 30 random SL2(C) conjugations to
    1.8e-14 (double-precision floor), as it must be.
  - Candidate replacement invariant, the normalized Killing/trace-form pairing
    K_ij = tr(X_i X_j)/sqrt(tr(X_i^2)tr(X_j^2)) (X_i the traceless part of the
    det-1-normalized matrix): invariant to 5.8e-13 (floor) -- confirmed
    conjugation-invariant on the real data, as the algebra requires
    (tr(CX_iC^-1 CX_jC^-1) = tr(X_iX_j) identically).
  - **The actual get_axis Euclidean angles used by the construction: NOT
    invariant.** Under the same 30 conjugations, theta(aaB,AbA) ranges
    [14.33,84.04] deg, theta(aaB,AAb) ranges [12.30,89.26] deg,
    theta(AbA,AAb) ranges [46.02,89.68] deg -- each base value is just one
    point inside a >55-degree-wide swept range. This is the real result on the
    real manifold and the real word triple, not a generic-matrix analogy.
**What this establishes, precisely:** the published CKM axis angles (and hence
the Gaussian-overlap-plus-QR mixing-matrix fit built from them) are not
determined by the abstract character/conjugacy class of the discrete-faithful
representation -- they depend on which specific SL2(C) matrix representative
(frame) SnapPy's `polished_holonomy()` happens to return, an implementation
detail with no argued geometric significance. A referee-level negative result
about the framed layer of the HFG construction (entries 21-22's character-layer
results are unaffected; this concerns only the axis/Borel-QR machinery).
**Not established:** any claim that the resulting CKM mixing-matrix FIT itself
is wrong or unreproducible (fitness numbers were separately audited, entries
elsewhere) -- only that its geometric input (the axis angles) is not a manifold
invariant.
**Self-correction recorded in the ledger, not hidden:** the first version of
this script used an incorrect "invariant" (the complex bilinear Pauli-coefficient
dot product from a from-scratch matrix-log derivation, which is mathematically
just a disguised copy of the SAME invariant quantity as the Killing pairing, not
the real construction's actual get_axis function) and consequently found NO
gauge dependence at all -- a wrong result from testing the wrong quantity, caught
before being reported, not after.
**Script:** `reproduce/m006_axis_gauge_conjugation_sweep.py`, log committed.
**Last verified:** Sep 30 2026

## 24. Correction: SnapPy and Sage ARE available in this environment (WSL, conda env "sage" under miniforge3)
**Claim/correction:** prior sessions (including entries and ledger text earlier
in this same project) repeatedly stated no SnapPy/Sage toolchain was available
and treated several tasks as blocked on that basis. This was an incomplete
search, not a fact about the machine: `~/miniforge3/envs/sage` contains a fully
working SnapPy 3.3.2 + SageMath 10.9 install in WSL, simply not on the default
PATH (`which sage`/`which conda` fail; the env must be addressed directly via
`~/miniforge3/envs/sage/bin/sage` or `~/miniforge3/bin/conda env list`).
**Status:** [Computed]/environment fact, confirmed directly (see entry 23,
plus a live re-verification of entry 14's m010 claim: volume 2.66674478344906,
1 cusp, minimal polynomial x^2-x+2, disc -7 -- reproduced exactly).
**Practical consequence:** tasks previously deferred as "needs SnapPy, not run
here" (the m006 conjugation sweep; census-wide searches) are not actually
blocked and should be attempted via this path before being reported as
unavailable.
**Last verified:** Sep 30 2026

## 25. k_inv(m010) independently verified equal to Q(sqrt(-7)) -- not conflated with the cusp field
**Claim:** CLAIMS_REGISTER entry 14 and `gentry-galois-product-theorem.tex` state m010's
INVARIANT TRACE FIELD (not cusp field) is Q(sqrt(-7)). A relayed caution (correctly)
flagged that this project already caught one real cusp-field/ITF conflation (entry 19,
m019) and should not assume the two coincide for m010 without checking.
**Status:** [Proved], exact (Groebner elimination, not algdep, for the load-bearing
claim; algdep used only as an independent cross-check that agreed).
`reproduce/m010_invariant_trace_field_certificate.py`, log committed.
**Method, mirroring the m003 paper's own Gate F1 at quadratic scale:** got m010's
presentation directly from SnapPy (relator `aabaBaaBab`, meridian `AbAA`, not assumed);
built the Fricke-chart relator ideal and primary-decomposed it (5 components: four
0-dimensional, one 1-dimensional -- the bare cusped relator variety, analogous to
m003's X_0); confirmed which component the certified discrete-faithful character
(SnapPy `verify_hyperbolicity`, 300 bits) sits on (residual 1.1e-88, i.e. exact);
imposed the parabolic/completeness condition on the meridian (tr(mu)^2=4) to cut this
down to a finite set of points (6 zero-dimensional components), identified which one
is the actual geometric point (residual 6.0e-89); then computed EXACT minimal
polynomials by further elimination:
  tr(a)   satisfies x^4-5x^2+8=0            (the ordinary trace field, degree <=4)
  tr(a)^2-2  satisfies s^2-s+2=0            (disc -7)
  tr(b)^2-2  satisfies s^2+6s+16=0          (disc -28 = 4x(-7), same field Q(sqrt(-7)))
  tr(ab)^2-2 satisfies s^2+7s+14=0          (disc -7)
All three independently confirm the SAME quadratic field Q(sqrt(-7)) -- not assumed
equal to the (separately, also live-re-verified) cusp field, and not the same
computation as the cusp field (that used `cusp_info('shape')`; this used the trace-of-
squares of the holonomy representation, the actual definition of k_inv).
**Conclusion:** k_inv(m010) = Q(sqrt(-7)), genuinely independently confirmed, and
happens to equal m010's cusp field -- unlike the m019/m003(-2,3) case, these two
different invariants coincide here, checked rather than assumed.
**Not established:** whether m010 is the CANONICAL/minimal-volume representative of
this field among all 1-cusped census manifolds -- entry 14 already flags this as open,
unresolved here, would need the structured census search entry 14 describes to be
rerun and checked live rather than trusted from August.
**Last verified:** Sep 30 2026

## 26. m009 and m010 are an EXACT tie on volume and invariant trace field; canonicity of m010 rests on maximal cusp order, not volume -- SELF-CORRECTED below after checking MASTER_GAP_REPORT.md, which already had this
**Claim:** entry 14 previously dismissed m009 as "not a second independent candidate"
without an exact k_inv computation. Re-checked exactly, same Gate-F1-style method as
entry 25, applied to BOTH manifolds side by side in one script.
**Status:** [Proved]/[Computed], exact where stated.
**Result (this session's independent re-check):**
  vol(m009), 300 bits = vol(m010), 300 bits, EXACTLY (difference = 0 to all 300 bits
    printed: 2.66674478344905979079671246261065004409838388855263953139317180331572348841561131881281222)
  trace field min poly of tr(a): x^4-5x^2+8 for BOTH (identical, not just same degree)
  k_inv candidate min poly of tr(a)^2-2: s^2-s+2 for BOTH, i.e. both generate
    Q(sqrt(-7)) as INVARIANT trace field (not merely cusp field)
  snappy `is_isometric_to`: False -- genuinely distinct, non-isometric manifolds
**Self-correction -- this entry originally (first draft, Oct 1 2026) claimed "no
distinguishing criterion between m009 and m010 has been identified" and that entry
14's canonicity framing was "not supported." That was WRONG and was caught, before
being left standing, by reading `notes/MASTER_GAP_REPORT.md` items 30 and 32 (dated
Aug 24-25 2026, already in this project, never yet propagated to this register --
see entries 29-30 below) and `papers/galois-product/gentry-galois-product-theorem.tex`
Proposition "Cusp-Order Distinction for K_3" (already drafted, also pre-dating this
session's work): a distinguishing criterion DOES already exist and is already proved
exactly -- tau_{m009}=sqrt(-7) generates the nonmaximal order Z[sqrt(-7)], while
tau_{m010}=(1+sqrt(-7))/2 generates the maximal order O_K, index 2 apart (verified via
the exact algebraic identity tau_{m009}=2*tau_{m010}-1). The paper's own wording is
already careful and correct: "m010 is distinguished at the tied minimal volume by
realizing the maximal cusp order" -- it does NOT claim m010 is volume-unique, only
order-unique among the tied-volume pair. This session's independent re-verification
of the volume/k_inv tie (above) is still a legitimate, useful cross-check (it had not
been done via this exact Gate-F1 elimination method before), but the claim that
canonicity was "unsupported" was an error made by not checking the existing gap
report first.
**Not established (genuinely open, per MASTER_GAP_REPORT item 32's own open question):**
whether m010 is the unique minimum-volume manifold among ALL manifolds realizing the
maximal order O_K census-wide -- item 32 answers this too (yes, checked across the
full 212,641-manifold census) but that full-census maximal-order result has also not
yet been propagated to this register; see entry 30 below. Also still open: the
relayed "m009/m010 are index-3 covers of the Bianchi orbifold" claim -- already
directly refuted by MASTER_GAP_REPORT item 34 (COMPLETED, exact Humbert-volume
computation: the volume ratio is exactly 3, but Grunewald-Schwermer's torsion
obstruction requires index divisible by 6 for any literal embedding in ordinary
T_7=PSL_2(O_{-7}), so no such embedding exists; the open question is which OTHER
maximal arithmetic lattice contains them, see MASTER_GAP_REPORT OPEN item 2, not
reproduced in full here).
**Script:** `reproduce/su2r_census_competitors.py` (Part 1), log committed.
**Last verified:** Oct 1 2026

## 27. Partial-census field screen (<=7 tetrahedra): 17 candidates with cusp field = Q(sqrt(-7)), found via an independent method -- cross-checks, and is a strict subset of, the already-existing full-census result (item 32, not yet in this register -- see entry 30)
**Claim:** this session, before discovering MASTER_GAP_REPORT item 32 already existed
(a full 212,641-manifold census scan from Aug 24-25 2026 computing the EXACT order
realized, not just the field), independently re-ran a field-level screen limited to
<=7 tetrahedra as a fresh cross-check, via a different computational route (direct
`algdep` on the cusp shape, not the `p,q`-order-coefficient method item 32 used).
**Status:** [Computed], exact enumeration at the field-screening level (algdep used
only as a quadratic-degree SCREEN; any hit is a candidate for the same exact Gate-F1
elimination treatment as m009/m010, not itself a proof of field membership).
**Method:** screened all 4587 one-cusped OrientableCuspedCensus manifolds with
<=7 tetrahedra; for each, `algdep(cusp_shape, 2)`, then tested
`squarefree_kernel(discriminant) == -7` (the correct field-equivalence test, not
literal equality -- see entry 28 for a bug this introduced and its fix).
**Result: 17 candidates, in two volume tiers:**
  minimal volume 2.66674478344906: m009, m010 (the entry-26 tie)
  exactly double that volume, 5.33348956689812: s772, s773, s775, s777, s778, s779,
    s781, s783, s784, s786, s787, s788, s789, v1539, v1540 (15 manifolds), via
    discriminants -7, -28, -63, -175, -567 -- all with squarefree kernel -7, i.e. all
    genuinely the same field via different generators.
**Cross-check against the pre-existing full-census result (item 32):** item 32's
`census_uniqueness_pass2.json` (read directly, not re-trusted on the gap report's
word alone) independently lists the SAME two volume tiers at <=7 tetrahedra, with
per-manifold order data (`p,q,index`) this session's simpler field-only screen does
not compute: m009 has index 2 (nonmaximal order, consistent with entry 26), m010 and
most of the 5.333-volume tier have index 1 (maximal order O_K) -- e.g. s772-s776,
s778-s779, s781-s782, s786-s787 are exact index-1 hits, while s783-s785, s788-s789,
v1539-v1540 are flagged `exact: false` in that file (order not pinned down there,
though they do pass the field screen here). The two independent methods agree on the
field-level candidate set at this tetrahedra range -- a genuine, useful cross-check --
but item 32 is the deeper, already-existing, full-census (not just <=7-tetrahedra) and
order-resolving (not just field-resolving) result; this entry's sweep does not
supersede it and should have been checked against it before being reported as new.
**Not established:** isometry/covering relationships among the 15 double-volume
manifolds, or between any of them and m009/m010 (e.g. whether they are 2-fold covers);
not checked here, would need pairwise `is_isometric_to` and/or explicit covering maps.
**Script:** `reproduce/su2r_census_competitors.py` (Part 2), log committed.
**Last verified:** Oct 1 2026

## 28. Methodological correction: the multi-hour "WSL/Sage sweep keeps stalling" problem this session was never an environment issue -- it was a trial-division bug triggered by algdep's LLL noise
**Claim/correction:** across several hours of this session, the census sweep (entry 27)
stalled repeatedly (90 to 300+ minutes, zero progress output) on multiple reruns. This
was wrongly diagnosed in real time as a WSL/Sage performance problem, and "fixed" by
increasingly drastic environment-level interventions: per-manifold signal-alarm
timeouts, batching into fresh-subprocess chunks, and finally a full `wsl --shutdown`
(complete VM restart). None of these addressed the actual cause and the restart did
not reliably fix it either (a post-restart rerun was still stalled at 44+ CPU-minutes
with zero progress markers when checked).
**Actual root cause, found by adding timestamped per-step logging to a 10-manifold
reproduction of the exact loop:** `algdep(tau, 2)` does not fail or flag low
confidence when a manifold's true cusp field is NOT degree <=2 -- it always returns
SOME degree-2 polynomial via LLL, and when there is no genuine small relation the
coefficients are astronomically large (observed for m006, the census's 3rd manifold:
a discriminant of magnitude ~10^36). The screen's own `squarefree_kernel` helper
factors the discriminant by trial division incrementing by 1 up to sqrt(|discriminant|)
-- for a ~10^18-magnitude square root this is computationally infeasible, so the
process hangs indefinitely on the very first non-quadratic manifold in the census
order, not from any WSL/Sage/environment cause. (The pre-fix script that completed in
~9 minutes, entry 27's "old screen," never hit this because it used a cheap literal
equality check on the discriminant, not a factorization.)
**Fix:** reject algdep's result as LLL noise (skip, do not factor) when its
coefficients exceed a generous bound (10^6) before computing the discriminant's
squarefree kernel -- genuine quadratic-field hits at this volume range have small
coefficients (x^2-x+1, x^2+7, x^2-x+2, etc.), so this costs nothing real.
**Lesson for this project's own practice:** before attributing a stall/slowdown to
the external toolchain (and escalating to environment-level fixes), instrument the
SAME code path with fine-grained logging to localize exactly where it stops, rather
than assuming the infrastructure is at fault. Three separate environment-level
interventions were tried and reported as attempted fixes before this was done.
**Status:** [Computed]/bug-fix, confirmed by rerun completing in the originally
expected timeframe (minutes, not hours) after the one-line fix.
**Script:** `reproduce/su2r_census_competitors.py`, fixed in place; diagnostic
scripts used to localize the bug were scratch files, not committed.
**Last verified:** Oct 1 2026

## 29. Cusp-order distinction between m009 and m010 (propagated from MASTER_GAP_REPORT item 30, dated Aug 25 2026 -- not previously in this register)
**Claim:** m009 and m010 share invariant trace field Q(sqrt(-7)), volume, tetrahedron
count, and symmetry group, but have cusp shapes generating different orders of the
same field: tau_{m009}=sqrt(-7) generates the nonmaximal order Z[sqrt(-7)];
tau_{m010}=(1+sqrt(-7))/2 generates the maximal order O_K, index 2 apart -- confirmed
via the exact algebraic identity tau_{m009}=2*tau_{m010}-1 in K.
**Status:** [Proved] (exact algebraic identity, not numerical).
**Papers:** `papers/galois-product/gentry-galois-product-theorem.tex`, Proposition
"Cusp-Order Distinction for K_3".
**Why this was missed initially this session:** this session's own entry 26 (above)
first (wrongly) claimed no distinguishing criterion between m009/m010 existed, before
this entry's source was located and checked -- see entry 26's self-correction.
**Last verified:** Aug 25 2026 (not independently re-run this session; propagated
from the existing gap report and paper text, both read directly).

## 30. m010 is uniquely the minimum-volume manifold realizing the maximal order O_K, full 212,641-manifold census (propagated from MASTER_GAP_REPORT item 32, dated Aug 25 2026 -- not previously in this register)
**Claim:** among ALL 1-cusped manifolds in SnapPy's full OrientableCuspedCensus
(212,641 manifolds, not merely a <=7-tetrahedra slice), exactly 37 share invariant
trace field Q(sqrt(-7)); of those, 17 realize the maximal order O_K exactly (via an
exact p+q*sqrt(-7)-style index check, not a numerical approximation); m010
(vol=2.66674478344906) is uniquely the minimum-volume manifold among those 17 --
the next-smallest maximal-order realization is at exactly double that volume.
**Status:** [Computed], exact (not statistical) -- ran to completion, ~5.8 CPU-hours,
1 error, 0 timeouts.
**Script:** `reproduce/census_uniqueness_scan.py`; raw output independently spot-
checked this session (not merely trusted from the gap report's prose) by reading
`reproduce/census_uniqueness_run/census_uniqueness_pass2.json` directly -- confirms
m009 at index 2 (consistent with entry 29) and m010 plus several s7xx/o9_xxxx
manifolds at index 1, across three volume tiers (~2.667, ~5.333, ~8.0002).
**Relation to entry 27 (this session's own, independent <=7-tetrahedra field screen):**
entry 27's 17 field-level candidates (a different, smaller "17" -- field-matching
only, restricted to <=7 tetrahedra) is NOT the same set as this entry's 17
(order-matching, full census, any tetrahedra count) -- the coincidence in count (17
and 17) is exactly that, a coincidence between two different filters on overlapping
but non-identical manifold sets. Do not conflate the two "17"s in future citations.
**Papers:** upgrades `gentry-galois-product-theorem.tex` Proposition
"Canonicity of m010" from an earlier ~20,000-manifold slice to a genuine full-census
result; per the gap report this upgrade has not yet been reflected in the paper's own
wording either (separate from the CLAIMS_REGISTER propagation done here).
**Last verified:** Aug 25 2026 (not independently re-run this session; the underlying
JSON output was read and spot-checked this session, Oct 1 2026).

## 31. m009/m010 arithmeticity evidence (propagated from MASTER_GAP_REPORT item 31, dated Aug 25 2026 -- not previously in this register)
**Claim:** both m009 and m010's invariant quaternion algebras are (automatically,
since both are cusped) split, A(Gamma)=M_2(K); trace integrality of Gamma^(2) (the
subgroup generated by squares, trace field K by the Neumann-Reid construction) was
checked on all 4 Reidemeister-Schreier generators of Gamma^(2), all 15 ordered
subset-product traces, and all 64 triple products, for BOTH manifolds: every trace
checked lands exactly in O_K, no exceptions (78/78 checks total).
**Status:** [Computed], extensive but explicitly NOT a formal closed-form certificate
that every element of the infinite group Gamma^(2) has integral trace -- the paper
states this limitation itself rather than overclaiming a full arithmeticity proof.
**Papers:** `gentry-galois-product-theorem.tex`, same Proposition as entry 29.
**Last verified:** Aug 25 2026 (not independently re-run this session).

## 32. m009/m010 are NOT subgroups of the ordinary (or maximally extended) Bianchi group for d=-7 (propagated from MASTER_GAP_REPORT item 34 and OPEN item 2's since-completed sub-results, dated Aug-Sep 2026 -- not previously in this register)
**Claim:** covol(T_7), T_7=PSL_2(O_{-7}), computed exactly via the Humbert volume
formula directly in Sage/PARI: 0.888914927816353. vol(m009)=vol(m010)=2.66674478344906.
Ratio = exactly 3.000000... . A literal embedding of Gamma_009 or Gamma_010 as a
finite-index subgroup of T_7 would therefore require index exactly 3 -- but
Grunewald-Schwermer's torsion obstruction requires any torsion-free finite-index
subgroup of T_7 to have index divisible by 6. 3 is not divisible by 6, so this is
impossible: m009/m010 are not subgroups of ordinary T_7. Separately, Krieg-Rodriguez-
Wernz's maximal discrete extension of SL_2(O_K) for d=-7 was identified exactly
(index exactly 2 over SL_2(O_K), the unique nontrivial extension since d=-7 has one
prime divisor) and a direct GAP low-index-subgroup search of this maximal extension
(not just T_7 itself) found 45 index-6 subgroups, 6 torsion-free, none matching
m009 or m010 (wrong H_1 rank in all 6 cases).
**Status:** [Computed], exact for the volume-ratio/torsion-obstruction argument
(a genuine impossibility proof, not a heuristic); [Computed]/GAP-search for the
maximal-extension non-subgroup result (a completed negative result for the specific
groups searched, not a proof that NO maximal arithmetic lattice contains them -- see
below).
**This directly and pre-emptively refutes a claim relayed to this session** (Oct 1
2026) that m009/m010 are "index-3 covers of the Bianchi orbifold H^3/PSL_2(O_{-7})"
via volume-ratio agreement alone -- the volume ratio of 3 is real and was independently
confirmed, but (as a separate relayed caution had already correctly flagged) a volume
ratio is not by itself a covering/subgroup certificate, and here the torsion
obstruction shows the most natural such covering is actually impossible.
**Not established / genuinely still open (MASTER_GAP_REPORT OPEN item 2, extensive,
not reproduced in full here):** which OTHER maximal arithmetic lattice (not the
standard Bianchi group or its one maximal extension) contains Gamma_009 and
Gamma_010. Substantial partial progress exists (exact Eichler-order level computation
via reduced-discriminant Gram determinants, converged and calibrated: m009's level
works out to an exact index-1 match with its predicted Eichler-order normalizer;
m010's analogous level-(4) computation does NOT give an integer index and is
explicitly flagged as unresolved, needing a two-prime prime-power normalizer theory
not yet sourced from a primary reference) -- this remains open, in progress, and
should be tracked in MASTER_GAP_REPORT, not treated as settled here.
**Last verified:** Sep 2026 (not independently re-run this session; propagated from
the existing gap report, which is itself the authoritative live record of this
still-open sub-investigation).
