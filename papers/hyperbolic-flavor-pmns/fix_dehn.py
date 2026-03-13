path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

old = (
    'The cusped hyperbolic manifold \\texttt{m003} (one cusp) has volume\n'
    '$2.029$, equal to the volume of the cusped \\texttt{m006} (one cusp).\n'
    'The closed manifold \\texttt{OrientableClosedCensus}[1] (m003,\n'
    'vol~$= 0.981$, $H_1 = \\mathbb{Z}/5$) is a Dehn filling of this\n'
    'cusped ancestor, as is the CKM manifold\n'
    '\\texttt{OrientableClosedCensus}[43] (m006, vol~$= 2.029$,\n'
    '$H_1 = \\mathbb{Z}/5$). This raises the possibility that both\n'
    'manifolds arise as Dehn fillings of the \\emph{same} cusped ancestor,\n'
    'with the filling coefficient encoding the quark-lepton distinction\n'
    'between the $K$- and $N$-factors.'
)

new = (
    'The cusped manifold \\texttt{m003} (one cusp, SnapPy cusped census,\n'
    'vol~$= 2.029$) is the cusped ancestor of the closed PMNS manifold\n'
    '\\texttt{OrientableClosedCensus}[1] (vol~$= 0.981$, $H_1 = \\mathbb{Z}/5$)\n'
    'via Dehn filling.\n'
    'The closed CKM manifold \\texttt{OrientableClosedCensus}[43]\n'
    '(vol~$= 2.029$, $H_1 = \\mathbb{Z}/5$) is a Dehn filling of a\n'
    '\\emph{distinct} cusped manifold, also of volume $2.029$.\n'
    'The fact that both closed manifolds share $H_1 = \\mathbb{Z}/5$ and\n'
    'arise from cusped ancestors of equal volume may reflect a deeper\n'
    'arithmetic or topological relation, possibly related to\n'
    'quark-lepton complementarity.'
)

if old in tex:
    tex = tex.replace(old, new)
    with open(path, 'w', encoding='utf-8') as f: f.write(tex)
    print('Fixed')
else:
    print('Not found -- dumping Dehn section for inspection:')
    i = tex.find('subsection{Dehn')
    print(repr(tex[i:i+600]))
