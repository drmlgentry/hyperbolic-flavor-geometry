"""
Fixed historical triple W0=(aa,ab,aB), column permutation (0,2,1), no
optimization, no word reselection, no search of any kind -- evaluated
identically on every H1=Z/5 census manifold. Records c12,c13,c23 and
F_geom (dot-product Borel construction, matching pmns_borel_scan_v2.py's
own borel_to_unitary) so real manifold-to-manifold variation (or lack of
it) in the RAW inputs is visible, not just the final fitness number.

Caveat, stated up front: 'aa','ab','aB' are presentation-dependent
words. This is a historical marked-presentation control, not yet a
presentation-invariant statement about any manifold other than m003.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import json
import numpy as np
from scipy.linalg import qr, logm
from itertools import permutations
import snappy

CENSUS_PATH = "/mnt/c/dev/hyperbolic-flavor-geometry/data/h1z5_manifold_list.json"
PMNS_TARGET = np.array([
    [0.821, 0.550, 0.148],
    [0.357, 0.339, 0.871],
    [0.442, 0.762, 0.471],
])
WORDS = ["aa", "ab", "aB"]
PERM = [0, 2, 1]  # historically frozen permutation


def to_numpy(m):
    return np.array([[complex(m[i, j]) for j in range(2)] for i in range(2)])


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


def evaluate(name):
    M = snappy.Manifold(name)
    G = M.fundamental_group()
    axes = {}
    for w in WORDS:
        try:
            m = to_numpy(G.SL2C(w))
            n = axis_from_matrix(m)
            axes[w] = n
        except Exception:
            axes[w] = None
    if any(axes[w] is None for w in WORDS):
        return None
    n1, n2, n3 = axes["aa"], axes["ab"], axes["aB"]
    c12 = float(np.dot(n1, n2))
    c13 = float(np.dot(n1, n3))
    c23 = float(np.dot(n2, n3))
    L = np.array([[1., 0., 0.], [c12, 1., 0.], [c13, c23, 1.]])
    Q, R = qr(L.T)
    signs = np.diag(np.sign(np.diag(R)))
    U = np.abs(Q @ signs)
    Uperm = U[:, PERM]
    F = float(np.linalg.norm(Uperm - PMNS_TARGET, 'fro'))
    return {"c12": c12, "c13": c13, "c23": c23, "F_geom": F, "U": Uperm.tolist()}


census = json.load(open(CENSUS_PATH))
print("N manifolds:", len(census))
results = []
n_fail = 0
for entry in census:
    name = entry["full_name"]
    try:
        r = evaluate(name)
        if r is None:
            n_fail += 1
            results.append({"name": name, "census_index": entry["census_index"], "error": "word undefined"})
        else:
            r["name"] = name
            r["census_index"] = entry["census_index"]
            results.append(r)
    except Exception as e:
        n_fail += 1
        results.append({"name": name, "census_index": entry["census_index"], "error": str(e)})

print("failures/undefined:", n_fail, "/", len(census))
valid = [r for r in results if "F_geom" in r]
print("valid:", len(valid))

m003_row = [r for r in results if r["name"] == "m003(-2,3)"][0]
print("m003(-2,3):", m003_row)

Fs = sorted(r["F_geom"] for r in valid)
print("F_geom distribution: min={:.6f} p10={:.6f} median={:.6f} p90={:.6f} max={:.6f}".format(
    Fs[0], Fs[len(Fs)//10], Fs[len(Fs)//2], Fs[int(len(Fs)*0.9)], Fs[-1]))
n_distinct = len(set(round(f, 6) for f in Fs))
print(f"number of DISTINCT F_geom values (rounded to 6dp): {n_distinct} / {len(Fs)}")

F_m003 = m003_row["F_geom"]
rank = 1 + sum(1 for r in valid if r["F_geom"] < F_m003 and r["name"] != "m003(-2,3)")
print(f"m003 rank: {rank} / {len(valid)}  (F_m003={F_m003:.6f})")

with open("/mnt/c/dev/hyperbolic-flavor-geometry/reproduce/pmns_fixed_triple_census_results.json", "w") as f:
    json.dump(results, f, indent=2, default=str)
print("EXIT=0")
