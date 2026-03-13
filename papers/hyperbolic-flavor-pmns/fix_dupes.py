path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

for label in ['fig:clustering', 'fig:geodesic', 'fig:floor_volume']:
    marker = '\\label{' + label + '}'
    count = tex.count(marker)
    print(label + ': ' + str(count) + ' occurrences')

# For each figure environment, keep only the first occurrence
import re
for figname in ['fig1_l_clustering', 'fig2_geodesic_axes', 'fig3_floor_vs_volume']:
    pattern = re.compile(
        r'\\begin\{figure\*\}.*?\\includegraphics[^}]*' + figname + r'.*?\\end\{figure\*\}',
        re.DOTALL)
    matches = list(pattern.finditer(tex))
    print(figname + ': ' + str(len(matches)) + ' figure environments found')
    if len(matches) > 1:
        # Remove all but the first
        for m in reversed(matches[1:]):
            tex = tex[:m.start()] + tex[m.end():]
        print('  -> duplicates removed')

with open(path, 'w', encoding='utf-8') as f: f.write(tex)
print('Done')
