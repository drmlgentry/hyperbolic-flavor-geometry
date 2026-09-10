"""
Stage 3.3: with group-theoretic conjugacy now exactly ruled out (stage
3.2) as the explanation for the trace-equal/homology-inverse pattern,
ask a sharper, more data-grounded question first, before searching for
an algebraic mechanism from scratch: does the correlation found by the
stage-1 enrichment test (squared-trace collision <-> homology
inversion) sharpen further under the SIGNED trace relation?

The four known pairs all satisfy tr(w)=tr(w') EXACTLY (never
tr(w)=-tr(w')), while [w]=-[w'] always. This script tests that pattern
against the WHOLE frozen atlas (not just the four already-known
collision pairs), using data already computed and validated:
  - m003_word_atlas.csv: tr_re, tr_im (signed trace, not just tr2)
  - m003_per_filling_characters.json: validated per-filling character
    tables (same method already cross-checked against the independently
    Sage-verified (-2,3) result)

For every atlas word pair, classifies:
  - homology relation: S (same class), I (inverse), O (other)
  - signed trace relation: EQ (tr(u)=tr(v) exactly), NEG (tr(u)=-tr(v)
    exactly), OTHER (neither)
and cross-tabulates. This directly extends the stage-1 squared-trace
enrichment test to the signed case, using only data already validated
this session -- no new representation-theoretic machinery.
"""
import csv
import json
from collections import defaultdict

ATLAS_DIR = "/mnt/c/dev/hyperbolic-flavor-geometry/reproduce"
TOL = 1e-6  # atlas was computed at 300-bit precision; this is generous

chars = json.load(open(f"{ATLAS_DIR}/m003_per_filling_characters.json"))

words_exp = defaultdict(dict)     # filling -> word -> (ea, eb)
words_trace = defaultdict(dict)   # filling -> word -> complex trace
with open(f"{ATLAS_DIR}/m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        fname = row["filling"]
        words_exp[fname][row["word"]] = (int(row["exp_a"]), int(row["exp_b"]))
        words_trace[fname][row["word"]] = complex(float(row["tr_re"]), float(row["tr_im"]))

pairs_by_filling = defaultdict(list)
with open(f"{ATLAS_DIR}/m003_pair_atlas.csv") as f:
    for row in csv.DictReader(f):
        pairs_by_filling[row["filling"]].append((row["u"], row["v"]))


def negate(vec, invariants):
    out = []
    for v, m in zip(vec, invariants):
        out.append(-v if m == 0 else (-v) % m)
    return tuple(out)


def norm(vec, invariants):
    return tuple(v if m == 0 else v % m for v, m in zip(vec, invariants))


grand = defaultdict(int)
per_filling_summary = []

for filling, cdata in chars.items():
    invariants = cdata["invariants"]
    table = cdata["table"]
    exps = words_exp[filling]
    traces = words_trace[filling]

    def chi(word):
        ea, eb = exps.get(word, (None, None))
        if ea is None:
            return None
        v = table.get(f"{ea},{eb}")
        return tuple(v) if v is not None else None

    counts = defaultdict(int)
    n_pairs_used = 0
    for u, v in pairs_by_filling[filling]:
        cu, cv = chi(u), chi(v)
        tu, tv = traces.get(u), traces.get(v)
        if cu is None or cv is None or tu is None or tv is None:
            continue
        n_pairs_used += 1
        cu_n, cv_n = norm(cu, invariants), norm(cv, invariants)
        if cu_n == cv_n:
            hrel = "S"
        elif cu_n == negate(cv_n, invariants):
            hrel = "I"
        else:
            hrel = "O"

        if abs(tu - tv) < TOL:
            trel = "EQ"
        elif abs(tu + tv) < TOL:
            trel = "NEG"
        else:
            trel = "OTHER"

        key = f"{hrel}_{trel}"
        counts[key] += 1
        grand[key] += 1

    per_filling_summary.append((filling, invariants, n_pairs_used, dict(counts)))
    print(f"{filling:16s} invariants={invariants}  n_pairs={n_pairs_used}  {dict(counts)}")

print()
print("=" * 78)
print("GRAND TABLE (pooled across all 13 fillings)")
print("=" * 78)
for hrel in ("S", "I", "O"):
    row = {trel: grand.get(f"{hrel}_{trel}", 0) for trel in ("EQ", "NEG", "OTHER")}
    total = sum(row.values())
    print(f"  homology={hrel:5s}  EQ={row['EQ']:5d}  NEG={row['NEG']:5d}  "
          f"OTHER={row['OTHER']:6d}  (total {total})")

n_I_EQ = grand.get("I_EQ", 0)
n_I_NEG = grand.get("I_NEG", 0)
n_I_OTHER = grand.get("I_OTHER", 0)
n_I = n_I_EQ + n_I_NEG + n_I_OTHER
print()
print(f"Among homology-INVERSE pairs (n={n_I}): "
      f"EQ={n_I_EQ} ({100*n_I_EQ/n_I:.2f}%)  "
      f"NEG={n_I_NEG} ({100*n_I_NEG/n_I:.2f}%)  "
      f"OTHER={n_I_OTHER} ({100*n_I_OTHER/n_I:.2f}%)")

n_S_EQ = grand.get("S_EQ", 0)
n_S = n_S_EQ + grand.get("S_NEG", 0) + grand.get("S_OTHER", 0)
print(f"Among homology-SAME pairs (n={n_S}): "
      f"EQ={n_S_EQ} ({100*n_S_EQ/n_S:.2f}%)" if n_S else "no homology-SAME pairs found")

with open(f"{ATLAS_DIR}/m003_stage3p3_correlation_results.json", "w") as f:
    json.dump({"per_filling": per_filling_summary, "grand_table": dict(grand)}, f, indent=2, default=str)

print()
print("EXIT=0")
