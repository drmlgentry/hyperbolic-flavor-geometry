# Local normalizer certificate for R_pbar (m009, at pbar=(1-w)).
#
# The relayed GPT/webclaude argument reduces N(R)=N(E) to exactly ONE
# checkable lattice fact, once combined with the ALREADY-CERTIFIED
# complete overorder poset {R,E,M0,M1} (two independent scripts this
# session):
#
#   (i)  N(R) subset N(E):
#        purely formal, given the poset is complete and E is the
#        UNIQUE index-2 overorder of R: for g in N(R), conjugation
#        sends overorders of R to overorders of R bijectively,
#        preserving index (S/R -> gSg^-1/R, x+R |-> gxg^-1+R is a
#        well-defined bijection of abelian groups once gRg^-1=R). The
#        unique index-2 overorder must map to itself, so g in N(E).
#        No new computation needed -- this follows from the already-
#        certified poset alone.
#
#   (ii) N(E) subset N(R), CONTINGENT on one fact:
#        IF R = {x in E : tr(x) in 2*Z2} exactly (as Z2-lattices),
#        THEN N(E) subset N(R) follows from the elementary,
#        always-true fact tr(g*x*g^-1) = tr(x) (cyclic trace
#        invariance -- true for ANY invertible g, no order theory
#        needed): for g in N(E), x in R subset E, g*x*g^-1 is in
#        g*E*g^-1 = E (since g in N(E)) and has the same trace as x,
#        hence lies in 2*Z2, hence g*x*g^-1 is in R. Applying to
#        g^-1 too gives the reverse containment, so g*R*g^-1 = R.
#
# So the WHOLE theorem rests on verifying "R = trace-even subset of E"
# as an EXACT lattice identity from the REAL R_std/E_std bases already
# computed and certified this session -- not from hand-picked matrices.
# That is what STEP 1-2 below does. STEPS 3-5 then independently
# derive (not assume) the conjugation action of three concrete
# candidate N(E) generators from their REAL matrix conjugation on
# E_std, as a second, fully concrete check, and cross-check against
# the abstract matrices GPT supplied.
#
# Setup (K, R_BASIS, pbar embedding, BT-tree branch/E/R_std) copied
# verbatim from m009_dyadic_index_check.sage / m009_dyadic_bass_certificate.sage
# (already independently verified twice this session).

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector, GF, Integer)

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
# 2. BT-tree machinery -- find the branch, E_std, R_std
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
assert len(branch) == 2
g0, g1 = branch[0], branch[1]

step_index = None
for idx, h in enumerate(NEIGHBOR_STEPS):
    if same_vertex(g0 * h, g1):
        step_index = idx
        break
assert step_index is not None
h_connect = NEIGHBOR_STEPS[step_index]

E_std_basis_exact = [matrix(QQ, [[1, 0], [0, 0]]),
                      matrix(QQ, [[0, 2], [0, 0]]),
                      matrix(QQ, [[0, 0], [1, 0]]),
                      matrix(QQ, [[0, 0], [0, 1]])]

g0_Q2 = g_to_Q2(g0)
g0_inv_Q2 = g0_Q2.inverse()
R_std = [g0_inv_Q2 * r * g0_Q2 for r in Rloc]
r_basis = R_std

print("branch size:", len(branch), " connecting step:", step_index)
print("E_std, R_std recomputed (matches prior scripts' setup).")

######################################################################
# 3. flat() and the E_std flattened basis (A,B,C,D order)
######################################################################


def flat(m):
    return vector(Q2, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


A, B, C, D = [matrix(Q2, [[Q2(c) for c in row] for row in e.rows()])
              for e in E_std_basis_exact]
E_std = [A, B, C, D]
Ef = matrix(Q2, [flat(e) for e in E_std])
Rf = matrix(Q2, [flat(r) for r in r_basis])

print()
print("=" * 70)
print("STEP 1: verify 2*E_std subset R_std (needed for R/2E to make sense)")
print("=" * 70)
TwoEf = matrix(Q2, [flat(2 * e) for e in E_std])
P_2E_in_R = TwoEf * Rf.inverse()
ok_2E_in_R = all((c == 0) or (c.valuation() >= 0) for row in P_2E_in_R.rows() for c in row)
print("2*E_std subset R_std:", ok_2E_in_R)
assert ok_2E_in_R, "2E not contained in R -- the trace-even hypothesis cannot even be posed this way"

######################################################################
# STEP 2: THE CRUCIAL CHECK -- is R_std EXACTLY the trace-even subset
#          of E_std, i.e. R/2E = ker(ell), ell(a,b,c,d) = a+d (mod 2)?
######################################################################
print()
print("=" * 70)
print("STEP 2: is R_std = {x in E_std : tr(x) in 2*Z2} EXACTLY?")
print("=" * 70)

# (a) direct trace check on R's own basis (no coordinate change needed --
#     trace of a 2x2 matrix is just entry[0,0]+entry[1,1], read off
#     directly from r_basis, independent of any basis choice).
print("Direct trace of each R_std basis element (should be in 2*Z2):")
all_traces_even = True
for i, r in enumerate(r_basis):
    tr = r[0, 0] + r[1, 1]
    v = tr.valuation() if tr != 0 else Infinity
    even = (tr == 0) or (v >= 1)
    print(f"  tr(r_{i+1}) = {tr}  valuation={v}  even={even}")
    all_traces_even = all_traces_even and even
print("All R_std generators trace-even:", all_traces_even)
assert all_traces_even, "R is NOT contained in the trace-even subset -- claim FALSE"

# (b) completeness: R's image in E/2E must be the FULL 3-dim kernel of
#     ell, not merely contained in it. Compute R's exact coordinates in
#     the E_std basis (over Q2), reduce mod 2, and compare spans.
X = Rf * Ef.inverse()  # R_std basis rows, in E_std (A,B,C,D) coordinates
print()
print("R_std basis in E_std coordinates (X), valuations only:")
for row in X.rows():
    print("  ", [c.valuation() if c != 0 else "inf" for c in row])
vals_ok = all((c == 0) or (c.valuation() >= 0) for row in X.rows() for c in row)
assert vals_ok, "R not contained in E in these coordinates -- bug"

F2 = GF(2)


def res2(a):
    if a == 0:
        return F2(0)
    return F2(0) if a.valuation() >= 1 else F2(a.residue())


X_mod2 = matrix(F2, [[res2(c) for c in row] for row in X.rows()])
print()
print("R_std basis reduced mod 2 (coords in A,B,C,D basis of E/2E):")
print(X_mod2)
R_mod2_span = matrix(F2, X_mod2).row_space()
print("dim(R/2E) computed:", R_mod2_span.dimension(), " (expect 3, matching [E:R]=2)")
assert R_mod2_span.dimension() == 3

V4 = vector(F2, [0, 0, 0, 0]).parent()
ell = vector(F2, [1, 0, 0, 1])  # a+d functional
ker_ell = matrix(F2, [[1, 0, 0, 1], [0, 1, 0, 0], [0, 0, 1, 0]]).row_space()
print("dim(ker ell) =", ker_ell.dimension(), " (expect 3)")

same_subspace = (R_mod2_span == ker_ell)
print()
print("R/2E == ker(ell) [trace-even hyperplane] EXACTLY:", same_subspace)
if not same_subspace:
    print("!!! CLAIM FALSE as stated -- R is NOT the trace-even subset of E.")
    print("    (Would need to identify the ACTUAL functional instead.)")
assert same_subspace, "R is contained in the trace-even hyperplane but does not equal it, or vice versa -- the claim as stated is FALSE; do not use it downstream"
print()
print("CONFIRMED (from the real, previously-certified R_std/E_std bases,")
print("not from hand-picked matrices): R_pbar = {x in E_pbar : tr(x) in 2*Z2}")
print("exactly, as Z2-lattices.")

######################################################################
# STEP 3: N(R) subset N(E) -- formal, from the ALREADY-CERTIFIED
#          complete overorder poset (unique index-2 overorder E).
#          No new computation: restated for the record.
######################################################################
print()
print("=" * 70)
print("STEP 3: N(R) subset N(E) -- from the certified poset (formal)")
print("=" * 70)
print("Poset {R,E,M0,M1} is complete and exhaustive (certified twice: ")
print("m009_dyadic_index_check.sage AND m009_dyadic_bass_certificate.sage).")
print("E is the UNIQUE index-2 overorder of R. For g in N(R), conjugation")
print("permutes R's overorders preserving index (S/R -> gSg^-1/R is a")
print("group isomorphism once gRg^-1=R), so g must fix the unique index-2")
print("overorder: g E g^-1 = E, i.e. g in N(E). N(R) subset N(E). QED (formal).")

######################################################################
# STEP 4: N(E) subset N(R) -- from trace-invariance + STEP 2's fact.
#          Also formal, but STATE it explicitly and verify the trace-
#          invariance identity computationally on a random test element
#          as an extra sanity check (trace(g x g^-1) = trace(x) is an
#          elementary algebraic identity, but verifying it numerically
#          here costs nothing and catches any convention slip).
######################################################################
print()
print("=" * 70)
print("STEP 4: N(E) subset N(R) -- from tr(gxg^-1)=tr(x) + Step 2")
print("=" * 70)
test_g = matrix(Q2, [[Q2(3), Q2(1)], [Q2(0), Q2(1)]])  # arbitrary invertible test matrix
test_x = A + 2 * B + 3 * C + 5 * D
lhs = (test_g * test_x * test_g.inverse())[0, 0] + (test_g * test_x * test_g.inverse())[1, 1]
rhs = test_x[0, 0] + test_x[1, 1]
print("trace(g x g^-1) == trace(x) for arbitrary test g,x:", lhs == rhs)
assert lhs == rhs
print("Elementary identity confirmed. Combined with Step 2 (R = trace-even")
print("subset of E exactly): for g in N(E), x in R => g x g^-1 in E (since")
print("g E g^-1=E) with the same trace as x (in 2Z2) => g x g^-1 in R.")
print("Applying to g^-1 too gives the reverse containment. N(E) subset N(R). QED.")

print()
print("=" * 70)
print(">>> STEPS 3+4 TOGETHER: N(R_pbar) = N(E_pbar) <<<")
print("=" * 70)

######################################################################
# STEP 5: CONCRETE cross-check -- derive (not assume) the conjugation
#          action of three explicit candidate N(E) generators from
#          REAL matrix conjugation, verify they actually normalize
#          E_std AND R_std at the FULL Z2-lattice level (not just mod
#          2), and cross-check the derived mod-2 action matrices
#          against GPT's hand-supplied TB, TC, W.
######################################################################
print()
print("=" * 70)
print("STEP 5: concrete generators -- derive TB,TC,W by REAL conjugation")
print("=" * 70)

uB = matrix(Q2, [[Q2(1), Q2(2)], [Q2(0), Q2(1)]])
uC = matrix(Q2, [[Q2(1), Q2(0)], [Q2(1), Q2(1)]])
w_elt = matrix(Q2, [[Q2(0), Q2(2)], [Q2(1), Q2(0)]])
gens = {"uB": uB, "uC": uC, "w": w_elt}


def same_lattice(basis1, basis2):
    F1 = matrix(Q2, [flat(b) for b in basis1])
    F2m = matrix(Q2, [flat(b) for b in basis2])
    Aq = F1 * F2m.inverse()
    Bq = F2m * F1.inverse()
    return (all((c == 0) or (c.valuation() >= 0) for row in Aq.rows() for c in row) and
            all((c == 0) or (c.valuation() >= 0) for row in Bq.rows() for c in row))


for name, g in gens.items():
    ginv = g.inverse()
    conj_E = [g * e * ginv for e in E_std]
    normalizes_E = same_lattice(conj_E, E_std)
    print(f"  {name}: normalizes E_std (g*E*g^-1 == E, full Z2-lattice)?  {normalizes_E}")
    assert normalizes_E, f"{name} does NOT actually normalize E -- GPT's generator claim is wrong"
    conj_R = [g * r * ginv for r in r_basis]
    normalizes_R = same_lattice(conj_R, r_basis)
    print(f"  {name}: normalizes R_std (g*R*g^-1 == R, full Z2-lattice, DIRECT check)?  {normalizes_R}")
    assert normalizes_R, f"{name} normalizes E but NOT R -- N(E)=N(R) would be FALSE"

print()
print("All three generators independently verified, at the FULL Z2-lattice")
print("level (not just mod 2), to normalize BOTH E_std and R_std directly.")
print("This is a strictly stronger, more direct check than the mod-2 residue")
print("action alone.")

######################################################################
# STEP 6: derive the mod-2E conjugation action matrices from the REAL
#          generators (not hand-typed), and cross-check vs GPT's TB,TC,W.
######################################################################
print()
print("=" * 70)
print("STEP 6: derive TB,TC,W (mod-2 conjugation action) from real data")
print("=" * 70)

Ef_inv = Ef.inverse()


def action_matrix(g):
    ginv = g.inverse()
    cols = []
    for e in E_std:
        img = g * e * ginv
        coeffs = flat(img) * Ef_inv  # coords in (A,B,C,D)
        vals = [c.valuation() if c != 0 else Infinity for c in coeffs]
        assert all(v >= 0 for v in vals), "conjugate not integral in E_std coords -- bug"
        cols.append(vector(F2, [res2(c) for c in coeffs]))
    # cols[j] = image of basis vector j in (A,B,C,D) coords, matching
    # GPT's stated convention "image vectors as columns": M's j-th
    # COLUMN is cols[j], so M acts on COLUMN coordinate vectors via
    # left multiplication y = M*x (NOT row vectors via v*M).
    return matrix(F2, 4, 4, lambda a, b: cols[b][a])


TB_computed = action_matrix(uB)
TC_computed = action_matrix(uC)
W_computed = action_matrix(w_elt)

TB_claimed = matrix(F2, [[1, 0, 0, 0], [1, 1, 0, 1], [0, 0, 1, 0], [0, 0, 0, 1]])
TC_claimed = matrix(F2, [[1, 0, 0, 0], [0, 1, 0, 0], [1, 0, 1, 1], [0, 0, 0, 1]])
W_claimed = matrix(F2, [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]])

print("TB (derived from real conjugation):")
print(TB_computed)
print("TB (GPT's claimed matrix):")
print(TB_claimed)
print("match:", TB_computed == TB_claimed)
print()
print("TC (derived):")
print(TC_computed)
print("TC (claimed):")
print(TC_claimed)
print("match:", TC_computed == TC_claimed)
print()
print("W (derived):")
print(W_computed)
print("W (claimed):")
print(W_claimed)
print("match:", W_computed == W_claimed)

TB_match = (TB_computed == TB_claimed)
TC_match = (TC_computed == TC_claimed)
W_match = (W_computed == W_claimed)

######################################################################
# STEP 7: group generated by the DERIVED matrices; stabilizer of the
#          ACTUAL R/2E subspace (from Step 2, not the hand-picked H).
######################################################################
print()
print("=" * 70)
print("STEP 7: group + stabilizer, using DERIVED matrices and REAL R/2E")
print("=" * 70)
G_derived = MatrixGroup([TB_computed, TC_computed, W_computed])
print("order of <TB,TC,W> (derived):", G_derived.order())

H_real = R_mod2_span  # the ACTUAL R/2E subspace computed in Step 2
stab_ok = True
# NOTE on convention: action_matrix() builds M with columns = images of
# basis vectors (matching GPT's own stated convention "image vectors as
# columns"), so M acts on COORDINATE vectors via left mult y = M*x (x a
# column vector) -- NOT via right mult v*M. Get this backwards and the
# stabilizer check silently tests the wrong (transposed) action.
for g in G_derived:
    gm = matrix(F2, g.matrix())
    img = matrix(F2, [gm * b for b in H_real.basis()]).row_space()
    if img != H_real:
        stab_ok = False
        break
print("Every element of <TB,TC,W> (derived) preserves the REAL R/2E subspace:", stab_ok)

######################################################################
# FINAL SUMMARY
######################################################################
print()
print("=" * 70)
print("FINAL SUMMARY")
print("=" * 70)
print(f"R_pbar = trace-even subset of E_pbar (exact lattice identity): CONFIRMED")
print(f"N(R_pbar) subset N(E_pbar): proved formally from certified poset")
print(f"N(E_pbar) subset N(R_pbar): proved formally from trace-invariance + above")
print(f"  ==> N(R_pbar) = N(E_pbar), LOCALLY AT pbar.  [rigorous, not a heuristic match]")
print()
print(f"Concrete generators uB, uC, w: normalize BOTH E and R directly (full lattice): CONFIRMED")
print(f"Derived mod-2 action matrices match GPT's hand-supplied TB,TC,W: "
      f"TB={TB_match}, TC={TC_match}, W={W_match}")
print(f"<TB,TC,W> order (derived): {G_derived.order()}")
print(f"<TB,TC,W> (derived) stabilizes the REAL R/2E subspace: {stab_ok}")
print()
print("NOT established here (explicitly out of scope for this script):")
print("  - whether {uB,uC,w} together with GL2(Z2)-units generate the FULL")
print("    image of N(E) on E/2E (i.e. completeness of the D8 image claim)")
print("  - the GLOBAL claim: whether the local edge-swap w globalizes to an")
print("    actual K-rational element of the arithmetic normalizer, whether")
print("    local normalizers are trivial at all OTHER finite places, and")
print("    hence whether [N(R):Gamma_009]=2 and covol(N(R))=1.33337... hold")
print("    globally. These require separate, dedicated verification before")
print("    being written into the paper or gap report as proved.")
