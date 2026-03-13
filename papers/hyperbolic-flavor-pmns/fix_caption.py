path = r'C:\dev\framework\papers\hyperbolic-flavor-pmns\gentry-hyperbolic-flavor-pmns.tex'
with open(path, 'r', encoding='utf-8-sig') as f: tex = f.read()

# Find and show the fig2 caption to diagnose
i = tex.find('fig2_geodesic_axes')
print(repr(tex[i:i+400]))
