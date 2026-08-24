import time, sys
Mx = load("q001_Mx.sobj")
print("Mx loaded:", Mx.nrows(), "x", Mx.ncols()); sys.stdout.flush()

t0=time.time()
px = Mx.minimal_polynomial()
print("minpoly degree:", px.degree(), " (%.2fs)" % (time.time()-t0)); sys.stdout.flush()
print("minpoly:", px); sys.stdout.flush()

t1=time.time()
fac = px.factor()
print("factorization time %.2fs" % (time.time()-t1)); sys.stdout.flush()
facs = list(fac)
print("num irreducible factors:", len(facs)); sys.stdout.flush()
for q,e in facs:
    print("  deg", q.degree(), "mult", e, ":", q); sys.stdout.flush()

save(px, "q001_px.sobj")
save(facs, "q001_px_factors.sobj")
print("px and factors saved")
