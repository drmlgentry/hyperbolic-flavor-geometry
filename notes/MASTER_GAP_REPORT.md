# HFG Program — Master Gap Report

Consolidated 2026-08-25 from a full read of `CLAIMS_REGISTER.md`, all six
`HANDOFF_*.md` files, `GALOIS_WEYL_THEOREM_2026-06-17.md` and
`-06-27.md`, `AUDIT_SNAPSHOT_2026-06-20.md`, `CONFIRMED_abstracts.md`,
`NT_PAPER_OUTLINE_JUNE29.md`, `TRACE_ALGEBRA_JUNE27.md`,
`strengthened_mechanism.md`, `reproduce/q001_writeup_for_gpt.md`,
`reproduce/stage2_invariance_proof.md`, and
`reproduce/stage3_spin_lift_continuity_note.md` (all in
`C:\dev\hyperbolic-flavor-geometry`), plus this session's own work
(census scans, Q-001).

**Evidence tags follow `CLAIMS_REGISTER.md`'s own scheme**
([Proved] / [Computed] / [Structural] / [Statistical] / [Conjecture])
where an item comes from the register. Items from session handoff notes
use "PROVED"/similar labels as the *author asserted them at the time* —
those documents are working notes, not the formal register, so their
tags are reported as-is, not upgraded or downgraded.

A note on provenance: an earlier version of this file was built from a
list of claimed results relayed via an external AI session that cited a
transcript path (`/mnt/transcripts/...`) not reachable from this machine.
That path was never verified to exist. Six of the seven specific claims
in that list turned out to be real and are included below with their
actual sources; the seventh ("F_τ fiber theorem: tr(ρ(a))=−α") was a
conflation of two distinct real theorems about two different manifolds —
see the note at the end of this document.

---

## COMPLETED

### From `CLAIMS_REGISTER.md`

1. **Dual surgery identity** [Proved]. m003(−2,3) ≅ m019(2,1) ≅ M_PMNS;
   volumes agree to 15 significant figures, SnapPy `is_isometric_to`=True,
   both H₁=ℤ/5. (Entry 1)
2. **Galois closure of m003/m019 compositum** [Proved]. Gal(L/ℚ) ≅
   S₄×ℤ/2 ≅ Weyl(SU(4))×Weyl(SU(2)_L). (Entry 2)
3. **m019 cusp field Galois group** [Computed]. x⁴−x−1, disc −283,
   Gal=S₄. (Entry 3)
4. **σ_opt exact value (corrected form)** [Proved]. σ_opt =
   (3/2)log(√(13/5)). (Entry 7, corrected)
5. **M_PMNS minimal-volume-with-H₁=ℤ/5** [Proved]. Unique minimum-volume
   closed hyperbolic 3-manifold *with H₁=ℤ/5* — not the global minimum
   (that's Weeks). (Entry 8, qualified)
6. **CKM negative-result search** [Computed]. No S₄-parent found for
   M_CKM among 9 named manifolds, slopes |p|,|q|≤15. (Entry 11)
7. **Lucas/Fibonacci trace identity (corrected form, v4)** [Proved]. φᵏ+
   φ⁻ᵏ=L_k only for even k; odd k gives √5·F_k. (Entry 12) — supersedes
   the "proved exactly for all k" form used in the earlier SSRN 6754501
   abstract quoted in `CONFIRMED_abstracts.md`.
8. **Linear disjointness K_m003/K_m006** [Proved]. Compositum degree
   6=2×3; Galois closure degree 12, group D₆. (Entry 13)
9. **m010 triple-closure arithmetic (SU(2)_R candidate, arithmetic part
   only)** [Computed]. C₂×C₂×S₄, order 96. Physical reading stays
   [Conjecture]. (Entry 14)
10. **Four-field Galois closure** [Proved] (register text: "not merely
    [Computed]"). Gal ≅ ℤ/2×S₄×ℤ/2×S₃, order 576, over the four cusp
    fields (disc −3, −283, −7, −59). Physical reading stays
    [Conjecture]. (Entry 15)
11. **Stage 2 — oriented G/H coset selector, m006** [Proved] (upgraded
    from [Computed]; full proof in `reproduce/stage2_invariance_proof.md`).
    Peripheral basis-change invariance and orientation-reversal behavior
    of the r₊ embedding selection. (Entry 17)

### From session handoff notes (author-asserted "PROVED"/similar tags)

12. **p₂=31 forced by Frobenius discriminant** ("PROVED June 24," per
    `HANDOFF_JUNE29_2026.md` §16 / `GALOIS_WEYL_THEOREM_2026-06-27.md`
    §16 / `NT_PAPER_OUTLINE_JUNE29.md`). a_31²−4·31=−75=−3·5², uniquely
    among tested tower primes {11,41,61,101,151,211,281}, forcing
    χ₅-twist descent to level 283×31=8773.
13. **Three-Ray Theorem** ("PROVED," `HANDOFF_JUNE27_2026.md` §17, also
    `-2026_v2.md`, `HANDOFF_JUNE29_2026.md`, formalized in
    `NT_PAPER_OUTLINE_JUNE29.md`). Hecke eigenvalues A+B√5 at level 8773
    fall into three classes (B=0; B=−A; B=+A), |A|=|B| always; verified
    for 31 primes. φ is described as "forced" via the Frobenius
    condition plus its own self-referential eigenvalue structure
    (`GALOIS_WEYL_THEOREM_2026-06-27.md` §17).
14. **122-node trace-quotient graph** ("PROVED"/"ESTABLISHED by BFS,"
    `HANDOFF_JUNE27_2026_v2.md`, `GALOIS_WEYL_THEOREM_2026-06-27.md`
    §18, `TRACE_ALGEBRA_JUNE27.md`). Finite 122-node trace-quotient
    graph for π₁(m006(−5,2)) (88 nodes in the scan range); includes
    tr(ρ(a))=−α where α generates the degree-10 ITF field K₁₀ (this is
    a *different* result from the F_τ fiber theorem below — see the
    provenance note); tr(ρ(ab))=tr(ρ(a)) (Fricke codim-1 collapse); other
    exact trace-collapse identities.
15. **Lucas-geodesic bridge theorem** (named and "proved exactly" per
    `GALOIS_WEYL_THEOREM_2026-06-17.md` §4b and the SSRN 6754501 abstract
    quoted in `CONFIRMED_abstracts.md`): ℓ(γ)=2k·log(φ) ⟺ |tr(ρ(γ))|=L_k.
    **Caveat:** this "all k" form is the version `CLAIMS_REGISTER.md`
    entry 12 later corrects — see item 7 above. Treat the even-k-only
    form as current.
16. **Same-search null test, CKM** ("PASSED, p=0.005,"
    `HANDOFF_JUNE29_2026.md`, `CLAIMS_REGISTER.md` entry 10). Real CKM
    fitness 0.003989 vs. 200 Haar-random targets (mean 0.288, min
    0.146); one-sided p=0.005 (corrected).
17. **General law a_p≡p+1 (mod 5) for X₀(11)** (`strengthened_mechanism.md`),
    derived from the classical Mazur/Ogg torsion-injects-into-reduction
    fact; independently checked on 19 non-tower primes and extended to
    k=60 tower primes (p_k≤18301), zero exceptions.
18. **Census null test (m006(−5,2))**: ranks 6th of 12 H₁=ℤ/5 census
    manifolds by fitness, but is the unique one with ITF signature
    (8,1) — framed as a falsifiable selection criterion, not a
    fitness-ranking claim.
19. **m006 Langlands bridge** ("✅ Proved," `GALOIS_WEYL_THEOREM_2026-06-17.md`).
    Artin rep 2.59.3t2.a → newform 59.1.b.a, 11 Frobenius eigenvalues
    match LMFDB exactly.
20. **F_τ fiber theorem** ("✅ Proved," same source). For the *cusped*
    m006: F_τ={w : tr(ρ(w))=τ̄} has exactly 4 oriented conjugacy classes
    (interval-certified), n_a=±2, n_b≢0 mod 5. This is a separate result
    from item 14's tr(ρ(a))=−α (different manifold: cusped m006 vs.
    closed m006(−5,2); different target: Q(τ), degree 3, vs. K₁₀, degree
    10).
21. **Hecke-character theorem** (§12, `GALOIS_WEYL_THEOREM_2026-06-17.md`):
    every cover-tower prime p_n≡1 (mod 5) admits a non-trivial order-5
    Hecke character of Q(√−3).
22. **WRT Slope Norm Theorem** ("PROVED," `HANDOFF_MAY25_2026.md`):
    |WRT_r(M_PMNS)|²=13/r for r≡1,3 mod 4 (plus variants for other
    residues).
23. **CKM ITF confirmed** (`HANDOFF_MAY25_2026.md`): degree-10
    polynomial x¹⁰−7x⁸−4x⁷+17x⁶+14x⁵−18x⁴−14x³+8x²+3x−1, disc=
    −271488204251=−11×239×103266719, signature (8,1); stable across
    200/300/500-bit precision.
24. **X₀(11) Bianchi/Hilbert base-change**: 12/12 Hecke eigenvalues
    match ("Verified," `HANDOFF_MAY25_2026.md`).

### This session's own work

25. **Q-001 Fricke-collapse exact resolution** ("RESOLVED," 2026-08-24,
    `reproduce/q001_writeup_for_gpt.md`, commit `e419cfa`). B=A/(q₁₀(x))
    has dim 20 exactly; induced M_u on B has rank 10 and M_u²=0 exactly
    — confirmed by exact rational linear algebra, not modular/numerical
    evidence alone (the modular evidence at 4 primes had earlier come
    from a parallel, unverified session; this session re-derived it
    exactly).
26. **m009/m010 cusp-order distinction** [Proved via exact algebraic
    identity] (`gentry-galois-product-theorem.tex` Proposition 3.2, this
    session, 2026-08-24): cusp shapes √−7 (order Z[√−7]) vs.
    (1+√−7)/2 (maximal order O_K), index 2 apart.
27. **m009/m010 arithmeticity** [Computed, extensive but not a formal
    closed-form certificate]: 78/78 Γ^(2) trace-integrality checks (15
    Horowitz-Southcott generators + 64 triple products) land exactly in
    O_K, both manifolds.

---

## OPEN (highest priority first)

1. **[GAP-001] Stage 3 blind session — mapping geometric states to mass
   indices.** Stage 1 (canonical C₂ transposition) + Stage 2 (Entry 17,
   [Proved]) give a 2×3=6-element geometric state space; Stage 3A (Entry
   18, [Structural]) independently confirms the same six-slot structure.
   **No map from those six states to the six actual quark mass indices
   {12, 18, 43, 65, 75, 106} has been attempted** (`CLAIMS_REGISTER.md`
   lines 289–291, 334–337 — "That remains completely open"). The frozen
   six-state invariant table is in `reproduce/stage3_state_invariants.csv`.
   To close: pass the frozen table to a fresh session blind to the
   targets, construct one narrow pre-committed rule F, evaluate once,
   require uniform F across all six states — see the full protocol in
   the previous version of this report / session notes.

2. **[GAP-002/CLAIMS-18] Stage 3A deformation theorem — three unverified
   hypotheses.** Entry 18 is [Structural], not [Proved], specifically
   because: (1) existence of the continuous cone-manifold deformation
   path α∈[0,2π] is cited (Thurston; Neumann-Zagier; Hodgson-Kerckhoff),
   not re-derived; (2) the monotonicity argument at α=π was checked in
   Menal-Ferrer–Porti's proof for their own auxiliary curve, not
   independently for the slope s=−5μ+2λ; (3) irreducibility along the
   full deformation path has not been explicitly checked. See
   `reproduce/stage3_spin_lift_continuity_note.md` for the exact gap.

3. **[GAP-003/CLAIMS-16] Geometry-only lepton mass selector
   {Q_e=0, Q_μ=44, Q_τ=68}.** [Conjecture]. The source script's own
   status note admits "the rule is NOT yet canonically derived"; there
   are free choices in which invariant/operation/prime-selection rule to
   use, and real look-elsewhere risk since the targets (44, 68) were
   already known when the rule was built. Contrast: the analogous quark
   selector search (`hfg_quark_selector_audit.py`) found **no uniform
   rule at all** — an explicit negative result.

4. **[GAP-004/CLAIMS-10] CKM fitness canonical value.** Conflicting
   values (0.016482, 0.003618, 0.003989) still circulate across
   different papers/sessions for the "canonical" F=0.002728 (σ=0.47).
   M_CKM explicitly ranks 82nd/134 in the census, not best-in-class —
   needs reconciling which value is authoritative and why.

5. **[GAP-005] Bianchi index-6 subgroup enumeration for m009/m010.**
   Conjecture that both are torsion-free index-6 subgroups of the
   extended d=−7 Bianchi group T_7=PSL₂(O_{−7}) or its maximal discrete
   extension Γ~_{−7} (covolume≈0.4445). **The Grunewald-Schwermer
   citation (forbidding index-3 torsion-free subgroups of T_7) and the
   Dinakaran (2022)/Reese (2023) presentation citations have not been
   independently checked** — verify these before spending GAP compute
   time on `LowIndexSubgroups(T_7, 6)`.

6. **[GAP-006] Census-wide rarity of the C₂×S₄×C₂×S₃ configuration.**
   Is the disjoint-ramification quadruple type (and the specific primes
   {3,7,59,283}) rare across the full 212,641-manifold census? Running
   this session as `census_disjoint_ramification_scan.sage.py`
   (checkpointed, resumable, hard OS-level per-manifold timeout after an
   earlier `signal.alarm()`-based approach was found not to actually
   bound cost). Currently deep in the census's `s`-family (6-tetrahedron
   manifolds), where most manifolds fail to resolve under
   `--degree-bound 10`/`--closure-degree-max 48` — a structural finding
   that trace-field complexity outgrows these bounds past the
   `m`-family; whether to loosen bounds, accept lower yield, or add a
   pre-filter is an open methodology decision.
   A companion scan (`census_uniqueness_scan.py`, testing whether m010
   is uniquely the minimum-volume manifold realizing the maximal cusp
   order O_K) is separately running, near completion.

7. **[GAP-007] Dual surgery paper (SSRN 7277458) revision + venue.**
   AGT rejected (desk decision: "too narrow in scope," not a math
   error) — needs an explicit prior-unknown statement, Neumann-Reid
   commensurability framing, forward-looking questions. Candidate venues
   not yet chosen: Geometriae Dedicata, JLMS, Michigan Math. J.,
   Experimental Mathematics. Do not resubmit to AGT.

8. **Physical/Pati-Salam interpretation of S₄×ℤ/2 and the 576-element
   closure** [Conjecture] (CLAIMS entries 4, 14, 15, 17, 18 — same
   status throughout). Arithmetic is proved in every case; no
   field-theoretic mechanism (Class S / 3D-3D bridge) connects any of it
   to physical gauge groups. This is the umbrella status for essentially
   all "physical reading" claims in the program.

9. **Volume quantum mechanism** (`AUDIT_SNAPSHOT_2026-06-20.md`,
   `HANDOFF_JUNE22_2026.md`): vol(m019)=3v₀, vol(m178)=4v₀ verified
   numerically to 4.44e-16 (T-orbit/Bloch-Wigner mechanism understood),
   but **why D(z₀)=v₀ specifically** — the algebraic proof — is still
   open.

10. **m003 Langlands bridge** ("📝 Structurally established," not proved
    to the m006 standard, `GALOIS_WEYL_THEOREM_2026-06-17.md`): level-283
    Bianchi form connection established structurally, but "Hecke
    eigenvalue verification pending (CAPTCHA blocked)."

11. **F_τ ↔ covering-tower biconditional — explicitly falsified as
    originally claimed** (`GALOIS_WEYL_THEOREM_2026-06-17.md` §11/§12:
    "This biconditional is false — the converse fails"). Only the
    one-directional (Level A) statement holds. The Lucas mass-ratio
    chain from the tower (Chain 4) is listed as "Level C... still
    open."

12. **Whether p₂=31=conductor(χ₅) is "forced" or coincidental** —
    explicitly called "a clean open question for future investigation"
    even after the Frobenius-discriminant mechanism (item 12 above) was
    worked out (`GALOIS_WEYL_THEOREM_2026-06-27.md` §15). Related: does
    the same Q(√5) dimension-split pattern hold at p₃=61 (level
    283×61=17263)? — checked and it does NOT hold as a general pattern
    (falsified at p₃=61, p₅=151 per `AUDIT_SNAPSHOT_2026-06-20.md`),
    leaving why it holds specifically at p₂=31 unexplained.

13. **Whether Hecke eigenvalue values a_p(X₀(11)) encode fermion mass
    values** (not just lattice structure) — unresolved
    (`GALOIS_WEYL_THEOREM_2026-06-27.md` §17, `NT_PAPER_OUTLINE_JUNE29.md`
    §6).

14. **Degree-8 subfield identity** containing tr(AAAAB), tr(aaaba) —
    whether it's a subfield of the Galois closure of K₁₀ — unresolved
    (`TRACE_ALGEBRA_JUNE27.md`, `NT_PAPER_OUTLINE_JUNE29.md` §6).

15. **F_τ/golden-ratio bridge** (`HANDOFF_JUNE22_2026.md` Thread 4): the
    F_τ fiber (in Q(τ_m006), disc −59) and the Q(√5) component at level
    8773 have no direct containment bridge (compositum is degree 6);
    completing this needs twisted Bianchi eigenvalue computation in
    Sage. A related result (Thread 6) suggests the Lucas-number
    connection specifically will NOT hold.

16. **Full census extension** — the uniqueness/selection census checks
    so far only covered the first 80–200 of ~10,000+ manifolds
    (`GALOIS_WEYL_THEOREM_2026-06-17.md` §5); this session's
    `census_uniqueness_scan.py`/`census_disjoint_ramification_scan.sage.py`
    (item 6 above) are the actual full-census follow-through on this.

17. **h(P₁)=0.020644 vs. sin²θ₁₃=0.02220±0.00068** — 2.3σ discrepancy,
    "no mechanism established... do not claim until mechanism found"
    (`GALOIS_WEYL_THEOREM_2026-06-17.md` §10).

18. **SSRN 6631218** neutrino mass prediction (m_ν=71.4±2.9 meV) —
    stated as falsifiable by future CMB-S4 data; untested.

19. **SSRN 6775158** correction note — SSRN form was failing with a save
    error; action was to email support@ssrn.com with the corrected text
    (Q(√17) retraction + σ_opt fix). Not confirmed done.

20. **SSRN 6876278** (Sextic-Octic decomposition) — still listed as
    PRELIMINARY_UPLOAD, needs formal submission.

21. **p=31 double role** — whether p=31 being both the tower prime p₂
    AND the unique prime with ord₃₁(5)=3 is one fact or two unrelated
    coincidences is unresolved (`HANDOFF_JUNE22_2026.md`).

---

## Retracted / superseded (kept for record, not open or completed)

- **CKM ITF = Q(√17)** — wrong; real quadratic fields cannot be
  invariant trace fields of arithmetic Kleinian groups. Correct ITF is
  the degree-10 field, disc −271488204251, signature (8,1).
  (`CLAIMS_REGISTER.md` Entry 6)
- **Eisenstein-norm BPS mass ratios** (208, 3477 for muon/tau) —
  Monte Carlo p=0.106 (tau), p=0.862 (muon); explicitly "do not cite as
  evidence." (Entry 5)
- **m206(1,2) "order-6 torsion"** — actual H₁=ℤ/5, not order 6.
  (Entry 9)
- **Universal spectral gap conjecture** — falsified by a ℤ/47
  counterexample. (`AUDIT_SNAPSHOT_2026-06-20.md`)
- **Lucas-geodesic bridge, "all k" form** — corrected to even-k-only;
  see item 15 in Completed and item 7 in the original numbered list.
- **F_τ ↔ covering-tower biconditional** — the converse direction is
  false; see OPEN item 11.

---

## Provenance note: externally-relayed disputed claims

A prior draft of this report was built from a list of results relayed
via an external AI session, which cited `/mnt/transcripts/2026-08-25-...txt`
as its source. That path does not exist on this machine (checked via
both WSL and the Windows filesystem) — it may belong to a different
environment, or be fabricated. Rather than trust the relayed list, each
claimed item was checked directly against the actual corpus files by a
dedicated extraction pass. Result: 6 of 7 claims were real and are
included above with correct sourcing (Three-Ray Theorem, the 122-node
graph, the p=31/Frobenius result, the Lucas-geodesic bridge theorem —
noting its corrected form, the same-search null test, and the lepton
selector). The seventh, "F_τ fiber theorem: tr(ρ(a))=−α," conflated two
distinct real theorems about two different manifolds (the F_τ fiber
theorem for cusped m006, and a separate trace identity for closed
m006(−5,2)) — see items 14 and 20 above for the correct, separate
statements.
