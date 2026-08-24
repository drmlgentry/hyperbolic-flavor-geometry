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

t1 = time.time()
ker = q10_Mx.right_kernel()
print("ker(q10(Mx)) dimension:", ker.dimension(), " (%.2fs)" % (time.time()-t1)); sys.stdout.flush()

# B = A / im(q10(Mx)) has dimension N - rank(q10(Mx))
rk = q10_Mx.rank()
print("rank(q10(Mx)) =", rk, " => dim B = N - rank =", N-rk); sys.stdout.flush()

# Restrict Mu to the kernel of q10(Mx): does the kernel decompose Mu invariantly?
t2 = time.time()
Kbasis = ker.basis_matrix()   # rows span the kernel
print("kernel basis matrix shape:", Kbasis.nrows(), "x", Kbasis.ncols()); sys.stdout.flush()

# Check Mu preserves the kernel (Mu * v in ker for v in ker) -- needed for a valid restriction
images = [Mu*v for v in Kbasis.rows()]
preserves = all(q10_Mx*img == 0 for img in images)
print("Mu preserves ker(q10(Mx)):", preserves, " (%.2fs)" % (time.time()-t2)); sys.stdout.flush()

if preserves:
    # Express Mu restricted to the kernel in the kernel's own basis
    # Solve images[i] = sum_j c_ij * Kbasis.row(j)
    Kmat = Kbasis.transpose()  # columns = basis vectors, N x dim(ker)
    Mu_restricted_cols = []
    for img in images:
        sol = Kmat.solve_right(img)
        Mu_restricted_cols.append(sol)
    Mu_B = matrix(QQ, ker.dimension(), ker.dimension(), lambda i,j: Mu_restricted_cols[j][i])
    print("Mu restricted to ker(q10(Mx)) built, shape:", Mu_B.nrows(), "x", Mu_B.ncols()); sys.stdout.flush()
    print("Mu_B == 0:", Mu_B == 0)
    print("rank(Mu_B):", Mu_B.rank())
    print("Mu_B^2 == 0:", (Mu_B*Mu_B) == 0)
    save(Mu_B, "q001_MuB.sobj")
else:
    print("Kernel is NOT Mu-invariant -- need the full B=A/im(q10(Mx)) quotient action instead, not just the kernel.")
