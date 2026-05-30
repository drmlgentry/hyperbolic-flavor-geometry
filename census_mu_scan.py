import snappy
from math import gcd

def eis_norm(p,q): return p*p - p*q + q*q

def is_eis_norm(n, s=55):
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

print("Scanning census for self-encoding manifolds...")
import sys
self_enc = []
for count, M in enumerate(snappy.OrientableCuspedCensus()):
    if count >= 300: break
    if M.num_cusps() != 1: continue
    try:
        from sage.all import algdep
        long = M.homological_longitude()
        tau = M.cusp_info('shape', bits_prec=200)[0]
        for deg in [2,3,4]:
            poly = algdep(tau, deg)
            if abs(poly(tau)) < 1e-25 and poly.degree()==deg:
                d = abs(int(poly.discriminant()))
                if is_eis_norm(d, s=int(d**0.5)+5):
                    for n in range(1,60):
                        mu_val, sl = mu_search(long, n)
                        if mu_val == d:
                            self_enc.append((M.name(), d, n, str(poly)))
                            print(f"SELF-ENC: {M.name()}, disc={d}, n={n}, poly={poly}")
                            sys.stdout.flush()
                            break
                break
    except: pass
    if count % 50 == 0:
        print(f"  {count} scanned, {len(self_enc)} self-encoding found")
        sys.stdout.flush()

print(f"\nFinal: {len(self_enc)} self-encoding manifolds in first 300")
for r in self_enc: print(r)
