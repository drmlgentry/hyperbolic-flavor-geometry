path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

old = 'The odd primes appearing are 3, 5, and 7---precisely the odd primes\nsatisfying $p \\leq 2N_g + 1 = 7$ for $N_g = 3$ generations.'

new = ('The odd primes appearing are 3, 5, 7, and 13---all odd primes.\n'
       'The primes 3, 5, and 7 satisfy $p \\leq 2N_g + 1 = 7$ for $N_g = 3$\n'
       'generations, while $p = 13$ suggests the full pattern may involve\n'
       'all odd primes dividing the order of a flavor symmetry group larger\n'
       'than $S_{N_g}$; we leave this as an open question.')

if old in tex:
    tex = tex.replace(old, new)
    with open(path, 'w', encoding='utf-8') as f: f.write(tex)
    print('Prime bound sentence updated')
else:
    print('Pattern not found')
