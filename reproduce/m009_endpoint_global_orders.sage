# Exact global maximal-overorder and endpoint-stabilizer certificate for m009.
#
# This script does NOT enumerate the full endpoint stabilizer and does
# NOT determine [N_K^+(R):Gamma_009^+].  A successful run certifies the
# global orders, their intersection, the trace-kernel description of R,
# and whether [-1] occurs globally through the explicit element J.

import snappy
from sage.all import (ComplexField, algdep, QQ, PolynomialRing, Matrix,
                      NumberField, vector, polygen)

x = polygen(QQ, 'x')
CC0 = ComplexField(300)
w_num = (1 + CC0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
CC = ComplexField(300)

pi_pbar = 1 - w
pbar = K.ideal(pi_pbar)
assert pi_pbar.norm() == 2
assert pbar.norm() == 2
assert K.class_number() == 1


def exact_K_element(numval, label):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        raise RuntimeError("%s failed degree<=2 recognition: %s" %
                           (label, dep))
    if dep.degree() == 1:
        return K(-dep[0] / dep[1])
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        raise RuntimeError("%s has no recognized root in K" % label)
    return min((r for r, mult in roots),
               key=lambda r: abs(CC(r) - numval))


def get_conjugated_exact_matrices(name):
    M = snappy.Manifold(name)
    G = M.polished_holonomy(bits_prec=300)
    words = ['aa', 'bb', 'ab', 'ba']
    raw = {word: G.SL2C(word) for word in words}
    beta = CC(raw['aa'][0, 1])
    ans = {}
    for word in words:
        m = raw[word]
        vals = [CC(m[0, 0]), beta * CC(m[0, 1]),
                CC(m[1, 0]) / beta, CC(m[1, 1])]
        exact = [exact_K_element(z, "%s[%s]" % (word, i))
                 for i, z in enumerate(vals)]
        ans[word] = Matrix(K, 2, 2, exact)
    return ans


def coord(m):
    return vector(K, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


def build_order_basis(mats):
    identity = Matrix(K, [[1, 0], [0, 1]])
    gens = [mats['aa'], mats['bb'], mats['ab'], mats['ba']]
    spanning = [identity] + gens
    spanning += [a * b for a in gens for b in gens]
    scale = K(2)
    rows = [scale * coord(m) for m in spanning]
    H = Matrix(OK, rows).hermite_form()
    basis_scaled = [H[i] for i in range(H.nrows())
                    if not H[i].is_zero()]
    assert len(basis_scaled) == 4
    return [(1 / scale) * Matrix(K, 2, 2, list(v))
            for v in basis_scaled]


mats = get_conjugated_exact_matrices('m009')
R_basis = build_order_basis(mats)

print("K =", K)
print("O_K =", OK)
print("pbar = (1-w), norm =", pbar.norm())
print("class number =", K.class_number())
print("Exact global R basis:")
for r in R_basis:
    print(" ", r.list())


def basis_matrix(basis):
    return Matrix(K, [coord(m) for m in basis])


def coordinates_in(basis_from, basis_to):
    return basis_matrix(basis_from) * basis_matrix(basis_to).inverse()


def integral_matrix(A):
    return all(K(c).is_integral() for c in A.list())


def lattice_contained(basis_small, basis_large):
    return integral_matrix(coordinates_in(basis_small, basis_large))


def same_lattice(basis_a, basis_b):
    return (lattice_contained(basis_a, basis_b) and
            lattice_contained(basis_b, basis_a))


def conjugate_basis(g, basis):
    gi = g.inverse()
    return [g * b * gi for b in basis]


E11 = Matrix(K, [[1, 0], [0, 0]])
E12 = Matrix(K, [[0, 1], [0, 0]])
E21 = Matrix(K, [[0, 0], [1, 0]])
E22 = Matrix(K, [[0, 0], [0, 1]])
Mstd = [E11, E12, E21, E22]

# At pbar the certified branch vertices are represented by diag(2,1)
# and diag(4,1).  Since 2=w(1-w), replace 2 by the globally supported
# uniformizer pi=1-w; its omitted factor w is a pbar-local unit.
d0 = Matrix(K, [[pi_pbar, 0], [0, 1]])
d1 = Matrix(K, [[pi_pbar**2, 0], [0, 1]])
M0_basis = conjugate_basis(d0, Mstd)
M1_basis = conjugate_basis(d1, Mstd)

print()
print("Candidate global M0 basis:")
for m in M0_basis:
    print(" ", m.list())
print("Candidate global M1 basis:")
for m in M1_basis:
    print(" ", m.list())

R_in_M0 = lattice_contained(R_basis, M0_basis)
R_in_M1 = lattice_contained(R_basis, M1_basis)
print()
print("R subset M0 globally (exact O_K lattice):", R_in_M0)
print("R subset M1 globally (exact O_K lattice):", R_in_M1)
assert R_in_M0
assert R_in_M1
assert not same_lattice(M0_basis, M1_basis)

# Each Mi is explicitly a conjugate of M2(O_K), hence maximal.  The
# prior local branch exhaustion gives exactly two maximal overorders at
# pbar, and the global discriminant scan makes R maximal elsewhere.
# Thus a successful containment check makes these the exhaustive two
# global maximal overorders containing R.

# From the diagonal conjugates, the intersection has upper-right entry
# in pi^2 O_K and lower-left entry in pi^-1 O_K.
E_basis = [E11, pi_pbar**2 * E12, (1 / pi_pbar) * E21, E22]
assert lattice_contained(E_basis, M0_basis)
assert lattice_contained(E_basis, M1_basis)
assert lattice_contained(R_basis, E_basis)

X_R_E = coordinates_in(R_basis, E_basis)
assert integral_matrix(X_R_E)
index_ideal = K.ideal(X_R_E.det())
index_norm = index_ideal.norm()

print()
print("Exact global E=M0 intersection M1 basis:")
for e in E_basis:
    print(" ", e.list())
print("R in E coordinate matrix:")
print(X_R_E)
print("Index ideal determinant:", index_ideal)
print("Norm of index ideal [E:R]:", index_norm)
assert index_norm == 2

traces_R_in_pbar = all(r.trace() in pbar for r in R_basis)
trace_E_surjective = any(e.trace() not in pbar for e in E_basis)
print("Every R-basis trace lies in pbar:", traces_R_in_pbar)
print("Trace E -> O_K/pbar is nonzero/surjective:", trace_E_surjective)
assert traces_R_in_pbar
assert trace_E_surjective
print("R = {x in E : tr(x) in pbar}, by containment and equal index 2.")

J_global = Matrix(K, [[-1, 0], [0, 1]])
J_fixes_M0 = same_lattice(conjugate_basis(J_global, M0_basis), M0_basis)
J_fixes_M1 = same_lattice(conjugate_basis(J_global, M1_basis), M1_basis)
J_normalizes_E = same_lattice(conjugate_basis(J_global, E_basis), E_basis)
J_normalizes_R = same_lattice(conjugate_basis(J_global, R_basis), R_basis)

print()
print("GLOBAL J CERTIFICATE:")
print("J fixes global M0 individually:", J_fixes_M0)
print("J fixes global M1 individually:", J_fixes_M1)
print("J normalizes global E:", J_normalizes_E)
print("J normalizes global R directly:", J_normalizes_R)
print("det(J) =", J_global.det())
print("det(J) is a square in K:", K(J_global.det()).is_square())
assert J_fixes_M0
assert J_fixes_M1
assert J_normalizes_E
assert J_normalizes_R
assert J_global.det() == -1
assert not K(-1).is_square()


def adjugate(m):
    return Matrix(K, [[m[1, 1], -m[0, 1]],
                      [-m[1, 0], m[0, 0]]])


A = mats['aa'] + Matrix.identity(K, 2)
B = mats['bb'] + Matrix.identity(K, 2)
BAinv_projective = B * adjugate(A)
kernel_reps = {
    "a^2": mats['aa'],
    "ab": mats['ab'],
    "ba^-1": BAinv_projective,
}

print()
print("DETERMINANT CLASSES OF Gamma_009^+ GENERATORS:")
for name, g in kernel_reps.items():
    detg = K(g.det())
    print(" ", name, "det =", detg, "square in K =", detg.is_square())
    assert detg.is_square()
assert BAinv_projective.det() == 16

print()
print("=" * 72)
print("CERTIFIED BY A SUCCESSFUL RUN")
print("=" * 72)
print("1. M0,M1 are the two exact GLOBAL maximal overorders of R.")
print("2. E=M0 cap M1 globally and [E:R]=2.")
print("3. R is the global trace-pbar kernel inside E.")
print("4. J fixes M0,M1 individually and normalizes R globally.")
print("5. [-1] occurs in delta(N_K^+(R)); it is not a square in K.")
print("6. Gamma_009^+ lies in ker(delta).")
print()
print("STILL NOT CERTIFIED HERE")
print("- the full determinant image delta(N_K^+(R))")
print("- exhaustion of N_K^+(R) or its square-determinant subgroup")
print("- either factor, or the product, in [N_K^+(R):Gamma_009^+]")
