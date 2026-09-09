"""
Stage 3.1: recast the bounded conjugacy search geometrically, as
proposed. For loxodromic W=rho(w), T=rho(w'^-1) with equal trace
(established in stage 2), the set of ambient SL2(C) conjugators
{C : C W C^-1 = T} is a coset C_0 * Z(W), where Z(W) is the
1-complex-dimensional centralizer of W. There are exactly two such
cosets in general (one per matching of W's two eigenvalues to T's two
eigenvalues -- both {lambda, lambda^-1} for both, since traces match).

Rather than measure ||rho(g) - C_0|| at one fixed point in the coset
(the earlier, cruder test), test coset MEMBERSHIP directly: g is a
valid conjugator iff C_0^-1 . rho(g) commutes with W, i.e.
[C_0^-1 rho(g), W] = 0. Rank candidates by this commutator norm
(minimized over the two discrete eigenvalue-pairing choices), which
correctly accounts for the continuous freedom in choosing WHICH
element of the centralizer coset to compare against -- the earlier
Frobenius-distance-to-one-point test conflated "wrong t" with "not in
the coset at all".
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


def eig_decomp(Mm):
    """Return (V, eigvals) with Mm = V diag(eigvals) V^-1."""
    vals, vecs = np.linalg.eig(Mm)
    return vecs, vals


def build_C0(W, T, pairing):
    """
    C0 with C0 W C0^-1 = T, using the given eigenvalue pairing
    (0 = match eigvec order as-is, 1 = swap T's eigenvector columns).
    Normalized to det(C0) = 1 (up to a remaining sign, irrelevant for
    the commutator test below).
    """
    V, wv = eig_decomp(W)
    U, tv = eig_decomp(T)
    if pairing == 1:
        U = U[:, [1, 0]]
        tv = tv[[1, 0]]
    C0 = U @ np.linalg.inv(V)
    d = np.linalg.det(C0)
    C0 = C0 / np.sqrt(d)
    return C0


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
print(f"searching {len(candidates)} candidates, coset-membership test", flush=True)

tests = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]

for w, wp in tests:
    print("=" * 70, flush=True)
    print(f"pair (w={w}, w'={wp})", flush=True)
    W = mat(w)
    T = mat(inv_word(wp))  # T = rho(w'^-1)

    # sanity: confirm W, T really have matching eigenvalues (trace-equal, stage 2)
    wv = np.linalg.eigvals(W)
    tv = np.linalg.eigvals(T)
    print(f"  eigenvalues of rho({w}): {sorted(wv, key=lambda z: z.real)}")
    print(f"  eigenvalues of rho({inv_word(wp)}): {sorted(tv, key=lambda z: z.real)}")

    C0_candidates = [build_C0(W, T, pairing) for pairing in (0, 1)]
    # verify each C0 actually conjugates W to T (sanity on the construction itself)
    for i, C0 in enumerate(C0_candidates):
        check = fro_norm(C0 @ W @ np.linalg.inv(C0) - T)
        print(f"  C0 (pairing {i}) construction check ||C0 W C0^-1 - T||_F = {check:.3e}")

    best_overall = None
    scored = []
    for g in candidates:
        Mg = mat(g)
        best_for_g = min(
            fro_norm(np.linalg.inv(C0) @ Mg @ W - W @ np.linalg.inv(C0) @ Mg)
            for C0 in C0_candidates
        )
        scored.append((best_for_g, g))
    scored.sort(key=lambda t: t[0])

    print("  top 10 candidates by COMMUTATOR norm ||[C0^-1.rho(g), W]||_F "
          "(true coset-membership distance):")
    for err, g in scored[:10]:
        print(f"    g={g!r:14s} |g|={len(g):2d}  commutator_norm={err:.6e}")

    best_err, best_g = scored[0]
    print(f"  best: g={best_g!r}  commutator_norm={best_err:.6e}")
    print(f"  (0 would mean g is an exact ambient conjugator, i.e. genuine coset membership)")
    print()

print("EXIT=0")
