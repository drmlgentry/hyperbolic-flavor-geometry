# spectral_gap_test.py v2
# Uses cached spectra where available, smaller cutoff=4.5 for new ones
# Run: sage /mnt/c/dev/framework/spectral_gap_test.py

import snappy, sys, os, json, time, math
from math import log, sqrt, exp, gcd

CHECKPOINT = "/mnt/c/dev/framework/spectral_gap_checkpoint.json"
PHI   = (1+sqrt(5))/2
LUCAS = [2,1,3,4,7,11,18,29,47,76,123,199,322,521,843]
TOL   = 0.001
CUTOFF = 4.5   # smaller = faster
SEP   = "=" * 65

def lucas_index(n):
    for k,L in enumerate(LUCAS):
        if L == n: return k
    return None

def get_hits(lengths, cutoff=CUTOFF):
    hits = set()
    for reL in lengths:
        if reL <= 0 or reL > cutoff: continue
        for k in range(1, 20):
            target = k * log(PHI)
            if target > cutoff + 0.01: break
            if abs(reL-target)/target < TOL:
                hits.add(int(k))
    return hits

def p_gap(N, k, cutoff=CUTOFF):
    target = k * log(PHI)
    if target > cutoff: return 1.0, 0.0
    window = 2 * TOL * target
    expected = N * window / cutoff
    return exp(-expected), expected

def save_cp(data):
    with open(CHECKPOINT, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"  [saved {time.strftime('%H:%M:%S')}]", flush=True)

def load_cp():
    if os.path.exists(CHECKPOINT):
        with open(CHECKPOINT) as f: return json.load(f)
    return {}

cp = load_cp()

print(SEP)
print("  SPECTRAL GAP TEST v2  |  cutoff=4.5  |  tol=0.1%")
print(f"  Start: {time.strftime('%H:%M:%S')}")
print(SEP, flush=True)

# Known results from last night (already computed)
# m019(4,1): 795 geodesics at cutoff=5.0, hits={3,5,6,8,9,10}, gaps at k=4,7
# m019(8,3): 883 geodesics, hits={8,9,10}, gaps at k=2,3
# m003(-2,3): 230 geodesics, hits={6,8,9}, gap at k=5
# m006(-5,2): 440 geodesics, hits={8,9,10}, gap at k=5

known = {
    "m019(4,1)":  {"n":7,  "hits":[3,5,6,8,9,10], "gaps":[4,7], "N":795},
    "m019(8,3)":  {"n":3,  "hits":[8,9,10],        "gaps":[2,3], "N":883},
    "m003(-2,3)": {"n":5,  "hits":[6,8,9],         "gaps":[5],   "N":230},
    "m006(-5,2)": {"n":5,  "hits":[8,9,10],        "gaps":[5],   "N":440},
}

print("PART 1: STATISTICAL VALIDATION (from cached spectra)")
print("-" * 65, flush=True)

for mname, d in known.items():
    n, hits_set, gaps, N = d["n"], set(d["hits"]), d["gaps"], d["N"]
    li = lucas_index(n)
    is_lucas = li is not None

    print(f"\n  {mname}: H1=Z/{n}  N={N} geodesics")
    print(f"  n is Lucas: {is_lucas}"
          + (f" (L_{li}={n})" if is_lucas else ""))
    print(f"  Predicted gaps: k={gaps}")
    print(f"  Hits present: k={sorted(hits_set)}")

    all_ok = True
    for k in gaps:
        target = k * log(PHI)
        absent = k not in hits_set
        pv, ex = p_gap(N, k)
        status = "ABSENT ✓" if absent else "PRESENT ✗"
        print(f"  k={k:<3} target={target:.4f}  {status}  "
              f"p(gap)={pv:.5f}  expected={ex:.2f} hits")
        if not absent: all_ok = False

    print(f"  Conjecture: {'✓ HOLDS' if all_ok else '✗ FAILS'}", flush=True)

print()
print("PART 2: NEW PREDICTIONS — Lucas prime torsion")
print("-" * 65)
print("  Prediction: Z/11 gaps at k=5,11; Z/29 at k=7,29; Z/47 at k=8,47")
print("  Searching m019 slopes with H1 in {11,29,47}...")
sys.stdout.flush()

key2 = "lucas_prime_fillings"
if key2 in cp:
    fillings = cp[key2]
    print(f"  [cached: {len(fillings)} fillings]", flush=True)
else:
    fillings = []
    M19 = snappy.Manifold("m019")
    checked = 0
    for p in range(-12,13):
        for q in range(-12,13):
            if p==0 and q==0: continue
            if gcd(abs(p),abs(q))!=1: continue
            checked += 1
            if checked % 200 == 0:
                sys.stdout.write(f"\r  {checked} slopes checked, "
                                 f"{len(fillings)} found ...")
                sys.stdout.flush()
            try:
                N2 = M19.copy()
                N2.dehn_fill((p,q))
                order = N2.homology().order()
                vol = float(N2.volume())
                if vol > 0.5 and order in [11,29,47]:
                    fillings.append([int(p),int(q),int(order),round(vol,5)])
                    print(f"\n  FOUND: m019({p},{q}): H1=Z/{order}, "
                          f"vol={vol:.5f}", flush=True)
            except: pass
    cp[key2] = fillings
    save_cp(cp)
    print(flush=True)

print(f"\n  Found {len(fillings)} fillings with Lucas prime torsion")

# Test each — use small cutoff for speed
for p,q,order,vol in fillings[:3]:  # test first 3
    name = f"m019({p},{q})"
    key3 = f"gap_{p}_{q}"
    li = lucas_index(order)
    predicted = sorted(set([order]+([li] if li else [])))

    print(f"\n  Testing {name}: H1=Z/{order}  vol={vol:.4f}")
    print(f"  Predicted gaps: k={predicted}", flush=True)

    if key3 in cp:
        r = cp[key3]
        hits_set = set(r['hits'])
        N_t = r['N']
        print(f"  [cached: {N_t} geodesics]")
    else:
        print(f"  Getting spectrum (cutoff={CUTOFF})...", end="")
        sys.stdout.flush()
        try:
            M_t = snappy.Manifold("m019")
            M_t.dehn_fill((p,q))
            spec_t = M_t.length_spectrum(CUTOFF)
            lengths = [float(g['length'].real()) for g in spec_t
                      if float(g['length'].real()) > 0]
            N_t = len(lengths)
            print(f" {N_t} geodesics", flush=True)
            hits_set = get_hits(lengths, CUTOFF)
            cp[key3] = {'hits': sorted(hits_set), 'N': int(N_t)}
            save_cp(cp)
        except Exception as e:
            print(f" ERROR: {e}", flush=True)
            continue

    print(f"  Hits present: k={sorted(hits_set)}")
    all_ok = True
    for k in predicted:
        target = k * log(PHI)
        if target > CUTOFF:
            print(f"  k={k}: target={target:.3f} > cutoff, skip")
            continue
        absent = k not in hits_set
        pv, ex = p_gap(N_t, k, CUTOFF)
        status = "ABSENT ✓" if absent else "PRESENT ✗"
        print(f"  k={k:<3} {status}  p(gap)={pv:.5f}  expected={ex:.2f}")
        if not absent: all_ok = False
    print(f"  Conjecture: {'✓ HOLDS' if all_ok else '✗ FAILS'}", flush=True)

print()
print(SEP)
print("  SUMMARY")
print(SEP)
print(f"  {'Manifold':<16} {'H1':<8} {'Gaps':<14} {'p-values':<20} {'Result'}")
print(f"  {'-'*16}  {'-'*8}  {'-'*14}  {'-'*20}  {'-'*8}")
for mname, d in known.items():
    gaps, N = d["gaps"], d["N"]
    pvs = [f"k={k}:{p_gap(N,k)[0]:.4f}" for k in gaps]
    hits = set(d["hits"])
    ok = all(k not in hits for k in gaps)
    print(f"  {mname:<16}  Z/{d['n']:<6}  k={str(gaps):<14}  "
          f"{', '.join(pvs):<20}  {'✓' if ok else '✗'}")
print(SEP)
print(f"  Done: {time.strftime('%H:%M:%S')}")
print(SEP)
sys.exit(0)
