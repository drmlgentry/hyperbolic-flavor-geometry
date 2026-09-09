"""
Stage 3.1 refinement, per review: avoid eigendecomposition entirely.
For non-scalar 2x2 W, the full matrix centralizer is exactly
Z_{M2}(W) = {alpha*I + beta*W : alpha, beta in C} (a 2-complex-
dimensional subspace of M2(C)). G is a genuine ambient conjugator
(G in C0*Z(W)) iff H = C0^-1 G lies EXACTLY in that subspace.

Rather than a raw commutator norm (a valid zero-test but not
intrinsically a normalized distance -- depends on C0's conditioning),
compute the actual least-squares distance from H to span{I, W} in the
Frobenius inner product on M2(C): solve for the best-fit alpha, beta
minimizing ||H - alpha*I - beta*W||_F, and report that residual. This
is a genuine, properly-normalized distance-to-subspace measure, and
also avoids all eigenvector-conditioning issues.

Also corrects a framing error in m003_stage3p1_conjugator_coset.sage:
that script called the two eigenvalue pairings "two conjugator
candidates" -- they are not two components of the conjugator locus.
If C W C^-1 = T, C must send a lambda-eigenvector of W to a
lambda-eigenvector of T; swapping lambda<->lambda^-1 instead gives
C W C^-1 = T^-1 generically, not T. The "invalid pairing" found there
(O(10) residual) is exactly this T^-1 case, confirmed as a sanity
check on the algebra, not a second candidate family.
"""
import snappy
import numpy as np

BITS = 300
M = snappy.Manifold("m003(-2,3)")
rho = M.polished_holonomy(bits_prec=BITS, fundamental_group_args=[True, False, True, False])


def _to_np(m):
    return np.array([[complex(m[0, 0]), complex(m[0, 1])],
                      [complex(m[1, 0]), complex(m[1, 1])]], dtype=complex)


_GEN = {"a": _to_np(rho("a")), "b": _to_np(rho("b"))}
_GEN["A"] = np.linalg.inv(_GEN["a"])
_GEN["B"] = np.linalg.inv(_GEN["b"])


def mat(word):
    Mm = np.eye(2, dtype=complex)
    for c in word:
        Mm = Mm @ _GEN[c]
    return Mm


def inv_word(w):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(w))


def fro_norm(Mm):
    return float(np.sqrt(np.sum(np.abs(Mm) ** 2)))


def build_C0(W, T):
    """The single genuine conjugator (correct eigenvalue-to-eigenvector
    pairing: lambda -> lambda, not lambda -> lambda^-1)."""
    wvals, V = np.linalg.eig(W)
    tvals, U = np.linalg.eig(T)
    # match each eigenvalue of W to the SAME eigenvalue of T (not swapped)
    order = [int(np.argmin(np.abs(tvals - wv))) for wv in wvals]
    U = U[:, order]
    C0 = U @ np.linalg.inv(V)
    C0 = C0 / np.sqrt(np.linalg.det(C0))
    return C0


def dist_to_centralizer_span(H, W):
    """Least-squares Frobenius distance from H to span{I, W} in M2(C)."""
    I2 = np.eye(2, dtype=complex)
    # Frobenius inner product <X,Y> = trace(X^* Y); solve normal equations
    # for alpha, beta minimizing ||H - alpha I - beta W||_F^2
    basis = [I2, W]
    Gmat = np.array([[np.trace(np.conj(bi).T @ bj) for bj in basis] for bi in basis])
    rhs = np.array([np.trace(np.conj(bi).T @ H) for bi in basis])
    coeffs = np.linalg.solve(Gmat, rhs)
    fit = coeffs[0] * I2 + coeffs[1] * W
    return fro_norm(H - fit)


letters = "aAbB"


def freely_reduced_words_upto_length(max_len):
    words = [""]
    frontier = [""]
    for _ in range(max_len):
        new_frontier = []
        for w in frontier:
            last = w[-1] if w else None
            for c in letters:
                if last is not None and c == inv_word(last):
                    continue
                nw = w + c
                new_frontier.append(nw)
                words.append(nw)
        frontier = new_frontier
    return words


MAX_G_LEN = 10
candidates = freely_reduced_words_upto_length(MAX_G_LEN)
print(f"searching {len(candidates)} candidates, distance-to-centralizer-span test", flush=True)

tests = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]

for w, wp in tests:
    print("=" * 70, flush=True)
    print(f"pair (w={w}, w'={wp})", flush=True)
    W = mat(w)
    T = mat(inv_word(wp))

    C0 = build_C0(W, T)
    check = fro_norm(C0 @ W @ np.linalg.inv(C0) - T)
    print(f"  C0 construction check ||C0 W C0^-1 - T||_F = {check:.3e}  (should be ~machine eps)")

    C0inv = np.linalg.inv(C0)
    scored = []
    for g in candidates:
        G = mat(g)
        H = C0inv @ G
        d = dist_to_centralizer_span(H, W)
        scored.append((d, g))
    scored.sort(key=lambda t: t[0])

    print("  top 10 by least-squares distance to centralizer span {I, W}:")
    for d, g in scored[:10]:
        print(f"    g={g!r:14s} |g|={len(g):2d}  distance={d:.6e}")

    best_d, best_g = scored[0]
    print(f"  best: g={best_g!r}  distance={best_d:.6e}")
    print(f"  (0 would mean g is an exact ambient conjugator)")
    print()

print("EXIT=0")
