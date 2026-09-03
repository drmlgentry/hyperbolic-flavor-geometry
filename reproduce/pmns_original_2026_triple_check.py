"""
Decisive check on the ORIGINAL March 2026 PMNS paper draft's own claim
(framework/papers/hyperbolic-flavor-pmns/gentry-hyperbolic-flavor-pmns.tex,
commit e5731d1 in the C:\\dev repo -- predates every script examined so
far this session):

  Table "Top results from the Borel construction PMNS scan":
    m003 (index 1), words aa/ab/aB, fitness 0.01897

  Text (line 364-366): "The Borel overlap parameters are lambda=1.0,
  (s21,s31,s32)=(+1,-1,+1), giving (l21,l31,l32)=(0.443,-0.530,0.432)."

  i.e. lambda=1 (not fit -- literally 1), so l_ij = s_ij * dot(n_i,n_j)
  directly -- the RAW axis dot products, no optimization at all.

  Also: "Theoretical minimum of the Borel construction... 5000 random
  Nelder-Mead starts... F_min = 0.018968, achieved at
  (l21,l31,l32)=(0.443,-0.530,0.432)" -- the SAME point.

Question: does m003's real, live-computed axis geometry for {aa,ab,aB}
actually produce dot products this close to (0.443,0.530,0.432) in
absolute value? If yes, this is a genuine, non-trivial, manifold-
dependent geometric fact (not explained by "any manifold reaches the
floor via free optimization" -- this is the RAW dot product, unoptimized).
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import numpy as np
from scipy.linalg import qr, logm
from itertools import permutations
import snappy

PMNS_2026 = np.array([
    [0.821, 0.550, 0.148],
    [0.357, 0.339, 0.871],
    [0.442, 0.762, 0.471],
])
PERMS = list(permutations([0, 1, 2]))
WORDS = ["aa", "ab", "aB"]


def get_axis(rho, word):
    mat = np.array(rho(word), dtype=complex)
    mat = mat / np.sqrt(np.linalg.det(mat))
    L = logm(mat)
    x = float(np.real(L[0, 1] + L[1, 0])) / 2
    y = float(np.imag(L[1, 0] - L[0, 1])) / 2
    z = float(np.real(L[0, 0] - L[1, 1])) / 2
    v = np.array([x, y, z])
    n = np.linalg.norm(v)
    return v / n if n > 1e-10 else None


def fitness_of(l21, l31, l32, target):
    Lm = np.array([[1., 0., 0.], [l21, 1., 0.], [l31, l32, 1.]])
    Q, _ = qr(Lm)
    Qabs = np.abs(Q)
    return min(float(np.linalg.norm(Qabs[:, list(p)] - target, 'fro')) for p in PERMS)


M = snappy.OrientableClosedCensus[1]
print(f"Manifold: {M.name()}  vol={float(M.volume()):.4f}  H1={M.homology()}")

CONVENTIONS = {
    "default (M.polished_holonomy(), no fg_args)": dict(fg_args=None),
    "explicit cusp-preserving [T,F,T,F]": dict(fg_args=[True, False, True, False]),
}

for label, cfg in CONVENTIONS.items():
    print(f"\n{'='*70}\n{label}\n{'='*70}")
    if cfg["fg_args"] is None:
        rho = M.polished_holonomy()
    else:
        rho = M.polished_holonomy(fundamental_group_args=cfg["fg_args"])
    try:
        axes = [get_axis(rho, w) for w in WORDS]
    except Exception as e:
        print(f"  FAILED: {e}")
        continue
    d12 = float(np.dot(axes[0], axes[1]))
    d13 = float(np.dot(axes[0], axes[2]))
    d23 = float(np.dot(axes[1], axes[2]))
    print(f"Words {WORDS}:")
    print(f"  d12 (aa.ab) = {d12:+.6f}   paper's l21/lambda = +0.443")
    print(f"  d13 (aa.aB) = {d13:+.6f}   paper's l31/lambda = -0.530")
    print(f"  d23 (ab.aB) = {d23:+.6f}   paper's l32/lambda = +0.432")

    l21, l31, l32 = d12, -d13, d23
    f = fitness_of(l21, l31, l32, PMNS_2026)
    print(f"  raw (lambda=1, signs +,-,+) fitness: {f:.6f}  (paper claims 0.01897)")

    best = 1e9
    best_params = None
    for lam in np.linspace(0.1, 5.0, 50):
        for s21 in [1, -1]:
            for s31 in [1, -1]:
                for s32 in [1, -1]:
                    f2 = fitness_of(lam * s21 * d12, lam * s31 * d13, lam * s32 * d23, PMNS_2026)
                    if f2 < best:
                        best = f2
                        best_params = (lam, s21, s31, s32)
    print(f"  full lambda+signs grid best: {best:.6f} at {best_params}")

print("\nEXIT=0")
