# Exact algebraic investigation: is tr^2(rho(B)) = tr^2(rho(Abb)) (found
# numerically by m003_structure_atlas.sage, exactly at m003(-2,3), nowhere
# close at 12 other checked fillings/the cusp) a generic identity on the
# m003 character variety (Riley surface), or specific to the (-2,3)
# filling? Pure exact Fricke/commutative algebra throughout -- no
# polished_holonomy, no floating point, as requested.
#
# Same rank-2 Fricke chart as ckm_presentation_elimination.sage /
# pmns_itf_certificate.sage: A=[[x,-1],[1,0]] (tr=x), B=[[0,-u],[uinv,y]]
# (tr=y), uinv=-z-u from det relation u^2+z*u+1=0, giving tr(AB)=z.

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


def inverse_word(word):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(word))


def banner(t):
    print("\n" + "=" * 78)
    print(t)
    print("=" * 78)


det_relation = u**2 + z*u + 1

banner("STEP 1: exact tr(B), tr(Abb) as polynomials in x,y,z")
MB = word_matrix("b")
trB_raw = MB[0, 0] + MB[1, 1]
print("tr(B) raw =", trB_raw, " (matches y trivially:", trB_raw == y, ")")

MAbb = word_matrix("Abb")
trAbb_raw = MAbb[0, 0] + MAbb[1, 1]
det_ideal = R.ideal([det_relation])
trAbb = det_ideal.reduce(trAbb_raw)
assert trAbb.degree(u) == 0, "tr(Abb) unexpectedly still depends on u"
print("tr(Abb) reduced (pure x,y,z) =", trAbb)

banner("STEP 2: exact m003 relator (from SnapPy, not assumed) -- the")
print("presentation-only Riley variety, no filling imposed")
relator = "abAAbabbb"  # independently pulled from SnapPy this session, verified
Mr = word_matrix(relator)
gens_riley = [det_relation] + list((Mr - I2).list())
I_riley = R.ideal(gens_riley)
Iel_riley = I_riley.elimination_ideal([u])
print("Riley variety (presentation only) generators, pure x,y,z:")
for g in Iel_riley.gens():
    print(" ", g)

diff = R(y**2 - trAbb**2)
print()
print("y^2 - tr(Abb)^2 =", diff.factor())
reduced_on_riley = Iel_riley.reduce(diff)
identity_on_riley = (reduced_on_riley == 0)
print("reduces to 0 on the general Riley variety (i.e. an identity for")
print("EVERY representation of m003, not filling-specific)?", identity_on_riley)
assert not identity_on_riley, (
    "Unexpected: this would mean the degeneracy is generic, not "
    "filling-specific -- contradicts the atlas's own finding that only "
    "(-2,3) shows it numerically."
)

banner("STEP 3: exact locus -- impose the (-2,3) filling and test both signs")
mu, longitude = "ABABB", "ABAbab"  # SnapPy peripheral words, verified this session
filling_word = inverse_word(mu) * 2 + longitude * 3
Ms = word_matrix(filling_word)
gens_filled = gens_riley + list((Ms - I2).list())
I_filled = R.ideal(gens_filled)
Iel_filled = I_filled.elimination_ideal([u])
filled_gens = list(Iel_filled.gens())
print("m003(-2,3) filled character variety, generators (pure x,y,z):")
for g in filled_gens:
    print(" ", g)

results = {}
for label, extra in [("y - tr(Abb)", y - trAbb), ("y + tr(Abb)", y + trAbb)]:
    I_test = R.ideal(gens_filled + [extra])
    Iel_test = I_test.elimination_ideal([u])
    is_unit = (R(1) in Iel_test)
    unchanged = (set(Iel_test.gens()) == set(Iel_filled.gens())) if not is_unit else False
    # More robust than set-equality of generator lists: compare ideals directly.
    same_ideal = (not is_unit) and (Iel_test == Iel_filled)
    results[label] = (is_unit, same_ideal)
    print()
    print("condition:", label, "= 0")
    print("  forces the UNIT ideal (no solution at all)?", is_unit)
    print("  leaves the filled variety UNCHANGED (exact consequence of",
          "relator+filling alone, holds at every point)?", same_ideal)

banner("CONCLUSION")
minus_unit, minus_same = results["y - tr(Abb)"]
plus_unit, plus_same = results["y + tr(Abb)"]
assert not minus_unit and minus_same, "y=tr(Abb) case did not come out as expected"
assert plus_unit, "y=-tr(Abb) case did not come out as expected"

print("tr^2(B) = tr^2(Abb) is NOT an identity on the general m003 Riley")
print("variety -- it is FILLING-SPECIFIC to (-2,3), confirmed exactly.")
print()
print("Stronger than the atlas's numeric finding: the UNSQUARED identity")
print("tr(B) = tr(Abb) (not just tr^2) is an EXACT ALGEBRAIC CONSEQUENCE")
print("of the presentation relator + the (-2,3) filling relation alone --")
print("it holds at EVERY point of the filled character variety (all")
print("Galois conjugates, not just the discrete-faithful geometric point),")
print("proved by exact ideal containment, no floating point anywhere in")
print("this step. The opposite sign tr(B)=-tr(Abb) is exactly impossible")
print("(forces the unit ideal).")
print()
print("RILEY IDENTITY INVESTIGATION: COMPLETE")
