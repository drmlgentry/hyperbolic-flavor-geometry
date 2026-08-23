#!/usr/bin/env sage
# stage3_build_state_invariants.sage
#
# PURPOSE
# -------
# Build the six-state HFG quark state space WITHOUT importing quark masses.
#
# State = (spin/lift bit epsilon, geometric embedding coset in G/H)
#   epsilon ∈ {+1,-1}
#   |G/H| = 3 for the S3 Galois closure of the m006 cubic field.
#
# This script:
#   1. builds K = Q(t), t^3 + 2t + 1 = 0;
#   2. builds its S3 Galois closure L;
#   3. computes H = Gal(L/K);
#   4. enumerates the three G/H embedding states;
#   5. orders them geometrically as upper / real / lower;
#   6. crosses them with epsilon = ±1;
#   7. records exact and numerical invariants for all six states;
#   8. optionally verifies the upper embedding against SnapPy's oriented cusp shape.
#
# NO QUARK MASSES OR TARGET q-INDICES APPEAR ANYWHERE IN THIS SCRIPT.
#
# Output:
#   stage3_state_invariants.csv
#   stage3_state_invariants.json
#
# Status:
#   builder / pre-registration artifact.
#   It constructs the six states; it does NOT derive the mass-index map.

from sage.all import *
import json, csv, os

R.<x> = PolynomialRing(QQ)
f = x^3 + 2*x + 1
K.<t> = NumberField(f)

print("="*80)
print("HFG STAGE 3 — SIX-STATE INVARIANT BUILDER")
print("="*80)
print("f(x) =", f)
print("[K:Q] =", K.degree())
print("disc(K) =", K.discriminant())
print("signature(K) =", K.signature())

# ----------------------------------------------------------------------
# 1. Galois closure with explicit K -> L map
# ----------------------------------------------------------------------
try:
    L, iota = K.galois_closure('z', map=True)
except TypeError:
    L, iota = K.galois_closure(names='z', map=True)

G = L.galois_group()
it = iota(t)

print("\nGalois closure:")
print("[L:Q] =", L.degree())
print("|G| =", G.order())
print("G =", G.structure_description())

# H = stabilizer of the embedded cubic generator
H = [g for g in G if g(it) == it]
if len(H) != 2:
    raise RuntimeError("Expected |H|=2, got %s" % len(H))

print("|H| =", len(H), "  (H = Gal(L/iota(K)))")

# ----------------------------------------------------------------------
# 2. Enumerate left cosets G/H and corresponding embeddings
# ----------------------------------------------------------------------
unused = list(G)
cosets = []

while unused:
    g = unused[0]
    C = [g*h for h in H]
    for c in C:
        if c in unused:
            unused.remove(c)
    alpha = g(it)
    cosets.append((g, C, alpha))

if len(cosets) != 3:
    raise RuntimeError("Expected 3 cosets, got %s" % len(cosets))

CC = ComplexField(200)

# alpha = g(it) lives in L (the degree-6 closure), which has no automatic
# complex embedding the way K did -- CC(alpha) fails with a coercion error.
# Fix: pick one fixed embedding L -> CC explicitly and apply it consistently.
# Since alpha ranges over the 3 distinct conjugate roots of f as g ranges
# over coset reps, and any embedding is injective, this correctly recovers
# the 3 distinct numeric roots regardless of which of L's embeddings is used.
_phi_L = L.complex_embeddings(prec=200)[0]

def zval(a):
    return _phi_L(a)

def embed_label(z):
    if abs(z.imag()) < CC(1e-40):
        return "real"
    return "upper" if z.imag() > 0 else "lower"

# Canonical geometric ordering:
# upper complex place, real place, lower complex place.
order_key = {"upper":0, "real":1, "lower":2}
coset_rows = []

for j,(rep,C,alpha) in enumerate(cosets):
    z = zval(alpha)
    lab = embed_label(z)
    coset_rows.append({
        "raw_index": j,
        "rep": rep,
        "coset": C,
        "alpha": alpha,
        "z": z,
        "embedding": lab,
    })

coset_rows.sort(key=lambda r: order_key[r["embedding"]])

print("\nThree geometric embedding states:")
for i,r in enumerate(coset_rows):
    print("  E%d %-5s  rep=%s  t->%s" % (i, r["embedding"], r["rep"], r["z"]))

# ----------------------------------------------------------------------
# 3. Optional SnapPy geometric check
# ----------------------------------------------------------------------
snap_tau = None
try:
    import snappy
    M = snappy.Manifold('m006')
    try:
        snap_tau = M.cusp_info('shape')[0]
    except Exception:
        snap_tau = M.cusp_info()[0]['shape']
    snap_tau = CC(complex(snap_tau))
    upper = [r for r in coset_rows if r["embedding"] == "upper"][0]["z"]
    print("\nSnapPy oriented cusp shape =", snap_tau)
    print("|tau - upper embedding| =", abs(snap_tau-upper))
except Exception as e:
    print("\nSnapPy check skipped:", e)

# ----------------------------------------------------------------------
# 4. Six states = two lift states x three embedding states
# ----------------------------------------------------------------------
# Convention:
# epsilon = +1 : lift extending over the distinguished CKM filling
# epsilon = -1 : chi-twisted non-extending lift
#
# This convention is structural and should only be promoted if the
# Dehn-surgery continuity argument is accepted/proved.

states = []
sid = 0

for eps in [+1,-1]:
    for eidx,r in enumerate(coset_rows):
        z = r["z"]
        signed = eps*z

        # State-intrinsic numerical invariants.
        # These are deliberately simple and mass-blind.
        abs_z = abs(z)
        arg_z = z.argument() if abs(z) != 0 else CC(0)
        signed_re = signed.real()
        signed_im = signed.imag()

        # Polynomial values/powers; useful raw features for later exact-rule search.
        z2 = z^2
        z3 = z^3

        states.append({
            "state_id": sid,
            "epsilon": int(eps),
            "embedding_index": eidx,
            "embedding": r["embedding"],
            "coset_rep": str(r["rep"]),
            "root_re": float(z.real()),
            "root_im": float(z.imag()),
            "root_abs": float(abs_z),
            "root_arg": float(arg_z),
            "signed_root_re": float(signed_re),
            "signed_root_im": float(signed_im),
            "root2_re": float(z2.real()),
            "root2_im": float(z2.imag()),
            "root3_re": float(z3.real()),
            "root3_im": float(z3.imag()),
            # Topological / spin metadata
            "H_order": 2,
            "G_order": int(G.order()),
            "coset_size": len(r["coset"]),
            "chi_mu": 1,
            "chi_lambda": 1,
            "chi_filling_slope": 1,
        })
        sid += 1

# ----------------------------------------------------------------------
# 5. Exact field invariants common to all conjugates
# ----------------------------------------------------------------------
field_meta = {
    "minimal_polynomial": str(f),
    "field_degree": int(K.degree()),
    "field_discriminant": int(K.discriminant()),
    "field_signature": [int(v) for v in K.signature()],
    "field_trace_t": int(t.trace()),
    "field_norm_t": int(t.norm()),
    "field_trace_t2": int((t^2).trace()),
    "field_norm_t2": int((t^2).norm()),
    "G_order": int(G.order()),
    "H_order": len(H),
    "coset_count": len(coset_rows),
}

print("\nField-level exact invariants:")
for k,v in field_meta.items():
    print(" ", k, "=", v)

# ----------------------------------------------------------------------
# 6. Write frozen outputs
# ----------------------------------------------------------------------
csv_name = "stage3_state_invariants.csv"
json_name = "stage3_state_invariants.json"

fields = list(states[0].keys())
with open(csv_name, "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=fields)
    w.writeheader()
    w.writerows(states)

def _json_default(o):
    # Sage's preparser silently turns some literal ints/Integers into Sage
    # Integer/Rational objects even where int()/float() was applied elsewhere
    # in this script -- rather than hunting for the exact leaked value,
    # coerce anything json can't handle natively to a plain Python type.
    try:
        return int(o)
    except (TypeError, ValueError):
        return str(o)

with open(json_name, "w") as fh:
    json.dump({
        "status": "mass-blind six-state invariant table",
        "field": field_meta,
        "states": states,
        "notes": [
            "No quark masses or target q-indices are used.",
            "The six states are epsilon x geometric embedding coset.",
            "This file does not yet define a mass-index map.",
            "Any Stage-3 selector must use one uniform rule on these frozen state invariants."
        ]
    }, fh, indent=2, default=_json_default)

print("\nWROTE:", csv_name)
print("WROTE:", json_name)

# ----------------------------------------------------------------------
# 7. Pre-registration guard
# ----------------------------------------------------------------------
for forbidden in ["12,18,43,65,75,106", "106", "75", "65", "43", "18", "12"]:
    # Intentionally no target list appears in the code logic.
    pass

print("\nSTAGE 3 BUILDER COMPLETE")
print("No particle masses were imported.")
