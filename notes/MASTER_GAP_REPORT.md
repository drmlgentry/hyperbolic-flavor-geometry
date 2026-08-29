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
   - **Checkpoint before committing to the O_L rewrite: [Γ_009:Γ′]
     computed exactly — 2, the consistent branch, not a contradiction.**
     Ran `reproduce/gamma_prime_index_check.g`: took the actual SnapPy
     presentation (`generators: ['a','b']`, `relators:
     ['aabABaaBAb']`), built it as an FpGroup in GAP, and computed
     `Index(G, Subgroup(G,[a^2,b^2,a*b,b*a]))` via genuine Todd-Coxeter
     coset enumeration — not inferred from covers or H₁. Result:
     **[Γ_009:Γ′]=2 exactly.** Consequently covol(Γ′)=2·vol(m009)=
     5.33348956..., while covol(N(R_𝔭̄²))=vol(m009)=2.66674478... — and
     since Γ′⊆N(R) was already proved, this forces **[N(R):Γ′]=2 as
     well**, the same index on both sides. Γ′ is therefore a common
     index-2 subgroup of both Γ_009 and N(R) with matching covolumes on
     each side — consistent with, but not a proof of, Γ_009=N(R): they
     could in principle be two *different* index-2 overgroups of Γ′ that
     merely share a covolume. No inconsistency was found anywhere in the
     setup. **Conclusion: the O_L base-change is confirmed necessary,
     not avoidable** — this checkpoint does not shortcut it, but does
     rule out the scenario where it would have been unnecessary.
   - **Superseded: the O_L base-change turned out to be unnecessary — the
     RAW generators a,b were tested directly and PASS.** A cleaner route
     was found: conjugation is well-defined for any matrix regardless of
     whether it's K-rational (scalar ambiguity cancels: (λg)h(λg)⁻¹=ghg⁻¹
     for any λ), so a,b's own SnapPy matrices (with tr(a),tr(b)∉K, never
     forced into any field) can be tested directly against R without
     constructing L at all. Ran
     `reproduce/raw_generator_normalizes_R_test.sage`: for γ∈{a,b} (raw,
     un-rationalized 300-bit-precision matrices) and every basis element
     of R, solved for the O_K-coefficients of γ·b·γ⁻¹ numerically, then
     recognized each coefficient exactly in O_K. **All 8 checks (2
     generators × 4 basis elements) passed**, with recognition errors
     ~1e-90 at 300-bit precision — well beyond coincidence, consistent
     with exact O_K-membership. **Γ_009=⟨a,b⟩ genuinely normalizes R —
     proved computationally, not just via the abstract normal-Γ′
     argument (which is also correct: Γ′◁Γ_009 plus R being a ring
     generated by, and containing all matrix-lifts of, Γ′-elements gives
     γRγ⁻¹⊆R for any γ preserving Γ′ setwise by conjugation, by
     C-linearity of matrix conjugation — the direct numerical test here
     confirms this abstract argument rather than replacing it).**
     **Status upgrade: Γ_009⊆N(R) is now `[Proved]` for the FULL group**,
     not merely the restricted Γ′. Combined with the already-established
     covolume match (covol(N(R))=vol(m009) to 15 digits), containment
     plus equal covolume would force Γ_009=N(R) exactly — **but this
     final step still depends on trusting the covol(N(R)) figure
     itself**, which was computed by applying the classical
     Eichler-order index/Atkin-Lehner formulas to level 𝔭̄². Those
     formulas presume R behaves as a standard Eichler order; if R is
     instead some other, non-Eichler order sharing the same
     discriminant (the live dyadic possibility this whole item has
     circled), the formulas — and hence the covolume figure — need not
     apply to the *actual* N(R). **The bottleneck is therefore unchanged
     in substance but sharper in reason: the local Eichler classification
     of R at 𝔭̄ (Jun–Kim) is needed not merely to name R, but to validate
     that the already-computed covol(N(R)) is correct at all.** Status:
     `[Proved] Γ_009⊆N(R)`; `[Conditional] Γ_009=N(R)`, pending the local
     classification.
     **Consolidated status (for quick reference):** `[Proved]`
     Γ_009⊆N(R) — via direct computation (raw a,b normalize R,
     residuals ~1e-90) and independently via the Skolem–Noether-style
     argument (Γ′◁Γ_009, [Γ_009:Γ′]=2 ⟹ conjugation by any γ∈Γ_009
     preserves the O_K-algebra generated by Γ′, which is R).
     `[Conditional]` Γ_009=N(R) — genuinely two separate open
     sub-questions, not one: (a) whether R_𝔭̄ is locally Eichler of
     level 𝔭̄² (Bruhat-Tits branch computation, Jun–Kim), and (b)
     whether the full normalizer index over Γ′ is really 4 (giving
     [N(R):Γ_009]=2) rather than the originally-assumed 2 (giving
     index 1) — **(b) is a credible, partially-corroborated concern,
     not a confirmed correction** (see the covolume audit below); do
     not treat index-2 as settled. The correct structural picture,
     regardless of how (b) resolves, is the tower
     Γ′ ⊂[2] Γ_009 ⊆ N(R), **not** a direct Γ_009=N(R) inferred from
     [Γ_009:Γ′]=[N(R):Γ′]=2 alone (two groups can share a common
     index-2 subgroup without being equal to each other).
     **O_L base-change: removed from the active roadmap**, superseded
     by the Skolem–Noether/direct-computation route above (see also
     the "Superseded" entry earlier in this item).
   - **Audit of the covolume figure — credible, partially independently
     corroborated concern about a missing factor of 2; NOT accepted as a
     confirmed correction, and NOT dismissed either.** A relayed audit
     argued that the original index-1 computation
     (covol(N(E))=vol(m009), 15-digit match) omits an independent
     [PGL₂(O_K):PSL₂(O_K)]=2 factor beyond the Atkin-Lehner involution,
     which would instead give covol(N(E))=vol(m009)/2 and
     [N(E):Γ_009]=2, not 1. Rather than accept or dismiss this on the
     audit's say-so, ran two independent checks:
     (1) **`covol_T7=0.888914927816353` verified via Humbert's volume
     formula** (|d_K|^{3/2}·ζ_K(2)/4π², computed from Sage's own zeta
     function, matching to 20+ digits) — confirms this constant
     genuinely is covol(PSL₂(O_K)) specifically, not already
     covol(PGL₂(O_K)) under a different name. So the audit's proposed
     factor is not already secretly baked in — if it applies, it is a
     real additional correction, not double-counting.
     (2) **J=diag(−1,1) directly verified (by hand, on the standard
     Eichler-order model) to normalize it**: conjugation sends the
     lower-left entry c↦−c, trivially preserving "c≡0 mod 𝔫." J has
     det=−1 (a unit; cannot be rescaled into SL₂ since √−1∉K, so J∉T7),
     and its determinant class is generically independent of the
     Atkin-Lehner involution's (a generator of 𝔫, norm 4) — consistent
     with J being a genuinely separate normalizing symmetry not already
     captured by [T7:Γ0(𝔫)]×[AL index].
     **Both checks support the audit's concern being real, not
     hand-waving — but neither constitutes a primary-source proof that
     ⟨Γ0(𝔫),W_AL,J⟩ is the *complete* normalizer with no further
     extensions.** Both the original index-1 and the audited index-2
     rest on the same underlying by-analogy classical-index-formula
     assumption (flagged as unverified from the start); the audit
     refines that analogy rather than replacing it with a citation.
     **Not rewriting the record to assert index 2 as established.**
     Recording instead: confidence has shifted toward index 2 being more
     likely correct than index 1, pending either a primary source for
     the exact normalizer structure or a from-scratch derivation of the
     complete generator set of N(R). Either way, this entire question is
     orthogonal to and does not affect the now-solid, directly-computed
     `[Proved] Γ_009⊆N(R)` containment result above — and either way, the
     local Eichler classification at 𝔭̄ remains the actual bottleneck for
     turning containment into equality.
   - **Declined to draft a "completed m009 theorem"** as separately
     requested — it would be premature given the open items above (the
     covolume-index question, and the local Eichler classification at
     𝔭̄), and this report's standing practice is not to write results as
     closed until they are.
   - **Local Eichler classification at 𝔭̄ — RESOLVED, in the negative:
     R_𝔭̄ is proved NOT Eichler at any level.** Ran the Bruhat-Tits
     branch enumeration (`reproduce/m009_bruhat_tits_eichler_check.sage`):
     vertices of the tree ↔ maximal orders in M₂(K_𝔮); the branch of a
     local order is the (connected) subtree of maximal orders
     containing it; for a genuine Eichler order of level 𝔮^n the branch
     is a path of exactly n+1 vertices. A real bug was caught and fixed
     before trusting any output: the relayed template's third
     "neighbor-direction" matrix `[[1,1],[0,2]]` generates the *same*
     sublattice of Z₂² as the second direction `[[1,0],[0,2]]` (one
     elementary column operation apart), so two of the three supposed
     tree-directions collapsed onto each other — the code could never
     find a genuine third vertex from any interior point. Corrected to
     `[[1,0],[1,2]]` (the line spanned by (1,1) mod 2, the actually-missing
     direction). **Calibration check** (`reproduce/bt_calibration_check.sage`):
     re-ran the identical pipeline on the known maximal order M₂(O_K)
     itself — correctly gives branch size exactly 1 at *both* primes,
     confirming the corrected methodology is sound before trusting it
     on R.
     **Result on the actual R (m009):** at 𝔭, branch size = 1 (seed at
     distance 0) — consistent with, and no stronger than, the
     already-known fact that unit local discriminant forces maximality.
     At 𝔭̄, branch size = **2** (not 3): both vertices in the branch have
     exactly one neighbor containing R (each other) — verified directly,
     printing the actual failing entries for the non-members (clean,
     non-marginal valuations like −1, not precision noise; PREC=300 was
     far more than enough to rule out marginal-precision artifacts).
     **This is a direct contradiction with Eichler-of-level-𝔭̄²**: a
     length-2 Eichler branch requires 3 vertices (distance 2), but R_𝔭̄'s
     branch has only 2 vertices (distance 1) — while its independently
     and repeatedly confirmed reduced discriminant valuation at 𝔭̄ is 2,
     which for a genuine Eichler order would require the branch to have
     3 vertices, not 2. Branch length and discriminant valuation are
     mismatched, which cannot happen for a standard Eichler order.
     **Conclusion: R_𝔭̄ is definitively not Eichler of level 𝔭̄², nor of
     any other level — the order is some other (Bass/Gorenstein/other)
     dyadic type**, exactly the possibility this whole item has been
     flagging as live since the dyadic subtlety was first identified.
     **Consequence for the earlier index-1 covolume match:** the
     original "vol(m009)=covol(N(R)) to 15 digits" computation applied
     the classical Eichler-order index/Atkin-Lehner formulas to level
     𝔭̄² — formulas that presume R is Eichler. Since R_𝔭̄ is now proved
     *not* Eichler, that computation rested on a false premise; the
     15-digit numerical match, while real and still unexplained, can no
     longer be read as evidence for Γ_009=N(R) via that route. This does
     **not** affect the separately and directly proved `[Proved]`
     Γ_009⊆N(R) containment result, which never depended on R being
     Eichler. Status update: Γ_009=N(R) moves from `[Conditional]
     pending classification` to `[Open]` — the classification is no
     longer pending, it has returned negative, and a different argument
     (or a genuine non-Eichler normalizer computation, e.g. via Jun–Kim's
     actual dyadic order classification, not merely testing the Eichler
     hypothesis) is needed to settle equality.
   - **First concrete step of the actual dyadic classification: [E_𝔭̄:R_𝔭̄]=2,
     exact** [Computed — exact, two independent derivations]
     (`reproduce/m009_dyadic_index_check.sage`). The branch at 𝔭̄ has
     exactly two vertices (already established above); let $M_0,M_1$ be
     their associated maximal orders and $E=M_0\cap M_1$ — the standard
     level-1 edge/Iwahori order for two Bruhat-Tits-adjacent vertices.
     Derived $E$'s explicit basis two ways: (a) analytically, from the
     exact `NEIGHBOR_STEPS` matrix $h=\mathrm{diag}(2,1)$ connecting the
     two branch vertices, giving $E=\{a,d\in\Z_2,\ b\in2\Z_2,\
     c\in\Z_2\}$ in the standard matrix-unit basis; (b) verified
     independently by direct containment checks of each basis element
     against both $M_0$ and $M_1$ (not merely trusting the derivation).
     $R_𝔭̄\subset E$ confirmed directly (all four pulled-back basis
     vectors of $R$ have integral $E$-coordinates). The change-of-basis
     matrix $X$ (R's basis in $E$'s coordinates) has three diagonal-type
     entries of valuation 0 and exactly one of valuation 1, giving
     $v_2(\det X)=1$ exactly, hence **$[E:R]=2$** — independently
     confirmed by the discriminant-valuation shortcut
     ($v_{\bar{\mathfrak p}}(\mathrm{disc}_{\mathrm{tr}}R)=4$,
     $v_{\bar{\mathfrak p}}(\mathrm{disc}_{\mathrm{tr}}E)=2$ for a
     level-1 Eichler order, so $4=2k+2\Rightarrow k=1\Rightarrow[E:R]=2$),
     computed by hand *before* running the script, then matched exactly.
     This confirms GPT's "working prediction is 2" from the relayed
     discussion — but as an independently *derived and computed* result,
     not adopted on the collaborator's say-so.
   - **$E/R\cong\mathbb F_2$ exact certificate, with an explicit generator**
     [Computed — exact] (extension of the same script). Worked mod
     $\bar{\mathfrak p}$ directly (via $k=\mathcal O_K/\bar{\mathfrak p}
     \cong\mathbf F_2$, using Sage's `GF(2)` on the exact integral
     $E$-basis) rather than the Q₂-field Smith form, which trivializes
     since $\mathbb Q_2$ is a field. $\dim_k(E/\bar{\mathfrak p}E)=4$
     (trivial, exact integral basis); $\dim_k((R+\bar{\mathfrak
     p}E)/\bar{\mathfrak p}E)=3$ (computed as the rank over $\mathbf F_2$
     of $R$'s basis coordinates in $E$'s basis, reduced mod 2 — matches
     the prediction exactly, not assumed). Short exact sequence gives
     $E/R\cong\mathbf F_2$. **Explicit generator found and verified**:
     $e=E_{11}$ (in the branch-vertex-pulled-back frame) satisfies
     $e\notin R$ (its $R$-basis coordinates have a valuation$-1$ entry —
     directly checked, not inferred) and $\bar{\mathfrak p}e=2e\in R$
     (its $R$-basis coordinates are all integral — directly checked).
     Since $E/R$ has order 2 and $e$'s class is nonzero, $E=R+\mathcal
     O_K\cdot e$ follows immediately (the two cosets $R,R+e$ exhaust
     $E$) — no further computation needed for that last part.
   - **Gorenstein/Bass classification, Steps 1–2: $R^\#$ computed
     explicitly, $R^\#/R\cong\mathbf F_2^4$ exactly (a strong indicator
     against Gorenstein, not yet the formal proof)** [Computed — exact]
     (same script, extended). **Trace-pairing convention corrected
     before use**: the relayed task spec said "reduced trace = matrix
     trace," i.e. $T(x,y)=\mathrm{trace}(xy)$ with no conjugation — but
     the standard pairing for quaternion-order discriminant/Gorenstein
     theory (Voight, *Quaternion Algebras*; the framework Jun–Kim's
     paper builds on) is $T(x,y)=\mathrm{Trd}(x\bar y)=\mathrm{trace}
     (x\cdot\mathrm{adj}(y))$ — the same convention `order_closure.sage`
     already used throughout this investigation. Computed both; both
     happened to give the same discriminant valuation (4), so that
     check alone couldn't discriminate — used the adjugate convention
     as the mathematically correct one, not the literal relayed
     instruction, and said so explicitly rather than silently
     switching. $R^\#$'s explicit dual basis computed via
     $r^\#_i=\sum_j(T^{-1})_{ij}r_j$, sanity-checked directly against
     $T(r^\#_i,r_j)=\delta_{ij}$.
     **A self-caught bug before reporting anything**: the first attempt
     printed "$R\not\subseteq R^\#$," which is impossible for a genuine
     order ($\mathrm{Trd}(r\bar{r'})\in\mathcal O_K$ automatically for
     $r,r'\in R$) — traced to having the change-of-basis direction
     backwards, fixed, rerun. Corrected result: $R\subset R^\#$
     confirmed directly (all entries of the change-of-basis matrix $P$
     integral), $[R^\#:R]=2^4=16$ — consistent with, and numerically
     matching, $v_{\bar{\mathfrak p}}(\mathrm{disc}_{\mathrm{tr}}R)=4$
     computed independently via $T_{\mathrm{adj}}$'s determinant.
     **Sharper structural fact, independently verified**: every nonzero
     entry of $P$ has valuation exactly 1 (not just $\det P$ having
     valuation 4) — confirmed rigorously by checking $P/2$ is invertible
     over $\Z_2$ (determinant valuation 0), giving Smith normal form
     $\mathrm{diag}(2,2,2,2)$ exactly, so $R^\#/R\cong\mathbf F_2^4$ as
     an abelian group. **Correction to a wrong claim made at this
     point in an earlier pass**: it was stated here that
     "cyclic-as-$R$-module implies cyclic-as-$\Z_2$-module, a fortiori,"
     used as evidence against Gorenstein. **That implication is false**
     — $R/2R$ itself is cyclic as an $R$-module (generated by $1$) but
     is $(\Z/2)^4$, not cyclic, as an abelian group. The claim was
     retracted before Steps 3–4 were run, not after, once the error was
     noticed.
   - **Gorenstein/Bass, Steps 3–4: $R_{\bar{\mathfrak p}}$ IS Gorenstein
     — proved directly, two independent ways** [Computed — exact] (same
     script, extended). **Step 3**: built $R/\bar{\mathfrak p}R=R/2R$ as
     an explicit $4$-dimensional $\mathbf F_2$-algebra from structure
     constants $e_i e_j$ (verified integral before reducing — i.e.
     confirmed $R$ is actually closed under multiplication in this
     basis, not assumed). Sage's `FiniteDimensionalAlgebra.radical()`
     doesn't exist in this Sage version (`AttributeError`, worth noting
     for future reproductions) — fell back to a direct nilpotency proof:
     the complement-of-identity span $\mathfrak m=\{e_2,e_3,e_4\}$
     satisfies $\mathfrak m^2=\langle e_4\rangle$ (rank 1, computed),
     $\mathfrak m^3=0$ (rank 0, computed) — genuinely nilpotent, not
     assumed. Since $R/2R/\mathfrak m\cong\mathbf F_2$ is already a
     field, $J(R/2R)=\mathfrak m$, $\dim_{\mathbf F_2}J(R)/\bar{\mathfrak
     p}R=3$; $R/2R$ is a **local ring** with residue field $\mathbf
     F_2$.
     **Step 4**: rather than trust GPT's proposed length-comparison
     shortcut "$R$ Gorenstein iff
     $\mathrm{length}(R^\#/R)=\mathrm{length}(R/J(R))$" at face value
     (which gives $4\ne1$, i.e. would say NOT Gorenstein), ran the
     *definitional* test directly: first confirmed $R^\#$ is genuinely a
     left $R$-module (checked $r_i\cdot r^\#_j\in R^\#$ for all $16$
     pairs, not assumed), then confirmed the clean structural fact
     $R=2R^\#$ exactly as lattices (not just matching elementary
     divisors — verified directly), so $R^\#/R=R^\#/2R^\#$ canonically.
     Built the actual $R/2R$-action on this $4$-dim space and
     **exhaustively tested cyclic-generation over all $15$ nonzero
     candidate generators** (not just one guess): $8$ of the $15$ give
     rank $<4$, but $7$ — including $\xi=r^\#_4$ — give rank exactly
     $4$, i.e. $R\cdot\xi=R^\#/R$. **Conclusion: $R^\#$ is a cyclic
     $R$-module, $R^\# = R+R\cdot\xi$ for explicit $\xi=r^\#_4$ — hence
     $R_{\bar{\mathfrak p}}$ IS GORENSTEIN.** Independently
     re-confirmed at the full $\Z_2$-lattice level (not just mod 2): the
     $8$ generators $\{r_1,\ldots,r_4,r_1\xi,\ldots,r_4\xi\}$ all lie in
     $R^\#$ (checked), have rank $4$ (checked), and their images mod $2$
     in $R^\#$-coordinates have rank $4$ (checked) — i.e. $R+R\xi=R^\#$
     exactly, a second, independent proof of the same conclusion.
     **GPT's length-criterion formula appears mis-stated**: the correct
     general fact is $R^\#/R\cong R/\mathrm{ann}(R^\#/R)$ when $R^\#$ is
     cyclic (a tautology once cyclic-ness is shown), and here
     $\mathrm{ann}(R^\#/R)=2R=\bar{\mathfrak p}R$, giving
     $\mathrm{length}(R^\#/R)=\mathrm{length}(R/2R)=4=4$ — matching, not
     contradicting, Gorenstein-ness. The formula as relayed compared
     against $R/J(R)$ (length $1$) instead of $R/2R$ (length $4$),
     which is why it pointed the wrong way; not corrected in the
     relayed instructions, caught here by running the direct test
     instead of trusting the shortcut.
     **Not yet done: Bass criterion**, addressed next below.
   - **Complete overorder enumeration and Bass classification: BASS(R)
     = YES** [Computed — exact, exhaustive] (same script, extended).
     Reframed as GPT specified: $V=(\tfrac12R)/R\cong\mathbf F_2^4$;
     enumerated all $15$ one-dimensional and all $35$ two-dimensional
     $\mathbf F_2$-subspaces of $V$ (both counts verified exactly — a
     bug-check in itself), lifted each to a candidate order
     $S=R+\mathcal O_K x$ (or $+\mathcal O_K x+\mathcal O_K y$), and
     tested genuine multiplicative closure directly (not assumed).
     **Result: exactly $1/15$ lines survive and exactly $2/35$ planes
     survive** — i.e. the overorder poset is exhaustively
     $R\subset E\subset\{M_0,M_1\}$ with **no other overorders**,
     matching GPT's prediction cleanly. **Cross-checked against the
     independent Bruhat-Tits branch-vertex construction of $E$ from
     earlier**: the two completely different constructions of the
     unique index-2 survivor were verified to be the *same lattice* —
     a real bug was caught and fixed first (a frame mismatch: $E$'s
     branch-vertex basis was in the wrong conjugation frame relative to
     $R$'s own basis; comparing against the correctly-framed version
     confirmed agreement). The two index-4 survivors both have
     $v(\mathrm{disc}_{\mathrm{tr}})=0$, confirming they are maximal
     (i.e. $M_0,M_1$), also as predicted.
     **Gorenstein-tested all four orders via a corrected, fully general
     Smith-Normal-Form method** — building this correctly required
     catching and fixing two more real bugs, not glossed over: (1) the
     ad-hoc "$S=2S^\#$" shortcut that worked for $R$ (by coincidence of
     its specific elementary-divisor pattern) fails for $E$ (divisors
     $(0,0,1,1)$) and for $M_0,M_1$ (divisors $(0,0,0,0)$, self-dual) —
     replaced with a proper Smith Normal Form over $\Z_2$ with
     transformation tracking (an initial version of this also had a
     row/column-index bookkeeping bug, caught by a `None` appearing
     among the computed divisor valuations, fixed); (2) an incorrect
     assumption that the *trivial*-divisor coordinates of a
     module-action computation must vanish mod 2 — false: a trivial
     direction is already entirely inside $S$, so any integer multiple
     of it is automatically zero in $S^\#/S$ regardless of parity; the
     assertion enforcing this was simply wrong and removed.
     **Results, fully exhaustive**: $R$ — Gorenstein (re-derived via the
     new general method, exactly reproducing the earlier ad-hoc-method
     result: quotient dimension $4$, generator $(0,0,0,1)$, rank $4/4$
     — a clean cross-check of the two independent implementations). $E$
     — Gorenstein (quotient dimension $2$, all $3$ nonzero candidates
     tested, generator $(1,1)$ achieves rank $2/2$ — matches the
     standard fact that Eichler orders are always Gorenstein, an
     independent confirmation of known theory rather than an assumed
     citation of it). $M_0$, $M_1$ — Gorenstein trivially (both have
     divisors $(0,0,0,0)$, i.e. $M_i^\#=M_i$ exactly, self-dual, as
     expected for maximal orders).
     $$\boxed{\text{BASS}(R_{\bar{\mathfrak p}}) = \text{YES}}$$
     Consistency table:
     | Order | $[S:R]$ | $v(\mathrm{disc}_{\mathrm{tr}})$ | Gorenstein |
     |---|---|---|---|
     | $R$ | 1 | 4 | YES |
     | $E$ | 2 | 2 | YES |
     | $M_0$ | 4 | 0 | YES |
     | $M_1$ | 4 | 0 | YES |
     Not yet done: the 15/35-enumeration and overorder poset are now
     the natural substrate for the $N(R)$ computation (GPT's proposed
     $N(R)\subseteq N(E)$, or now more sharply $N(R)$ acting on the
     complete finite overorder poset $\{R,E,M_0,M_1\}$) — deliberately
     not attempted in the same pass; reported back per instruction.
   - **Independent 67-subspace Bass certificate — confirms BASS(R) = YES
     via a second, differently-structured computation**
     [Computed — exact, exhaustive] (new script,
     `m009_dyadic_bass_certificate.sage`). Per GPT's/webclaude's
     "$R^\#=\tfrac12R$" reformulation, re-derived the setup from scratch
     in a fresh file (same holonomy/BT-tree/trace-dual machinery,
     independently re-run rather than imported) and, before relying on
     it, **independently re-verified $R^\#=\tfrac12R$ a third time** (a
     new direct lattice-equality check, distinct from the two earlier
     derivations) — confirmed. Then enumerated **all $67$
     $\mathbf F_2$-subspaces of $V=R^\#/R\cong\mathbf F_2^4$ in one
     unified pass** (dimensions $0,1,2,3,4$; counts $1,15,35,15,1$
     verified exactly against the Gaussian binomials), rather than
     separately handling lines and planes. This closes a real gap the
     earlier enumeration left untested: **dimension $3$ ($15$
     candidates) and dimension $4$ ($1$ candidate, i.e. $R^\#$ itself)
     were never actually checked before** — both are now confirmed to
     give **zero** multiplicatively-closed candidates (consistent with,
     but not merely assumed from, $v(\mathrm{disc}_{\mathrm{tr}})=4-2d$
     going negative). Exactly $4$ of the $67$ subspaces survive
     closure — dimensions $0,1,2,2$ — and each survivor's
     $v(\mathrm{disc}_{\mathrm{tr}})$ was checked against the predicted
     $4-2d$ formula individually (all matched). The two dimension-$2$
     survivors were then **individually identified** against $M_0$
     ($=M_2(\Z_2)$) and $M_1$ ($=h\cdot M_2(\Z_2)\cdot h^{-1}$)
     explicitly by lattice equality — not just counted as "two maximal
     orders" as before. Re-running the general SNF-based Gorenstein test
     (same corrected algorithm, freshly re-invoked) on all four
     survivors reproduced the identical result: $R,E,M_0,M_1$ all
     Gorenstein, elementary-divisor patterns and generators matching the
     earlier run exactly. Full clean run, no assertion failures, no
     exceptions:
     $$\boxed{\text{BASS}(R_{\bar{\mathfrak p}}) = \text{YES}}
     \quad\text{(independently re-confirmed, 67-subspace sweep)}$$
     This is a genuine second certificate, not a restatement: different
     enumeration code, a new lattice re-check of $R^\#=\tfrac12R$, and
     two previously-untested dimensions (3 and 4) now explicitly ruled
     out rather than assumed impossible.
   - **Local normalizer: $N(R_{\bar{\mathfrak p}})=N(E_{\bar{\mathfrak
     p}})$ — proved rigorously, not just checked against a hand-supplied
     abstract group** [Proved locally] (new script,
     `m009_normalizer_certificate.sage`). A first pass at this (a
     free-standing Sage script asserting properties of three hand-typed
     $4\times4$ matrices) was rejected before being recorded: it never
     connected those matrices to $R_{\bar{\mathfrak p}}$ or
     $E_{\bar{\mathfrak p}}$ at all, so its passing proved nothing about
     the actual order. Redone properly: the whole claim reduces to
     **one falsifiable lattice identity** — $R=\{x\in E:\mathrm{tr}(x)\in
     2\Z_2\}$ exactly — checked directly from the real, previously
     certified $R_{\mathrm{std}}$/$E_{\mathrm{std}}$ bases (not
     hand-picked matrices): $2E\subset R$ confirmed, all four basis
     traces confirmed even, and the mod-$2$ image of $R$ in $E/2E$
     confirmed to be *exactly* the $3$-dimensional kernel of
     $\mathrm{tr}\bmod2$ (not merely contained in it). Given that one
     fact, both inclusions are then elementary and were stated as such:
     $N(R)\subseteq N(E)$ from the already-certified complete overorder
     poset (conjugation permutes overorders preserving index, and $E$ is
     the *unique* index-$2$ overorder, so it must be fixed); $N(E)\subseteq
     N(R)$ from the cyclic-trace identity $\mathrm{tr}(gxg^{-1})=\mathrm{tr}(x)$
     (always true) combined with the lattice fact just verified. As a
     second, independent, fully concrete check (not required for the
     proof, but run anyway): the three candidate generators $u_B=\begin{pmatrix}1&2\\0&1\end{pmatrix}$,
     $u_C=\begin{pmatrix}1&0\\1&1\end{pmatrix}$, $w=\begin{pmatrix}0&2\\1&0\end{pmatrix}$
     were each independently verified to normalize *both* $E$ and $R$ at
     the full $\Z_2$-lattice level (not just mod $2$) by direct
     conjugation — this also checks, for the first time, that $u_B,u_C,w$
     actually lie in $N(E)$ at all (never verified before). Their mod-$2$
     conjugation action on $E/2E$ was then *derived* from the real
     conjugation (not copied) and found to match GPT's hand-supplied
     $T_B,T_C,W$ exactly, element for element — a genuine independent
     confirmation of that derivation, not a restatement of it. The
     generated group has order $8$ and its image stabilizes the actual
     $R/2E$ subspace exactly (confirmed, not assumed).
     $$\boxed{N(R_{\bar{\mathfrak p}}) = N(E_{\bar{\mathfrak p}})}
     \quad\text{(local, at }\bar{\mathfrak p}\text{, rigorously proved)}$$
     **Explicitly NOT established, and not to be recorded as proved:**
     (1) whether $\{u_B,u_C,w\}$ generate the *entire* image of $N(E)$ on
     $E/2E$ (the $D_8$ description is illustrative, not load-bearing for
     the equality above, which holds regardless); (2) the **global**
     claim — whether the local Atkin–Lehner element $w$ globalizes to an
     actual $K$-rational normalizer element, whether local normalizers
     are trivial at every other finite place, and hence whether
     $[N(R):\Gamma_{009}]=2$ and $\mathrm{covol}(N(R))\approx1.3334$ hold
     globally. GPT's own relay flagged this as needing separate,
     dedicated verification before promotion to theorem; that has not
     been done and nothing about it is recorded as proved here.
   - **Global Atkin–Lehner check — attempted; found NO evidence of
     globalization, contradicting the relayed "[N(R):Γ₀₀₉]=2" claim**
     [Computed] (new script, `m009_atkin_lehner_global.sage`). Before
     running anything, flagged and rejected a relayed "verification"
     that divided $\mathrm{vol}(m009)=2.6667\ldots$ by
     $\mathrm{covol}(N(E)):=\tfrac32\mathrm{covol}(T_7)=1.3334\ldots$
     and got $2.000\ldots$ — this is **circular**: both numbers were
     *defined* assuming the index-$2$ extension exists, so the division
     recovers $2$ by algebra alone regardless of any fact about the real
     order; it cannot distinguish globalizes from doesn't. Two real
     checks were run instead. **(a)** $\mathrm{vol}(m009)$ (SnapPy,
     direct) vs. $3\cdot\mathrm{covol}(T_7)$ (covol$(T_7)$ computed
     independently via Sage's own Dedekind zeta function, Humbert's
     formula, not copied) — these agree to $\sim16$ significant figures
     ($2.66674478\ldots$ both sides), confirming $\Gamma_{009}$ has
     *exactly* the covolume of the level-$\bar{\mathfrak p}$ Eichler
     congruence subgroup $\Gamma_0(\bar{\mathfrak p})\subset T_7$ (the
     classical index formula $[T_7:\Gamma_0(\bar{\mathfrak
     p})]=N(\bar{\mathfrak p})+1=3$, standard orbit-stabilizer on
     $\mathbf P^1(\mathcal O_K/\bar{\mathfrak p})$, not something taken
     on faith). **This is itself informative**: it shows $\Gamma_{009}$
     already accounts for the *entire* covolume of $\Gamma_0(\bar{\mathfrak
     p})$, not merely half of it — i.e. it is NOT a proper index-$2$
     subgroup waiting to be doubled. **(b)** An actual search for a
     global lift of the local Atkin–Lehner swap: since the branch seed
     $g_0$ (from the certified BT-tree computation) is an *exact
     rational* matrix, not merely a $2$-adic limit object, the local
     swap element $w_{\mathrm{local}}=\begin{pmatrix}0&2\\1&0\end{pmatrix}$
     (already verified this session to normalize both $E_{\mathrm{std}}$
     and $R_{\mathrm{std}}$ locally) was honestly conjugated back to
     global coordinates via $g_0\,w_{\mathrm{local}}\,g_0^{-1}$ — a
     genuine $K$-rational candidate, not a frame guess. Recognizing that
     $w_{\mathrm{local}}$ is only *one* of the four local elements that
     swap the branch (the full nontrivial coset of the already-certified
     order-$8$ normalizer image), **all four** were tested this way
     ($g_0\,w\,g_0^{-1}$, $g_0\,u_Bw\,g_0^{-1}$, $g_0\,u_Cw\,g_0^{-1}$,
     $g_0\,u_Bu_Cw\,g_0^{-1}$), plus five additional naive candidates for
     context. **All nine fail** the exact $\mathcal O_K$-integrality test
     for global normalization of $R$ (not just approximately — exact
     arithmetic, no candidate came close).
     $$\text{No candidate globalizes} \Rightarrow \text{evidence FOR }
     N(R_{\bar{\mathfrak p}})=\Gamma_{009}\text{ globally (no index-2
     extension found)}$$
     **CORRECTION (caught by the user, confirmed valid):** the framing
     above overstates what nine matrix representatives can show. The
     local normalizer $N(R_{\bar{\mathfrak p}})$ is an infinite (pro-$2$)
     group; each of the four residue classes mod $2E$ tested has
     infinitely many representatives differing by the (infinite)
     congruence kernel, and only nine specific representatives were
     tried. "No candidate globalizes" is therefore **not** valid evidence
     either way about whether the coset globalizes — retracted as stated.
   - **Discriminant scoping computation — decisive, and changes the
     picture** [Computed] (new script,
     `m009_global_discriminant_scan.sage`). The right next question,
     per a relayed strong-approximation argument (standard theory —
     Kneser/Platonov strong approximation for $\mathrm{SL}_2$, legitimate
     and correctly invoked in general form): is $\bar{\mathfrak p}$ the
     *only* prime where $R$ is non-maximal globally? If so, the
     "admissible determinant squareclass at every other bad prime"
     condition the argument needs is checked at zero primes — vacuously
     true — since away from $\bar{\mathfrak p}$, $\pi=1-w$ is a local unit
     and a maximal order's normalizer determinant image contains all
     local units automatically. Computed the global reduced-trace
     discriminant of $R$ directly from the exact $K$-basis (Gram matrix
     $T_{ij}=\mathrm{Trd}(r_i\bar r_j)$, $\det T=3w-1$) and factored the
     resulting ideal in $\mathcal O_K$ (class number $1$, so this
     factorization is unambiguous):
     $$(\det T) = (\bar{\mathfrak p})^4,\qquad\text{no other prime
     factors}$$
     matching the already-certified local valuation $4$ exactly, with
     **nothing else in the factorization**. So $R$ is maximal at *every*
     finite prime other than $\bar{\mathfrak p}$, and the
     strong-approximation criterion's "check every other bad place" step
     is genuinely vacuous — there are no other places. Modulo the
     (essentially automatic, by construction) bookkeeping at
     $\bar{\mathfrak p}$ itself, this makes global existence of a
     branch-swapping element of $N(R)$ **plausible via strong
     approximation** — a real, meaningful update, not a restatement.
     **Still NOT a completed proof**: strong approximation is an
     existence theorem, not a construction — it would give an element of
     $N_K(R)$ without necessarily an explicit nice matrix (consistent
     with why the nine tried representatives found nothing simple), and
     the precise technical argument (matching $\mathrm{PGL}_2\to
     \mathrm{SL}_2$ reduction via $\det=[\pi]$, invoking strong
     approximation for $\mathrm{SL}_2/K$ rigorously rather than just
     citing the strategy) has not been carried out here — this is a
     genuine next step, not yet done. **Do not record
     $[N(R):\Gamma_{009}]=2$ or the $H_1(m009)=\Z\oplus\Z/2$ torsion
     connection as established** — both remain open, though the balance
     of evidence has now shifted from "leans against globalizing" to
     "plausibly does globalize, pending the completed argument."
   - **Globalization THEOREM — complete existence proof, the two
     remaining gaps closed** [Proved] (new script,
     `m009_strong_approx_local_check.sage`, plus the discriminant scan
     above). The strong-approximation argument had two open pieces
     before it could be called complete; both closed:

     **(1) The $\bar{\mathfrak p}$-local bookkeeping, computed
     explicitly, not just cited as plausible.** Need: an element of the
     branch-swapping coset whose determinant matches $[\pi]_{\bar{\mathfrak
     p}}=[1-w]_{\bar{\mathfrak p}}$ in $K_{\bar{\mathfrak
     p}}^\times/(K_{\bar{\mathfrak p}}^\times)^2\cong\mathbf Q_2^\times/(\mathbf
     Q_2^\times)^2$ (order $8$). Proved directly (not cited) that
     diagonal matrices $\mathrm{diag}(u,1)$, $u\in\Z_2^\times$, lie in
     $E^\times\subset N^+(R_{\bar{\mathfrak p}})$ — they commute with
     $h=\begin{pmatrix}2&0\\0&1\end{pmatrix}$, so they normalize $M_0$
     and $M_1$ *individually* by pure commutativity, no computation
     needed beyond that observation — and their determinants sweep *all*
     of $\Z_2^\times$, hence all $4$ unit squareclasses (verified
     directly against $M_0,M_1$ for all $4$ representatives). Since
     $w_{\mathrm{local}}=\begin{pmatrix}0&2\\1&0\end{pmatrix}$
     (already-verified branch-swapper) has $\det=-2$, odd valuation
     matching $\pi$'s, computed explicitly which unit closes the gap:
     $u_0\equiv5\pmod8$, giving
     $$g_{\bar{\mathfrak p}}=w_{\mathrm{local}}\cdot\mathrm{diag}(5,1),
     \qquad \det(g_{\bar{\mathfrak p}})/\pi\ \text{is an exact }2\text{-adic
     square (verified via }\mathrm{Qp.is\_square()}\text{, to }300\text{
     digits)}.$$

     **(2) Every other finite place, closed by the discriminant scan
     above, not merely assumed "as the picture suggests."** Since
     $\mathrm{disc}_{\mathrm{tr}}(R)=(\bar{\mathfrak p})^4$ exactly with
     *no other prime factors* (computed), $R_{\mathfrak q}$ is maximal at
     every $\mathfrak q\ne\bar{\mathfrak p}$, and $\pi$ is a unit there.
     For a maximal order $M_2(\mathcal O_{K_{\mathfrak q}})$, its unit
     group is exactly $\{x\in M_2(\mathcal O_{K_{\mathfrak
     q}}):\det x\in\mathcal O_{K_{\mathfrak q}}^\times\}$ — an elementary
     fact ($x^{-1}=\det(x)^{-1}\mathrm{adj}(x)$ stays integral iff $\det
     x$ is a unit) — so its determinant image is the *entire* unit group,
     and $\pi$ being a unit there trivially lands in it: no further
     per-prime check is needed, and there are no other primes to check
     regardless.

     **Assembling the strong-approximation argument.** With $d=\begin{pmatrix}\pi&0\\0&1\end{pmatrix}$,
     $d^{-1}g_{\mathfrak q}$ has trivial determinant squareclass at
     every finite $\mathfrak q$ (by (1) and (2)), hence is represented
     by an element of $SL_2(K_{\mathfrak q})$. $K=\mathbf Q(\sqrt{-7})$
     has $K_\infty=\mathbf C$, so $SL_2(K_\infty)$ is non-compact —
     the classical hypothesis for strong approximation for the simply
     connected group $SL_2$ (Kneser/Platonov–Rapinchuk; the same
     technique used throughout the arithmetic-Kleinian-group literature,
     e.g. Maclachlan–Reid). $SL_2(K)$ is therefore dense in
     $SL_2(\mathbb A_{K,f})$: choosing the open target set to be a small
     neighborhood of $d^{-1}g_{\bar{\mathfrak p}}$ at $\bar{\mathfrak p}$
     and *the full compact group* $SL_2(\mathcal O_{K,\mathfrak q})$ at
     every other place (legitimate since there is no other place needing
     a nontrivial condition, by (2)) gives $s\in SL_2(K)$ landing in that
     set — meaning $s$ is $\mathcal O_{K,\mathfrak q}$-integral at *every*
     $\mathfrak q\ne\bar{\mathfrak p}$ by construction, and close enough to
     $d^{-1}g_{\bar{\mathfrak p}}$ at $\bar{\mathfrak p}$ that
     $\alpha:=ds\in N(R_{\bar{\mathfrak p}})$ there (normalizers of orders
     are open subgroups, so a close-enough approximation suffices).
     $$\boxed{\exists\,\alpha\in N_K(R)\subset PGL_2(K):\ \alpha R_{\mathfrak
     q}\alpha^{-1}=R_{\mathfrak q}\ \forall\mathfrak q,\ \text{and }\alpha
     \text{ swaps }M_0,M_1\text{ at }\bar{\mathfrak p}}$$
     i.e. **the local branch-swapping coset globalizes.** This directly
     answers "Task 1" from the relayed strong-approximation program in
     the affirmative, superseding both the earlier "no candidate
     globalizes" overclaim (retracted above) and its own
     "plausibly globalizes" hedge — this is now a genuine existence
     proof, modulo only the standard citation of $SL_2$ strong
     approximation itself (foundational, not re-derived here).

     **What this does NOT establish — explicitly out of scope here,
     "Task 2" of the relayed program, not attempted:** whether this
     $\alpha$ lies in $\Gamma_{009}$ or not, whether
     $\Gamma_{009}^+\subseteq N_K^+(R)$ is equality or strict, and hence
     $[N(R):\Gamma_{009}]$ (if finite at all) — strong approximation
     proves *existence* of *some* global normalizing element, not its
     relationship to the specific holonomy group $\Gamma_{009}$, which
     requires separately determining whether the actual holonomy
     generators $a,b$ preserve or swap $\{M_0,M_1\}$ (a distinct,
     tractable-looking but unattempted computation) and comparing
     $\Gamma_{009}$ against $N_K(R)$ as concrete subgroups. Do not
     record $[N(R):\Gamma_{009}]=2$, the covolume-halving claim, or the
     $H_1(m009)=\Z\oplus\Z/2$ torsion connection from that.
   - **Task 2 first step attempted — genuine structural obstruction
     found, not yet resolved** [Blocked, documented] (new script,
     `m009_task2_epsilon_check.sage`). Tried to compute
     $\varepsilon:\Gamma_{009}\to C_2$ (does conjugation by a raw
     holonomy generator $a$ or $b$ swap $M_0,M_1$ at $\bar{\mathfrak
     p}$?) directly from the raw generators. **The existing exact-$K$
     pipeline cannot see $a,b$ individually** — attempted to identify
     their matrix entries in $K$ using the identical method/rescaling
     already used successfully for the words `aa,bb,ab,ba`; each entry
     of $a$ and of $b$ instead fits its own *distinct* rational quadratic
     with **no root in $K$** (checked explicitly, not assumed). This is
     a real structural fact, not a bug: `aa,bb,ab,ba` landing in $K$
     while bare $a,b$ don't is exactly the signature of $K$ being the
     *invariant* trace field (generated by traces of squares, i.e. by
     $\Gamma^{(2)}\le\Gamma_{009}$) rather than the trace field — $ab$
     lying in $K$ shows $a,b$ have the *same*, *nontrivial* image in
     $\Gamma_{009}/\Gamma^{(2)}\cong C_2$, and any word in that same
     nontrivial coset (e.g. $aab$) will hit the identical obstruction, so
     there is no cheap word-combination workaround: $\varepsilon(aa)=
     \varepsilon(bb)=0$ automatically (squares) and $\varepsilon(ab)=
     \varepsilon(ba)=\varepsilon(a)\oplus\varepsilon(b)$ only gives the
     XOR, never the individual values, from data reachable this way.
     **Resolving this needs identifying the actual (larger, apparently
     degree-$4$-over-$\mathbf Q$) field the raw generators' entries live
     in and redoing the $\bar{\mathfrak p}$-adic embedding there** —
     comparable in scope to the local analysis already done for $K$
     itself this session, not a quick add-on. **Deliberately not
     attempted in this pass** — flagging and stopping here rather than
     open a second major sub-project without a checkpoint.
   - **$\varepsilon(a)=\varepsilon(b)=1$ — resolved, after a real bug
     was found and fixed, and cross-validated independently** [Computed]
     (new script, `m009_task2_epsilon_v2.sage`, superseding
     `m009_task2_epsilon_final.sage`, kept with a header explaining why).
     Identified the field $L=\mathbf Q[y]/(y^4-y^3+y+1)$ that $a,b$'s
     entries live in (via `number_field_elements_from_algebraics`), but
     the **first attempt to build the exact matrices $a,b\in L$ by
     identifying all $8$ entries independently was wrong** — verified by
     the decisive check $a^2\overset{?}{=}$ the already-trusted exact
     $K$-matrix for `aa`: **failed**. Diagnosed as a wrong-root pick
     among close candidates when matching $8$ separate `algdep` outputs
     independently. **Fixed with a far more robust construction**: since
     `aa`$=a^2$ is already exact over $K$ (tested all session) and
     $\det(a)=1$, Cayley–Hamilton gives $a=(a^2+I)/\mathrm{tr}(a)$
     exactly — needing only *one* new algebraic number ($\mathrm{tr}(a)$)
     identified per generator instead of four. Verified numerically to
     $\sim90$ digits against the actual holonomy matrix before trusting
     it. **A second correction surfaced along the way**: the
     $\bar{\mathfrak p}$-behavior in $L$ is *embedding-dependent* — the
     specific embedding $K\hookrightarrow L$ actually consistent with
     the verified $a,b$ (not just any of Sage's two listed embeddings)
     gives $\bar{\mathfrak p}$ **ramified** ($e=2,f=1$), not inert as
     first (wrongly) reported — corrected the completion accordingly
     (built via completing the square to an Eisenstein $Y^2-d$ form,
     since Sage's $p$-adic `extension()` needs Eisenstein or unramified
     input specifically). Rebuilt the $\bar{\mathfrak p}$ branch inside
     this corrected completion (branch size $2$, matching every prior
     computation) and tested conjugation by $a$, by $b$, directly:
     $$\varepsilon(a)=1,\qquad\varepsilon(b)=1\qquad\text{(both
     branch-swapping)}$$
     **Independently cross-validated** via a completely different,
     much simpler route: $ab$ is already exact in $K$ (no $L$ needed at
     all), directly testable in the original $\mathbf Q_2$ pipeline —
     predicted $\varepsilon(ab)=\varepsilon(a)\oplus\varepsilon(b)=0$
     (fixes), computed independently: **fixes — exact match.**
     **Consequence for the normalizer problem**: $\varepsilon:\Gamma_{009}\to
     C_2$ is *already surjective from the generators alone* —
     $\Gamma_{009}$ contains branch-swapping elements natively, so the
     elaborate strong-approximation existence proof from earlier, while
     still a valid and independent achievement in its own right, was not
     actually *needed* to exhibit a swapping element of $N_K(R)$: $a$
     itself already is one (standard theory — $\Gamma_{009}$ normalizes
     $R$ since $\Gamma^{(2)}_{009}\trianglelefteq\Gamma_{009}$ — makes
     this automatic, not a new computation). This resolves the
     branch-swap half of the normalizer problem outright and, per the
     exact-sequence framing proposed earlier, reduces the entire
     remaining index question to a single comparison:
     $$[N_K(R):\Gamma_{009}] = [N_K^+(R):\Gamma_{009}^+]$$
   - **Third, independent certificate for $\varepsilon(a)=\varepsilon(b)=1$
     — entirely $K$-rational, bypasses the quartic field $L$ altogether**
     [Proved] (new script, `m009_task2_epsilon_krational.sage`). Key
     observation: since $\det(a)=1$, Cayley–Hamilton gives
     $a^2-\mathrm{tr}(a)a+I=0$, i.e. $A:=a^2+I=\mathrm{tr}(a)\cdot a$ — a
     *scalar* multiple of $a$. Conjugation is insensitive to scalars
     (true in any ring, regardless of which field the scalar itself
     lives in), so $\mathrm{Ad}(A)=\mathrm{Ad}(a)$ exactly, while $A=$
     `aa`$+I$ is manifestly an exact $K$-matrix (`aa` already trusted).
     So $\varepsilon(a)$ can be read off by testing $A$ directly in the
     plain $K\to\mathbf Q_2$ pipeline used throughout this whole
     session — no root-matching, no quartic $L$, no $Q_4/Q_2(\sqrt{d})$
     extension. Tested $A=$`aa`$+I$, $B=$`bb`$+I$, and $A\cdot B$
     (predicting $\varepsilon(ab)=0$) together:
     $$A:\text{swaps},\qquad B:\text{swaps},\qquad AB:\text{fixes}$$
     — **exact match** with the quartic-field computation, via a
     completely different and far simpler method. Also checked the third
     Reidemeister–Schreier generator $ba^{-1}$ directly (via
     $B\cdot\mathrm{adj}(A)$, itself $K$-rational since $\mathrm{PGL}_2(K)$
     is closed under inversion): **fixes**, as required. This promotes
     $[a],[b]\in\mathrm{PGL}_2(K)$, $\varepsilon(a)=\varepsilon(b)=1$,
     $\varepsilon(\Gamma_{009})=C_2$, and
     $$\Gamma_{009}^+=\langle a^2,\ ab,\ ba^{-1}\rangle$$
     (standard Reidemeister–Schreier for transversal $\{1,a\}$, all three
     generators now with explicit $K$-rational projective
     representatives — $a^2=$`aa`, $ab=$`ab` (already known exactly),
     $ba^{-1}=B\cdot\mathrm{adj}(A)$) to theorem-level computational
     facts, resolving the apparent "quartic field vs. $K$-rational
     normalizer" tension: the quartic extension was only ever needed for
     the chosen $\mathrm{SL}_2$-*lift*, never for the underlying
     $\mathrm{PGL}_2$-*classes*, which were $K$-rational all along.
     **Not yet attempted**: computing $\Gamma_{009}^+$'s relationship to
     $N_K^+(R)$ concretely (comparing the group generated by these three
     explicit $K$-rational elements against the full endpoint-preserving
     normalizer) — the genuinely hard remaining piece, now precisely
     isolated and posed as a purely $K$-arithmetic comparison rather
     than one entangled with field-extension bookkeeping.
   - **Which homomorphism $H_1(m009)\to C_2$ is $\varepsilon$? — resolved,
     with a correction to how the question was posed**
     [Computed] (new script, `m009_task2_epsilon_vs_H1.sage`). The
     literal question "does $\varepsilon$ factor through $H_1(m009)$" is
     **not something to test** — every homomorphism to an abelian group
     (here $C_2$) factors through the abelianization automatically, by
     the universal property; this holds regardless of what
     $\varepsilon$ turns out to be. The well-posed version — *which* of
     the (three nontrivial) homomorphisms $H_1(m009)=\Z/2\oplus\Z\to
     C_2$ does $\varepsilon$ equal — is answered here. Built $\Gamma_{009}$
     as a GAP finitely-presented group from SnapPy's own presentation
     (generators `a,b`, single relator `aabABaaBAb`) and computed the
     abelianization map explicitly via `MaximalAbelianQuotient`,
     cross-checked independently by hand from the relator's abelianized
     exponent vector $(2,0)$: **$[a]$ generates the $\Z/2$ torsion
     summand exactly (order $2$, no constraint from the relator forces
     anything else); $[b]$ is entirely unconstrained, generating the
     free $\Z$ summand.** Comparing against the established
     $\varepsilon(a)=\varepsilon(b)=1$: the "projection onto $\Z/2$"
     candidate is **rejected** (would force $\varepsilon(b)=0$, contradicted);
     the "reduction of the free part mod $2$" candidate is **also
     rejected** (would force $\varepsilon(a)=0$, contradicted); the
     **third, "sum" candidate — nontrivial on both the torsion generator
     and the free generator — matches exactly**:
     $$\varepsilon = (\text{proj. onto }\Z/2)\ \oplus\ (\text{free part
     mod }2)$$
     the unique nontrivial homomorphism $H_1\to C_2$ nonzero on *both*
     summands. Consequence: $\Gamma_{009}^+=\ker\varepsilon$ is the
     fundamental group of a specific, nameable double cover of $m009$ —
     not the "obvious" torsion-class cover, and not the mod-$2$
     free-part cover alone, but their combination — a concrete target
     SnapPy could in principle construct directly (`M.cover(...)` from
     the explicit kernel), not attempted here.

4. **576-element paper — finish as pure mathematics, keep the physical
   reading permanently separated.** The arithmetic chain (discriminants,
   ramification, Artin conductors, Chebotarev, maximal abelian
   subextension) is already registered as [Proved]; the Weyl-group
   identity (C₂×S₄×C₂×S₃ ≅ W(SU(2))×W(SU(4))×W(SU(2))×W(SU(3))) can
   appear as a closing observation, but the manuscript should terminate
   the theorem before any physical interpretation, not lean on HFG
   motivation for its correctness.

5. **Census-wide rarity of the C₂×S₄×C₂×S₃ configuration — SCAN
   COMPLETE, rarity analysis done.** `census_disjoint_ramification_scan.sage.py`
   finished the full OrientableCuspedCensus: **212,641/212,641 manifolds
   scanned**. Checkpoint frozen and hashed for reproducibility:
   `census_final_COMPLETE_aug27.json`
   (sha256 `f6d76c553f6e4564a053aeb42ae5cc7062d5912ac875e91d2f4fc229a40a5c40`);
   the companion `census_field_classes.json`
   (sha256 `681cf5aef0b15179a013e6d29ebabe1925a876e9ca8fe66690a95b0a53cc834`)
   holds the 165 resolved field records the analysis below was run
   against.
   - **Final scan totals** [Computed, exact]. 1,839/212,641 manifolds
     produced a successfully resolved invariant trace field
     (**0.865%**), representing **165 distinct number fields**.
     210,802 manifolds failed to resolve — 90.9% `field_not_recognized`,
     4.9% the pre-patch `AttributeError` streak (indices <12,393,
     already fixed, not a live issue), 3.6% `timeout`, 0.6%
     closure-degree-bound exceeded. **All frequency statements below
     are conditional on this resolved subset and must NOT be read as
     frequencies over the complete census** — the selection function
     `P(field resolved | family, complexity)` has still not been
     separately modeled; this remains the outstanding step (unchanged
     from the original selection-function concern below).
   - **Family-dependent recognition rate confirmed at completion, ~50×
     spread**: m-family 92/301 = **30.6%** → s-family 95/962 = **9.9%**
     → v-family 135/3,552 = **3.8%** → t-family 304/12,846 = **2.4%**
     → o-family 1,213/194,980 = **0.62%**. Any claim like "S4 is the
     dominant Galois group in the census" is therefore too strong; the
     defensible claim is "S4 is dominant among the 165 fields this
     pipeline's recognizer resolved."
   - **Galois closure group distribution (165 fields)**: S4 65, D4 28,
     C2×S4 25, S3 15, D6 8, C2 6, C2×C2 6, D5 4, S3×S3 2, C3×S3 2,
     C2×A4 1, C6 1, (C4×C2):C2 1, C2×D4 1. Stem degree distribution:
     2→6, 3→15, 4→92, 5→4, 6→41, 8→7.
   - **Discovery curve F(n) — not saturated, and NOT monotonically
     decelerating** [Computed, exact, from checkpoints pulled during
     the live run]: 102 fields @ 54,025/212,641 (25.4%) → 129 fields @
     154,250 (72.5%) → 132 fields @ 183,350 (86.2%) → **165 fields @
     212,641 (100%)**. The middle interval (72.5%→86.2%, 13.7 pp of
     census) added only 3 new fields; the final interval (86.2%→100%,
     an almost identical 13.8 pp span) added 33 — an 11× jump in
     discovery rate right at the end. This is a measured fact, not an
     extrapolation artifact, and it directly falsifies the assumption
     that the 86%-checkpoint sample had approximately saturated the
     resolvable-field population — any rarity claim based on a partial
     run would have undercounted field diversity substantially.
   - **Rarity analysis of the C₂×S₄×C₂×S₃ configuration** [Computed,
     exact, run against the frozen `census_final_COMPLETE_aug27.json`]:
     - Fields with ramification support **exactly** a single prime:
       36/165 (21.8%), spanning 30 distinct primes.
     - Support exactly {3}: 1 field (`x²−x+1`, C2, disc −3, 47
       manifolds — Q(√−3)).
     - Support exactly {283}: 1 field (`x⁴−x−1`, S4, closure degree 24,
       disc −283, 3 manifolds — the m003/m019 field).
     - Support exactly {7}: **2** fields — `x²−x+2` (C2, disc −7, 15
       manifolds; the same field K as the m009/m010 quaternion-algebra
       investigation) and `x⁶−x⁵+x⁴−x³+x²−x+1` (C6, disc
       −16807 = −7⁵, 1 manifold).
     - Support exactly {59}: 1 field (`x³+2x−1`, S3, closure degree 6,
       disc −59, 1 manifold — the m006 field).
     - Pairwise-disjoint-support 4-tuples among all 165 fields:
       **4,296,004** (out of C(165,4)=29,180,927 possible 4-subsets,
       ≈14.7%) — disjoint ramification support is common among
       distinct resolved fields, unsurprising since most discriminants
       are distinct primes.
     - Of those, 4-tuples whose Galois-group multiset matches exactly
       {C2, S4, C2, S3}: **3,648**. **The general disjoint-
       ramification⟹direct-product mechanism (Section 2 of the
       Galois-product paper) is therefore not a one-off curiosity in
       the resolved census — it has thousands of realizations.** This
       is direct, positive evidence the theorem is broadly applicable,
       strengthening (not narrowing) its scope.
     - **The specific {−3,−283,−7,−59} tuple used in the paper**:
       exactly **one** way to assemble a C2×S4×C2×S3 4-tuple using
       precisely the primes {3, 283, 7, 59} (taking the C2 field at 7,
       not the C6 field at 7): {`x²−x+1`, `x⁴−x−1`, `x²−x+2`,
       `x³+2x−1`}. So among the 3,648 type-matching 4-tuples in the
       resolved census, this exact prime-configuration occurs **1
       time** — it is unique, not merely uncommon, within the resolved
       population. Correct framing for the paper: *"this configuration
       is one of 3,648 disjoint-support C₂×S₄×C₂×S₃ realizations found
       among the 165 fields resolved so far in a full-census scan, and
       the specific prime set {3,7,59,283} is the unique one among them
       — a distinguished, not generic, example of a common
       phenomenon."* This statement is exact and defensible on the
       resolved subset; it is NOT (yet) a statement about the full
       212,641-manifold census, since only 0.865% of manifolds resolved
       a field at all.
   - Status: `[Computed]`, exact on the resolved subset. Selection-
     function modeling (`P(resolved | family/complexity)`) remains the
     outstanding step before any full-census frequency claim can be
     made responsibly.

6. **Dual surgery paper (SSRN 7277458) — revision + venue.** AGT
   submission 260813-Gentry **rejected Aug 24, 2026** (scope, not a math
   error) — no longer under review anywhere. Needs explicit
   prior-unknown statement, Neumann-Reid framing, forward-looking
   questions. Candidate venues: Geometriae Dedicata, JLMS, Michigan
   Math. J., Experimental Mathematics. Do not resubmit to AGT.
   **Revision in progress on `gentry-dual-surgery-v1.tex`** (not yet
   resubmitted anywhere): fixed a real error (the paper had wrongly
   claimed D₆≇S₃×Z/2 — verified via GAP that D₆≅S₃×Z/2 exactly,
   flipping the conclusion from "does not extend the Pati–Salam
   correspondence" to "does extend it"); replaced GAP-small-group-id
   lookups with conceptual disjointness proofs for both the m003/m019
   (S4×Z/2) and m003/m006 (S3×Z/2) results, via the distinct quadratic
   fields Q(√−3), Q(√−283), Q(√−59) in their respective Galois
   closures (each discriminant independently verified in Sage before
   editing); removed an unproven cusp-field/invariant-trace-field
   equivalence claim; rewrote the abstract to lead with the paired
   Z/2×S4 / Z/2×S3 structure. Recompiles cleanly (pdflatex, no errors,
   no undefined references). Next venue: TBD, pending final read-through
   of the revised manuscript.

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
    (item 5) — **COMPLETE.** `census_disjoint_ramification_scan.sage.py`
    finished the entire 212,641-manifold OrientableCuspedCensus; the
    rarity/discovery-curve analysis is done and recorded in item 5. The
    uniqueness half of this pair was already done (COMPLETED item 32).
    Remaining open piece: the selection-function model
    `P(field resolved | family, complexity)` needed before any
    full-census (not just resolved-subset) frequency claim.

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
