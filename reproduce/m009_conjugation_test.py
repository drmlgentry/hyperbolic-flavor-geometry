import snappy
from sage.all import ComplexField, algdep

CCf = ComplexField(300)

M = snappy.Manifold('m009')
G = M.polished_holonomy(bits_prec=300)

words = ['aa', 'bb', 'ab', 'ba']
mats = {w: G.SL2C(w) for w in words}

# Candidate conjugator: beta = aa's own (0,1) entry (b, where b^2 = kappa in K)
beta = CCf(mats['aa'][0, 1])
print(f"beta = aa[0,1] = {beta}")
print(f"beta^2 = {beta**2}  (expect this to match one of the K-rational roots)")

for w in words:
    m = mats[w]
    a = CCf(m[0, 0])
    b = CCf(m[0, 1])
    c = CCf(m[1, 0])
    d = CCf(m[1, 1])
    # D M D^-1 = [[a, beta*b], [c/beta, d]]  for D = diag(beta, 1)
    new_01 = beta * b
    new_10 = c / beta
    print(f"\n{w}: original off-diag minpolys vs conjugated")
    print(f"  new [0,1] = {new_01}")
    if abs(new_01) > 1e-10:
        print(f"    algdep(.,4) = {algdep(new_01, 4, known_bits=200)}")
    else:
        print("    (~0)")
    print(f"  new [1,0] = {new_10}")
    if abs(new_10) > 1e-10:
        print(f"    algdep(.,4) = {algdep(new_10, 4, known_bits=200)}")
    else:
        print("    (~0)")
