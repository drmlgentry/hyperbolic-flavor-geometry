"""
CORRECTED PMNS Borel null test.

The previous version (pmns_null_test_exact_count.py) froze the ENTIRE
matrix -- including the L_m Nelder-Mead optimization -- and only varied
the target. That tests a narrower, less meaningful null hypothesis
("does a random target happen to land near one fixed point") than what
the manuscript's own text describes: "it asks whether the already-
selected canonical triple's construction is special relative to Haar-
random targets" -- contrasted explicitly against CKM's per-target
re-search. Re-reading closely: what is NOT re-run is the WORD TRIPLE
search (always {aa,aaB,baa}); nothing in that text says the L_m
optimization itself is frozen too. The correct null re-optimizes L_m
fresh for each Haar target (word triple held fixed), matching how
"the construction" (Nelder-Mead fit) is actually defined and used
against the real PDG target in the first place.

This was a real methodological error in the previous run, caught before
being written into the gap report as final. Both versions are kept for
the record; this one supersedes it.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import time
import argparse
import snappy
import numpy as np
from scipy.linalg import qr
from scipy.optimize import minimize
import scipy

from hfg_reproduce import get_axis, PMNS_PDG, PERMS

parser = argparse.ArgumentParser()
parser.add_argument("--n", type=int, default=2000)
parser.add_argument("--seed", type=int, default=20260902)
parser.add_argument("--out", type=str, default=None)
args = parser.parse_args()

SEED = args.seed
N_TRIALS = args.n

print("=" * 70)
print("PMNS BOREL NULL TEST -- CORRECT CONSTRUCTION (re-optimize per target)")
print("=" * 70)
print("Python:", sys.version.split()[0])
print("NumPy:", np.__version__, " SciPy:", scipy.__version__)
print("SnapPy:", snappy.__version__)
print("N_TRIALS =", N_TRIALS, " SEED =", SEED)

M_pmns = snappy.OrientableClosedCensus[1]
pmns_words = ['aa', 'aaB', 'baa']
rho = M_pmns.polished_holonomy()
axes = [get_axis(rho, w) for w in pmns_words]
d12 = float(np.dot(axes[0], axes[1]))
d13 = float(np.dot(axes[0], axes[2]))
d23 = float(np.dot(axes[1], axes[2]))
X0LIST = [[d12, d13, d23], [-d12, -d13, d23], [-1, -1, 1], [-2, -2, 1]]


def fit_to_target(target, x0list=X0LIST):
    def f(p):
        Lm = np.array([[1., 0., 0.], [p[0], 1., 0.], [p[1], p[2], 1.]])
        Q, _ = qr(Lm)
        Qabs = np.abs(Q)
        return min(float(np.linalg.norm(Qabs[:, list(perm)] - target, 'fro'))
                   for perm in PERMS)
    best = float('inf')
    for x0 in x0list:
        res = minimize(f, x0, method='Nelder-Mead',
                        options={'xatol': 1e-12, 'fatol': 1e-12, 'maxiter': 200000})
        if res.fun < best:
            best = res.fun
    return best


print()
print("Re-deriving the real fitness against PDG (sanity check):")
fit_pdg = fit_to_target(PMNS_PDG)
print("fitness vs PDG =", fit_pdg)
assert abs(fit_pdg - 0.005087) < 1e-5

rng = np.random.default_rng(SEED)


def haar_unitary_3x3(rng):
    Z = (rng.standard_normal((3, 3)) + 1j * rng.standard_normal((3, 3))) / np.sqrt(2)
    Q, R = qr(Z)
    d = np.diagonal(R)
    ph = d / np.abs(d)
    return Q * ph


t0 = time.time()
fitnesses = np.empty(N_TRIALS)
for i in range(N_TRIALS):
    V = np.abs(haar_unitary_3x3(rng))
    fitnesses[i] = fit_to_target(V)
    if (i + 1) % max(1, N_TRIALS // 10) == 0:
        elapsed = time.time() - t0
        print("  %d/%d done, %.1fs elapsed, est total %.1fs" %
              (i + 1, N_TRIALS, elapsed, elapsed / (i + 1) * N_TRIALS))

k = int(np.sum(fitnesses <= fit_pdg))
print()
print("=" * 70)
print("RESULT (CORRECT CONSTRUCTION)")
print("=" * 70)
print("N_TRIALS =", N_TRIALS)
print("target fitness (re-optimized vs PDG) =", fit_pdg)
print("exact exceedance count k =", k)
print("exact empirical p = k/%d = %.6f" % (N_TRIALS, k / N_TRIALS))
print("null distribution: mean=%.6f  std=%.6f  min=%.6f  max=%.6f" %
      (fitnesses.mean(), fitnesses.std(), fitnesses.min(), fitnesses.max()))
print("wall time: %.1f sec" % (time.time() - t0))

if args.out:
    np.save(args.out, fitnesses)
    print("saved raw fitnesses to", args.out)

print("EXIT=0")
