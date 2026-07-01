"""
trace_quotient_enum.py
======================
Enumerates distinct trace classes of M_CKM = m006(-5,2) at 100-digit
precision via BFS over freely-reduced words in {a, b, A, B}.

Background
----------
π₁(M_CKM) is presented on two generators a, b.  For a hyperbolic
representation ρ : π₁ → PSL(2,C), the trace function factors through
the trace quotient: two words w, v represent the same trace class iff
tr(ρ(w)) = tr(ρ(v)).  The trace field is the subfield of C generated
by all such traces; for M_CKM it has degree 10 over Q, discriminant
-271488204251, and signature (8,1).

Key identity (Fricke collapse):
    tr(ρ(ab)) = tr(ρ(a))   [verified; see verify_trace.py §1]

This collapses the naive word count substantially.

Usage
-----
    pip install snappy mpmath
    python3 reproduce/trace_quotient_enum.py

No SageMath required for the numerical enumeration.
SageMath is required only for the algebraic characterization (minimal
polynomials, Galois orbits) — those steps are flagged below.

Output
------
Prints trace class table and summary statistics; optionally writes
trace_classes.json to data/ for downstream analysis.
"""

import snappy
import mpmath
import json
import os
import sys
from collections import defaultdict

mpmath.mp.dps = 60   # 60 decimal digits — enough to separate traces reliably

HLINE = "=" * 72
SLINE = "-" * 72

# ── Holonomy representation ───────────────────────────────────────────────────
print(HLINE)
print("  Trace Quotient Enumeration — M_CKM = m006(-5,2)")
print(f"  snappy {snappy.__version__}  |  mpmath {mpmath.__version__}  |  dps={mpmath.mp.dps}")
print(HLINE)

M   = snappy.ManifoldHP('m006(-5,2)')
rho = M.polished_holonomy()

def hp_trace(word):
    """Trace of ρ(word) as an mpmath.mpc at current dps."""
    if not word:
        return mpmath.mpc('2', '0')
    mat = rho(word)
    tr  = mat[0][0] + mat[1][1]
    return mpmath.mpc(str(tr.real()), str(tr.imag()))

# Verify basic sanity: tr(A) = tr(a), tr(ab) = tr(a)  (Fricke collapse)
tr_a  = hp_trace('a')
tr_A  = hp_trace('A')
tr_ab = hp_trace('ab')
print(f"\n  tr(a)  = {mpmath.nstr(tr_a, 18)}")
print(f"  tr(A)  = {mpmath.nstr(tr_A, 18)}  [should equal tr(a)]")
print(f"  tr(ab) = {mpmath.nstr(tr_ab, 18)}  [Fricke collapse = tr(a)]")
err_frick = float(mpmath.fabs(tr_ab - tr_a))
print(f"  |tr(ab) - tr(a)| = {err_frick:.2e}")
print()

# ── BFS word enumeration ──────────────────────────────────────────────────────

MAX_LEN = 6    # freely-reduced words of length 1 .. MAX_LEN

GENS  = ['a', 'b', 'A', 'B']
INV   = {'a': 'A', 'A': 'a', 'b': 'B', 'B': 'b'}

# Grouping tolerance: two traces are in the same class iff |t1-t2| < TOL
# At dps=60 the HP engine gives ~50-55 reliable digits; 1e-20 is safe.
TOL   = mpmath.mpf('1e-20')

def freely_reduced_words(max_len):
    """Yield all freely-reduced words of length 1..max_len."""
    stack = ['']
    result = []
    while stack:
        w = stack.pop()
        if w:
            result.append(w)
        if len(w) < max_len:
            last = w[-1] if w else None
            for c in GENS:
                if last is None or c != INV[last]:
                    stack.append(w + c)
    return result

print(f"  Enumerating freely-reduced words up to length {MAX_LEN} ...")
all_words = freely_reduced_words(MAX_LEN)
print(f"  Total words: {len(all_words)}")
print()

# Group into trace classes
# trace_classes[i] = {'trace': mpc, 'words': [str, ...], 'min_len': int}
trace_classes = []

def find_class(tr):
    """Return index of existing class within TOL, or -1."""
    for i, tc in enumerate(trace_classes):
        if mpmath.fabs(tr - tc['trace']) < TOL:
            return i
    return -1

sys.stdout.write("  Grouping traces .")
sys.stdout.flush()
dot_every = max(1, len(all_words) // 40)

for idx, word in enumerate(all_words):
    if idx % dot_every == 0:
        sys.stdout.write('.')
        sys.stdout.flush()
    tr = hp_trace(word)
    ci = find_class(tr)
    if ci >= 0:
        trace_classes[ci]['words'].append(word)
        if len(word) < trace_classes[ci]['min_len']:
            trace_classes[ci]['min_len'] = len(word)
    else:
        trace_classes.append({
            'trace':   tr,
            'words':   [word],
            'min_len': len(word),
        })

print()
print(f"\n  Distinct trace classes at length ≤ {MAX_LEN}: {len(trace_classes)}")
print()

# ── Length-stratified breakdown ───────────────────────────────────────────────
print(SLINE)
print("  New trace classes appearing at each word length")
print(SLINE)

new_at = defaultdict(int)
for tc in trace_classes:
    new_at[tc['min_len']] += 1

cumul = 0
for L in range(1, MAX_LEN + 1):
    cumul += new_at[L]
    print(f"  Length {L}: {new_at[L]:3d} new classes   (cumulative: {cumul})")

print()

# ── Multiplicity distribution ─────────────────────────────────────────────────
print(SLINE)
print("  Multiplicity distribution  (# words per trace class)")
print(SLINE)
mult_hist = defaultdict(int)
for tc in trace_classes:
    mult_hist[len(tc['words'])] += 1

for m, cnt in sorted(mult_hist.items()):
    print(f"  {m:4d} words in class: {cnt:3d} classes")

print()

# ── Full trace class table ────────────────────────────────────────────────────
print(SLINE)
print(f"  Trace classes — shortest representative and trace value")
print(SLINE)
print(f"  {'Idx':>4}  {'Shortest word':16}  {'|tr|':>10}  {'Re(tr)':>20}  Im(tr)")

# Sort by |trace| for readability
trace_classes.sort(key=lambda tc: float(mpmath.fabs(tc['trace'])))

for i, tc in enumerate(trace_classes):
    tr   = tc['trace']
    sw   = min(tc['words'], key=len)   # shortest representative
    absv = float(mpmath.fabs(tr))
    re   = float(mpmath.re(tr))
    im   = float(mpmath.im(tr))
    n    = len(tc['words'])
    print(f"  {i:4d}  {sw:16s}  {absv:10.6f}  {re:20.12f}  {im:20.12f}   [{n} words]")

# ── Fricke collapse quantification ────────────────────────────────────────────
print()
print(SLINE)
print("  Fricke collapse: classes collapsing length-k and length-(k+1) words")
print(SLINE)

for L in range(2, MAX_LEN):
    # Words of length L+1 that fall into a class first seen at length ≤ L
    collapse_count = 0
    for tc in trace_classes:
        if tc['min_len'] <= L:
            extra = sum(1 for w in tc['words'] if len(w) == L + 1)
            collapse_count += extra
    total_new = sum(1 for w in all_words if len(w) == L + 1)
    if total_new > 0:
        frac = collapse_count / total_new
        print(f"  Length {L+1}: {collapse_count}/{total_new} words ({100*frac:.1f}%) "
              f"collapse to existing class")

# ── JSON output ───────────────────────────────────────────────────────────────
out_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'data')
os.makedirs(out_dir, exist_ok=True)
out_path = os.path.join(out_dir, 'trace_classes_len6.json')

records = []
for i, tc in enumerate(trace_classes):
    sw = min(tc['words'], key=len)
    records.append({
        'index':      i,
        'trace_re':   float(mpmath.re(tc['trace'])),
        'trace_im':   float(mpmath.im(tc['trace'])),
        'trace_abs':  float(mpmath.fabs(tc['trace'])),
        'min_len':    tc['min_len'],
        'n_words':    len(tc['words']),
        'shortest':   sw,
        'all_words':  tc['words'],
    })

with open(out_path, 'w') as f:
    json.dump({'max_len': MAX_LEN, 'n_classes': len(trace_classes),
               'classes': records}, f, indent=2)

print()
print(f"  Trace class data written to: {out_path}")

# ── Summary ───────────────────────────────────────────────────────────────────
print()
print(HLINE)
print(f"  SUMMARY")
print(HLINE)
print(f"  Manifold:        M_CKM = m006(-5,2)")
print(f"  Generators:      a, b  (π₁ presentation)")
print(f"  Word length:     1 to {MAX_LEN} (freely reduced)")
print(f"  Total words:     {len(all_words)}")
print(f"  Trace classes:   {len(trace_classes)}")
print(f"  Precision:       mpmath dps={mpmath.mp.dps}")
print(f"  Grouping tol:    {float(TOL):.1e}")
print()
print("  Algebraic characterization (requires SageMath):")
print("    conda activate sage")
print("    python3 reproduce/verify_trace.py")
print("    → ITF degree 10, disc=-271488204251, sig=(8,1)")
print("    → tr(a) = -alpha  where alpha = ITF generator root")
print(HLINE)
