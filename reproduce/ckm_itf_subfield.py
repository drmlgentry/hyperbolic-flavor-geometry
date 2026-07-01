#!/usr/bin/env python3
"""
ckm_itf_subfield.py
===================
Computes and verifies the Galois group and subfield lattice of the
invariant trace field K₁₀ of M_CKM = m006(-5,2).

Result (verified 2026-07-01):
  Gal(K̃₁₀/Q) ≅ S₁₀   (PARI group [3628800, -1, 45, "S10"])
  Subfield lattice: TRIVIAL — only Q (degree 1) and K₁₀ (degree 10).
  No proper intermediate subfields exist.

Arithmetic significance:
  1. No quadratic subfield: the 3.4% agreement δ(M_CKM) ≈ J_CKM cannot
     be attributed to a hidden quadratic sub-field composition.
  2. No degree-5 subfield: despite H₁(M_CKM; Z) ≅ Z/5, the ITF has no
     cyclotomic sub-structure at the quintic level.
  3. Gal = S₁₀ (maximally generic): the Galois closure of K₁₀ has degree
     10! = 3,628,800 over Q.  K₁₀ is arithmetically primitive.
  4. Same pattern as the 4 degree-8 near-miss manifolds (all have Gal = S₈),
     confirming that the H₁=Z/5 stratum yields maximally generic fields.

The ITF polynomial (scan convention: minimal poly of tr(a)):
  f₁₀ = x¹⁰ - 7x⁸ + 4x⁷ + 17x⁶ - 14x⁵ - 18x⁴ + 14x³ + 8x² - 3x - 1
  disc = -271488204251
  sig  = (8, 1)   [8 real embeddings, 1 complex pair]

Usage
-----
  conda activate sage
  cd /path/to/hyperbolic-flavor-geometry
  python3 reproduce/ckm_itf_subfield.py

Requires SageMath (for galois_group, subfields).
Expected runtime: 30 seconds – 5 minutes (galois_group is the slow step).

Author: M. L. Gentry / Claude (Anthropic), July 2026
"""

import json
import os
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR  = os.path.join(REPO_ROOT, 'data')
OUT_FILE  = os.path.join(DATA_DIR, 'ckm_itf_subfield.json')

HLINE = '=' * 72
SLINE = '-' * 72

print(HLINE)
print("  M_CKM Invariant Trace Field: Galois Group and Subfield Lattice")
print(HLINE)

# ── SageMath ──────────────────────────────────────────────────────────────────
try:
    from sage.all import QQ, NumberField
except ImportError:
    sys.exit(
        "SageMath not available.\n"
        "Run:  conda activate sage && python3 reproduce/ckm_itf_subfield.py"
    )

R = QQ['x']
x = R.gen()

# M_CKM ITF polynomial (scan convention: minimal poly of tr(a))
# Coefficients in ascending order: [c0, c1, ..., c10]
f10 = x**10 - 7*x**8 + 4*x**7 + 17*x**6 - 14*x**5 - 18*x**4 + 14*x**3 + 8*x**2 - 3*x - 1

K10 = NumberField(f10, 'g')
disc  = int(K10.discriminant())
sig   = K10.signature()  # (r1, r2)

print(f"\n  Polynomial : {f10}")
print(f"  Degree     : {f10.degree()}")
print(f"  disc(K₁₀)  : {disc}")
print(f"  signature  : r₁={sig[0]}, r₂={sig[1]}")

# ── Verify polynomial properties ──────────────────────────────────────────────
EXPECTED_DISC = -271488204251
EXPECTED_SIG  = (8, 1)

checks = {}
checks['degree_10']         = (f10.degree() == 10)
checks['irreducible']       = bool(f10.is_irreducible())
checks['disc_correct']      = (disc == EXPECTED_DISC)
checks['signature_correct'] = (sig == EXPECTED_SIG)

print(f"\n{SLINE}")
print("  Basic checks:")
for label, ok in checks.items():
    status = "PASS" if ok else "FAIL"
    print(f"    {status}  {label}")

if not all(checks.values()):
    sys.exit("ERROR: Basic checks failed.  Verify polynomial.")

# ── Galois group ──────────────────────────────────────────────────────────────
print(f"\n{SLINE}")
print("  Computing Galois group Gal(K̃₁₀/Q) via PARI...")
print("  (This may take 30 seconds to several minutes.)")

try:
    G = f10.galois_group(pari_group=True)
    gal_order  = int(G.order())
    gal_label  = str(G)
    gal_is_S10 = (gal_order == 3628800)   # 10! = 3,628,800

    print(f"\n  Gal(K̃₁₀/Q) = {gal_label}")
    print(f"  Order       = {gal_order}  {'= 10! ✓' if gal_is_S10 else '(NOT S₁₀)'}")

    checks['galois_S10'] = gal_is_S10
    if gal_is_S10:
        print("  PASS  Galois group is the full symmetric group S₁₀")
    else:
        print(f"  NOTE  Galois group is a proper subgroup of S₁₀ (order {gal_order})")

except Exception as e:
    print(f"  ERROR computing Galois group: {e}")
    gal_order  = None
    gal_label  = str(e)
    checks['galois_S10'] = False

# ── Subfield lattice ──────────────────────────────────────────────────────────
print(f"\n{SLINE}")
print("  Computing subfield lattice of K₁₀...")
print("  (Possible degrees: 1, 2, 5, 10 — divisors of 10)")

subfields_data = []
try:
    subs = K10.subfields()
    print(f"\n  Total subfields (including Q and K₁₀): {len(subs)}")

    for sf, emb, _ in subs:
        d   = int(sf.degree())
        sd  = int(sf.discriminant())
        ss  = sf.signature()
        label = "Q" if d == 1 else ("K₁₀" if d == 10 else f"K_{d}")
        print(f"\n    degree {d}  ({label})")
        print(f"      disc      = {sd}")
        print(f"      signature = r₁={ss[0]}, r₂={ss[1]}")
        if 1 < d < 10:
            print(f"      poly      = {sf.polynomial()}")

        subfields_data.append({
            'degree':     d,
            'disc':       sd,
            'signature':  [int(ss[0]), int(ss[1])],
            'poly':       list(sf.polynomial()) if 1 < d < 10 else None,
        })

    proper_subs = [s for s in subfields_data if 1 < s['degree'] < 10]
    checks['no_proper_subfields'] = (len(proper_subs) == 0)

    if checks['no_proper_subfields']:
        print(f"\n  PASS  No proper intermediate subfields — lattice is TRIVIAL.")
    else:
        print(f"\n  NOTE  {len(proper_subs)} proper intermediate subfield(s) found:")
        for s in proper_subs:
            print(f"        degree {s['degree']}: disc={s['disc']}, sig={s['signature']}")

except Exception as e:
    print(f"  ERROR computing subfields: {e}")
    checks['no_proper_subfields'] = False

# ── Arithmetic interpretation ─────────────────────────────────────────────────
print(f"\n{HLINE}")
print("  Arithmetic interpretation")
print(HLINE)
print("""
  Gal(K̃₁₀/Q) = S₁₀   is the MAXIMUM possible Galois group for a degree-10
  number field.  It means:

  1. K₁₀/Q is not Galois (the Galois closure [K̃₁₀:Q] = 10! = 3,628,800).

  2. Trivial subfield lattice: the only subfields of K₁₀ are Q and K₁₀
     itself.  Equivalently, every subgroup of S₁₀ that contains the
     point-stabiliser Stab(1) ≅ S₉ is either S₉ itself (giving Q) or
     S₁₀ (giving K₁₀).

  3. No quadratic subfield: the peripheral determinant agreement
     δ(M_CKM) ≈ J_CKM = 3.06×10⁻⁴ (3.4%) cannot arise from a quadratic
     field composition (no Q(√d) sits inside K₁₀).

  4. No degree-5 subfield: despite H₁(M_CKM;Z) ≅ Z/5, the ITF carries
     no quintic cyclotomic sub-structure.  The Z/5 topology and the
     degree-10 field are related at the level of the full arithmetic
     invariant, not through a quotient field.

  5. Pattern: the 4 degree-8 near-miss manifolds also had Gal = S₈.
     The H₁=Z/5 stratum appears to produce MAXIMALLY GENERIC number fields
     across all ITF degrees observed (8 and 10).  This is unexpected —
     special topological constraints (Z/5 homology) do NOT impose special
     Galois structure on the arithmetic.

  6. The selectivity of the filtration (134 → 106 → 1 = M_CKM) therefore
     rests on the GLOBAL arithmetic invariants (discriminant, signature),
     not on any reducible sub-structure that could be coincidental.
""")

# ── Summary ───────────────────────────────────────────────────────────────────
print(HLINE)
print("  FINAL SUMMARY")
print(HLINE)
all_pass = all(checks.values())
for label, ok in checks.items():
    status = "PASS" if ok else "FAIL"
    print(f"  {status}  {label}")

print()
if all_pass:
    print("  ALL CHECKS PASSED")
    print("  Gal(K̃₁₀/Q) = S₁₀  |  Subfield lattice: TRIVIAL")
else:
    failed = [k for k, v in checks.items() if not v]
    print(f"  {len(failed)} check(s) FAILED: {failed}")

# ── Write JSON ────────────────────────────────────────────────────────────────
result = {
    'description': (
        'Galois group and subfield lattice of M_CKM ITF K₁₀. '
        'Gal(K̃₁₀/Q) = S₁₀ (order 3628800 = 10!). '
        'Subfield lattice: trivial (only Q and K₁₀).'
    ),
    'manifold':       'm006(-5,2)',
    'poly':           list(f10),
    'disc':           disc,
    'signature':      list(sig),
    'galois_order':   gal_order,
    'galois_label':   gal_label,
    'galois_is_S10':  checks.get('galois_S10', False),
    'subfields':      subfields_data,
    'n_proper_subfields': len([s for s in subfields_data if 1 < s['degree'] < 10]),
    'lattice_trivial': checks.get('no_proper_subfields', False),
    'checks':         checks,
    'all_pass':       all_pass,
}

os.makedirs(DATA_DIR, exist_ok=True)
with open(OUT_FILE, 'w') as fh:
    json.dump(result, fh, indent=2)

print(f"\n  Results written to: {OUT_FILE}")
print(HLINE)
