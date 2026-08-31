# Stage 3 #3A: normalized T4 admission audit

Date: 2026-08-30 (America/Los_Angeles)

Scope: contaminated, mathematics-only pre-admission audit. No flavor target,
state-to-target assignment, selector, fit, or numerical torsion value was
accessed or computed.

Repository checkpoint at the start of the audit:

`57368c61ea283cbc7d972a845972f2ba2b4fe337`

## Classification

**FAIL_GATE_2 — CHARACTER DETERMINED.**

The proposed observable is the normalized higher Reidemeister torsion

\[
\mathcal T_4(m006;\eta),
\]

where the four-dimensional irreducible representation is
`Sym^3` of the spin lift of the hyperbolic holonomy.

This classification does **not** assert

\[
\mathcal T_4(m006;\eta_+)
=
\mathcal T_4(m006;\eta_-).
\]

No such equality or inequality has been computed or proved here. Instead, the
candidate fails the separately stated independence gate: for a fixed manifold,
the normalized torsion is an invariant constructed from the `SL(2,C)`
representation, and the existing irreducible Fricke character already
determines that representation up to conjugacy. The chain complex and manifold
are fixed common inputs, not additional state coordinates.

## Admission gates

The preregistered gates are:

1. **Gate 1 (spin sensitivity):** the observable must distinguish, or be
   proved capable of distinguishing, the two central spin lifts.
2. **Gate 2 (independent information):** the observable must not be completely
   determined by the existing exact Fricke-character data for the fixed
   geometric object.

The allowed classifications are `FAIL_GATE_1`, `FAIL_GATE_2`,
`PASS_ADMISSION`, and `UNRESOLVED`. Failure of either gate is sufficient for
pre-fit rejection.

## 1. Gate 1: structurally eligible, numerically unresolved

Let

\[
\rho^\chi(\gamma)=\chi(\gamma)\rho(\gamma),
\qquad
\chi:\pi_1(m006)\longrightarrow\{\pm1\}.
\]

For the `n`-dimensional irreducible representation

\[
\sigma_n=\operatorname{Sym}^{n-1},
\]

homogeneity gives

\[
\sigma_n(\rho^\chi(\gamma))
=\chi(\gamma)^{n-1}\sigma_n(\rho(\gamma)).
\]

For `n=4`,

\[
\sigma_4(\rho^\chi(\gamma))
=\chi(\gamma)\sigma_4(\rho(\gamma)).
\]

Thus `Sym^3` does not factor through `PSL(2,C)` and the central sign is not
automatically killed. This is an exact representation-theoretic distinction
from the projective-character candidate rejected in Stage 3 #2.

It proves only **eligibility**. It does not prove that the normalized torsions
of the two actual m006 spin lifts differ. Consequently the Gate-1 field remains

`spin_sensitive: UNRESOLVED`.

## 2. Gate 2: exact failure under the registered meaning

Fix a finite CW model `X` of m006. Given a representation

\[
\alpha:\pi_1(X)\longrightarrow GL(V),
\]

the twisted cellular chain complex is obtained from the fixed cellular
boundary operators over the group ring by applying `alpha`. Hence, once `X`
and the conjugacy class of `alpha` are fixed, the twisted complex and its
Reidemeister torsion data are fixed (subject to the usual stated basis and
normalization conventions).

For the proposed candidate,

\[
\alpha=\sigma_4\circ\rho_\eta.
\]

Menal-Ferrer and Porti define the cusped higher torsions from the lift of the
holonomy selected by the spin structure and the irreducible representation of
`SL(2,C)`. Their normalized quotient removes the dependence on the auxiliary
peripheral cycles used to choose homology bases. Thus the normalization does
not introduce a new state variable.

The exact Stage 3 representation-lift audit already proved for the m006 points
in scope that:

- the Fricke coordinates `(x,y,z)=(tr A,tr B,tr AB)` determine an irreducible
  `SL(2,C)` character;
- an irreducible two-generator character determines one representation
  conjugacy class;
- the two spin lifts are represented by their two distinct `SL(2,C)`
  character points.

It follows that, for fixed m006 and the fixed normalized-torsion definition,

\[
(x,y,z)
\quad\Longrightarrow\quad
[\rho_\eta]
\quad\Longrightarrow\quad
\mathcal T_4(m006;\eta).
\]

The implication is a determinacy statement; it does not claim that
`T4` is a short trace polynomial. Computing torsion may require Fox matrices,
a CW complex, symmetric-power matrices, and exact determinant arithmetic.
Those ingredients define a possibly complicated function of the already fixed
representation. They do not supply an additional varying coordinate among the
six registered states.

Therefore

`character_independent: false`

under the strict Gate-2 definition used for Stage 3 admission.

## 3. What this result does and does not close

Certified here:

- `Sym^3` retains the central sign, so projective blindness is not the Gate-1
  obstruction.
- The proposed normalized `T4` value for fixed m006 is determined by the
  existing irreducible `SL(2)` character and fixed topological input.
- The candidate is `REJECTED_PRE_FIT` by Gate 2.
- No target access or fit is mathematically warranted.

Still open, but no longer required for this candidate's admission decision:

- whether the two normalized m006 values are equal or unequal;
- exact numerical or algebraic values of either torsion;
- acyclicity and implementation details for a direct m006 computation.

An observable based on torsion could be reconsidered only under a materially
different, prospectively defined gate—for example, one that admits derived
functions of the full character but excludes only universal trace-polynomial
re-expression. That would be a governance change, not a reinterpretation of
this audit after seeing outputs.

## 4. Theorem / computation / conjecture ledger

### Exact theorem or definition

- `Sym^3(-A)=-Sym^3(A)`.
- A fixed twisted cellular chain complex is determined by its fixed CW complex
  and coefficient representation.
- Reidemeister torsion is invariant under conjugation of the coefficient
  representation, with the standard compatible basis conventions.
- The normalized cusped invariant is defined from the spin lift and removes
  the auxiliary peripheral-cycle choice by taking the prescribed quotient.
- The prior exact audit's irreducible Fricke character determines the m006
  representation conjugacy class.

### Exact deduction conditional on the prior m006 identification

- `T4(m006;eta)` is determined by the recorded exact `SL(2)` character point.
- Gate 2 fails and the candidate is rejected before fitting.

### Not computed or certified

- `T4(m006;eta_+)` and `T4(m006;eta_-)`.
- Equality or inequality of those two values.
- Any target comparison.

### Conjecture

None is promoted by this audit.

## Sources

- P. Menal-Ferrer and J. Porti, *Higher dimensional Reidemeister torsion
  invariants for cusped hyperbolic 3-manifolds*, arXiv:1110.3718,
  https://arxiv.org/abs/1110.3718.
- J. Porti, *Reidemeister torsion, hyperbolic three-manifolds, and character
  varieties*, arXiv:1511.00400, https://arxiv.org/abs/1511.00400.
- Y. Yamaguchi, *Higher even dimensional Reidemeister torsion for torus knot
  exteriors*, arXiv:1208.4452, https://arxiv.org/abs/1208.4452. This source is
  corroborating context for the role of the twisted chain complex and
  acyclicity; it is not used to transfer a torus-knot formula to m006.

## Repository provenance

- `STAGE3_REPRESENTATION_LIFT_AUDIT.md`
- `reproduce/stage3_reconstruct_representations.sage`
- `reproduce/stage3_reconstruct_representations_exact.py`
- starting commit `57368c61ea283cbc7d972a845972f2ba2b4fe337`

No file containing flavor targets was read for this audit.
