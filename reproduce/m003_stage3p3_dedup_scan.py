"""
Stage 3.3, properly structured (redo of the flawed first pass, which
pooled 13 fillings into one statistic, conflated numerical candidates
with exact identities, and didn't handle the chi=0 / tau=0 degeneracies).

Step 1 of the pipeline:
  atlas scan -> candidate signed collisions -> DEDUPLICATE by distinct
  word-pair (not per-filling occurrence) -> [next: exact reduction].

The primary structural unit is the distinct word pair {u,v} (99 choose
2 = 4851 of them, same across all 13 fillings since it's the same word
list). For each, record AT WHICH of the 13 fillings the NUMERICAL
signed trace relation (EQ: tau_u=tau_v, NEG: tau_u=-tau_v, both within
tolerance) holds. A pair holding at ALL (or nearly all) 13 fillings is
a strong candidate for a genuine X_0-wide identity (like the three
already-known universal ones); a pair holding at only 1 filling is a
strong candidate for a filling-specific fact (like B/Abb, which is
(-2,3)-specific only). This distinguishes the two cases BEFORE
spending any exact-certification effort, and avoids counting the same
underlying identity 13 times as if it were 13 independent samples.
"""
import csv
from collections import defaultdict

ATLAS_DIR = "/mnt/c/dev/hyperbolic-flavor-geometry/reproduce"
TOL = 1e-6

words_trace = defaultdict(dict)  # filling -> word -> complex trace
with open(f"{ATLAS_DIR}/m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        words_trace[row["filling"]][row["word"]] = complex(float(row["tr_re"]), float(row["tr_im"]))

pairs_by_filling = defaultdict(list)
all_pairs = None
with open(f"{ATLAS_DIR}/m003_pair_atlas.csv") as f:
    for row in csv.DictReader(f):
        pairs_by_filling[row["filling"]].append((row["u"], row["v"]))

fillings = list(words_trace.keys())
print("fillings:", fillings)
print()

# canonical pair list (same across fillings, per the atlas construction)
canonical_pairs = pairs_by_filling[fillings[0]]
for f in fillings[1:]:
    assert set(pairs_by_filling[f]) == set(canonical_pairs), f"pair list differs at {f}"
print(f"canonical pair list: {len(canonical_pairs)} pairs (same across all fillings, confirmed)")
print()

# for each distinct pair, record relation at each filling
pair_pattern = {}  # (u,v) -> {filling: 'EQ'|'NEG'|'BOTH_ZERO'|'OTHER'}
for u, v in canonical_pairs:
    pattern = {}
    for filling in fillings:
        tu = words_trace[filling].get(u)
        tv = words_trace[filling].get(v)
        if tu is None or tv is None:
            pattern[filling] = "MISSING"
            continue
        eq = abs(tu - tv) < TOL
        neg = abs(tu + tv) < TOL
        both_zero = abs(tu) < TOL and abs(tv) < TOL
        if both_zero:
            pattern[filling] = "BOTH_ZERO"
        elif eq:
            pattern[filling] = "EQ"
        elif neg:
            pattern[filling] = "NEG"
        else:
            pattern[filling] = "OTHER"
    pair_pattern[(u, v)] = pattern

# classify each pair by how many fillings show EQ or NEG (ignoring BOTH_ZERO/OTHER)
universal_eq = []   # EQ at all 13
universal_neg = []  # NEG at all 13
partial_eq = []     # EQ at 2..12 fillings
single_eq = []      # EQ at exactly 1 filling
partial_neg = []
single_neg = []

N_FILLINGS = len(fillings)
for (u, v), pattern in pair_pattern.items():
    n_eq = sum(1 for r in pattern.values() if r == "EQ")
    n_neg = sum(1 for r in pattern.values() if r == "NEG")
    if n_eq == N_FILLINGS:
        universal_eq.append((u, v))
    elif n_eq == 1:
        single_eq.append((u, v, [f for f, r in pattern.items() if r == "EQ"][0]))
    elif n_eq > 1:
        partial_eq.append((u, v, n_eq))

    if n_neg == N_FILLINGS:
        universal_neg.append((u, v))
    elif n_neg == 1:
        single_neg.append((u, v, [f for f, r in pattern.items() if r == "NEG"][0]))
    elif n_neg > 1:
        partial_neg.append((u, v, n_neg))

print("=" * 78)
print(f"DISTINCT word pairs with tau_u = tau_v (numerically) at ALL {N_FILLINGS} fillings")
print("(strong candidates for genuine X_0-wide identities):")
print("=" * 78)
for u, v in universal_eq:
    print(f"  ({u}, {v})")
print(f"  -> {len(universal_eq)} such pairs")

print()
print("=" * 78)
print(f"DISTINCT word pairs with tau_u = tau_v at PARTIAL (2..{N_FILLINGS-1}) fillings:")
print("=" * 78)
for u, v, n in partial_eq:
    which = [f for f, r in pair_pattern[(u, v)].items() if r == "EQ"]
    print(f"  ({u}, {v}): EQ at {n} fillings: {which}")

print()
print("=" * 78)
print("DISTINCT word pairs with tau_u = tau_v at EXACTLY 1 filling")
print("(strong candidates for filling-SPECIFIC facts, like B/Abb):")
print("=" * 78)
for u, v, f in single_eq:
    print(f"  ({u}, {v}) at {f}")
print(f"  -> {len(single_eq)} such pairs")

print()
print("=" * 78)
print(f"DISTINCT word pairs with tau_u = -tau_v (numerically, nonzero) at ANY filling:")
print("=" * 78)
print(f"  universal (all {N_FILLINGS}): {len(universal_neg)}")
print(f"  partial: {len(partial_neg)}")
for u, v, n in partial_neg:
    which = [f for f, r in pair_pattern[(u, v)].items() if r == "NEG"]
    print(f"    ({u}, {v}): NEG at {n} fillings: {which}")
print(f"  single: {len(single_neg)}")
for u, v, f in single_neg:
    print(f"    ({u}, {v}) at {f}")

print()
print("EXIT=0")
