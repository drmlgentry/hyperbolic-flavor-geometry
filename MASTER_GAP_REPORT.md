# CORE_MASTER Gap Report

## Aug 25 2026 — Full-census confirmation: m010 uniquely minimal-volume maximal-order manifold

**`census_uniqueness_scan.py` ran to completion across the entire
212,641-manifold `OrientableCuspedCensus`** (~5.8 CPU-hours, 1 error, 0
timeouts after a per-manifold hard timeout and resumable checkpointing
were added following two earlier silent kills — one from a host reboot
tearing down WSL2, one from WSL2's own idle-timeout between separate
`wsl.exe` invocations; both fixed by running the job as one continuously-
attached session). Result:

- 37 manifolds in the full census have invariant trace field Q(√−7).
- 17 of those realize the maximal order O_K (cusp-shape index 1, exact
  algebraic check via `p+qb` coordinate recovery, not numerical).
- **m010 (vol=2.66674478344906) is uniquely the minimum-volume manifold
  among all 17** — the next-smallest maximal-order manifolds (s772,
  s774–s776, s778, s781–s782, s786–s787) are all at exactly double that
  volume (5.333490), with nothing at or below m010's own volume.

This upgrades `gentry-galois-product-theorem.tex` Proposition 3.2 from
"verified in an early ~20,000-manifold slice" to a genuine, exact,
full-census result. Companion scan
(`census_disjoint_ramification_scan.sage.py`, testing rarity of the
C₂×S₄×C₂×S₃ configuration and the {3,7,59,283} quadruple) is still
running as of this entry — see its own methodological caveat about
non-random missingness in the `s`-family before treating any rarity
statistic from it as unbiased.

**Not yet done:** propagating this into `CLAIMS_REGISTER.md` (a new or
upgraded entry) and into the paper's Proposition 3.2 wording itself —
both are the user's call, not made unilaterally here.

## Aug 23 2026 — Stage 3 BLIND TEST COMPLETE: result NULL (no canonical selector found)

**The full pre-registered blind protocol ran to completion.** Sealed packet
(`STAGE3_BLIND_PACKET.md` + `stage3_blind_states.json`, commit `29c3c08`,
verified leak-free of target integers and domain keywords) handed to two
independent fresh sessions -- one Claude, one GPT -- neither exposed to this
conversation or the target index list. Scoring criterion pre-registered
(`STAGE3_SCORING_CRITERION.md`, commit `4f322ae`) before either frozen
answer was examined. Both responses frozen, hashed, and committed
(`8139c2d` Claude sha256 371ea4f4..., `8336b7b` GPT sha256 8128d688...)
before the target set was opened.

**Candidates produced:**
- Claude #1: `Q=N_{K/Q}(tr_a)` = (2,2,2,-2,-2,-2)
- Claude #2: `Q=Tr_{K/Q}(tr_a)` = (-1,-1,-1,1,1,1)
- Claude #3: `Q=tr_b-tr_a` = (1,1,1,1,1,1) -- built on a real documentation
  error in the sealed packet (the stated identity "tr_b=tr_a+1 in every
  state" only holds on the epsilon=+1 sheet; for epsilon=-1 the correct
  relation is tr_b=1-tr_a, since tr_b never flips with epsilon (chi(b)=0)
  while tr_a does (chi(a)=1) -- caught by GPT's session checking the raw
  data directly rather than trusting the packet's summary claim, not a
  computational bug in the underlying construction, purely a documentation
  overgeneralization)
- GPT #1: `Q=round(3/pi * Arg(tr_a))` = (-2,2,0,1,-1,3)
- GPT #2: `Q=N_{K/Q}(tr_a)` = (2,2,2,-2,-2,-2) -- numerically identical to
  Claude #1, found independently

**Unblinding pass** (targets {12,18,43,65,75,106}, pre-registered
state_id-order pairing, no permutation search): every candidate scores
0/6 exact matches and 0/6 within the pre-registered tolerance of 1.
Secondary permutation-allowed set-match check also fails for all five --
not one candidate's output set overlaps the target set under any bijection.
Deviations are tens of units against a 12-106 target range -- not a
borderline call, nothing close to argue about.

**Result: NULL, precisely stated.** "No canonical selector is supported by
these invariants" is reasonable shorthand but overstates the result; the
searched rule class was deliberately restricted (round(AI+B), field norm/
trace, simple linear combinations of at most two invariants, exact integers
already in hand -- see STAGE3_SCORING_CRITERION.md). The defensible
statement is narrower and is the one that stands:

**No natural selector within the pre-registered low-complexity function
class recovered the target indices from the frozen invariant set.**

This is the valid, anticipated negative outcome the protocol was built to
allow -- not a failure of the experiment, a real result of it. Commit
`070e62d` (the unblinding record) is a milestone, not something to revise.

**Dataset erratum, corrected separately, frozen packet left untouched:**
the sealed packet's claim "tr_b=tr_a+1 exactly, in every state" is an
overgeneralization (true only for epsilon=+1; for epsilon=-1 the correct
relation is tr_b=1-tr_a, since tr_b does not flip with epsilon while tr_a
does). `stage3_blind_states.json` (commit 29c3c08) is NOT edited -- it
remains the historical experimental input exactly as both blind sessions
received it. The correction is recorded in `STAGE3_DATASET_ERRATA.md`, and
`reproduce/stage3_enrich_state_invariants.sage` and its regenerated CSV/JSON
now document the correct relation for any future dataset built from this
construction.

**Project state as of this result:**
- Stages 1-3A: retained independently of this test, subject to their
  existing proof/status classifications (entries 15 [Proved], 17 [Proved],
  18 [Structural]) -- unaffected by Stage 3's outcome.
- Stage 3 prospective selector test #1: NEGATIVE.
- Specific mechanisms eliminated (not merely untested): the frozen norm/
  trace of tr_a, the peripheral-trace-derived values, the simple trace
  difference tr_b-tr_a, and the degree-normalized principal-argument
  candidate tested here.
- Mass-index selector: OPEN.
- Next legitimate experiment: introduce genuinely new, independently
  motivated geometry (candidates: non-peripheral holonomy words beyond a/b,
  complex lengths/eigenvalues of geometrically distinguished elements,
  representation characters beyond tr_a/tr_b, exact arithmetic attached to
  the filling representation) -- criterion for adding any such invariant is
  geometric motivation established BEFORE checking whether it improves the
  mass-index match, not after. Do not launch an unconstrained search over
  increasingly elaborate functions of the same five invariants already
  ruled out here -- that would turn this clean negative result back into
  exactly the pattern-hunt the blind protocol was built to prevent.

## Aug 23 2026 — Stage 3 first attempt: INCONCLUSIVE (blinding problem + thin table)

**Built the six-state invariant table** (`reproduce/stage3_build_state_invariants.sage`,
relayed script, three real Sage-API bugs fixed here -- `CC(alpha)` fails on elements of
the degree-6 closure field without an explicit embedding, `K.trace/norm(t)` should be
`t.trace()/t.norm()`, and a leaked Sage Integer broke JSON serialization; all mechanical,
no logic errors). Output cross-checked against SnapPy independently: the "upper"
embedding matches the real cusp shape to 1.18e-16, consistent with every prior check
this session. Frozen output: `reproduce/stage3_state_invariants.csv/json`, no target
indices anywhere (verified by reading the whole script).

**Attempted to find F, concluded INCONCLUSIVE rather than propose a candidate, for two
compounding reasons, both real:**

1. **A genuine blinding problem, not a technicality.** The agent (Claude) attempting to
   choose F already held the target list {12,18,43,65,75,106} in its working context
   from earlier in the same conversation. Pre-registration only has force if the process
   choosing F hasn't seen the targets -- that was not true here. A live example surfaced
   during exploration: 59*|root^2| (59 = the field's own discriminant, not externally
   fit) is approximately 12.13 for one state, near the first target -- flagged explicitly
   as an example of the exact failure mode (a large-enough unconscious exploration will
   eventually produce a near-hit by chance), not presented as a finding.
2. **The current invariant table is thinner than it looks.** Beyond the bare root value
   and epsilon, every other column (abs, arg, root^2, root^3) is a deterministic recoding
   of the same one complex number -- no new independent information. Reaching the
   12-106 target range from an O(1)-magnitude root requires an externally chosen scale,
   and any scale chosen after seeing the targets is unfalsifiable regardless of
   justification offered for it.

**Resolution (user's explicit choice, offered three options, this one selected):** report
this round as inconclusive rather than propose any F. No candidate rule is recorded as a
Stage 3 result. Entries 15/17/18 (the six-state geometry itself) stand independent of
whether Stage 3 ever succeeds -- exactly as the pre-registration below anticipated.

**For any future Stage 3 attempt:** the blinding problem is structural, not fixable by
being more careful -- it requires either a genuinely fresh context/session that has never
seen the target list, or a human selecting F with the frozen table only. Separately,
before that even matters, the invariant table itself likely needs new, independent
geometric content (e.g. trace of the filling-slope word s evaluated at each state, not
yet computed) rather than more recombinations of the bare root value.

## Aug 23 2026 — Stage 3 pre-registered success criterion (LOCKED BEFORE ANY ATTEMPT)

**Context:** Stages 1 (entry 15/companion Frobenius result), 2 (entry 17, [Proved]),
and 3A (entry 18, [Structural]) together assemble a genuine 6-element geometric
state space S_geom = C2 x G/H (2x3=6) from independent ingredients -- none of them
derived from, or tuned against, "there are six quarks." The cardinality-six
structure is upstream of the data, which is the whole point: it removes the
weakest part of the earlier geometry-only mass-index selectors (entry 16's
lepton selector carried an explicit look-elsewhere caveat for exactly this
reason -- free choice of which invariants/coefficients to combine).

**Stage 3, the only remaining untouched link, is now posed as a strict,
falsifiable test -- recorded here BEFORE any attempt, so this criterion cannot
later be accused of being fitted to the answer:**

Derive a mass-blind function Q: S_geom -> Z, |S_geom|=6, using a SINGLE fixed
rule F applied uniformly to all six states:

    Q(s_i) = F(I_1(s_i), I_2(s_i), ...)

where I_1, I_2, ... are geometric/arithmetic invariants already attached to each
state by Stages 1-3A (e.g. trace, complex length, twist, peripheral exponent
data, reduction/Frobenius data, spin sign, canonical word/holonomy
representative) -- NOT the target integers themselves. Success criteria, fixed
now, before comparison:

  - F is the SAME rule for all six states -- no per-state constants.
  - The observed quark masses/indices {12,18,43,65,75,106} play NO role in
    choosing F -- no search over formulas that already contain those numbers.
  - No permutation of outputs-to-quarks is chosen after seeing which output is
    closest to which target. The map S_geom -> quarks (if one is even needed
    beyond Q's own value) must be fixed before comparison too, e.g. by the
    same geometric labeling already used in Stages 1-3A.

**Only after F is frozen** do we compare Q's six outputs against
{12,18,43,65,75,106}. If it succeeds, the mass mechanism's status changes
substantially. If it fails, the six-state geometry (entries 15/17/18) stands on
its own as a real structural result regardless -- it does not depend on Stage 3
succeeding.

**Not yet attempted.** This entry exists solely to lock the criterion in before
any search begins.

## Aug 22 2026 — Mass-lattice mechanism check, Substack visuals, m006 root-labeled selector, Q-001

**Q-001 (Fricke-collapse identity, m006 character variety):** dug into the actual logs
rather than trusting the stale top-level checkpoint. Real progress confirmed: dim(I)=0
(modstd, ~5.7h), (z-x) fails on the full ideal (reduces to -x+z, not 0) so the identity
can only hold on the single geometric component. Two brute-force `variety()` enumeration
attempts both died from memory exhaustion, not logic. The smart targeted approach
(isolate the geometric component via `elimination_ideal([y,z])`, factor, match the known
root, test membership on the restricted ideal) is already scripted and was already
launched twice — both times dying silently at the `elimination_ideal` call itself, no
process left running. Wrote up the precise obstruction and a candidate faster alternative
(multiplication-matrix minimal polynomial, since dim=0 makes the quotient ring finite-
dimensional) for the GPT relay to weigh in on — same pattern that resolved entry 15's
four-way closure. No further action taken pending that response.

**Stage 1 canonical prime-lift test — PASSED** (`reproduce/hfg_stage1_canonical_prime_lift.sage`,
relayed script, one Sage-API bug fixed here — `ring_of_integers()` order objects lack
`.factor()` in this Sage version, fixed by using `K.ideal(...)`/`L.ideal(...)` directly —
then independently rerun): for all six tested tower primes (11, 31, 61, 101, 151, 211,
all transposition-type in the m006 S3 closure), the residue-degree-1 prime q1 of K is
unique, stays prime (inert) in L/K, and its decomposition group D(P) computed directly
as an ideal stabilizer in G=Gal(L/Q) equals exactly H=Gal(L/K)={e,h}, order 2 — real
ideal arithmetic, no masses, no root-ordering choices. This DOES strengthen "Frobenius
canonical only up to conjugacy" to "Frobenius is exactly h, once K subset L is fixed" —
a genuine result. But it also forces a NO-GO: since |H|=2 has only one nontrivial
element, every transposition-type prime necessarily selects the SAME h, so this datum
alone cannot distinguish six quark slots. This looks like a general theorem (the group-
theoretic argument sketched through it holds for any transposition acting on 3 cosets,
not just these 6 primes) but has only been verified computationally on 6 cases here, not
proved abstractly — tag as [Computed], not [Proved], until that gap is closed. Stage 2
target (per the script's own next-step note): test whether m006's holonomy/peripheral
geometry canonically distinguishes the three conjugate cubic subfields (cosets G/H),
which combined with h would give 2×3=6 slots. Not yet added to CLAIMS_REGISTER.md —
flagging as a candidate entry pending the user's call, since it's a stronger result than
anything else in this section but the abstract proof isn't done.

**Stage 2 oriented G/H coset selector — PASSED, now CLAIMS_REGISTER entry 17.** Tested
whether the oriented holonomy's selected embedding of m006's cusp field survives
peripheral-basis changes: it does, exactly, on all 7 tested SL(2,Z) bases (residuals
~1e-16), and orientation reversal swaps the two complex embeddings as predicted. Two
real bugs found and fixed en route (wrong Mobius-formula convention, caught by an
identity-matrix sanity check; an invalid direct-root comparison in the verdict logic,
which was exactly the mistake the original write-up warned against). Combined with
Stage 1's C2 result, this gives a genuine 6-element geometric state space — but mapping
those six states to the six actual quark mass indices (Stage 3) remains completely open
and was explicitly not attempted this session.

**Stage 2 promoted [Computed] -> [Proved]**, `reproduce/stage2_invariance_proof.md`:
the basis-change invariance follows immediately from field-embedding homomorphism
commutativity (no case-by-case checking needed, once alpha's embedding is fixed by
the geometry), and orientation reversal swapping sigma_+/sigma_- follows from the
standard fact that reversing orientation conjugates PSL(2,C) holonomy. Two relayed
Mobius-formula variants (both this session) failed the identity-matrix sanity check
before the correct one, tau'=(d*tau+c)/(b*tau+a), was empirically pinned down.

**Stage 3A -- RESOLVED NEGATIVELY, refined target identified (no mass indices
consulted).** The original question ("does the pair (h, gH) canonically reconstruct a
specific g in S3?") has a definite answer: NO, and it's a real two-fold ambiguity, not
a technicality. A coset gH={g,gh} has exactly two elements; knowing the fixed h alone
never says which one is g. Verified directly here by brute-force enumeration over S3
(not just re-derived symbolically): each of the 3 cosets does split into exactly one
even and one odd element (since h is a transposition, sgn(gh)=-sgn(g) always); "take
the odd element of each coset" reproduces exactly the 3 transpositions of S3, and the
map gH -> ghg^-1 is genuinely well-defined on cosets (confirmed computationally,
independent of representative) -- but both routes cap out at 3 outputs, not 6, because
Stage 1 as it stands only ever supplies h itself (never e) as the reference element.

The refined target: IF geometry could supply an independent binary parity/orientation
datum epsilon in {e,h} -- not the fixed Frobenius h from Stage 1, but a state genuinely
free to take either value -- then epsilon paired with the Stage-2 coset WOULD
canonically reconstruct a full g in S3 via g = the unique x in gH with sgn(x)=sgn(epsilon).
Verified directly: this parity-matching construction is an exact bijection H x G/H -> G
recovering all 6 elements (confirmed by direct enumeration). Still a canonical SET
bijection, not a group-quotient structure, since H is not normal in S3.

**Stage 3A, precise next question (not yet attempted):** can m006's geometry produce
that independent binary datum epsilon -- most naturally sought in the orientation/
chirality structure Stage 2 already exhibits (orientation reversal swaps the two
complex embeddings while fixing the real one) -- separately from, and not fixed equal
to, Stage 1's Frobenius h? This must be answered with no mass indices involved before
any attempt to connect the six geometric states to the six quark mass indices
(12, 18, 43, 65, 75, 106) -- that mapping is Stage 3, still untouched.

**Ideas, not yet screened** (a relayed GPT analysis proposed investigating whether the
four cusp-field discriminant primes {3,7,59,283} connect to the Lucas sequence that
already governs the programme's Eisenstein-norm mass encoding; both checks below were
run and independently reproduced here, not taken on the relay's word — not claims the
current programme makes, recorded here so they aren't lost, not in CLAIMS_REGISTER.md):

- **Discriminant primes vs. Lucas numbers**: 3 (K1, SU(2)_L factor) = L_2 and 7 (K3,
  SU(2)_R factor) = L_4 are genuine Lucas numbers; 59 (K4, S3/SU(3) factor) and 283 (K2,
  S4/Pati-Salam factor) are not. A clean 2-of-2/0-of-2 split along the abelian/non-abelian
  divide of entry 15's Galois factors — but n=4 is too small a sample and small Lucas
  numbers are dense enough among small primes that this is not strong evidence by itself.
  No null test has been run against how often 4 random small primes would show this same
  split by chance.
- **Mass-lattice mechanism test** (`reproduce/mass_lattice_mechanism_test.py`, copied from
  a relayed deliverable and independently rerun here — every number reproduced exactly):
  the φ^(q/4) charged-fermion lattice has RMS residual 0.0582 φ-units (marginal, consistent
  with the corpus's existing non-significant nulls); the naive Lucas matches
  L_11=199≈m_μ/m_e and L_17=3571≈m_τ/m_e are only 3.76%/2.70% accurate (NOT the "0.003%"/
  "essentially 0%" figures that appear in one stale internal note,
  `notes/GALOIS_WEYL_THEOREM_2026-06-17.md` — every actual paper already has the correct
  3.8%/2.7%, so no submission-facing document needs correcting); the tighter Eisenstein-norm
  matches (208 for μ/e at 0.594% error, 3477 for τ/e at 0.006% error) are search-aware
  null-sensitive — the τ/e match's significance flips across p≈0.05 depending on whether the
  null is uniform (p=0.061) or log-uniform (p=0.037) over the same search window, so it is
  not robust evidence of a mechanism on its own. Bottom line, matching the relay's own
  conclusion: log(φ) has a legitimate arithmetic-geometric origin (Alexander-polynomial
  Mahler measure M(Δ)=φ²), but nothing yet derives which integer q each fermion occupies —
  the lattice remains a phenomenological regularity, not a mass-generating mechanism.
- Substack visual series (parchment/green/tan house style, three formats each — SVG, TikZ,
  interactive HTML): all four modules now produced and verified — 1 (576-element Galois
  closure), 2 (ramification disjointness), 3 (Weyl-product correspondence), 4 (evidence
  ladder, entry 15 promoted to headline Proved, stale SU(2)_R Open item retired). Note:
  the already-published `docs/figures/shape_of_flavor_fig6_evidence_ladder.svg` still has
  the old, now-stale version of that ladder — not yet updated in the live article.
- **m006 root-labeled S3 selector test** (`reproduce/hfg_m006_root_labeled_selector.sage`,
  relayed script, independently rerun here via live Sage/SnapPy — not taken on the relay's
  word): m006's cusp cubic is exactly K4 from entry 15 (f(x)=x^3+2x+1, disc=-59, S3 Galois
  closure). Confirmed by hand and by computation: SnapPy's independently-computed oriented
  cusp shape matches the root r_+ = 0.226699+1.467712i to ~1e-16 (essentially exact),
  while the other two roots are O(1) away — a real, precise, verified numerical fact, not
  a coincidence. This gives a genuine geometry-selected ordered triple (sigma_+, sigma_R,
  sigma_-) and hence a real 6-element S3 "torsor" of embedding labels. BUT: rational-prime
  Frobenius elements are only canonical up to conjugacy class in S3 (standard Chebotarev
  fact) — turning that into ONE specific permutation requires choosing a prime P above p
  in the Galois closure, and nothing about the archimedean/orientation labeling supplies
  that choice. Also empirically confirmed a genuine subtlety flagged by the relay itself:
  SnapPy's `reverse_orientation()` does NOT simply conjugate the numeric cusp-shape
  coordinate (tau_rev != conj(tau); it negates the real part instead, consistent with
  cusp shapes being peripheral-basis-dependent coordinates rather than the invariant
  object, which is the abstract complex place). Net result: the archimedean root-labeling
  half of a six-quark-slot mechanism is real and verified; the arithmetic half (prime ->
  specific S3 element) remains open. Not promoted to CLAIMS_REGISTER.md — same treatment
  as the mass-lattice mechanism check above.

## Aug 20 2026 — Paper Audit

**Submission history — now fully confirmed from an actual editorialmanager.com/plb
"Completed - Reject" portal screenshot** (supersedes all earlier relayed/transcript-sourced
claims about this history, several of which did not check out):

| Manuscript | Title | Submitted | Rejected |
|---|---|---|---|
| PLB-D-26-01006 | Charge Conjugation as Orientation Reversal (Chirality) | 19 Apr 2026 | **still active, Under Review** — do not touch |
| PLB-D-26-01017 | Neutrino Masses from the Golden Ratio Lattice | 19 Apr 2026 | 19 Apr 2026 (same day) |
| PLB-D-26-01341 | CP Violation from Twist Angles (`gentry-cp-final.tex`) | 17 May 2026 | 20 May 2026 |
| PLB-D-26-01448 | Lepton Mixing from Borel Structure (PMNS) | 26 May 2026 | 09 Jun 2026 |
| PLB-D-26-01449 | Homology Class Asymmetry (Torsion) | 26 May 2026 | 09 Jun 2026 |
| PLB-D-26-01463 | Quark Mixing from Hyperbolic Geometry (CKM, 1st attempt) | 27 May 2026 | 09 Jun 2026 |
| PLB-D-26-01854 | Quark Mixing from Hyperbolic Geometry (CKM, 2nd attempt, same title) | 25 Jun 2026 | 26 Jun 2026 |

A separately relayed claim of an additional CMP→Geometriae Dedicata→Topology and its
Applications rejection chain for the torsion paper (specific manuscript ID 81e2ee6b, editor
name Dyatlov) could not be verified anywhere in the corpus or the portal and should be
treated as unconfirmed, not fact.

**Paper audit findings:**

- **Torsion** (`gentry-torsion-plb.tex`): confirmed rejected PLB-D-26-01449. MSC codes
  added, compiles clean. Free to resubmit — Geometriae Dedicata (original recommendation,
  no confirmed prior rejection there) or Topology and its Applications.
- **Lepton Mixing / PMNS** (`gentry-pmns-plb.tex`): confirmed rejected PLB-D-26-01448.
  MSC codes added, Chinburg bibkey bug fixed, compiles clean. Recommended venue: SciPost
  Physics.
- **CP Violation from Twist Angles** (`gentry-cp-final.tex`, already in
  `05_rejected_archived/`): confirmed rejected PLB-D-26-01341. Checked for redundancy
  against the PMNS paper: content (δ=195.91° CP-phase formula) is fully duplicated there.
  Do not resurrect as a standalone paper.
- **Twist Angle Spectrum** (`papers/hyperbolic-flavor-twist/gentry-hyperbolic-flavor-twist-npb.tex`
  — a different paper from Torsion above despite the similar folder name; self-declared as a
  Nuclear Physics B submission with its own manuscript IDs, not a PLB submission, so it does
  not appear in the table above). Full readthrough completed. Findings:
  - **No null-hypothesis test anywhere in the paper**, unlike every sibling paper (CKM/PMNS
    are null-tested against 50,000 Haar-random unitary matrices, p<0.002/p<10⁻⁴). This paper
    scans 484 words per manifold against 7 SM targets with a folding convention that doubles
    the comparison space (|φ| and 180°−|φ|) and reports "6 of 7 matched to <3%" with no
    measure of how likely that is by chance. This is the paper's central methodological gap.
  - **The δ_CKM=68.0° claim does NOT actually contradict the CKM paper's J_CKM=0 result** —
    resolved by reading the paper's own §3.5 ("The generator twist and CKM isospectrality"):
    δ_CKM here comes from a single word (`aa`), while J=0 in the CKM paper comes from the
    three-word triple `{aaB, AbA, AAb}` (all ≈92.49°, causing phase-cancellation). Different
    objects, not a contradiction — but the paper's own framing blurs this distinction and
    should be more explicit that `δ_CKM` is an independent single-word coincidence, not the
    matrix-derived phase.
  - **No Data Availability / reproducibility section at all** — every sibling paper checked
    this session (CKM, PMNS, torsion, dual-surgery) has one citing
    `github.com/drmlgentry/hyperbolic-flavor-scan`; this paper has none.
  - One genuinely good element: §5 ("Null Result: θ₁₃^CKM") is an honestly-labeled negative
    result with appropriate hedging ("this estimate is heuristic... requires explicit
    computation") — worth keeping in any revision.
  - The paper self-cites four companion PRD/NPB submissions with specific manuscript IDs
    (PRD: es2026mar11_966, es2026mar13_942, es2026mar14_722; NPB: NPB-S-26-00538/39/40,
    all "submitted March 2026") — not yet cross-checked against current status. Worth
    reconciling before any resubmission, since these are stated as "currently under review"
    inside the paper's own text and may now be stale.
  - **Recommendation: HOLD.** Needs a real null test, the word-choice clarification above,
    and a reproducibility section before resubmission — not ready regardless of venue.

**CKM v3 audit (`papers/04_new_needs_journal/gentry-ckm-v3.tex`), completed:** no "5 pending
upgrades" checklist could be found anywhere in the corpus despite searching — that framing
appears ungrounded, same pattern as several other unverified relayed claims this session.
Read the file directly and assessed independently instead. Findings: genuinely the most
rigorous paper in the portfolio — explicitly separates arithmetic selection from fitness
quality (reports its own manifold ranking 82nd of 134, below average, in its own comparison
class), has a real null test with a robustness re-check, and reports the live Q-001
computation status honestly as an open problem. Two concrete fixes needed: bibliography
cites SSRN 6775158 as "(2025)" when `CONFIRMED_abstracts.md` has it created May 2026; no
MSC classification. **Recommendation: ready to resubmit once those two are fixed** — this
supersedes the 4x-rejected `gentry-ckm-plb` lineage (PRD, RINP, PLB x2, all confirmed
rejected this session). Suggested venue: SciPost Physics, alongside the PMNS paper.

**Qubit gates audit (`papers/qubit-gates/gentry-qubit-gates-v2.tex`), completed:** the CS
level k=2 claim is still the blocking issue, but precisely characterized now — the algebraic
identity itself (Δ₄ = 3/2 = c_WZW(k=2)) is exact and provable; what's unproven is packaging
the *physical interpretation* (that this identifies the manifold's actual Chern-Simons level)
under the same "Proposition" label as the proven algebra. The paper's own §6.3 already states
the honest distinction — the fix is moving that separation earlier (split into a Lemma for
the identity + an explicit Conjecture for the physical claim), not inventing new hedges.
Two more issues found: bibliography cites PLB-D-26-01854 as a live reference, now confirmed
rejected 26 Jun 2026 this session; and its proof that J_CKM=0 (homology-class collision →
rank-deficient overlap matrix) uses a different mechanism than the CKM v3 paper's proof of
the same fact (any real-valued kernel construction forces J=0) — worth reconciling before
both go out, though not blocking either individually. **Recommendation**: fixable, not a
rewrite — npj Quantum Information is a reasonable venue once the k=2 claim is restructured.

**Holonomy-CP audit (`gentry-holonomy-cp-ahp.tex`), completed:** genuinely solid pure-math
paper — Theorem/Lemma/Proof throughout, no overclaiming found, no evidence-tag issues (this
is proof-based representation theory, not a numerical-fitting paper, so no null test applies
and the "no research data" Data Availability line is honestly correct, not a gap). The
abelianization-vs-π₁-conjugacy remark (§2, addressing why Θ*'s inversion action on
H₁=ℤ/5 doesn't contradict the fixed-conjugacy-class hypothesis) is a nice piece of honest
care that anticipates a real objection. Redundancy re-confirmed on full read: its only
worked example (Meyerhoff manifold, W_ρ(γ)=e^(2πi/5)) is illustrative, never fit against
PDG data, genuinely distinct from the PMNS paper's δ=195.91° result.

**Real bug found**: both self-citations (`Gentry:CKM`, `Gentry:PMNS`) are internally
garbled — each lists "Phys. Rev. D (2026)" *and* "Results in Physics (2026)" as the same
journal while citing a RINP-specific manuscript number (RINP-D-26-00327/00328), reading
like a template mismatch. Now also stale: both describe the companion papers as "submitted
March 2026" (i.e. pending) when we've confirmed this session both were rejected 14 May 2026.
No MSC codes present.

**Correction to a recurring conflation**: an instruction this session again described
PLB-D-26-01006 as this paper's live submission — same error already corrected two turns
earlier in this file. PLB-D-26-01006 is the Chirality paper (`gentry-chirality.tex`), a
different file with a different abstract. Holonomy-CP has **zero live submissions** — its
only confirmed history is the NPB-D-26-00449 rejection (20 Mar 2026), fully closed, free
to resubmit.

**Recommendation: REVISE, not hold** — citation cleanup + MSC codes, genuinely closer to
submission-ready than several other papers audited tonight.

**Qubit gates**: audit findings recorded as a scoped comment block at the top of
`gentry-qubit-gates-v2.tex` itself (Aug 20 2026) rather than only here, so a future session
finds the task pre-scoped without needing to re-read this report. Paper body not otherwise
edited.

---

## Aug 18 2026 — Session updates

**Resolved this session:**
- "The Shape of Flavor" popular article published: website (`docs/shape-of-flavor.html`,
  linked from `docs/index.html` nav + Popular Articles + Substack Dispatch list) and
  Substack (marvingentrynd.substack.com/p/the-shape-of-flavor). YouTube pin/description
  still pending on Marvin's end.
- Confirmed CLAIMS_REGISTER.md has zero uncommitted changes (a relayed claim from a
  separate session that it needed a commit was checked directly via `git status` and
  found false).
- Confirmed the "Aug 3 2026 American-spelling decision" (program not programme) claimed
  by a separate session's memory does not exist in any primary source (`CLAUDE.md` absent
  from both repo locations, `HFG_STATUS.md` has zero spelling mentions) and directly
  contradicts a real, already-published Substack URL slug
  (`the-hfg-programme-from-derivation`, Jun 9 2026). Treated as false; "programme" spelling
  is unchanged.

**New gaps found / partially resolved this session:**
- SU(2)_R factor of Pati-Salam: **first candidate found**, see CLAIMS_REGISTER.md entry
  14. m010 (vol 2.6667, cusp field ℚ(√−7)) is linearly disjoint from the m003/m019
  compositum; full closure with both is degree 96, group C₂×C₂×S₄ = Weyl(SU(2))² ×
  Weyl(SU(4)), independently re-verified twice. Tagged [Computed] for the group theory,
  [Conjecture] for any physical reading — not a resolution of the "still open" item below,
  a first candidate for it. `reproduce/su2r_candidate_search.py`.
- Linear disjointness of K_m003/K_m019 with K_m006 (the specific three-way item this
  report has carried since Aug 3): still not checked. What *was* resolved Aug 11 (entry
  13) is the simpler pairwise K_m003/K_m006 case only — degree-6 compositum, D₆ closure —
  a distinct, smaller question from the one this report names. Do not treat entry 13 as
  closing this item.

**Still open, carried forward:**
- SU(2)_R factor of Pati-Salam: candidate found (entry 14), not yet a derivation —
  the field-theoretic mechanism connecting any of these cusp fields to physical gauge
  groups is still entirely unaddressed
- Class S / 3D-3D field-theoretic derivation: proposed, not proved
- Linear disjointness of the full K_m003/K_m019 compositum with K_m006 (three-way,
  distinct from entry 13's pairwise check) — not yet checked
- Q-001 (primary decomposition, WSL/Sage) still running — PID 730 (changed since the
  Aug 6 entry's PID 703, restart tied to `HFG_Q001_ModStd_Watchdog` firing Aug 17 03:45,
  ~22.6 CPU-hours since), no new milestone since the last check
- Poincaré Disk Explorer: specced, not built — next session

**Ideas, not yet screened** (resurfaced from an earlier, superseded golden-ratio-lattice /
A₅ modular-symmetry thread via a DeepSeek relay; not claims the current programme makes,
recorded here so they aren't lost twice, not in CLAIMS_REGISTER.md):
- Z/5 stabilizer of the golden point τ₀ in A₅ vs. H₁(Meyerhoff) = Z/5 — both are cyclic of
  order 5, which is close to tautological (5 is prime, all order-5 groups are cyclic); not
  an independently verified correspondence.
- Whether the 2D A₅ modular geometry at τ₀ can be read as the conformal boundary of the
  Meyerhoff manifold's 3D hyperbolic geometry (a 3d-3d/DGG-style holographic proposal,
  cf. arXiv:1112.5179) — no mechanism established, not yet screened against current results.

---

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
