# Stage 2 invariance proof: the oriented G/H coset selector

**Status of this document:** written and checked here, not transcribed from the
relayed sketch as-is. The relayed proposition's literal formula,
`tau -> (b*tau+a)/(d*tau+c)`, fails its own identity-matrix sanity check (for
(a,b,c,d)=(1,0,0,1) it gives `1/tau`, not `tau`) — the same bug pattern already
caught once while building `hfg_stage2_oriented_coset_selector.sage`. The
underlying *strategy* the relay proposed (field embeddings commute with rational
Möbius maps; orientation matters for the reversal case) is sound and is what
this proof actually uses — but the formula and the precise logical roles of its
two ingredients needed to be reworked, not copied.

## Setup

- `K = Q(alpha)`, `f(alpha) = 0`, `f(x) = x^3 + 2x + 1`, disc(f) = -59.
- Three embeddings `sigma_R, sigma_+, sigma_- : K -> C`, sending `alpha` to the
  three roots `r_R` (real), `r_+` (Im > 0), `r_-` (Im < 0) of `f`, with
  `r_- = conj(r_+)`.
- `M = m006`, oriented. Its discrete faithful holonomy representation
  `rho_geo : pi_1(M) -> PSL(2,C)` determines a geometric complex embedding
  `iota_geo : K -> C`. Established computationally (independent of this proof,
  to ~1e-16): `iota_geo = sigma_+`.
- A change of peripheral basis replaces the meridian/longitude pair `(mu,
  lambda)` by `(mu', lambda') = (a*mu+b*lambda, c*mu+d*lambda)` for an integer
  matrix `(a,b;c,d)` with `ad-bc = +-1`. The cusp shape `tau = lambda/mu`
  (in a fixed normalization) transforms accordingly. **Empirically calibrated
  here against real SnapPy output** (matched to ~1e-16, see the script): with
  this basis-change convention, `tau' = (d*tau+c)/(b*tau+a)`.

## Proposition 1 (basis-change invariance)

*For any integer matrix `(a,b,c,d)` with `ad-bc = +-1`, recomputing the cusp
shape under the peripheral basis it defines always yields the value predicted
by applying the **same** transform to `alpha` and evaluating under `sigma_+` —
never under `sigma_R` or `sigma_-`.*

**Proof.** A peripheral basis change does not alter the manifold, its
orientation, or `rho_geo` — it only changes which curve pair on the *same*
fixed cusp torus is labeled meridian/longitude. So the geometric content being
recomputed is, in every case, some fixed rational function of the *same*
underlying geometric quantity, namely the value `iota_geo(alpha) = sigma_+(alpha)
= r_+`. Concretely (standard in the theory of cusped hyperbolic 3-manifolds:
the cusp shape transforms under peripheral basis change by the corresponding
linear-fractional action on the ratio of translation lengths — confirmed here
to match SnapPy's implementation to ~1e-16), SnapPy's recomputed shape for
basis `(a,b,c,d)` is

    tau' = (d*tau+c)/(b*tau+a),    tau = sigma_+(alpha) = r_+.

Now let `N(alpha) = (d*alpha+c)/(b*alpha+a)` be the *same* rational function,
formed abstractly inside `K` (well-defined since `a,b,c,d` are rational and
`b*alpha+a` is nonzero — it can only vanish for the specific rational value
`alpha = -a/b`, which is not a root of the irreducible cubic `f` since `f` has
no rational roots). Since `sigma_+ : K -> C` is a field homomorphism fixing
`Q` pointwise, and `a,b,c,d in Z subset Q`, homomorphism commutativity gives

    sigma_+(N(alpha)) = (d*sigma_+(alpha)+c) / (b*sigma_+(alpha)+a)
                       = (d*r_+ + c) / (b*r_+ + a)
                       = (d*tau+c)/(b*tau+a) = tau'.

So `tau' = sigma_+(N(alpha))` exactly — the transform lands back on the
`sigma_+` embedding, never `sigma_R` or `sigma_-`, for every valid basis
change. This argument used only that `a,b,c,d` are rational (so the *same*
homomorphism-commutativity holds for `sigma_R` and `sigma_-` too, giving three
generally-distinct candidate values `sigma_R(N(alpha))`, `sigma_+(N(alpha))`,
`sigma_-(N(alpha))` — SnapPy's actual output picks out the `sigma_+` one
because that is which embedding was geometric to begin with, not because of
anything special about the matrix). QED.

*(Note: this argument did not need the determinant condition `ad-bc=+-1` or
any orientation-preservation fact — it is a direct consequence of `alpha`'s
embedding being fixed by the geometry, plus elementary field homomorphism
commutativity. The determinant condition matters only for the basis change to
be a *valid* change of basis (invertible over Z), not for which embedding gets
selected.)*

## Proposition 2 (orientation reversal)

*Reversing the manifold's orientation replaces the selected embedding
`sigma_+` by `sigma_-`, and fixes `sigma_R`.*

**Proof.** Reversing the orientation of an oriented hyperbolic 3-manifold
replaces its discrete faithful representation `rho_geo` by the
complex-conjugate representation `bar(rho_geo)` — a standard fact: an
orientation-reversing isometry of `H^3` conjugates `PSL(2,C)` by complex
conjugation, so reversing orientation replaces every holonomy image `rho_geo(g)`
by `conj(rho_geo(g))`. The geometric embedding therefore becomes
`conj o iota_geo = conj o sigma_+`. Since `r_-` is by construction the complex
conjugate of `r_+` (the two non-real roots of a real cubic form a
conjugate pair) and `r_R` is real, we have, as functions `K -> C`:

    conj(sigma_+(alpha)) = conj(r_+) = r_- = sigma_-(alpha)
    conj(sigma_R(alpha)) = conj(r_R) = r_R = sigma_R(alpha)   (r_R real)

so `conj o sigma_+ = sigma_-` and `conj o sigma_R = sigma_R` as embeddings.
Hence orientation reversal swaps the selected embedding to `sigma_-` and
leaves the real embedding fixed. QED.

*(This matches the observed data up to a peripheral-convention artifact:
SnapPy's `reverse_orientation()` also resets its internal meridian/longitude
convention, so the raw reported number is `-conj(tau)`, not `conj(tau)`
directly — an extra basis change layered on top, covered by Proposition 1
once identified, and confirmed to ~1e-16 empirically.)*

## Conclusion

Propositions 1 and 2 together give an unconditional proof — not merely a
7-cases-tested numerical check — that the oriented m006 holonomy selects a
single, basis-independent embedding of `K` (equivalently, a single element of
`G/H`), and that orientation reversal moves between exactly the two complex
choices while fixing the real one. The only empirical input used is (a) that
`iota_geo = sigma_+` for the *default* basis (confirmed to ~1e-16, established
before this proof) and (b) that SnapPy's `set_peripheral_curves` implements
the standard cusp-shape transformation law (confirmed to ~1e-16 against real
output, consistent with the standard theory rather than merely asserted).
Given (a) and (b), Propositions 1–2 are exact algebra, not numerics.

**Recommendation:** promote CLAIMS_REGISTER entry 17 from [Computed] to
[Proved] on the strength of this argument, while keeping the empirical
inputs (a) and (b) stated explicitly in the entry — they are established
facts about this specific field and this specific manifold, not remaining
gaps in the logic connecting them.
