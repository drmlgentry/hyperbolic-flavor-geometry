"""
verify_frobenius.py
===================
Reproduces Table 1 of the NT paper (§2, Frobenius discriminant theorem).

Tests: for each Farey tower prime p_k = 5k(k+1)+1 up to k=7,
compute a_p = a_p(X_0(11)) and check whether a_p^2 - 4p = -3*m^2.
Expected: PASS only at p=31.

Run (WSL, conda activate sage):
  python3 reproduce/verify_frobenius.py

Expected output: all PASS, final line THEOREM A: VERIFIED
"""
from sage.all import EllipticCurve, Rational, Integer, ZZ

E = EllipticCurve('11a1')   # X_0(11), a_31 = 7

tower = [11, 31, 61, 101, 151, 211, 281]   # p_k = 5k(k+1)+1, k=1..7

print("Frobenius discriminant at each Farey tower prime")
print(f"{'p':>5}  {'a_p':>5}  {'D=a_p^2-4p':>12}  {'-D/3':>10}  {'square?':>8}  {'passes?':>8}")
print("-" * 65)

results = {}
for p in tower:
    ap = E.ap(p)
    D  = ap**2 - 4*p
    ratio = Rational(-D, 3)
    is_int = ratio in ZZ
    is_sq  = is_int and Integer(ratio).is_square()
    passes = is_sq

    results[p] = passes
    sq_str  = f"YES (m={Integer(ratio).sqrt()})" if is_sq else ("no (not sq)" if is_int else "no (not int)")
    pass_str = "PASS" if passes else "----"
    print(f"{p:>5}  {ap:>5}  {D:>12}  {str(ratio):>10}  {sq_str:>8}  {pass_str:>8}")

print()

# Assertions
errors = []
for p in tower:
    expected = (p == 31)
    if results[p] != expected:
        errors.append(f"p={p}: expected {'PASS' if expected else 'FAIL'}, got {'PASS' if results[p] else 'FAIL'}")

if errors:
    for e in errors:
        print(f"ERROR: {e}")
    print("\nTHEOREM A: FAILED")
else:
    print("Unique solution: p=31 (a_31=7, D=-75=-3*25, m=5)")
    print("All other tower primes: no solution")
    print("\nTHEOREM A: VERIFIED  [PASS]")
