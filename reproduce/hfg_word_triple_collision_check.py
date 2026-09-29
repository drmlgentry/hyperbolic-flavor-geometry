"""
hfg_word_triple_collision_check.py
===================================
Tests the ACTUAL historical HFG word triples (retrieved from the real
papers, not a relayed transcript) for trace collision on their respective
manifolds' geometric character-variety components, using the exact
machinery of `gentry-m003-arithmetic-v5.tex` (Lemma 5.5, Theorem 5.7,
Remark 5.11).

Retrieved directly from source, verified by reading the actual files:
  - PMNS triple {aa, aaB, baa}, M_PMNS = m003(-2,3)
    (papers/01_active_plb/gentry-pmns-plb.tex, Observation "Canonical
    triple", line 215).
  - CKM triple {aaB, AbA, AAb}, M_CKM = m006(-5,2)
    (papers/01_active_plb/gentry-ckm-plb-v3.tex, Observation
    "CKM word triple" obs:triple, line 210; M_CKM identified as
    m006(-5,2), NOT m003, at line 38).

A relayed transcript had asserted a CKM triple {aaab, aabb, bAbAB} and
implicitly tested it against m003's ideal. Both are wrong: the real CKM
triple is different, and it lives in pi_1(m006), not pi_1(m003) -- so
even the correct triple must be tested against m006's own collision
ideal (P006 = <x-z, yz^2-y-1>, Remark 5.11), not m003's P0.

IMPORTANT SCOPE NOTE, stated before any result: the test below checks
whether trace differences vanish IDENTICALLY on the geometric component
X_0 (ideal membership in P0 or P006) -- this is necessary but decidedly
NOT SUFFICIENT for the actual HFG "Borel construction" observable to be
insensitive to the collision. That construction (both PMNS and CKM
papers, sec:borel) extracts an axis direction n_hat(gamma) in S^2 from
the Pauli decomposition of log(rho(gamma)) -- i.e. from the FULL matrix,
not from the trace alone. Two elements with equal trace generically have
DIFFERENT axis directions (trace fixes only the eigenvalue pair, not
where the axis points in H^3), so a trace collision here does not, by
itself, imply the Borel/QR construction cannot distinguish the words.
This script answers the narrower, still meaningful, question: do these
specific word pairs collide as FRICKE TRACE POLYNOMIALS on the geometric
component -- nothing stronger is claimed.

Exit status: 0 (informational; always exits 0, this is a report not a
correctness certificate of anything upstream).
"""
import sys

import sympy as sp

x, y, z, u = sp.symbols("x y z u")


def make_tr_xyz(det_relation):
    A = sp.Matrix([[x, -1], [1, 0]])
    B = sp.Matrix([[0, -u], [_uinv(det_relation), y]])

    def inv2(M):
        return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])

    MAT = {"a": A, "A": inv2(A), "b": B, "B": inv2(B)}

    def tr_xyz(word):
        M = sp.eye(2)
        for c in word:
            M = M * MAT[c]
        tr = sp.expand(M.trace())
        r = sp.expand(sp.rem(tr, det_relation, u))
        assert sp.degree(r, u) <= 0, (word, r)
        return r

    return tr_xyz


def _uinv(det_relation):
    # det_relation = u^2 + z*u + 1  =>  u*(-z-u) = 1, so u^{-1} = -z-u
    return -z - u


DET = u**2 + z * u + 1
tr_xyz = make_tr_xyz(DET)


def in_ideal(diff, gens):
    G = sp.groebner(gens, x, y, z, order="grevlex")
    r = sp.reduced(sp.expand(diff), list(G.exprs), x, y, z, order="grevlex")[1]
    return sp.expand(r) == 0


def report(label, manifold, words, ideal_gens, ideal_name):
    print("=" * 78)
    print(f"{label}  --  words {words}  on {manifold}")
    print(f"testing ideal membership in {ideal_name} = {ideal_gens}")
    print("=" * 78)
    tr = {w: tr_xyz(w) for w in words}
    for w in words:
        print(f"  tau_{w} = {tr[w]}")
    import itertools
    for w1, w2 in itertools.combinations(words, 2):
        d = sp.expand(tr[w1] - tr[w2])
        collide = in_ideal(d, ideal_gens)
        print(f"  Delta_{{{w1},{w2}}} = {d}")
        print(f"    lies in {ideal_name}  =>  tau_{w1} == tau_{w2} identically on X_0 : {collide}")
    print()


# ---- PMNS: real triple {aa, aaB, baa} on m003, ideal P0 -------------------
P0 = [x * z + 1, x**2 + y - 1]
report("PMNS (real triple, gentry-pmns-plb.tex line 215)",
       "m003 / M_PMNS = m003(-2,3)", ["aa", "aaB", "baa"], P0, "P0")

# ---- CKM: real triple {aaB, AbA, AAb} on m006, ideal P006 -----------------
# m006 relator r = ababbAAbb; geometric component X_0(m006) = V(x-z, yz^2-y-1)
# (gentry-m003-arithmetic-v5.tex, Remark 5.11 -- independently re-derivable by
#  primary decomposition of <rho(r)-I> for m006's relator, not redone here).
P006 = [x - z, y * z**2 - y - 1]
report("CKM (real triple, gentry-ckm-plb-v3.tex line 210)",
       "m006 / M_CKM = m006(-5,2)", ["aaB", "AbA", "AAb"], P006, "P006")

print("REMINDER: a positive collision result above means the two words have")
print("identical trace polynomials on the geometric component X_0 -- it does")
print("NOT by itself mean the Borel/QR axis-direction construction (which uses")
print("full matrix data, not just trace) is insensitive to the distinction.")
print("See module docstring.")
sys.exit(0)
