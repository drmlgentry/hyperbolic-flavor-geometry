path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

old = (
    'm003 (idx~1)  & $\\mathbb{Z}/5$                          & 0.981 & \\textbf{0.01897} & 5 \\\\\\\n'
    'm007 (idx~15) & $\\mathbb{Z}/3 \\oplus \\mathbb{Z}/9$      & 1.583 & 0.01935          & 3 \\\\\\\n'
    'm007 (idx~29) & $\\mathbb{Z}/24$                         & 1.885 & 0.01950          & 3 \\\\\\\n'
    'm010 (idx~47) & $\\mathbb{Z}/2 \\oplus \\mathbb{Z}/6$      & 2.030 & 0.01974          & 3 \\\\\\\n'
    'm023 (idx~41) & $\\mathbb{Z}/3 \\oplus \\mathbb{Z}/3$      & 2.014 & 0.01978          & 3 \\\\\\\n'
    'm016 (idx~28) & $\\mathbb{Z}/39$                         & 1.885 & 0.01981          & 3 \\\\\\\n'
    'm009 (idx~55) & $\\mathbb{Z}/14$                         & 2.063 & 0.01987          & 7 \\\\\\\n'
    'm006 (idx~16) & $\\mathbb{Z}/30$                         & 1.589 & 0.02023          & 3, 5 \\\\\\\n'
    'm004 (idx~11) & $\\mathbb{Z}/5$                          & 1.529 & 0.02100          & 5 \\\\\\\n'
    'm010 (idx~33) & $\\mathbb{Z}/30$                         & 1.911 & 0.02142          & 3, 5 \\\\\\'
)

new = (
    'm003 (idx~1)  & $\\mathbb{Z}/5$                          & 0.981 & \\textbf{0.01897} & 5 \\\\\\\n'
    'm007 (idx~15) & $\\mathbb{Z}/3 \\oplus \\mathbb{Z}/9$      & 1.583 & 0.01935          & 3 \\\\\\\n'
    'm015 (idx~19) & $\\mathbb{Z}/7$                          & 1.757 & 0.01937          & 7 \\\\\\\n'
    'm034 (idx~73) & $\\mathbb{Z}/30$                         & 2.208 & 0.01943          & 3, 5 \\\\\\\n'
    'm007 (idx~29) & $\\mathbb{Z}/24$                         & 1.885 & 0.01950          & 3 \\\\\\\n'
    'm026 (idx~82) & $\\mathbb{Z}/13$                         & 2.273 & 0.01953          & 13 \\\\\\\n'
    'm011 (idx~85) & $\\mathbb{Z}/49$                         & 2.276 & 0.01956          & 7 \\\\\\\n'
    'm010 (idx~47) & $\\mathbb{Z}/2 \\oplus \\mathbb{Z}/6$      & 2.030 & 0.01974          & 3 \\\\\\\n'
    'm023 (idx~41) & $\\mathbb{Z}/3 \\oplus \\mathbb{Z}/3$      & 2.014 & 0.01978          & 3 \\\\\\\n'
    'm016 (idx~28) & $\\mathbb{Z}/39$                         & 1.885 & 0.01981          & 3 \\\\\\'
)

if old in tex:
    tex = tex.replace(old, new)
    with open(path, 'w', encoding='utf-8') as f: f.write(tex)
    print('Table II updated')
else:
    print('Pattern not found -- showing current table rows:')
    i = tex.find('tab:homology_pattern')
    print(repr(tex[i:i+1200]))
