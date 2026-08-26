# HFG Program — Master Gap Report

Rebuilt 2026-08-25 (second rebuild). Primary source this time:
`C:\dev\hyperbolic-flavor-geometry\MASTER_GAP_REPORT.md` — a 50KB,
chronologically-maintained research journal (dated entries Aug 3 through
Aug 23 2026) at the repo **root**, missed entirely in the first two
versions of this document because only `notes/` and `HFG-CORPUS` were
searched. That file is the authoritative primary log; this document is a
derived snapshot summarizing it plus the other corpus files. Do not
overwrite the root journal — append to it going forward, per this
project's own established discipline (see `CLAUDE.md`'s
progress-log policy).

Also incorporated: `CLAIMS_REGISTER.md` (full), all six `HANDOFF_*.md`
files, `GALOIS_WEYL_THEOREM_2026-06-17/-06-27.md`,
`AUDIT_SNAPSHOT_2026-06-20.md`, `CONFIRMED_abstracts.md`,
`NT_PAPER_OUTLINE_JUNE29.md`, `TRACE_ALGEBRA_JUNE27.md`,
`strengthened_mechanism.md`, `reproduce/q001_writeup_for_gpt.md`,
`reproduce/stage2_invariance_proof.md`,
`reproduce/stage3_spin_lift_continuity_note.md`, and the Stage 3 blind-test
primary sources (`STAGE3_BLIND_PACKET.md`, `STAGE3_SCORING_CRITERION.md`,
`STAGE3_DATASET_ERRATA.md`, `stage3_blind_response_claude.md`,
`stage3_blind_response_gpt.md`), all in
`C:\dev\hyperbolic-flavor-geometry`, plus this session's own work.

**Evidence tags** follow `CLAIMS_REGISTER.md`'s scheme ([Proved] /
[Computed] / [Structural] / [Statistical] / [Conjecture]) where an item
comes from the register; items from handoff/journal notes use the tag the
author gave at the time, reported as-is.

---

## Provenance note (read before trusting any external relay again)

A session earlier today built this file from a list of claimed results
relayed via an external AI session that cited a transcript path,
`/mnt/transcripts/...`, as its source. **That path does not exist on this
machine** — confirmed by checking every WSL distro (only one, "Ubuntu",
exists), every `/mnt` entry, and a full-drive search for both a
"transcripts" directory and the specific claimed filenames, all empty.
It was not mounted; there is nothing to mount.

Rather than either blindly trust or blindly dismiss the relayed claims,
each was checked directly against the real corpus. Result: **6 of 7 were
real** (found verbatim or in clear substance, correctly sourced below);
the 7th ("F_τ fiber theorem: tr(ρ(a))=−α") conflated two distinct real
theorems about two different manifolds — see items 24 and 30 below for
the correct, separated statements. Separately, and much more
significantly: the relayed claim that a full blind mass-selector
experiment had already been run — which this document's first two
versions listed as still-open (GAP-001) — turned out to be **true**, not
because of the cited transcript, but because the actual record was
sitting in the repo-root `MASTER_GAP_REPORT.md` the whole time, which
simply hadn't been found yet. All five referenced git commits
(`29c3c08`, `4f322ae`, `8139c2d`, `8336b7b`, `070e62d`) were independently
verified to exist with matching commit messages.

**The lesson, made standard practice going forward:** an externally-relayed
claim is neither proof nor noise — it's a lead. Check it against primary
sources before writing it into any report with a status tag, and keep
checking even after finding it wrong once, since it can also turn out to
be right for the wrong stated reason.

---

## COMPLETED

### Stage 1–3 geometric state-space program (the mass-index selector chain)

1. **Stage 1 — canonical prime-lift transposition** [Computed], not yet
   [Proved] abstractly (verified computationally on 6 tower primes: 11,
   31, 61, 101, 151, 211). For each, the residue-degree-1 prime q₁ of K
   stays inert in L/K, and its decomposition group equals exactly
   H=Gal(L/K)={e,h}, order 2 — real ideal arithmetic, no root-ordering
   choices. Forces a no-go noted at the time: |H|=2 means every
   transposition-type prime selects the *same* h, so this datum alone
   cannot distinguish six quark slots on its own.
2. **Stage 2 — oriented G/H coset selector** [Proved] (`CLAIMS_REGISTER.md`
   entry 17; full proof `reproduce/stage2_invariance_proof.md`).
   Peripheral basis-change invariance (all 7 tested SL(2,Z) bases,
   residuals ~1e-16) and orientation-reversal swapping the two complex
   embeddings while fixing the real one.
3. **Stage 3A — original question resolved NEGATIVELY (no mass indices
   consulted), refined target identified.** Does (h, gH) canonically
   reconstruct a specific g∈S₃? **No** — verified by brute-force S₃
   enumeration, a genuine two-fold ambiguity, not a technicality (each
   coset splits into one even/one odd element; Stage 1 only ever supplies
   h, never e). Refined target found and verified: an independent binary
   parity datum ε∈{e,h} paired with the Stage-2 coset reconstructs a full
   g∈S₃ via g = the unique x∈gH with sgn(x)=sgn(ε) — an exact bijection
   H×G/H→G, confirmed by direct enumeration.
4. **Stage 3A — spin-lift binary state realizing ε** [Structural]
   (`CLAIMS_REGISTER.md` entry 18). H₁(m006;ℤ/2)≅ℤ/2 verified directly
   from the actual fundamental group presentation; by Menal-Ferrer–Porti,
   SL(2,C) lifts form a torsor over H¹(M;ℤ/2); computed from actual
   holonomy traces (SnapPy default lift: tr(μ)=+2, tr(λ)=−2, tr(s)=+2)
   that the filling-extending lift is the χ-twist of the default, not
   the default itself — giving a concrete, falsifiable ε. Combined with
   Stage 2: a genuine 2×3=6-element geometric state space, none of it
   derived from or tuned against "there are six quarks." Not [Proved]:
   three named technical hypotheses (continuous deformation path cited
   not re-derived; monotonicity at α=π checked only for
   Menal-Ferrer–Porti's own curve; irreducibility along the full path
   not explicitly checked) — see `reproduce/stage3_spin_lift_continuity_note.md`.
5. **Stage 3 — pre-registered success criterion locked before any
   attempt** (`STAGE3_SCORING_CRITERION.md`, commit `4f322ae`). A single
   fixed rule F, applied uniformly to all six frozen states, using only
   invariants already attached by Stages 1–3A — mass indices play no
   role in choosing F; correspondence between states and targets fixed
   independently of both sides' values (state_id order paired with
   target-set increasing order) *before* comparison, not chosen after
   seeing which output is closest to which target.
6. **Stage 3 — first attempt: INCONCLUSIVE**, correctly not counted as a
   real test. A genuine blinding problem: the agent choosing F already
   held the target list in its working context (a live example
   surfaced: 59·|root²|≈12.13 for one state, near the first target —
   flagged as exactly the failure mode, not a finding). Also: the
   invariant table was too thin (every column beyond the bare root value
   was a deterministic recoding of the same one complex number).
7. **Stage 3 — full blind protocol, run to completion, NULL result**
   [Computed — this is a completed negative result, not an open
   question]. Sealed packet (`STAGE3_BLIND_PACKET.md` +
   `stage3_blind_states.json`, commit `29c3c08`, verified leak-free of
   target integers/domain keywords) handed to two independent fresh
   sessions (one Claude, one GPT), neither exposed to the target list.
   Both responses frozen, hashed, and committed before the target set
   was opened (`8139c2d` Claude sha256 `371ea4f4...`, `8336b7b` GPT
   sha256 `8128d688...`). Five candidate rules produced: `N_{K/Q}(tr_a)`
   (found independently by both sessions), `Tr_{K/Q}(tr_a)`,
   `tr_b−tr_a`, `round(3/π·Arg(tr_a))`. **Unblinding: every candidate
   scores 0/6 exact matches, 0/6 within tolerance-1, and 0/6 under the
   weaker permutation-allowed set-match check** — deviations are tens of
   units against a 12–106 range, not a borderline call.
   **Precise result, not overstated:** "No natural selector within the
   pre-registered low-complexity function class (round(AI+B), field
   norm/trace, simple linear combinations of at most two invariants)
   recovered the target indices from the frozen invariant set." This is
   the anticipated valid negative outcome the protocol was built to
   allow, not a failure of the experiment — commit `070e62d` is a
   milestone. Mechanisms eliminated (not merely untested): frozen
   norm/trace of tr_a, peripheral-trace-derived values, the simple trace
   difference, the degree-normalized principal-argument candidate.
   Mass-index selector as a whole: **still open** (see OPEN item 1) —
   what's closed specifically is this function class over these five
   invariants.
8. **Stage 3 dataset erratum, found and corrected without touching the
   frozen packet** (`STAGE3_DATASET_ERRATA.md`). The sealed packet's
   claim "tr_b=tr_a+1 exactly, in every state" is an overgeneralization
   — true only for ε=+1; for ε=−1, tr_b=1−tr_a (since tr_b never flips
   with ε while tr_a does). Caught by the blind GPT session checking raw
   data rather than trusting the packet's summary. `stage3_blind_states.json`
   left untouched (historical experimental input); correction lives
   separately and is now baked into `reproduce/stage3_enrich_state_invariants.sage`'s
   regenerated outputs. Did not change the blind test's outcome — Claude
   candidate #3 was already failing regardless.

### From `CLAIMS_REGISTER.md`

9. **Dual surgery identity** [Proved]. m003(−2,3) ≅ m019(2,1) ≅ M_PMNS.
10. **Galois closure, m003/m019 compositum** [Proved]. S₄×ℤ/2 ≅
    Weyl(SU(4))×Weyl(SU(2)_L).
11. **m019 cusp field Galois group** [Computed]. x⁴−x−1, disc −283, S₄.
12. **σ_opt exact value** [Proved]. (3/2)log(√(13/5)).
13. **M_PMNS minimal-volume-with-H₁=ℤ/5** [Proved] (qualified — not the
    global minimum, that's Weeks).
14. **CKM negative-result search** [Computed]. No S₄-parent for M_CKM
    among 9 named manifolds, |p|,|q|≤15.
15. **Lucas/Fibonacci trace identity, corrected (v4)** [Proved]. φᵏ+φ⁻ᵏ=L_k
    for even k only; odd k gives √5·F_k.
16. **Linear disjointness K_m003/K_m006** [Proved]. Degree 6 compositum,
    D₆ closure.
17. **m010 triple-closure arithmetic (SU(2)_R candidate)** [Computed].
    C₂×C₂×S₄, order 96.
18. **Four-field Galois closure** [Proved]. Gal≅ℤ/2×S₄×ℤ/2×S₃, order 576.

### From session handoffs and research notes

19. **p₂=31 forced by Frobenius discriminant** ("PROVED June 24"). a_31²−4·31=
    −75=−3·5², uniquely among {11,41,61,101,151,211,281}.
20. **Three-Ray Theorem** ("PROVED"). Hecke eigenvalues A+B√5 at level
    8773 fall into three classes, |A|=|B| always; φ described as
    "forced" via the Frobenius condition plus its own self-referential
    eigenvalue structure.
21. **122-node trace-quotient graph** ("PROVED"/"ESTABLISHED by BFS").
    Finite trace-quotient graph for π₁(m006(−5,2)); includes
    tr(ρ(a))=−α (α generates K₁₀) and tr(ρ(ab))=tr(ρ(a)) (Fricke
    codim-1 collapse).
22. **Lucas-geodesic bridge theorem**, corrected form only (superseded
    "all k" form retracted — see below).
23. **Same-search null test, CKM**: fitness 0.003989 vs. 200 Haar-random
    targets, one-sided p=0.005.
24. **m006 Langlands bridge** ("✅ Proved"). Artin rep 2.59.3t2.a →
    newform 59.1.b.a, 11 Frobenius eigenvalues match LMFDB exactly.
25. **F_τ fiber theorem** ("✅ Proved," *cusped* m006). F_τ={w :
    tr(ρ(w))=τ̄} has exactly 4 oriented conjugacy classes. **Distinct**
    from item 21's tr(ρ(a))=−α (different manifold, cusped vs. closed;
    different target field, degree 3 vs. degree 10).
26. **General law a_p≡p+1 (mod 5) for X₀(11)**, from the classical
    Mazur/Ogg torsion-injects-into-reduction fact; zero exceptions on 19
    non-tower primes + 60 tower primes up to p_k≤18301.
27. **WRT Slope Norm Theorem** ("PROVED"). |WRT_r(M_PMNS)|²=13/r for
    r≡1,3 mod 4.
28. **X₀(11) Bianchi/Hilbert base-change**: 12/12 Hecke eigenvalues
    match.

### This session's own work

29. **Q-001 Fricke-collapse exact resolution, including the nilpotent-
    thickening formulation** ("RESOLVED," commit `e419cfa`;
    `reproduce/q001_writeup_for_gpt.md`). B=A/(q₁₀(x)) has dim 20
    exactly; multiplication by u=z−x on B has rank 10 and **u²=0
    exactly** — confirmed by exact rational linear algebra. The writeup
    already states the precise ring-theoretic structure this gives:
    **B ≅ K[ε]/(ε²)** (the dual numbers over the degree-10 field K, with
    ε=z−x) — equivalently, in the ambient ring, z−x∈√(I+⟨q₁₀(x)⟩)∖(I+⟨q₁₀(x)⟩).
    z=x holds exactly on the reduced geometric component, while z−x is a
    genuine order-2 nilpotent at the scheme level, not literally zero
    there. (An externally-relayed suggestion to compute this radical as
    a fresh next step was checked against this file and found to already
    be answered by the existing result — no new computation needed;
    u²∈J with u∉J already gives u∈√J by definition, and u∉J follows
    immediately from rank(M_u)=10≠0.)
30. **m009/m010 cusp-order distinction** [Proved via exact algebraic
    identity] (`gentry-galois-product-theorem.tex` Prop. 3.2). τ₉=√−7
    (order Z[√−7]), τ₁₀=(1+√−7)/2 (maximal order O_K), index 2 apart.
31. **m009/m010 arithmeticity** [Computed, extensive but not a formal
    closed-form certificate]: 78/78 Γ^(2) trace-integrality checks land
    exactly in O_K.
32. **m010 uniquely the minimum-volume maximal-order manifold, full
    census** [Computed — exact, not statistical]. `census_uniqueness_scan.py`
    ran to completion across the entire 212,641-manifold
    OrientableCuspedCensus (~5.8 CPU-hours, 1 error, 0 timeouts). 37
    manifolds share invariant trace field Q(√−7); 17 realize the maximal
    order O_K (exact `p+qb` index check, not numerical); m010
    (vol=2.66674478344906) is uniquely the minimum-volume manifold among
    all 17 — the next-smallest maximal-order manifolds are all at
    exactly double that volume. Upgrades
    `gentry-galois-product-theorem.tex` Proposition 3.2 from an early
    ~20,000-manifold slice to a genuine full-census result. Not yet
    propagated into `CLAIMS_REGISTER.md` or the paper's own wording —
    both still open, see below.
34. **m009/m010 cannot be subgroups of ordinary T_7=PSL₂(O_{−7})**
    [Computed — exact]. covol(T_7) independently computed this session
    via the Humbert volume formula directly in Sage/PARI (not taken from
    any relay): **0.888914927816353**. vol(m009)=vol(m010)=2.66674478344906.
    Ratio = 2.66674478344906/0.888914927816353 = 3.000000... exactly. A
    literal embedding would therefore require index 3 — but
    Grunewald-Schwermer's torsion obstruction requires any torsion-free
    finite-index subgroup of T_7 to have index divisible by 6. The two
    facts are incompatible, so m009/m010 are not subgroups of ordinary
    T_7. This redirects the Bianchi search to the maximal arithmetic
    extension T7~ — see OPEN item 2.

---

## OPEN (highest priority first, per the revised assessment below)

**Note on ordering:** an external review (relayed via the user, cross-
checked against the corpus and mostly upheld — see the provenance note)
proposed re-ranking the program's priorities toward the arithmetic/
Langlands results, which have survived serious testing repeatedly, and
away from further attempts at a mass-index formula, which is precisely
where the negative results and look-elsewhere concerns concentrate. That
re-ranking is reflected in the order below; each item still stands on
its own regardless of rank.

1. **Mass-index selector — dormant, not abandoned.** The pre-registered
   low-complexity function class over the current five invariants is
   exhausted and failed (item 7 above). The correct next move, per the
   program's own next-step note, is **not** an unconstrained search over
   more elaborate functions of the same invariants (that would
   reintroduce exactly the look-elsewhere problem the blind protocol
   exists to prevent) — it requires genuinely new, independently
   motivated geometric content established *before* checking whether it
   improves the match: candidates named are non-peripheral holonomy
   words beyond a/b, complex lengths/eigenvalues of geometrically
   distinguished elements, representation characters beyond tr_a/tr_b,
   or exact arithmetic attached to the filling representation.

2. **Bianchi subgroup identification for m009/m010 — GAP search complete
   for one candidate parent group; result precisely scoped, not yet a
   theorem about the manifolds.** `Γ_{009}, Γ_{010}` are proved not to be
   subgroups of ordinary T_7=PSL₂(O_{−7}) (COMPLETED item 34). The
   presentation blocker is resolved: the Reese paper's full text was read
   directly (arXiv:2206.01262 is legitimately open access — no
   institutional login or piracy involved), giving the exact d=−7
   presentation, Γ_{−7}=⟨A,B,U | B², (BA)³, AUA⁻¹U⁻¹, (BAU⁻¹BU)²⟩ with
   A=[[1,1],[0,1]], B=[[0,1],[−1,0]], U=[[1,ω],[0,1]] (p.12). Peripheral
   generators: A (=T₁), U (=T_ω). The Stage-2 conjugation action was
   computed from these real matrices and independently checked
   numerically (zero error): J·g·J⁻¹=g⁻¹ for all of g∈{A,B,U} (this
   follows automatically from J,A,B,U being real matrices in one common
   ambient group — conjugation is always a genuine automorphism, so it
   necessarily preserves every relation the generators satisfy; this
   does not by itself certify the resulting *presentation* is complete).
   `reproduce/bianchi_d7_lowindex.g` was run end-to-end in GAP:
   - Stage 1 sanity checks passed: all 3 index-3 classes of T_7 show
     torsion, as required.
   - Stage 2 (the constructed group G_GAP=⟨T_7,J⟩): 45 index-6
     subgroups, 6 torsion-free, **none matching m009 or m010** — all 6
     have entirely finite H₁ (zero free rank) against both targets'
     required free rank 1.
   - **Presentation audit performed in response to a methodologically
     sound objection** (relayed via the user: automorphism-preserves-
     relators alone doesn't certify the extension presentation is
     complete/faithful) — checked directly in GAP:
     T_7's own abelianization from this presentation is [0,2]=Z⊕Z/2,
     which matches Reese's own published table value (Γ₋₇ᵃᵇ=C₂×C∞)
     *exactly* — real evidence the T_7 presentation was entered
     correctly, since a relator typo would very likely break this
     match. ⟨A,B,U⟩ sits at index exactly 2 inside G_GAP and is normal,
     as intended. B and BA retain their expected orders (2, 3) inside
     G_GAP — nothing collapsed. G_GAP's abelianization is [2,2,2] (all
     torsion) — initially surprising, but this is the *predicted*
     consequence of jAj⁻¹=A⁻¹ becoming A²=1 once abelianized (conjugation
     is trivial in an abelian quotient), not evidence of an error. All
     five checks pass cleanly and consistently — meaningfully raises
     confidence that G_GAP is a faithful presentation of ⟨T_7,J⟩, though
     it does not amount to a full independent proof of that fact.
   - **MAXIMALITY CONFIRMED — result upgraded.** Read Vulakh's cited
     companion source directly: Krieg, Rodriguez, Wernz, "The maximal
     discrete extension of SL₂(O_K) for an imaginary quadratic number
     field K," *Arch. Math.* (2019), arXiv:1811.08251 — citation
     verified real via the authors' own institutional listing, then the
     full text read directly (legitimately open access). Their Theorem
     1 + Proposition give [Γ*_K : SL₂(O_K)] = 2^ν, ν = #{primes dividing
     d_K}. For d_K=−7 (prime discriminant), ν=1, so the index is exactly
     2 — only one possible nontrivial extension exists at all. Checked
     by hand whether J=diag(−1,1) (this session's extension generator)
     actually satisfies their Proposition's precise membership condition
     for Γ*_K: taking (α,β,γ,δ)=(−1,0,0,1) — literally in O_K, and the
     ideal condition ⟨αδ−βγ⟩=⟨−1⟩=O_K=⟨α,β,γ,δ⟩ holds — confirms
     J genuinely is an element of Γ*_K. Since ν=1 means only one
     nontrivial coset exists, J and the paper's own Atkin-Lehner-style
     generator V_7 must generate the identical extension. **This
     confirms, independently and from the primary source (not merely
     asserted), that B_7=PGL₂(O_{−7}) as constructed in
     `bianchi_d7_lowindex.g` genuinely is the maximal discrete extension
     for d=−7** — matching Vulakh's terminology exactly.
   - **Result, now correctly upgraded:** m009 and m010 are confirmed
     **not** to be index-6 subgroups of the maximal discrete extension
     of the standard d=−7 Bianchi group — not merely of one particular
     constructed presentation. m009/m010's own cusp-order theorem (item
     30) remains entirely unaffected; what changes is the shape of the
     open question below.
   - **The open question has changed accordingly.** It is no longer "is
     there a larger extension of T_7?" — that branch is closed. It is
     now: **which maximal arithmetic lattice, among those in the same
     Q(√−7) commensurability class, actually contains Γ_009 and
     Γ_010?** Equal volume does not force m009/m010 to share the same
     maximal parent lattice — the invariant trace field being M₂(K)-
     split (already established) permits other maximal arithmetic
     lattices arising as normalizers of other Eichler-type orders in
     M₂(K), which need not literally contain the standard Bianchi group
     PSL₂(O_K). A structurally attractive possibility, consistent with
     the already-proved cusp-order distinction (Z[√−7]⊂O_K, index 2):
     Γ_009 and Γ_010 could sit in maximal lattices attached to two
     *different* orders R₉, R₁₀ that happen to share the same covolume.
     Proposed (not yet attempted) computational route: for each
     manifold, compute the O_K-order R_i generated by the (now
     confirmed-integral, see below) squared-generator holonomy matrices,
     determine its local level/discriminant, compute its normalizer in
     PGL₂(K) and that normalizer's covolume, then recover the genuine
     subgroup index via vol(m_i)/covol(N(R_i)) — only after that,
     enumerate subgroups of the correct parent.
   - **Partial progress on that route: Γ^(2) holonomy entries tested
     directly, more informative than the earlier raw-generator test.**
     Ran `reproduce/m009_m010_gamma2_holonomy_order_test.py`: pulled
     m009/m010's holonomy for the squared/product generators (aa, bb,
     ab, ba — matching this session's earlier Γ^(2) trace-integrality
     scope) at 300-bit precision and ran `algdep` on all entries.
     **Diagonal entries are confirmed elements of O_K** — recognizable
     minimal polynomials x²−x+2 (=ω's own polynomial), x²+7 (=√−7's),
     rational integers, and other quadratic patterns matching O_K's
     lattice structure exactly, across all four words and both
     manifolds. **Off-diagonal entries are degree-4**, but structurally
     revealing: e.g. x⁴+5x²+8 factors as a quadratic in x² with roots
     (−5±√−7)/2 ∈ K exactly — i.e. these entries satisfy x²∈K, meaning
     they live in a specific quadratic extension of K, not a
     random degree-4 field. This is consistent with (not yet confirmed
     as) a single global diagonal conjugation/rescaling being able to
     bring the off-diagonal entries into O_K while leaving the
     already-good diagonal entries untouched — the natural next
     computational step for the order-identification route above.
   - **That conjugation attempted directly — strong, convergent partial
     result.** Ran `reproduce/m009_conjugation_test.py` and
     `m010_conjugation_test.py`: conjugated by D=diag(β,1) with
     β=aa[0,1] (the natural first candidate — note this is genuinely
     testable numerically even though "β=√(entry²) in K" as originally
     phrased is not quite well-posed, since β itself has degree 4, not
     2, over Q; the actual conjugation was just run directly and
     checked). Result, at 300-bit precision:
     - **m009 and m010 both**: 6 of 8 off-diagonal entries (across aa,
       bb, ab, ba) become exact elements of O_K after this single
       conjugation. (Correction to an earlier miscount in this report:
       m010 was previously stated as 7/8 — rechecked, it's 6/8, the
       same as m009.) The 2 residual entries in each manifold land in K
       but not O_K.
     - **The two residual obstructions are structurally identical
       between the manifolds, just at swapped word positions**: both
       manifolds have one obstruction from a 2x²−x+8-type entry
       (bb[1,0] in both) and one from a 2x²+x+1-type entry (ab[1,0] in
       m009, ba[1,0] in m010 — same value, transposed position). Not
       noise — tied specifically to a prime dividing 2 (which splits in
       Q(√−7), since −7≡1 mod 8).
     **This is genuine, convergent evidence for an Eichler order of
     some level dividing 2, not O_K itself** — consistent with the
     "nonstandard maximal arithmetic lattice" hypothesis above.
   - **Level pinned down further — exact valuations computed.** Ran
     `reproduce/eichler_level_check.sage` and
     `eichler_level_valuation_check.sage`: confirmed exactly (not
     numerically) that (2)=𝔭·𝔭̄ in O_K, both primes norm 2, via
     𝔭=(ω), 𝔭̄=(1−ω). The 2x²−x+8-type obstruction equals exactly
     (3ω−1)/2, confirmed by direct valuation computation to have
     v_𝔭=−1, v_𝔭̄=+3 — a clean simple pole at 𝔭 only. The 2x²+x+1-type
     obstruction equals exactly −ω/2, with v_𝔭=0, v_𝔭̄=−1 — a clean
     simple pole at 𝔭̄ only. **Since both obstructions appear in both
     manifolds** (just at transposed word positions), **this
     disconfirms the "conjugate parents" sub-hypothesis** (m009↔𝔭,
     m010↔𝔭̄ as distinct single-prime parents) — both manifolds instead
     show the same combined level-(2)=𝔭𝔭̄ pattern, symmetric between
     them, not asymmetric. The broader Eichler-order-of-level-dividing-2
     picture stands; the specific "distinct conjugate parents explaining
     the H₁ difference" idea does not, at least not via this mechanism.
     **The level-(2) Γ₀((2)) numerical coincidence flagged above is
     ruled out on reflection**: covol(Γ₀((2)))=8.000234350347 is
     *larger* than vol(m009)=2.66674478344906, and subgroups always
     have volume ≥ their ambient supergroup's covolume (vol(subgroup) =
     index × covol(supergroup), index≥1) — so Γ₀((2)) cannot be an
     ambient supergroup of Γ_009 at all; the earlier "3×covol
     ≈vol(m009)" proximity was comparing the wrong direction and is a
     coincidence, not a containment.
   - **Attempted the actual reduced-discriminant computation directly —
     real methodological progress, but the specific numbers obtained
     are not yet reliable.** Built `reproduce/order_classify.sage`:
     recovers exact O_K-basis-recognized matrices for all four Γ^(2)
     generators (automating what was done by hand before — cross-
     checked and it reproduces the earlier by-hand findings exactly),
     then computes the reduced discriminant of the O_K-module they span
     via the trace-pairing Gram determinant (Trd(e_i·conj(e_j)),
     conjugation via the standard M₂ adjugate) — a genuine,
     conjugation-invariant order-theoretic quantity, not a numerical
     coincidence check. Result: v_𝔭(disc)=4, v_𝔭̄(disc)=6 for m009;
     v_𝔭(disc)=6, v_𝔭̄(disc)=6 for m010. **These numbers should NOT be
     read as the true Eichler level** — two real gaps remain: (1) only
     4 of the 5 generators (I, aa, bb, ab) were used to build a K-basis,
     dropping `ba`, which may contribute lattice points not already in
     that span; (2) closure under multiplication was never checked —
     products like aa·bb could introduce genuinely new O_K-module
     elements not in the current span, meaning the true order (as an
     O_K-*algebra*, not just the module spanned by these 5 elements)
     could be strictly larger than what was computed here, which would
     make the true discriminant smaller (the true, minimal level) than
     what was found. The large, mutually inconsistent exponents
     obtained here (nothing symmetric or small, unlike the clean
     valuation-1 pattern found for the individual obstructing entries)
     are consistent with this being an inflated, non-minimal
     discriminant from an incomplete spanning set, not a real
     measurement of the level.
     **Closure completed — genuinely converged result.** Ran
     `reproduce/order_closure.sage`: built the full O_K-module spanned
     by I, the 4 Γ^(2) generators, and all 16 pairwise products (exact
     symbolic matrix multiplication over K, no re-recognition needed —
     the exact generator matrices were already in hand), reduced via
     Hermite Normal Form over O_K (valid: O_K is norm-Euclidean for
     d=−7 and has class number 1). **Verified convergence directly**: a
     second closure round (multiplying the round-1 basis by itself and
     by the original generators again) gave the identical discriminant
     both times — not assumed, checked. Also calibrated against the
     reference discriminant of the maximal order M₂(O_K) itself under
     the same trace-pairing normalization (`order_baseline_check.sage`):
     disc(M₂(O_K))=1 exactly (v_𝔭=v_𝔭̄=0), confirming no correction
     factor is needed to read the computed exponents directly as level
     valuations.
     **Converged, calibrated result:** m009: v_𝔭(disc R)=0, v_𝔭̄(disc
     R)=4 → level 𝔫=𝔭̄² (both valuations even, consistent with — though
     not a full proof of — R being genuinely Eichler). m010: v_𝔭(disc
     R)=4, v_𝔭̄(disc R)=4 → level 𝔫=𝔭²𝔭̄²=(4).
   - **m009: a real, precise result.** Using the classical prime-power
     Eichler index formula [PSL₂(O_K):Γ₀(𝔭̄²)]=N(𝔭̄)²+N(𝔭̄)=4+2=6 (not
     independently verified from a Bianchi-specific source — applying
     the classical formula by analogy) and a single Atkin-Lehner
     involution (one prime dividing the level, normalizer index 2):
     covol(N(R))=6×covol(T_7)/2=2.66674478344906. **vol(m009)/covol(N(R))
     = 1.00000000000000 exactly** (15-digit match) — meaning **Γ_009 is
     not merely a subgroup but essentially equal to the full normalizer
     N(R) of this level-𝔭̄² Eichler order**, index 1. This is a genuinely
     precise numerical confirmation, not a loose coincidence.
   - **m010: does not follow the same pattern — reported honestly, not
     forced.** Applying the same style of formula to the level-(4)
     case ([PSL₂(O_K):Γ₀((4))]=6×6=36, normalizer index 4 assuming two
     independent Atkin-Lehner involutions, one per prime) gives
     covol(N(R))=8.00023435034718, and **vol(m010)/covol(N(R)) =
     1/3 exactly — not an integer**, so m010 cannot be an index-k
     subgroup of this specific candidate normalizer for any integer k.
     Either the assumed Atkin-Lehner-index-4 structure is wrong for a
     level with squared exponents at both primes (the classical
     squarefree-level formula may not directly generalize this way),
     or some other aspect of the level-(4) case needs different
     treatment. **Not yet resolved** — this is the concrete remaining
     gap, not a dead end: m009's chain (exact discriminant → exact
     level → exact index-1 match) is fully worked and precise; m010's
     needs the correct prime-power-with-two-primes normalizer theory,
     which hasn't been sourced from a primary reference.
   - **GPT's reduced-discriminant table received and reconciled — no new
     arithmetic required, the already-computed result was reinterpreted
     correctly.** `Status: [Conjecture] pending Cowork computation` →
     resolved. The Gram/trace-pairing quantity computed by
     `order_closure.sage` (disc(R)=det(Trd(e_i·adj(e_j)))) is the
     classical *trace* discriminant, whose valuation is double the
     *reduced* discriminant's for an Eichler order (disc(R)=𝔫² relative
     to the maximal order; reduced discriminant rd(R)=𝔫). This is
     exactly consistent with — not a correction to — the halving already
     applied in `order_index_predictions.sage` before treating the
     exponents as level exponents, confirmed by the existing baseline
     calibration (disc(M₂(O_K))=1, the 𝔫=∅ case). Converting the already-
     converged values:
     - m009: disc(R) valuations (v_𝔭,v_𝔭̄)=(0,4) → reduced discriminant
       exponents **(a,b)=(0,2)**.
     - m010: disc(R) valuations (v_𝔭,v_𝔭̄)=(4,4) → reduced discriminant
       exponents **(a,b)=(2,2)**.
     m009's (0,2) is exactly the table's flagged "case to look for" — and
     independently already produced the exact index-1 volume match above,
     *before* this table arrived. m010's (2,2) is exactly the table's
     "essentially dead" cell — consistent with the already-found
     non-integer 1/3 index. Two independently derived routes (direct
     Sage computation; relayed index-formula table) agree — genuine
     cross-validation, not new information content.
     **Still NOT checked: local Eichler/Bass/Gorenstein type at 𝔭, 𝔭̄.**
     Only the necessary even-valuation condition has been verified for
     either manifold. This matters specifically because 𝔭, 𝔭̄ lie over
     p=2 — the field is dyadic there (2=𝔭𝔭̄ splits) — where Eichler-order
     behavior has known extra subtlety absent at odd primes. Jun & Kim,
     "On the Orders in a Quaternion Algebra over a Dyadic Local Field"
     (Honam Math. J., 2009) — citation verified real via the Korea
     Science index — is the directly relevant reference and has not yet
     been read. Maclachlan–Reid's two cited works (*Orders in Quaternion
     Algebras*; *Commensurable Arithmetic Groups and Volumes*) have not
     yet been verified or read either.
     **Torsion-freeness of N(R) for m009 — the conditional logic is
     sound, but the antecedent is still open.** The index-1 numerical
     match (vol(m009)=covol(N(R)) to 15 digits) is strong evidence for,
     but does not by itself establish, the literal containment
     Γ_009⊆N(R): covol(N(R)) was computed from index-formula arithmetic
     applied to T₇, not from an explicit embedding of Γ_009 inside N(R).
     *If* that containment holds, matching covolume forces index exactly
     1 (Γ_009=N(R) as groups), and since Γ_009 is torsion-free (a
     manifold group), N(R) would be torsion-free too automatically — no
     separate torsion computation needed. That conditional argument is
     correct. What remains open is the antecedent itself — an actual
     containment/embedding proof, not a covolume coincidence — the same
     gap this item has carried since the T₇-non-containment result first
     forced the "which maximal lattice" question.
     **m010's (2,2) asymmetry — one hypothesis ruled out, one has partial
     evidence, one remains live.** (c) A different conjugating matrix
     giving a lower level is not viable in general: the reduced
     discriminant is invariant under GL₂(K)-conjugation (an inner
     automorphism of the ambient algebra) whenever the conjugating
     matrix itself yields a K-rational embedding, so no further
     conjugation search is warranted. (a) Non-minimal/non-closed basis
     already has partial evidence against it: the two-round closure
     check in `order_closure.sage` gave identical discriminants both
     times for m010 specifically, not just m009 — evidence of
     convergence, not an exhaustive proof. (b) m010's holonomy order
     genuinely not Eichler is the live open question, and converges with
     the not-yet-done local-type classification above. Also: two
     manifolds sharing a commensurability class, trace field, and even
     volume are not required to share a local type relative to a fixed
     maximal order — different subgroups of one commensurability class
     routinely sit at different local positions. The (0,2) vs (2,2)
     split is not inherently in tension with m009/m010 sharing a
     commensurability class.
   - **Jun–Kim citation confirmed and full local-order question set
     precisely stated — status: next arithmetic calculation, not yet
     attempted.** Full citation: Sungtae Jun and Insuk Kim, "On the
     orders in a quaternion algebra over a dyadic local field," *Honam
     Mathematical Journal* 31 (2009), no. 4, pp. 611– (closing page not
     given in the relayed citation, recorded as received rather than
     guessed), DOI: 10.5831/HMJ.2009.31.4.611. This is the reference for
     the still-open local classification flagged above.
     **m009 — two precise local questions:**
     Q1: is R_𝔭̄ ≅ an Eichler order of level 𝔭̄² locally?
     Q2: is R_𝔭 ≅ M₂(O_{K,𝔭}) (maximal) locally?
     If both hold, containment Γ_009⊆N(R) would then force Γ_009=N(R)
     (covolume equality already established + torsion-free, per the
     conditional argument above).
     **m010 — one precise local question:**
     are R_𝔭, R_𝔭̄ both Eichler of level 𝔭², 𝔭̄² respectively? If not,
     classify as Bass / Gorenstein / non-Eichler. The level-(2,2)
     non-integer volume ratio found above means either the order is
     non-Eichler at one or both primes, or the correct arithmetic parent
     is not the standard Eichler normalizer construction used for m009.
     **Method for both:** apply Jun–Kim's dyadic local classification
     directly to R_𝔭, R_𝔭̄ (not yet attempted — this is genuinely new
     computation, distinct from the discriminant/index arithmetic
     already converged above, which should not be repeated further; the
     missing information is local isomorphism type, not more volume
     numerology).
   - **First attempt at Q1/Q2 for m009, via `reproduce/dyadic_local_order_test.sage`
     — one part inconclusive, one part genuinely upgraded.** Reused the
     converged `basis_R` from `order_closure.sage` (not the raw
     generators, which are merely elements of R in an arbitrary spanning
     set) and computed entry-level 𝔭/𝔭̄-adic valuations directly.
     **Q2 (maximality at 𝔭): no stronger than already known.** No basis
     entry has negative 𝔭-valuation anywhere — consistent with, but not
     independent confirmation beyond, the standard fact that unit local
     discriminant (v_𝔭(disc R)=0, already established) forces R to be
     maximal at 𝔭.
     **Q1 (Eichler-ness at 𝔭̄): test as run is inconclusive, not
     confirming.** The basis entries show a mixed pattern, not the clean
     upper-triangular-mod-𝔭̄² shape an Eichler order presents in a good
     basis — notably `basis_R[2][1,0]` has v_𝔭̄=**−1** (a literal pole,
     not merely a non-negative valuation). This means the specific
     O_K-basis found by HNF is not in local normal form at 𝔭̄, so this
     entry-level test cannot distinguish Eichler from a non-Eichler order
     of the same discriminant — exactly the dyadic subtlety Jun–Kim's
     paper is needed to resolve. Q1 remains open.
     **Containment (Step 2): genuinely proved for a subgroup, not
     numerical.** For every γ∈{a²,b²,ab,ba} and every basis element b of
     R, γ·b·γ⁻¹ was verified via exact O_K-arithmetic (solve over K,
     check coefficients lie in O_K — no floating point) to lie in the
     O_K-span of `basis_R`. All 16 checks passed. This proves
     Γ′=⟨a²,b²,ab,ba⟩ ⊆ N(R) — an actual containment, not a covolume
     coincidence.
     **Important scope limit — do not overclaim.** Γ′ is the same
     restricted generating set used throughout this investigation
     precisely because the *raw* generators a,b were never brought to
     O_K-integral (or confirmed even K-rational) form under this
     conjugation (found earlier this session to carry literal ±i
     entries). So this proves Γ′⊆N(R), a finite-index subgroup
     containment, **not** the full Γ_009=⟨a,b⟩⊆N(R). Promoting the m009
     result to `[Proved] Γ_009=N(R_𝔭̄²)` still requires resolving a,b's
     own matrix realization and testing those directly — a distinct,
     still-open obstacle. Status stays `[Computed]` (index-1 covolume
     match) + `[Proved, restricted]` (Γ′⊆N(R)), not yet `[Proved]` for
     the full group.
   - **K-rationalization of raw generators a,b — proved IMPOSSIBLE, not
     merely unattempted.** Ran `reproduce/tr_a_field_test.sage`: computed
     tr(a), tr(b) at 300-bit precision for both manifolds and ran algdep
     (degree bound 8, 200 known bits). Both traces satisfy genuine
     degree-4 minimal polynomials over Q — m009: a: `x⁴−5x²+8`, b:
     `x⁴−10x²+32`; m010: a: `x⁴−5x²+8` (same as m009's a), b:
     `x⁴+2x²+8` — not degree ≤2. **Since trace is a conjugation
     invariant, this rigorously rules out any g∈GL₂(C) with
     g·a·g⁻¹∈M₂(K)**: no search over conjugations can ever fix this, the
     obstruction is intrinsic to a itself, not to the choice of basis.
     The earlier plan to test the *full* Γ_009=⟨a,b⟩ against N(R) inside
     M₂(K) is closed off as stated.
     **Positive structure found: a,b live in a genuine degree-2
     extension of K, not an unrelated field.** Both quartics are
     biquadratic in x², and tr(a)², tr(b)² land exactly in K: for m009,
     tr(a)²=(5±√−7)/2, tr(b)²=5±√−7 (both roots of quadratics with
     discriminant −7, i.e. elements of K=Q(√−7) itself). So a,b are
     defined over L=K(tr(a)), a degree-4-over-Q, degree-2-over-K field —
     exactly the classical trace-field-vs-invariant-trace-field relation
     [kΓ:kΓ^(2)]≤2 (Maclachlan–Reid), concretely pinned down here rather
     than merely cited.
     **Consequence for the open containment question.** Testing whether
     the full Γ_009 normalizes R now requires base-changing R to an
     O_L-order (R⊗_{O_K}O_L) and testing a,b against that — a materially
     larger computation than the O_K-arithmetic used for Γ′ so far, not
     yet attempted. Recorded as the concrete next step, not launched
     without being asked given its scope.

4. **576-element paper — finish as pure mathematics, keep the physical
   reading permanently separated.** The arithmetic chain (discriminants,
   ramification, Artin conductors, Chebotarev, maximal abelian
   subextension) is already registered as [Proved]; the Weyl-group
   identity (C₂×S₄×C₂×S₃ ≅ W(SU(2))×W(SU(4))×W(SU(2))×W(SU(3))) can
   appear as a closing observation, but the manuscript should terminate
   the theorem before any physical interpretation, not lean on HFG
   motivation for its correctness.

5. **Census-wide rarity of the C₂×S₄×C₂×S₃ configuration — needs a
   methodological redesign, not just more CPU time.** Running
   (`census_disjoint_ramification_scan.sage.py`), currently deep in the
   census's `s`-family where most manifolds fail to resolve under the
   current bounds — this is a **non-random missingness problem**: any
   "`x`% of the census has property P" claim from this scan alone would
   be biased toward low-complexity trace fields. The scan currently only
   estimates `P(disjoint support | field successfully resolved)`; a
   defensible rarity claim also needs `P(field resolved | tetrahedron
   count, degree, volume, census family)` — the selection function of
   the computation itself. A companion scan (`census_uniqueness_scan.py`,
   testing whether m010 is uniquely the minimal-volume manifold with
   maximal cusp order) did not have this bias and has **completed — see
   COMPLETED item 32**.

6. **Dual surgery paper (SSRN 7277458) — revision + venue.** AGT
   rejected (scope, not a math error). Needs explicit prior-unknown
   statement, Neumann-Reid framing, forward-looking questions. Candidate
   venues: Geometriae Dedicata, JLMS, Michigan Math. J., Experimental
   Mathematics. Do not resubmit to AGT.

7. **Physical/Pati-Salam interpretation of every arithmetic result above**
   [Conjecture], uniformly. No field-theoretic mechanism (Class S /
   3D-3D bridge) connects any proved arithmetic structure to physical
   gauge groups — this is the umbrella status for every "physical
   reading" claim in the program, not a per-result gap.

8. **Volume quantum mechanism**: vol(m019)=3v₀, vol(m178)=4v₀ verified
   numerically to 4.44e-16; why D(z₀)=v₀ specifically (the algebraic
   proof) is still open.

9. **m003 Langlands bridge** — "structurally established," not proved
   to the m006 standard; Hecke eigenvalue verification pending
   (blocked on a CAPTCHA-gated lookup at the time).

10. **F_τ ↔ covering-tower biconditional — the converse is false as
    originally claimed.** Only the one-directional statement holds; the
    Lucas mass-ratio chain from the tower is listed as still open.

11. **Whether p₂=31=conductor(χ₅) is forced or coincidental** remains
    an open question even after the Frobenius-discriminant mechanism
    (item 19) was worked out. Related: the same Q(√5) dimension-split
    pattern does **not** hold at p₃=61 or p₅=151 (checked and falsified
    as a general pattern), leaving why it holds specifically at p₂=31
    unexplained.

12. **Whether Hecke eigenvalue values a_p(X₀(11)) encode fermion mass
    values** (not just lattice structure) — unresolved.

13. **Degree-8 subfield identity** containing tr(AAAAB), tr(aaaba) —
    whether it's a subfield of the Galois closure of K₁₀ — unresolved.

14. **F_τ/golden-ratio bridge**: F_τ (in Q(τ_m006), disc −59) and the
    Q(√5) component at level 8773 have no direct containment bridge
    (compositum degree 6); needs twisted Bianchi eigenvalue computation.
    A related result suggests the Lucas-number connection specifically
    will NOT hold.

15. **CKM fitness canonical value** — conflicting figures (0.016482,
    0.003618, 0.003989) still circulate for the claimed canonical
    F=0.002728; M_CKM ranks 82nd/134 in the census, not best-in-class.

16. **Geometry-only lepton mass selector** {Q_e=0, Q_μ=44, Q_τ=68}
    [Conjecture]. The source script's own note admits the rule is "NOT
    yet canonically derived"; real look-elsewhere risk since the
    targets were already known. Contrast: the analogous quark selector
    search found no uniform rule at all (explicit negative result).

17. **h(P₁)=0.020644 vs. sin²θ₁₃=0.02220±0.00068** — 2.3σ discrepancy,
    "no mechanism established... do not claim until mechanism found."

18. **SSRN 6631218** neutrino mass prediction (m_ν=71.4±2.9 meV) —
    falsifiable by future CMB-S4 data; untested.

19. **Full census extension for the disjoint-ramification/rarity check**
    (item 5) — earlier checks only covered the first 80–200 of ~10,000+
    manifolds. The uniqueness half of this pair is now done (COMPLETED
    item 32); this item now refers only to the still-running
    `census_disjoint_ramification_scan.sage.py`.

### Paper-portfolio / editorial gaps (from the Aug 6–20 2026 audit entries)

20. **Twist Angle Spectrum paper** — HOLD, not ready: no null-hypothesis
    test anywhere in the paper (every sibling paper has one), no Data
    Availability section, and a real ambiguity between its δ_CKM=68.0°
    (single-word) and the CKM paper's J=0 (three-word triple) that the
    paper's own framing blurs without contradicting.
21. **CKM v3 paper — fixed, verified this session** (commit `63dbc34`,
    "CKM v3: fix citation year, add MSC2020 codes"). Confirmed directly
    in `papers/04_new_needs_journal/gentry-ckm-v3.tex`: MSC codes present
    (`Primary 57K32; Secondary 11R32`), SSRN citations correctly dated
    2026. Ready to resubmit. **Duplicate-copy risk resolved 2026-08-25:**
    `papers/ckm-rebuild/gentry-ckm-v3.tex` was confirmed genuinely
    different from the fixed version (missing MSC codes/keywords,
    different AI-acknowledgment wording) — not deleted (it has an
    associated compiled .pdf/.aux/.log that might still be wanted for
    reference), instead renamed to `gentry-ckm-v3.tex.STALE` with a
    header comment pointing to the live file, so it can no longer be
    mistaken for an editable/submittable .tex.
22. **Qubit gates paper** — the CS level k=2 physical-interpretation
    claim needs to be split from the proven algebraic identity (already
    flagged honestly in the paper's own §6.3, just needs moving
    earlier); a citation to a now-confirmed-rejected manuscript needs
    updating. Not independently re-verified this session.
23. **Holonomy-CP paper — fixed, verified this session** (commit
    `7f4ac46`, "Holonomy-CP: fix citations, add amsthm/theorems, add MSC
    codes" — note: an externally-relayed claim cited commit `e0bfd33`
    for this fix, which is real but is a *different, unrelated* commit;
    `7f4ac46` is the correct one). Confirmed directly in
    `papers/01_active_plb/gentry-holonomy-cp-ahp.tex`: MSC codes present
    (`Primary 57K32; Secondary 20H10`), both self-citations now clean
    (plain SSRN references, no garbled double-journal listing, no stale
    "submitted March 2026" text). **Duplicate-copy risk resolved
    2026-08-25:** `papers/holonomy-cp/gentry-holonomy-cp-ahp.tex` was
    confirmed genuinely different from the fixed version — renamed to
    `gentry-holonomy-cp-ahp.tex.STALE` with a header comment pointing to
    the live file. Note: `papers/holonomy-cp/` also contains
    `gentry-holonomy-cp-epjc.tex` (a *genuinely different* paper —
    different `\journalname`, Eur. Phys. J. C, different
    `\documentclass` options) and a bare `gentry-holonomy-cp.tex` —
    neither was touched, since neither was the flagged duplicate and
    the epjc variant is a legitimate separate submission target, not a
    stale copy.
24. **CORE_MASTER_v12 gap table** (July 29 audit, ~20 findings): several
    major results are proved elsewhere in the corpus but never made it
    into the "master" paper — most notably, **no Galois-Weyl
    correspondence section exists in CORE_MASTER_v12 at all**, despite
    being one of the most-cited results in the video presentation
    script; also no WRT-invariant section, no Frobenius-discriminant/
    Bianchi-descent section, and several results (Borel/KAN PMNS
    theorem, the 0.300 floor, the Z/5 modular bridge) present only in
    adjacent, less specific sections. This is a "lost findings" pattern,
    not new mathematics — worth a reconciliation pass before treating
    CORE_MASTER_v12 as the authoritative summary of the program.
25. **PLB-D-26-01006** (Charge Conjugation as Orientation Reversal) —
    confirmed still an **active, live submission under review** as of
    the Aug 20 audit. Do not touch, resubmit, or treat as available.

### Infrastructure / non-mathematical

26. **2TB backup drive (WD Elements, disk 5)** showing pre-failure SMART
    status — needs a ddrescue clone before any recovery attempt. The
    candidate destination drive was ruled out (repeated disk I/O errors,
    worsened after a physical reseat — points to drive/enclosure
    failure, not a connection issue). A different destination drive was
    still being sourced as of the last entry.
27. **SSRN 6775158** correction note — SSRN form was failing with a save
    error; corrected text drafted but submission not confirmed done.
28. **SSRN 6876278** (Sextic-Octic decomposition) — still listed
    PRELIMINARY_UPLOAD, needs formal submission.

---

## Retracted / superseded (kept for record, not open or completed)

- **CKM ITF = Q(√17)** — wrong; real quadratic fields cannot be
  invariant trace fields of arithmetic Kleinian groups. Correct ITF:
  degree-10 field, disc −271488204251, signature (8,1).
- **Eisenstein-norm BPS mass ratios** (208, 3477 for muon/tau) — Monte
  Carlo p=0.106/0.862; "do not cite as evidence."
- **m206(1,2) "order-6 torsion"** — actual H₁=ℤ/5, not order 6.
- **Universal spectral gap conjecture** — falsified by a ℤ/47
  counterexample.
- **Lucas-geodesic bridge, "all k" form** — corrected to even-k-only
  (odd k gives √5·F_k); the "proved exactly" all-k version in the SSRN
  6754501 abstract is superseded.
- **F_τ ↔ covering-tower biconditional** — the converse direction is
  false as originally claimed.
- **CORE_MASTER_v12's blanket Lucas formula** |tr(γ)|=L_k for all k —
  mathematically wrong for odd k (verified numerically, not a rounding
  artifact); does not appear to have propagated into any active paper
  submission, confined to this one internal document.
- **A separately-relayed CMP→Geometriae Dedicata→Topology and its
  Applications rejection chain** for the torsion paper (specific
  manuscript ID, named editor) — could not be verified anywhere in the
  corpus or the actual submission portal; treat as unconfirmed, not fact.
- **A claimed "Aug 3 2026 American-spelling decision"** (program vs.
  programme) — does not exist in any primary source and directly
  contradicts an already-published URL slug using "programme."
  "Programme" spelling stands.
