import json, time, sys
with open("q001_modstd_gb_cache.json") as f:
    data = json.load(f)
gb_strings = data["gb_strings"]

R.<x,y,z> = PolynomialRing(QQ, order="degrevlex")
gens = [R(s) for s in gb_strings]
I = R.ideal(gens)
GB = I.groebner_basis()
print("GB recomputed, size", len(GB)); sys.stdout.flush()

sb = I.normal_basis()
N = len(sb)
print("N =", N); sys.stdout.flush()
index = {m.exponents()[0]: i for i,m in enumerate(sb)}

def coords(f):
    r = f.reduce(GB)
    v = vector(QQ, N)
    for mono, coeff in r.dict().items():
        v[index[mono]] = coeff
    return v

t0=time.time()
Mx = matrix(QQ, N, N)
for j in range(N):
    Mx.set_column(j, coords(x*sb[j]))
    if j % 50 == 0:
        print("  col", j, "done, elapsed %.1fs" % (time.time()-t0)); sys.stdout.flush()
print("Mx built in %.2fs" % (time.time()-t0)); sys.stdout.flush()

save(Mx, "q001_Mx.sobj")
save(sb, "q001_sb.sobj")
save(GB, "q001_GB.sobj")
print("Mx, sb, GB saved"); sys.stdout.flush()
