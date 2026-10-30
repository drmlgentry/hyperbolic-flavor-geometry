"""
K_283 base rate over the SnapPy closed orientable census (Hodgson-Weeks, 11031 manifolds).

K_283 = Q(t), t^4 - t - 1 = 0  (disc -283, signature (2,1), Galois closure S4).
This is the invariant trace field of the Meyerhoff manifold m003(-2,3) = m004(5,1).

For each manifold M with holonomy generators g_1..g_n (quad-double, ~63 digits):
  kM = Q( tr(g_i)^2,  tr g_i tr g_j tr(g_i g_j),  tr g_i tr g_j tr g_k tr(g_i g_j g_k) )
(Maclachlan-Reid, Lemma 3.5.9).

Test A (K_283 membership, the base-rate question):
  kM = K_283  iff  every generator z satisfies an integer relation
  c0 z + c1 + c2 t + c3 t^2 + c4 t^3 = 0, c0 != 0, for ONE fixed complex embedding t
  (t or conj t, same for all generators). Since K_283 has no subfields besides Q
  and kM is never real, containment forces equality.

Test B (field identification, for context): algdep a random integer combination
  of the generators up to degree MAXDEG, verify all generators lie in the resulting
  field, and record polredabs(poly) and the field discriminant.

Requires only SnapPy (bundled PARI); no Sage.
"""
import csv
import random
import sys
import time

import snappy
from cypari import pari

pari.set_real_precision(80)
ACC = 55            # digits of trusted accuracy passed to lindep/algdep
HMAX = 10 ** 8      # max relation height accepted (spurious relations are ~10^20+)
MAXDEG = 8
K283 = pari('x^4 - x - 1')
roots = pari('polroots(x^4 - x - 1)')
roots = [roots[i] for i in range(4)]
T = [r for r in roots if float(r.imag()) > 0][0]
EMB = {'t': T, 'conj_t': T.conj()}


def tr(m):
    return m[0][0] + m[1][1]


def mul(a, b):
    return [[a[0][0] * b[0][0] + a[0][1] * b[1][0], a[0][0] * b[0][1] + a[0][1] * b[1][1]],
            [a[1][0] * b[0][0] + a[1][1] * b[1][0], a[1][0] * b[0][1] + a[1][1] * b[1][1]]]


def holonomy(M):
    G = M.fundamental_group()
    mats = []
    for g in G.generators():
        A = G.SL2C(g)
        mats.append([[A[i, j].gen for j in range(2)] for i in range(2)])
    return mats


def itf_gens(mats):
    n = len(mats)
    t = [tr(m) for m in mats]
    out = [ti ** 2 for ti in t]
    for i in range(n):
        for j in range(i + 1, n):
            out.append(t[i] * t[j] * tr(mul(mats[i], mats[j])))
            for k in range(j + 1, n):
                out.append(t[i] * t[j] * t[k] * tr(mul(mul(mats[i], mats[j]), mats[k])))
    return out


def in_field(z, alpha, d):
    """Integer relation c0 z + sum c_i alpha^i = 0 with c0 != 0 and small height?"""
    if abs(z) < pari(10) ** (-ACC + 5):
        return True
    v = [z] + [alpha ** i for i in range(d)]
    rel = pari.lindep(v, ACC)
    if len(rel) == 0 or rel[0] == 0:
        return False
    if max(abs(int(c)) for c in rel) > HMAX:
        return False
    res = sum(rel[i] * v[i] for i in range(len(v)))
    return abs(res) < pari(10) ** (-ACC + 10)


def is_k283(gens):
    for name, t in EMB.items():
        if all(in_field(z, t, 4) for z in gens):
            return name
    return ''


def identify(gens, rng):
    nz = [z for z in gens if abs(z) > pari(10) ** (-40)]
    for _ in range(3):
        prim = sum(rng.randint(-3, 3) * z for z in nz) + nz[0]
        for d in range(2, MAXDEG + 1):
            p = pari.algdep(prim, d, ACC)
            if pari.poldegree(p) < 2 or not pari.polisirreducible(p):
                continue
            if max(abs(int(c)) for c in pari.Vec(p)) > HMAX:
                continue
            alpha, dp = prim, pari.deriv(p)
            for _ in range(8):  # Newton polish: polroots works at low default precision
                alpha = alpha - pari.subst(p, 'x', alpha) / pari.subst(dp, 'x', alpha)
            if abs(alpha - prim) > pari(10) ** (-ACC + 10):
                continue
            dd = int(pari.poldegree(p))
            if all(in_field(z, alpha, dd) for z in nz):
                red = pari.polredabs(p)
                return dd, str(red), int(pari.nfdisc(red))
            break
    return '', '', ''


def main():
    limit = int(sys.argv[1]) if len(sys.argv) > 1 else None
    census = snappy.OrientableClosedCensus
    n = len(census) if limit is None else limit
    rng = random.Random(283)
    t0 = time.time()
    with open('k283_census.csv', 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['index', 'name', 'volume', 'k283', 'deg', 'polredabs', 'disc'])
        for idx in range(n):
            M = snappy.ManifoldHP(census[idx])
            name = str(M)
            try:
                gens = itf_gens(holonomy(M))
                k = is_k283(gens)
                deg, red, disc = identify(gens, rng)
            except Exception as e:  # record and move on
                k, deg, red, disc = 'ERR', '', repr(e)[:80], ''
            w.writerow([idx, name, f'{float(M.volume()):.9f}', k, deg, red, disc])
            if idx % 500 == 0:
                f.flush()
                print(idx, name, k, deg, red, f'{time.time() - t0:.0f}s', flush=True)


if __name__ == '__main__':
    main()
