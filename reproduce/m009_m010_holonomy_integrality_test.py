import snappy
from sage.all import CC, algdep

for name in ['m009', 'm010']:
    M = snappy.Manifold(name)
    G = M.polished_holonomy(bits_prec=200)
    gen_names = G.generators()
    print(f"\n=== {name} ===  generators: {gen_names}")
    mats = {g: G.SL2C(g) for g in gen_names}
    for g, m in mats.items():
        print(f"\n  generator {g}:")
        print(f"  {m}")
        for i in range(2):
            for j in range(2):
                entry = m[i, j]
                cc_entry = CC(entry)
                dep = algdep(cc_entry, 4)
                print(f"    [{i},{j}] = {cc_entry}")
                print(f"      algdep(., 4) = {dep}")
