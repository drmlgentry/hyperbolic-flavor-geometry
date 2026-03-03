import os, re

base = r'C:\dev\framework\papers'

tex_files = {
    r'holonomy-cp\gentry-holonomy-cp.tex':               'gentry-holonomy-cp',
    r'shape-space\gentry-shape-space.tex':               'gentry-shape-space',
    r'hyperbolic-lattice\gentry-hyperbolic-lattice.tex': 'gentry-hyperbolic-lattice',
    r'flavor-mixing\gentry-flavor-mixing.tex':           'gentry-flavor-mixing',
}

affil = (
    '\\author[1]{Marvin L.\\ Gentry}\n'
    '\\affil[1]{Independent Researcher\\\\\n'
    '  \\texttt{drmlgentry@protonmail.com}\\\\\n'
    '  ORCID: 0009-0006-4550-2663}'
)

for rel, bibname in tex_files.items():
    path = os.path.join(base, rel)
    raw = open(path, encoding='utf-8').read()
    # Remove any control characters (U+0000-U+001F except tab, newline, cr)
    cleaned = ''.join(c for c in raw if ord(c) >= 32 or c in '\t\n\r')
    # Fix corrupted author block - remove any line containing ^^G artifacts
    lines = cleaned.splitlines()
    lines = [l for l in lines if '\x07' not in l and 'uthor[1]' not in l and 'ffil[1]' not in l]
    cleaned = '\n'.join(lines)
    # Now insert correct author block after \date{}
    cleaned = cleaned.replace('\\date{}', '\\date{}\n' + affil, 1)
    open(path, 'w', encoding='utf-8').write(cleaned)
    print(f'Fixed: {os.path.basename(path)}')

print('Done.')
