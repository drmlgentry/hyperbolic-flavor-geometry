"""
corrected_twist_distribution.py
================================
Corrects the SL(2,C) sign-lift ambiguity in twist angle measurement.

PROBLEM WITH PREVIOUS SCRIPT:
  SnapPy's polished_holonomy() returns SL(2,C) representatives, but
  chooses ±M arbitrarily for each element. For a loxodromic γ with
  dominant eigenvalue λ = exp(l/2), l = L + iθ (L>0, θ ∈ (-π,π]):

    Im(log λ)        = θ/2 ∈ (-π/2, π/2]     if SnapPy chose +M
    Im(log(-λ))      = θ/2 ± π                if SnapPy chose -M

  The previous script treated Im(log λ_dominant) as the twist angle,
  but this is only θ/2, and the ±M ambiguity adds ±π to it.

CORRECT FORMULA:
  Geodesic twist θ = 2 × φ_script  (mod 2π, reduced to (-π, π])

  In degrees:  θ = ((2 × φ_script + 180) % 360) - 180

  This is equivalent to computing complex length from the trace:
    l = 2·arccosh(tr/2),  choosing branch with Re(l) > 0
    θ = Im(l) reduced to (-π, π]

VERIFICATION:
  BB in M_CKM: φ_script = 178.31° → θ = 2×178.31 mod 360 adj = -3.38°  (near-hyperbolic)
  aaB in PMNS: φ_script = -176.73° → θ = 2×(-176.73) mod 360 adj = +6.54° (near-hyperbolic)
  aaab in CKM: φ_script = 121.73°  → θ = -116.54°   (strongly loxodromic)
  aabb in CKM: φ_script = -51.94°  → θ = -103.88°   (strongly loxodromic)

Run:
  conda run -n sage python3 reproduce/corrected_twist_distribution.py 2>/dev/null
"""

import numpy as np
import cmath
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

def phi_script(rho, w):
    """Raw Im(log λ_dominant) in degrees — has ±π ambiguity."""
    try:
        mat = np.array(rho(w), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        eigs = np.linalg.eigvals(mat)
        lam  = eigs[0] if abs(eigs[0]) >= abs(eigs[1]) else eigs[1]
        if abs(abs(lam) - 1.0) < 1e-8:
            return None
        return np.degrees(np.imag(np.log(lam)))
    except Exception:
        return None

def geodesic_twist(rho, w):
    """
    Correct geodesic twist θ ∈ (-180°, 180°], invariant under ±M lift.
    Formula: θ = 2 × φ_script  (mod 360°, then adjusted to (-180°, 180°])
    """
    phi = phi_script(rho, w)
    if phi is None:
        return None
    # Corrected formula: double, then reduce modulo 360° to (-180°, 180°]
    theta = (2.0 * phi + 180.0) % 360.0 - 180.0
    return theta

def geodesic_twist_from_trace(rho, w):
    """
    Independent verification via trace-based complex length.
    l = 2·arccosh(tr/2) choosing branch with Re(l) > 0.
    θ = Im(l) reduced to (-π, π].
    """
    try:
        mat   = np.array(rho(w), dtype=complex)
        tr    = complex(np.trace(mat))
        # Note: trace from SnapPy matrix may be ±tr(M). Try both.
        for sign in [1, -1]:
            z = sign * tr / 2.0
            w_arccosh = cmath.acosh(z)
            l = 2 * w_arccosh
            L = l.real
            if L > 1e-8:          # positive geodesic length → correct branch
                theta = l.imag    # Im(l) from cmath.acosh ∈ [0, π] × 2 = [0, 2π]
                # Reduce to (-π, π]
                while theta >  np.pi: theta -= 2 * np.pi
                while theta <= -np.pi: theta += 2 * np.pi
                return np.degrees(theta)
        return None
    except Exception:
        return None

words = freely_reduced_words(MAX_LEN)

manifolds = {
    'M_CKM  (m006(-5,2), K₁₀ sig (8,1)  )': (snappy.OrientableClosedCensus[43], ['aaab', 'aabb', 'bAbAB']),
    'M_PMNS (m003(-2,3), ℚ(√-3) sig (0,1))': (snappy.OrientableClosedCensus[1],  ['aa',   'aaB',  'baa']),
}

print("="*65)
print("SIGN CONVENTION VERIFICATION")
print("Confirms θ_corrected = 2×φ_script mod 360° matches trace method")
print("="*65)

for label, (M, canonical) in manifolds.items():
    rho = M.polished_holonomy()
    print(f"\n{label}")
    for w in canonical:
        phi   = phi_script(rho, w)
        theta = geodesic_twist(rho, w)
        theta_tr = geodesic_twist_from_trace(rho, w)
        match = "✓" if abs(theta - theta_tr) < 0.1 else "✗ MISMATCH"
        print(f"  {w:8s}: φ_script={phi:+8.3f}°  θ_correct={theta:+8.3f}°  "
              f"θ_trace={theta_tr:+8.3f}°  {match}")

print()
print("="*65)
print("CORRECTED TWIST ANGLE DISTRIBUTIONS")
print("="*65)

results = {}

for label, (M, canonical) in manifolds.items():
    rho    = M.polished_holonomy()
    twists = []
    for wrd in words:
        theta = geodesic_twist(rho, wrd)
        if theta is not None:
            twists.append(theta)
    twists = np.array(twists)
    abs_t  = np.abs(twists)
    results[label] = (twists, canonical)

    near_hyp  = np.sum(abs_t < 30)    # |θ| < 30°: quasi-hyperbolic
    mod_lox   = np.sum((abs_t >= 30) & (abs_t <= 150))
    str_lox   = np.sum(abs_t > 150)   # |θ| > 150°: strongly loxodromic (near ±π)

    print(f"\n{label}")
    print(f"  Loxodromic words: {len(twists)} / {len(words)}")
    print(f"  Mean |θ|:   {np.mean(abs_t):.2f}°")
    print(f"  Median |θ|: {np.median(abs_t):.2f}°")
    print(f"  Std |θ|:    {np.std(abs_t):.2f}°")
    print(f"\n  Regime breakdown:")
    print(f"    |θ| < 30°          (quasi-hyperbolic):  {near_hyp:4d}  ({100*near_hyp/len(twists):.1f}%)")
    print(f"    30° ≤ |θ| ≤ 150°   (moderate loxodromic): {mod_lox:4d}  ({100*mod_lox/len(twists):.1f}%)")
    print(f"    |θ| > 150°         (strongly loxodromic): {str_lox:4d}  ({100*str_lox/len(twists):.1f}%)")

    print(f"\n  Histogram of |θ| (bin 18°):")
    for lo in range(0, 180, 18):
        hi  = lo + 18
        cnt = np.sum((abs_t >= lo) & (abs_t < hi))
        bar = '█' * (cnt // 10)
        print(f"    [{lo:3d}°–{hi:3d}°): {cnt:4d}  {bar}")

    print(f"\n  Canonical triple corrected twists:")
    rho_c = M.polished_holonomy()
    for w in canonical:
        theta = geodesic_twist(rho_c, w)
        regime = ("quasi-hyperbolic" if abs(theta) < 30
                  else "strongly loxodromic" if abs(theta) > 150
                  else "moderate loxodromic")
        print(f"    θ({w:7s}) = {theta:+8.3f}°   [{regime}]")

# Summary and conjecture test
print()
print("="*65)
print("KEY COMPARISON: CANONICAL TRIPLE REGIME")
print("="*65)
for label, (twists, canonical) in results.items():
    rho = manifolds[label][0].polished_holonomy()
    triple_twists = [geodesic_twist(rho, w) for w in canonical]
    mean_abs = np.mean([abs(t) for t in triple_twists])
    print(f"\n{label}")
    print(f"  Canonical triple mean |θ| = {mean_abs:.2f}°")
    for w, t in zip(canonical, triple_twists):
        print(f"    θ({w}) = {t:+.2f}°")

print()
print("="*65)
print("CONJECTURE (K vs N selection):")
print("="*65)
labels = list(results.keys())
rho_ckm  = manifolds[labels[0]][0].polished_holonomy()
rho_pmns = manifolds[labels[1]][0].polished_holonomy()
ckm_canonical  = manifolds[labels[0]][1]
pmns_canonical = manifolds[labels[1]][1]

ckm_mean  = np.mean([abs(geodesic_twist(rho_ckm,  w)) for w in ckm_canonical])
pmns_mean = np.mean([abs(geodesic_twist(rho_pmns, w)) for w in pmns_canonical])

print(f"  M_CKM  canonical triple mean |θ| = {ckm_mean:.1f}°  → K-factor")
print(f"  M_PMNS canonical triple mean |θ| = {pmns_mean:.1f}°  → N-factor")
print()
if pmns_mean < ckm_mean:
    print("  SUPPORTED: PMNS triple is MORE quasi-hyperbolic than CKM triple.")
    print("  Quasi-hyperbolic words → nearly collinear axes → K-factor blocked → N-factor.")
    print("  CKM triple is strongly loxodromic → spread axes → K-factor works.")
else:
    print("  NOT SUPPORTED in expected direction. Further investigation needed.")
print()
print("  Physical interpretation:")
print("  - Quasi-hyperbolic (|θ| small): element ≈ pure geodesic translation.")
print("    Translation axes tend to cluster (parallel transport preserves direction).")
print("    Nearly collinear axes → symmetric overlap nearly rank-1 → K-factor floor.")
print("  - Strongly loxodromic (|θ| large): significant rotation component.")
print("    Rotation spreads axes in angular space.")
print("    Well-separated axes → non-degenerate overlap → K-factor works.")
