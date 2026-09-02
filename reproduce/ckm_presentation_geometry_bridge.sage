#!/usr/bin/env sage
"""
Final provenance bridge for the CKM presentation-only elimination.

This standalone, read-only certificate connects the exact hard-coded
presentation chart used by ckm_presentation_elimination.sage to the
verified geometric SL(2,C) holonomy returned by SnapPy.

It writes no files and does not modify the repository.
"""

from sage.all import *
import hashlib
import os
import sage.version


BITS_PREC = 300
REPO = "/mnt/c/dev/hyperbolic-flavor-geometry"
SOURCE = os.path.join(REPO, "reproduce", "q001_fricke_collapse_m006.sage")
ELIM_SCRIPT = "/mnt/c/Users/Your Name Here/Documents/Codex/ckm_presentation_elimination.sage"
ELIM_LOG = "/tmp/ckm_presentation_elimination.log"

EXPECTED_SOURCE_SHA256 = "29D8D4917AF10B4C49417832761D9719D9089479BF99BBEDAEA5DBE556F3616D"
EXPECTED_ELIM_SCRIPT_SHA256 = "A2D729E5F59A40B6D130AB7A38CBF705F834E9B4C99302797311CA750DC8DA74"

RELATOR = "ababbAAbb"
MU = "Abb"
LONGITUDE = "AAbA"
FILLING_WORD = "BBaBBaBBaBBaBBaAAbAAAbA"
SHORTENED_FILLING_WORD = "aBabbAbbAbbaBabbAbb"
EXPECTED_GENERATORS = ("a", "b")

# Ask SnapPy to preserve the cusped presentation's generators when adding
# the Dehn filling relation, and disable the optional aggressive relator
# shortening.  The first audit run with the final argument True replaced
# the literal slope word by `aBabbAbbAbbaBabbAbb`; that replacement is
# expected from the option but was not independently certified there.
# Keeping it False makes the provenance bridge demand the original slope
# word itself (up to cyclic rotation/inversion).
FUNDAMENTAL_GROUP_ARGS = [True, False, True, False]


def banner(text):
    print("\n" + "=" * 78)
    print(text)
    print("=" * 78)


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest().upper()


def inverse_word(word):
    swap = {"a": "A", "A": "a", "b": "B", "B": "b"}
    return "".join(swap[c] for c in reversed(word))


def freely_reduce(word):
    inverse = {"a": "A", "A": "a", "b": "B", "B": "b"}
    stack = []
    for c in word:
        if stack and inverse[c] == stack[-1]:
            stack.pop()
        else:
            stack.append(c)
    return "".join(stack)


def cyclic_or_inverse_cyclic_equivalent(left, right):
    left = freely_reduce(left)
    right = freely_reduce(right)
    if len(left) != len(right):
        return False
    if not left:
        return not right
    doubled = left + left
    return right in doubled or inverse_word(right) in doubled


def interval_contains_real(z, target):
    return (z.real().lower() <= target <= z.real().upper()
            and z.imag().lower() <= 0 <= z.imag().upper())


def matrix_interval_contains(M, target):
    for i in range(2):
        for j in range(2):
            expected = target if i == j else 0
            if not interval_contains_real(M[i, j], expected):
                return False
    return True


def matching_relator_indices(relators, target):
    return [i for i, word in enumerate(relators)
            if cyclic_or_inverse_cyclic_equivalent(word, target)]


def rotations(word):
    return tuple(word[i:] + word[:i] for i in range(len(word)))


RELATOR_CYCLES = (
    set(rotations(RELATOR)) |
    set(rotations(inverse_word(RELATOR)))
)


def verify_dehn_rule(lhs, rhs):
    """Verify lhs=rhs from one cyclic conjugate of r or r^(-1)."""
    assert len(rhs) < len(lhs)
    relator_form = freely_reduce(lhs + inverse_word(rhs))
    assert relator_form in RELATOR_CYCLES
    return relator_form


def certify_dehn_trace(label, initial_word, steps):
    """Check a supplied finite derivation; no word-problem solver is used."""
    current = freely_reduce(initial_word)
    print(label, "initial word =", current)
    for number, (position, lhs, rhs) in enumerate(steps, start=1):
        assert current[position:position + len(lhs)] == lhs
        relator_form = verify_dehn_rule(lhs, rhs)
        replaced = current[:position] + rhs + current[position + len(lhs):]
        next_word = freely_reduce(replaced)
        assert len(next_word) < len(current)
        print(
            label, "step", number, "position", position,
            repr(lhs), "->", repr(rhs),
            "using relator cycle", relator_form,
            "result", next_word if next_word else "<empty>",
        )
        current = next_word
    assert current == ""
    print(label, "finite Dehn reduction: PASS")


QS_STEPS = (
    (12, "BaaBB", "baba"),
    (8, "Abbabab", "aB"),
    (9, "BaaBB", "baba"),
    (5, "Abbabab", "aB"),
    (6, "BaaBBA", "bab"),
    (3, "bbababbAA", ""),
)

SQ_STEPS = (
    (15, "bAAbb", "BABA"),
    (11, "aBBABAB", "Ab"),
    (12, "bAAbb", "BABA"),
    (8, "aBBABAB", "Ab"),
    (9, "bAAbba", "BAB"),
    (5, "aBBABABBa", ""),
)


banner("CKM FINAL PRESENTATION/GEOMETRY PROVENANCE BRIDGE")
print("Sage version =", sage.version.version)
print("SnapPy fundamental_group_args =", FUNDAMENTAL_GROUP_ARGS)
print("fillings_may_affect_generators = False")
print("try_hard_to_shorten_relators = False")

source_hash = sha256_file(SOURCE)
elim_script_hash = sha256_file(ELIM_SCRIPT)
print("source =", SOURCE)
print("source SHA256 =", source_hash)
print("elimination script =", ELIM_SCRIPT)
print("elimination script SHA256 =", elim_script_hash)
assert source_hash == EXPECTED_SOURCE_SHA256
assert elim_script_hash == EXPECTED_ELIM_SCRIPT_SHA256

if os.path.exists(ELIM_LOG):
    elim_log_hash = sha256_file(ELIM_LOG)
    with open(ELIM_LOG, "r", encoding="utf-8", errors="replace") as f:
        elim_log_text = f.read()
    print("elimination log =", ELIM_LOG)
    print("elimination log SHA256 =", elim_log_hash)
    print("elimination PASS marker present =",
          "INDEPENDENT DERIVATION CERTIFICATE: PASS" in elim_log_text)
    assert "INDEPENDENT DERIVATION CERTIFICATE: PASS" in elim_log_text
else:
    print("elimination log = ABSENT (provenance bridge continues independently)")


banner("EXACT CUSPED PRESENTATION COORDINATES")
import snappy

M_cusp = snappy.Manifold("m006")
G_cusp = M_cusp.fundamental_group(*FUNDAMENTAL_GROUP_ARGS)
cusp_generators = tuple(str(g) for g in G_cusp.generators())
cusp_relators = tuple(str(w) for w in G_cusp.relators())
cusp_peripheral = tuple((str(m), str(l))
                        for m, l in G_cusp.peripheral_curves())

print("cusped generators =", cusp_generators)
print("cusped relators =", cusp_relators)
print("cusped peripheral curves =", cusp_peripheral)

assert cusp_generators == EXPECTED_GENERATORS, (
    "Cusped generator coordinates differ from the elimination chart."
)
cusp_relator_matches = matching_relator_indices(cusp_relators, RELATOR)
print("indices matching hard-coded relator up to cyclic/inverse cyclic =",
      cusp_relator_matches)
assert cusp_relator_matches, "Hard-coded relator not found in cusped presentation."
assert len(cusp_peripheral) == 1
assert cusp_peripheral[0] == (MU, LONGITUDE), (
    "Peripheral words differ from the elimination chart."
)

derived_filling_word = inverse_word(MU) * 5 + LONGITUDE * 2
print("derived slope (-5,2) word =", derived_filling_word)
assert derived_filling_word == FILLING_WORD


banner("FILLED PRESENTATION WITH CUSP GENERATORS PRESERVED")
M_filled = snappy.Manifold("m006")
M_filled.dehn_fill((-5, 2))
G_filled = M_filled.fundamental_group(*FUNDAMENTAL_GROUP_ARGS)
filled_generators = tuple(str(g) for g in G_filled.generators())
filled_relators = tuple(str(w) for w in G_filled.relators())
filled_peripheral = tuple((str(m), str(l))
                          for m, l in G_filled.peripheral_curves())

print("filled generators =", filled_generators)
print("filled relators =", filled_relators)
print("filled peripheral curves =", filled_peripheral)
assert filled_generators == EXPECTED_GENERATORS, (
    "Filled presentation did not preserve the cusped a,b coordinates."
)
assert filled_peripheral == cusp_peripheral, (
    "Peripheral coordinate words changed after filling."
)

filled_relator_matches = matching_relator_indices(filled_relators, RELATOR)
filled_slope_matches = matching_relator_indices(filled_relators, FILLING_WORD)
print("filled relator indices matching r =", filled_relator_matches)
print("filled relator indices matching slope word =", filled_slope_matches)

assert filled_relator_matches, "Original relator not visible in filled presentation."

if filled_slope_matches:
    print("literal slope relator visible: no relator-equivalence fallback needed")
else:
    banner("EXACT SHORTENED-RELATOR EQUIVALENCE")
    non_r_indices = [i for i in range(len(filled_relators))
                     if i not in filled_relator_matches]
    print("non-r relator indices =", non_r_indices)
    assert len(non_r_indices) == 1, (
        "Expected exactly one shortened filling relator."
    )
    shortened_word = filled_relators[non_r_indices[0]]
    print("shortened filling relator q =", shortened_word)
    assert shortened_word == SHORTENED_FILLING_WORD

    # These two finite derivations prove q*s=s*q=1 modulo <<r>>.
    # Each move is independently checked against a cyclic conjugate of
    # r or r^(-1); no confluence or word-problem oracle is required.
    certify_dehn_trace("q*s", shortened_word + FILLING_WORD, QS_STEPS)
    certify_dehn_trace("s*q", FILLING_WORD + shortened_word, SQ_STEPS)
    print("q = s^(-1) in <a,b | r>: PASS")
    print("normal_closure(r,q) = normal_closure(r,s): PASS")


banner("VERIFIED SL(2,C) HOLONOMY IN THE SAME PRESENTATION")
ok, rho = M_filled.verify_hyperbolicity(
    holonomy=True,
    bits_prec=BITS_PREC,
    fundamental_group_args=FUNDAMENTAL_GROUP_ARGS,
)
print("verify_hyperbolicity(..., holonomy=True, bits_prec=300) =", ok)
assert ok

rho_generators = tuple(str(g) for g in rho.generators())
rho_relators = tuple(str(w) for w in rho.relators())
rho_peripheral = tuple((str(m), str(l))
                       for m, l in rho.peripheral_curves())
print("rho generators =", rho_generators)
print("rho relators =", rho_relators)
print("rho peripheral curves =", rho_peripheral)

assert rho_generators == filled_generators == cusp_generators
assert rho_relators == filled_relators
assert rho_peripheral == filled_peripheral == cusp_peripheral

rho_r = rho(RELATOR)
rho_s = rho(FILLING_WORD)
print("rho(relator) =")
print(rho_r)
print("rho(filling word) =")
print(rho_s)

r_contains_plus_I = matrix_interval_contains(rho_r, 1)
r_contains_minus_I = matrix_interval_contains(rho_r, -1)
s_contains_plus_I = matrix_interval_contains(rho_s, 1)
s_contains_minus_I = matrix_interval_contains(rho_s, -1)

print("rho(relator) interval contains +I =", r_contains_plus_I)
print("rho(relator) interval contains -I =", r_contains_minus_I)
print("rho(filling word) interval contains +I =", s_contains_plus_I)
print("rho(filling word) interval contains -I =", s_contains_minus_I)

assert r_contains_plus_I and not r_contains_minus_I
assert s_contains_plus_I and not s_contains_minus_I

T_x = rho("a").trace()
T_y = rho("b").trace()
T_z = rho("ab").trace()
T_mu = rho(MU).trace()
irreducibility_discriminant = T_x**2 + T_y**2 + T_z**2 - T_x*T_y*T_z - 4

print("T_x =", T_x)
print("T_y =", T_y)
print("T_z =", T_z)
print("T_mu =", T_mu)
print("irreducibility discriminant =", irreducibility_discriminant)

disc_contains_zero = interval_contains_real(irreducibility_discriminant, 0)
print("irreducibility discriminant contains 0 =", disc_contains_zero)
assert not disc_contains_zero


banner("FINAL PROVENANCE VERDICT")
print("cusped presentation words match elimination chart: PASS")
print("filled presentation preserves a,b coordinates: PASS")
print("slope (-5,2) kills mu^(-5)*longitude^2 in those coordinates: PASS")
print("verified rho uses exactly that filled presentation: PASS")
print("relator lift sign is +I, not -I: PASS")
print("filling-word lift sign is +I, not -I: PASS")
print("geometric character is irreducible; exact chart applies: PASS")
print("COMBINED WITH PRESENTATION ELIMINATION E(T)=m_mu(T):")
print("m_mu(tr rho_geom(mu)) = 0")
print("FINAL PRESENTATION/GEOMETRY PROVENANCE CERTIFICATE: PASS")
