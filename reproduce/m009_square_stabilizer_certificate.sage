# Exact structural and index certificate for the square-determinant
# endpoint-preserving m009 normalizer.
#
# Inputs:
# (1) reproduce/m009_endpoint_global_orders.sage;
# (2) Tanner Reese's presentation of PSL_2(O_{-7}), Topology Appl. 328
#     (2023), article 108443, arXiv:2206.01262, p. 12:
#       < A,B,U | B^2, (BA)^3, [A,U], (BAU^-1BU)^2 >,
#     with A=T_1, B=[[0,1],[-1,0]], U=T_w.
#
# The script first proves the simultaneous square-determinant stabilizer
# is the level-pbar Iwahori in the M0 frame. It then expresses the three
# certified Gamma_009^+ matrices as exact Bianchi-generator words and asks
# GAP for an exhaustive coset index. No candidate index is used as input.

load("reproduce/m009_endpoint_global_orders.sage")

from sage.all import ZZ, ceil, floor, libgap

print()
print("=" * 72)
print("SQUARE-DETERMINANT SIMULTANEOUS STABILIZER")
print("=" * 72)

# In the M0 frame, L0=O_K^2 and L1=t*O_K^2.
t = d0.inverse() * d1
t_expected = Matrix(K, [[pi_pbar, 0], [0, 1]])
assert t == t_expected
assert d1 == d0 * t

print("relative lattice matrix t=d0^-1*d1 =", t.list())
print("L1 in the M0 frame is pi_pbar*O_K e1 + O_K e2.")
print("For A=[[a,b],[c,d]] in SL_2(O_K),")
print("t^-1*A*t = [[a,b/pi_pbar],[pi_pbar*c,d]].")
print("Therefore A preserves L1 exactly iff b lies in pbar.")
print("Because det(A)=1, an order-stabilizing homothety A*L1=alpha*L1")
print("has alpha^2 a unit, hence alpha is a unit. Thus, modulo {+I,-I},")
print("N^{+,0}=d0*Gamma^0(pbar)*d0^-1,")
print("Gamma^0(pbar)={A in SL_2(O_K):A[0,1] in pbar}.")


def integral_zw_coeffs(z):
    """Return integral m,n with z=m+n*w; assert z is in O_K."""
    z = K(z)
    assert z.is_integral()
    pol = z.polynomial()
    m = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    n = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    assert m.denominator() == 1
    assert n.denominator() == 1
    return ZZ(m), ZZ(n)


def translation_matrix(z):
    return Matrix(K, [[1, K(z)], [0, 1]])


def projectively_equal(g, h):
    return g == h or g == -h


# Normalize all three certified projective generators to determinant one.
gamma_global_sl = {
    "a^2": kernel_reps["a^2"],
    "ab": kernel_reps["ab"],
    "ba^-1": (K(1) / 4) * kernel_reps["ba^-1"],
}

gamma_frame_sl = {}
print()
print("EXACT Gamma_009^+ GENERATORS IN THE M0 FRAME")
for name, g in gamma_global_sl.items():
    assert g.det() == 1
    assert same_lattice(conjugate_basis(g, M0_basis), M0_basis)
    assert same_lattice(conjugate_basis(g, M1_basis), M1_basis)
    assert same_lattice(conjugate_basis(g, R_basis), R_basis)
    gf = d0.inverse() * g * d0
    assert gf.det() == 1
    assert all(K(z).is_integral() for z in gf.list())
    assert gf[0, 1] in pbar
    gamma_frame_sl[name] = gf
    print(" ", name, "=", gf.list(), "  b in pbar =", gf[0, 1] in pbar)

expected_frame_matrices = {
    "a^2": Matrix(K, [[1 - 2*w, -1 - w], [w - 1, w]]),
    "ab": Matrix(K, [[2 - w, -1 - w], [-1, w]]),
    "ba^-1": Matrix(K, [[w, w - 1], [1 - w, 2 - w]]),
}
for name in gamma_frame_sl:
    assert projectively_equal(gamma_frame_sl[name],
                              expected_frame_matrices[name])

print()
print("=" * 72)
print("EXACT PSL_2(O_K) PRESENTATION AND MOD-pbar IWAHORI")
print("=" * 72)

TA = translation_matrix(1)
TB = Matrix(K, [[0, 1], [-1, 0]])
TU = translation_matrix(w)
I2 = Matrix.identity(K, 2)


def projective_identity(g):
    return g == I2 or g == -I2


# Exact matrix audit of all relators in the cited presentation.
presentation_relator_matrices = [
    TB**2,
    (TB * TA)**3,
    TA * TU * TA.inverse() * TU.inverse(),
    (TB * TA * TU.inverse() * TB * TU)**2,
]
assert all(projective_identity(r) for r in presentation_relator_matrices)

Fgap = libgap.FreeGroup(3)
fA, fB, fU = list(Fgap.GeneratorsOfGroup())
gap_relators = [
    fB**2,
    (fB*fA)**3,
    fA*fU*fA**-1*fU**-1,
    (fB*fA*fU**-1*fB*fU)**2,
]
T7 = Fgap / gap_relators
tA, tB, tU = list(T7.GeneratorsOfGroup())

# Mod pbar, w=1 in F_2. On e1,e2,e1+e2, A and U act as
# (2,3), while B acts as (1,2).
perm_A = libgap.PermList([1, 3, 2])
perm_B = libgap.PermList([2, 1, 3])
perm_U = libgap.PermList([1, 3, 2])
S3 = libgap.Group([perm_A, perm_B])
rho = libgap.GroupHomomorphismByImages(
    T7, S3, [tA, tB, tU], [perm_A, perm_B, perm_U])
assert bool(libgap.IsGroupHomomorphism(rho))
assert ZZ(libgap.Size(libgap.Image(rho))) == 6

# b=0 mod pbar is exactly the stabilizer of the column line e2.
point_stabilizer = libgap.Stabilizer(S3, 2)
Iwahori = libgap.PreImage(rho, point_stabilizer)
ambient_index = ZZ(libgap.Index(T7, Iwahori))
print("[PSL_2(O_K):Gamma^0(pbar)] =", ambient_index)
assert ambient_index == 3


def field_norm_abs(z):
    return abs(QQ(K(z).norm()))


def nearest_OK(z):
    """Exact nearest-lattice quotient for norm-Euclidean O_{-7}."""
    z = K(z)
    pol = z.polynomial()
    x0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    x1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    best = None
    best_norm = None
    for m in range(ZZ(floor(x0)) - 4, ZZ(ceil(x0)) + 5):
        for n in range(ZZ(floor(x1)) - 4, ZZ(ceil(x1)) + 5):
            q = K(m + n*w)
            nq = field_norm_abs(z - q)
            if best_norm is None or nq < best_norm:
                best = q
                best_norm = nq
    return best


def translation_word(z, gen_A, gen_U):
    m, n = integral_zw_coeffs(z)
    return gen_A**m * gen_U**n


def euclidean_word(M, gen_A, gen_B, gen_U):
    """Express M as a word in T_1,B,T_w and verify it exactly."""
    assert M.det() == 1
    assert all(K(z).is_integral() for z in M.list())
    original = M
    current = M
    left_matrix = I2
    left_word = gen_A**0
    steps = 0
    while current[1, 0] != 0:
        a = K(current[0, 0])
        c = K(current[1, 0])
        q = nearest_OK(a / c)
        remainder = a - q*c
        if remainder != 0:
            assert field_norm_abs(remainder) < field_norm_abs(c)
        step_matrix = TB * translation_matrix(-q)
        step_word = gen_B * translation_word(-q, gen_A, gen_U)
        current = step_matrix * current
        left_matrix = step_matrix * left_matrix
        left_word = step_word * left_word
        steps += 1
        assert steps < 30
    unit = K(current[0, 0])
    assert unit == 1 or unit == -1
    assert current[1, 1] == unit
    z = K(current[0, 1] / unit)
    integral_zw_coeffs(z)
    result_word = left_word**-1 * translation_word(z, gen_A, gen_U)
    result_matrix = left_matrix.inverse() * translation_matrix(z)
    assert projectively_equal(result_matrix, original)
    return result_word, steps


gamma_words = []
print()
print("EXACT EUCLIDEAN WORDS FOR Gamma_009^+")
for name in ["a^2", "ab", "ba^-1"]:
    word, steps = euclidean_word(gamma_frame_sl[name], tA, tB, tU)
    gamma_words.append(word)
    print(" ", name, "->", word, "(Euclidean steps =", steps, ")")

GammaPlus = libgap.Subgroup(T7, gamma_words)
assert bool(libgap.IsSubgroup(Iwahori, GammaPlus))

print()
print("=" * 72)
print("GAP COSET EXHAUSTION")
print("=" * 72)
square_index_gap = libgap.Index(Iwahori, GammaPlus)
assert str(square_index_gap) != "infinity"
square_index = ZZ(square_index_gap)
assert square_index > 0
print("[Gamma^0(pbar):Gamma_009^+] =", square_index)

# Test a simple explicit candidate for a nontrivial coset: T_{1-w}.
x_frame = translation_matrix(pi_pbar)
x_global = d0 * x_frame * d0.inverse()
x_word = tA * tU**-1
assert x_frame.det() == 1
assert x_frame[0, 1] in pbar
assert x_global == Matrix(K, [[1, pi_pbar**2], [0, 1]])
assert same_lattice(conjugate_basis(x_global, M0_basis), M0_basis)
assert same_lattice(conjugate_basis(x_global, M1_basis), M1_basis)
assert same_lattice(conjugate_basis(x_global, R_basis), R_basis)

# Exact coset enumeration, independent of how x was selected, decides its
# membership and how much of the ambient group it generates with GammaPlus.
GammaPlusWithX = libgap.Subgroup(T7, gamma_words + [x_word])
index_extended_over_gamma = ZZ(libgap.Index(GammaPlusWithX, GammaPlus))
index_ambient_over_extended = ZZ(libgap.Index(Iwahori, GammaPlusWithX))
assert index_extended_over_gamma * index_ambient_over_extended == square_index
print("explicit candidate x in M0 frame = T_(1-w) =", x_frame.list())
print("explicit candidate x in global frame =", x_global.list())
print("[<Gamma_009^+,x>:Gamma_009^+] =", index_extended_over_gamma)
print("[Gamma^0(pbar):<Gamma_009^+,x>] =", index_ambient_over_extended)
print("x outside Gamma_009^+ =", index_extended_over_gamma > 1)

full_index = 2 * square_index
print()
print("=" * 72)
print("CERTIFIED CONCLUSION OF A SUCCESSFUL RUN")
print("=" * 72)
print("N^{+,0} = d0*Gamma^0(pbar)*d0^-1 exactly.")
print("[N^{+,0}:Gamma_009^+] =", square_index)
print("Using the separately certified determinant image of order 2:")
print("[N_K^+(R):Gamma_009^+] =", full_index)
