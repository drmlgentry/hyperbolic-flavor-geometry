import snappy
from sage.all import QQ, PolynomialRing, NumberField, ComplexField, algdep

Rx = PolynomialRing(QQ, 'x')
x = Rx.gen()
K = NumberField(x**2 - x + 2, 'w')  # Q(sqrt(-7)), w=(1+sqrt(-7))/2
OK = K.ring_of_integers()

CCf = ComplexField(300)

for name in ['m009', 'm010']:
    M = snappy.Manifold(name)
    G = M.polished_holonomy(bits_prec=300)

    print(f"\n=== {name} ===")

    words = ['aa', 'bb', 'ab', 'ba']
    mats = []
    for w_str in words:
        m = G.SL2C(w_str)
        mats.append(m)
        print(f"tr({w_str}) = {m[0,0]+m[1,1]}")

    for w_str, m in zip(words, mats):
        for i in range(2):
            for j in range(2):
                entry = CCf(m[i, j])
                if abs(entry) > 1e-10:
                    p = algdep(entry, 4, known_bits=200)
                    print(f"  {w_str}[{i},{j}] minpoly: {p}")
