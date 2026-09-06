"""
First concrete step of the speculative "charge as topological sector"
research direction: construct the canonical character
    chi: pi_1(M_PMNS) -> H_1(M_PMNS) = Z/5 -> U(1)
for M_PMNS = m003(-2,3), directly from the verified presentation
(relator r=abAAbabbb, meridian mu=ABABB, longitude lambda=ABAbab) and
the (-2,3) filling relation, and check it against theorems already
established this session.

Key finding: [a] = [b] in H_1(M_PMNS) = Z/5 -- both generators map to
the SAME class. This is not obvious from the presentation alone; it is
a consequence of the specific (-2,3) filling. Verified via Sage's own
quotient-module machinery (sage.all.FreeModule quotient), not by hand.

Consequence: chi(w) depends only on the TOTAL signed letter count of w
(a-exponent + b-exponent), reduced mod 5 -- not on which letters
appear. This is the whole content of the canonical character for this
manifold; there is no further freedom in "which combination of a,b" to
use.

This is explicitly exploratory theory-building, not an exact-proof
result of the kind established elsewhere in this repo (ITF, character
variety). It establishes the requested mathematical object (a canonical,
composition-compatible -- chi(uv)=chi(u)chi(v) automatically, since it
factors through abelianization -- character on pi_1) and reports what
it actually gives, honestly, including where it does NOT match an
earlier, unverified relayed claim.
"""


def exp_vec(w):
    """Signed exponent vector (n_a, n_b) of a word in a,A,b,B."""
    ea, eb = 0, 0
    for c in w:
        if c == 'a':
            ea += 1
        elif c == 'A':
            ea -= 1
        elif c == 'b':
            eb += 1
        elif c == 'B':
            eb -= 1
    return ea, eb


def chi(w):
    """Canonical character pi_1(M_PMNS) -> Z/5, chi(w) = (n_a+n_b) mod 5."""
    ea, eb = exp_vec(w)
    return (ea + eb) % 5


if __name__ == "__main__":
    print("Canonical character chi: pi_1(M_PMNS) -> Z/5")
    print("(derived from relator r=abAAbabbb, mu=ABABB, lambda=ABAbab,")
    print(" filling (-2,3); [a]=[b] verified via Sage quotient module)")
    print()
    print("PMNS word triple {aa, aaB, baa}:")
    for w in ["aa", "aaB", "baa"]:
        print(f"  chi({w}) = {chi(w)}")

    print()
    print("CKM word triples:")
    for w in ["aaB", "AbA", "AAb", "aaab", "aabb", "bAbAB"]:
        print(f"  chi({w}) = {chi(w)}  [note: this is M_PMNS's character, not m006's own]")

    print()
    print("Cross-check against the proven conjugacy theorem (BaBA).B.(BaBA)^-1 = Abb^-1,")
    print("which forces [B] = -[Abb] in any abelianization:")
    print(f"  chi(B)={chi('B')}, chi(Abb)={chi('Abb')}, sum mod 5 = {(chi('B')+chi('Abb'))%5} (expect 0)")

    print()
    print("Same check against the three UNPROVEN-to-be-related universal identities")
    print("(these are squared-trace identities on X_0, not claimed a priori to respect")
    print("homology -- checking whether they do anyway):")
    for w, wp in [("A", "ABBB"), ("AB", "ABB"), ("AAb", "AABB")]:
        s = (chi(w) + chi(wp)) % 5
        print(f"  chi({w})={chi(w)}, chi({wp})={chi(wp)}, sum mod 5 = {s} (0 means [w]=-[w'])")

    print()
    print("All four squared-trace-degeneracy pairs found by the atlas satisfy")
    print("[w] = -[w'] in H_1(M) -- a genuine pattern across all 4 known cases,")
    print("not yet shown to be a theorem (small sample, not derived from first")
    print("principles here).")

    print()
    print("Correction of an earlier, unverified relayed claim: a relayed message")
    print("earlier this session asserted h(w) = 3*n_a(w) + n_b(w) mod 5 as 'the'")
    print("homology-class formula, and that B and Abb both lie in class 4. Neither")
    print("holds under the actual, rigorously-derived character: h(w) = n_a+n_b")
    print("(unweighted, since [a]=[b]), and chi(B)=4 while chi(Abb)=1 -- different")
    print("classes, related by chi(B)=-chi(Abb), not equality.")
