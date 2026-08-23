#!/usr/bin/env python3
"""
HFG geometry-only charged-lepton mass-index selector (candidate rule)

IMPORTANT:
- The selector itself does NOT read particle masses.
- It uses only arithmetic/topological data already present in the HFG corpus:
    H1 = Z/5
    Farey-tower primes p_n = 5 n(n+1)+1
    modular conductor N = 11 = p_1
    order-5 character conductor 31 = p_2
    level-11 elliptic curve E: y^2 + y = x^3 - x^2
- The physical comparison is performed only AFTER the indices are produced.

Status: candidate mechanism, not a theorem of HFG.
"""

from math import sqrt, log

# ------------------------------
# Geometry/arithmetic input only
# ------------------------------
H_ORDER = 5

def tower_value(n):
    return 5*n*(n+1) + 1

# first tower levels
tower = {n: tower_value(n) for n in range(1, 10)}

MODULAR_CONDUCTOR = tower[1]      # 11
CHARACTER_CONDUCTOR = tower[2]    # 31

def is_prime(n):
    if n < 2:
        return False
    if n % 2 == 0:
        return n == 2
    d = 3
    while d*d <= n:
        if n % d == 0:
            return False
        d += 2
    return True

def primitive_root_mod_prime(p):
    # simple brute-force primitive root
    phi = p - 1
    fac = []
    n = phi
    q = 2
    while q*q <= n:
        if n % q == 0:
            fac.append(q)
            while n % q == 0:
                n //= q
        q += 1
    if n > 1:
        fac.append(n)
    for g in range(2, p):
        if all(pow(g, phi//q, p) != 1 for q in fac):
            return g
    raise RuntimeError("no primitive root found")

def discrete_log_bruteforce(a, g, p):
    x = 1
    for e in range(p-1):
        if x == a % p:
            return e
        x = (x*g) % p
    raise ValueError("no discrete log")

# primitive order-5 character modulo 31:
# chi_5(p) = zeta_5^(log_g(p) mod 5).
g31 = primitive_root_mod_prime(31)

def chi5_exponent(p):
    if p % 31 == 0:
        return None   # ramified / conductor
    e = discrete_log_bruteforce(p % 31, g31, 31)
    return e % 5

def first_postconductor_trivial_tower_prime():
    # Search tower levels strictly after p_2 = 31.
    for n in range(3, 100):
        p = tower_value(n)
        if is_prime(p) and chi5_exponent(p) == 0:
            return n, p
    raise RuntimeError("not found")

# Level-11 elliptic curve:
# E : y^2 + y = x^3 - x^2
def hecke_ap(p):
    # For good primes p, a_p = p + 1 - #E(F_p).
    count = 1  # point at infinity
    for x in range(p):
        rhs = (x*x*x - x*x) % p
        for y in range(p):
            if (y*y + y - rhs) % p == 0:
                count += 1
    return p + 1 - count

n_star, p_star = first_postconductor_trivial_tower_prime()
a_star = hecke_ap(p_star)

# ---------------------------------
# Candidate geometry-only selector
# ---------------------------------
#
# Nonzero classes of Z/5: 4.
# Inversion orbits {±1}, {±2}: 2.
#
# Q is the integer in m = m_e * phi^(Q/4).
#
# Transition 1:
#   Q_mu - Q_e = (# nonzero classes) * p_1 = 4*11.
#
# Transition 2:
#   Q_tau - Q_mu = (# inversion orbits) * |a_{p*}| = 2*12.
#
# This gives Q = 0,44,68 without reading masses.

nonzero_classes = H_ORDER - 1
inverse_orbits = (H_ORDER - 1)//2

Q_e = 0
Q_mu = Q_e + nonzero_classes * MODULAR_CONDUCTOR
Q_tau = Q_mu + inverse_orbits * abs(a_star)

print("=== GEOMETRY-ONLY SELECTOR ===")
print(f"H1 order                         = {H_ORDER}")
print(f"nonzero H1 classes               = {nonzero_classes}")
print(f"inversion orbits of nonzero H1   = {inverse_orbits}")
print(f"p_1                              = {MODULAR_CONDUCTOR}")
print(f"p_2 (character conductor)        = {CHARACTER_CONDUCTOR}")
print(f"first post-conductor prime with chi5=1: p_{n_star} = {p_star}")
print(f"a_{p_star} for X0(11) curve      = {a_star}")
print()
print(f"Predicted Q_e   = {Q_e}")
print(f"Predicted Q_mu  = {Q_mu}")
print(f"Predicted Q_tau = {Q_tau}")
print()
print("Equivalent k = Q/4 indices:")
print(f"k_e={Q_e/4:g}, k_mu={Q_mu/4:g}, k_tau={Q_tau/4:g}")

# ---------------------------------
# Evaluation only: masses enter here
# ---------------------------------
phi = (1 + sqrt(5))/2
m_e = 0.51099895 # MeV
observed = {
    "e": 0.51099895,
    "mu": 105.6583755,
    "tau": 1776.86,
}
predQ = {"e": Q_e, "mu": Q_mu, "tau": Q_tau}

print("\n=== POST-HOC EVALUATION (NOT USED BY SELECTOR) ===")
for name in ["e","mu","tau"]:
    pred = m_e * phi**(predQ[name]/4)
    obs = observed[name]
    rel = abs(pred-obs)/obs*100
    q_exact = 4*log(obs/m_e)/log(phi)
    print(f"{name:>3}: Q_pred={predQ[name]:>3}, Q_exact={q_exact:9.4f}, "
          f"m_pred={pred:11.6f} MeV, m_obs={obs:11.6f} MeV, error={rel:7.3f}%")

print("\nSTATUS:")
print("  The numerical selector is mass-blind.")
print("  The rule is NOT yet canonically derived.")
print("  Missing proof: why the first transition uses the 4 nonzero H1 classes")
print("  with p1, and why the second uses the 2 inversion orbits with a_p*.")
