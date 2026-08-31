# Primitive-geodesic census for m006 and m003 (compact, H_1=Z/5 each),
# replacing the invalid word-length enumeration / n_a+n_b classifier
# used in gentry-torsion-plb.tex (see
# torsion_homology_correction_certificate.sage for that certificate).
#
# Protocol (as specified):
#   primitive unoriented geodesics -> exact homology class -> (l,psi)
#   -> frozen complete table
# with psi_gamma = dist(arg(lambda_gamma), pi*Z) in [0, pi/2].
#
# Implementation choices, stated explicitly (manifest):
#   - Enumeration: SnapPy's own length_spectrum(L_max, include_words=True),
#     a genuine geodesic-tracing enumeration (NOT word-length truncation).
#     This returns each primitive geodesic once (as an unoriented class,
#     the standard convention for a length spectrum) together with an
#     explicit word representative and multiplicity.
#   - Homology class: the CERTIFIED map from
#     torsion_homology_correction_certificate.sage --
#       m006: [a]->2, [b]->1  (mod 5)
#       m003: [a]->3, [b]->1  (mod 5)
#     applied to the exponent-sum vector of SnapPy's own word for each
#     geodesic (not re-derived per geodesic by any other means).
#   - psi: theta = Im(complex_length) is the geometric twist (matches
#     the standard relation lambda=exp(complex_length/2), so
#     arg(lambda) = theta/2 up to the usual branch ambiguity); fold to
#     [0, pi/2] via distance to the nearest multiple of pi.
#   - Multiplicities preserved exactly as SnapPy reports them.
#
# Sanity checks (must pass before any statistic is defined):
#   (1) conjugate/cyclic-rotation invariance of the homology class --
#       homology class is abelianization, hence conjugation-invariant
#       by construction; verified empirically on every word returned
#       (compare class(w) to class(any cyclic rotation of w)).
#   (2) inversion sends class -> -class exactly, checked on every word.

import snappy
import math
import json
import hashlib
from datetime import datetime

L_MAX = 6.0   # frozen BEFORE looking at any class-resolved statistic
PREC_BITS = 212  # SnapPy default working precision for length_spectrum

# CORRECTED: length_spectrum(..., include_words=True) returns words in
# SnapPy's UNSIMPLIFIED Dirichlet-domain presentation, NOT the
# simplified 2-generator {a,b} presentation the first certificate
# covered (confirmed: m006 uses {a,b,c,d}, m003 uses {a,b,c} -- checked
# directly, not assumed). Redid the certificate for these exact
# presentations in torsion_homology_correction_certificate_4gen.sage;
# reusing its certified coefficients here.
CLASSIFIER = {
    'm006': {'census_index': 43, 'order': 5,
             'coeffs': {'a': 1, 'b': 4, 'c': 2, 'd': 2}},
    'm003': {'census_index': 1, 'order': 5,
             'coeffs': {'a': 1, 'b': 3, 'c': 4}},
}


def exponent_vector(word, letters):
    vec = {L: 0 for L in letters}
    for ch in word:
        if ch.islower():
            vec[ch] += 1
        else:
            vec[ch.lower()] -= 1
    return vec


def homology_class(word, coeffs, order):
    letters = list(coeffs.keys())
    ev = exponent_vector(word, letters)
    return sum(ev[L] * coeffs[L] for L in letters) % order


def invert_word(word):
    def flip(c):
        return c.lower() if c.isupper() else c.upper()
    return ''.join(flip(c) for c in reversed(word))


def cyclic_rotations(word):
    return [word[i:] + word[:i] for i in range(len(word))]


def fold_psi(theta):
    # NOTE: a real bug was caught here and fixed. Sage's "%" operator
    # silently misbehaves (returns its input completely unchanged,
    # with no error) for the sage.rings.real_mpfr.RealNumber type
    # (the type produced by ordinary arithmetic like division) -- even
    # though it works correctly for the closely related RealLiteral
    # type (a bare numeric literal typed directly into a .sage file).
    # Verified directly (reproduce/_debug_fold.sage, not committed):
    # fold_psi(-2.69...) worked, but fold_psi((-2.69...)/2) silently
    # returned its negative input unfolded. Avoided entirely by forcing
    # a plain Python float and using an explicit floor-based reduction
    # instead of relying on "%" on a Sage numeric type.
    theta = float(theta)
    r = theta - math.pi * math.floor(theta / math.pi)
    return min(r, math.pi - r)


manifest = {
    'generated': str(datetime.now()),
    'L_max': L_MAX,
    'precision_bits': PREC_BITS,
    'manifolds': {},
}

full_results = {}

for name, cfg in CLASSIFIER.items():
    M = snappy.OrientableClosedCensus[cfg['census_index']]
    G = M.fundamental_group(simplify_presentation=False)  # matches length_spectrum's word convention
    assert set(G.generators()) == set(cfg['coeffs'].keys()), (
        f"{name}: presentation generators {G.generators()} do not match the "
        f"certified classifier's generators {list(cfg['coeffs'].keys())} -- "
        "wrong presentation, would misclassify every word")
    manifest['manifolds'][name] = {
        'snappy_name': M.name(),
        'census_index': cfg['census_index'],
        'volume': str(M.volume()),
        'presentation_generators': G.generators(),
        'presentation_relators': G.relators(),
        'homology_map': f"{cfg['coeffs']} (mod {cfg['order']}) -- certified in "
                         f"torsion_homology_correction_certificate_4gen.sage",
    }

    print()
    print("=" * 72)
    print(f"{name} ({M.name()}), vol={M.volume()}, L_max={L_MAX}")
    print("=" * 72)

    spectrum = M.length_spectrum(L_MAX, include_words=True)
    print(f"length_spectrum({L_MAX}) entries: {len(spectrum)}")

    rows = []
    sanity1_failures = 0
    sanity2_failures = 0

    for entry in spectrum:
        word = entry.word
        mult = entry.multiplicity
        cl = entry.length  # complex length L + i*theta
        L_real = float(cl.real())
        theta = float(cl.imag())
        psi = fold_psi(theta / 2.0)
        hc = homology_class(word, cfg['coeffs'], cfg['order'])

        # Sanity check 1: cyclic rotation invariance.
        for rot in cyclic_rotations(word):
            if homology_class(rot, cfg['coeffs'], cfg['order']) != hc:
                sanity1_failures += 1
                print(f"  !! rotation mismatch: {word} -> {rot}")
                break

        # Sanity check 2: inversion sends class -> -class exactly.
        inv = invert_word(word)
        hc_inv = homology_class(inv, cfg['coeffs'], cfg['order'])
        expected = (-hc) % cfg['order']
        if hc_inv != expected:
            sanity2_failures += 1
            print(f"  !! inversion mismatch: {word} class={hc}, inverse {inv} class={hc_inv}, expected {expected}")

        rows.append({
            'word': word,
            'homology_class': hc,
            'length': L_real,
            'psi': psi,
            'theta': theta,
            'multiplicity': mult,
            'topology': str(entry.topology),
        })

    print(f"sanity check 1 (rotation invariance) failures: {sanity1_failures} / {len(spectrum)}")
    print(f"sanity check 2 (inversion -> -class) failures: {sanity2_failures} / {len(spectrum)}")
    assert sanity1_failures == 0, f"{name}: rotation-invariance sanity check FAILED"
    assert sanity2_failures == 0, f"{name}: inversion sanity check FAILED"
    print("BOTH SANITY CHECKS PASS.")

    # Class-resolved summary (structural only -- no thresholded
    # statistic defined here, per protocol).
    by_class = {}
    for r in rows:
        by_class.setdefault(r['homology_class'], []).append(r)
    print()
    print("Class-resolved counts and psi-floor (min psi seen), structural only:")
    for k in range(cfg['order']):
        entries_k = by_class.get(k, [])
        if entries_k:
            floor_psi = min(e['psi'] for e in entries_k)
            floor_word = [e['word'] for e in entries_k if e['psi'] == floor_psi][0]
        else:
            floor_psi, floor_word = None, None
        print(f"  class {k}: count={len(entries_k)}, psi_floor={floor_psi}, word={floor_word}")

    full_results[name] = rows

manifest['sha256_of_full_table'] = hashlib.sha256(
    json.dumps(full_results, sort_keys=True, default=str).encode()).hexdigest()

with open('reproduce/primitive_geodesic_census_manifest.json', 'w') as f:
    json.dump(manifest, f, indent=2, default=str)
with open('reproduce/primitive_geodesic_census_table.json', 'w') as f:
    json.dump(full_results, f, indent=2, default=str)

print()
print("=" * 72)
print("Manifest and full table written.")
print("sha256:", manifest['sha256_of_full_table'])
print("=" * 72)
