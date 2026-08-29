# Cover 2 (Z+Z homology, torsion-free) is Gamma_009^+ -- confirmed via
# the abstract-group route in m009_task2_identify_double_cover_v2.sage
# (H_1(<a^2,ab,ba^-1>) = Z+Z via GAP, uniquely matching SnapPy's cover
# 2 among the three -- the other two have torsion and are ruled out).
# Get more invariants: identify(), cusps, trace field, etc.

import snappy

M = snappy.Manifold('m009')
covers = M.covers(2)
Mplus = covers[2]
print("Cover 2 (= M+ = cover corresponding to Gamma_009^+):")
print("  name:", Mplus.name())
print("  volume:", Mplus.volume())
print("  homology:", Mplus.homology())
print("  num cusps:", Mplus.num_cusps())
try:
    print("  identify():", Mplus.identify())
except Exception as ex:
    print("  identify() failed:", ex)

print()
print("Cusp shapes:", Mplus.cusp_info())

try:
    tf = Mplus.trace_field_gens()
    print("trace field gens (numeric):", tf)
except Exception as ex:
    print("trace_field_gens failed:", ex)
