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

29. **Q-001 Fricke-collapse exact resolution** ("RESOLVED," commit
    `e419cfa`). B=A/(q₁₀(x)) has dim 20 exactly; multiplication by
    u=z−x on B has rank 10 and **u²=0 exactly** — confirmed by exact
    rational linear algebra. This is a genuine nonreduced/nilpotent
    scheme-theoretic structure, not a plain z=x collapse — see OPEN
    item 2 for the natural next calculation this motivates.
30. **m009/m010 cusp-order distinction** [Proved via exact algebraic
    identity] (`gentry-galois-product-theorem.tex` Prop. 3.2). τ₉=√−7
    (order Z[√−7]), τ₁₀=(1+√−7)/2 (maximal order O_K), index 2 apart.
31. **m009/m010 arithmeticity** [Computed, extensive but not a formal
    closed-form certificate]: 78/78 Γ^(2) trace-integrality checks land
    exactly in O_K.

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

2. **Q-001 — determine the radical of J=I+⟨q₁₀(x)⟩ and test whether
   z−x∈√J.** Natural next step given item 29: if true, z=x holds on
   every closed point of the geometric component while z−x≠0 in A/J,
   meaning the apparent Fricke collapse is exact on the reduced variety
   but carries a first-order nilpotent transverse direction — a
   materially stronger and more interesting theorem than the original
   z=x collapse question. Not yet attempted.

3. **Bianchi index-6 subgroup enumeration for m009/m010.** Conjecture
   that both are torsion-free index-6 subgroups of T_7=PSL₂(O_{−7}) or
   its extension Γ~_{−7} (covolume≈0.4445). **The Grunewald-Schwermer
   citation and the Dinakaran(2022)/Reese(2023) presentation citations
   have not been independently checked** — verify before spending GAP
   compute time on `LowIndexSubgroups(T_7, 6)`. A more careful sequence
   than jumping straight to the index-6 enumeration: (i) certify
   arithmeticity exactly rather than resting on the 78/78 computational
   check; (ii) identify and verify the correct maximal arithmetic
   lattice; (iii) compute its covolume exactly; (iv) only then infer the
   candidate index from the volume ratio; (v) enumerate subgroups at
   that index; (vi) compute torsion/cusp-number/abelianization/peripheral
   lattice for each; (vii) identify m009/m010 from those invariants. A
   built-in falsifier: if the enumeration doesn't produce the expected
   pair, the overgroup/index picture is wrong even though the cusp-order
   theorem (item 30) remains true regardless.

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
   maximal cusp order) does not have this bias and is separately running,
   near completion.

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

19. **Full census extension** for the uniqueness/selection checks —
    earlier checks only covered the first 80–200 of ~10,000+ manifolds;
    this session's two census scans (item 5) are the actual follow-through.

### Paper-portfolio / editorial gaps (from the Aug 6–20 2026 audit entries)

20. **Twist Angle Spectrum paper** — HOLD, not ready: no null-hypothesis
    test anywhere in the paper (every sibling paper has one), no Data
    Availability section, and a real ambiguity between its δ_CKM=68.0°
    (single-word) and the CKM paper's J=0 (three-word triple) that the
    paper's own framing blurs without contradicting.
21. **CKM v3 paper** — two small fixes needed (a stale SSRN citation
    year, missing MSC classification), otherwise assessed as the most
    rigorous paper in the portfolio and ready to resubmit.
22. **Qubit gates paper** — the CS level k=2 physical-interpretation
    claim needs to be split from the proven algebraic identity (already
    flagged honestly in the paper's own §6.3, just needs moving
    earlier); a citation to a now-confirmed-rejected manuscript needs
    updating.
23. **Holonomy-CP paper** — genuinely solid, no overclaiming found;
    needs citation cleanup (two garbled self-citations, stale
    "submitted" status) and MSC codes. Assessed closer to
    submission-ready than most other papers audited.
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
