# SUPERSEDED -- kept for the record, not to be trusted on its own.
# This first attempt builds a_mat_L, b_mat_L by identifying each of the
# 8 matrix entries of a,b SEPARATELY via algdep+QQbar-root-matching,
# then feeding all 8 into number_field_elements_from_algebraics at
# once. That construction turned out to be WRONG: a_mat_L^2 != the
# already-trusted exact K-matrix for 'aa' (diagnosed in
# scratch_diag2.sage, not committed), most likely a wrong-root pick
# among close QQbar candidates for one or more of the 8 independent
# entries. Consequently this script's final eps(a)/eps(b)="neither
# fixes nor swaps" result is WRONG -- a computational artifact, not a
# mathematical finding. See m009_task2_epsilon_v2.sage for the fixed,
# cross-validated version (builds a,b via Cayley-Hamilton from the
# already-trusted 'aa','bb' matrices plus a single trace value each --
# far more robust than matching 8 entries independently -- and
# confirms the result against an independent 'ab'-based check).
#
# Task 2: finish computing eps(a), eps(b) -- does the raw holonomy
# generator a (resp. b) preserve or swap the branch vertices M0,M1 at
# pbar? L = Q[y]/(y^4-y^3+y+1) is where a,b's entries actually live
# (found via number_field_elements_from_algebraics); pbar is INERT in
# L/K (residue degree 2, unramified) -- confirmed via ideal
# factorization -- so the relevant completion is Q_4, the unramified
# quadratic extension of Q_2. Root-finding is done by factoring the
# quartic over Q_2 first (works reliably) and finding roots of the
# unramified quadratic factor in Q_4 (factoring the quartic directly
# over Q_4 hits a Sage/Singular backend limitation for p-adic
# extension rings -- worked around this way instead).
#
# NOTE: also, the "pbar is inert" claim below is embedding-dependent --
# the v2 script found that the embedding actually consistent with a,b
# (verified numerically) gives pbar RAMIFIED, not inert. Both this
# script's field-identification method AND its embedding choice turned
# out not to carry over reliably; see v2 for the trustworthy version.

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

print("Loading m009 holonomy, extracting a, b, aa (for beta) exactly...")
M = snappy.Manifold('m009')
G = M.polished_holonomy(bits_prec=300)
raw = {wd: G.SL2C(wd) for wd in ['a', 'b', 'aa']}
beta = CCf(raw['aa'][0, 1])

entries = []
labels = []
for wd in ['a', 'b']:
    m = raw[wd]
    a_, b_, c_, d_ = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
    new_b, new_c = beta * b_, c_ / beta
    for val, lab in [(a_, f"{wd}[0,0]"), (new_b, f"{wd}[0,1]"),
                      (new_c, f"{wd}[1,0]"), (d_, f"{wd}[1,1]")]:
        entries.append(val)
        labels.append(lab)

qq_entries = []
for val in entries:
    dep = algdep(val, 8, known_bits=250)
    roots = dep.roots(QQbar, multiplicities=False)
    best, best_err = None, None
    for r in roots:
        err = abs(CCf(r) - val)
        if best_err is None or err < best_err:
            best_err, best = err, r
    qq_entries.append(best)

Lfield, field_elts, hom = number_field_elements_from_algebraics(qq_entries, minimal=True)
print("L =", Lfield, " degree", Lfield.degree())
assert str(Lfield.polynomial()) == 'y^4 - y^3 + y + 1', f"unexpected field polynomial: {Lfield.polynomial()}"

a_mat_L = Matrix(Lfield, 2, 2, field_elts[0:4])
b_mat_L = Matrix(Lfield, 2, 2, field_elts[4:8])
print("a (in L, beta-rescaled basis):", a_mat_L.list())
print("b (in L, beta-rescaled basis):", b_mat_L.list())

embs = K.embeddings(Lfield)
phi = embs[0]
print()
print("Using phi = embs[0]: w ->", phi(w))

pbar_K = K.ideal(1 - w)
pbar_in_L = Lfield.ideal([phi(g) for g in pbar_K.gens()])
fact_pbar = pbar_in_L.factor()
print("pbar in L factors as:", fact_pbar, " (expect single inert prime, f=2)")
assert len(fact_pbar) == 1 and fact_pbar[0][1] == 1 and fact_pbar[0][0].residue_class_degree() == 2, \
    "pbar is not inert under this embedding -- wrong choice, investigate"

######################################################################
# Factor y^4-y^3+y+1 over Q_2 (works reliably), pick the UNRAMIFIED
# quadratic factor (reduces to Y^2+Y+1 mod 2, irreducible over F_2),
# then find its roots in Q_4.
######################################################################
PREC = 150
Q2 = Qp(2, prec=PREC)
P2c = PolynomialRing(Q2, 'Y')
Yv = P2c.gen()
quartic2 = Yv**4 - Yv**3 + Yv + 1
facs2 = quartic2.factor()
unram_factor = None
for fac, e in facs2:
    coeffs_mod2 = [c.residue() for c in fac.list()]
    print("  Q2 factor mod 2 coeffs (const,lin,quad):", coeffs_mod2)
    if coeffs_mod2 == [1, 1, 1]:
        unram_factor = fac
assert unram_factor is not None, "could not find the unramified quadratic factor"

Q4 = Qq(4, prec=PREC, names='t')
P4 = PolynomialRing(Q4, 'Y')
Y4 = P4.gen()
unram_Q4 = sum(Q4(c) * Y4**i for i, c in enumerate(unram_factor.list()))
roots_Q4 = unram_Q4.roots(multiplicities=False)
print("roots of unramified factor in Q4 (the two Frobenius conjugates):", len(roots_Q4))

######################################################################
# Consistency check against the ALREADY-ESTABLISHED pbar embedding
# (root_pbar) used throughout this session, for each candidate root.
######################################################################
P2 = PolynomialRing(Q2, 'X')
Xg = P2.gen()
roots2 = [r for r, m in (Xg**2 - Xg + 2).roots()]
root_pbar = None
for r in roots2:
    if (1 - r).valuation() > 0:
        root_pbar = r
assert root_pbar is not None


def K_to_Q2(elt, root):
    aa = K(elt)
    pol = aa.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return Q2(c0) + Q2(c1) * root


w_via_old_pipeline_Q4 = Q4(K_to_Q2(w, root_pbar))


def L_to_Q4(elt, root):
    pol = Lfield(elt).polynomial()
    return sum(QQ(c) * root**i for i, c in enumerate(pol.list()))


chosen_root = None
for cand in roots_Q4:
    phi_w_in_Q4 = L_to_Q4(phi(w), cand)
    diff = phi_w_in_Q4 - w_via_old_pipeline_Q4
    dv = diff.valuation() if diff != 0 else Infinity
    print("candidate root:", cand, " -> diff valuation:", dv)
    if dv >= PREC - 10:
        chosen_root = cand
        print("  ==> MATCHES the original pbar embedding.")

assert chosen_root is not None, "neither root matches -- embedding choice is wrong, need embs[1]"

######################################################################
# Now embed a_mat_L, b_mat_L into Q4 via chosen_root, and test against
# the branch vertices g0, g1 (rational, extend scalars to Q4 trivially).
######################################################################


def elt_to_Q4(elt):
    return L_to_Q4(elt, chosen_root)


def mat_to_Q4(m):
    return matrix(Q4, 2, 2, [elt_to_Q4(c) for c in m.list()])


a_Q4 = mat_to_Q4(a_mat_L)
b_Q4 = mat_to_Q4(b_mat_L)
print()
print("a embedded in Q4:", a_Q4.list())
print("b embedded in Q4:", b_Q4.list())

# Branch vertices g0, g1 -- rebuild via the same BT-tree search, but now
# need R embedded in Q4 too (extend the Q2 pbar-embedding of R trivially).
NEIGHBOR_STEPS = [matrix(QQ, [[2, 0], [0, 1]]), matrix(QQ, [[1, 0], [0, 2]]),
                  matrix(QQ, [[1, 0], [1, 2]])]
Id = identity_matrix(QQ, 2)


def v2q(aq):
    aq = QQ(aq)
    if aq == 0:
        return Infinity
    return aq.valuation(2)


def same_vertex_Q4(g1_, g2_):
    h = g1_.inverse() * g2_
    vals = [v2q(h[i, j]) if h.base_ring() is QQ else
            (h[i, j].valuation() if h[i, j] != 0 else Infinity)
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


# rebuild R_BASIS (exact, K) and embed into Q4 to redo the branch search
# in Q4 (should reproduce g0,g1 as before, just now over the bigger field).
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
    return exact_mats


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


mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)


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
print("Rebuilding BT-tree branch in Q4 (should reproduce size 2)...")
seed, dist = find_seed(Rloc_Q4)
branch = enumerate_branch(Rloc_Q4, seed)
print("branch size:", len(branch))
assert len(branch) == 2
g0, g1 = branch[0], branch[1]
g0_Q4, g1_Q4 = g_to_Q4(g0), g_to_Q4(g1)

print()
print("=" * 70)
print("TESTING eps(a), eps(b): does conjugation FIX g0 or SWAP to g1?")
print("=" * 70)
for name, gen_Q4 in [("a", a_Q4), ("b", b_Q4)]:
    img = gen_Q4 * g0_Q4
    fixes = same_vertex_Q4(img, g0_Q4)
    swaps = same_vertex_Q4(img, g1_Q4)
    print(f"  {name}: fixes g0={fixes}, swaps to g1={swaps}")
    assert fixes != swaps or (not fixes and not swaps), "ambiguous result -- investigate"
    if swaps:
        print(f"  ==> eps({name}) = 1 (branch-swapping)")
    elif fixes:
        print(f"  ==> eps({name}) = 0 (endpoint-preserving)")
    else:
        print(f"  ==> NEITHER -- {name} conjugation sends g0 outside the branch entirely?! investigate")
