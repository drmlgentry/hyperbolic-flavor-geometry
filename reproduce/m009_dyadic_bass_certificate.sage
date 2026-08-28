# Independent Bass-order certificate for R_pbar (m009, at pbar=(1-w)),
# per GPT's/webclaude's "67-subspace" reformulation of the earlier
# 15-line + 35-plane enumeration (m009_dyadic_index_check.sage).
#
# Key fact used (already proved TWICE in m009_dyadic_index_check.sage,
# via two independent derivations -- re-verified again below from a
# third angle before being relied on here): R# = (1/2)*R exactly, so
# every overorder S with R subset S subset R# corresponds to an
# F2-subspace W of V := R#/R = F2^4, and there are exactly
# 1+15+35+15+1 = 67 such subspaces (dims 0..4).
#
# What is genuinely NEW here relative to the earlier script (not just a
# restatement):
#   1. A single unified subspace enumerator covering ALL dims 0..4 in
#      one pass (previous script only ever tried dim 1 and dim 2 --
#      dim 0 was implicit/untested and dim 3, dim 4 were NEVER checked
#      at all). Confirming 0 survivors at dim 3 and dim 4 is a real gap
#      being closed, not a restatement.
#   2. Multiplicative closure and Gorenstein-ness are tested completely
#      uniformly (same two functions) across every one of the 67
#      candidates, with no line/plane-specific code paths.
#   3. An explicit identification of the two dim-2 survivors against
#      M0 = M2(Z2) and M1 = h*M2(Z2)*h^-1 individually (previous script
#      only cross-checked the dim-1 survivor against E; it never
#      confirmed which plane survivor is M0 vs M1).
#
# Setup (K, R_BASIS, pbar embedding, BT-tree branch/E/R_std machinery,
# adjugate2/flat, R# via T_adj) is copied verbatim from
# m009_dyadic_index_check.sage since it is foundational infrastructure
# already independently verified this session -- re-deriving BT-tree
# machinery from scratch here would not add any independent check on
# THIS claim (Bass), it would just duplicate untouched code.

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector, GF, Integer)
from itertools import combinations

######################################################################
# 0. GLOBAL FIELD
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


print("Recomputing m009 order basis (identical method to prior scripts)...")
mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)
print("R_BASIS recovered, 4 elements.")

######################################################################
# 1. pbar embedding
######################################################################
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
    return matrix(Q2, 2, 2,
                  [K_to_Q2(M[i, j], root) for i in range(2) for j in range(2)])


Rloc = [matrix_to_Q2(r, root_pbar) for r in R_BASIS]

######################################################################
# 2. BT-tree machinery (identical to the eichler check / index-2 script)
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
                if len(branch) > MAX_BRANCH:
                    raise RuntimeError("branch too large")
    return branch


seed, dist = find_seed(Rloc)
branch = enumerate_branch(Rloc, seed)
print("branch size at pbar:", len(branch), " (expect 2)")
assert len(branch) == 2

g0, g1 = branch[0], branch[1]

step_index = None
for idx, h in enumerate(NEIGHBOR_STEPS):
    if same_vertex(g0 * h, g1):
        step_index = idx
        break
assert step_index is not None
h_connect = NEIGHBOR_STEPS[step_index]
print("connecting step index:", step_index, " h =", h_connect.list())

h_exact = h_connect
h_exact_inv = h_exact.inverse()
std_exact = [matrix(QQ, [[1, 0], [0, 0]]), matrix(QQ, [[0, 1], [0, 0]]),
             matrix(QQ, [[0, 0], [1, 0]]), matrix(QQ, [[0, 0], [0, 1]])]
conj_exact = [h_exact * e * h_exact_inv for e in std_exact]

E_std_basis_exact = [matrix(QQ, [[1, 0], [0, 0]]),
                      matrix(QQ, [[0, 2], [0, 0]]),
                      matrix(QQ, [[0, 0], [1, 0]]),
                      matrix(QQ, [[0, 0], [0, 1]])]

g0_Q2 = g_to_Q2(g0)
g0_inv_Q2 = g0_Q2.inverse()
R_std = [g0_inv_Q2 * r * g0_Q2 for r in Rloc]

######################################################################
# 3. adjugate2 / flat / trace-dual R# (T_adj convention, as established
#    and justified in m009_dyadic_index_check.sage).
######################################################################


def flat(m):
    return vector(Q2, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


def adjugate2(m2x2):
    a_, b_, c_, d_ = m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]
    return matrix(Q2, [[d_, -b_], [-c_, a_]])


r_basis = R_std
T_adj = matrix(Q2, 4, 4, lambda i, j: (r_basis[i] * adjugate2(r_basis[j])).trace())
assert T_adj == T_adj.transpose()
Tinv = T_adj.inverse()
Rsharp_basis = [sum(Tinv[i, j] * r_basis[j] for j in range(4)) for i in range(4)]
Rsharp_flat = matrix(Q2, [flat(e) for e in Rsharp_basis])
R_flat = matrix(Q2, [flat(r) for r in r_basis])

print()
print("=" * 70)
print("PRE-CHECK: independently re-verify R# = (1/2)*R (third derivation)")
print("=" * 70)
# Third, independent path: (1/2)*R_flat should span EXACTLY the same
# lattice as Rsharp_flat (change-of-basis both ways integral+unit det).
half_R_flat = R_flat / 2
A_ = half_R_flat * Rsharp_flat.inverse()
B_ = Rsharp_flat * half_R_flat.inverse()
ok_fwd = all((c == 0) or (c.valuation() >= 0) for row in A_.rows() for c in row)
ok_bwd = all((c == 0) or (c.valuation() >= 0) for row in B_.rows() for c in row)
det_unit = (A_.det().valuation() == 0)
print("  (1/2)R subset R#:", ok_fwd, "  R# subset (1/2)R:", ok_bwd, "  det(A_) valuation:", A_.det().valuation())
assert ok_fwd and ok_bwd and det_unit, "R# = (1/2)R re-verification FAILED -- cannot proceed"
print("  CONFIRMED (third independent check): R# = (1/2)*R exactly.")

######################################################################
# 4. UNIFIED SUBSPACE ENUMERATOR: all 67 F2-subspaces of V = F2^4.
######################################################################
F2 = GF(2)
nonzero_vecs = [vector(F2, [(b >> k) & 1 for k in range(4)]) for b in range(1, 16)]


def enumerate_subspaces_dim(d):
    """All d-dim F2-subspaces of F2^4, each as a tuple of echelon-form
    row tuples (canonical, deduplicated)."""
    if d == 0:
        return [tuple()]
    if d == 4:
        I = identity_matrix(F2, 4)
        return [tuple(tuple(row) for row in I.rows())]
    seen = set()
    results = []
    for combo in combinations(nonzero_vecs, d):
        M = matrix(F2, list(combo))
        if M.rank() != d:
            continue
        red = M.echelon_form()
        key = tuple(tuple(row) for row in red.rows())
        if key in seen:
            continue
        seen.add(key)
        results.append(key)
    return results


subspaces_by_dim = {d: enumerate_subspaces_dim(d) for d in range(5)}
counts = {d: len(subspaces_by_dim[d]) for d in range(5)}
print()
print("=" * 70)
print("STEP 1: ENUMERATE ALL SUBSPACES OF V = R#/R = F2^4")
print("=" * 70)
print("counts by dimension:", counts, " total:", sum(counts.values()))
assert counts == {0: 1, 1: 15, 2: 35, 3: 15, 4: 1}, f"unexpected subspace counts {counts}"
assert sum(counts.values()) == 67
print("CONFIRMED: exactly 67 subspaces (1+15+35+15+1), as expected from")
print("the Gaussian binomial coefficients [4 choose d]_2.")

######################################################################
# 5. LIFT EACH SUBSPACE TO A CANDIDATE ORDER S_W, TEST CLOSURE.
######################################################################


def lift_subspace_to_S_basis(subspace_rows_F2):
    if len(subspace_rows_F2) == 0:
        return list(r_basis)
    M = matrix(F2, [vector(F2, row) for row in subspace_rows_F2])
    Mred = M.echelon_form()
    pivots = Mred.pivots()
    new_basis = list(r_basis)
    for row_idx, piv_col in enumerate(pivots):
        row = Mred.row(row_idx)
        lift_coeffs = [Integer(c) for c in row]
        elt = sum(lift_coeffs[i] * r_basis[i] for i in range(4)) / 2
        new_basis[piv_col] = elt
    return new_basis


def is_mult_closed(S_basis):
    Sf = matrix(Q2, [flat(b) for b in S_basis])
    Sf_inv = Sf.inverse()
    for i in range(4):
        for j in range(4):
            prod = S_basis[i] * S_basis[j]
            coeffs = flat(prod) * Sf_inv
            if not all((c == 0) or (c.valuation() >= 0) for c in coeffs):
                return False
    return True


def disc_val(S_basis):
    TS = matrix(Q2, 4, 4, lambda i, j: (S_basis[i] * adjugate2(S_basis[j])).trace())
    d = TS.det()
    return d.valuation() if d != 0 else None


print()
print("=" * 70)
print("STEP 2: TEST MULTIPLICATIVE CLOSURE FOR ALL 67 CANDIDATES")
print("=" * 70)

survivors = []  # (dim, key, S_basis, disc_val)
per_dim_survivor_count = {}
for d in range(5):
    n_survive = 0
    for key in subspaces_by_dim[d]:
        S_basis = lift_subspace_to_S_basis(key)
        closed = is_mult_closed(S_basis)
        if closed:
            dv = disc_val(S_basis)
            expected_dv = 4 - 2 * d
            consistent = (dv == expected_dv)
            print(f"  dim={d} key={key}: CLOSED, v(disc_tr)={dv} (predicted 4-2*{d}={expected_dv}, match={consistent})")
            assert consistent, f"disc valuation mismatch at dim {d}: got {dv}, predicted {expected_dv}"
            survivors.append((d, key, S_basis, dv))
            n_survive += 1
    per_dim_survivor_count[d] = n_survive
    print(f"  -- dim {d}: {n_survive}/{len(subspaces_by_dim[d])} closed")

print()
print("Survivor counts by dimension:", per_dim_survivor_count)
print(f"Total overorders found (including R itself): {len(survivors)}")
assert per_dim_survivor_count[3] == 0, "unexpected: a dim-3 subspace gave a genuine order (would need v(disc)=-2, impossible)"
assert per_dim_survivor_count[4] == 0, "unexpected: R# itself is multiplicatively closed (would make R# an order)"
print("CONFIRMED: no dim-3 or dim-4 order exists (matches the a priori")
print("impossibility of negative discriminant valuation) -- this was never")
print("explicitly tested in the earlier 15-line/35-plane script.")

######################################################################
# 6. IDENTIFY SURVIVORS: R itself, E, and the two maximal orders M0/M1.
######################################################################
print()
print("=" * 70)
print("STEP 3: IDENTIFY EACH SURVIVOR AGAINST KNOWN CONSTRUCTIONS")
print("=" * 70)


def same_lattice(basis1, basis2):
    F1 = matrix(Q2, [flat(b) for b in basis1])
    F2m = matrix(Q2, [flat(b) for b in basis2])
    A_ = F1 * F2m.inverse()
    B_ = F2m * F1.inverse()
    return (all((c == 0) or (c.valuation() >= 0) for row in A_.rows() for c in row) and
            all((c == 0) or (c.valuation() >= 0) for row in B_.rows() for c in row))


Estd_check = [matrix(Q2, [[Q2(c) for c in row] for row in e.rows()]) for e in E_std_basis_exact]
M0_check = [matrix(Q2, [[Q2(c) for c in row] for row in e.rows()]) for e in std_exact]
M1_check = [matrix(Q2, [[Q2(c) for c in row] for row in e.rows()]) for e in conj_exact]

identified = {}
for (d, key, S_basis, dv) in survivors:
    if d == 0:
        label = "R"
    elif d == 1:
        label = "E" if same_lattice(S_basis, Estd_check) else f"UNKNOWN(dim1,{key})"
    elif d == 2:
        if same_lattice(S_basis, M0_check):
            label = "M0"
        elif same_lattice(S_basis, M1_check):
            label = "M1"
        else:
            label = f"UNKNOWN(dim2,{key})"
    else:
        label = f"UNKNOWN(dim{d},{key})"
    identified[(d, key)] = label
    print(f"  dim={d} key={key} -> identified as {label}  (v(disc_tr)={dv})")

labels_found = sorted(identified.values())
print()
print("labels found:", labels_found)
assert labels_found == ["E", "M0", "M1", "R"], f"unexpected survivor set/labels: {labels_found}"
print("CONFIRMED: the complete overorder poset is exactly {R, E, M0, M1},")
print("with no incomparable 'sideways' index-2 or index-4 overorders --")
print("independently matches the 15-line/35-plane result, now via a")
print("single unified 67-subspace sweep AND with M0/M1 individually")
print("identified against their explicit constructions (new).")

######################################################################
# 7. GORENSTEIN TEST FOR EVERY SURVIVOR (uniform SNF-based test).
######################################################################
print()
print("=" * 70)
print("STEP 4: GORENSTEIN TEST FOR EVERY SURVIVOR (uniform)")
print("=" * 70)


def snf_with_transform_z2(mat):
    n = mat.nrows()
    M = matrix(Q2, mat)
    V = identity_matrix(Q2, n)
    divs = [None] * n
    active_rows = list(range(n))
    active_cols = list(range(n))
    for step in range(n):
        if len(active_rows) == 0 or len(active_cols) == 0:
            break
        best = None
        for i in active_rows:
            for j in active_cols:
                if M[i, j] != 0:
                    v = M[i, j].valuation()
                    if best is None or v < best[0]:
                        best = (v, i, j)
        if best is None:
            for j in active_cols:
                divs[j] = Infinity
            break
        v0, pi, pj = best
        piv = M[pi, pj]
        for j in active_cols:
            if j != pj and M[pi, j] != 0:
                factor = M[pi, j] / piv
                for i in active_rows:
                    M[i, j] -= factor * M[i, pj]
                for i in range(n):
                    V[i, j] -= factor * V[i, pj]
        for i in active_rows:
            if i != pi and M[i, pj] != 0:
                factor = M[i, pj] / piv
                for j in active_cols:
                    M[i, j] -= factor * M[pi, j]
        divs[pj] = v0
        active_rows.remove(pi)
        active_cols.remove(pj)
    return divs, V


def general_gorenstein_test_v2(S_basis, label=""):
    n = len(S_basis)
    T_S = matrix(Q2, n, n, lambda i, j: (S_basis[i] * adjugate2(S_basis[j])).trace())
    Tinv_S = T_S.inverse()
    Ssharp = [sum(Tinv_S[i, j] * S_basis[j] for j in range(n)) for i in range(n)]
    Sf = matrix(Q2, [flat(b) for b in S_basis])
    Ssf = matrix(Q2, [flat(b) for b in Ssharp])
    P = Sf * Ssf.inverse()
    divs, V = snf_with_transform_z2(P)
    nontrivial_idx = [i for i, d in enumerate(divs) if d and d > 0]
    if len(nontrivial_idx) == 0:
        print(f"  [{label}] S# = S exactly (self-dual) -- Gorenstein trivially YES. divs={divs}")
        return True, {"divs": divs}
    if len(nontrivial_idx) == 1:
        print(f"  [{label}] S#/S cyclic as abelian group -- Gorenstein automatically YES. divs={divs}")
        return True, {"divs": divs}
    dset = set(divs[i] for i in nontrivial_idx)
    if len(dset) != 1 or list(dset)[0] != 1:
        raise NotImplementedError(f"{label}: unsupported divisor pattern {divs}")
    f_basis = [sum(V[row, col] * Ssharp[row] for row in range(n)) for col in range(n)]
    k = len(nontrivial_idx)
    f_flat = matrix(Q2, [flat(f_basis[i]) for i in range(n)])
    f_inv = f_flat.inverse()

    def res2(a):
        if a == 0:
            return GF(2)(0)
        return GF(2)(0) if a.valuation() >= 1 else GF(2)(a.residue())
    action = {}
    for si in range(n):
        for jj, j in enumerate(nontrivial_idx):
            prod = S_basis[si] * f_basis[j]
            coeffs = flat(prod) * f_inv
            vals2 = [c.valuation() if c != 0 else Infinity for c in coeffs]
            assert all(v >= 0 for v in vals2), f"{label}: S# not closed under S-mult, adapted basis"
            action[si, jj] = vector(GF(2), [res2(coeffs[nontrivial_idx[t]]) for t in range(k)])
    Mmats = []
    for si in range(n):
        cols = [action[si, jj] for jj in range(k)]
        Mmats.append(matrix(GF(2), k, k, lambda a, b: cols[b][a]))
    best_rank = 0
    gen = None
    for bits in range(1, 2**k):
        xi = vector(GF(2), [(bits >> t) & 1 for t in range(k)])
        orbit = matrix(GF(2), [Mi * xi for Mi in Mmats])
        rk = orbit.rank()
        if rk > best_rank:
            best_rank = rk
        if rk == k and gen is None:
            gen = xi
    is_gor = (gen is not None)
    print(f"  [{label}] divs={divs}, genuine quotient dim={k}, best_rank={best_rank}/{k}, generator={gen} -> Gorenstein={is_gor}")
    return is_gor, {"divs": divs, "quotient_dim": k, "generator": gen}


gorenstein_results = {}
for (d, key, S_basis, dv) in survivors:
    label = identified[(d, key)]
    is_gor, details = general_gorenstein_test_v2(S_basis, label)
    gorenstein_results[label] = (is_gor, dv, details)

######################################################################
# 8. FINAL TABLE AND BASS CONCLUSION.
######################################################################
print()
print("=" * 70)
print("FINAL TABLE (67-subspace certificate)")
print("=" * 70)
print(f"{'Order':<8}{'[S:R]':<8}{'v(disc_tr)':<12}{'Gorenstein?'}")
order_index = {"R": 1, "E": 2, "M0": 4, "M1": 4}
for label in ["R", "E", "M0", "M1"]:
    is_gor, dv, details = gorenstein_results[label]
    print(f"{label:<8}{str(order_index[label]):<8}{str(dv):<12}{is_gor}")

all_gorenstein = all(gorenstein_results[label][0] for label in ["R", "E", "M0", "M1"])
bass_conclusion = "YES" if all_gorenstein else "NO"
print()
print(f"Overorder poset (67-subspace exhaustive sweep): R subset E subset {{M0, M1}}")
print(f"No overorders outside this set exist (0/15 at dim 3, 0/1 at dim 4).")
print(f"All four orders Gorenstein: {all_gorenstein}")
print()
print(f"BASS(R_pbar) = {bass_conclusion}   [independent 67-subspace certificate]")
