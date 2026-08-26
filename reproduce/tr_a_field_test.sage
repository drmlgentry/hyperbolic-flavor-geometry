import snappy
from sage.all import ComplexField, algdep, QQ

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
CCf = ComplexField(300)

for name in ['m009', 'm010']:
    print("=" * 70)
    print(name)
    print("=" * 70)
    M = snappy.Manifold(name)
    G = M.polished_holonomy(bits_prec=300)

    for word in ['a', 'b']:
        mat = G.SL2C(word)
        tr = CCf(mat[0, 0] + mat[1, 1])
        det = CCf(mat[0, 0] * mat[1, 1] - mat[0, 1] * mat[1, 0])
        print(f"\n{word}: tr = {tr}")
        print(f"{word}: det = {det}  (expect 1 for SL2)")

        dep = algdep(tr, 8, known_bits=200)
        print(f"{word}: algdep(tr, degree<=8) = {dep}")
        print(f"{word}: degree found = {dep.degree()}")

        # Is tr already in K (degree <= 2, and does it satisfy K's poly
        # or a linear combination)? Try recognizing directly in K.
        in_K = None
        if dep.degree() <= 2:
            Rk = PolynomialRing(K, 'y')
            y = Rk.gen()
            poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
            roots = poly_in_K.roots()
            if roots:
                best, best_err = None, None
                for r, mult in roots:
                    err = abs(CCf(r) - tr)
                    if best_err is None or err < best_err:
                        best_err, best = err, r
                if best_err < 1e-50:
                    in_K = best
        if in_K is not None:
            print(f"{word}: tr IS in K = Q(sqrt(-7)), value = {in_K}")
        else:
            print(f"{word}: tr is NOT recognized in K (degree {dep.degree()} "
                  f"over Q, K has degree 2) -- lives in a larger field")
