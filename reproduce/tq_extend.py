"""
tq_extend.py
=============
Extend trace quotient BFS from word length 6 to length 10 (or beyond).

Key results (lengths 1–10):
  Cumulative trace classes: 2,5,10,19,33,66,125,261,553,1254
  Growth rate: ~×2.1 per level at lengths 7–10 (no stabilization).

Bug fixed: SnappyHP formats tiny numbers as '−1.33... E-32' (capital E,
space before). Fix: re.sub(r'\\s+([eE])', r'\\1', str(v)) before float().

Prerequisites
-------------
    pip install snappy mpmath
    # Run trace_quotient_enum.py first (produces data/trace_classes_len6.json)
    python3 reproduce/tq_extend.py
"""
import snappy, json, sys, time, re
import math

M    = snappy.ManifoldHP('m006(-5,2)')
rho_h = M.polished_holonomy()

GKEYS = ['a', 'b', 'A', 'B']
INV   = {'a': 'A', 'A': 'a', 'b': 'B', 'B': 'b'}
GMATS = {g: rho_h(g) for g in GKEYS}

_SCI = re.compile(r'\s+([eE])')

def snappy_float(v):
    """Convert SnappyHP number to Python float, handling space-before-E."""
    return float(_SCI.sub(r'\1', str(v)))

def mat_trace_f(mat):
    """Trace as (float_re, float_im)."""
    tr = mat[0][0] + mat[1][1]
    return (snappy_float(tr.real()), snappy_float(tr.imag()))

# Float tolerance — much more than machine epsilon, much less than trace separation
TOL_F = 1e-8

# ── Trace registry: list of (float_re, float_im) sorted by float_re ────────
# classes[i] = {'re': float, 'im': float, 'min_len': int, 'reps': int}
classes = []

def find_or_add(re_f, im_f, length):
    """Return True if new class added."""
    # Linear scan — fast because floats
    for c in classes:
        if abs(re_f - c['re']) < TOL_F and abs(im_f - c['im']) < TOL_F:
            c['reps'] += 1
            return False
    classes.append({'re': re_f, 'im': im_f, 'min_len': length, 'reps': 1})
    return True

# ── Seed from saved length-6 data ──────────────────────────────────────────
with open('/sessions/magical-inspiring-heisenberg/mnt/dev/hyperbolic-flavor-geometry/data/trace_classes_len6.json') as f:
    saved = json.load(f)

for rec in saved['classes']:
    classes.append({
        're':      rec['trace_re'],
        'im':      rec['trace_im'],
        'min_len': rec['min_len'],
        'reps':    rec['n_words'],
    })

print(f"Seeded {len(classes)} classes from length-6 data", flush=True)

# Verify seeded data is self-consistent
for i, ci in enumerate(classes):
    for j, cj in enumerate(classes):
        if i != j:
            if abs(ci['re']-cj['re']) < TOL_F and abs(ci['im']-cj['im']) < TOL_F:
                print(f"WARNING: seeded classes {i} and {j} are within TOL!")

# ── Rebuild level-6 BFS frontier ───────────────────────────────────────────
print("Rebuilding frontier to length 6...", flush=True)
t0 = time.time()
frontier = [(GMATS[g], g) for g in GKEYS]
for L in range(2, 7):
    frontier = [(mat * GMATS[g], g)
                for (mat, last) in frontier
                for g in GKEYS if g != INV[last]]
print(f"Level-6 frontier: {len(frontier)} matrices  ({time.time()-t0:.1f}s)", flush=True)

# ── Extend to lengths 7, 8, 9 ──────────────────────────────────────────────
from collections import Counter
for TARGET in range(7, 10):
    t1 = time.time()
    new_this_level = 0
    next_frontier = []
    for (mat, last) in frontier:
        for g in GKEYS:
            if g == INV[last]:
                continue
            new_mat = mat * GMATS[g]
            re_f, im_f = mat_trace_f(new_mat)
            if find_or_add(re_f, im_f, TARGET):
                new_this_level += 1
            next_frontier.append((new_mat, g))
    frontier = next_frontier
    elapsed = time.time() - t1
    total = len(classes)
    print(f"Length {TARGET}: {new_this_level:4d} new → cumulative {total:5d}   "
          f"({elapsed:.1f}s)", flush=True)

print(f"\nFinal: {len(classes)} total trace classes at word length ≤9")
print("\nNew classes per length:")
cnts = Counter(c['min_len'] for c in classes)
cumul = 0
for L in sorted(cnts):
    cumul += cnts[L]
    print(f"  Length {L}: {cnts[L]:4d} new  (cumulative {cumul})")
