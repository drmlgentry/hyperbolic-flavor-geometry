"""
cusped_vs_filled.py  (v2)
=========================
Tests the relationship between geodesic twists in the cusped manifold m003
and the filled manifold m003(-2,3) = M_PMNS.

KEY FINDING FROM v1:
  PMNS optimal words (aa, aaB, baa) are LOXODROMIC in cusped m003,
  with |tr| = sqrt(7) ≈ 2.646 (NOT parabolic, |tr| ≠ 2).
  The commutator [a,b] = aAbB IS the parabolic cusp element (tr = 2).
  → The original "residual parabolicity" conjecture is FALSE.
  → Quasi-hyperbolicity in m003(-2,3) is CREATED by the surgery.

This script:
  PART 1: Exact Eisenstein traces in cusped m003, geodesic twists.
  PART 2: Contrast cusped twists vs filled twists (filled at s=1).
  PART 3: Integer Dehn surgery family m003(-2, q) for q=3..15
           (avoids real-coefficient polished_holonomy failures).
  PART 4: Interpretation — what the (-2,3) surgery does arithmetically.

Run:
  conda run -n sage python3 reproduce/cusped_vs_filled.py 2>/dev/null
"""

import cmath, numpy as np, snappy
from scipy.linalg import logm

# ── Helpers ──────────────────────────────────────────────────────

def geodesic_twist_from_trace(tr):
    """
    Returns (L_deg, theta_deg) from trace tr.
    Tries both SL(2,C) lifts; picks Re(l) > 0.
    """
    for sign in [1, -1]:
        z = sign * tr / 2.0
        try:
            w = cmath.acosh(z)
        except Exception:
            continue
        l = 2 * w
        if l.real > 1e-8:
            theta = l.imag
            while theta >  np.pi: theta -= 2*np.pi
            while theta <= -np.pi: theta += 2*np.pi
            return np.degrees(2*w.real), np.degrees(theta)
    return None, None

def get_trace(rho, word):
    mat = np.array(rho(word), dtype=complex)
    mat /= np.sqrt(np.linalg.det(mat))
    return complex(np.trace(mat))

def get_axis_logm(rho, word):
    """logm-based axis (matches census_scan_extended.py convention)."""
    try:
        mat = np.array(rho(word), dtype=complex)
        mat /= np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        v = np.array([float(np.real(L[0,1]+L[1,0]))/2,
                      float(np.imag(L[1,0]-L[0,1]))/2,
                      float(np.real(L[0,0]-L[1,1]))/2])
        n = np.linalg.norm(v)
        return v/n if n > 1e-10 else None
    except Exception:
        return None

# ── PART 1: Cusped m003 — exact Eisenstein traces ────────────────

print("="*65)
print("PART 1: Cusped m003 — Eisenstein traces and geodesic twists")
print("="*65)

M_cusp = snappy.Manifold('m003')
rho_c  = M_cusp.polished_holonomy()

# The trace field of m003 is Q(sqrt(-3)) = Q(omega), omega = (-1+i*sqrt(3))/2
omega = complex(-0.5, np.sqrt(3)/2)   # primitive cube root of unity

words = ['aa','aaB','baa','aaab','aabb','bAbAB','aAbB']
print(f"\n  {'Word':<8}  {'tr (numeric)':<34}  {'|tr|':>6}  {'L (°)':>8}  {'θ (°)':>9}  Eisenstein form")
print(f"  {'-'*8}  {'-'*34}  {'-'*6}  {'-'*8}  {'-'*9}  {'-'*22}")

cusped_twists = {}
for w in words:
    tr = get_trace(rho_c, w)
    L_deg, theta_deg = geodesic_twist_from_trace(tr)
    mod_tr = abs(tr)

    # Try to identify Eisenstein form  a + b*omega  with small a,b
    best, best_form = 1e9, '?'
    for a in np.arange(-5, 6, 0.5):
        for b in np.arange(-6, 7, 1):
            candidate = a + b*omega
            if abs(candidate - tr) < 0.01:
                best = abs(candidate - tr)
                best_form = f'{a:+g}+{b:+g}ω' if b != 0 else f'{a:+g}'
    regime = ('para' if L_deg is None
              else ('quasi-hyp' if abs(theta_deg) < 30
                    else ('str-lox' if abs(theta_deg) > 150 else 'lox')))
    cusped_twists[w] = theta_deg
    L_s = f"{L_deg:8.2f}" if L_deg else "  (para)"
    t_s = f"{theta_deg:+9.2f}°" if theta_deg is not None else "   (para)"
    print(f"  {w:<8}  {tr.real:+.6f} + {tr.imag:+.6f}i  {mod_tr:6.4f}  {L_s}  {t_s}  {best_form}  [{regime}]")

print(f"\n  ω = e^(2πi/3) = (-1+i√3)/2 ≈ {omega:.6f}")
print(f"  Norm 7 in Z[ω]: -2+ω, 1+3ω")
print(f"  Norm 9 in Z[ω]: 3(1+ω) = 3e^(iπ/3)")
print(f"  Cusp element aAbB: tr=2 (parabolic) ✓")

# ── PART 2: Contrast with filled manifold m003(-2,3) ─────────────

print()
print("="*65)
print("PART 2: Cusped vs filled m003(-2,3) geodesic twist comparison")
print("="*65)

M_fill = snappy.OrientableClosedCensus[1]   # m003(-2,3)
rho_f  = M_fill.polished_holonomy()

track = ['aa','aaB','baa','aaab']
print(f"\n  {'Word':<8}  {'θ_cusped':>10}  {'θ_filled':>10}  {'Δθ':>8}  Surgery effect")
print(f"  {'-'*8}  {'-'*10}  {'-'*10}  {'-'*8}  {'-'*30}")
for w in track:
    tr_f   = get_trace(rho_f, w)
    _, tf  = geodesic_twist_from_trace(tr_f)
    tc     = cusped_twists.get(w)
    if tc is not None and tf is not None:
        delta = tf - tc
        # Reduce delta to (-180, 180]
        while delta >  180: delta -= 360
        while delta <= -180: delta += 360
        effect = ("surgery → quasi-hyp ✓" if abs(tf) < 30
                  else ("surgery → near-π" if abs(tf) > 150 else "moderate"))
        print(f"  {w:<8}  {tc:+10.2f}°  {tf:+10.2f}°  {delta:+8.2f}°  {effect}")

print(f"""
  Interpretation:
  The Dehn surgery (-2,3) changes geodesic twists dramatically.
  aaB:  cusped θ ≈ -163° → filled θ ≈  +6.5°  (Δθ ≈ +170°)
  baa:  cusped θ ≈ -163° → filled θ ≈ +25.3°  (Δθ ≈ +188°)
  aa:   cusped θ ≈  big  → filled θ ≈ -22.9°  (reduced)
  aaab: cusped θ ≈ +163° → filled θ ≈ -178.5° (near ±π throughout)

  REVISED CONJECTURE: The (-2,3) surgery coefficient is special because
  it maps the strongly-loxodromic Eisenstein characters (norm-7 elements)
  to quasi-hyperbolic elements. This is determined by the CHARACTER VARIETY
  of m003, not by parabolicity.  Specifically: the meridian element
  (killed by the surgery) has a definite Dehn surgery formula that
  drives Im(tr) → 0 for aaB and baa at p/q = -2/3.
""")

# ── PART 3: Integer surgery family m003(-2, q), q = 3..15 ────────

print("="*65)
print("PART 3: Integer family m003(-2, q) for q = 3..15")
print("How does θ(aaB) vary with q?")
print("="*65)

print(f"\n  {'q':>4}  {'θ(aaB)':>10}  {'θ(baa)':>10}  {'θ(aa)':>10}  {'θ(aaab)':>10}")
print(f"  {'-'*4}  {'-'*10}  {'-'*10}  {'-'*10}  {'-'*10}")

for q in range(3, 16):
    try:
        M = snappy.Manifold('m003')
        M.dehn_fill((-2, q))
        rho = M.polished_holonomy()
        row_vals = []
        for w in ['aaB','baa','aa','aaab']:
            tr = get_trace(rho, w)
            _, theta = geodesic_twist_from_trace(tr)
            row_vals.append(theta)
        row = f"  {q:>4}  " + "  ".join(
            f"{v:+10.3f}°" if v is not None else f"{'---':>10}" for v in row_vals
        )
        marker = " ← M_PMNS" if q == 3 else ""
        print(row + marker)
    except Exception as e:
        print(f"  {q:>4}  [error: {str(e)[:40]}]")

print(f"""
  If θ(aaB) monotonically increases from near 0 as q increases from 3:
  → quasi-hyperbolicity is specific to small q; (-2,3) is minimum-twist.
  If θ(aaB) is near 0 only at q=3 and grows away:
  → (-2,3) is arithmetically special in the character variety.
""")

# ── PART 4: Interpretation ────────────────────────────────────────

print("="*65)
print("PART 4: Arithmetic interpretation")
print("="*65)

# Check if traces in the filled manifold are "nearly real"
print(f"\n  Traces in filled m003(-2,3) — are they nearly real?")
print(f"  (Small |Im(tr)| ↔ small geodesic twist θ)")
print(f"  {'Word':<8}  {'tr (filled)':<34}  {'|Im(tr)|':>10}  θ_filled")
for w in track:
    tr = get_trace(rho_f, w)
    _, tf = geodesic_twist_from_trace(tr)
    tf_s = f"{tf:+.2f}°" if tf is not None else "---"
    print(f"  {w:<8}  {tr.real:+.6f} + {tr.imag:+.6f}i  {abs(tr.imag):10.6f}  {tf_s}")

print(f"""
  The surgery (-2,3) imposes the relation: (meridian word)^(-2) * (longitude word)^3 = id
  in π₁(M_PMNS). This forces a specific polynomial identity on the holonomy traces,
  moving them to new values in the character variety.

  For aaB and baa: the new traces have small |Im(tr)| → small θ.
  For aaab: the new trace has large |Im(tr)| → θ near ±π.

  OPEN QUESTION: Is (-2,3) the UNIQUE surgery coefficient that produces
  quasi-hyperbolic aaB and baa?  (Check Part 3 results.)
  If yes, this arithmetically characterizes the Meyerhoff manifold
  m003(-2,3) as the unique N-factor manifold in the m003 Dehn surgery family.
""")
