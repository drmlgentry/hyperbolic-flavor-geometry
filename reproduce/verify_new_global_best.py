"""
verify_new_global_best.py
=========================
Verifies the new global-best triple found by sigma_refine:
  triple = ('aaab', 'aabb', 'bAbAB')
  sigma  = 0.47
  claimed fitness = 0.002728

Uses the IDENTICAL construction as census_null_test.py (abs-dot kernel).
Also computes mixing angles, H1 homology classes, and J=0 check.

Run:
  cd /mnt/c/dev/hyperbolic-flavor-geometry
  conda run -n sage python3 reproduce/verify_new_global_best.py
"""

import numpy as np
from scipy.linalg import logm
from itertools import permutations

# ── PDG 2024 CKM (identical to census_null_test.py) ──────────────────────────
PDG_CKM = np.array([[0.97435, 0.22500, 0.00369],
                    [0.22486, 0.97349, 0.04182],
                    [0.00857, 0.04110, 0.99917]])
PERMS = list(permutations(range(3)))

# ── Load manifold ─────────────────────────────────────────────────────────────
try:
    import snappy
except ImportError:
    raise SystemExit("SnapPy not found — activate conda env 'sage'")

M   = snappy.OrientableClosedCensus[43]   # m006(-5,2)
rho = M.polished_holonomy()
print(f"Manifold: {M.name()}  vol={float(M.volume()):.9f}  H1={M.homology()}")

# ── Axis extraction (identical to null test) ──────────────────────────────────
def get_axis(w):
    try:
        mat = np.array(rho(w), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        L   = logm(mat)
        x   = float(np.real(L[0,1] + L[1,0])) / 2
        y   = float(np.imag(L[1,0] - L[0,1])) / 2
        z   = float(np.real(L[0,0] - L[1,1])) / 2
        v   = np.array([x, y, z])
        n   = np.linalg.norm(v)
        return v / n if n > 1e-10 else None
    except Exception:
        return None

def homology_class(word):
    a = sum(1 if c == 'a' else -1 if c == 'A' else 0 for c in word)
    b = sum(1 if c == 'b' else -1 if c == 'B' else 0 for c in word)
    return (a % 5, b % 5)

def ckm_angles(U):
    s13 = float(U[0, 2])
    t13 = np.degrees(np.arcsin(min(abs(s13), 1.0)))
    c13 = np.cos(np.radians(t13))
    t12 = np.degrees(np.arcsin(min(abs(float(U[0,1])) / max(c13, 1e-10), 1.0)))
    t23 = np.degrees(np.arcsin(min(abs(float(U[1,2])) / max(c13, 1e-10), 1.0)))
    return t12, t13, t23

# ── Primary verification ──────────────────────────────────────────────────────
TRIPLE = ['aaab', 'aabb', 'bAbAB']
SIGMA  = 0.47
CLAIMED_FITNESS = 0.002728

print(f"\n{'='*60}")
print(f"TRIPLE:  {TRIPLE}")
print(f"SIGMA:   {SIGMA}")
print(f"CLAIMED: {CLAIMED_FITNESS}")
print(f"{'='*60}")

axes = [get_axis(w) for w in TRIPLE]
if any(ax is None for ax in axes):
    raise ValueError("Failed to compute axis for one or more words")

# Pairwise angles (ABS-DOT — matches census_null_test.py line 100)
print("\nPairwise axes (abs-dot angles):")
for i in range(3):
    for j in range(i+1, 3):
        d   = float(np.dot(axes[i], axes[j]))
        ang = np.degrees(np.arccos(np.clip(abs(d), -1, 1)))
        print(f"  θ({TRIPLE[i]}, {TRIPLE[j]}) = {ang:.4f}°  (raw dot = {d:.6f})")

# Build overlap kernel (abs-dot)
O = np.zeros((3, 3))
for i in range(3):
    for j in range(3):
        ang    = np.arccos(np.clip(abs(np.dot(axes[i], axes[j])), -1, 1))
        O[i,j] = np.exp(-ang**2 / (2 * SIGMA**2))

Q, _ = np.linalg.qr(O)
U    = np.abs(Q)

# Best column permutation
best_f    = float('inf')
best_perm = None
for p in PERMS:
    f = float(np.sqrt(np.sum((U[:, list(p)] - PDG_CKM)**2)))
    if f < best_f:
        best_f    = f
        best_perm = p

U_aligned = U[:, list(best_perm)]

print(f"\nFitness (abs-dot, sigma={SIGMA}): {best_f:.8f}")
print(f"Claimed fitness:                  {CLAIMED_FITNESS}")
print(f"Match: {'YES ✓' if abs(best_f - CLAIMED_FITNESS) < 1e-4 else 'NO ✗  <-- kernel mismatch!'}")

# Mixing angles
t12, t13, t23 = ckm_angles(U_aligned)
pdg_t12, pdg_t13, pdg_t23 = 13.00, 0.211, 2.396
print(f"\nMixing angles:")
print(f"  θ12 = {t12:.4f}°  PDG = {pdg_t12:.3f}°  err = {(t12-pdg_t12)/pdg_t12*100:+.2f}%")
print(f"  θ13 = {t13:.4f}°  PDG = {pdg_t13:.3f}°  err = {(t13-pdg_t13)/pdg_t13*100:+.2f}%")
print(f"  θ23 = {t23:.4f}°  PDG = {pdg_t23:.3f}°  err = {(t23-pdg_t23)/pdg_t23*100:+.2f}%")

# H1 homology classes
print(f"\nH1 homology classes (Z/5 x Z/5):")
classes = []
for w in TRIPLE:
    hc = homology_class(w)
    classes.append(hc)
    print(f"  {w}: {hc}")
distinct = len(set(classes)) == 3
print(f"All distinct: {distinct}  ({'J≠0 possible' if distinct else 'J=0 forced by collision'})")
print(f"J=0 from construction (real kernel): always True")

# Aligned matrix vs PDG
print(f"\nAligned matrix vs PDG:")
for i, (row_h, row_p) in enumerate(zip(U_aligned, PDG_CKM)):
    print(f"  HFG: {row_h[0]:.6f}  {row_h[1]:.6f}  {row_h[2]:.6f}")
    print(f"  PDG: {row_p[0]:.6f}  {row_p[1]:.6f}  {row_p[2]:.6f}")
    print()

# ── Sigma sweep around 0.47 ───────────────────────────────────────────────────
print(f"{'='*60}")
print("SIGMA SWEEP around 0.47 for this triple:")
print(f"{'='*60}")
for sig in [0.42, 0.44, 0.45, 0.46, 0.47, 0.48, 0.49, 0.50, 0.52, 0.55]:
    O2 = np.zeros((3,3))
    for i in range(3):
        for j in range(3):
            ang     = np.arccos(np.clip(abs(np.dot(axes[i], axes[j])), -1, 1))
            O2[i,j] = np.exp(-ang**2 / (2 * sig**2))
    Q2, _ = np.linalg.qr(O2)
    U2    = np.abs(Q2)
    f2    = min(float(np.sqrt(np.sum((U2[:,list(p)]-PDG_CKM)**2))) for p in PERMS)
    marker = " ← optimum?" if f2 < 0.003 else ""
    print(f"  sigma={sig:.2f}:  F={f2:.6f}{marker}")

print(f"\n{'='*60}")
print("Also compare the null-test triple at sigma=0.47:")
print(f"{'='*60}")
null_triple = ['AbaaB', 'BAAAA', 'BAAbaB']
null_axes   = [get_axis(w) for w in null_triple]
for sig in [0.45, 0.47]:
    O3 = np.zeros((3,3))
    for i in range(3):
        for j in range(3):
            ang     = np.arccos(np.clip(abs(np.dot(null_axes[i], null_axes[j])), -1, 1))
            O3[i,j] = np.exp(-ang**2 / (2 * sig**2))
    Q3, _ = np.linalg.qr(O3)
    U3    = np.abs(Q3)
    f3    = min(float(np.sqrt(np.sum((U3[:,list(p)]-PDG_CKM)**2))) for p in PERMS)
    print(f"  null-test triple (AbaaB,BAAAA,BAAbaB) at sigma={sig:.2f}: F={f3:.6f}")
