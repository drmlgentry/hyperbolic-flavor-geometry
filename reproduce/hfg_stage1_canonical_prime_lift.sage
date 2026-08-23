#!/usr/bin/env sage
# HFG Stage 1: canonical prime-lift test for the m006 S3 field
#
# Goal
# ----
# For tower primes p with cubic splitting type (1,2):
#   Q -> K (degree 3, non-Galois) -> L (degree 6, S3 Galois closure)
#
# test whether:
#   (i)  p O_K has a UNIQUE degree-1 prime q,
#   (ii) q has a UNIQUE prime P above it in L,
#   (iii) the decomposition group D(P) equals H = Gal(L/K),
#   (iv) hence Frobenius at that selected P is the unique nontrivial
#        element of H (a specific transposition, once K⊂L is fixed).
#
# This is exact ideal arithmetic. No particle masses enter.
#
# Run:
#   sage hfg_stage1_canonical_prime_lift.sage
#
# Output:
#   results/stage1_canonical_prime_lift.txt   (if results/ exists)
#   or stdout only.

from sage.all import *
import os, sys, time

print("="*78)
print("HFG STAGE 1 — CANONICAL PRIME-LIFT TEST (m006 cubic → S3 closure)")
print("="*78)
sys.stdout.flush()

# ----------------------------------------------------------------------
# 0. Exact field
# ----------------------------------------------------------------------
R.<x> = PolynomialRing(QQ)
f = x^3 + 2*x + 1

print("\n[0/6] Building exact cubic field K...")
K.<a> = NumberField(f)
OK = K   # disc(f)=-59 is squarefree, so Z[a] is already the maximal order;
         # use K.ideal(...) directly since order-object ideals lack .factor()

print("  f(x)             =", f)
print("  [K:Q]            =", K.degree())
print("  field discriminant =", K.discriminant())
print("  signature         =", K.signature())
sys.stdout.flush()

# ----------------------------------------------------------------------
# 1. Galois closure WITH explicit embedding K -> L
# ----------------------------------------------------------------------
print("\n[1/6] Building Galois closure L and embedding iota: K -> L...")
t0 = time.time()

try:
    L, iota = K.galois_closure('b', map=True)
except TypeError:
    # Fallback for Sage versions with different signature.
    tmp = K.galois_closure(names='b', map=True)
    L, iota = tmp

OL = L   # same reasoning: use L.ideal(...) directly, not the order object
print("  [L:Q]            =", L.degree())
print("  elapsed           = %.3fs" % (time.time()-t0))
sys.stdout.flush()

# ----------------------------------------------------------------------
# 2. Galois group and the distinguished subgroup H = Gal(L / iota(K))
# ----------------------------------------------------------------------
print("\n[2/6] Computing G = Gal(L/Q) and H = Gal(L/iota(K))...")
G = L.galois_group()
print("  |G|               =", G.order())
print("  G structure        =", G.structure_description())

ia = iota(a)

def fixes_K(sigma):
    return sigma(ia) == ia

H = [sigma for sigma in G if fixes_K(sigma)]
print("  |H|               =", len(H))
print("  H elements         =", H)

if len(H) != 2:
    raise RuntimeError("Expected |Gal(L/K)| = 2; got %s" % len(H))

h_nontriv = [s for s in H if s != G.identity()][0]
print("  distinguished nontrivial h in H =", h_nontriv)
sys.stdout.flush()

# ----------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------
def tower(n):
    return ZZ(5*n*(n+1)+1)

def ideal_extend_via_embedding(q, emb, target_ring):
    """
    Extend ideal q of O_K to O_L using explicit K -> L embedding.
    """
    gensL = [emb(K(g)) for g in q.gens()]
    return target_ring.ideal(gensL)

def ideal_image(P, sigma, target_ring):
    """
    Galois image sigma(P).
    """
    return target_ring.ideal([sigma(L(g)) for g in P.gens()])

def residue_degree_from_norm(P, p):
    """
    For an unramified prime P over p, Norm(P)=p^f.
    Recover f exactly.
    """
    N = ZZ(P.norm())
    fdeg = 0
    while N % p == 0:
        N //= p
        fdeg += 1
    if N != 1:
        return None
    return fdeg

# ----------------------------------------------------------------------
# 3. Prime-by-prime exact test
# ----------------------------------------------------------------------
print("\n[3/6] Factoring tower primes in K and lifting the unique degree-1 prime...")
print()
header = (
    " n    p      factor degrees in K     q1 unique?   "
    "q1O_L factors    f(P/Q)   |D(P)|   D(P)=H?"
)
print(header)
print("-"*len(header))
sys.stdout.flush()

records = []

for n in range(1, 15):
    p = tower(n)
    if not p.is_prime():
        continue
    if p == 59:
        continue

    facK = OK.ideal(p).factor()

    # For a prime q over p, Norm(q)=p^f in this unramified cubic.
    q_data = []
    for q,e in facK:
        fq = residue_degree_from_norm(q, p)
        q_data.append((q, e, fq))

    degs = sorted([fq for q,e,fq in q_data for _ in range(e)])
    degree1 = [(q,e,fq) for q,e,fq in q_data if fq == 1]

    if len(degree1) != 1:
        print("%2d  %4d    %-24s   %-10s" % (n,p,str(degs),"NO"))
        records.append((n,p,degs,False,None,None,None,None))
        continue

    q1 = degree1[0][0]

    # Extend q1 to L using the explicit K -> L embedding.
    q1L = ideal_extend_via_embedding(q1, iota, OL)
    facL = q1L.factor()

    # Collect primes above q1.
    P_list = []
    for P,e in facL:
        for _ in range(e):
            P_list.append(P)

    # If unique, compute decomposition group by ideal stabilizer.
    if len(P_list) == 1:
        P = P_list[0]
        fP = residue_degree_from_norm(P, p)
        D = [sigma for sigma in G if ideal_image(P, sigma, OL) == P]
        sameH = (set(D) == set(H))
        print("%2d  %4d    %-24s   %-10s   %-13s   %-6s   %-6d   %s"
              % (n,p,str(degs),"YES",str(len(P_list)),str(fP),len(D),str(sameH)))
        records.append((n,p,degs,True,len(P_list),fP,len(D),sameH))
    else:
        print("%2d  %4d    %-24s   %-10s   %-13s"
              % (n,p,str(degs),"YES",str(len(P_list))))
        records.append((n,p,degs,True,len(P_list),None,None,None))

    sys.stdout.flush()

# ----------------------------------------------------------------------
# 4. Check the first six prime tower sites specifically
# ----------------------------------------------------------------------
print("\n[4/6] First-six-site verdict")
first_six = records[:6]

all_12 = all(r[2] == [1,2] for r in first_six)
all_unique_q = all(r[3] for r in first_six)
all_unique_P = all(r[4] == 1 for r in first_six if r[3])
all_D_eq_H = all(r[7] is True for r in first_six if r[4] == 1)

print("  all splitting type (1,2):         ", all_12)
print("  unique degree-1 q in K:           ", all_unique_q)
print("  unique P above selected q in L:   ", all_unique_P)
print("  D(P) = H = Gal(L/K):              ", all_D_eq_H)
sys.stdout.flush()

# ----------------------------------------------------------------------
# 5. Mathematical interpretation
# ----------------------------------------------------------------------
print("\n[5/6] Interpretation")
if all_12 and all_unique_q and all_unique_P and all_D_eq_H:
    print("""
PASS.

For each tested transposition-type tower prime p:
  p O_K = q1 * q2
with q1 the unique residue-degree-1 prime of the distinguished cubic K.

The selected q1 remains prime in the quadratic extension L/K, so it has a
unique prime P above it. Its decomposition group is exactly

    D(P) = H = Gal(L/K) ≅ C2.

Therefore the Frobenius at this canonically selected P is the unique
nontrivial element h of H.

This DOES canonically lift the transposition conjugacy class to one
specific transposition AFTER the geometric cubic subfield K⊂L has been fixed.

But it also implies a NO-GO for six distinct quark labels from this datum
alone: all such primes select the SAME transposition h.
""")
else:
    print("""
The clean canonical-lift pattern did not hold uniformly.
Inspect the rows above before drawing any structural conclusion.
""")

# ----------------------------------------------------------------------
# 6. Next-stage target
# ----------------------------------------------------------------------
print("[6/6] Stage-2 target")
print("""
If Stage 1 passes, Stage 2 should NOT search for another Frobenius class rule.
Instead test whether additional geometric data supplies the missing coset/orbit
label, e.g.

  (selected transposition h) × (three geometric embedding/cusp sectors)

or an independent orientation/peripheral label that produces a six-element
torsor without arbitrary choices.

The key question becomes:
  Can the m006 holonomy/peripheral geometry canonically distinguish the
  three conjugate cubic subfields / cosets G/H?

If yes, h combined with that 3-state datum gives 2×3 = 6 slots naturally.
""")

print("="*78)
print("STAGE 1 COMPLETE")
print("="*78)
