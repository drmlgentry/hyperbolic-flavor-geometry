import json
from itertools import combinations
from collections import Counter

with open("C:/dev/hyperbolic-flavor-geometry/reproduce/census_full_scan/census_field_classes.json") as f:
    fields = json.load(f)

items = list(fields.items())
n = len(items)

C2 = [(k, frozenset(v['ramification_support'])) for k, v in items if v['galois_group'] == 'C2']
S4 = [(k, frozenset(v['ramification_support'])) for k, v in items if v['galois_group'] == 'S4']
S3 = [(k, frozenset(v['ramification_support'])) for k, v in items if v['galois_group'] == 'S3']

print(f"N_C2 = {len(C2)}")
print(f"N_S4 = {len(S4)}")
print(f"N_S3 = {len(S3)}")
print()

# All unordered pairs of distinct C2 fields with disjoint support
c2_pairs = []
for (k1, s1), (k2, s2) in combinations(C2, 2):
    if s1.isdisjoint(s2):
        c2_pairs.append((k1, k2, s1, s2))

print(f"Unordered C2-C2 pairs total (before disjointness filter): {len(C2)*(len(C2)-1)//2}")
print(f"Unordered C2-C2 pairs with disjoint support: {len(c2_pairs)}")
print()

# For each disjoint C2-pair, count eligible S4 (disjoint from both) and eligible S3 (disjoint from all three)
rows = []
total_check = 0
for k1, k2, s1, s2 in c2_pairs:
    used = s1 | s2
    eligible_s4 = [(ks4, ss4) for ks4, ss4 in S4 if ss4.isdisjoint(used)]
    n_s4 = len(eligible_s4)
    # for each eligible S4, count eligible S3 disjoint from used | that S4's support
    per_s4_s3_counts = []
    subtotal = 0
    for ks4, ss4 in eligible_s4:
        used2 = used | ss4
        n_s3 = sum(1 for ks3, ss3 in S3 if ss3.isdisjoint(used2))
        per_s4_s3_counts.append(n_s3)
        subtotal += n_s3
    rows.append((k1, k2, n_s4, subtotal, per_s4_s3_counts))
    total_check += subtotal

print(f"Sum over all disjoint C2-pairs of (S4 count x per-S4 S3 count) = {total_check}")
print()

# Report per-C2-pair breakdown
print("--- Per C2-pair breakdown (k1, k2, #eligible S4, sum of S3 over those S4) ---")
for k1, k2, n_s4, subtotal, per_s4_s3 in rows:
    avg_s3 = subtotal / n_s4 if n_s4 else 0
    print(f"  ({k1!r}, {k2!r}): eligible_S4={n_s4}, total_(S4,S3)_pairs={subtotal}, "
          f"S3-count range=[{min(per_s4_s3) if per_s4_s3 else 0},{max(per_s4_s3) if per_s4_s3 else 0}], avg_S3={avg_s3:.2f}")

# Is it a clean product? Check if n_s4 is constant across all pairs, and s3 count constant across all (pair,S4)
n_s4_values = set(r[2] for r in rows)
all_s3_values = set()
for r in rows:
    all_s3_values.update(r[4])
print()
print(f"Distinct values of 'eligible S4 count' across C2-pairs: {sorted(n_s4_values)}")
print(f"Distinct values of 'eligible S3 count' across all (C2-pair,S4) combos: {sorted(all_s3_values)}")

print()
print(f"=== TOTAL (should equal 3648): {total_check} ===")
