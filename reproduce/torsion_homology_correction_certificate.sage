# Standalone exact certificate: correct abelianization classifier for
# the torsion paper's two compact manifolds, replacing the ad hoc
# "n_a+n_b mod 5" classifier used in gentry-torsion-plb.tex (Table 1's
# word-length-12 spectral floors), which implicitly assumes a,b both
# map to the SAME generator of H_1=Z/5 with equal weight -- checked
# here directly against the actual presentations, not assumed either
# way.
#
# For each manifold:
#   1. Get the actual SnapPy fundamental-group presentation (same
#      2-generator presentation SnapPy itself reports, matching what
#      any word-enumeration scan over {a,b,A,B} would have used).
#   2. Build the exponent-sum (abelianization) matrix from the actual
#      relator(s).
#   3. Smith normal form -> confirm H_1 and get the genuine [a],[b]
#      images in it.
#   4. Verify every relator maps to zero under this map (the basic
#      sanity check a valid abelianization must satisfy).
#   5. Test whether the OLD classifier w -> (exponent sum of a) +
#      (exponent sum of b), reduced mod |H_1|, is even well-defined on
#      pi_1(M) at all -- i.e. does it send the relator to 0? If not, it
#      does not descend to a homomorphism from pi_1(M), and every
#      "homology class" label computed with it in the paper is invalid
#      for elements involving the relator (not just a minor
#      renormalization issue).
#   6. Record the CORRECT relation between [a] and [b] in H_1.

import snappy
from sage.all import matrix, ZZ, vector

for name, census_index in [('m006', 43), ('m003', 1)]:
    M = snappy.OrientableClosedCensus[census_index]
    print()
    print("=" * 72)
    print(f"{name} = OrientableClosedCensus[{census_index}] -> {M.name()}, vol={M.volume()}")
    print("=" * 72)

    G = M.fundamental_group()
    gens = G.generators()
    rels = G.relators()
    print("generators:", gens)
    print("relators:", rels)
    hom = M.homology()
    print("H_1(M) (SnapPy):", hom)

    assert gens == ['a', 'b'], f"unexpected generator set for {name}: {gens}"

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
    print("abelianized relator matrix (rows=relators, cols=[a,b]):")
    print(rel_matrix)

    D, U, V = rel_matrix.smith_form()
    print("Smith normal form D:", D.list())

    # H_1 = Z^2 / rowspan(rel_matrix). Elementary divisors read off D's
    # diagonal (padded with 0 = free factor if rank < 2).
    diag = [D[i, i] for i in range(min(D.nrows(), D.ncols()))]
    nontrivial = [d for d in diag if d not in (0, 1)]
    print("nontrivial elementary divisors:", nontrivial)
    assert len(nontrivial) == 1, f"expected cyclic torsion H_1 for {name}, got divisors {diag}"
    order = nontrivial[0]
    print(f"H_1(M) = Z/{order} (matches SnapPy: {hom})")

    # Genuine images of a,b in H_1: use Sage's own quotient-module
    # machinery directly (robust for ANY number of relators, not just a
    # single-relator special case) -- H_1 = Z^2 / <relator rows>.
    Amod = ZZ**2
    Bsub = Amod.submodule(rel_matrix.rows())
    Q = Amod.quotient(Bsub)
    a_img = Q(vector(ZZ, [1, 0]))
    b_img = Q(vector(ZZ, [0, 1]))
    print(f"[a] in H_1 (Sage quotient module): {a_img}")
    print(f"[b] in H_1 (Sage quotient module): {b_img}")

    # Find integer k in range(order) with [a] = k*[b] (search -- H_1 is
    # small and cyclic, this is exact and exhaustive, not a guess).
    k_found = None
    for k in range(order):
        if a_img == k * b_img:
            k_found = k
            break
    assert k_found is not None, f"[a] is not an integer multiple of [b] in H_1 for {name} -- unexpected"
    print(f"CORRECT relation, found by exhaustive exact search: [a] = {k_found} * [b]  in H_1 = Z/{order}")

    print()
    print("Does every relator vanish under the OLD classifier w -> (n_a+n_b) mod", order, "?")
    all_old_zero = True
    for i, r in enumerate(rels):
        p, q = rel_matrix[i, 0], rel_matrix[i, 1]
        val = (p + q) % order
        ok = (val == 0)
        all_old_zero = all_old_zero and ok
        print(f"  relator {i} ({rels[i]}): (n_a,n_b)=({p},{q}), n_a+n_b={p+q} = {val} (mod {order}) -- zero: {ok}")
    if not all_old_zero:
        print(">>> OLD CLASSIFIER DOES NOT DESCEND for", name, ": it fails to send at")
        print(">>> least one defining relator to 0, so 'n_a+n_b mod", order, "' is NOT a")
        print(">>> well-defined homomorphism pi_1(M) -> Z/%d at all. Every homology-" % order)
        print(">>> class label computed with it in the paper is invalid for this")
        print(">>> manifold, not merely unnormalized.")
    else:
        print(">>> OLD CLASSIFIER DOES descend for", name, "(all relators map to 0).")

    print()
    print("Self-consistency: verify every relator vanishes under the CORRECT map")
    print(f"[a]->{k_found}, [b]->1 (mod {order}):")
    for i, r in enumerate(rels):
        p, q = rel_matrix[i, 0], rel_matrix[i, 1]
        val = (p * k_found + q * 1) % order
        print(f"  relator {i}: {p}*{k_found} + {q}*1 = {p*k_found+q} = {val} (mod {order})")
        assert val == 0
    print("  ALL CONFIRMED ZERO.")
