# m003 Target-Free Invariant Atlas — protocol v1

## Scope

This atlas is designed to reveal structural regularities of the cusped manifold `m003` and selected Dehn fillings without using a PMNS target matrix or the historically selected PMNS word triple. It is an exploratory/computational atlas, not the exact invariant-trace-field certificate.

The PMNS source material distinguishes the cusped parent field from the closed filling field, but the current paper also contains an internally inconsistent Proposition 1 that still assigns Q(sqrt(-3)) to the closed filling. The atlas therefore keeps cusp and filling arithmetic separate.

## Frozen word universe

Enumerate freely reduced, cyclically reduced words in `a,A,b,B` through length 6; quotient by cyclic rotation and inverse; exclude proper powers of the cyclic word.

This is a canonical combinatorial quotient. It is not claimed to be a complete quotient by conjugacy in pi_1(m003), and the retained words are not called primitive group elements.

For every retained word record:
- exponent vector (n_a,n_b);
- for m003(-2,3), corrected homology class h = 3 n_a + n_b mod 5;
- tr rho(w);
- tr^2 rho(w), the primary PSL2-character observable;
- numerical complex length 2 arccosh(tr/2);
- twist angle;
- absolute trace.

No fit score is computed.

## Pair invariants

For the shorter word universe through length 4, record for every unordered pair:
- tr rho(uv);
- tr rho([u,v]);
- |tr^2 rho(u)-tr^2 rho(v)|.

These expose trace degeneracies and commutator strata without reference to flavor data.

## Control filling families

1. m003(-2,q), q = 3,5,7,9,11,13,15.
2. Corrected H1 = Z/5 Farey ray 2p+q=-1:
   (-2,3),(-3,5),(-4,7),(-5,9),(-6,11),(-7,13).

Hyperbolicity is checked at 300-bit precision before filled word data are accepted.

## Generator-basis gate

Earlier m003 calculations warn that surgery polynomials use cusped generators {a,b}, while a filled `polished_holonomy()` can use a different basis. The atlas fixes:

`fundamental_group_args = [True, False, True, False]`

with `fillings_may_affect_generators=False`, and aborts on generator-name drift.

A future stronger atlas should archive a full presentation/peripheral-word bridge for every filling, analogous to the CKM presentation/geometry bridge.

## Interpretation rules

A repeated equality or cluster is first labeled COMPUTED.

It can be promoted to EXACT only after a symbolic certificate proves it in the Riley/Fricke character algebra.

A pattern seen in a finite family is never called universal.

Apparent homology dependence must use the corrected classifier.

No historical PMNS word receives preferred status.

## Next stage after freezing the atlas

1. Partition by homology class, squared-trace equality, complex-length equality, and commutator-trace strata.
2. Search for degeneracy loci persistent across the H1=Z/5 Farey ray.
3. Derive exact trace-polynomial relations on the Riley surface
   z^2-z(xy-x-y)+(x^2+y^2-xy-1)=0
   for every robust numerical equality.
4. Only after hashes are frozen may a separate analysis ask where the historical Borel triple ranks structurally.

## Explicit non-goals

This atlas does not certify k_inv(m003(-2,3)), run algdep/PSLQ field recognition, evaluate a PMNS matrix, optimize Borel fitness, or claim prospective blindness in the current contaminated conversation.
