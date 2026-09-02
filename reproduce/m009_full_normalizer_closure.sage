# Exact normality and quotient-structure certificate for the FULL m009
# normalizer, extending the already-certified endpoint-preserving result
# N_K^+(R)/Gamma_009^+ = C2xC2 to N_K(R)/Gamma_009.
#
# Genuinely new content: the raw generators a,b (which swap M0<->M1, unlike
# every previously-certified object) are not K-rational in the fixed global
# frame -- this script derives their EXACT matrices over a degree-2
# extension L=K(sqrt(D_a)) via Cayley-Hamilton (a^2 is already K-rational;
# a = (a^2+I)/tr(a), tr(a)^2 = tr(a^2)+2), fixes the sign against the
# certified 300-bit numerical holonomy, and cross-validates against the
# independently certified K-rational product a*b.
#
# Key structural fact, verified below rather than assumed: a = sq*A0,
# b = sq*B0 for K-rational matrices A0,B0 and a scalar sq with sq^2=D_a in
# K. Since sq is central, ANY conjugation sandwich g*a*g^-1*a^-1 (g in
# N_K^+(R), K-rational) has sq^2=D_a pulled out as a scalar and is
# therefore automatically K-rational -- this lets every normality question
# below be answered with the SAME certified Euclidean-word + GAP
# coset-membership machinery already used for Gamma_009^+, with no new
# infrastructure required.

load("reproduce/m009_square_stabilizer_coset_rep.sage")

print()
print("=" * 72)
print("FULL NORMALIZER CLOSURE: STEP 1 -- EXACT a,b OVER L=K(sqrt(D_a))")
print("=" * 72)

import snappy
M009 = snappy.Manifold("m009")
G = M009.polished_holonomy(bits_prec=300)
raw = {word: G.SL2C(word) for word in ["a", "b", "aa"]}
# beta is local to get_conjugated_exact_matrices() in the loaded script and
# not exported; recompute it identically (same manifold, same bits_prec,
# same deterministic polished_holonomy) so a,b land in the same frame as
# the already-certified mats['aa'], mats['bb'], mats['ab'].
def exact_K_element_deg2(numval, label):
    if abs(numval) < 1e-10:
        return K(0)
    dep = algdep(numval, 2, known_bits=200)
    if dep.degree() > 2 or dep.degree() == 0:
        raise RuntimeError("%s failed degree<=2 recognition: %s" % (label, dep))
    if dep.degree() == 1:
        return K(-dep[0] / dep[1])
    Rk = PolynomialRing(K, 'y')
    y = Rk.gen()
    poly_in_K = sum(QQ(c) * y**i for i, c in enumerate(dep.list()))
    roots = poly_in_K.roots()
    if not roots:
        raise RuntimeError("%s has no recognized root in K" % label)
    return min((r for r, mult in roots), key=lambda r: abs(CC(r) - numval))

beta = CC(raw['aa'][0, 1])
recomputed_aa = Matrix(K, 2, 2,
    [exact_K_element_deg2(CC(raw['aa'][0,0]), "check_aa0"),
     exact_K_element_deg2(beta*CC(raw['aa'][0,1]), "check_aa1"),
     exact_K_element_deg2(CC(raw['aa'][1,0])/beta, "check_aa2"),
     exact_K_element_deg2(CC(raw['aa'][1,1]), "check_aa3")])
print("recomputed 'aa' matches certified mats['aa'] (frame/beta sanity check):",
      recomputed_aa == mats['aa'])
assert recomputed_aa == mats['aa']

Maa = mats['aa']
Mbb = mats['bb']
D_a = K(Maa.trace() + 2)
D_b = K(Mbb.trace() + 2)
print("D_a = tr(aa)+2 =", D_a, " square in K:", D_a.is_square())
print("D_b = tr(bb)+2 =", D_b, " square in K:", D_b.is_square())
assert not D_a.is_square()
assert D_a * D_b == 16, "expected D_a*D_b to be a perfect square (same field L)"

RL = PolynomialRing(K, 's')
s = RL.gen()
L = K.extension(s**2 - D_a, 'sq')
sq = L.gen()
I2L = Matrix(L, [[1, 0], [0, 1]])

A0 = (Maa + Matrix.identity(K, 2)) / D_a
B0 = (Mbb + Matrix.identity(K, 2)) / 4
print("A0 (a=sq*A0) =", A0.list())
print("B0 (b=sq*B0) =", B0.list())

def L_to_CC(elt, sqrtD_num):
    v = L(elt).list()
    p = v[0] if len(v) > 0 else 0
    q = v[1] if len(v) > 1 else 0
    return CC(p) + CC(q) * sqrtD_num

def pick_sign(cands, numeric_vals, sqrtD_num):
    best, best_dist = None, None
    for cand in cands:
        entries = cand.list()
        dist = sum(abs(L_to_CC(entries[i], sqrtD_num) - numeric_vals[i]) for i in range(4))
        if best_dist is None or dist < best_dist:
            best, best_dist = cand, dist
    return best, best_dist

sqrtD_num = CC(D_a).sqrt()
beta_local = beta  # from mats construction upstream (same conjugation frame)
vals_a = [CC(raw['a'][0,0]), beta_local*CC(raw['a'][0,1]),
          CC(raw['a'][1,0])/beta_local, CC(raw['a'][1,1])]
vals_b = [CC(raw['b'][0,0]), beta_local*CC(raw['b'][0,1]),
          CC(raw['b'][1,0])/beta_local, CC(raw['b'][1,1])]

# a = sq*A0 (i.e. tr(a)=sq, since a=(aa+I)/tr(a) and A0=(aa+I)/D_a=(aa+I)/sq^2);
# the other sign is tr(a)=-sq, i.e. a=-sq*A0.
a_cands = [sq * A0.change_ring(L), -sq * A0.change_ring(L)]
b_cands = [sq * B0.change_ring(L), -sq * B0.change_ring(L)]
a_L, dist_a = pick_sign(a_cands, vals_a, sqrtD_num)
b_L, dist_b = pick_sign(b_cands, vals_b, sqrtD_num)
print("a matches certified 300-bit holonomy to distance:", dist_a)
print("b matches certified 300-bit holonomy to distance:", dist_b)
assert dist_a < 1e-60
assert dist_b < 1e-60

Mab_L = mats['ab'].change_ring(L)
assert a_L * b_L == Mab_L, "a*b must equal the independently certified K-rational product ab"
print("a*b == certified K-rational 'ab': True  (independent sign cross-check)")
print("a^2 == aa:", a_L*a_L == Maa.change_ring(L))
print("b^2 == bb:", b_L*b_L == Mbb.change_ring(L))

print()
print("=" * 72)
print("STEP 2 -- a NORMALIZES R AND SWAPS M0 <-> M1 (GLOBALLY)")
print("=" * 72)

def adjugate_K(m):
    return Matrix(K, [[m[1,1], -m[0,1]], [-m[1,0], m[0,0]]])

Ainv0 = adjugate_K(A0)  # a^{-1} = sq * Ainv0
# a * m * a^{-1} = sq*A0 * m * sq*Ainv0 = D_a * A0 * m * Ainv0, for any
# K-rational m: the sq's cancel to D_a in K.  Purely K-rational computation.
def conj_by_a(m):
    return D_a * A0 * m * Ainv0

R_conj_by_a = [conj_by_a(m) for m in R_basis]
a_normalizes_R = same_lattice(R_conj_by_a, R_basis)
a_M0_to_M1 = same_lattice([conj_by_a(m) for m in M0_basis], M1_basis)
a_M1_to_M0 = same_lattice([conj_by_a(m) for m in M1_basis], M0_basis)
a_fixes_M0 = same_lattice([conj_by_a(m) for m in M0_basis], M0_basis)

print("a normalizes global R (a R a^-1 = R, as O_K-lattices):", a_normalizes_R)
print("a sends M0 -> M1:", a_M0_to_M1)
print("a sends M1 -> M0:", a_M1_to_M0)
print("a fixes M0 individually (should be False):", a_fixes_M0)
assert a_normalizes_R
assert a_M0_to_M1
assert a_M1_to_M0
assert not a_fixes_M0
print("=> a in N_K(R), a NOT in N_K^+(R): CERTIFIED")

print()
print("=" * 72)
print("STEP 3 -- NORMALITY OF Gamma_009^+ UNDER J AND Y (already-known")
print("N_K^+(R) generators), CHECKED ON ITS OWN GENERATORS a^2,ab,ba^-1")
print("=" * 72)

def frame_convert(g_global):
    return d0.inverse() * g_global * d0

def word_for_K_rational(g_global, label):
    gf = frame_convert(g_global)
    print("   [%s] det in M0 frame =" % label, gf.det())
    assert gf.det() == 1, "%s: determinant is not 1 (%s)" % (label, gf.det())
    assert all(K(z).is_integral() for z in gf.list()), (label, "not O_K-integral in M0 frame")
    word, steps = euclidean_word(gf, tA, tB, tU)
    return word, gf, steps

def in_subgroup(word, subgroup):
    cyclic = libgap.Subgroup(T7, [word])
    return bool(libgap.IsSubgroup(subgroup, cyclic))

named = {"a^2": kernel_reps["a^2"], "ab": kernel_reps["ab"],
         "ba^-1": kernel_reps["ba^-1"]}
# normalize to det 1 exactly as in the square_stabilizer certificate
named_sl = {"a^2": kernel_reps["a^2"], "ab": kernel_reps["ab"],
            "ba^-1": (K(1)/4) * kernel_reps["ba^-1"]}

all_pass_step3 = True
for outer_name, Outer in [("J", J_global), ("Y", Y_global)]:
    for gen_name, g in named_sl.items():
        conj = Outer * g * Outer.inverse()
        word, gf, steps = word_for_K_rational(conj, "%s(%s)J^-1" % (outer_name, gen_name))
        ok = in_subgroup(word, GammaPlus)
        print(" %s (%s) %s^-1 -> word %s  (Euclidean steps=%d)  in Gamma_009^+: %s"
              % (outer_name, gen_name, outer_name, word, steps, ok))
        all_pass_step3 = all_pass_step3 and ok
        assert ok, "%s does NOT normalize Gamma_009^+ on generator %s" % (outer_name, gen_name)

print()
print("Gamma_009^+ normalized by both J and Y on all three generators:", all_pass_step3)

print()
print("=" * 72)
print("STEP 4 -- NORMALITY ON THE ODD GENERATOR a: J a J^-1 a^-1 and")
print("Y a Y^-1 a^-1 (automatically K-rational; the sq's cancel)")
print("=" * 72)

def conj_odd_over_a(Outer):
    # Outer * a * Outer^-1 * a^-1 = sq*(Outer A0 Outer^-1) * sq*Ainv0
    #                            = D_a * (Outer A0 Outer^-1) * Ainv0
    inner = Outer * A0 * Outer.inverse()
    return D_a * inner * Ainv0

for outer_name, Outer in [("J", J_global), ("Y", Y_global)]:
    gamma = conj_odd_over_a(Outer)
    print(outer_name, "a", outer_name, "^-1 a^-1 =", gamma.list(), " det =", gamma.det())
    word, gf, steps = word_for_K_rational(gamma, "%s a %s^-1 a^-1" % (outer_name, outer_name))
    ok = in_subgroup(word, GammaPlus)
    print("  -> word", word, " (Euclidean steps=%d)  in Gamma_009^+:" % steps, ok)
    assert ok, "%s does not normalize Gamma_009 via the odd generator a" % outer_name

print()
print("=" * 72)
print("STEP 5 -- QUOTIENT STRUCTURE: C4 vs C2xC2, via direct relations")
print("=" * 72)
print("Gamma_009 = Gamma_009^+ . {1,a} (disjoint, by parity: a=sq*A0 is not")
print("K-rational, so Gamma_009^+ . a is entirely OUTSIDE PGL_2(K)).")
print("J, Y, J*Y are all K-rational, hence never lie in Gamma_009^+ . a --")
print("so J,Y,J*Y lie in Gamma_009 at all only if they lie in Gamma_009^+.")

for name, g in [("J^2", J_global**2), ("Y^2", Y_global**2),
                ("[J,Y]=JYJ^-1Y^-1",
                 J_global*Y_global*J_global.inverse()*Y_global.inverse())]:
    word, gf, steps = word_for_K_rational(g, name)
    ok = in_subgroup(word, GammaPlus)
    print(" ", name, "-> word", word, " in Gamma_009^+:", ok)
    assert ok

print()
print("det(J) =", J_global.det(), " square in K:", K(J_global.det()).is_square())
print("det(Y) =", Y_global.det(), " square in K:", K(Y_global.det()).is_square())
print("det(J*Y) =", (J_global*Y_global).det(),
      " square in K:", K((J_global*Y_global).det()).is_square())
print("Every Gamma_009^+ generator has square determinant (certified earlier),")
print("so Gamma_009^+ subset ker(delta). J and J*Y have NONsquare determinant,")
print("hence J, J*Y are NOT in Gamma_009^+ (so not in Gamma_009 at all, by the")
print("parity argument above). Y was already GAP-certified y not in Gamma_009^+")
print("in the loaded coset-rep certificate. So J,Y,J*Y are three PAIRWISE")
print("DISTINCT nontrivial elements of N_K(R)/Gamma_009, each squaring to the")
print("identity, and they commute -- the Klein four-group, not C4.")

assert K(J_global.det()).is_square() is False
assert K((J_global*Y_global).det()).is_square() is False
assert not y_in_gamma  # Y not in Gamma_009^+, from the loaded certificate

print()
print("=" * 72)
print("CERTIFIED CONCLUSION")
print("=" * 72)
print("Gamma_009^+ is normalized by J and Y (Step 3).")
print("J a J^-1 a^-1 and Y a Y^-1 a^-1 both lie in Gamma_009^+ (Step 4),")
print("so J a J^-1 and Y a Y^-1 both lie in Gamma_009 = Gamma_009^+ . {1,a}.")
print("a in Gamma_009 trivially conjugates Gamma_009 into itself.")
print("Since N_K(R) = N_K^+(R) . {1,a} (Step 2) and N_K^+(R) = <J,Y,Gamma_009^+>,")
print("every generator of N_K(R) normalizes Gamma_009:")
print()
print("  Gamma_009 is normal in N_K(R): CERTIFIED")
print("  [N_K(R):Gamma_009] = 4  (already certified by index-chasing)")
print("  N_K(R)/Gamma_009 = {1, J, Y, JY} mod Gamma_009, each of order <=2,")
print("  pairwise distinct, commuting (Step 5):")
print()
print("  N_K(R)/Gamma_009 =~= C2 x C2")
print()
print("FULL NORMALIZER QUOTIENT CERTIFICATE: PASS")
