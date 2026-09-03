"""
Exact-count Haar null test for the canonical PMNS Borel result.

The manuscript (gentry-pmns-plb.tex) reports "fewer than 5 of 50,000"
Haar-random exceedances, without the exact count, exact RNG seed, or a
committed script. This reuses the CANONICAL, already-verified
construction (hyperbolic-flavor-scan/hfg_reproduce.py, run live and
confirmed this session, fitness=0.005087 exactly) and its own stated
null protocol: score the ALREADY-FITTED matrix (found once via
Nelder-Mead against the real PDG target) against fresh Haar-random
targets -- NOT a full re-optimization per target, matching the
manuscript's own description ("Score the canonical word triple's Borel
construction... against each null target").

Honesty about scope: the original run's exact RNG algorithm and seed
were never recorded anywhere found in either repo. This uses numpy's
default_rng with an explicitly stated seed (not a reconstruction of an
undocumented original) and reports that seed, so the exact count here
is reproducible, even though it is not guaranteed byte-identical to
whatever produced "<5" in the manuscript.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import snappy
import numpy as np
from scipy.linalg import qr
import scipy

from hfg_reproduce import pmns_borel, PMNS_PDG, PERMS

SEED = 20260902
N_TRIALS = 50000

print("=" * 70)
print("PMNS BOREL NULL TEST -- EXACT COUNT (not just '<5')")
print("=" * 70)
print("Python:", sys.version.split()[0])
print("NumPy:", np.__version__, " SciPy:", scipy.__version__)
print("SnapPy:", snappy.__version__)
print("RNG: numpy.random.default_rng(seed=%d) -- explicit, since no" % SEED)
print("     original seed is documented anywhere found in either repo.")

M_pmns = snappy.OrientableClosedCensus[1]
pmns_words = ['aa', 'aaB', 'baa']
print()
print("Fitting the canonical construction once (same as hfg_reproduce.py):")
U_fixed, fit = pmns_borel(M_pmns, pmns_words)
print("U_fixed fitness vs PDG 2024:", fit)
assert abs(fit - 0.005087) < 1e-5, "canonical fit did not reproduce 0.005087"
print(np.array2string(U_fixed, precision=6, suppress_small=True))

rng = np.random.default_rng(SEED)


def haar_unitary_3x3(rng):
    """Standard Haar-random U(3) via QR of a complex Ginibre matrix,
    with the sign/phase correction (Mezzadri 2007) needed for a genuine
    Haar measure (plain QR without it is NOT Haar-distributed)."""
    Z = (rng.standard_normal((3, 3)) + 1j * rng.standard_normal((3, 3))) / np.sqrt(2)
    Q, R = qr(Z)
    d = np.diagonal(R)
    ph = d / np.abs(d)
    return Q * ph


fitnesses = np.empty(N_TRIALS)
for i in range(N_TRIALS):
    V = haar_unitary_3x3(rng)
    Vabs = np.abs(V)
    fitnesses[i] = min(float(np.linalg.norm(U_fixed[:, list(p)] - Vabs, 'fro'))
                        for p in PERMS)

k = int(np.sum(fitnesses <= fit))
print()
print("=" * 70)
print("RESULT")
print("=" * 70)
print("N_TRIALS =", N_TRIALS)
print("target fitness (U_fixed vs PDG) =", fit)
print("exact exceedance count k =", k)
print("exact empirical p = k/%d = %.6f" % (N_TRIALS, k / N_TRIALS))
print("null distribution: mean=%.6f  std=%.6f  min=%.6f" %
      (fitnesses.mean(), fitnesses.std(), fitnesses.min()))
print()
print("For comparison, the manuscript's own claim: 'fewer than 5 of")
print("50,000', i.e. k<5, p<1e-4.")
print("EXIT=0")
