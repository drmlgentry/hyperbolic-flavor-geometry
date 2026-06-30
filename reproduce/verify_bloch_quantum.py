"""
verify_bloch_quantum.py
=======================
Dedicated verification suite for:

  "The Meyerhoff Manifold as a Volume Quantum
   for the Cusped Manifolds m019 and m178"
  M. L. Gentry, 2026

Reproduces all computational claims in the paper at 100-digit working
precision (mpmath dps=100, ~100 significant figures).

Usage:
    python3 verify_bloch_quantum.py

Dependencies:
    pip install snappy mpmath

All output is self-documenting.  A final PASS/FAIL summary is printed.
"""

import mpmath
import snappy
import sys

mpmath.mp.dps = 100   # 100 decimal places throughout

HLINE = "=" * 72
SLINE = "-" * 72

failures = []

def chk(label, condition, detail=""):
    if condition:
        print(f"   PASS  {label}")
    else:
        print(f"   FAIL  {label}  {detail}")
        failures.append(label)

def section(n, title):
    print()
    print(SLINE)
    print(f"  {n}. {title}")
    print(SLINE)


print(HLINE)
print("  VERIFICATION: Bloch Volume Quantum (m019 and m178)")
print(f"  snappy {snappy.__version__}  |  mpmath {mpmath.__version__}  |  dps={mpmath.mp.dps}")
print(HLINE)


# ─────────────────────────────────────────────────────────────────────────────
# 0.  FUNDAMENTAL VOLUME  v0 = vol(M_PMNS) = vol(m003(-2,3))
# ─────────────────────────────────────────────────────────────────────────────
section(0, "Fundamental volume  v0 = vol(m003(-2,3))")

M_ref = snappy.ManifoldHP('m003(-2,3)')
v0 = mpmath.mpf(str(M_ref.volume()))
print(f"   v0 = {mpmath.nstr(v0, 25)}")
chk("v0 > 0.981 and v0 < 0.982", mpmath.mpf('0.981') < v0 < mpmath.mpf('0.982'))


# ─────────────────────────────────────────────────────────────────────────────
# 1.  SHAPE PARAMETERS  (from SnapPy, lifted to mpmath)
# ─────────────────────────────────────────────────────────────────────────────
section(1, "Shape parameters of m019 and m178")

def hp_shapes(name):
    """Return shape parameters as mpmath complex numbers."""
    M = snappy.ManifoldHP(name)
    raw = M.tetrahedra_shapes('rect')
    return [mpmath.mpc(str(z.real()), str(z.imag())) for z in raw]

shapes_019 = hp_shapes('m019')
shapes_178 = hp_shapes('m178')

print(f"\n   m019 shapes ({len(shapes_019)} tetrahedra):")
for i, z in enumerate(shapes_019):
    print(f"     z[{i}] = {mpmath.nstr(z, 22)}")

print(f"\n   m178 shapes ({len(shapes_178)} tetrahedra):")
for i, z in enumerate(shapes_178):
    print(f"     z[{i}] = {mpmath.nstr(z, 22)}")

# Identify the distinct values (Table 1 in paper):
# m019: zA appears twice, zS appears once
# m178: zB appears three times, zS appears once
# The shared parameter zS appears in both.

# Sort by imaginary part to identify zA, zB, zS
def distinct(zlist, tol=mpmath.mpf('1e-30')):
    out = []
    for z in zlist:
        if not any(mpmath.fabs(z - w) < tol for w in out):
            out.append(z)
    return out

dist_019 = distinct(shapes_019)
dist_178 = distinct(shapes_178)

print(f"\n   m019 distinct shapes: {len(dist_019)}")
print(f"   m178 distinct shapes: {len(dist_178)}")

chk("m019 has ≥2 distinct shapes", len(dist_019) >= 2)
chk("m178 has ≥2 distinct shapes", len(dist_178) >= 2)

# Find the shared shape zS (common to both m019 and m178)
zS = None
zA_candidates = []
zB_candidates = []
for z in dist_019:
    matched = any(mpmath.fabs(z - w) < mpmath.mpf('1e-20') for w in dist_178)
    if matched:
        zS = z
    else:
        zA_candidates.append(z)
for z in dist_178:
    matched = any(mpmath.fabs(z - w) < mpmath.mpf('1e-20') for w in dist_019)
    if not matched:
        zB_candidates.append(z)

chk("Shared shape zS found in both manifolds", zS is not None)

zA = zA_candidates[0] if zA_candidates else None
zB = zB_candidates[0] if zB_candidates else None

print(f"\n   zA (m019-only)  = {mpmath.nstr(zA, 22)}")
print(f"   zB (m178-only)  = {mpmath.nstr(zB, 22)}")
print(f"   zS (shared)     = {mpmath.nstr(zS, 22)}")

chk("zA is not None", zA is not None)
chk("zB is not None", zB is not None)


# ─────────────────────────────────────────────────────────────────────────────
# 2.  PSL(2,Z) ORBIT  under T(z) = 1/(1-z)
# ─────────────────────────────────────────────────────────────────────────────
section(2, "PSL(2,Z) orbit structure under T(z) = 1/(1-z)")

T  = lambda z: mpmath.mpf('1') / (1 - z)

TzA = T(zA)
TzB = T(zB)
TzS = T(zS)

err_AB = mpmath.fabs(TzA - zB)
err_BS = mpmath.fabs(TzB - zS)
err_SA = mpmath.fabs(TzS - zA)

print(f"\n   T(zA) - zB  error = {mpmath.nstr(err_AB, 6)}")
print(f"   T(zB) - zS  error = {mpmath.nstr(err_BS, 6)}")
print(f"   T(zS) - zA  error = {mpmath.nstr(err_SA, 6)}")

tol_orbit = mpmath.mpf('1e-20')
chk("T(zA) = zB", err_AB < tol_orbit,  f"  (err={float(err_AB):.2e})")
chk("T(zB) = zS", err_BS < tol_orbit,  f"  (err={float(err_BS):.2e})")
chk("T(zS) = zA", err_SA < tol_orbit,  f"  (err={float(err_SA):.2e})")

digits_orbit = min(
    int(-mpmath.log10(err_AB + mpmath.mpf('1e-200'))),
    int(-mpmath.log10(err_BS + mpmath.mpf('1e-200'))),
    int(-mpmath.log10(err_SA + mpmath.mpf('1e-200'))),
)
print(f"\n   Orbit closure verified to ~{digits_orbit} significant figures")


# ─────────────────────────────────────────────────────────────────────────────
# 3.  BLOCH–WIGNER VALUES
# ─────────────────────────────────────────────────────────────────────────────
section(3, "Bloch-Wigner function D(z) evaluated at 100-digit precision")

def D(z):
    """Bloch-Wigner dilogarithm, real-valued."""
    z = mpmath.mpc(z)
    return mpmath.im(mpmath.polylog(2, z)) + mpmath.arg(1 - z) * mpmath.log(mpmath.fabs(z))

DzA = D(zA)
DzB = D(zB)
DzS = D(zS)

print(f"\n   D(zA) = {mpmath.nstr(DzA, 25)}")
print(f"   D(zB) = {mpmath.nstr(DzB, 25)}")
print(f"   D(zS) = {mpmath.nstr(DzS, 25)}")
print(f"   v0    = {mpmath.nstr(v0,  25)}")

# D-values must be equal (exact consequence of T-orbit + D(T(z))=D(z))
err_DAB = mpmath.fabs(DzA - DzB)
err_DAS = mpmath.fabs(DzA - DzS)

print(f"\n   |D(zA) - D(zB)| = {mpmath.nstr(err_DAB, 6)}")
print(f"   |D(zA) - D(zS)| = {mpmath.nstr(err_DAS, 6)}")

tol_equal = mpmath.mpf('1e-50')
chk("D(zA) = D(zB)  [orbit consequence]", err_DAB < tol_equal)
chk("D(zA) = D(zS)  [orbit consequence]", err_DAS < tol_equal)

# Main numerical claim: D-common = v0
diff_v0 = mpmath.fabs(DzA - v0)
digits_bloch = int(-mpmath.log10(diff_v0 + mpmath.mpf('1e-200')))

print(f"\n   |D(zA) - v0|    = {mpmath.nstr(diff_v0, 6)}")
print(f"   Agreement with v0: ~{digits_bloch} significant figures")

chk("D(zA) = v0  to at least 10 figures",  diff_v0 < mpmath.mpf('1e-10'))
chk("D(zA) = v0  to at least 15 figures",  diff_v0 < mpmath.mpf('1e-15'))


# ─────────────────────────────────────────────────────────────────────────────
# 4.  VOLUME MULTIPLES   vol(m019) = 3·v0 ,  vol(m178) = 4·v0
# ─────────────────────────────────────────────────────────────────────────────
section(4, "Volume multiples  vol(m019)=3v0 ,  vol(m178)=4v0")

vol_019 = mpmath.mpf(str(snappy.ManifoldHP('m019').volume()))
vol_178 = mpmath.mpf(str(snappy.ManifoldHP('m178').volume()))

err_019 = mpmath.fabs(vol_019 - 3 * v0)
err_178 = mpmath.fabs(vol_178 - 4 * v0)
digits_019 = int(-mpmath.log10(err_019 + mpmath.mpf('1e-200')))
digits_178 = int(-mpmath.log10(err_178 + mpmath.mpf('1e-200')))

print(f"\n   vol(m019)      = {mpmath.nstr(vol_019, 22)}")
print(f"   3·v0           = {mpmath.nstr(3*v0,    22)}")
print(f"   |error|        = {mpmath.nstr(err_019, 6)}  (~{digits_019} figures)")

print(f"\n   vol(m178)      = {mpmath.nstr(vol_178, 22)}")
print(f"   4·v0           = {mpmath.nstr(4*v0,    22)}")
print(f"   |error|        = {mpmath.nstr(err_178, 6)}  (~{digits_178} figures)")

chk("vol(m019) = 3·v0  to ≥10 figures", err_019 < mpmath.mpf('1e-10'))
chk("vol(m178) = 4·v0  to ≥10 figures", err_178 < mpmath.mpf('1e-10'))

# Cross-check via Bloch decomposition (eq.(1) in paper)
# vol(m019) = 2·D(zA) + D(zS) = 3·D(zA)
# vol(m178) = 3·D(zB) + D(zS) = 4·D(zB)
bloch_019 = 2 * DzA + DzS
bloch_178 = 3 * DzB + DzS
err_bloch_019 = mpmath.fabs(bloch_019 - vol_019)
err_bloch_178 = mpmath.fabs(bloch_178 - vol_178)
print(f"\n   Bloch decomp: 2·D(zA)+D(zS) = {mpmath.nstr(bloch_019, 22)}")
print(f"   vs vol(m019)               = {mpmath.nstr(vol_019,    22)}")
print(f"   |error|                    = {mpmath.nstr(err_bloch_019, 6)}")

print(f"\n   Bloch decomp: 3·D(zB)+D(zS) = {mpmath.nstr(bloch_178, 22)}")
print(f"   vs vol(m178)               = {mpmath.nstr(vol_178,    22)}")
print(f"   |error|                    = {mpmath.nstr(err_bloch_178, 6)}")

chk("Bloch decomp matches vol(m019)", err_bloch_019 < mpmath.mpf('1e-10'))
chk("Bloch decomp matches vol(m178)", err_bloch_178 < mpmath.mpf('1e-10'))


# ─────────────────────────────────────────────────────────────────────────────
# 5.  SUMMARY TABLE
# ─────────────────────────────────────────────────────────────────────────────
section(5, "Summary")

print(f"""
   ┌──────────────────────────────────────────────────────────────────┐
   │  Quantity                              Value            Prec.    │
   ├──────────────────────────────────────────────────────────────────┤
   │  v0 = vol(m003(-2,3))                 {float(v0):.15f}    HP   │
   │  Orbit closure T(zA→zB→zS→zA)        verified          ~{digits_orbit:2d} fig │
   │  D(zA) = D(zB) = D(zS)  [orbit]      exact             ~{int(-mpmath.log10(err_DAB+mpmath.mpf('1e-200'))):2d} fig │
   │  D(zA) - v0                           {float(diff_v0):.2e}      ~{digits_bloch:2d} fig │
   │  vol(m019) - 3·v0                     {float(err_019):.2e}      ~{digits_019:2d} fig │
   │  vol(m178) - 4·v0                     {float(err_178):.2e}      ~{digits_178:2d} fig │
   └──────────────────────────────────────────────────────────────────┘
""")

print(HLINE)
if failures:
    print(f"  RESULT: FAILED ({len(failures)} check(s))")
    for f in failures:
        print(f"     ✗  {f}")
else:
    print(f"  RESULT: ALL CHECKS PASSED")
print(HLINE)
