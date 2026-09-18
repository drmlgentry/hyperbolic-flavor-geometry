"""
Classify the length<=10 m003 collision fibers (words sharing the same
restricted trace T_w(t) on X_0) into:
  - "ambient"  : Delta_{w,v} = tr_xyz(w) - tr_xyz(v) is IDENTICALLY ZERO
                 as a polynomial in Q[x,y,z] (a literal trace-identity
                 coincidence, no use of I(X_0) at all)
  - "genuine"  : Delta_{w,v} != 0 in Q[x,y,z] but vanishes on X_0, i.e.
                 Delta_{w,v} in I(X_0) = <xz+1, x^2+y-1>

For the genuine pairs, compute an exact ideal-membership certificate
    Delta_{w,v} = f*(xz+1) + h*(x^2+y-1)
via sympy's exact multivariate division (sp.reduced), verify the
remainder is exactly zero, and record the certificate's shape (is f=0?
is h=0? total degrees) to look for recurring patterns across the
larger census.

Reuses reproduce/m003_traces_len10_cache.json (words + Laurent-on-X0
data, from m003_compute_and_cache_traces.py) to reconstruct the exact
same collision groups as m003_N_counterexample_search.py (1087 groups
expected), then recomputes the raw tr_xyz(w) in Q[x,y,z] (NOT cached
previously -- only the t-restricted Laurent form was cached) for every
word that appears in a group of size > 1.
"""

import json
import sys
import time
from collections import defaultdict

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u = sp.symbols("x y z u")

A = sp.Matrix([[x, -1], [1, 0]])
uinv = -z - u
B = sp.Matrix([[0, -u], [uinv, y]])
I2 = sp.eye(2)


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET_REL = sp.Poly(u**2 + z * u + 1, u)


def word_matrix(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    return sp.expand(M)


def tr_xyz(word):
    tr = sp.expand(word_matrix(word).trace())
    _, r = sp.div(sp.Poly(tr, u), DET_REL, u)
    r = sp.expand(r.as_expr())
    assert sp.Poly(r, u).degree() <= 0, f"{word}: residual u term {r}"
    return sp.expand(r)


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78, flush=True)


# ==========================================================================
banner("1. load cache, reconstruct collision groups from Laurent-on-X0 data")

with open("m003_traces_len10_cache.json") as f:
    data = json.load(f)

words = data["words"]
ea_signed = {w: int(v) for w, v in data["ea"].items()}
laurent_raw = data["laurent"]

by_laurent = defaultdict(list)
for w in words:
    key = tuple((e, c) for e, c in laurent_raw[w])
    by_laurent[key].append(w)

groups = [sorted(v, key=lambda w: (len(w), w)) for v in by_laurent.values() if len(v) > 1]
print(f"  {len(words)} words -> {len(by_laurent)} distinct T_w(t) classes, "
      f"{len(groups)} collision groups")
assert len(groups) == 1087, f"expected 1087 collision groups, got {len(groups)} -- grouping mismatch"
print("  MATCH: reproduces the 1087 groups from m003_N_counterexample_search.py")

needed_words = sorted({w for grp in groups for w in grp}, key=lambda w: (len(w), w))
print(f"  {len(needed_words)} distinct words appear in some collision group "
      f"(need raw tr_xyz(w) in Q[x,y,z] for these)")

# ==========================================================================
banner("2. compute raw tr_xyz(w) in Q[x,y,z] for every word in a collision group")
import os
CACHE_PATH = "m003_collision_words_trxyz_cache.json"
trxyz = {}
if os.path.exists(CACHE_PATH):
    with open(CACHE_PATH) as f:
        cached = json.load(f)
    if set(cached.keys()) == set(needed_words):
        print(f"  reusing cached tr_xyz(w) for all {len(needed_words)} words from {CACHE_PATH}")
        for w, s in cached.items():
            trxyz[w] = sp.sympify(s)
    else:
        print(f"  cache exists but word set mismatch -- recomputing")
if not trxyz:
    t0 = time.time()
    for i, w in enumerate(needed_words):
        trxyz[w] = tr_xyz(w)
        if (i + 1) % 200 == 0:
            print(f"    ... {i+1}/{len(needed_words)} ({time.time()-t0:.0f}s)", flush=True)
    print(f"  done in {time.time()-t0:.1f}s")
    with open(CACHE_PATH, "w") as f:
        json.dump({w: sp.srepr(trxyz[w]) for w in needed_words}, f)
    print(f"  cached raw tr_xyz(w) polynomials to {CACHE_PATH}")

# ==========================================================================
banner("3. within each group, partition by EXACT tr_xyz equality (ambient classes)")

# ambient-class key: exact polynomial (expand + srepr) -- literal identity
poly_key = {w: sp.srepr(sp.expand(trxyz[w])) for w in needed_words}

pure_ambient_groups = []   # groups where all members share ONE ambient class
mixed_groups = []          # groups with >=2 ambient classes (genuine content)

for grp in groups:
    classes = defaultdict(list)
    for w in grp:
        classes[poly_key[w]].append(w)
    if len(classes) == 1:
        pure_ambient_groups.append(grp)
    else:
        mixed_groups.append((grp, list(classes.values())))

print(f"  {len(pure_ambient_groups)} groups are PURELY AMBIENT "
      f"(all members literally equal as polynomials in x,y,z -- no use of I(X_0))")
print(f"  {len(mixed_groups)} groups have GENUINE content "
      f"(>=2 distinct ambient classes, collision created specifically by I(X_0))")

# ==========================================================================
banner("4. for genuine (mixed) groups: certificate Delta = f*(xz+1) + h*(x^2+y-1)")

g1 = sp.expand(x * z + 1)
g2 = sp.expand(x**2 + y - 1)
GB = [g1, g2]
# IMPORTANT: {g1,g2} is only a genuine Groebner basis (remainder=0 for every
# true ideal member) under lex order with z > y > x. Verified directly:
# sp.groebner([g1,g2], z,y,x, order='lex').exprs == [g1,g2] exactly. Under
# the "natural" (x,y,z) variable order (or grlex/grevlex), Buchberger's
# algorithm produces a THIRD basis element (x - y*z + z), so naive division
# against just {g1,g2} in that order can give a nonzero remainder even for
# elements that ARE in the ideal -- caught by an assertion failure on the
# first (A, ABBB) pair before this fix.
REDUCE_GENS = (z, y, x)
REDUCE_ORDER = "lex"

certificates = []   # (w0, v, degree info, f, h)
t0 = time.time()
n_pairs_checked = 0
for grp, classes in mixed_groups:
    reps = [cls[0] for cls in classes]
    w0 = reps[0]
    for v in reps[1:]:
        n_pairs_checked += 1
        Delta = sp.expand(trxyz[w0] - trxyz[v])
        assert Delta != 0, "mixed-group representative pair should differ as polynomials"
        quotients, remainder = sp.reduced(Delta, GB, *REDUCE_GENS, order=REDUCE_ORDER)
        remainder = sp.expand(remainder)
        assert remainder == 0, (
            f"CERTIFICATE FAILURE: Delta_{{{w0},{v}}} does NOT reduce to 0 mod "
            f"<xz+1,x^2+y-1> -- remainder={remainder}"
        )
        f_coef, h_coef = quotients
        f_coef = sp.expand(f_coef)
        h_coef = sp.expand(h_coef)
        # re-verify the certificate directly (independent check of sp.reduced's claim)
        rebuilt = sp.expand(f_coef * g1 + h_coef * g2)
        assert sp.expand(rebuilt - Delta) == 0, (
            f"CERTIFICATE REBUILD FAILURE for Delta_{{{w0},{v}}}"
        )
        certificates.append((w0, v, Delta, f_coef, h_coef))

print(f"  {n_pairs_checked} genuine cross-ambient-class pairs certified "
      f"(one rep-pair per pair of ambient classes within each of the "
      f"{len(mixed_groups)} mixed groups)")
print(f"  every certificate independently rebuilt and verified: f*(xz+1)+h*(x^2+y-1) == Delta")
print(f"  done in {time.time()-t0:.1f}s")

# ==========================================================================
banner("4b. CANONICAL trichotomy: principal-ideal membership (order-independent)")
print("  Note: the (f,h) pair from step 4 is NOT unique -- <xz+1,x^2+y-1> is a")
print("  complete intersection, so its syzygy module is generated by the single")
print("  Koszul relation (g2,-g1); any (f + p*g2, h - p*g1) is an equally valid")
print("  certificate for the same Delta. So bucketing by deg(f),deg(h) from a")
print("  single sp.reduced() call is an order-dependent artifact, not a genuine")
print("  invariant of Delta. The canonical, order-independent question instead")
print("  is: does Delta lie in one of the two PRINCIPAL ideals (xz+1) or")
print("  (x^2+y-1) alone? A single-generator set is automatically a Groebner")
print("  basis for every order (no S-polynomials to reduce), so this divisibility")
print("  test is unambiguous. This mirrors the m006 ambient/pure-g2/needs-both")
print("  classification exactly.")

needs_g1_only, needs_g2_only, needs_both = [], [], []
for (w0, v, Delta, f_coef, h_coef) in certificates:
    _, r1 = sp.reduced(Delta, [g1], x, y, z)
    _, r2 = sp.reduced(Delta, [g2], x, y, z)
    in_g1_alone = (sp.expand(r1) == 0)
    in_g2_alone = (sp.expand(r2) == 0)
    if in_g1_alone:
        needs_g1_only.append((w0, v, Delta))
    elif in_g2_alone:
        needs_g2_only.append((w0, v, Delta))
    else:
        needs_both.append((w0, v, Delta))

n_tot = len(certificates)
print(f"\n  {len(needs_g1_only)} ({100.0*len(needs_g1_only)/n_tot:.1f}%) lie in (xz+1) ALONE "
      f"-- pure-g1, h can be taken 0")
print(f"  {len(needs_g2_only)} ({100.0*len(needs_g2_only)/n_tot:.1f}%) lie in (x^2+y-1) ALONE "
      f"-- pure-g2, f can be taken 0")
print(f"  {len(needs_both)} ({100.0*len(needs_both)/n_tot:.1f}%) lie in NEITHER principal ideal "
      f"-- genuinely need both generators")

if needs_g1_only:
    w0, v, Delta = needs_g1_only[0]
    print(f"\n  example pure-g1: w0={w0!r} v={v!r}  Delta={Delta}")
if needs_g2_only:
    w0, v, Delta = needs_g2_only[0]
    print(f"  example pure-g2: w0={w0!r} v={v!r}  Delta={Delta}")
if needs_both:
    w0, v, Delta = needs_both[0]
    print(f"  example needs-both: w0={w0!r} v={v!r}  Delta={Delta}")

# ==========================================================================
banner("5. certificate-pattern census (order-dependent, supplementary only)")


def shape_of(f_coef, h_coef):
    f_zero = (f_coef == 0)
    h_zero = (h_coef == 0)
    f_deg = -1 if f_zero else int(sp.total_degree(sp.Poly(f_coef, x, y, z)))
    h_deg = -1 if h_zero else int(sp.total_degree(sp.Poly(h_coef, x, y, z)))
    return (f_zero, h_zero, f_deg, h_deg)


shape_counts = defaultdict(int)
shape_examples = {}
for (w0, v, Delta, f_coef, h_coef) in certificates:
    s = shape_of(f_coef, h_coef)
    shape_counts[s] += 1
    if s not in shape_examples:
        shape_examples[s] = (w0, v, Delta, f_coef, h_coef)

print(f"  {len(shape_counts)} distinct (f==0?, h==0?, deg f, deg h) certificate shapes "
      f"across {len(certificates)} genuine certificates")
print()
for s, cnt in sorted(shape_counts.items(), key=lambda kv: -kv[1]):
    f_zero, h_zero, fd, hd = s
    pct = 100.0 * cnt / len(certificates)
    print(f"    f==0:{str(f_zero):5s} h==0:{str(h_zero):5s} deg(f)={fd:3d} deg(h)={hd:3d}  "
          f"-> {cnt:4d} certs ({pct:5.1f}%)")

print()
print("  example certificate for each of the top 5 shapes:")
top5 = sorted(shape_counts.items(), key=lambda kv: -kv[1])[:5]
for s, cnt in top5:
    w0, v, Delta, f_coef, h_coef = shape_examples[s]
    print(f"\n    shape {s} (n={cnt}):")
    print(f"      w0={w0!r}  v={v!r}")
    print(f"      Delta = {Delta}")
    print(f"      f (coeff of xz+1)     = {f_coef}")
    print(f"      h (coeff of x^2+y-1)  = {h_coef}")

# ==========================================================================
banner("6. summary")
print(f"  1087 total length<=10 collision groups (words sharing T_w(t) on X_0)")
print(f"    {len(pure_ambient_groups)} ({100.0*len(pure_ambient_groups)/1087:.1f}%) purely ambient "
      f"-- coincidence needs NO input from I(X_0)")
print(f"    {len(mixed_groups)} ({100.0*len(mixed_groups)/1087:.1f}%) genuine "
      f"-- collision specifically created by imposing I(X_0)")
print(f"  {len(certificates)} genuine cross-class certificates computed and independently verified")
print(f"  canonical trichotomy: {len(needs_g1_only)} pure-g1, {len(needs_g2_only)} pure-g2, "
      f"{len(needs_both)} need-both (order-independent, principal-ideal test)")
print(f"  ({len(shape_counts)} distinct (f,h)-degree shapes from one sp.reduced() normal form -- "
      f"NOT a canonical invariant, since the certificate is unique only up to the ideal's Koszul "
      f"syzygy; reported as supplementary data only, not as evidence of a small generator set)")

print("\nPY_EXIT=0")
