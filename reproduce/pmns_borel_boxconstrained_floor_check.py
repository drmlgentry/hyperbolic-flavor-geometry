"""
Is 1.04370 (the value every census manifold tied at in the no-optimization
dot-product Borel construction) the manifold-independent GLOBAL MINIMUM of
{QR(L) : L lower-triangular, diag=1, off-diag in [-1,1]^3} against the
crude PMNS_TARGET -- i.e. the same degeneracy mechanism as pmns_borel's
manifold-independent 0.005087/0.01897, just box-constrained because these
particular off-diagonal entries are dot products of unit vectors?

Zero manifold information used anywhere in this script.
"""
import numpy as np
from scipy.linalg import qr
from scipy.optimize import minimize, differential_evolution
from itertools import permutations

PMNS_TARGET = np.array([
    [0.821, 0.550, 0.148],
    [0.357, 0.339, 0.871],
    [0.442, 0.762, 0.471],
])
PERMS = list(permutations([0, 1, 2]))


def fitness_from_L(c12, c13, c23):
    L = np.array([[1., 0., 0.], [c12, 1., 0.], [c13, c23, 1.]])
    Q, R = qr(L.T)
    signs = np.diag(np.sign(np.diag(R)))
    U = np.abs(Q @ signs)
    return min(float(np.linalg.norm(U[:, list(p)] - PMNS_TARGET, 'fro')) for p in PERMS)


def neg(params):
    c12, c13, c23 = params
    return fitness_from_L(c12, c13, c23)


print("=== Bounded global search over c12,c13,c23 in [-1,1]^3 (differential_evolution) ===")
res = differential_evolution(neg, bounds=[(-1, 1), (-1, 1), (-1, 1)],
                              tol=1e-12, seed=0, maxiter=2000, popsize=40, polish=True)
print(f"box-constrained global min: {res.fun:.6f}  at c=({res.x[0]:.4f},{res.x[1]:.4f},{res.x[2]:.4f})")

print()
print("=== Grid scan for sanity (21^3 = 9261 points on [-1,1]^3) ===")
best = 1e9
best_c = None
grid = np.linspace(-1, 1, 21)
for c12 in grid:
    for c13 in grid:
        for c23 in grid:
            f = fitness_from_L(c12, c13, c23)
            if f < best:
                best = f
                best_c = (c12, c13, c23)
print(f"grid best: {best:.6f} at {best_c}")

print()
print("=== Many-restart Nelder-Mead from box-clipped random starts ===")
rng = np.random.default_rng(1)
best2 = 1e9
best2_c = None
for _ in range(500):
    x0 = rng.uniform(-1, 1, 3)
    r = minimize(neg, x0, method='Nelder-Mead',
                 options={'xatol': 1e-10, 'fatol': 1e-10, 'maxiter': 20000})
    xclip = np.clip(r.x, -1, 1)
    f = fitness_from_L(*xclip)
    if f < best2:
        best2 = f
        best2_c = xclip
print(f"many-restart (clipped) best: {best2:.6f} at {best2_c}")

print()
print(f"Compare to census-observed value: 1.04370")
print("EXIT=0")
