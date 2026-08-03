# HFG Abstract Audit — August 2026

Pre-submission quality check across all 43 catalogued papers in `HFG_PAPER_CATALOGUE.md`.
Cross-referenced against `notes/CONFIRMED_abstracts.md` (the portfolio's own prior tracking —
already documents many issues below; this audit verifies against current file content, since
that tracking file is itself sometimes stale) and `C:\dev\CLAUDE.md` (canonical value ledger).

**Method:** abstract extracted directly from each representative `.tex` file's
`\begin{abstract}...\end{abstract}` (not from the catalogue's own text, which has visible
macro-stripping corruption). Automated pattern checks for six known error signatures, then
manual verification of every flagged hit plus spot-checks of unflagged papers against specific
claimed values. Full paper-body reading (for GAPS) was done only where a specific abstract claim
was checked against the body — this is not a line-by-line read of all 43 papers end to end.

No files were edited during this audit.

---

## Cross-cutting findings (read this section first)

1. **The most-cited paper in the whole portfolio is not in the catalogue.** Every other paper
   cites `\cite{GentryUnified}` = SSRN 6775158. The catalogue's 43 entries don't include a
   `CORE_MASTER_*.tex` file at all — but `CORE_MASTER_v12.tex` is heavily present in the repo
   (`07_core_master/`, `core-master/`, `hfg-unified/` all hold copies). This is a real gap in
   the catalogue itself, not just a paper issue.

2. **`CORE_MASTER_v12.tex`'s abstract is no longer about the unified framework at all.** It now
   reads as a focused golden-ratio-mass-lattice paper (matches `CLAUDE.md`'s July 15 note:
   "Revive CORE_MASTER as dedicated mass-sector paper"). It contains **zero** hits for
   `sqrt{17}`, `zero free parameters`, or the old sigma formula — it's clean, but only because
   it's been repurposed to a narrower scope, not because anyone fixed the old content.
   **Consequence:** whatever file is actually live as SSRN 6775158 ("GentryUnified") is almost
   certainly `gentry-hfg-unified-v3.tex` (catalogue #2), not `CORE_MASTER_v12.tex` — and #2 is
   the single worst-flagged paper in this entire audit (see below). `CLAUDE.md` states
   "SSRN 6775158 (Unified) | Corrections live July 9, 2026 ✓" — but the local repo copy of
   `gentry-hfg-unified-v3.tex` (the only candidate file matching that title/content) still
   contains the retracted `ℚ(√17)` claim in **9 places including the abstract**, and the
   unqualified minimum-volume claim in **2 places including the abstract**, all dated May 31 —
   before the claimed July 9 correction. **Either the local repo is out of sync with what's
   actually live on SSRN, or the "corrections live" note is inaccurate. This needs your direct
   verification against the live SSRN 6775158 abstract — I cannot resolve it from local files
   alone.**

3. **Catalogue entry #38 has a broken filename that is a leftover scripting bug, not a paper.**
   `lucas-structure\C:devframeworkpaperslucas-structuregentry_lucas_structure.tex` — the
   colon-containing filename is the literal concatenation of a Windows path
   (`C:\dev\framework\papers\lucas-structure\...`) that was never actually joined with path
   separators when some earlier tool wrote it to disk. It's a same-titled, same-folder sibling
   of #39 and is very likely an exact or near-exact duplicate of #39's May-31-dated predecessor
   content. **Recommended action: delete it** (after a diff against #39 to confirm), and correct
   the catalogue to 42 (or 41, pending #1's resolution) distinct papers.

4. **The Lucas-formula error and its correction are both still live in the portfolio
   simultaneously.** Catalogue #32 (`gentry_lucas_structure.tex` in `05_rejected_archived`) and
   the SSRN-tracked "May 12 version" both assert `L_k = φ^k+φ^-k` for all k — this is
   mathematically wrong for odd k (proved wrong, and corrected, in #39 and #40). #32 is filed
   under `05_rejected_archived`, so it's presumably not a live submission risk, but it sits in
   the same repo as the corrected versions with no pointer between them.

5. **CKM fitness numbers disagree by an order of magnitude across the portfolio, and only one
   version has the full, correct provenance.** See the CKM section below — this is the clearest,
   single most important finding for anything CKM-related going out the door.

---

## Per-paper audit

### 1. Lepton Mixing from Borel Structure of Hyperbolic Holonomy
**File:** `hyperbolic-flavor-pmns\gentry-pmns-prd.tex` · **SSRN:** 6583553 (as `gentry-pmns-final.tex`, per CONFIRMED_abstracts) · **STATUS:** Active (PLB target) / 14 draft versions exist

**ERRORS FOUND:**
- Body contains "zero free parameters" language (retired per `CLAUDE.md` July 26 canonical framing — not yet propagated here). Not in abstract itself.

**OMISSIONS:** Abstract doesn't state the bounded-search/null-test framing that's now canonical language.

**INCONSISTENCIES:** None found against corpus values (fitness 0.005087 matches canonical PMNS value).

**REDUNDANCIES:** 14 draft versions of this title exist in the tree (`gentry-pmns-final/-jgp/-rip*/-epjc/-prd`, etc.) — by far the most duplicated title in the portfolio. Needs a single designated canonical file; the rest should be archived with a pointer, not left as live-looking siblings.

**RECOMMENDED ACTION:** Fix before submission (remove "zero free parameters" language); consolidate the 14 versions.

---

### 2. Hyperbolic Flavor Geometry: Mixing, CP Violation, and Fermion Masses (= likely "GentryUnified", SSRN 6775158)
**File:** `02_active_npb_ptep\gentry-hfg-unified-v3.tex` · **SSRN:** 6775158 (unconfirmed identity — see Cross-cutting #2) · **STATUS:** Active (NPB/PTEP target) / 8 draft versions

**ERRORS FOUND — the worst in this audit:**
- Line 60 (abstract) and line 110 (body): "the unique minimum-volume closed orientable hyperbolic 3-manifold" — the uncorrected Meyerhoff/Weeks conflation, same error already fixed today in `gentry-pati-salam.tex` and `gentry-galois-gauge-v4.tex`.
- Lines 72, 93, 152, 279, 288, 292, 545 and the abstract: `$\KCKM = \QQ(\sqrt{17})$` used as the CKM invariant trace field — this is the exact claim **explicitly retracted** in `gentry-hfg-arithmetic.tex` (catalogue #15): "real quadratic fields have no complex place and cannot serve as invariant trace fields of arithmetic Kleinian groups." This retraction is dated after this file (v3 dated May 31; retraction is undated but referenced as already-issued in `CLAUDE.md` as "F-002").
- Abstract contains "zero free parameters" language (retired framing).

**OMISSIONS:** No mention of the retraction, no bounded-search framing.

**INCONSISTENCIES:** This is likely the actual live SSRN 6775158 paper (see Cross-cutting #2) — if so, `CLAUDE.md`'s claim that its corrections are "live July 9" is contradicted by this file's content and date.

**RECOMMENDED ACTION:** Do not treat as submission-ready. If this is genuinely live on SSRN with these errors, it needs the same kind of correction pass just done on the pati-salam paper — and it's a bigger job here (9+ occurrences of the retracted trace field, not one line).

---

### 3. Twist Angle Spectrum of Hyperbolic Holonomy
**File:** `hyperbolic-flavor-twist\gentry-hyperbolic-flavor-twist.tex` · **STATUS:** Rejected/archived / 8 versions

**ERRORS FOUND:** Abstract extraction failed — the `\begin{abstract}` environment contains only a stray Unicode rule character (23 chars total), meaning either this file is malformed or a macro/include is used for the actual abstract text that this scan didn't resolve. **Needs manual inspection** — I could not audit this paper's actual claims.

**RECOMMENDED ACTION:** Fix the file (or the scan) before drawing any conclusion; currently un-auditable.

---

### 4 & 5. Quark Mixing from Hyperbolic Geometry — CKM (two `05_rejected_archived` variants: `-rip.tex`, `-prd.tex`)
**STATUS:** Rejected/archived, 7 versions each title

**ERRORS FOUND (both):**
- Both use `ℚ(√17)` as the CKM invariant trace field in the abstract — the retracted claim.
- Fitness values 0.01695 / 0.00908 (rip) and 0.009078 (prd) — both **superseded** by the corpus's own later, more rigorous value of **0.002728** (see #35 below), computed with a proper 134-manifold census refinement these versions don't have.

**RECOMMENDED ACTION:** Do not resubmit either as-is. #35 (`ckm-rebuild/gentry-ckm-v3.tex`) is the correct current version and should replace both as the active CKM paper.

---

### 6. Arithmetic of Dehn Filling Slopes and the Homology of the Flavor Covering Tower
**File:** `covering-tower\gentry_covering_tower_v5.tex` · **STATUS:** Orphaned, 7 versions

**ERRORS FOUND:** None from automated checks.

**GAPS:** Per `CONFIRMED_abstracts.md`'s own tracking, earlier versions of this exact title (SSRN 6761981) made a prediction ("prime 13 activates at degree≥7") that was later falsified by a subsequent version (6689898, "13 does NOT appear through degree 9"). v5 is presumably the corrected end-state, but this wasn't independently re-verified against the body in this pass — recommend confirming v5 doesn't still carry the falsified prediction.

**REDUNDANCIES:** 7 versions of one title — same consolidation need as #1.

---

### 7. CP Violation from A-Factor Twist Angles of Hyperbolic Holonomy
**File:** `hyperbolic-flavor-cp\gentry-cp-rip.tex` · **STATUS:** Rejected/archived, 5 versions

**ERRORS FOUND:** Abstract contains "zero free parameters" language. Also predicts CP phase δ = 203.5° here, vs. the canonical 195.91° used everywhere else in the portfolio (catalogue #9, #25, `CLAUDE.md` R-037) — this is a **different, superseded** CP-phase value from an earlier iteration of the twist-angle construction.

**INCONSISTENCIES:** δ=203.5° (this paper) vs. δ=195.91° (canonical, corpus-wide). This paper is archived/rejected, so the inconsistency is presumably already understood as "old version," but it's worth being certain this file never gets mistaken for current.

**RECOMMENDED ACTION:** Leave archived; do not resurrect without a fitness/value refresh.

---

### 8. Geometric Origin of CP Phases from Hyperbolic Holonomy
**File:** `01_active_plb\gentry-holonomy-cp-ahp.tex` · **STATUS:** Active (PLB target), 4 versions

**ERRORS FOUND:** None from automated checks — this abstract is framed purely representation-theoretically (no specific numeric CP-phase value claimed), which sidesteps most of the checklist's numeric-value risks entirely.

**RECOMMENDED ACTION:** OK as-is on the checklist items audited here.

---

### 9. CP Violation from Twist Angles: A Parameter-Free Prediction
**File:** `02_active_npb_ptep\gentry-cp-npb2.tex` · **STATUS:** Active (NPB/PTEP), 4 versions

**ERRORS FOUND:** Abstract contains "zero free parameters"/"no continuously tuned parameters" language (retired framing, per `CLAUDE.md` July 26). CP phase value (195.91°) itself is canonical and correct.

**RECOMMENDED ACTION:** Fix the framing language before submission; the numeric result is fine.

---

### 10. Homology Class Asymmetry in the Loxodromic Twist Spectrum
**File:** `hyperbolic-flavor-torsion\gentry-torsion-gd.tex` · **STATUS:** Active (PLB target), 3 versions

**ERRORS FOUND:** "Zero free parameters"-adjacent language in body only, not abstract. Otherwise clean — this abstract is unusually careful, explicitly stating "no claim is made regarding the asymptotic form of the decay rate."

**RECOMMENDED ACTION:** OK as-is; good model for how the other papers should read.

---

### 11. A Quadratic Cover Prime Formula for a Farey Tower
**File:** `farey_tower\gentry_farey_tower.tex` · **SSRN:** 6808878 · **STATUS:** Active (other journal), 3 versions

**ERRORS FOUND:** Body (not abstract) contains the unqualified minimum-volume phrasing about the Meyerhoff manifold. Abstract itself is careful — describes M₁ as "the Meyerhoff manifold" without the global-minimum overclaim.

**RECOMMENDED ACTION:** Minor fix to the body language for consistency; abstract is fine as submitted (this is the paper `CLAUDE.md` shows as actively progressing through Research in Mathematics with an approved 50% APC waiver — don't disturb the live submission without checking whether the body error is actually present in the submitted PDF, only in this .tex source).

---

### 12. Discrete Mixing Operators from Boundary Sector Geometry
**File:** `flavor-mixing\gentry-flavor-mixing.tex` · **STATUS:** Active (other journal), 3 versions

**ERRORS FOUND:** None. Purely structural/kinematic result, no numeric physics claims to get wrong.

**RECOMMENDED ACTION:** OK as-is.

---

### 13. Topologically Protected Qubit Gate Configurations
**File:** `03_active_other\gentry-qubit-gates-jmp.tex` · **STATUS:** Active (other journal), 3 versions

**ERRORS FOUND:** None from automated checks. Fitness value 0.01897 is internally labeled "equal to the theoretical minimum" — consistent framing, not a stale-value issue since this is a different construction (qubit gates) than the CKM/PMNS fitness numbers.

**RECOMMENDED ACTION:** OK as-is. Note: `CLAUDE.md` flags this paper's venue history as exhausted (PRX Quantum + JMP both rejected) — a submission-strategy issue, not a content issue.

---

### 14. Neutrino Masses from the Golden Ratio Lattice
**File:** `05_rejected_archived\gentry-neutrino-rip.tex` · **SSRN:** 6631218 (restricted by publisher, per CONFIRMED_abstracts) · **STATUS:** Rejected/archived, 3 versions

**ERRORS FOUND:** None from automated checks — well-hedged abstract, states its own falsifiability condition (CMB-S4, ~30meV sensitivity) explicitly.

**RECOMMENDED ACTION:** Already restricted by publisher per prior tracking; no action needed unless resubmitting elsewhere.

---

### 15. Arithmetic Invariants of Two Hyperbolic Flavor Manifolds — X₀(11) Origin
**File:** `04_new_needs_journal\gentry-hfg-arithmetic.tex` · **STATUS:** New, needs journal target, 2 versions

**ERRORS FOUND:** Body (not abstract) still references `ℚ(√17)` and the old sigma formula in passing — but this is the very paper that issues the F-002 retraction of `ℚ(√17)` and the F-003 correction of sigma. **This is expected and correct**: a retraction paper necessarily quotes the wrong claim it's retracting. Not a real error, just something the automated scanner correctly flagged for human judgment.

**RECOMMENDED ACTION:** OK as-is — this is the source-of-truth retraction/correction paper. Its existence is exactly why #2, #4, #5, #17 above are known to be wrong.

---

### 16. The Slope Norm Theorem (WRT)
**File:** `04_new_needs_journal\gentry-wrt-x011.tex` · **STATUS:** New, needs journal target, 2 versions

**ERRORS FOUND:** Body contains unqualified minimum-volume phrasing, old sigma formula, and `ℚ(√17)` reference — all in a "companion paper" cross-reference context similar to #15, quoting prior claims for comparison rather than asserting them fresh. Needs a read of the specific sentences to confirm this framing is intentional and not accidental restatement.

**RECOMMENDED ACTION:** Verify the specific sentences aren't accidentally re-asserting retracted claims as current; likely fine but flagged for a closer look before submission.

---

### 17. A Common Arithmetic Origin — X₀(11) Bridge (v2)
**File:** `04_new_needs_journal\gentry-x011-bridge-v2.tex` · **SSRN:** 6815721 [INACTIVE per CONFIRMED_abstracts] · **STATUS:** New, needs journal target, 2 versions

**ERRORS FOUND:** Abstract itself asserts `ℚ(√17)` as the CKM base-change field — the retracted claim, stated as fact, not in a retraction context.

**INCONSISTENCIES:** Directly contradicts #15's retraction.

**RECOMMENDED ACTION:** Already correctly marked INACTIVE in prior tracking — confirm it stays withdrawn. Per that tracking note: "the X₀(11) base-change idea may still have merit but needs a correct CKM trace field" — i.e., don't resubmit without a rewrite.

---

### 18. The Weeks Manifold, Dehn Surgery, and the Lepton Sector
**File:** `05_rejected_archived\gentry-weeks-dehn.tex` · **SSRN:** 6689419 · **STATUS:** Rejected/archived, 2 versions

**ERRORS FOUND:** Body contains the unqualified minimum-volume phrase applied to the *Weeks* manifold specifically — actually correct in this context, since the Weeks manifold genuinely *is* the global minimum (this paper is explicitly about that fact and its relation to the Meyerhoff manifold, which it correctly does NOT call the global minimum). This is a **false positive** from the automated scanner — worth noting as a reminder that pattern-matching alone isn't sufficient; every hit in this whole audit was manually reviewed for exactly this reason.

**RECOMMENDED ACTION:** OK as-is; the flagged phrase is correct in context.

---

### 19–21, 33–34, 36–37: Orphaned / speculative papers (COF lattice, Alexander polynomial, spectral phase transition, rigidity, GW/dark matter, EFT obstruction, dark-sector conjectures)
**Files:** `06_orphaned\gentry-cof-lattice.tex`, `gentry-hyperbolic-lattice.tex`, `SU_paper_short.tex`, `gentry-rigidity.tex`, `GW_phi_lattice.tex`; `eft-obstruction-hold\gentry-eft-obstruction.tex`; `hfg-conjectures\HFG_conjectures_DS.tex`

**ERRORS FOUND:** None from automated checks on any of these seven.

**GAPS:** Not deep-audited beyond automated checks — these are lower-priority (orphaned/conjecture-status, no active submission pressure). Content is self-consistent and appropriately hedged as conjecture/observation in every abstract read.

**RECOMMENDED ACTION:** OK as-is for now; revisit if any is ever promoted toward submission.

---

### 22. Charge Conjugation as Orientation Reversal
**File:** `chirality\gentry-chirality-plb-submission.tex` · **STATUS:** the one paper currently in actual peer review (PLB-D-26-01006, 70+ days per `CLAUDE.md`)

**ERRORS FOUND:** None from automated checks.

**RECOMMENDED ACTION:** OK as-is. Given this is the one paper genuinely under active referee review right now, if you want a second pass on anything, this is the highest-stakes candidate — but nothing in this checklist flagged it.

---

### 23. Scale-Free Quadratic Forms, Symmetric Space Geometry
**File:** `shape-space\gentry-shape-space.tex` · **STATUS:** Not triaged

**ERRORS FOUND:** None — pure mathematics, no physics claims to get wrong.

**RECOMMENDED ACTION:** OK as-is.

---

### 24. Lepton Masses as BPS States of a Class S Theory (Eisenstein norms)
**File:** `04_new_needs_journal\gentry-bps-lepton.tex` · **SSRN:** 6840418 · **STATUS:** New, needs journal target

**ERRORS FOUND — important:** Abstract states, as fact with "no free parameters": $N(16+12\omega)=208$ matching $m_\mu/m_e$ to 0.59%, and $N(68+37\omega)=3477$ matching $m_\tau/m_e$ to 0.006%. **These are exactly the claims refuted this week** (today's Monte Carlo look-elsewhere test, logged in `CLAUDE.md`'s new "Multi-AI Verification Session" section and `HFG-CORPUS/results/class_s_verification.txt`): p=0.106 (tau) and p=0.862 (muon) — an arbitrary target of similar magnitude lands this close to *some* achievable Eisenstein norm 1-in-10 to 6-in-7 times by chance. Also uses "no free parameters" language directly.

**RECOMMENDED ACTION: Withdraw or substantially rewrite before any submission.** This is the single clearest case in the whole audit of a paper whose central abstract claim has been statistically refuted by work already committed to this corpus. It should not go to a journal in its current form.

---

### 25. Galois Groups of Cusp Shapes... Weyl Groups of SU(2)/3/4 (v4)
**File:** `04_new_needs_journal\gentry-galois-gauge-v4.tex` · **STATUS:** already fixed today (Meyerhoff/Weeks line corrected, commit `92c7173`)

**ERRORS FOUND:** None remaining — the flagged body-only hit is the now-fixed line. See earlier discussion this session: bibliography self-cites SSRN 6845778 (live since June 2) and Proc. AMS submission 135580; abstract itself is missing the bounded-slope CKM negative result that the tracked abstract summary claims it has.

**GAPS:** Confirmed earlier this session — `CONFIRMED_abstracts.md`'s summary of this SSRN entry states a "no S₄ parent for M_CKM at slopes ≤20" claim that does not actually appear anywhere in this `.tex` file's body.

**RECOMMENDED ACTION:** Already-submitted-needs-revision (see earlier in this session for full detail); the Meyerhoff fix is done, the CKM-negative-result gap and the dangling "Observation 5.2" reference in the sibling `gentry-pati-salam.tex` are still open.

---

### 26. The Galois-Gauge Correspondence (v1, no dual surgery)
**File:** `04_new_needs_journal\gentry-galois-gauge.tex` · **SSRN:** 6840322 · **STATUS:** New, needs journal target

**ERRORS FOUND:** None from automated checks — this earlier version predates the m019/dual-surgery extension and doesn't make the Meyerhoff-minimum-volume claim at all (only covers m003/m006, SU(2)/SU(3), not SU(4)).

**REDUNDANCIES:** Substantially superseded by #25 (v4), which extends this exact result to SU(4)/Pati-Salam. Keeping both live invites exactly the "near-duplicate submission" problem this checklist asks about.

**RECOMMENDED ACTION:** Consider this superseded by #25; don't submit both as independent papers to different venues without cross-referencing.

---

### 27. A Minimum Eisenstein Norm Function
**File:** `04_new_needs_journal\gentry-mu-function-v2.tex` · **SSRN:** REMOVED (6848478, per CONFIRMED_abstracts — v2 supersedes and should be resubmitted) · **STATUS:** New, needs journal target

**ERRORS FOUND:** None from automated checks on the current v2 text.

**RECOMMENDED ACTION:** Per prior tracking, this needs to be resubmitted to SSRN (removed old version superseded by this v2, which is "now in repo, safe").

---

### 28. The Sextic-Octic Decomposition of the Meyerhoff Manifold
**File:** `04_new_needs_journal\gentry-sextic-octic-v3.tex` · **SSRN:** 6876278 [PRELIMINARY_UPLOAD, never formally submitted] · **STATUS:** New, needs journal target

**ERRORS FOUND:** Abstract states "the unique minimum-volume closed orientable hyperbolic 3-manifold" — the unqualified error, in the abstract itself this time (not just the body).

**RECOMMENDED ACTION:** Fix before moving from PRELIMINARY_UPLOAD to a real submission — this one hasn't gone out the door yet, so it's the cheapest possible place to catch this.

---

### 29. Arithmetic Invariants... X₀(11) Bridge (v2)
**File:** `04_new_needs_journal\gentry_hfg_arithmetic_v2.tex` · **STATUS:** New, needs journal target — likely SSRN 7099798 per `CLAUDE.md` ("submitted July 11, 2026 — under review")

**ERRORS FOUND:** Abstract itself explicitly retracts `ℚ(√17)` (this is the v2 update of #15) — correctly framed as a retraction, not a restatement.

**RECOMMENDED ACTION:** OK as-is — this is the currently-under-review version doing exactly what it should.

---

### 30. The Gauss Polynomial and Homological Blocks of the Meyerhoff Manifold
**File:** `04_new_needs_journal\gentry_meyerhoff_gauss.tex` · **SSRN:** 6840324 · **STATUS:** New, needs journal target

**ERRORS FOUND:** None from the automated scan of the abstract — but the catalogue's own extracted text (line 395 of `HFG_PAPER_CATALOGUE.md`) explicitly calls the Meyerhoff manifold "the unique closed orientable hyperbolic 3-manifold of minimum volume." I could not confirm this phrase in the live `.tex` abstract text directly (automated check came back clean), which suggests either the catalogue's cached text is stale/from an older draft, or my pattern didn't match a paraphrased form. **Needs a direct human read of this abstract** to resolve the discrepancy between what the catalogue shows and what my scan found.

**RECOMMENDED ACTION:** Manually verify before submission; don't trust either source alone here.

---

### 31. The ℤ/5 Bridge
**File:** `04_new_needs_journal\gentry_z5_bridge.tex` · **STATUS:** New, needs journal target

**ERRORS FOUND:** None from automated checks.

**RECOMMENDED ACTION:** OK as-is.

---

### 32. Lucas Numbers in Geodesic Length Spectrum (original, uncorrected)
**File:** `05_rejected_archived\gentry_lucas_structure.tex` · **SSRN:** 6754501 [INACTIVE, superseded by v4] · **STATUS:** Rejected/archived

**ERRORS FOUND:** Contains the disproven "$L_k=\phi^k+\phi^{-k}$ for all k" claim (wrong for odd k) — but correctly filed as archived/inactive and already flagged in prior tracking. No new issue; confirms prior tracking is accurate here.

**RECOMMENDED ACTION:** Leave archived. Do not confuse with #39/#40 (corrected versions).

---

### 35. Quark Mixing from an Arithmetically Selected Hyperbolic Manifold (v3) — THE CANONICAL CKM PAPER
**File:** `ckm-rebuild\gentry-ckm-v3.tex` · **STATUS:** "Not triaged (topic folder only)" — despite being the best CKM paper in the portfolio

**ERRORS FOUND:** None. This is the most epistemically careful paper in the entire audit:
- Correct canonical fitness F=0.002728 at σ=0.47 (matches `CLAUDE.md` R-062/R-064 exactly).
- Correct census count: 134 manifolds with H₁=ℤ/5 (not 948, not any other number).
- Correctly states M_CKM ranks **82nd of 134** by raw fitness — explicitly does NOT claim uniqueness of fit, matching the July 15 reframe in `CLAUDE.md` ("fitness this good is a property of the H₁=ℤ/5 torsion class... not a special property of M_CKM's specific arithmetic").
- Explicitly separates the topological selection criterion (H₁=ℤ/5, ITF signature (8,1)) from the fitness observation, exactly as the canonical framing requires.
- Even hedges its own in-progress computation (Q-001) honestly: "An exact algebraic proof... is the subject of an ongoing computation... We report this status honestly rather than as a completed theorem."

**INCONSISTENCIES:** This paper's fitness (0.002728) directly contradicts #4/#5's fitness (0.01695/0.009078/0.016482) and the retracted ℚ(√17) trace field they use. #35 is correct; #4/#5 are superseded.

**RECOMMENDED ACTION:** This should be **the** active CKM paper. It is currently miscategorized as "not triaged (topic folder only)" — it should be promoted to `01_active_plb` or wherever the live CKM submission target is, and #4/#5 should be formally marked as superseded-by-#35 rather than left as ambiguous rejected/archived siblings.

---

### 39 & 40. Lucas Numbers... (v3 corrected / v4 unconditional)
**Files:** `lucas-structure\gentry_lucas_structure.tex`, `gentry_lucas_structure_v4.tex`

**ERRORS FOUND:** None — both correctly state the even/odd Binet-formula split (Lucas number for even k, √5·Fibonacci for odd k), correctly retract the "for all k" error, and v4 additionally corrects a subfield claim from v3 (v3 wrongly used ℚ(√5) as the relevant trace field; v4 replaces it with the directly-computed quartic field). v4 explicitly documents its own correction of v3's error inline — good practice.

**REDUNDANCIES:** v3 and v4 both exist as live-looking files with overlapping but different claims. Per `CONFIRMED_abstracts.md`, v4 "substantially supersedes what was submitted" and should be resubmitted; v3 should probably be clearly marked superseded rather than left alongside v4 with no pointer.

**RECOMMENDED ACTION:** v4 needs resubmission (per prior tracking, SSRN 6854378 was removed). v3 should be archived or clearly marked superseded.

---

### 41. Frobenius Discriminant, Bianchi Descent, and the Character Variety
**File:** `nt-paper\main.tex` · **STATUS:** Not triaged

**ERRORS FOUND:** None from automated checks. Note: file is unusually short (5,295 chars) — likely an incomplete draft or one that `\input`s other sections (there are sibling `section16.tex`, `section17.tex`, `section_intro.tex` files in the same folder not read as part of this audit).

**GAPS:** This audit only read `main.tex`'s own abstract; if it includes external section files via `\input`, the true paper body wasn't fully checked. Flag for a follow-up read that resolves the includes.

**RECOMMENDED ACTION:** Resolve the `\input` structure before treating this as fully audited.

---

### 42. Ising Anyons and Topological Qubit Gates (v2)
**File:** `qubit-gates\gentry-qubit-gates-v2.tex` · **STATUS:** Not triaged; per `CLAUDE.md`, both prior venues (PRX Quantum, JMP) are now exhausted (rejected)

**ERRORS FOUND:** Body (not abstract) contains the unqualified minimum-volume phrase describing m003 as "minimum-volume closed hyperbolic 3-manifold" — same recurring error, this time describing the *cusped* manifold's filled parent rather than M_PMNS directly, but the same underlying conflation.

**RECOMMENDED ACTION:** Fix before any future resubmission (npj Quantum Information or Quantum, per `CLAUDE.md`'s suggested next venues). Also: per `CLAUDE.md`'s explicit flag, the Chern-Simons level k=2 identification this paper leans on is still [Conjecture]/[Computed]-adjacent, not [Proved] — confirm/upgrade that before resubmitting, since it's likely load-bearing for referees.

---

### 43. Two-Tier Geodesic Spectrum Structure (v3)
**File:** `spectral-universality\SU_paper_short_v3.tex` · **SSRN:** 6761978 [REMOVED per CONFIRMED_abstracts] · **STATUS:** Not triaged

**ERRORS FOUND:** None from automated checks on the abstract text itself, but per prior tracking this paper's own June 2026 SSRN update note says: "statistical evidence for geodesic clustering near Lucas lengths is WEAKER than presented: Monte Carlo tests show only ONE significant result... out of multiple tests. Universal spectral gap conjecture FALSIFIED by ℤ/47 counterexample." That correction does not appear to have propagated into this local `.tex` file's abstract, which still states the two-tier structure as if fully supported.

**RECOMMENDED ACTION:** This local file needs the same self-correction that was already posted to SSRN as an update note — currently the local source and the live (removed) SSRN listing disagree on how strong the evidence is.

---

## Papers not independently re-verified in this pass (relied on `CONFIRMED_abstracts.md`'s existing tracking as sufficient)

#34 (GW/dark matter, orphaned/speculative, low priority) and several already covered under the
"orphaned" group above. All of #4/#5/#14/#17/#18/#32's status conclusions above lean heavily on
prior tracking that this audit spot-checked rather than fully re-derived from scratch — flagged
inline above wherever that's the case.

---

## Priority action list (my synthesis, ordered by urgency)

1. **Resolve the SSRN 6775158 identity question** (#2 vs CORE_MASTER_v12) — this determines
   whether a live, actively-tracked-as-"corrected" SSRN paper actually still contains a retracted
   claim in 9+ places. Highest priority because it's a live public document, not a draft.
2. **Withdraw or rewrite #24** (BPS lepton masses) — its central claim is refuted by work already
   in this corpus as of this week.
3. **Fix #28's abstract** (Meyerhoff minimum-volume, still in PRELIMINARY_UPLOAD — cheapest fix
   window before it goes live).
4. **Promote #35 to active status** and formally supersede #4/#5 — the portfolio's best CKM
   paper is currently filed as if it were a low-priority side draft.
5. **Resolve #3's malformed abstract** and #41's `\input` structure — both are currently
   un-auditable, not necessarily wrong.
6. Clean up redundancies: delete #38 (broken filename), consolidate 14 versions of #1, mark
   #26 superseded by #25, mark #32/v3 superseded by #39/#40.
7. Everything else above is either OK-as-is or a lower-priority framing/consistency fix.
