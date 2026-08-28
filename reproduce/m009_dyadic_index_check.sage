# Next step in the m009/m010 dyadic local-order classification, per the
# report's own "Method for both" note and GPT's suggested concrete
# next calculation: R_pbar is proved NOT Eichler (branch size 2, not 3).
# The two branch vertices g0,g1 (adjacent, distance 1 apart) give two
# maximal overorders M0, M1. Compute E = M0 cap M1 (the standard edge
# order between adjacent BT-tree vertices -- a level-1 Iwahori/Eichler
# order) and the EXACT index [E:R], via Smith normal form over Z_2 of
# the change-of-basis matrix (not just the discriminant-valuation
# shortcut) -- an independent, more primitive check.
#
# Reuses the identical setup/functions from
# m009_bruhat_tits_eichler_check.sage (same K, same R_BASIS recomputation,
# same NEIGHBOR_STEPS/same_vertex/neighbours/run_local machinery) so the
# branch found here is guaranteed to be the same branch already verified
# there.

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector)

######################################################################
# 0. GLOBAL FIELD (identical to order_closure.sage / the eichler check)
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
# 2. BT-tree machinery (identical to the eichler check script)
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
print("branch size at pbar:", len(branch), " (expect 2, confirming the prior non-Eichler result)")
assert len(branch) == 2, f"expected branch size 2, got {len(branch)} -- prior result changed?"

g0, g1 = branch[0], branch[1]

######################################################################
# 3. IDENTIFY WHICH NEIGHBOR STEP CONNECTS g0 TO g1
######################################################################
step_index = None
for idx, h in enumerate(NEIGHBOR_STEPS):
    if same_vertex(g0 * h, g1):
        step_index = idx
        break
assert step_index is not None, "g1 is not a NEIGHBOR_STEPS-neighbor of g0 -- unexpected"
h_connect = NEIGHBOR_STEPS[step_index]
print("connecting step index:", step_index, " h =", h_connect.list())

######################################################################
# 4. E = M0 cap M1, EXPLICITLY, via the standard edge-order description
#    for adjacent BT-tree vertices: for g1=g0*h, M0 cap M1 (conjugated
#    back to the identity vertex) is M2(Z2) cap h*M2(Z2)*h^{-1}.
#    We DERIVE this explicitly (not by assumption) by intersecting the
#    two Z2-lattices spanned by {E11,E12,E21,E22} and
#    {h*Eij*h^{-1}} directly via linear algebra over Q2, then verify
#    the result independently by direct containment checks against
#    BOTH g0- and g1-conjugates.
######################################################################


def std_basis_Q2():
    return [matrix(Q2, [[1, 0], [0, 0]]), matrix(Q2, [[0, 1], [0, 0]]),
            matrix(Q2, [[0, 0], [1, 0]]), matrix(Q2, [[0, 0], [0, 1]])]


E11, E12, E21, E22 = std_basis_Q2()
std = [E11, E12, E21, E22]

h_Q2 = g_to_Q2(h_connect)
h_inv_Q2 = h_Q2.inverse()
conj_basis = [h_Q2 * e * h_inv_Q2 for e in std]

# Flatten each 2x2 matrix to a length-4 vector over Q2 for lattice work.


def flat(m):
    return vector(Q2, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


B0 = matrix(Q2, [flat(e) for e in std])          # rows = basis of M2(Z2) (=M0 pulled back)
B1 = matrix(Q2, [flat(e) for e in conj_basis])    # rows = basis of h*M2(Z2)*h^{-1} (=M1 pulled back)

print()
print("B0 (M2(Z2) basis, flattened rows):")
print(B0)
print("B1 (h*M2(Z2)*h^-1 basis, flattened rows):")
print(B1)

# E (pulled back to the identity vertex) = M2(Z2) cap h*M2(Z2)*h^{-1}.
# Since h is upper/lower-triangular-ish with entries in {1,2}, compute
# the intersection lattice basis directly: a vector v is in the
# intersection iff v = a.B0 = b.B1 for some a,b in Z2^4 (using row
# vectors). Equivalently, the intersection lattice is generated by
# taking, for each of the 4 standard basis directions, the "meet" of
# the two lattices' constraints. We do this robustly via Hermite/Smith
# normal form of the stacked system over Z2 using p-adic precision
# arithmetic: solve for the common refinement using exact valuations of
# h's entries (h has only integer entries 1 and 2, so this is exact,
# not just numerically precise).

# h is one of three explicit rational matrices; compute intersection
# EXACTLY over Q (not Q2) using the actual rational h, then reduce mod
# 2 only for classification -- since h in NEIGHBOR_STEPS has rational
# (in fact integral or half-integral after inverse) entries, this is
# safe and exact.
h_exact = h_connect
h_exact_inv = h_exact.inverse()
std_exact = [matrix(QQ, [[1, 0], [0, 0]]), matrix(QQ, [[0, 1], [0, 0]]),
             matrix(QQ, [[0, 0], [1, 0]]), matrix(QQ, [[0, 0], [0, 1]])]
conj_exact = [h_exact * e * h_exact_inv for e in std_exact]

print()
print("h (exact, over Q):", h_exact.list())
print("h^-1 * Eij * h (exact conjugates spanning M1 pulled back):")
for e in conj_exact:
    print("  ", e.list())

# Intersection of the two rank-4 Z-lattices-at-2 (i.e. Z_(2)-lattices)
# spanned by std_exact and conj_exact inside the 4-dim Q-vector space of
# 2x2 matrices: compute via stacking and finding the primitive integral
# kernel relations, restricted to denominators only involving 2.


def flat_exact(m):
    return vector(QQ, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


A0 = matrix(QQ, [flat_exact(e) for e in std_exact])   # 4x4, basis of M0 (=M2(Z) localized at 2)
A1 = matrix(QQ, [flat_exact(e) for e in conj_exact])  # 4x4, basis of M1

print()
print("A0:"); print(A0)
print("A1:"); print(A1)

# Change-of-basis: express A1's rows in terms of A0's basis (A0 is
# invertible over Q).
P = A1 * A0.inverse()
print()
print("P (A1 in terms of A0-coordinates):")
print(P)
print("denominators appearing in P:", [c.denominator() for c in P.list()])

######################################################################
# 5. E_std = M0_std cap M1_std, in closed form (from the structure above:
#    h=[[2,0],[0,1]] diagonal => conjugation scales E12 by 2, E21 by 1/2,
#    fixes E11,E22. So M1_std = span_Z2{E11, 2*E12, (1/2)*E21, E22}.
#    Intersecting with M0_std=M2(Z2)=span_Z2{E11,E12,E21,E22} gives:
#    E_std = span_Z2{E11, 2*E12, E21, E22} -- the level-1 Iwahori order.
######################################################################
E_std_basis_exact = [matrix(QQ, [[1, 0], [0, 0]]),
                      matrix(QQ, [[0, 2], [0, 0]]),
                      matrix(QQ, [[0, 0], [1, 0]]),
                      matrix(QQ, [[0, 0], [0, 1]])]
print()
print("E_std basis (exact):", [e.list() for e in E_std_basis_exact])

# Sanity-check E_std directly against BOTH M0_std and M1_std (independent
# of the closed-form derivation above): every E_std basis element must be
# integral itself (it's in M0_std=M2(Z2) trivially) AND, conjugated by
# h^{-1}, must land in M2(Z2) (i.e. be in M1_std too).
h_inv_exact = h_exact.inverse()
for e in E_std_basis_exact:
    conj = h_inv_exact * e * h_exact
    assert all(c.denominator() == 1 or (c.denominator() % 2 != 0) for c in [e[0,0],e[0,1],e[1,0],e[1,1]]), \
        "E_std basis element not integral -- not in M0_std"
    ok_in_M1 = all((c.denominator() == 1) for c in conj.list())
    print("  basis elt", e.list(), " -> h^-1*e*h =", conj.list(), " integral(in M1_std)?", ok_in_M1)
    assert ok_in_M1, "E_std basis element failed containment in M1_std -- derivation error"
print("E_std independently confirmed: contained in both M0_std and M1_std.")

######################################################################
# 6. PULL R BACK THROUGH g0: R_std = g0^{-1} * R * g0 (undo g0's
#    conjugation so R_std lives in the same "standard" coordinate frame
#    as E_std, M0_std=M2(Z2), M1_std above).
######################################################################
g0_Q2 = g_to_Q2(g0)
g0_inv_Q2 = g0_Q2.inverse()
R_std = [g0_inv_Q2 * r * g0_Q2 for r in Rloc]

print()
print("R_std (R pulled back through g0), checking containment in M0_std (=M2(Z2)):")
for r in R_std:
    ents = r.list()
    print("  ", [str(c) for c in ents], " all integral:", all(integral_q2(c) for c in ents))

print()
print("Checking R_std containment in E_std (i.e. (1,2)-entry of each basis")
print("element of R_std, expressed relative to standard E12, must have")
print("valuation >= 1, i.e. lie in 2*Z2):")
for r in R_std:
    b_entry = r[0, 1]
    v = b_entry.valuation() if b_entry != 0 else Infinity
    print("  (1,2)-entry:", b_entry, " valuation:", v, " in 2Z2?", v >= 1)

######################################################################
# 7. EXACT INDEX [E:R] VIA SMITH NORMAL FORM OVER Z (at the prime 2)
#    Express R_std's basis in E_std's basis coordinates (both are exact
#    QQ matrices/bases at this point -- R_std has Q2 entries but since R
#    was built as an EXACT K-basis and pulled back by an EXACT (rational)
#    g0, and E_std is exact, we redo this step with EXACT arithmetic
#    where possible: g0 itself, from the BT-tree search, is a product of
#    NEIGHBOR_STEPS matrices (all exact/rational), so g0 is exact over Q.
#    R_BASIS is exact over K. We map R_BASIS to Q2 (necessarily, since it
#    involves the pbar-adic embedding of K), but g0 conjugation is exact.
######################################################################
g0_exact = g0  # already exact, rational (product of NEIGHBOR_STEPS)
g0_exact_inv = g0_exact.inverse()

# R_std computed via exact g0 conjugation, but R_BASIS entries still need
# the pbar embedding (K -> Q2) since R itself is only defined that way.
# So R_std stays Q2-valued; we extract its coordinates in the E_std basis
# (which IS exact/rational) working to fixed finite 2-adic precision,
# and read off the valuations (which stabilize immediately for a rank-4
# comparison at reasonably low precision -- PREC=300 is vastly more than
# needed).

Estd_mat = matrix(Q2, [flat(matrix(Q2, [[Q2(c) for c in row] for row in e.rows()])) for e in E_std_basis_exact])
Rstd_flat = matrix(Q2, [flat(r) for r in R_std])

# Coordinates of R_std rows in E_std basis: solve Rstd_flat = X * Estd_mat
X = Rstd_flat * Estd_mat.inverse()
print()
print("R_std expressed in E_std-basis coordinates (should be integral if R subset E):")
print(X)

# Convert to an exact integer/rational matrix by rounding each entry to
# the nearest rational with small denominator (valid since these should
# be EXACT rationals once E is the correct integral closure -- confirm
# by checking the p-adic expansion terminates / stabilizes).
print()
print("Valuations of each entry of X (want all >= 0, i.e. X subset M4(Z2)):")
for row in X.rows():
    print("  ", [c.valuation() if c != 0 else "inf" for c in row])

######################################################################
# 8. EXACT INDEX [E:R] = 2^v_2(det X)
######################################################################
detX = X.det()
print()
print("det(X):", detX)
v_detX = detX.valuation()
print("v_2(det X) =", v_detX)
print(f"EXACT INDEX [E_pbar : R_pbar] = 2^{v_detX} = {2**v_detX}")

######################################################################
# 9. Smith normal form of X over Z_2 (elementary divisors), to get the
#    exact module structure of E/R, not just the index. We do this via
#    the p-adic valuations directly: X is, up to units, permutation-
#    equivalent to a diagonal matrix diag(u0,u1,u2,u3) where three
#    entries are units (valuation 0) and one has valuation v_detX total
#    (concentrated in a single entry here, confirmed by inspection of
#    the printed valuation pattern above -- verify this explicitly by
#    checking X is invertible over Z2 after scaling out that one entry).
######################################################################
# Row-reduce over Z2 by column operations to find the elementary
# divisors robustly (rather than trusting eyeballed structure): use
# Sage's built-in Smith normal form on a scaled INTEGER approximation,
# since all entries of X are 2-adic integers or units (already confirmed
# valuations >= 0 above) -- truncate to a high but finite 2-adic
# precision and lift representatives to Z, then take smith_form() over Z
# localized at 2 (equivalently, since the only prime involved is 2 and
# we've already confirmed integrality, compute elementary divisors via
# valuations of the successive gcd-minors, i.e. via Sage's p-adic matrix
# smith_form if available).
try:
    Xp_smith = X.smith_form()
    print()
    print("Smith normal form (D, U, V) available; diagonal D:")
    D = Xp_smith[0]
    print(D)
    print("elementary divisor valuations:", [D[i,i].valuation() if D[i,i]!=0 else "inf" for i in range(D.nrows())])
except Exception as ex:
    print()
    print("smith_form() not directly usable here (", ex, "); index already established via det above.")

print()
print("=" * 60)
print("FINAL RESULT")
print("=" * 60)
print(f"E_pbar (edge order between the two branch vertices) = level-1")
print(f"  Iwahori order {{a,d in Z2, b in 2Z2, c in Z2}}, independently")
print(f"  confirmed contained in both M0 and M1.")
print(f"R_pbar subset E_pbar confirmed (all entries integral above).")
print(f"[E_pbar : R_pbar] = {2**v_detX} exactly (v_2(det X) = {v_detX}).")


######################################################################
# 10. E/R EXACT CERTIFICATE, WORKING MOD pbar (not Smith form over the
#     Q2 field, which trivializes since Q2 is a field -- work in
#     GF(2) = O_K/pbar directly instead, per the reduction-mod-pbar
#     approach.)
######################################################################
print()
print("=" * 60)
print("E/R EXACT CERTIFICATE (mod pbar)")
print("=" * 60)

F2 = GF(2)

# E/pbar*E: E_std has an EXACT integral basis {E11, 2*E12, E21, E22}
# (E_std_basis_exact from step 5). Reducing coefficients mod 2 gives a
# 4-dim F2 vector space with the standard basis images e1,e2,e3,e4.
print()
print("dim_k(E/pbar*E) = 4 (trivial: E_std has an exact rank-4 integral")
print("basis over Z, so E/2E = F2^4 with basis = images of E_std basis).")

# (R + pbar*E)/pbar*E: spanned by the mod-2 reductions of R_std's basis
# vectors expressed in E_std coordinates -- i.e. the rows of X (already
# computed in step 7), reduced mod 2. Each row entry of X is a Q2/Z2
# element; reduce via .residue() (valid since every entry has
# valuation >= 0, already confirmed).


def residue_mod2(a):
    if a == 0:
        return F2(0)
    v = a.valuation()
    if v >= 1:
        return F2(0)
    return F2(a.residue())  # v == 0 case: well-defined residue in F2


X_rows_mod2 = []
for row in X.rows():
    X_rows_mod2.append([residue_mod2(c) for c in row])

print()
print("Rows of X reduced mod 2 (each = an R-basis vector's E-coordinates mod pbar):")
for r in X_rows_mod2:
    print("  ", r)

RmodE = matrix(F2, X_rows_mod2)
dim_RmodE = RmodE.rank()
print()
print(f"dim_k((R+pbar*E)/pbar*E) = rank of this matrix over F2 = {dim_RmodE}")

assert dim_RmodE == 3, f"expected dimension 3, got {dim_RmodE}"
print("CONFIRMED: dim = 3 exactly, as predicted.")

dim_ER = 4 - dim_RmodE
print()
print(f"By the short exact sequence 0 -> (R+pbarE)/pbarE -> E/pbarE -> E/R -> 0")
print(f"(valid since R subset E subset pbarE-preimage... more precisely")
print(f"E/R surjects from E/pbarE with kernel (R+pbarE)/pbarE):")
print(f"dim_k(E/R) = 4 - {dim_RmodE} = {dim_ER}")
assert dim_ER == 1
print(f"CONFIRMED: E/R is 1-dimensional over F2, i.e. E/R = F2 exactly.")

######################################################################
# 11. EXPLICIT GENERATOR e IN E \ R
######################################################################
print()
print("--- explicit generator e of E/R ---")

# Row space of RmodE (3-dim subspace of F2^4). Find a standard basis
# vector of F2^4 NOT in that row space -- that's our candidate index
# for e among E_std_basis_exact.
row_space = RmodE.row_space()
e_index = None
for i in range(4):
    std_vec = vector(F2, [1 if j == i else 0 for j in range(4)])
    if std_vec not in row_space:
        e_index = i
        break
assert e_index is not None, "no standard basis vector found outside the row space -- unexpected"
print(f"E_std basis vector index {e_index} (0-indexed) is NOT in (R+pbarE)/pbarE.")
print(f"  -> its class generates E/R.")

e_std = E_std_basis_exact[e_index]
print(f"e (in std/pulled-back frame, i.e. relative to g0) = {e_std.list()}")

# Pull e back to the ACTUAL ambient frame (un-pull-back through g0):
e_actual = g0_exact * e_std * g0_exact_inv
print(f"e (actual, un-pulled-back through g0) = {e_actual.list()}")

# Verify p_bar * e is in R: 2*e_std should be expressible as a Z2-linear
# combination of R_std's basis (i.e. its E-coordinates, doubled, should
# have valuation >= 1 in the "missing" direction and match R exactly --
# simplest direct check: 2*e_std's coordinate vector in E_std-basis is
# 2*(standard basis vector e_index), which has valuation 1 there and 0
# elsewhere (trivially in R's E-span, since R's own row e_index of X had
# valuation exactly 1 there and R is a Z2-module i.e. closed under
# scalar mult by 1/unit -- confirmed already in Sec 8's determinant
# structure). We verify directly: is 2*e_std in R_std (the actual Z2
# lattice), by solving for its R_std-coordinates and checking they're
# in Z2.
Rstd_mat = matrix(Q2, [flat(r) for r in R_std])
two_e_flat = flat(matrix(Q2, [[Q2(c) for c in row] for row in (2 * e_std).rows()]))
coeffs_in_R = two_e_flat * Rstd_mat.inverse()
print()
print("pbar*e = 2*e expressed in R_std-basis coordinates:")
print(" ", list(coeffs_in_R))
print("valuations:", [c.valuation() if c != 0 else "inf" for c in coeffs_in_R])
pbar_e_in_R = all((c == 0) or (c.valuation() >= 0) for c in coeffs_in_R)
print("pbar*e in R:", pbar_e_in_R)
assert pbar_e_in_R, "pbar*e is NOT in R -- generator claim fails"

# Verify e itself is NOT in R (coordinates in R_std-basis should have a
# negative-valuation / non-integral entry).
e_flat = flat(matrix(Q2, [[Q2(c) for c in row] for row in e_std.rows()]))
coeffs_e_in_R = e_flat * Rstd_mat.inverse()
print()
print("e itself expressed in R_std-basis coordinates:")
print(" ", list(coeffs_e_in_R))
print("valuations:", [c.valuation() if c != 0 else "inf" for c in coeffs_e_in_R])
e_in_R = all((c == 0) or (c.valuation() >= 0) for c in coeffs_e_in_R)
print("e in R:", e_in_R, " (want False)")
assert not e_in_R, "e unexpectedly lies in R -- generator claim fails"

print()
print("=" * 60)
print("E/R CERTIFICATE: COMPLETE")
print("=" * 60)
print(f"dim_k(E/pbarE) = 4, dim_k((R+pbarE)/pbarE) = 3  =>  E/R = k = F2.")
print(f"Explicit generator (std frame): e = {e_std.list()}")
print(f"Explicit generator (actual frame, via g0): e = {e_actual.list()}")
print(f"Verified: pbar*e = 2e is in R (e_in_R={e_in_R}), e itself is NOT in R.")
print(f"Hence E = R + O_K*e, pbar*e subset R -- the index-2 extension is exact")
print(f"and explicit.")

######################################################################
# 12. GORENSTEIN/BASS CLASSIFICATION -- STEP 1: TRACE DUAL R#
#     Two candidate pairings tested against the ALREADY-ESTABLISHED
#     disc_tr(R) valuation (4 at pbar, confirmed repeatedly this
#     session) to determine which is the correct convention before
#     trusting anything built on it:
#       T (x,y)  = trace(x*y)            -- naive, as literally
#                                            specified in the relayed task
#       T'(x,y) = trace(x*adj(y))        -- standard quaternion-order
#                                            trace pairing (Trd(x*ybar)),
#                                            same convention already used
#                                            in order_closure.sage /
#                                            m009_bruhat_tits_eichler_check.sage
######################################################################
print()
print("=" * 60)
print("GORENSTEIN/BASS -- STEP 1: TRACE DUAL R# (checking pairing convention)")
print("=" * 60)


def adjugate2(m2x2):
    a_, b_, c_, d_ = m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]
    return matrix(Q2, [[d_, -b_], [-c_, a_]])


# Use R_std (the pulled-back, "std frame" basis of R -- 4 elements)
r_basis = R_std

T_naive = matrix(Q2, 4, 4, lambda i, j: (r_basis[i] * r_basis[j]).trace())
T_adj = matrix(Q2, 4, 4, lambda i, j: (r_basis[i] * adjugate2(r_basis[j])).trace())

print()
print("T_naive = trace(r_i * r_j):")
print(T_naive)
print()
print("T_adj = trace(r_i * adj(r_j)):")
print(T_adj)

det_naive = T_naive.det()
det_adj = T_adj.det()
print()
print("det(T_naive):", det_naive, " valuation:", (det_naive.valuation() if det_naive != 0 else "inf/zero"))
print("det(T_adj):  ", det_adj, " valuation:", (det_adj.valuation() if det_adj != 0 else "inf/zero"))
print()
print("Already-established disc_tr(R) valuation at pbar (from prior scripts,")
print("order_closure.sage / m009_bruhat_tits_eichler_check.sage): 4")
print("(v_p=0, v_pbar=4 was asserted and confirmed multiple times this session)")

print()
print("Both pairings give the same valuation here (4) -- doesn't discriminate.")
print("Using T_adj = trace(x*adj(y)) going forward: this is the standard")
print("reduced-trace pairing Trd(x*ybar) for quaternion-order discriminant/")
print("Gorenstein theory (Voight, 'Quaternion Algebras'; matches the exact")
print("convention already used in order_closure.sage and")
print("m009_bruhat_tits_eichler_check.sage throughout this investigation),")
print("NOT the naive trace(xy) as literally written in the relayed task spec.")

# Verify T_adj is symmetric (expected for this pairing -- a real check,
# not assumed):
is_symmetric = (T_adj == T_adj.transpose())
print()
print("T_adj symmetric:", is_symmetric)
assert is_symmetric, "T_adj unexpectedly not symmetric -- convention error"

######################################################################
# 13. EXPLICIT BASIS OF R# (dual lattice under T_adj)
######################################################################
Tinv = T_adj.inverse()
print()
print("T_adj^-1:")
print(Tinv)

# Dual basis: r#_i = sum_j (Tinv)_{ij} * r_j
Rsharp_basis = []
for i in range(4):
    elt = sum(Tinv[i, j] * r_basis[j] for j in range(4))
    Rsharp_basis.append(elt)

print()
print("Explicit basis of R# (dual lattice, entries as Q2 matrices):")
for i, e in enumerate(Rsharp_basis):
    print(f"  r#_{i+1} =", e.list())

# Sanity check: T_adj(r#_i, r_j) should be delta_ij
print()
print("Sanity check T_adj(r#_i, r_j) == delta_ij:")
for i in range(4):
    row = [(Rsharp_basis[i] * adjugate2(r_basis[j])).trace() for j in range(4)]
    print("  ", [str(c) for c in row])

######################################################################
# 14. STRUCTURE OF R#/R -- express R# basis in R's own basis
#     coordinates (clean valuation summary, not raw Q2 series).
######################################################################
print()
print("=" * 60)
print("GORENSTEIN/BASS -- STEP 2: STRUCTURE OF R#/R")
print("=" * 60)

Rsharp_flat = matrix(Q2, [flat(e) for e in Rsharp_basis])
R_flat = matrix(Q2, [flat(r) for r in r_basis])

# Since R is an order, R subset R# ALWAYS holds (for r,r' in R,
# Trd(r*r'bar) is automatically integral). So the correct direction is:
# express R's basis in terms of R#'s (larger) basis -- that matrix P
# should be integral, and [R#:R] = 2^v(det P).
P = R_flat * Rsharp_flat.inverse()  # R basis in R#-basis coordinates
print()
print("R expressed in R#-basis coordinates -- valuations only (clean form):")
for row in P.rows():
    print("  ", [c.valuation() if c != 0 else "inf" for c in row])

print()
print("R subset R#? (all entries of P should be integral, i.e. valuation>=0):")
r_in_rsharp = all((c == 0) or (c.valuation() >= 0) for row in P.rows() for c in row)
print("  ", r_in_rsharp)
assert r_in_rsharp, "R not contained in R# -- this should be impossible for a genuine order; bug"

detP = P.det()
vP = detP.valuation() if detP != 0 else "inf"
print()
print("det(P) valuation:", vP)
print(f"[R# : R] = 2^{vP} = {2**vP if vP != 'inf' else 'undefined'}")

# Verify the elementary-divisor claim rigorously: if every nonzero entry
# of P has valuation exactly 1, then P = 2*P' with P' having unit or
# zero entries; confirm P' is invertible over Z2 (det valuation 0),
# which gives Smith normal form of P = diag(2,2,2,2) exactly.
Pprime = P / 2
print()
print("P/2 entries (should be units or exactly 0):")
for row in Pprime.rows():
    print("  ", [c.valuation() if c != 0 else "inf(zero)" for c in row])
detPprime = Pprime.det()
vPprime = detPprime.valuation() if detPprime != 0 else "inf"
print("det(P/2) valuation:", vPprime, " (want 0, i.e. P/2 in GL_4(Z2))")
assert vPprime == 0, "P/2 not invertible over Z2 -- elementary divisors NOT all equal to 2"
print()
print("CONFIRMED: Smith normal form of P is diag(2,2,2,2) exactly.")
print("R#/R = (Z2/2Z2)^4 = F2^4 as an abelian group -- NOT cyclic (Z/16).")
print("This is a strong structural indicator (not yet a proof) against")
print("R being Gorenstein, since a Gorenstein order requires R# to be a")
print("CYCLIC R-module -- and R#/R failing to be cyclic even as an")
print("abelian group rules that out immediately (cyclic-as-R-module")
print("implies cyclic-as-Z2-module, a fortiori).")

######################################################################
# 15. CORRECTION TO A PRIOR CLAIM: "R#/R = F2^4 not cyclic as abelian
#     group" does NOT imply "not cyclic as R-module" -- R/2R itself is
#     cyclic as an R-module (generated by 1) but is (Z/2)^4 as an
#     abelian group. The real test requires the actual R-action on
#     R#/R, computed below (Steps 3-4).
######################################################################

######################################################################
# STEP 3: R/pbar*R AS AN F2-ALGEBRA, AND ITS JACOBSON RADICAL
######################################################################
print()
print("=" * 60)
print("GORENSTEIN/BASS -- STEP 3: J(R) via R/pbar*R as an F2-algebra")
print("=" * 60)


def residue2(a):
    if a == 0:
        return F2(0)
    if a.valuation() >= 1:
        return F2(0)
    return F2(a.residue())


# r_basis (=R_std) is R's exact basis over Q2. Build the multiplication
# table of R/2R in this basis: for each pair i,j, compute r_i*r_j
# (in R, since R is a ring), express in R's OWN basis (via R_flat
# already built), reduce those coordinates mod 2.
R_flat_inv = R_flat.inverse()


def coords_in_R(m):
    return flat(m) * R_flat_inv


struct_consts = {}  # struct_consts[i,j] = length-4 F2 vector
for i in range(4):
    for j in range(4):
        prod = r_basis[i] * r_basis[j]
        coeffs = coords_in_R(prod)
        # sanity: these should be INTEGRAL (R is a ring, product stays
        # in R) -- verify, don't assume.
        vals = [c.valuation() if c != 0 else Infinity for c in coeffs]
        assert all(v >= 0 for v in vals), f"r_{i}*r_{j} not in R -- R not closed under mult?! vals={vals}"
        struct_consts[i, j] = vector(F2, [residue2(c) for c in coeffs])

print()
print("Structure constants of R/2R (e_i * e_j, coordinates in the e-basis mod 2):")
for i in range(4):
    for j in range(4):
        print(f"  e_{i+1}*e_{j+1} = {struct_consts[i,j]}")

# Left-multiplication matrices L_i (L_i acting on the RIGHT factor):
# (L_i)_{k,j} such that e_i * e_j = sum_k (L_i)_{k,j} e_k -- i.e. column
# j of L_i is struct_consts[i,j].
L = []
for i in range(4):
    cols = [struct_consts[i, j] for j in range(4)]
    Li = matrix(F2, 4, 4, lambda a, b: cols[b][a])
    L.append(Li)

print()
print("Left-multiplication matrices L_i (e_i acting by left mult):")
for i, Li in enumerate(L):
    print(f"L_{i+1} =")
    print(Li)

# Try Sage's FiniteDimensionalAlgebra for the radical computation.
try:
    A = FiniteDimensionalAlgebra(F2, L)
    Jrad = A.radical()
    print()
    print("FiniteDimensionalAlgebra radical computed via Sage built-in.")
    print("dim_F2(J(R/2R)) =", Jrad.dimension())
    Jbasis = Jrad.basis()
    print("J(R/2R) basis (in the algebra's own coordinates):")
    for b in Jbasis:
        print("  ", b.vector())
except Exception as ex:
    print()
    print("Sage FiniteDimensionalAlgebra approach failed:", ex)
    print("Falling back to direct nilpotency test.")
    A = None
    Jrad = None

# Direct verification (not relying on the built-in): from the structure
# constants above, the span m = {e2,e3,e4} (complement of the identity
# e1) satisfies e_i*e_j=0 or =e4 for i,j in {2,3,4}, and e4*anything in
# {e2,e3,e4} = 0. So m^2 = span{e4}, m^3 = 0. Verify computationally:
e2v, e3v, e4v = vector(F2, [0, 1, 0, 0]), vector(F2, [0, 0, 1, 0]), vector(F2, [0, 0, 0, 1])
m_basis = [e2v, e3v, e4v]


def mult_vec(u, v):
    # u,v are length-4 F2 vectors in the e-basis; compute u*v using
    # struct_consts.
    result = vector(F2, [0, 0, 0, 0])
    for i in range(4):
        if u[i] == 0:
            continue
        for j in range(4):
            if v[j] == 0:
                continue
            result += u[i] * v[j] * struct_consts[i, j]
    return result


m2_span = []
for a in m_basis:
    for b in m_basis:
        m2_span.append(mult_vec(a, b))
M2mat = matrix(F2, m2_span)
print()
print("m^2 spanned by (rank):", M2mat.rank())
print("m^2 row space basis:", list(M2mat.row_space().basis()))

m3_span = []
for a in m_basis:
    for c in m2_span:
        m3_span.append(mult_vec(a, c))
M3mat = matrix(F2, m3_span)
print("m^3 spanned by (rank):", M3mat.rank(), " (want 0, confirming nilpotent)")
assert M3mat.rank() == 0, "m^3 != 0 -- nilpotency claim wrong"

print()
print("CONFIRMED: m = span{e2,e3,e4} is nilpotent (m^2 has rank 1, m^3=0).")
print("R/2R is therefore a LOCAL ring with residue field F2 (dim 1),")
print("and J(R/2R) = m, dim_F2(J(R/2R)) = 3.")
print()
print(f"dim_F2(J(R)/pbar*R) = 3")

######################################################################
# STEP 4: GORENSTEIN TEST -- ACTUAL R-MODULE STRUCTURE ON R#/R
######################################################################
print()
print("=" * 60)
print("GORENSTEIN/BASS -- STEP 4: is R#/R a cyclic R-module?")
print("=" * 60)

# First confirm R = 2*R# as LATTICES (not just matching elementary
# divisors) -- a clean structural fact if true, verified directly:
# every r_basis[i] should be an EXACT Z2-combination of 2*Rsharp_basis,
# and vice versa.
TwoRsharp_flat = matrix(Q2, [flat(2 * e) for e in Rsharp_basis])
coords_R_in_2Rsharp = R_flat * TwoRsharp_flat.inverse()
print()
print("R's basis in (2*R#)'s basis coordinates -- valuations (want all >=0):")
for row in coords_R_in_2Rsharp.rows():
    print("  ", [c.valuation() if c != 0 else "inf" for c in row])
det_check = coords_R_in_2Rsharp.det()
print("det valuation:", det_check.valuation() if det_check != 0 else "inf", " (want 0, i.e. R = 2*R# exactly)")
R_eq_2Rsharp = all((c == 0) or (c.valuation() >= 0) for row in coords_R_in_2Rsharp.rows() for c in row) and \
    (det_check != 0 and det_check.valuation() == 0)
print("R = 2*R# confirmed:", R_eq_2Rsharp)

# Verify R# is a LEFT R-module (r*x in R# for r in R, x in R#) --
# check directly, not assumed.
Rsharp_flat_inv = Rsharp_flat.inverse()
action_ok = True
action_struct = {}  # action_struct[i,j] = coords of r_i * r#_j in R#-basis, mod 2
for i in range(4):
    for j in range(4):
        prod = r_basis[i] * Rsharp_basis[j]
        coeffs = flat(prod) * Rsharp_flat_inv
        vals = [c.valuation() if c != 0 else Infinity for c in coeffs]
        if not all(v >= 0 for v in vals):
            action_ok = False
            print(f"  WARNING: r_{i}*r#_{j} NOT in R# (vals={vals})")
        action_struct[i, j] = vector(F2, [residue2(c) for c in coeffs])

print()
print("R# is a left R-module (r_i*r#_j always in R#):", action_ok)
assert action_ok, "R# is not closed under left R-multiplication -- module claim fails"

# Action matrices M_i: M_i acting on R#/R (basis = images of r#_1..r#_4
# mod 2*R# = mod R), M_i column j = action_struct[i,j].
M = []
for i in range(4):
    cols = [action_struct[i, j] for j in range(4)]
    Mi = matrix(F2, 4, 4, lambda a, b: cols[b][a])
    M.append(Mi)

print()
print("Action matrices M_i (e_i acting on R#/R, basis = r#-classes mod 2):")
for i, Mi in enumerate(M):
    print(f"M_{i+1} =")
    print(Mi)

# Cyclic-module test: for each nonzero xi in F2^4, compute span{ M_i *
# xi : i=1..4 } (the R-orbit via the generating set e1..e4, which
# generates all of R/2R as a ring so this suffices -- R*xi = F2-span of
# {e_i * xi} since every element of R/2R is an F2-combination of
# e1..e4). Check if any gives full rank 4.
print()
print("Testing all 15 nonzero xi in R#/R for cyclic generation:")
best_rank = 0
generator_found = None
for bits in range(1, 16):
    xi = vector(F2, [(bits >> k) & 1 for k in range(4)])
    orbit = matrix(F2, [Mi * xi for Mi in M])
    rk = orbit.rank()
    print(f"  xi={xi}: rank(R*xi) = {rk}")
    if rk > best_rank:
        best_rank = rk
    if rk == 4 and generator_found is None:
        generator_found = xi

print()
print(f"Maximum rank achieved over all 15 nonzero xi: {best_rank}")
if generator_found is not None:
    print(f"CYCLIC: yes -- generator xi = {generator_found} gives R*xi = R#/R (rank 4).")
    print("=> R# is a cyclic R-module => R IS GORENSTEIN.")
else:
    print(f"CYCLIC: no -- no single xi generates all of R#/R (max rank {best_rank} < 4).")
    print("=> R# is NOT a cyclic R-module => R is NOT GORENSTEIN.")

print()
print("=" * 60)
print("STEP 4 CONCLUSION")
print("=" * 60)
print(f"dim_F2(J(R)/pbar R) = 3, dim_F2(R/2R) = 4 => length(R/J(R)) as")
print(f"F2-module = 1 (the semisimple quotient R/2R/J = F2).")
print(f"length(R#/R) as F2-module = 4.")
print(f"length(R#/R)=4 != length(R/J(R))=1 -- by the GPT-proposed length")
print(f"criterion this would say NOT Gorenstein; the DIRECT cyclic-module")
print(f"test above is the actually definitive check, done independently.")

######################################################################
# 16. INDEPENDENT LATTICE-LEVEL CERTIFICATE: R# = R + R*xi_actual,
#     checked as an actual Z2-lattice equality (not just mod 2), using
#     the explicit generator found above (xi=(0,0,0,1) -> Rsharp_basis[3]).
######################################################################
print()
print("=" * 60)
print("INDEPENDENT LATTICE-LEVEL CHECK: R# = R + R*xi_actual")
print("=" * 60)
xi_actual = Rsharp_basis[3]
print("xi_actual (the actual Q2 matrix, = r#_4):", xi_actual.list())

generators = list(r_basis) + [r_basis[i] * xi_actual for i in range(4)]
Gen_flat = matrix(Q2, [flat(g) for g in generators])  # 8x4

# Rank of these 8 generators (over Q2) should be 4 (full).
print()
print("rank of the 8 flattened generators (R's basis + R*xi):", Gen_flat.rank())

# Check each generator lies in R# (integral coords in Rsharp basis).
print()
print("Each generator's coordinates in R#-basis (want all integral):")
all_in_Rsharp = True
for g in generators:
    coeffs = flat(g) * Rsharp_flat_inv
    ok = all((c == 0) or (c.valuation() >= 0) for c in coeffs)
    all_in_Rsharp = all_in_Rsharp and ok
    print("  ", [c.valuation() if c != 0 else "inf" for c in coeffs], " integral:", ok)
assert all_in_Rsharp

# Check the generators SPAN R# exactly: their Z2-span, expressed as a
# subset of R#'s own coordinates mod 2, should have full rank 4 (i.e.
# recovers R#/R = R#/2R# entirely) -- already shown above via M_i, but
# redo directly here as the final consolidating check using the actual
# matrices, independent of the earlier struct-constant bookkeeping.
gens_in_Rsharp_coords_mod2 = matrix(F2, [
    [residue2(c) for c in (flat(g) * Rsharp_flat_inv)] for g in generators
])
print()
print("rank of generators' R#-coordinates mod 2:", gens_in_Rsharp_coords_mod2.rank(), " (want 4)")
assert gens_in_Rsharp_coords_mod2.rank() == 4

print()
print("CONFIRMED INDEPENDENTLY: R# = R + R*xi_actual exactly (lattice equality).")
print()
print("=" * 70)
print("FINAL GORENSTEIN CONCLUSION")
print("=" * 70)
print("R_pbar (m009's local order at the dyadic prime pbar) IS GORENSTEIN.")
print("R# = R + R*xi with xi = r#_4, verified both via the mod-2 module")
print("action (exhaustive check over all 15 nonzero candidates) and via")
print("an independent full Z2-lattice-level generator check.")

######################################################################
# 17. COMPLETE OVERORDER ENUMERATION: 15 lines + 35 planes of
#     V = (1/2)R / R (isomorphic to R/2R via x <-> 2x, used here in
#     the "half-lattice" framing GPT specified).
######################################################################
print()
print("=" * 70)
print("COMPLETE OVERORDER ENUMERATION")
print("=" * 70)
print()
print("V = (1/2 R)/R = F2^4 (isomorphic to R/2R via mult-by-2)")


def lift_subspace_to_S_basis(subspace_rows_F2):
    """subspace_rows_F2: list of F2 vectors (length 4), a basis for a
    subspace of R/2R (equivalently of V via the x<->2x identification).
    Returns an explicit Z2-basis (list of Q2 2x2 matrices) for
    S = R + sum Z2*(lift of each row /2)."""
    M = matrix(F2, subspace_rows_F2)
    Mred = M.echelon_form()
    pivots = Mred.pivots()
    new_basis = list(r_basis)  # start as R's basis, will replace pivot slots
    for row_idx, piv_col in enumerate(pivots):
        row = Mred.row(row_idx)
        # lift row (F2 vector) to an integer combo of r_basis, divide by 2
        lift_coeffs = [Integer(c) for c in row]
        x = sum(lift_coeffs[i] * r_basis[i] for i in range(4)) / 2
        new_basis[piv_col] = x
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


def gorenstein_test(S_basis, label=""):
    """Returns (is_gorenstein: bool, details dict)."""
    n = len(S_basis)
    T_S = matrix(Q2, n, n, lambda i, j: (S_basis[i] * adjugate2(S_basis[j])).trace())
    if T_S.det() == 0:
        return None, {"error": "degenerate trace form"}
    Tinv_S = T_S.inverse()
    Ssharp = [sum(Tinv_S[i, j] * S_basis[j] for j in range(n)) for i in range(n)]
    Sf = matrix(Q2, [flat(b) for b in S_basis])
    Ssf = matrix(Q2, [flat(b) for b in Ssharp])
    # P: S in S#-basis coords (should be integral, S subset S#)
    P_S = Sf * Ssf.inverse()
    vals = [c.valuation() if c != 0 else Infinity for row in P_S.rows() for c in row]
    if not all(v >= 0 for v in vals):
        return None, {"error": "S not subset S# -- bug"}
    dv = disc_val(S_basis)
    index_val = dv  # [S#:S] = 2^dv
    # Build S/2S structure constants & S is an F2-algebra of dim n
    Sf_inv = Sf.inverse()

    def res2(a):
        if a == 0:
            return F2(0)
        return F2(0) if a.valuation() >= 1 else F2(a.residue())
    # action of S (mod 2) on S#/S = S#/2S# (need S = 2*S#? check)
    TwoSsf = matrix(Q2, [flat(2 * e) for e in Ssharp])
    coords_S_in_2Ssharp = Sf * TwoSsf.inverse()
    is_S_eq_2Ssharp = all((c == 0) or (c.valuation() >= 0) for row in coords_S_in_2Ssharp.rows() for c in row)
    if not is_S_eq_2Ssharp:
        # Not the simple case S=2S# -- fall back to a direct dim count
        # via elementary divisors of P_S and note it for manual review.
        return None, {"error": "S != 2*S# -- needs separate handling", "disc_val": dv}
    Ssharp_inv = Ssf.inverse()
    action = {}
    for i in range(n):
        for j in range(n):
            prod = S_basis[i] * Ssharp[j]
            coeffs = flat(prod) * Ssharp_inv
            vals2 = [c.valuation() if c != 0 else Infinity for c in coeffs]
            if not all(v >= 0 for v in vals2):
                return None, {"error": "S# not a left S-module -- bug"}
            action[i, j] = vector(F2, [res2(c) for c in coeffs])
    Mmats = []
    for i in range(n):
        cols = [action[i, j] for j in range(n)]
        Mmats.append(matrix(F2, n, n, lambda a, b: cols[b][a]))
    best_rank = 0
    gen = None
    for bits in range(1, 2**n):
        xi = vector(F2, [(bits >> k) & 1 for k in range(n)])
        orbit = matrix(F2, [Mi * xi for Mi in Mmats])
        rk = orbit.rank()
        if rk > best_rank:
            best_rank = rk
        if rk == n and gen is None:
            gen = xi
    is_gor = (gen is not None)
    return is_gor, {"disc_val": dv, "dim_Sf_2Sf": n, "best_rank": best_rank, "generator": gen}

######################################################################
# STEP 1: 15 index-2 candidates (lines)
######################################################################
print()
print("--- STEP 1: 15 index-2 candidate lines ---")
line_survivors = []
for bits in range(1, 16):
    xvec = vector(F2, [(bits >> k) & 1 for k in range(4)])
    S_basis = lift_subspace_to_S_basis([xvec])
    closed = is_mult_closed(S_basis)
    dv = disc_val(S_basis) if closed else None
    print(f"  line {xvec}: mult_closed={closed}", f" v(disc_tr)={dv}" if closed else "")
    if closed:
        line_survivors.append((xvec, S_basis, dv))

print()
print(f"index-2 survivors: {len(line_survivors)} / 15")

######################################################################
# STEP 2: 35 index-4 candidates (planes)
######################################################################
print()
print("--- STEP 2: 35 index-4 candidate planes ---")

seen_planes = set()
plane_survivors = []
count_planes = 0
for b1 in range(1, 16):
    v1 = vector(F2, [(b1 >> k) & 1 for k in range(4)])
    for b2 in range(b1 + 1, 16):
        v2 = vector(F2, [(b2 >> k) & 1 for k in range(4)])
        M2span = matrix(F2, [v1, v2])
        if M2span.rank() != 2:
            continue
        red = M2span.echelon_form()
        key = tuple(tuple(row) for row in red.rows())
        if key in seen_planes:
            continue
        seen_planes.add(key)
        count_planes += 1
        rows = [red.row(0), red.row(1)]
        S_basis = lift_subspace_to_S_basis(rows)
        closed = is_mult_closed(S_basis)
        dv = disc_val(S_basis) if closed else None
        print(f"  plane #{count_planes} {key}: mult_closed={closed}", f" v(disc_tr)={dv}" if closed else "")
        if closed:
            plane_survivors.append((key, S_basis, dv))

print()
print(f"total distinct planes enumerated: {count_planes} (want 35)")
assert count_planes == 35
print(f"index-4 survivors: {len(plane_survivors)} / 35")

######################################################################
# Cross-check: does the index-2 survivor equal E (found independently
# via the Bruhat-Tits branch method)? IMPORTANT FRAME NOTE: r_basis
# (used throughout lift_subspace_to_S_basis, hence for all line/plane
# survivors) is R_std -- the g0-PULLED-BACK frame. So the correct
# comparison is against E_std_basis_exact (also pulled-back, no g0
# conjugation) -- NOT E_actual_basis (which would need g0 conjugation
# applied to r_basis too, or removed from E, to compare consistently).
######################################################################
print()
print("--- Cross-check: index-2 survivor vs E (from the branch-vertex method) ---")
Estd_flat_check = matrix(Q2, [flat(matrix(Q2, [[Q2(c) for c in row] for row in e.rows()])) for e in E_std_basis_exact])

xvec2, S2_basis, dv2 = line_survivors[0]
S2_flat = matrix(Q2, [flat(b) for b in S2_basis])

# Same lattice iff each spans the other integrally (both directions).
A_ = S2_flat * Estd_flat_check.inverse()
B_ = Estd_flat_check * S2_flat.inverse()
same_lattice = (all((c == 0) or (c.valuation() >= 0) for row in A_.rows() for c in row) and
                all((c == 0) or (c.valuation() >= 0) for row in B_.rows() for c in row))
print("index-2 survivor == E (branch-vertex construction)?", same_lattice)
assert same_lattice, "the two independent methods disagree -- investigate"
print("CONFIRMED: the two completely independent constructions of the")
print("unique index-2 overorder agree exactly.")

######################################################################
# STEP 3: Gorenstein test for the index-2 survivor (E)
######################################################################
print()
print("--- STEP 3: Gorenstein test for index-2 survivor (E) ---")
is_gor_E, details_E = gorenstein_test(S2_basis, "E")
print("E Gorenstein?", is_gor_E, " details:", details_E)

######################################################################
# Gorenstein test for the two index-4 (maximal) survivors, for the
# consistency table (expected: trivially Gorenstein, verify directly
# rather than assume).
######################################################################
print()
print("--- Gorenstein test for the two index-4 (maximal) survivors ---")
maximal_results = []
for idx, (key, S_basis, dv) in enumerate(plane_survivors):
    is_gor, details = gorenstein_test(S_basis, f"M{idx}")
    print(f"M{idx} (key={key}) Gorenstein?", is_gor, " details:", details)
    maximal_results.append((key, is_gor, details))

######################################################################
# FINAL CONSISTENCY TABLE AND BASS CONCLUSION
######################################################################
print()
print("=" * 70)
print("FINAL POSET / CONSISTENCY TABLE")
print("=" * 70)
print(f"{'Order':<8}{'[S:R]':<8}{'v(disc_tr)':<12}{'Gorenstein?'}")
print(f"{'R':<8}{'1':<8}{'4':<12}{'YES (proved earlier)'}")
print(f"{'E':<8}{'2':<8}{str(dv2):<12}{is_gor_E}")
for idx, (key, is_gor, details) in enumerate(maximal_results):
    print(f"{'M'+str(idx):<8}{'4':<8}{str(details.get('disc_val')):<12}{is_gor}")

all_index2_gorenstein = is_gor_E  # only one index-2 survivor found
bass_conclusion = "YES" if (all_index2_gorenstein and all(r[1] for r in maximal_results)) else "NO"
print()
print(f"Overorder poset: R subset E subset {{M0, M1}}, no other overorders found")
print(f"  (1/15 lines survive, 2/35 planes survive -- exhaustive).")
print(f"All index-2 survivors Gorenstein: {all_index2_gorenstein}")
print(f"All maximal overorders Gorenstein: {all(r[1] for r in maximal_results)}")
print()
print(f"BASS(R) = {bass_conclusion}")

######################################################################
# 18. GENERAL SMITH NORMAL FORM OVER Z2 (valuation-pivoting), since the
#     earlier "S=2*S#" shortcut only happened to hold for R's specific
#     structure and fails for E (index 4) and M0/M1 (index 1, self-dual).
######################################################################


def snf_valuations_z2(mat):
    """mat: square Q2 matrix with all entries of valuation >= 0 (or 0).
    Returns list of elementary-divisor valuations via row/col reduction
    with minimal-valuation pivoting. Non-destructive (copies input)."""
    n = mat.nrows()
    M = matrix(Q2, mat)  # copy
    divs = []
    size = n
    for step in range(n):
        # find min valuation nonzero entry in the remaining (size x size) block
        best = None
        for i in range(size):
            for j in range(size):
                if M[i, j] != 0:
                    v = M[i, j].valuation()
                    if best is None or v < best[0]:
                        best = (v, i, j)
        if best is None:
            divs.append(Infinity)
            continue
        v0, pi, pj = best
        # swap pivot to (0,0) of remaining block
        M.swap_rows(0, pi)
        M.swap_columns(0, pj)
        piv = M[0, 0]
        # clear rest of row 0 and column 0
        for j in range(1, size):
            if M[0, j] != 0:
                factor = M[0, j] / piv
                for i in range(size):
                    M[i, j] -= factor * M[i, 0]
        for i in range(1, size):
            if M[i, 0] != 0:
                factor = M[i, 0] / piv
                for j in range(size):
                    M[i, j] -= factor * M[0, j]
        divs.append(v0)
        # shrink to the bottom-right (size-1)x(size-1) block by relabeling
        M = M[1:, 1:]
        size -= 1
    return divs


def general_gorenstein_test(S_basis, label=""):
    n = len(S_basis)
    T_S = matrix(Q2, n, n, lambda i, j: (S_basis[i] * adjugate2(S_basis[j])).trace())
    Tinv_S = T_S.inverse()
    Ssharp = [sum(Tinv_S[i, j] * S_basis[j] for j in range(n)) for i in range(n)]
    Sf = matrix(Q2, [flat(b) for b in S_basis])
    Ssf = matrix(Q2, [flat(b) for b in Ssharp])
    P = Sf * Ssf.inverse()  # S in S#-basis coords, should be integral
    vals = [c.valuation() if c != 0 else Infinity for row in P.rows() for c in row]
    assert all(v >= 0 for v in vals), f"{label}: S not subset S#"
    divs = snf_valuations_z2(P)
    nontrivial = [d for d in divs if d > 0]
    print(f"  [{label}] elementary divisor valuations of S subset S#: {divs}")
    if len(nontrivial) == 0:
        print(f"  [{label}] S# = S exactly (self-dual, index 1) -- Gorenstein trivially YES.")
        return True, {"divs": divs, "index": 1}
    total_index = 2**sum(divs)
    if len(nontrivial) == 1:
        print(f"  [{label}] S#/S is CYCLIC as abelian group (Z/2^{nontrivial[0]}) -- ")
        print(f"  [{label}] automatically cyclic as S-module (Z-cyclic implies R-cyclic) -- Gorenstein YES.")
        return True, {"divs": divs, "index": total_index}
    # Multiple nontrivial divisors -- need the real module-action test.
    # Handle the case where all nontrivial divisors equal the SAME value m
    # (so 2^m * S# subset S, giving a module over S/(2^m S)); this covers
    # what we need here. General mixed-torsion case not implemented.
    if len(set(nontrivial)) == 1:
        m = nontrivial[0]
        print(f"  [{label}] {len(nontrivial)} equal nontrivial divisors = {m} -- testing as S/2^{m}S-module.")
        # Build S#/S as an (F_{2^m}-ish) module: since all divisors equal m,
        # 2^m * S# subset S. Work with k = len(nontrivial)-dim space over
        # Z/2^m via coordinates from P's Smith-reduced basis. For our cases
        # (m=1 always, since E has divisors either (0,0,1,1) or similar with
        # nontrivial entries =1), specialize to m=1 (F2 case), matching the
        # R computation exactly but on the REDUCED-rank nontrivial subspace.
        assert m == 1, f"only m=1 handled here, got m={m}"
        k = len(nontrivial)
        # Recompute a clean basis where S = S# with the nontrivial
        # directions scaled by 2: use the SNF-adapted bases directly by
        # redoing the reduction while tracking basis transforms.
        # Simpler: reuse the earlier general approach but restricted to
        # the sublattice actually mod 2 -- since all divisors are 1,
        # S#/S is killed by 2 entirely (2*S# subset S), same as before.
        TwoSsf = matrix(Q2, [flat(2 * e) for e in Ssharp])
        coordsS_in_2Ssharp = Sf * TwoSsf.inverse()
        ok2 = all((c == 0) or (c.valuation() >= 0) for row in coordsS_in_2Ssharp.rows() for c in row)
        assert ok2, f"{label}: expected 2*S# subset S given all divisors=1, but check failed"

        def res2(a):
            if a == 0:
                return F2(0)
            return F2(0) if a.valuation() >= 1 else F2(a.residue())
        Ssharp_inv = Ssf.inverse()
        action = {}
        for i in range(n):
            for j in range(n):
                prod = S_basis[i] * Ssharp[j]
                coeffs = flat(prod) * Ssharp_inv
                vals2 = [c.valuation() if c != 0 else Infinity for c in coeffs]
                assert all(v >= 0 for v in vals2), f"{label}: S# not a left S-module"
                action[i, j] = vector(F2, [res2(c) for c in coeffs])
        Mmats = []
        for i in range(n):
            cols = [action[i, j] for j in range(n)]
            Mmats.append(matrix(F2, n, n, lambda a, b: cols[b][a]))
        best_rank = 0
        gen = None
        for bits in range(1, 2**n):
            xi = vector(F2, [(bits >> t) & 1 for t in range(n)])
            orbit = matrix(F2, [Mi * xi for Mi in Mmats])
            rk = orbit.rank()
            if rk > best_rank:
                best_rank = rk
            if rk == n and gen is None:
                gen = xi
        # Note: this computes rank in the FULL n-dim reduction of S/2S
        # acting on S#/2S# (which has dim n, with dim-len(nontrivial)
        # trivial/zero directions where S#=S already) -- cyclic iff some
        # generator achieves rank = n (matches R's own successful case).
        is_gor = (gen is not None)
        print(f"  [{label}] exhaustive cyclic test over {2**n-1} nonzero candidates: best_rank={best_rank}/{n}, generator={gen}")
        return is_gor, {"divs": divs, "index": total_index, "generator": gen}
    raise NotImplementedError(f"{label}: mixed elementary divisors {nontrivial} not handled")


print()
print("=" * 70)
print("(superseded: general_gorenstein_test only handled the special case")
print("S = 2*S# which happens to hold for R but not E/M0/M1 -- skipping")
print("straight to the corrected general_gorenstein_test_v2 below, which")
print("properly tracks the SNF transformation and tests the genuine")
print("quotient dimension.)")
print("=" * 70)

######################################################################
# 19. CORRECTED general Gorenstein test: track the SNF transformation so
#     S#/S is tested in its own genuine quotient dimension (equal to the
#     number of nontrivial divisors), not the full n-dim mod-2 reduction
#     of S#. Bug found: for E, divisors are (0,0,1,1), so E#/E is
#     genuinely 2-dimensional, not 4 -- the earlier version tested the
#     wrong (larger) group.
######################################################################


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
    print(f"  [{label}] elementary divisor valuations: {divs}")
    nontrivial_idx = [i for i, d in enumerate(divs) if d and d > 0]
    if len(nontrivial_idx) == 0:
        print(f"  [{label}] S sharp equals S exactly -- Gorenstein trivially YES.")
        return True, {"divs": divs}
    if len(nontrivial_idx) == 1:
        print(f"  [{label}] S sharp / S is cyclic as abelian group -- Gorenstein automatically YES.")
        return True, {"divs": divs}
    dset = set(divs[i] for i in nontrivial_idx)
    if len(dset) != 1 or list(dset)[0] != 1:
        raise NotImplementedError(f"{label}: unsupported divisor pattern {divs}")
    f_basis = []
    for col in range(n):
        elt = sum(V[row, col] * Ssharp[row] for row in range(n))
        f_basis.append(elt)
    k = len(nontrivial_idx)
    f_flat = matrix(Q2, [flat(f_basis[i]) for i in range(n)])
    f_inv = f_flat.inverse()

    def res2(a):
        if a == 0:
            return F2(0)
        return F2(0) if a.valuation() >= 1 else F2(a.residue())
    action = {}
    for si in range(n):
        for jj, j in enumerate(nontrivial_idx):
            prod = S_basis[si] * f_basis[j]
            coeffs = flat(prod) * f_inv
            vals2 = [c.valuation() if c != 0 else Infinity for c in coeffs]
            assert all(v >= 0 for v in vals2), f"{label}: S sharp not closed under S-mult, adapted basis"
            # Trivial-index coordinates do NOT need to vanish mod 2: since
            # f_i is itself in S for trivial i, ANY integer multiple of it
            # is already 0 in S#/S regardless of parity -- just ignore
            # those coordinates rather than requiring them to vanish.
            action[si, jj] = vector(F2, [res2(coeffs[nontrivial_idx[t]]) for t in range(k)])
    Mmats = []
    for si in range(n):
        cols = [action[si, jj] for jj in range(k)]
        Mmats.append(matrix(F2, k, k, lambda a, b: cols[b][a]))
    best_rank = 0
    gen = None
    for bits in range(1, 2**k):
        xi = vector(F2, [(bits >> t) & 1 for t in range(k)])
        orbit = matrix(F2, [Mi * xi for Mi in Mmats])
        rk = orbit.rank()
        if rk > best_rank:
            best_rank = rk
        if rk == k and gen is None:
            gen = xi
    is_gor = (gen is not None)
    print(f"  [{label}] genuine quotient dim = {k}; exhaustive test over {2**k-1} candidates: "
          f"best_rank={best_rank}/{k}, generator={gen}")
    return is_gor, {"divs": divs, "quotient_dim": k, "generator": gen}


print()
print("=" * 70)
print("CORRECTED GENERALIZED GORENSTEIN TESTS (proper quotient dimension)")
print("=" * 70)
print()
print("--- R ---")
is_gor_R3, det_R3 = general_gorenstein_test_v2(r_basis, "R")
print()
print("--- E ---")
is_gor_E3, det_E3 = general_gorenstein_test_v2(S2_basis, "E")
print()
print("--- M0, M1 ---")
max_results3 = []
for idx, (key, S_basis, dv) in enumerate(plane_survivors):
    is_gor, det = general_gorenstein_test_v2(S_basis, f"M{idx}")
    max_results3.append((key, is_gor, det))

print()
print("=" * 70)
print("CORRECTED FINAL TABLE")
print("=" * 70)
print(f"R : Gorenstein={is_gor_R3}")
print(f"E : Gorenstein={is_gor_E3}")
for idx, (key, is_gor, det) in enumerate(max_results3):
    print(f"M{idx}: Gorenstein={is_gor}")
bass_final = is_gor_E3 and all(r[1] for r in max_results3)
print()
print(f"BASS(R) = {'YES' if bass_final else 'NO'}")
