# Stage 3A spin-lift: continuity argument and sign resolution

**Status: [Structural], not [Proved].** The mechanism is standard and correctly
applied; a fully rigorous write-up verifying every technical hypothesis of the
deformation theorem has not been done. What follows *does* resolve the sign
ambiguity left open in the original write-up, using real computed data rather
than an abstract choice.

## The gap in the original claim

The relayed write-up asserted "the lift with chi(s)=+1 extends over the
(-5,2) filling, the other sends s to -I" without pinning down which of the
two actual lifts that is. This is not just a labeling nitpick: chi in
H^1(m006;Z/2) describes the DIFFERENCE between the two lifts' signs on a
curve (Menal-Ferrer-Porti Prop 3.8: "elements in H^1(M;Z/2Z)... describe the
difference between signs of two different lifts") -- it is not, by itself, a
property that picks out one specific lift. To say which lift extends, you
need an absolute baseline: an actual computed sign for at least one real lift.

## Resolving it with real holonomy data

Using `G.SL2C(word)` in Sage/SnapPy on `m006`'s actual discrete faithful
representation (verified to be the genuine geometric holonomy: peripheral
elements come out exactly parabolic, trace +-2, as required for a complete
cusped hyperbolic structure):

    tr(mu)     = +2.0   (mu = Abb)
    tr(lambda) = -2.0   (lambda = AAbA)
    tr(s)      = +2.0   (s = -5*mu + 2*lambda, computed as mu^-5 * lambda^2;
                          checked both multiplication orders, they agree,
                          consistent with mu, lambda commuting)

All exact to floating-point precision (residuals ~1e-14, from a single
non-iterative matrix computation, not an optimization).

## The continuity argument (Menal-Ferrer-Porti Lemma 3.9 style, applied
## directly to s -- no auxiliary large-slope trick needed)

Since m006(-5,2) is independently known to be an actual hyperbolic Dehn
filling (established throughout the corpus via direct SnapPy computation,
not merely "for sufficiently large slopes" as in Lemma 3.9's general
statement -- that caveat was only needed there to handle an ARBITRARY curve,
not a slope already known to give a hyperbolic filling), the standard
Thurston hyperbolic Dehn surgery deformation gives a continuous path of
(possibly singular, cone-angle alpha) hyperbolic structures for alpha in
[0, 2*pi], with alpha=0 the complete cusped structure and alpha=2*pi the
filled structure. Along this path,

    trace(rho_alpha(s)) = eps * 2*cos(alpha/2)

for a FIXED sign eps in {+1,-1} (continuous, nonzero except possibly at
alpha=pi, where the same monotonicity argument as Lemma 3.9's proof applies).

At alpha = 2*pi, s is killed in pi_1 of the filled manifold, so any
representation that genuinely represents pi_1(filled) must send s to the
identity I exactly (trace = +2, not just "parabolic with trace +2" -- s has
literally become trivial). Setting alpha=2*pi:

    eps * 2*cos(pi) = eps * (-2) = +2   =>   eps = -1.

So the EXTENDING lift has, at alpha=0 (the complete structure):

    trace = eps * 2*cos(0) = -1 * 2 = -2.

## Conclusion

The extending lift has tr(s) = -2 at the complete structure. SnapPy's actual
default lift has tr(s) = +2. Therefore:

**The lift that extends over m006(-5,2) is SnapPy's default discrete-faithful
lift TWISTED by chi -- not the default lift itself.**

This is a concrete, falsifiable, checkable claim (anyone can rerun
`G.SL2C(...)` and get the same +2/-2/+2 numbers), not an unresolved +-1 sign
left as a free choice.

## What is still missing before [Proved]

1. The deformation-theoretic fact used above (existence of the continuous
   cone-manifold path for alpha in [0,2*pi] whenever the filling is
   hyperbolic, with trace varying as 2*cos(alpha/2) along a fixed-sign
   branch) is standard (Thurston; Neumann-Zagier; Hodgson-Kerckhoff for the
   existence of the path itself) but has not been re-derived from scratch
   here -- it is cited/applied, not proved independently.
2. The monotonicity argument at alpha=pi (needed to pin the sign eps
   unambiguously when the trace passes through zero) was checked in Lemma
   3.9's proof for the AUTHORS' specific auxiliary curve construction; it has
   not been independently re-verified here for s directly, though there is
   no evident reason it would behave differently.
3. Irreducibility of the representation must be maintained throughout the
   deformation path for the argument to go through cleanly (Menal-Ferrer-
   Porti's own results assume nonelementary/irreducible holonomy throughout);
   this has not been explicitly checked along the path for m006 specifically.

Given these, [Structural] is the appropriate tag: the mechanism is sound and
concretely applied with a definite, checkable answer, but a from-scratch
formal proof at the standard of `reproduce/stage2_invariance_proof.md` has
not been completed.
