# Scoping computation for the strong-approximation globalization
# argument: is pbar the ONLY bad (non-maximal) prime for R globally?
#
# This decides how big the "check det N(R_q) at every bad finite q"
# program actually is. If disc_tr(R) factors as EXACTLY pbar^4 (matching
# the already-certified local valuation at pbar, with no other prime
# factors), then at every OTHER finite prime q, R_q is maximal and
# pi=1-w is a LOCAL UNIT there (its valuation is 0 away from pbar,pbar's
# conjugate p) -- and the determinant image of the normalizer of a
# maximal order in M2(K_q) is known to contain all local units, so the
# admissibility condition [pi]_q in det N(R_q) is automatic at every
# such place, with nothing further to check there. That would make the
# "check every bad prime" step in the strong-approximation argument
# trivial/vacuous outside pbar, and the whole criterion would reduce to
# bookkeeping at pbar alone (already consistent by construction of the
# local coset). If instead OTHER primes divide the discriminant, the
# fuller multi-prime local analysis is a real, separate undertaking
# (each such prime would need its own BT-tree/local order classification,
# same scale of work as everything done for pbar this session) and is
# explicitly NOT attempted in this script -- scoping only.

import snappy
from sage.all import ComplexField, algdep, QQ, PolynomialRing, Matrix, vector

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


print("Recomputing m009 GLOBAL order basis (exact, over K)...")
mats009 = get_conjugated_exact_matrices('m009')
R_BASIS = build_order_basis(mats009)
print("R_BASIS recovered, 4 elements.")


def adjugate_K(m2x2):
    a_, b_, c_, d_ = m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]
    return Matrix(K, [[d_, -b_], [-c_, a_]])


print()
print("=" * 70)
print("Global reduced-trace Gram matrix and discriminant of R")
print("=" * 70)
T = Matrix(K, 4, 4, lambda i, j: (R_BASIS[i] * adjugate_K(R_BASIS[j])).trace())
print("T (Gram matrix over K):")
for row in T.rows():
    print("  ", [str(c) for c in row])

detT = T.det()
print()
print("det(T) =", detT)
print("det(T) is in O_K:", detT.is_integral())

disc_ideal = K.ideal(detT)
print()
print("Ideal (det T) =", disc_ideal)
fact = disc_ideal.factor()
print("Factorization:", fact)

pbar_id = K.ideal(1 - w)
p_id = K.ideal(w)
print()
print("pbar = (1-w):", pbar_id, " norm:", pbar_id.norm())
print("p    = (w):  ", p_id, " norm:", p_id.norm())

print()
print("=" * 70)
print("SCOPING RESULT")
print("=" * 70)
primes_involved = [P for P, e in fact]
only_pbar = (len(primes_involved) == 1 and primes_involved[0] == pbar_id)
print("Primes appearing in disc_tr(R):", primes_involved)
print("Is pbar the ONLY bad prime globally?:", only_pbar)
if only_pbar:
    e = dict(fact)[pbar_id]
    print(f"  v_pbar(disc_tr R) = {e}  (matches local valuation 4 found earlier: {e == 4})")
    print()
    print("CONCLUSION: R is maximal at EVERY finite prime other than pbar.")
    print("At every such prime q, pi=1-w is a local UNIT (valuation 0),")
    print("automatically admissible for a maximal order's normalizer")
    print("determinant image there. The strong-approximation criterion's")
    print("'check every bad prime' step is therefore VACUOUS outside pbar")
    print("-- there is nothing else to check. This is a real correction to")
    print("the earlier 'no candidate globalizes' framing: that tested only")
    print("finitely many representatives of the local residue coset at")
    print("pbar, not the full (infinite) local coset, so it was NOT valid")
    print("evidence against globalization. Modulo the class-number-1")
    print("bookkeeping at pbar itself (consistent by construction), strong")
    print("approximation for SL2/K plausibly DOES produce a global")
    print("branch-swapping element -- existence, not necessarily a simple")
    print("explicit matrix like the 9 tried.")
else:
    print("CONCLUSION: other primes ALSO divide disc_tr(R) -- the full")
    print("multi-prime local analysis (BT-tree/local order classification")
    print("at each of these, same scale of work as done for pbar) would be")
    print("needed before the strong-approximation criterion can be checked.")
    print("NOT attempted in this script -- reporting scope only.")
