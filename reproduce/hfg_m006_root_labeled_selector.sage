#!/usr/bin/env sage
# hfg_m006_root_labeled_selector.sage
#
# Purpose:
#   1. Verify the three archimedean roots/embeddings of the m006 cusp cubic.
#   2. Match the oriented geometric cusp shape to the upper-half-plane root.
#   3. Check orientation reversal and peripheral-basis dependence.
#   4. Demonstrate why a rational-prime Frobenius is still only canonical
#      up to conjugacy, even after the archimedean roots are labeled.
#
# Run:
#   sage hfg_m006_root_labeled_selector.sage

import snappy
from sage.all import *

R.<x> = PolynomialRing(QQ)
f = x^3 + 2*x + 1

print("="*72)
print("m006 ROOT-LABELED S3 SELECTOR AUDIT")
print("="*72)

# ------------------------------------------------------------------
# 1. Exact number field and archimedean roots
# ------------------------------------------------------------------
print("\n[1] Cubic field")
print("canonical cusp polynomial f(x) =", f)
print("disc(f) =", f.discriminant())
print("irreducible =", f.is_irreducible())

CC200 = ComplexField(200)
roots = sorted(f.roots(CC200, multiplicities=False), key=lambda z: (abs(z.imag()) < 1e-40, z.imag()))

real_roots = [z for z in roots if abs(z.imag()) < CC200(1e-40)]
complex_roots = [z for z in roots if abs(z.imag()) >= CC200(1e-40)]

rR = real_roots[0]
rminus = min(complex_roots, key=lambda z: z.imag())
rplus  = max(complex_roots, key=lambda z: z.imag())

print("r_R =", rR)
print("r_+ =", rplus)
print("r_- =", rminus)
print("conjugacy check |r_- - conj(r_+)| =", abs(rminus - rplus.conjugate()))

# ------------------------------------------------------------------
# 2. Geometry: oriented cusp shape
# ------------------------------------------------------------------
print("\n[2] SnapPy oriented cusp shape")
M = snappy.Manifold('m006')
try:
    tau = M.cusp_info('shape')[0]
except Exception:
    tau = M.cusp_info()[0]['shape']

tauC = CC200(complex(tau))
print("SnapPy cusp shape tau =", tauC)

# Direct matching test against the three roots.
dists = {
    "r_R": abs(tauC-rR),
    "r_+": abs(tauC-rplus),
    "r_-": abs(tauC-rminus),
}
print("distance to roots:", dists)
best = min(dists, key=dists.get)
print("closest literal polynomial root =", best)

# If the literal cusp parameter is not itself the chosen polynomial generator,
# this will not be ~0. That is not a contradiction: cusp parameters transform
# under PSL(2,Z) changes of peripheral basis. The field embedding is the more
# invariant object.

# ------------------------------------------------------------------
# 3. Orientation reversal
# ------------------------------------------------------------------
print("\n[3] Orientation reversal")
Mr = M.copy()
try:
    Mr.reverse_orientation()
    try:
        tau_r = Mr.cusp_info('shape')[0]
    except Exception:
        tau_r = Mr.cusp_info()[0]['shape']
    tau_rC = CC200(complex(tau_r))
    print("reversed cusp shape =", tau_rC)
    print("|tau_rev - conj(tau)| =", abs(tau_rC - tauC.conjugate()))
except Exception as e:
    print("orientation-reversal check unavailable:", e)

# ------------------------------------------------------------------
# 4. Canonical archimedean labeling
# ------------------------------------------------------------------
print("\n[4] Candidate canonical embedding labels")
print("sigma_R : unique real embedding")
print("sigma_+ : complex embedding selected by manifold orientation (Im > 0)")
print("sigma_- : complex conjugate embedding")
print()
print("This gives a canonical ORDERED triple at the archimedean place,")
print("provided the manifold orientation and the relevant field generator/")
print("embedding have been fixed.")

# ------------------------------------------------------------------
# 5. Six S3 labels
# ------------------------------------------------------------------
print("\n[5] Six permutation labels relative to B=(sigma_+,sigma_R,sigma_-)")
S3 = SymmetricGroup(3)
labels = ["sigma_+", "sigma_R", "sigma_-"]
for g in S3:
    permuted = [labels[g(i+1)-1] for i in range(3)]
    print(f"{g}: {permuted}")

# ------------------------------------------------------------------
# 6. Frobenius ambiguity test
# ------------------------------------------------------------------
print("\n[6] Frobenius ambiguity")
print("For a rational prime p unramified in the S3 closure, Frob_p is")
print("canonical only as a CONJUGACY CLASS.")
print("Choosing an actual element Frob_P requires choosing a prime P above p.")
print("The oriented complex embedding does NOT canonically choose such a p-adic prime P.")
print()
print("Therefore:")
print("  archimedean root labeling: YES, geometry can distinguish R,+,-")
print("  canonical prime -> specific S3 element: NO, not from this data alone")
print("  six quark slots from Frobenius alone: NOT YET DERIVED")

# ------------------------------------------------------------------
# 7. What extra structure could close the gap?
# ------------------------------------------------------------------
print("\n[7] Required extra datum")
print("A successful six-slot selector needs a canonical non-class-function datum,")
print("for example one of:")
print("  * a geometry-selected prime ideal P|p in the normal closure;")
print("  * a canonical p-adic embedding tied to a geometric peripheral structure;")
print("  * a holonomy/root labeling that survives peripheral-basis changes;")
print("  * a second Z/2 orientation/chirality label combined with the 3 embeddings.")
print()
print("Without such a datum, any lift from a transposition conjugacy class")
print("to one of (12),(13),(23) is a choice, not a theorem.")
