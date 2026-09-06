"""
Attempt to recover the historical generator convention used by the
March 2026 paper draft for words {aa,ab,aB} on m003(-2,3), whose axis
dot products were reported (via lambda=1, signs=+,-,+) as approximately
(0.443, -0.530, 0.432).

Tries all 16 boolean fundamental_group_args combinations, plus the
plain default (no args), computing the actual dot products each time
and checking closeness to the target.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import numpy as np
from scipy.linalg import logm
from itertools import product
import snappy

TARGET = np.array([0.443, -0.530, 0.432])
WORDS = ["aa", "ab", "aB"]


def get_axis(rho, w):
    try:
        mat = np.array(rho(w), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        v = np.array([float(np.real(L[0, 1] + L[1, 0])) / 2,
                      float(np.imag(L[1, 0] - L[0, 1])) / 2,
                      float(np.real(L[0, 0] - L[1, 1])) / 2])
        n = np.linalg.norm(v)
        return v / n if n > 1e-10 else None
    except Exception:
        return None


M = snappy.OrientableClosedCensus[1]

results = []

# default, no fg_args
try:
    rho = M.polished_holonomy()
    axes = [get_axis(rho, w) for w in WORDS]
    if all(a is not None for a in axes):
        d = np.array([np.dot(axes[0], axes[1]), np.dot(axes[0], axes[2]), np.dot(axes[1], axes[2])])
        results.append(("default", d))
except Exception as e:
    print("default failed:", e)

for combo in product([True, False], repeat=4):
    try:
        rho = M.polished_holonomy(fundamental_group_args=list(combo))
        axes = [get_axis(rho, w) for w in WORDS]
        if all(a is not None for a in axes):
            d = np.array([np.dot(axes[0], axes[1]), np.dot(axes[0], axes[2]), np.dot(axes[1], axes[2])])
            results.append((str(combo), d))
    except Exception as e:
        print(combo, "failed:", e)

print(f"{'convention':40s}  {'d12':>8s} {'d13':>8s} {'d23':>8s}   dist_to_target(abs)")
for label, d in results:
    dist = np.linalg.norm(np.abs(d) - np.abs(TARGET))
    print(f"{label:40s}  {d[0]:+.4f}  {d[1]:+.4f}  {d[2]:+.4f}   {dist:.4f}")

best = min(results, key=lambda r: np.linalg.norm(np.abs(r[1]) - np.abs(TARGET)))
print()
print("BEST MATCH:", best[0], best[1])
print("target:", TARGET)
print("EXIT=0")
