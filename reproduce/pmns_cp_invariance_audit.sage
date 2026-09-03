# Invariance audit for the HFG leptonic CP phase formula, BEFORE any
# census/significance testing: is
#   delta_HFG = (pi + phi(aaB) + phi(baa)) mod 2pi,   phi(g) = Im log lambda(g)
#   (lambda(g) = the "dominant" eigenvalue of rho(g))
# actually well-defined -- invariant under (1) conjugating the whole
# representation, (2) the word-inverse convention, (3) an SL2 central
# sign twist rho -> -rho, and (4) the generator-basis convention used to
# build rho in the first place (the exact class of bug already found once
# this session, in the PMNS ITF certificate work)?

from sage.all import *
import snappy

BITS_PREC = 150  # matches the manuscript's own stated precision
FG_ARGS_EXPLICIT = [True, False, True, False]

def banner(t):
    print("\n" + "=" * 78)
    print(t)
    print("=" * 78)

CC = ComplexField(BITS_PREC)

def phi_of(M):
    """phi(g) = Im log(dominant eigenvalue of M), dominant = larger |.|."""
    ev = M.eigenvalues()
    ev = [CC(e) for e in ev]
    ev_sorted = sorted(ev, key=lambda e: -abs(e))
    lam = ev_sorted[0]
    return CC(lam.log()).imag(), lam, ev

banner("Build the certified holonomy two ways: default vs explicit FG_ARGS")
M = snappy.Manifold("m003")
M.dehn_fill((-2, 3))

G_default = M.fundamental_group()
print("default filled relators:", tuple(str(r) for r in G_default.relators()))

rho_default = M.polished_holonomy(bits_prec=BITS_PREC)
rho_explicit = M.polished_holonomy(bits_prec=BITS_PREC,
                                    fundamental_group_args=FG_ARGS_EXPLICIT)

print("default rho relators:  ", tuple(str(r) for r in rho_default.relators()))
print("explicit rho relators: ", tuple(str(r) for r in rho_explicit.relators()))
same_basis = (tuple(str(r) for r in rho_default.relators())
              == tuple(str(r) for r in rho_explicit.relators()))
print("default and explicit FG_ARGS give the SAME presentation?", same_basis)

words = ["aaB", "baa"]

banner("STEP 1: phi(w) under default vs explicit generator basis")
results = {}
for label, rho in [("default", rho_default), ("explicit_FG_ARGS", rho_explicit)]:
    print()
    print("--", label, "--")
    for w in words:
        Mw = rho(w)
        Mw_cc = matrix(CC, [[CC(Mw[0,0]), CC(Mw[0,1])], [CC(Mw[1,0]), CC(Mw[1,1])]])
        phi, lam, ev = phi_of(Mw_cc)
        phi_deg = phi * 180 / CC.pi()
        print(f"  phi({w}) = {phi_deg} deg   (eigenvalues: {ev})")
        results[(label, w)] = (phi_deg, lam, Mw_cc)

banner("STEP 2: reproduce delta_HFG under BOTH conventions")
for label in ["default", "explicit_FG_ARGS"]:
    phi_aaB, _, _ = results[(label, "aaB")]
    phi_baa, _, _ = results[(label, "baa")]
    phi_aaB_f = float(phi_aaB.real())
    phi_baa_f = float(phi_baa.real())
    delta_deg = 180.0 + phi_aaB_f + phi_baa_f
    import math
    delta_deg_mod = delta_deg - 360.0 * math.floor(delta_deg / 360.0)
    print(f"[{label}] phi(aaB)={phi_aaB_f} deg, phi(baa)={phi_baa_f} deg,",
          f" delta_HFG = 180+phi(aaB)+phi(baa) = {delta_deg} deg,",
          f" mod 360 = {delta_deg_mod} deg")
print("(manuscript claims 195.91 deg)")

banner("STEP 3: word-inverse convention -- phi(w^-1) vs phi(w)")
for label, rho in [("explicit_FG_ARGS", rho_explicit)]:
    for w in words:
        winv = "".join({"a":"A","A":"a","b":"B","B":"b"}[c] for c in reversed(w))
        Mw = rho(w); Mwinv = rho(winv)
        Mw_cc = matrix(CC, [[CC(Mw[0,0]), CC(Mw[0,1])], [CC(Mw[1,0]), CC(Mw[1,1])]])
        Mwinv_cc = matrix(CC, [[CC(Mwinv[0,0]), CC(Mwinv[0,1])], [CC(Mwinv[1,0]), CC(Mwinv[1,1])]])
        phi_w, lam_w, _ = phi_of(Mw_cc)
        phi_winv, lam_winv, _ = phi_of(Mwinv_cc)
        print(f"  w={w}  winv={winv}")
        print(f"    phi(w)    = {phi_w} deg   dominant eigval = {lam_w}")
        print(f"    phi(winv) = {phi_winv} deg   dominant eigval = {lam_winv}")
        print(f"    phi(w)+phi(winv) = {phi_w+phi_winv} deg  (0 if equal-and-opposite)")
        print(f"    phi(w)-phi(winv) = {phi_w-phi_winv} deg  (0 if equal, i.e. NOT antisymmetric)")

banner("STEP 4: central sign twist rho(w) -> -rho(w) -- does phi shift by 180deg?")
for w in words:
    Mw = rho_explicit(w)
    Mw_cc = matrix(CC, [[CC(Mw[0,0]), CC(Mw[0,1])], [CC(Mw[1,0]), CC(Mw[1,1])]])
    phi_plus, lam_plus, _ = phi_of(Mw_cc)
    phi_minus, lam_minus, _ = phi_of(-Mw_cc)
    shift = (phi_minus - phi_plus)
    print(f"  w={w}: phi(+rho(w)) = {phi_plus} deg,  phi(-rho(w)) = {phi_minus} deg,",
          f" shift = {shift} deg")

banner("STEP 5: conjugation invariance -- rho -> g rho g^-1 for fixed g")
g = matrix(CC, [[CC(1.3, 0.2), CC(0.4,-0.1)], [CC(0.1,0.05), CC(1.0,0.0)]])
# normalize det to 1 for a genuine SL2 conjugation
detg = g.det()
g = g / detg.sqrt()
ginv = g.inverse()
for w in words:
    Mw = rho_explicit(w)
    Mw_cc = matrix(CC, [[CC(Mw[0,0]), CC(Mw[0,1])], [CC(Mw[1,0]), CC(Mw[1,1])]])
    Mw_conj = g * Mw_cc * ginv
    phi_orig, _, _ = phi_of(Mw_cc)
    phi_conj, _, _ = phi_of(Mw_conj)
    print(f"  w={w}: phi(rho(w)) = {phi_orig} deg,  phi(g*rho(w)*g^-1) = {phi_conj} deg,",
          f" diff = {phi_orig-phi_conj} deg")

print()
print("CP INVARIANCE AUDIT: SEE ABOVE FOR EACH RESULT")
print("SAGE_EXIT=0")
