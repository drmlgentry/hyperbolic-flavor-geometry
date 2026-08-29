# Third, independent certificate for eps(a)=eps(b)=1, entirely inside
# K (no quartic field L, no Q4 -- bypasses that whole apparatus).
#
# Since det(a)=1, Cayley-Hamilton gives a^2-tr(a)*a+I=0, i.e.
# A := a^2+I = tr(a)*a exactly -- a SCALAR multiple of a. Conjugation
# is insensitive to scalars (Ad(c*a)=Ad(a) for any nonzero scalar c,
# in ANY ring, regardless of which field c itself lives in), so
# Ad(A)=Ad(a) exactly, even though tr(a) itself is NOT in K. And
# A=a^2+I=aa+I IS an exact K-matrix (aa is already exact and trusted).
# So testing whether A swaps/fixes the branch gives eps(a) directly,
# via the plain K -> Q2 pipeline used throughout this whole session --
# no root-matching, no Cayley-Hamilton division by tr(a), no L/Q4.

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector)

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
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
    A_ = Matrix(OK, scaled_vecs)
    H = A_.hermite_form()
    basis_scaled = [H[i] for i in range(H.nrows()) if not H[i].is_zero()]
    basis_R = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]
    return basis_R


print("Recomputing exact_mats and R_BASIS...")
mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)

I2_K = Matrix(K, [[1, 0], [0, 1]])
A_mat = mats009['aa'] + I2_K
B_mat = mats009['bb'] + I2_K
print("A = aa+I:", A_mat.list())
print("B = bb+I:", B_mat.list())
print("det(A):", A_mat.det(), " det(B):", B_mat.det())
assert A_mat.det() != 0 and B_mat.det() != 0

PREC = 300
Q2 = Qp(2, prec=PREC)
P2 = PolynomialRing(Q2, 'X')
Xg = P2.gen()
roots = [r for r, m in (Xg**2 - Xg + 2).roots()]
root_pbar = None
for r in roots:
    if (1 - r).valuation() > 0:
        root_pbar = r


def K_to_Q2(a, root):
    aa = K(a)
    pol = aa.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return Q2(c0) + Q2(c1) * root


def matrix_to_Q2(M, root):
    return matrix(Q2, 2, 2, [K_to_Q2(M[i, j], root) for i in range(2) for j in range(2)])


Rloc = [matrix_to_Q2(r, root_pbar) for r in R_BASIS]
A_Q2 = matrix_to_Q2(A_mat, root_pbar)
B_Q2 = matrix_to_Q2(B_mat, root_pbar)
AB_Q2 = A_Q2 * B_Q2

Id = identity_matrix(QQ, 2)
NEIGHBOR_STEPS = [matrix(QQ, [[2, 0], [0, 1]]), matrix(QQ, [[1, 0], [0, 2]]),
                  matrix(QQ, [[1, 0], [1, 2]])]


def v2q(a):
    a = QQ(a)
    if a == 0:
        return Infinity
    return a.valuation(2)


def same_vertex(g1, g2):
    h = g1.inverse() * g2
    vals = [v2q(h[i, j]) for i in range(2) for j in range(2) if h[i, j] != 0]
    m = min(vals)
    return v2q(h.det()) == 2 * m


def neighbours(g):
    return [g * h for h in NEIGHBOR_STEPS]


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
        M = gi * r * g2
        for z in M.list():
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
        for h in neighbours(g):
            if not any(same_vertex(h, u) for u, _ in verts):
                verts.append((h, d + 1))
    return None, None


def enumerate_branch(Rloc_, seed, MAX_BRANCH=100):
    branch = [seed]
    i = 0
    while i < len(branch):
        g = branch[i]
        i += 1
        for h in neighbours(g):
            if any(same_vertex(h, u) for u in branch):
                continue
            if R_contained_in_vertex(h, Rloc_):
                branch.append(h)
    return branch


seed, dist = find_seed(Rloc)
branch = enumerate_branch(Rloc, seed)
assert len(branch) == 2
g0, g1 = branch[0], branch[1]
g0_Q2, g1_Q2 = g_to_Q2(g0), g_to_Q2(g1)

print()
print("=" * 70)
print("K-RATIONAL CERTIFICATE: testing A=aa+I, B=bb+I directly (no L/Q4)")
print("=" * 70)
for name, mat_Q2 in [("A (Ad=Ad(a))", A_Q2), ("B (Ad=Ad(b))", B_Q2), ("A*B (Ad=Ad(ab))", AB_Q2)]:
    img = mat_Q2 * g0_Q2
    fixes = same_vertex(img, g0_Q2)
    swaps = same_vertex(img, g1_Q2)
    print(f"  {name}: fixes g0={fixes}, swaps to g1={swaps}")

print()
print("Expected: A swaps (eps(a)=1), B swaps (eps(b)=1), A*B fixes (eps(ab)=0).")
print("This entirely bypasses the quartic field L and Q4 extension used")
print("in m009_task2_epsilon_v2.sage -- a genuinely independent, K-rational")
print("re-derivation of the same result.")
