"""
eisenstein_angle_test.py
========================
Tests whether M_PMNS twist angles are quantized to multiples of π/3 (60°),
consistent with the Eisenstein trace field ℚ(√-3).

In ℚ(√-3), the roots of unity are 6th roots: e^(iπk/3) for k=0,...,5,
giving angles 0°, 60°, 120°, 180°, 240°, 300°.

If M_PMNS twist angles are "Eisenstein-quantized", they should cluster
near multiples of 60° = π/3.  The gap at [36°–54°) would reflect the
repulsion away from 45° toward the nearest Eisenstein angles (0° or 60°).

By contrast, M_CKM (degree-10 trace field, no low-order roots of unity)
should show NO such quantization.

Run:
  conda run -n sage python3 reproduce/eisenstein_angle_test.py 2>/dev/null
"""

import numpy as np
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

def get_twist(rho, w):
    try:
        mat = np.array(rho(w), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        eigs = np.linalg.eigvals(mat)
        lam = eigs[0] if abs(eigs[0]) >= abs(eigs[1]) else eigs[1]
        if abs(abs(lam) - 1.0) < 1e-8:
            return None
        return np.degrees(np.imag(np.log(lam)))
    except Exception:
        return None

words = freely_reduced_words(MAX_LEN)

manifolds = {
    'M_CKM  (m006(-5,2), K₁₀ sig (8,1)  )': snappy.OrientableClosedCensus[43],
    'M_PMNS (m003(-2,3), ℚ(√-3) sig (0,1))': snappy.OrientableClosedCensus[1],
}

# Eisenstein angles: multiples of 60° mapped to [0°,180°)
eisenstein_angles = np.array([0., 60., 120., 180.])

for label, M in manifolds.items():
    rho = M.polished_holonomy()
    twists = []
    for w in words:
        phi = get_twist(rho, w)
        if phi is not None:
            twists.append(phi)
    twists = np.array(twists)
    abs_t  = np.abs(twists)

    # For each twist angle, distance to nearest Eisenstein multiple of 60°
    def dist_to_eisenstein(angle_deg):
        """Distance (in degrees) from |φ| to nearest multiple of 60°."""
        abs_a = abs(angle_deg) % 180.
        return min(abs(abs_a - e) for e in eisenstein_angles)

    dist_eisen = np.array([dist_to_eisenstein(t) for t in twists])

    print(f"\n{'='*65}")
    print(f"{label}")
    print(f"{'='*65}")
    print(f"  Words: {len(twists)}")
    print(f"\n  Distance of |φ| to nearest Eisenstein multiple of 60°:")
    print(f"    Mean distance:   {np.mean(dist_eisen):.2f}°   (0° = perfect Eisenstein)")
    print(f"    Median distance: {np.median(dist_eisen):.2f}°")
    print(f"    Std distance:    {np.std(dist_eisen):.2f}°")

    # How many are within 10° of an Eisenstein angle?
    close = np.sum(dist_eisen < 10)
    print(f"    Within 10° of Eisenstein angle: {close} ({100*close/len(twists):.1f}%)")
    close5 = np.sum(dist_eisen < 5)
    print(f"    Within  5° of Eisenstein angle: {close5} ({100*close5/len(twists):.1f}%)")

    # Fine histogram mod 60°: if Eisenstein, should cluster near 0° and 60°
    mod60 = abs_t % 60.
    print(f"\n  |φ| mod 60° distribution (Eisenstein → peaks at 0° and 60°):")
    for lo in range(0, 60, 6):
        hi = lo + 6
        count = np.sum((mod60 >= lo) & (mod60 < hi))
        bar = '█' * (count // 5)
        print(f"    [{lo:2d}°–{hi:2d}°): {count:4d}  {bar}")

    # Residues mod 60° — mean absolute deviation from 0° (i.e. from Eisenstein)
    dev_from_zero = np.minimum(mod60, 60. - mod60)  # dist to nearest multiple of 60°
    print(f"\n  Mean deviation from nearest 60°-multiple: {np.mean(dev_from_zero):.2f}°")
    print(f"  (Expected if uniform on [0°,30°): 15.00°)")
    print(f"  (Expected if Eisenstein-quantized): << 15°)")

    # Check specific Eisenstein residues
    print(f"\n  Near 0° (mod 60°):  {np.sum(mod60 < 10):3d} words")
    print(f"  Near 60° (mod 60°): {np.sum(mod60 > 50):3d} words")
    print(f"  Near 30° (anti-Eisenstein): {np.sum((mod60>20)&(mod60<40)):3d} words")

    # Also check: do traces lie near Eisenstein values?
    print(f"\n  Sample traces (first 10 length-2 words):")
    len2 = [w for w in words if len(w) == 2][:10]
    for w in len2:
        try:
            mat = np.array(rho(w), dtype=complex)
            mat = mat / np.sqrt(np.linalg.det(mat))
            tr  = float(np.real(np.trace(mat)))
            tri = float(np.imag(np.trace(mat)))
            phi = get_twist(rho, w)
            print(f"    {w:8s}: tr = {tr:+.6f} + {tri:+.6f}i   φ = {phi:.2f}°")
        except Exception:
            pass

print(f"\n{'='*65}")
print("CONCLUSION")
print(f"{'='*65}")
print("If M_PMNS shows significantly lower mean deviation from Eisenstein")
print("angles than M_CKM, the gap at [36°-54°) is likely arithmetic,")
print("forced by ℚ(√-3) quantization of twist angles to 60° multiples.")
print("If both are similar, the gap is geometric/accidental.")
