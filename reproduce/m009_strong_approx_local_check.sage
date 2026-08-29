# Closes the last open piece of the strong-approximation argument: does
# the branch-swapping local coset at pbar actually CONTAIN an element
# whose determinant has the same K_pbar^x/(K_pbar^x)^2 squareclass as
# pi=1-w? (Needed so that d=diag(pi,1) can be used to reduce the PGL2
# problem to SL2, per the relayed strong-approximation argument.)
#
# Claim (proved here, not just cited): YES, and explicitly. Diagonal
# matrices diag(u,1) for u in Z2^x lie in E^x (hence in N^+(R_pbar),
# the endpoint-preserving part -- they commute with h=[[2,0],[0,1]], so
# they normalize BOTH M0=M2(Z2) and M1=h*M2(Z2)*h^-1 trivially, no
# computation needed for that part, just commutativity of diagonal
# matrices), with det=u ranging over ALL of Z2^x as u varies -- i.e.
# det(E^x) = Z2^x exactly (the standard "order unit group has unit
# determinant, surjectively" fact, verified directly here rather than
# only cited). Since w_local=[[0,2],[1,0]] is a genuine branch-swapping
# element (already verified in m009_normalizer_certificate.sage) with
# det=-2 (odd valuation), the coset w_local*diag(Z2^x,1) realizes ALL
# FOUR squareclasses of odd-valuation elements of Q2^x. Since
# v_pbar(pi)=1 is odd, [pi] is one of those four -- find u0 explicitly.

from sage.all import Qp, PolynomialRing, QQ, ComplexField, matrix, Matrix, Infinity

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()

PREC = 300
Q2 = Qp(2, prec=PREC)
P2 = PolynomialRing(Q2, 'X')
Xg = P2.gen()
roots = [r for r, m in (Xg**2 - Xg + 2).roots()]
root_pbar = None
for r in roots:
    if (1 - r).valuation() > 0:
        root_pbar = r
assert root_pbar is not None


def K_to_Q2(a, root):
    aa = K(a)
    pol = aa.polynomial()
    c0 = QQ(pol[0]) if pol.degree() >= 0 else QQ(0)
    c1 = QQ(pol[1]) if pol.degree() >= 1 else QQ(0)
    return Q2(c0) + Q2(c1) * root


pi_pbar = K_to_Q2(1 - w, root_pbar)
print("pi = 1-w, embedded at pbar (Q2):", pi_pbar)
print("valuation(pi):", pi_pbar.valuation(), " (expect 1, odd)")
assert pi_pbar.valuation() == 1

w_local = matrix(Q2, [[0, 2], [1, 0]])
det_w_local = w_local.det()
print("det(w_local) =", det_w_local, " valuation:", det_w_local.valuation())
assert det_w_local.valuation() == 1

print()
print("=" * 70)
print("Verify diag(u,1) for representative units u normalizes BOTH")
print("M0=M2(Z2) and M1=h*M2(Z2)*h^-1 (endpoint-preserving), and sweeps")
print("all 4 unit squareclasses -- direct check, not just cited.")
print("=" * 70)
h = matrix(Q2, [[2, 0], [0, 1]])
h_inv = h.inverse()
unit_class_reps = [Q2(1), Q2(-1), Q2(5), Q2(-5)]  # standard reps of Z2^x/(Z2^x)^2


def normalizes(alpha, lattice_basis):
    ainv = alpha.inverse()
    F = matrix(Q2, [[m[0, 0], m[0, 1], m[1, 0], m[1, 1]] for m in lattice_basis])
    Finv = F.inverse()
    for m in lattice_basis:
        conj = alpha * m * ainv
        v = matrix(Q2, [[conj[0, 0], conj[0, 1], conj[1, 0], conj[1, 1]]])
        coeffs = (v * Finv).list()
        if not all((c == 0) or (c.valuation() >= 0) for c in coeffs):
            return False
    return True


M0_basis = [matrix(Q2, [[1, 0], [0, 0]]), matrix(Q2, [[0, 1], [0, 0]]),
            matrix(Q2, [[0, 0], [1, 0]]), matrix(Q2, [[0, 0], [0, 1]])]
M1_basis = [h * e * h_inv for e in M0_basis]

for u in unit_class_reps:
    d = matrix(Q2, [[u, 0], [0, 1]])
    okM0 = normalizes(d, M0_basis)
    okM1 = normalizes(d, M1_basis)
    print(f"  diag({u},1): normalizes M0={okM0}, normalizes M1={okM1}")
    assert okM0 and okM1

print()
print("Confirmed: diag(u,1) is endpoint-preserving (in N^+) for all four")
print("unit squareclass representatives, with det=u sweeping all four")
print("classes of Z2^x/(Z2^x)^2 exactly.")

print()
print("=" * 70)
print("Find u0 with [pi] = [det(w_local)] * [u0]  in Q2^x/(Q2^x)^2")
print("=" * 70)
target = pi_pbar / det_w_local
print("pi / det(w_local) =", target, " valuation:", target.valuation(),
      " (expect 0, i.e. a UNIT -- since both have valuation 1)")
assert target.valuation() == 0


def is_square_unit(u):
    # u a Z2^x unit (Qp element, valuation 0): square iff u = 1 mod 8
    # (standard 2-adic criterion), checked directly via .is_square().
    return u.is_square()


for u in unit_class_reps:
    ratio = target / u
    print(f"  target/{u} is a square: {ratio.is_square()}")
    if ratio.is_square():
        u0 = u
        sqrt_val = ratio.sqrt()
        print(f"  ==> u0 = {u0} works: target = {u0} * (unit square), sqrt(target/u0) = {sqrt_val}")

g_pbar = matrix(Q2, [[0, 2 * u0], [1, 0]])
print()
print("Explicit g_pbar = w_local * diag(u0,1) =", g_pbar.list())
print("det(g_pbar) =", g_pbar.det(), " should equal pi times a square:")
ratio_check = g_pbar.det() / pi_pbar
print("  det(g_pbar)/pi =", ratio_check, " is_square:", ratio_check.is_square())
assert ratio_check.is_square()
print()
print("CONFIRMED: an explicit element g_pbar in the branch-swapping local")
print("coset has det(g_pbar) in the SAME K_pbar^x/(K_pbar^x)^2 squareclass")
print("as pi=1-w. This closes the local bookkeeping step at pbar needed")
print("for the strong-approximation globalization argument -- computed")
print("explicitly, not assumed.")
