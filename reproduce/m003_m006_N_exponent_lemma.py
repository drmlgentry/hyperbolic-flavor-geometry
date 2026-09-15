"""
Upgrades the empirical "1028/4851 pairs vanish on N" finding
(m003_m006_universal_line_N.py) to a fully general, proven lemma, and
corrects an overclaim in that script's stated conclusion.

LEMMA (proved below, not merely checked on the 99-word atlas). For
ANY two freely reduced words w, v in {a,A,b,B} (of any length),
    Delta_{w,v}(x,y,z) = tr(w) - tr(v)
vanishes identically on N = V(x-z, y-2) if and only if
    |e_a(w)| = |e_a(v)|,
where e_a(word) is the total signed a-exponent (#a - #A).

PROOF. tr(w) is given, for every word w, by a UNIVERSAL Fricke
polynomial P_w(x,y,z) -- a fact independent of which SL2
representation realizes a given (x,y,z), following from the
Cayley-Hamilton recursion alone. So P_w(x,2,x) can be computed by
evaluating tr(rho(w)) under ANY representation rho landing at
(x,y,z)=(x,2,x). Take rho: a |-> a matrix with trace x, b |-> I.
This representation manifestly has y=tr(rho(b))=tr(I)=2 and
z=tr(rho(ab))=tr(rho(a))=x, i.e. it lands exactly on N. Under rho,
every b and B letter contributes the identity matrix, so
rho(w) = rho(a)^{e_a(w)} for every word w, giving
    P_w(x,2,x) = tr(rho(a)^{e_a(w)}) = s_{|e_a(w)|}(x),
where s_n(x) = tr(A^n) is the standard SL2 trace-power (Chebyshev-
type) sequence, s_0=2, s_1=x, s_n = x s_{n-1} - s_{n-2} (from
Cayley-Hamilton A^2=xA-I), using tr(A^{-n})=tr(A^n). The s_n have
strictly increasing degree n in x (leading coefficient 1), so they
are pairwise distinct polynomials for distinct n>=0. Hence
Delta_{w,v}|_N = s_{|e_a(w)|} - s_{|e_a(v)|} = 0 iff |e_a(w)|=|e_a(v)|.
QED.

This explains (not just documents) why N appeared independently in
both m003's and m006's atlas-collision ideals: bounded-length
collisions happen to preferentially involve pairs with matching total
a-exponent, and ANY such pair is automatically N-vanishing by this
lemma -- with no reference to either manifold's relator.

CORRECTION to m003_m006_universal_line_N.py's stated conclusion: that
script's closing claim ("a component-generating pair, if one exists,
needs words longer than 6 letters") overstates what was proved. The
computation there established only that no subset of the TESTED
99-word/length<=6 atlas collisions can generate I(X_0) -- not that
longer words would escape I(N). Given the lemma above, the corrected,
sharper open question is:

    Does EVERY genuine X_0-collision (Delta in I(X_0), Delta != 0),
    at ANY word length, necessarily satisfy |e_a(w)|=|e_a(v)|
    (hence automatically lie in I(N))?

If yes, N is a PERMANENT structural obstruction to recovering I(X_0)
from word-trace equalities at any length, not a bounded-atlas
artifact. This is NOT resolved here -- verified only that no
counterexample exists among the length-<=6 atlas (this script re-
confirms the lemma exactly on that atlas), and a light spot-check at
length 7-8 is included as a first (still not exhaustive) look beyond
the frozen protocol.
"""

import csv
import itertools
import sys

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u = sp.symbols("x y z u")

A = sp.Matrix([[x, -1], [1, 0]])
uinv = -z - u
B = sp.Matrix([[0, -u], [uinv, y]])
I2 = sp.eye(2)


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET_REL = sp.Poly(u**2 + z * u + 1, u)


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


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


def net_exp(word, ch):
    return sum(1 for c in word if c == ch) - sum(1 for c in word if c == ch.upper())


# ==========================================================================
banner("1. the trace-power sequence s_n = tr(a^n)")
s = {0: sp.Integer(2), 1: x}
for n in range(2, 12):
    s[n] = sp.expand(x * s[n - 1] - s[n - 2])
for n in range(8):
    print(f"  s_{n} = {s[n]}")
print("  degrees strictly increasing (0,1,2,...) => pairwise distinct polynomials")

# ==========================================================================
banner("2. exact closed form tr(w)|_N = s_{|e_a(w)|}: verified on all 99 atlas words")

words_meta = {}
with open("m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        if row["filling"] == "m003(cusp)":
            words_meta[row["word"]] = int(row["exp_a"])
assert len(words_meta) == 99
trxyz = {wd: tr_xyz(wd) for wd in words_meta}

n_ok = 0
for wd, ea in words_meta.items():
    restricted = sp.expand(trxyz[wd].subs({z: x, y: 2}))
    predicted = s[abs(ea)]
    if sp.expand(restricted - predicted) == 0:
        n_ok += 1
print(f"  matches: {n_ok}/99 (this is a consequence of the general proof above,")
print(f"  not an independent empirical fact -- included as a concrete check)")

# ==========================================================================
banner("3. re-derive the 1028/4851 count from the lemma, cross-check against direct computation")

words = list(words_meta)
from collections import Counter
by_abs_ea = Counter(abs(words_meta[wd]) for wd in words)
predicted_pairs = sum(c * (c - 1) // 2 for c in by_abs_ea.values())
print(f"  |e_a| value counts: {dict(sorted(by_abs_ea.items()))}")
print(f"  predicted N-vanishing pair count from the lemma "
      f"(sum of C(count,2) per |e_a| value): {predicted_pairs}")

direct_count = 0
for w1, w2 in itertools.combinations(words, 2):
    d = sp.expand(trxyz[w1] - trxyz[w2])
    if sp.expand(d.subs({z: x, y: 2})) == 0:
        direct_count += 1
print(f"  direct computation (as in m003_m006_universal_line_N.py): {direct_count}")
print(f"  match: {predicted_pairs == direct_count == 1028}")

# ==========================================================================
banner("4. light spot-check beyond the frozen length-6 atlas (NOT exhaustive)")

extra_words = ["aaaaaaa", "aaaaaab", "aabbbbb", "abababa", "aabbaabb"]
for wd in extra_words:
    ea = net_exp(wd, "a")
    tr = tr_xyz(wd)
    restricted = sp.expand(tr.subs({z: x, y: 2}))
    predicted = s[abs(ea)]
    print(f"  {wd:10s} (len {len(wd)}, e_a={ea}): tr|_N == s_{{|e_a|}}: "
          f"{sp.expand(restricted - predicted) == 0}")
print("  (this only re-confirms the general lemma on a few longer words; it")
print("   does NOT test whether longer-word X_0-collisions with mismatched")
print("   |e_a| exist -- that open question is not addressed by this script.)")

print("\nPY_EXIT=0")
