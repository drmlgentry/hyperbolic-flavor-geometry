# census_mu_scan_v3.py — CHECKPOINTED version
# Saves progress every 10 manifolds to JSON
# Run: sage /mnt/c/dev/framework/census_mu_scan_v3.py

import snappy, sys, os, json, time
from math import gcd

CHECKPOINT = "/mnt/c/dev/framework/census_v3_checkpoint.json"
MAX = 1000

def eis_norm(p,q): return p*p - p*q + q*q

def is_eis_norm(n):
    s = int(n**0.5) + 3
    return any(eis_norm(p,q)==n
               for p in range(-s,s+1)
               for q in range(-s,s+1))

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

def get_cusp_poly(M, coeff_bound=1000):
    from sage.all import algdep
    import signal
    
    def timeout_handler(signum, frame):
        raise TimeoutError("algdep timeout")
    
    try:
        tau = M.cusp_info('shape', bits_prec=200)[0]  # reduced from 300
        for deg in [2,3,4]:
            signal.signal(signal.SIGALRM, timeout_handler)
            signal.alarm(8)  # 8 second timeout per degree
            try:
                p = algdep(tau, deg)
                signal.alarm(0)
                if abs(p(tau)) < 1e-25 and p.degree()==deg:
                    if max(abs(c) for c in p.coefficients()) < coeff_bound:
                        return p
            except TimeoutError:
                signal.alarm(0)
                continue
            except:
                signal.alarm(0)
                continue
    except: pass
    return None

# Load checkpoint
if os.path.exists(CHECKPOINT):
    with open(CHECKPOINT) as f:
        state = json.load(f)
    start = state['last_count']
    self_enc = state['self_enc']
    print(f"Resuming from count={start}, {len(self_enc)} found so far")
else:
    start = 0
    self_enc = []
    print("Starting fresh scan")

print(f"Census mu-scan v3 (checkpointed, deg 2-4, max={MAX})")
print("=" * 55)
print(f"Started: {time.strftime('%H:%M:%S')}")
sys.stdout.flush()

scan_start = time.time()

for count, M in enumerate(snappy.OrientableCuspedCensus()):
    if count >= MAX: break
    if count < start: continue  # skip already processed
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
                rec = [str(M.name()), int(d), int(n), str(poly), int(deg)]
                self_enc.append(rec)
                print(f"SELF-ENC: {M.name()}, disc={d}, n={n}, "
                      f"deg={deg}, poly={poly}")
                sys.stdout.flush()
                break
    except: pass

    if count % 10 == 0 and count > start:
        elapsed = time.time() - scan_start
        done = count - start
        remaining = MAX - count
        rate = done / elapsed  # manifolds per second
        eta_sec = remaining / rate if rate > 0 else 0
        eta_min = eta_sec / 60
        pct = 100 * count / MAX
        print(f"  [{time.strftime('%H:%M:%S')}] "
              f"{count}/{MAX} ({pct:.0f}%) | "
              f"found={len(self_enc)} | "
              f"ETA {eta_min:.0f} min | "
              f"rate={rate*60:.1f}/min")
        sys.stdout.flush()
        # Checkpoint
        state = {'last_count': int(count), 'self_enc': self_enc}
        with open(CHECKPOINT, 'w') as f:
            json.dump(state, f)

# Final save
state = {'last_count': int(MAX), 'self_enc': self_enc}
with open(CHECKPOINT, 'w') as f:
    json.dump(state, f)

print(f"\nDone: {len(self_enc)} self-encoding manifolds in {MAX}")
for r in self_enc:
    print(f"  {r[0]}: disc={r[1]}, n={r[2]}, deg={r[4]}, poly={r[3]}")
