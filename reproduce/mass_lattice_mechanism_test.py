
import math
import random

# HFG mass-lattice audit / mechanism test
# Uses the central values that have appeared in the HFG working corpus.
# Replace these with a frozen PDG input file for any publication-grade rerun.

phi = (1 + math.sqrt(5)) / 2

masses = {
    "e":   5.11000e-4,   # GeV
    "mu":  1.05660e-1,
    "tau": 1.77686,
    "u":   2.16000e-3,
    "d":   4.67000e-3,
    "s":   9.34000e-2,
    "c":   1.27500,
    "b":   4.18000,
    "t":   1.72760e2,
}

def q_exact(m):
    return 4.0 * math.log(m / masses["e"]) / math.log(phi)

def nearest_int_residual(x):
    return abs(x - round(x))

def lucas(n):
    a, b = 2, 1
    if n == 0: return a
    if n == 1: return b
    for _ in range(2, n+1):
        a, b = b, a+b
    return b

def eisenstein_norm(a,b):
    return a*a - a*b + b*b

def distinct_eisenstein_norms(bound=120):
    vals = set()
    for a in range(-bound, bound+1):
        for b in range(-bound, bound+1):
            vals.add(eisenstein_norm(a,b))
    return sorted(vals)

def nearest_value(sorted_vals, x):
    import bisect
    i = bisect.bisect_left(sorted_vals, x)
    cand = []
    if i < len(sorted_vals): cand.append(sorted_vals[i])
    if i > 0: cand.append(sorted_vals[i-1])
    return min(cand, key=lambda v: abs(v-x))

print("=== HFG MASS-LATTICE MECHANISM TEST ===\n")

print("1) phi^(q/4) lattice residuals")
residuals = []
for name,m in masses.items():
    q = q_exact(m)
    r = nearest_int_residual(q)
    if name != "e":
        residuals.append(r/4.0)
    print(f"{name:>4s}: q_exact={q:9.4f}  q_nearest={round(q):4d}  "
          f"resid(q)={r:.4f}  resid(phi-units)={r/4:.4f}")

rms = math.sqrt(sum(r*r for r in residuals)/len(residuals))
print(f"\nRMS residual over 8 non-electron charged fermions = {rms:.5f} phi-units")

print("\n2) Lucas charged-lepton check")
r_mu = masses["mu"]/masses["e"]
r_tau = masses["tau"]/masses["e"]
for idx, target, label in [(11,r_mu,"mu/e"),(17,r_tau,"tau/e")]:
    L = lucas(idx)
    err = abs(L-target)/target*100
    print(f"L_{idx}={L:6d} vs {label}={target:.6f}: relative error={err:.4f}%")

print("\n3) Eisenstein-norm nearest-match check")
vals = distinct_eisenstein_norms(120)
for target,label in [(r_mu,"mu/e"),(r_tau,"tau/e")]:
    n = nearest_value(vals,target)
    err = abs(n-target)/target
    print(f"{label}: nearest norm={n}, relative error={100*err:.5f}%")

# Illustrative search-aware null: random targets in the same 150..4000 window.
# Two choices shown to make the null sensitivity explicit.
N = 20000
rng = random.Random(20260822)
def null_p(target_err, mode):
    count = 0
    lo, hi = 150.0, 4000.0
    for _ in range(N):
        if mode == "uniform":
            x = rng.uniform(lo,hi)
        else:
            x = math.exp(rng.uniform(math.log(lo),math.log(hi)))
        n = nearest_value(vals,x)
        err = abs(n-x)/x
        if err <= target_err:
            count += 1
    return count/N

for target,label in [(r_mu,"mu/e"),(r_tau,"tau/e")]:
    n = nearest_value(vals,target)
    e = abs(n-target)/target
    pu = null_p(e,"uniform")
    pl = null_p(e,"log")
    print(f"{label}: illustrative nearest-norm null p_uniform={pu:.4f}, p_loguniform={pl:.4f}")

print("\n4) Discriminant-prime Lucas membership")
disc_primes = [3,7,59,283]
lucas_vals = {lucas(i):i for i in range(0,20)}
for p in disc_primes:
    print(f"{p:3d}: " + (f"Lucas L_{lucas_vals[p]}" if p in lucas_vals else "not a Lucas number"))

print("\n5) Mechanism status")
print("PASS: geometry/arithmetic can motivate the scale log(phi).")
print("PASS: Lucas/Fibonacci trace identities are exact conditional algebra.")
print("OPEN: no geometry-derived rule currently selects the occupied q values for each fermion.")
print("WEAK: whole-spectrum phi-lattice significance is marginal/non-significant in existing HFG nulls.")
print("FAIL AS CURRENT MECHANISM: post-hoc Eisenstein/Lucas near-matches do not by themselves select masses.")
