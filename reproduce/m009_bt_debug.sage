import snappy
from sage.all import ComplexField, algdep, QQ, Qp, PolynomialRing, matrix, Infinity, identity_matrix

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
    A = Matrix(OK, scaled_vecs)
    H = A.hermite_form()
    basis_scaled = [H[i] for i in range(H.nrows()) if not H[i].is_zero()]
    basis_R = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]
    return basis_R


mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)

PREC = 300
Q2 = Qp(2, prec=PREC)
P2 = PolynomialRing(Q2, 'X')
Xg = P2.gen()
roots = [r for r, m in (Xg**2 - Xg + 2).roots()]
root_pbar = None
for r in roots:
    if (1 - r).valuation() > 0:
        root_pbar = r
assert root_pbar is not None


def K_to_Q2(a, root):
    aa = K(a)
    pol = aa.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return Q2(c0) + Q2(c1) * root


def matrix_to_Q2(M, root):
    return matrix(Q2, 2, 2, [K_to_Q2(M[i, j], root) for i in range(2) for j in range(2)])


Rloc = [matrix_to_Q2(r, root_pbar) for r in R_BASIS]

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


def R_contained_in_vertex(g, Rloc, verbose=False):
    g2 = g_to_Q2(g)
    gi = g2.inverse()
    minval = None
    for idx, r in enumerate(Rloc):
        M = gi * r * g2
        for z in M.list():
            if z != 0:
                v = z.valuation()
                if minval is None or v < minval:
                    minval = v
                if v < 0:
                    if verbose:
                        print(f"    basis[{idx}] fails: entry valuation {v} (matrix entries: {[e.valuation() if e!=0 else 'inf' for e in M.list()]})")
                    return False
    if verbose:
        print(f"    PASS, minimum entry valuation seen = {minval}")
    return True


# seed = I (distance 0 fails per prior run at distance... wait pbar seed was distance 1)
# reconstruct v0 as neighbours(Id)[?] -- find which one worked
print("Checking Id (distance 0):", R_contained_in_vertex(Id, Rloc))
v0 = None
for idx, h in enumerate(NEIGHBOR_STEPS):
    g = Id * h
    ok = R_contained_in_vertex(g, Rloc)
    print(f"  neighbour[{idx}] of Id = {h.list()}: contained = {ok}")
    if ok and v0 is None:
        v0 = g

print()
print("v0 =", v0.list() if v0 is not None else None)

known = [("Id", Id), ("v0", v0)]


def identify(g):
    for name, u in known:
        if same_vertex(g, u):
            return name
    return "NEW"


print()
print("v0's neighbours (should be 3 distinct vertices: Id, and 2 others):")
v1 = None
for idx, h in enumerate(NEIGHBOR_STEPS):
    g = v0 * h
    label = identify(g)
    ok = R_contained_in_vertex(g, Rloc, verbose=True)
    print(f"  v0-neighbour[{idx}] (h={h.list()}): identity={label}, contained={ok}")
    if ok and label == "NEW":
        v1 = g
        known.append(("v1", v1))

print()
print("v1 =", v1.list() if v1 is not None else None)

if v1 is not None:
    print()
    print("v1's neighbours (should include v0, and 2 others):")
    for idx, h in enumerate(NEIGHBOR_STEPS):
        g = v1 * h
        label = identify(g)
        ok = R_contained_in_vertex(g, Rloc, verbose=True)
        print(f"  v1-neighbour[{idx}] (h={h.list()}): identity={label}, contained={ok}")
