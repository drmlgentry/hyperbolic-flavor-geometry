"""
Diagnostic check on the "flat top-10 residual" observation from
m003_stage3_conjugacy_search_v2.sage: is it a real geometric fact, or
a search/representation artifact (duplicate matrices, rounding)?

Three checks:
1. Full-precision residuals for the top 10 (not 6-decimal-rounded) --
   are they really tied, or does print precision hide real ordering?
2. Deduplicate the top 10 candidates by their actual rho(g) matrix
   (fingerprint on real/imag parts to ~50 significant digits) -- how
   many DISTINCT matrices actually occur?
3. Control distribution: residuals for 3000 random freely-reduced
   words of length 8-10, for comparison (median, min) against the
   best found (~3.2-4.6).
"""
import snappy
import numpy as np
import random
import json

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


def fingerprint(Mm, digits=12):
    # round to `digits` significant decimal digits on each entry's re/im
    def r(x):
        return complex(round(x.real, digits), round(x.imag, digits))
    return tuple(r(Mm[i, j]) for i in range(2) for j in range(2))


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


tests = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]

print("=" * 78)
print("CHECK 1 & 2: full-precision residuals + matrix dedup for top-10")
print("=" * 78)

MAX_G_LEN = 10
candidates = freely_reduced_words_upto_length(MAX_G_LEN)
print(f"({len(candidates)} candidates)")

for w, wp in tests:
    print(f"\npair ({w}, {wp}):")
    Mw = mat(w)
    Mwp_inv = mat(inv_word(wp))
    scored = []
    for g in candidates:
        Mg = mat(g)
        Mg_inv = np.linalg.inv(Mg)
        lhs = Mg @ Mw @ Mg_inv
        err = fro_norm(lhs - Mwp_inv)
        scored.append((err, g, lhs))
    scored.sort(key=lambda t: t[0])

    print("  top 10, FULL precision residual:")
    fps = set()
    for err, g, lhs in scored[:10]:
        fp = fingerprint(lhs, digits=10)
        fps.add(fp)
        print(f"    g={g!r:14s} residual={err!r}")
    print(f"  distinct rho(g.w.g^-1) matrices among top 10 (10-digit fingerprint): {len(fps)}")

print()
print("=" * 78)
print("CHECK 3: control distribution -- random freely-reduced words, length 8-10")
print("=" * 78)

random.seed(0)


def random_freely_reduced_word(length):
    w = ""
    last = None
    for _ in range(length):
        choices = [c for c in letters if last is None or c != inv_word(last)]
        c = random.choice(choices)
        w += c
        last = c
    return w


N_RANDOM = 3000
for w, wp in tests:
    Mw = mat(w)
    Mwp_inv = mat(inv_word(wp))
    residuals = []
    for _ in range(N_RANDOM):
        length = random.randint(8, 10)
        g = random_freely_reduced_word(length)
        Mg = mat(g)
        Mg_inv = np.linalg.inv(Mg)
        lhs = Mg @ Mw @ Mg_inv
        residuals.append(fro_norm(lhs - Mwp_inv))
    residuals.sort()
    print(f"pair ({w},{wp}): random control (n={N_RANDOM}, length 8-10): "
          f"min={residuals[0]:.6f}  median={residuals[N_RANDOM//2]:.6f}  max={residuals[-1]:.6f}")

print()
print("EXIT=0")
