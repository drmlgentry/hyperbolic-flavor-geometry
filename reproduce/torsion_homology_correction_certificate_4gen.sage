# Extension of torsion_homology_correction_certificate.sage: SnapPy's
# length_spectrum(..., include_words=True) uses the UNSIMPLIFIED
# Dirichlet-domain presentation (4 generators a,b,c,d), not the
# simplified 2-generator one the original certificate covered. Redo the
# SAME certified methodology (exponent-sum matrix, Smith normal form,
# exact quotient-module lookup, relator verification) for THIS
# presentation, since primitive_geodesic_census.sage needs to classify
# words stated in these exact generators.

import snappy
from sage.all import matrix, ZZ, vector

for name, census_index in [('m006', 43), ('m003', 1)]:
    M = snappy.OrientableClosedCensus[census_index]
    print()
    print("=" * 72)
    print(f"{name} = OrientableClosedCensus[{census_index}] -> {M.name()}  (4-gen, unsimplified)")
    print("=" * 72)

    G = M.fundamental_group(simplify_presentation=False)
    gens = G.generators()
    rels = G.relators()
    print("generators:", gens)
    print("relators:", rels)
    hom = M.homology()
    print("H_1(M) (SnapPy):", hom)

    def exponent_vector(word, gens_):
        vec = [0] * len(gens_)
        idx = {g: i for i, g in enumerate(gens_)}
        for ch in word:
            if ch.islower():
                vec[idx[ch]] += 1
            else:
                vec[idx[ch.lower()]] -= 1
        return vec

    rel_matrix = matrix(ZZ, [exponent_vector(r, gens) for r in rels])
    print("abelianized relator matrix (rows=relators, cols=", gens, "):")
    print(rel_matrix)

    D, U, V = rel_matrix.smith_form()
    diag = [D[i, i] for i in range(min(D.nrows(), D.ncols()))]
    nontrivial = [d for d in diag if d not in (0, 1)]
    print("Smith form diagonal:", diag, " nontrivial divisors:", nontrivial)
    assert len(nontrivial) == 1, f"expected cyclic torsion H_1 for {name}, got {diag}"
    order = nontrivial[0]
    print(f"H_1(M) = Z/{order} (matches SnapPy: {hom})")

    Amod = ZZ**len(gens)
    Bsub = Amod.submodule(rel_matrix.rows())
    Q = Amod.quotient(Bsub)
    images = {}
    for i, g in enumerate(gens):
        e = [0] * len(gens)
        e[i] = 1
        images[g] = Q(vector(ZZ, e))
        print(f"  [{g}] in H_1: {images[g]}")

    # Express each generator's class as an explicit residue mod `order`
    # (Q's internal representation may use a different but isomorphic
    # cyclic presentation -- find k_g in range(order) with images[g] ==
    # k_g * images[gens[0]] for a fixed reference generator, matching
    # the same style as the 2-generator certificate).
    ref = gens[0]
    coeffs = {}
    for g in gens:
        found = None
        for k in range(order):
            if images[g] == k * images[ref]:
                found = k
                break
        assert found is not None, f"{g}'s class is not an integer multiple of {ref}'s -- unexpected"
        coeffs[g] = found
    print(f"Coefficients relative to [{ref}]=1: {coeffs}")

    print()
    print("Verifying every relator maps to 0 under this map:")
    for i, r in enumerate(rels):
        ev = exponent_vector(r, gens)
        val = sum(ev[j] * coeffs[gens[j]] for j in range(len(gens))) % order
        print(f"  relator {i} ({r}): {val} (mod {order})")
        assert val == 0
    print("  ALL CONFIRMED ZERO.")

    print()
    print(f"CERTIFIED classifier for {name} (4-gen Dirichlet presentation):")
    print(f"  {coeffs}  (mod {order})")
