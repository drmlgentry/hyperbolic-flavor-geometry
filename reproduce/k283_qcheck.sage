import snappy
from snappy.snap.find_field import ListOfApproximateAlgebraicNumbers
def alg(name, pairs):
    M = snappy.Manifold(name)
    def f(prec):
        H = M.polished_holonomy(bits_prec=prec); tr = lambda w: H(w).trace()
        v = []
        for g, h in pairs:
            v += [tr(g+g), tr(h+h), tr(g+g+h+h)]
        return v
    K, _, e = ListOfApproximateAlgebraicNumbers(f).find_field(400, 8, optimize=True)
    res = []
    for i in range(len(pairs)):
        s, t, u = e[3*i:3*i+3]
        Q = QuaternionAlgebra(K, s^2-4, s^2+t^2+u^2-s*t*u-4)
        fin, inf = Q.ramified_places(inf=True)
        res.append((pairs[i], sorted(P.norm() for P in fin), len(inf)))
    print(name, K.polynomial(), K.discriminant(), res, flush=True)
P = [('a','b'), ('a','ab'), ('b','aB'), ('ab','aab')]
for n in ['m003(-3,1)', 'm003(-2,3)', 'm006(2,3)', 'm339(-2,3)', 'm294(-4,1)', 'v3244(4,3)']:
    alg(n, P)
