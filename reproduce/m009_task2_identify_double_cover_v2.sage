# Identify which of SnapPy's 3 degree-2 covers corresponds to
# Gamma_009^+ = ker(eps), via an abstract-group route (GAP) that
# doesn't depend on reverse-engineering SnapPy's internal permutation
# labeling: compute H_1(Gamma_009^+) directly (Reidemeister-Schreier via
# GAP's own subgroup-presentation machinery, using the ALREADY-KNOWN
# explicit generators a^2, ab, ba^-1), then match against the 3
# homologies SnapPy already reported for its covers -- since these
# should be genuinely distinguishing invariants (unlike volume, which
# is identical for all three).

import snappy
from sage.all import libgap

M = snappy.Manifold('m009')
G = M.fundamental_group()
gens = G.generators()
rels = G.relators()
print("Generators:", gens, " Relators:", rels)

F = libgap.FreeGroup(len(gens))
gap_gens = list(F.GeneratorsOfGroup())
gen_index = {g: i for i, g in enumerate(gens)}


def word_to_gap(word):
    elt = None
    for ch in word:
        letter = gap_gens[gen_index[ch.lower()]]
        factor = letter if ch.islower() else letter.Inverse()
        elt = factor if elt is None else elt * factor
    return elt


gap_rels = [word_to_gap(r) for r in rels]
Ggap = F / gap_rels
gap_a, gap_b = Ggap.GeneratorsOfGroup()[0], Ggap.GeneratorsOfGroup()[1]

# Gamma_009^+ = <a^2, ab, ba^-1>, exactly as established.
h1 = gap_a**2
h2 = gap_a * gap_b
h3 = gap_b * gap_a**-1
Hplus = libgap.Subgroup(Ggap, [h1, h2, h3])
print()
print("Index of <a^2,ab,ba^-1> in Gamma_009 (should be 2):", libgap.Index(Ggap, Hplus))

# Abelianization of the subgroup itself (= H_1 of the corresponding
# cover), via GAP's IsomorphismFpGroup on the subgroup + abelianization.
iso = libgap.IsomorphismFpGroup(Hplus)
Fp_Hplus = iso.Range()
print("Presentation of Gamma_009^+:", Fp_Hplus)
print("Relators:", libgap.RelatorsOfFpGroup(Fp_Hplus))
inv = libgap.AbelianInvariants(Fp_Hplus)
print()
print("H_1(Gamma_009^+) abelian invariants (GAP):", inv)

print()
print("=" * 70)
print("Compare against SnapPy's 3 reported cover homologies:")
print("  cover 0: Z/2 + Z/6 + Z")
print("  cover 1: Z/4 + Z")
print("  cover 2: Z + Z")
print("=" * 70)
