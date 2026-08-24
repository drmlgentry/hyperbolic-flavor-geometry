import json, time, sys
with open("q001_modstd_gb_cache.json") as f:
    data = json.load(f)
gb_strings = data["gb_strings"]

R.<x,y,z> = PolynomialRing(QQ, order="degrevlex")
G = [R(s) for s in gb_strings]
I = R.ideal(G)
print("I loaded, GB size", len(G)); sys.stdout.flush()

q10 = x^10 - 7*x^8 + 4*x^7 + 17*x^6 - 14*x^5 - 18*x^4 + 14*x^3 + 8*x^2 - 3*x - 1
J = I + R.ideal(q10)
print("J formed, computing Groebner basis of J..."); sys.stdout.flush()

t0 = time.time()
GJ = J.groebner_basis()
print("GJ computed in %.2fs, size=%d" % (time.time()-t0, len(GJ))); sys.stdout.flush()

t1 = time.time()
dimJ = len(J.normal_basis())
print("dim_Q(R/J) = %d  (%.2fs)" % (dimJ, time.time()-t1)); sys.stdout.flush()

t2 = time.time()
r1 = (z - x).reduce(GJ)
print("reduce(z-x) computed in %.2fs" % (time.time()-t2)); sys.stdout.flush()
print("J.reduce(z-x) =", r1); sys.stdout.flush()

t3 = time.time()
r2 = ((z - x)^2).reduce(GJ)
print("reduce((z-x)^2) computed in %.2fs" % (time.time()-t3)); sys.stdout.flush()
print("J.reduce((z-x)^2) =", r2); sys.stdout.flush()

print("\n=== SUMMARY ===")
print("dim_Q(R/J) =", dimJ, " (expected 20)")
print("z-x mod J =", r1, " (expected nonzero)")
print("(z-x)^2 mod J =", r2, " (expected 0)")

save(GJ, "q001_GJ.sobj")
save((r1,r2,dimJ), "q001_final_test.sobj")
print("saved")
