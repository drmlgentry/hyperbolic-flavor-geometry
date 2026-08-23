#!/usr/bin/env python3
import sympy as sp

x = sp.symbols('x')
f = 8*x**3 - 24*x**2 + 28*x - 11
DISC_PRIME = 59

def tower(n):
    return 5*n*(n+1)+1

def frobenius_cycle_type(p):
    if p == DISC_PRIME:
        return ("ramified", [])
    fac = sp.factor_list(sp.Poly(f, x, modulus=p))[1]
    degrees = []
    factors = []
    for poly, e in fac:
        P = sp.Poly(poly, x, modulus=p)
        factors.extend([P.as_expr()] * e)
        degrees.extend([P.degree()] * e)
    degrees = tuple(sorted(degrees))
    if degrees == (1,1,1):
        ctype = "identity"
        artin_trace = 2
        sign = +1
        order = 1
    elif degrees == (1,2):
        ctype = "transposition"
        artin_trace = 0
        sign = -1
        order = 2
    elif degrees == (3,):
        ctype = "3-cycle"
        artin_trace = -1
        sign = +1
        order = 3
    else:
        ctype = f"unexpected {degrees}"
        artin_trace = None
        sign = None
        order = None
    return (ctype, degrees, factors, artin_trace, sign, order)

print("S3 Frobenius audit for f(x)=8x^3-24x^2+28x-11")
print("n   p_n    class          splitting    chi_std  sign  order")
print("-"*70)

rows=[]
for n in range(1, 15):
    p = tower(n)
    if not sp.isprime(p):
        continue
    ctype, degs, factors, tr, sign, order = frobenius_cycle_type(p)
    rows.append((n,p,ctype,degs,tr,sign,order,factors))
    print(f"{n:2d}  {p:4d}    {ctype:13s} {str(degs):12s} {str(tr):>7s} {str(sign):>5s} {str(order):>5s}")

print("\nFirst six tower primes:")
for r in rows[:6]:
    n,p,ctype,degs,tr,sign,order,factors=r
    print(f"p_{n}={p}: {ctype}, factors mod p = {factors}")

print("\nNO-GO CHECK")
first6 = rows[:6]
same = len({r[2] for r in first6}) == 1
print("All first six prime tower sites have same Frobenius conjugacy class:", same)
print("Distinct conjugacy classes among first six:", sorted({r[2] for r in first6}))
print("Distinct standard Artin traces among first six:", sorted({r[4] for r in first6}))

print("\nConclusion:")
print("A selector depending only on the S3 Frobenius conjugacy class, splitting type,")
print("standard character trace, sign, or element order cannot distinguish six quark slots.")
print("To obtain six distinct labels one must add non-class-function data, such as a")
print("canonical root/embedding labeling supplied by geometry. Without such extra structure,")
print("the S3 Frobenius selector is underdetermined.")
