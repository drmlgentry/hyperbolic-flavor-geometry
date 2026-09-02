#!/usr/bin/env sage
"""
Read-only CKM factor-selection audit (corrected full-primary complement).

This script writes no files.  By default it loads the exact multiplication
matrix and its exact saved minimal polynomial from the Q-001 computation.
Pass --recompute-minpoly to recompute the minimal polynomial from the 440x440
rational matrix (the previous run took about 2.3 hours).

The named file q001_quotient_correct.sage is downstream: it loads q001_Mx.sobj
and does not contain the defining ideal.  The matrix was constructed from the
exact cached Groebner basis by q001_mx_step.sage without using q10 as a
defining equation.  This audit therefore uses that exact matrix directly.
"""

from sage.all import *
import hashlib
import os
import sys

import snappy


BITS_PREC = 300
DEFAULT_REPO = "/mnt/c/dev/hyperbolic-flavor-geometry"
RECOMPUTE = "--recompute-minpoly" in sys.argv


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest().upper()


def sha256_text(value):
    return hashlib.sha256(str(value).encode("utf-8")).hexdigest().upper()


def strictly_contained(inner, outer):
    return (inner.real().lower() > outer.real().lower() and
            inner.real().upper() < outer.real().upper() and
            inner.imag().lower() > outer.imag().lower() and
            inner.imag().upper() < outer.imag().upper())


repo_args = [a for a in sys.argv[1:] if not a.startswith("--")]
REPO = os.path.abspath(repo_args[0]) if repo_args else DEFAULT_REPO
REPRO = os.path.join(REPO, "reproduce")

mx_path = os.path.join(REPRO, "q001_Mx.sobj")
mu_path = os.path.join(REPRO, "q001_px.sobj")
factor_path = os.path.join(REPRO, "q001_px_factors.sobj")

for path in (mx_path, mu_path, factor_path):
    if not os.path.isfile(path):
        raise FileNotFoundError(path)

print("=" * 78)
print("CKM FACTOR-SELECTION CERTIFICATE — CORRECTED READ-ONLY AUDIT")
print("=" * 78)
print("repo =", REPO)
print("q001_Mx.sobj SHA256 =", sha256_file(mx_path))
print("q001_px.sobj SHA256 =", sha256_file(mu_path))
print("q001_px_factors.sobj SHA256 =", sha256_file(factor_path))

Mx = load(mx_path)
mu_saved = load(mu_path)

assert Mx.base_ring() is QQ or Mx.base_ring() == QQ
assert Mx.nrows() == Mx.ncols()
print()
print("dim A0 =", Mx.nrows())

if RECOMPUTE:
    print("Recomputing Mx.minimal_polynomial(); the earlier run took ~2.3 hours.")
    mu = Mx.minimal_polynomial()
    assert mu == mu_saved, "recomputed minpoly differs from saved exact artifact"
    print("recomputed minpoly matches q001_px.sobj exactly: True")
else:
    mu = mu_saved
    print("minpoly source = exact saved q001_px.sobj")
    print("To recompute from Mx, rerun with --recompute-minpoly.")

S = mu.parent()
x = S.gen()
q10 = (x**10 - 7*x**8 + 4*x**7 + 17*x**6 - 14*x**5
       - 18*x**4 + 14*x**3 + 8*x**2 - 3*x - 1)

fac = list(mu.factor())
print("minpoly(Mx) degree =", mu.degree())
print("minpoly(Mx) coefficient-text SHA256 =", sha256_text(mu))
print("factorization summary:")
for factor, exponent in fac:
    if factor.degree() <= 20:
        print("  degree", factor.degree(), "multiplicity", exponent,
              "irreducible =", factor.is_irreducible(),
              "polynomial =", factor)
    else:
        print("  degree", factor.degree(), "multiplicity", exponent,
              "irreducible =", factor.is_irreducible(),
              "coefficient-text SHA256 =", sha256_text(factor))

assert q10.is_irreducible(), "q10 is not irreducible"
q10_divides = (mu % q10 == 0)
print()
print("q10 irreducible =", q10.is_irreducible())
print("q10 divides mu exactly =", q10_divides)
assert q10_divides, "q10 NOT a factor — certificate FAILS"

tmp = mu
q10_multiplicity = 0
while tmp % q10 == 0:
    tmp //= q10
    q10_multiplicity += 1

print("multiplicity of q10 in mu =", q10_multiplicity)
assert q10_multiplicity == 3, "expected exact q10 multiplicity 3"

# Remove the entire q10-primary multiplicity, not just one copy.
r_comp = tmp
g = gcd(r_comp, q10).monic()
print("degree r_comp = degree(mu // q10^3) =", r_comp.degree())
print("gcd(q10, r_comp) =", g)
print("q10 divides r_comp =", r_comp % q10 == 0)
print("r_comp coefficient-text SHA256 =", sha256_text(r_comp))
assert r_comp.degree() == 400
assert g == 1

remaining_fac = list(r_comp.factor())
print("r_comp factorization summary:")
for factor, exponent in remaining_fac:
    print("  degree", factor.degree(), "multiplicity", exponent,
          "irreducible =", factor.is_irreducible(),
          "coefficient-text SHA256 =", sha256_text(factor))
assert sorted((factor.degree(), exponent) for factor, exponent in remaining_fac) == [(200, 1), (200, 1)]

print()
print("=" * 78)
print("CERTIFIED TRACE BOX AND q10 ROOT ISOLATION")
print("=" * 78)
M = snappy.Manifold("m006(-5,2)")
ok, rho = M.verify_hyperbolicity(holonomy=True, bits_prec=BITS_PREC)
print("verify_hyperbolicity(holonomy=True, bits_prec=300) =", ok)
assert ok

trace_interval = rho('a').trace()
print("T_a =", trace_interval)

CIF = ComplexIntervalField(BITS_PREC)
RIF = RealIntervalField(BITS_PREC)
q10_CIF = q10.change_ring(CIF)
q10_prime_CIF = q10_CIF.derivative()

delta = RIF(2)**(-BITS_PREC + 20)
pad = RIF(-1, 1) * delta
box = CIF(trace_interval.real() + pad, trace_interval.imag() + pad)

mre = (box.real().lower() + box.real().upper()) / 2
mim = (box.imag().lower() + box.imag().upper()) / 2
m = CIF(mre, mim)
N_box = m - q10_CIF(m) / q10_prime_CIF(box)
contracted = strictly_contained(N_box, box)

print("Newton box =", box)
print("N(box) =", N_box)
print("N(box) strictly contained in box =", contracted)
assert contracted, "q10 root isolation failed"
print("q10 roots in T_a box = exactly one (interval-Newton certificate)")

print()
print("=" * 78)
print("CERTIFIED EXCLUSION OF THE FULL COMPLEMENTARY FACTOR")
print("=" * 78)

# Evaluating an exact QQ polynomial after changing its base ring to CIF gives
# a rigorous interval enclosure.  If zero is not in the rectangular complex
# interval r_comp(T_a), no root of r_comp lies anywhere in T_a.
r_comp_CIF = r_comp.change_ring(CIF)
r_comp_on_Ta = r_comp_CIF(trace_interval)
real_contains_zero = (r_comp_on_Ta.real().lower() <= 0 <=
                      r_comp_on_Ta.real().upper())
imag_contains_zero = (r_comp_on_Ta.imag().lower() <= 0 <=
                      r_comp_on_Ta.imag().upper())
complex_contains_zero = real_contains_zero and imag_contains_zero

print("r_comp(T_a) =", r_comp_on_Ta)
print("real projection contains 0 =", real_contains_zero)
print("imag projection contains 0 =", imag_contains_zero)
print("complex interval contains 0 =", complex_contains_zero)
assert not complex_contains_zero, "interval evaluation cannot exclude an r_comp root from T_a"

print()
print("=" * 78)
print("FACTOR-SELECTION VERDICT")
print("=" * 78)
print("q10 divides mu exactly: PASS")
print("valuation v_q10(mu) = 3: PASS")
print("T_a contains exactly one q10 root: PASS")
print("T_a contains no root of r_comp = mu/q10^3: PASS")
print("FACTOR SELECTION CERTIFICATE: PASS")
print()
print("SCOPE: this selects the q10-supported x-value among the distinct factor")
print("supports of the exact multiplication polynomial.  It does not explain")
print("the q10-primary multiplicity three, and it does not by itself replace")
print("the separate logical requirement connecting the verified geometric")
print("trace to an exact point of the character algebra.")
print("END OF CERTIFICATE — ALL ASSERTIONS PASSED")
