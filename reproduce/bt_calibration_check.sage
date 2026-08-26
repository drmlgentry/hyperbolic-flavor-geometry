from sage.all import ComplexField, QQ, Qp, PolynomialRing, matrix, Infinity, identity_matrix

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()

# Calibration order: the standard maximal order M2(O_K), basis = matrix units.
E11 = Matrix(K, [[1, 0], [0, 0]])
E12 = Matrix(K, [[0, 1], [0, 0]])
E21 = Matrix(K, [[0, 0], [1, 0]])
E22 = Matrix(K, [[0, 0], [0, 1]])
R_BASIS = [E11, E12, E21, E22]

PREC = 300
Q2 = Qp(2, prec=PREC)
P2 = PolynomialRing(Q2, 'X')
Xg = P2.gen()
roots = [r for r, m in (Xg**2 - Xg + 2).roots()]
root_p = None
root_pbar = None
for r in roots:
    if r.valuation() > 0:
        root_p = r
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


Id = identity_matrix(QQ, 2)
NEIGHBOR_STEPS = [
    matrix(QQ, [[2, 0], [0, 1]]),
    matrix(QQ, [[1, 0], [0, 2]]),
    matrix(QQ, [[1, 0], [1, 2]]),
]


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


def R_contained_in_vertex(g, Rloc):
    g2 = g_to_Q2(g)
    gi = g2.inverse()
    for r in Rloc:
        M = gi * r * g2
        for z in M.list():
            if not integral_q2(z):
                return False
    return True


def find_seed(Rloc, RMAX=8):
    verts = [(Id, 0)]
    i = 0
    while i < len(verts):
        g, d = verts[i]
        i += 1
        if R_contained_in_vertex(g, Rloc):
            return g, d
        if d == RMAX:
            continue
        for h in neighbours(g):
            if not any(same_vertex(h, u) for u, _ in verts):
                verts.append((h, d + 1))
    return None, None


def enumerate_branch(Rloc, seed, MAX_BRANCH=100):
    branch = [seed]
    i = 0
    while i < len(branch):
        g = branch[i]
        i += 1
        for h in neighbours(g):
            if any(same_vertex(h, u) for u in branch):
                continue
            if R_contained_in_vertex(h, Rloc):
                branch.append(h)
                if len(branch) > MAX_BRANCH:
                    raise RuntimeError("branch too large")
    return branch


for root, label in [(root_p, "p"), (root_pbar, "pbar")]:
    Rloc = [matrix_to_Q2(r, root) for r in R_BASIS]
    seed, dist = find_seed(Rloc)
    branch = enumerate_branch(Rloc, seed)
    print(f"M2(O_K) at {label}: seed_dist={dist}, branch_size={len(branch)}  (expected: 1)")
