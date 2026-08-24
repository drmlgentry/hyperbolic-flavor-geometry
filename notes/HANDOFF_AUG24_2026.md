# HANDOFF — 2026-08-24

## JOURNAL REJECTIONS TO ACTION

### AGT rejection — dual surgery paper (SSRN 7277458)

Manuscript: "The Meyerhoff Manifold as a Dual Dehn Filling: Arithmetic
Independence of SU(2) and SU(4) Cusped Parents." Editor: Jessica S. Purcell.
Desk decision after one referee report; not accepted.

Referee's critique (their own words): "I have no reason to doubt the
computations... As it is written, the paper is just computing facts about
small manifolds... I am not convinced that it meets the very high standards
of AGT. The result seems quite narrow in scope. AGT typically publishes
papers that are broader, for example proving surprising results about
infinitely many 3-manifolds."

Two distinct issues, not one:
1. **Presentation gap** — the paper doesn't situate the arithmetic
   independence result within existing mathematical literature (no framing
   via Neumann-Reid's commensurability program, no discussion of what was
   previously unknown, no forward-looking questions raised).
2. **Scope/fit** — AGT wants results about infinite families; this paper is
   about two specific manifolds. This is a venue-fit problem independent of
   the writing.

Fixable for a revision, but the scope issue argues for a different venue
regardless of how well the presentation is fixed.

**Do not resubmit to AGT.** Candidate venues raised in discussion:
- Geometriae Dedicata — explicitly receptive to computational results about
  specific manifolds
- Journal of the London Mathematical Society — broader scope than AGT
- Michigan Mathematical Journal — good fit for arithmetic 3-manifold results
- Experimental Mathematics — computational results explicitly welcome

Next step: decide venue, then revise the introduction to add (a) a clear
statement of what was previously unknown, framed mathematically rather than
via the HFG physical motivation, (b) explicit connection to Neumann-Reid's
commensurability framework, (c) the dual surgery identity cited against the
standard Dehn surgery literature, (d) forward-looking questions (e.g.
commensurability classes, covering spaces) that the result opens up.

**Note — this does not affect the galois-product-theorem paper's own AGT
plan.** That paper (SSRN 7341038) has a different hook (the 576-element
direct-product theorem with two independent proofs, now plus the Artin
conductor cross-check) and was always a separate submission decision.
Whether to still target AGT for it is unaffected by this rejection unless
the author decides otherwise.

---

## OPEN: m009/m010 Bianchi subgroup enumeration

Proved so far (see `papers/galois-product/gentry-galois-product-theorem.tex`
Proposition 3.2 and `reproduce/gap_gamma2_*.py`):
- Both m009 and m010 arithmetic (extensive $\Gamma^{(2)}$ trace-integrality
  check: all 15 Horowitz-Southcott generators plus all 64 triple products,
  every trace exactly in $\mathcal{O}_K$, $K=\Q(\sqrt{-7})$; not a formal
  closed-form proof, but no exceptions found across 78 checked elements)
- Both commensurable (same invariant trace field, split quaternion algebra
  in the cusped case)
- Cusp shapes confirmed exactly (algebraic identity, not numerical):
  $\tau_{009}=\sqrt{-7}$ (nonmaximal order $\Z[\sqrt{-7}]$),
  $\tau_{010}=\frac{1+\sqrt{-7}}{2}$ (maximal order $\mathcal{O}_K$),
  index 2 apart

Volume-ratio reasoning (from external GPT discussion, not independently
verified here -- record as a hypothesis, not an established fact):
- $\mathrm{vol}(m009)=\mathrm{vol}(m010)/\mathrm{vol}(T_7)\approx 3$ where
  $T_7=\mathrm{PSL}_2(\mathcal{O}_{-7})$
- But index-3 torsion-free subgroups of $T_7$ are claimed impossible
  (Grunewald-Schwermer: $S_3<T_7$ forces $6\mid[T_7:H]$ for torsion-free
  $H$) -- this citation has not been independently checked
- Revised hypothesis: m009, m010 are index-6 torsion-free subgroups,
  either of $T_7$ itself or of its maximal discrete extension
  $\widetilde\Gamma_{-7}$ (covolume claimed $\approx 0.4445$, also
  unverified here)

Next computation (flagged as a half-day GAP project, not a quick check):
```
LowIndexSubgroups(T_7, 6)
  -> filter torsion-free, one-cusped
  -> compare H_1 against Z+Z/2 and Z+Z/6
  -> compare peripheral lattices against Z[sqrt(-7)] and O_K
```
Needs an explicit presentation of $T_7$ or its extension (external
discussion cites Dinakaran (2022) / Reese (2023) -- not independently
verified). If exactly two torsion-free index-6 classes survive and match
m009/m010's invariants, that would show they are specific, identifiable
sibling subgroups of a common parent lattice rather than just abstractly
commensurable.

**Caveat on this whole section:** everything under "Volume-ratio reasoning"
and the citations above (Grunewald-Schwermer, Vulakh, Dinakaran, Reese)
came from an external AI research session, relayed here, and have not been
independently checked the way the arithmeticity/cusp-order result above
was. Treat as a research lead, not a verified claim, until someone
actually runs the enumeration or checks the citations.
