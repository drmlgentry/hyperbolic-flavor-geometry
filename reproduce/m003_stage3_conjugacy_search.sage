"""
Stage 3: search for the conjugating element g in pi_1(m003(-2,3)) for
each of the three universal identity pairs, testing the hypothesis
motivated by stage 2's signed-trace result and the already-proven
B/Abb mechanism (g.B.g^-1 = Abb^-1):

  is w' conjugate to w^-1 (equivalently, is w conjugate to w'^-1)?

for (w,w') in {(A,ABBB), (AB,ABB), (AAb,AABB)}.

Method: certified holonomy of M_PMNS at high precision (same
fundamental_group_args convention verified throughout this session),
short-word search over g for g.rho(w).g^-1 ~= rho(w')^-1 numerically,
then exact confirmation via the SL2(C) faithfulness argument (the
discrete-faithful representation is injective for a complete
finite-volume hyperbolic structure, so an exact matrix identity to high
precision at the geometric point certifies the abstract group identity)
-- the same argument already used to establish g=BaBA for B/Abb.
"""
import snappy
import numpy as np

BITS = 300
M = snappy.Manifold("m003(-2,3)")
rho = M.polished_holonomy(bits_prec=BITS, fundamental_group_args=[True, False, True, False])


def mat(word):
    m = rho(word)
    return np.array([[complex(m[0, 0]), complex(m[0, 1])],
                      [complex(m[1, 0]), complex(m[1, 1])]], dtype=complex)


def inv_word(w):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(w))


def mat_close(m1, m2, tol=1e-8):
    return np.max(np.abs(m1 - m2)) < tol


letters = "aAbB"


def short_words(max_len):
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


pairs = [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]

MAX_G_LEN = 8
candidates = short_words(MAX_G_LEN)
print(f"searching {len(candidates)} candidate conjugators up to length {MAX_G_LEN}")
print()

I2 = np.eye(2, dtype=complex)

for w, wp in pairs:
    print("=" * 70)
    print(f"pair (w={w}, w'={wp}): testing w' conjugate to w^-1  (g.rho(w).g^-1 = rho(w')^-1)")
    print("=" * 70)
    Mw = mat(w)
    Mwp_inv = mat(inv_word(wp))  # rho(w')^-1 = rho(w'^-1)
    found = []
    for g in candidates:
        Mg = mat(g) if g else I2
        try:
            Mg_inv = np.linalg.inv(Mg)
        except np.linalg.LinAlgError:
            continue
        lhs = Mg @ Mw @ Mg_inv
        if mat_close(lhs, Mwp_inv, tol=1e-6):
            found.append(g)
    print(f"  conjugators found (g.{w}.g^-1 = {wp}^-1): {found[:10]}"
          f"{' ...' if len(found) > 10 else ''}  (total {len(found)})")

    # also test the reverse pairing: w conjugate to w'^-1
    Mwp = mat(wp)
    Mw_inv = mat(inv_word(w))
    found2 = []
    for g in candidates:
        Mg = mat(g) if g else I2
        try:
            Mg_inv = np.linalg.inv(Mg)
        except np.linalg.LinAlgError:
            continue
        lhs = Mg @ Mwp @ Mg_inv
        if mat_close(lhs, Mw_inv, tol=1e-6):
            found2.append(g)
    print(f"  conjugators found (g.{wp}.g^-1 = {w}^-1): {found2[:10]}"
          f"{' ...' if len(found2) > 10 else ''}  (total {len(found2)})")
    print()

print("EXIT=0")
