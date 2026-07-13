"""
twist_angle_distribution.py
===========================
Computes the distribution of holonomy twist angles φ(γ) = Im(log λ(γ))
for all freely-reduced words up to length 5 in π₁(M_CKM) and π₁(M_PMNS).

Tests the conjecture:
  M_CKM  (trace field sig (8,1), predominantly real):
      twist angles concentrated near 0°/180° (quasi-hyperbolic)
  M_PMNS (trace field sig (0,1), purely imaginary):
      twist angles large and spread (strongly loxodromic)

If confirmed, this provides computational evidence for the theorem:
  "K-factor for real trace field, N-factor for imaginary trace field"
  — the arithmetic basis for the KAN kernel selection rule.

Run:
  conda run -n sage python3 reproduce/twist_angle_distribution.py
"""

import numpy as np
from scipy.linalg import logm
import snappy

MAX_LEN = 5

def freely_reduced_words(max_len):
    inv = {'a': 'A', 'A': 'a', 'b': 'B', 'B': 'b'}
    stack, result = [''], []
    while stack:
        w = stack.pop()
        if w: result.append(w)
        if len(w) < max_len:
            last = w[-1] if w else None
            for c in ('a', 'b', 'A', 'B'):
                if last is None or c != inv[last]:
                    stack.append(w + c)
    return result

def get_twist_angle(rho, w):
    """
    Returns Im(log λ) in degrees, where λ is the dominant eigenvalue
    of the SL(2,C) holonomy matrix of word w.
    Returns None if element is not loxodromic.
    """
    try:
        mat = np.array(rho(w), dtype=complex)
        # Normalize to SL(2,C)
        mat = mat / np.sqrt(np.linalg.det(mat))
        eigs = np.linalg.eigvals(mat)
        # Pick the dominant eigenvalue (|λ| ≥ 1)
        lam = eigs[0] if abs(eigs[0]) >= abs(eigs[1]) else eigs[1]
        if abs(abs(lam) - 1.0) < 1e-8:
            return None  # parabolic or elliptic
        twist = np.degrees(np.imag(np.log(lam)))
        return twist
    except Exception:
        return None

words = freely_reduced_words(MAX_LEN)
print(f"Words up to length {MAX_LEN}: {len(words)}")

manifolds = {
    'M_CKM  (m006(-5,2), ITF sig (8,1))': snappy.OrientableClosedCensus[43],
    'M_PMNS (m003(-2,3), ITF ℚ(√-3)  )': snappy.OrientableClosedCensus[1],
}

results = {}

for label, M in manifolds.items():
    rho = M.polished_holonomy()
    twists = []
    for w in words:
        phi = get_twist_angle(rho, w)
        if phi is not None:
            twists.append(phi)
    twists = np.array(twists)
    results[label] = twists

    abs_twists = np.abs(twists)
    near_zero  = np.sum(abs_twists < 30)          # |φ| < 30°
    near_180   = np.sum(abs_twists > 150)         # |φ| > 150° (near ±180°)
    large      = np.sum((abs_twists >= 30) & (abs_twists <= 150))

    print(f"\n{'='*60}")
    print(f"{label}")
    print(f"{'='*60}")
    print(f"  Loxodromic words:   {len(twists)} / {len(words)}")
    print(f"  Mean |φ|:           {np.mean(abs_twists):.2f}°")
    print(f"  Median |φ|:         {np.median(abs_twists):.2f}°")
    print(f"  Std  |φ|:           {np.std(abs_twists):.2f}°")
    print(f"  |φ| < 30°  (quasi-hyperbolic): {near_zero:4d}  ({100*near_zero/len(twists):.1f}%)")
    print(f"  |φ| > 150° (near ±π):          {near_180:4d}  ({100*near_180/len(twists):.1f}%)")
    print(f"  30° ≤ |φ| ≤ 150°   (loxodromic): {large:4d}  ({100*large/len(twists):.1f}%)")
    print(f"\n  Histogram of |φ| (bin width 18°):")
    for lo in range(0, 180, 18):
        hi = lo + 18
        count = np.sum((abs_twists >= lo) & (abs_twists < hi))
        bar = '█' * (count // 20)
        print(f"    [{lo:3d}°–{hi:3d}°): {count:4d}  {bar}")

    # Specific words of interest
    print(f"\n  Canonical triple twist angles:")
    if 'CKM' in label:
        triple = ['aaab', 'aabb', 'bAbAB']
    else:
        triple = ['aa', 'aaB', 'baa']
    for w in triple:
        phi = get_twist_angle(rho, w)
        print(f"    φ({w}) = {phi:.4f}°")

# Summary
print(f"\n{'='*60}")
print("SUMMARY: Twist angle distribution comparison")
print(f"{'='*60}")
for label, twists in results.items():
    abs_t = np.abs(twists)
    print(f"\n{label}")
    print(f"  Mean |φ| = {np.mean(abs_t):.1f}°  (larger → more loxodromic)")
    frac_small = np.mean(abs_t < 45)
    print(f"  Fraction with |φ| < 45°: {frac_small:.3f}")
    frac_large = np.mean(abs_t > 135)
    print(f"  Fraction with |φ| > 135°: {frac_large:.3f}")

print(f"\nConjecture check:")
print("  IF M_CKM has higher fraction near 0°/180° → quasi-hyperbolic → K-factor")
print("  IF M_PMNS has uniform large angles → loxodromic → N-factor")
