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
    return (e1 * adjugate(e2)).trace()


def coord(m):
    return vector(K, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


for manifold_name in ['m009', 'm010']:
    print(f"\n{'='*60}\n{manifold_name}\n{'='*60}")
    mats = get_conjugated_exact_matrices(manifold_name)
    I2 = Matrix(K, [[1, 0], [0, 1]])
    gens4 = [mats['aa'], mats['bb'], mats['ab'], mats['ba']]

    # Build the full generating set: I, the 4 generators, and ALL pairwise
    # products (both orders, since matrix mult is non-commutative) --
    # exact symbolic multiplication over K, no re-recognition needed.
    all_mats = [I2] + gens4
    for m1 in gens4:
        for m2 in gens4:
            all_mats.append(m1 * m2)

    print(f"{manifold_name}: {len(all_mats)} generating matrices "
          f"(I + 4 generators + 16 pairwise products)")

    # Find a common denominator: scale by 2 (already established as the
    # worst denominator for the un-multiplied generators; verify this
    # covers the products too by checking after scaling).
    scale = 2
    scaled_vecs = []
    for m in all_mats:
        v = scale * coord(m)
        if not all(e in OK for e in v):
            print(f"  WARNING: an entry needs a denominator beyond {scale}: {v}")
        scaled_vecs.append(v)

    # Build the O_K-module spanned by the scaled (now integral) vectors,
    # via Hermite Normal Form over O_K (valid: O_K is norm-Euclidean for
    # d=-7, and has class number 1, confirmed earlier this session).
    A = Matrix(OK, scaled_vecs)
    print(f"{manifold_name}: {A.nrows()}x{A.ncols()} integral matrix built, computing HNF...")
    H = A.hermite_form()
    print(f"{manifold_name}: Hermite normal form:\n{H}")

    # Extract the 4 nonzero rows as the minimal O_K-basis of the SCALED
    # lattice (2 * true order R), then unscale.
    basis_scaled = [H[i] for i in range(H.nrows()) if not H[i].is_zero()]
    print(f"{manifold_name}: {len(basis_scaled)} nonzero HNF rows (expect 4)")

    if len(basis_scaled) != 4:
        print(f"{manifold_name}: UNEXPECTED rank, skipping discriminant computation")
        continue

    basis_R = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]

    Gram = Matrix(K, 4, 4, lambda i, j: reduced_trace_pairing(basis_R[i], basis_R[j]))
    discR = Gram.det()
    frac_ideal = K.ideal(discR)
    vP = frac_ideal.valuation(Pw)
    vPbar = frac_ideal.valuation(P1w)
    print(f"{manifold_name}: ROUND 1 disc(R) = {discR},  v_P={vP}, v_Pbar={vPbar}")

    # ROUND 2: verify closure actually converged. Multiply the round-1
    # basis by itself (all pairwise products, both orders) and by the
    # original 4 generators, then re-run HNF. If the discriminant is
    # unchanged, round 1 had already converged.
    round2_mats = list(basis_R)
    for m1 in basis_R:
        for m2 in basis_R + gens4:
            round2_mats.append(m1 * m2)
    print(f"{manifold_name}: round 2 -- {len(round2_mats)} generating matrices")

    scaled_vecs2 = []
    for m in round2_mats:
        v = scale * coord(m)
        if not all(e in OK for e in v):
            print(f"  WARNING (round 2): entry needs denominator beyond {scale}: {v}")
        scaled_vecs2.append(v)
    A2 = Matrix(OK, scaled_vecs2)
    H2 = A2.hermite_form()
    basis_scaled2 = [H2[i] for i in range(H2.nrows()) if not H2[i].is_zero()]
    print(f"{manifold_name}: round 2 -- {len(basis_scaled2)} nonzero HNF rows")

    if len(basis_scaled2) == 4:
        basis_R2 = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled2]
        Gram2 = Matrix(K, 4, 4, lambda i, j: reduced_trace_pairing(basis_R2[i], basis_R2[j]))
        discR2 = Gram2.det()
        frac_ideal2 = K.ideal(discR2)
        vP2 = frac_ideal2.valuation(Pw)
        vPbar2 = frac_ideal2.valuation(P1w)
        print(f"{manifold_name}: ROUND 2 disc(R) = {discR2},  v_P={vP2}, v_Pbar={vPbar2}")
        print(f"{manifold_name}: CONVERGED? {(vP, vPbar) == (vP2, vPbar2)}")
    else:
        print(f"{manifold_name}: round 2 gave unexpected rank {len(basis_scaled2)}")
