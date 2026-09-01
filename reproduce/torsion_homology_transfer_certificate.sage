# Bounded task (per instruction): certify the simplified<->unsimplified
# homology-coordinate transfer for m006, m003, and determine the unit
# u in (Z/5)^x relating the natively-derived unsimplified classifier
# (torsion_homology_correction_certificate_4gen.sage) to the classifier
# obtained by transferring the already-certified SIMPLIFIED classifier
# (torsion_homology_correction_certificate.sage) via
# G.original_generators() -- the correspondence SnapPy itself tracks
# between the two presentations.
#
# Does NOT touch the primitive-geodesic census. Does NOT interpret any
# class-resolved data.

import snappy
from sage.all import matrix, ZZ, vector

# Already-certified NATIVE unsimplified classifiers (from
# torsion_homology_correction_certificate_4gen.sage, independently
# re-verified there via Smith normal form + all-relators-vanish on the
# unsimplified presentation itself).
NATIVE = {
    'm006': {'order': 5, 'coeffs': {'a': 1, 'b': 4, 'c': 2, 'd': 2}},
    'm003': {'order': 5, 'coeffs': {'a': 1, 'b': 3, 'c': 4}},
}

# Already-certified SIMPLIFIED (2-generator) classifiers (from
# torsion_homology_correction_certificate.sage).
SIMPLIFIED = {
    'm006': {'order': 5, 'a': 2, 'b': 1},
    'm003': {'order': 5, 'a': 3, 'b': 1},
}

CENSUS_INDEX = {'m006': 43, 'm003': 1}


def exponent_in_simplified(word):
    na = sum(1 for c in word if c == 'a') - sum(1 for c in word if c == 'A')
    nb = sum(1 for c in word if c == 'b') - sum(1 for c in word if c == 'B')
    return na, nb


def simplified_map(word, name):
    na, nb = exponent_in_simplified(word)
    s = SIMPLIFIED[name]
    return (na * s['a'] + nb * s['b']) % s['order']


for name in ['m006', 'm003']:
    print()
    print("=" * 72)
    print(f"{name}: transfer certificate")
    print("=" * 72)

    M = snappy.OrientableClosedCensus[CENSUS_INDEX[name]]
    Gs = M.fundamental_group(simplify_presentation=True)
    Gu = M.fundamental_group(simplify_presentation=False)

    print("simplified generators:", Gs.generators())
    print("unsimplified generators:", Gu.generators())

    orig_words = Gs.original_generators()
    print("original_generators() (unsimplified gens as words in simplified {a,b}):")
    for g, w in zip(Gu.generators(), orig_words):
        print(f"  unsimplified '{g}' = '{w}' (in simplified gens)")

    assert len(orig_words) == len(Gu.generators()), \
        "original_generators() count does not match unsimplified generator count"

    order = NATIVE[name]['order']
    assert order == SIMPLIFIED[name]['order']

    transferred = {}
    for g, w in zip(Gu.generators(), orig_words):
        transferred[g] = simplified_map(w, name)

    native = NATIVE[name]['coeffs']
    print()
    print("native (from unsimplified relators directly):", native)
    print("transferred (simplified map o original_generators()):", transferred)

    # Find u in (Z/5)^x with transferred[g] = u * native[g] (mod order)
    # for EVERY generator g simultaneously (a single global unit, not a
    # per-generator fit).
    found_u = None
    for u in range(1, order):
        if all((u * native[g]) % order == transferred[g] for g in Gu.generators()):
            found_u = u
            break

    print()
    if found_u is not None:
        print(f"CERTIFIED: transferred = {found_u} * native (mod {order}), for EVERY generator.")
        print(f"u = {found_u} in (Z/{order})^x relates the two independently-derived maps exactly.")
    else:
        print("NO consistent global unit found -- the two classifiers do NOT")
        print("agree up to a scalar. This would mean at least one of the two")
        print("certificates (native or transferred) has an error -- investigate")
        print("before trusting either for the census.")
        print("Per-generator ratios (for diagnosis):")
        for g in Gu.generators():
            for u in range(1, order):
                if (u * native[g]) % order == transferred[g]:
                    print(f"  {g}: u={u} works alone (but not for all generators)")

    assert found_u is not None, f"{name}: transfer certificate FAILED -- classifiers inconsistent"
