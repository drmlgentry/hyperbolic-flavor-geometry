x = polygen(QQ, 'x')
K.<w> = NumberField(x^2 - x + 2)
print('K =', K, ' disc =', K.discriminant())
print('Factorization of (2) in O_K:')
F2 = K.ideal(2).factor()
print(F2)
for pr, e in F2:
    print(' prime:', pr, ' norm:', pr.norm(), ' exponent:', e)

Rp.<xx> = K[]
p = 2*xx^2 - xx + 8
print()
print('roots of 2x^2-x+8 over K:', p.roots())
candidate = (3*w - 1)/2
print('(3w-1)/2 =', candidate)
print('is (3w-1)/2 a root?', p(candidate) == 0)
OK = K.ring_of_integers()
print('is (3w-1)/2 in O_K?', candidate in OK)
print('is 2*(3w-1)/2 = 3w-1 in O_K?', (2*candidate) in OK)

print()
print('=== volume/covolume cross-check ===')
covol_T7 = 0.888914927816353
covol_N_p = covol_T7 * 3/2
print('covol(N(R_p)) predicted =', covol_N_p)
vol_m009 = 2.66674478344906
print('vol(m009)/covol(N(R_p)) =', vol_m009/covol_N_p)
