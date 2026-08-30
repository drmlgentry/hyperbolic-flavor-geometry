# Exact determinant-squareclass image certificate for the global
# endpoint-preserving m009 normalizer.
#
# Dependency: m009_endpoint_global_orders.sage and its successful log.
#
# This script certifies the finite field/order facts used by the proof
# below and reruns the exact global-order assertions.  The exhaustion of
# determinant support is mathematical: the normalizer of a split global
# maximal order is its projective unit group when the class number is 1.
#
# It does NOT determine [N^{+,0}:Gamma_009^+].

load("reproduce/m009_endpoint_global_orders.sage")

print()
print("=" * 72)
print("DETERMINANT-IMAGE SUPPORT: EXACT GLOBAL FIELD FACTS")
print("=" * 72)

signature = K.signature()
class_number = K.class_number()
number_of_roots = K.number_of_roots_of_unity()
minus_one_square = K(-1).is_square()

print("signature(K) =", signature)
print("class_number(K) =", class_number)
print("number_of_roots_of_unity(K) =", number_of_roots)
print("-1 is a square in K =", minus_one_square)

assert signature == (0, 1)
assert class_number == 1
assert number_of_roots == 2
assert not minus_one_square

# The loaded exact global certificate supplies M0_basis, M1_basis,
# J_global, J_fixes_M0, J_fixes_M1, and J_normalizes_R.
assert J_fixes_M0
assert J_fixes_M1
assert J_normalizes_R
assert J_global.det() == -1

identity = Matrix.identity(K, 2)
assert same_lattice(conjugate_basis(identity, M0_basis), M0_basis)
assert same_lattice(conjugate_basis(identity, M1_basis), M1_basis)
assert identity.det() == 1

print()
print("=" * 72)
print("EXHAUSTION PROOF")
print("=" * 72)
print("""
Let L0=d0*O_K^2, so M0=End_O_K(L0).  If [g] in PGL_2(K)
normalizes M0, then gL0 is an M0-stable lattice.  Matrix units show
that every M0-stable full lattice has the form I*L0 for a fractional
O_K-ideal I.  Since h(K)=1, I=alpha*O_K is principal.  Therefore
alpha^(-1)g preserves L0, and in the d0-frame it lies in GL_2(O_K).

Hence

  N_{PGL_2(K)}(M0) = d0 PGL_2(O_K) d0^(-1).

Conjugation by d0 and projective scalar rescaling do not change the
determinant squareclass.  Thus every element normalizing M0 has
determinant squareclass represented by det(A) for A in GL_2(O_K),
which is a global unit.

K is imaginary quadratic (signature (0,1)), so Dirichlet's unit
theorem says O_K^x is finite and equals its roots of unity.  The exact
root-of-unity count above is 2, hence O_K^x={+1,-1}.  Therefore

  delta(N_K^+(R)) subset { [1], [-1] },

because N_K^+(R) fixes M0 individually and is a subgroup of N(M0).
The identity realizes [1].  The already certified global element
J=diag(-1,1) fixes M0 and M1 individually, normalizes R, and realizes
[-1], which is nonsquare in K.  Both classes occur, completing the
upper- and lower-bound exhaustion.
""")

print("=" * 72)
print("CERTIFIED CONCLUSION")
print("=" * 72)
print("delta(N_K^+(R)) = { [1], [-1] }")
print("|delta(N_K^+(R))| = 2")
print()
print("INDEX REDUCTION (assuming finiteness):")
print("[N_K^+(R):Gamma_009^+] = 2 * [N^{+,0}:Gamma_009^+]")
print()
print("STILL OPEN:")
print("[N^{+,0}:Gamma_009^+]")
print("[N_K^+(R):Gamma_009^+] until the square-determinant factor is known")
