import time, sys
Mx = load("q001_Mx.sobj")
Mu = load("q001_Mu.sobj")
N = Mx.nrows()
print("N =", N); sys.stdout.flush()

R = PolynomialRing(QQ, 't')
t = R.gen()
q10 = t^10 - 7*t^8 + 4*t^7 + 17*t^6 - 14*t^5 - 18*t^4 + 14*t^3 + 8*t^2 - 3*t - 1

t0 = time.time()
q10_Mx = q10(Mx)
print("q10(Mx) computed in %.2fs" % (time.time()-t0)); sys.stdout.flush()
save(q10_Mx, "q001_q10Mx.sobj")

t1 = time.time()
rk = q10_Mx.rank()
dimB = N - rk
print("rank(q10(Mx)) =", rk, " => dim B = N - rank =", dimB, " (%.2fs)" % (time.time()-t1)); sys.stdout.flush()

# V = im(q10(Mx)): column space
t2 = time.time()
V = q10_Mx.column_space()
print("V = im(q10(Mx)) dimension:", V.dimension(), " (%.2fs)" % (time.time()-t2)); sys.stdout.flush()

# Build a complement W to V in Q^N: extend a basis of V to a basis of Q^N
t3 = time.time()
Vbasis = V.basis()
full = matrix(QQ, Vbasis)  # dim(V) x N
# Use Sage's extend-to-basis: find standard basis vectors not in span, greedily
std = identity_matrix(QQ, N)
Wvecs = []
current = matrix(QQ, Vbasis) if Vbasis else matrix(QQ, 0, N)
for i in range(N):
    cand = std.row(i)
    test = current.stack(matrix(QQ,[cand]))
    if test.rank() > current.nrows():
        current = test
        Wvecs.append(cand)
    if len(Wvecs) == dimB:
        break
print("found", len(Wvecs), "complement vectors (%.2fs)" % (time.time()-t3)); sys.stdout.flush()

Wmat = matrix(QQ, Wvecs)  # dimB x N, rows = complement basis
FullBasis = matrix(QQ, Vbasis + Wvecs)  # N x N, change of basis (V then W)
FullBasisT = FullBasis.transpose()

t4 = time.time()
# For each w in W, compute u*w = Mu*w, then express in FullBasis coords, take the W-part
MuB_cols = []
for w in Wvecs:
    img = Mu*w
    coeffs = FullBasisT.solve_right(img)  # coeffs in terms of (V-basis..., W-basis...)
    w_part = coeffs[V.dimension():]  # the W-coordinates
    MuB_cols.append(w_part)
Mu_B = matrix(QQ, dimB, dimB, lambda i,j: MuB_cols[j][i])
print("Mu_B built, shape", Mu_B.nrows(), "x", Mu_B.ncols(), " (%.2fs)" % (time.time()-t4)); sys.stdout.flush()

print("Mu_B == 0:", Mu_B == 0)
print("rank(Mu_B):", Mu_B.rank())
Mu_B2 = Mu_B*Mu_B
print("Mu_B^2 == 0:", Mu_B2 == 0)
if Mu_B2 != 0:
    print("Mu_B^2 nonzero entries sample, rank(Mu_B^2):", Mu_B2.rank())

save(Mu_B, "q001_MuB.sobj")
print("saved")
