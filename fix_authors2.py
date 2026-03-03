import os, re

base = r'C:\dev\framework\papers'

tex_files = {
    r'holonomy-cp\gentry-holonomy-cp.tex':               'gentry-holonomy-cp',
    r'shape-space\gentry-shape-space.tex':               'gentry-shape-space',
    r'hyperbolic-lattice\gentry-hyperbolic-lattice.tex': 'gentry-hyperbolic-lattice',
    r'flavor-mixing\gentry-flavor-mixing.tex':           'gentry-flavor-mixing',
}

for rel, bibname in tex_files.items():
    path = os.path.join(base, rel)
    lines = open(path, encoding='utf-8').readlines()
    
    # Remove any line that is part of a broken author/affil block
    # (lines containing control chars, partial exttt, partial affil fragments)
    clean = []
    for l in lines:
        if any(ord(c) < 32 and c not in '\t\n\r' for c in l):
            continue  # skip control char lines
        stripped = l.strip()
        # Skip broken fragments (not starting with backslash but containing these)
        if stripped.startswith('exttt{') or stripped.startswith('ORCID') and not stripped.startswith('\\'):
            continue
        if stripped.startswith('exttt'):
            continue
        clean.append(l)
    
    # Now ensure exactly one correct author block after \date{}
    # First remove any existing \author and \affil lines
    clean = [l for l in clean if not l.strip().startswith('\\author[') 
             and not l.strip().startswith('\\affil[')]
    
    # Insert correct block after \date{}
    result = []
    for l in clean:
        result.append(l)
        if l.strip() == '\\date{}':
            result.append('\\author[1]{Marvin L.\\ Gentry}\n')
            result.append('\\affil[1]{Independent Researcher\\\\\n')
            result.append('  \\texttt{drmlgentry@protonmail.com}\\\\\n')
            result.append('  ORCID: 0009-0006-4550-2663}\n')
    
    open(path, 'w', encoding='utf-8').write(''.join(result))
    print(f'Fixed: {os.path.basename(path)}')

print('Done.')
