import json, time, sys
with open("q001_modstd_gb_cache.json") as f:
    data = json.load(f)
gb_strings = data["gb_strings"]

R.<x,y,z> = PolynomialRing(QQ, order="degrevlex")
G = [R(s) for s in gb_strings]
I = R.ideal(G)
print("I loaded, GB size", len(G)); sys.stdout.flush()

q10 = x^10 - 7*x^8 + 4*x^7 + 17*x^6 - 14*x^5 - 18*x^4 + 14*x^3 + 8*x^2 - 3*x - 1
print("q10 =", q10); sys.stdout.flush()

t0 = time.time()
J = I + R.ideal(q10)
print("J formed, computing Groebner basis..."); sys.stdout.flush()
GJ = J.groebner_basis()
print("GJ computed in %.2fs, size=%d" % (time.time()-t0, len(GJ))); sys.stdout.flush()

t1 = time.time()
test = (z - x).reduce(GJ)
print("reduce time %.2fs" % (time.time()-t1)); sys.stdout.flush()
print("(z-x) reduces to:", test)

if test == 0:
    print("RESULT: PROVED -- z=x on the geometric component (mod J)")
else:
    print("RESULT: z-x does NOT reduce to 0")
    print("degree in x:", test.degree(x) if test != 0 else None)
    print("degree in y:", test.degree(y) if test != 0 else None)
    print("degree in z:", test.degree(z) if test != 0 else None)

save(GJ, "q001_GJ.sobj")
save(test, "q001_zx_test_result.sobj")
print("saved GJ and test result")
