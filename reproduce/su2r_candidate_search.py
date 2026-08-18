# su2r_candidate_search.py
# Run in WSL sage: sage su2r_candidate_search.py
#
# Structured census search for a candidate manifold to supply the missing
# SU(2)_R factor of the Pati-Salam gauge group SU(4) x SU(2)_L x SU(2)_R.
#
# Established (CLAIMS_REGISTER.md entries 1-4): m003 (cusp field Q(sqrt(-3)),
# Gal = Z/2 = Weyl(SU(2)_L)) and m019 (cusp field degree 4, Gal = S4 =
# Weyl(SU(4))) combine into a compositum of degree 8, Galois closure S4 x Z/2
# of order 48 -- the Weyl group of SU(4) x SU(2)_L. SU(2)_R is unaddressed:
# no candidate manifold has been identified whose cusp field is (a) quadratic
# (Gal = Z/2, matching Weyl(SU(2))), (b) a genuinely different field from
# K_m003 = Q(sqrt(-3)) (not a redundant duplicate of the SU(2)_L factor), and
# (c) linearly disjoint from the existing m003/m019 compositum.
#
# Search pool: all 1-cusped orientable manifolds in SnapPy's classic small
# census with 2-6 ideal tetrahedra (tets=2..6). This is the same regime the
# 11 manifolds already in use (m003 through m178) are drawn from (max 5
# tetrahedra among them) -- one step of headroom added, not an arbitrarily
# large pool chosen to guarantee a hit.
#
# Method:
#   Stage 1 (screen, cheap): compute cusp shape minimal polynomial and its
#     degree/discriminant for every manifold in the pool. Keep only quadratic
#     fields with discriminant != -3 (excludes duplicates of K_m003).
#   Stage 2 (disjointness check, cheap): for each surviving candidate, verify
#     the compositum with K_m003 x K_m019 (known degree 8) has degree 16 --
#     the arithmetic-independence certificate, same style as entry 13.
#   Stage 3 (closure, expensive -- top candidates only): for the smallest-
#     volume candidates that pass Stage 2, compute the full Galois closure
#     order/structure of the 3-field compositum.
#
# No result from this script should be treated as more than [Computed] until
# independently re-run; this is a discovery pass, not a proof.

import snappy
from sage.all import algdep, QQ, NumberField, RealField, ComplexField

R = QQ['x']
CF = ComplexField(300)

RESIDUAL_THRESHOLD = 1e-60  # well within the 300-bit (~90 decimal digit) budget

def true_minimal_poly(cs, max_degree=6):
    """Find the genuine minimal polynomial of cs by factoring algdep's output
    and keeping only the irreducible factor that actually vanishes at cs to
    high precision. Returns None if no factor clears RESIDUAL_THRESHOLD.

    This exists because algdep(cs, N) with N below the true degree does not
    fail or return 0 -- it returns a spurious LLL-fitted polynomial with no
    warning. Naively trusting the first low-degree result (as an earlier
    version of this script did) misclassified m019 (true degree 4) as a
    bogus degree-2 field with huge, meaningless coefficients."""
    best = None  # (residual, poly)
    cs_c = CF(cs)
    for N in range(2, max_degree + 1):
        p = algdep(cs, N)
        if p == 0:
            continue
        for factor, mult in p.factor():
            if factor.degree() < 1:
                continue
            try:
                residual = abs(CF(factor(cs_c)))
            except Exception:
                continue
            if best is None or residual < best[0]:
                best = (residual, factor / factor.leading_coefficient())
    if best is not None and best[0] < RESIDUAL_THRESHOLD:
        return best[1], best[0]
    return None, None

K3 = NumberField(R([1, -1, 1]), 'a')          # m003: x^2 - x + 1, disc -3
K19 = NumberField(R([-1, -1, 0, 0, 1]), 'b')  # m019: x^4 - x - 1

print("Reference fields:")
print(f"  K_m003 degree {K3.degree()}, disc {K3.discriminant()}")
print(f"  K_m019 degree {K19.degree()}, disc {K19.discriminant()}")
comp19 = K3.composite_fields(K19)
deg8 = [F for F in comp19 if F.degree() == 8][0]
print(f"  K_m003.K_m019 compositum degree {deg8.degree()} (expect 8)")
print()

pool = []
for t in range(2, 7):
    pool.extend(list(snappy.OrientableCuspedCensus(cusps=1, tets=t)))
print(f"Search pool: {len(pool)} one-cusped manifolds, tets=2..6")
print()

# --- Stage 1: screen for quadratic cusp fields, disc != -3 ---
quadratic_candidates = []
skipped = 0
for M in pool:
    name = M.name()
    if name in ("m003", "m004"):  # m003 itself, m004 shares disc -3 (mirror-ish)
        continue
    try:
        cs = M.cusp_info('shape', bits_prec=300)[0]
        poly, residual = true_minimal_poly(cs, max_degree=6)
        if poly is None or poly.degree() != 2:
            continue
        if not poly.is_irreducible():
            continue
        disc = poly.discriminant()
        if disc == -3:
            continue
        # sanity check: reject anything with implausibly large coefficients --
        # a genuine low-degree cusp field from a small census manifold should
        # have modest height; anything else signals a residual-check gap
        if max(abs(c.numerator()) for c in poly.coefficients()) > 10**6 or \
           max(abs(c.denominator()) for c in poly.coefficients()) > 10**6:
            continue
        quadratic_candidates.append((name, M.volume(), M.num_tetrahedra(), poly, disc, residual))
    except Exception:
        skipped += 1
        continue

print(f"Stage 1: {len(quadratic_candidates)} quadratic-cusp-field candidates found "
      f"(disc != -3), {skipped} manifolds skipped on error")
quadratic_candidates.sort(key=lambda row: row[1])  # sort by volume ascending
print()

# --- Stage 2: disjointness screen against K_m003.K_m019 (degree 8) ---
print(f"{'Manifold':<10} {'Vol':<8} {'Tets':<5} {'MinPoly':<20} {'Disc':<8} {'Residual':<10} {'CompDeg16?'}")
print("-" * 85)
disjoint_survivors = []
for name, vol, tets, poly, disc, residual in quadratic_candidates:  # verified list is small now
    try:
        Kc = NumberField(poly, 'c')
        comp = deg8.composite_fields(Kc)
        best = max(F.degree() for F in comp)
        ok = (best == 16)
        print(f"{name:<10} {vol:<8.4f} {tets:<5} {str(poly):<20} {str(disc):<8} {float(residual):<10.2e} {ok}")
        if ok:
            disjoint_survivors.append((name, vol, tets, poly, disc))
    except Exception as e:
        print(f"{name:<10} {vol:<8.4f} {tets:<5} {str(poly):<20} {str(disc):<8} {float(residual):<10.2e} ERROR: {e}")

print()
print(f"Stage 2: {len(disjoint_survivors)} candidates linearly disjoint from K_m003.K_m019")
print()

# --- Stage 3: full closure on the smallest-volume survivors ---
print("Stage 3: Galois closure of the full 3-field compositum (top 3 by volume)")
print("-" * 70)
for name, vol, tets, poly, disc in disjoint_survivors[:3]:
    try:
        Kc = NumberField(poly, 'c')
        comp3 = deg8.composite_fields(Kc)
        F16 = [F for F in comp3 if F.degree() == 16][0]
        closure = F16.galois_closure('z')
        G = closure.galois_group()
        print(f"{name}: vol={vol:.4f}, closure degree={closure.degree()}, "
              f"Galois group order={G.order()}, structure={G.structure_description()}")
    except Exception as e:
        print(f"{name}: closure computation failed: {e}")
