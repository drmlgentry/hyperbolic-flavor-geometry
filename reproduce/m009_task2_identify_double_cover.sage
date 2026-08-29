# Identify which degree-2 cover of m009 corresponds to Gamma_009^+ =
# ker(eps).
#
# IMPORTANT CAVEAT checked before trusting anything: volume ALONE
# cannot distinguish which cover is "ours" -- ANY degree-2 cover has
# volume exactly 2*vol(m009)=5.3335..., automatically, trivially, for
# all three nontrivial homs Gamma_009 -> C2 (pure Z/2-projection, pure
# free-part-mod-2, and the "sum" that is actually eps). So "volume
# matches 5.333" as proposed is not actually discriminating -- it's
# true of all three candidate covers. Need a genuinely distinguishing
# invariant (which generators lift to loops vs not) instead.

import snappy

M = snappy.Manifold('m009')
print("vol(m009):", M.volume())

covers = M.covers(2)
print()
print("Number of degree-2 covers found:", len(covers))
for i, C in enumerate(covers):
    print(f"  cover {i}: volume={C.volume()}, homology={C.homology()}")

######################################################################
# Distinguish which cover is ours DIRECTLY: does the specific element
# 'a' lift to a closed loop (i.e. a in ker(eps)) or not? Since
# eps(a)=1, 'a' should NOT lift -- i.e. in the covering space
# permutation representation, 'a' acts as the nontrivial transposition,
# and similarly for 'b'. SnapPy's covers() are constructed from
# representations to S_n; inspect via the covering relators / homology
# structure of Gamma_009^+ itself (already known explicitly:
# <a^2, ab, ba^-1>) as a cross-check on which returned cover matches,
# by comparing to the ABSTRACT structure of the subgroup rather than
# guessing from SnapPy's internal labeling.
######################################################################
G = M.fundamental_group()
print()
print("Fundamental group generators/relators:", G.generators(), G.relators())

# Cross-check via the OTHER two candidate homs' predicted behavior:
# hom1 (pure Z/2 proj): a->1, b->0 -- kernel contains b but not a
# hom2 (pure free mod 2): a->0, b->1 -- kernel contains a but not b
# eps (ours):             a->1, b->1 -- kernel contains NEITHER a nor b
#                           (but contains a*b, b*a^-1, a^2, b^2, etc.)
print()
print("Predicted distinguishing test: for the cover matching eps, NEITHER")
print("'a' nor 'b' individually lifts to a closed loop (both act as the")
print("nontrivial deck transformation); for the other two covers, exactly")
print("one of a,b lifts trivially.")

# SnapPy low-level: each cover object records its permutation
# representation via .covering_dictionary() in some versions, or we can
# recover it from which lifts of the generators return to the basepoint
# by checking the corresponding LiftedFundamentalGroup / core geodesics.
# Try the direct API if available; report plainly if not.
for i, C in enumerate(covers):
    try:
        cd = C.covering_dictionary()
        print(f"cover {i} covering_dictionary:", cd)
    except Exception as ex:
        print(f"cover {i}: covering_dictionary() not available ({ex})")
