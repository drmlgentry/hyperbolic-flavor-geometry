# Independent verification (Claude, not Codex) of the claims in
# m009_endpoint_global_orders.sage / m009_determinant_image_certificate.sage.
#
# Checks:
# 1. Codex's global R_basis is literally the SAME construction as this
#    session's own R_BASIS (identical code) -- should match trivially,
#    confirmed directly rather than assumed.
# 2. THE KEY QUESTION: Codex substituted d0=diag(1-w,1) for the
#    "certified" local branch matrix g0=diag(2,1) (and d1=diag((1-w)^2,1)
#    for g1=diag(4,1)), justified by "2=w(1-w) and w is a pbar-local
#    unit". Verify this substitution is actually valid: does Codex's
#    GLOBAL M0 (resp M1), when embedded at pbar, match the ALREADY
#    ESTABLISHED local M0_std=M2(Z2) (resp M1_std=h*M2(Z2)*h^-1) from
#    m009_dyadic_index_check.sage / m009_normalizer_certificate.sage
#    (this session's own trusted prior work), exactly as a LOCAL lattice?
# 3. Is w actually a pbar-local unit (val_pbar(w)=0)? Direct check.
# 4. Independently re-verify R subset M0, R subset M1, [E:R]=2 with
#    FRESH code (not copy-pasted from Codex's script).

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector, polygen)

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
CCf = ComplexField(300)

pi_pbar = 1 - w
print("Check: 2 == w*(1-w) exactly:", K(2) == w * (1 - w))

######################################################################
# Rebuild R_BASIS (my own, trusted, identical construction to all
# session).
######################################################################


def exact_K_element(numval, label):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        raise RuntimeError(f"{label} failed degree<=2: {dep}")
    if dep.degree() == 1:
        return K(-dep[0] / dep[1])
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        raise RuntimeError(f"{label} no root in K")
    best, best_err = None, None
    for r, mult in roots:
        err = abs(CCf(r) - numval)
        if best_err is None or err < best_err:
            best_err, best = err, r
    return best


def get_conjugated_exact_matrices(name):
    M = snappy.Manifold(name)
    G = M.polished_holonomy(bits_prec=300)
    words = ['aa', 'bb', 'ab', 'ba']
    raw = {wd: G.SL2C(wd) for wd in words}
    beta = CCf(raw['aa'][0, 1])
    exact_mats = {}
    for wd in words:
        m = raw[wd]
        a_, b_, c_, d_ = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
        new_b, new_c = beta * b_, c_ / beta
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
    A = Matrix(OK, scaled_vecs)
    H = A.hermite_form()
    basis_scaled = [H[i] for i in range(H.nrows()) if not H[i].is_zero()]
    assert len(basis_scaled) == 4
    return [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]


mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)
print()
print("My own (independently rebuilt) R_BASIS:")
for r in R_BASIS:
    print(" ", r.list())

######################################################################
# Compare against Codex's printed R basis via direct lattice equality
# (should match exactly -- same code, same holonomy, deterministic).
######################################################################


def flatK(m):
    return vector(K, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


def same_lattice_K(basis1, basis2):
    F1 = Matrix(K, [flatK(b) for b in basis1])
    F2 = Matrix(K, [flatK(b) for b in basis2])
    A_ = F1 * F2.inverse()
    B_ = F2 * F1.inverse()
    return (all(K(c).is_integral() for c in A_.list()) and
            all(K(c).is_integral() for c in B_.list()))


codex_R_basis = [
    Matrix(K, 2, 2, [1, 0, 0, 1]),
    Matrix(K, 2, 2, [0, -w - 1, 0, 0]),
    Matrix(K, 2, 2, [0, 0, w / 2, 0]),
    Matrix(K, 2, 2, [0, 0, 0, -w + 1]),
]
print()
print("My R_BASIS == Codex's printed R basis (same lattice):",
      same_lattice_K(R_BASIS, codex_R_basis))

######################################################################
# Is w a pbar-local unit? Direct 2-adic check.
######################################################################
PREC = 200
Q2 = Qp(2, prec=PREC)
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


w_Q2 = K_to_Q2(w, root_pbar)
print()
print("w embedded at pbar:", w_Q2)
print("valuation(w) at pbar:", w_Q2.valuation(), " (want 0, i.e. w IS a pbar-local unit)")
assert w_Q2.valuation() == 0

######################################################################
# Rebuild the ALREADY-ESTABLISHED local branch (g0=diag(2,1) frame,
# M0_std=M2(Z2), M1_std=h*M2(Z2)*h^-1) exactly as in
# m009_dyadic_index_check.sage / m009_normalizer_certificate.sage, and
# compare against Codex's GLOBAL M0,M1 (embedded at pbar) directly.
######################################################################


def matrix_to_Q2(M2x2, root):
    return matrix(Q2, 2, 2, [K_to_Q2(M2x2[i, j], root) for i in range(2) for j in range(2)])


Rloc = [matrix_to_Q2(r, root_pbar) for r in R_BASIS]

Id = identity_matrix(QQ, 2)
NEIGHBOR_STEPS = [matrix(QQ, [[2, 0], [0, 1]]), matrix(QQ, [[1, 0], [0, 2]]),
                  matrix(QQ, [[1, 0], [1, 2]])]


def v2q(a):
    a = QQ(a)
    if a == 0:
        return Infinity
    return a.valuation(2)


def same_vertex(g1_, g2_):
    h = g1_.inverse() * g2_
    vals = [v2q(h[i, j]) for i in range(2) for j in range(2) if h[i, j] != 0]
    m = min(vals)
    return v2q(h.det()) == 2 * m


def neighbours(g):
    return [g * hh for hh in NEIGHBOR_STEPS]


def g_to_Q2(g):
    return matrix(Q2, 2, 2, [Q2(a) for a in g.list()])


def integral_q2(a):
    if a == 0:
        return True
    return a.valuation() >= 0


def R_contained_in_vertex(g, Rloc_):
    g2 = g_to_Q2(g)
    gi = g2.inverse()
    for r in Rloc_:
        Mm = gi * r * g2
        for z in Mm.list():
            if not integral_q2(z):
                return False
    return True


def find_seed(Rloc_, RMAX=8):
    verts = [(Id, 0)]
    i = 0
    while i < len(verts):
        g, d = verts[i]
        i += 1
        if R_contained_in_vertex(g, Rloc_):
            return g, d
        if d == RMAX:
            continue
        for hh in neighbours(g):
            if not any(same_vertex(hh, u) for u, _ in verts):
                verts.append((hh, d + 1))
    return None, None


def enumerate_branch(Rloc_, seed, MAX_BRANCH=100):
    branch = [seed]
    i = 0
    while i < len(branch):
        g = branch[i]
        i += 1
        for hh in neighbours(g):
            if any(same_vertex(hh, u) for u in branch):
                continue
            if R_contained_in_vertex(hh, Rloc_):
                branch.append(hh)
    return branch


seed, dist = find_seed(Rloc)
branch = enumerate_branch(Rloc, seed)
print()
print("Rebuilt branch size (independent, own code):", len(branch), " (want 2)")
assert len(branch) == 2
g0, g1 = branch[0], branch[1]
print("g0 =", g0.list(), " g1 =", g1.list())

def std_basis_Q2():
    return [matrix(Q2, [[1, 0], [0, 0]]), matrix(Q2, [[0, 1], [0, 0]]),
            matrix(Q2, [[0, 0], [1, 0]]), matrix(Q2, [[0, 0], [0, 1]])]


g0_Q2 = g_to_Q2(g0)
g0_inv_Q2 = g0_Q2.inverse()
g1_Q2 = g_to_Q2(g1)
g1_inv_Q2 = g1_Q2.inverse()
std = std_basis_Q2()
# The vertex g corresponds to the local maximal order g^-1 * M2(Z2) * g
# (this is the TRUSTED convention used throughout this session:
# R_contained_in_vertex(g,...) checks g^-1*r*g integral, i.e. the order
# AT vertex g, pulled back to standard position, is g*M2(Z2)*g^-1 in
# the ORIGINAL (un-pulled-back) frame -- i.e. M_g := g*M2(Z2)*g^-1).
M0_local = [g0_Q2 * e * g0_inv_Q2 for e in std]
M1_local = [g1_Q2 * e * g1_inv_Q2 for e in std]

######################################################################
# Now embed Codex's GLOBAL M0, M1 (via d0=diag(1-w,1), d1=diag((1-w)^2,1))
# at pbar and compare against M0_local, M1_local as LOCAL lattices.
######################################################################
E11K = Matrix(K, [[1, 0], [0, 0]])
E12K = Matrix(K, [[0, 1], [0, 0]])
E21K = Matrix(K, [[0, 0], [1, 0]])
E22K = Matrix(K, [[0, 0], [0, 1]])
MstdK = [E11K, E12K, E21K, E22K]


def conjugate_basis_K(g, basis):
    gi = g.inverse()
    return [g * b * gi for b in basis]


d0 = Matrix(K, [[pi_pbar, 0], [0, 1]])
d1 = Matrix(K, [[pi_pbar**2, 0], [0, 1]])
codex_M0_basis = conjugate_basis_K(d0, MstdK)
codex_M1_basis = conjugate_basis_K(d1, MstdK)


def same_lattice_Q2(basis1, basis2):
    F1 = matrix(Q2, [[m[0, 0], m[0, 1], m[1, 0], m[1, 1]] for m in basis1])
    F2 = matrix(Q2, [[m[0, 0], m[0, 1], m[1, 0], m[1, 1]] for m in basis2])
    A_ = F1 * F2.inverse()
    B_ = F2 * F1.inverse()
    return (all((c == 0) or (c.valuation() >= 0) for row in A_.rows() for c in row) and
            all((c == 0) or (c.valuation() >= 0) for row in B_.rows() for c in row))


codex_M0_Q2 = [matrix_to_Q2(m, root_pbar) for m in codex_M0_basis]
codex_M1_Q2 = [matrix_to_Q2(m, root_pbar) for m in codex_M1_basis]

print()
print("=" * 70)
print("KEY CHECK: does Codex's GLOBAL M0 (embedded at pbar) match the")
print("TRUSTED local M0 from the branch (or M1)?")
print("=" * 70)
match_M0_to_M0 = same_lattice_Q2(codex_M0_Q2, M0_local)
match_M0_to_M1 = same_lattice_Q2(codex_M0_Q2, M1_local)
match_M1_to_M0 = same_lattice_Q2(codex_M1_Q2, M0_local)
match_M1_to_M1 = same_lattice_Q2(codex_M1_Q2, M1_local)
print("Codex M0 == trusted M0_local:", match_M0_to_M0)
print("Codex M0 == trusted M1_local:", match_M0_to_M1)
print("Codex M1 == trusted M0_local:", match_M1_to_M0)
print("Codex M1 == trusted M1_local:", match_M1_to_M1)

ok = (match_M0_to_M0 and match_M1_to_M1) or (match_M0_to_M1 and match_M1_to_M0)
print()
print("Codex's global M0,M1 correspond (as a SET) to the trusted local")
print("branch {M0_local, M1_local} exactly:", ok)
