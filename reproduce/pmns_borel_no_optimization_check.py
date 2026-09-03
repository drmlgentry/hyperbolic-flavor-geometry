"""
Test the OTHER PMNS Borel construction found in
hyperbolic-flavor-scan/archive/scans/pmns_borel_scan_v2.py:
L[i,j] = axis_i . axis_j directly (no free-parameter optimization at
all), then QR. Unlike pmns_borel's free Nelder-Mead fit, this
construction has NO tunable slack -- if it still doesn't depend on the
manifold, that's a separate finding; if it DOES depend on the manifold,
it's a structurally different (and non-degenerate) construction that
deserves to be distinguished from the free-optimization one.

Run on m003(-2,3) and several other census manifolds, scanning real
word triples up to length 3 (matching scan_v2's default --max-len 3).
"""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import numpy as np
from scipy.linalg import qr, logm
from itertools import permutations, product as iproduct
import snappy

PMNS_TARGET = np.array([
    [0.821, 0.550, 0.148],
    [0.357, 0.339, 0.871],
    [0.442, 0.762, 0.471],
])
PERMS = list(permutations([0, 1, 2]))


def to_numpy(m):
    return np.array([[complex(m[i, j]) for j in range(2)] for i in range(2)])


def fitness(U):
    best = 1e9
    for perm in PERMS:
        best = min(best, float(np.linalg.norm(U[:, perm] - PMNS_TARGET, 'fro')))
    return best


def axis_from_matrix(M):
    try:
        L = logm(M)
    except Exception:
        return None
    nx = (L[0, 1].real + L[1, 0].real) / 2
    ny = (L[1, 0].imag - L[0, 1].imag) / 2
    nz = (L[0, 0].real - L[1, 1].real) / 2
    n = np.array([nx, ny, nz])
    nm = np.linalg.norm(n)
    return n / nm if nm > 1e-10 else None


def borel_to_unitary(n1, n2, n3, scale=1.0):
    axes = [n1, n2, n3]
    L = np.zeros((3, 3))
    for i in range(3):
        for j in range(i + 1):
            L[i, j] = np.dot(axes[i], axes[j])
    L = L * scale
    if abs(np.linalg.det(L)) < 1e-10:
        return None
    Q, R = qr(L.T)
    signs = np.diag(np.sign(np.diag(R)))
    U = Q @ signs
    return np.abs(U)


def scan(name, max_len=3):
    M = snappy.Manifold(name)
    G = M.fundamental_group()
    base_gens = [g for g in G.generators() if g.islower()]
    all_gens = base_gens + [g.upper() for g in base_gens]
    inv = {g: g.upper() if g.islower() else g.lower() for g in all_gens}
    words = []
    for length in range(1, max_len + 1):
        for w in iproduct(all_gens, repeat=length):
            ok = all(w[i] != inv.get(w[i + 1], "___") for i in range(len(w) - 1))
            if ok:
                words.append("".join(w))

    axes = {}
    for w in words:
        try:
            m = to_numpy(G.SL2C(w))
            n = axis_from_matrix(m)
            if n is not None:
                axes[w] = n
        except Exception:
            pass

    word_list = list(axes.keys())
    best_f = 1e9
    best_triple = None
    best_f_distinct_axes = 1e9
    best_triple_distinct_axes = None
    for w1 in word_list:
        for w2 in word_list:
            for w3 in word_list:
                n1, n2, n3 = axes[w1], axes[w2], axes[w3]
                U = borel_to_unitary(n1, n2, n3)
                if U is None:
                    continue
                f = fitness(U)
                if f < best_f:
                    best_f = f
                    best_triple = (w1, w2, w3)
                # also track best among GENUINELY distinct axis directions
                # (excludes w1=w2=w3 and any pair sharing an axis, which
                # trivially gives a manifold-independent all-ones L)
                d12 = abs(np.dot(n1, n2))
                d13 = abs(np.dot(n1, n3))
                d23 = abs(np.dot(n2, n3))
                if d12 < 0.9999 and d13 < 0.9999 and d23 < 0.9999:
                    if f < best_f_distinct_axes:
                        best_f_distinct_axes = f
                        best_triple_distinct_axes = (w1, w2, w3)
    return (best_f, best_triple, best_f_distinct_axes,
            best_triple_distinct_axes, len(word_list))


for name in ["m003(-2,3)", "m004(5,2)", "m006(-5,2)", "m038(3,2)"]:
    best_f, triple, best_fd, triple_d, nwords = scan(name, max_len=3)
    print(f"{name:15s}  nwords={nwords:4d}  "
          f"best_fitness(any)={best_f:.5f} triple={triple}   "
          f"best_fitness(distinct axes)={best_fd:.5f} triple={triple_d}")

print("EXIT=0")
