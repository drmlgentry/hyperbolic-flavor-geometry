path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

fig1 = """
\\begin{figure*}[!t]
\\centering
\\includegraphics[width=\\textwidth]{fig1_l_clustering}
\\caption{Clustering of optimal Borel $L$-entries across the census scan,
separated by regime ($|l_{32}| < 1$: compact, circles; $|l_{32}| \\geq 1$:
extended, squares). Color encodes fitness $\\mathcal{F}$.
Dashed lines show the closed-form predictions of
Table~\\ref{tab:closed_form}: the compact and extended values of $|l_{32}|$
are the two roots of the quadratic in Proposition~\\ref{prop:quadratic}.
The entries $|l_{21}|$ and $|l_{31}|$ are universal across both regimes.}
\\label{fig:clustering}
\\end{figure*}
"""

fig2 = """
\\begin{figure*}[!t]
\\centering
\\includegraphics[width=\\textwidth]{fig2_geodesic_axes}
\\caption{Geodesic axis triangles on $S^2$ for three representative manifolds.
Colored arrows show the three holonomy axis directions $\\hat{n}_1, \\hat{n}_2,
\\hat{n}_3$; dashed arcs are the geodesic edges of the spherical triangle.
Left: m003 (compact regime, $\\mathcal{F} = 0.019$);
centre: m015 (extended regime, $\\mathcal{F} = 0.019$);
right: m026 ($H_1 = \\mathbb{Z}/13$, $\\mathcal{F} = 0.020$).}
\\label{fig:geodesic}
\\end{figure*}
"""

fig3 = """
\\begin{figure*}[!t]
\\centering
\\includegraphics[width=0.75\\textwidth]{fig3_floor_vs_volume}
\\caption{PMNS Frobenius fitness $\\mathcal{F}$ versus hyperbolic volume
for the top-20 results. Point color encodes the smallest odd prime $p$
dividing $|H_1(M;\\mathbb{Z})|$. The fitness floor near
$\\mathcal{F} \\approx 0.019$ does not decrease monotonically with volume,
consistent with the floor being set by the real-matrix constraint.}
\\label{fig:floor_volume}
\\end{figure*}
"""

markers = [
    (r'\subsection{Two-regime structure', fig1, 'Fig 1'),
    (r'\subsection{Axis extraction}',     fig2, 'Fig 2'),
    (r'\subsection{Physical interpretation of the two Borel regimes}', fig3, 'Fig 3'),
]

for marker, figblock, name in markers:
    if marker in tex:
        tex = tex.replace(marker, figblock + '\n' + marker, 1)
        print(name + ' inserted')
    else:
        print(name + ' marker NOT FOUND -- showing nearby section headers:')
        for line in tex.split('\n'):
            if 'subsection{' in line or 'section{' in line:
                print('  ' + line[:80])

with open(path, 'w', encoding='utf-8') as f: f.write(tex)
print('Done')
