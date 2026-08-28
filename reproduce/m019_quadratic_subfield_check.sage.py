# Third independent verification (direct subfield enumeration) that the
# S4-closure of x^4-x-1 (m019's cusp field) has a unique quadratic
# subfield, and that it is Q(sqrt(-283)), distinct from Q(sqrt(-3)).
#
# This is a reproducibility artifact for gentry-dual-surgery-v1.tex,
# Theorem thm:disjoint (proved there via the abstract "S4 has a unique
# index-2 subgroup A4" argument, cross-checked there via GAP small-group
# id [48,48] on the degree-48 closure of K1*K2). This script checks the
# same fact a third, independent way: direct enumeration of quadratic
# subfields via Sage's NumberField.subfields().
#
# Result (verified 2026-08-28):
#   L2 = Galois closure of x^4-x-1, degree 24
#   number of quadratic subfields: 1
#   that subfield has discriminant -283

from sage.all import polygen, QQ, NumberField

x = polygen(QQ)
K2 = NumberField(x**4 - x - 1, 'a')
L2 = K2.galois_closure('b')
print("L2 degree:", L2.degree())

subs = L2.subfields(degree=2)
print("number of quadratic subfields:", len(subs))
for Kf, emb, _ in subs:
    print("  field:", Kf, "  discriminant:", Kf.discriminant())

assert len(subs) == 1
assert subs[0][0].discriminant() == -283
print("OK: unique quadratic subfield, disc=-283, confirmed.")
