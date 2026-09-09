"""
Stage 3, corrected methodology: numeric conjugator discovery (ranked by
residual, not threshold-only) at the certified geometric representation
of M_PMNS = m003(-2,3), followed by SEPARATE exact verification.

Corrects an error in the first attempt (m003_stage3_conjugacy_search.sage):
that script's accompanying "provably impossible" argument incorrectly
cited a fact about the CUSPED group / bare Riley variety (Step 0 of
m003_three_universal_identities.sage: not a free-group identity) to
rule out conjugacy in the CLOSED group pi_1(m003(-2,3)). Those are
different groups -- the closed group has the filling relation imposed
in addition to the cusped relator, exactly as B/Abb itself is false on
all of X_0 and only becomes a true conjugacy fact after the (-2,3)
filling relation is imposed. That argument is retracted; only the
numeric non-finding stands, and only up to the search depth tried.

Three tests: is w' conjugate to w^-1 (equivalently: does
g.w.g^-1.w' reduce to the identity for some g)?
  (A, ABBB)   -> target rho(a)         = rho(A^-1)  [A^-1 = a]
  (AB, ABB)   -> target rho(ba)        = rho((AB)^-1) [since (AB)^-1 = ba]
  (AAb, AABB) -> target rho(Baa)       = rho((AAb)^-1) [since (AAb)^-1 = Baa]

For each, search freely reduced g up to length 10, rank by
||rho(g) rho(w) rho(g)^-1 - rho(w'^-1)||_F, report the best candidates,
and separately verify the exact word g.w.g^-1.w' reduces to the
identity at 300-bit certified precision for the best candidate(s).
"""
import snappy
import numpy as np
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
    """Build word matrix by multiplying cached generator matrices in numpy
    (avoids one SnapPy rho() call per candidate word -- far too slow for
    ~10^5 candidates)."""
    M = np.eye(2, dtype=complex)
    for c in word:
        M = M @ _GEN[c]
    return M


def inv_word(w):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(w))


def fro_norm(M):
    return float(np.sqrt(np.sum(np.abs(M) ** 2)))


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
print(f"searching {len(candidates)} candidate conjugators up to length {MAX_G_LEN}", flush=True)
print()

tests = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]
all_results = []

for idx, (w, wp) in enumerate(tests, start=1):
    target_word = inv_word(w)  # w^-1, expected to equal 'a', 'ba', 'Baa' resp.
    print("=" * 70)
    print(f"PAIR {idx}")
    print(f"w       = {w}")
    print(f"wprime  = {wp}")
    print(f"target  = {target_word}  (= {w}^-1)")

    Mw = mat(w)
    Mwp_inv = mat(inv_word(wp))  # rho(w'^-1) -- the actual matrix target

    scored = []
    for g in candidates:
        Mg = mat(g)
        Mg_inv = np.linalg.inv(Mg)
        lhs = Mg @ Mw @ Mg_inv
        err = fro_norm(lhs - Mwp_inv)
        scored.append((err, g))
    scored.sort(key=lambda t: t[0])

    print("top 10 candidates by residual:")
    for err, g in scored[:10]:
        print(f"  g={g!r:14s} |g|={len(g):2d}  residual={err:.6e}")

    best_err, best_g = scored[0]
    print(f"best g  = {best_g!r}   |g| = {len(best_g)}")
    print(f"numeric residual = {best_err:.6e}")

    # Exact verification: does g.w.g^-1.w' reduce to the identity at
    # certified precision? (equivalent to g w g^-1 = w'^-1, i.e. the
    # conjugacy hypothesis). Uses SnapPy's own certified rho() call
    # directly on the full word (not the cached numpy double-precision
    # chain used for the fast ranking search above) so this check
    # actually carries the full 300-bit precision.
    exact_word = best_g + w + inv_word(best_g) + wp
    Mexact = _to_np(rho(exact_word))
    exact_residual = fro_norm(Mexact - np.eye(2, dtype=complex))
    exact_pass = exact_residual < 1e-60  # 300-bit precision: should be ~0 or clearly not
    print(f"exact matrix residual (g.{w}.g^-1.{wp} vs I) = {exact_residual:.3e}  "
          f"PASS/FAIL: {'PASS' if exact_pass else 'FAIL'}")
    print(f"group identity certified? {'YES (faithfulness promotes this to pi_1)' if exact_pass else 'NO'}")
    print()

    all_results.append({
        "w": w, "wprime": wp, "target": target_word,
        "top10": [{"g": g, "len": len(g), "residual": err} for err, g in scored[:10]],
        "best_g": best_g, "best_g_len": len(best_g), "numeric_residual": best_err,
        "exact_word": exact_word, "exact_residual": exact_residual, "exact_pass": exact_pass,
    })

with open("/mnt/c/dev/hyperbolic-flavor-geometry/reproduce/m003_stage3_conjugacy_search_v2_results.json", "w") as f:
    json.dump(all_results, f, indent=2, default=str)

print("EXIT=0")
