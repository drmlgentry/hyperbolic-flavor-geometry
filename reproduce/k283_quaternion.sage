# Run inside Sage (WSL conda env `sage`):  sage k283_quaternion.sage
# For each census manifold flagged K_283 by k283_census.py, with g = a^2, h = b^2 in Gamma^(2):
#   kM  and  A0 = ( tr^2 g - 4 , tr[g,h] - 2 )_kM          (Maclachlan-Reid Thm 3.6.2)
#   tr[g,h] - 2 = s^2 + t^2 + u^2 - s t u - 4,  s = tr a^2, t = tr b^2, u = tr a^2 b^2
#   integral traces: tr^2(w) in kM is integral for w = generators, pairs, triples (MR Lemma 8.5.2)
# Arithmetic (one complex place, integral traces, A0 ramified at all real places) and the same
# (kM, ramification of A0) for all  =>  one commensurability class (MR Thm 8.4.1).
import csv
import itertools
import snappy
from snappy.snap.find_field import ListOfApproximateAlgebraicNumbers

PREC, DEG = 400, 8
rows = [r for r in csv.DictReader(open('k283_census.csv')) if r['k283'] in ('t', 'conj_t')]


def numbers(M):
    def f(prec):
        H = M.polished_holonomy(bits_prec=prec)
        gens = H.generators()
        tr = lambda w: H(w).trace()
        a, b = gens[0], gens[1]
        out = [tr(a + a), tr(b + b), tr(a + a + b + b)]
        words = [''.join(c) for k in (1, 2, 3) for c in itertools.combinations(gens, k)]
        return out + [tr(w) ** 2 for w in words]
    return ListOfApproximateAlgebraicNumbers(f)


out = []
for r in rows:
    M = snappy.Manifold(r['name'])
    K, _, e = numbers(M).find_field(PREC, DEG, optimize=True)
    s, t, u = e[0], e[1], e[2]
    Q = QuaternionAlgebra(K, s ** 2 - 4, s ** 2 + t ** 2 + u ** 2 - s * t * u - 4)
    fin, inf = Q.ramified_places(inf=True)
    integral = all(x.is_integral() for x in e[3:])
    rec = (r['name'], r['volume'], str(K.polynomial()), K.discriminant(), K.signature(),
           integral, sorted(P.norm() for P in fin), len(inf))
    out.append(rec)
    print(rec, flush=True)

sig = {o[2:] for o in [(x[0], x[1], x[2], x[4], x[5], tuple(x[6]), x[7]) for x in out]}
print('\nmanifolds:', len(out))
print('distinct (field, signature, integral traces, finite ramification, #real places ramified):')
for s_ in sig:
    print('  ', s_)
