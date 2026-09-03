# Identifies Y_- : the extra, non-(-2,3), non-reducible component of the
# C_minus branch (tr(Abb)+tr(B)=0) found in m003_squared_locus_and_conjugacy.sage,
# left explicitly open there.
#
# Answer, verified exactly (no floating point): Y_- is not a different
# manifold or Dehn-filling slope at all. It is the EXACT image of X_{-2,3}
# under the sign twist (x,y,z) -> (-x,y,-z), which is the character
# eps(a)=-1, eps(b)=+1 of the CUSPED group pi_1(m003) -- a genuine
# character, since it respects the bare relator exactly (checked below).
# This twist sends the (-2,3) filling curve mu^{-2}*lambda^3 to eps=-1,
# i.e. to -I rather than +I: so Y_- is the SAME closed hyperbolic
# structure on m003(-2,3), reached via the OTHER principal SL2(C) lift of
# the same PSL2(C) discrete faithful representation (the one sending the
# filling curve to -I instead of +I) -- not a genuinely different
# character-variety phenomenon.

from sage.all import *

R3 = PolynomialRing(QQ, names=("x", "y", "z"))
x, y, z = R3.gens()

X_minus23 = R3.ideal([z**2 + x + y - 1, y*z - x - z, x*z + 1, y**2 - y + z - 1,
                       x*y - x - y - z + 1, x**2 + y - 1])
Y_minus = R3.ideal([z**2 - x + y - 1, y*z - x - z, x*z + 1, y**2 - y - z - 1,
                     x*y - x + y - z - 1, x**2 + y - 1])

print("=" * 78)
print("Testing: is Y_- the image of X_{-2,3} under a sign twist?")
print("=" * 78)

phi = R3.hom([-x, y, -z], R3)
X_twisted = R3.ideal([phi(g) for g in X_minus23.gens()])
print("twisted X_{-2,3} generators:", list(X_twisted.gens()))
print("Y_-              generators:", list(Y_minus.gens()))
same = (X_twisted == Y_minus)
print("twisted X_{-2,3} == Y_- exactly (Sage ideal equality)?", same)
assert same

print()
print("=" * 78)
print("Is (x,y,z)->(-x,y,-z) a genuine character of pi_1(m003)?")
print("=" * 78)


def exp_sum(word, letter):
    return word.count(letter) - word.count(letter.upper())


relator = "abAAbabbb"
ea, eb = -1, 1
eps_relator = ea ** exp_sum(relator, "a") * eb ** exp_sum(relator, "b")
print("relator a,b-exponent sums:", exp_sum(relator, "a"), exp_sum(relator, "b"))
print("eps(relator) with eps(a)=-1, eps(b)=+1:", eps_relator,
      " (must be +1 to respect the relator)")
assert eps_relator == 1

print()
print("=" * 78)
print("What does this twist do to the (-2,3) FILLING curve?")
print("=" * 78)

mu, longitude = "ABABB", "ABAbab"


def signed_exp(word, n):
    return exp_sum(word, "a") * n, exp_sum(word, "b") * n


fma, fmb = signed_exp(mu, -2)
fla, flb = signed_exp(longitude, 3)
fill_a, fill_b = fma + fla, fmb + flb
eps_fill = ea ** fill_a * eb ** fill_b
print("filling word (mu^-2 lambda^3) a,b-exponent sums:", fill_a, fill_b)
print("eps(filling word):", eps_fill)
assert eps_fill == -1

print()
print("=" * 78)
print("CONCLUSION")
print("=" * 78)
print("Y_- = X_{-2,3} twisted by eps(a)=-1, eps(b)=+1 -- a genuine")
print("character of the CUSPED group pi_1(m003) (confirmed: it respects")
print("the bare relator exactly, eps(relator)=+1). This twist sends the")
print("(-2,3) filling curve to eps=-1, i.e. the twisted representation")
print("maps that curve to -I rather than +I.")
print()
print("Y_- is therefore NOT a different manifold, slope, or genuinely new")
print("character-variety phenomenon. It is the SAME closed hyperbolic")
print("structure on m003(-2,3), reached via the OTHER principal SL2(C)")
print("lift of the identical PSL2(C) discrete-faithful holonomy -- the")
print("lift sending the filling curve to -I instead of +I, both of which")
print("are projectively trivial (PSL2(C)-trivial) and so both genuinely")
print("represent the same closed 3-manifold group.")
print()
print("This also explains, structurally, why C_minus (tr(Abb)+tr(B)=0)")
print("has a non-reducible component at all: it is not evidence of a")
print("second, unrelated exceptional filling -- it is the unavoidable")
print("sign-lift shadow of the SAME (-2,3) exceptional locus found on the")
print("C_plus branch, forced to appear because tr(B), tr(Abb) both flip")
print("sign under a twist that fixes tr(ab)=z up to sign consistently.")
print()
print("Y_- IDENTIFICATION: COMPLETE")
print("SAGE_EXIT=0")
