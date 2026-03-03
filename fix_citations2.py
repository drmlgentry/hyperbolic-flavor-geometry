import os

base = r'C:\dev\framework\papers'

fixes = {
    r'holonomy-cp\gentry-holonomy-cp.tex': [
        ('requires no continuous parameter tuning and applies to any compact hyperbolic',
         'requires no continuous parameter tuning~\\cite{thurston,BrancoCP} and applies to any compact hyperbolic'),
        ('stable, and independent of continuous parameter tuning. We make the',
         'stable, and independent of continuous parameter tuning~\\cite{ratcliffe,bridsonhaefliger}. We make the'),
    ],
    r'flavor-mixing\gentry-flavor-mixing.tex': [
        ('dynamical input or continuous tuning.',
         'dynamical input or continuous tuning~\\cite{Jarlskog,ratcliffe,PDGreview}.'),
    ],
}

for rel, replacements in fixes.items():
    path = os.path.join(base, rel)
    t = open(path, encoding='utf-8').read()
    for old, new in replacements:
        if old in t:
            t = t.replace(old, new, 1)
            print(f'  OK: {old[:60]}')
        else:
            print(f'  MISS: {old[:60]}')
    open(path, 'w', encoding='utf-8').write(t)
    print(f'Saved: {os.path.basename(path)}')

print('Done.')
