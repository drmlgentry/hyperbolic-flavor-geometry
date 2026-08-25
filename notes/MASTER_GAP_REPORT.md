# HFG Program — Master Gap Report

Consolidated 2026-08-25 from `HANDOFF_AUG24_2026.md`, `CLAIMS_REGISTER.md`,
and `HANDOFF_JUNE22_2026.md` (all in `C:\dev\hyperbolic-flavor-geometry`),
plus this session's own work (census scans, Q-001). Lists open items only —
not a status summary of completed/proved results. See those source files
and `docs/progress.html` for what has already been established.

---

## GAP-001: Stage 3 blind session — mapping geometric states to mass indices

**Claim under test:** Stage 1 (canonical prime-lift transposition, a C₂
datum) and Stage 2 (oriented holonomy coset selection, `CLAIMS_REGISTER.md`
entry 17) together give a genuine 2×3=6-element geometric state space.
Stage 3A (entry 18) independently confirms the same six-slot structure via
an H¹(M;ℤ/2)-torsor spin-lift argument (Menal-Ferrer–Porti), computing a
concrete sign ε from actual holonomy traces (tr(μ)=+2, tr(λ)=−2 default
lift; the filling-extending lift is the χ-twist, trace(s)=−2).

The six frozen states, with their exact invariants, are recorded in
`reproduce/stage3_state_invariants.csv` (embedding index 0/1/2 × ε=±1,
root real/imaginary parts, argument, coset representative, character
values on μ/λ/the filling slope).

**What's open:** no map from those six states to the six actual quark mass
indices {12, 18, 43, 65, 75, 106} has been attempted or found
(`CLAIMS_REGISTER.md` lines 289–291, 334–337: "That remains completely
open (Stage 3, explicitly not attempted this session)").

**Status:** Not yet attempted. Requirements for a valid attempt (to avoid
post-hoc curve-fitting a 6-element permutation, which is nearly free):
- Pass the frozen `stage3_state_invariants.csv` table to a fresh session
  with no memory of the mass indices.
- Construct a narrow, pre-committed rule class F (e.g. "order by |root|,"
  "order by root_arg," some other single natural invariant) — the
  narrower and more falsifiable F is, the more a successful match means.
- The six target mass indices {12,18,43,65,75,106} must NOT be visible to
  whatever process is constructing F.
- Evaluate the match only after F is frozen; one shot, not iterative
  fitting against the known targets.
- Require a single uniform F applied identically across all six states,
  not six separately-justified assignments.

**Physical reading if it fails or is skipped:** [Conjecture]/open, same
status as `CLAIMS_REGISTER.md` entries 4, 14, 15, 17, 18 — the six-element
geometric torsor is real and independently confirmed twice (Stage 2 and
Stage 3A), but supplies no mechanism connecting it to which quark occupies
which slot until Stage 3 is actually run.

---

## GAP-002: Bianchi index-6 subgroup enumeration for m009/m010

m009 and m010 are proved arithmetic (extensive Γ^(2) trace-integrality
check, all 15 Horowitz-Southcott traces + 64 triple products in O_K) and
commensurable, both with invariant trace field K=Q(√-7), tied minimal
volume, non-isometric, cusp shapes √-7 (nonmaximal order Z[√-7]) vs
(1+√-7)/2 (maximal order O_K), index 2 apart — see
`gentry-galois-product-theorem.tex` Proposition 3.2.

**Conjecture (not independently verified):** both are torsion-free
index-6 subgroups of the extended d=-7 Bianchi group (T_7=PSL₂(O_{-7}) or
its maximal discrete extension Γ~_{-7}, covolume ≈0.4445). Chain of
reasoning: vol(m010)/vol(m009)≈3 relative to T_7's covolume; a
Grunewald-Schwermer citation is claimed to forbid index-3 torsion-free
subgroups of T_7 (S₃<T_7 forces 6∣[T_7:H]), pushing the hypothesis to
index 6.

**Status:** Requires GAP `LowIndexSubgroups(T_7, 6)`, filtered to
torsion-free + one-cusped, compared against m009/m010's known H₁ and
peripheral-lattice invariants. Needs an explicit presentation of T_7 or
Γ~_{-7} — external discussion cites Dinakaran (2022) / Reese (2023), but
**neither the Grunewald-Schwermer citation nor the Dinakaran/Reese
presentation claims have been independently checked** (`HANDOFF_AUG24_2026.md`,
"Caveat on this whole section"). Verify those citations before spending
GAP compute time on the enumeration itself.

---

## GAP-003: Stage 3A deformation theorem — three unverified hypotheses

`CLAIMS_REGISTER.md` entry 18 status is [Structural], not [Proved], for a
specific, named reason: three technical hypotheses underlying the
continuity argument (that the χ-twisted lift, not SnapPy's default lift,
is the one extending over the m006(−5,2) filling) have not been
independently re-verified to the standard of entry 17's proof:
1. Existence of the continuous cone-manifold deformation path α∈[0,2π] is
   cited (Thurston; Neumann-Zagier; Hodgson-Kerckhoff), not re-derived.
2. The monotonicity argument at α=π was checked in Menal-Ferrer–Porti's
   proof for their own auxiliary curve, not independently re-verified
   here for the slope s=−5μ+2λ directly.
3. Irreducibility of the representation along the full deformation path
   has not been explicitly checked.

**Status:** Needs independent Sage verification of all three. See
`reproduce/stage3_spin_lift_continuity_note.md` for the exact statement
of the gap.

---

## GAP-004: Census-wide rarity of the C₂×S₄×C₂×S₃ configuration

Is the disjoint-ramification quadruple type used in the paper's uniform
discriminant-288 construction (Section 5) — and the specific prime
quadruple {3,7,59,283} within it — rare across the full 212,641-manifold
census, or does it recur? A 20-manifold pilot found 15 matching
quadruples in an early slice; that doesn't establish rarity or minimality
census-wide.

**Status:** Running (`census_disjoint_ramification_scan.sage.py`, job
in `reproduce/census_full_scan/`). As of this session: checkpointed,
resumable, using a persistent-subprocess worker with a hard OS-level
per-manifold timeout (an earlier in-process `signal.alarm()` approach was
found not to actually bound per-manifold cost, since PARI/GP calls inside
Sage don't yield to Python's signal handler until they return on their
own). Currently deep in the census's `s`-family (6-tetrahedron manifolds),
where the large majority of manifolds fail to resolve within the current
`--degree-bound 10` / `--closure-degree-max 48` bounds — a real, structural
finding suggesting trace-field complexity grows faster than these bounds
accommodate past the `m`-family. Whether to loosen the bounds, accept a
lower yield, or add a cheaper pre-filter is an open methodology decision.

A companion scan (`census_uniqueness_scan.py`) testing whether m010 is
uniquely the minimum-volume manifold realizing the maximal cusp order
O_K across the full census is separately running and near completion
(~96% through Pass 1 as of this session).

---

## GAP-005: Dual surgery paper (SSRN 7277458) needs revision + new venue

Rejected by AGT (desk decision, one referee: "too narrow in scope," not a
math error). Two distinct issues per the referee: (1) missing framing —
no situating of the arithmetic-independence result within existing
literature (Neumann-Reid commensurability program), no explicit statement
of what was previously unknown, no forward-looking questions; (2) venue
fit — AGT wants infinite-family results, this paper is about two specific
manifolds, a scope mismatch independent of the writing quality.

**Status:** Not yet revised. Candidate venues (not yet chosen): Geometriae
Dedicata, Journal of the London Mathematical Society, Michigan Mathematical
Journal, Experimental Mathematics. **Do not resubmit to AGT.** Revision
needs: explicit prior-unknown statement, Neumann-Reid framing, the dual
surgery identity cited against standard Dehn surgery literature,
forward-looking questions (commensurability classes, covering spaces).
Does not affect the galois-product-theorem paper's own separate AGT plan.

---

## GAP-006: Q-001 Fricke-collapse exact proof

**Status: [Computed] — this one is resolved, kept here for completeness
of the consolidation, not as an open item.** The question ("does the
Fricke involution collapse z=x exactly, or only numerically, on
m006(-5,2)'s SL(2,C) character variety") was resolved exactly via quotient-
ring linear algebra: dim(R/I)=440; the geometric degree-10 factor q₁₀(x)
of minpoly(Mₓ) (confirmed to be m006(-5,2)'s own trace-field polynomial up
to sign) cuts out a 20-dimensional quotient B=A/(q₁₀(x)); the induced
action of u=z−x on B has rank 10 and **u²=0 exactly** — confirmed by exact
rational linear algebra, not modular/numerical evidence alone. This
confirms the Fricke collapse holds exactly on the reduced geometric point,
with a genuine order-2 nilpotent thickening at the scheme level. Commit
`e419cfa`.

---

## Other open items found while consolidating (`HANDOFF_JUNE22_2026.md`)

Different, tangential research thread (Eisenstein norms / Bianchi
base-change / golden-ratio fiber), included here only because the source
file was explicitly scanned for open items:

- **SSRN 6775158** correction note pending — form was failing with a save
  error; action was to email support@ssrn.com with the text from
  `correction_note_6775158.md` (two corrections: a Q(√17) retraction and
  a σ_opt fix). Not confirmed done.
- **SSRN 6876278** (Sextic-Octic decomposition) still listed as
  PRELIMINARY_UPLOAD — needs formal submission.
- **Thread 2** (Bloch-Wigner): observation that z₁ is m019's cusp shape;
  algebraic proof of why D(z₀)=v₀ specifically, via Bloch group elements,
  is still open.
- **Thread 4** (F_τ / golden ratio): the F_τ fiber and the Q(√5) component
  at level 8773 are different fields with no direct containment bridge
  (compositum is degree 6); completing this requires computing twisted
  Bianchi eigenvalues in Sage. Thread 6's result is flagged as suggesting
  the Lucas-number connection specifically will NOT hold.
- vol(m019)=3·v₀, vol(m178)=4·v₀ — numerically clear, mechanism
  understood, but no proof yet.
- Whether p=31 being both the tower prime p₂ AND the unique prime with
  ord₃₁(5)=3 is one fact or two coincidences is unresolved.
