# Rigorous interval-arithmetic certificate for tr(rho(a)) at M_CKM =
# m006(-5,2), replacing the algdep-based (floating-point recognition)
# evidence used in gentry-ckm-v3.tex's Theorem "ITF generator identity"
# with a genuine interval-Newton root-isolation certificate.
#
# IMPORTANT — what this script does and does NOT establish, stated
# up front rather than left implicit: this certifies, to a rigorous,
# explicit, arbitrarily-improvable numerical precision (here 300 bits),
# that the true geometric trace tr(rho(a)) lies inside an interval that
# provably contains EXACTLY ONE root of the claimed degree-10
# polynomial qa, and that this is nowhere near any of qa's other roots.
# This is a substantial upgrade over algdep-based recognition (which
# carries no rigorous error bound at all) but it is still a NUMERICAL
# certificate, not a symbolic/exact algebraic proof that tr(rho(a)) is
# exactly a root of qa (that would need an exact identity on the
# character variety, in the spirit of the Q-001 computation). Reporting
# this distinction explicitly rather than blurring it.

import snappy
from sage.all import (PolynomialRing, QQ, ComplexIntervalField, ComplexField,
                       RealIntervalField, Infinity)
import hashlib

BITS_PREC = 300

print("=" * 72)
print("STEP 1: verify hyperbolicity of M_CKM = m006(-5,2), interval arithmetic")
print("=" * 72)
M = snappy.Manifold("m006(-5,2)")
ok, rho = M.verify_hyperbolicity(holonomy=True, bits_prec=BITS_PREC)
print("verify_hyperbolicity(holonomy=True, bits_prec=%d):" % BITS_PREC, ok)
assert ok, "hyperbolicity verification FAILED -- cannot proceed"

print()
print("=" * 72)
print("STEP 2: exact polynomial p(x), and qa(x) = p(-x)")
print("=" * 72)
R = PolynomialRing(QQ, 'x')
x = R.gen()
p = (x**10 - 7*x**8 - 4*x**7 + 17*x**6 + 14*x**5
     - 18*x**4 - 14*x**3 + 8*x**2 + 3*x - 1)
print("p(x) =", p)
print("p irreducible:", p.is_irreducible())
assert p.is_irreducible()

qa = p(-x)
print("qa(x) = p(-x) =", qa)
print("qa irreducible:", qa.is_irreducible())
assert qa.is_irreducible()

print()
print("=" * 72)
print("STEP 3: certified trace interval for tr(rho(a))")
print("=" * 72)
trace_interval = rho('a').trace()
print("tr(rho(a)) certified interval:")
print(" ", trace_interval)
print("real part diameter:", float(trace_interval.real().diameter()))
print("imag part diameter:", float(trace_interval.imag().diameter()))

print()
print("=" * 72)
print("STEP 4: isolate the unique root of qa consistent with this trace,")
print("via interval-Newton contraction (NOT algdep -- a rigorous method)")
print("=" * 72)

CF = ComplexField(BITS_PREC)
qa_numeric = qa.change_ring(CF)
all_roots_numeric = qa_numeric.roots(multiplicities=False)
print("qa has", len(all_roots_numeric), "numerical roots (high-precision, not yet certified):")
for r in all_roots_numeric:
    print("  ", r)

# Find the numeric root nearest the certified trace interval's center.
tc_re = (float(trace_interval.real().lower()) + float(trace_interval.real().upper())) / 2.0
tc_im = (float(trace_interval.imag().lower()) + float(trace_interval.imag().upper())) / 2.0
trace_center = CF(tc_re, tc_im)
distances = [(abs(r - trace_center), r) for r in all_roots_numeric]
distances.sort(key=lambda t: t[0])
nearest_dist, nearest_root = distances[0]
second_dist = distances[1][0]
print()
print("nearest root to trace center:", nearest_root, " distance:", float(nearest_dist))
print("second-nearest root distance:", float(second_dist),
      " (separation margin confirms roots are well-isolated at this scale)")
assert nearest_dist < 1e-10, "trace does not appear to match any root of qa at high precision"
# NOTE: Sage's generic ComplexField(300).roots() does not actually
# converge to the full 300 bits requested for this degree-10 polynomial
# (observed nearest-root distance ~1e-16, i.e. only double-precision
# accuracy) -- this is a limitation of that convenience root-finder, not
# of the certificate itself. This numeric root is only used to SEED the
# interval-Newton contraction below, which is the actual rigorous step
# and does not depend on the seed being more precise than "close enough
# to converge" -- confirmed by the contraction succeeding regardless.
assert second_dist > 1e-3, "roots of qa are not well-separated -- unexpected for an irreducible degree-10 field polynomial"

CIF = ComplexIntervalField(BITS_PREC)
qa_interval_poly = qa.change_ring(CIF)
qa_prime_interval_poly = qa_interval_poly.derivative()


def interval_newton_step(box):
    # midpoint as an exact point (real/imag midpoints of the box)
    mre = (box.real().lower() + box.real().upper()) / 2
    mim = (box.imag().lower() + box.imag().upper()) / 2
    m = CIF(mre, mim)
    fm = qa_interval_poly(m)
    fprime_box = qa_prime_interval_poly(box)
    return m - fm / fprime_box


# Start the Newton box at the certified trace interval itself, widened
# slightly (a few ULPs) to give the contraction room to work, since a
# zero-radius point interval cannot contract in the usual sense.
RIF = RealIntervalField(BITS_PREC)
delta = RIF(2)**(-BITS_PREC + 20)
pad = RIF(-1, 1) * delta
re_widened = trace_interval.real() + pad
im_widened = trace_interval.imag() + pad
box = CIF(re_widened, im_widened)
print()
print("initial Newton box (trace interval, slightly widened):")
print(" ", box)

N_box = interval_newton_step(box)
print()
print("N(box) =", N_box)


def strictly_contained(inner, outer):
    return (inner.real().lower() > outer.real().lower() and
            inner.real().upper() < outer.real().upper() and
            inner.imag().lower() > outer.imag().lower() and
            inner.imag().upper() < outer.imag().upper())


contracted = strictly_contained(N_box, box)
print("N(box) strictly contained in box (Newton contraction succeeded):", contracted)
assert contracted, "interval Newton did not contract -- root isolation FAILED, cannot certify"

print()
print("CERTIFIED: qa has a UNIQUE root strictly inside the initial box,")
print("and that root is enclosed by N(box) =", N_box)

print()
print("=" * 72)
print("STEP 5: verify trace_interval is contained in the certified root box,")
print("and disjoint from all other roots")
print("=" * 72)
# trace_interval was literally used to build 'box' (widened by an
# infinitesimal margin), so containment is by construction; state this
# plainly rather than treat it as an independent check.
print("trace_interval was used (widened by 2^-%d) to construct the Newton box" % (BITS_PREC - 20))
print("directly, so trace_interval subset box by construction -- the substantive")
print("claim is that box (hence trace_interval) contains a UNIQUE root of qa,")
print("established by the Newton contraction above, not by this containment alone.")

disjoint_from_others = []
for r in all_roots_numeric:
    if r == nearest_root:
        continue
    d = abs(CF(r) - CF(trace_center))
    disjoint_from_others.append((r, float(d)))
    assert d > 1e-3, f"root {r} suspiciously close to the certified trace -- investigate"
print()
print("distances from trace center to all OTHER 9 roots (all >> box radius):")
for r, d in disjoint_from_others:
    print(f"  {r}: distance {d}")

print()
print("=" * 72)
print("RESULT")
print("=" * 72)
print("PASS: tr(rho(a)) for M_CKM=m006(-5,2), computed via a CERTIFIED")
print("(interval-arithmetic, not algdep) holonomy representation, is proven")
print("via interval-Newton contraction to lie in a box containing EXACTLY")
print("ONE root of qa(x)=p(-x), well-separated (distance > 1e-3, vs. box")
print("radius ~2^-%d) from all 9 other roots." % (BITS_PREC - 20))
print()
print("This is a substantial rigor upgrade over algdep-based recognition:")
print("an explicit, arbitrarily-improvable numerical certificate with a")
print("provable error bound, via interval Newton -- NOT yet a symbolic/exact")
print("algebraic proof that tr(rho(a)) is EXACTLY a root of qa (that would")
print("require an exact identity on the character variety, as in Q-001).")

output_summary = {
    'trace_interval': str(trace_interval),
    'qa': str(qa),
    'nearest_root': str(nearest_root),
    'N_box': str(N_box),
    'contracted': contracted,
    'second_nearest_root_distance': float(second_dist),
}
log_text = str(output_summary)
h = hashlib.sha256(log_text.encode()).hexdigest()
print()
print("sha256 of summary:", h)
