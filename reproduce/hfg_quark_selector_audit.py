#!/usr/bin/env python3
"""
Audit natural geometry-only quark-index selector candidates.

Inputs used by candidate rules are arithmetic data only:
- shared Farey tower p_n = 5 n(n+1)+1
- X0(11) curve E: y^2+y=x^3-x^2
- m006 cusp Galois group S3 (order 6)
- m006 boundary conductor/discriminant prime 59

Observed q values are used ONLY in the evaluation section.
"""

from math import log, sqrt

def is_prime(n):
    if n < 2: return False
    if n % 2 == 0: return n == 2
    d=3
    while d*d<=n:
        if n%d==0: return False
        d += 2
    return True

def tower(n):
    return 5*n*(n+1)+1

def ap(p):
    # E: y^2+y=x^3-x^2
    count = 1
    for x in range(p):
        rhs=(x*x*x-x*x)%p
        for y in range(p):
            if (y*y+y-rhs)%p==0:
                count += 1
    return p+1-count

tower_primes=[]
for n in range(1,20):
    p=tower(n)
    if is_prime(p):
        tower_primes.append((n,p,ap(p)))

print("=== ARITHMETIC INPUT ===")
for n,p,a in tower_primes[:8]:
    print(f"n={n:2d}  p_n={p:4d}  a_p={a:3d}")

S3_ORDER=6
CONDUCTOR=59
print(f"\n|S3|={S3_ORDER}, conductor={CONDUCTOR}")

# Natural sequential rule: q_n = p_n + a_{p_n}
seq=[p+a for n,p,a in tower_primes[:6]]
print("\nCandidate A: q_n = p_n + a_{p_n}")
print(seq)

# Natural shared-base paired rule:
# first two indices from first tower prime plus first two Hecke corrections
pair1=[tower_primes[0][1] + tower_primes[j][2] for j in (0,1)]
print("\nCandidate B first generation: p1 + {a_p1,a_p2}")
print(pair1)

# Conductor-centered residue structure of empirical q's shown ONLY in evaluation.
observed={"u":12,"d":18,"s":43,"c":65,"b":75,"t":106}
print("\n=== EVALUATION ONLY ===")
print("Observed q values:", observed)
print("Residues q mod 59:", {k:v%59 for k,v in observed.items()})
print("Exact conductor reflection pairs:")
items=list(observed.items())
for i,(a,qa) in enumerate(items):
    for b,qb in items[i+1:]:
        if qa+qb==2*CONDUCTOR:
            print(f"  {a}+{b}: {qa}+{qb}=118=2*59")

# Check simplest exact matches among p_n + c*a_pn for intrinsic c in {1,2,3,6}
print("\nMatches of q = p_n + c*a_pn, c in {1,2,3,6}:")
for name,q in observed.items():
    hits=[]
    for n,p,a in tower_primes:
        for c in [1,2,3,6]:
            if p+c*a == q:
                hits.append((n,p,a,c))
    print(name, hits)

print("\nVERDICT:")
print("No single uniform, geometry-only rule from the verified m006 invariants")
print("reproduces all six quark q-indices. Several low-complexity partial matches")
print("exist, but extending them requires changing coefficients or bases post hoc.")
