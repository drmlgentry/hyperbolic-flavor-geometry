# Actually settle C2xC2 vs C4 for N_K(R)/Gamma_009, rather than accept it
# asserted with no script or log attached.
#
# Reduction used (derived, not assumed): {1, J, Y, J*Y} are valid
# representatives for N_K(R)/Gamma_009 as a SET -- all four lie in
# N_K^+(R), hence are K-rational, hence distinct mod Gamma_009 exactly
# when distinct mod Gamma_009^+, because the only element of Gamma_009
# outside Gamma_009^+ is (a coset of) the raw generator 'a', which is
# NOT K-rational (established earlier this session), so it can never
# identify two distinct K-rational cosets. So the group-structure
# question reduces to: is Gamma_009^+ normal in N_K^+(R)=<N^{+,0},J>,
# and if so is the order-4 quotient C2xC2 or C4.

load("reproduce/m009_square_stabilizer_certificate.sage")

from sage.all import libgap


def in_gamma_plus(word_elt):
    return bool(word_elt in GammaPlus)


print()
print("=" * 72)
print("STEP 1: does J normalize Gamma_009^+ ?")
print("=" * 72)

conj_membership = {}
for name, g in gamma_global_sl.items():
    conj = J_global * g * J_global.inverse()
    assert conj.det() == 1
    conj_frame = d0.inverse() * conj * d0
    assert all(K(z).is_integral() for z in conj_frame.list())
    word, _ = euclidean_word(conj_frame, tA, tB, tU)
    is_in = in_gamma_plus(word)
    conj_membership[name] = is_in
    print(f"  J*{name}*J^-1 -> word {word} -> in Gamma_009^+: {is_in}")

J_normalizes_GammaPlus = all(conj_membership.values())
print()
print("J normalizes Gamma_009^+:", J_normalizes_GammaPlus)

if not J_normalizes_GammaPlus:
    print()
    print("RESULT: Gamma_009 is NOT normal in N_K(R) -- no well-defined")
    print("quotient GROUP exists. 'C2xC2 vs C4' is malformed as posed;")
    print("only the coset SPACE of size 4 (already established) exists.")
else:
    print()
    print("=" * 72)
    print("STEP 2: orders mod Gamma_009^+ of Y and J*Y (J^2=I trivially)")
    print("=" * 72)
    # BUG FIX: pi_pbar=1-w gives T_(1-w), which the coset-rep hardening
    # certificate explicitly showed is ALREADY in Gamma_009^+ (the
    # rejected guess, "x outside Gamma_009^+ = False" in the earlier
    # log) -- NOT the genuine nontrivial representative. The actual
    # certified one is y = T_{-1-w} (M0 frame [[1,-w-1],[0,1]], Reese
    # word f1^-1*f3^-1 = A^-1*U^-1), global frame [[1,w-3],[0,1]].
    Y_frame_correct = translation_matrix(-1 - w)
    assert Y_frame_correct == Matrix(K, [[1, -w - 1], [0, 1]])
    Y_global = d0 * Y_frame_correct * d0.inverse()
    assert Y_global == Matrix(K, [[1, w - 3], [0, 1]]), \
        f"Y_global mismatch: got {Y_global.list()}, expected the certified [1,w-3,0,1]"
    print("Y_global (CORRECTED, matches the certified hardening rep) =", Y_global.list())
    Y_sq = Y_global * Y_global
    Y_sq_frame = d0.inverse() * Y_sq * d0
    assert Y_sq.det() == 1
    assert all(K(z).is_integral() for z in Y_sq_frame.list())
    word_Ysq, _ = euclidean_word(Y_sq_frame, tA, tB, tU)
    Y_sq_in = in_gamma_plus(word_Ysq)
    print("Y^2 in Gamma_009^+:", Y_sq_in, "(expect True, matches hardening cert)")

    JY = J_global * Y_global
    JY_sq = JY * JY
    print()
    print("(J*Y)^2 =", JY_sq.list(), " det =", JY_sq.det())
    if JY_sq.det() == 1:
        JY_sq_frame = d0.inverse() * JY_sq * d0
        if all(K(z).is_integral() for z in JY_sq_frame.list()):
            word_JYsq, _ = euclidean_word(JY_sq_frame, tA, tB, tU)
            JY_sq_in = in_gamma_plus(word_JYsq)
            print("(J*Y)^2 in Gamma_009^+:", JY_sq_in)
        else:
            print("(J*Y)^2 not integral in the d0-SL2(O_K) frame -- unexpected, investigate")
            JY_sq_in = None
    else:
        print("(J*Y)^2 has det != 1 -- unexpected since det(J)=-1 and det(Y)=1,")
        print("det(JY)=-1, det((JY)^2)=1 should hold... investigate if this fires")
        JY_sq_in = None

    print()
    print("=" * 72)
    print("CONCLUSION")
    print("=" * 72)
    if Y_sq_in and JY_sq_in:
        print("Every one of J, Y, J*Y has order dividing 2 mod Gamma_009^+.")
        print("An order-4 group in which every non-identity element has")
        print("order <=2 is FORCED to be C2xC2 (a cyclic C4 needs an")
        print("element of order 4). Hence:")
        print()
        print("N_K^+(R)/Gamma_009^+ (and hence N_K(R)/Gamma_009) = C2 x C2")
    else:
        print("At least one of Y^2, (J*Y)^2 does NOT lie in Gamma_009^+ --")
        print("cannot conclude C2xC2 from this test; would need the actual")
        print("element orders mod Gamma_009^+ computed directly in GAP.")
