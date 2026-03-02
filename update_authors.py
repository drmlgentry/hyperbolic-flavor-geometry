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
    t = open(path, encoding='utf-8').read()
    t = re.sub(r'\\bibliography\{[^}]+\}', r'\\bibliography{' + bibname + '}', t)
    t = t.replace('\\usepackage{geometry}', '\\usepackage{geometry}\n\\usepackage{authblk}', 1)
    t = re.sub(r'\\author\{Marvin L\.\\ Gentry\}', affil, t)
    open(path, 'w', encoding='utf-8').write(t)
    print(f'Updated: {os.path.basename(path)}')

print('All done.')
