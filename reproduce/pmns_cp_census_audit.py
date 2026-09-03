"""
Census-wide PMNS mixing-fit and CP-phase significance audit.

Test A (historical replication): freeze the historical word triple
{aa,aaB,baa} and ask whether m003(-2,3) is unusual among the 134
manifolds with H1=Z/5 (data/h1z5_manifold_list.json, already committed
this session) -- same construction, same words, applied uniformly.

Generator-basis convention: SnapPy's DEFAULT polished_holonomy() (no
fundamental_group_args), applied UNIFORMLY to every manifold. This is
NOT claimed to be geometrically canonical -- the invariance audit
(pmns_cp_invariance_audit.sage) showed there is no obviously canonical
choice, and this default happens to be the one that reproduces the
manuscript's own m003 values exactly. Using it uniformly means this
census tests "is the ACTUAL computation the paper did exceptional
across controls" -- the most directly relevant question given what is
already known, not a claim that this basis is the right one in any
deeper sense.

PMNS statistic: F_M = Nelder-Mead-optimized Borel fitness vs PDG PMNS,
same as hfg_reproduce.py's pmns_borel, applied to each census manifold.

CP statistic: d_CP(M) = circular distance between delta_M = (pi +
phi_M(aaB) + phi_M(baa)) mod 360 and the PDG value 197.0 deg (as stated
in the manuscript).

This is the "historical replication" test (Test A/B in the framework,
words NOT re-searched per manifold) -- cheap, feasible, and the correct
first step. The "full-selection null" (re-searching words per manifold)
is a separate, much more expensive test not attempted here.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import json
import time
import numpy as np
from scipy.linalg import qr
from scipy.optimize import minimize
import snappy

from hfg_reproduce import get_axis, PMNS_PDG, PERMS

CENSUS_PATH = "/mnt/c/dev/hyperbolic-flavor-geometry/data/h1z5_manifold_list.json"
PDG_DELTA_CP_DEG = 197.0
WORDS = ["aa", "aaB", "baa"]


def fit_pmns(M):
    rho = M.polished_holonomy()
    axes = [get_axis(rho, w) for w in WORDS]
    if any(a is None for a in axes):
        return None
    d12 = float(np.dot(axes[0], axes[1]))
    d13 = float(np.dot(axes[0], axes[2]))
    d23 = float(np.dot(axes[1], axes[2]))

    def f(p):
        Lm = np.array([[1., 0., 0.], [p[0], 1., 0.], [p[1], p[2], 1.]])
        Q, _ = qr(Lm)
        Qabs = np.abs(Q)
        return min(float(np.linalg.norm(Qabs[:, list(perm)] - PMNS_PDG, 'fro'))
                   for perm in PERMS)

    best = float('inf')
    for x0 in [[d12, d13, d23], [-d12, -d13, d23], [-1, -1, 1], [-2, -2, 1]]:
        res = minimize(f, x0, method='Nelder-Mead',
                        options={'xatol': 1e-10, 'fatol': 1e-10, 'maxiter': 50000})
        if res.fun < best:
            best = res.fun
    return best


def phi_of(mat):
    ev = np.linalg.eigvals(mat)
    ev_sorted = sorted(ev, key=lambda e: -abs(e))
    lam = ev_sorted[0]
    return float(np.angle(lam) * 180.0 / np.pi)


def cp_delta(M):
    rho = M.polished_holonomy()
    try:
        MaaB = np.array(rho("aaB"), dtype=complex)
        Mbaa = np.array(rho("baa"), dtype=complex)
    except Exception:
        return None
    phi_aaB = phi_of(MaaB)
    phi_baa = phi_of(Mbaa)
    delta = 180.0 + phi_aaB + phi_baa
    delta_mod = delta - 360.0 * np.floor(delta / 360.0)
    return delta_mod


def circular_dist(a_deg, b_deg):
    d = abs(a_deg - b_deg) % 360.0
    return min(d, 360.0 - d)


census = json.load(open(CENSUS_PATH))
print("=" * 70)
print("CENSUS-WIDE PMNS + CP SIGNIFICANCE AUDIT")
print("=" * 70)
print("N manifolds in H1=Z/5 census:", len(census))
print("word triple (frozen, historical, not re-searched):", WORDS)
print("PDG delta_CP target:", PDG_DELTA_CP_DEG, "deg")
print()

results = []
t0 = time.time()
n_fail = 0
for i, entry in enumerate(census):
    name = entry["full_name"]
    try:
        M = snappy.Manifold(name)
        f_pmns = fit_pmns(M)
        delta = cp_delta(M)
        d_cp = circular_dist(delta, PDG_DELTA_CP_DEG) if delta is not None else None
        results.append({"name": name, "census_index": entry["census_index"],
                         "F_pmns": f_pmns, "delta_CP": delta, "d_CP": d_cp})
    except Exception as e:
        n_fail += 1
        results.append({"name": name, "census_index": entry["census_index"],
                         "F_pmns": None, "delta_CP": None, "d_CP": None,
                         "error": str(e)})
    if (i + 1) % 20 == 0:
        print(f"  {i+1}/{len(census)} done, {time.time()-t0:.1f}s elapsed")

print()
print("failures:", n_fail, "/", len(census))

valid = [r for r in results if r["F_pmns"] is not None]
valid_cp = [r for r in results if r["d_CP"] is not None]
print("valid PMNS fits:", len(valid))
print("valid CP computations:", len(valid_cp))

m003_row = [r for r in results if r["name"] == "m003(-2,3)"]
assert len(m003_row) == 1
m003_row = m003_row[0]
print()
print("m003(-2,3) row:", m003_row)

F_m003 = m003_row["F_pmns"]
d_m003 = m003_row["d_CP"]

rank_pmns = 1 + sum(1 for r in valid if r["F_pmns"] < F_m003 and r["name"] != "m003(-2,3)")
rank_cp = (1 + sum(1 for r in valid_cp if r["d_CP"] < d_m003 and r["name"] != "m003(-2,3)")
           if d_m003 is not None else None)

print()
print("=" * 70)
print("RESULTS")
print("=" * 70)
print(f"PMNS: F_m003 = {F_m003:.6f}, rank = {rank_pmns} / {len(valid)}")
print(f"CP:   delta_m003 = {d_m003.__class__ and m003_row['delta_CP']}, "
      f"d_CP(m003) = {d_m003}, rank = {rank_cp} / {len(valid_cp)}")

all_F = sorted(r["F_pmns"] for r in valid)
print()
print("PMNS fitness distribution: min={:.6f} p10={:.6f} median={:.6f} p90={:.6f} max={:.6f}".format(
    all_F[0], all_F[len(all_F)//10], all_F[len(all_F)//2],
    all_F[int(len(all_F)*0.9)], all_F[-1]))

all_d = sorted(r["d_CP"] for r in valid_cp)
print("CP distance distribution: min={:.4f} p10={:.4f} median={:.4f} p90={:.4f} max={:.4f}".format(
    all_d[0], all_d[len(all_d)//10], all_d[len(all_d)//2],
    all_d[int(len(all_d)*0.9)], all_d[-1]))

with open("/mnt/c/dev/hyperbolic-flavor-geometry/reproduce/pmns_cp_census_results.json", "w") as f:
    json.dump(results, f, indent=2, default=str)

print()
print("wall time: %.1f sec" % (time.time() - t0))
print("EXIT=0")
