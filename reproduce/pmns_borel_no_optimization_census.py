"""
Census-wide test of the NO-FREE-PARAMETER Borel construction from
hyperbolic-flavor-scan/archive/scans/pmns_borel_scan_v2.py:
L[i,j] = axis_i . axis_j directly (real geodesic data, no Nelder-Mead
optimization at all), then QR. Unlike pmns_borel's free fit, there is
no tunable slack, so if this ALSO turns out manifold-independent, it is
a separate and more surprising structural fact worth establishing
properly rather than judging from a 4-manifold sample.

Run across the full 134-manifold H1=Z/5 census, words up to length 3
(matching pmns_borel_scan_v2.py's own default --max-len 3), excluding
trivially parallel-axis triples (|dot|>0.9999, which trivially gives a
manifold-independent all-ones-type L regardless of geometry).

v2: word list capped at MAX_WORDS per manifold (some census manifolds
have larger presentations than m003's 2-generator one, and the triple
loop is cubic in word-list size -- uncapped, a single manifold with a
bigger presentation can dominate runtime unboundedly, which is exactly
what stalled the first attempt at this run for ~4 hours wall-clock with
no visible progress). Also flushes progress per manifold so it can
actually be monitored.
"""
import os
os.environ.setdefault("OPENBLAS_NUM_THREADS", "1")
os.environ.setdefault("OMP_NUM_THREADS", "1")
os.environ.setdefault("MKL_NUM_THREADS", "1")
os.environ.setdefault("NUMEXPR_NUM_THREADS", "1")

import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import json
import time
import numpy as np
from scipy.linalg import qr, logm
from itertools import permutations, product as iproduct
import snappy

CENSUS_PATH = "/mnt/c/dev/hyperbolic-flavor-geometry/data/h1z5_manifold_list.json"
PMNS_TARGET = np.array([
    [0.821, 0.550, 0.148],
    [0.357, 0.339, 0.871],
    [0.442, 0.762, 0.471],
])
PERMS = list(permutations([0, 1, 2]))
MAX_WORDS = 60  # cap word-list size per manifold -- bounds the O(n^3) triple loop


def to_numpy(m):
    return np.array([[complex(m[i, j]) for j in range(2)] for i in range(2)])


def fitness(U):
    best = 1e9
    for perm in PERMS:
        best = min(best, float(np.linalg.norm(U[:, perm] - PMNS_TARGET, 'fro')))
    return best


def axis_from_matrix(M):
    try:
        L = logm(M)
    except Exception:
        return None
    nx = (L[0, 1].real + L[1, 0].real) / 2
    ny = (L[1, 0].imag - L[0, 1].imag) / 2
    nz = (L[0, 0].real - L[1, 1].real) / 2
    n = np.array([nx, ny, nz])
    nm = np.linalg.norm(n)
    return n / nm if nm > 1e-10 else None


def borel_to_unitary(n1, n2, n3, scale=1.0):
    axes = [n1, n2, n3]
    L = np.zeros((3, 3))
    for i in range(3):
        for j in range(i + 1):
            L[i, j] = np.dot(axes[i], axes[j])
    L = L * scale
    if abs(np.linalg.det(L)) < 1e-10:
        return None
    Q, R = qr(L.T)
    signs = np.diag(np.sign(np.diag(R)))
    U = Q @ signs
    return np.abs(U)


def scan(name, max_len=3):
    M = snappy.Manifold(name)
    G = M.fundamental_group()
    base_gens = [g for g in G.generators() if g.islower()]
    all_gens = base_gens + [g.upper() for g in base_gens]
    inv = {g: g.upper() if g.islower() else g.lower() for g in all_gens}
    words = []
    for length in range(1, max_len + 1):
        for w in iproduct(all_gens, repeat=length):
            ok = all(w[i] != inv.get(w[i + 1], "___") for i in range(len(w) - 1))
            if ok:
                words.append("".join(w))

    truncated = False
    if len(words) > MAX_WORDS:
        words = words[:MAX_WORDS]
        truncated = True

    axes = {}
    for w in words:
        try:
            m = to_numpy(G.SL2C(w))
            n = axis_from_matrix(m)
            if n is not None:
                axes[w] = n
        except Exception:
            pass

    word_list = list(axes.keys())
    best_f = 1e9
    best_triple = None
    for w1 in word_list:
        for w2 in word_list:
            for w3 in word_list:
                n1, n2, n3 = axes[w1], axes[w2], axes[w3]
                d12 = abs(np.dot(n1, n2))
                d13 = abs(np.dot(n1, n3))
                d23 = abs(np.dot(n2, n3))
                if d12 >= 0.9999 or d13 >= 0.9999 or d23 >= 0.9999:
                    continue
                U = borel_to_unitary(n1, n2, n3)
                if U is None:
                    continue
                f = fitness(U)
                if f < best_f:
                    best_f = f
                    best_triple = (w1, w2, w3)
    return best_f, best_triple, len(word_list), truncated


census = json.load(open(CENSUS_PATH))
print("N manifolds:", len(census), flush=True)
results = []
t0 = time.time()
n_fail = 0
for i, entry in enumerate(census):
    name = entry["full_name"]
    tm0 = time.time()
    try:
        best_f, triple, nwords, truncated = scan(name, max_len=3)
        results.append({"name": name, "census_index": entry["census_index"],
                         "best_f": best_f, "triple": triple, "nwords": nwords,
                         "truncated": truncated})
        print(f"  [{i+1}/{len(census)}] {name:15s} nwords={nwords:3d} "
              f"trunc={truncated}  best_f={best_f:.5f}  "
              f"({time.time()-tm0:.1f}s, total {time.time()-t0:.1f}s)", flush=True)
    except Exception as e:
        n_fail += 1
        results.append({"name": name, "census_index": entry["census_index"],
                         "best_f": None, "error": str(e)})
        print(f"  [{i+1}/{len(census)}] {name:15s} FAILED: {e}", flush=True)

print("failures:", n_fail, "/", len(census), flush=True)
valid = [r for r in results if r.get("best_f") is not None]
print("valid:", len(valid), flush=True)

m003_row = [r for r in results if r["name"] == "m003(-2,3)"][0]
print("m003(-2,3) row:", m003_row, flush=True)

vals = sorted(r["best_f"] for r in valid)
print("distribution: min={:.6f} p10={:.6f} median={:.6f} p90={:.6f} max={:.6f}".format(
    vals[0], vals[len(vals)//10], vals[len(vals)//2], vals[int(len(vals)*0.9)], vals[-1]), flush=True)
n_tied_at_min = sum(1 for v in vals if abs(v - vals[0]) < 1e-6)
print(f"number of manifolds tied at the global min (within 1e-6): {n_tied_at_min} / {len(vals)}", flush=True)

F_m003 = m003_row["best_f"]
rank = 1 + sum(1 for r in valid if r["best_f"] < F_m003 and r["name"] != "m003(-2,3)")
print(f"m003 rank: {rank} / {len(valid)}  (F_m003={F_m003:.6f})", flush=True)

with open("/mnt/c/dev/hyperbolic-flavor-geometry/reproduce/pmns_borel_no_optimization_census_results.json", "w") as f:
    json.dump(results, f, indent=2, default=str)

print("wall time: %.1f sec" % (time.time() - t0), flush=True)
print("EXIT=0", flush=True)
