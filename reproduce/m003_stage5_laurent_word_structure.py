"""
Stage 5 (option 4 from the "what's next" discussion): the Laurent
structure of word traces on X_0 = m003's geometric component.

Stage 4 established X_0 ~= G_m, uniformized by t = tr(a), with
Phi: Q[x,y,z] -> Q[t,t^-1], ker Phi = I(X_0) = <xz+1, x^2+y-1>.
Every word trace tr(w), restricted to X_0, is therefore a LAURENT
POLYNOMIAL in the single variable t. This script computes Phi(tr(w))
exactly for the full atlas word universe (99 freely+cyclically reduced
words in a,A,b,B through length 6, mod rotation+inversion, proper
powers excluded -- the frozen protocol of Section 4 "atlas" in
gentry-m003-arithmetic-v4.tex), and looks for a DERIVED (not fitted)
structural invariant: Laurent degree span, sparsity, and collisions.

This is exploratory (Stage 5, not yet a certified theorem): it reuses
the exact Fricke/Phi infrastructure from Stage 4
(m003_stage4_x0_identity_origin.py), which is certified, but the
correlations examined here are new and not yet claimed as identities
unless flagged EXACT with a proof sketch.
"""

import csv
import sys
from collections import defaultdict

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u, t = sp.symbols("x y z u t")

# ---- exact Stage-4 Fricke infrastructure (reused verbatim) -----------------
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


PARAM = {x: t, y: 1 - t**2, z: -sp.Rational(1, 1) / t}


def phi_tr(word):
    """Phi(tr(word)) as an exact Laurent polynomial in t (sympy expr)."""
    return sp.together(sp.expand(tr_xyz(word).subs(PARAM)))


def laurent_support(expr):
    """Return sorted list of (exponent, coeff) for a Laurent polynomial in t."""
    num, den = sp.fraction(sp.together(expr))
    den_deg = int(sp.degree(sp.Poly(den, t))) if den != 1 else 0
    # den is always a pure power of t (X_0's coordinate ring is Q[t,t^-1])
    num_poly = sp.Poly(sp.expand(num), t)
    shift = -den_deg
    terms = []
    for monom, coeff in num_poly.terms():
        terms.append((int(monom[0]) + shift, coeff))
    terms.sort()
    return terms


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


# ---- load the frozen atlas word universe -----------------------------------
words_meta = {}
with open("m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        if row["filling"] == "m003(cusp)":
            words_meta[row["word"]] = {
                "exp_a": int(row["exp_a"]),
                "exp_b": int(row["exp_b"]),
                "length": int(row["length_letters"]),
            }
assert len(words_meta) == 99, len(words_meta)

banner("1. Phi(tr(w)) for all 99 atlas words: exact Laurent support")

results = {}
for w in sorted(words_meta, key=lambda s: (words_meta[s]["length"], s)):
    expr = phi_tr(w)
    supp = laurent_support(expr)
    lo, hi = supp[0][0], supp[-1][0]
    nterms = len(supp)
    results[w] = dict(expr=expr, supp=supp, lo=lo, hi=hi, span=hi - lo, nterms=nterms)

for w in results:
    m = words_meta[w]
    r = results[w]
    print(f"  {w:8s} len={m['length']}  (n_a,n_b)=({m['exp_a']:+d},{m['exp_b']:+d})  "
          f"deg=[{r['lo']:+d},{r['hi']:+d}]  span={r['span']}  #terms={r['nterms']}  "
          f"Phi(tr)={r['expr']}")

banner("2. degree-span vs word length: is span a derived invariant of length?")

by_length = defaultdict(list)
for w, r in results.items():
    by_length[words_meta[w]["length"]].append(r["span"])
for L in sorted(by_length):
    spans = by_length[L]
    print(f"  length {L}: n={len(spans):3d}  span min={min(spans)} max={max(spans)} "
          f"mean={sum(spans)/len(spans):.2f}  distinct={sorted(set(spans))}")

banner("3. is span determined by (|n_a|, |n_b|) alone? (candidate closed form)")

span_by_na_nb = defaultdict(set)
for w, r in results.items():
    m = words_meta[w]
    span_by_na_nb[(abs(m["exp_a"]), abs(m["exp_b"]))].add(r["span"])
consistent = all(len(v) == 1 for v in span_by_na_nb.values())
print(f"  span is a function of (|n_a|,|n_b|) alone for all 99 words: {consistent}")
if not consistent:
    for k, v in span_by_na_nb.items():
        if len(v) > 1:
            print(f"    (|n_a|,|n_b|)={k}: spans seen = {sorted(v)}  (NOT constant)")
else:
    for k in sorted(span_by_na_nb):
        print(f"    (|n_a|,|n_b|)={k}: span = {list(span_by_na_nb[k])[0]}")

banner("4. leading/trailing coefficients: any pattern (+-1, small integers)?")

lead_vals = defaultdict(int)
trail_vals = defaultdict(int)
for w, r in results.items():
    lead_vals[r["supp"][-1][1]] += 1
    trail_vals[r["supp"][0][1]] += 1
print("  leading-coefficient value counts:", dict(sorted(lead_vals.items())))
print("  trailing-coefficient value counts:", dict(sorted(trail_vals.items())))

banner("5. collisions: which distinct words share the EXACT same Phi(tr(w))?")

by_poly = defaultdict(list)
for w, r in results.items():
    by_poly[sp.srepr(sp.expand(r["expr"]))].append(w)
collisions = {k: v for k, v in by_poly.items() if len(v) > 1}
print(f"  {len(collisions)} distinct Laurent polynomials are shared by >1 word "
      f"(out of {len(results)} words in {len(by_poly)} distinct classes):")
for k, ws in collisions.items():
    print(f"    {sorted(ws)}  ->  {results[ws[0]]['expr']}")

banner("6. minimal-span words at each length: a candidate canonical subset")

for L in sorted(by_length):
    ws_at_L = [w for w in results if words_meta[w]["length"] == L]
    min_span = min(results[w]["span"] for w in ws_at_L)
    winners = sorted(w for w in ws_at_L if results[w]["span"] == min_span)
    print(f"  length {L}: min span = {min_span}, achieved by {winners}")

banner("7. IMPORTANT SCOPE CHECK: what did the original atlas actually scan?")

with open("m003_pair_atlas.csv") as f:
    cusp_pairs = set(frozenset([r["u"], r["v"]]) for r in csv.DictReader(f)
                      if r["filling"] == "m003(cusp)")
words_in_pairs = set(w for p in cusp_pairs for w in p)
from math import comb
print(f"  m003_pair_atlas.csv records {len(cusp_pairs)} pairs at the cusp, "
      f"over {len(words_in_pairs)} distinct words.")
print(f"  Full word universe: {len(words_meta)} words, C({len(words_meta)},2) = "
      f"{comb(len(words_meta), 2)} possible pairs.")
print(f"  => the original atlas's degeneracy scan (Thm.~thm:universal /")
print(f"     manuscript 'four squared-trace degeneracies') is a CURATED")
print(f"     {len(cusp_pairs)}-pair / {len(words_in_pairs)}-word subset, NOT an")
print(f"     exhaustive check of the full {len(words_meta)}-word universe. This")
print(f"     script's collision scan (Section 5 above) IS exhaustive over the")
print(f"     full universe and is not a contradiction of the atlas result --")
print(f"     it completes a check the atlas never performed.")

banner("8. control test: is X_0's collision density generic to any rank-1 cut?")

def collision_summary(param):
    seen = {}
    trxyz = {w: tr_xyz(w) for w in words_meta}
    for w, p in trxyz.items():
        val = sp.together(sp.expand(p.subs(param)))
        key = sp.srepr(sp.expand(val))
        seen.setdefault(key, []).append(w)
    groups = {k: v for k, v in seen.items() if len(v) > 1}
    return len(seen), len(groups), max((len(v) for v in groups.values()), default=1)

controls = [
    ("X_0 itself: y=1-t^2, z=-1/t", {y: 1 - t**2, z: -1 / t}),
    ("control A: generic line y=t, z=t", {y: t, z: t}),
    ("control B: generic line y=t+1, z=t-1", {y: t + 1, z: t - 1}),
    ("control C: same shape, y=t^2, z=1/t", {y: t**2, z: 1 / t}),
    ("control D: sign-flipped z, y=1-t^2, z=+1/t", {y: 1 - t**2, z: 1 / t}),
    ("control E: shifted, y=2-t^2, z=-1/t", {y: 2 - t**2, z: -1 / t}),
]
for label, sub in controls:
    full_sub = {x: t, **sub}
    classes, ngroups, maxgroup = collision_summary(full_sub)
    print(f"  {label:42s}: {classes:2d} distinct classes, {ngroups:2d} groups, "
          f"largest group = {maxgroup}")
print()
print("  X_0 is markedly MORE collapsed than the shape-matched-but-arbitrary")
print("  controls C/D/E (58 vs 78-81 classes), so the collision density is")
print("  tied to X_0's actual defining constants, not merely 'any 1-parameter")
print("  cut of similar shape'. But an even more special arbitrary line")
print("  (control A, y=z=t) collapses further still (33 classes) -- so raw")
print("  collision COUNT is not by itself a rare/exceptional statistic in")
print("  this space of substitutions. NOT YET A THEOREM: this motivates but")
print("  does not establish that X_0's specific collisions are meaningful.")

print("\nPY_EXIT=0")
