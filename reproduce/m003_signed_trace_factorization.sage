"""
Stage 2 of the enrichment -> factorization -> involution program.

For each of the three universal squared-trace identities
(A~ABBB, AB~ABB, AAb~AABB), factor
    D_{w,w'} = tr^2(w) - tr^2(w') = (tr(w)-tr(w')) * (tr(w)+tr(w'))
and reduce EACH signed factor separately modulo the defining ideal of
the geometric component X_0 (the same component identified in
m003_three_universal_identities.sage, reused here verbatim -- same
ring, same matrices, same primary decomposition) to determine whether
each universal identity is really tr(w)=tr(w') or tr(w)=-tr(w') on X_0.

Also restates, for comparison, the ALREADY-established signed relation
for the fourth (exceptional, (-2,3)-specific) pair B/Abb: proved
earlier (m003_squared_locus_and_conjugacy.sage) to be tr(B)=tr(Abb)
(the "+" branch, C_+ = tr(Abb)-tr(B) vanishing) on the geometric
(-2,3) locus, NOT tr(B)=-tr(Abb).

This directly tests whether the sign of the trace identity correlates
with the [w]=-[w'] homology-inversion pattern found by the atlas
enrichment test, or is independent of it.
"""
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


det_relation = u**2 + z*u + 1
det_ideal = R.ideal([det_relation])


def tr(word):
    M = word_matrix(word)
    t = det_ideal.reduce(M[0, 0] + M[1, 1])
    assert t.degree(u) == 0, (word, "still depends on u after reduction")
    return R(t)


# ---- reconstruct the same primary decomposition as
#      m003_three_universal_identities.sage, to identify GEOM ----
relator = "abAAbabbb"
Mr = word_matrix(relator)
gens_riley = [det_relation] + list((Mr - I2).list())
I_riley = R.ideal(gens_riley)
Iel_riley = I_riley.elimination_ideal([u])
PD = Iel_riley.primary_decomposition()

pairs = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]


def find_geom_component():
    for i, comp in enumerate(PD):
        if all(comp.reduce(R(tr(w1)**2 - tr(w2)**2)) == 0 for w1, w2 in pairs):
            return i, comp
    raise RuntimeError("no component found where all three squared identities vanish")


GEOM, comp = find_geom_component()
print("geometric component index:", GEOM, " (out of", len(PD), "components)")
print()

print("=" * 78)
print("SIGNED TRACE FACTORIZATION on the geometric component X_0")
print("=" * 78)
for w1, w2 in pairs:
    t1, t2 = tr(w1), tr(w2)
    diff = R(t1 - t2)
    summ = R(t1 + t2)
    r_diff = comp.reduce(diff)
    r_sum = comp.reduce(summ)
    print(f"\npair ({w1}, {w2}):")
    print(f"  tr({w1}) - tr({w2}) reduces on X_0 to: {r_diff}   (vanishes: {r_diff == 0})")
    print(f"  tr({w1}) + tr({w2}) reduces on X_0 to: {r_sum}   (vanishes: {r_sum == 0})")
    if r_diff == 0 and r_sum != 0:
        print(f"  => tr({w1}) =  tr({w2})  exactly on X_0 (the 'S'-type sign)")
    elif r_sum == 0 and r_diff != 0:
        print(f"  => tr({w1}) = -tr({w2})  exactly on X_0 (the 'I'-type sign)")
    elif r_diff == 0 and r_sum == 0:
        print("  => BOTH factors vanish -- degenerate on this component (trace(s) = 0 identically)")
    else:
        print("  => NEITHER factor vanishes identically -- squared identity holds without a")
        print("     single global sign choice (may split by sub-branch/further component)")

print()
print("=" * 78)
print("FOR COMPARISON: the fourth (exceptional) pair B/Abb, already established")
print("=" * 78)
print("Recall (m003_squared_locus_and_conjugacy.sage): on the (-2,3) geometric")
print("locus X^+_{-2,3}, C_+ = tr(Abb) - tr(B) is the vanishing branch, i.e.")
print("tr(B) = tr(Abb) exactly (the 'S'-type sign), NOT tr(B) = -tr(Abb).")
print("Re-verified directly here on the full geometric component X_0 (before")
print("restricting to the (-2,3) sub-locus, where B/Abb is not yet forced):")
trB, trAbb = tr("B"), tr("Abb")
print("  tr(B) - tr(Abb) on X_0:", comp.reduce(R(trB - trAbb)))
print("  tr(B) + tr(Abb) on X_0:", comp.reduce(R(trB + trAbb)))
print("  (neither expected to vanish on all of X_0 -- B/Abb is (-2,3)-specific,")
print("   not a whole-X_0 identity; the +/- distinction only becomes forced")
print("   after further restricting to the (-2,3) sub-locus, as already proved.)")

print()
print("SAGE_EXIT=0")
