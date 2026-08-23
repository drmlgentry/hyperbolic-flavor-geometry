# stage3_enrich_state_invariants.sage
#
# PURPOSE
# -------
# Extend the mass-blind six-state table (stage3_build_state_invariants.sage)
# with genuinely NEW, representation-level invariants: traces of the actual
# holonomy generators tr(a), tr(b), plus the already-established peripheral
# traces tr(mu), tr(lambda), tr(s). The bare cusp root (and its powers/abs/
# arg -- the content of the first builder) turned out to carry no independent
# information beyond one complex number; this script adds real new content.
#
# A REAL SUBTLETY DISCOVERED WHILE BUILDING THIS (not assumed, not glossed
# over): the "upper/real/lower" embedding labels were originally fixed via
# the CUSP SHAPE (g=identity assigned to "upper" because it reproduces the
# actual SnapPy geometric cusp shape, verified to ~1e-16 in Stage 2). There
# is no a priori reason this SAME labeling automatically aligns with "which
# embedding reproduces the geometric REPRESENTATION's trace values" for a
# DIFFERENT algebraic quantity like tr(a) -- and it does NOT, here. Checked
# directly: applying g=identity to the abstract quantity tau_a = t^2+1 (found
# via PARI algdep + explicit field isomorphism, both reproducible below) gives
# r_+^2+1, which does NOT match the actual geometric tr(a) (confirmed to 90+
# digits). The coset rep that DOES match is g_lower = (1,2,3)(4,5,6). This
# script explicitly discovers and applies that correction rather than
# assuming embedding labels transfer naively between different invariants --
# a naive per-embedding evaluation would have silently mislabeled the table.
#
# Also established (forced by geometry, not numerical coincidence): tr(mu),
# tr(lambda), tr(s) are EXACTLY rational (+-2) -- peripheral curves are
# parabolic in any complete hyperbolic structure, and rationals are fixed by
# every embedding, so these three do NOT vary across upper/real/lower. They
# vary only by spin (epsilon), via the already-established chi character.
# Since chi(a)=1 but chi(b)=0 (Stage 3A), epsilon flips the SIGN of tr(a) but
# leaves tr(b) UNCHANGED between the two spin lifts -- an asymmetry that
# follows directly from chi, not an assumption.
#
# NO QUARK MASSES OR TARGET q-INDICES APPEAR ANYWHERE IN THIS SCRIPT.
#
# Output:
#   stage3_enriched_state_invariants.csv
#   stage3_enriched_state_invariants.json
#
# Run:
#   sage stage3_enrich_state_invariants.sage
# (requires snappy + polished_holonomy, i.e. run inside the Sage/SnapPy env)

import snappy
import json, csv

R.<x> = PolynomialRing(QQ)
f = x^3 + 2*x + 1
K.<t> = NumberField(f)
L, iota = K.galois_closure('z', map=True)
Grp = L.galois_group()
it = iota(t)
H = [g for g in Grp if g(it) == it]

CC = ComplexField(300)
phi_L = L.complex_embeddings(prec=300)[0]

print("="*80)
print("HFG STAGE 3 -- ENRICHED SIX-STATE INVARIANT TABLE")
print("="*80)

# ----------------------------------------------------------------------
# 1. Recover the three embedding states exactly as in the base builder
# ----------------------------------------------------------------------
unused = list(Grp)
cosets = []
while unused:
    g = unused[0]
    C = [g*h for h in H]
    for c in C:
        if c in unused:
            unused.remove(c)
    cosets.append((g, phi_L(g(it))))

def embed_label(zc):
    if abs(zc.imag()) < CC(1e-80):
        return "real"
    return "upper" if zc.imag() > 0 else "lower"

state_g = {}
state_root = {}
for g, alpha in cosets:
    lab = embed_label(alpha)
    state_g[lab] = g
    state_root[lab] = alpha

print("\nCoset reps by embedding label (matches Stage 1/2/3A convention):")
for name in ["upper", "real", "lower"]:
    print(f"  {name:6s}: g={state_g[name]}   root={state_root[name]}")

# ----------------------------------------------------------------------
# 2. Geometric holonomy: traces of a, b, mu, lambda, s at high precision
# ----------------------------------------------------------------------
M = snappy.Manifold('m006')
Gh = M.polished_holonomy(bits_prec=300)
tr_a_geo = CC(Gh.SL2C('a').trace())
tr_b_geo = CC(Gh.SL2C('b').trace())
tr_mu_geo = CC(Gh.SL2C('Abb').trace())     # mu, confirmed against G.meridian() earlier
tr_lam_geo = CC(Gh.SL2C('AAbA').trace())   # lambda, confirmed against G.longitude() earlier

print("\nGeometric holonomy traces (300-bit precision):")
print("  tr(a)      =", tr_a_geo)
print("  tr(b)      =", tr_b_geo)
print("  tr(mu)     =", tr_mu_geo)
print("  tr(lambda) =", tr_lam_geo)

assert abs(tr_mu_geo - 2) < CC(1e-60), "tr(mu) is not exactly +2 -- geometry assumption violated"
assert abs(tr_lam_geo + 2) < CC(1e-60), "tr(lambda) is not exactly -2 -- geometry assumption violated"
print("  (confirmed: tr(mu)=+2, tr(lambda)=-2 exactly -- peripheral, parabolic, rational)")

# ----------------------------------------------------------------------
# 3. Recognize tr(a) as an exact element of K via PARI algdep
# ----------------------------------------------------------------------
pari.set_real_precision(90)
dep_poly_coeffs = pari.algdep(pari(tr_a_geo), 3)
print("\nalgdep(tr(a), degree<=3) =", dep_poly_coeffs)

Rq.<y> = QQ[]
f2 = Rq(list(reversed(dep_poly_coeffs.Vec())))
f2 = f2 / f2.leading_coefficient()
K2.<u> = NumberField(f2)
print("f2 =", f2, "  disc(f2) =", f2.discriminant(), "  disc(K) =", K.discriminant())
assert f2.discriminant() == K.discriminant() or K.is_isomorphic(K2), \
    "tr(a)'s field does not match the cusp field K -- unexpected, stop"

isoms = K2.embeddings(K)
assert len(isoms) == 1, "expected exactly one isomorphism (K has trivial automorphism group)"
tau_a_K = isoms[0](u)          # tau_a as an EXACT element of K, in terms of t
print("tau_a (tr(a)'s abstract value, as element of K) =", tau_a_K)

tau_a_L = iota(tau_a_K)        # embed into L

# ----------------------------------------------------------------------
# 4. Find which coset rep g0 reproduces the geometric tr(a) -- CHECKED,
#    not assumed. Corrects for the mismatch documented above.
# ----------------------------------------------------------------------
g0 = None
for name, g in state_g.items():
    val = phi_L(g(tau_a_L))
    diff = abs(val - tr_a_geo)
    print(f"  g_{name}(tau_a) matches tr(a)_geometric?  diff={float(diff):.3e}")
    if diff < CC(1e-60):
        g0 = g
        g0_name = name

assert g0 is not None, "no coset rep reproduces tr(a)_geometric -- correction failed"
print(f"\nCorrection found: g0 = g_{g0_name} = {g0}")

tau_a_corrected = g0(tau_a_L)   # exact element of L, g=identity now gives the geometric value

# ----------------------------------------------------------------------
# 5. Build tr(a), tr(b) at all three embedding states, both spin lifts
# ----------------------------------------------------------------------
tr_a_by_state = {name: phi_L(g(tau_a_corrected)) for name, g in state_g.items()}

print("\ntr(a) at each embedding state (epsilon=+1 reference lift):")
for name in ["upper", "real", "lower"]:
    print(f"  {name:6s}: {tr_a_by_state[name]}")

sanity = abs(tr_a_by_state["upper"] - tr_a_geo)
assert sanity < CC(1e-60), "sanity check failed: corrected upper state does not match geometric tr(a)"
print(f"\nSanity check (corrected 'upper' state == actual geometric tr(a)): diff={float(sanity):.3e}")

# ----------------------------------------------------------------------
# 6. Assemble the six states with all invariants
# ----------------------------------------------------------------------
# chi(a)=1, chi(b)=0, chi(mu)=chi(lambda)=chi(s)=1 (established Stage 3A):
# epsilon=-1 flips sign exactly where chi is nonzero.
chi_a, chi_b, chi_mu, chi_lambda, chi_s = 1, 0, 1, 1, 1

rows = []
sid = 0
for eps in [1, -1]:
    for name in ["upper", "real", "lower"]:
        tr_a = tr_a_by_state[name] * ((-1) ** (chi_a if eps == -1 else 0))
        tr_b = tr_a_by_state[name] + 1   # tr(b)=tr(a)+1 exact, chi(b)=0 so no flip
        tr_mu = 2 * ((-1) ** (chi_mu if eps == -1 else 0))
        tr_lambda = -2 * ((-1) ** (chi_lambda if eps == -1 else 0))
        tr_s = 2 * ((-1) ** (chi_s if eps == -1 else 0))
        rows.append({
            "state_id": sid,
            "epsilon": eps,
            "embedding": name,
            "tr_a_re": float(tr_a.real()), "tr_a_im": float(tr_a.imag()),
            "tr_b_re": float(tr_b.real()), "tr_b_im": float(tr_b.imag()),
            "tr_mu": int(tr_mu),
            "tr_lambda": int(tr_lambda),
            "tr_s": int(tr_s),
        })
        sid += 1

print("\nFinal enriched six-state table:")
for r in rows:
    print(f"  id={r['state_id']} eps={r['epsilon']:+d} {r['embedding']:6s}"
          f"  tr(a)={r['tr_a_re']:.4f}{r['tr_a_im']:+.4f}i"
          f"  tr(b)={r['tr_b_re']:.4f}{r['tr_b_im']:+.4f}i"
          f"  tr(mu)={r['tr_mu']:+d} tr(lam)={r['tr_lambda']:+d} tr(s)={r['tr_s']:+d}")

# ----------------------------------------------------------------------
# 7. Write frozen outputs
# ----------------------------------------------------------------------
csv_name = "stage3_enriched_state_invariants.csv"
json_name = "stage3_enriched_state_invariants.json"

fields = list(rows[0].keys())
with open(csv_name, "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=fields)
    w.writeheader()
    w.writerows(rows)

with open(json_name, "w") as fh:
    json.dump({
        "status": "mass-blind enriched six-state invariant table",
        "notes": [
            "No quark masses or target q-indices are used.",
            "tr(a),tr(b) vary genuinely across embedding states -- new information,",
            "not a recoding of the bare cusp root.",
            "tr(mu),tr(lambda),tr(s) are exactly rational, hence embedding-invariant;",
            "they vary only by spin (epsilon), via chi(mu)=chi(lambda)=chi(s)=1.",
            "The upper/real/lower <-> geometric-trace correction (g0) is derived and",
            "checked in this script, not assumed.",
        ],
        "states": rows,
    }, fh, indent=2, default=lambda o: str(o))

print("\nWROTE:", csv_name)
print("WROTE:", json_name)
print("\nSTAGE 3 ENRICHMENT COMPLETE. No particle masses were imported.")
