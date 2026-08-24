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

## UPDATE 2026-08-24 (later same day): RESOLVED EXACTLY

Followed the quotient-linear-algebra approach recommended above instead of
another Grobner basis. Using the already-computed M_x (from the minpoly
work) and a freshly built M_z (same construction, 37s), then M_u = M_z-M_x:

- On the full 440-dim A: M_u != 0, rank(M_u) = 420, M_u^2 != 0 (this is
  NOT the same question as below -- it's unrestricted, doesn't respect
  the q_10 factor, and isn't decisive by itself).
- The actual decisive computation: induced action of M_u on the quotient
  B = A/(q_10(x)*A) = A/im(q_10(M_x)) (an ideal quotient, NOT the kernel
  of q_10(M_x) -- these differ in general; first attempt at this got that
  wrong and was corrected).
  - rank(q_10(M_x)) = 420 exactly, so dim B = 440-420 = 20, confirmed
    exactly (matches the modular prediction).
  - M_u induced on B (via an explicit vector-space complement to
    im(q_10(M_x)), 20x20): M_u_B != 0, rank(M_u_B) = 10, and
    **M_u_B^2 == 0 exactly** -- confirmed by exact rational linear
    algebra, not modular reduction.

Status: RESOLVED (for this sub-question). B = A/(q_10(x)) is exactly
K[epsilon]/(epsilon^2) with epsilon = z-x, K the degree-10 field cut out
by q_10. The Fricke collapse z=x holds exactly on the reduced geometric
support at x0; z-x is a genuine order-2 nilpotent at the scheme level,
not literally zero there. This confirms modular evidence (4 primes,
GPT's parallel computation) with an exact computation over Q.

Total wall time for the corrected quotient approach once M_x was already
in hand: well under 2 minutes (37s to build M_z + ~80s for the q_10(M_x)
rank/complement/induced-matrix construction), vastly cheaper than the
killed J.groebner_basis() attempt (257 min, no result).
