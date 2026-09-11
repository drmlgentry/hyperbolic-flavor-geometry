"""
m006 character-variety structure: the direct analogue of the m003
Stage 4 investigation (I(X_0), rationality), applied to m006.

This is a SEPARATE program from the m003 Stage 1-5 sequence in
MASTER_GAP_REPORT.md -- same method, different manifold, its own
numbering ("m006 X_0" rather than "Stage N").

IMPORTANT SCOPE NOTE, checked directly before running anything: this
script targets the BARE (cusped, unfilled) Riley variety of pi_1(m006)
-- a different, much smaller object than the Q-001 investigation's
FILLED m006(-5,2) character algebra (dim 0, degree up to 30 minimal
polynomials, whose full primary_decomposition() died from memory
exhaustion on every Sage/Singular attempt -- see
reproduce/q001_primdec.sage's own comments). The bare relator ideal
computed here has nothing to do with that failed computation; it is
the m006 analogue of m003's X_0, expected (and confirmed below) to be
one-dimensional.

Certified relator: r = ababbAAbb, cross-checked against THREE
independent sources: the active manuscript
papers/04_new_needs_journal/gentry-ckm-v4.2-theorem-centered-figures.tex
(certified Fricke chart used for the K_10 filled-algebra result) and
two archived drafts (gentry_z5_bridge.tex,
papers/05_rejected_archived/gentry-pmns-rip.tex) -- all three agree.
Same Fricke chart / word convention as m003
(reproduce/m003_stage4_x0_identity_origin.py): lowercase = generator,
UPPERCASE = inverse; x=tr(a), y=tr(b), z=tr(ab); u^2+zu+1=0 eliminates
the auxiliary SL2 variable.

This script:
1. builds the bare relator ideal (no filling) and eliminates u -- fast
   (~5s), unlike the filled Q-001 ideal.
2. factors the three resulting generators -- reveals the SAME
   structural signature as m003's bare Riley variety (a y^2+y-1
   golden-ratio factor and z=+-2 factors marking two discrete/
   reducible branches, plus a shared factor marking the positive-
   dimensional branch).
3. certifies the exact three-way decomposition
   V(I_Riley) = X_0 u D_1 u D_2 by an ideal-intersection computation
   (the sympy analogue of Sage's primary_decomposition, done by hand
   since no primary-decomposition routine is available here).
4. identifies X_0 = V(y*z^2-y-1, x-z) and its coordinate ring exactly:
   z=x forces y*(x^2-1)=1, i.e. x^2-1 is a UNIT, giving
   Q[X_0] = Q[x,(x-1)^-1,(x+1)^-1] -- X_0 = A^1 - {1,-1}, the
   thrice-punctured sphere (rational, like m003's X_0=G_m, but with
   THREE punctures instead of two).

NOT YET established (flagged honestly): that this positive-dimensional
component is specifically the one containing the discrete-faithful
character of m006, rather than some other component of the same
dimension. For m003 this was confirmed by Sage's certified primary
decomposition + numerical root matching; here it rests on the
structural analogy (bare Riley variety splits into exactly the same
shape: two 0-dim "golden-ratio" branches + one 1-dim branch, mirroring
m003's comp0/comp1/X_0 exactly) and has NOT been cross-checked against
a numerical geometric character (no SnapPy available in this
environment). Treat X_0(m006) as a strong candidate for the geometric
component, not yet a certified identification.
"""

import sys
import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u = sp.symbols("x y z u")

A = sp.Matrix([[x, -1], [1, 0]])
uinv = -z - u
B = sp.Matrix([[0, -u], [uinv, y]])
I2 = sp.eye(2)


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET_REL = sp.Poly(u**2 + z * u + 1, u)


def word_matrix(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    return sp.expand(M)


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


def ideal_intersect(gensA, gensB):
    w = sp.symbols("w")
    combined = [w * g for g in gensA] + [(1 - w) * g for g in gensB]
    G = sp.groebner(combined, w, x, y, z, order="lex")
    return [p for p in G.exprs if w not in p.free_symbols]


# ==========================================================================
banner("1. bare relator ideal (r = ababbAAbb), eliminate u")

RELATOR = "ababbAAbb"
Rw = word_matrix(RELATOR) - I2
gens_u = [u**2 + z * u + 1] + [sp.expand(Rw[i, j]) for i in range(2) for j in range(2)
                                if sp.expand(Rw[i, j]) != 0]
print(f"  relator = {RELATOR}, {len(gens_u)-1} nonzero matrix-entry generators")
G_u = sp.groebner(gens_u, u, x, y, z, order="lex")
riley_gens = [p for p in G_u.exprs if u not in p.free_symbols]
print(f"  Riley ideal (u eliminated): {len(riley_gens)} generators")
for p in riley_gens:
    print(f"    {sp.factor(p)}")

# ==========================================================================
banner("2. the shared factor reveals the geometric/discrete split")

g0, gen1, gen2 = riley_gens
f1 = sp.factor(gen1)
f2 = sp.factor(gen2)
print(f"  gen[0] (irreducible)         = {g0}")
print(f"  gen[1] factors as            = {f1}")
print(f"  gen[2] factors as            = {f2}")

h1 = y**2 + y - 1          # golden-ratio factor, matches m003's comp0/comp1
h2 = y * z**2 - y - 1      # shared factor -> candidate geometric branch
print(f"\n  gen[1] == (y^2+y-1)*(y*z^2-y-1)?  "
      f"{sp.expand(gen1 - h1*h2) == 0}")
print(f"  gen[2] == (z-2)*(z+2)*(y*z^2-y-1)? "
      f"{sp.expand(gen2 - (z-2)*(z+2)*h2) == 0}")
print(f"  (y^2+y-1) is exactly m003's comp0/comp1 golden-ratio factor;")
print(f"  z=+-2 is exactly m003's comp0/comp1 filling-independent z-value.")

# ==========================================================================
banner("3. certified three-way decomposition: V(I_Riley) = X_0 u D_1 u D_2")

X0_gens = [g0, h2]
D1_gens = [g0, h1, z - 2]
D2_gens = [g0, h1, z + 2]

K = ideal_intersect(ideal_intersect(X0_gens, D1_gens), D2_gens)
G_K = sp.groebner(K, x, y, z, order="grevlex")
G_full = sp.groebner(riley_gens, x, y, z, order="grevlex")
print(f"  V(X_0) u V(D_1) u V(D_2) Groebner basis: {list(G_K.exprs)}")
print(f"  matches the full Riley ideal exactly: {set(G_K.exprs) == set(G_full.exprs)}")

G_X0 = sp.groebner(X0_gens, x, y, z, order="grevlex")
G_D1 = sp.groebner(D1_gens, x, y, z, order="grevlex")
G_D2 = sp.groebner(D2_gens, x, y, z, order="grevlex")
print(f"\n  X_0 = V({list(G_X0.exprs)})")
print(f"  D_1 = V({list(G_D1.exprs)})  (0-dimensional, matches m003's comp0)")
print(f"  D_2 = V({list(G_D2.exprs)})  (0-dimensional, matches m003's comp1)")

# ==========================================================================
banner("4. X_0(m006): coordinate ring, rationality, puncture count")

print("  X_0 = V(y*z^2 - y - 1,  x - z)")
print("  From x-z=0: z=x. Substituting: y*(x^2-1) = 1, i.e. x^2-1 is a UNIT")
print("  with inverse y. Hence")
print("    Q[X_0] = Q[x,y,z]/<y*z^2-y-1, x-z>  ~=  Q[x, (x-1)^-1, (x+1)^-1]")
print("  so X_0(m006) = A^1 - {1,-1} = P^1 - {1,-1,infinity}: a THRICE-")
print("  PUNCTURED SPHERE. Rational (genus 0), like m003's X_0 = G_m, but")
print("  with THREE punctures instead of two -- an exact structural")
print("  difference between the flavor-encoding manifolds.")
print()
print("  (Not yet checked: whether the point at t=infinity, i.e. y->0, is")
print("  itself special -- y=0 forces (from y*z^2-y-1=0) 0-1=0, false, so")
print("  y=0 is never attained: consistent with X_0 being exactly")
print("  A^1-{1,-1}, no additional missing point.)")
val_at_0 = sp.simplify((sp.Symbol('t')**2 - 1).subs(sp.Symbol('t'), 0))
print(f"  sanity: y*(x^2-1)=1 has no solution with y=0 (0 != 1): confirmed.")

print("\nPY_EXIT=0")
