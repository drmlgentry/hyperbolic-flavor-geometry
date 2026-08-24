# Q-001 status — 2026-08-24

`J.groebner_basis()` killed at ~257 min CPU time, no result produced.

Modular evidence (4 good primes: 1009, 1013, 1019, 1031, computed by GPT
in a parallel session, not independently re-verified here): dim(A/q) = 20,
rank(M_u) = 10 for u = z-x, and M_u^2 = 0 in every case — i.e.
(z-x)^2 = 0 in A/(q_10(x)) modulo each of these four primes.

The exact-over-Q version of this claim has not been confirmed. What has
been confirmed exactly (not modularly):
- N = dim_Q(R/I) = 440 (I.vector_space_dimension(), ~9.5s)
- The 440 standard monomials, minpoly(M_x) (degree 430, ~2.3hr), and its
  factorization into a degree-10 factor (multiplicity 3) and two degree-200
  factors (multiplicity 1 each) -- all exact, all saved (see
  q001_gpt_handoff.json, q001_Mx.sobj, q001_px.sobj, q001_px_factors.sobj)
- The degree-10 factor's root matches x0 to 4e-7 and is exactly m006(-5,2)'s
  own trace field polynomial (SnapPy), up to the sign substitution x -> -t

Next approach: quotient linear algebra directly, rather than a fresh
J.groebner_basis() computation. Build M_z - M_x as a 440x440 matrix
(multiplication operators already have a working construction pipeline --
see the M_x-building code used for the minpoly computation) and check
(M_z - M_x)^2 == 0 as an exact matrix identity over Q. This avoids a new
Grobner basis entirely and should be tractable given M_x alone took ~1
minute to build.

Status: Structural. (Numerically/modularly consistent with
B = A/(q_10) ≅ K[epsilon]/(epsilon^2), epsilon = z-x, i.e. the Fricke
collapse z=x holding on the reduced geometric support with a nilpotent
thickening at the scheme level -- but not yet confirmed by an exact
rational computation.)
