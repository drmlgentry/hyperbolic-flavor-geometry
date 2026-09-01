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
# polynomial qa. Disjointness from qa's other 9 roots is established by
# an EXACT counting argument (irreducibility over a characteristic-0
# field forces separability, so qa has exactly 10 distinct roots; the
# interval-Newton contraction certifies exactly 1 is in the box; the
# other 9 are therefore outside it, with no need to individually locate
# them) -- NOT by numerical distance to non-certified approximations of
# those other roots. (An earlier version of this script did use such a
# distance check via ComplexField(300).roots(); removed as a targeted
# fix, since it was never the proof-bearing step and introduced a
# non-certified method for a fact the counting argument already gives
# rigorously.)
# This is a substantial upgrade over algdep-based recognition (which
# carries no rigorous error bound at all) but it is still a NUMERICAL
# certificate, not a symbolic/exact algebraic proof that tr(rho(a)) is
# exactly a root of qa (that would need an exact identity on the
# character variety, in the spirit of the Q-001 computation). Reporting
# this distinction explicitly rather than blurring it.

import snappy
from sage.all import (PolynomialRing, QQ, ComplexIntervalField,
                       RealIntervalField)
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
print("STEP 5: disjointness from the other 9 roots -- by counting, not by")
print("individually certified enclosures (targeted fix, replacing the")
print("earlier ComplexField(300).roots()-based numerical distance check,")
print("which was never the proof-bearing step and used a non-certified")
print("method for a fact already implied rigorously by what STEP 4 proved)")
print("=" * 72)
# trace_interval was literally used to build 'box' (widened by an
# infinitesimal margin), so containment is by construction.
print("trace_interval was used (widened by 2^-%d) to construct the Newton box" % (BITS_PREC - 20))
print("directly, so trace_interval subset box by construction.")
print()
print("The disjointness argument, made explicit:")
print("  (1) qa is irreducible over Q (verified, Step 2) and Q has")
print("      characteristic 0, so qa is automatically SEPARABLE: an")
print("      irreducible polynomial sharing a repeated root with itself")
print("      would share a nonzero common factor with its own derivative,")
print("      contradicting irreducibility (the derivative cannot vanish")
print("      identically in characteristic 0 for a nonconstant polynomial).")
print("      Hence qa, having degree 10, has EXACTLY 10 DISTINCT complex roots.")
print("  (2) STEP 4's interval-Newton contraction rigorously certifies")
print("      that EXACTLY ONE of those 10 roots lies in box.")
print("  (3) By (1) and (2), the remaining 9 roots -- wherever they are --")
print("      are, by elementary counting, NOT in box. This requires no")
print("      numerical information about their locations at all.")
assert qa.degree() == 10
assert qa.is_squarefree()  # formal certificate of separability, exact, not numerical
print()
print("qa.degree() == 10:", qa.degree() == 10)
print("qa.is_squarefree() (exact, formal separability certificate):", qa.is_squarefree())
print()
print("UNIQUENESS CERTIFIED: exactly one qa root lies in the box containing")
print("the certified trace interval. Disjointness from the other 9 roots")
print("follows from uniqueness + separability + degree count, not from")
print("individual root enclosures.")

print()
print("=" * 72)
print("RESULT")
print("=" * 72)
print("PASS: tr(rho(a)) for M_CKM=m006(-5,2), computed via a CERTIFIED")
print("(interval-arithmetic, not algdep) holonomy representation, is proven")
print("via interval-Newton contraction to lie in a box containing EXACTLY")
print("ONE of qa(x)=p(-x)'s 10 distinct roots -- the other 9 are excluded")
print("from that box by an exact counting argument (irreducibility over a")
print("characteristic-0 field forces separability), not by numerical")
print("distance to non-certified approximations of them.")
print()
print("This is a substantial rigor upgrade over algdep-based recognition:")
print("an explicit, arbitrarily-improvable numerical certificate with a")
print("provable error bound, via interval Newton -- NOT yet a symbolic/exact")
print("algebraic proof that tr(rho(a)) is EXACTLY a root of qa (that would")
print("require an exact identity on the character variety, as in Q-001).")

output_summary = {
    'trace_interval': str(trace_interval),
    'qa': str(qa),
    'N_box': str(N_box),
    'contracted': contracted,
    'qa_degree': qa.degree(),
    'qa_squarefree': bool(qa.is_squarefree()),
}
log_text = str(output_summary)
h = hashlib.sha256(log_text.encode()).hexdigest()
print()
print("sha256 of summary:", h)
