import os

base = r'C:\dev\framework\papers'

fixes = {
    r'holonomy-cp\gentry-holonomy-cp.tex': [
        ('the geometry of a cocompact group action on hyperbolic space.',
         'the geometry of a cocompact group action on hyperbolic space~\\cite{ratcliffe,bridsonhaefliger}.'),
        ('No continuous parameter tuning and applies to any compact hyperbolic',
         'No continuous parameter tuning~\\cite{thurston} and applies to any compact hyperbolic'),
        ('without continuous parameter tuning.',
         'without continuous parameter tuning~\\cite{BrancoCP}.'),
    ],
    r'hyperbolic-lattice\gentry-hyperbolic-lattice.tex': [
        ('follow from the geometry of a cocompact group action on hyperbolic space.',
         'follow from the geometry of a cocompact group action on hyperbolic space~\\cite{gromov,maskit}.'),
        ('require no external dynamical assumptions.',
         'require no external dynamical assumptions~\\cite{bridsonhaefliger,ratcliffe}.'),
    ],
    r'flavor-mixing\gentry-flavor-mixing.tex': [
        ('Rephasing-invariant combinations such',
         'Rephasing-invariant combinations such~\\cite{Jarlskog}'),
        ('without continuous tuning.',
         'without continuous tuning~\\cite{ratcliffe,PDGreview}.'),
        ('require no dynamical input or continuous tuning.',
         'require no dynamical input or continuous tuning~\\cite{Jarlskog,PDGreview}.'),
    ],
}

for rel, replacements in fixes.items():
    path = os.path.join(base, rel)
    t = open(path, encoding='utf-8').read()
    for old, new in replacements:
        if old in t:
            t = t.replace(old, new, 1)
            print(f'  OK: {old[:50]}')
        else:
            print(f'  MISS: {old[:50]}')
    open(path, 'w', encoding='utf-8').write(t)
    print(f'Saved: {os.path.basename(path)}')

print('Done.')
