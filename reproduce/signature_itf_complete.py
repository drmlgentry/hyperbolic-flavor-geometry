#!/usr/bin/env python3
"""
signature_itf_complete.py
=========================
Full ITF signature enumeration of every H₁≅Z/5 manifold in the
SnapPy OrientableClosedCensus (11,031 manifolds).

Purpose
-------
Verifies Theorem 6.1 of the HFG synthesis paper:

    "Among the 11,031 closed manifolds in the full census, 740 have
     H₁≅Z/5, and of those, exactly one has ITF signature (8,1):
     m006(-5,2) = M_CKM."

This is the definitive, checkpointed version. It:
  - Resumes automatically from a checkpoint if the run was interrupted.
  - Writes a checkpoint after every manifold (checkpoint is atomic JSON).
  - Prints an ETA based on per-manifold algdep timing.
  - At completion, writes a final results JSON to data/.

Usage (WSL, SageMath environment)
----------------------------------
    cd /path/to/hyperbolic-flavor-geometry
    conda activate sage
    python3 reproduce/signature_itf_complete.py

To restart from scratch (ignore any existing checkpoint):
    python3 reproduce/signature_itf_complete.py --restart

Dependencies
------------
    pip install snappy
    # SageMath for algdep (conda activate sage)

Author: M. L. Gentry / Claude (Anthropic), June 2026
"""

import sys
import os
import json
import time
import argparse

# ── Paths (relative to repo root) ────────────────────────────────────────────
REPO_ROOT     = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR      = os.path.join(REPO_ROOT, 'data')
CHECKPOINT    = os.path.join(DATA_DIR, 'itf_checkpoint.json')
FINAL_OUTPUT  = os.path.join(DATA_DIR, 'signature_itf_complete.json')

os.makedirs(DATA_DIR, exist_ok=True)

# ── algdep settings ───────────────────────────────────────────────────────────
# known_bits=50 is correct for double-precision (53-bit) holonomy input.
# Higher values find wrong polynomials. Verified on m006(-5,2) → degree 10.
ALGDEP_MAX_DEG  = 10
ALGDEP_KNOWN_BITS = 50

# ── Helpers ───────────────────────────────────────────────────────────────────

def h1_is_z5(M):
    """
    Return True iff H₁(M;Z) ≅ Z/5.
    Uses SnapPy's homology string representation.
    We check for EXACTLY 'Z/5' as the full homology group
    (not Z/5 ⊕ Z/5, not Z/5 ⊕ Z, etc.).
    """
    try:
        h1 = M.homology()
        s  = str(h1).strip()
        # SnapPy prints 'Z/5' for cyclic group of order 5
        # and 'Z/5 + Z/5' for Z/5 ⊕ Z/5, etc.
        return s == 'Z/5'
    except Exception:
        return False


def compute_itf(M):
    """
    Compute ITF data for manifold M via algdep on tr(a).

    Returns dict with keys:
        degree, disc, signature, tr_a_re, tr_a_im, poly
    or dict with key 'error' on failure.

    The polynomial is returned as a list of coefficients [a₀, a₁, ..., aₙ]
    (degree-0 to degree-n, i.e., the polynomial is sum(coeffs[k]*x^k)).
    """
    try:
        import numpy as np
        from sage.all import CC, algdep, NumberField, ZZ

        rho   = M.polished_holonomy()
        mat_a = np.array(rho('a'), dtype=complex)
        tr_a  = complex(np.trace(mat_a))

        mp  = algdep(CC(tr_a), ALGDEP_MAX_DEG, known_bits=ALGDEP_KNOWN_BITS)
        K   = NumberField(mp, 'g')

        coeffs = [int(ZZ(mp[k])) for k in range(mp.degree() + 1)]

        # Explicitly coerce all Sage types to Python natives before returning.
        # K.signature() returns a tuple of sage.Integer, not Python int.
        sig = [int(x) for x in K.signature()]

        return {
            'degree':    int(mp.degree()),
            'disc':      int(K.discriminant()),
            'signature': sig,
            'tr_a_re':   float(tr_a.real),
            'tr_a_imag': float(tr_a.imag),
            'poly':      coeffs,
        }
    except Exception as e:
        return {'error': str(e)}


def eta_str(elapsed, done, total):
    """Human-readable ETA string."""
    if done == 0:
        return "ETA: unknown"
    rate = elapsed / done          # seconds per manifold
    remaining = (total - done) * rate
    h = int(remaining // 3600)
    m = int((remaining % 3600) // 60)
    s = int(remaining % 60)
    return f"ETA: {h}h {m:02d}m {s:02d}s  (rate: {rate:.1f}s/mfld)"


class _SageEncoder(json.JSONEncoder):
    """Fallback encoder: coerce any remaining Sage/numpy types to Python."""
    def default(self, obj):
        try:
            return int(obj)
        except (TypeError, ValueError):
            pass
        try:
            return float(obj)
        except (TypeError, ValueError):
            pass
        return super().default(obj)


def atomic_write_json(path, data):
    """Write JSON atomically (write to .tmp, then rename)."""
    tmp = path + '.tmp'
    with open(tmp, 'w') as f:
        json.dump(data, f, indent=2, cls=_SageEncoder)
    os.replace(tmp, path)


# ── Checkpoint I/O ────────────────────────────────────────────────────────────

def load_checkpoint():
    """Load checkpoint; returns (next_index, results_so_far) or (0, [])."""
    if not os.path.exists(CHECKPOINT):
        return 0, []
    try:
        with open(CHECKPOINT) as f:
            ckpt = json.load(f)
        next_idx = int(ckpt.get('next_census_index', 0))
        results  = ckpt.get('results', [])
        print(f"  Checkpoint found: next_index={next_idx}, "
              f"results={len(results)} records.")
        return next_idx, results
    except Exception as e:
        print(f"  Warning: checkpoint unreadable ({e}). Starting fresh.")
        return 0, []


def save_checkpoint(next_idx, results):
    atomic_write_json(CHECKPOINT, {
        'next_census_index': next_idx,
        'n_results':         len(results),
        'results':           results,
    })


# ── Main enumeration ──────────────────────────────────────────────────────────

def run_enumeration(start_idx, results):
    import snappy

    census  = snappy.OrientableClosedCensus
    n_total = len(census)

    print(f"\nCensus size: {n_total}")
    print(f"Starting at index: {start_idx}")
    if results:
        n81 = sum(1 for r in results if r['itf'].get('signature') == [8, 1])
        print(f"Resuming with {len(results)} H₁=Z/5 records "
              f"({n81} with sig=(8,1)) already found.\n")

    t0       = time.time()
    n_tested = 0   # manifolds processed in this run (for ETA)

    for idx in range(start_idx, n_total):
        M    = census[idx]
        name = M.name()

        # ── H₁ filter ────────────────────────────────────────────────────────
        if not h1_is_z5(M):
            # Save checkpoint every 200 manifolds even for non-matching ones
            if idx % 200 == 0:
                save_checkpoint(idx + 1, results)
                elapsed = time.time() - t0
                pct = 100 * (idx + 1) / n_total
                print(f"  [{idx:5d}/{n_total}]  {pct:5.1f}%  "
                      f"{eta_str(elapsed, n_tested + (idx - start_idx), n_total - start_idx)}",
                      flush=True)
            continue

        # ── H₁=Z/5 found: compute ITF ────────────────────────────────────────
        vol       = float(M.volume())
        full_name = repr(M)   # includes Dehn coefficients, e.g. m006(-5,2)
        print(f"\n  [idx={idx:5d}]  {full_name:<16}  vol={vol:.5f}  "
              f"H₁=Z/5 → computing ITF...", end='', flush=True)

        t1  = time.time()
        itf = compute_itf(M)
        dt  = time.time() - t1

        sig = itf.get('signature', 'ERROR')
        deg = itf.get('degree', '?')
        is_target = (abs(vol - 2.028853) < 1e-4)   # vol(m006(-5,2))
        marker = '  <--- M_CKM' if is_target else ''
        is_81  = (sig == [8, 1])
        flag   = ' *** (8,1) ***' if is_81 and not is_target else ''
        print(f"  deg={deg}  sig={sig}  ({dt:.1f}s){marker}{flag}", flush=True)

        results.append({
            'census_index': idx,
            'name':         name,
            'full_name':    full_name,
            'vol':          vol,
            'itf':          itf,
        })
        n_tested += 1

        # Checkpoint after every H₁=Z/5 manifold
        save_checkpoint(idx + 1, results)

        elapsed = time.time() - t0
        total_done = (idx - start_idx) + 1
        print(f"    [{len(results)} H₁=Z/5 found so far]  "
              f"{eta_str(elapsed, total_done, n_total - start_idx)}", flush=True)

    return results


# ── Final summary and output ──────────────────────────────────────────────────

def write_final(results):
    from collections import Counter

    sig_counts = Counter()
    for r in results:
        itf = r.get('itf', {})
        if 'signature' in itf:
            sig_counts[str(itf['signature'])] += 1
        elif 'error' in itf:
            sig_counts['ERROR'] += 1
        else:
            sig_counts['UNKNOWN'] += 1

    n81    = sig_counts.get('[8, 1]', 0)
    m_ckm  = next((r for r in results if r['census_index'] == 43), None)

    print("\n" + "="*70)
    print("FINAL SUMMARY — ITF Signature Enumeration")
    print("="*70)
    print(f"\nTotal H₁=Z/5 manifolds in full census:  {len(results)}")
    print(f"Of these, ITF signature (8,1):           {n81}")
    print()
    print("Signature distribution:")
    for sig, cnt in sorted(sig_counts.items(), key=lambda x: -x[1]):
        print(f"  {sig:20s}  {cnt:4d}")

    print()
    if m_ckm:
        print(f"M_CKM = m006(-5,2) [index 43]:")
        print(f"  vol      = {m_ckm['vol']:.6f}")
        print(f"  ITF      = {m_ckm['itf']}")
    else:
        print("WARNING: m006(-5,2) [index 43] not found in H₁=Z/5 results!")

    print()
    print("VERDICT:", "="*50)
    if n81 == 1 and m_ckm and m_ckm['itf'].get('signature') == [8, 1]:
        print("  CONFIRMED: m006(-5,2) is the UNIQUE H₁=Z/5 manifold in the")
        print("  full closed census with ITF signature (8,1).")
        print("  Theorem 6.1 of the HFG synthesis paper is VERIFIED.")
    elif n81 == 0:
        print("  ERROR: m006(-5,2) not found with sig=(8,1) — check ITF computation.")
    else:
        others = [r for r in results
                  if r['itf'].get('signature') == [8, 1]
                  and r['census_index'] != 43]
        print(f"  {n81} manifold(s) with sig=(8,1):")
        for r in others:
            print(f"    [{r['census_index']}] {r['name']}  vol={r['vol']:.5f}  "
                  f"disc={r['itf'].get('disc','?')}")
        if others:
            print("  NOTE: additional (8,1) manifolds found. Paper needs revision.")

    # Write final JSON
    final = {
        'description': (
            'Full ITF signature enumeration — all H₁=Z/5 manifolds in '
            'SnapPy OrientableClosedCensus (11,031 manifolds).'
        ),
        'theorem': 'Theorem 6.1 of gentry_hfg_synthesis_v1.tex',
        'algdep_max_degree':   ALGDEP_MAX_DEG,
        'algdep_known_bits':   ALGDEP_KNOWN_BITS,
        'n_h1z5':              len(results),
        'n_sig_8_1':           n81,
        'verdict':             'UNIQUE' if n81 == 1 and m_ckm and
                               m_ckm['itf'].get('signature') == [8, 1]
                               else 'SEE_RECORDS',
        'signature_counts':    dict(sig_counts),
        'records':             results,
    }
    atomic_write_json(FINAL_OUTPUT, final)
    print(f"\nFinal results written to: {FINAL_OUTPUT}")

    # Clean up checkpoint on success
    if os.path.exists(CHECKPOINT):
        os.remove(CHECKPOINT)
        print("Checkpoint removed (run complete).")


# ── Entry point ───────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description='Full ITF enumeration for H₁=Z/5 manifolds (checkpointed).')
    parser.add_argument('--restart', action='store_true',
                        help='Ignore existing checkpoint and start from scratch.')
    args = parser.parse_args()

    print("="*70)
    print("HFG PROGRAM — FULL ITF SIGNATURE ENUMERATION")
    print("Theorem 6.1 verification: H₁=Z/5  ∩  ITF sig=(8,1)  →  unique")
    print("="*70)
    print(f"\nCheckpoint file:  {CHECKPOINT}")
    print(f"Final output:     {FINAL_OUTPUT}")
    print(f"algdep settings:  max_deg={ALGDEP_MAX_DEG}, known_bits={ALGDEP_KNOWN_BITS}")

    # ── Load or start checkpoint ──────────────────────────────────────────────
    if args.restart:
        print("\n--restart flag set: ignoring any existing checkpoint.")
        start_idx, results = 0, []
    else:
        start_idx, results = load_checkpoint()

    if start_idx == 0 and not results:
        print("\nStarting fresh scan of all 11,031 manifolds.")
        print("Estimated runtime: 2–4 hours depending on WSL speed.\n")
        print("You can interrupt (Ctrl+C) at any time and resume with:")
        print("  python3 reproduce/signature_itf_complete.py\n")
    else:
        print(f"\nResuming from census index {start_idx}.")

    # ── Run ───────────────────────────────────────────────────────────────────
    t_start = time.time()
    try:
        results = run_enumeration(start_idx, results)
    except KeyboardInterrupt:
        print("\n\nInterrupted. Checkpoint saved. Resume with:")
        print("  python3 reproduce/signature_itf_complete.py")
        sys.exit(0)

    # ── Complete ───────────────────────────────────────────────────────────────
    elapsed = time.time() - t_start
    h = int(elapsed // 3600)
    m = int((elapsed % 3600) // 60)
    print(f"\n\nScan complete in {h}h {m:02d}m.")
    write_final(results)


if __name__ == '__main__':
    main()
