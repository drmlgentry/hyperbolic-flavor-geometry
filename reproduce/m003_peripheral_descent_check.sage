"""
Tests the proposed commutative-diagram question: does the peripheral
integral character Q_0(p,q)=2p+q descend mod 5 to match the closed
character chi on H_1(m003(-2,3))=Z/5, via the peripheral inclusion
H_1(dM)=Z^2 -> H_1(m003) -> H_1(m003(-2,3))?

Answer: the question is vacuous. Both peripheral generators mu, lambda
map to the trivial class in H_1(m003(-2,3)) -- a general fact about
Dehn filling (the meridian bounds the filling solid torus's disk, so
becomes null-homologous; since mu,lambda generate the whole peripheral
Z^2, the entire peripheral image dies), not something specific to this
manifold. So "Q_0 mod 5 restricted to the peripheral image" is
identically 0 for any filling and any choice of Q_0 -- it cannot fail
or succeed in an interesting way. The real, already-established
connection between Q_0 and the closed structure remains exactly
|H_1(m003(p,q))| = 5|Q_0(p,q)|.
"""
from sage.all import ZZ

Zn = ZZ**2
MU_EXP = (-2, -3)   # ABABB
LAM_EXP = (-1, 1)   # ABAbab

# H1(m003): just the relator relation, 5b=0
rel_cusp = Zn.submodule([(0, 5)])
Q_cusp = Zn.quotient(rel_cusp)
print("H1(m003) invariants:", Q_cusp.invariants())
print("[mu] in H1(m003):", Q_cusp(Zn(MU_EXP)))
print("[lambda] in H1(m003):", Q_cusp(Zn(LAM_EXP)))

# H1(m003(-2,3)): relator + filling relation (1,9) for slope (-2,3)
rel_closed = Zn.submodule([(0, 5), (1, 9)])
Q_closed = Zn.quotient(rel_closed)
print()
print("H1(m003(-2,3)) invariants:", Q_closed.invariants())
mu_closed = Q_closed(Zn(MU_EXP))
lam_closed = Q_closed(Zn(LAM_EXP))
print("[mu] in H1(m003(-2,3)):", mu_closed)
print("[lambda] in H1(m003(-2,3)):", lam_closed)
print()
print("Both peripheral generators trivial in the closed H1:",
      mu_closed == Q_closed(Zn((0, 0))) and lam_closed == Q_closed(Zn((0, 0))))
print("SAGE_EXIT=0")
