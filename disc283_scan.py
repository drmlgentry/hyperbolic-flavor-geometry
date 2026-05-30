# disc283_scan.py
# Find all cusped manifolds with cusp field disc=-283
# and test each for self-encoding mu_M(n0) = 283
# Run: sage /mnt/c/dev/framework/disc283_scan.py

import snappy, sys, os, json, time
from math import gcd

CHECKPOINT = "/mnt/c/dev/framework/disc283_checkpoint.json"
MAX        = 2000
TARGET_DISC = 283
SEP        = "=" * 65

def eis_norm(p, q): return p*p - p*q + q*q

def mu_search(longitude, n, search=150):
    """Min Eis norm over slopes giving H1=Z/n."""
    a, b = int(longitude[0]), int(longitude[1])
    best, best_s = float('inf'), None
    for q in range(-search, search+1):
        num = n + a*q
        if b == 0 or num % b != 0: continue
        p = num // b
        if gcd(abs(p), abs(q)) != 1: continue
        en = eis_norm(p, q)
        if 0 < en < best:
            best, best_s = en, (p, q)
    return best, best_s

def verify_filling(name, slope, n):
    try:
        N = snappy.Manifold(name)
        N.dehn_fill(slope)
        if N.homology().order() != n: return 0.0, False
        vol = float(N.volume())
        return vol, vol > 0
    except:
        return 0.0, False

def get_disc(M, coeff_bound=2000):
    """Return abs(disc) of cusp poly if clean, else None."""
    from sage.all import algdep
    import signal
    def _timeout(signum, frame): raise TimeoutError()
    try:
        tau = M.cusp_info('shape', bits_prec=200)[0]
        for deg in [2, 3, 4, 5]:
            signal.signal(signal.SIGALRM, _timeout)
            signal.alarm(10)
            try:
                p = algdep(tau, deg)
                signal.alarm(0)
                if abs(p(tau)) < 1e-25 and p.degree() == deg:
                    if max(abs(c) for c in p.coefficients()) < coeff_bound:
                        d = abs(int(p.discriminant()))
                        return d, str(p), int(deg)
            except:
                signal.alarm(0)
    except: pass
    return None, None, None

def save(state):
    with open(CHECKPOINT, 'w') as f:
        json.dump(state, f, indent=2)

# ── Load checkpoint ────────────────────────────────────────────────
if os.path.exists(CHECKPOINT):
    with open(CHECKPOINT) as f:
        state = json.load(f)
    start       = state['last_count']
    disc283     = state['disc283']
    self_enc    = state['self_enc']
    print(f"Resuming from {start} | {len(disc283)} disc=283 found | "
          f"{len(self_enc)} self-encoding")
else:
    start    = 0
    disc283  = []   # all manifolds with disc=283
    self_enc = []   # those that also self-encode
    print("Starting fresh")

print(SEP)
print(f"  disc=283 scan  |  max={MAX}  |  target disc={TARGET_DISC}")
print(f"  Start: {time.strftime('%Y-%m-%d  %H:%M:%S')}")
print(SEP)
print(f"  {'TYPE':<12} | {'NAME':<8} | {'n0':<5} | {'SLOPE':<12} | {'VOL':<10} | POLY")
print(f"  {'-'*12}-+-{'-'*8}-+-{'-'*5}-+-{'-'*12}-+-{'-'*10}-+---------")
sys.stdout.flush()

scan_start = time.time()

# ── Main loop ──────────────────────────────────────────────────────
for count, M in enumerate(snappy.OrientableCuspedCensus()):
    if count >= MAX: break
    if count < start: continue
    if M.num_cusps() != 1: continue

    try:
        d, poly_str, deg = get_disc(M)
        if d is None or d != TARGET_DISC: continue

        # Found a disc=283 manifold
        name = str(M.name())
        long = M.homological_longitude()
        long_list = [int(long[0]), int(long[1])]
        disc283.append([name, int(d), poly_str, int(deg), long_list])
        print(f"  {'DISC=283':<12} | {name:<8} | {'--':<5} | {'--':<12} | "
              f"{'--':<10} | {poly_str}")
        sys.stdout.flush()

        # Test self-encoding
        for n in range(1, 80):
            mu_val, sl = mu_search(long_list, n)
            if mu_val != TARGET_DISC or sl is None: continue
            vol, ok = verify_filling(name, sl, n)
            if not ok: continue
            rec = [name, int(d), int(n), poly_str, int(deg),
                   [int(sl[0]), int(sl[1])], round(vol, 6)]
            self_enc.append(rec)
            print(f"  {'SELF-ENC':<12} | {name:<8} | {n:<5} | "
                  f"{str(sl):<12} | {vol:<10.5f} | {poly_str}")
            sys.stdout.flush()
            break

    except: pass

    # ── Progress + checkpoint every 10 ────────────────────────────
    if count % 10 == 0 and count > start:
        elapsed   = time.time() - scan_start
        done      = count - start
        remaining = MAX - count
        rate      = done / elapsed if elapsed > 0 else 1
        eta       = int(remaining / rate / 60)
        pct       = int(100 * count / MAX)
        print(f"  {'---':<12} | {count:>5}/{MAX}  {pct:>3}%  | "
              f"disc283={len(disc283)}  self_enc={len(self_enc)}  | "
              f"ETA ~{eta}m  | {rate*60:.1f}/min")
        sys.stdout.flush()
        save({'last_count': int(count), 'disc283': disc283,
              'self_enc': self_enc})

# ── Final ──────────────────────────────────────────────────────────
save({'last_count': int(MAX), 'disc283': disc283, 'self_enc': self_enc})

elapsed_total = time.time() - scan_start
print()
print(SEP)
print(f"  COMPLETE  |  {MAX} manifolds  |  "
      f"{int(elapsed_total//60)}m {int(elapsed_total%60)}s")
print(SEP)
print(f"\n  Manifolds with cusp field disc=283: {len(disc283)}")
for r in disc283:
    print(f"    {r[0]:<8}  long={r[4]}  poly={r[2]}")

print(f"\n  Self-encoding (verified): {len(self_enc)}")
for r in self_enc:
    print(f"    {r[0]:<8}  n={r[2]:<3}  slope={r[5]}  vol={r[6]}")
    print(f"             poly: {r[3]}")
print(SEP)
sys.exit(0)
