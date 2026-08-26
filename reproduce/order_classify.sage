import snappy
from sage.all import ComplexField, algdep, QQ

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
CCf = ComplexField(300)

Pw = K.ideal(w)
P1w = K.ideal(1 - w)


def exact_K_element(numval, label):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        print(f"  WARNING: {label} does not fit degree<=2 (got {dep})")
        return None
    if dep.degree() == 1:
        val = -dep[0] / dep[1]
        return K(val)
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
    if best_err > 1e-50:
        print(f"  WARNING: {label} best root match has error {best_err}")
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
        a, b, c, d = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
        new_b, new_c = beta * b, c / beta
        ea = exact_K_element(a, f"{wd}[0,0]")
        eb = exact_K_element(new_b, f"{wd}[0,1]")
        ec = exact_K_element(new_c, f"{wd}[1,0]")
        ed = exact_K_element(d, f"{wd}[1,1]")
        exact_mats[wd] = Matrix(K, [[ea, eb], [ec, ed]])
    return exact_mats


def adjugate(m2x2):
    a, b, c, d = m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]
    return Matrix(K, [[d, -b], [-c, a]])


def reduced_trace_pairing(e1, e2):
    # Trd(e1 * conjugate(e2)) for elements of M_2(K) as a quaternion algebra
    return (e1 * adjugate(e2)).trace()


for manifold_name in ['m009', 'm010']:
    print(f"\n{'='*60}\n{manifold_name}\n{'='*60}")
    mats = get_conjugated_exact_matrices(manifold_name)
    for wd, m in mats.items():
        print(f"  {wd} = {list(m)}")

    I2 = Matrix(K, [[1, 0], [0, 1]])
    gens = [I2, mats['aa'], mats['bb'], mats['ab'], mats['ba']]
    labels = ['I', 'aa', 'bb', 'ab', 'ba']

    # Check K-rank of the span (as vectors in K^4)
    coord = lambda m: vector(K, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])
    V = Matrix(K, [coord(g) for g in gens])
    print(f"\n{manifold_name}: rank of 5x4 coordinate matrix over K: {V.rank()}")

    # Use the first 4 K-linearly-independent generators to compute the
    # reduced discriminant via the trace-pairing Gram determinant --
    # a conjugation-invariant quantity, computed directly over K
    # (works fine even with fractional/non-O_K-integral entries).
    basis = []
    for g in gens:
        test = basis + [g]
        Vtest = Matrix(K, [coord(b) for b in test])
        if Vtest.rank() == len(test):
            basis.append(g)
        if len(basis) == 4:
            break
    print(f"{manifold_name}: using {len(basis)} generators as a K-basis for the span")

    Gram = Matrix(K, 4, 4, lambda i, j: reduced_trace_pairing(basis[i], basis[j]))
    print(f"{manifold_name}: Gram (trace-pairing) matrix:\n{Gram}")
    discR = Gram.det()
    print(f"{manifold_name}: disc(R) [as a K-element, up to squares] = {discR}")

    frac_ideal = K.ideal(discR)
    print(f"{manifold_name}: (disc(R)) as a fractional ideal = {frac_ideal}")
    vP = frac_ideal.valuation(Pw)
    vPbar = frac_ideal.valuation(P1w)
    print(f"{manifold_name}: v_P(disc R) = {vP},  v_Pbar(disc R) = {vPbar}")
