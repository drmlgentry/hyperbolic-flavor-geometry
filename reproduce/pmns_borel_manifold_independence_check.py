"""
Decisive check: does pmns_borel's fitness statistic depend on the manifold
at all, or is it purely the global minimum of the free (p0,p1,p2) -> |Q|
family against PMNS_PDG, reachable from any starting point?

Method: call pmns_borel's exact optimization core with (a) real m003(-2,3)
axes, (b) real axes from several OTHER census manifolds, and (c) axes
replaced by literally random unit vectors having nothing to do with any
3-manifold. If all give fitness ~0.005087, the statistic carries zero
manifold information and the "geometric encoding" reading of it is void.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import numpy as np
from scipy.linalg import qr
from scipy.optimize import minimize
import snappy

from hfg_reproduce import get_axis, PMNS_PDG, PERMS

WORDS = ["aa", "aaB", "baa"]


def fit_from_dots(d12, d13, d23, extra_x0=None):
    def f(p):
        Lm = np.array([[1., 0., 0.], [p[0], 1., 0.], [p[1], p[2], 1.]])
        Q, _ = qr(Lm)
        Qabs = np.abs(Q)
        return min(float(np.linalg.norm(Qabs[:, list(perm)] - PMNS_PDG, 'fro'))
                    for perm in PERMS)
    x0s = [[d12, d13, d23], [-d12, -d13, d23], [-1, -1, 1], [-2, -2, 1]]
    if extra_x0:
        x0s = x0s + extra_x0
    best = float('inf')
    for x0 in x0s:
        res = minimize(f, x0, method='Nelder-Mead',
                        options={'xatol': 1e-12, 'fatol': 1e-12, 'maxiter': 200000})
        if res.fun < best:
            best = res.fun
    return best


print("=" * 70)
print("(a) real manifold axes, several different census entries")
print("=" * 70)
for name in ["m003(-2,3)", "m004(5,2)", "m006(-5,2)", "m038(3,2)"]:
    M = snappy.Manifold(name)
    rho = M.polished_holonomy()
    axes = [get_axis(rho, w) for w in WORDS]
    d12 = float(np.dot(axes[0], axes[1]))
    d13 = float(np.dot(axes[0], axes[2]))
    d23 = float(np.dot(axes[1], axes[2]))
    fit = fit_from_dots(d12, d13, d23)
    print(f"  {name:15s}  d12={d12:+.4f} d13={d13:+.4f} d23={d23:+.4f}  fitness={fit:.9f}")

print()
print("=" * 70)
print("(b) axes replaced by LITERALLY RANDOM unit vectors (no manifold at all)")
print("=" * 70)
rng = np.random.default_rng(0)
for trial in range(6):
    v = rng.normal(size=(3, 3))
    v = v / np.linalg.norm(v, axis=1, keepdims=True)
    d12 = float(np.dot(v[0], v[1]))
    d13 = float(np.dot(v[0], v[2]))
    d23 = float(np.dot(v[1], v[2]))
    fit = fit_from_dots(d12, d13, d23)
    print(f"  random trial {trial}:  d12={d12:+.4f} d13={d13:+.4f} d23={d23:+.4f}  fitness={fit:.9f}")

print()
print("=" * 70)
print("(c) ZERO starting-point information at all: x0=[0,0,0] only, single restart")
print("=" * 70)
def f(p):
    Lm = np.array([[1., 0., 0.], [p[0], 1., 0.], [p[1], p[2], 1.]])
    Q, _ = qr(Lm)
    Qabs = np.abs(Q)
    return min(float(np.linalg.norm(Qabs[:, list(perm)] - PMNS_PDG, 'fro'))
                for perm in PERMS)
res = minimize(f, [0., 0., 0.], method='Nelder-Mead',
                options={'xatol': 1e-12, 'fatol': 1e-12, 'maxiter': 200000})
print(f"  single restart from [0,0,0]: fitness={res.fun:.9f}  p={res.x}")

print()
print("EXIT=0")
