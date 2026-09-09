"""
Stage 3.2: seek an EXACT conjugacy-class obstruction in
Gamma_fill = pi_1(m003(-2,3)) = <a,b | r, s>, r=abAAbabbb (cusped
relator), s=filling word for slope (-2,3) (mu^-2 lambda^3, verified
peripheral words mu=ABABB, lambda=ABAbab).

Method: rather than attempt IsConjugate on the infinite finitely
presented group directly (already known to time out for a similar
question this session -- the original B/Abb search), find a FINITE
quotient of Gamma_fill (via low-index subgroups -> coset action
permutation representation) and test conjugacy of the relevant
elements' IMAGES there. Finite-group conjugacy is fast and decidable;
if the images are proved non-conjugate in ANY finite quotient, that is
an EXACT, rigorous proof of non-conjugacy in the infinite group
(homomorphisms send conjugate elements to conjugate elements, so
non-conjugate images force non-conjugate preimages).

Tests all three universal pairs: is A conjugate to (ABBB)^-1? Is AB
conjugate to (ABB)^-1? Is AAb conjugate to (AABB)^-1?
"""
from sage.all import *

F = libgap.FreeGroup("a", "b")
a, b = F.GeneratorsOfGroup()

# Build the two relator words as GAP free-group elements from strings.
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
print("G defined:", G)
ga, gb = G.GeneratorsOfGroup()

def word_in_G(w):
    return word_from_string(w, ga, gb)

pairs = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]

print()
print("Searching for a useful finite quotient via low-index subgroups...")
INDEX_BOUND = 15
try:
    subgroups = libgap.LowIndexSubgroupsFpGroup(G, INDEX_BOUND)
    print(f"found {len(subgroups)} subgroups of index <= {INDEX_BOUND}")
except Exception as e:
    print("LowIndexSubgroupsFpGroup failed/too slow:", e)
    subgroups = []

# Try each nontrivial proper subgroup found, build the coset-action
# permutation representation, and test conjugacy of the relevant
# elements' images in the resulting (finite) permutation image.
results = {}
for w, wp in pairs:
    results[(w, wp)] = None

for H in subgroups:
    idx = libgap.Index(G, H)
    if idx == 1 or idx > INDEX_BOUND:
        continue
    try:
        hom = libgap.FactorCosetAction(G, H)
        img = libgap.Image(hom)
    except Exception as e:
        continue
    order = libgap.Size(img)
    print(f"  subgroup index {idx}: permutation image order {order}")
    for w, wp in pairs:
        if results[(w, wp)] is not None:
            continue  # already resolved
        target = word_in_G(w) * word_in_G(wp)  # w * (w')  -- test w ~ (w')^-1 <=> w * w' conjugate check via direct elements
        # We test: is word_in_G(w) conjugate to word_in_G(inverse_word(wp)) in img?
        elt_w = libgap.Image(hom, word_in_G(w))
        elt_wp_inv = libgap.Image(hom, word_in_G(inverse_word(wp)))
        conj = libgap.IsConjugate(img, elt_w, elt_wp_inv)
        print(f"    pair ({w},{wp}): images conjugate in this quotient? {conj}")
        if not conj:
            results[(w, wp)] = ("NOT CONJUGATE", idx, int(order))

print()
print("=" * 70)
print("SUMMARY")
print("=" * 70)
for (w, wp), res in results.items():
    if res is None:
        print(f"({w},{wp}): no distinguishing finite quotient found up to index {INDEX_BOUND}")
    else:
        status, idx, order = res
        print(f"({w},{wp}): {status} -- proved via index-{idx} quotient (order {order})")

print()
print("SAGE_EXIT=0")
