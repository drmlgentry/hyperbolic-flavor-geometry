"""
Like-for-like comparison of the collision-certificate structure of m003 and
m006, using the IDENTICAL pipeline for both manifolds:

  word universe   : same 4692 word classes (length <= 10), manifold-independent
  collision group : words with equal restricted trace on X_0(manifold)
  ambient class   : words with literally equal tr_xyz polynomial
  genuine pair    : star pair (rep of class 1, rep of class i), Delta != 0
  trichotomy      : Delta in <g_a> alone / <g_b> alone / neither (principal-ideal
                    membership; single generators are Groebner bases in any order)

Reported at word-length bounds L = 6 (the old 99-word atlas scale) and L = 10,
both at PAIR level and GROUP level (a group is 'needs both' if any of its
star pairs is), so that the earlier m006 group-level 8/11/9 census
(reproduce/m006_collision_certificates.py) can be cross-checked and the
unit mismatch with the m003 pair-level census (1316 pairs) is removed.

Also tests, for each manifold, J_L <= P_0 cap I(N) (Delta vanishing on
N = V(x-z, y-2)).
"""

import json
import os
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


def tr_xyz(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    tr = sp.expand(M.trace())
    _, r = sp.div(sp.Poly(tr, u), DET_REL, u)
    r = sp.expand(r.as_expr())
    assert sp.Poly(r, u).degree() <= 0
    return sp.expand(r)


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78, flush=True)


banner("0. load words; ensure raw tr_xyz for ALL 4692 words")
with open("m003_traces_len10_cache.json") as f:
    words = json.load(f)["words"]
with open("m003_collision_words_trxyz_cache.json") as f:
    cached = json.load(f)
trxyz = {w: sp.expand(sp.sympify(v)) for w, v in cached.items()}
missing = [w for w in words if w not in trxyz]
print(f"  {len(words)} words; {len(trxyz)} cached; computing {len(missing)} missing")
t0 = time.time()
for w in missing:
    trxyz[w] = tr_xyz(w)
print(f"  done in {time.time()-t0:.1f}s")
poly_key = {w: sp.srepr(trxyz[w]) for w in words}

MANIFOLDS = {
    "m003": dict(
        param={x: t, y: 1 - t**2, z: -1 / t},
        ga=x * z + 1,
        gb=x**2 + y - 1,
        names=("(xz+1)", "(x^2+y-1)"),
    ),
    "m006": dict(
        param={x: t, y: 1 / (t**2 - 1), z: t},
        ga=x - z,
        gb=y * z**2 - y - 1,
        names=("(x-z)", "(yz^2-y-1)"),
    ),
}

N_SUBS = {z: x, y: 2}


def analyse(name, cfg, maxlen):
    ga, gb = cfg["ga"], cfg["gb"]
    GB = sp.groebner([ga, gb], x, y, z, order="grevlex")
    # restricted traces on X_0 for words of length <= maxlen, grouped
    by_val = defaultdict(list)
    for w in words:
        if len(w) > maxlen:
            continue
        val = sp.cancel(sp.together(trxyz[w].subs(cfg["param"])))
        by_val[sp.srepr(val)].append(w)
    groups = [sorted(v, key=lambda w: (len(w), w)) for v in by_val.values() if len(v) > 1]
    pure_amb = 0
    pair_a = pair_b = pair_both = 0
    grp_a = grp_b = grp_both = 0
    n_pairs = 0
    not_in_ideal = 0
    not_on_N = 0
    for grp in groups:
        classes = defaultdict(list)
        for w in grp:
            classes[poly_key[w]].append(w)
        reps = [c[0] for c in classes.values()]
        if len(reps) == 1:
            pure_amb += 1
            continue
        w0 = reps[0]
        kinds = []
        for v in reps[1:]:
            D = sp.expand(trxyz[w0] - trxyz[v])
            n_pairs += 1
            _, r = sp.reduced(D, list(GB.exprs), x, y, z, order="grevlex")
            if sp.expand(r) != 0:
                not_in_ideal += 1
            if sp.expand(D.subs(N_SUBS)) != 0:
                not_on_N += 1
            in_a = sp.expand(sp.reduced(D, [ga], x, y, z)[1]) == 0
            in_b = sp.expand(sp.reduced(D, [gb], x, y, z)[1]) == 0
            if in_a:
                pair_a += 1
                kinds.append("a")
            elif in_b:
                pair_b += 1
                kinds.append("b")
            else:
                pair_both += 1
                kinds.append("both")
        if "both" in kinds:
            grp_both += 1
        elif "b" in kinds and "a" not in kinds:
            grp_b += 1
        elif "a" in kinds and "b" not in kinds:
            grp_a += 1
        else:
            grp_a += 0  # mixture of a-only and b-only, no 'both': counted below
    mixed = len(groups) - pure_amb - grp_a - grp_b - grp_both
    return dict(
        n_groups=len(groups), pure_amb=pure_amb, n_pairs=n_pairs,
        pair_a=pair_a, pair_b=pair_b, pair_both=pair_both,
        grp_a=grp_a, grp_b=grp_b, grp_both=grp_both, grp_mixed_ab=mixed,
        not_in_ideal=not_in_ideal, not_on_N=not_on_N,
    )


results = {}
for L in (6, 10):
    for name, cfg in MANIFOLDS.items():
        banner(f"{name}, word length <= {L}")
        t0 = time.time()
        r = analyse(name, cfg, L)
        results[(name, L)] = r
        na, nb = cfg["names"]
        print(f"  collision groups: {r['n_groups']}  (purely ambient: {r['pure_amb']}, "
              f"genuine: {r['n_groups'] - r['pure_amb']})")
        print(f"  genuine star pairs: {r['n_pairs']}  "
              f"(Delta not in P_0: {r['not_in_ideal']} ; Delta not vanishing on N: {r['not_on_N']})")
        tot = max(r["n_pairs"], 1)
        print(f"  PAIR level : only {na}: {r['pair_a']} ({100*r['pair_a']/tot:.1f}%) | "
              f"only {nb}: {r['pair_b']} ({100*r['pair_b']/tot:.1f}%) | "
              f"needs both: {r['pair_both']} ({100*r['pair_both']/tot:.1f}%)")
        ng = max(r["n_groups"] - r["pure_amb"], 1)
        print(f"  GROUP level: only {na}: {r['grp_a']} | only {nb}: {r['grp_b']} | "
              f"needs both (any pair): {r['grp_both']} | mixed a-only/b-only: {r['grp_mixed_ab']}"
              f"   [needs-both share of genuine groups: {100*r['grp_both']/ng:.1f}%]")
        print(f"  ({time.time()-t0:.0f}s)")

banner("summary table")
print(f"{'manifold':8s} {'L':>3s} {'groups':>6s} {'ambient':>7s} {'genuine':>7s} "
      f"{'pairs':>6s} {'pair-both%':>10s} {'grp-both/genuine':>17s}")
for (name, L), r in results.items():
    gen = r["n_groups"] - r["pure_amb"]
    pb = 100 * r["pair_both"] / max(r["n_pairs"], 1)
    print(f"{name:8s} {L:3d} {r['n_groups']:6d} {r['pure_amb']:7d} {gen:7d} "
          f"{r['n_pairs']:6d} {pb:9.1f}% {r['grp_both']:>8d}/{gen:<8d}")

print("\nPY_EXIT=0")
