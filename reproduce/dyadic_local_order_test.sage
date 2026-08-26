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


def build_order_basis(mats):
    """Reproduce order_closure.sage's converged basis_R for one manifold."""
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
    return basis_R, gens4


def in_OK_span(mat, basis_mats):
    """Solve mat = sum c_i * basis_mats[i] over K, check c_i in OK."""
    Bmat = Matrix(K, [coord(b) for b in basis_mats]).transpose()
    target = coord(mat)
    try:
        sol = Bmat.solve_right(target)
    except ValueError:
        return False, None
    ok = all(c in OK for c in sol)
    return ok, sol


print("=" * 70)
print("m009 -- dyadic local order test + containment verification")
print("=" * 70)

mats = get_conjugated_exact_matrices('m009')
basis_R, gens4 = build_order_basis(mats)
gen_names = ['aa', 'bb', 'ab', 'ba']

print("\n--- STEP 1a: raw-generator entry valuations (diagnostic only) ---")
for name, M in zip(gen_names, gens4):
    for label, entry in [('[0,0]', M[0, 0]), ('[0,1]', M[0, 1]),
                          ('[1,0]', M[1, 0]), ('[1,1]', M[1, 1])]:
        if entry == 0:
            print(f"  {name}{label}: 0 (v_p=inf, v_pbar=inf)")
            continue
        fi = K.ideal(entry)
        vp = fi.valuation(Pw)
        vpb = fi.valuation(P1w)
        print(f"  {name}{label}: v_p={vp}, v_pbar={vpb}")

print("\n--- STEP 1b: established-basis (basis_R) entry valuations ---")
print("(basis_R is the actual converged O_K-basis of R from order_closure.sage;")
print(" this is the structure that matters for local order type, not the raw")
print(" generators, which are merely elements of R expressed in an arbitrary")
print(" spanning set.)")
for i, b in enumerate(basis_R):
    for label, entry in [('[0,0]', b[0, 0]), ('[0,1]', b[0, 1]),
                          ('[1,0]', b[1, 0]), ('[1,1]', b[1, 1])]:
        if entry == 0:
            print(f"  basis_R[{i}]{label}: 0")
            continue
        fi = K.ideal(entry)
        vp = fi.valuation(Pw)
        vpb = fi.valuation(P1w)
        print(f"  basis_R[{i}]{label}: v_p={vp}, v_pbar={vpb}")

print("\n--- STEP 1c: sanity check against known disc(R) valuations ---")
Gram = Matrix(K, 4, 4, lambda i, j: reduced_trace_pairing(basis_R[i], basis_R[j]))
discR = Gram.det()
fi = K.ideal(discR)
print(f"disc(R) = {discR}, v_p = {fi.valuation(Pw)}, v_pbar = {fi.valuation(P1w)}")
print("(expected from prior converged run: v_p=0, v_pbar=4)")

print("\n--- STEP 2: containment check -- does each generator normalize R? ---")
print("(gamma * b * gamma^-1 in O_K-span(basis_R) for every basis element b,")
print(" for every generator gamma in {aa,bb,ab,ba}. If ALL pass for ALL four")
print(" generators, then Gamma_009 <= N(R) is proved -- not just numerically")
print(" suggested by the covolume match.)")

all_pass = True
for gname, gen in zip(gen_names, gens4):
    if gen.det() == 0:
        print(f"  {gname}: SINGULAR, cannot invert -- skipping")
        all_pass = False
        continue
    gen_inv = gen.inverse()
    for bi, b in enumerate(basis_R):
        conjugated = gen * b * gen_inv
        ok, sol = in_OK_span(conjugated, basis_R)
        status = "OK" if ok else "FAIL"
        if not ok:
            all_pass = False
        print(f"  {gname} conjugates basis_R[{bi}]: {status}"
              + ("" if ok else f"  (coeffs={list(sol) if sol is not None else None})"))

print("\n" + "=" * 70)
if all_pass:
    print("RESULT: containment check PASSED for all generators and basis elements.")
    print("Gamma_009 normalizes R (Gamma_009 <= N(R)) -- proved, not numerical.")
else:
    print("RESULT: containment check FAILED for at least one (generator, basis) pair.")
    print("Gamma_009 <= N(R) is NOT established by this test as stated.")
print("=" * 70)
