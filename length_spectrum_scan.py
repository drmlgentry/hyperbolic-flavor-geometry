# length_spectrum_scan.py v2 — correct SnapPy API
# Run: sage /mnt/c/dev/framework/length_spectrum_scan.py

import snappy, sys, os, json, time
from math import log, sqrt

CHECKPOINT = "/mnt/c/dev/framework/length_spectrum_checkpoint.json"
PHI  = (1 + sqrt(5)) / 2
ME   = 0.51099895   # MeV
SEP  = "=" * 70

MANIFOLDS = [
    ("m003",        "SU(2) cusped"),
    ("m006",        "SU(3) cusped"),
    ("m019",        "SU(4) cusped"),
    ("m003(-2,3)",  "M_PMNS closed"),
    ("m006(-5,2)",  "M_CKM  closed"),
    ("m019(2,1)",   "M_PMNS/SU(4)"),
    ("m019(4,1)",   "m019 Z/7"),
    ("m019(8,3)",   "m019 Z/3"),
]

LUCAS = [2,1,3,4,7,11,18,29,47,76,123,199,322,521,843,
         1364,2207,3571,5778,9349]

def lucas_check(L, tol=0.004):
    for k in range(1, 20):
        target = k * log(PHI)
        if abs(L - target) < tol:
            Lk = LUCAS[k] if k < len(LUCAS) else "?"
            return k, Lk, target
    return None, None, None

def load_cp():
    if os.path.exists(CHECKPOINT):
        with open(CHECKPOINT) as f: return json.load(f)
    return {}

def save_cp(data):
    with open(CHECKPOINT, 'w') as f: json.dump(data, f, indent=2)

results = load_cp()

print(SEP)
print("  HFG MANIFOLD LENGTH SPECTRUM  v2")
print(f"  Start: {time.strftime('%Y-%m-%d  %H:%M:%S')}")
print(f"  phi={PHI:.8f}   log(phi)={log(PHI):.8f}")
print(SEP)
sys.stdout.flush()

for name, label in MANIFOLDS:
    print(f"\n  {'─'*66}")
    print(f"  {label}  ({name})")
    print(f"  {'─'*66}")
    sys.stdout.flush()

    if name in results:
        geo = results[name]
        print(f"  [checkpoint: {len(geo)} geodesics]")
    else:
        try:
            M    = snappy.Manifold(name)
            spec = M.length_spectrum(5.0)   # positional cutoff
            geo  = []
            for g in spec:
                try:
                    L    = g['length']
                    reL  = float(L.real())
                    imL  = float(L.imag())
                    mult = int(g['multiplicity'])
                    topo = str(g['topology'])
                    if reL > 0:
                        geo.append([reL, imL, mult, topo])
                except: pass
            geo.sort(key=lambda x: x[0])
            results[name] = geo
            save_cp(results)
            print(f"  Found {len(geo)} geodesics (cutoff=5.0)")
        except Exception as e:
            print(f"  ERROR: {e}")
            results[name] = []
            save_cp(results)
            continue

    geo = results[name]
    if not geo:
        print("  No geodesics.")
        continue

    # Print table
    print(f"  {'#':<4} {'L (real)':<14} {'L (imag)':<14} "
          f"{'mult':<6} {'topology':<10} {'Lucas k':<10} {'mass MeV'}")
    print(f"  {'-'*4}  {'-'*14}  {'-'*14}  "
          f"{'-'*6}  {'-'*10}  {'-'*10}  {'-'*10}")

    lucas_hits = []
    for i, (reL, imL, mult, topo) in enumerate(geo[:20]):
        k, Lk, target = lucas_check(reL)
        lucas_str = f"k={k} L_{k}={Lk}" if k else ""
        if k: lucas_hits.append((k, Lk, reL, target))
        # Mass calibration: 1 length unit ~ m_e (rough)
        mass = reL * ME
        print(f"  {i+1:<4} {reL:<14.8f}  {imL:<14.8f}  "
              f"{mult:<6}  {topo:<10}  {lucas_str:<10}  {mass:.4f}")

    # Lucas bridge summary
    if lucas_hits:
        print(f"\n  *** LUCAS BRIDGE HITS ***")
        for k, Lk, reL, target in lucas_hits:
            err = abs(reL - target) / target * 100
            print(f"    k={k:2d}: L_{k}={Lk:<6}  "
                  f"geodesic={reL:.8f}  "
                  f"target={target:.8f}  "
                  f"err={err:.4f}%")
    else:
        print(f"\n  No Lucas bridge hits in first 20 geodesics.")

    sys.stdout.flush()

# ── Summary ────────────────────────────────────────────────────────
print()
print(SEP)
print("  SUMMARY TABLE")
print(SEP)
print(f"  {'Name':<14} {'Label':<16} {'N':<6} {'L_min':<12} "
      f"{'L_max shown':<12} {'Lucas hits'}")
print(f"  {'-'*14}  {'-'*16}  {'-'*6}  {'-'*12}  {'-'*12}  {'-'*20}")

for name, label in MANIFOLDS:
    geo = results.get(name, [])
    n   = len(geo)
    Lmin = f"{geo[0][0]:.6f}" if geo else "none"
    Lmax = f"{geo[-1][0]:.6f}" if geo else "none"
    hits = []
    for reL, imL, mult, topo in geo:
        k, Lk, _ = lucas_check(reL)
        if k: hits.append(f"k={k}")
    print(f"  {name:<14}  {label:<16}  {n:<6}  {Lmin:<12}  "
          f"{Lmax:<12}  {', '.join(hits) if hits else 'none'}")

print(SEP)
print(f"  Done: {time.strftime('%H:%M:%S')}")
print(SEP)
sys.exit(0)
