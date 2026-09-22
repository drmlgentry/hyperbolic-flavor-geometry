"""
Two verifications requested after the intersection-point theorem.

PART 1 -- Fox-calculus / Alexander-polynomial interpretation of X_0 cap N.
  A reducible character s: pi -> C^*, s(a)=lambda, s(b)=1 (the points of N),
  gives psi = s^2: a -> t = lambda^2, b -> 1. The classical necessary condition
  for such a reducible character to be a limit of irreducible ones is
  H^1(pi; C_psi) != 0, i.e. (one relator r, two generators) that the Fox row
  (dr/da, dr/db) evaluated at psi vanishes. We compute the Fox derivatives of the
  certified relators, solve dr/db|_psi = 0, and compare with X_0 cap N computed
  independently (Groebner elimination). Nothing here assumes the theorem.

PART 2 -- coordinate-free version of the specialization lemma.
  For a homomorphism ell(w) = alpha*e_a(w) + beta*e_b(w) put rho(a)=A^alpha,
  rho(b)=A^beta, A = [[c,-1],[1,0]]. Then tr rho(w) = S_{|ell(w)|}(c), and the
  character is (x,y,z) = (S_{|alpha|}(c), S_{|beta|}(c), S_{|alpha+beta|}(c)).
  Verify tau_w(S_alpha, S_beta, S_{alpha+beta}) == S_{|ell(w)|} as polynomials
  in c for every word of the length<=10 census, for several (alpha,beta).
"""

import json
import sys

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u, t, c = sp.symbols("x y z u t c")


def banner(msg):
    print("\n" + "=" * 78 + "\n" + msg + "\n" + "=" * 78, flush=True)


# ------------------------------------------------------------------ PART 1
def fox_under_psi(word, tt):
    """Fox derivatives (dr/da, dr/db) under psi: a -> tt, b -> 1."""
    da = sp.Integer(0)
    db = sp.Integer(0)
    p = 0  # net a-exponent of the prefix; psi(prefix) = tt**p
    for ch in word:
        if ch == "a":
            da += tt**p
            p += 1
        elif ch == "A":
            p -= 1
            da -= tt**p
        elif ch == "b":
            db += tt**p
        elif ch == "B":
            db -= tt**p
        else:
            raise ValueError(ch)
    return sp.simplify(da), sp.simplify(db), p


banner("PART 1. Fox calculus: dr/db at psi (a->t, b->1), versus X_0 cap N")
CASES = {
    "m003": dict(r="abAAbabbb", ga=x * z + 1, gb=x**2 + y - 1),
    "m006": dict(r="ababbAAbb", ga=x - z, gb=y * z**2 - y - 1),
}
for name, cfg in CASES.items():
    r = cfg["r"]
    ea = r.count("a") - r.count("A")
    eb = r.count("b") - r.count("B")
    da, db, pfinal = fox_under_psi(r, t)
    print(f"\n  {name}: r = {r}, e_a(r)={ea}, e_b(r)={eb}")
    print(f"    precondition e_a(r)=0 (needed since lambda is not a root of unity): {ea == 0}")
    print(f"    dr/da at psi = {da}   (fundamental identity forces 0 when e_a=0 and t != 1)")
    print(f"    dr/db at psi = {sp.factor(db)}")
    assert ea == 0 and da == 0
    # solutions of dr/db = 0, and the resulting x-coordinates c = lambda + 1/lambda
    roots_t = sp.solve(sp.numer(sp.together(db)), t)
    csq_fox = sorted({sp.simplify(tv + 2 + 1 / tv) for tv in roots_t}, key=str)
    # independent: X_0 cap N by elimination
    sol = sp.solve([cfg["ga"], cfg["gb"], x - z, y - 2], [x, y, z], dict=True)
    csq_int = sorted({sp.simplify(s_[x] ** 2) for s_ in sol}, key=str)
    print(f"    roots t=lambda^2 of dr/db: {roots_t}")
    print(f"    c^2 = t + 2 + 1/t from Fox roots: {csq_fox}")
    print(f"    c^2 from X_0 cap N (independent Groebner/solve): {csq_int}")
    print(f"    MATCH: {csq_fox == csq_int}")
    assert csq_fox == csq_int
    # is t a root of unity?  (algebraic integer test on the primitive integer polynomial)
    P = sp.Poly(sp.numer(sp.together(db)), t)
    lead = P.LC()
    print(f"    primitive integer polynomial {P.as_expr()}, leading coeff {lead}: "
          f"{'monic' if abs(lead) == 1 else 'NOT monic, so roots are not algebraic integers, hence not roots of unity'}")
    if abs(lead) == 1:
        mods = [sp.N(abs(rt)) for rt in roots_t]
        print(f"    monic; root moduli {mods} (roots of unity have modulus 1)")

# ------------------------------------------------------------------ PART 2
banner("PART 2. coordinate-free specialization: tr rho(w) = S_{|ell(w)|}(c)")
A = sp.Matrix([[x, -1], [1, 0]])
B = sp.Matrix([[0, -u], [-z - u, y]])


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET = sp.Poly(u**2 + z * u + 1, u)


def tr_xyz(w):
    M = sp.eye(2)
    for ch in w:
        M = M * MATS[ch]
    tr = sp.expand(M.trace())
    _, r_ = sp.div(sp.Poly(tr, u), DET, u)
    return sp.expand(r_.as_expr())


with open("m003_traces_len10_cache.json") as f:
    words = json.load(f)["words"]
with open("m003_collision_words_trxyz_cache.json") as f:
    trxyz = {w: sp.expand(sp.sympify(v)) for w, v in json.load(f).items()}
for w in words:
    if w not in trxyz:
        trxyz[w] = tr_xyz(w)


def S(n):
    a_, b_ = sp.Integer(2), c
    if n == 0:
        return a_
    for _ in range(n - 1):
        a_, b_ = b_, sp.expand(c * b_ - a_)
    return b_


Smax = max(abs(w.count("a") - w.count("A")) * 3 + abs(w.count("b") - w.count("B")) * 3 for w in words) + 12
Sc = {n: S(n) for n in range(0, Smax + 1)}

for (al, be) in [(1, 0), (0, 1), (1, 1), (2, 3), (1, -2)]:
    point = {x: Sc[abs(al)], y: Sc[abs(be)], z: Sc[abs(al + be)]}
    bad = 0
    for w in words:
        ell = al * (w.count("a") - w.count("A")) + be * (w.count("b") - w.count("B"))
        lhs = sp.expand(trxyz[w].subs(point, simultaneous=True))
        if sp.expand(lhs - Sc[abs(ell)]) != 0:
            bad += 1
    print(f"  ell = {al}*e_a + {be}*e_b: character (S_{abs(al)}, S_{abs(be)}, S_{abs(al+be)}); "
          f"mismatches over {len(words)} words: {bad}")
    assert bad == 0

print("\nPY_EXIT=0")
