# verify_s4_manifold_table.py
# Run in WSL sage: sage verify_s4_manifold_table.py
#
# Recomputes the cusp field minimal polynomial, discriminant, and Galois group
# order for each of the 9 S4-type manifolds used in the CKM negative-result
# search (gentry-dual-surgery-v1.tex, Table 1 / Proposition 11), directly from
# SnapPy cusp shapes rather than from corpus notes. Written after an earlier
# hand-assembled version of this table was found to be fabricated for 8 of 9
# rows (only m019 was correct) -- this script is the actual source of truth
# for that table going forward.

import snappy
from sage.all import algdep, QQ, NumberField

manifolds = ["m011", "m019", "m026", "m033", "m079", "m115", "m141", "m155", "m178"]

R = QQ['x']

print(f"{'Manifold':<8} {'Min poly':<35} {'Disc':<8} {'Gal order'}")
print("-" * 70)

for name in manifolds:
    M = snappy.Manifold(name)
    cs = M.cusp_info('shape', bits_prec=300)[0]
    poly = algdep(cs, 4)
    poly = poly / poly.leading_coefficient()
    disc = poly.discriminant()
    Kfield = NumberField(poly, 'w')
    G = Kfield.galois_group()
    print(f"{name:<8} {str(poly):<35} {str(disc):<8} {G.order()}")
