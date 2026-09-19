"""
Direct argument (no induction) for the permanent-N conjecture:

    T_w = T_v on X_0   ==>   |e_a(w)| = |e_a(v)|

via the POINTS of X_0 cap N.

  1. P_0 = ker(Phi) exactly (elimination), so a collision Delta = tr(w)-tr(v)
     lies in P_0 and therefore vanishes at every point of V(P_0).
  2. V(P_0) cap N is nonempty: m003: p = (i, 2, i); m006: p = (r, 2, r), r^2 = 3/2.
  3. At any point of N, tr_xyz(w) = s_{|e_a(w)|}(x)  (specialization lemma,
     b -> I).  So Delta(p) = s_n(x_p) - s_m(x_p), n=|e_a(w)|, m=|e_a(v)|.
  4. n -> s_n(x_p) is injective on n >= 0:
       m003: s_n(i) = i^n L_n (Lucas), |s_n(i)| = L_n injective on n>=0.
       m006: s_n(r) = 2 cos(n theta), cos(2 theta) = -1/4; theta/pi irrational (Niven),
             so injective.
     Hence Delta(p) = 0  ==>  n = m  ==>  Delta|_N = 0.

This script verifies every finite/exact ingredient:
  (a) kernel-of-Phi = P_0 for both manifolds (Groebner elimination);
  (b) V(P_0) cap N computed exactly;
  (c) for ALL 4692 words (length<=10): tr_xyz(w)(p) == s_{|e_a|}(x_p) exactly,
      and (m003) the value equals i^n * L_n;
  (d) injectivity checks (exact integer Lucas; high-precision cos for m006).
"""

import json
import sys
import time

import mpmath as mp
import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u, t, s = sp.symbols("x y z u t s")


def banner(msg):
    print("\n" + "=" * 78 + "\n" + msg + "\n" + "=" * 78, flush=True)


banner("(a) P_0 = ker(Phi), both manifolds, by elimination of the parameter t")
# m003: Phi(x,y,z) = (t, 1-t^2, -1/t): graph ideal <x-t, y-1+t^2, z*t+1>
E3 = sp.groebner([x - t, y - 1 + t**2, z * t + 1], t, x, y, z, order="lex")
K3 = [p for p in E3.exprs if not p.has(t)]
G3 = sp.groebner([x * z + 1, x**2 + y - 1], x, y, z, order="grevlex")
same3 = sp.groebner(K3, x, y, z, order="grevlex").exprs == G3.exprs
print(f"  m003: eliminated ideal = <{', '.join(map(str, K3))}> ; equals <xz+1, x^2+y-1>: {same3}")
# m006: Phi(x,y,z) = (t, 1/(t^2-1), t): graph ideal <x-t, z-t, y*(t^2-1)-1>
E6 = sp.groebner([x - t, z - t, y * (t**2 - 1) - 1], t, x, y, z, order="lex")
K6 = [p for p in E6.exprs if not p.has(t)]
G6 = sp.groebner([x - z, y * z**2 - y - 1], x, y, z, order="grevlex")
same6 = sp.groebner(K6, x, y, z, order="grevlex").exprs == G6.exprs
print(f"  m006: eliminated ideal = <{', '.join(map(str, K6))}> ; equals <x-z, yz^2-y-1>: {same6}")
assert same3 and same6

banner("(b) V(P_0) cap N exactly")
for name, gens in (("m003", [x * z + 1, x**2 + y - 1]), ("m006", [x - z, y * z**2 - y - 1])):
    sol = sp.solve(gens + [x - z, y - 2], [x, y, z], dict=True)
    print(f"  {name}: V(P_0) cap N = {sol}")

banner("(c) every word: tr_xyz(w)(p) == s_{|e_a(w)|}(x_p) exactly")
A = sp.Matrix([[x, -1], [1, 0]])
B = sp.Matrix([[0, -u], [-z - u, y]])


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET = sp.Poly(u**2 + z * u + 1, u)


def tr_xyz(w):
    M = sp.eye(2)
    for c in w:
        M = M * MATS[c]
    tr = sp.expand(M.trace())
    _, r = sp.div(sp.Poly(tr, u), DET, u)
    return sp.expand(r.as_expr())


with open("m003_traces_len10_cache.json") as f:
    words = json.load(f)["words"]
with open("m003_collision_words_trxyz_cache.json") as f:
    trxyz = {w: sp.expand(sp.sympify(v)) for w, v in json.load(f).items()}
for w in words:
    if w not in trxyz:
        trxyz[w] = tr_xyz(w)
print(f"  {len(words)} words with raw tr_xyz(w) available")


def net_a(w):
    return w.count("a") - w.count("A")


def s_seq(n_max, xv):
    seq = [sp.Integer(2), xv]
    for k in range(2, n_max + 1):
        seq.append(sp.expand(xv * seq[-1] - seq[-2]))
    return seq


def lucas(n_max):
    L = [2, 1]
    for k in range(2, n_max + 1):
        L.append(L[-1] + L[-2])
    return L


nmax = max(abs(net_a(w)) for w in words)
print(f"  max |e_a| over the census: {nmax}")

# m003: p = (i,2,i)
S3 = s_seq(nmax, sp.I)
Lc = lucas(nmax)
bad3 = bad3_lucas = 0
t0 = time.time()
for w in words:
    val = sp.expand(trxyz[w].subs({x: sp.I, y: 2, z: sp.I}))
    n = abs(net_a(w))
    if sp.expand(val - S3[n]) != 0:
        bad3 += 1
    if sp.expand(val - sp.I**n * Lc[n]) != 0:
        bad3_lucas += 1
print(f"  m003 p=(i,2,i): mismatches vs s_n(i): {bad3}; vs i^n*L_n: {bad3_lucas}  ({time.time()-t0:.0f}s)")

# m006: p = (r,2,r), r = sqrt(3/2)
r = sp.sqrt(sp.Rational(3, 2))
S6 = s_seq(nmax, r)
bad6 = 0
t0 = time.time()
for w in words:
    val = sp.expand(trxyz[w].subs({x: r, y: 2, z: r}))
    n = abs(net_a(w))
    if sp.simplify(sp.expand(val - S6[n])) != 0:
        bad6 += 1
print(f"  m006 p=(r,2,r), r^2=3/2: mismatches vs s_n(r): {bad6}  ({time.time()-t0:.0f}s)")
assert bad3 == 0 and bad3_lucas == 0 and bad6 == 0

banner("(d) injectivity of n -> s_n(x_p) on n >= 0")
Ln = lucas(400)
print(f"  Lucas L_0..L_400 pairwise distinct: {len(set(Ln)) == len(Ln)}  (L_0=2,L_1=1,L_2=3 then strictly increasing)")
mp.mp.dps = 60
rr = mp.sqrt(mp.mpf(3) / 2)
theta = mp.acos(rr / 2)
vals = [2 * mp.cos(n * theta) for n in range(0, 401)]
gap = min(abs(vals[i] - vals[j]) for i in range(401) for j in range(i))
print(f"  m006: theta = {mp.nstr(theta,20)}; cos(2 theta) = {mp.nstr(mp.cos(2*theta),20)} (= -1/4)")
print(f"  m006: min pairwise gap of s_n(r) over n=0..400 is {mp.nstr(gap,5)}  (>0)")
print("  m006 exact reason (Niven): if 2*theta/pi were rational then 2*cos(2*theta) would be rational and hence in {0,+-1,+-2};")
print("  but 2*cos(2*theta) = -1/2, so theta/pi is irrational, and n*theta = +-m*theta + 2*pi*k forces n = m.")

banner("verdict")
print("  All ingredients verified. Combined: T_w = T_v on X_0  ==>  Delta in P_0 = ker(Phi)  ==>  Delta(p)=0")
print("  ==> s_n(x_p) = s_m(x_p) ==> n = m ==> |e_a(w)| = |e_a(v)|  ==> Delta|_N = 0 (N-exponent lemma).")
print("\nPY_EXIT=0")
