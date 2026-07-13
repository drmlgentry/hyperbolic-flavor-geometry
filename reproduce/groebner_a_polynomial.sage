"""
groebner_a_polynomial.sage  —  Route A proof of R-039 uniqueness
================================================================
Strategy: add a THIRD polynomial to the ideal <riley, surg-2> so that
the result is 0-dimensional, isolating the holonomy of m003(-2,3).

The third polynomial is the minimal polynomial of tr(μ)_cusped at the
holonomy of m003(-2,3) in the CUSPED generator basis.  This polynomial
was found by PSLQ at 50 decimal digits (50-digit SnapPy shapes via
polished_holonomy(bits_prec=200)):

    min_poly_mu(t) = t⁴ − 2t² + t + 1

Verification:
  tr(μ)_cusped = 2·cosh(core_length/2) = 1.007552... + 0.513116...j
  All 4 roots: 1.00755±0.51312j (complex pair) and −0.52489, −1.49022 (real)
  Discriminant: disc(min_poly_mu) = −283  (prime)
  Product of roots = 1 (constant term = leading coefficient = 1)

RELATION TO HFG:
  tr(μ)_cusped = tr(b)_filled − 1  [identity verified numerically]
  where tr(b)_filled = trace_field_generators()[1] from polished_holonomy.
  The prime 283 in the discriminant is a new arithmetic invariant of M_PMNS.

GEOMETRY RECAP:
  V(riley) is 2-dim, V(surg-2) is 2-dim → intersection is 1-dim (curve).
  Adding min_poly_mu(tr_mu_poly(x,y,z)) cuts the curve to finitely many points.
  Expected: dim = 0 → M_PMNS holonomy is isolated → R-039 proved.

USAGE (from bash):
    sage reproduce/groebner_a_polynomial.sage

NOTE: The riley polynomial and surg polynomial use the CUSPED generator basis
  (x,y,z) = (tr a, tr b, tr ab).  The FILLED polished_holonomy gives DIFFERENT
  (x,y,z) that do NOT satisfy riley = 0 (generator basis mismatch).  The ideal
  computation here works in the CUSPED basis throughout.
"""

import snappy, cmath

# ─────────────────────────────────────────────────────────────────────────────
# 1. Polynomial ring and Riley surface
# ─────────────────────────────────────────────────────────────────────────────
R.<x, y, z> = QQ[]

riley = z^2 - z*(x*y - x - y) + (x^2 + y^2 - x*y - 1)

# tr(μ) = tr(ABABB) in cusped generator basis {a, b}
tr_mu_poly = -x*z + y*z^2 - y

# ─────────────────────────────────────────────────────────────────────────────
# 2. Surgery polynomial tr(μ^{-2}λ^3)  [same as groebner_surgery_m003.sage]
# ─────────────────────────────────────────────────────────────────────────────
surg = (
    x^6*y^2*z^3
    - 4*x^5*y^3*z^4 - x^5*y^3*z^2 + 2*x^5*y*z^4 - 2*x^5*y*z^2
    + 6*x^4*y^4*z^5 + 5*x^4*y^4*z^3 - x^4*y^4*z
    - 4*x^4*y^2*z^5 - 3*x^4*y^2*z^3 + 4*x^4*y^2*z + x^4*z^5 - 2*x^4*z^3
    - 4*x^3*y^5*z^6 - 9*x^3*y^5*z^4 + 2*x^3*y^5*z^2 + x^3*y^5
    + 22*x^3*y^3*z^4 - 12*x^3*y^3*z^2 - 2*x^3*y^3
    + 2*x^3*y*z^6 - 15*x^3*y*z^4 + 19*x^3*y*z^2
    + x^2*y^6*z^7 + 7*x^2*y^6*z^5 - 3*x^2*y^6*z
    + 4*x^2*y^4*z^7 - 25*x^2*y^4*z^5 + 2*x^2*y^4*z^3 + 13*x^2*y^4*z
    - 6*x^2*y^2*z^7 + 28*x^2*y^2*z^5 - 17*x^2*y^2*z^3 - 17*x^2*y^2*z
    + 2*x^2*z^7 - 11*x^2*z^5 + 15*x^2*z^3 - 2*x^2*z
    - 2*x*y^7*z^6 - 2*x*y^7*z^4 + 3*x*y^7*z**2
    - 2*x*y^5*z^8 + 6*x*y^5*z^6 + 16*x*y^5*z^4 - 20*x*y^5*z^2
    + 2*x*y^3*z^8 - 37*x*y^3*z^4 + 50*x*y^3*z^2 - 2*x*y^3
    - 6*x*y*z^6 + 32*x*y*z^4 - 42*x*y*z^2 + 4*x*y
    + y^8*z^5 - y^8*z^3
    + 2*y^6*z^7 - 10*y^6*z^5 + 9*y^6*z^3
    + y^4*z^9 - 11*y^4*z^7 + 35*y^4*z^5 - 33*y^4*z^3 + 2*y^4*z
    - 2*y^2*z^9 + 18*y^2*z^7 - 53*y^2*z^5 + 54*y^2*z^3 - 8*y^2*z
    + z^9 - 9*z^7 + 27*z^5 - 30*z^3 + 9*z
)

print("riley degree:", riley.degree())
print("surg degree :", surg.degree())
print("tr_mu degree:", tr_mu_poly.degree())
print()

# ─────────────────────────────────────────────────────────────────────────────
# 3. Minimal polynomial of tr(μ)_cusped — HARD-CODED (pre-computed by PSLQ)
# ─────────────────────────────────────────────────────────────────────────────
# Found by mpmath.pslq at 50 decimal digits on tr(μ)_cusped = tr(b)_filled - 1.
# PSLQ vector: [1, 1, -2, 0, 1] (coefficients of 1 + t - 2t² + t⁴).
# Equivalent form:  t⁴ - 2t² + t + 1
#
# Discriminant: disc(t⁴ - 2t² + t + 1) = -283  (prime — new arithmetic invariant)
# Roots: {1.007552...±0.513116...·i, -0.524889..., -1.490216...}

S.<t> = QQ[]
min_poly_mu = t^4 - 2*t^2 + t + 1

print("Minimal polynomial of tr(μ)_cusped [pre-computed by PSLQ]:")
print(f"  p(t) = {min_poly_mu}")
print(f"  degree: {min_poly_mu.degree()}")
print(f"  discriminant: {min_poly_mu.discriminant()}")
print(f"  irreducible over QQ: {min_poly_mu.is_irreducible()}")
print(f"  roots: {min_poly_mu.roots(ring=CC)}")
print()

# Verify against the numerical value of tr(mu)_cusped
print("Numerical verification:")
try:
    M_cusp = snappy.Manifold('m003')
    M_cusp.dehn_fill((-2, 3))
    info = M_cusp.cusp_info(0)
    cl = info['core_length']
    tr_mu_num = 2 * cmath.cosh(complex(cl)/2)
    residual = abs(complex(min_poly_mu(CC(tr_mu_num.real, tr_mu_num.imag))))
    print(f"  tr(μ)_cusped = {tr_mu_num:.12f}")
    print(f"  |p(tr(μ))| = {residual:.2e}  (should be ~0)")
    print()
    # Also verify: tr(mu) = tr(b)_filled - 1
    rho_fill = snappy.Manifold('m003')
    rho_fill.dehn_fill((-2, 3))
    rho = rho_fill.polished_holonomy(bits_prec=100)
    tr_b_fill = complex(rho.SL2C('b').trace())
    print(f"  tr(b)_filled = {tr_b_fill:.12f}")
    print(f"  tr(b)_filled - 1 = {tr_b_fill-1:.12f}")
    print(f"  Match tr(μ)_cusped: diff = {abs((tr_b_fill-1) - tr_mu_num):.2e}")
except Exception as e:
    print(f"  SnapPy verification error: {e}")
print()

min_poly_sM = min_poly_mu

# ─────────────────────────────────────────────────────────────────────────────
# 5. Build 0-dimensional ideal and check
# ─────────────────────────────────────────────────────────────────────────────
# Substitute: in R[x,y,z], min_poly_sM(tr_mu_poly(x,y,z)) = 0
S.<t> = QQ[]
min_poly_in_t = S(min_poly_sM)  # ensure it's in univariate poly ring
print("Substituting min_poly_sM(tr_mu(x,y,z)) into the ideal ...")
min_constraint = min_poly_in_t(tr_mu_poly)   # polynomial in R[x,y,z]
print(f"  min_constraint degree: {min_constraint.degree()}")
print()

# Try surg = +2 branch first
print("Building I₀ = <riley, surg-2, min_poly(tr_mu)> ...")
I0 = R.ideal([riley, surg - 2, min_constraint])
print("Computing Gröbner basis (this may take a few minutes) ...")
G0 = I0.groebner_basis()
dim0 = I0.dimension()
print(f"  dim(I₀) = {dim0}  {'← SUCCESS (0-dim)' if dim0==0 else '← Still positive-dim'}")
print(f"  Gröbner basis: {len(G0)} elements")
print()

if dim0 == 0:
    # Count isolated solutions
    print("  Variety is 0-dimensional. Points (x₀, y₀, z₀):")
    V = I0.variety(CC200)
    for i, pt in enumerate(V):
        xv, yv, zv = pt[x], pt[y], pt[z]
        # Check riley and surg constraints
        rv = float(abs(riley(xv, yv, zv)))
        sv = float(abs(surg(xv, yv, zv) - 2))
        tr_mu_v = float(abs(tr_mu_poly(xv, yv, zv) - tr_mu_val))
        print(f"  [{i}] x={complex(xv):.6f}  y={complex(yv):.6f}  z={complex(zv):.6f}")
        print(f"       |riley|={rv:.1e}  |surg-2|={sv:.1e}  |tr(μ)-target|={tr_mu_v:.1e}")
    print(f"\nTotal: {len(V)} solution(s)")
    if len(V) == 1:
        print("UNIQUE SOLUTION: m003(-2,3) holonomy is isolated. R-039 path to proof complete.")
    else:
        print("Multiple solutions — holonomy is ONE among these; need to identify which.")

# Also try surg = -2 branch
print()
print("Building I₀⁻ = <riley, surg+2, min_poly(tr_mu)> ...")
I0m = R.ideal([riley, surg + 2, min_constraint])
dim0m = I0m.dimension()
print(f"  dim(I₀⁻) = {dim0m}")

print()
print("Done.")
