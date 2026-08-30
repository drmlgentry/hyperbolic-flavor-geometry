# Stage 3 representation-lift audit

Date: 2026-08-30 (America/Los_Angeles)

Scope: unblinded mathematics-only infrastructure audit. No flavor comparison, selector search, or execution of Stage 3 #2 v1 was performed.

Repository checkpoint inspected:

`1bef6a581000070cfabc2caf65a9719f1c3ef1fa`

## Verdicts

**Classification: CHARACTER DETERMINED / REPRESENTATION RECONSTRUCTIBLE.**

Here “representation reconstructible” means the irreducible `SL(2)` conjugacy class is uniquely determined and admits one uniform exact companion-gauge representative. Literal matrices are never intrinsic because simultaneous conjugation is unavoidable; the reconstruction introduces no state-dependent choice affecting any character or projective invariant.

**Independent-information verdict: SHORT-WORD TRACES ARE FUNCTIONS OF EXISTING CHARACTER DATA.**

More strongly, the projective character used in the frozen Stage 3 #2 preregistration is exactly blind to the spin/lift bit. Thus that proposed six-state experiment cannot distinguish all six states, regardless of word cutoff.

Stage 3 #2 v1 itself remains formally terminated as:

**NOT EXECUTABLE — REQUIRED GEOMETRIC STRUCTURE NOT YET DEFINED.**

No v1 observations were generated, so the theorem-level audit below is not a retroactive experimental `STRUCTURAL NULL` classification.

## Execution status

- `reproduce/stage3_reconstruct_representations_exact.py`: **EXECUTED — PASS**, exit `0`. Its output was reproduced from the repository copy and matched the saved log after newline normalization.
- `reproduce/stage3_reconstruct_representations.sage`: **EXECUTED — PASS**, `SAGE_EXIT=0`, in the user’s Sage/WSL environment on 2026-08-30. Every exact assertion completed before the certificate verdict was printed.
- The combined execution record is `reproduce/stage3_reconstruct_representations_exact.log`.

## 1. Exact character field and coordinates

The existing six-state construction begins with

\[
K_0=\mathbf Q(t),\qquad t^3+2t+1=0,
\]

and identifies the base generator trace as

\[
u=t^2+1.
\]

Direct elimination gives

\[
q(u)=u^3+u^2-u-2=0,
\]

whose discriminant is `-59`. The three geometric states are the three embeddings of this cubic field.

For the reference lift, the existing exact character data and peripheral signs are

\[
x=\operatorname{tr}A=u,\qquad
y=\operatorname{tr}B=u+1,
\]

\[
\operatorname{tr}(\mu)=+2,\qquad
\operatorname{tr}(\lambda)=-2,
\]

with presentation and peripheral words

\[
\langle a,b\mid ababbAAbb\rangle,
\qquad \mu=Abb,\qquad \lambda=AAbA.
\]

Writing

\[
z=\operatorname{tr}(AB),
\]

the meridian identity is

\[
\operatorname{tr}(Abb)=xy^2-x-yz.
\]

Substitution of `x=u`, `y=u+1`, and `tr(mu)=2` gives exactly

\[
z=u.
\]

The longitude identity

\[
\operatorname{tr}(AAbA)=x^3y-x^2z-2xy+z
\]

then gives `-2` exactly.

## 2. Exact uniqueness inside the m006 character surface

This is not merely one fitted solution. Fixing `x=u` and eliminating `z` from the two peripheral trace equations gives

\[
u y^2-2y-u^2=0
=u\bigl(y-(u+1)\bigr)\bigl(y-(u^2-2)\bigr).
\]

The two peripheral-equation candidates are therefore

\[
(y,z)=(u+1,u)
\]

and

\[
(y,z)=(u^2-2,u+4).
\]

The first lies on the exact m006 character surface derived from the relator. Substitution of the second into that surface gives

\[
-16(u+4)\ne0.
\]

Hence the relator plus the exact peripheral data select the first character point uniquely for each embedding of `K`.

The reducibility discriminant is

\[
\Delta=x^2+y^2+z^2-xyz-4=3u^2+u-5\ne0.
\]

Thus the character is irreducible. By the standard Fricke–Vogt theorem for two-generator `SL(2)` representations, an irreducible character point `(x,y,z)` determines one representation conjugacy class.

## 3. Uniform exact matrix reconstruction

Let

\[
E=K[s]/(s^2-us+1).
\]

The polynomial is irreducible over the real-embedded cubic field because its discriminant `u^2-4` is negative at the real geometric embedding and therefore cannot be a square in `K`.

A uniform companion-gauge representative is

\[
A=\begin{pmatrix}u&-1\\1&0\end{pmatrix},
\qquad
B=\begin{pmatrix}0&s\\s-u&u+1\end{pmatrix}.
\]

Since `s^2-us+1=0`, one has `s-u=-s^{-1}`. Consequently

\[
\det A=\det B=1,
\quad \operatorname{tr}A=u,
\quad \operatorname{tr}B=u+1,
\quad \operatorname{tr}(AB)=u.
\]

Exact matrix multiplication certifies:

- `ababbAAbb = I`;
- `tr(Abb)=+2`;
- `tr(AAbA)=-2`;
- the two peripheral matrices commute.

The two roots of `s^2-us+1` yield the same irreducible character and hence conjugate representations. This is ordinary gauge/conjugacy freedom, not a second state or unresolved representation ambiguity.

## 4. The six states

Let `sigma` range over the three embeddings of `K`, and let `eta` be the spin/lift sign. The six exact `SL(2)` characters are

\[
(x_{\sigma,\eta},y_{\sigma,\eta},z_{\sigma,\eta})
=\bigl(\eta\,\sigma(u),\ \sigma(u)+1,\ \eta\,\sigma(u)\bigr),
\qquad \eta\in\{+1,-1\}.
\]

This follows because the nontrivial character has

\[
\chi(a)=1,\qquad \chi(b)=0,
\]

so it sends `A` and `AB` to their negatives while leaving `B` unchanged. Exact multiplication also gives the twisted peripheral signs `tr(mu)=-2` and `tr(lambda)=+2`.

## 5. Are short-word traces new?

No. For two matrices in `SL(2)`, the Fricke–Vogt trace algebra is generated by

\[
x=\operatorname{tr}A,
\qquad y=\operatorname{tr}B,
\qquad z=\operatorname{tr}(AB).
\]

For every word `W` in `A` and `B`, there is a universal polynomial

\[
P_W\in\mathbf Z[x,y,z]
\]

such that

\[
\operatorname{tr}\rho(W)=P_W(x,y,z).
\]

Therefore an arbitrary collection of short-word traces cannot add representation-theoretic information beyond the already determined character point. It may re-express that information, but it is not an independent invariant family.

The frozen experiment used the projective character

\[
\chi_{\mathrm{proj}}(W)
=\frac{\operatorname{tr}(\rho(W))^2}{\det(\rho(W))}.
\]

Under the spin twist,

\[
\rho^\chi(W)=(-1)^{\chi(W)}\rho(W).
\]

Hence

\[
\chi_{\mathrm{proj}}^\chi(W)=\chi_{\mathrm{proj}}(W)
\]

for every word. The two spin states over each fixed embedding are exactly the same `PGL(2)` representation. No projective word invariant—not merely the proposed first 24—can recover that spin bit.

## 6. Epistemic status

### Exact theorem/computation

- Conditional on the existing algebraic identification `tr(A)=u`, the coordinate derivation, uniqueness calculation, irreducibility test, matrix reconstruction, relator check, peripheral checks, and spin-twist formulas are exact.
- The dependence of every word trace on `(x,y,z)` and uniqueness of an irreducible representation from its character are standard theorems.
- Projective blindness to a central sign twist is immediate and exact.

### Existing computed identification retained as computed

The repository's identification of the geometric polished-holonomy trace with the chosen embedded algebraic number `u=t^2+1` was obtained through high-precision holonomy, algebraic recognition, and an embedding match. This audit does not promote that source-identification step beyond its existing computational status. It proves what follows exactly once that recorded identification is accepted.

## 7. Consequence for future Stage 3 work

The non-peripheral short-word proposal should be abandoned as a source of genuinely new six-state information. A replacement observable must not be a function solely of the ordinary two-generator character and must not descend to `PGL(2)` if it is expected to detect the spin/lift bit.

Candidates such as torsion, spin-refined data, peripheral logarithm/eigenvalue branches, or Chern–Simons-type refinements require separate well-definedness and independence audits before any new blind protocol is registered.

## Provenance

Primary repository sources:

- `reproduce/stage3_build_state_invariants.sage`
- `reproduce/stage3_enrich_state_invariants.sage`
- `reproduce/hfg_stage3_binary_spin_selector.py`
- `reproduce/stage3_spin_lift_continuity_note.md`
- `reproduce/q001_fricke_collapse_m006.sage` for the exact cusped m006 character-surface polynomial only; its filled-manifold `z=x` theorem was not transferred to the cusped setting.

New certificate:

- `stage3_reconstruct_representations.sage`
- `stage3_reconstruct_representations_exact.py`
- `stage3_reconstruct_representations_exact.log`

No prior target assignment or mass datum is used in any derivation above.
