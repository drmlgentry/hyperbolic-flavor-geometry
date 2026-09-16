"""
Structural attack on Delta_{w,v} in I(X_0) ==> Delta_{w,v} in I(N), for
m003, following up on m003_N_counterexample_search.py (verified zero
counterexamples through word length 10, 4692 words, 1087 collision
groups -- see that script/.log for the raw survival data).

Goal: find a functional E on T_w(t) = Phi(tr_w) in Q[t,t^-1] with
E(T_w) = |e_a(w)| exactly, using the asymptotic (Laurent) data at the
two punctures t=0, t=infinity of X_0(m003) = G_m:
    nu_0(T_w)   = order of the lowest-degree term (vanishing/pole at 0)
    lc_0(T_w)   = its coefficient
    nu_inf(T_w) = -(order of the highest-degree term) (pole order at infinity)
    lc_inf(T_w) = its coefficient
tested for whether this signature determines |e_a(w)| across the
SAME word universe already generated and verified in
m003_N_counterexample_search.py (regenerated here identically, with
the same sanity gate).

If a clean formula is found, we then try to derive it from the trace
recursion tr(UV) + tr(UV^{-1}) = tr(U) tr(V) (Fricke/Cayley-Hamilton),
which is the natural route to an actual proof rather than a fitted
pattern.
"""

import sys
import time
from collections import defaultdict
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
    """exact Laurent expansion: list of (exponent, coeff), sorted by exponent."""
    num, den = sp.fraction(sp.together(expr))
    den_deg = int(sp.degree(sp.Poly(den, t))) if den != 1 else 0
    num_poly = sp.Poly(sp.expand(num), t)
    terms = [(int(m[0]) - den_deg, c) for m, c in num_poly.terms()]
    terms.sort()
    return terms


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


MAXLEN = 10

banner("0. regenerate word universe (sanity-gated) and restricted traces")
words6 = gen_words(6)
assert len(words6) == 99, "generator mismatch!"
t0 = time.time()
words = gen_words(MAXLEN)
print(f"  {len(words)} word classes at length <= {MAXLEN}")

PARAM3 = {x: t, y: 1 - t**2, z: -1 / t}
restricted = {}
ea = {}
for w in words:
    p = tr_xyz(w)
    val = sp.cancel(sp.together(p.subs(PARAM3)))
    restricted[w] = val
    ea[w] = abs(net_exp(w, "a"))
print(f"  computed in {time.time()-t0:.1f}s")

banner("1. extract puncture signatures (nu_0, lc_0, nu_inf, lc_inf)")

sig = {}
for w, val in restricted.items():
    terms = laurent_terms(val)
    lo_exp, lo_c = terms[0]
    hi_exp, hi_c = terms[-1]
    sig[w] = (lo_exp, lo_c, -hi_exp, hi_c)  # (nu_0, lc_0, nu_inf, lc_inf)

banner("2. does (nu_0, lc_0, nu_inf, lc_inf) alone determine |e_a|?")

by_sig = defaultdict(set)
for w, s4 in sig.items():
    by_sig[s4].add(ea[w])
bad = {k: v for k, v in by_sig.items() if len(v) > 1}
print(f"  {len(by_sig)} distinct 4-tuples across {len(words)} words")
print(f"  4-tuples mapping to MULTIPLE |e_a| values: {len(bad)}")
for k, v in list(bad.items())[:10]:
    print(f"    sig={k} -> |e_a| values {v}")

banner("3. does the PAIR (nu_0, nu_inf) alone determine |e_a|? (drop coefficients)")
by_orders = defaultdict(set)
for w, (n0, l0, ninf, linf) in sig.items():
    by_orders[(n0, ninf)].add(ea[w])
bad2 = {k: v for k, v in by_orders.items() if len(v) > 1}
print(f"  {len(by_orders)} distinct (nu_0,nu_inf) pairs")
print(f"  pairs mapping to multiple |e_a|: {len(bad2)}")
for k, v in list(bad2.items())[:10]:
    print(f"    (nu_0,nu_inf)={k} -> |e_a| values {v}")

banner("4. simplest candidate: is |e_a| == max(|nu_0|, |nu_inf|) (again, now full census)?")
n_ok = sum(1 for w in words if max(abs(sig[w][0]), abs(sig[w][2])) == ea[w])
print(f"  matches: {n_ok}/{len(words)}")

banner("5. is |e_a| == (nu_inf - nu_0)/2, i.e. half the Laurent width?")
n_ok2 = 0
mismatch_examples = []
for w in words:
    n0, l0, ninf, linf = sig[w]
    width = ninf - (-n0)  # hi_exp - lo_exp effectively; let's just use span
for w in words:
    terms = laurent_terms(restricted[w])
    lo, hi = terms[0][0], terms[-1][0]
    width = hi - lo
    if width == 2 * ea[w]:
        n_ok2 += 1
    else:
        mismatch_examples.append((w, ea[w], width))
print(f"  width == 2*|e_a| matches: {n_ok2}/{len(words)}")
for w, aea, width in mismatch_examples[:10]:
    print(f"    {w}: |e_a|={aea}, width={width}")

banner("6. sample data for hand inspection: short words")
for w in sorted(words, key=lambda w: (len(w), w))[:20]:
    n0, l0, ninf, linf = sig[w]
    print(f"  {w:6s} len={len(w)} |e_a|={ea[w]}  nu_0={n0} lc_0={l0}  "
          f"nu_inf={ninf} lc_inf={linf}   T_w={restricted[w]}")

print("\nPY_EXIT=0")
