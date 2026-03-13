path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'

# Read and strip BOM
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

# 1. Abstract: add parenthetical on lower-triangular / upper unipotent
old_abs = 'the lower-triangular factor of the Iwasawa decomposition'
new_abs = 'the lower-triangular (Borel) factor of the Iwasawa decomposition, equivalently the transpose of the upper unipotent subgroup,'
if old_abs in tex:
    tex = tex.replace(old_abs, new_abs)
    print('Abstract updated')
else:
    print('Abstract pattern not found -- skipping')

# 2. Conclusion: add A-factor next-steps sentence before \end{enumerate}
old_conc = ('\\item The CKM and PMNS constructions are unified by the Iwasawa\n'
            'decomposition $\\PSL = KAN$, with $K \\to$ CKM and $N \\to$ PMNS,\n'
            'leaving the $A$-factor as a candidate for CP phases and mass ratios.\n'
            '\\end{enumerate}')
new_conc = ('\\item The CKM and PMNS constructions are unified by the Iwasawa\n'
            'decomposition $\\PSL = KAN$, with $K \\to$ CKM and $N \\to$ PMNS,\n'
            'leaving the $A$-factor as a candidate for CP phases and mass ratios.\n'
            '\\end{enumerate}\n\n'
            'Incorporating the $A$-factor of the Iwasawa decomposition---via\n'
            'the twist angles $\\phi(\\gamma)$ of loxodromic holonomy elements---to\n'
            'address CP violation and fermion mass ratios is the immediate next step.')
if old_conc in tex:
    tex = tex.replace(old_conc, new_conc)
    print('Conclusion updated')
else:
    print('Conclusion pattern not found -- skipping')

# Write without BOM
with open(path, 'w', encoding='utf-8') as f: f.write(tex)
print('File written (UTF-8, no BOM)')
