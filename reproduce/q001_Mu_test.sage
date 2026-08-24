import time, sys
Mx = load("q001_Mx.sobj")
sb = load("q001_sb.sobj")
GB = load("q001_GB.sobj")
N = len(sb)
print("loaded Mx, sb (N=%d), GB (size %d)" % (N, len(GB))); sys.stdout.flush()

R = GB[0].parent()
x, y, z = R.gens()

index = {m.exponents()[0]: i for i,m in enumerate(sb)}

def coords(f):
    r = f.reduce(GB)
    v = vector(QQ, N)
    for mono, coeff in r.dict().items():
        v[index[mono]] = coeff
    return v

t0=time.time()
Mz = matrix(QQ, N, N)
for j in range(N):
    Mz.set_column(j, coords(z*sb[j]))
    if j % 50 == 0:
        print("  col", j, "done, elapsed %.1fs" % (time.time()-t0)); sys.stdout.flush()
print("Mz built in %.2fs" % (time.time()-t0)); sys.stdout.flush()
save(Mz, "q001_Mz.sobj")

t1=time.time()
Mu = Mz - Mx
print("Mu formed in %.2fs" % (time.time()-t1)); sys.stdout.flush()

t2=time.time()
Mu_is_zero = (Mu == 0)
print("Mu == 0:", Mu_is_zero, " (%.2fs)" % (time.time()-t2)); sys.stdout.flush()

t3=time.time()
r = Mu.rank()
print("rank(Mu) =", r, " (%.2fs)" % (time.time()-t3)); sys.stdout.flush()

t4=time.time()
Mu2 = Mu*Mu
Mu2_is_zero = (Mu2 == 0)
print("Mu^2 == 0:", Mu2_is_zero, " (%.2fs)" % (time.time()-t4)); sys.stdout.flush()

print("\n=== SUMMARY ===")
print("Mu == 0:", Mu_is_zero)
print("rank(Mu):", r)
print("Mu^2 == 0:", Mu2_is_zero)

save(Mu, "q001_Mu.sobj")
print("saved")
