# Explicit nontrivial coset representative and quotient-action hardening
# certificate for the already-proved m009 square stabilizer index.
#
# This script does not change the theorem proved by
# m009_square_stabilizer_certificate.sage. It loads that exact certificate,
# extracts the nonidentity coset from GAP, converts its Reese word back to
# an exact matrix, and independently checks the degree-two quotient action.

load("reproduce/m009_square_stabilizer_certificate.sage")

print()
print("=" * 72)
print("EXPLICIT NONTRIVIAL SQUARE-PART COSET REPRESENTATIVE")
print("=" * 72)

assert square_index == 2
assert bool(libgap.IsNormal(Iwahori, GammaPlus))


def gap_element_in_subgroup(element, subgroup):
    """Exact membership via containment of the generated cyclic subgroup."""
    cyclic = libgap.Subgroup(T7, [element])
    return bool(libgap.IsSubgroup(subgroup, cyclic))


# Extract the two right cosets from the already-certified index-two pair.
transversal = libgap.RightTransversal(Iwahori, GammaPlus)
transversal_list = list(libgap.AsList(transversal))
assert len(transversal_list) == 2

inside_reps = [g for g in transversal_list
               if gap_element_in_subgroup(g, GammaPlus)]
outside_reps = [g for g in transversal_list
                if not gap_element_in_subgroup(g, GammaPlus)]
assert len(inside_reps) == 1
assert len(outside_reps) == 1

y_gap = outside_reps[0]
y_in_gamma = gap_element_in_subgroup(y_gap, GammaPlus)
y_square_in_gamma = gap_element_in_subgroup(y_gap**2, GammaPlus)
assert not y_in_gamma
assert y_square_in_gamma

print("Reese word:", y_gap)
print("y in Gamma_009^+ (direct GAP membership):", y_in_gamma)
print("y^2 in Gamma_009^+ (direct GAP membership):", y_square_in_gamma)


# Convert the exact fp-group word to a matrix in the Reese generators.
external_rep = [ZZ(z) for z in list(libgap.ExtRepOfObj(y_gap))]
assert len(external_rep) % 2 == 0
reese_matrices = [TA, TB, TU]
Y = I2
for j in range(0, len(external_rep), 2):
    generator_number = external_rep[j]
    exponent = external_rep[j + 1]
    assert 1 <= generator_number <= 3
    Y = Y * reese_matrices[generator_number - 1]**exponent

assert Y.det() == 1
assert all(K(z).is_integral() for z in Y.list())
assert Y[0, 1] in pbar

# Reconstruct the square word independently and verify the corresponding
# exact matrix is Y^2 up to the projective central sign.
y_square_external_rep = [ZZ(z) for z in
                         list(libgap.ExtRepOfObj(y_gap**2))]
Y_square_from_word = I2
for j in range(0, len(y_square_external_rep), 2):
    generator_number = y_square_external_rep[j]
    exponent = y_square_external_rep[j + 1]
    assert 1 <= generator_number <= 3
    Y_square_from_word = (
        Y_square_from_word *
        reese_matrices[generator_number - 1]**exponent)
assert projectively_equal(Y_square_from_word, Y**2)


# Independent degree-two quotient-action check. Since GammaPlus is normal
# of index two, the kernel of the action on right cosets must be GammaPlus;
# assert this rather than infer it from the direct Index call alone.
right_cosets = libgap.RightCosets(Iwahori, GammaPlus)
assert len(list(right_cosets)) == 2
coset_action = libgap.ActionHomomorphism(Iwahori, right_cosets,
                                         libgap.OnRight)
action_image = libgap.Image(coset_action)
action_kernel = libgap.Kernel(coset_action)
assert ZZ(libgap.Size(action_image)) == 2
assert bool(libgap.IsSubgroup(action_kernel, GammaPlus))
assert bool(libgap.IsSubgroup(GammaPlus, action_kernel))

y_action = libgap.Image(coset_action, y_gap)
assert not bool(libgap.IsOne(y_action))
assert bool(libgap.IsOne(y_action**2))

print()
print("DEGREE-TWO QUOTIENT ACTION")
print("image size:", libgap.Size(action_image))
print("image of y:", y_action)
print("kernel equals Gamma_009^+: True")
print("Images of the GAP-generated Iwahori generators:")
for j, generator in enumerate(list(Iwahori.GeneratorsOfGroup())):
    print("  Iwahori generator", j + 1, "=", generator,
          " -> ", libgap.Image(coset_action, generator))


# Return to the original exact global frame and verify every global object.
Y_global = d0 * Y * d0.inverse()
Y_fixes_M0 = same_lattice(conjugate_basis(Y_global, M0_basis), M0_basis)
Y_fixes_M1 = same_lattice(conjugate_basis(Y_global, M1_basis), M1_basis)
Y_normalizes_R = same_lattice(conjugate_basis(Y_global, R_basis), R_basis)
Y_squareclass_trivial = K(Y_global.det()).is_square()

assert Y_fixes_M0
assert Y_fixes_M1
assert Y_normalizes_R
assert Y_global.det() == 1
assert Y_squareclass_trivial

print()
print("M0-frame matrix:")
print(Y)
print("Global-frame matrix:")
print(Y_global)
print("y in Gamma^0(pbar):", Y.det() == 1 and Y[0, 1] in pbar)
print("y in Gamma_009^+:", y_in_gamma)
print("y^2 in Gamma_009^+:", y_square_in_gamma)
print("y fixes global M0:", Y_fixes_M0)
print("y fixes global M1:", Y_fixes_M1)
print("y normalizes global R:", Y_normalizes_R)
print("determinant squareclass trivial:", Y_squareclass_trivial)

print()
print("=" * 72)
print("CERTIFIED HARDENING CONCLUSION OF A SUCCESSFUL RUN")
print("=" * 72)
print("N^{+,0}/Gamma_009^+ = {Gamma_009^+, y*Gamma_009^+}")
print("with the exact Reese word and matrices printed above.")
print("This does not change the already-certified full index 4.")
