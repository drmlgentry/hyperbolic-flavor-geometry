# fourway_ramification_check.py
#
# ORIENTATION FOR A NEW READER: this is the script that proves the headline
# "576 theorem" -- CLAIMS_REGISTER.md entry 15, "The 576-Element Breakthrough"
# (Substack, Aug 22 2026): the compositum of all four HFG cusp fields is
# Galois over Q with group C2xS4xC2xS3, order 576, abstractly isomorphic to
# Weyl(SU(2))xWeyl(SU(4))xWeyl(SU(2))xWeyl(SU(3)) -- the complete Pati-Salam-
# plus-color Weyl group. See also entries 16-17 for the follow-on Stage 1/2
# work (canonical Frobenius/coset selectors) that this result made possible.
#
# Verifies the ramification-disjointness argument for the four-field Galois
# closure question, following the reasoning: if the individual closures
# L1,L2,L3,L4 are Galois over Q with pairwise disjoint ramified-prime sets,
# any nontrivial intersection between them would be unramified everywhere,
# hence trivial (Minkowski) -- giving joint linear disjointness and
# Gal(L1L2L3L4/Q) = Z/2 x S4 x Z/2 x S3, order 576, WITHOUT needing the
# expensive degree-48 closure computation directly.
#
# This is a genuinely different, much cheaper computation: closures of the
# individual degree-4 (S4) and degree-3 (S3) fields, not the degree-48
# compositum.

import time
from sage.all import QQ, NumberField

R = QQ['x']

print("=== Stage 1: field discriminants (already established this session) ===", flush=True)
K1 = NumberField(R([1, -1, 1]), 'a1')          # m003, disc -3
K2 = NumberField(R([-1, -1, 0, 0, 1]), 'a2')   # m019, disc -283
K3 = NumberField(R([2, -1, 1]), 'a3')          # m010, disc -7
K4 = NumberField(R([1, 2, 0, 1]), 'a4')        # m006 cusped, disc -59

for name, K in [("K1/m003", K1), ("K2/m019", K2), ("K3/m010", K3), ("K4/m006", K4)]:
    print(f"  {name}: degree {K.degree()}, disc {K.discriminant()}", flush=True)

print("\n=== Stage 2: individual Galois closures of K2, K4 (the non-Galois ones) ===", flush=True)
t0 = time.time()
L2 = K2.galois_closure('b')
print(f"  L2 (closure of K2): degree {L2.degree()} in {time.time()-t0:.1f}s", flush=True)

t0 = time.time()
L4 = K4.galois_closure('d')
print(f"  L4 (closure of K4): degree {L4.degree()} in {time.time()-t0:.1f}s", flush=True)

print("\n=== Stage 3: ramification check on the closures themselves ===", flush=True)
print(f"  L2 discriminant: {L2.discriminant()}", flush=True)
print(f"  L4 discriminant: {L4.discriminant()}", flush=True)

print("\n=== Stage 4: verify L2, L4 linearly disjoint (compositum degree = 144) ===", flush=True)
t0 = time.time()
comp = L2.composite_fields(L4)
degs = sorted(set(F.degree() for F in comp))
print(f"  L2.L4 composite_fields degrees: {degs} (expected 144) in {time.time()-t0:.1f}s", flush=True)

print("\n=== Stage 5: full 4-field compositum degree check (should already be known: 576) ===", flush=True)
L24 = [F for F in comp if F.degree() == 144][0] if 144 in degs else None
if L24 is not None:
    t0 = time.time()
    comp2 = L24.composite_fields(K1)
    degs2 = sorted(set(F.degree() for F in comp2))
    print(f"  L2L4.K1 degrees: {degs2} (expected 288) in {time.time()-t0:.1f}s", flush=True)
    if 288 in degs2:
        L241 = [F for F in comp2 if F.degree() == 288][0]
        t0 = time.time()
        comp3 = L241.composite_fields(K3)
        degs3 = sorted(set(F.degree() for F in comp3))
        print(f"  L2L4K1.K3 degrees: {degs3} (expected 576) in {time.time()-t0:.1f}s", flush=True)

print("\n=== DONE ===", flush=True)
