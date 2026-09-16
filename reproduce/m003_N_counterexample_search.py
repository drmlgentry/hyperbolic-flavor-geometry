"""
Extended counterexample search for the conjecture

    Delta_{w,v} in I(X_0)  ==>?  Delta_{w,v} in I(N)     (equivalently |e_a(w)|=|e_a(v)|)

pushed past the frozen length-<=6/99-word atlas, per the agreed attack
order: extended exact counterexample search first (aggressive, no
physical target, purely mathematical falsification), structural proof
attempt only if it survives.

Word universe: freely + cyclically reduced words in {a,A,b,B} of
length 1..L, quotiented by cyclic rotation AND inversion (w ~ w^-1,
since tr(w)=tr(w^-1) always in SL2 -- quotienting avoids trivial
double-counting), proper powers excluded. Regenerated from scratch
here (not reusing m003_word_atlas.csv) and cross-checked to reproduce
exactly 99 classes at L<=6 as a sanity gate before trusting the
extension.

Method: hash-based collision search (not O(n^2) pairwise) on the exact
restricted trace tau_w(t) in Q[t,t^-1] (m003's X_0), canonicalized via
sympy's exact rational-function simplification, keyed by a hashable
exact representation. For every collision class found, check whether
all members share the same |e_a|; report any mismatch as an immediate,
decisive counterexample.
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
    """min over all cyclic rotations of w and of w^{-1}."""
    n = len(w)
    rotations = [w[i:] + w[:i] for i in range(n)]
    wi = word_inverse(w)
    rotations += [wi[i:] + wi[:i] for i in range(n)]
    return min(rotations)


def gen_words(max_len):
    """freely+cyclically reduced words, length 1..max_len, canonical
    reps only (dedup by rotation+inversion), proper powers excluded."""
    seen = set()
    result = []
    alphabet = "aAbB"
    for n in range(1, max_len + 1):
        for tup in product(alphabet, repeat=n):
            w = "".join(tup)
            # freely reduced (no adjacent cancellation)
            if any((w[i], w[i + 1]) in CANCELS for i in range(n - 1)):
                continue
            # cyclically reduced (first/last not inverse, for n>1)
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


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


# ==========================================================================
banner("0. sanity gate: regenerated word universe must match the frozen atlas at L<=6")

words6 = gen_words(6)
print(f"  regenerated word classes at length <= 6: {len(words6)}  (frozen atlas: 99)")
assert len(words6) == 99, "word generator does not match the frozen atlas protocol!"
print("  MATCH -- generator trusted for extension past length 6.")

# ==========================================================================
banner("1. extend to length <= 8, compute exact restricted traces on X_0(m003)")

MAXLEN = 10
t0 = time.time()
words = gen_words(MAXLEN)
print(f"  {len(words)} word classes at length <= {MAXLEN} (generation: {time.time()-t0:.1f}s)")

PARAM3 = {x: t, y: 1 - t**2, z: -1 / t}

t0 = time.time()
restricted = {}
ea = {}
for w in words:
    p = tr_xyz(w)
    val = sp.cancel(sp.together(p.subs(PARAM3)))
    restricted[w] = val
    ea[w] = abs(net_exp(w, "a"))
print(f"  computed all restricted traces in {time.time()-t0:.1f}s")

# ==========================================================================
banner("2. hash-based collision search + immediate |e_a| mismatch check")

by_val = defaultdict(list)
for w, val in restricted.items():
    key = sp.srepr(val)
    by_val[key].append(w)

groups = [sorted(v) for v in by_val.values() if len(v) > 1]
print(f"  {len(words)} words -> {len(by_val)} distinct trace classes, "
      f"{len(groups)} collision groups")

counterexamples = []
for grp in groups:
    eas = set(ea[w] for w in grp)
    if len(eas) > 1:
        counterexamples.append((grp, eas))

print(f"\n  COUNTEREXAMPLES (mismatched |e_a| within a collision class): "
      f"{len(counterexamples)}")
for grp, eas in counterexamples:
    print(f"    {grp}  |e_a| values: {eas}")

if not counterexamples:
    print("  NONE FOUND. The conjecture survives the extension to length <= "
          f"{MAXLEN} ({len(words)} words, {len(groups)} collision groups checked).")

# breakdown by word length for context
from collections import Counter
len_counts = Counter(len(w) for w in words)
print(f"\n  word classes by length: {dict(sorted(len_counts.items()))}")

print("\nPY_EXIT=0")
