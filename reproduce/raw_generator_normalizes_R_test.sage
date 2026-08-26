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


def exact_K_element(numval, label, tol=1e-40):
    if abs(numval) < 1e-10:
        return K(0), 0.0
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        return None, None
    if dep.degree() == 1:
        val = -dep[0] / dep[1]
        return K(val), abs(CCf(K(val)) - numval)
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        return None, None
    best, best_err = None, None
    for r, mult in roots:
        err = abs(CCf(r) - numval)
        if best_err is None or err < best_err:
            best_err, best = err, r
    return best, best_err


def get_conjugated_exact_matrices(name):
    """Reproduce order_closure.sage's conjugation exactly, but ALSO return
    the raw (numeric, un-K-rationalized) matrices for the generators a,b
    under the SAME global conjugation D=diag(beta,1)."""
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
        ea, _ = exact_K_element(a_, f"{wd}[0,0]")
        eb, _ = exact_K_element(new_b, f"{wd}[0,1]")
        ec, _ = exact_K_element(new_c, f"{wd}[1,0]")
        ed, _ = exact_K_element(d_, f"{wd}[1,1]")
        exact_mats[wd] = Matrix(K, [[ea, eb], [ec, ed]])

    # Raw (numeric complex, NOT forced into K) matrices for a, b, under the
    # SAME D=diag(beta,1) conjugation used for the Gamma' generators.
    raw_numeric = {}
    for wd in ['a', 'b']:
        m = G.SL2C(wd)
        a_, b_, c_, d_ = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
        new_b, new_c = beta * b_, c_ / beta
        raw_numeric[wd] = Matrix(CCf, [[a_, new_b], [new_c, d_]])

    return exact_mats, raw_numeric


def adjugate(m2x2):
    a_, b_, c_, d_ = m2x2[0, 0], m2x2[0, 1], m2x2[1, 0], m2x2[1, 1]
    return Matrix(K, [[d_, -b_], [-c_, a_]])


def reduced_trace_pairing(e1, e2):
    return (e1 * adjugate(e2)).trace()


def coord(m):
    return vector(K, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


def coord_numeric(m):
    return vector(CCf, [m[0, 0], m[0, 1], m[1, 0], m[1, 1]])


def build_order_basis(mats):
    I2 = Matrix(K, [[1, 0], [0, 1]])
    gens4 = [mats['aa'], mats['bb'], mats['ab'], mats['ba']]
    all_mats = [I2] + gens4
    for m1 in gens4:
        for m2 in gens4:
            all_mats.append(m1 * m2)
    scale = 2
    scaled_vecs = [scale * coord(m) for m in all_mats]
    A = Matrix(OK, scaled_vecs)
    H = A.hermite_form()
    basis_scaled = [H[i] for i in range(H.nrows()) if not H[i].is_zero()]
    if len(basis_scaled) != 4:
        raise RuntimeError(f"unexpected basis rank {len(basis_scaled)}")
    basis_R = [(1 / K(scale)) * Matrix(K, 2, 2, list(v)) for v in basis_scaled]
    return basis_R


print("=" * 70)
print("m009 -- does the RAW generator a (tr(a) not in K) normalize R?")
print("=" * 70)

mats, raw_numeric = get_conjugated_exact_matrices('m009')
basis_R = build_order_basis(mats)

# Numeric versions of basis_R for solving the linear system.
basis_R_numeric = [Matrix(CCf, [[CCf(b[0, 0]), CCf(b[0, 1])],
                                 [CCf(b[1, 0]), CCf(b[1, 1])]])
                    for b in basis_R]
Bmat_numeric = Matrix(CCf, [coord_numeric(b) for b in basis_R_numeric]).transpose()

all_pass = True
for gname in ['a', 'b']:
    g = raw_numeric[gname]
    det_g = g[0, 0] * g[1, 1] - g[0, 1] * g[1, 0]
    print(f"\n{gname}: det = {det_g}  (expect 1, up to precision)")
    tr_g = g[0, 0] + g[1, 1]
    g_inv = tr_g * Matrix(CCf, [[1, 0], [0, 1]]) - g  # since det=1: g^-1 = tr(g)I - g

    for i, b in enumerate(basis_R_numeric):
        conjugated = g * b * g_inv
        target = coord_numeric(conjugated)
        try:
            sol = Bmat_numeric.solve_right(target)
        except Exception as e:
            print(f"  {gname} conjugates basis_R[{i}]: SOLVE FAILED ({e})")
            all_pass = False
            continue

        recognized = []
        errs = []
        ok = True
        for c in sol:
            val, err = exact_K_element(c, "coeff")
            if val is None or val not in OK:
                ok = False
                recognized.append(None)
                errs.append(None)
            else:
                recognized.append(val)
                errs.append(err)

        status = "OK (coeffs in O_K)" if ok else "FAIL (coeffs not in O_K)"
        if not ok:
            all_pass = False
        maxerr = max([e for e in errs if e is not None], default=None)
        print(f"  {gname} conjugates basis_R[{i}]: {status}"
              + (f"  coeffs={recognized}  max_recognition_err~{maxerr}"
                 if ok else f"  raw_solved_coeffs(numeric)={list(sol)}"))

print("\n" + "=" * 70)
if all_pass:
    print("RESULT: the RAW generators a AND b (neither K-rational) both")
    print("conjugate every basis_R element back into O_K-span(basis_R).")
    print("This directly confirms Gamma_009 = <a,b> normalizes R --")
    print("computationally, not just via the abstract normal-subgroup argument.")
else:
    print("RESULT: at least one (generator, basis element) pair FAILED.")
    print("The abstract Gamma'-normal argument does NOT computationally")
    print("confirm here as stated -- needs re-examination.")
print("=" * 70)
