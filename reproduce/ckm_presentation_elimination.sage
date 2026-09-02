#!/usr/bin/env sage
"""
CKM presentation-only elimination certificate.

This standalone audit script derives a polynomial relation for
T = tr(rho(mu)), mu = Abb, from the exact filled-group presentation.
It never inserts the previously recognized polynomial m_mu into the
presentation ideal.  m_mu is introduced only after elimination, as a
factor to test against the independently derived eliminant.

This file is intentionally outside the repository and writes no files.
"""

from sage.all import *
import hashlib
import platform
import sys
import time

try:
    sys.stdout.reconfigure(line_buffering=True)
except Exception:
    pass


def banner(text):
    print("\n" + "=" * 78, flush=True)
    print(text, flush=True)
    print("=" * 78, flush=True)


def sha256_text(value):
    return hashlib.sha256(str(value).encode("utf-8")).hexdigest().upper()


def complex_interval_contains_zero(value):
    return (value.real().lower() <= 0 <= value.real().upper()
            and value.imag().lower() <= 0 <= value.imag().upper())


banner("CKM PRESENTATION-ONLY ELIMINATION CERTIFICATE")
print("Sage version =", version())
print("Python =", platform.python_version())
print("PROVENANCE RULE: m_mu is not used in the presentation ideal.")


# ---------------------------------------------------------------------------
# STEP 1: Exact representation chart.
# ---------------------------------------------------------------------------

R = PolynomialRing(QQ, names=("x", "y", "z", "u", "T"),
                   order="degrevlex")
x, y, z, u, T = R.gens()

A = matrix(R, [[x, -1], [1, 0]])
uinv = -z - u                 # u^{-1} modulo u^2 + z*u + 1
B = matrix(R, [[0, -u], [uinv, y]])
I2 = identity_matrix(R, 2)


def inv_sl2(M):
    """Adjugate, equal to M^{-1} after imposing det(M)=1."""
    return matrix(R, [[M[1, 1], -M[0, 1]],
                      [-M[1, 0], M[0, 0]]])


Ai = inv_sl2(A)
Bi = inv_sl2(B)
MATS = {"a": A, "A": Ai, "b": B, "B": Bi}


def word_matrix(word):
    M = I2
    for letter in word:
        M = M * MATS[letter]
    return M


def inverse_word(word):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(word))


relator = "ababbAAbb"
mu = "Abb"
longitude = "AAbA"
filling_word = inverse_word(mu) * 5 + longitude * 2

assert filling_word == "BBaBBaBBaBBaBBaAAbAAAbA"
print("relator =", relator)
print("mu =", mu)
print("longitude =", longitude)
print("filling word mu^(-5)*longitude^2 =", filling_word)

Mr = word_matrix(relator)
Ms = word_matrix(filling_word)


# ---------------------------------------------------------------------------
# STEP 2: Presentation-only ideal.
# ---------------------------------------------------------------------------

det_relation = u**2 + z*u + 1
gens = [det_relation]
for M in (Mr - I2, Ms - I2):
    gens.extend([M[0, 0], M[0, 1], M[1, 0], M[1, 1]])

tr_mu = x*y**2 - x - y*z
trace_coordinate = T - tr_mu
gens.append(trace_coordinate)

assert len(gens) == 10
assert gens[-1] == T - (x*y**2 - x - y*z)
assert all(g.degree(T) == 0 for g in gens[:-1])
assert gens[-1].degree(T) == 1

banner("PRESENTATION-ONLY IDEAL GENERATORS")
print("Number of generators:", len(gens))
print("Generators (m_mu has not yet been defined):")
for i, g in enumerate(gens):
    print("GENERATOR", i, "=", g)
    print("GENERATOR", i, "total degree =", g.total_degree())
    print("GENERATOR", i, "coefficient-text SHA256 =", sha256_text(g))

all_gens_text = "\n".join(str(g) for g in gens)
print("all-generators coefficient-text SHA256 =", sha256_text(all_gens_text))
print("m_mu inserted into presentation ideal = False")


# ---------------------------------------------------------------------------
# STEP 3: Lexicographic elimination to Q[T].
# ---------------------------------------------------------------------------

banner("LEXICOGRAPHIC GROEBNER ELIMINATION")
S = PolynomialRing(QQ, names=("x", "y", "z", "u", "T"), order="lex")
sx, sy, sz, su, sT = S.gens()
phi = R.hom([sx, sy, sz, su, sT], S)
JS = S.ideal([phi(g) for g in gens])

print("Starting exact lex Groebner basis at", time.ctime(), flush=True)
print("This is the potentially expensive step.", flush=True)
gb_start = time.time()
GS = JS.groebner_basis()
gb_seconds = time.time() - gb_start
print("Groebner basis completed at", time.ctime(), flush=True)
print("Groebner wall seconds =", gb_seconds)
print("Groebner basis length =", len(GS))

univariate_S = [g for g in GS
                if g.degree(sx) == 0
                and g.degree(sy) == 0
                and g.degree(sz) == 0
                and g.degree(su) == 0]

print("Univariate T-polynomials found:", len(univariate_S))
for i, g in enumerate(univariate_S):
    print("UNIVARIATE_S", i, "degree =", g.degree(sT))
    print("UNIVARIATE_S", i, "=", g)
    print("UNIVARIATE_S", i, "coefficient-text SHA256 =", sha256_text(g))

assert univariate_S, (
    "No nonzero univariate T-polynomial was found; the requested finite "
    "elimination certificate is unavailable from this chart/ideal."
)

UT = PolynomialRing(QQ, "T")
t = UT.gen()
to_UT = S.hom([UT(0), UT(0), UT(0), UT(0), t], UT)
univariate = [to_UT(g) for g in univariate_S if g != 0]
assert univariate

E = univariate[0]
for g in univariate[1:]:
    E = gcd(E, g)
E = E / E.leading_coefficient()
E = UT(E)

banner("PRESENTATION-DERIVED ELIMINANT")
print("E(T) degree =", E.degree())
print("E(T) =", E)
print("E(T) coefficient-text SHA256 =", sha256_text(E))
E_factorization = E.factor()
print("E(T) factorization =", E_factorization)


# ---------------------------------------------------------------------------
# STEP 4: Compare only now with the historical candidate m_mu.
# This polynomial was NOT available when JS or GS was built.
# ---------------------------------------------------------------------------

m_mu = (t**10 + 4*t**9 - 4*t**8 - 36*t**7 - 32*t**6
        + 54*t**5 + 80*t**4 - 13*t**3 - 46*t**2 - 8*t + 1)

print("m_mu(T) =", m_mu)
print("m_mu irreducible over Q =", m_mu.is_irreducible())
assert m_mu.is_irreducible()

m_mu_divides = (E % m_mu == 0)
print("m_mu divides E(T) =", m_mu_divides)
assert m_mu_divides, "Presentation-derived E(T) is not divisible by m_mu."

multiplicity = 0
complement = E
while complement % m_mu == 0:
    complement = complement // m_mu
    multiplicity += 1

print("valuation v_m_mu(E) =", multiplicity)
print("full complementary factor C(T)=E/m_mu^v degree =", complement.degree())
print("C(T) =", complement)
print("C(T) coefficient-text SHA256 =", sha256_text(complement))
print("gcd(m_mu,C) =", gcd(m_mu, complement))
assert gcd(m_mu, complement) == 1


# ---------------------------------------------------------------------------
# STEP 5: Certified geometric trace interval for mu=Abb (not the old T_a).
# ---------------------------------------------------------------------------

banner("CERTIFIED GEOMETRIC mu-TRACE AND FACTOR SELECTION")
import snappy

BITS_PREC = 300
Mgeom = snappy.Manifold("m006(-5,2)")
ok, rho = Mgeom.verify_hyperbolicity(holonomy=True, bits_prec=BITS_PREC)
print("verify_hyperbolicity(holonomy=True, bits_prec=%d) =" % BITS_PREC, ok)
assert ok

T_mu = rho(mu).trace()
print("certified T_mu = tr(rho('%s')) =" % mu, T_mu)
print("T_mu real diameter =", T_mu.real().diameter())
print("T_mu imag diameter =", T_mu.imag().diameter())

# Certify irreducibility of the geometric character.  This justifies the
# standard two-generator representation-chart theorem used here: an
# irreducible SL_2 character (x,y,z) is represented, over an algebraic
# closure, by the exact A,B chart above for a root of u^2+z*u+1.
x_iv = rho("a").trace()
y_iv = rho("b").trace()
z_iv = rho("ab").trace()
irreducibility_discriminant = (x_iv**2 + y_iv**2 + z_iv**2
                               - x_iv*y_iv*z_iv - 4)
print("irreducibility discriminant interval =", irreducibility_discriminant)
disc_excludes_zero = not complex_interval_contains_zero(
    irreducibility_discriminant
)
print("irreducibility discriminant excludes 0 =", disc_excludes_zero)
assert disc_excludes_zero

CIF = ComplexIntervalField(BITS_PREC)
RIF = RealIntervalField(BITS_PREC)
m_mu_CIF = m_mu.change_ring(CIF)
m_mu_prime_CIF = m_mu_CIF.derivative()

delta = RIF(2)**(-BITS_PREC + 20)
pad = RIF(-1, 1) * delta
box = CIF(T_mu.real() + pad, T_mu.imag() + pad)


def strictly_contained(inner, outer):
    return (inner.real().lower() > outer.real().lower()
            and inner.real().upper() < outer.real().upper()
            and inner.imag().lower() > outer.imag().lower()
            and inner.imag().upper() < outer.imag().upper())


mid_re = (box.real().lower() + box.real().upper()) / 2
mid_im = (box.imag().lower() + box.imag().upper()) / 2
mid = CIF(mid_re, mid_im)
N_box = mid - m_mu_CIF(mid) / m_mu_prime_CIF(box)
contracted = strictly_contained(N_box, box)

print("widened certified T_mu box =", box)
print("m_mu interval-Newton N(box) =", N_box)
print("N(box) strictly contained in box =", contracted)
assert contracted, "Could not isolate a unique m_mu root in the T_mu box."

complement_CIF = complement.change_ring(CIF)
complement_at_box = complement_CIF(box)
complement_excludes_zero = not complex_interval_contains_zero(complement_at_box)
print("C(T_mu box) =", complement_at_box)
print("C(T_mu box) excludes 0 =", complement_excludes_zero)
assert complement_excludes_zero, (
    "Direct interval evaluation did not exclude the full complementary "
    "factor on the geometric T_mu box."
)


# ---------------------------------------------------------------------------
# STEP 6: Final scope-controlled conclusion.
# ---------------------------------------------------------------------------

banner("CERTIFICATE SUMMARY")
print("E(T) derived from presentation only: YES")
print("m_mu divides E(T):", m_mu_divides)
print("v_m_mu(E):", multiplicity)
print("T_mu box contains exactly one m_mu root: YES")
print("T_mu box contains no root of E/m_mu^v: YES")
print("m_mu NEVER inserted into presentation ideal: YES")
print("geometric character irreducible / chart applicable: YES")
print("CONCLUSION: m_mu(tr rho_geom(mu)) = 0")
print("PROVENANCE: exact presentation elimination + verified interval arithmetic;")
print("            no algdep, PSLQ, or numerical polynomial recognition used")
print("INDEPENDENT DERIVATION CERTIFICATE: PASS")
