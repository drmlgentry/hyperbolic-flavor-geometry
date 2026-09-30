"""
m006_axis_gauge_conjugation_sweep.py
=====================================
The decisive test: whether the HFG CKM Borel/QR construction's axis
directions are basis/frame-dependent, run on the REAL polished holonomy
of M_CKM = m006(-5,2) (CLAIMS_REGISTER.md entry 1) and the REAL CKM word
triple {aaB, AbA, AAb} (`gentry-ckm-plb-v3.tex` line 210, entry 20 of this
register) -- not generic random matrices, not a fabricated triple.

Uses the EXACT `get_axis` function from `hyperbolic-flavor-scan/hfg_reproduce.py`
(the actual construction `pmns_borel`/`ckm_gaussian` call), copied verbatim
below rather than reimplemented, so this tests the real construction and
not a reinterpretation of it:

    def get_axis(rho, word):
        mat = np.array(rho(word), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        x = float(np.real(L[0,1]+L[1,0]))/2
        y = float(np.imag(L[1,0]-L[0,1]))/2
        z = float(np.real(L[0,0]-L[1,1]))/2
        v = np.array([x,y,z])
        n = np.linalg.norm(v)
        return v/n if n>1e-10 else None

Note this takes specific real/imaginary PARTS of specific matrix-log
entries in the ambient representation's fixed basis -- it is not built
from a bilinear or Hermitian invariant of the traceless log, so there is
no a priori reason for it to be covariant under conjugation, unlike a
trace-form pairing. This script measures, rather than assumes, what
happens under conjugation.

For the base representation and for each of N random C in SL2(C) (full
group, not restricted to SU(2)), conjugates ALL THREE matrices by the
SAME C, recomputes get_axis for each, and tracks:
  - trace of each generator (must be invariant)
  - the pairwise angle arccos(|n_i . n_j|) from get_axis's own real
    3-vectors (the actual quantity theta_ij = arccos(n_hat_i . n_hat_j)
    the construction uses, per `gentry-ckm-plb-v3.tex` eq. for theta_ij)

Exit status: 0 (measurement, not a certificate of a predetermined outcome).
"""
import sys

import numpy as np
from scipy.linalg import logm
import snappy

WORDS = ['aaB', 'AbA', 'AAb']


def get_axis(rho, word):
    """Verbatim copy of hyperbolic-flavor-scan/hfg_reproduce.py's get_axis."""
    mat = np.array(rho(word), dtype=complex)
    mat = mat / np.sqrt(np.linalg.det(mat))
    L = logm(mat)
    x = float(np.real(L[0, 1] + L[1, 0])) / 2
    y = float(np.imag(L[1, 0] - L[0, 1])) / 2
    z = float(np.real(L[0, 0] - L[1, 1])) / 2
    v = np.array([x, y, z])
    n = np.linalg.norm(v)
    return v / n if n > 1e-10 else None


def angle(n1, n2):
    c = abs(float(np.dot(n1, n2)))
    c = min(1.0, max(-1.0, c))
    return np.degrees(np.arccos(c))


def killing_pairing(mat_w, mat_v):
    """Conjugation-invariant candidate: normalized trace-form pairing of
    the traceless parts X_w, X_v of the (det-1-normalized) matrices,
    K = tr(X_w X_v) / sqrt(tr(X_w^2) tr(X_v^2)). tr(X_w X_v) is invariant
    under simultaneous conjugation by any C in SL2(C): tr(CX_wC^-1 CX_vC^-1)
    = tr(C X_w X_v C^-1) = tr(X_w X_v)."""
    Xw = mat_w - (np.trace(mat_w) / 2) * np.eye(2)
    Xv = mat_v - (np.trace(mat_v) / 2) * np.eye(2)
    num = np.trace(Xw @ Xv)
    den = np.sqrt(np.trace(Xw @ Xw) * np.trace(Xv @ Xv))
    return num / den


def random_sl2c():
    M = (np.random.randn(2, 2) + 1j * np.random.randn(2, 2))
    d = np.linalg.det(M)
    return M / np.sqrt(d)


def banner(s):
    print("\n" + "=" * 78)
    print(s)
    print("=" * 78)


def main():
    banner("Loading M_CKM = m006(-5,2), real polished holonomy")
    M = snappy.Manifold('m006')
    M.dehn_fill((-5, 2))
    print("volume:", M.volume(), " homology:", M.homology())
    rho = M.polished_holonomy(bits_prec=212)

    mats = {}
    for w in WORDS:
        m = np.array(rho(w), dtype=complex)
        m = m / np.sqrt(np.linalg.det(m))
        mats[w] = m
    for w in WORDS:
        print(f"tr(rho({w})) = {np.trace(mats[w])}")

    pairs = [(WORDS[0], WORDS[1]), (WORDS[0], WORDS[2]), (WORDS[1], WORDS[2])]

    banner("get_axis (the REAL construction) at the base frame")
    axes = {w: get_axis(lambda word, w=w: mats[w], w) for w in WORDS}
    for w in WORDS:
        print(f"  n_hat({w}) = {axes[w]}")
    print("\nBase pairwise angles theta_ij = arccos(|n_i . n_j|):")
    base_ang = {}
    for w1, w2 in pairs:
        a = angle(axes[w1], axes[w2])
        base_ang[(w1, w2)] = a
        print(f"  theta({w1},{w2}) = {a:.4f} deg")

    print("\nBase Killing pairings K_ij (candidate conjugation-invariant replacement):")
    base_K = {}
    for w1, w2 in pairs:
        k = killing_pairing(mats[w1], mats[w2])
        base_K[(w1, w2)] = k
        print(f"  K({w1},{w2}) = {k}")

    banner("Conjugation sweep: rho -> C rho C^-1, SAME random C in SL2(C) for all three words")
    np.random.seed(20260929)
    N = 30
    trace_maxdrift = 0.0
    K_maxdrift = {p: 0.0 for p in pairs}
    ang_min = {p: 1e9 for p in pairs}
    ang_max = {p: -1e9 for p in pairs}
    none_count = 0

    for trial in range(N):
        C = random_sl2c()
        Cinv = np.linalg.inv(C)
        conj = {w: C @ mats[w] @ Cinv for w in WORDS}
        for w in WORDS:
            trace_maxdrift = max(trace_maxdrift, abs(np.trace(conj[w]) - np.trace(mats[w])))
        for w1, w2 in pairs:
            k = killing_pairing(conj[w1], conj[w2])
            K_maxdrift[(w1, w2)] = max(K_maxdrift[(w1, w2)], abs(k - base_K[(w1, w2)]))
        conj_axes = {}
        bad = False
        for w in WORDS:
            a = get_axis(lambda word, w=w: conj[w], w)
            if a is None:
                bad = True
                none_count += 1
            conj_axes[w] = a
        if bad:
            continue
        for w1, w2 in pairs:
            a = angle(conj_axes[w1], conj_axes[w2])
            ang_min[(w1, w2)] = min(ang_min[(w1, w2)], a)
            ang_max[(w1, w2)] = max(ang_max[(w1, w2)], a)

    print(f"\nmax |trace drift| over {N} random SL2(C) conjugations: {trace_maxdrift:.3e}")
    print("max |Killing pairing drift| over the same conjugations (should be ~0):")
    for p in pairs:
        print(f"  {p}: {K_maxdrift[p]:.3e}")
    print(f"\nNone-axis occurrences (near-parabolic under conjugation): {none_count}")
    print("\nget_axis Euclidean angle RANGE swept under conjugation (base value in parens):")
    for p in pairs:
        print(f"  theta{p}: [{ang_min[p]:.2f}, {ang_max[p]:.2f}] deg   (base: {base_ang[p]:.2f})")

    print("\nPY_EXIT=0")
    return 0


if __name__ in ("__main__", "sage.all"):
    sys.exit(main())
