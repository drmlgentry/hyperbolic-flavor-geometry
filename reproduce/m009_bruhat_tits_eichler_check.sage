import snappy
from sage.all import ComplexField, algdep, QQ, Qp, PolynomialRing, matrix, Infinity, identity_matrix

######################################################################
# 0. GLOBAL FIELD (same conventions as order_closure.sage)
######################################################################
x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
CCf = ComplexField(300)

p_id = K.ideal(w)
pbar_id = K.ideal(1 - w)
assert p_id.norm() == 2
assert pbar_id.norm() == 2
assert p_id * pbar_id == K.ideal(2)
print("p    =", p_id)
print("pbar =", pbar_id)

######################################################################
# 1. RECOMPUTE THE EXACT ORDER BASIS (identical to order_closure.sage)
######################################################################


def exact_K_element(numval, label):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        print(f"  WARNING: {label} does not fit degree<=2 (got {dep})")
        return None
    if dep.degree() == 1:
        return K(-dep[0] / dep[1])
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        print(f"  WARNING: {label} poly {dep} has no roots in K")
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
    if len(basis_scaled) != 4:
        raise RuntimeError(f"unexpected basis rank {len(basis_scaled)}")
    basis_R = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]
    return basis_R


print("Recomputing m009 order basis (identical method to order_closure.sage)...")
mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)
print("R_BASIS recovered, 4 elements. Sanity check against known result:")


def adjugate(m2x2):
    a_, b_, c_, d_ = m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]
    return Matrix(K, [[d_, -b_], [-c_, a_]])


def reduced_trace_pairing(e1, e2):
    return (e1 * adjugate(e2)).trace()


Gram = Matrix(K, 4, 4, lambda i, j: reduced_trace_pairing(R_BASIS[i], R_BASIS[j]))
discR = Gram.det()
fi = K.ideal(discR)
vp_disc = fi.valuation(p_id)
vpbar_disc = fi.valuation(pbar_id)
print(f"  disc(R) = {discR}, v_p={vp_disc}, v_pbar={vpbar_disc}  (expect 0, 4 -- trace disc, matches prior run)")
assert (vp_disc, vpbar_disc) == (0, 4), "basis recomputation disagrees with prior order_closure.sage run"
print("  Confirmed: matches the already-recorded (0,4) trace-discriminant valuations exactly.")

######################################################################
# 2. TWO 2-ADIC EMBEDDINGS (2 splits in K, both completions are Q_2)
######################################################################
PREC = 300
Q2 = Qp(2, prec=PREC)
P2 = PolynomialRing(Q2, 'X')
Xg = P2.gen()
roots = [r for r, m in (Xg**2 - Xg + 2).roots()]
assert len(roots) == 2, f"expected 2 roots in Q2, got {len(roots)} -- did 2 really split?"

root_p = None
root_pbar = None
for r in roots:
    vw = r.valuation()
    v1mw = (1 - r).valuation()
    if vw > 0:
        root_p = r
    if v1mw > 0:
        root_pbar = r
assert root_p is not None, "no root with v(w)>0 found"
assert root_pbar is not None, "no root with v(1-w)>0 found"
print("root for p:    ", root_p)
print("root for pbar: ", root_pbar)
print("v_p(w)      =", root_p.valuation())
print("v_pbar(1-w) =", (1 - root_pbar).valuation())

######################################################################
# 3. EXACT K -> Q2 EVALUATION
######################################################################


def K_to_Q2(a, root):
    aa = K(a)
    pol = aa.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return Q2(c0) + Q2(c1) * root


def matrix_to_Q2(M, root):
    return matrix(Q2, 2, 2,
                  [K_to_Q2(M[i, j], root)
                   for i in range(2)
                   for j in range(2)])

######################################################################
# 4. BRUHAT-TITS TREE VERTICES for GL_2(Q_2)
######################################################################


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

######################################################################
# 5. CONTAINMENT TEST R subset M_g
######################################################################


def local_R_basis(root):
    return [matrix_to_Q2(r, root) for r in R_BASIS]


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

######################################################################
# 6. FIND ONE VERTEX CONTAINING R
######################################################################


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

######################################################################
# 7. ENUMERATE THE COMPLETE BRANCH
######################################################################


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
                    raise RuntimeError("Branch exceeded MAX_BRANCH: possible precision/order problem.")
    return branch

######################################################################
# 8. BUILD THE INDUCED BRANCH GRAPH
######################################################################


def branch_adjacency(branch):
    n = len(branch)
    adj = {i: set() for i in range(n)}
    for i in range(n):
        for h in neighbours(branch[i]):
            for j in range(n):
                if i != j and same_vertex(h, branch[j]):
                    adj[i].add(j)
    return adj


def print_branch(branch, adj, label):
    print()
    print("====", label, "====")
    print("number of vertices =", len(branch))
    degs = sorted(len(adj[i]) for i in adj)
    print("degree sequence =", degs)
    for i in range(len(branch)):
        print("vertex", i, " neighbours ", sorted(adj[i]))

######################################################################
# 9. RUN AT ONE LOCAL PRIME
######################################################################


def run_local(root, label, expected_vertices):
    Rloc = local_R_basis(root)
    seed, dist = find_seed(Rloc, RMAX=8)
    if seed is None:
        raise RuntimeError("No containing maximal order found within radius 8.")
    print(label, ": seed found at root-distance", dist)
    branch = enumerate_branch(Rloc, seed)
    adj = branch_adjacency(branch)
    print_branch(branch, adj, label)
    if len(branch) != expected_vertices:
        print(f"  ** UNEXPECTED: got {len(branch)} vertices, expected {expected_vertices} **")
    return branch, adj


######################################################################
# 10. p SIDE -- EXPECT MAXIMAL (1 vertex)
######################################################################
Bp, Ap = run_local(root_p, "prime p=(w)", expected_vertices=1)

######################################################################
# 11. pbar SIDE -- EXPECT LENGTH-2 EICHLER BRANCH (3 vertices)
######################################################################
Bb, Ab = run_local(root_pbar, "prime pbar=(1-w)", expected_vertices=3)

######################################################################
# 12/13. IDENTIFY ENDPOINTS, VERIFY EICHLER EQUALITY VIA DISCRIMINANT
######################################################################
if len(Bb) == 3:
    degs = sorted(len(Ab[i]) for i in Ab)
    print()
    if degs == [1, 1, 2]:
        endpoints = [i for i in Ab if len(Ab[i]) == 1]
        middle = [i for i in Ab if len(Ab[i]) == 2]
        e0, e2 = endpoints
        m_ = middle[0]
        print("PASS: branch at pbar is a path with 3 vertices (endpoints", e0, e2, ", middle", m_, ")")
        print("endpoint distance = 2")
        KNOWN_REDUCED_DISC_EXP_PBAR = vpbar_disc // 2  # trace disc valuation / 2 = reduced disc valuation
        print(f"reduced discriminant exponent at pbar = {KNOWN_REDUCED_DISC_EXP_PBAR}")
        if KNOWN_REDUCED_DISC_EXP_PBAR == 2:
            print()
            print("FINAL LOCAL CERTIFICATE:")
            print("R_pbar is contained in the intersection E of two maximal orders")
            print("at Bruhat-Tits distance 2 -- E is Eichler of level pbar^2.")
            print("R_pbar and E share reduced discriminant exponent 2, so by")
            print("disc_tr(R) = [E:R]^2 * disc_tr(E), [E:R]=1 locally: R_pbar = E.")
        else:
            print(f"  ** discriminant exponent {KNOWN_REDUCED_DISC_EXP_PBAR} != 2, cannot conclude R_pbar=E **")
    else:
        print(f"** branch shape {degs} is NOT a length-2 path -- R_pbar may not be Eichler **")

print()
print("=" * 60)
print("SUMMARY")
print("=" * 60)
print(f"#branch(R_p)    = {len(Bp)}  (expected 1)")
print(f"#branch(R_pbar) = {len(Bb)}  (expected 3)")
