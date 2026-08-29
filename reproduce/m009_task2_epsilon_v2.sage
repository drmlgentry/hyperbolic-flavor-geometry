# Task 2, robust redo: a = (a^2+I)/tr(a) via Cayley-Hamilton (det a=1),
# with a^2='aa' ALREADY exact over K (well-tested all session) and
# tr(a) identified as a SINGLE algebraic number (far more robust than
# matching 8 separate matrix entries independently, which produced an
# inconsistent a^2 != 'aa' in the first attempt -- diagnosed and fixed
# here). w, tr(a), tr(b) are all found in ONE common field via
# number_field_elements_from_algebraics for internal consistency.

import snappy
from sage.all import (ComplexField, algdep, QQ, QQbar, Qq, Qp, PolynomialRing,
                       matrix, Matrix, polygen, Infinity, identity_matrix, vector)
from sage.rings.qqbar import number_field_elements_from_algebraics

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
CCf = ComplexField(300)


def exact_K_element(numval, label):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        return None
    if dep.degree() == 1:
        return K(-dep[0] / dep[1])
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        return None
    best, best_err = None, None
    for r, mult in roots:
        err = abs(CCf(r) - numval)
        if best_err is None or err < best_err:
            best_err, best = err, r
    return best


def get_conjugated_exact_matrices(name):
    Mm = snappy.Manifold(name)
    Gg = Mm.polished_holonomy(bits_prec=300)
    words = ['aa', 'bb', 'ab', 'ba']
    raw_ = {wd: Gg.SL2C(wd) for wd in words}
    beta_ = CCf(raw_['aa'][0, 1])
    exact_mats = {}
    for wd in words:
        m = raw_[wd]
        a_, b_, c_, d_ = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
        new_b, new_c = beta_ * b_, c_ / beta_
        ea = exact_K_element(a_, f"{wd}[0,0]")
        eb = exact_K_element(new_b, f"{wd}[0,1]")
        ec = exact_K_element(new_c, f"{wd}[1,0]")
        ed = exact_K_element(d_, f"{wd}[1,1]")
        exact_mats[wd] = Matrix(K, [[ea, eb], [ec, ed]])
    return exact_mats, Gg


def coord(m2x2):
    return vector(K, [m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]])


def build_order_basis(mats):
    I2 = Matrix(K, [[1, 0], [0, 1]])
    gens4 = [mats['aa'], mats['bb'], mats['ab'], mats['ba']]
    all_mats = [I2] + gens4
    for m1 in gens4:
        for m2 in gens4:
            all_mats.append(m1 * m2)
    scale = 2
    scaled_vecs = [scale * coord(m2x2) for m2x2 in all_mats]
    OK = K.ring_of_integers()
    A = Matrix(OK, scaled_vecs)
    H = A.hermite_form()
    basis_scaled = [H[i] for i in range(H.nrows()) if not H[i].is_zero()]
    basis_R = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]
    return basis_R


print("Recomputing exact_mats (aa,bb,ab,ba) and R_BASIS...")
exact_mats, G = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(exact_mats)
print("Done.")

######################################################################
# Identify tr(a), tr(b) as elements of a common field with w, via a
# single robust joint call.
######################################################################
raw_a = G.SL2C('a')
raw_b = G.SL2C('b')
tr_a_num = CCf(raw_a.trace())
tr_b_num = CCf(raw_b.trace())
print("tr(a) numeric:", tr_a_num)
print("tr(b) numeric:", tr_b_num)

targets = [w_num, tr_a_num, tr_b_num]
qq_targets = []
for val in targets:
    dep = algdep(val, 4, known_bits=250)
    roots = dep.roots(QQbar, multiplicities=False)
    best, best_err = None, None
    for r in roots:
        err = abs(CCf(r) - val)
        if best_err is None or err < best_err:
            best_err, best = err, r
    qq_targets.append(best)

Lfield, field_elts, hom = number_field_elements_from_algebraics(qq_targets, minimal=True)
w_in_L, tra_in_L, trb_in_L = field_elts
print()
print("Common field L2:", Lfield, " degree:", Lfield.degree())
print("w_in_L:", w_in_L)
print("tr(a)_in_L:", tra_in_L)
print("tr(b)_in_L:", trb_in_L)

# phi: K -> L2, determined by w -> w_in_L (must be a ring hom -- verify
# it respects w's minimal polynomial as a sanity check).
assert (w_in_L**2 - w_in_L + 2) == 0, "w_in_L does not satisfy K's defining relation -- bug"
print("Sanity check w_in_L^2 - w_in_L + 2 == 0: OK")


def phi(k_elt):
    kk = K(k_elt)
    pol = kk.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return c0 + c1 * w_in_L


I2_L = Matrix(Lfield, [[1, 0], [0, 1]])
aa_L = Matrix(Lfield, [[phi(c) for c in row] for row in exact_mats['aa'].rows()])
bb_L = Matrix(Lfield, [[phi(c) for c in row] for row in exact_mats['bb'].rows()])

a_exact = (aa_L + I2_L) / tra_in_L
b_exact = (bb_L + I2_L) / trb_in_L
print()
print("a_exact (via Cayley-Hamilton):", a_exact.list())
print("b_exact (via Cayley-Hamilton):", b_exact.list())
print("det(a_exact):", a_exact.det(), " det(b_exact):", b_exact.det())

######################################################################
# Cross-check: does a_exact numerically match raw_a (the actual SnapPy
# holonomy matrix for 'a', beta-rescaled)?
######################################################################
Lemb = Lfield.embeddings(ComplexField(300))
# There are TWO embeddings matching w_in_L -> w_num (since [L2:K]=2) --
# try both, don't just take the first.
candidates_emb = [e for e in Lemb if abs(CCf(e(w_in_L)) - w_num) < 1e-50]
print()
print("Number of L2 embeddings matching w_in_L -> w_num:", len(candidates_emb))
assert len(candidates_emb) >= 1, "no L2 embedding matches w_num"

beta = CCf(G.SL2C('aa')[0, 1])
raw_a_rescaled = matrix(CCf, [[CCf(raw_a[0, 0]), beta * CCf(raw_a[0, 1])],
                               [CCf(raw_a[1, 0]) / beta, CCf(raw_a[1, 1])]])
Lemb_correct = None
for e in candidates_emb:
    a_numeric_check = matrix(CCf, 2, 2, [e(c) for c in a_exact.list()])
    diff = max(abs(a_numeric_check[i, j] - raw_a_rescaled[i, j]) for i in range(2) for j in range(2))
    print("  embedding candidate: diff =", diff)
    if diff < 1e-80:
        Lemb_correct = e

assert Lemb_correct is not None, "a_exact does not match the actual holonomy matrix under EITHER candidate embedding -- still broken"
print("CONFIRMED: a_exact matches the actual holonomy generator numerically.")

######################################################################
# Same consistency re-check as before: locate pbar in L2, find Q4
# embedding, verify against the established root_pbar.
######################################################################
embsK = K.embeddings(Lfield)
phiK = [e for e in embsK if e(w) == w_in_L]
assert len(phiK) == 1
phiK = phiK[0]
pbar_K = K.ideal(1 - w)
pbar_in_L = Lfield.ideal([phiK(g) for g in pbar_K.gens()])
fact_pbar = pbar_in_L.factor()
print()
print("pbar in L2 factors as:", fact_pbar)
# NOTE: unlike the earlier (differently-constructed, isomorphic but NOT
# the same embedding) attempt, THIS specific phiK -- the one actually
# consistent with a_exact/b_exact, verified numerically above -- gives
# pbar RAMIFIED (e=2, f=1), not inert. Trust the one tied to a validated
# construction; branch accordingly instead of asserting "inert".
is_inert = (len(fact_pbar) == 1 and fact_pbar[0][1] == 1 and fact_pbar[0][0].residue_class_degree() == 2)
is_ramified = (len(fact_pbar) == 1 and fact_pbar[0][1] == 2 and fact_pbar[0][0].residue_class_degree() == 1)
print("inert:", is_inert, " ramified:", is_ramified)
assert is_inert or is_ramified, f"unexpected factorization pattern: {fact_pbar}"

PREC = 150
Q2 = Qp(2, prec=PREC)
P2c = PolynomialRing(Q2, 'Y')
Yv = P2c.gen()
Lpoly_over_Q = Lfield.polynomial()
quartic2 = sum(Q2(QQ(c)) * Yv**i for i, c in enumerate(Lpoly_over_Q.list()))
facs2 = quartic2.factor()
target_pattern = [1, 1, 1] if is_inert else [1, 0, 1]
chosen_factor = None
for fac, e in facs2:
    coeffs_mod2 = [c.residue() for c in fac.list()]
    if fac.degree() == 2 and coeffs_mod2 == target_pattern:
        chosen_factor = fac
assert chosen_factor is not None, f"could not find factor matching pattern {target_pattern}"

if is_inert:
    Q4 = Qq(4, prec=PREC, names='t')
    P4 = PolynomialRing(Q4, 'Y')
    Y4 = P4.gen()
    unram_Q4 = sum(Q4(c) * Y4**i for i, c in enumerate(chosen_factor.list()))
    roots_Q4 = unram_Q4.roots(multiplicities=False)
else:
    # Sage's p-adic extension() needs an Eisenstein (or unramified)
    # defining polynomial -- complete the square on the general
    # quadratic factor A*Y^2+B*Y+C to get Z^2=disc/(4A^2), an Eisenstein
    # Y^2-d form (v(d)=1 expected, matching ramification).
    C0, B0, A0 = [Q2(c) for c in chosen_factor.list()]
    disc = B0**2 - 4 * A0 * C0
    dtarget = disc / (4 * A0**2)
    print("completed-square target d (want valuation 1):", dtarget.valuation())
    assert dtarget.valuation() == 1, f"unexpected valuation {dtarget.valuation()} -- not Eisenstein-ready"
    PT = PolynomialRing(Q2, 'T')
    Tg = PT.gen()
    defpoly = Tg**2 - dtarget
    Q4 = Q2.extension(defpoly, names='t')
    z = Q4.gen()  # satisfies z^2 = dtarget
    # Y = -B/(2A) + Z, so the two Y-roots are -B/(2A) +/- z
    shift = -B0 / (2 * A0)
    roots_Q4 = [Q4(shift) + z, Q4(shift) - z]
    for rt in roots_Q4:
        val = sum(Q4(c) * rt**i for i, c in enumerate(chosen_factor.list()))
        assert val == 0 or val.valuation() >= PREC - 10, f"root check failed: {val}"


def K_to_Q2(elt, root):
    aa = K(elt)
    pol = aa.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return Q2(c0) + Q2(c1) * root


P2x = PolynomialRing(Q2, 'X')
Xg = P2x.gen()
roots2 = [r for r, m in (Xg**2 - Xg + 2).roots()]
root_pbar = None
for r in roots2:
    if (1 - r).valuation() > 0:
        root_pbar = r
w_via_old_pipeline_Q4 = Q4(K_to_Q2(w, root_pbar))


def L_to_Q4(elt, root):
    pol = Lfield(elt).polynomial()
    return sum(QQ(c) * root**i for i, c in enumerate(pol.list()))


chosen_root = None
for cand in roots_Q4:
    diff2 = L_to_Q4(phiK(w), cand) - w_via_old_pipeline_Q4
    dv = diff2.valuation() if diff2 != 0 else Infinity
    if dv >= PREC - 10:
        chosen_root = cand

assert chosen_root is not None, "root mismatch -- try phiK from embsK[1] or other root"
print("chosen_root confirmed consistent with established pbar embedding.")

######################################################################
# Embed a_exact, b_exact into Q4, rebuild the branch, test eps(a),eps(b)
######################################################################


def elt_to_Q4(elt):
    return L_to_Q4(elt, chosen_root)


def mat_to_Q4(m):
    return matrix(Q4, 2, 2, [elt_to_Q4(c) for c in m.list()])


a_Q4 = mat_to_Q4(a_exact)
b_Q4 = mat_to_Q4(b_exact)

NEIGHBOR_STEPS = [matrix(QQ, [[2, 0], [0, 1]]), matrix(QQ, [[1, 0], [0, 2]]),
                  matrix(QQ, [[1, 0], [1, 2]])]
Id = identity_matrix(QQ, 2)


def same_vertex_Q4(g1_, g2_):
    h = g1_.inverse() * g2_
    vals = [h[i, j].valuation() if h[i, j] != 0 else Infinity
            for i in range(2) for j in range(2) if h[i, j] != 0]
    m = min(vals)
    dv = h.det().valuation() if h.det() != 0 else Infinity
    return dv == 2 * m


def g_to_Q4(g):
    return matrix(Q4, 2, 2, [Q4(QQ(a)) for a in g.list()])


def integral_q4(aq):
    if aq == 0:
        return True
    return aq.valuation() >= 0


def K_to_Q4(elt):
    return Q4(K_to_Q2(elt, root_pbar))


def R_to_Q4(m2x2):
    return matrix(Q4, 2, 2, [K_to_Q4(c) for c in m2x2.list()])


Rloc_Q4 = [R_to_Q4(r) for r in R_BASIS]


def R_contained_in_vertex_Q4(g, Rloc_):
    g2 = g_to_Q4(g)
    gi = g2.inverse()
    for r in Rloc_:
        Mm = gi * r * g2
        for z in Mm.list():
            if not integral_q4(z):
                return False
    return True


def neighbours(g):
    return [g * h for h in NEIGHBOR_STEPS]


def find_seed(Rloc_, RMAX=8):
    verts = [(Id, 0)]
    i = 0
    while i < len(verts):
        g, d = verts[i]
        i += 1
        if R_contained_in_vertex_Q4(g, Rloc_):
            return g, d
        if d == RMAX:
            continue
        for h in neighbours(g):
            if not any(same_vertex_Q4(g_to_Q4(h), g_to_Q4(u)) for u, _ in verts):
                verts.append((h, d + 1))
    return None, None


def enumerate_branch(Rloc_, seed, MAX_BRANCH=100):
    branch = [seed]
    i = 0
    while i < len(branch):
        g = branch[i]
        i += 1
        for h in neighbours(g):
            if any(same_vertex_Q4(g_to_Q4(h), g_to_Q4(u)) for u in branch):
                continue
            if R_contained_in_vertex_Q4(h, Rloc_):
                branch.append(h)
                if len(branch) > MAX_BRANCH:
                    raise RuntimeError("branch too large")
    return branch


print()
print("Rebuilding BT-tree branch in Q4...")
seed, dist = find_seed(Rloc_Q4)
branch = enumerate_branch(Rloc_Q4, seed)
print("branch size:", len(branch))
assert len(branch) == 2
g0, g1 = branch[0], branch[1]
g0_Q4, g1_Q4 = g_to_Q4(g0), g_to_Q4(g1)

print()
print("=" * 70)
print("TESTING eps(a), eps(b)")
print("=" * 70)
for name, gen_Q4 in [("a", a_Q4), ("b", b_Q4)]:
    img = gen_Q4 * g0_Q4
    fixes = same_vertex_Q4(img, g0_Q4)
    swaps = same_vertex_Q4(img, g1_Q4)
    print(f"  {name}: fixes g0={fixes}, swaps to g1={swaps}")
    if swaps:
        print(f"  ==> eps({name}) = 1 (branch-swapping)")
    elif fixes:
        print(f"  ==> eps({name}) = 0 (endpoint-preserving)")
    else:
        print(f"  ==> NEITHER -- unexpected, investigate further")
