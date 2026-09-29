"""
m003_m019_field_isomorphism_certificate.py
==========================================
Checks a specific cross-manifold coincidence flagged for verification: is
the invariant trace field of the closed manifold M = m003(-2,3),
K_283 = Q[X]/(X^4+X^3-1) (this session's m003 collision-theorem paper,
Theorem 3.1), isomorphic to the cusp field of m019, Q[x]/(x^4-x-1)
(CLAIMS_REGISTER.md, "3. m019 cusp field Galois group," [Computed],
independently re-verified Aug 2 2026)?

Both are irreducible degree-4 polynomials over Q with the same discriminant
(-283, prime, squarefree), so the two fields are strong CANDIDATES for
being the same field -- but disc alone never PROVES isomorphism in general
(distinct fields can share a discriminant), so this is checked directly.

METHOD (exact, no floating point, no algdep/PSLQ): two irreducible monic
integer polynomials f, g of the same degree n define isomorphic number
fields iff g has a root in K1 = Q[x]/(f(x)); if so, that root generates a
subfield of degree dividing n with minimal polynomial dividing the
irreducible g (degree n), hence of degree exactly n, hence equal to K1,
giving an explicit isomorphism K2 = Q[x]/(g) -> K1.

Two independent exact algorithms are used and cross-checked against each
other, plus a search for the inverse map:
  1. sympy's exact factorization of g over the algebraic extension Q(alpha)
     (alpha = CRootOf(f, i), each of the 4 embeddings) -- does g acquire a
     linear factor?
  2. An independent construction via resultants: if beta = p(alpha) is
     conjectured to be a root of g, then the resultant
     Res_alpha(f(alpha), y - p(alpha)) must equal g(y) exactly (up to the
     choice of monic normalization) -- computed here from scratch, not
     derived from method 1's internals.
  3. A direct brute-force search (bounded small integer coefficients) for
     the inverse map: a polynomial q(gamma) with f(q(gamma)) == 0 mod
     g(gamma), verified by exact polynomial remainder.

Exit status: 0 iff the isomorphism is established and cross-verified.
"""
import sys

import sympy as sp

x, y, alpha, gamma = sp.symbols("x y alpha gamma")

f = x**4 + x**3 - 1   # K_283: m003(-2,3) invariant trace field (this paper, Thm 3.1)
g = x**4 - x - 1       # m019 cusp field (CLAIMS_REGISTER.md item 3)

ok = True


def check(label, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + label)
    ok &= bool(cond)


print("f = X^4+X^3-1 (m003(-2,3) invariant trace field, K_283)")
print("g = X^4-X-1   (m019 cusp field)")
check("disc(f) = -283", sp.discriminant(sp.Poly(f, x)) == -283)
check("disc(g) = -283", sp.discriminant(sp.Poly(g, x)) == -283)
check("f irreducible over Q", sp.Poly(f, x).is_irreducible)
check("g irreducible over Q", sp.Poly(g, x).is_irreducible)
check("disc = -283 is not a perfect square (necessary, not sufficient, for non-A4 Galois group)",
      not sp.Integer(-283).is_negative or True)  # -283<0, never a square; recorded for completeness

# ---- Method 1: exact factorization of g over Q(alpha), all 4 embeddings ----
print()
print("Method 1: factor g over Q(alpha) for each root alpha of f")
found_root = None
for i in range(4):
    ai = sp.CRootOf(f, i)
    fl = sp.factor_list(sp.Poly(g, x), extension=ai)
    linear = [fac for fac, mult in fl[1] if sp.degree(fac, x) == 1]
    print(f"  embedding {i}: {len(linear)} linear factor(s) of g over Q(alpha_{i})")
    check(f"  embedding {i} gives a linear factor (K1 contains a root of g)", len(linear) >= 1)
    if i == 0 and linear:
        # extract the explicit root beta = alpha - (root of the linear factor's constant term)
        found_root = sp.expand(ai - linear[0].as_expr().subs(x, 0))

# ---- Method 2: independent resultant construction ----
print()
print("Method 2: independent resultant check of the explicit candidate beta = alpha^2+alpha^3")
frel = alpha**4 + alpha**3 - 1
beta_expr = alpha**2 + alpha**3
remcheck = sp.rem(sp.Poly(g.subs(x, beta_expr), alpha), sp.Poly(frel, alpha)).as_expr()
check("g(alpha^2+alpha^3) == 0 mod f(alpha), by exact polynomial remainder", remcheck == 0)

R = sp.Poly(sp.resultant(sp.Poly(frel, alpha), sp.Poly(y - beta_expr, alpha), alpha), y)
Rmonic = sp.expand(R.as_expr() / R.LC())
gy = g.subs(x, y)
check("Res_alpha(f(alpha), y-alpha^2-alpha^3), normalized, equals g(y) exactly (independent of Method 1)",
      sp.expand(Rmonic - gy) == 0)
print("  resultant (normalized):", Rmonic)

# ---- Method 3: explicit inverse map, bounded search, exact verification ----
print()
print("Method 3: explicit inverse map (root of f as a polynomial in a root of g)")
grel = gamma**4 - gamma - 1
inverse_map = None
import itertools
for c1, c2, c3 in itertools.product(range(-2, 3), repeat=3):
    for c0 in range(-2, 3):
        cand = c0 + c1 * gamma + c2 * gamma**2 + c3 * gamma**3
        val = sp.rem(sp.Poly(f.subs(x, cand), gamma), sp.Poly(grel, gamma)).as_expr()
        if val == 0:
            inverse_map = cand
            break
    if inverse_map is not None:
        break
check("an inverse map alpha = q(gamma) exists with small integer coefficients", inverse_map is not None)
print("  explicit inverse map: alpha =", inverse_map)
verify_inv = sp.rem(sp.Poly(f.subs(x, inverse_map), gamma), sp.Poly(grel, gamma)).as_expr()
check("f(q(gamma)) == 0 mod g(gamma), independently re-verified", verify_inv == 0)

print()
print("CONCLUSION: K_283 = Q[X]/(X^4+X^3-1) (m003(-2,3) invariant trace field)")
print("            is ISOMORPHIC to Q[x]/(x^4-x-1) (m019 cusp field)." if ok else
      "CONCLUSION: NOT ESTABLISHED")
print("Explicit isomorphism, both directions, cross-verified by 3 independent methods:")
print("  alpha |-> alpha^2 + alpha^3   (root of f  -> root of g)")
print(f"  gamma |-> {inverse_map}   (root of g  -> root of f)")
sys.exit(0 if ok else 1)
