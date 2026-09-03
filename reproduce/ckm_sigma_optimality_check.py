"""
Does sigma_opt = (3/2)*log(sqrt(13/5)) = 0.716634 (or the manuscript's
printed 0.7218) actually minimize the CKM Gaussian-kernel fitness, as
claimed in gentry-pmns-plb.tex lines 162-165 ("the same sigma that
minimises the CKM fitness")?

Uses the live, canonical ckm_gaussian construction's exact formula
(hyperbolic-flavor-scan/hfg_reproduce.py), on the real m006(-5,2)
holonomy and word triple {aaB,AbA,AAb}, scanning sigma directly.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import numpy as np
from scipy.linalg import qr
from scipy.optimize import minimize_scalar
from itertools import permutations
import snappy

from hfg_reproduce import get_axis, CKM_PDG

M = snappy.OrientableClosedCensus[43]
rho = M.polished_holonomy()
words = ["aaB", "AbA", "AAb"]
axes = [get_axis(rho, w) for w in words]
PERMS = list(permutations([0, 1, 2]))


def fit(sigma):
    theta = np.zeros((3, 3))
    for i in range(3):
        for j in range(3):
            c = float(np.clip(np.dot(axes[i], axes[j]), -1, 1))
            theta[i, j] = np.arccos(abs(c))
    O = np.exp(-theta**2 / (2 * sigma**2))
    Q, _ = qr(O)
    for col in range(3):
        if float(Q[0, col]) < 0:
            Q[:, col] = -Q[:, col]
    U = np.abs(Q)
    return min(float(np.linalg.norm(U[np.ix_(p, p)] - CKM_PDG, 'fro')) for p in PERMS)


SIGMA_OPT_CORRECTED = 1.5 * np.log(np.sqrt(13.0 / 5.0))
SIGMA_OPT_STALE = 1.5 * np.log((1 + 5**0.5) / 2)  # (3/2)log(phi), the pre-correction value

print(f"sigma_opt (corrected, (3/2)log sqrt(13/5)) = {SIGMA_OPT_CORRECTED:.6f}")
print(f"sigma_opt (stale, (3/2)log(phi), manuscript's printed 0.7218) = {SIGMA_OPT_STALE:.6f}")
print()
for s in [0.3, 0.4, 0.49, 0.5, 0.6, 0.7, SIGMA_OPT_CORRECTED, SIGMA_OPT_STALE, 0.8, 0.9, 1.0]:
    print(f"sigma={s:.6f}  CKM fitness={fit(s):.6f}")

res = minimize_scalar(fit, bounds=(0.05, 3.0), method="bounded")
print()
print(f"TRUE CKM-optimal sigma = {res.x:.6f}, fitness = {res.fun:.6f}")
print(f"(live canonical ckm_gaussian default: sigma=0.49, published fitness 0.016482)")
print("EXIT=0")
