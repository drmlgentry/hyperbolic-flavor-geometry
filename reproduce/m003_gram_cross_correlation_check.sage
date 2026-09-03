# Tests one well-posed, exact sub-question from a relayed proposal that is
# independent of that proposal's construction mismatch (see
# pmns_borel_flexibility_audit.py for that correction): does the proven
# universal identity tr^2(AAb)=tr^2(AABB) on X_0 extend to a stronger
# cross-correlation identity
#
#   Xi(AAb, w) =? Xi(AABB, w)   for w in {aa, baa}
#
# where Xi(A,B) = (2z-xy)^2 / ((x^2-4)(y^2-4)), x=tr(A), y=tr(B), z=tr(AB)
# -- the squared normalized SL2 Killing-type correlation between A,B
# (sign-independent, so insensitive to the C_+/C_- split). First verifies
# the Xi formula itself symbolically (2z-xy = 2*tr(A_0 B_0) for traceless
# parts A_0,B_0), rather than trusting the relayed formula uncritically.

from sage.all import *

R = PolynomialRing(QQ, names=("x", "y", "z", "u"), order="degrevlex")
x, y, z, u = R.gens()

A = matrix(R, [[x, -1], [1, 0]])
uinv = -z - u
B = matrix(R, [[0, -u], [uinv, y]])
I2 = identity_matrix(R, 2)


def inv_sl2(M):
    return matrix(R, [[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


Ai = inv_sl2(A)
Bi = inv_sl2(B)
MATS = {"a": A, "A": Ai, "b": B, "B": Bi}


def word_matrix(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    return M


def banner(t):
    print("\n" + "=" * 78)
    print(t)
    print("=" * 78)


det_relation = u**2 + z*u + 1
det_ideal = R.ideal([det_relation])

banner("STEP 0: verify the Xi formula itself, symbolically")
# For generic A,B (using the SAME a,b generator matrices), check
# 2*tr(AB) - tr(A)*tr(B) == 2*tr(A0*B0) where A0=A-tr(A)/2*I, B0=B-tr(B)/2*I.
A0 = A - (x/2) * I2
B0 = B - (y/2) * I2
lhs = 2*z - x*y
rhs_raw = 2*(A0*B0)[0, 0] + 2*(A0*B0)[1, 1]  # 2*tr(A0*B0)
rhs = det_ideal.reduce(rhs_raw)
print("2z - xy =", lhs)
print("2*tr(A0*B0) reduced =", rhs)
print("formula verified (lhs == rhs)?", R(lhs - rhs) == 0)
assert R(lhs - rhs) == 0

banner("STEP 1: exact trace formulas for the relevant words")
words_needed = ["aa", "baa", "AAb", "AABB"]
tr_word = {}
for w in words_needed:
    M = word_matrix(w)
    tr_word[w] = det_ideal.reduce(M[0, 0] + M[1, 1])
    print("tr(%s) =" % w, tr_word[w])


def z_of(w1, w2):
    """tr(w1*w2), used as the 'z' Fricke coordinate for the pair (w1,w2)."""
    M = word_matrix(w1) * word_matrix(w2)
    return det_ideal.reduce(M[0, 0] + M[1, 1])


def Xi(w1, w2):
    xw = tr_word[w1]
    yw = tr_word[w2]
    zw = z_of(w1, w2)
    num = R((2*zw - xw*yw)**2)
    den = R((xw**2 - 4) * (yw**2 - 4))
    return num, den


banner("STEP 2: bare Riley variety (relator only), identify X_0")
relator = "abAAbabbb"
Mr = word_matrix(relator)
gens_riley = [det_relation] + list((Mr - I2).list())
I_riley = R.ideal(gens_riley)
Iel_riley = I_riley.elimination_ideal([u])
S3 = PolynomialRing(QQ, names=("x", "y", "z"))
sx, sy, sz = S3.gens()
phi3 = R.hom([sx, sy, sz, S3(0)], S3)
Iriley_3 = S3.ideal([phi3(g) for g in Iel_riley.gens()])
PD = Iriley_3.primary_decomposition()
print("bare Riley variety components:", len(PD))
X0 = None
for i, comp in enumerate(PD):
    print(" component", i, "dim =", comp.dimension(), " gens =", list(comp.gens()))
    if comp.dimension() >= 1:
        X0 = comp
assert X0 is not None
print("X_0 (positive-dimensional component) identified.")

banner("STEP 3: test Xi(AAb,w) =? Xi(AABB,w) on X_0, for w in {aa, baa}")
for w in ["aa", "baa"]:
    num1, den1 = Xi("AAb", w)
    num2, den2 = Xi("AABB", w)
    # Xi1 - Xi2 = num1/den1 - num2/den2 = (num1*den2 - num2*den1) / (den1*den2)
    # test the numerator of the difference (cross-multiplied) for vanishing
    # on X_0 -- avoids division in the polynomial ring.
    diff_num = R(num1 * den2 - num2 * den1)
    diff_num_3 = S3(phi3(diff_num))
    reduced = X0.reduce(diff_num_3)
    print(f"Xi(AAb,{w}) vs Xi(AABB,{w}): cross-multiplied difference reduces to",
          reduced, " -- identical on X_0?", reduced == 0)
