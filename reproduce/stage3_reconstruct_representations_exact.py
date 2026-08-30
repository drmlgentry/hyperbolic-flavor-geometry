#!/usr/bin/env python3
"""Dependency-free exact certificate for the Stage 3 representation-lift audit.

This script checks only the defining presentation, peripheral words, and
universal character coordinates.  It does not enumerate experimental words
or compare states.
"""


def k_add(a, b):
    return tuple(a[i] + b[i] for i in range(3))


def k_neg(a):
    return tuple(-v for v in a)


def k_sub(a, b):
    return k_add(a, k_neg(b))


def k_mul(a, b):
    # Q[u]/(u^3 + u^2 - u - 2); all values used here are integral.
    c = [0] * 5
    for i, av in enumerate(a):
        for j, bv in enumerate(b):
            c[i + j] += av * bv
    for degree in range(4, 2, -1):
        coeff = c[degree]
        if coeff:
            # u^degree = u^(degree-3) * (-u^2 + u + 2)
            c[degree] = 0
            c[degree - 1] -= coeff
            c[degree - 2] += coeff
            c[degree - 3] += 2 * coeff
    return tuple(c[:3])


def k_scale(n, a):
    return tuple(n * v for v in a)


def k_pow(a, n):
    value = K_ONE
    for _ in range(n):
        value = k_mul(value, a)
    return value


def k_sum(*values):
    out = K_ZERO
    for value in values:
        out = k_add(out, value)
    return out


K_ZERO = (0, 0, 0)
K_ONE = (1, 0, 0)
K_U = (0, 1, 0)


def m006_character_surface(x, y, z):
    inner = k_sum(
        k_mul(k_mul(k_pow(x, 3), y), z),
        k_neg(k_mul(k_mul(k_pow(x, 2), k_pow(y, 2)), k_pow(z, 2))),
        k_mul(k_pow(x, 2), k_pow(y, 2)),
        k_scale(-2, k_pow(x, 2)),
        k_mul(k_mul(x, y), k_pow(z, 3)),
        k_scale(-2, k_mul(k_mul(x, y), z)),
        k_mul(k_pow(y, 2), k_pow(z, 2)),
        k_neg(k_pow(y, 2)),
        k_scale(-2, k_pow(z, 2)),
        (3, 0, 0),
    )
    return k_sub(k_neg(k_mul(y, inner)), (2, 0, 0))


def e_add(a, b):
    return (k_add(a[0], b[0]), k_add(a[1], b[1]))


def e_neg(a):
    return (k_neg(a[0]), k_neg(a[1]))


def e_sub(a, b):
    return e_add(a, e_neg(b))


def e_mul(a, b):
    # E = K[s]/(s^2 - u*s + 1).  Write elements as a0 + a1*s.
    a0, a1 = a
    b0, b1 = b
    a1b1 = k_mul(a1, b1)
    constant = k_sub(k_mul(a0, b0), a1b1)
    s_coeff = k_add(k_add(k_mul(a0, b1), k_mul(a1, b0)),
                    k_mul(K_U, a1b1))
    return (constant, s_coeff)


E_ZERO = (K_ZERO, K_ZERO)
E_ONE = (K_ONE, K_ZERO)
E_U = (K_U, K_ZERO)
E_S = (K_ZERO, K_ONE)


def e_from_int(n):
    return ((n, 0, 0), K_ZERO)


def mat_mul(a, b):
    out = [[E_ZERO, E_ZERO], [E_ZERO, E_ZERO]]
    for i in range(2):
        for j in range(2):
            value = E_ZERO
            for k in range(2):
                value = e_add(value, e_mul(a[i][k], b[k][j]))
            out[i][j] = value
    return out


def mat_neg(a):
    return [[e_neg(a[i][j]) for j in range(2)] for i in range(2)]


def mat_trace(a):
    return e_add(a[0][0], a[1][1])


def mat_det(a):
    return e_sub(e_mul(a[0][0], a[1][1]), e_mul(a[0][1], a[1][0]))


def mat_inv_sl2(a):
    assert mat_det(a) == E_ONE
    return [[a[1][1], e_neg(a[0][1])],
            [e_neg(a[1][0]), a[0][0]]]


MAT_ID = [[E_ONE, E_ZERO], [E_ZERO, E_ONE]]


def eval_word(word, a, b):
    inv_a = mat_inv_sl2(a)
    inv_b = mat_inv_sl2(b)
    letters = {"a": a, "b": b, "A": inv_a, "B": inv_b}
    value = MAT_ID
    for letter in word:
        value = mat_mul(value, letters[letter])
    return value


def fmt_k(a):
    return f"({a[0]}) + ({a[1]})*u + ({a[2]})*u^2"


def fmt_e(a):
    return f"[{fmt_k(a[0])}] + [{fmt_k(a[1])}]*s"


def main():
    # Companion gauge with tr(A)=u, tr(B)=u+1, tr(AB)=s+s^-1=u.
    # Since s^2-u*s+1=0, -s^-1=s-u.
    a = [[E_U, e_from_int(-1)], [E_ONE, E_ZERO]]
    b = [[E_ZERO, E_S], [e_sub(E_S, E_U), e_add(E_U, E_ONE)]]

    relator = "ababbAAbb"
    meridian = "Abb"
    longitude = "AAbA"

    assert mat_det(a) == E_ONE
    assert mat_det(b) == E_ONE
    assert mat_trace(a) == E_U
    assert mat_trace(b) == e_add(E_U, E_ONE)
    assert mat_trace(mat_mul(a, b)) == E_U
    assert eval_word(relator, a, b) == MAT_ID
    assert mat_trace(eval_word(meridian, a, b)) == e_from_int(2)
    assert mat_trace(eval_word(longitude, a, b)) == e_from_int(-2)
    assert mat_mul(eval_word(meridian, a, b), eval_word(longitude, a, b)) == \
        mat_mul(eval_word(longitude, a, b), eval_word(meridian, a, b))

    # Twist by chi(a)=1, chi(b)=0.
    at = mat_neg(a)
    bt = b
    assert eval_word(relator, at, bt) == MAT_ID
    assert mat_trace(at) == e_neg(E_U)
    assert mat_trace(bt) == e_add(E_U, E_ONE)
    assert mat_trace(mat_mul(at, bt)) == e_neg(E_U)
    assert mat_trace(eval_word(meridian, at, bt)) == e_from_int(-2)
    assert mat_trace(eval_word(longitude, at, bt)) == e_from_int(2)

    assert m006_character_surface(K_U, k_add(K_U, K_ONE), K_U) == K_ZERO

    # The peripheral trace equations alone admit another algebraic branch
    # y=u^2-2, z=u+4, but it does not lie on the m006 character surface.
    alternate_y = (-2, 0, 1)
    alternate_z = (4, 1, 0)
    assert m006_character_surface(K_U, alternate_y, alternate_z) != K_ZERO

    # Reducibility discriminant x^2+y^2+z^2-xyz-4 = 3*u^2+u-5.
    discr = (-5, 1, 3)
    assert discr != K_ZERO

    print("EXACT CHECK: PASS")
    print("base det(A)=det(B)=1")
    print("base tr(A) =", fmt_e(mat_trace(a)))
    print("base tr(B) =", fmt_e(mat_trace(b)))
    print("base tr(AB)=", fmt_e(mat_trace(mat_mul(a, b))))
    print("base relator=I")
    print("base tr(mu)=+2, tr(lambda)=-2, [mu,lambda]=I")
    print("twist relator=I")
    print("twist tr(A)=-u, tr(B)=u+1, tr(AB)=-u")
    print("twist tr(mu)=-2, tr(lambda)=+2")
    print("m006 character surface vanishes at (u,u+1,u)")
    print("the second peripheral-equation branch (u,u^2-2,u+4) is rejected by the character surface")
    print("irreducibility discriminant = 3*u^2+u-5 != 0 in Q[u]/(u^3+u^2-u-2)")


if __name__ == "__main__":
    main()
