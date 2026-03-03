import os

base = r'C:\dev\framework\papers'

tex_files = [
    r'holonomy-cp\gentry-holonomy-cp.tex',
    r'shape-space\gentry-shape-space.tex',
    r'hyperbolic-lattice\gentry-hyperbolic-lattice.tex',
    r'flavor-mixing\gentry-flavor-mixing.tex',
]

correct_block = (
    '\\author[1]{Marvin L.\\ Gentry}\n'
    '\\affil[1]{Independent Researcher\\\\\n'
    '  \\texttt{drmlgentry@protonmail.com}\\\\\n'
    '  ORCID: 0009-0006-4550-2663}\n'
)

for rel in tex_files:
    path = os.path.join(base, rel)
    t = open(path, encoding='utf-8').read()
    
    # Remove everything between \date{} and \begin{document}
    # then insert exactly one correct block
    import re
    t = re.sub(
        r'(\\date\{\})\s*(.*?)(\\begin\{document\})',
        r'\1\n' + correct_block.replace('\\', '\\\\') + r'\3',
        t, flags=re.DOTALL
    )
    open(path, 'w', encoding='utf-8').write(t)
    print(f'Fixed: {os.path.basename(path)}')

print('Done.')
