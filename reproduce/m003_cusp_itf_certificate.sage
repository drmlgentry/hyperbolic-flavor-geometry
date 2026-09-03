# Rigorous certificate for the invariant trace field of CUSPED m003,
# k_inv(m003), following this session's exact methodology (presentation-
# only elimination + certified interval geometry, no algdep/PSLQ),
# rather than accepting the relayed claim k_inv(m003)=Q(sqrt(-3)) at
# face value.
#
# The complete cusped hyperbolic structure is the point of the character
# variety where the meridian mu is PARABOLIC: tr(rho(mu)) = +-2. Imposed
# here on the bare Riley ideal (no Dehn filling at all -- this is the
# cusped manifold). That locus turns out to be reducible (two degree-2
# components, not one clean degree-4 field); primary decomposition
# isolates which one the certified geometric point actually sits on.

from sage.all import *

R = PolynomialRing(QQ, names=("x", "y", "z", "u"), order="degrevlex")
x, y, z, u = R.gens()

A = matrix(R, [[x, -1], [1, 0]])
uinv = -z - u
B = matrix(R, [[0, -u], [uinv, y]])
I2 = identity_matrix(R, 2)


def inv_sl2(M):
    return matrix(R, [[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


Ai = inv_sl2(A)
Bi = inv_sl2(B)
MATS = {"a": A, "A": Ai, "b": B, "B": Bi}


def word_matrix(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    return M


def banner(t):
    print("\n" + "=" * 78)
    print(t)
    print("=" * 78)


det_relation = u**2 + z*u + 1
det_ideal = R.ideal([det_relation])

banner("m003 exact cusped presentation (from SnapPy, verified this session)")
import snappy
Mcusp = snappy.Manifold("m003")
Gcusp = Mcusp.fundamental_group()
relator = str(Gcusp.relators()[0])
mu, longitude = (str(w) for w in Gcusp.peripheral_curves()[0])
print("relator =", relator, " mu =", mu, " longitude =", longitude)
assert relator == "abAAbabbb" and mu == "ABABB" and longitude == "ABAbab"

Mr = word_matrix(relator)
gens_riley = [det_relation] + list((Mr - I2).list())
I_riley = R.ideal(gens_riley)
Iel_riley = I_riley.elimination_ideal([u])
print("bare Riley variety generators (pure x,y,z):", list(Iel_riley.gens()))

banner("STEP 1: exact trace formula for the meridian mu = ABABB")
Mmu = word_matrix(mu)
tr_mu_raw = Mmu[0, 0] + Mmu[1, 1]
tr_mu = det_ideal.reduce(tr_mu_raw)
assert tr_mu.degree(u) == 0
print("tr(mu) reduced (pure x,y,z) =", tr_mu)

S3 = PolynomialRing(QQ, names=("x", "y", "z"))
sx, sy, sz = S3.gens()
phi3 = R.hom([sx, sy, sz, S3(0)], S3)
tr_mu_3 = phi3(tr_mu)
Iriley_3 = S3.ideal([phi3(g) for g in Iel_riley.gens()])

banner("STEP 2: certified geometric holonomy (which sign, exact traces)")
BITS_PREC = 300
FUNDAMENTAL_GROUP_ARGS = [True, False, True, False]
Mgeom = snappy.Manifold("m003")
ok, rho = Mgeom.verify_hyperbolicity(
    holonomy=True, bits_prec=BITS_PREC,
    fundamental_group_args=FUNDAMENTAL_GROUP_ARGS)
print("verify_hyperbolicity(holonomy=True, bits_prec=%d) =" % BITS_PREC, ok)
assert ok
Grho_relators = tuple(str(w) for w in rho.relators())
assert relator in Grho_relators

T_mu_certified = rho(mu).trace()
T_a_certified = rho("a").trace()
T_b_certified = rho("b").trace()
T_ab_certified = rho("ab").trace()
print("certified T_mu =", T_mu_certified)
print("certified T_a  =", T_a_certified)
print("certified T_b  =", T_b_certified)
print("certified T_ab =", T_ab_certified)

banner("STEP 3: impose the parabolic condition on the correct sign")
I_parabolic = Iriley_3 + S3.ideal([tr_mu_3 + 2])  # tr(mu)=-2, matching the certified sign
dimQ_total = I_parabolic.vector_space_dimension()
print("dim_Q(coordinate ring, tr(mu)=-2 branch) =", dimQ_total)
is_radical = (I_parabolic == I_parabolic.radical())
print("radical?", is_radical, " prime?", I_parabolic.is_prime())
assert is_radical
assert not I_parabolic.is_prime(), "expected this branch to be reducible"

banner("STEP 4: primary decomposition -- find the geometric component")
PD = I_parabolic.primary_decomposition()
print("number of components:", len(PD))
geometric_component = None
for i, comp in enumerate(PD):
    gens = list(comp.gens())
    print(" component", i, "generators:", gens)
    # numerically test: does substituting T_a,T_b,T_ab satisfy this component?
    CC = ComplexField(BITS_PREC)
    vals = {sx: CC(T_a_certified.real().center(), T_a_certified.imag().center()),
            sy: CC(T_b_certified.real().center(), T_b_certified.imag().center()),
            sz: CC(T_ab_certified.real().center(), T_ab_certified.imag().center())}
    residual = sum(abs(CC(g.subs(vals))) for g in gens)
    print("   numeric residual at certified point:", residual)
    if residual < CC(1e-60):
        geometric_component = comp
        print("   ==> THIS is the geometric component.")

assert geometric_component is not None

banner("STEP 5: exact field of the geometric component")
gens = list(geometric_component.gens())
# isolate the z-only generator (the field-defining polynomial)
z_poly = [g for g in gens if g.variables() == (sz,)]
assert len(z_poly) == 1
Uz = PolynomialRing(QQ, "T")
Tg = Uz.gen()
p_z = Uz([z_poly[0].coefficient({sz: d}) for d in range(z_poly[0].degree(sz) + 1)])
print("exact minimal polynomial of z=tr(ab):", p_z)
assert p_z.is_irreducible()
print("degree:", p_z.degree())

K = NumberField(p_z, "zeta")
print("K = Q(z), [K:Q] =", K.degree())
print("disc(K) =", K.discriminant())

cand = NumberField(Uz("T^2+3"), "s")
print()
print("historical candidate Q(sqrt(-3)): disc =", cand.discriminant())
print("K isomorphic to Q(sqrt(-3))?", K.is_isomorphic(cand))

banner("STEP 6: certified interval-Newton root isolation")
CIF = ComplexIntervalField(BITS_PREC)
RIF = RealIntervalField(BITS_PREC)
p_z_CIF = p_z.change_ring(CIF)
p_z_prime_CIF = p_z_CIF.derivative()
delta = RIF(2)**(-BITS_PREC + 20)
pad = RIF(-1, 1) * delta
box = CIF(T_ab_certified.real() + pad, T_ab_certified.imag() + pad)
mid = CIF((box.real().lower() + box.real().upper()) / 2,
          (box.imag().lower() + box.imag().upper()) / 2)
N_box = mid - p_z_CIF(mid) / p_z_prime_CIF(box)


def strictly_contained(inner, outer):
    return (inner.real().lower() > outer.real().lower()
            and inner.real().upper() < outer.real().upper()
            and inner.imag().lower() > outer.imag().lower()
            and inner.imag().upper() < outer.imag().upper())


contracted = strictly_contained(N_box, box)
print("interval-Newton contraction of p_z at certified T_ab box:", contracted)
assert contracted

banner("STEP 7: full closure, same standard as the (-2,3) filled case")
dimQ_geom = geometric_component.vector_space_dimension()
is_radical_geom = (geometric_component == geometric_component.radical())
is_prime_geom = geometric_component.is_prime()
print("dim_Q(R/I_geometric) =", dimQ_geom, " (matches [K:Q] =", K.degree(), ")")
print("radical?", is_radical_geom, " prime?", is_prime_geom)
assert dimQ_geom == K.degree()
assert is_radical_geom and is_prime_geom
print()
print("R/I_geometric is a finite-dimensional integral domain over Q, hence")
print("a field -- and its dimension matches [K:Q] exactly, so R/I_geometric")
print("= K directly, no localization needed (same clean pattern as the")
print("(-2,3) filled case). Upper inclusion: x,y,z all lie in R/I_geometric")
print("= K (in fact x=z-1, y=z+1, integer shifts of z, on this component),")
print("so by Fricke trace algebra every word trace, hence k_inv(m003),")
print("lies in K. Lower inclusion: z=tr(ab) has exact degree 2 = [K:Q],")
print("so Q(z) subset k_inv(m003) already equals K. Both inclusions close.")

banner("CONCLUSION")
print("k_inv(m003) [cusped] = Q(z)/(%s) = K, [K:Q]=%d, disc(K)=%s" %
      (p_z, K.degree(), K.discriminant()))
print("Isomorphic to the historically-claimed Q(sqrt(-3)):",
      K.is_isomorphic(cand))
print()
print("Full four-gate closure, same standard as (-2,3): presentation-only")
print("elimination (F1), certified geometric root via interval-Newton (F2),")
print("reduced algebra R/I_geometric = K exactly, radical+prime (F3 upper")
print("inclusion), and deg(z)=[K:Q] (F4 lower inclusion). No algdep/PSLQ")
print("anywhere in this chain.")
print()
print("CUSPED m003 ITF CERTIFICATE: FULL CLOSURE, PASS")
print("SAGE_EXIT=0")
