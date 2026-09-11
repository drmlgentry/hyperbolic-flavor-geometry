"""
Does m006 have a "universal identity" like m003?

m003's Theorem (Universal identities) found three word-pairs with
tr(w) = tr(w') identically on X_0(m003) = G_m. This script runs the
same exact scan on X_0(m006) = A^1 - {1,-1} (established in
m006_x0_identity_origin.py), reusing the SAME Fricke trace polynomials
as m003_stage5_laurent_word_structure.py -- the trace polynomial
tr(w)(x,y,z) for a word w in the generic 2x2 Fricke chart is a
manifold-independent SL2 identity; only the substitution
Phi:(x,y,z)->(function of t) differs between the two manifolds. The
99-word atlas universe (freely+cyclically reduced words through
length 6, mod rotation+inversion, no proper powers) is likewise
manifold-independent, so the frozen m003 word list is reused directly
(word combinatorics only, no m003-specific data).

Phi_m006 : (x,y,z) -> (t, 1/(t^2-1), t)   [z=x=t, y=1/(t^2-1)]
ker Phi_m006 = I(X_0(m006)) = <y*z^2-y-1, x-z>  (m006_x0_identity_origin.py)

Same honesty discipline as Stage 5: report the exact collision census,
then run the SAME control test (shape-matched arbitrary substitutions)
before concluding anything about whether the collision density is
meaningful.
"""

import csv
import sys
from collections import defaultdict
from math import comb

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


# ---- word universe: reused from m003 (manifold-independent combinatorics) --
words_meta = {}
with open("m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        if row["filling"] == "m003(cusp)":
            words_meta[row["word"]] = {
                "exp_a": int(row["exp_a"]),
                "exp_b": int(row["exp_b"]),
                "length": int(row["length_letters"]),
            }
assert len(words_meta) == 99

banner("1. Phi_m006(tr(w)) for all 99 words: exact rational-function support")

PARAM_M006 = {x: t, y: 1 / (t**2 - 1), z: t}

results = {}
for w in sorted(words_meta, key=lambda s: (words_meta[s]["length"], s)):
    p_xyz = tr_xyz(w)
    val = sp.cancel(sp.together(p_xyz.subs(PARAM_M006)))
    results[w] = val

for w, v in results.items():
    m = words_meta[w]
    print(f"  {w:8s} len={m['length']}  (n_a,n_b)=({m['exp_a']:+d},{m['exp_b']:+d})  "
          f"Phi(tr)={v}")

banner("2. collisions: distinct words sharing the EXACT same Phi_m006(tr(w))")

by_poly = defaultdict(list)
for w, v in results.items():
    by_poly[sp.srepr(v)].append(w)
classes = len(by_poly)
collisions = {k: v for k, v in by_poly.items() if len(v) > 1}
print(f"  {len(words_meta)} words -> {classes} distinct classes, "
      f"{len(collisions)} collision groups")
for k, ws in sorted(collisions.items(), key=lambda kv: -len(kv[1])):
    print(f"    {sorted(ws)}  ->  {results[ws[0]]}")

banner("3. is there an m006 analogue of m003's THREE universal pairs?")

if not collisions:
    print("  NO collisions at all among the 99-word universe: no m006")
    print("  analogue of m003's universal identities exists at this word")
    print("  length bound.")
else:
    print(f"  {len(collisions)} collision group(s) found (listed above). Each is")
    print("  an EXACT identity tr(w)=tr(w') on X_0(m006), certified via the")
    print("  same Phi_m006 whose kernel is I(X_0(m006)).")

banner("4. control test: is this collision count generic to a rank-1 cut?")


def collision_summary(param):
    seen = {}
    for w in words_meta:
        p = tr_xyz(w)
        val = sp.cancel(sp.together(p.subs(param)))
        key = sp.srepr(val)
        seen.setdefault(key, []).append(w)
    groups = {k: v for k, v in seen.items() if len(v) > 1}
    return len(seen), len(groups), max((len(v) for v in groups.values()), default=1)


controls = [
    ("X_0(m006) itself: y=1/(t^2-1), z=t", {y: 1 / (t**2 - 1), z: t}),
    ("X_0(m003): y=1-t^2, z=-1/t", {y: 1 - t**2, z: -1 / t}),
    ("control A: generic line y=t, z=t", {y: t, z: t}),
    ("control B: generic line y=t+1, z=t-1", {y: t + 1, z: t - 1}),
    ("control C: same shape, y=1/(t^2-4), z=t", {y: 1 / (t**2 - 4), z: t}),
    ("control D: same shape, y=1/(t^2-1), z=2*t", {y: 1 / (t**2 - 1), z: 2 * t}),
    ("control E: same shape, y=1/(t^2+1), z=t", {y: 1 / (t**2 + 1), z: t}),
]
for label, sub in controls:
    full_sub = {x: t, **sub}
    classes_, ngroups, maxgroup = collision_summary(full_sub)
    print(f"  {label:38s}: {classes_:2d} classes, {ngroups:2d} groups, "
          f"largest group = {maxgroup}")

print()
print("  X_0(m003) is reproduced here as a cross-check (should read 58/25/4,")
print("  matching m003_stage5_laurent_word_structure.log exactly).")

print("\nPY_EXIT=0")
