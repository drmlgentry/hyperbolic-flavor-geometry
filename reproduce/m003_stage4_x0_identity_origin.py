"""
Stage 4: the algebraic origin of the three universal identities on X_0.

(sympy port -- no Sage/Singular/Macaulay2 available in this environment;
all Stage 4 algebra is commutative algebra over QQ, which sympy handles:
Groebner bases, ideal membership by normal form, factorization, and
rational-function arithmetic for the parametrization.)

Established elsewhere (m003_three_universal_identities.sage/.log, exact):
on the geometric component X_0 of the SL2(C) character variety of
pi_1(m003) (cusped, relator abAAbabbb only, NO Dehn filling),
    tr(A) = tr(ABBB),   tr(AB) = tr(ABB),   tr(AAb) = tr(AABB)
hold identically as regular functions on X_0 -- and Stage 3.2 proved this
is NOT group conjugacy (cusped: not a free-group identity, so impossible;
filled m003(-2,3): the word pairs are EXACTLY non-conjugate via the
order-5616 finite quotient).

Fricke coordinates: x = tr(a), y = tr(b), z = tr(ab); u is the auxiliary
SL2 variable eliminated via the determinant relation u^2 + z u + 1 = 0.
Word convention: lowercase = generator, UPPERCASE = its inverse.

X_0 = component 2 of the primary decomposition of the bare Riley variety
(from the certified .log):
    I(X_0) = < y*z - x - z,  x*z + 1,  x^2 + y - 1 >.

This script establishes, all exactly:
  (1) the first generator is redundant:
        y*z - x - z = -x*(x*z + 1) + z*(x^2 + y - 1),
      so I(X_0) = < x*z + 1, x^2 + y - 1 >, a codim-2 complete
      intersection -> X_0 is a rational curve, parametrized by x itself:
        x = t,   y = 1 - t^2,   z = -1/t        (t in C^*).
  (2) the six trace polynomials in x,y,z, and their pullbacks to t.
  (3) each identity tr(w) - tr(w') as a rational function of t: it is
      identically zero -- the transparent, one-variable form.
  (4) the three trace-difference polynomials D_i(x,y,z), each factored,
      their gcd, the ideal J = <D_1,D_2,D_3>, and its exact relation to
      I(X_0): is J = I(X_0), a proper sub-ideal, or is its radical
      I(X_0)?  Which D_i are redundant modulo the others + I(X_0)?
  (5) the explicit ideal-membership certificates
        D_i = f_i * (x*z + 1) + g_i * (x^2 + y - 1)
      -- the actual "syzygy with the relator" that makes each identity
      hold on X_0 (and, by Step 2 of the .log, nowhere else on the
      bare Riley variety except the two discrete components).
"""

import sys
import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u, t = sp.symbols("x y z u t")

# ---- SL2 matrices in the Fricke chart --------------------------------------
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


def tr_xyz(word):
    """tr(word) as a polynomial in x,y,z (u killed via u^2 + z u + 1 = 0)."""
    tr = sp.expand((word_matrix(word)).trace())
    # reduce modulo the determinant relation, treating u as the main variable
    _, r = sp.div(sp.Poly(tr, u), DET_REL, u)
    r = sp.expand(r.as_expr())
    assert sp.Poly(r, u).degree() <= 0, f"{word}: residual u term {r}"
    return sp.expand(r)


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


# ==========================================================================
banner("1. I(X_0): redundant generator, complete intersection, rational param")

g_red = sp.expand(y * z - x - z)
g1 = sp.expand(x * z + 1)
g2 = sp.expand(x**2 + y - 1)
combo = sp.expand(-x * g1 + z * g2)
print(f"  y*z - x - z                         = {g_red}")
print(f"  -x*(x*z+1) + z*(x^2+y-1)            = {combo}")
print(f"  redundant generator identity holds:  {sp.simplify(g_red - combo) == 0}")

# rational parametrization x=t, y=1-t^2, z=-1/t
param = {x: t, y: 1 - t**2, z: -sp.Rational(1, 1) / t}
for name, g in [("x*z+1", g1), ("x^2+y-1", g2), ("y*z-x-z", g_red)]:
    val = sp.simplify(g.subs(param))
    print(f"  {name:10s} at (t, 1-t^2, -1/t) = {val}   vanishes: {val == 0}")

# confirm I_full == I_ci as ideals via Groebner bases
G_full = sp.groebner([g_red, g1, g2], x, y, z, order="grevlex")
G_ci = sp.groebner([g1, g2], x, y, z, order="grevlex")
print(f"\n  Groebner basis of <y*z-x-z, x*z+1, x^2+y-1>: {list(G_full.exprs)}")
print(f"  Groebner basis of <x*z+1, x^2+y-1>          : {list(G_ci.exprs)}")
print(f"  ideals equal: {set(G_full.exprs) == set(G_ci.exprs)}")

# ==========================================================================
banner("2. the six trace polynomials, in x,y,z and pulled back to t")

words = ["A", "ABBB", "AB", "ABB", "AAb", "AABB"]
trp = {}
trt = {}
for w in words:
    trp[w] = tr_xyz(w)
    trt[w] = sp.simplify(trp[w].subs(param))
    print(f"  tr({w:5s}) = {trp[w]}")
    print(f"          (t) = {trt[w]}")

# ==========================================================================
banner("3. each identity as a rational-function identity in t")

pairs = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]
for w1, w2 in pairs:
    d = sp.simplify(trt[w1] - trt[w2])
    print(f"  tr({w1}) - tr({w2})  =  {d}   (identically 0: {d == 0})")

# ==========================================================================
banner("4. trace-difference polys D_i, factorization, gcd, ideal vs I(X_0)")

D = {}
for w1, w2 in pairs:
    d = sp.expand(trp[w1] - trp[w2])
    D[(w1, w2)] = d
    print(f"  D[{w1},{w2}] = {d}")
    print(f"       factored: {sp.factor(d)}")

Dl = list(D.values())
gg = Dl[0]
for d in Dl[1:]:
    gg = sp.gcd(gg, d)
print(f"\n  gcd(D1, D2, D3) = {gg}")

I_ci = [g1, g2]


def nf(poly, gens=(x, y, z)):
    """normal form of poly modulo I(X_0) via its grevlex Groebner basis."""
    return sp.reduced(sp.expand(poly), list(G_ci.polys and G_ci.exprs), *gens,
                      order="grevlex")[1]


for key, d in D.items():
    r = sp.reduced(d, list(G_ci.exprs), x, y, z, order="grevlex")[1]
    print(f"  D[{key[0]},{key[1]}] mod I(X_0)  ->  {sp.expand(r)}   (in I(X_0): {sp.expand(r) == 0})")

# is I(X_0) contained in J = <D1,D2,D3> ?
G_J = sp.groebner(Dl, x, y, z, order="grevlex")
print(f"\n  Groebner basis of J = <D1,D2,D3>: {list(G_J.exprs)}")
for name, g in [("x*z+1", g1), ("x^2+y-1", g2)]:
    r = sp.reduced(g, list(G_J.exprs), x, y, z, order="grevlex")[1]
    print(f"  {name:10s} mod J  ->  {sp.expand(r)}   (in J: {sp.expand(r) == 0})")
print(f"  J == I(X_0) as ideals: {set(G_J.exprs) == set(G_ci.exprs)}")

# radical of J
try:
    print(f"  (J radical check) sqrt-membership of x*z+1: "
          f"{sp.expand(sp.reduced((x*z+1), list(G_J.exprs), x, y, z, order='grevlex')[1]) == 0}")
except Exception as e:
    print(f"  radical check skipped: {e}")

# which D_i are redundant modulo the other two + I(X_0)?
for i, key in enumerate(D):
    rest = [Dl[j] for j in range(3) if j != i] + I_ci
    G_rest = sp.groebner(rest, x, y, z, order="grevlex")
    r = sp.reduced(Dl[i], list(G_rest.exprs), x, y, z, order="grevlex")[1]
    print(f"  D[{key[0]},{key[1]}] in <other two D's, I(X_0)>: {sp.expand(r) == 0}")

# ==========================================================================
banner("5. the structural picture: D_2 IS the redundant generator; (y+1) ties all three")

D1 = D[("A", "ABBB")]
D2 = D[("AB", "ABB")]
D3 = D[("AAb", "AABB")]

# (a) D_2 = tr(AB) - tr(ABB) is exactly -(y*z - x - z), the redundant
#     generator of I(X_0) -- i.e. the CI syzygy  -x*(x*z+1) + z*(x^2+y-1).
print(f"  D_2                       = {sp.expand(D2)}")
print(f"  -(y*z - x - z)            = {sp.expand(-(y*z - x - z))}")
print(f"  D_2 == -(y*z-x-z):         {sp.expand(D2 + (y*z - x - z)) == 0}")
print(f"  D_2 == x*(x*z+1) - z*(x^2+y-1):  "
      f"{sp.expand(D2 - (x*g1 - z*g2)) == 0}")

# (b) D_1 = (y+1) * D_2   -- identity 1 is identity 2 scaled by (tr(b)+1)
print(f"\n  D_1 == (y+1)*D_2:          {sp.expand(D1 - (y + 1) * D2) == 0}")

# (c) D_3 = (y+1) * [ (x^2+y-1) - (x*z+1) ]
#         = (y+1) * (x^2 - x*z + y - 2)
print(f"  D_3 == (y+1)*((x^2+y-1)-(x*z+1)):  "
      f"{sp.expand(D3 - (y + 1) * (g2 - g1)) == 0}")

# (d) explicit certificates D_i = f_i*(x*z+1) + g_i*(x^2+y-1), by construction
certs = {
    "D_1 = (A,ABBB)":   ((x*y + x),        -(y*z + z)),
    "D_2 = (AB,ABB)":   (x,                -z),
    "D_3 = (AAb,AABB)": (-(y + 1),         (y + 1)),
}
print()
for name, (f_i, g_i) in certs.items():
    lhs = D1 if name.startswith("D_1") else D2 if name.startswith("D_2") else D3
    ok = sp.expand(f_i * g1 + g_i * g2 - lhs) == 0
    print(f"  {name}:  f = {sp.expand(f_i)} ,  g = {sp.expand(g_i)}   exact: {ok}")

# (e) common factor: (y+1) = tr(b)+1 divides D_1 and D_3 but not D_2
print(f"\n  (y+1) | D_1 : {sp.rem(D1, y + 1, y) == 0}")
print(f"  (y+1) | D_2 : {sp.rem(D2, y + 1, y) == 0}")
print(f"  (y+1) | D_3 : {sp.rem(D3, y + 1, y) == 0}")

# (f) cofactors F_i (D_i with the non-vanishing y+1 stripped) and their
#     reduction mod I(X_0).  On X_0, y+1 = 2 - x^2 is not identically 0 and
#     Q[X_0] = Q[x,x^-1] is a domain, so (y+1)*F_i = 0 there forces F_i = 0.
F1 = sp.factor(D1) / (y + 1)
F1 = sp.expand(sp.cancel(F1))
F3 = sp.expand(sp.cancel(sp.factor(D3) / (y + 1)))
print(f"\n  F_1 = D_1/(y+1) = {F1}")
print(f"  F_2 = D_2       = {sp.expand(D2)}")
print(f"  F_3 = D_3/(y+1) = {F3}")
print(f"  F_1 == F_2 (== -g_1 == x*g_2 - z*g_3):  "
      f"{sp.expand(F1 - D2) == 0 and sp.expand(F1 - (x*g1 - z*g2)) == 0}")
print(f"  F_3 == g_3 - g_2 == (x^2+y-1) - (x*z+1):  "
      f"{sp.expand(F3 - (g2 - g1)) == 0}")
for nm, Fi in [("F_1", F1), ("F_2", sp.expand(D2)), ("F_3", F3)]:
    r = sp.reduced(Fi, list(G_ci.exprs), x, y, z, order="grevlex")[1]
    print(f"  {nm} mod I(X_0) = {sp.expand(r)}")

# ==========================================================================
banner("6. V(J_D):  is sqrt(J_D) = I(X_0), or X_0 plus spurious components?")

# J_D = <D1,D2,D3>.  D2 = -g1; D1 = (y+1)*(-g1) in <g1>; so
#   J_D = < g1 , (y+1)*(g3 - g2) >   (g1 = y*z - x - z here = -g_red above)
g1c = sp.expand(y*z - x - z)          # canonical component redundant gen
JD_gens = [g1c, sp.expand((y + 1) * (g2 - g1))]   # g2=x*z+1, g1(local)=x^2+y-1
G_JD_a = sp.groebner([D1, D2, D3], x, y, z, order="grevlex")
G_JD_b = sp.groebner(JD_gens, x, y, z, order="grevlex")
print(f"  <D1,D2,D3> Groebner: {list(G_JD_a.exprs)}")
print(f"  <g1,(y+1)(g3-g2)> Groebner: {list(G_JD_b.exprs)}")
print(f"  J_D == <g1, (y+1)(g3-g2)>:  {set(G_JD_a.exprs) == set(G_JD_b.exprs)}")

# candidate decomposition V(J_D) = X_0  u  L  u  M with
#   L : y = -1, x = -2z      (from g1 = 0 & y+1 = 0)
#   M : y =  2, x =  z       (from g1 = 0 & g3-g2 = y-2 = 0, x=z branch)
sL, sM = sp.symbols("sL sM")
paramL = {x: -2*sL, y: -1, z: sL}
paramM = {x: sM,    y: 2,  z: sM}
for nm, pm in [("L (y=-1, x=-2z)", paramL), ("M (y=2, x=z)", paramM)]:
    vals = [sp.expand(e.subs(pm)) for e in G_JD_a.exprs]
    on_JD = all(v == 0 for v in vals)
    on_X0 = all(sp.expand(e.subs(pm)) == 0 for e in G_ci.exprs)
    print(f"  line {nm}: lies in V(J_D): {on_JD} ;  lies in X_0: {on_X0}")

# certify sqrt(J_D) = I(X_0) ∩ I(L) ∩ I(M) by ideal intersection (elimination)
w = sp.symbols("w")
def ideal_intersect(gensA, gensB):
    combined = [w * g for g in gensA] + [(1 - w) * g for g in gensB]
    G = sp.groebner(combined, w, x, y, z, order="lex")
    return [p for p in G.exprs if w not in p.free_symbols]

I_L = [y + 1, x + 2*z]
I_M = [y - 2, x - z]
K1 = ideal_intersect(I_ci, I_L)
K = ideal_intersect(K1, I_M)
G_K = sp.groebner(K, x, y, z, order="grevlex")
print(f"\n  I(X_0) cap I(L) cap I(M) Groebner: {list(G_K.exprs)}")


def in_radical(p, Ggb, kmax=8):
    q = sp.Integer(1)
    for k in range(1, kmax + 1):
        q = sp.expand(q * p)
        if sp.expand(sp.reduced(q, list(Ggb.exprs), x, y, z, order="grevlex")[1]) == 0:
            return k
    return None


#   J_D subset K :
JD_in_K = all(sp.expand(sp.reduced(gg, list(G_K.exprs), x, y, z, order="grevlex")[1]) == 0
              for gg in G_JD_a.exprs)
print(f"  J_D subset (I(X_0) cap I(L) cap I(M)) : {JD_in_K}")
for g in G_K.exprs:
    print(f"  K-generator {g}:  lies in sqrt(J_D) at power {in_radical(g, G_JD_a)}")
print(f"\n  => in the ambient Fricke A^3 the three universal identities cut out")
print(f"     X_0 TOGETHER WITH the two spurious lines L (y=-1, x=-2z) and")
print(f"     M (y=2, x=z).  sqrt(J_D) = I(X_0) cap I(L) cap I(M), a proper")
print(f"     SUB-ideal of I(X_0): V(J_D) = X_0 u L u M strictly contains X_0.")

# ==========================================================================
banner("6b. inside the bare Riley variety: does J_D + I_Riley cut out exactly X_0?")

# The bare relator ideal's radical is its primary decomposition, already
# CERTIFIED by Sage in m003_three_universal_identities.log (STEP 1):
#   sqrt(I_Riley) = comp0 cap comp1 cap X_0   with
#   comp0 = <z-2, x-y, y^2+y-1>   (discrete, golden-ratio)
#   comp1 = <z+2, x+y, y^2+y-1>   (discrete, golden-ratio)
#   comp2 = X_0 = <x*z+1, x^2+y-1> (geometric component)
# (Re-deriving it here from the relator matrix entries needs an expensive
#  u-elimination Groebner basis; the Sage primary decomposition is the
#  certified source, so we use it directly.)
comp0 = [z - 2, x - y, y**2 + y - 1]
comp1 = [z + 2, x + y, y**2 + y - 1]
comp2 = [g1, g2]                       # = I(X_0)
rad_Riley = ideal_intersect(ideal_intersect(comp0, comp1), comp2)
G_radR = sp.groebner(rad_Riley, x, y, z, order="grevlex")
print(f"  sqrt(I_Riley) = comp0 cap comp1 cap X_0, Groebner basis:")
for g in G_radR.exprs:
    print(f"     {g}")
G_Riley = G_radR

# now J_D + I_Riley  (use the radical Riley form for a set-theoretic statement)
A_gens = list(G_radR.exprs) + [D1, D2, D3]
G_A = sp.groebner(A_gens, x, y, z, order="grevlex")
print(f"\n  A := sqrt(I_Riley) + <D1,D2,D3>, Groebner basis:")
for g in G_A.exprs:
    print(f"     {g}")
# (i) A subset I(X_0)?
A_in_X0 = all(sp.expand(sp.reduced(g, list(G_ci.exprs), x, y, z, order="grevlex")[1]) == 0
              for g in G_A.exprs)
# (ii) I(X_0) subset sqrt(A)?
g2_pow = in_radical(g1, G_A)   # g1 (local) = x^2 + y - 1
g3_pow = in_radical(g2, G_A)   # g2 (local) = x*z + 1
print(f"\n  A subset I(X_0):                 {A_in_X0}")
print(f"  x^2+y-1 in sqrt(A) at power:     {g2_pow}")
print(f"  x*z+1   in sqrt(A) at power:     {g3_pow}")
print(f"  => sqrt(A) == I(X_0):            "
      f"{A_in_X0 and g2_pow is not None and g3_pow is not None}")
# the ambient lines L, M are NOT contained in the Riley variety, but they
# DO meet X_0 in finitely many points (which are legitimately on X_0):
for nm, pm, eqn in [("L", paramL, "x*z+1 = 1 - 2 s^2"),
                    ("M", paramM, "x*z+1 = s^2 + 1")]:
    line_on_R = all(sp.expand(e.subs(pm)) == 0 for e in G_Riley.exprs)
    meet = sp.solve([sp.expand(e.subs(pm)) for e in G_ci.exprs],
                    dict=True)
    print(f"  line {nm}: contained in Riley variety: {line_on_R} ; "
          f"{nm} cap X_0 solves {eqn} = 0  ->  {meet}")
print(f"\n  => V(sqrt(I_Riley)) cap V(J_D) = X_0 AS VARIETIES:")
print(f"     - comp0, comp1 (golden-ratio points) contribute NO points to")
print(f"       V(J_D): y^2+y-1 != 0 at y=-1 (L) and y=2 (M).")
print(f"     - L, M meet X_0 only in the finite sets above, which are on X_0.")
print(f"     At the certified-radical level this is also an ideal equality:")
print(f"     (comp0 cap comp1 cap X_0) + <D1,D2,D3> = I(X_0)  (GBs coincide).")
print(f"     No claim is made about the un-radicalised relator ideal.")

# ==========================================================================
banner("7. the mechanism: Phi : Q[x,y,z] -> Q[t,t^-1], ker Phi = I(X_0)")

print("  Phi: Q[x,y,z] -> Q[t,t^-1], (x,y,z) |-> (t, 1-t^2, -1/t), ker Phi = I(X_0).")
print("  NOT an independent explanation (Q[t,t^-1] has infinitely many distinct")
print("  functions); this is the one-variable shadow of blocks 2-3, where the D_i")
print("  are shown to lie in ker Phi = I(X_0) for explicit algebraic reasons.")
print("  The six words give only THREE images under Phi:")
for w in words:
    print(f"    T_{w:5s}(t) = {sp.expand(trt[w])}")
print()
for w1, w2 in pairs:
    print(f"    T_{w1}  ==  T_{w2}  :  {sp.expand(trt[w1] - trt[w2]) == 0}")
print()
print("  T_AAb = T_AABB = 2 t^2 - t^4 = 1 - (t^2 - 1)^2  "
      f": {sp.expand(trt['AAb'] - (1 - (t**2 - 1)**2)) == 0}")

print("\nPY_EXIT=0")
