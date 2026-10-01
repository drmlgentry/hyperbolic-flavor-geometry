"""
su2r_census_competitors.py
===========================
Two things, both prompted by a relayed caution not to trust "m010 is
canonical" or "m010 is arithmetic" without checking:

PART 1: m009 -- CLAIMS_REGISTER entry 14 says m009 has the same volume as
m010 and generates Q(sqrt(-7)) "via a different generator polynomial,"
dismissed there as "not a second independent candidate" without an exact
k_inv computation. Redone here exactly (same Gate-F1-style method as
m010_invariant_trace_field_certificate.py): presentation, relator variety,
parabolic condition, exact elimination of tr(a)^2-2 etc. Also compares
volumes to 300 bits, not just "numerically close."

PART 2: a real census sweep (not trusting the August screen's "1199
manifolds, minimal volume, done") for 1-cusped manifolds with cusp field
Q(sqrt(-7)) -- using algdep at degree 2 for the SCREEN only (safe for a
quadratic target; any hit is then a candidate for the same exact
elimination treatment as m009/m010, not a proof-bearing use). Sorted by
volume, so the minimal-volume question is answered by data, not assumed.

Exit status: 0 if the sweep completes (this is a measurement/enumeration).
"""
import signal
import sys

from sage.all import (PolynomialRing, QQ, ComplexField, algdep)
import snappy

try:
    sys.stdout.reconfigure(line_buffering=True)
except Exception:
    pass


class _Timeout(Exception):
    pass


def _alarm_handler(signum, frame):
    raise _Timeout()

BITS = 300
CF = ComplexField(BITS)


def banner(s):
    print("\n" + "=" * 78)
    print(s)
    print("=" * 78)


def exact_kinv_quadratic(name):
    """Mirrors m010_invariant_trace_field_certificate.py: exact Groebner
    elimination of tr(a)^2-2 on the certified geometric point (after
    imposing the parabolic condition). Returns (poly_or_None, disc_or_None,
    trace_field_min_poly_of_x, volume_highprec) or raises on any surprise
    (2 generators, 1 relator, 1 cusp assumed, as for m009/m010)."""
    import sage.all as sa
    M = snappy.Manifold(name)
    if M.num_cusps() != 1:
        return {"error": f"{name} has {M.num_cusps()} cusps, not 1"}
    G = M.fundamental_group(simplify_presentation=True)
    gens, rels = G.generators(), G.relators()
    if len(gens) != 2 or len(rels) != 1:
        return {"error": f"{name}: {len(gens)} gens, {len(rels)} rels (need 2,1)"}
    r = rels[0]

    R = PolynomialRing(QQ, names=('x', 'y', 'z', 'u'), order='lex')
    x, y, z, u = R.gens()
    A = sa.matrix(R, [[x, -1], [1, 0]])
    Ainv = sa.matrix(R, [[0, 1], [-1, x]])
    B = sa.matrix(R, [[0, -u], [-z - u, y]])
    Binv = sa.matrix(R, [[y, u], [z + u, 0]])
    MATS = {'a': A, 'A': Ainv, 'b': B, 'B': Binv}

    def word_matrix(word):
        Mw = sa.identity_matrix(R, 2)
        for c in word:
            Mw = Mw * MATS[c]
        return Mw

    Mr = word_matrix(r)
    det_rel = u * u + z * u + 1
    gens_ideal = [det_rel] + list((Mr - sa.identity_matrix(R, 2)).list())
    I = R.ideal(gens_ideal)
    Iel = I.elimination_ideal([u])
    Rxyz = PolynomialRing(QQ, names=('x', 'y', 'z'), order='lex')
    xs, ys, zs = Rxyz.gens()
    Iel3 = Rxyz.ideal([Rxyz(str(g)) for g in Iel.gens()])
    PD = Iel3.primary_decomposition()

    ok = M.verify_hyperbolicity(bits_prec=BITS)
    if not ok[0]:
        return {"error": f"{name}: verify_hyperbolicity failed"}
    Ggeom = M.polished_holonomy(bits_prec=BITS)
    tr_a = CF(Ggeom.SL2C('a').trace())
    tr_b = CF(Ggeom.SL2C('b').trace())
    tr_ab = CF((Ggeom.SL2C('a') * Ggeom.SL2C('b')).trace())

    def resid(gens_):
        vals = []
        for g in gens_:
            s = str(g).replace('^', '**')
            v = eval(s.replace('x', 'tr_a').replace('y', 'tr_b').replace('z', 'tr_ab'),
                     {'tr_a': tr_a, 'tr_b': tr_b, 'tr_ab': tr_ab})
            vals.append(abs(CF(v)))
        return max(vals) if vals else CF(0)

    best_i, best_r = None, None
    for i, comp in enumerate(PD):
        rr = resid(comp.gens())
        if best_r is None or rr < best_r:
            best_r, best_i = rr, i
    geom_comp = PD[best_i]
    if float(best_r) > 1e-30:
        return {"error": f"{name}: geometric component match poor, residual {float(best_r):.2e}"}

    periph = G.peripheral_curves()
    mu_word = periph[0][0]
    Mmu = word_matrix(mu_word)
    tr_mu_poly = (Mmu[0, 0] + Mmu[1, 1])
    Rparab = PolynomialRing(QQ, names=('x', 'y', 'z', 'u'), order='lex')
    xp, yp, zp, up = Rparab.gens()
    tr_mu_R = Rparab(str(tr_mu_poly))
    parab_gens = [Rparab(str(g)) for g in gens_ideal] + [tr_mu_R**2 - 4]
    Iparab_el = Rparab.ideal(parab_gens).elimination_ideal([up])
    Iparab_xyz = Rxyz.ideal([Rxyz(str(g)) for g in Iparab_el.gens()])
    PDparab = Iparab_xyz.primary_decomposition()

    best_i2, best_r2 = None, None
    for i, comp in enumerate(PDparab):
        rr = resid(comp.gens())
        if best_r2 is None or rr < best_r2:
            best_r2, best_i2 = rr, i
    if float(best_r2) > 1e-30:
        return {"error": f"{name}: parabolic-point match poor, residual {float(best_r2):.2e}"}
    geom_pt = PDparab[best_i2]

    elim_x = geom_pt.elimination_ideal([ys, zs])
    trace_field_polys = list(elim_x.gens())

    Rs = PolynomialRing(QQ, names=('x', 'y', 'z', 's'), order='lex')
    xs2, ys2, zs2, s = Rs.gens()
    lifted = [Rs(str(g)) for g in geom_pt.gens()] + [s - (xs2**2 - 2)]
    elim_s = Rs.ideal(lifted).elimination_ideal([xs2, ys2, zs2])
    kinv_polys = list(elim_s.gens())

    return {
        "volume": M.volume(),
        "volume_highprec": M.volume(bits_prec=BITS) if hasattr(M, 'volume') else None,
        "relator": r,
        "trace_field_min_polys": trace_field_polys,
        "kinv_min_polys": kinv_polys,
    }


def main():
    banner("PART 1: exact k_inv(m009), compared to k_inv(m010)")
    for name in ["m009", "m010"]:
        print(f"\n--- {name} ---")
        res = exact_kinv_quadratic(name)
        if "error" in res:
            print("  ERROR:", res["error"])
            continue
        print("  volume (300 bits):", res["volume_highprec"])
        print("  relator:", res["relator"])
        print("  trace field min poly(s) of x=tr(a):", res["trace_field_min_polys"])
        print("  k_inv candidate min poly(s) of tr(a)^2-2:", res["kinv_min_polys"])

    banner("Volume comparison: m009 vs m010, to 300 bits, and difference")
    v9 = snappy.Manifold("m009").volume(bits_prec=BITS)
    v10 = snappy.Manifold("m010").volume(bits_prec=BITS)
    print("vol(m009) =", v9)
    print("vol(m010) =", v10)
    print("difference =", (v9 - v10))
    print("is_isometric_to check:",
          snappy.Manifold("m009").is_isometric_to(snappy.Manifold("m010")))

    banner("PART 2: census sweep, 1-cusped manifolds, cusp field screen for disc=-7")
    print("Screening OrientableCuspedCensus manifolds up to 7 tetrahedra "
          "(a superset of the August screen's 2-6 range)")
    candidates = []
    checked = 0
    failed = 0
    def squarefree_kernel(n):
        n = int(n)
        sign = -1 if n < 0 else 1
        n = abs(n)
        d = 2
        while d * d <= n:
            while n % (d * d) == 0:
                n //= d * d
            d += 1
        return sign * n

    assert squarefree_kernel(-28) == -7
    assert squarefree_kernel(-7) == -7
    assert squarefree_kernel(-12) == -3
    assert squarefree_kernel(-4) == -1

    census = snappy.OrientableCuspedCensus(num_cusps=1)
    for M in census:
        if M.num_tetrahedra() > 7:
            continue
        checked += 1
        nm = M.name()
        if checked % 500 == 0:
            print(f"  ... progress: {checked} checked, {len(candidates)} candidates, current={nm}", flush=True)
        try:
            tau = M.cusp_info('shape', bits_prec=100)[0]
            p = algdep(tau, 2)
            # algdep(tau,2) ALWAYS returns some degree-2 "best fit" via LLL,
            # even when tau's true minimal polynomial has higher degree --
            # in that case the coefficients are huge (LLL filling the full
            # bits_prec budget with no genuine small relation), giving a
            # discriminant with ~10^18+ digits that is infeasible to factor
            # by trial division. A genuine quadratic cusp field at this
            # volume range has small coefficients (e.g. x^2+7, x^2-x+2), so
            # reject large-coefficient "hits" as LLL noise before factoring.
            max_coeff = max(abs(int(c)) for c in p.coefficients())
            if max_coeff > 10**6:
                continue
            if p.degree() == 2 and squarefree_kernel(p.discriminant()) == -7:
                vol = M.volume()
                candidates.append((nm, vol, str(p), int(p.discriminant())))
        except Exception:
            failed += 1
            continue
    print(f"checked {checked} manifolds (<=7 tetrahedra, 1 cusp), {failed} failed the screen")
    print(f"candidates with cusp field disc=-7: {len(candidates)}")
    candidates.sort(key=lambda t: t[1])
    for nm, vol, poly, disc in candidates[:30]:
        print(f"  {nm:12s}  vol={vol}  poly={poly}  disc={disc}")

    print("\nPY_EXIT=0")
    return 0


if __name__ in ("__main__", "sage.all"):
    sys.exit(main())
