# Task 2, first computation: does either raw holonomy generator a or b
# swap the two branch vertices M0,M1 at pbar, or do both preserve them?
# This determines eps: Gamma_009 -> C2 on generators.
#
# NOTE: the existing pipeline (get_conjugated_exact_matrices) only ever
# computed WORDS 'aa','bb','ab','ba' as exact K-matrices, never the raw
# single generators a,b. That's a real gap for this specific question:
# eps(aa)=eps(bb)=0 automatically (squares), and eps(ab)=eps(ba)=
# eps(a) XOR eps(b) only gives the XOR, not the individual values -- NOT
# enough to distinguish "both trivial" from "both swap". So this script
# first attempts to identify the RAW generators a,b as exact K-matrices
# (same beta-rescaling convention as the existing pipeline) before
# anything else. If that fails (entries need a bigger field), that
# itself is reported honestly rather than falling back to the
# insufficient word-based proxy.

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector)

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
CCf = ComplexField(300)


def exact_K_element(numval, label, verbose=True):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        if verbose:
            print(f"  WARNING: {label} does not fit degree<=2 (got {dep})")
        return None
    if dep.degree() == 1:
        return K(-dep[0] / dep[1])
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        if verbose:
            print(f"  WARNING: {label} poly {dep} has no roots in K")
        return None
    best, best_err = None, None
    for r, mult in roots:
        err = abs(CCf(r) - numval)
        if best_err is None or err < best_err:
            best_err, best = err, r
    return best


print("Loading m009 holonomy...")
M = snappy.Manifold('m009')
G = M.polished_holonomy(bits_prec=300)
words_needed = ['aa', 'bb', 'ab', 'ba', 'a', 'b']
raw = {wd: G.SL2C(wd) for wd in words_needed}
beta = CCf(raw['aa'][0, 1])
print("beta (fixed rescaling factor, from 'aa'[0,1]):", beta)

print()
print("=" * 70)
print("Attempt to identify RAW generators a, b as exact K-matrices")
print("(same beta-rescaling convention as 'aa','bb','ab','ba')")
print("=" * 70)

exact_mats = {}
raw_ok = {}
for wd in words_needed:
    m = raw[wd]
    a_, b_, c_, d_ = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
    new_b, new_c = beta * b_, c_ / beta
    ea = exact_K_element(a_, f"{wd}[0,0]", verbose=(wd in ('a', 'b')))
    eb = exact_K_element(new_b, f"{wd}[0,1]", verbose=(wd in ('a', 'b')))
    ec = exact_K_element(new_c, f"{wd}[1,0]", verbose=(wd in ('a', 'b')))
    ed = exact_K_element(d_, f"{wd}[1,1]", verbose=(wd in ('a', 'b')))
    ok = all(v is not None for v in (ea, eb, ec, ed))
    raw_ok[wd] = ok
    if ok:
        exact_mats[wd] = Matrix(K, [[ea, eb], [ec, ed]])
        print(f"  {wd}: identified exactly in K.")
    else:
        print(f"  {wd}: FAILED to identify in K (degree>2 or no root) -- see warnings above.")

print()
print("Raw generators a,b landed in K:", raw_ok.get('a'), raw_ok.get('b'))
