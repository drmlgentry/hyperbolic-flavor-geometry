# fourway_galois_group_direct.py
# Bounded attempt at a faster route to the same answer the closure job was
# after: the Galois group of K1234 (the degree-48 compositum of m003, m019,
# m010, m006's cusp fields), WITHOUT going through galois_closure() first.
#
# Rationale (Aug 21 2026 decision): galois_closure() on this degree-48 field
# ran 27 hours with zero progress signal (and 46 hours on an earlier attempt)
# with no evidence of convergence. K1234.galois_group() may route through a
# different Sage/PARI algorithm (e.g. nfgaloisconj-based methods) that
# doesn't require constructing the full splitting field explicitly. This is
# a genuinely different code path, not a retry of the same computation.
#
# Hard-bounded by design: this should NOT be allowed to run for days. If it
# doesn't return within the timeout, that's itself the answer (this route
# isn't faster either) -- kill it and report the disjointness result
# (entry 14, already independently verified twice) as the final state
# without the extra closure-group confirmation.
#
# Run: sage fourway_galois_group_direct.py

import os, sys, time, signal

DIR = "/mnt/c/dev/hyperbolic-flavor-geometry/reproduce"
LOG = os.path.join(DIR, "fourway_direct_progress.log")

def log(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    with open(LOG, 'a') as f:
        f.write(line + "\n")

log("=== fourway_galois_group_direct.py starting ===")

from sage.all import load, pari

pari.allocatemem(4 * 1024**3)

K1234 = load(os.path.join(DIR, "fourway_K1234.sobj"))
log(f"loaded K1234: degree {K1234.degree()}, disc {K1234.discriminant()}")

log("attempting K1234.galois_group() directly (no explicit closure construction)...")
t0 = time.time()
try:
    G = K1234.galois_group()
    elapsed = time.time() - t0
    log(f"SUCCESS in {elapsed:.1f}s -- order {G.order()}, structure {G.structure_description()}")
    with open(os.path.join(DIR, "fourway_direct_RESULT.txt"), 'w') as f:
        f.write(f"order={G.order()}\n")
        f.write(f"structure={G.structure_description()}\n")
        f.write(f"elapsed_seconds={elapsed:.1f}\n")
    log("=== COMPLETE ===")
except Exception as e:
    elapsed = time.time() - t0
    log(f"FAILED after {elapsed:.1f}s: {e}")
    log("=== FAILED ===")
