"""
Batch-test further structural hypotheses for recovering |e_a(w)| from
T_w(t), using the cached length<=10 trace data
(m003_traces_len10_cache.json) so no trace recomputation is needed.
"""

import json
import sys
from collections import defaultdict

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

t = sp.symbols("t")

with open("m003_traces_len10_cache.json") as f:
    data = json.load(f)

words = data["words"]
ea_signed = {w: int(v) for w, v in data["ea"].items()}
ea = {w: abs(v) for w, v in ea_signed.items()}
laurent_raw = data["laurent"]


def to_expr(w):
    terms = laurent_raw[w]
    return sum(sp.Rational(sp.sympify(c)) * t**int(e) for e, c in terms)


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


exprs = {w: to_expr(w) for w in words}

# ==========================================================================
banner("A. number of terms (sparsity) vs |e_a|")
by_nterms = defaultdict(set)
for w in words:
    nterms = len(laurent_raw[w])
    by_nterms[nterms].add(ea[w])
n_ok = sum(1 for w in words if len(set(ea[x] for x in words if len(laurent_raw[x]) == len(laurent_raw[w]))) == 1)
bad = {k: v for k, v in by_nterms.items() if len(v) > 1}
print(f"  nterms values mapping to multiple |e_a|: {len(bad)}/{len(by_nterms)}")

# ==========================================================================
banner("B. T_w(1) and T_w(-1) (special points: y=1-t^2=0 there)")
vals1 = {w: exprs[w].subs(t, 1) for w in words}
valsm1 = {w: exprs[w].subs(t, -1) for w in words}
by_v1 = defaultdict(set)
for w in words:
    by_v1[vals1[w]].add(ea[w])
bad1 = {k: v for k, v in by_v1.items() if len(v) > 1}
print(f"  T_w(1) values mapping to multiple |e_a|: {len(bad1)}/{len(by_v1)}")
by_vm1 = defaultdict(set)
for w in words:
    by_vm1[valsm1[w]].add(ea[w])
badm1 = {k: v for k, v in by_vm1.items() if len(v) > 1}
print(f"  T_w(-1) values mapping to multiple |e_a|: {len(badm1)}/{len(by_vm1)}")
# combined
by_v1m1 = defaultdict(set)
for w in words:
    by_v1m1[(vals1[w], valsm1[w])].add(ea[w])
bad1m1 = {k: v for k, v in by_v1m1.items() if len(v) > 1}
print(f"  (T_w(1),T_w(-1)) pair mapping to multiple |e_a|: {len(bad1m1)}/{len(by_v1m1)}")

# ==========================================================================
banner("C. does T_w(t) relate to T_w(1/t) simply? (symmetric/antisymmetric check)")
n_sym, n_antisym, n_neither = 0, 0, 0
for w in words[:200]:  # sample first 200 for speed of this exploratory check
    e = exprs[w]
    e_inv = sp.cancel(sp.together(e.subs(t, 1/t)))
    if sp.expand(e_inv - e) == 0:
        n_sym += 1
    elif sp.expand(e_inv + e) == 0:
        n_antisym += 1
    else:
        n_neither += 1
print(f"  (sample of 200) T_w(1/t)==T_w(t): {n_sym}, ==-T_w(t): {n_antisym}, neither: {n_neither}")

# ==========================================================================
banner("D. signed e_a: does T_w(t) determine e_a(w) UP TO SIGN via T_w(1/t) vs T_v(t) matching?")
# i.e. is T_w(1/t) always equal to T_{w'}(t) for w' = the 'a-inverted' word?
# quick check: for words of length <=4, is T_w(1/t) equal to T_v(t) for some v with e_a(v)=-e_a(w)?
by_expr = defaultdict(list)
for w in words:
    by_expr[sp.srepr(exprs[w])].append(w)

expr_to_words = defaultdict(list)
for w in words:
    expr_to_words[sp.srepr(sp.expand(exprs[w]))].append(w)

matches, misses, no_match_at_all = 0, 0, 0
sample = [w for w in words if len(w) <= 6]
for w in sample:
    inv_expr = sp.expand(sp.cancel(sp.together(exprs[w].subs(t, 1/t))))
    key = sp.srepr(inv_expr)
    found_words = expr_to_words.get(key, [])
    if not found_words:
        no_match_at_all += 1
        continue
    if any(ea_signed[w2] == -ea_signed[w] for w2 in found_words):
        matches += 1
    else:
        misses += 1
print(f"  (sample len<=6, {len(sample)} words) T_w(1/t) matches some T_v(t) with e_a(v)=-e_a(w): "
      f"{matches} matches, {misses} misses, {no_match_at_all} no match to ANY word's trace at all")

# ==========================================================================
banner("E. degree of T_w in terms of (t - 1/t) or (t + 1/t) -- substitution check")
s = sp.symbols("s")
# try w = A (simplest, e_a=1): T_A = t. Does t = f(t+1/t) or f(t-1/t) for simple f? Not generally (t itself isn't symmetric).
# so this only makes sense for e_a-even or words with extra symmetry -- quick sanity print only
for w in ["A", "AB", "AAb", "AABB"]:
    print(f"  T_{w} = {exprs[w]}")

print("\nPY_EXIT=0")
