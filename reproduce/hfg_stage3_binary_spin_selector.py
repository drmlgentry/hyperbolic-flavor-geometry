#!/usr/bin/env python3
"""
HFG Stage 3A — binary state from m006 spin/holonomy lifts

Purely topological input:
  pi1(m006) = <a,b | ababbAAbb>
  mu = Abb
  lambda = AAbA
  CKM filling slope = (-5,2)

Convention:
  lowercase generator = +1 exponent
  uppercase generator = inverse = -1 exponent

This script derives:
  H1(m006;Z) = Z<a> ⊕ Z/5<b>
  H^1(m006;Z/2) = Z/2
  unique nontrivial character chi(a)=1, chi(b)=0 (additive mod 2)
  chi(mu)=chi(lambda)=chi(slope)=1
Hence the two SL(2,C) holonomy lifts are toggled on the filling slope.
Exactly one can factor through the (-5,2) filled group.

No particle masses enter.

VERIFICATION NOTE (Aug 23 2026, independently checked against real SnapPy data,
not just this script's internal arithmetic):
  snappy.Manifold('m006').fundamental_group() confirms this EXACT presentation
  (generators, relator 'ababbAAbb', peripheral words Abb/AAbA) verbatim -- not
  assumed. All chi values above independently reproduced.

  This script's INTERPRETATION section (printed at the end) asserts "the lift
  with chi(s)=+1 extends" without pinning down which of the two actual lifts
  that is in absolute terms -- chi describes the DIFFERENCE between the two
  lifts' signs on s, not a property of one lift in isolation. Resolved via
  explicit holonomy matrices (G.SL2C(...) in Sage/SnapPy): the actual discrete
  faithful lift SnapPy returns by default has tr(mu)=+2, tr(lambda)=-2,
  tr(s)=tr(mu^-5 lambda^2)=+2 exactly (s = -5*mu+2*lambda, i.e. mu^-5*lambda^2
  as a word, mu/lambda commute so word order doesn't matter -- checked both
  orders, they agree). Working the Menal-Ferrer-Porti Lemma 3.9 style
  continuity argument (tr(rho_alpha(s)) = eps*2cos(alpha/2) for alpha in
  [0,2pi], fixed sign eps, filled endpoint alpha=2pi forces rho(s)=+I exactly
  since s is killed in pi_1 of the filled manifold) gives eps=-1, hence the
  EXTENDING lift has tr(s)=-2 at the complete structure (alpha=0) -- which is
  the OPPOSITE of SnapPy's natural/default lift (tr(s)=+2). So the extending
  lift is SnapPy's default lift TWISTED by chi, not the default lift itself.
  This is a concrete, checkable resolution of the sign, not left as an open
  +-1 ambiguity -- see reproduce/stage3_spin_lift_continuity_note.md.
  Framework status: [Structural], not yet [Proved] -- the general continuity
  mechanism (standard Thurston hyperbolic Dehn surgery deformation, same
  technique as Menal-Ferrer-Porti Lemma 3.9) is sound and correctly applied,
  but a fully rigorous write-up verifying every technical hypothesis (e.g.
  irreducibility maintained throughout the deformation path) has not been
  done to the same standard as the Stage 2 invariance proof.
"""

def exp_vector(word):
    ea = eb = 0
    for c in word:
        if c == 'a': ea += 1
        elif c == 'A': ea -= 1
        elif c == 'b': eb += 1
        elif c == 'B': eb -= 1
        else: raise ValueError(c)
    return ea, eb

rel = "ababbAAbb"
mu = "Abb"
lam = "AAbA"

er = exp_vector(rel)
emu = exp_vector(mu)
elam = exp_vector(lam)

print("="*72)
print("HFG STAGE 3A — BINARY SPIN / HOLONOMY-LIFT SELECTOR")
print("="*72)
print("relator exponent vector:", er)
print("mu exponent vector:     ", emu)
print("lambda exponent vector: ", elam)

assert er == (0,5)
print("\nH1(m006;Z) = Z<a> ⊕ Z/5<b>")
print("H^1(m006;Z/2) = Hom(H1,Z/2) = Z/2")

def chi(vec):
    ea, eb = vec
    return ea % 2

print("\nUnique nontrivial character chi:")
print("  chi(a)=1, chi(b)=0   (additive mod 2)")
print("  chi(mu)     =", chi(emu))
print("  chi(lambda) =", chi(elam))

s = (-5*emu[0] + 2*elam[0],
     -5*emu[1] + 2*elam[1])
print("\nCKM filling slope s = -5 mu + 2 lambda")
print("  exponent vector =", s)
print("  chi(s)          =", chi(s))
assert chi(s) == 1

print("""
INTERPRETATION
--------------
The two SL(2,C) lifts of the PSL(2,C) holonomy differ by chi.
Because chi(s)=1, twisting by chi flips the sign of the lifted
holonomy on the filling slope s.

At the filled representation, s is trivial in the filled fundamental
group. Therefore a lift that factors through the filled group must send
s to +I. The other lift sends s to -I and does not factor through.

Thus the distinguished CKM filling canonically labels the two spin/lift
states:

  epsilon = +1 : extendable lift, s -> +I
  epsilon = -1 : nonextendable lift, s -> -I

This gives an intrinsic binary state relative to the chosen filling.
""")

print("Stage 3A result: PASS (topological derivation)")
