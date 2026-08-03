#!/usr/bin/env python3
"""
signature_enum_test.py
======================
Out-of-sample validation of the arithmetic selection criterion for M_CKM.

HYPOTHESIS: m006(-5,2) is selected because it is the unique H1=Z/5
hyperbolic 3-manifold with ITF signature (8,1). This signature (8 real
places, 1 complex pair) geometrically explains suppressed CP violation.

TEST: Enumerate ALL H1=Z/5 manifolds in the full OrientableClosedCensus.
For each, compute the minimal polynomial of tr(a) (proxy for ITF) and its
signature. For those with sig=(8,1), run CKM fitness. For those without,
also record fitness. If the criterion is real, (8,1) manifolds should
cluster near CKM; non-(8,1) should not.

This is a POST-HOC HYPOTHESIS FORMED FROM THE FIRST 500 MANIFOLDS.
The full census is the held-out test. It can come back either way.

Run (WSL, conda activate sage):
  python3 reproduce/signature_enum_test.py > signature_enum_output.txt 2>&1 &

Author: Marvin L. Gentry / Claude (Anthropic)
Date: 2026-06-29
"""

import snappy
import numpy as np
from scipy.linalg import logm
import json
import time
import sys
from itertools import permutations as iperms

# ── CKM target ───────────────────────────────────────────────────────────────
PDG_CKM = np.array([[0.97435, 0.22500, 0.00369],
                    [0.22486, 0.97349, 0.04182],
                    [0.00857, 0.04110, 0.99917]])

PERMS = list(iperms(range(3)))
SIGMA_GRID = [0.30, 0.35, 0.40, 0.45, 0.50]

# Bank size for fitness evaluation of sig=(8,1) candidates
# 30k triples, same as census_null_test.py
BANK_SIZE   = 30_000
WORD_LENGTH = 6
SEED        = 42

# ── Holonomy axis / fitness ───────────────────────────────────────────────────

def get_axis(rho, word):
    try:
        mat = np.array(rho(word), dtype=complex)
        mat = mat / np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        x = float(np.real(L[0, 1] + L[1, 0])) / 2
        y = float(np.imag(L[1, 0] - L[0, 1])) / 2
        z = float(np.real(L[0, 0] - L[1, 1])) / 2
        v = np.array([x, y, z])
        n = np.linalg.norm(v)
        return v / n if n > 1e-10 else None
    except Exception:
        return None


def ckm_fitness_triple(axes, sigma):
    O = np.zeros((3, 3))
    for i in range(3):
        for j in range(3):
            ang = np.arccos(np.clip(abs(np.dot(axes[i], axes[j])), -1, 1))
            O[i, j] = np.exp(-ang**2 / (2 * sigma**2))
    Q, _ = np.linalg.qr(O)
    U = np.abs(Q)
    return min(np.sqrt(np.sum((U[:, list(p)] - PDG_CKM)**2)) for p in PERMS)


def best_fitness(rho, bank):
    """Best fitness over bank triples and sigma grid."""
    best = 1e9
    for triple in bank:
        axes = [get_axis(rho, w) for w in triple]
        if any(ax is None for ax in axes):
            continue
        for sigma in SIGMA_GRID:
            f = ckm_fitness_triple(axes, sigma)
            if f < best:
                best = f
    return best if best < 1e8 else None


# ── Word bank builder ─────────────────────────────────────────────────────────

def build_bank(size, length, seed):
    """
    Sample `size` freely-reduced word triples from {a,b,A,B}^<=length.
    Same construction as census_null_test.py / null_test.py.
    """
    rng = np.random.default_rng(seed)
    letters = ['a', 'b', 'A', 'B']
    cancel  = {'a': 'A', 'b': 'B', 'A': 'a', 'B': 'b'}

    def random_word(max_len):
        wlen = rng.integers(1, max_len + 1)
        w = []
        for _ in range(wlen):
            choices = [l for l in letters if (not w or l != cancel[w[-1]])]
            w.append(rng.choice(choices))
        return ''.join(w)

    bank = []
    while len(bank) < size:
        triple = [random_word(length) for _ in range(3)]
        bank.append(triple)
    return bank


# ── ITF signature via algdep on tr(a) ────────────────────────────────────────

def itf_signature(M):
    """
    Returns (degree, discriminant, signature, tr_a) for the minimal poly
    of tr(a) under the polished holonomy of manifold M.

    Exact replication of the original working Sage session:
      algdep(CC(complex(tr_a)), 10, known_bits=50)

    No loop. algdep returns the actual minimal polynomial (degree <= 10)
    regardless of the degree cap. known_bits=50 matches the real precision
    of the double-precision (53-bit) numpy complex input. Using known_bits
    higher than ~53 causes LLL to find wrong polynomials at this precision.

    Verified PASS on: m006(-5,2) deg=10 sig=[8,1], m206 deg=3 sig=[1,1],
                      m222 deg=7 sig=[5,1], m155 deg=10 sig=[0,5].
    """
    try:
        rho  = M.polished_holonomy()
        mat_a = np.array(rho('a'), dtype=complex)
        tr_a  = np.trace(mat_a)

        from sage.all import CC, algdep, NumberField
        mp = algdep(CC(complex(tr_a)), 10, known_bits=50)
        K  = NumberField(mp, 'g')
        return {
            'degree':    mp.degree(),
            'disc':      int(K.discriminant()),
            'signature': list(K.signature()),
            'tr_a_real': float(tr_a.real),
            'tr_a_imag': float(tr_a.imag),
        }
    except Exception as e:
        return {'error': str(e)}


# ── Phase 1: enumerate H1=Z/5 manifolds, compute ITF data ────────────────────

def phase1_enumerate():
    census = snappy.OrientableClosedCensus
    n_total = len(census)
    print(f"Phase 1: scanning {n_total} manifolds for H1=Z/5...", flush=True)

    h1z5 = []
    t0 = time.time()

    for idx in range(n_total):
        M = census[idx]
        try:
            h1 = M.homology()
            h1_str = str(h1)
        except Exception:
            continue

        if 'Z/5' not in h1_str:
            continue

        name = M.name()
        vol  = float(M.volume())
        print(f"  H1=Z/5 found: [{idx}] {name}  vol={vol:.4f}", flush=True)

        itf = itf_signature(M)
        rec = {
            'index': idx,
            'name':  name,
            'vol':   vol,
            'h1':    h1_str,
            'itf':   itf,
        }
        h1z5.append(rec)

        elapsed = time.time() - t0
        print(f"    ITF: {itf}  (elapsed {elapsed:.1f}s)", flush=True)
        sys.stdout.flush()

    print(f"\nPhase 1 complete: found {len(h1z5)} H1=Z/5 manifolds "
          f"in {time.time()-t0:.1f}s", flush=True)
    return h1z5


# ── Phase 2: fitness for sig=(8,1) manifolds ─────────────────────────────────

def phase2_fitness(h1z5_records):
    sig81 = [r for r in h1z5_records
             if r['itf'] and 'signature' in r['itf']
             and r['itf']['signature'] == [8, 1]]

    print(f"\nPhase 2: found {len(sig81)} manifolds with sig=(8,1). "
          f"Running CKM fitness on each...", flush=True)

    if not sig81:
        print("  None found — criterion predicts m006 is unique.", flush=True)
        return sig81

    # Build word bank once
    print(f"  Building word bank ({BANK_SIZE} triples, len<={WORD_LENGTH})...",
          flush=True)
    bank = build_bank(BANK_SIZE, WORD_LENGTH, SEED)
    print("  Bank ready.", flush=True)

    census = snappy.OrientableClosedCensus

    for rec in sig81:
        idx  = rec['index']
        name = rec['name']
        M    = census[idx]
        print(f"\n  Fitness test: [{idx}] {name}  sig=(8,1)...", flush=True)
        t0 = time.time()
        try:
            rho = M.polished_holonomy()
            f   = best_fitness(rho, bank)
            rec['ckm_fitness'] = f
            target_flag = "(TARGET M_CKM)" if idx == 43 else ""
            print(f"    fitness={f:.6f}  {target_flag}  ({time.time()-t0:.1f}s)",
                  flush=True)
        except Exception as e:
            rec['ckm_fitness'] = None
            rec['fitness_error'] = str(e)
            print(f"    ERROR: {e}", flush=True)

    return sig81


# ── Phase 3: spot-check best non-(8,1) fitness ───────────────────────────────

def phase3_nontarget_fitness(h1z5_records):
    """
    Run fitness on the non-(8,1) manifolds too, so we can directly compare.
    Use a smaller bank (5k) for speed — we just want rough comparisons.
    """
    non81 = [r for r in h1z5_records
             if r['itf'] and 'signature' in r['itf']
             and r['itf']['signature'] != [8, 1]]

    print(f"\nPhase 3: fitness spot-check on {len(non81)} non-(8,1) manifolds "
          f"(5k bank)...", flush=True)

    bank_small = build_bank(5_000, WORD_LENGTH, SEED + 1)
    census = snappy.OrientableClosedCensus

    for rec in non81:
        idx  = rec['index']
        name = rec['name']
        M    = census[idx]
        sig  = rec['itf']['signature']
        try:
            rho = M.polished_holonomy()
            f   = best_fitness(rho, bank_small)
            rec['ckm_fitness_approx'] = f
            print(f"  [{idx}] {name}  sig={sig}  fitness~{f:.6f}", flush=True)
        except Exception as e:
            rec['ckm_fitness_approx'] = None
            print(f"  [{idx}] {name}  ERROR: {e}", flush=True)

    return non81


# ── Summary / verdict ─────────────────────────────────────────────────────────

def print_summary(h1z5_records):
    print("\n" + "="*70)
    print("SIGNATURE ENUMERATION SUMMARY")
    print("="*70)

    sig81 = [r for r in h1z5_records
             if r['itf'] and 'signature' in r['itf']
             and r['itf']['signature'] == [8, 1]]

    non81 = [r for r in h1z5_records
             if r['itf'] and 'signature' in r['itf']
             and r['itf']['signature'] != [8, 1]]

    print(f"\nTotal H1=Z/5 manifolds found: {len(h1z5_records)}")
    print(f"  Signature (8,1):     {len(sig81)}")
    print(f"  Other signatures:    {len(non81)}")
    print(f"  ITF error/unknown:   "
          f"{len(h1z5_records) - len(sig81) - len(non81)}")

    # sig=(8,1) table
    print("\nSIG=(8,1) MANIFOLDS (full fitness test):")
    print(f"  {'Index':>6}  {'Name':<10}  {'Vol':>7}  {'Fitness':>10}  Note")
    print(f"  {'-'*6}  {'-'*10}  {'-'*7}  {'-'*10}  ----")
    for r in sorted(sig81, key=lambda x: x.get('ckm_fitness') or 1):
        f    = r.get('ckm_fitness')
        fstr = f"{f:.6f}" if f is not None else "ERROR"
        note = "<-- M_CKM TARGET" if r['index'] == 43 else ""
        print(f"  {r['index']:>6}  {r['name']:<10}  {r['vol']:>7.4f}  {fstr:>10}  {note}")

    # non-(8,1) fitness (approximate)
    print("\nNON-(8,1) MANIFOLDS (approx fitness, 5k bank):")
    print(f"  {'Index':>6}  {'Name':<10}  {'Sig':<10}  {'Fitness~':>10}")
    print(f"  {'-'*6}  {'-'*10}  {'-'*10}  {'-'*10}")
    for r in sorted(non81, key=lambda x: x.get('ckm_fitness_approx') or 1):
        f    = r.get('ckm_fitness_approx')
        fstr = f"{f:.6f}" if f is not None else "ERROR"
        sig  = r['itf']['signature'] if r['itf'] else "?"
        print(f"  {r['index']:>6}  {r['name']:<10}  {str(sig):<10}  {fstr:>10}")

    # Verdict
    print("\n" + "="*70)
    print("VERDICT")
    print("="*70)

    if not sig81:
        print("UNIQUE: m006(-5,2) is the ONLY H1=Z/5 manifold with sig=(8,1)")
        print("  in the full census. Uniqueness claim is strengthened.")
    else:
        fitnesses_81 = [r['ckm_fitness'] for r in sig81
                        if r.get('ckm_fitness') is not None]
        fitnesses_non = [r.get('ckm_fitness_approx') for r in non81
                         if r.get('ckm_fitness_approx') is not None]

        if fitnesses_81 and fitnesses_non:
            mean81  = np.mean(fitnesses_81)
            mean_n  = np.mean(fitnesses_non)
            print(f"  Mean fitness  sig=(8,1): {mean81:.6f}  (n={len(fitnesses_81)})")
            print(f"  Mean fitness  other sig:  {mean_n:.6f}  (n={len(fitnesses_non)})")
            if mean81 < mean_n:
                print("  SUPPORTS criterion: sig=(8,1) manifolds fit CKM better.")
            else:
                print("  REFUTES criterion: no fitness advantage for sig=(8,1).")
        else:
            print("  Insufficient data for comparison.")

    m006 = next((r for r in sig81 if r['index'] == 43), None)
    if m006 and m006.get('ckm_fitness'):
        better = [r for r in sig81
                  if r.get('ckm_fitness') and r['ckm_fitness'] < m006['ckm_fitness']
                  and r['index'] != 43]
        print(f"\n  Among sig=(8,1) manifolds, m006 fitness = {m006['ckm_fitness']:.6f}")
        print(f"  Sig=(8,1) manifolds with better fitness: {len(better)}")
        for r in better:
            print(f"    [{r['index']}] {r['name']}: {r['ckm_fitness']:.6f}")


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    print("="*70)
    print("SIGNATURE ENUMERATION TEST")
    print("HFG Program — Out-of-sample validation")
    print("Hypothesis: H1=Z/5 AND ITF sig=(8,1) selects M_CKM")
    print("="*70)
    print(f"Full OrientableClosedCensus, all manifolds.", flush=True)
    print(f"Word bank: {BANK_SIZE} triples, length<={WORD_LENGTH}, seed={SEED}", flush=True)
    print(f"Sigma grid: {SIGMA_GRID}", flush=True)
    print()

    # Phase 1: find all H1=Z/5, compute ITF signature
    h1z5 = phase1_enumerate()

    # Phase 2: full fitness on sig=(8,1)
    phase2_fitness(h1z5)

    # Phase 3: approx fitness on non-(8,1) for comparison
    phase3_nontarget_fitness(h1z5)

    # Summary
    print_summary(h1z5)

    # Save JSON
    outfile = "data/signature_enumeration_june29.json"

    class SageEncoder(json.JSONEncoder):
        """Convert SageMath Integer/float types to native Python."""
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

    def sanitize(obj):
        """Recursively convert SageMath types in nested dicts/lists."""
        if isinstance(obj, dict):
            return {k: sanitize(v) for k, v in obj.items()}
        if isinstance(obj, list):
            return [sanitize(v) for v in obj]
        try:
            # catches sage Integer, RealNumber, etc.
            if hasattr(obj, 'parent'):
                return int(obj) if obj in obj.parent() else float(obj)
        except Exception:
            pass
        return obj

    with open(outfile, 'w') as f:
        json.dump(sanitize({
            'description': 'Signature enumeration test — all H1=Z/5 manifolds, full census',
            'hypothesis':  'H1=Z/5 AND ITF sig=(8,1) selects M_CKM',
            'bank_size':   BANK_SIZE,
            'word_length': WORD_LENGTH,
            'seed':        SEED,
            'sigma_grid':  SIGMA_GRID,
            'n_found':     len(h1z5),
            'records':     h1z5,
        }), f, indent=2, cls=SageEncoder)
    print(f"\nResults saved to {outfile}", flush=True)
    print("Done.", flush=True)


if __name__ == '__main__':
    main()
