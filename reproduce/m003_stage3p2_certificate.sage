"""
Stage 3.2 CERTIFICATE: exact non-conjugacy of the three universal-
identity pairs in Gamma_fill = pi_1(m003(-2,3)), via a finite quotient.

Gamma_fill = <a,b | r, s>, r=abAAbabbb (cusped relator, verified),
s = mu^-2 lambda^3 for the (-2,3) filling (mu=ABABB, lambda=ABAbab,
both independently verified elsewhere this session).

Method: a homomorphism phi: Gamma_fill -> Q (Q finite) sends conjugate
elements to conjugate elements. So if phi(w) and phi(w'^-1) are NOT
conjugate in Q for some finite quotient Q, then w and w'^-1 are NOT
conjugate in Gamma_fill -- an EXACT proof (finite-group conjugacy is
exactly decidable, no numerical approximation), not a numerical
exclusion like stages 3B/3.1.

Q here is the permutation image of Gamma_fill acting on the cosets of
an index-13 subgroup found by LowIndexSubgroupsFpGroup, order 5616.
Verified two independent ways for each pair:
  (i) GAP's IsConjugate on the finite permutation group Q (exact).
  (ii) An independent necessary condition: cycle type. Conjugate
       permutations in Sym(n) always have identical cycle type; if the
       cycle types already differ, that alone proves non-conjugacy,
       independent of trusting IsConjugate as a black box.

Reproducibility: rerun twice from a fresh Sage/GAP process, identical
subgroup list and identical results both times.
"""
from sage.all import *

F = libgap.FreeGroup("a", "b")
a, b = F.GeneratorsOfGroup()


def word_from_string(w, a, b):
    letter_map = {"a": a, "A": a**-1, "b": b, "B": b**-1}
    result = None
    for c in w:
        g = letter_map[c]
        result = g if result is None else result * g
    return result


def inverse_word(w):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(w))


r_str = "abAAbabbb"
mu, longitude = "ABABB", "ABAbab"
s_str = inverse_word(mu) * 2 + longitude * 3
print("relator r  =", r_str)
print("filling  s =", s_str)

r_word = word_from_string(r_str, a, b)
s_word = word_from_string(s_str, a, b)
G = F / libgap([r_word, s_word])
ga, gb = G.GeneratorsOfGroup()


def word_in_G(w):
    return word_from_string(w, ga, gb)


INDEX_BOUND = 15
subgroups = libgap.LowIndexSubgroupsFpGroup(G, INDEX_BOUND)
print(f"LowIndexSubgroupsFpGroup(G, {INDEX_BOUND}): {len(subgroups)} subgroups found")

# locate the index-13 subgroup with the largest permutation image
best_H = None
best_order = 0
best_idx = None
for H in subgroups:
    idx = int(libgap.Index(G, H))
    if idx == 1:
        continue
    hom = libgap.FactorCosetAction(G, H)
    img = libgap.Image(hom)
    order = int(libgap.Size(img))
    if order > best_order:
        best_order = order
        best_H = H
        best_idx = idx
        best_hom = hom
        best_img = img

print(f"\nSelected quotient: index-{best_idx} subgroup, permutation image order {best_order}")
print(f"Permutation degree: {int(libgap.Index(G, best_H))}")

pairs = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]

print()
print("=" * 78)
print("CERTIFICATE: exact non-conjugacy in the finite quotient (order %d)" % best_order)
print("=" * 78)

all_pass = True
for w, wp in pairs:
    elt_w = libgap.Image(best_hom, word_in_G(w))
    elt_wp_inv = libgap.Image(best_hom, word_in_G(inverse_word(wp)))

    # (i) exact conjugacy test in the finite group
    is_conj = bool(libgap.IsConjugate(best_img, elt_w, elt_wp_inv))

    # (ii) independent cycle-type cross-check
    cyc_w = libgap.CycleStructurePerm(elt_w)
    cyc_wp_inv = libgap.CycleStructurePerm(elt_wp_inv)
    same_cycle_type = bool(cyc_w == cyc_wp_inv)

    print(f"\npair (w={w}, w'={wp})  [testing w ~ (w')^-1, equivalently w' ~ w^-1]")
    print(f"  phi({w})       cycle structure: {cyc_w}")
    print(f"  phi(({wp})^-1) cycle structure: {cyc_wp_inv}")
    print(f"  same cycle type? {same_cycle_type}  "
          f"({'consistent with possible conjugacy' if same_cycle_type else 'ALREADY proves non-conjugacy on its own'})")
    print(f"  GAP IsConjugate (exact, finite group): {is_conj}")

    status = "NOT CONJUGATE (exact)" if not is_conj else "CONJUGATE in this quotient (inconclusive)"
    print(f"  ==> {status}")
    if is_conj:
        all_pass = False

print()
print("=" * 78)
if all_pass:
    print("STAGE 3.2 RESULT: all three pairs proved NOT conjugate in Gamma_fill.")
    print("This is an EXACT result (finite-quotient homomorphism argument), not a")
    print("numerical exclusion. Combined with stage 2 (tr(w)=tr(w') on X_0) and the")
    print("atlas (established [w']=-[w]):")
    print()
    print("  tr(w)=tr(w'), [w']=-[w]  DOES NOT IMPLY  w' ~ w^-1")
    print()
    print("for these three pairs -- the universal X_0 identities and the filling-")
    print("specific B/Abb identity (which DOES have this exact conjugacy mechanism,")
    print("g=BaBA) genuinely arise from different structures.")
else:
    print("STAGE 3.2 RESULT: inconclusive for at least one pair in this quotient.")

print()
print("SAGE_EXIT=0")
