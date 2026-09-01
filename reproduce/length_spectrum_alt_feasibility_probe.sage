# Bounded task (per instruction): probe length_spectrum_alt(verified=True)
# ONLY for computational feasibility -- success/failure and timing -- to
# find a conservative common cutoff L* where BOTH m006 and m003 run
# reliably. Does NOT extract, print, or inspect any geodesic/class data;
# only len() and success/failure are recorded. Does NOT generate any
# replacement census.

import snappy
import time
import sys

CENSUS_INDEX = {'m006': 43, 'm003': 1}
CUTOFFS = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0]
PRECISIONS = [212, 300]  # 500 dropped for time -- the observed failure
# modes (ValueError: floor on inf/NaN; "start point too close to
# 1-skeleton") look like real robustness limits, not simple precision
# shortfalls, so a third precision tier is unlikely to change the
# feasibility verdict and would roughly triple runtime.

results = {}

for name, idx in CENSUS_INDEX.items():
    M = snappy.OrientableClosedCensus[idx]
    print()
    print("=" * 72)
    print(f"{name}: feasibility probe (verified=True)")
    print("=" * 72)
    results[name] = {}
    for cutoff in CUTOFFS:
        row = {}
        for prec in PRECISIONS:
            t0 = time.time()
            try:
                L = M.length_spectrum_alt(max_len=cutoff, verified=True, bits_prec=prec)
                elapsed = time.time() - t0
                row[prec] = ('OK', len(L), round(elapsed, 2))
                print(f"  cutoff={cutoff}, bits_prec={prec}: OK, {len(L)} entries, {round(elapsed,2)}s")
            except Exception as ex:
                elapsed = time.time() - t0
                row[prec] = ('FAIL', type(ex).__name__, round(elapsed, 2))
                print(f"  cutoff={cutoff}, bits_prec={prec}: FAILED ({type(ex).__name__}), {round(elapsed,2)}s")
            sys.stdout.flush()
        results[name][cutoff] = row
        # stop increasing cutoff for this manifold once ALL precisions
        # fail at this cutoff (no point probing further out)
        if all(row[p][0] == 'FAIL' for p in PRECISIONS):
            print(f"  (all precisions failed at cutoff={cutoff}; stopping escalation for {name})")
            break

print()
print("=" * 72)
print("SUMMARY: largest cutoff with at least one working precision, per manifold")
print("=" * 72)
best_working = {}
for name in CENSUS_INDEX:
    working_cutoffs = [c for c, row in results[name].items()
                       if any(row[p][0] == 'OK' for p in PRECISIONS)]
    best_working[name] = max(working_cutoffs) if working_cutoffs else None
    print(f"  {name}: largest working cutoff = {best_working[name]}")

common = [c for c in CUTOFFS
          if all(c in results[name] and any(results[name][c][p][0] == 'OK' for p in PRECISIONS)
                 for name in CENSUS_INDEX)]
L_star = max(common) if common else None
print()
print(f"Conservative common cutoff L* (both manifolds succeed, some precision): {L_star}")
