"""
m003_uniqueness_scan.py
=======================
Tests whether m003(-2,3) = M_PMNS is the UNIQUE Dehn filling of m003
whose PMNS optimal word triple (aa, aaB, baa) is entirely quasi-hyperbolic
(all corrected geodesic twists |θ| < 30°).

Scans:
  A. m003(p, 3)  for p ∈ [-15, 15] \ {0, multiples of 3}
  B. m003(-2, q) for q ∈ [1, 21]    (re-confirms Part 3 of cusped_vs_filled)
  C. Broad grid  m003(p, q) for |p|,|q| ≤ 5, gcd(p,q)=1
     — a complete census of small surgery coefficients

For each hyperbolic filling:
  - Compute θ(aa), θ(aaB), θ(baa) (PMNS canonical words)
  - Flag if ALL THREE are quasi-hyperbolic (|θ| < 30°) ← M_PMNS criterion
  - Report mean axis spread (logm convention, σ=0.47, compared to K-factor floor)

Run (takes ~5-10 min for the broad grid):
  conda run -n sage python3 reproduce/m003_uniqueness_scan.py 2>/dev/null
"""

import cmath, numpy as np, snappy
from math import gcd
from scipy.linalg import logm
from itertools import permutations as iperms

QUASI_HYP_THRESH = 30.0   # |θ| < 30° → quasi-hyperbolic
SIGMA = 0.47
PMNS_WORDS = ['aa', 'aaB', 'baa']
CONTROL_WORDS = ['aaab']

PDG_CKM = np.array([[0.97435, 0.22500, 0.00369],
                    [0.22486, 0.97349, 0.04182],
                    [0.00857, 0.04110, 0.99912]])
PERMS = list(iperms(range(3)))

# ── Helpers ──────────────────────────────────────────────────────

def geodesic_twist(tr):
    for sign in [1, -1]:
        z = sign * complex(tr) / 2.0
        try:
            w = cmath.acosh(z)
        except Exception:
            continue
        l = 2 * w
        if l.real > 1e-8:
            theta = l.imag
            while theta >  np.pi: theta -= 2*np.pi
            while theta <= -np.pi: theta += 2*np.pi
            return np.degrees(theta)
    return None

def get_twist(rho, word):
    try:
        mat = np.array(rho(word), dtype=complex)
        mat /= np.sqrt(np.linalg.det(mat))
        tr = complex(np.trace(mat))
        return geodesic_twist(tr)
    except Exception:
        return None

def get_axis(rho, word):
    try:
        mat = np.array(rho(word), dtype=complex)
        mat /= np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        v = np.array([float(np.real(L[0,1]+L[1,0]))/2,
                      float(np.imag(L[1,0]-L[0,1]))/2,
                      float(np.real(L[0,0]-L[1,1]))/2])
        n = np.linalg.norm(v)
        return v/n if n > 1e-10 else None
    except Exception:
        return None

def k_fitness(axes):
    O = np.zeros((3,3))
    for i in range(3):
        for j in range(3):
            ang = np.arccos(np.clip(abs(np.dot(axes[i], axes[j])), 0, 1))
            O[i,j] = np.exp(-ang**2 / (2*SIGMA**2))
    Q, _ = np.linalg.qr(O)
    U = np.abs(Q)
    return min(float(np.sqrt(np.sum((U[:,list(p)]-PDG_CKM)**2))) for p in PERMS)

def analyze_filling(p, q):
    """
    Returns dict with twist data, or None if not hyperbolic / SnapPy error.
    """
    try:
        M = snappy.Manifold('m003')
        M.dehn_fill((p, q))
        rho = M.polished_holonomy()
        twists = {w: get_twist(rho, w) for w in PMNS_WORDS + CONTROL_WORDS}
        if any(v is None for v in twists.values()):
            return None
        pmns_abs = [abs(twists[w]) for w in PMNS_WORDS]
        all_quasi = all(t < QUASI_HYP_THRESH for t in pmns_abs)
        mean_abs  = np.mean(pmns_abs)
        # Axis spread for PMNS triple
        axes = [get_axis(rho, w) for w in PMNS_WORDS]
        if any(ax is None for ax in axes):
            spread = None; kf = None
        else:
            pairwise = []
            for i in range(3):
                for j in range(i+1, 3):
                    dot = np.clip(abs(np.dot(axes[i], axes[j])), 0, 1)
                    pairwise.append(np.degrees(np.arccos(dot)))
            spread = np.mean(pairwise)
            kf = k_fitness(axes)
        return dict(twists=twists, all_quasi=all_quasi,
                    mean_abs=mean_abs, spread=spread, kf=kf)
    except Exception:
        return None

# ── PART A: m003(p, 3) varying p ─────────────────────────────────

print("="*70)
print("PART A: m003(p, 3) — varying p, fixed q=3")
print(f"Quasi-hyperbolic criterion: ALL of |θ(aa)|, |θ(aaB)|, |θ(baa)| < {QUASI_HYP_THRESH}°")
print("="*70)

print(f"\n  {'p':>4}  {'θ(aa)':>8}  {'θ(aaB)':>8}  {'θ(baa)':>8}  "
      f"{'mean|θ|':>8}  {'spread':>7}  {'K-fit':>7}  {'all QH?':>8}")
print(f"  {'-'*4}  {'-'*8}  {'-'*8}  {'-'*8}  "
      f"{'-'*8}  {'-'*7}  {'-'*7}  {'-'*8}")

quasi_hits_A = []
for p in range(-15, 16):
    if p == 0: continue
    if gcd(abs(p), 3) != 1: continue   # require primitive vector
    res = analyze_filling(p, 3)
    if res is None:
        continue
    t = res['twists']
    aq = "✓ QUASI" if res['all_quasi'] else ""
    sp = f"{res['spread']:7.1f}°" if res['spread'] is not None else "    ---"
    kf = f"{res['kf']:7.4f}"  if res['kf']  is not None else "    ---"
    print(f"  {p:>4}  {t['aa']:+8.2f}°  {t['aaB']:+8.2f}°  {t['baa']:+8.2f}°  "
          f"{res['mean_abs']:8.2f}°  {sp}  {kf}  {aq}")
    if res['all_quasi']:
        quasi_hits_A.append(p)

if quasi_hits_A:
    print(f"\n  ALL-QUASI fillings found at p = {quasi_hits_A}")
else:
    print(f"\n  No other p gives all-quasi-hyperbolic PMNS triple at q=3.")

# ── PART B: m003(-2, q) varying q ────────────────────────────────

print()
print("="*70)
print("PART B: m003(-2, q) — varying q, fixed p=-2  (re-confirms family scan)")
print("="*70)

print(f"\n  {'q':>4}  {'θ(aa)':>8}  {'θ(aaB)':>8}  {'θ(baa)':>8}  "
      f"{'mean|θ|':>8}  {'spread':>7}  {'K-fit':>7}  {'all QH?':>8}")
print(f"  {'-'*4}  {'-'*8}  {'-'*8}  {'-'*8}  "
      f"{'-'*8}  {'-'*7}  {'-'*7}  {'-'*8}")

quasi_hits_B = []
for q in range(1, 22):
    if gcd(2, abs(q)) != 1: continue   # gcd(-2, q) = gcd(2,q); need = 1 → q odd
    res = analyze_filling(-2, q)
    if res is None:
        continue
    t = res['twists']
    aq = "✓ QUASI" if res['all_quasi'] else ""
    sp = f"{res['spread']:7.1f}°" if res['spread'] is not None else "    ---"
    kf = f"{res['kf']:7.4f}"  if res['kf']  is not None else "    ---"
    print(f"  {q:>4}  {t['aa']:+8.2f}°  {t['aaB']:+8.2f}°  {t['baa']:+8.2f}°  "
          f"{res['mean_abs']:8.2f}°  {sp}  {kf}  {aq}")
    if res['all_quasi']:
        quasi_hits_B.append(q)

if quasi_hits_B:
    print(f"\n  ALL-QUASI fillings found at q = {quasi_hits_B}")
else:
    print(f"\n  Only q=3 gives all-quasi-hyperbolic PMNS triple at p=-2.")

# ── PART C: Broad grid |p|, |q| ≤ 7 ──────────────────────────────

print()
print("="*70)
print("PART C: Broad grid m003(p,q) for |p|,|q| ≤ 7, gcd(|p|,|q|)=1")
print("Reporting ALL-QUASI hits only (+ M_PMNS reference row)")
print("="*70)

quasi_hits_C = []
total_hyperbolic = 0

for p in range(-7, 8):
    for q in range(-7, 8):
        if p == 0 and q == 0: continue
        if p == 0 or q == 0: continue   # skip unilateral fills
        if gcd(abs(p), abs(q)) != 1: continue
        res = analyze_filling(p, q)
        if res is None:
            continue
        total_hyperbolic += 1
        if res['all_quasi']:
            quasi_hits_C.append((p, q, res))

print(f"\n  Total hyperbolic fillings in grid: {total_hyperbolic}")
print(f"  ALL-QUASI hits: {len(quasi_hits_C)}")
print()
print(f"  {'(p,q)':>10}  {'θ(aa)':>8}  {'θ(aaB)':>8}  {'θ(baa)':>8}  "
      f"{'mean|θ|':>8}  {'spread':>7}  {'K-fit':>8}")
print(f"  {'-'*10}  {'-'*8}  {'-'*8}  {'-'*8}  "
      f"{'-'*8}  {'-'*7}  {'-'*8}")

# Always print M_PMNS reference
ref = analyze_filling(-2, 3)
if ref:
    t = ref['twists']
    print(f"  {'(-2,3)':>10}  {t['aa']:+8.2f}°  {t['aaB']:+8.2f}°  {t['baa']:+8.2f}°  "
          f"{ref['mean_abs']:8.2f}°  {ref['spread']:7.1f}°  {ref['kf']:8.4f}  ← M_PMNS ref")

for (p, q, res) in sorted(quasi_hits_C, key=lambda x: x[2]['mean_abs']):
    if (p, q) == (-2, 3): continue   # already printed above
    t = res['twists']
    sp = f"{res['spread']:7.1f}°" if res['spread'] is not None else "    ---"
    kf = f"{res['kf']:8.4f}"  if res['kf']  is not None else "     ---"
    print(f"  {f'({p},{q})':>10}  {t['aa']:+8.2f}°  {t['aaB']:+8.2f}°  {t['baa']:+8.2f}°  "
          f"{res['mean_abs']:8.2f}°  {sp}  {kf}")

# ── Summary ───────────────────────────────────────────────────────

print()
print("="*70)
print("SUMMARY")
print("="*70)
n_other = sum(1 for (p,q,_) in quasi_hits_C if (p,q) != (-2,3))
print(f"""
  Part A (fixed q=3, p ∈ [-15,15]):   other quasi-hyp fillings: {len(quasi_hits_A)}
  Part B (fixed p=-2, q ∈ [1,21]):    other quasi-hyp fillings: {len(quasi_hits_B)-1 if 3 in quasi_hits_B else len(quasi_hits_B)}
  Part C (|p|,|q| ≤ 7 grid):          other quasi-hyp fillings: {n_other}

  IF all counts = 0 (or only (-2,3) appears):
    m003(-2,3) = Meyerhoff manifold is the UNIQUE Dehn filling of m003
    (in the range tested) whose PMNS optimal triple is quasi-hyperbolic.
    This arithmetically characterises M_PMNS = m003(-2,3) as the
    N-factor manifold in the m003 Dehn surgery family.
    → Evidence level: [Computed] (finite check, not a proof)
    → Path to proof: show character variety of m003 has unique solution
      with Im(tr(aaB)) ≈ 0 and Im(tr(baa)) ≈ 0 at slope (-2,3).

  IF other fillings appear:
    The uniqueness claim needs refinement (additional arithmetic constraint
    needed to isolate M_PMNS among quasi-hyperbolic fillings).
""")
