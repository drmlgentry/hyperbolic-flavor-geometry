import snappy
from math import gcd
import sys

def eis_norm(p,q): return p*p - p*q + q*q

def is_eis_norm(n, s=None):
    if s is None: s = int(n**0.5) + 3
    return any(eis_norm(p,q)==n for p in range(-s,s+1) for q in range(-s,s+1))

def mu_search(longitude, n, search=120):
    a, b = int(longitude[0]), int(longitude[1])
    best, best_s = float('inf'), None
    for q in range(-search, search+1):
        num = n + a*q
        if b == 0 or num % b != 0: continue
        p = num // b
        if gcd(abs(p),abs(q)) != 1: continue
        en = eis_norm(p,q)
        if 0 < en < best:
            best, best_s = en, (p,q)
    return best, best_s

def get_cusp_poly(M, prec=300, coeff_bound=1000):
    from sage.all import algdep
    try:
        tau = M.cusp_info('shape', bits_prec=prec)[0]
        for deg in [2, 3, 4]:
            p = algdep(tau, deg)
            if abs(p(tau)) < 1e-30 and p.degree() == deg:
                if max(abs(c) for c in p.coefficients()) < coeff_bound:
                    return p
    except: pass
    return None

print("Census mu-scan v2 (clean poly filter, deg 2-4)")
print("=" * 55)
self_enc = []

for count, M in enumerate(snappy.OrientableCuspedCensus()):
    if count >= 500: break
    if M.num_cusps() != 1: continue
    try:
        poly = get_cusp_poly(M)
        if poly is None: continue
        d = abs(int(poly.discriminant()))
        deg = poly.degree()
        if not is_eis_norm(d): continue
        long = M.homological_longitude()
        for n in range(1, 60):
            mu_val, sl = mu_search(long, n)
            if mu_val == d:
                rec = (M.name(), d, n, str(poly), deg)
                self_enc.append(rec)
                print(f"SELF-ENC: {M.name()}, disc={d}, n={n}, deg={deg}, poly={poly}")
                sys.stdout.flush()
                break
    except: pass
    if count % 50 == 0:
        print(f"  {count} scanned, {len(self_enc)} found")
        sys.stdout.flush()

print(f"\nDone: {len(self_enc)} self-encoding manifolds in 500")
for r in self_enc: print(r)
