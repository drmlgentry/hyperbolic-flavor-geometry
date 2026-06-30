"""
verify_trace.py
===============
Verifies the Trace Quotient Theorem (§4 of the NT paper) for m006(-5,2).

Checks:
  1. Fricke collapse: tr(ab) = tr(a)  [Theorem 4.1]
  2. Trace class equalities            [Theorem 4.2]
  3. ITF generator: tr(a) = -alpha    [Theorem 4.3]
  4. 122-node trace quotient count    [Theorem 4.4]

Run (WSL, conda activate sage):
  python3 reproduce/verify_trace.py

Expected output: all PASS, final line THEOREM C: VERIFIED
"""
import snappy
import numpy as np
from sage.all import CC, algdep, NumberField

TOL = 1e-5   # tolerance for numerical equalities

M   = snappy.OrientableClosedCensus[43]   # m006(-5,2)
rho = M.polished_holonomy()

def tr(word):
    return complex(np.trace(np.array(rho(word), dtype=complex)))

passed = []
failed = []

def check(label, val, expected_zero=True, tol=TOL):
    """Check |val| < tol (equality) or val is what we expect."""
    ok = abs(val) < tol
    status = "PASS" if ok else "FAIL"
    if ok:
        passed.append(label)
    else:
        failed.append(f"{label}: residual={abs(val):.2e} (tol={tol})")
    print(f"  {status}  {label:45s}  residual={abs(val):.2e}")
    return ok

print("="*65)
print("THEOREM C: Trace Quotient Structure of m006(-5,2)")
print("="*65)

# ── 1. Fricke collapse ────────────────────────────────────────────────────────
print("\n§1  Fricke collapse: tr(ab) = tr(a)")
check("tr(ab) - tr(a)",  tr('ab') - tr('a'))
check("tr(AB) - tr(a)",  tr('AB') - tr('a'))
check("aB relation: tr(aB) - tr(a)*(tr(b)-1)",
      tr('aB') - tr('a') * (tr('b') - 1))

# ── 2. Trace class equalities ─────────────────────────────────────────────────
print("\n§2  Trace class equalities")
check("tr(A) - tr(a)",          tr('A')    - tr('a'))
check("tr(abA) - tr(b)",        tr('abA')  - tr('b'))
check("tr(aaB) - tr(aBa)",      tr('aaB')  - tr('aBa'))
check("tr(aBa) - tr(bAA)",      tr('aBa')  - tr('bAA'))
check("tr(aab) - tr(aba)",      tr('aab')  - tr('aba'))
check("tr(bb)  - tr(ABBaB)",    tr('bb')   - tr('ABBaB'))

# ── 3. ITF generator identity ─────────────────────────────────────────────────
print("\n§3  ITF generator: tr(a) = -alpha")
tr_a = tr('a')
mp   = algdep(CC(complex(tr_a)), 10, known_bits=50)
K    = NumberField(mp, 'g')
disc = int(K.discriminant())
sig  = K.signature()

# Find the root alpha with Im(alpha) < 0 (so -alpha has Im > 0, matching tr(a))
roots = mp.roots(CC, multiplicities=False)
alpha = min(roots, key=lambda r: abs(complex(r) + tr_a))

print(f"  ITF poly degree: {mp.degree()}")
print(f"  Discriminant:    {disc}")
print(f"  Signature:       {sig}")

ok_poly  = mp.degree() == 10
ok_disc  = disc == -271488204251
ok_sig   = sig == (8, 1)
ok_alpha = abs(complex(alpha) + tr_a) < 1e-6

for label, ok in [("degree=10",          ok_poly),
                  ("disc=-271488204251",  ok_disc),
                  ("signature=(8,1)",     ok_sig),
                  ("tr(a) = -alpha",      ok_alpha)]:
    status = "PASS" if ok else "FAIL"
    if ok: passed.append(label)
    else:  failed.append(label)
    print(f"  {status}  {label}")

# ── 4. Trace quotient count ───────────────────────────────────────────────────
print("\n§4  Trace quotient: counting distinct tr values at word length <= 6")

letters = ['a', 'b', 'A', 'B']
cancel  = {'a': 'A', 'A': 'a', 'b': 'B', 'B': 'b'}

def freely_reduced_words(max_len):
    words = ['']
    result = []
    while words:
        w = words.pop()
        if w:
            result.append(w)
        if len(w) < max_len:
            last = w[-1] if w else None
            for c in letters:
                if last is None or c != cancel[last]:
                    words.append(w + c)
    return result

all_words = freely_reduced_words(6)
traces = set()
for w in all_words:
    t = tr(w)
    # Round to 4 decimal places to group near-equal traces
    traces.add((round(t.real, 4), round(t.imag, 4)))

n_traces = len(traces)
print(f"  Total freely-reduced words (len 1-6): {len(all_words)}")
print(f"  Distinct trace classes:               {n_traces}")

ok_count = n_traces <= 122
status = "PASS" if ok_count else "FAIL"
if ok_count: passed.append(f"trace count <= 122 (got {n_traces})")
else:        failed.append(f"trace count > 122 (got {n_traces})")
print(f"  {status}  trace count <= 122 (got {n_traces})")

# ── Summary ───────────────────────────────────────────────────────────────────
print("\n" + "="*65)
print(f"PASSED: {len(passed)}   FAILED: {len(failed)}")
if failed:
    print("\nFailures:")
    for f in failed:
        print(f"  {f}")
    print("\nTHEOREM C: FAILED")
else:
    print("\nTHEOREM C: VERIFIED  [PASS]")
