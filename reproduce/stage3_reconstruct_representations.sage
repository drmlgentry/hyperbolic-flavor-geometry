#!/usr/bin/env sage
"""Exact Stage 3 representation-lift audit certificate.

This checks only the m006 presentation, peripheral words, exact character
coordinates, and uniform representation reconstruction.  It does not
enumerate the frozen experimental words, compute a collision partition, or
test a selector.
"""

from sage.all import *


# ---------------------------------------------------------------------------
# Exact cubic trace field
# ---------------------------------------------------------------------------
R.<X> = PolynomialRing(QQ)
q = X^3 + X^2 - X - 2
assert q.is_irreducible()
assert q.discriminant() == -59
K.<u> = NumberField(q)

# Link to the source builder's field K0=Q(t), u=t^2+1.
K0.<t> = NumberField(X^3 + 2*X + 1)
assert (t^2 + 1).minpoly().list() == q.list()


# ---------------------------------------------------------------------------
# Exact character surface and peripheral trace polynomials
# ---------------------------------------------------------------------------
def character_surface(x, y, z):
    return (-y*(x^3*y*z - x^2*y^2*z^2 + x^2*y^2 - 2*x^2
                + x*y*z^3 - 2*x*y*z + y^2*z^2 - y^2
                - 2*z^2 + 3) - 2)


def tr_mu(x, y, z):
    # mu = Abb
    return x*y^2 - x - y*z


def tr_lambda(x, y, z):
    # lambda = AAbA, cyclically equivalent for trace to b*a^-3
    return x^3*y - x^2*z - 2*x*y + z


x = u
y = u + 1
z = u

assert character_surface(x, y, z) == 0
assert tr_mu(x, y, z) == 2
assert tr_lambda(x, y, z) == -2

# Exact uniqueness for fixed x=u and the two peripheral trace signs.
PY.<Y> = PolynomialRing(K)
peripheral_y_equation = u*Y^2 - 2*Y - u^2
y1 = u + 1
y2 = u^2 - 2
assert peripheral_y_equation == u*(Y-y1)*(Y-y2)

def z_from_mu(y_value):
    return (u*y_value^2 - u - 2) / y_value

z1 = z_from_mu(y1)
z2 = z_from_mu(y2)
assert z1 == u
assert z2 == u + 4
assert tr_lambda(u, y1, z1) == -2
assert tr_lambda(u, y2, z2) == -2
assert character_surface(u, y1, z1) == 0
assert character_surface(u, y2, z2) == -16*(u+4)
assert character_surface(u, y2, z2) != 0

# Irreducible character criterion.
reducibility_discriminant = x^2 + y^2 + z^2 - x*y*z - 4
assert reducibility_discriminant == 3*u^2 + u - 5
assert reducibility_discriminant != 0


# ---------------------------------------------------------------------------
# Uniform companion-gauge reconstruction
# ---------------------------------------------------------------------------
PS.<S> = PolynomialRing(K)
s_polynomial = S^2 - u*S + 1
assert s_polynomial.is_irreducible()
E.<s> = K.extension(s_polynomial)

A = matrix(E, [[u, -1], [1, 0]])
B = matrix(E, [[0, s], [s-u, u+1]])
I2 = identity_matrix(E, 2)

assert A.det() == 1
assert B.det() == 1
assert A.trace() == u
assert B.trace() == u + 1
assert (A*B).trace() == u


def eval_word(word, a_matrix=A, b_matrix=B):
    letters = {
        'a': a_matrix,
        'b': b_matrix,
        'A': a_matrix.inverse(),
        'B': b_matrix.inverse(),
    }
    value = I2
    for letter in word:
        value *= letters[letter]
    return value


relator = 'ababbAAbb'
meridian = 'Abb'
longitude = 'AAbA'

assert eval_word(relator) == I2
MU = eval_word(meridian)
LAMBDA = eval_word(longitude)
assert MU.trace() == 2
assert LAMBDA.trace() == -2
assert MU*LAMBDA == LAMBDA*MU


# ---------------------------------------------------------------------------
# Central spin/lift twist chi(a)=1, chi(b)=0
# ---------------------------------------------------------------------------
At = -A
Bt = B
assert eval_word(relator, At, Bt) == I2
assert At.trace() == -u
assert Bt.trace() == u + 1
assert (At*Bt).trace() == -u
assert eval_word(meridian, At, Bt).trace() == -2
assert eval_word(longitude, At, Bt).trace() == 2


print('='*78)
print('STAGE 3 REPRESENTATION-LIFT AUDIT — EXACT CERTIFICATE PASS')
print('='*78)
print('q(u) =', q)
print('disc(q) =', q.discriminant())
print('base character (tr A, tr B, tr AB) =', (u, u+1, u))
print('base peripheral traces =', (MU.trace(), LAMBDA.trace()))
print('twisted character =', (-u, u+1, -u))
print('twisted peripheral traces =',
      (eval_word(meridian, At, Bt).trace(),
       eval_word(longitude, At, Bt).trace()))
print('relator and peripheral commutation checks: PASS')
print('irreducibility discriminant =', reducibility_discriminant)
print('alternate peripheral branch rejected by surface =',
      character_surface(u, y2, z2))
print()
print('CLASSIFICATION: CHARACTER DETERMINED / REPRESENTATION RECONSTRUCTIBLE')
print('VERDICT: SHORT-WORD TRACES ARE FUNCTIONS OF EXISTING CHARACTER DATA')
print('PROJECTIVE CONSEQUENCE: central spin-twist pairs are identical in PGL2')
print('='*78)

