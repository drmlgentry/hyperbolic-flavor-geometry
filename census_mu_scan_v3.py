# census_mu_scan_v3.py — CHECKPOINTED, VERIFIED, CLEAN OUTPUT
# Saves progress every 10 manifolds to JSON
# Run: sage /mnt/c/dev/framework/census_mu_scan_v3.py

import snappy, sys, os, json, time
from math import gcd

CHECKPOINT = "/mnt/c/dev/framework/census_v3_checkpoint.json"
MAX        = 1000
SEP        = "=" * 62

def eis_norm(p, q):
    return p*p - p*q + q*q

def is_eis_norm(n):
    s = int(n**0.5) + 3
    return any(eis_norm(p, q) == n
               for p in range(-s, s+1)
               for q in range(-s, s+1))

def mu_search(longitude, n, search=120):
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

def get_cusp_poly(M, coeff_bound=1000):
    from sage.all import algdep
    import signal
    def _timeout(signum, frame): raise TimeoutError()
    try:
        tau = M.cusp_info('shape', bits_prec=200)[0]
        for deg in [2, 3, 4]:
            signal.signal(signal.SIGALRM, _timeout)
            signal.alarm(8)
            try:
                p = algdep(tau, deg)
                signal.alarm(0)
                if abs(p(tau)) < 1e-25 and p.degree() == deg:
                    if max(abs(c) for c in p.coefficients()) < coeff_bound:
                        return p
            except:
                signal.alarm(0)
    except: pass
    return None

def verify_filling(name, slope, n):
    """Return (vol, True) if filling is hyperbolic with H1=Z/n, else (0, False)."""
    try:
        N = snappy.Manifold(name)
        N.dehn_fill(slope)
        if N.homology().order() != n: return 0.0, False
        vol = float(N.volume())
        return vol, vol > 0
    except:
        return 0.0, False

def save(state):
    with open(CHECKPOINT, 'w') as f:
        json.dump(state, f, indent=2)

def print_result(r):
    print(f"  {'FOUND':<6} | {r[0]:<8} | disc={r[1]:<5} | n={r[2]:<3} | "
          f"deg={r[4]} | slope={r[5]} | vol={r[6]:.5f}")
    print(f"         | poly: {r[3]}")
    sys.stdout.flush()

# ── Load or init checkpoint ────────────────────────────────────────
if os.path.exists(CHECKPOINT):
    with open(CHECKPOINT) as f:
        state = json.load(f)
    start    = state['last_count']
    self_enc = state['self_enc']
    print(f"Resuming from manifold {start}  ({len(self_enc)} found so far)")
else:
    start    = 0
    self_enc = []
    print("Starting fresh scan")

# ── Header ─────────────────────────────────────────────────────────
print(SEP)
print(f"  Census mu-scan v3   |  max={MAX}  |  checkpointed")
print(f"  Start: {time.strftime('%Y-%m-%d  %H:%M:%S')}")
print(SEP)
print(f"  {'STATUS':<6} | {'NAME':<8} | {'DISC':<9} | {'n':<4} | "
      f"{'DEG':<4} | SLOPE     | VOL")
print(f"  {'-'*6}-+-{'-'*8}-+-{'-'*9}-+-{'-'*4}-+-{'-'*4}-+-{'-'*9}-+-{'-'*10}")
sys.stdout.flush()

scan_start = time.time()

# ── Main loop ──────────────────────────────────────────────────────
for count, M in enumerate(snappy.OrientableCuspedCensus()):
    if count >= MAX: break
    if count < start: continue
    if M.num_cusps() != 1: continue

    try:
        poly = get_cusp_poly(M)
        if poly is None: continue
        d   = abs(int(poly.discriminant()))
        deg = int(poly.degree())
        if not is_eis_norm(d): continue

        long = M.homological_longitude()
        for n in range(1, 60):
            mu_val, sl = mu_search(long, n)
            if mu_val != d or sl is None: continue
            vol, ok = verify_filling(M.name(), sl, n)
            if not ok: continue
            rec = [str(M.name()), int(d), int(n), str(poly), deg,
                   list(sl), round(vol, 6)]
            self_enc.append(rec)
            print_result(rec)
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
        print(f"  {'---':<6} | {count:>4}/{MAX}  {pct:>3}%  | "
              f"found={len(self_enc)}  | "
              f"ETA ~{eta} min  | "
              f"{rate*60:.1f}/min")
        sys.stdout.flush()
        save({'last_count': int(count), 'self_enc': self_enc})

# ── Final checkpoint + summary ─────────────────────────────────────
save({'last_count': int(MAX), 'self_enc': self_enc})

elapsed_total = time.time() - scan_start
print()
print(SEP)
print(f"  COMPLETE  |  {MAX} manifolds  |  "
      f"{int(elapsed_total//60)}m {int(elapsed_total%60)}s elapsed")
print(SEP)
print(f"  {len(self_enc)} self-encoding manifold(s) found:\n")
if self_enc:
    for r in self_enc:
        print(f"    {r[0]:<8}  disc={r[1]:<5}  n={r[2]:<3}  "
              f"deg={r[4]}  slope={r[5]}  vol={r[6]}")
        print(f"             poly: {r[3]}")
else:
    print("    None found.")
print(SEP)
sys.exit(0)
