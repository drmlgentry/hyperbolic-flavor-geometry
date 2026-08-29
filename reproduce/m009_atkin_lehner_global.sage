# Global Atkin-Lehner check for m009's order R at pbar=(1-w).
#
# IMPORTANT CORRECTION BEFORE RUNNING ANYTHING: the "covolume division"
# shortcut relayed alongside this task (covol(N(E)) := (3/2)*covol(T7),
# then vol(m009)/covol(N(E)) "=2.000...") is CIRCULAR, not a check. Both
# numbers are defined via the SAME assumption (that the local
# Atkin-Lehner element globalizes with index exactly 2), so dividing
# them recovers 2 by algebra alone, independent of any fact about the
# real manifold or order -- it cannot distinguish "globalizes" from
# "doesn't". The only way to actually settle this is what this script
# does: search for a genuine global lift of the local AL element and
# test it against the REAL global order R (not a volume heuristic).
#
# What this script actually establishes:
#   (a) two independently-computed real numbers -- vol(m009) via
#       SnapPy directly, and covol(T7) via Sage's own Dedekind zeta
#       function (Humbert's formula) -- compared against the CLASSICAL,
#       independently-justifiable index formula [T7:Gamma0(pbar)] =
#       N(pbar)+1 = 3 (orbit-stabilizer for PSL2(O_K/pbar) acting on
#       P^1(O_K/pbar), a standard fact, not something borrowed on
#       faith).
#   (b) an explicit search for natural candidate global lifts of the
#       local Atkin-Lehner matrix, tested by DIRECT exact O_K
#       arithmetic against the real global order R (R_BASIS), each
#       cross-checked locally at pbar to confirm it genuinely swaps the
#       two branch vertices (not just normalizes E trivially, e.g. by
#       already lying in the known local unit group).
# A "no natural candidate found" result is reported honestly as just
# that -- NOT as a proof that no global lift exists (that would need a
# real non-existence argument, out of scope here).

import snappy
from sage.all import (ComplexField, algdep, QQ, Qp, PolynomialRing, matrix,
                       Infinity, identity_matrix, Matrix, vector, GF, Integer,
                       RealField, pi)

######################################################################
# 0. GLOBAL FIELD / R_BASIS (identical construction to prior scripts)
######################################################################
x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
CCf = ComplexField(300)

pi_pbar = 1 - w  # generator of pbar=(1-w), N(pi_pbar)=2
print("N(1-w) =", (1 - w).norm(), " (should be 2, confirming pi_pbar generates pbar)")
assert (1 - w).norm() == 2


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


print("Recomputing m009 GLOBAL order basis (exact, over K, not localized)...")
mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)
print("R_BASIS (global) recovered, 4 elements, exact over K.")

######################################################################
# STEP A: INDEPENDENT volume/covolume cross-check (real data, not
#          copied from the relayed message).
######################################################################
print()
print("=" * 70)
print("STEP A: independent covolume check (vol(m009) vs 3*covol(T7))")
print("=" * 70)

M009 = snappy.Manifold('m009')
vol_m009 = M009.volume()
print("vol(m009) via SnapPy, direct:", vol_m009)

RF = RealField(200)
try:
    zeta_K_2 = K.zeta_function()(2)
except Exception as ex:
    zeta_K_2 = None
    print("K.zeta_function() unavailable:", ex)

DK = K.discriminant()
print("Disc(K) =", DK)
if zeta_K_2 is not None:
    covol_T7 = (RF(abs(DK))**RF(1.5)) * RF(zeta_K_2) / (4 * RF(pi)**2)
    print("covol(T7) via Sage's own Dedekind zeta (Humbert's formula):", covol_T7)
    print("3*covol(T7):", 3 * covol_T7)
    print("vol(m009) / covol(T7):", RF(vol_m009) / covol_T7,
          " (expect ~3, i.e. [T7:Gamma0(pbar)]=N(pbar)+1=3, orbit-stabilizer")
    print("  on P^1(O_K/pbar), a standard/classical fact -- NOT the")
    print("  circular AL-halving claim, which is NOT tested by this ratio)")
else:
    print("Could not independently compute covol(T7) this way -- skipping ratio check.")

######################################################################
# STEP B: pbar embedding + BT-tree machinery (needed to check LOCAL
#          behavior of any candidate global lift -- does it swap the
#          branch vertices M0,M1, or does it fix the seed / do nothing
#          interesting locally?).
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
print()
print("Local branch recovered (matches prior scripts): g0, g1 identified.")
print("g0 =", g0.list(), " (dist from Id:", dist, ") -- NOTE: g0 is an exact")
print("RATIONAL matrix (product of NEIGHBOR_STEPS), hence also a genuine")
print("K-rational (in fact Q-rational) global matrix, not merely a 2-adic")
print("limit object -- this is what makes a properly-framed global")
print("candidate constructible below.")

step_index = None
for idx, h in enumerate(NEIGHBOR_STEPS):
    if same_vertex(g0 * h, g1):
        step_index = idx
        break
assert step_index is not None
h_connect = NEIGHBOR_STEPS[step_index]
print("connecting step h_connect =", h_connect.list())

######################################################################
# STEP C0 (CORRECTED CANDIDATE): the naive candidates alpha1-5 below
# guess a matrix shape directly in R_BASIS's own (arbitrary, Hermite-
# form-derived) coordinate frame, with NO reason to match the local
# swap behavior in that frame. The mathematically correct construction
# instead: take the LOCAL swap element w_local (already independently
# verified, in m009_normalizer_certificate.sage, to normalize BOTH
# E_std and R_std in the g0-pulled-back "standard" frame), and conjugate
# it back through g0 -- which is itself an exact RATIONAL matrix, so
# this conjugation is honest global (K-rational) arithmetic, not a
# frame guess. By construction this candidate is GUARANTEED to swap the
# branch vertices locally (no need to re-check that part); the only
# open question is whether it ALSO preserves R_BASIS globally.
######################################################################
w_local = Matrix(QQ, [[0, 2], [1, 0]])  # verified locally in the prior script
alpha_correct = g0 * w_local * g0.inverse()  # exact QQ matrix -> exact K matrix
alpha_correct_K = Matrix(K, [[K(c) for c in row] for row in alpha_correct.rows()])
print()
print("Correctly-framed candidate alpha = g0 * w_local * g0^-1 =")
print(" ", alpha_correct.list())

######################################################################
# STEP C0b: w_local is only ONE of FOUR local elements that swap the
# branch (the nontrivial coset of the order-8 <TB,TC,W> image, verified
# in m009_normalizer_certificate.sage -- the "unit" subgroup <uB,uC> has
# order 4, and w_local*<uB,uC> is its nontrivial coset). Testing only
# w_local's global pullback would be too narrow a search -- all four
# swap-coset representatives are also exact QQ-rational, so test all of
# them, each conjugated honestly through the real g0.
######################################################################
uB_local = Matrix(QQ, [[1, 2], [0, 1]])
uC_local = Matrix(QQ, [[1, 0], [1, 1]])
swap_coset_local = {
    "w": w_local,
    "uB*w": uB_local * w_local,
    "uC*w": uC_local * w_local,
    "uB*uC*w": uB_local * uC_local * w_local,
}
swap_coset_global = {}
for name, m in swap_coset_local.items():
    a = g0 * m * g0.inverse()
    swap_coset_global[f"g0*({name})*g0^-1"] = Matrix(K, [[K(c) for c in row] for row in a.rows()])

######################################################################
# STEP C: candidate global Atkin-Lehner lifts -- exact O_K test against
#          the REAL global order R_BASIS.
######################################################################
print()
print("=" * 70)
print("STEP C: search natural candidate global AL lifts")
print("=" * 70)

Rf_K = matrix(K, [coord(r) for r in R_BASIS])
Rf_K_inv = Rf_K.inverse()


def normalizes_R_global(alpha):
    """Exact O_K check: alpha * R_BASIS[i] * alpha^-1 must be an
    O_K-linear combination of R_BASIS, for every i."""
    ainv = alpha.inverse()
    for r in R_BASIS:
        conj = alpha * r * ainv
        coeffs = coord(conj) * Rf_K_inv
        for c in coeffs:
            if not K(c).is_integral():
                return False, coeffs
    return True, None


def local_swaps_branch(alpha):
    """Does alpha (embedded at pbar) send g0 to the OTHER branch vertex
    (genuine swap), or fix g0 (trivial/local-unit-group behavior)?"""
    a2 = matrix_to_Q2(alpha, root_pbar)
    # Compare against both branch vertices directly (g0, g1 already Q2
    # via g_to_Q2 since they're exact rational matrices):
    swaps = same_vertex(a2 * g_to_Q2(g0), g_to_Q2(g1))
    fixes = same_vertex(a2 * g_to_Q2(g0), g_to_Q2(g0))
    return swaps, fixes


candidates = dict(swap_coset_global)
candidates.update({
    "alpha1 = [[0,1],[pi,0]] (naive, wrong frame, expect fail)": Matrix(K, [[0, 1], [pi_pbar, 0]]),
    "alpha2 = [[0,pi],[1,0]] (naive, wrong frame, expect fail)": Matrix(K, [[0, pi_pbar], [1, 0]]),
    "alpha3 = [[0,-1],[pi,0]] (naive, wrong frame, expect fail)": Matrix(K, [[0, -1], [pi_pbar, 0]]),
    "alpha4 = [[0,pi],[-1,0]] (naive, wrong frame, expect fail)": Matrix(K, [[0, pi_pbar], [-1, 0]]),
    "alpha5 = [[1,0],[0,pi]] (naive diag, sanity-negative-expected)": Matrix(K, [[1, 0], [0, pi_pbar]]),
})

found_any = False
for label, alpha in candidates.items():
    ok, coeffs = normalizes_R_global(alpha)
    print(f"  {label}:")
    print(f"    normalizes R GLOBALLY (exact O_K check): {ok}")
    if ok:
        swaps, fixes = local_swaps_branch(alpha)
        print(f"    locally swaps branch vertices (genuine AL role): {swaps}")
        print(f"    locally FIXES seed vertex (trivial/already-local-unit): {fixes}")
        if swaps:
            found_any = True
            print(f"    ==> CANDIDATE GLOBAL LIFT FOUND: {label}")
            print(f"        alpha = {alpha.list()}")

print()
print("=" * 70)
print("RESULT")
print("=" * 70)
if found_any:
    print("At least one natural candidate GLOBALLY normalizes R AND locally")
    print("swaps the branch vertices at pbar -- a genuine candidate global")
    print("Atkin-Lehner lift. NOTE: this does NOT by itself prove the")
    print("element is outside Gamma_009 (that would need an independent")
    print("check against the holonomy group's actual presentation/generators,")
    print("not attempted here) -- report as 'candidate found', not as a")
    print("fully closed proof of [N(R):Gamma_009]=2.")
else:
    print("NO natural candidate (among alpha1-alpha5) both normalizes R")
    print("globally AND swaps the branch locally. This is EVIDENCE against")
    print("globalization, NOT a proof of non-existence -- a real non-")
    print("existence argument (e.g. via the relevant class field / adelic")
    print("double-coset structure) would be needed to close this rigorously,")
    print("and has not been attempted here.")
