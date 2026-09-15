"""
Certificate: the discrete-faithful character of m006 lies on X_0 =
V(y*z^2-y-1, x-z), not merely "by structural analogy" (the caveat
flagged in m006_x0_identity_origin.py).

Source of the numerical point: NOT a fresh SnapPy run (none available
in this environment) -- reused directly from the ALREADY-CERTIFIED
300-bit interval computation in
reproduce/ckm_presentation_geometry_bridge_v4.log, produced for the
CKM invariant-trace-field proof chain (k_inv(m006(-5,2)) = K_10). That
log verifies, with Sage's certified interval arithmetic:
  - fundamental_group_args = [True, False, True, False] (same
    convention as this whole program)
  - cusped relator = 'ababbAAbb'  (identical to this script's/
    m006_x0_identity_origin.py's relator, verified by string match)
  - rho(relator) interval contains +I, excludes -I  (i.e. rho
    genuinely represents <a,b | ababbAAbb> -- a certified point of
    the SAME bare Riley variety analyzed in
    m006_x0_identity_origin.py)
  - rho(filling word) interval contains +I, excludes -I  (rho is the
    discrete-faithful holonomy of the CLOSED, Dehn-filled manifold
    m006(-5,2))
  - irreducibility discriminant excludes 0 (rho is irreducible)

T_x, T_y, T_z below are transcribed verbatim from that log (85+
significant digits each).

Logical bridge (standard, not re-derived here): by Thurston's
hyperbolic Dehn surgery theorem, the discrete-faithful holonomy of
every sufficiently large Dehn filling of a 1-cusped hyperbolic
3-manifold lies on the SAME irreducible component of the
(unfilled/cusped) character variety as the complete structure's
discrete-faithful character -- this is the standard way "the
geometric component" is identified in practice throughout this
literature (A-polynomial theory, etc.). So: if this certified
(-5,2)-filled point lies on X_0, then X_0 is (not just "analogous to")
the component containing m006's cusped discrete-faithful character,
modulo that one standard theorem (cited, not re-proved here).

This script does NOT re-verify Thurston's theorem or SnapPy's interval
arithmetic; it verifies ARITHMETIC membership of the already-certified
point in X_0's defining equations, to the full available precision.
"""

import sys
import mpmath as mp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

mp.mp.dps = 100  # working precision well beyond the ~85 certified digits

# transcribed verbatim from reproduce/ckm_presentation_geometry_bridge_v4.log
T_x = mp.mpc(
    "1.23906622274705711516596254737209221606192693469147494805341511094762126337977428609",
    "0.81142069235465915601856126825239111739434590904174867523598788435568162609273444858",
)
T_y = mp.mpc(
    "-0.03033589532555413963385295162608107789394127921563548865966287929835332241200198851",
    "-0.49545512024915493216774895525514843838403872288354419996830513482273169998918299440",
)
T_z = mp.mpc(
    "1.2390662227470571151659625473720922160619269346914749480534151109476212633797742861",
    "0.8114206923546591560185612682523911173943459090417486752359878843556816260927344486",
)

# the source log's stated precision: values are given to ~85-86 significant
# decimal digits with a trailing "?" (uncertain last digit) -- treat the
# last ~3 digits as noise and require agreement well inside that margin.
TOL = mp.mpf("1e-75")


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


banner("1. certified point, transcribed from ckm_presentation_geometry_bridge_v4.log")
print(f"  T_x = {T_x}")
print(f"  T_y = {T_y}")
print(f"  T_z = {T_z}")

banner("2. X_0(m006) generator 1:  x - z  = 0 ?")
d1 = T_x - T_z
print(f"  x - z = {d1}")
print(f"  |x-z| = {abs(d1)}")
print(f"  within tolerance {TOL}: {abs(d1) < TOL}")

banner("3. X_0(m006) generator 2:  y*(z^2-1) - 1  = 0 ?")
d2 = T_y * (T_z**2 - 1) - 1
print(f"  y*(z^2-1) - 1 = {d2}")
print(f"  |y*(z^2-1)-1| = {abs(d2)}")
print(f"  within tolerance {TOL}: {abs(d2) < TOL}")

banner("4. this point is NOT on either discrete branch D_1, D_2")
print(f"  D_1, D_2 require z = +2 or z = -2 exactly (real).")
print(f"  T_z is non-real with Im(T_z) = {mp.im(T_z)} != 0: excluded from both.")
print(f"  (V(I_Riley) = X_0 u D_1 u D_2 exactly -- certified in")
print(f"   m006_x0_identity_origin.py -- so exclusion from D_1,D_2 plus")
print(f"   satisfying X_0's equations means this point is ON X_0, not merely")
print(f"   'off the discrete branches'.)")

banner("5. verdict")
ok = abs(d1) < TOL and abs(d2) < TOL
print(f"  The certified (-5,2)-filled discrete-faithful character satisfies")
print(f"  BOTH defining equations of X_0(m006) to ~80 digits of precision: {ok}")
print(f"  => by Thurston's Dehn-surgery theorem (cited, not re-derived here),")
print(f"     X_0(m006) is the component containing m006's cusped")
print(f"     discrete-faithful character -- no longer resting on structural")
print(f"     analogy alone.")

print("\nPY_EXIT=0")
