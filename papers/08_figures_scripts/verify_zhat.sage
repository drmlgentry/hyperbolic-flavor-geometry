# verify_zhat.sage
# Verifies the Gauss polynomial, WRT formula, false theta structure,
# and sector cancellations for the Meyerhoff manifold M_PMNS = m003(-2,3).
# Run with: sage verify_zhat.sage

print("=" * 60)
print("VERIFICATION: Gauss polynomial and WRT for M_PMNS")
print("=" * 60)

# Parameters
p = 5          # |H_1|
CS = QQ(1,4)   # Chern-Simons invariant
k = 1/CS       # CS level = 4
level = 2*p*k  # false theta level = 40

print(f"\nParameters: p={p}, CS={CS}, k={k}, level={level}")

# CS values for each a in Z/5
CS_vals = {a: (a^2 * CS) % 1 for a in range(p)}
print(f"\nCS_a values: {CS_vals}")
assert CS_vals == {0:0, 1:QQ(1,4), 2:0, 3:QQ(1,4), 4:0}
print("CS values verified: {0,1/4,0,1/4,0} ✓")

# Theorem 1: Gauss polynomial
def G(t):
    return sum(t^(4*CS_vals[a]) for a in range(p))

print(f"\nGauss polynomial G(t) = {G(SR.var('t'))}")
assert G(SR.var('t')).expand() == 3 + 2*SR.var('t')
print("G(t) = 3 + 2t ✓")

# Theorem 2: WRT formula
print("\nWRT formula verification:")
print(f"{'r':>4}  {'WRT (computed)':>30}  {'(-i/√r)(3+2iʳ)':>30}  match")
print("-" * 75)
for r in [1,3,5,7,9,11,13,15,17,19]:
    if gcd(r, 5) != 1:
        continue
    I = CDF(0,1)
    wrt_sum = sum(exp(2*pi*I*r*CS_vals[a]) for a in range(p))
    wrt = (-I/sqrt(CDF(r))) * wrt_sum
    expected = (-I/sqrt(CDF(r))) * (3 + 2*I^r)
    match = abs(wrt - expected) < 1e-10
    print(f"{r:>4}  {str(CDF(wrt))[:28]:>30}  {str(CDF(expected))[:28]:>30}  {'✓' if match else '✗'}")

# Corollary: |WRT|^2 = 13/r for r ≡ 1,3 mod 4
print("\n|WRT_r|^2 = 13/r check (odd r, gcd(r,5)=1):")
for r in [1,3,7,9,11,13,17,19,23]:
    if gcd(r,5) == 1 and r % 2 == 1:
        I = CDF(0,1)
        expected = (-I/sqrt(CDF(r))) * (3 + 2*I^r)
        norm_sq = abs(expected)^2
        print(f"  r={r:2d}: |WRT|^2 = {norm_sq:.6f}, 13/r = {13/r:.6f}  {'✓' if abs(norm_sq - 13/r) < 1e-8 else '✗'}")

# False theta functions
print("\nFalse theta sector cancellations:")

def theta_terms(a, N=8):
    """Return first N positive-n terms of Theta_a"""
    terms = {}
    for n in range(1, N*p + p):
        if n % p == a % p:
            exp_val = QQ(n^2, level)
            terms[exp_val] = terms.get(exp_val, 0) + 1
        if n % p == (-a) % p and a != 0:
            exp_val = QQ(n^2, level)
            terms[exp_val] = terms.get(exp_val, 0) - 1
    return {e:c for e,c in sorted(terms.items()) if c != 0}

T1 = theta_terms(1)
T4 = theta_terms(4)
T2 = theta_terms(2)
T3 = theta_terms(3)

# Check Theta_1 = -Theta_4
cancel14 = all(T1.get(e,0) == -T4.get(e,0) for e in set(list(T1.keys())+list(T4.keys())))
print(f"  Theta_1 = -Theta_4: {'✓' if cancel14 else '✗'}")

# Check Theta_2 = -Theta_3
cancel23 = all(T2.get(e,0) == -T3.get(e,0) for e in set(list(T2.keys())+list(T3.keys())))
print(f"  Theta_2 = -Theta_3: {'✓' if cancel23 else '✗'}")

print("\nFirst terms of Theta_1:")
for e,c in list(T1.items())[:5]:
    print(f"  {c:+}*q^{{{e}}}")

print("\nFirst terms of Theta_4 (should be -Theta_1):")
for e,c in list(T4.items())[:5]:
    print(f"  {c:+}*q^{{{e}}}")

# DGG saddle data
print("\n" + "="*60)
print("DGG SADDLE VERIFICATION")
print("="*60)

omega = exp(I*pi/3)
li2_re = pi^2/36
li2_im = RR(clausen_cl(2, pi/3))

print(f"\nomega = e^{{i*pi/3}} = {CDF(omega).n(digits=10)}")
print(f"Li_2(omega):")
print(f"  Re = pi^2/36 = {RR(pi^2/36).n(digits=10)}")
print(f"  Im = Cl_2(pi/3) = {li2_im.n(digits=10)}")
print(f"  vol(reg.tet.)/2 = {li2_im.n(digits=10)}")
print(f"  W = 2*Li_2(omega): Im(W) = vol(m003)/2 ≈ {(2*li2_im).n(digits=8)}")

print(f"\nEisenstein relation: 1 - omega = omega^{{-1}}")
print(f"  1 - omega = {CDF(1-omega).n(digits=10)}")
print(f"  1/omega   = {CDF(1/omega).n(digits=10)}")
print(f"  Match: {abs(CDF(1-omega) - CDF(1/omega)) < 1e-13}")

print(f"\nHessian: W''(omega) = omega^2 = e^{{2*pi*i/3}}")
d2W = omega / (1 - omega)
print(f"  omega/(1-omega) = {CDF(d2W).n(digits=10)}")
print(f"  omega^2         = {CDF(omega^2).n(digits=10)}")
print(f"  Match: {abs(CDF(d2W) - CDF(omega^2)) < 1e-13}")

print("\n" + "="*60)
print("ALL VERIFICATIONS COMPLETE")
print("="*60)
