# Task 2, step 1c: how does pbar factor in L (degree 4, containing K)?
# Determines whether a,b's local action at pbar can be tested inside
# Q2 itself (if pbar splits/stays with residue-friendly behavior in L)
# or needs a genuine 2-adic extension.

from sage.all import ComplexField, QQ, polygen

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()

y = polygen(QQ, 'y')
L = NumberField(y**4 - y**3 + y + 1, 'a')
a_gen = L.gen()

print("K:", K, " disc:", K.discriminant())
print("L:", L, " disc:", L.discriminant())
print("L disc factorization:", L.discriminant().factor())

embs = K.embeddings(L)
print()
print("Number of K -> L embeddings:", len(embs))
phi = embs[0]
print("Using embedding: w ->", phi(w))

pbar_K = K.ideal(1 - w)
p_K = K.ideal(w)
print()
print("pbar (in K):", pbar_K, " norm:", pbar_K.norm())

pbar_in_L = L.ideal([phi(g) for g in pbar_K.gens()])
print()
print("pbar extended to L:", pbar_in_L)
fact_pbar = pbar_in_L.factor()
print("Factorization of pbar*O_L:", fact_pbar)
for P, e in fact_pbar:
    print(f"  prime {P}: norm={P.norm()}, residue degree f={P.residue_class_degree()}, ram e={e}")

print()
p_in_L = L.ideal([phi(g) for g in p_K.gens()])
fact_p = p_in_L.factor()
print("Factorization of p*O_L:", fact_p)
for P, e in fact_p:
    print(f"  prime {P}: norm={P.norm()}, residue degree f={P.residue_class_degree()}, ram e={e}")

print()
print("2*O_L factorization (sanity, should combine p and pbar's L-factors):")
fact2 = L.ideal(2).factor()
print(fact2)
