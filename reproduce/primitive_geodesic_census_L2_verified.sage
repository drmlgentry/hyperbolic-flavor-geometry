# Canonical torsion-investigation census: formally VERIFIED primitive
# geodesic enumeration at the feasible common cutoff L*=2.0 (determined
# in length_spectrum_alt_feasibility_probe.sage). Supersedes the
# unverified L_max=6 diagnostic run (frozen separately as
# primitive_geodesic_census_FROZEN_aug31_2026.sage, sha256
# c830b75602dc040cbe91d34efc45ced43b34c24117c592505a3865608d5007bc,
# preserved as provenance, NOT used for any claim).
#
# Uses length_spectrum_alt(verified=True, bits_prec=300, max_len=2.0):
# the returned length is a certified INTERVAL (ComplexIntervalFieldElement),
# not a floating-point approximation, and the algorithm is proven to
# include every geodesic genuinely below the cutoff (it may also include
# some whose interval straddles or exceeds the cutoff -- these are
# classified explicitly below, not silently included or excluded).
#
# Uses the NATIVE unsimplified classifiers (independently certified,
# torsion_homology_correction_certificate_4gen.sage; NOT the transferred
# ones -- the transfer certificate showed native and transferred agree
# only up to a manifold-specific unit u in (Z/5)^x, so mixing them
# without correcting for u would silently relabel classes).
#
# Records the primary UNORIENTED class as the pair {c, -c} (not a single
# residue), per protocol -- and separately verifies, from the actual
# certified units u=4 (m006) and u=2 (m003), exactly which inverse-orbit
# pairs are fixed vs swapped between the native and transferred
# coordinate systems (do not just assert this, check it here).

import snappy
import math
import json
import hashlib
from datetime import datetime

L_STAR = 2.0
BITS_PREC = 300

CLASSIFIER = {
    'm006': {'census_index': 43, 'order': 5,
             'coeffs': {'a': 1, 'b': 4, 'c': 2, 'd': 2}, 'u': 4},
    'm003': {'census_index': 1, 'order': 5,
             'coeffs': {'a': 1, 'b': 3, 'c': 4}, 'u': 2},
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
    # Same fix as before: force plain float, explicit floor-based
    # reduction (Sage's "%" silently no-ops on RealNumber -- do not
    # reintroduce that bug).
    theta = float(theta)
    r = theta - math.pi * math.floor(theta / math.pi)
    return min(r, math.pi - r)


######################################################################
# STEP 3 (verify before using): does u fix or swap each inverse-orbit
# pair {c,-c} in Z/5, for each manifold's certified u?
######################################################################
print("=" * 72)
print("STEP 3: inverse-orbit fix/swap check for each manifold's unit u")
print("=" * 72)
for name, cfg in CLASSIFIER.items():
    order = cfg['order']
    u = cfg['u']
    orbits = []
    seen = set()
    for c in range(1, order):
        if c in seen:
            continue
        pair = frozenset({c, (-c) % order})
        orbits.append(pair)
        seen.update(pair)
    print(f"{name}: u={u}, orbits={sorted(tuple(sorted(o)) for o in orbits)}")
    for orbit in orbits:
        image = frozenset({(u * c) % order for c in orbit})
        status = "FIXED (maps to itself)" if image == orbit else f"MAPPED to {sorted(image)}"
        print(f"    orbit {sorted(orbit)} -> {status}")

######################################################################
# STEP 2: verified census at L*=2.0
######################################################################
manifest = {
    'generated': str(datetime.now()),
    'L_star': L_STAR,
    'bits_prec': BITS_PREC,
    'method': 'length_spectrum_alt(verified=True)',
    'frozen_diagnostic_script_sha256': 'c830b75602dc040cbe91d34efc45ced43b34c24117c592505a3865608d5007bc',
    'manifolds': {},
}
full_results = {}

for name, cfg in CLASSIFIER.items():
    M = snappy.OrientableClosedCensus[cfg['census_index']]
    Gu = M.fundamental_group(simplify_presentation=False)
    assert set(Gu.generators()) == set(cfg['coeffs'].keys()), \
        f"{name}: generator mismatch, wrong presentation for classifier"

    manifest['manifolds'][name] = {
        'snappy_name': M.name(),
        'census_index': cfg['census_index'],
        'volume': str(M.volume()),
        'presentation_generators': Gu.generators(),
        'presentation_relators': Gu.relators(),
        'native_classifier': cfg['coeffs'],
        'order': cfg['order'],
        'transfer_unit_u': cfg['u'],
    }

    print()
    print("=" * 72)
    print(f"{name} ({M.name()}), vol={M.volume()}, L*={L_STAR}, bits_prec={BITS_PREC}")
    print("=" * 72)

    spectrum = M.length_spectrum_alt(max_len=L_STAR, verified=True, bits_prec=BITS_PREC)
    print(f"length_spectrum_alt(max_len={L_STAR}, verified=True) entries: {len(spectrum)}")

    rows = []
    boundary_flagged = 0
    sanity1_failures = 0
    sanity2_failures = 0

    for entry in spectrum:
        word = entry.word
        mult = entry.multiplicity
        cl = entry.length  # certified COMPLEX INTERVAL
        real_part = cl.real()
        imag_part = cl.imag()
        L_lower = float(real_part.lower())
        L_upper = float(real_part.upper())

        # Interval boundary classification -- explicit, not silent.
        if L_upper <= L_STAR:
            boundary_status = 'CERTAIN_BELOW'
        elif L_lower > L_STAR:
            boundary_status = 'CERTAIN_ABOVE'  # should be excluded
        else:
            boundary_status = 'STRADDLES_CUTOFF'
            boundary_flagged += 1

        theta_mid = (float(imag_part.lower()) + float(imag_part.upper())) / 2.0
        psi = fold_psi(theta_mid / 2.0)
        hc = homology_class(word, cfg['coeffs'], cfg['order'])

        # Sanity checks (same as before, required to pass).
        for rot in cyclic_rotations(word):
            if homology_class(rot, cfg['coeffs'], cfg['order']) != hc:
                sanity1_failures += 1
                break
        inv = invert_word(word)
        hc_inv = homology_class(inv, cfg['coeffs'], cfg['order'])
        if hc_inv != (-hc) % cfg['order']:
            sanity2_failures += 1

        primary_class = tuple(sorted({hc, (-hc) % cfg['order']}))

        rows.append({
            'word': word,
            'homology_class': hc,
            'primary_class_pm': list(primary_class),
            'length_lower': L_lower,
            'length_upper': L_upper,
            'boundary_status': boundary_status,
            'psi': psi,
            'multiplicity': mult,
            'topology': str(entry.topology),
            'parity': str(entry.parity),
        })

    print(f"sanity check 1 (rotation invariance) failures: {sanity1_failures} / {len(spectrum)}")
    print(f"sanity check 2 (inversion -> -class) failures: {sanity2_failures} / {len(spectrum)}")
    print(f"entries whose length interval STRADDLES the cutoff (flagged, not silently included/excluded): {boundary_flagged}")
    assert sanity1_failures == 0, f"{name}: rotation-invariance FAILED"
    assert sanity2_failures == 0, f"{name}: inversion FAILED"
    print("BOTH REQUIRED SANITY CHECKS PASS.")

    print()
    print("Complete verified table (no minima, no epsilon, no ranking -- full listing):")
    for r in rows:
        print(f"  word={r['word']:20s} class={r['homology_class']} pm_class={r['primary_class_pm']} "
              f"length=[{r['length_lower']:.6f},{r['length_upper']:.6f}] psi={r['psi']:.6f} "
              f"status={r['boundary_status']} mult={r['multiplicity']}")

    full_results[name] = rows

manifest['sha256_of_full_table'] = hashlib.sha256(
    json.dumps(full_results, sort_keys=True, default=str).encode()).hexdigest()

with open('reproduce/primitive_geodesic_census_L2_manifest.json', 'w') as f:
    json.dump(manifest, f, indent=2, default=str)
with open('reproduce/primitive_geodesic_census_L2_table.json', 'w') as f:
    json.dump(full_results, f, indent=2, default=str)

print()
print("=" * 72)
print("Manifest and full VERIFIED L*=2.0 table written.")
print("sha256 of table:", manifest['sha256_of_full_table'])
print("=" * 72)
