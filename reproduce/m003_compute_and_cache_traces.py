"""
Compute and cache T_w(t) = Phi(tau_w) for the full length-<=10 word
census (4692 words), so further structural-hypothesis tests can reuse
this data without repaying the ~9 minute trace computation each time.

Also checks the reducibility criterion kappa = x^2+y^2+z^2-xyz-4 on
X_0(m003) directly, to confirm there is no "b -> I" style degenerate
specialization available for X_0 (unlike N): X_0 should be a genuine
family of IRREDUCIBLE representations, kappa != 0 identically.

Output: reproduce/m003_traces_len10_cache.json
  {"words": [...], "ea": {word: int}, "laurent": {word: [[exp,coeff_str],...]}}
"""

import csv
import json
import sys
import time
from itertools import product

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u, t = sp.symbols("x y z u t")

A = sp.Matrix([[x, -1], [1, 0]])
uinv = -z - u
B = sp.Matrix([[0, -u], [uinv, y]])
I2 = sp.eye(2)


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET_REL = sp.Poly(u**2 + z * u + 1, u)

INV_LETTER = {"a": "A", "A": "a", "b": "B", "B": "b"}
CANCELS = {("a", "A"), ("A", "a"), ("b", "B"), ("B", "b")}


def word_inverse(w):
    return "".join(INV_LETTER[c] for c in reversed(w))


def is_proper_power(w):
    n = len(w)
    for d in range(1, n):
        if n % d == 0 and w == w[:d] * (n // d):
            return True
    return False


def canonical_class_rep(w):
    n = len(w)
    rotations = [w[i:] + w[:i] for i in range(n)]
    wi = word_inverse(w)
    rotations += [wi[i:] + wi[:i] for i in range(n)]
    return min(rotations)


def gen_words(max_len):
    seen = set()
    result = []
    alphabet = "aAbB"
    for n in range(1, max_len + 1):
        for tup in product(alphabet, repeat=n):
            w = "".join(tup)
            if any((w[i], w[i + 1]) in CANCELS for i in range(n - 1)):
                continue
            if n > 1 and (w[-1], w[0]) in CANCELS:
                continue
            if is_proper_power(w):
                continue
            rep = canonical_class_rep(w)
            if rep in seen:
                continue
            seen.add(rep)
            result.append(rep)
    return result


def word_matrix(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    return sp.expand(M)


def tr_xyz(word):
    tr = sp.expand(word_matrix(word).trace())
    _, r = sp.div(sp.Poly(tr, u), DET_REL, u)
    r = sp.expand(r.as_expr())
    assert sp.Poly(r, u).degree() <= 0, f"{word}: residual u term {r}"
    return sp.expand(r)


def net_exp(word, ch):
    return sum(1 for c in word if c == ch) - sum(1 for c in word if c == ch.upper())


def laurent_terms(expr):
    num, den = sp.fraction(sp.together(expr))
    den_deg = int(sp.degree(sp.Poly(den, t))) if den != 1 else 0
    num_poly = sp.Poly(sp.expand(num), t)
    terms = [(int(m[0]) - den_deg, c) for m, c in num_poly.terms()]
    terms.sort()
    return terms


print("=" * 78)
print("0. reducibility check: is X_0(m003) a family of reducible reps?")
print("=" * 78)
kappa = sp.expand(x**2 + y**2 + z**2 - x * y * z - 4)
PARAM3 = {x: t, y: 1 - t**2, z: -1 / t}
kappa_on_X0 = sp.cancel(sp.together(kappa.subs(PARAM3)))
print(f"  kappa = x^2+y^2+z^2-xyz-4, restricted to X_0: {kappa_on_X0}")
print(f"  identically zero (i.e. X_0 all-reducible)? {kappa_on_X0 == 0}")
print(f"  => X_0 is a genuine family of IRREDUCIBLE reps (generically);")
print(f"     no 'b -> I' style degenerate specialization is available here,")
print(f"     unlike N (which is exactly the b=I / y=2 locus).")

print("\n" + "=" * 78)
print("1. compute and cache T_w(t) for all length<=10 word classes")
print("=" * 78)
words6 = gen_words(6)
assert len(words6) == 99
t0 = time.time()
words = gen_words(10)
print(f"  {len(words)} word classes at length <= 10")

ea = {}
laurent = {}
for i, w in enumerate(words):
    p = tr_xyz(w)
    val = sp.cancel(sp.together(p.subs(PARAM3)))
    terms = laurent_terms(val)
    laurent[w] = [[e, str(c)] for e, c in terms]
    ea[w] = net_exp(w, "a")  # signed, not abs -- keep full info in the cache
    if (i + 1) % 1000 == 0:
        print(f"    ... {i+1}/{len(words)} done ({time.time()-t0:.0f}s elapsed)")
print(f"  done in {time.time()-t0:.1f}s")

with open("m003_traces_len10_cache.json", "w") as f:
    json.dump({"words": words, "ea": ea, "laurent": laurent}, f)
print(f"  cached to m003_traces_len10_cache.json")

print("\nPY_EXIT=0")
