"""
frobenius_floor_analysis.py  (v2 — fixed axis convention)
===========================================================
Uses the same logm-based get_axis() as census_scan_extended.py.

Previous version used the fixed-point-on-∂H³ axis (wrong convention),
giving F=0.778 for CKM triple instead of the correct 0.002728.

Tests the claim:
  "Nearly collinear geodesic axes (small mean inter-axis angle)
   produce high K-factor Frobenius floor → K-factor blocked."

PARTS
-----
A. Synthetic floor curve: random axis triples at controlled spread.
B. M_PMNS canonical triple (aa, aaB, baa): axis spread and floor.
C. M_CKM canonical triple (aaab, aabb, bAbAB): axis spread and floor.
D. Summary.

Run:
  conda run -n sage python3 reproduce/frobenius_floor_analysis.py 2>/dev/null
"""

import numpy as np
from scipy.linalg import logm
from itertools import permutations as iperms
import snappy

SIGMA = 0.47

PDG_CKM = np.array([[0.97435, 0.22500, 0.00369],
                    [0.22486, 0.97349, 0.04182],
                    [0.00857, 0.04110, 0.99912]])
PERMS = list(iperms(range(3)))

# ── Same axis and fitness functions as census_scan_extended.py ──

def get_axis(rho, w):
    """logm-based axis — MATCHES census_scan_extended.py exactly."""
    try:
        mat = np.array(rho(w), dtype=complex)
        mat /= np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        v = np.array([float(np.real(L[0,1]+L[1,0]))/2,
                      float(np.imag(L[1,0]-L[0,1]))/2,
                      float(np.real(L[0,0]-L[1,1]))/2])
        n = np.linalg.norm(v)
        return v/n if n > 1e-10 else None
    except Exception:
        return None

def k_factor_fitness(axes, sigma=SIGMA, target=PDG_CKM):
    """Exact frob() from census_scan_extended.py."""
    O = np.zeros((3,3))
    for i in range(3):
        for j in range(3):
            ang = np.arccos(np.clip(abs(np.dot(axes[i], axes[j])), 0, 1))
            O[i,j] = np.exp(-ang**2 / (2*sigma**2))
    Q, _ = np.linalg.qr(O)
    U = np.abs(Q)
    return min(float(np.sqrt(np.sum((U[:,list(p)]-target)**2))) for p in PERMS)

def pairwise_angles(axes):
    """Mean and individual pairwise angles between unit 3-vectors."""
    angles = []
    for i in range(len(axes)):
        for j in range(i+1, len(axes)):
            dot = np.clip(abs(np.dot(axes[i], axes[j])), 0, 1)
            angles.append(np.degrees(np.arccos(dot)))
    return angles

# ── PART A: Synthetic floor curve ───────────────────────────────

print("="*65)
print("PART A: K-factor floor vs axis angular spread (500 trials/point)")
print("="*65)

np.random.seed(42)
N_TRIALS = 500
ref = np.array([0., 0., 1.])

def random_axis_near(ref, spread_deg):
    spread_rad = np.radians(spread_deg)
    for _ in range(10000):
        v = np.random.randn(3); v /= np.linalg.norm(v)
        if np.arccos(np.clip(abs(np.dot(v, ref)), 0, 1)) < spread_rad:
            return v
    return ref + np.random.randn(3)*0.01  # fallback

spreads = [5, 10, 15, 20, 25, 30, 35, 40, 50, 60, 70, 80, 90]
floor_data = []

print(f"\n  {'Spread':>8}  {'Min F':>8}  {'Q10 F':>8}  {'Mean F':>8}")
print(f"  {'-'*8}  {'-'*8}  {'-'*8}  {'-'*8}")

for spread in spreads:
    fs = []
    for _ in range(N_TRIALS):
        axes = [random_axis_near(ref, spread) for _ in range(3)]
        fs.append(k_factor_fitness(axes))
    min_F  = np.min(fs)
    q10_F  = np.percentile(fs, 10)
    mean_F = np.mean(fs)
    floor_data.append((spread, min_F, q10_F))
    print(f"  {spread:>7}°  {min_F:8.5f}  {q10_F:8.5f}  {mean_F:8.5f}")

# Find where floor < 0.01 (K-factor viable)
viable_spread = next((s for s,m,_ in floor_data if m < 0.01), None)
print(f"\n  K-factor Min F < 0.01 threshold: spread > "
      f"{'not reached' if not viable_spread else str(viable_spread)+'°'}")

# ── PART B: M_PMNS axis spread ─────────────────────────────────

print()
print("="*65)
print("PART B: M_PMNS canonical triple axis spread")
print("="*65)

M_PMNS = snappy.OrientableClosedCensus[1]
rho_p  = M_PMNS.polished_holonomy()
pmns_words = ['aa', 'aaB', 'baa']

pmns_axes = []
for w in pmns_words:
    ax = get_axis(rho_p, w)
    if ax is not None:
        pmns_axes.append(ax)
        print(f"  axis({w:6s}): ({ax[0]:+.5f}, {ax[1]:+.5f}, {ax[2]:+.5f})")

if len(pmns_axes) == 3:
    angles_p = pairwise_angles(pmns_axes)
    mean_p   = np.mean(angles_p)
    pairs    = [('aa','aaB'), ('aa','baa'), ('aaB','baa')]
    print(f"\n  Pairwise inter-axis angles:")
    for (w1,w2), ang in zip(pairs, angles_p):
        print(f"    {w1} vs {w2}: {ang:.2f}°")
    print(f"  Mean pairwise angle = {mean_p:.2f}°")

    F_pmns = k_factor_fitness(pmns_axes)
    nearby = min(floor_data, key=lambda x: abs(x[0]-mean_p))
    print(f"\n  Direct K-factor fitness (census convention): F = {F_pmns:.6f}")
    print(f"  Borel N-factor fitness (from census scan):   F = 0.005087")
    print(f"  Floor prediction at spread≈{nearby[0]}°: min_F ≥ {nearby[1]:.5f}")

# ── PART C: M_CKM axis spread ──────────────────────────────────

print()
print("="*65)
print("PART C: M_CKM canonical triple axis spread")
print("="*65)

M_CKM = snappy.OrientableClosedCensus[43]
rho_k = M_CKM.polished_holonomy()
ckm_words = ['aaab', 'aabb', 'bAbAB']

ckm_axes = []
for w in ckm_words:
    ax = get_axis(rho_k, w)
    if ax is not None:
        ckm_axes.append(ax)
        print(f"  axis({w:7s}): ({ax[0]:+.5f}, {ax[1]:+.5f}, {ax[2]:+.5f})")

if len(ckm_axes) == 3:
    angles_k = pairwise_angles(ckm_axes)
    mean_k   = np.mean(angles_k)
    pairs    = [('aaab','aabb'), ('aaab','bAbAB'), ('aabb','bAbAB')]
    print(f"\n  Pairwise inter-axis angles:")
    for (w1,w2), ang in zip(pairs, angles_k):
        print(f"    {w1} vs {w2}: {ang:.2f}°")
    print(f"  Mean pairwise angle = {mean_k:.2f}°")

    F_ckm  = k_factor_fitness(ckm_axes)
    nearby = min(floor_data, key=lambda x: abs(x[0]-mean_k))
    print(f"\n  Direct K-factor fitness (census convention): F = {F_ckm:.6f}")
    print(f"  Known best from census scan:                 F = 0.002728")
    print(f"  Floor prediction at spread≈{nearby[0]}°: min_F ≥ {nearby[1]:.5f}")

# ── PART D: Summary ───────────────────────────────────────────

print()
print("="*65)
print("PART D: Summary")
print("="*65)

if len(pmns_axes) == 3 and len(ckm_axes) == 3:
    F_pmns = k_factor_fitness(pmns_axes)
    F_ckm  = k_factor_fitness(ckm_axes)
    print(f"""
  Manifold     Mean axis spread  K-factor F  Best known F  Factor diff
  M_PMNS       {np.mean(angles_p):>10.1f}°   {F_pmns:10.6f}   0.005087 (Borel)  —
  M_CKM        {np.mean(angles_k):>10.1f}°   {F_ckm:10.6f}   0.002728 (K-fac)  —

  For M_PMNS: direct K-factor fitness / Borel fitness = {F_pmns/0.005087:.0f}×
  The K-factor is blocked by a factor of ~{F_pmns/0.005087:.0f} relative to the Borel construction.

  Connection to geodesic twists (from corrected_twist_distribution.py):
    M_PMNS canonical triple: mean |θ| = 18.2°  (quasi-hyperbolic)
    M_CKM  canonical triple: mean |θ| = 131.8° (strongly loxodromic)

  Quasi-hyperbolic (|θ| ≪ 90°): element ≈ pure geodesic translation.
  Pure translations along nearly-parallel axes → logm axes nearly parallel
  → kernel matrix O nearly rank-1 → QR gives degenerate Q → high floor.

  Strongly loxodromic (|θ| ≫ 0°): large rotational component.
  Different rotation angles → logm axes spread in 3D → O non-degenerate
  → QR gives well-conditioned Q → low floor, K-factor viable.
""")
