"""
Audit of the ACTUAL PMNS Borel construction's effective flexibility.

Correction to a relayed proposal: the real construction (hfg_reproduce.py
pmns_borel) is NOT a single-bandwidth Gaussian-kernel model with a scalar
scale L. It is a direct 3-real-parameter lower-triangular matrix L_m,
QR-decomposed straight to |Q| -- no kernel, no scale to select. The
dimension-counting account below is the correct one for THIS model.
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import numpy as np
from scipy.linalg import qr
from hfg_reproduce import PERMS, PMNS_PDG

# The map (p0,p1,p2) -> |Q| sends R^3 into the space of entrywise-absolute-
# values of O(3) matrices. dim O(3) = 3. So a 3-real-parameter family is
# mapping onto (an open chart of) a 3-dimensional target manifold sitting
# inside the 9-dimensional space of all 3x3 matrices -- full-dimensional,
# not a thin curve or surface. That alone is the expected reason random
# targets can often be approximated reasonably well: this is NOT a sparse
# 1-parameter curve threading through 9-space (which would make a 12.5%
# hit rate genuinely surprising and worth a special geometric explanation)
# -- it is a parametrization of essentially the full local dimension of
# the actual constraint manifold |Q|, Q in O(3).

print("dim(parameter space) =", 3)
print("dim(O(3)) =", 3, "(the manifold |Q| lives on, up to sign/entry-abs)")
print("=> the model has full LOCAL dimension relative to its own target")
print("   manifold. A ~12%% hit rate for matching an arbitrary point in a")
print("   3-dimensional manifold, from a 3-parameter smooth family, is NOT")
print("   surprising by dimension count alone -- no additional exotic")
print("   geometric mechanism is needed to explain the ORDER of p~0.1.")

print()
print("=" * 70)
print("Direct check: Jacobian rank of (p0,p1,p2) -> |Q| at several points")
print("=" * 70)


def Qabs_of(p):
    Lm = np.array([[1., 0., 0.], [p[0], 1., 0.], [p[1], p[2], 1.]])
    Q, _ = qr(Lm)
    return np.abs(Q)


def jacobian(p, eps=1e-6):
    f0 = Qabs_of(p).flatten()
    J = np.zeros((9, 3))
    for k in range(3):
        pp = np.array(p, dtype=float)
        pp[k] += eps
        J[:, k] = (Qabs_of(pp).flatten() - f0) / eps
    return J


for p in [[0., 0., 0.], [-1., -1., 1.], [0.5, -0.3, 0.8], [-1.131144, -1.021736, 1.096306]]:
    J = jacobian(p)
    rank = np.linalg.matrix_rank(J, tol=1e-6)
    sv = np.linalg.svd(J, compute_uv=False)
    print(f"p={p}: Jacobian rank = {rank}/3, singular values = {np.array2string(sv, precision=4)}")

print()
print("=" * 70)
print("Where the PDG-optimal point sits: is it in a low-sensitivity")
print("(nearly-degenerate Jacobian) region, or a generic one?")
print("=" * 70)
p_star = [-1.131144, -1.021736, 1.096306]
J_star = jacobian(p_star)
sv_star = np.linalg.svd(J_star, compute_uv=False)
print("singular values at the fitted optimum:", sv_star)
print("condition number:", sv_star[0] / sv_star[-1] if sv_star[-1] > 1e-12 else "singular")
