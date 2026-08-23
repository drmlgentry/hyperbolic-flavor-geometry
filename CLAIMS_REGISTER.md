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
