x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
OK = K.ring_of_integers()
Pw = K.ideal(w)
P1w = K.ideal(1 - w)

def adjugate(m):
    a, b, c, d = m[0, 0], m[0, 1], m[1, 0], m[1, 1]
    return Matrix(K, [[d, -b], [-c, a]])

def trd_pairing(e1, e2):
    return (e1 * adjugate(e2)).trace()

# Standard basis of M_2(O_K): the four matrix units
E11 = Matrix(K, [[1, 0], [0, 0]])
E12 = Matrix(K, [[0, 1], [0, 0]])
E21 = Matrix(K, [[0, 0], [1, 0]])
E22 = Matrix(K, [[0, 0], [0, 1]])
basis = [E11, E12, E21, E22]

Gram = Matrix(K, 4, 4, lambda i, j: trd_pairing(basis[i], basis[j]))
print("Gram matrix of M_2(O_K) standard basis:")
print(Gram)
disc = Gram.det()
print("disc(M_2(O_K)) [reference/baseline] =", disc)
fi = K.ideal(disc)
print("v_P(disc) =", fi.valuation(Pw), " v_Pbar(disc) =", fi.valuation(P1w))
