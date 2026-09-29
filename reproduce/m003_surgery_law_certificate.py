"""
m003_surgery_law_certificate.py
===============================
Exact check of Theorem 2.1 / Corollary 2.2 of the m003(-2,3) paper:
    |H_1(m003(p,q); Z)| = 5 |2p+q|,   H_1 = Z/5  iff  |2p+q| = 1.

Everything is integer arithmetic from the WORDS (no SnapPy, no floating point):
  r = abAAbabbb, mu = ABABB, lambda = ABAbab   (SnapPy presentation, as recorded in
  reproduce/pmns_itf_certificate.log line 11 and the peripheral words in that script).
  1. abelianize r, mu, lambda by counting letters;
  2. build the presentation matrix of H_1(m003(p,q)) on ([a],[b]) with rows
        r,   p*mu + q*lambda;
  3. symbolic determinant in Z[p,q] must equal 5(2p+q);
  4. for every coprime (p,q) with |p|,|q| <= N and 2p+q != 0, the Smith normal form
     (computed with sympy over ZZ) has |H_1| = 5|2p+q|, and H_1 is cyclic exactly
     when gcd of the entries is 1, which happens exactly when |2p+q| = 1 among
     the tested slopes  (so H_1 = Z/5 iff |2p+q| = 1).

NOTE: an empirical cross-check against SnapPy's own homology() on 14 slopes exists
(linking_form.py in the separate hyperbolic-flavor-scan directory); it is not part
of this certificate and was not re-run here (no SnapPy in this environment).

Exit status: 0 iff all assertions hold.
"""
import math
import sys

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form

R = "abAAbabbb"
MU = "ABABB"
LAM = "ABAbab"
N = 30


def exps(w):
    return (w.count("a") - w.count("A"), w.count("b") - w.count("B"))


ok = True


def check(label, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + label)
    ok &= bool(cond)


p, q = sp.symbols("p q")
er, em, el = exps(R), exps(MU), exps(LAM)
print("exponent vectors  r:", er, " mu:", em, " lambda:", el)
check("exp(r) = (0,5)", er == (0, 5))
check("exp(mu) = (-2,-3)", em == (-2, -3))
check("exp(lambda) = (-1,1)", el == (-1, 1))

M = sp.Matrix([[er[0], er[1]],
               [p * em[0] + q * el[0], p * em[1] + q * el[1]]])
print("presentation matrix:", M.tolist())
check("det = 5(2p+q) identically in Z[p,q]", sp.expand(M.det() - 5 * (2 * p + q)) == 0)

bad = []
tested = 0
for pp in range(-N, N + 1):
    for qq in range(-N, N + 1):
        if math.gcd(abs(pp), abs(qq)) != 1 or 2 * pp + qq == 0:
            continue
        Mn = sp.Matrix([[er[0], er[1]],
                        [pp * em[0] + qq * el[0], pp * em[1] + qq * el[1]]])
        S = smith_normal_form(Mn, domain=sp.ZZ)
        d1, d2 = abs(S[0, 0]), abs(S[1, 1])
        order = d1 * d2
        cyclic = (d1 == 1)
        tested += 1
        if order != 5 * abs(2 * pp + qq):
            bad.append((pp, qq, order))
        # Z/5 exactly when |2p+q| = 1
        is_z5 = (order == 5 and cyclic)
        if is_z5 != (abs(2 * pp + qq) == 1):
            bad.append((pp, qq, "Z/5 criterion"))
print("slopes tested (coprime, |p|,|q| <= %d, 2p+q != 0):" % N, tested)
check("|H_1| = 5|2p+q| for every tested slope; H_1 = Z/5 iff |2p+q| = 1", not bad)
if bad:
    print("counterexamples:", bad[:10])

check("ray 2p+q = -1 contains (-2,3),(-3,5),(-4,7),(-5,9)",
      all(2 * a + b == -1 for a, b in [(-2, 3), (-3, 5), (-4, 7), (-5, 9)]))

print()
print("SURGERY-LAW CERTIFICATE:", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
