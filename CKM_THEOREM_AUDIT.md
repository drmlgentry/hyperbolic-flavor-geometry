# CKM manuscript theorem-status audit

Target: `papers/04_new_needs_journal/gentry-ckm-v3.tex` (997 lines, working
tree as of this audit — the file has an unrelated pre-existing uncommitted
diff, not from this session; audited against the current working-tree text).

Scope discipline, per instruction: **no manuscript edit in this pass.**
This document classifies claims; it does not rewrite them.

## How this audit was built

A relayed audit (GPT, working from the corpus without direct file access)
proposed a 42-item claim table. Rather than transcribe it, I read the
actual manuscript directly and independently checked the claims flagged as
flatly **INCORRECT** — those are sharp, checkable factual assertions, and
the highest-cost place to be wrong. Three are confirmed real; one place
the relayed audit understated how careful the paper already is. The
remaining items are proof-status/labeling judgments, which I formed from
reading the text myself rather than by re-deriving each one from scratch —
noted per-item below.

## Independently verified findings (not relayed — checked directly)

### 1. Internal numerical inconsistency: `12,288` vs `1,456` words — CONFIRMED, both by hand-derivation and by finding both numbers in the same document

The number of freely-reduced words of length 1–6 over 4 generators
$\{a,b,A,B\}$ (no immediate cancellation) is
$\sum_{n=1}^{6}4\cdot3^{n-1}=4(1+3+9+27+81+243)=4\cdot364=\mathbf{1456}$ —
derived directly, not looked up.

The manuscript uses **both** numbers, in different places, for what
appears to be the same combinatorial object:
- Line 481 (proof of Theorem `thm:quotient`): *"Computed by BFS over all
  freely-reduced words of length $\le6$ ($12{,}288$ words)..."*
- Line 672: *"Generate $N_w=1{,}456$ valid words (freely-reduced,
  length $\le6$)."*

`1,456` is the mathematically correct count; `12,288` is wrong (it's
$4^6$, i.e. counting all length-$\le6$ strings over 4 letters *without*
excluding immediate backtracking — a plausible off-by-a-wrong-formula
error). **The theorem's proof (line 481) uses the wrong number; a later
section of the same paper (line 672) uses the right one.** This needs
fixing regardless of what the true trace-class count turns out to be.

### 2. PMNS closed-manifold ITF misattribution — CONFIRMED by direct SnapPy computation

Lines 253–257 ("Geometric explanation of CP suppression"):
> *"the PMNS manifold $M_{PMNS}=m003(-2,3)$ has ITF $\mathbb Q(\sqrt{-3})$
> with signature $(0,1)$: all Archimedean places are complex, giving
> fully loxodromic holonomy and maximal CP violation."*

Computed directly (not trusted from either source):
```
M = snappy.Manifold('m003'); M.dehn_fill((-2,3))
invariant_trace_field_gens().find_field(300,20,True)
  -> Number Field x^4 - x - 1, discriminant = -283
```
independently cross-checked against `snappy.OrientableClosedCensus[1]`
(matching volume $0.981368828892232$ exactly, confirming it's the same
manifold). **The closed $M_{PMNS}$'s actual invariant trace field is
degree 4, discriminant $-283$ — not $\mathbb Q(\sqrt{-3})$.** $\mathbb
Q(\sqrt{-3})$ (disc $-3$) is the *cusped* m003's cusp field (correctly
used elsewhere in this same paper, line 308–309, for the Galois–Weyl
correspondence). The CP-suppression section conflates the cusped cusp
field with the closed manifold's own trace field — a real error, and it's
the field the whole subsection's "$(0,1)$ signature → maximal CP
violation" argument rests on. **This entire subsection needs rebuilding
on the correct field, or removing** — its conclusion isn't just weakly
supported, its input datum is wrong.

### 3. $p_2=31$ theorem's proof does not cover its own statement — CONFIRMED by reading the text

Theorem `thm:p31` (line 854+) states: *"Among all Farey tower primes
$p_k=5k(k+1)+1$, [the Frobenius-descent property holds] only at
$p_2=31$."* Its own proof note (line 867): *"Verified computationally for
all Farey tower primes $p\le281$."* An unbounded "among all" claim
proved only up to a finite checked bound is a real proof-statement/proof-
content mismatch, present in the manuscript as written. Needs either an
actual finiteness/uniqueness argument beyond the scan, or the theorem
statement rewritten as an explicit bounded verification.

### 4. Where the relayed audit understated the paper's own care: Q-001 in the abstract

The relayed audit's item 9 characterizes the abstract's Q-001 language as
flatly stale/superseded. Reading it directly (lines 57–66), it's more
careful than that already: *"a first rigorous result from that effort has
already excluded the strongest possible form of the claim... We report
this status honestly rather than as a completed theorem."* That's not
wrong, and isn't contradicted by the fuller resolution — it's just an
earlier checkpoint of the same investigation, correctly hedged at the time
it was written. The *substantive* problem is real (see next item), but
it's a **completeness** gap, not a false-statement one: the Remark this
points to (lines 396–431) describes the computation as **stalled**
("the process terminated without output after ~15 hours... a re-run is
planned"). Per this session's own earlier work (`q001_writeup_for_gpt.md`,
commit `e419cfa`, independently re-verified in this same conversation:
$N=440$, $\mathrm{rank}(q_{10}(M_x))=420 \Rightarrow \dim B=20$,
$\mathrm{rank}(M_{u,B})=10$, $M_{u,B}^2=0$ exactly), **that stalled
computation has since completed**, giving the exact result the relayed
audit describes ($u=z-x\ne0$, $u^2=0$, so $z-x\in\sqrt I_0\setminus I_0$
— a genuine square-zero nilpotent thickening, not just "excluded the
strongest form"). **Action: update the Remark and abstract to the
completed result — this is a real upgrade, correctly identified by the
relay, just mis-described as the paper being dishonest rather than
out of date.**

## Full claim register

Status column: **[Verified]** = independently checked in this pass
(above); **[Confirmed-in-text]** = I read the actual passage and the
relayed characterization matches it, but I did not independently re-derive
the underlying computation; **[Judgment]** = editorial/labeling call made
by reading the passage, not a checkable factual dispute.

| # | Claim (location) | Current label | Assessment | Confidence |
|---|---|---|---|---|
| 1 | $M_{CKM}=m006(-5,2)$, census idx 43, $H_1=\mathbb Z/5$, vol $2.0299\ldots$ | factual | Keep — direct invariants | [Confirmed-in-text] |
| 2 | Farey determinant $=11=L_5$ | factual | Keep as lemma; arithmetic identity is exact, physical reading is separate | [Judgment] |
| 3 | "$M_{CKM}$ is an arithmetic hyperbolic 3-manifold" | wording | No arithmeticity certificate (quaternion order, integrality) appears in this paper — signature data alone doesn't establish it. Remove or cite a certificate. | [Judgment] |
| 4 | Degree-10 ITF polynomial | Proposition | `algdep`-based recognition — label as certified recognition, not exact algebraic derivation, unless a certificate is added | [Confirmed-in-text] |
| 5 | ITF disc $-271488204251$, sig $(8,1)$, Gal $S_{10}$ | Proposition | Exact **given** the polynomial is accepted (pure Sage algebra from there); the unresolved step is the recognition itself (item 4) | [Judgment] |
| 6 | trace field = invariant trace field | proof text | Needs an explicit equality certificate or a downgrade to "both recognized the same polynomial" | [Judgment] |
| 7 | $\mathrm{tr}\rho(a)=-\alpha$ | Theorem | Same recognition-vs-derivation issue as #4 | [Judgment] |
| 8 | $\mathrm{tr}\rho(ab)=\mathrm{tr}\rho(a)$ / Q-001 | Observation, "still open" | **Upgrade** — see finding #4 above. Real dimension-20/square-zero result now exists and should replace the "still open" framing | [Verified — see above] |
| 9 | Q-001 "remains open" (abstract, intro) | repeated | Not false as worded (correctly hedged at time of writing), but stale relative to the now-completed result | [Verified — see above] |
| 10 | "Fricke codimension-1 collapse" as a plain identity | Observation | Reformulate using the actual $\sqrt I_0\setminus I_0$ structure once #8/#9 are updated | [Judgment, follows from #8] |
| 11 | "at most 122 distinct trace classes" | Theorem | Proof (line 481) is built on the wrong word count (`12,288` vs correct `1,456` — see finding #1). The class *count itself* (122) was not independently recomputed here — re-running `verify_trace.py` against the correct 1,456-word enumeration is the needed next step before trusting either 122 or any other number | [Verified: input count is wrong; **not verified**: whether 122 itself is consequently wrong] |
| 12 | $12{,}288$ freely-reduced words | proof | **Wrong.** Correct value is $1{,}456$ (hand-derived, and the paper's own line 672 already uses the correct number) | [Verified] |
| 13 | Trace-class count should be 66, not 122 | relayed claim | **Not independently verified in this pass** — would need rerunning the BFS/trace enumeration against the corrected word count. Do not assert 66 as fact until that's done | [Unverified — flagged, not confirmed] |
| 14 | Listed trace equalities (eqs. tc1–tc5) | Theorem | Mix of formal identities ($\mathrm{tr}(A)=\mathrm{tr}(A^{-1})$, always true) and representation-specific ones (need the numerical holonomy) — split these in any rewrite | [Judgment] |
| 15 | "finite 122-node graph rather than continuous word space" (discussion) | conclusion | The finiteness claim is trivially true for a bounded word search regardless of the exact node count; the specific "122" is downstream of finding #1/#11 | [Judgment] |
| 16 | Cusp field Gal $S_3\cong W(SU(3))$ | Theorem | Keep — group-theoretic content, correctly computed (cusp field $x^3+\ldots$, standard Galois-group computation) | [Confirmed-in-text] |
| 17 | "...identifying the geometric origin of the quark sector" (same theorem, abstract line 79–80, intro line 130) | same Theorem | Confirmed present verbatim. This is a physical-interpretation clause folded into a theorem statement — split it out, matching how the dual-surgery paper already handles the analogous claim | [Verified — read directly] |
| 18 | $m003$ cusp Gal $=C_2\cong W(SU(2))$ | Theorem | Same as #16 — keep the group fact, separate the physical reading | [Confirmed-in-text] |
| 19 | Closed $M_{PMNS}$ ITF $=\mathbb Q(\sqrt{-3})$ | CP subsection | **Wrong** — see finding #2 above | [Verified] |
| 20 | Signature $(8,1)$ $\Rightarrow$ "predominantly hyperbolic" holonomy | explanatory prose | Built on finding #2's wrong field for the *contrast* side; the "MacLachlan–Reid theorem" citation for the *forward* direction (real ITF $\Rightarrow$ predominantly hyperbolic elements) was not independently checked against the cited source in this pass | [Judgment / partially verified via #2] |
| 21 | Signature contrast "is the geometric origin of" CP asymmetry | conclusion | Depends on #19/#20; remove or move to an explicitly speculative/conjecture section | [Judgment, follows from #19] |
| 22 | 134/11,031 census, unique $(8,1)$ signature | Proposition | Keep as an exhaustive finite-census proposition (already correctly scoped in the text — "Among all 11,031... exactly 134... exactly one") | [Confirmed-in-text] |
| 23 | Criterion identifies $M_{CKM}$ "without fitting" | interpretive | True as a procedural claim if the criterion really was fixed before the fitness computation — provenance not independently re-traced in this pass | [Judgment] |
| 24 | K-factor "selected... not by optimisation" | subsection | The quoted twist statistics (mean $131.8°$, spread $66.3°$) are properties of the *already-optimized* triple, so calling the K-factor choice independent of the optimization is circular as currently argued | [Judgment] |
| 25 | Specific twist/spread/$F_K$ numbers | prose | Keep as measured properties of the selected triple; don't read them as a causal selection principle | [Judgment] |
| 26–27 | $\sigma=0.47$ "not fitted" / $\sigma=2/|H_1|$ structural prediction | Remark | The manuscript's own description (line 70–71: *"optimal from systematic sigma sweep"*) is a sweep-selected value: that's fitting, by the ordinary meaning of the word, regardless of whether it also happens to equal $2/|H_1|=0.4$ (close to but not equal to $0.47$ — worth checking directly whether the paper claims exact equality or just proximity; not resolved in this pass) | [Judgment, one sub-point unverified] |
| 28 | Optimal triple, $F=0.002728$ | Observation | Keep as "best found under the stated search"; do not call it a global optimum without an exhaustive-search certificate | [Judgment] |
| 29 | $H_1$ classes for the triple given as "(3,1),(2,2),(3,1)" | Observation | These read as exponent-count pairs, not $\mathbb Z/5$ classes. Under the certified map $h_{006}=2n_a+n_b\pmod5$ (this session, torsion investigation) they'd need recomputation — **not independently redone against this specific paper's word triple in this pass**, but worth checking given the certified classifier now exists | [Unverified — flagged] |
| 30 | $J=0$ theorem (real QR $\Rightarrow$ real orthogonal $\Rightarrow$ $J=0$) | Theorem | The stated mechanism is mathematically sound as a general fact (a real matrix has zero Jarlskog invariant, trivially) — this is probably the cleanest theorem in the paper as-is | [Judgment, but low-risk — elementary] |
| 31 | Nonzero physical $J$ "will arise from" higher-order corrections | discussion | Speculative; keep only as an open direction, not a "requires" claim | [Judgment] |
| 32–33 | Null test: $0/200$, wording "$p=0.005$... rules out search-expressiveness" | null section | Confirmed present verbatim (line 85, 148). $0/200$ successes gives a resolution floor of $1/200$ for THIS finite ensemble, not a rigorous population-level $p$-value; "rules out search-expressiveness" is broader than a 200-sample Monte Carlo test can support | [Verified — read directly, statistical point is standard] |
| 34 | Uniform-null robustness, "$\sim2.1\times$ worse" | prose | Keep if the script/log exists; label as a robustness computation | [Judgment, provenance not re-traced] |
| 35 | 82nd of 134, census refinement | census section | Confirmed present verbatim (line 87–90) and already correctly scoped as a negative/genericity result, not hidden | [Confirmed-in-text] |
| 36 | "Generic" fitness in $H_1=\mathbb Z/5$ class | Observation | Keep, scoped to this specific census and pipeline; "generic" should read as "common in these 134 cases" | [Judgment] |
| 37 | Torsion order "explains" fitness via $\sigma=2/|H_1|$ | Remark | Same proximity-vs-equality question as #26–27 | [Judgment, unverified sub-point] |
| 38 | Longer words "expected to improve" $\theta_{13}$ | discussion | Speculative wording; soften to "could be tested" | [Judgment] |
| 39 | $p_2=31$ "uniquely... among all Farey tower primes" | Theorem | **Proof scope does not cover the statement** — see finding #3 above | [Verified] |
| 40 | 31 "uniquely forces" the $8773$ component / $\varphi$ as mass-lattice base | same theorem | Physical/interpretive conclusion layered on #39; split out | [Judgment, follows from #39] |
| 41 | Degree-8 polynomial, signature $(0,4)$, open problem | — | Presented as open already; fine as-is | [Confirmed-in-text] |
| 42 | "Arithmetic selection and fitness are independent facts" (repeated) | methodological framing | This is the paper's best methodological instinct — keep, reword as "logically separate results" rather than implying statistical independence in the technical sense | [Judgment] |

## What should NOT be lost in a rewrite

The paper's own headline negative result — $M_{CKM}$ ranks 82nd of 134 in
raw fitness, explicitly reported rather than hidden, with the arithmetic
selection criterion presented as logically independent of fit quality —
is genuinely good scientific practice and is already correctly scoped in
the current text (items 22, 35, 42 above). Any rewrite should preserve
this, not soften it.

## Recommended immediate priorities (highest confidence first)

1. Fix the `12,288`/`1,456` inconsistency (finding #1) — cheap, unambiguous.
2. Replace the PMNS-ITF-based CP-suppression subsection (finding #2) — the
   input field is simply wrong; rebuild or remove.
3. Update the Q-001 remark to the completed dimension-20/square-zero
   result (finding #4) rather than the stalled-computation description.
4. Rescope Theorem `thm:p31` to match its actual (bounded) proof, or
   supply a real unboundedness argument (finding #3).
5. Re-run the trace-class enumeration against the corrected word count
   before asserting any specific number (122, 66, or otherwise) in a
   rewrite (item 11/13 — genuinely open, not resolved by this audit).
6. Separate physical-interpretation clauses from theorem statements
   throughout (items 17, 21, 40, and the abstract's own framing) —
   matching the pattern the dual-surgery paper already uses.

No manuscript file has been edited as part of this audit.
