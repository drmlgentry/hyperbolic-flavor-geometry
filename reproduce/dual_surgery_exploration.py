# dual_surgery_exploration.py
# Run in WSL sage: sage dual_surgery_exploration.py
# Explores the dual surgery structure of M_PMNS and M_CKM

import snappy

print("=" * 60)
print("STEP 1: Verify dual surgery and linking forms")
print("=" * 60)

M1 = snappy.Manifold("m003(-2,3)")
M2 = snappy.Manifold("m019(2,1)")
print(f"H1 m003(-2,3): {M1.homology()}")
print(f"H1 m019(2,1):  {M2.homology()}")
print(f"vol m003: {M1.volume():.15f}")
print(f"vol m019: {M2.volume():.15f}")
print(f"Same volume: {abs(M1.volume()-M2.volume()) < 1e-10}")

print()
print("=" * 60)
print("STEP 2: Search for dual parent of M_CKM = m006(-5,2)")
print("=" * 60)

M_CKM = snappy.Manifold("m006(-5,2)")
target_vol = M_CKM.volume()
target_h1  = 5
print(f"M_CKM vol = {target_vol:.10f}, H1 = Z/5")
print()
print("Searching S4 manifolds for a filling matching M_CKM...")

s4_names = ["m011","m019","m026","m033","m079","m115","m141","m155","m178"]
from math import gcd

for name in s4_names:
    M = snappy.Manifold(name)
    for p in range(-15, 16):
        for q in range(-15, 16):
            if p==0 and q==0: continue
            if gcd(abs(p),abs(q)) != 1: continue
            try:
                N = M.copy()
                N.dehn_fill((p,q))
                if N.homology().order() != target_h1: continue
                if abs(N.volume() - target_vol) < 1e-6:
                    ids = N.identify()
                    print(f"  MATCH: {name}({p},{q}) vol={N.volume():.8f}")
                    print(f"    identified as: {ids}")
                    print(f"    H1={N.homology()}, |slope|^2={p*p+q*q}")
            except: pass

print()
print("=" * 60)
print("STEP 3: Compositum of cusp splitting fields")
print("=" * 60)
print("""
# Sage computation (run interactively):
R.<x> = QQ[]
p_su2  = x^2 - x + 1      # m003 cusp, Gal=Z/2
p_su4  = x^4 - x - 1      # m019 cusp, Gal=S4

K1.<a> = p_su2.splitting_field()
K2.<b> = p_su4.splitting_field()
print("[K1:Q] =", K1.degree())   # = 2
print("[K2:Q] =", K2.degree())   # = 24

# Compositum
K12 = K1.composite_fields(K2)[0]
print("[K1*K2:Q] =", K12.degree())  # = 48 if independent
print("Gal(K1*K2) =", K12.galois_group())
""")

print()
print("=" * 60)
print("STEP 4: Other fillings of m019 — Z/3, Z/7 candidates")
print("=" * 60)

M019 = snappy.Manifold("m019")
print("m019 fillings with small prime torsion (from earlier scan):")
for p, q, order in [
    (-8,-3,3), (8,3,3),
    (-4,-1,7), (4,1,7),
    (-2,-1,5), (2,1,5),
    (0,-1,17),(0,1,17),
]:
    try:
        N = M019.copy()
        N.dehn_fill((p,q))
        h1 = N.homology()
        ids = N.identify()
        print(f"  m019({p},{q}): H1={h1}, |s|^2={p*p+q*q}, id={ids}")
    except Exception as e:
        print(f"  m019({p},{q}): error {e}")

print()
print("=" * 60)
print("STEP 5: Is m019(-8,-3) or m019(8,3) [H1=Z/3] known?")
print("=" * 60)
for slope in [(-8,-3),(8,3)]:
    p,q = slope
    try:
        N = M019.copy()
        N.dehn_fill((p,q))
        print(f"m019{slope}: H1={N.homology()}, vol={N.volume():.8f}")
        ids = N.identify()
        print(f"  identified: {ids}")
    except Exception as e:
        print(f"m019{slope}: {e}")
