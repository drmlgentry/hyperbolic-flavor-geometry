"""
m003_dehn_relator_certificate.py
================================
Certificate for Proposition 4.1 of the m003(-2,3) paper.

    s = mu^-2 lambda^3   (literal slope word)
    q = the shortened filling relator returned by SnapPy for m003(-2,3)
    g = ab

    CLAIM:  q = g s g^-1  in  pi_1(m003) = <a,b | r>.
    Hence  <<r,q>> = <<r,s>>  (conjugate elements have the same normal
    closure), so the shortened and literal filled presentations define the
    same marked quotient.

    (Correction recorded here: an earlier draft of the paper asserted
     q = s^-1 in <a,b | r>, transplanted from the m006/CKM certificate.  For the
     recorded m003 relator that is FALSE: exp(q) = exp(s) = (1,9), not -(1,9),
     and rho(q s^-1) is not +-I below.  This script checks the true statement
     and also asserts that q is NOT s or s^-1.)

METHOD (no word-problem solver, no Knuth-Bendix, no floating point):
  The complete hyperbolic structure on m003 gives a discrete FAITHFUL
  representation  rho_0 : pi_1(m003) -> PSL_2(C).  Therefore for a word w,
  rho_0(w) = +-I  <=>  w = 1 in pi_1(m003).  We evaluate rho_0 EXACTLY in the
  Q-algebra  Q[z,u]/(z^2 - z + 1, u^2 + z u + 1)  (dimension 4) and test the
  matrix identity rho_0(q) = +-rho_0(g s g^-1).

INPUTS (transcribed, with provenance; this script does not call SnapPy):
  r      = abAAbabbb       reproduce/pmns_itf_certificate.log, line 11
  mu     = ABABB, lambda = ABAbab      same script
  q      = abABAbabbbbabbbb            reproduce/pmns_itf_certificate.log, line 70
                                       ("rho's own relators": second entry)
  Exact geometric character of the CUSPED group (component "1" of
  reproduce/m003_cusp_itf_certificate.log, Step 4, certified against SnapPy's
  verify_hyperbolicity(holonomy=True, bits_prec=300) with residual ~1e-90):
                 z = tr(ab),  z^2 - z + 1 = 0,  x = tr(a) = z - 1,  y = tr(b) = z + 1
  in the chart  A = [[x,-1],[1,0]],  B = [[0,-u],[u^-1,y]],  u^2 + z u + 1 = 0.

SELF-CHECKS: rho_0(r) = +I and tr rho_0(mu) = -2 (parabolic), which must hold
at the geometric point; any failure aborts with non-zero exit status.

Exit status: 0 iff every assertion holds.
"""
import sys

import sympy as sp

R_WORD = "abAAbabbb"
MU = "ABABB"
LAM = "ABAbab"
Q_WORD = "abABAbabbbbabbbb"
G = "ab"
INV = {"a": "A", "A": "a", "b": "B", "B": "b"}


def inv(w):
    return "".join(INV[c] for c in reversed(w))


def exps(w):
    return (w.count("a") - w.count("A"), w.count("b") - w.count("B"))


z, u = sp.symbols("z u")
GB = sp.groebner([z**2 - z + 1, u**2 + z * u + 1], u, z, order="lex")


def red(e):
    return sp.expand(GB.reduce(sp.expand(e))[1])


x = z - 1
y = z + 1
uinv = -z - u  # u * (-z - u) = -zu - u^2 = 1 in the quotient
A = sp.Matrix([[x, -1], [1, 0]])
B = sp.Matrix([[0, -u], [uinv, y]])


def inv2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MAT = {"a": A, "A": inv2(A), "b": B, "B": inv2(B)}


def rho(word):
    M = sp.eye(2)
    for c in word:
        M = (M * MAT[c]).applyfunc(red)
    return M


def sign_class(M):
    if (M - sp.eye(2)).applyfunc(red) == sp.zeros(2):
        return "+I"
    if (M + sp.eye(2)).applyfunc(red) == sp.zeros(2):
        return "-I"
    return "other"


def main():
    ok = True

    def check(label, cond):
        nonlocal ok
        print(("PASS  " if cond else "FAIL  ") + label)
        ok &= bool(cond)

    print("m003(-2,3): Proposition 4.1 certificate (exact, faithful representation)")
    print("sympy =", sp.__version__, " python =", sys.version.split()[0])
    s = inv(MU) * 2 + LAM * 3
    print("s = mu^-2 lambda^3 =", s, "(unreduced)")
    print("q =", Q_WORD, "  g =", G)

    # self-checks at the exact geometric point
    check("rho_0(r) = +I", sign_class(rho(R_WORD)) == "+I")
    check("tr rho_0(mu) = -2", red(rho(MU).trace()) == -2)
    check("det rho_0(a) = det rho_0(b) = 1", red(A.det()) == 1 and red(B.det()) == 1)

    # abelianization consistency
    check("exp(q) = exp(s)   [%s vs %s]" % (exps(Q_WORD), exps(s)), exps(Q_WORD) == exps(s))

    Mq, Ms, Mg = rho(Q_WORD), rho(s), rho(G)
    conj = (Mg * Ms * inv2(Mg)).applyfunc(red)

    diff_plus = (Mq - conj).applyfunc(red)
    diff_minus = (Mq + conj).applyfunc(red)
    which = "+" if diff_plus == sp.zeros(2) else ("-" if diff_minus == sp.zeros(2) else None)
    check("rho_0(q) = +-rho_0(g s g^-1)   (sign %s)" % which, which is not None)

    # the corrected statement is genuinely different from the old one
    check("q != s   in pi_1 (rho_0(q s^-1) is not +-I)",
          sign_class((Mq * inv2(Ms)).applyfunc(red)) == "other")
    check("q != s^-1 in pi_1 (rho_0(q s) is not +-I)",
          sign_class((Mq * Ms).applyfunc(red)) == "other")

    print()
    if ok:
        print("CONCLUSION: q = (ab) s (ab)^-1 in pi_1(m003) = <a,b | r>;")
        print("            hence <<r,q>> = <<r,s>>.   PASS")
    else:
        print("CONCLUSION: NOT ESTABLISHED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
