"""
m003_collision_ideal_certificate.py
===================================
Exact verification of the FINITE certificate in the proof of Theorem 5.7
(and Remark 5.10) of the m003(-2,3) paper.  The all-word upper bound
J_inf <= P0 cap I(N) is proved by hand in the paper (Prop. 5.6, Lemma 5.5;
its ingredients are machine-checked in m003_m006_X0_cap_N_point_argument.py).
This script checks the remaining polynomial identities and ideal equalities:

  m003 (P0 = <xz+1, x^2+y-1>, I(N) = <x-z, y-2>, h = x^2-xz+y-2, q = yz-x-z):
    (1) the trace polynomials of A, ABBB, AB, ABB, AAb, AABB, AAbb, AABBB
        (computed from matrices, reduced mod u^2+zu+1) equal the ones printed
        in the paper;
    (2) eq. (26):  D_{AB,ABB} = -q,  D_{AAb,AABB} = (y+1)h,
                   D_{AAbb,AABBB} = (y^2+y-1)h            (identities in Z[x,y,z]);
    (3) eq. (27):  h = y*D_{AAb,AABB} - D_{AAbb,AABBB};
    (4) K := P0 cap I(N) (computed independently by Groebner elimination)
        has the same reduced Groebner basis as <h,q>;
    (5) each of the three pairs collides on X0, i.e. Phi(tau_w) = Phi(tau_v)
        under (x,y,z) -> (t, 1-t^2, -1/t);
  m006 (P = <x-z, y z^2 - y - 1>):
    (6) P cap I(N) equals <x-z, (y-2)(y z^2 - y - 1)>  (reduced GB equality);
    (7) D_{A,AB} = x - z;  D_{AAb,AAbb} = -(y-2)(y z^2 - y - 1) mod (x-z);
        both lie in P (hence the pairs collide on X0(m006)).

Exit status: 0 iff every assertion holds.  Pure sympy (exact).
"""
import sys

import sympy as sp

x, y, z, u, t, w = sp.symbols("x y z u t w")
DET = u**2 + z * u + 1
INV = {"a": "A", "A": "a", "b": "B", "B": "b"}

A = sp.Matrix([[x, -1], [1, 0]])
uinv = -z - u
B = sp.Matrix([[0, -u], [uinv, y]])


def inv2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MAT = {"a": A, "A": inv2(A), "b": B, "B": inv2(B)}


def tr_xyz(word):
    M = sp.eye(2)
    for c in word:
        M = M * MAT[c]
    tr = sp.expand(M.trace())
    r = sp.expand(sp.rem(tr, DET, u))
    assert sp.degree(r, u) <= 0, (word, r)
    return r


def nf(p, G):
    return sp.expand(sp.reduced(p, list(G.exprs), x, y, z, order="grevlex")[1])


def intersect(gA, gB):
    comb = [w * g for g in gA] + [(1 - w) * g for g in gB]
    G = sp.groebner(comb, w, x, y, z, order="lex")
    return sp.groebner([p for p in G.exprs if w not in p.free_symbols], x, y, z, order="grevlex")


ok = True


def check(label, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + label)
    ok &= bool(cond)


print("sympy", sp.__version__, "python", sys.version.split()[0])

# ---- m003 ----------------------------------------------------------------
tau = {wd: tr_xyz(wd) for wd in ["A", "ABBB", "AB", "ABB", "AAb", "AABB", "AAbb", "AABBB"]}
paper = {
    "A": x,
    "ABBB": -x * y + y**2 * z - z,
    "AB": z,
    "ABB": -x + y * z,
    "AAb": x**2 * y - x * z - y,
    "AABB": -x**2 + x * y * z - y**2 + 2,
    "AAbb": x**2 * y**2 - x**2 - x * y * z - y**2 + 2,
    "AABBB": -x**2 * y + x * y**2 * z - x * z - y**3 + 3 * y,
}
for wd, p in paper.items():
    check("tau_%s equals the polynomial printed in the paper" % wd, sp.expand(tau[wd] - p) == 0)

h = x**2 - x * z + y - 2
q = y * z - x - z
D2 = sp.expand(tau["AB"] - tau["ABB"])
D3 = sp.expand(tau["AAb"] - tau["AABB"])
D5 = sp.expand(tau["AAbb"] - tau["AABBB"])
check("(26a) D_{AB,ABB} = -q", sp.expand(D2 + q) == 0)
check("(26b) D_{AAb,AABB} = (y+1) h", sp.expand(D3 - (y + 1) * h) == 0)
check("(26c) D_{AAbb,AABBB} = (y^2+y-1) h", sp.expand(D5 - (y**2 + y - 1) * h) == 0)
check("(27)  h = y D_{AAb,AABB} - D_{AAbb,AABBB}", sp.expand(h - (y * D3 - D5)) == 0)

P0 = [x * z + 1, x**2 + y - 1]
IN = [x - z, y - 2]
K = intersect(P0, IN)
Ghq = sp.groebner([h, q], x, y, z, order="grevlex")
print("K = P0 cap I(N), GB:", list(K.exprs))
check("K = <h,q>  (reduced Groebner bases coincide)", list(K.exprs) == list(Ghq.exprs))

Phi = {x: t, y: 1 - t**2, z: -1 / t}
for (w1, w2) in [("AB", "ABB"), ("AAb", "AABB"), ("AAbb", "AABBB")]:
    d = sp.simplify((tau[w1] - tau[w2]).subs(Phi))
    check("pair (%s,%s) collides on X0:  Phi(tau_w - tau_v) = 0" % (w1, w2), d == 0)

# ---- m006 ----------------------------------------------------------------
P6 = [x - z, y * z**2 - y - 1]
K6 = intersect(P6, IN)
K6_claim = sp.groebner([x - z, (y - 2) * (y * z**2 - y - 1)], x, y, z, order="grevlex")
print("P006 cap I(N), GB:", list(K6.exprs))
check("m006: P cap I(N) = <x-z, (y-2)(yz^2-y-1)>", list(K6.exprs) == list(K6_claim.exprs))

D_A_AB = sp.expand(tr_xyz("A") - tr_xyz("AB"))
check("m006: D_{A,AB} = x - z", sp.expand(D_A_AB - (x - z)) == 0)
D_AAb_AAbb = sp.expand(tr_xyz("AAb") - tr_xyz("AAbb"))
G6 = sp.groebner(P6, x, y, z, order="grevlex")
check("m006: D_{AAb,AAbb} lies in P006 (pair collides on X0(m006))", nf(D_AAb_AAbb, G6) == 0)
target = sp.expand(-(y - 2) * (y * z**2 - y - 1))
red_target = sp.expand(sp.rem(sp.expand(D_AAb_AAbb - target), x - z, x))
check("m006: D_{AAb,AAbb} = -(y-2)(yz^2-y-1) modulo (x-z)", red_target == 0)

print()
print("COLLISION-IDEAL FINITE CERTIFICATE:", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
