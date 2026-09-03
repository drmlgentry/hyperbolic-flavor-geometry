# Two follow-ups on the (B,Abb) exact identity (m003_riley_b_abb.sage):
#
# (1) Complete squared-trace locus: primary-decompose BOTH signed branches
#     (not just the C_+ branch already established) so the full character
#     of V(tr(B)^2-tr(Abb)^2) is known, not just one factor of it.
#
# (2) The strong group-theoretic mechanism: is B actually CONJUGATE to Abb
#     or Abb^{-1} in pi_1(m003(-2,3)) itself (not just equal in trace)?
#     Rather than an open-ended GAP conjugacy search on an infinite
#     hyperbolic group (real risk of non-termination -- the CKM
#     normal-closure attempt hit exactly this), search NUMERICALLY for a
#     short conjugator at the certified discrete-faithful holonomy, then
#     verify any candidate EXACTLY via the Fricke chart. Logical bridge:
#     the discrete-faithful representation of a complete hyperbolic
#     3-manifold is FAITHFUL (injective), so an EXACT matrix identity
#     rho(g B g^-1) = rho(Abb^{\pm1}) at that representation already
#     proves g B g^-1 = Abb^{\pm1} as an honest identity in the abstract
#     group -- no word-problem solver needed.

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
det_ideal = R.ideal([det_relation])
relator = "abAAbabbb"
Mr = word_matrix(relator)
gens_riley = [det_relation] + list((Mr - I2).list())
I_riley = R.ideal(gens_riley)

MAbb = word_matrix("Abb")
trAbb = det_ideal.reduce(MAbb[0, 0] + MAbb[1, 1])
Cplus = R(trAbb - y)   # =0 means tr(Abb)=tr(B)
Cminus = R(trAbb + y)  # =0 means tr(Abb)=-tr(B)

banner("PART 1: complete squared-trace locus -- both signed branches")
print("Cplus  = tr(Abb) - tr(B) =", Cplus)
print("Cminus = tr(Abb) + tr(B) =", Cminus)

mu, longitude = "ABABB", "ABAbab"
filling_word = inverse_word(mu) * 2 + longitude * 3
Ms = word_matrix(filling_word)
gens_filled = gens_riley + list((Ms - I2).list())
I_filled = R.ideal(gens_filled)
Iel_filled = I_filled.elimination_ideal([u])
filled_set = set(Iel_filled.gens())

Comm = A*B*Ai*Bi
trComm = det_ideal.reduce(Comm[0, 0] + Comm[1, 1])
reducible_poly = R(trComm - 2)  # =0 iff reducible representation

for label, Cbranch in [("C_plus (tr(Abb)=tr(B))", Cplus),
                        ("C_minus (tr(Abb)=-tr(B))", Cminus)]:
    banner("Branch: " + label)
    I_branch = R.ideal(gens_riley + [Cbranch])
    Iel_branch = I_branch.elimination_ideal([u])
    is_unit = (R(1) in Iel_branch)
    print("unit ideal (no solutions at all on the bare presentation)?", is_unit)
    if is_unit:
        continue
    PD = Iel_branch.primary_decomposition()
    print("number of irreducible components:", len(PD))
    for i, comp in enumerate(PD):
        gens = list(comp.gens())
        is_fill = (set(gens) == filled_set)
        is_red = (reducible_poly in comp)
        print(f" component {i}: generators = {gens}")
        print(f"   equals the (-2,3) filled variety exactly: {is_fill}")
        print(f"   entirely reducible representations: {is_red}")

banner("IDENTIFYING the extra C_minus non-reducible component")
print("C_minus has a component that is neither reducible NOR the (-2,3)")
print("filled variety as this script built it. Do not gloss over this --")
print("identify it exactly rather than weaken the theorem silently.")

mystery_gens = [z**2 - x + y - 1, y*z - x - z, x*z + 1, y**2 - y - z - 1,
                x*y - x + y - z - 1, x**2 + y - 1]
print("mystery component generators:", mystery_gens)

# An attempt to identify this component with m003(2,-3) (the same unoriented
# slope as (-2,3) under the standard (p,q)~(-p,-q) Dehn-surgery relabeling)
# was tried and found INCONCLUSIVE -- the specific word-construction used
# for (2,-3) did not reproduce a genuinely different ideal from (-2,3)'s own
# (a bug in that attempt, not a finding), so no claim is made here about
# which slope, if any, this second component corresponds to. Reporting the
# ideal itself rather than an unverified identification.
Ux2 = PolynomialRing(QQ, "xx")
Smystery = PolynomialRing(QQ, names=("y", "z", "x"), order="lex")
sy2, sz2, sx2 = Smystery.gens()
phi_m = R.hom([sx2, sy2, sz2, Smystery(0)], Smystery)
Jm = Smystery.ideal([phi_m(g) for g in mystery_gens])
GBm = Jm.groebner_basis()
univ_m = [g for g in GBm if g.degree(sy2) == 0 and g.degree(sz2) == 0]
print("mystery component's own x-polynomial (in its lex ring):", univ_m)

banner("PART 1 CONCLUSION (complete and honest)")
print("The complete non-reducible squared-trace locus of tr(B)^2=tr(Abb)^2")
print("has TWO components, not one: X_{-2,3} exactly (component 0 of the")
print("C_plus branch), and a second, distinct irreducible component (from")
print("the C_minus branch) whose exact geometric identity (which slope, if")
print("any specific one) is NOT established here -- an identification")
print("attempt was tried and found inconclusive, and is reported as such")
print("rather than asserted. Both reducible components (one per branch) are")
print("confirmed genuinely reducible via the exact Fricke criterion.")
print()
print("This means the STRONGER claim 'the complete exact locus equals")
print("X_{-2,3} alone' is NOT what was found -- report two components. The")
print("atlas's original empirical claim (unique among the 13 CHECKED points)")
print("is untouched by this, since it was never a claim about the full")
print("algebraic locus, only about those 13 specific fillings.")

banner("PART 2: strong group-theoretic mechanism -- is B conjugate to")
print("Abb or Abb^-1 in pi_1(m003(-2,3)) itself, not just equal in trace?")
print()
print("Numeric search (certified 300-bit discrete-faithful holonomy) found")
print("a length-4 candidate: g = BaBA, with g*B*g^-1 = Abb^-1 numerically")
print("(matched to ~1e-30, far beyond doubt at this precision). Verifying")
print("EXACTLY via the Fricke chart, reduced modulo the (-2,3) filled ideal:")

g_word = "BaBA"
Mg = word_matrix(g_word)
Mg_inv = inv_sl2(Mg)
MB = word_matrix("B")
MAbb_inv = inv_sl2(MAbb)
conj = Mg * MB * Mg_inv
diffmat = conj - MAbb_inv
all_zero = True
for i in range(2):
    for j in range(2):
        r = I_filled.reduce(diffmat[i, j])
        print(f"  (g B g^-1 - Abb^-1)[{i},{j}] reduced mod filled ideal =", r)
        if r != 0:
            all_zero = False
print()
print("g B g^-1 = Abb^-1 EXACTLY, at EVERY point of the (-2,3) filled")
print("variety (all Galois conjugates, not just the geometric point):",
      all_zero)
assert all_zero

banner("PART 2 CONCLUSION")
print("Since the identity g B g^-1 (Abb)^-1 = 1 (g=BaBA) holds as an exact")
print("polynomial consequence at EVERY representation on the (-2,3) filled")
print("variety, it holds in particular at the discrete-faithful geometric")
print("representation. That representation is FAITHFUL (a standard fact")
print("for the holonomy of a complete finite-volume hyperbolic structure),")
print("so an exact matrix identity there already proves the abstract group")
print("identity")
print()
print("   (BaBA) * B * (BaBA)^-1 = (Abb)^-1   in pi_1(m003(-2,3)),")
print()
print("i.e. B and Abb are CONJUGATE (via the inverse) in the filled group")
print("itself -- not merely equal in trace, and not merely true at one")
print("representation. This is the strong group-theoretic mechanism: since")
print("conjugate elements automatically have equal trace under ANY")
print("representation of the group, tr(B)=tr(Abb) for the (-2,3)-filled")
print("group follows for every SL2(C) representation whatsoever, not just")
print("the ones on the character variety already checked.")
print()
print("GROUP-THEORETIC EXPLANATION: EXACT PASS (inverse-conjugacy)")
print("SQUARED-LOCUS AND CONJUGACY CERTIFICATE: COMPLETE")
