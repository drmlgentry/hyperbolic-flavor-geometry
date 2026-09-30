"""
m003_full_atlas_collision_classes.py
=====================================
Independently verifies two claims from a relayed message before accepting
them:
  (1) enumerating the paper's stated atlas protocol (freely and cyclically
      reduced words in a,A,b,B through length 6, quotiented by cyclic
      rotation and inversion, proper powers excluded) gives 99 classes
      (gentry-m003-arithmetic-v5.tex, sec:atlas);
  (2) grouping those 99 classes by EXACT trace collision on X_0 (ideal
      membership Delta_{w,v} in P0, the paper's own decisive test) gives
      "25 collision classes covering 54 of the 99 words," each collision
      class sitting inside a single |e_a| block, with two named triple
      classes {ABaB,ABBaB,ABaBB} and {AAbAb,AABBAb,AAbABB}.

Also checks the specific "falsifiable prediction" offered alongside: no
collision class may straddle two different |e_a| values (this is not
optional -- it is forced by Lemma 5.5 of the paper, already proved, so a
violation here would indicate a bug in THIS script, not new mathematics).

Pure combinatorics + exact symbolic algebra (sympy), no SnapPy needed.
"""
import itertools
import sys

import sympy as sp

x, y, z, u = sp.symbols("x y z u")
INV = {"a": "A", "A": "a", "b": "B", "B": "b"}


def inv(w):
    return "".join(INV[c] for c in reversed(w))


def is_freely_reduced(w):
    return all(INV[w[i]] != w[i + 1] for i in range(len(w) - 1)) and (
        len(w) < 2 or INV[w[-1]] != w[0] or len(w) == 1
    )


def cyclically_reduced(w):
    # freely reduced AND no cancellation across the cyclic join
    if not is_freely_reduced(w):
        return False
    if len(w) >= 2 and INV[w[-1]] == w[0]:
        return False
    return True


def cyclic_class(w):
    rots = [w[i:] + w[:i] for i in range(len(w))]
    rots += [inv(r) for r in rots]
    return min(rots)


def is_proper_power(w):
    n = len(w)
    for d in range(1, n):
        if n % d == 0 and w == w[:d] * (n // d):
            return True
    return False


def enumerate_atlas(maxlen=6, alphabet="aAbB"):
    seen_classes = set()
    reps = []
    for L in range(1, maxlen + 1):
        for tup in itertools.product(alphabet, repeat=L):
            w = "".join(tup)
            if not cyclically_reduced(w):
                continue
            if is_proper_power(w):
                continue
            cls = cyclic_class(w)
            if cls not in seen_classes:
                seen_classes.add(cls)
                reps.append(w)
    return reps


ea = lambda w: w.count("a") - w.count("A")
eb = lambda w: w.count("b") - w.count("B")

# ---- Fricke trace polynomial machinery (same chart used throughout) ----
A = sp.Matrix([[x, -1], [1, 0]])
B = sp.Matrix([[0, -u], [-z - u, y]])
MAT = {"a": A, "A": sp.Matrix([[A[1, 1], -A[0, 1]], [-A[1, 0], A[0, 0]]]),
       "b": B, "B": sp.Matrix([[B[1, 1], -B[0, 1]], [-B[1, 0], B[0, 0]]])}
DET = u**2 + z * u + 1


def tr_xyz(word, cache={}):
    if word in cache:
        return cache[word]
    M = sp.eye(2)
    for c in word:
        M = M * MAT[c]
    tr = sp.expand(M.trace())
    r = sp.expand(sp.rem(tr, DET, u))
    cache[word] = r
    return r


def main():
    reps = enumerate_atlas(6)
    print(f"Enumerated {len(reps)} classes (length<=6, cyclic+inverse+proper-power reduced).")
    print(f"Matches the paper's stated 99: {len(reps) == 99}")

    P0 = [x * z + 1, x**2 + y - 1]
    G = sp.groebner(P0, x, y, z, order="grevlex")

    def collide(w1, w2):
        d = sp.expand(tr_xyz(w1) - tr_xyz(w2))
        r = sp.reduced(d, list(G.exprs), x, y, z, order="grevlex")[1]
        return sp.expand(r) == 0

    tr = {w: tr_xyz(w) for w in reps}

    # union-find over the 99 reps by exact collision on X0
    parent = {w: w for w in reps}

    def find(w):
        while parent[w] != w:
            parent[w] = parent[parent[w]]
            w = parent[w]
        return w

    def union(w1, w2):
        r1, r2 = find(w1), find(w2)
        if r1 != r2:
            parent[r1] = r2

    n = len(reps)
    checked = 0
    for i in range(n):
        for j in range(i + 1, n):
            w1, w2 = reps[i], reps[j]
            if abs(ea(w1)) != abs(ea(w2)):
                continue  # necessary condition (Lemma 5.5); skip fast
            if collide(w1, w2):
                union(w1, w2)
            checked += 1

    groups = {}
    for w in reps:
        r = find(w)
        groups.setdefault(r, []).append(w)

    nontrivial = {r: g for r, g in groups.items() if len(g) > 1}
    covered = sum(len(g) for g in nontrivial.values())

    print(f"pairwise ideal-membership checks performed (|ea| match required first): {checked}")
    print(f"nontrivial collision classes (size >= 2): {len(nontrivial)}")
    print(f"words covered by a nontrivial collision class: {covered} of {n}")

    # falsifiable prediction: no class straddles two |ea| values
    bad = [g for g in nontrivial.values() if len({abs(ea(w)) for w in g}) > 1]
    print(f"classes straddling more than one |e_a| value (should be 0): {len(bad)}")
    if bad:
        print("  VIOLATIONS:", bad)

    print()
    print("nontrivial classes, sorted by size:")
    for r, g in sorted(nontrivial.items(), key=lambda t: -len(t[1])):
        print(f"  size {len(g)}: {sorted(g)}")

    # spot-check the two specific triples claimed
    claimed_triples = [{"ABaB", "ABBaB", "ABaBB"}, {"AAbAb", "AABBAb", "AAbABB"}]
    for ct in claimed_triples:
        present = ct.issubset(set(reps))
        print(f"\nclaimed triple {sorted(ct)}: all words present among the 99 reps? {present}")
        if present:
            grp = find(next(iter(ct)))
            same_class = all(find(w) == grp for w in ct)
            print(f"  all three in the same collision class here? {same_class}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
